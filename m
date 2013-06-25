Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab3FYLUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 07:20:39 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:34251 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752471Ab3FYLUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 07:20:37 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@stlinux.com,
        Arnd Bergmann <arnd@arndb.de>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH v5 3/7] ARM:sti: Add DEBUG_LL console support
Date: Tue, 25 Jun 2013 12:15:32 +0100
Message-Id: <1372158932-19725-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1372158822-19160-1-git-send-email-srinivas.kandagatla@st.com>
References: <1372158822-19160-1-git-send-email-srinivas.kandagatla@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

This patch adds low level debug uart support to sti based SOCs.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
CC: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/Kconfig.debug       |   35 ++++++++++++++++++++++++
 arch/arm/include/debug/sti.S |   61 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 96 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/include/debug/sti.S

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 1d41908..311f6f3 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -483,6 +483,16 @@ choice
 		  This option selects UART0 on VIA/Wondermedia System-on-a-chip
 		  devices, including VT8500, WM8505, WM8650 and WM8850.
 
+	config DEBUG_STI_UART
+		depends on ARCH_STI
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
@@ -617,6 +627,30 @@ choice
 
 endchoice
 
+choice
+	prompt "Low-level debug console UART"
+	depends on DEBUG_LL && DEBUG_STI_UART
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
 config DEBUG_LL_INCLUDE
 	string
 	default "debug/bcm2835.S" if DEBUG_BCM2835
@@ -641,6 +675,7 @@ config DEBUG_LL_INCLUDE
 				 DEBUG_MMP_UART3
 	default "debug/sirf.S" if DEBUG_SIRFPRIMA2_UART1 || DEBUG_SIRFMARCO_UART1
 	default "debug/socfpga.S" if DEBUG_SOCFPGA_UART
+	default "debug/sti.S" if DEBUG_STI_UART
 	default "debug/sunxi.S" if DEBUG_SUNXI_UART0 || DEBUG_SUNXI_UART1
 	default "debug/tegra.S" if DEBUG_TEGRA_UART
 	default "debug/ux500.S" if DEBUG_UX500_UART
diff --git a/arch/arm/include/debug/sti.S b/arch/arm/include/debug/sti.S
new file mode 100644
index 0000000..e3aa58f
--- /dev/null
+++ b/arch/arm/include/debug/sti.S
@@ -0,0 +1,61 @@
+/*
+ * arch/arm/include/debug/sti.S
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
-- 
1.7.6.5

