Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934454AbaDITqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 15:46:17 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:40885 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934433AbaDITqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 15:46:12 -0400
From: Matthias Brugger <matthias.bgg@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, linux@arm.linux.org.uk,
        daniel.lezcano@linaro.org, tglx@linutronix.de, matthias.bgg@gmail.com,
        thierry.reding@gmail.com, florian.vaussard@epfl.ch, jic23@kernel.org,
        jason@lakedaemon.net, andrew@lunn.ch, silvio.fricke@gmail.com,
        heiko.stuebner@bq.com, olof@lixom.net, sebastian.hesselbarth@gmail.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 4/4] arm: mediatek: Add earlyprintk support for MT6589
Date: Wed,  9 Apr 2014 21:45:36 +0200
Message-Id: <1397072736-10793-5-git-send-email-matthias.bgg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397072736-10793-1-git-send-email-matthias.bgg@gmail.com>
References: <1397072736-10793-1-git-send-email-matthias.bgg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
---
 arch/arm/Kconfig.debug            |   49 +++++++++++++++++++++++++++++++++++--
 arch/arm/include/debug/mediatek.S |   38 ++++++++++++++++++++++++++++
 2 files changed, 85 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm/include/debug/mediatek.S

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 4a2fc0b..dc51495 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -797,6 +797,38 @@ choice
 		  Say Y here if you want kernel low-level debugging support
 		  on Ux500 based platforms.
 
+	config DEBUG_MTK6589_UART0
+		depends on ARCH_MEDIATEK
+		bool "Mediatek mt6589 UART0"
+		select DEBUG_UART_MEDIATEK
+		help
+		  Say Y here if you want kernel low-level debugging support
+		  on Mediatek mt6589 based platforms.
+
+	config DEBUG_MTK6589_UART1
+		depends on ARCH_MEDIATEK
+		bool "Mediatek mt6589 UART1"
+		select DEBUG_UART_MEDIATEK
+		help
+		  Say Y here if you want kernel low-level debugging support
+		  on Mediatek mt6589 based platforms.
+
+	config DEBUG_MTK6589_UART2
+		depends on ARCH_MEDIATEK
+		bool "Mediatek mt6589 UART2"
+		select DEBUG_UART_MEDIATEK
+		help
+		  Say Y here if you want kernel low-level debugging support
+		  on Mediatek mt6589 based platforms.
+
+	config DEBUG_MTK6589_UART3
+		depends on ARCH_MEDIATEK
+		bool "Mediatek mt6589 UART3"
+		select DEBUG_UART_MEDIATEK
+		help
+		  Say Y here if you want kernel low-level debugging support
+		  on Mediatek mt6589 based platforms.
+
 	config DEBUG_VEXPRESS_UART0_DETECT
 		bool "Autodetect UART0 on Versatile Express Cortex-A core tiles"
 		depends on ARCH_VEXPRESS && CPU_CP15_MMU
@@ -954,6 +986,10 @@ config DEBUG_MSM_UART
 	bool
 	depends on ARCH_MSM || ARCH_QCOM
 
+config DEBUG_UART_MEDIATEK
+	bool
+	depends on ARCH_MEDIATEK
+
 config DEBUG_LL_INCLUDE
 	string
 	default "debug/8250.S" if DEBUG_LL_UART_8250 || DEBUG_UART_8250
@@ -971,6 +1007,7 @@ config DEBUG_LL_INCLUDE
 				 DEBUG_IMX53_UART ||\
 				 DEBUG_IMX6Q_UART || \
 				 DEBUG_IMX6SL_UART
+	default "debug/mediatek.S" if DEBUG_UART_MEDIATEK
 	default "debug/msm.S" if DEBUG_MSM_UART
 	default "debug/omap2plus.S" if DEBUG_OMAP2PLUS_UART
 	default "debug/sirf.S" if DEBUG_SIRFPRIMA2_UART1 || DEBUG_SIRFMARCO_UART1
