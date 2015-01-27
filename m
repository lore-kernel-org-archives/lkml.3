Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344AbbA0SIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 13:08:53 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:10718 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758824AbbA0SIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 13:08:52 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, Arnd Bergmann <arnd@arndb.de>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 5/7] ARM: at91: change board files into SoC files
Date: Tue, 27 Jan 2015 19:07:24 +0100
Message-ID: <f4777d45c52525babe431b01d6cbfb30bbaca265.1422381280.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <cover.1422381280.git.nicolas.ferre@atmel.com>
References: <cover.1422381280.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As board files are now DT only and can address all aspects of the SoC family,
we can rename them so that the mach-at91 directory looks cleaner.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/Makefile          | 11 ++---
 arch/arm/mach-at91/at91rm9200.c      | 68 ++++++++++++++++++++++++++
 arch/arm/mach-at91/at91sam9.c        | 90 ++++++++++++++++++++++++++++++++++
 arch/arm/mach-at91/board-dt-rm9200.c | 68 --------------------------
 arch/arm/mach-at91/board-dt-sam9.c   | 90 ----------------------------------
 arch/arm/mach-at91/board-dt-sama5.c  | 95 ------------------------------------
 arch/arm/mach-at91/sama5.c           | 95 ++++++++++++++++++++++++++++++++++++
 7 files changed, 256 insertions(+), 261 deletions(-)
 create mode 100644 arch/arm/mach-at91/at91rm9200.c
 create mode 100644 arch/arm/mach-at91/at91sam9.c
 delete mode 100644 arch/arm/mach-at91/board-dt-rm9200.c
 delete mode 100644 arch/arm/mach-at91/board-dt-sam9.c
 delete mode 100644 arch/arm/mach-at91/board-dt-sama5.c
 create mode 100644 arch/arm/mach-at91/sama5.c

diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
index 3362f51ffd82..827fdbcce1c7 100644
--- a/arch/arm/mach-at91/Makefile
+++ b/arch/arm/mach-at91/Makefile
@@ -7,14 +7,9 @@ obj-y		:= setup.o
 obj-$(CONFIG_SOC_AT91SAM9)	+= sam9_smc.o
 
 # CPU-specific support
-obj-$(CONFIG_SOC_AT91RM9200)	+= at91rm9200_time.o
-
-# AT91SAM board with device-tree
-obj-$(CONFIG_SOC_AT91RM9200) += board-dt-rm9200.o
-obj-$(CONFIG_SOC_AT91SAM9) += board-dt-sam9.o
-
-# SAMA5 board with device-tree
-obj-$(CONFIG_SOC_SAMA5)		+= board-dt-sama5.o
+obj-$(CONFIG_SOC_AT91RM9200)	+= at91rm9200.o at91rm9200_time.o
+obj-$(CONFIG_SOC_AT91SAM9)	+= at91sam9.o
+obj-$(CONFIG_SOC_SAMA5)		+= sama5.o
 
 # Power Management
 obj-$(CONFIG_PM)		+= pm.o
