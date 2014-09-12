Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbaILPnc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 11:43:32 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55591 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751283AbaILPn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 11:43:28 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv2 3/8] ARM: at91: introduce basic SAMA5D4 support
Date: Fri, 12 Sep 2014 17:43:02 +0200
Message-Id: <1410536587-24607-4-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410536587-24607-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1410536587-24607-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@atmel.com>

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/Kconfig.debug                    |  4 ++++
 arch/arm/mach-at91/Kconfig                | 18 ++++++++++++++++
 arch/arm/mach-at91/Makefile               |  1 +
 arch/arm/mach-at91/include/mach/cpu.h     |  9 ++++++++
 arch/arm/mach-at91/include/mach/sama5d4.h | 33 ++++++++++++++++++++++++++++
 arch/arm/mach-at91/sama5d4.c              | 36 +++++++++++++++++++++++++++++++
 arch/arm/mach-at91/soc.h                  |  5 +++++
 7 files changed, 106 insertions(+)
 create mode 100644 arch/arm/mach-at91/include/mach/sama5d4.h
 create mode 100644 arch/arm/mach-at91/sama5d4.c

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index b11ad54f8d17..7b44db208f10 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -101,6 +101,10 @@ choice
 		bool "Kernel low-level debugging on 9263 and 9g45"
 		depends on HAVE_AT91_DBGU1
 
+	config AT91_DEBUG_LL_DBGU2
+		bool "Kernel low-level debugging on sama5d4"
+		depends on HAVE_AT91_DBGU2
+
 	config DEBUG_BCM2835
 		bool "Kernel low-level debugging on BCM2835 PL011 UART"
 		depends on ARCH_BCM2835
diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index a2c8ecb10730..0e11013fea76 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -12,6 +12,9 @@ config HAVE_AT91_DBGU0
 config HAVE_AT91_DBGU1
 	bool
 
+config HAVE_AT91_DBGU2
+	bool
+
 config AT91_USE_OLD_CLK
 	bool
 
@@ -104,6 +107,21 @@ config SOC_SAMA5D3
 	help
 	  Select this if you are using one of Atmel's SAMA5D3 family SoC.
 	  This support covers SAMA5D31, SAMA5D33, SAMA5D34, SAMA5D35, SAMA5D36.
+
+config SOC_SAMA5D4
+	bool "SAMA5D4 family"
+	select SOC_SAMA5
+	select HAVE_AT91_DBGU2
+	select CLKSRC_MMIO
+	select CACHE_L2X0
+	select CACHE_PL310
+	select HAVE_FB_ATMEL
+	select HAVE_AT91_UTMI
+	select HAVE_AT91_SMD
+	select HAVE_AT91_USB_CLK
+	select HAVE_AT91_H64MX
+	help
+	  Select this if you are using one of Atmel's SAMA5D4 family SoC.
 endif
 
 if SOC_SAM_V4_V5
diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
index 306c82b3d45c..82edd532c139 100644
--- a/arch/arm/mach-at91/Makefile
+++ b/arch/arm/mach-at91/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_SOC_AT91SAM9N12)	+= at91sam9n12.o
 obj-$(CONFIG_SOC_AT91SAM9X5)	+= at91sam9x5.o
 obj-$(CONFIG_SOC_AT91SAM9RL)	+= at91sam9rl.o
 obj-$(CONFIG_SOC_SAMA5D3)	+= sama5d3.o
+obj-$(CONFIG_SOC_SAMA5D4)	+= sama5d4.o
 
 obj-$(CONFIG_ARCH_AT91RM9200)	+= at91rm9200_devices.o
 obj-$(CONFIG_ARCH_AT91SAM9260)	+= at91sam9260_devices.o
diff --git a/arch/arm/mach-at91/include/mach/cpu.h b/arch/arm/mach-at91/include/mach/cpu.h
index 86c71debab5b..d77572e8cb15 100644
--- a/arch/arm/mach-at91/include/mach/cpu.h
+++ b/arch/arm/mach-at91/include/mach/cpu.h
@@ -86,6 +86,9 @@ enum at91_soc_type {
 	/* SAMA5D3 */
 	AT91_SOC_SAMA5D3,
 
+	/* SAMA5D4 */
+	AT91_SOC_SAMA5D4,
+
 	/* Unknown type */
 	AT91_SOC_UNKNOWN,
 };
@@ -211,6 +214,12 @@ static inline int at91_soc_is_detected(void)
 #define cpu_is_sama5d3()	(0)
 #endif
 
