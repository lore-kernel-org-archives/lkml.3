Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161029Ab3FTOKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 10:10:46 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:37387 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030250Ab3FTOKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 10:10:42 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        kernel@stlinux.com, linux-serial@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 06/10] ARM:stixxxx: Add DEBUG_LL console support
Date: Thu, 20 Jun 2013 15:06:16 +0100
Message-Id: <1371737176-9473-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1371736996-8770-1-git-send-email-srinivas.kandagatla@st.com>
References: <1371736996-8770-1-git-send-email-srinivas.kandagatla@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds low level debug uart support to stixxxx based SOCs.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
CC: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/Kconfig.debug           |   38 +++++++++++++++++++++++
 arch/arm/include/debug/stixxxx.S |   61 ++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-stixxxx/board-dt.c |    2 +
 3 files changed, 101 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/include/debug/stixxxx.S

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 1d41908..cc98ef3 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -483,6 +483,16 @@ choice
 		  This option selects UART0 on VIA/Wondermedia System-on-a-chip
 		  devices, including VT8500, WM8505, WM8650 and WM8850.
 
+	config DEBUG_STIXXXX_UART
+		depends on ARCH_STIXXXX
+		bool "Use StiH415/416 ASC for low-level debug"
+		help
+		  Say Y here if you want kernel low-level debugging support
+		  on StiH415/416 based platforms like B2000, B2020.
+		  It support UART2 and SBC_UART1.
+
+		  If unsure, say N.
+
 	config DEBUG_LL_UART_NONE
 		bool "No low-level debugging UART"
 		depends on !ARCH_MULTIPLATFORM
@@ -617,6 +627,33 @@ choice
 
 endchoice
 
+choice
+	prompt "Low-level debug console UART"
+	depends on DEBUG_LL && DEBUG_STIXXXX_UART
+
+	config STIH41X_DEBUG_ASC2
+		bool "ASC2 UART"
+		help
+		  Say Y here if you want kernel low-level debugging support
+		  on STiH415/416 based platforms like b2000, which has
+		  default UART wired up to ASC2.
+
+		  If unsure, say N.
+
+	config STIH41X_DEBUG_SBC_ASC1
+		bool "SBC ASC1 UART"
+		help
+		  Say Y here if you want kernel low-level debugging support
+		  on STiH415/416 based platforms like b2020. which has
+		  default UART wired up to SBC ASC1.
+
+		  If unsure, say N.
+
+endchoice
+
+
+
+
 config DEBUG_LL_INCLUDE
 	string
 	default "debug/bcm2835.S" if DEBUG_BCM2835
@@ -641,6 +678,7 @@ config DEBUG_LL_INCLUDE
 				 DEBUG_MMP_UART3
 	default "debug/sirf.S" if DEBUG_SIRFPRIMA2_UART1 || DEBUG_SIRFMARCO_UART1
 	default "debug/socfpga.S" if DEBUG_SOCFPGA_UART
+	default "debug/stixxxx.S" if DEBUG_STIXXXX_UART
 	default "debug/sunxi.S" if DEBUG_SUNXI_UART0 || DEBUG_SUNXI_UART1
 	default "debug/tegra.S" if DEBUG_TEGRA_UART
 	default "debug/ux500.S" if DEBUG_UX500_UART
diff --git a/arch/arm/include/debug/stixxxx.S b/arch/arm/include/debug/stixxxx.S
new file mode 100644
index 0000000..7bc02a7
--- /dev/null
+++ b/arch/arm/include/debug/stixxxx.S
@@ -0,0 +1,61 @@
+/*
+ * arch/arm/include/debug/stixxxx.S
+ *
+ * Debugging macro include header
+ * Copyright (C) 2013 STMicroelectronics (R&D) Limited.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#define STIH41X_COMMS_BASE              0xfed00000
+#define STIH41X_ASC2_BASE               (STIH41X_COMMS_BASE+0x32000)
+
+#define STIH41X_SBC_LPM_BASE            0xfe400000
+#define STIH41X_SBC_COMMS_BASE          (STIH41X_SBC_LPM_BASE + 0x100000)
+#define STIH41X_SBC_ASC1_BASE           (STIH41X_SBC_COMMS_BASE + 0x31000)
+
+
+#define VIRT_ADDRESS(x)		(x - 0x1000000)
+
+#if IS_ENABLED(CONFIG_STIH41X_DEBUG_ASC2)
+#define DEBUG_LL_UART_BASE	STIH41X_ASC2_BASE
+#endif
+
+#if IS_ENABLED(CONFIG_STIH41X_DEBUG_SBC_ASC1)
+#define DEBUG_LL_UART_BASE	STIH41X_SBC_ASC1_BASE
+#endif
+
+#ifndef DEBUG_LL_UART_BASE
+#error "DEBUG UART is not Configured"
+#endif
+
+#define ASC_TX_BUF_OFF  0x04
+#define ASC_CTRL_OFF    0x0c
+#define ASC_STA_OFF     0x14
+
+#define ASC_STA_TX_FULL         (1<<9)
+#define ASC_STA_TX_EMPTY        (1<<1)
+
+
+		.macro	addruart, rp, rv, tmp
+		ldr	\rp,      =DEBUG_LL_UART_BASE	@ physical base
+		ldr	\rv,      =VIRT_ADDRESS(DEBUG_LL_UART_BASE) @ virt base
+		.endm
+
+                .macro  senduart,rd,rx
+                strb    \rd, [\rx, #ASC_TX_BUF_OFF]
+                .endm
+
+                .macro  waituart,rd,rx
+1001:           ldr     \rd, [\rx, #ASC_STA_OFF]
+                tst     \rd, #ASC_STA_TX_FULL
+                bne     1001b
+                .endm
+
+                .macro  busyuart,rd,rx
+1001:           ldr     \rd, [\rx, #ASC_STA_OFF]
+                tst     \rd, #ASC_STA_TX_EMPTY
+                beq     1001b
+                .endm
diff --git a/arch/arm/mach-stixxxx/board-dt.c b/arch/arm/mach-stixxxx/board-dt.c
index 6487a12..2c4e427 100644
--- a/arch/arm/mach-stixxxx/board-dt.c
+++ b/arch/arm/mach-stixxxx/board-dt.c
@@ -11,6 +11,7 @@
 #include <linux/clocksource.h>
 #include <linux/irq.h>
 #include <asm/hardware/cache-l2x0.h>
+#include <asm/mach/map.h>
 #include <asm/mach/arch.h>
 
 #include "smp.h"
@@ -42,6 +43,7 @@ static const char *stih41x_dt_match[] __initdata = {
 };
 
 DT_MACHINE_START(STM, "STiH415/416 SoC with Flattened Device Tree")
+	.map_io		= debug_ll_io_init,
 	.init_time	= stih41x_timer_init,
 	.smp		= smp_ops(stixxxx_smp_ops),
 	.dt_compat	= stih41x_dt_match,
-- 
1.7.6.5

