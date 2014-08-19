Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbaHSOva (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 10:51:30 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:55019 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbaHSOs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 10:48:57 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Arnd Bergmann <arnd@arndb.de>,
        Paul Bolle <pebolle@tiscali.nl>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, Greg Ungerer <gerg@uclinux.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: [PATCH v8 4/9] arm: ks8695: Migrate debug_ll macros to shared directory
Date: Tue, 19 Aug 2014 15:48:30 +0100
Message-Id: <1408459715-10151-5-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408459715-10151-1-git-send-email-daniel.thompson@linaro.org>
References: <1404127855-30459-1-git-send-email-daniel.thompson@linaro.org>
 <1408459715-10151-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of the migration a couple of uart definitions have been copied
from of the platform specific header files.

Note that, in order to keep oldconfig working nicely we must defer the
removal of arch/arm/mach-ks8695/include/mach/debug-macro.S until
DEBUG_LL_UART_NONE has been removed.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
---
 arch/arm/Kconfig.debug                          |  8 +++++
 arch/arm/include/debug/ks8695.S                 | 40 +++++++++++++++++++++++++
 arch/arm/mach-ks8695/include/mach/debug-macro.S | 36 ----------------------
 3 files changed, 48 insertions(+), 36 deletions(-)
 create mode 100644 arch/arm/include/debug/ks8695.S
 delete mode 100644 arch/arm/mach-ks8695/include/mach/debug-macro.S

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 9c46729..97c3058 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -348,6 +348,13 @@ choice
 		  Say Y here if you want the debug print routines to direct
 		  their output to UART1 serial port on KEYSTONE2 devices.
 
+	config DEBUG_KS8695_UART
+		bool "KS8695 Debug UART"
+		depends on ARCH_KS8695
+		help
+		  Say Y here if you want kernel low-level debugging support
+		  on KS8695.
+
 	config DEBUG_MMP_UART2
 		bool "Kernel low-level debugging message via MMP UART2"
 		depends on ARCH_MMP
@@ -1017,6 +1024,7 @@ config DEBUG_LL_INCLUDE
 				 DEBUG_IMX6Q_UART || \
 				 DEBUG_IMX6SL_UART || \
 				 DEBUG_IMX6SX_UART
+	default "debug/ks8695.S" if DEBUG_KS8695_UART
 	default "debug/msm.S" if DEBUG_MSM_UART || DEBUG_QCOM_UARTDM
 	default "debug/omap2plus.S" if DEBUG_OMAP2PLUS_UART
 	default "debug/s3c24xx.S" if DEBUG_S3C24XX_UART
diff --git a/arch/arm/include/debug/ks8695.S b/arch/arm/include/debug/ks8695.S
new file mode 100644
index 0000000..961da1f
--- /dev/null
+++ b/arch/arm/include/debug/ks8695.S
@@ -0,0 +1,40 @@
+/*
+ * arch/arm/include/debug/ks8695.S
+ *
+ * Copyright (C) 2006 Ben Dooks <ben@simtec.co.uk>
+ * Copyright (C) 2006 Simtec Electronics
+ *
+ * KS8695 - Debug macros
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#define KS8695_UART_PA	0x03ffe000
+#define KS8695_UART_VA	0xf00fe000
+#define KS8695_URTH	(0x04)
+#define KS8695_URLS	(0x14)
+#define URLS_URTE	(1 << 6)
+#define URLS_URTHRE	(1 << 5)
+
+	.macro	addruart, rp, rv, tmp
+		ldr	\rp, =KS8695_UART_PA		@ physical base address
+		ldr	\rv, =KS8695_UART_VA		@ virtual base address
+	.endm
+
+	.macro	senduart, rd, rx
+		str	\rd, [\rx, #KS8695_URTH]	@ Write to Transmit Holding Register
+	.endm
+
+	.macro	busyuart, rd, rx
+1001:		ldr	\rd, [\rx, #KS8695_URLS]	@ Read Line Status Register
+		tst	\rd, #URLS_URTE			@ Holding & Shift registers empty?
+		beq	1001b
+	.endm
+
+	.macro	waituart, rd, rx
+1001:		ldr	\rd, [\rx, #KS8695_URLS]	@ Read Line Status Register
+		tst	\rd, #URLS_URTHRE		@ Holding Register empty?
+		beq	1001b
+	.endm
diff --git a/arch/arm/mach-ks8695/include/mach/debug-macro.S b/arch/arm/mach-ks8695/include/mach/debug-macro.S
deleted file mode 100644
index a79e489..0000000
--- a/arch/arm/mach-ks8695/include/mach/debug-macro.S
+++ /dev/null
@@ -1,36 +0,0 @@
-/*
- * arch/arm/mach-ks8695/include/mach/debug-macro.S
- *
- * Copyright (C) 2006 Ben Dooks <ben@simtec.co.uk>
- * Copyright (C) 2006 Simtec Electronics
- *
- * KS8695 - Debug macros
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <mach/hardware.h>
-#include <mach/regs-uart.h>
-
-	.macro	addruart, rp, rv, tmp
-		ldr	\rp, =KS8695_UART_PA		@ physical base address
-		ldr	\rv, =KS8695_UART_VA		@ virtual base address
-	.endm
-
-	.macro	senduart, rd, rx
-		str	\rd, [\rx, #KS8695_URTH]	@ Write to Transmit Holding Register
-	.endm
-
-	.macro	busyuart, rd, rx
-1001:		ldr	\rd, [\rx, #KS8695_URLS]	@ Read Line Status Register
-		tst	\rd, #URLS_URTE			@ Holding & Shift registers empty?
-		beq	1001b
-	.endm
-
-	.macro	waituart, rd, rx
-1001:		ldr	\rd, [\rx, #KS8695_URLS]	@ Read Line Status Register
-		tst	\rd, #URLS_URTHRE		@ Holding Register empty?
-		beq	1001b
-	.endm
-- 
1.9.3

