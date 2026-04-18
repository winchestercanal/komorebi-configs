Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    public class WindowHelper {
        [DllImport("user32.dll")]
        public static extern IntPtr GetForegroundWindow();
        
        [DllImport("user32.dll")]
        public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint lpdwProcessId);
    }
"@

$activeWindow = [WindowHelper]::GetForegroundWindow()
$processId = 0
[WindowHelper]::GetWindowThreadProcessId($activeWindow, [ref]$processId) | Out-Null

if ($processId -ne 0) {
    $process = Get-Process -Id $processId
    Write-Host "Encerrando: $($process.ProcessName) (PID: $processId)"
    Stop-Process -Id $processId -Force
}