diff --git a/arch/arm/mach-at91/at91rm9200.c b/arch/arm/mach-at91/at91rm9200.c
new file mode 100644
index 000000000000..ec89806c9d5d
--- /dev/null
+++ b/arch/arm/mach-at91/at91rm9200.c
@@ -0,0 +1,68 @@
+/*
+ *  Setup code for AT91RM9200
+ *
+ *  Copyright (C) 2011 Atmel,
+ *                2011 Nicolas Ferre <nicolas.ferre@atmel.com>
+ *                2012 Joachim Eastwood <manabian@gmail.com>
+ *
+ * Licensed under GPLv2 or later.
+ */
+
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/gpio.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
+#include <linux/of_platform.h>
+#include <linux/clk-provider.h>
+
+#include <asm/setup.h>
+#include <asm/irq.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <asm/mach/irq.h>
+#include <asm/system_misc.h>
+
+#include <mach/at91_st.h>
+
+#include "generic.h"
+
+static void at91rm9200_restart(enum reboot_mode reboot_mode, const char *cmd)
+{
+	/*
+	 * Perform a hardware reset with the use of the Watchdog timer.
+	 */
+	at91_st_write(AT91_ST_WDMR, AT91_ST_RSTEN | AT91_ST_EXTEN | 1);
+	at91_st_write(AT91_ST_CR, AT91_ST_WDRST);
+}
+
+static void __init at91rm9200_dt_timer_init(void)
+{
+	of_clk_init(NULL);
+	at91rm9200_timer_init();
+}
+
+static void __init rm9200_dt_device_init(void)
+{
+	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+
+	arm_pm_idle = at91rm9200_idle;
+	arm_pm_restart = at91rm9200_restart;
+	at91_rm9200_pm_init();
+}
+
+
+
+static const char *at91rm9200_dt_board_compat[] __initconst = {
+	"atmel,at91rm9200",
+	NULL
+};
+
+DT_MACHINE_START(at91rm9200_dt, "Atmel AT91RM9200 (Device Tree)")
+	.init_time      = at91rm9200_dt_timer_init,
+	.map_io		= at91_map_io,
+	.init_early	= at91_dt_initialize,
+	.init_machine	= rm9200_dt_device_init,
+	.dt_compat	= at91rm9200_dt_board_compat,
+MACHINE_END
diff --git a/arch/arm/mach-at91/at91sam9.c b/arch/arm/mach-at91/at91sam9.c
new file mode 100644
index 000000000000..04a9af79aadb
--- /dev/null
+++ b/arch/arm/mach-at91/at91sam9.c
@@ -0,0 +1,90 @@
+/*
+ *  Setup code for AT91SAM9
+ *
+ *  Copyright (C) 2011 Atmel,
+ *                2011 Nicolas Ferre <nicolas.ferre@atmel.com>
+ *
+ * Licensed under GPLv2 or later.
+ */
+
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/gpio.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
+#include <linux/of_platform.h>
+#include <linux/clk-provider.h>
+
+#include <asm/system_misc.h>
+#include <asm/setup.h>
+#include <asm/irq.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <asm/mach/irq.h>
+
+#include "generic.h"
+
+static void __init sam9_dt_device_init(void)
+{
+	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+
+	arm_pm_idle = at91sam9_idle;
+	at91_sam9260_pm_init();
+}
+
+static const char *at91_dt_board_compat[] __initconst = {
+	"atmel,at91sam9",
+	NULL
+};
+
+DT_MACHINE_START(at91sam_dt, "Atmel AT91SAM (Device Tree)")
+	/* Maintainer: Atmel */
+	.map_io		= at91_map_io,
+	.init_early	= at91_dt_initialize,
+	.init_machine	= sam9_dt_device_init,
+	.dt_compat	= at91_dt_board_compat,
+MACHINE_END
+
+static void __init sam9g45_dt_device_init(void)
+{
+	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+
+	arm_pm_idle = at91sam9_idle;
+	at91_sam9g45_pm_init();
+}
+
+static const char *at91_9g45_board_compat[] __initconst = {
+	"atmel,at91sam9g45",
+	NULL
+};
+
+DT_MACHINE_START(at91sam9g45_dt, "Atmel AT91SAM9G45")
+	/* Maintainer: Atmel */
+	.map_io		= at91_map_io,
+	.init_early	= at91_dt_initialize,
+	.init_machine	= sam9g45_dt_device_init,
+	.dt_compat	= at91_9g45_board_compat,
+MACHINE_END
+
+static void __init sam9x5_dt_device_init(void)
+{
+	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+
+	arm_pm_idle = at91sam9_idle;
+	at91_sam9x5_pm_init();
+}
+
+static const char *at91_9x5_board_compat[] __initconst = {
+	"atmel,at91sam9x5",
+	"atmel,at91sam9n12",
+	NULL
+};
+
+DT_MACHINE_START(at91sam9x5_dt, "Atmel AT91SAM9")
+	/* Maintainer: Atmel */
+	.map_io		= at91_map_io,
+	.init_early	= at91_dt_initialize,
+	.init_machine	= sam9x5_dt_device_init,
+	.dt_compat	= at91_9x5_board_compat,
+MACHINE_END
diff --git a/arch/arm/mach-at91/board-dt-rm9200.c b/arch/arm/mach-at91/board-dt-rm9200.c
deleted file mode 100644
index 5fcd1c73ece0..000000000000
--- a/arch/arm/mach-at91/board-dt-rm9200.c
+++ /dev/null
@@ -1,68 +0,0 @@
-/*
- *  Setup code for AT91RM9200 Evaluation Kits with Device Tree support
- *
- *  Copyright (C) 2011 Atmel,
- *                2011 Nicolas Ferre <nicolas.ferre@atmel.com>
- *                2012 Joachim Eastwood <manabian@gmail.com>
- *
- * Licensed under GPLv2 or later.
- */
-
-#include <linux/types.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/gpio.h>
-#include <linux/of.h>
-#include <linux/of_irq.h>
-#include <linux/of_platform.h>
-#include <linux/clk-provider.h>
-
-#include <asm/setup.h>
-#include <asm/irq.h>
-#include <asm/mach/arch.h>
-#include <asm/mach/map.h>
-#include <asm/mach/irq.h>
-#include <asm/system_misc.h>
-
-#include <mach/at91_st.h>
-
-#include "generic.h"
-
-static void at91rm9200_restart(enum reboot_mode reboot_mode, const char *cmd)
-{
-	/*
-	 * Perform a hardware reset with the use of the Watchdog timer.
-	 */
-	at91_st_write(AT91_ST_WDMR, AT91_ST_RSTEN | AT91_ST_EXTEN | 1);
-	at91_st_write(AT91_ST_CR, AT91_ST_WDRST);
-}
-
-static void __init at91rm9200_dt_timer_init(void)
-{
-	of_clk_init(NULL);
-	at91rm9200_timer_init();
-}
-
-static void __init rm9200_dt_device_init(void)
-{
-	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
-
-	arm_pm_idle = at91rm9200_idle;
-	arm_pm_restart = at91rm9200_restart;
-	at91_rm9200_pm_init();
-}
-
-
-
-static const char *at91rm9200_dt_board_compat[] __initconst = {
-	"atmel,at91rm9200",
-	NULL
-};
-
-DT_MACHINE_START(at91rm9200_dt, "Atmel AT91RM9200 (Device Tree)")
-	.init_time      = at91rm9200_dt_timer_init,
-	.map_io		= at91_map_io,
-	.init_early	= at91_dt_initialize,
-	.init_machine	= rm9200_dt_device_init,
-	.dt_compat	= at91rm9200_dt_board_compat,
-MACHINE_END
diff --git a/arch/arm/mach-at91/board-dt-sam9.c b/arch/arm/mach-at91/board-dt-sam9.c
deleted file mode 100644
index f5d922e57655..000000000000
--- a/arch/arm/mach-at91/board-dt-sam9.c
+++ /dev/null
@@ -1,90 +0,0 @@
-/*
- *  Setup code for AT91SAM Evaluation Kits with Device Tree support
- *
- *  Copyright (C) 2011 Atmel,
- *                2011 Nicolas Ferre <nicolas.ferre@atmel.com>
- *
- * Licensed under GPLv2 or later.
- */
-
-#include <linux/types.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/gpio.h>
-#include <linux/of.h>
-#include <linux/of_irq.h>
-#include <linux/of_platform.h>
-#include <linux/clk-provider.h>
-
-#include <asm/system_misc.h>
-#include <asm/setup.h>
-#include <asm/irq.h>
-#include <asm/mach/arch.h>
-#include <asm/mach/map.h>
-#include <asm/mach/irq.h>
-
-#include "generic.h"
-
-static void __init sam9_dt_device_init(void)
-{
-	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
-
-	arm_pm_idle = at91sam9_idle;
-	at91_sam9260_pm_init();
-}
-
-static const char *at91_dt_board_compat[] __initconst = {
-	"atmel,at91sam9",
-	NULL
-};
-
-DT_MACHINE_START(at91sam_dt, "Atmel AT91SAM (Device Tree)")
-	/* Maintainer: Atmel */
-	.map_io		= at91_map_io,
-	.init_early	= at91_dt_initialize,
-	.init_machine	= sam9_dt_device_init,
-	.dt_compat	= at91_dt_board_compat,
-MACHINE_END
-
-static void __init sam9g45_dt_device_init(void)
-{
-	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
-
-	arm_pm_idle = at91sam9_idle;
-	at91_sam9g45_pm_init();
-}
-
-static const char *at91_9g45_board_compat[] __initconst = {
-	"atmel,at91sam9g45",
-	NULL
-};
-
-DT_MACHINE_START(at91sam9g45_dt, "Atmel AT91SAM9G45")
-	/* Maintainer: Atmel */
-	.map_io		= at91_map_io,
-	.init_early	= at91_dt_initialize,
-	.init_machine	= sam9g45_dt_device_init,
-	.dt_compat	= at91_9g45_board_compat,
-MACHINE_END
-
-static void __init sam9x5_dt_device_init(void)
-{
-	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
-
-	arm_pm_idle = at91sam9_idle;
-	at91_sam9x5_pm_init();
-}
-
-static const char *at91_9x5_board_compat[] __initconst = {
-	"atmel,at91sam9x5",
-	"atmel,at91sam9n12",
-	NULL
-};
-
-DT_MACHINE_START(at91sam9x5_dt, "Atmel AT91SAM9")
-	/* Maintainer: Atmel */
-	.map_io		= at91_map_io,
-	.init_early	= at91_dt_initialize,
-	.init_machine	= sam9x5_dt_device_init,
-	.dt_compat	= at91_9x5_board_compat,
-MACHINE_END
diff --git a/arch/arm/mach-at91/board-dt-sama5.c b/arch/arm/mach-at91/board-dt-sama5.c
deleted file mode 100644
index 7806f58c7e4d..000000000000
--- a/arch/arm/mach-at91/board-dt-sama5.c
+++ /dev/null
@@ -1,95 +0,0 @@
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
-#include <mach/hardware.h>
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
-	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
-	at91_sam9x5_pm_init();
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
-static struct map_desc at91_io_desc[] __initdata = {
-	{
-	.virtual        = (unsigned long)AT91_ALT_IO_P2V(SAMA5D4_BASE_MPDDRC),
-	.pfn            = __phys_to_pfn(SAMA5D4_BASE_MPDDRC),
-	.length         = SZ_512,
-	.type           = MT_DEVICE,
-	},
-	{
-	.virtual        = (unsigned long)AT91_ALT_IO_P2V(SAMA5D4_BASE_PMC),
-	.pfn            = __phys_to_pfn(SAMA5D4_BASE_PMC),
-	.length         = SZ_512,
-	.type           = MT_DEVICE,
-	},
-	{ /* On sama5d4, we use USART3 as serial console */
-	.virtual        = (unsigned long)AT91_ALT_IO_P2V(SAMA5D4_BASE_USART3),
-	.pfn            = __phys_to_pfn(SAMA5D4_BASE_USART3),
-	.length         = SZ_256,
-	.type           = MT_DEVICE,
-	},
-	{ /* A bunch of peripheral with fine grained IO space */
-	.virtual        = (unsigned long)AT91_ALT_IO_P2V(SAMA5D4_BASE_SYS2),
-	.pfn            = __phys_to_pfn(SAMA5D4_BASE_SYS2),
-	.length         = SZ_2K,
-	.type           = MT_DEVICE,
-	},
-};
-
-static void __init sama5_alt_map_io(void)
-{
-	at91_alt_map_io();
-	iotable_init(at91_io_desc, ARRAY_SIZE(at91_io_desc));
-}
-
-static const char *sama5_alt_dt_board_compat[] __initconst = {
-	"atmel,sama5d4",
-	NULL
-};
-
-DT_MACHINE_START(sama5_alt_dt, "Atmel SAMA5 (Device Tree)")
-	/* Maintainer: Atmel */
-	.map_io		= sama5_alt_map_io,
-	.init_early	= at91_dt_initialize,
-	.init_machine	= sama5_dt_device_init,
-	.dt_compat	= sama5_alt_dt_board_compat,
-	.l2c_aux_mask	= ~0UL,
-MACHINE_END
diff --git a/arch/arm/mach-at91/sama5.c b/arch/arm/mach-at91/sama5.c
new file mode 100644
index 000000000000..12440096762f
--- /dev/null
+++ b/arch/arm/mach-at91/sama5.c
@@ -0,0 +1,95 @@
+/*
+ *  Setup code for SAMA5
+ *
+ *  Copyright (C) 2013 Atmel,
+ *                2013 Ludovic Desroches <ludovic.desroches@atmel.com>
+ *
+ * Licensed under GPLv2 or later.
+ */
+
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/gpio.h>
+#include <linux/micrel_phy.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
+#include <linux/of_platform.h>
+#include <linux/phy.h>
+#include <linux/clk-provider.h>
+
+#include <mach/hardware.h>
+
+#include <asm/setup.h>
+#include <asm/irq.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <asm/mach/irq.h>
+
+#include "generic.h"
+
+static void __init sama5_dt_device_init(void)
+{
+	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+	at91_sam9x5_pm_init();
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
+
+static struct map_desc at91_io_desc[] __initdata = {
+	{
+	.virtual        = (unsigned long)AT91_ALT_IO_P2V(SAMA5D4_BASE_MPDDRC),
+	.pfn            = __phys_to_pfn(SAMA5D4_BASE_MPDDRC),
+	.length         = SZ_512,
+	.type           = MT_DEVICE,
+	},
+	{
+	.virtual        = (unsigned long)AT91_ALT_IO_P2V(SAMA5D4_BASE_PMC),
+	.pfn            = __phys_to_pfn(SAMA5D4_BASE_PMC),
+	.length         = SZ_512,
+	.type           = MT_DEVICE,
+	},
+	{ /* On sama5d4, we use USART3 as serial console */
+	.virtual        = (unsigned long)AT91_ALT_IO_P2V(SAMA5D4_BASE_USART3),
+	.pfn            = __phys_to_pfn(SAMA5D4_BASE_USART3),
+	.length         = SZ_256,
+	.type           = MT_DEVICE,
+	},
+	{ /* A bunch of peripheral with fine grained IO space */
+	.virtual        = (unsigned long)AT91_ALT_IO_P2V(SAMA5D4_BASE_SYS2),
+	.pfn            = __phys_to_pfn(SAMA5D4_BASE_SYS2),
+	.length         = SZ_2K,
+	.type           = MT_DEVICE,
+	},
+};
+
+static void __init sama5_alt_map_io(void)
+{
+	at91_alt_map_io();
+	iotable_init(at91_io_desc, ARRAY_SIZE(at91_io_desc));
+}
+
+static const char *sama5_alt_dt_board_compat[] __initconst = {
+	"atmel,sama5d4",
+	NULL
+};
+
+DT_MACHINE_START(sama5_alt_dt, "Atmel SAMA5 (Device Tree)")
+	/* Maintainer: Atmel */
+	.map_io		= sama5_alt_map_io,
+	.init_early	= at91_dt_initialize,
+	.init_machine	= sama5_dt_device_init,
+	.dt_compat	= sama5_alt_dt_board_compat,
+	.l2c_aux_mask	= ~0UL,
+MACHINE_END
-- 
2.1.3

