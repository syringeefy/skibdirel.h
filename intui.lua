


local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ExecutorUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui
screenGui.Enabled = true -- Start visible

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 500, 0, 300)
frame.Position = UDim2.new(0.5, -250, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(60, 60, 60)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Title Bar
local titleBar = Instance.new("TextLabel")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleBar.Text = "Lua Executor"
titleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
titleBar.Font = Enum.Font.GothamSemibold
titleBar.TextSize = 18
titleBar.Parent = frame


local textBox = Instance.new("TextBox")
textBox.MultiLine = true
textBox.ClearTextOnFocus = false
textBox.Size = UDim2.new(1, -20, 1, -90)
textBox.Position = UDim2.new(0, 10, 0, 40)
textBox.Text = "-- Type your code here"
textBox.Font = Enum.Font.Code
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.TextSize = 16
textBox.TextXAlignment = Enum.TextXAlignment.Left
textBox.TextYAlignment = Enum.TextYAlignment.Top
textBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
textBox.BorderSizePixel = 0
textBox.Parent = frame


local function createButton(name: string, position: UDim2, callback: () -> ())
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0, 100, 0, 35)
	button.Position = position
	button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Text = name
	button.Font = Enum.Font.GothamBold
	button.TextSize = 16
	button.BorderSizePixel = 0
	button.AutoButtonColor = true
	button.Parent = frame


	button.MouseEnter:Connect(function()
		button:TweenSizeAndPosition(button.Size, button.Position, Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.15, true)
		button.BackgroundColor3 = Color3.fromRGB(10, 60, 150)
	end)
	button.MouseLeave:Connect(function()
		button:TweenSizeAndPosition(button.Size, button.Position, Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.15, true)
		button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	end)

	button.MouseButton1Click:Connect(callback)
end


createButton("Clear", UDim2.new(0, 120, 1, -45), function()
	textBox.Text = ""
end)

createButton("Execute", UDim2.new(0, 10, 1, -45), function()
	local code = textBox.Text
	print("[Pipe Write Simulation] Sending Code:")
	print(code)


	pcall(function()
		local f = loadstring(code)
		if f then f() end
	end)
end)

for _, obj in ipairs({frame, textBox}) do
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = obj
end


UIS.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.Insert then
		screenGui.Enabled = not screenGui.Enabled
	end
end)


local dragging = false
local dragStart, startPos

local function updateInput(input)
	local delta = input.Position - dragStart
	local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	frame:TweenPosition(newPos, Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.2, true)
end

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		UIS.InputChanged:Connect(function(movementInput)
			if dragging then
				updateInput(movementInput)
			end
		end)
	end
end)
