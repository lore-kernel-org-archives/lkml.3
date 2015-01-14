Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbbANIl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:41:29 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:42906 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418AbbANIlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 03:41:23 -0500
From: Baruch Siach <baruch@tkos.co.il>
To: arm@kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH v3 2/4] ARM: digicolor: add low level debug support
Date: Wed, 14 Jan 2015 10:40:31 +0200
Message-Id: <5b6342c716e2e56da34d7a518b49817967de948a.1421219953.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <cover.1421219953.git.baruch@tkos.co.il>
References: <cover.1421219953.git.baruch@tkos.co.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the USART peripheral as UART for low level debug. Only the UA0 port is
currently supported.

Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 arch/arm/Kconfig.debug             | 12 ++++++++++--
 arch/arm/include/debug/digicolor.S | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm/include/debug/digicolor.S

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 5ddd4906f7a7..7ccab0629dd2 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -241,6 +241,13 @@ choice
 		  Say Y here if you want the debug print routines to direct
 		  their output to the serial port in the DC21285 (Footbridge).
 
+	config DEBUG_DIGICOLOR_UA0
+		bool "Kernel low-level debugging messages via Digicolor UA0"
+		depends on ARCH_DIGICOLOR
+		help
+		  Say Y here if you want the debug print routines to direct
+		  their output to the UA0 serial port in the CX92755.
+
 	config DEBUG_FOOTBRIDGE_COM1
 		bool "Kernel low-level debugging messages via footbridge 8250 at PCI COM1"
 		depends on FOOTBRIDGE
@@ -1204,6 +1211,7 @@ config DEBUG_LL_INCLUDE
 	default "debug/vt8500.S" if DEBUG_VT8500_UART0
 	default "debug/zynq.S" if DEBUG_ZYNQ_UART0 || DEBUG_ZYNQ_UART1
 	default "debug/bcm63xx.S" if DEBUG_UART_BCM63XX
+	default "debug/digicolor.S" if DEBUG_DIGICOLOR_UA0
 	default "mach/debug-macro.S"
 
 # Compatibility options for PL01x
@@ -1320,7 +1328,7 @@ config DEBUG_UART_PHYS
 		DEBUG_RCAR_GEN2_SCIF0 || DEBUG_RCAR_GEN2_SCIF2 || \
 		DEBUG_RMOBILE_SCIFA0 || DEBUG_RMOBILE_SCIFA1 || \
 		DEBUG_RMOBILE_SCIFA4 || DEBUG_S3C24XX_UART || \
-		DEBUG_UART_BCM63XX || DEBUG_ASM9260_UART
+		DEBUG_UART_BCM63XX || DEBUG_ASM9260_UART || DEBUG_DIGICOLOR_UA0
 
 config DEBUG_UART_VIRT
 	hex "Virtual base address of debug UART"
@@ -1398,7 +1406,7 @@ config DEBUG_UART_VIRT
 	depends on DEBUG_LL_UART_8250 || DEBUG_LL_UART_PL01X || \
 		DEBUG_UART_8250 || DEBUG_UART_PL01X || DEBUG_MESON_UARTAO || \
 		DEBUG_MSM_UART || DEBUG_QCOM_UARTDM || DEBUG_S3C24XX_UART || \
-		DEBUG_UART_BCM63XX || DEBUG_ASM9260_UART
+		DEBUG_UART_BCM63XX || DEBUG_ASM9260_UART || DEBUG_DIGICOLOR_UA0
 
 config DEBUG_UART_8250_SHIFT
 	int "Register offset shift for the 8250 debug UART"
diff --git a/arch/arm/include/debug/digicolor.S b/arch/arm/include/debug/digicolor.S
new file mode 100644
index 000000000000..c9517150766a
--- /dev/null
+++ b/arch/arm/include/debug/digicolor.S
@@ -0,0 +1,35 @@
+/*
+ * Debugging macro include header for Conexant Digicolor USART
+ *
+ * Copyright (C) 2014 Paradox Innovation Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+*/
+
+#define UA0_STATUS	0x0742
+#define UA0_EMI_REC	0x0744
+
+#define UA0_STATUS_TX_READY	0x40
+
+#ifdef CONFIG_DEBUG_UART_PHYS
+		.macro	addruart, rp, rv, tmp
+		ldr	\rp, =CONFIG_DEBUG_UART_PHYS
+		ldr	\rv, =CONFIG_DEBUG_UART_VIRT
+		.endm
+#endif
+
+		.macro	senduart,rd,rx
+		strb	\rd, [\rx, #UA0_EMI_REC]
+		.endm
+
+		.macro	waituart,rd,rx
+		.endm
+
+	.macro	busyuart,rd,rx
+1001:		ldrb	\rd, [\rx, #UA0_STATUS]
+		tst	\rd, #UA0_STATUS_TX_READY
+		beq	1001b
+		.endm
-- 
2.1.4