+#ifdef CONFIG_SOC_SAMA5D4
+#define cpu_is_sama5d4()	(at91_soc_initdata.type == AT91_SOC_SAMA5D4)
+#else
+#define cpu_is_sama5d4()	(0)
+#endif
+
 /*
  * Since this is ARM, we will never run on any AVR32 CPU. But these
  * definitions may reduce clutter in common drivers.
diff --git a/arch/arm/mach-at91/include/mach/sama5d4.h b/arch/arm/mach-at91/include/mach/sama5d4.h
new file mode 100644
index 000000000000..f256a45d9854
--- /dev/null
+++ b/arch/arm/mach-at91/include/mach/sama5d4.h
@@ -0,0 +1,33 @@
+/*
+ * Chip-specific header file for the SAMA5D4 family
+ *
+ *  Copyright (C) 2013 Atmel Corporation,
+ *                     Nicolas Ferre <nicolas.ferre@atmel.com>
+ *
+ * Common definitions.
+ * Based on SAMA5D4 datasheet.
+ *
+ * Licensed under GPLv2 or later.
+ */
+
+#ifndef SAMA5D4_H
+#define SAMA5D4_H
+
+/*
+ * User Peripheral physical base addresses.
+ */
+#define SAMA5D4_BASE_USART3	0xfc00c000 /* (USART3 non-secure) Base Address */
+#define SAMA5D4_BASE_PMC	0xf0018000 /* (PMC) Base Address */
+#define SAMA5D4_BASE_MPDDRC	0xf0010000 /* (MPDDRC) Base Address */
+#define SAMA5D4_BASE_PIOD	0xfc068000 /* (PIOD) Base Address */
+
+/* Some other peripherals */
+#define SAMA5D4_BASE_SYS2	SAMA5D4_BASE_PIOD
+
+/*
+ * Internal Memory.
+ */
+#define SAMA5D4_NS_SRAM_BASE     0x00210000      /* Internal SRAM base address Non-Secure */
+#define SAMA5D4_NS_SRAM_SIZE     (64 * SZ_1K)   /* Internal SRAM size Non-Secure part (64Kb) */
+
+#endif
diff --git a/arch/arm/mach-at91/sama5d4.c b/arch/arm/mach-at91/sama5d4.c
new file mode 100644
index 000000000000..f81f11ed8deb
--- /dev/null
+++ b/arch/arm/mach-at91/sama5d4.c
@@ -0,0 +1,36 @@
+/*
+ *  Chip-specific setup code for the SAMA5D4 family
+ *
+ *  Copyright (C) 2013 Atmel Corporation,
+ *                     Nicolas Ferre <nicolas.ferre@atmel.com>
+ *
+ * Licensed under GPLv2 or later.
+ */
+
+#include <linux/module.h>
+#include <linux/dma-mapping.h>
+#include <linux/clk/at91_pmc.h>
+
+#include <asm/irq.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <mach/sama5d4.h>
+#include <mach/cpu.h>
+#include <mach/hardware.h>
+
+#include "soc.h"
+#include "generic.h"
+#include "sam9_smc.h"
+
+/* --------------------------------------------------------------------
+ *  Processor initialization
+ * -------------------------------------------------------------------- */
+
+static void __init sama5d4_map_io(void)
+{
+	at91_init_sram(0, SAMA5D4_NS_SRAM_BASE, SAMA5D4_NS_SRAM_SIZE);
+}
+
+AT91_SOC_START(sama5d4)
+	.map_io = sama5d4_map_io,
+AT91_SOC_END
diff --git a/arch/arm/mach-at91/soc.h b/arch/arm/mach-at91/soc.h
index ab983f2cc7dd..85ecd8ad9c53 100644
--- a/arch/arm/mach-at91/soc.h
+++ b/arch/arm/mach-at91/soc.h
@@ -25,6 +25,7 @@ extern struct at91_init_soc at91sam9rl_soc;
 extern struct at91_init_soc at91sam9x5_soc;
 extern struct at91_init_soc at91sam9n12_soc;
 extern struct at91_init_soc sama5d3_soc;
+extern struct at91_init_soc sama5d4_soc;
 
 #define AT91_SOC_START(_name)				\
 struct at91_init_soc __initdata _name##_soc		\
@@ -75,3 +76,7 @@ static inline int at91_soc_is_enabled(void)
 #if !defined(CONFIG_SOC_SAMA5D3)
 #define sama5d3_soc	at91_boot_soc
 #endif
+
+#if !defined(CONFIG_SOC_SAMA5D4)
+#define sama5d4_soc	at91_boot_soc
+#endif
-- 
1.9.1

