Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932960AbaJXLA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 07:00:29 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:57345 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932832AbaJXLAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 07:00:25 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Arnd Bergmann <arnd@arndb.de>,
        Paul Bolle <pebolle@tiscali.nl>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        patches@linaro.org, linaro-kernel@lists.linaro.org
Subject: [PATCH v12 13/15] arm: sa1100: Migrate DEBUG_LL macros to shared directory
Date: Fri, 24 Oct 2014 11:54:34 +0100
Message-Id: <1414148076-12685-14-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1414148076-12685-1-git-send-email-daniel.thompson@linaro.org>
References: <1414148076-12685-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of the migration we copy a few definitions from the mach-sa1100
headers and replace the automatic serial port detectiion with explicit
configuration based on DEBUG_UART_PHYS/DEBUG_UART_VIRT.

The removal of the automatic configuration is similar to the way migration
was handled for OMAP2 (see 808b7e07464d...).

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/Kconfig.debug                          | 39 +++++++++++++++-
 arch/arm/include/debug/sa1100.S                 | 37 +++++++++++++++
 arch/arm/mach-sa1100/include/mach/debug-macro.S | 62 -------------------------
 3 files changed, 74 insertions(+), 64 deletions(-)
 create mode 100644 arch/arm/include/debug/sa1100.S
 delete mode 100644 arch/arm/mach-sa1100/include/mach/debug-macro.S

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 5bff47b..4a04c93 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -786,6 +786,30 @@ choice
 		  their output to UART 2. The port must have been initialised
 		  by the boot-loader before use.
 
+	config DEBUG_SA1100_UART1
+		depends on ARCH_SA1100
+		select DEBUG_SA1100_UART
+		bool "Kernel low-level debugging messages via SA1100 Ser1"
+		help
+		  Say Y here if you want kernel low-level debugging support
+		  on SA1100 based platforms.
+
+	config DEBUG_SA1100_UART2
+		depends on ARCH_SA1100
+		select DEBUG_SA1100_UART
+		bool "Kernel low-level debugging messages via SA1100 Ser2"
+		help
+		  Say Y here if you want kernel low-level debugging support
+		  on SA1100 based platforms.
+
+	config DEBUG_SA1100_UART3
+		depends on ARCH_SA1100
+		select DEBUG_SA1100_UART
+		bool "Kernel low-level debugging messages via SA1100 Ser3"
+		help
+		  Say Y here if you want kernel low-level debugging support
+		  on SA1100 based platforms.
+
 	config DEBUG_SOCFPGA_UART
 		depends on ARCH_SOCFPGA
 		bool "Use SOCFPGA UART for low-level debug"
@@ -1089,6 +1113,10 @@ config DEBUG_TEGRA_UART
 	bool
 	depends on ARCH_TEGRA
 
+config DEBUG_SA1100_UART
+	bool
+	depends on ARCH_SA1100
+
 config DEBUG_STI_UART
 	bool
 	depends on ARCH_STI
@@ -1119,6 +1147,7 @@ config DEBUG_LL_INCLUDE
 	default "debug/omap2plus.S" if DEBUG_OMAP2PLUS_UART
 	default "debug/s3c24xx.S" if DEBUG_S3C24XX_UART
 	default "debug/s5pv210.S" if DEBUG_S5PV210_UART
+	default "debug/sa1100.S" if DEBUG_SA1100_UART
 	default "debug/sirf.S" if DEBUG_SIRFPRIMA2_UART1 || DEBUG_SIRFMARCO_UART1
 	default "debug/sti.S" if DEBUG_STI_UART
 	default "debug/tegra.S" if DEBUG_TEGRA_UART
@@ -1191,6 +1220,9 @@ config DEBUG_UART_PHYS
 				DEBUG_S3C2410_UART2)
 	default 0x78000000 if DEBUG_CNS3XXX
 	default 0x7c0003f8 if FOOTBRIDGE
+	default 0x80010000 if DEBUG_SA1100_UART1
+	default 0x80030000 if DEBUG_SA1100_UART2
+	default 0x80050000 if DEBUG_SA1100_UART3
 	default 0x80070000 if DEBUG_IMX23_UART
 	default 0x80074000 if DEBUG_IMX28_UART
 	default 0x80230000 if DEBUG_PICOXCELL_UART
@@ -1231,7 +1263,7 @@ config DEBUG_UART_PHYS
 		DEBUG_UART_8250 || DEBUG_UART_PL01X || DEBUG_MESON_UARTAO || \
 		DEBUG_MSM_UART || DEBUG_NETX_UART || \
 		DEBUG_QCOM_UARTDM || DEBUG_S3C24XX_UART || \
-		DEBUG_UART_BCM63XX
+		DEBUG_SA1100_UART || DEBUG_UART_BCM63XX
 
 config DEBUG_UART_VIRT
 	hex "Virtual base address of debug UART"
@@ -1260,6 +1292,9 @@ config DEBUG_UART_VIRT
 	default 0xf7fc9000 if DEBUG_BERLIN_UART
 	default 0xf8007000 if DEBUG_HIP04_UART
 	default 0xf8009000 if DEBUG_VEXPRESS_UART0_CA9
