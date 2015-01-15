Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbbAOV7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:59:35 -0500
Received: from down.free-electrons.com ([37.187.137.238]:57553 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755848AbbAOV7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:59:32 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Bo Shen <voice.shen@atmel.com>, Wenyou Yang <Wenyou.Yang@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 02/17] ARM: at91: move sama5 specific code into per-soc files
Date: Thu, 15 Jan 2015 22:58:05 +0100
Message-Id: <1421359100-8930-3-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421359100-8930-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421359100-8930-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The common board-dt-sama5 file no longer contains any shared
code, so we can just move the machine descriptors into the
per-soc files for further cleanup.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/Makefile         |  3 --
 arch/arm/mach-at91/board-dt-sama5.c | 60 -------------------------------------
 arch/arm/mach-at91/sama5d3.c        | 28 +++++++++++++----
 arch/arm/mach-at91/sama5d4.c        | 33 ++++++++++++++++++--
 4 files changed, 54 insertions(+), 70 deletions(-)
 delete mode 100644 arch/arm/mach-at91/board-dt-sama5.c

diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
index d89c2437ef10..4bce1fac680e 100644
--- a/arch/arm/mach-at91/Makefile
+++ b/arch/arm/mach-at91/Makefile
@@ -21,9 +21,6 @@ obj-$(CONFIG_SOC_SAMA5D4)	+= sama5d4.o
 # AT91SAM board with device-tree
 obj-$(CONFIG_SOC_AT91SAM9) += board-dt-sam9.o
 
-# SAMA5 board with device-tree
-obj-$(CONFIG_SOC_SAMA5)		+= board-dt-sama5.o
-
 # Power Management
 obj-$(CONFIG_PM)		+= pm.o
 obj-$(CONFIG_AT91_SLOW_CLOCK)	+= pm_slowclock.o
diff --git a/arch/arm/mach-at91/board-dt-sama5.c b/arch/arm/mach-at91/board-dt-sama5.c
deleted file mode 100644
index 44d372a22a29..000000000000
--- a/arch/arm/mach-at91/board-dt-sama5.c
+++ /dev/null
@@ -1,60 +0,0 @@
-/*
- *  Setup code for SAMA5 Evaluation Kits with Device Tree support
- *
- *  Copyright (C) 2013 Atmel,
- *                2013 Ludovic Desroches <ludovic.desroches@atmel.com>
- *
- * Licensed under GPLv2 or later.
- */
-
-#include <linux/types.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/gpio.h>
-#include <linux/micrel_phy.h>
-#include <linux/of.h>
-#include <linux/of_irq.h>
-#include <linux/of_platform.h>
-#include <linux/phy.h>
-#include <linux/clk-provider.h>
-
-#include <asm/setup.h>
-#include <asm/irq.h>
-#include <asm/mach/arch.h>
-#include <asm/mach/map.h>
-#include <asm/mach/irq.h>
-
-#include "generic.h"
-
-static void __init sama5_dt_device_init(void)
-{
-	at91_sam9260_pm_init();
-	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
-}
-
-static const char *sama5_dt_board_compat[] __initconst = {
-	"atmel,sama5",
-	NULL
-};
-
-DT_MACHINE_START(sama5_dt, "Atmel SAMA5 (Device Tree)")
-	/* Maintainer: Atmel */
-	.map_io		= at91_map_io,
-	.init_early	= at91_dt_initialize,
-	.init_machine	= sama5_dt_device_init,
-	.dt_compat	= sama5_dt_board_compat,
-MACHINE_END
-
-static const char *sama5_alt_dt_board_compat[] __initconst = {
-	"atmel,sama5d4",
-	NULL
-};
-
-DT_MACHINE_START(sama5_alt_dt, "Atmel SAMA5 (Device Tree)")
-	/* Maintainer: Atmel */
-	.map_io		= at91_alt_map_io,
-	.init_early	= at91_dt_initialize,
-	.init_machine	= sama5_dt_device_init,
-	.dt_compat	= sama5_alt_dt_board_compat,
-	.l2c_aux_mask	= ~0UL,
-MACHINE_END
diff --git a/arch/arm/mach-at91/sama5d3.c b/arch/arm/mach-at91/sama5d3.c
index b7c64ca7107f..ecd35f135a9f 100644
--- a/arch/arm/mach-at91/sama5d3.c
+++ b/arch/arm/mach-at91/sama5d3.c
@@ -7,19 +7,18 @@
  * Licensed under GPLv2 or later.
  */
 
