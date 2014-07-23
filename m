Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956AbaGWJlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 05:41:45 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:64896 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757651AbaGWJlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 05:41:39 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH CFT] arm: netx: Migrate DEBUG_LL macros to shared directory
Date: Wed, 23 Jul 2014 10:41:03 +0100
Message-Id: <1406108463-11726-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of the migration we introduce DEBUG_UART_PHYS/DEBUG_UART_VIRT
which default to UART1 but allow a user to configure UART2 or UART3.
We also introduce symbolic names for the registers and flags.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/Kconfig.debug                             | 17 +++++++++++++++--
 .../mach/debug-macro.S => include/debug/netx.S}    | 22 +++++++++++-----------
 2 files changed, 26 insertions(+), 13 deletions(-)
 rename arch/arm/{mach-netx/include/mach/debug-macro.S => include/debug/netx.S} (62%)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 762b3ed..c7e05b7 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -439,6 +439,14 @@ choice
 		  Say Y here if you want kernel low-level debugging support
 		  on Vybrid based platforms.
 
+	config DEBUG_NETX_UART
+		bool "Kernel low-level debugging messages via NetX UART"
+		depends on ARCH_NETX
+		select DEBUG_UART_NETX
+		help
+		  Say Y here if you want kernel low-level debugging support
+		  on Hilscher NetX based platforms.
+
 	config DEBUG_NOMADIK_UART
 		bool "Kernel low-level debugging messages via NOMADIK UART"
 		depends on ARCH_NOMADIK
@@ -1063,6 +1071,7 @@ config DEBUG_LL_INCLUDE
 				 DEBUG_IMX6SX_UART
 	default "debug/ks8695.S" if DEBUG_KS8695_UART
 	default "debug/msm.S" if DEBUG_MSM_UART || DEBUG_QCOM_UARTDM
+	default "debug/netx.S" if DEBUG_NETX_UART
 	default "debug/omap2plus.S" if DEBUG_OMAP2PLUS_UART
 	default "debug/s3c24xx.S" if DEBUG_S3C24XX_UART
 	default "debug/sirf.S" if DEBUG_SIRFPRIMA2_UART1 || DEBUG_SIRFMARCO_UART1
@@ -1094,6 +1103,7 @@ config DEBUG_UART_8250
 
 config DEBUG_UART_PHYS
 	hex "Physical base address of debug UART"
+	default 0x00100a00 if DEBUG_NETX_UART
 	default 0x01c20000 if DEBUG_DAVINCI_DMx_UART0
 	default 0x01c28000 if DEBUG_SUNXI_UART0
 	default 0x01c28400 if DEBUG_SUNXI_UART1
@@ -1162,10 +1172,12 @@ config DEBUG_UART_PHYS
 	depends on DEBUG_LL_UART_8250 || DEBUG_LL_UART_PL01X || \
 		DEBUG_LL_UART_EFM32 || \
 		DEBUG_UART_8250 || DEBUG_UART_PL01X || \
-		DEBUG_MSM_UART || DEBUG_QCOM_UARTDM || DEBUG_S3C24XX_UART
+		DEBUG_MSM_UART || DEBUG_NETX_UART || DEBUG_QCOM_UARTDM || \
+		DEBUG_S3C24XX_UART
 
 config DEBUG_UART_VIRT
 	hex "Virtual base address of debug UART"
+	default 0xe0000a00 if DEBUG_NETX_UART
 	default 0xe0010fe0 if ARCH_RPC
 	default 0xe1000000 if DEBUG_MSM_UART
 	default 0xf0000be0 if ARCH_EBSA110
@@ -1232,7 +1244,8 @@ config DEBUG_UART_VIRT
 	default DEBUG_UART_PHYS if !MMU
 	depends on DEBUG_LL_UART_8250 || DEBUG_LL_UART_PL01X || \
 		DEBUG_UART_8250 || DEBUG_UART_PL01X || \
-		DEBUG_MSM_UART || DEBUG_QCOM_UARTDM || DEBUG_S3C24XX_UART
+		DEBUG_MSM_UART || DEBUG_NETX_UART || DEBUG_QCOM_UARTDM || \
+		DEBUG_S3C24XX_UART
 
 config DEBUG_UART_8250_SHIFT
 	int "Register offset shift for the 8250 debug UART"
diff --git a/arch/arm/mach-netx/include/mach/debug-macro.S b/arch/arm/include/debug/netx.S
similarity index 62%
rename from arch/arm/mach-netx/include/mach/debug-macro.S
rename to arch/arm/include/debug/netx.S
index 247781e..cf7522a 100644
--- a/arch/arm/mach-netx/include/mach/debug-macro.S
+++ b/arch/arm/include/debug/netx.S
@@ -1,5 +1,4 @@
-/* arch/arm/mach-netx/include/mach/debug-macro.S
- *
+/*
  * Debugging macro include header
  *
  *  Copyright (C) 1994-1999 Russell King
@@ -11,26 +10,27 @@
  *
 */
 
-#include "hardware.h"
+#define UART_DATA 0
+#define UART_FLAG 0x18
+#define UART_FLAG_BUSY (1 << 3)
 
 		.macro	addruart, rp, rv, tmp
-		mov	\rp, #0x00000a00
-		orr	\rv, \rp, #io_p2v(0x00100000)	@ virtual
-		orr	\rp, \rp, #0x00100000		@ physical
+		ldr	\rp, =CONFIG_DEBUG_UART_PHYS
+		ldr	\rp, =CONFIG_DEBUG_UART_VIRT
 		.endm
 
 		.macro	senduart,rd,rx
-		str	\rd, [\rx, #0]
+		str	\rd, [\rx, #UART_DATA]
 		.endm
 
 		.macro	busyuart,rd,rx
-1002:		ldr	\rd, [\rx, #0x18]
-		tst	\rd, #(1 << 3)
+1002:		ldr	\rd, [\rx, #UART_FLAG]
+		tst	\rd, #UART_FLAG_BUSY
 		bne	1002b
 		.endm
 
 		.macro	waituart,rd,rx
-1001:		ldr	\rd, [\rx, #0x18]
-		tst	\rd, #(1 << 3)
+1001:		ldr	\rd, [\rx, #UART_FLAG]
+		tst	\rd, #UART_FLAG_BUSY
 		bne	1001b
 		.endm
-- 
1.9.3