@@ -1043,6 +1080,10 @@ config DEBUG_UART_PHYS
 	default 0xd0012000 if DEBUG_MVEBU_UART
 	default 0xd4017000 if DEBUG_MMP_UART2
 	default 0xd4018000 if DEBUG_MMP_UART3
+	default 0x11006000 if DEBUG_MTK6589_UART0
+	default 0x11007000 if DEBUG_MTK6589_UART1
+	default 0x11008000 if DEBUG_MTK6589_UART2
+	default 0x11009000 if DEBUG_MTK6589_UART3
 	default 0xe0000000 if ARCH_SPEAR13XX
 	default 0xf0000be0 if ARCH_EBSA110
 	default 0xf1012000 if DEBUG_MVEBU_UART_ALTERNATE
@@ -1058,7 +1099,7 @@ config DEBUG_UART_PHYS
 	default 0xfffff700 if ARCH_IOP33X
 	depends on DEBUG_LL_UART_8250 || DEBUG_LL_UART_PL01X || \
 		DEBUG_LL_UART_EFM32 || \
-		DEBUG_UART_8250 || DEBUG_UART_PL01X
+		DEBUG_UART_8250 || DEBUG_UART_PL01X || DEBUG_UART_MEDIATEK
 
 config DEBUG_UART_VIRT
 	hex "Virtual base address of debug UART"
@@ -1087,6 +1128,10 @@ config DEBUG_UART_VIRT
 	default 0xfe012000 if ARCH_ORION5X
 	default 0xfe017000 if DEBUG_MMP_UART2
 	default 0xfe018000 if DEBUG_MMP_UART3
+	default 0xF1006000 if DEBUG_MTK6589_UART0
+	default 0xF1007000 if DEBUG_MTK6589_UART1
+	default 0xF1008000 if DEBUG_MTK6589_UART2
+	default 0xF1009000 if DEBUG_MTK6589_UART3
 	default 0xfe100000 if DEBUG_IMX23_UART || DEBUG_IMX28_UART
 	default 0xfe230000 if DEBUG_PICOXCELL_UART
 	default 0xfe300000 if DEBUG_BCM_KONA_UART
@@ -1116,7 +1161,7 @@ config DEBUG_UART_VIRT
 	default 0xff003000 if DEBUG_U300_UART
 	default DEBUG_UART_PHYS if !MMU
 	depends on DEBUG_LL_UART_8250 || DEBUG_LL_UART_PL01X || \
-		DEBUG_UART_8250 || DEBUG_UART_PL01X
+		DEBUG_UART_8250 || DEBUG_UART_PL01X || DEBUG_UART_MEDIATEK
 
 config DEBUG_UART_8250_SHIFT
 	int "Register offset shift for the 8250 debug UART"
diff --git a/arch/arm/include/debug/mediatek.S b/arch/arm/include/debug/mediatek.S
new file mode 100644
index 0000000..98e8414
--- /dev/null
+++ b/arch/arm/include/debug/mediatek.S
@@ -0,0 +1,38 @@
+/*
+ * Low-level debug macro for Mediatek SoCs
+ *
+ * Copyright (c) 2014 MundoReader S.L.
+ * Author: Matthias Brugger <matthias.bgg@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#include <linux/serial_reg.h>
+
+	        .macro  addruart, rp, rv, tmp
+	        ldr	\rp, =CONFIG_DEBUG_UART_PHYS
+	        ldr	\rv, =CONFIG_DEBUG_UART_VIRT
+	        .endm
+
+	        .macro  senduart,rd,rx
+	        strb    \rd, [\rx, #0x0]
+	        .endm
+
+	        .macro  waituart,rd,rx
+1001:   	ldr \rd, [\rx, #0x14]
+	        tst \rd, #0x40
+	        beq 1001b
+	        .endm
+
+		.macro  busyuart,rd,rx
+1002:   	ldr \rd, [\rx, #0x14]
+	        tst \rd, #0x40
+	        beq 1002b
+	        .endm
-- 
1.7.9.5

