Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab3AKUOA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 15:14:00 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:65533 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197Ab3AKUMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 15:12:33 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: olof@lixom.net
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH 3/4] arm: vt8500: Convert debug-macro.S to be multiplatform friendly
Date: Sat, 12 Jan 2013 09:12:41 +1300
Message-Id: <1357935162-7672-4-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357935162-7672-1-git-send-email-linux@prisktech.co.nz>
References: <1357935162-7672-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves debug-macro.S from arm/mach-vt8500/include/mach to
arm/include/debug/vt8500.S to provide multiplatform support.

Minor style changes in code for readability.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 arch/arm/Kconfig.debug                          |    8 +++++
 arch/arm/include/debug/vt8500.S                 |   37 +++++++++++++++++++++++
 arch/arm/mach-vt8500/include/mach/debug-macro.S |   31 -------------------
 3 files changed, 45 insertions(+), 31 deletions(-)
 create mode 100644 arch/arm/include/debug/vt8500.S
 delete mode 100644 arch/arm/mach-vt8500/include/mach/debug-macro.S

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 661030d..bbb0a67 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -412,6 +412,13 @@ choice
 		  of the tiles using the RS1 memory map, including all new A-class
 		  core tiles, FPGA-based SMMs and software models.
 
+	config DEBUG_VT8500_UART0
+		bool "Use UART0 on VIA/Wondermedia SoCs"
+		depends on ARCH_VT8500
+		help
+		  This option selects UART0 on VIA/Wondermedia System-on-a-chip
+		  devices, including VT8500, WM8505, WM8650 and WM8850.
+
 	config DEBUG_LL_UART_NONE
 		bool "No low-level debugging UART"
 		depends on !ARCH_MULTIPLATFORM
@@ -506,6 +513,7 @@ config DEBUG_LL_INCLUDE
 	default "debug/sunxi.S" if DEBUG_SUNXI_UART0 || DEBUG_SUNXI_UART1
 	default "debug/vexpress.S" if DEBUG_VEXPRESS_UART0_DETECT || \
 		DEBUG_VEXPRESS_UART0_CA9 || DEBUG_VEXPRESS_UART0_RS1
+	default "debug/vt8500.S" if DEBUG_VT8500_UART0
 	default "debug/tegra.S" if DEBUG_TEGRA_UART
 	default "debug/zynq.S" if DEBUG_ZYNQ_UART0 || DEBUG_ZYNQ_UART1
 	default "mach/debug-macro.S"
diff --git a/arch/arm/include/debug/vt8500.S b/arch/arm/include/debug/vt8500.S
new file mode 100644
index 0000000..0e0ca08
--- /dev/null
+++ b/arch/arm/include/debug/vt8500.S
@@ -0,0 +1,37 @@
+/* 
+ * Debugging macro include header
+ *
+ *  Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
+ *    Moved from arch/arm/mach-vt8500/include/mach/debug-macro.S
+ *    Minor changes for readability.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#define DEBUG_LL_PHYS_BASE		0xD8000000
+#define DEBUG_LL_VIRT_BASE		0xF8000000
+#define DEBUG_LL_UART_OFFSET		0x00200000
+
+#if defined(CONFIG_DEBUG_VT8500_UART0)
+	.macro	addruart, rp, rv, tmp
+	mov	\rp,      #DEBUG_LL_UART_OFFSET
+	orr	\rv, \rp, #DEBUG_LL_VIRT_BASE
+	orr	\rp, \rp, #DEBUG_LL_PHYS_BASE
+	.endm
+
+	.macro	senduart,rd,rx
+	strb	\rd, [\rx, #0]
+	.endm
+
+	.macro	busyuart,rd,rx
+1001:	ldr	\rd, [\rx, #0x1c]
+	ands	\rd, \rd, #0x2
+	bne	1001b
+	.endm
+
+	.macro	waituart,rd,rx
+	.endm
+
+#endif
diff --git a/arch/arm/mach-vt8500/include/mach/debug-macro.S b/arch/arm/mach-vt8500/include/mach/debug-macro.S
deleted file mode 100644
index ca292f2..0000000
--- a/arch/arm/mach-vt8500/include/mach/debug-macro.S
+++ /dev/null
@@ -1,31 +0,0 @@
-/*
- * arch/arm/mach-vt8500/include/mach/debug-macro.S
- *
- *  Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
- *
- * Debugging macro include header
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
-*/
-
-	.macro	addruart, rp, rv, tmp
-	mov	\rp,      #0x00200000
-	orr	\rv, \rp, #0xf8000000
-	orr	\rp, \rp, #0xd8000000
-	.endm
-
-	.macro	senduart,rd,rx
-	strb	\rd, [\rx, #0]
-	.endm
-
-	.macro	busyuart,rd,rx
-1001:	ldr	\rd, [\rx, #0x1c]
-	ands	\rd, \rd, #0x2
-	bne	1001b
-	.endm
-
-	.macro	waituart,rd,rx
-	.endm
-- 
1.7.9.5