-#include <linux/module.h>
-#include <linux/dma-mapping.h>
-#include <linux/clk/at91_pmc.h>
+#include <linux/init.h>
+#include <linux/of_platform.h>
 
-#include <asm/irq.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
+#include <asm/mach/irq.h>
+
 #include <mach/sama5d3.h>
 #include <mach/cpu.h>
 
 #include "soc.h"
 #include "generic.h"
-#include "sam9_smc.h"
 
 /* --------------------------------------------------------------------
  *  AT91SAM9x5 processor initialization
@@ -27,3 +26,22 @@
 
 AT91_SOC_START(sama5d3)
 AT91_SOC_END
+
+static void __init sama5_dt_device_init(void)
+{
+	at91_sam9260_pm_init();
+	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+}
+
+static const char *sama5_dt_board_compat[] __initconst = {
+	"atmel,sama5",
+	NULL
+};
+
+DT_MACHINE_START(sama5_dt, "Atmel SAMA5 (Device Tree)")
+	/* Maintainer: Atmel */
+	.map_io		= at91_map_io,
+	.init_early	= at91_dt_initialize,
+	.init_machine	= sama5_dt_device_init,
+	.dt_compat	= sama5_dt_board_compat,
+MACHINE_END
diff --git a/arch/arm/mach-at91/sama5d4.c b/arch/arm/mach-at91/sama5d4.c
index fa127fb79221..68573cd9d8f9 100644
--- a/arch/arm/mach-at91/sama5d4.c
+++ b/arch/arm/mach-at91/sama5d4.c
@@ -10,17 +10,27 @@
 #include <linux/module.h>
 #include <linux/dma-mapping.h>
 #include <linux/clk/at91_pmc.h>
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/gpio.h>
+#include <linux/micrel_phy.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
+#include <linux/of_platform.h>
+#include <linux/phy.h>
+#include <linux/clk-provider.h>
 
 #include <asm/irq.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
+#include <asm/mach/irq.h>
+
 #include <mach/sama5d4.h>
 #include <mach/cpu.h>
 #include <mach/hardware.h>
 
 #include "soc.h"
 #include "generic.h"
-#include "sam9_smc.h"
 
 /* --------------------------------------------------------------------
  *  Processor initialization
@@ -52,7 +62,6 @@ static struct map_desc at91_io_desc[] __initdata = {
 	},
 };
 
-
 static void __init sama5d4_map_io(void)
 {
 	iotable_init(at91_io_desc, ARRAY_SIZE(at91_io_desc));
@@ -61,3 +70,23 @@ static void __init sama5d4_map_io(void)
 AT91_SOC_START(sama5d4)
 	.map_io = sama5d4_map_io,
 AT91_SOC_END
+
+static void __init sama5d4_dt_device_init(void)
+{
+	at91_sam9260_pm_init();
+	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+}
+
+static const char *sama5_alt_dt_board_compat[] __initconst = {
+	"atmel,sama5d4",
+	NULL
+};
+
+DT_MACHINE_START(sama5_alt_dt, "Atmel SAMA5 (Device Tree)")
+	/* Maintainer: Atmel */
+	.map_io		= at91_alt_map_io,
+	.init_early	= at91_dt_initialize,
+	.init_machine	= sama5d4_dt_device_init,
+	.dt_compat	= sama5_alt_dt_board_compat,
+	.l2c_aux_mask	= ~0UL,
+MACHINE_END
-- 
2.1.0