+	default 0xf8010000 if DEBUG_SA1100_UART1
+	default 0xf8030000 if DEBUG_SA1100_UART2
+	default 0xf8050000 if DEBUG_SA1100_UART3
 	default 0xf8090000 if DEBUG_VEXPRESS_UART0_RS1
 	default 0xfa71e000 if DEBUG_QCOM_UARTDM
 	default 0xfb002000 if DEBUG_CNS3XXX
@@ -1309,7 +1344,7 @@ config DEBUG_UART_VIRT
 		DEBUG_UART_8250 || DEBUG_UART_PL01X || DEBUG_MESON_UARTAO || \
 		DEBUG_MSM_UART || DEBUG_NETX_UART || \
 		DEBUG_QCOM_UARTDM || DEBUG_S3C24XX_UART || \
-		DEBUG_UART_BCM63XX
+		DEBUG_SA1100_UART || DEBUG_UART_BCM63XX
 
 config DEBUG_UART_8250_SHIFT
 	int "Register offset shift for the 8250 debug UART"
diff --git a/arch/arm/include/debug/sa1100.S b/arch/arm/include/debug/sa1100.S
new file mode 100644
index 0000000..6b5e1ce
--- /dev/null
+++ b/arch/arm/include/debug/sa1100.S
@@ -0,0 +1,37 @@
+/*
+ * Debugging macro include header
+ *
+ *  Copyright (C) 1994-1999 Russell King
+ *  Moved from linux/arch/arm/kernel/debug.S by Ben Dooks
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+*/
+
+#define UTDR            0x14
+#define UTSR1           0x20
+#define UTSR1_TBY       0x00000001      /* Transmitter BusY (read)         */
+#define UTSR1_TNF       0x00000004      /* Transmit FIFO Not Full (read)   */
+
+		.macro	addruart, rp, rv, tmp
+		ldr	\rp, =CONFIG_DEBUG_UART_PHYS
+		ldr	\rv, =CONFIG_DEBUG_UART_VIRT
+		.endm
+
+		.macro	senduart,rd,rx
+		str	\rd, [\rx, #UTDR]
+		.endm
+
+		.macro	waituart,rd,rx
+1001:		ldr	\rd, [\rx, #UTSR1]
+		tst	\rd, #UTSR1_TNF
+		beq	1001b
+		.endm
+
+		.macro	busyuart,rd,rx
+1001:		ldr	\rd, [\rx, #UTSR1]
+		tst	\rd, #UTSR1_TBY
+		bne	1001b
+		.endm
diff --git a/arch/arm/mach-sa1100/include/mach/debug-macro.S b/arch/arm/mach-sa1100/include/mach/debug-macro.S
deleted file mode 100644
index 530772d..0000000
--- a/arch/arm/mach-sa1100/include/mach/debug-macro.S
+++ /dev/null
@@ -1,62 +0,0 @@
-/* arch/arm/mach-sa1100/include/mach/debug-macro.S
- *
- * Debugging macro include header
- *
- *  Copyright (C) 1994-1999 Russell King
- *  Moved from linux/arch/arm/kernel/debug.S by Ben Dooks
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
-*/
-#include <mach/hardware.h>
-
-		.macro	addruart, rp, rv, tmp
-		mrc	p15, 0, \rp, c1, c0
-		tst	\rp, #1			@ MMU enabled?
-		moveq	\rp, #0x80000000	@ physical base address
-		movne	\rp, #0xf8000000	@ virtual address
-
-		@ We probe for the active serial port here, coherently with
-		@ the comment in arch/arm/mach-sa1100/include/mach/uncompress.h.
-		@ We assume r1 can be clobbered.
-
-		@ see if Ser3 is active
-		add	\rp, \rp, #0x00050000
-		ldr	\rv, [\rp, #UTCR3]
-		tst	\rv, #UTCR3_TXE
-
-		@ if Ser3 is inactive, then try Ser1
-		addeq	\rp, \rp, #(0x00010000 - 0x00050000)
-		ldreq	\rv, [\rp, #UTCR3]
-		tsteq	\rv, #UTCR3_TXE
-
-		@ if Ser1 is inactive, then try Ser2
-		addeq	\rp, \rp, #(0x00030000 - 0x00010000)
-		ldreq	\rv, [\rp, #UTCR3]
-		tsteq	\rv, #UTCR3_TXE
-
-		@ clear top bits, and generate both phys and virt addresses
-		lsl	\rp, \rp, #8
-		lsr	\rp, \rp, #8
-		orr	\rv, \rp, #0xf8000000	@ virtual
-		orr	\rp, \rp, #0x80000000	@ physical
-
-		.endm
-
-		.macro	senduart,rd,rx
-		str	\rd, [\rx, #UTDR]
-		.endm
-
-		.macro	waituart,rd,rx
-1001:		ldr	\rd, [\rx, #UTSR1]
-		tst	\rd, #UTSR1_TNF
-		beq	1001b
-		.endm
-
-		.macro	busyuart,rd,rx
-1001:		ldr	\rd, [\rx, #UTSR1]
-		tst	\rd, #UTSR1_TBY
-		bne	1001b
-		.endm
-- 
1.9.3

