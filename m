Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280AbaDQIxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 04:53:41 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54381 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751113AbaDQIuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 04:50:09 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Emilio Lopez <emilio@elopez.com.ar>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, andriy.shevchenko@intel.com,
        Arnd Bergmann <arnd@arndb.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v6 2/8] ARM: sunxi: Split out the various machines into separate files
Date: Thu, 17 Apr 2014 10:46:13 +0200
Message-Id: <1397724379-15398-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397724379-15398-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1397724379-15398-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will allow to add per-SoC hooks more easily.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-sunxi/Makefile  |   6 +-
 arch/arm/mach-sunxi/restart.c | 104 +++++++++++++++++++++++++++
 arch/arm/mach-sunxi/restart.h |  20 ++++++
 arch/arm/mach-sunxi/sun4i.c   |  36 ++++++++++
 arch/arm/mach-sunxi/sun5i.c   |  37 ++++++++++
 arch/arm/mach-sunxi/sun6i.c   |  49 +++++++++++++
 arch/arm/mach-sunxi/sun7i.c   |  36 ++++++++++
 arch/arm/mach-sunxi/sunxi.c   | 164 ------------------------------------------
 8 files changed, 287 insertions(+), 165 deletions(-)
 create mode 100644 arch/arm/mach-sunxi/restart.c
 create mode 100644 arch/arm/mach-sunxi/restart.h
 create mode 100644 arch/arm/mach-sunxi/sun4i.c
 create mode 100644 arch/arm/mach-sunxi/sun5i.c
 create mode 100644 arch/arm/mach-sunxi/sun6i.c
 create mode 100644 arch/arm/mach-sunxi/sun7i.c
 delete mode 100644 arch/arm/mach-sunxi/sunxi.c

diff --git a/arch/arm/mach-sunxi/Makefile b/arch/arm/mach-sunxi/Makefile
index 27b168f121a1..e0e555fededa 100644
--- a/arch/arm/mach-sunxi/Makefile
+++ b/arch/arm/mach-sunxi/Makefile
@@ -1,2 +1,6 @@
-obj-$(CONFIG_ARCH_SUNXI) += sunxi.o
+obj-$(CONFIG_ARCH_SUNXI) += restart.o
+obj-$(CONFIG_ARCH_SUNXI) += sun4i.o
+obj-$(CONFIG_ARCH_SUNXI) += sun5i.o
+obj-$(CONFIG_ARCH_SUNXI) += sun6i.o
+obj-$(CONFIG_ARCH_SUNXI) += sun7i.o
 obj-$(CONFIG_SMP) += platsmp.o
diff --git a/arch/arm/mach-sunxi/restart.c b/arch/arm/mach-sunxi/restart.c
new file mode 100644
index 000000000000..3b89727ee943
--- /dev/null
+++ b/arch/arm/mach-sunxi/restart.c
@@ -0,0 +1,104 @@
+/*
+ * Restart code for Allwinner SoCs
+ *
+ * Copyright (C) 2012-2014 Maxime Ripard
+ *
+ * Maxime Ripard <maxime.ripard@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/mod_devicetable.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/reboot.h>
+
+#include "restart.h"
+
+#define SUN4I_WATCHDOG_CTRL_REG		0x00
+#define SUN4I_WATCHDOG_CTRL_RESTART		BIT(0)
+#define SUN4I_WATCHDOG_MODE_REG		0x04
+#define SUN4I_WATCHDOG_MODE_ENABLE		BIT(0)
+#define SUN4I_WATCHDOG_MODE_RESET_ENABLE	BIT(1)
+
+#define SUN6I_WATCHDOG1_IRQ_REG		0x00
+#define SUN6I_WATCHDOG1_CTRL_REG	0x10
+#define SUN6I_WATCHDOG1_CTRL_RESTART		BIT(0)
+#define SUN6I_WATCHDOG1_CONFIG_REG	0x14
+#define SUN6I_WATCHDOG1_CONFIG_RESTART		BIT(0)
+#define SUN6I_WATCHDOG1_CONFIG_IRQ		BIT(1)
+#define SUN6I_WATCHDOG1_MODE_REG	0x18
+#define SUN6I_WATCHDOG1_MODE_ENABLE		BIT(0)
+
+static void __iomem *wdt_base;
+
+void sun4i_restart(enum reboot_mode mode, const char *cmd)
+{
+	if (!wdt_base)
+		return;
+
+	/* Enable timer and set reset bit in the watchdog */
+	writel(SUN4I_WATCHDOG_MODE_ENABLE | SUN4I_WATCHDOG_MODE_RESET_ENABLE,
+	       wdt_base + SUN4I_WATCHDOG_MODE_REG);
+
+	/*
+	 * Restart the watchdog. The default (and lowest) interval
+	 * value for the watchdog is 0.5s.
+	 */
+	writel(SUN4I_WATCHDOG_CTRL_RESTART, wdt_base + SUN4I_WATCHDOG_CTRL_REG);
+
+	while (1) {
+		mdelay(5);
+		writel(SUN4I_WATCHDOG_MODE_ENABLE | SUN4I_WATCHDOG_MODE_RESET_ENABLE,
+		       wdt_base + SUN4I_WATCHDOG_MODE_REG);
+	}
+}
+
+void sun6i_restart(enum reboot_mode mode, const char *cmd)
+{
+	if (!wdt_base)
+		return;
+
+	/* Disable interrupts */
+	writel(0, wdt_base + SUN6I_WATCHDOG1_IRQ_REG);
+
+	/* We want to disable the IRQ and just reset the whole system */
+	writel(SUN6I_WATCHDOG1_CONFIG_RESTART,
+		wdt_base + SUN6I_WATCHDOG1_CONFIG_REG);
+
+	/* Enable timer. The default and lowest interval value is 0.5s */
+	writel(SUN6I_WATCHDOG1_MODE_ENABLE,
+		wdt_base + SUN6I_WATCHDOG1_MODE_REG);
+
+	/* Restart the watchdog. */
+	writel(SUN6I_WATCHDOG1_CTRL_RESTART,
+		wdt_base + SUN6I_WATCHDOG1_CTRL_REG);
+
+	while (1) {
+		mdelay(5);
+		writel(SUN6I_WATCHDOG1_MODE_ENABLE,
+			wdt_base + SUN6I_WATCHDOG1_MODE_REG);
+	}
+}
+
+static struct of_device_id sunxi_restart_ids[] = {
+	{ .compatible = "allwinner,sun4i-a10-wdt" },
+	{ .compatible = "allwinner,sun6i-a31-wdt" },
+	{ /*sentinel*/ }
+};
+
+void sunxi_setup_restart(void)
+{
+	struct device_node *np;
+
+	np = of_find_matching_node(NULL, sunxi_restart_ids);
+	if (WARN(!np, "unable to setup watchdog restart"))
+		return;
+
+	wdt_base = of_iomap(np, 0);
+	WARN(!wdt_base, "failed to map watchdog base address");
+}
diff --git a/arch/arm/mach-sunxi/restart.h b/arch/arm/mach-sunxi/restart.h
new file mode 100644
index 000000000000..ef039db8f544
--- /dev/null
+++ b/arch/arm/mach-sunxi/restart.h
@@ -0,0 +1,20 @@
+/*
+ * Restart code for Allwinner SoCs
+ *
+ * Copyright (C) 2012-2014 Maxime Ripard
+ *
+ * Maxime Ripard <maxime.ripard@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef _SUNXI_RESTART_H_
+#define _SUNXI_RESTART_H_
+
+void sun4i_restart(enum reboot_mode mode, const char *cmd);
+void sun6i_restart(enum reboot_mode mode, const char *cmd);
+void sunxi_setup_restart(void);
+
+#endif
diff --git a/arch/arm/mach-sunxi/sun4i.c b/arch/arm/mach-sunxi/sun4i.c
new file mode 100644
index 000000000000..fc28b89b3378
--- /dev/null
+++ b/arch/arm/mach-sunxi/sun4i.c
@@ -0,0 +1,36 @@
+/*
+ * Device Tree support for Allwinner A10 SoCs
+ *
+ * Copyright (C) 2012-2014 Maxime Ripard
+ *
+ * Maxime Ripard <maxime.ripard@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/init.h>
+#include <linux/of_platform.h>
+
+#include <asm/mach/arch.h>
+
+#include "restart.h"
+
+static void __init sun4i_dt_init(void)
+{
+	sunxi_setup_restart();
+
+	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+}
+
+static const char * const sun4i_board_dt_compat[] = {
+	"allwinner,sun4i-a10",
+	NULL,
+};
+
+DT_MACHINE_START(SUN4I_DT, "Allwinner sun4i (A10) Family")
+	.init_machine	= sun4i_dt_init,
+	.dt_compat	= sun4i_board_dt_compat,
+	.restart	= sun4i_restart,
+MACHINE_END
diff --git a/arch/arm/mach-sunxi/sun5i.c b/arch/arm/mach-sunxi/sun5i.c
new file mode 100644
index 000000000000..623a95ad93b7
--- /dev/null
+++ b/arch/arm/mach-sunxi/sun5i.c
@@ -0,0 +1,37 @@
+/*
+ * Device Tree support for Allwinner A20 SoCs
+ *
+ * Copyright (C) 2013-2014 Maxime Ripard
+ *
+ * Maxime Ripard <maxime.ripard@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/init.h>
+#include <linux/of_platform.h>
+
+#include <asm/mach/arch.h>
+
+#include "restart.h"
+
+static void __init sun5i_dt_init(void)
+{
+	sunxi_setup_restart();
+
+	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+}
+
+static const char * const sun5i_board_dt_compat[] = {
+	"allwinner,sun5i-a10s",
+	"allwinner,sun5i-a13",
+	NULL,
+};
+
+DT_MACHINE_START(SUN5I_DT, "Allwinner sun5i (A13/A10s) Family")
+	.init_machine	= sun5i_dt_init,
+	.dt_compat	= sun5i_board_dt_compat,
+	.restart	= sun4i_restart,
+MACHINE_END
diff --git a/arch/arm/mach-sunxi/sun6i.c b/arch/arm/mach-sunxi/sun6i.c
new file mode 100644
index 000000000000..c5dc81988ce9
--- /dev/null
+++ b/arch/arm/mach-sunxi/sun6i.c
@@ -0,0 +1,49 @@
+/*
+ * Device Tree support for Allwinner A31 SoCs
+ *
+ * Copyright (C) 2013-2014 Maxime Ripard
+ *
+ * Maxime Ripard <maxime.ripard@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/clk-provider.h>
+#include <linux/clocksource.h>
+#include <linux/init.h>
+#include <linux/of_platform.h>
+
+#include <asm/mach/arch.h>
+
+#include "common.h"
+#include "restart.h"
+
+static void __init sun6i_dt_init(void)
+{
+	sunxi_setup_restart();
+
+	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+}
+
+extern void __init sun6i_reset_init(void);
+static void __init sun6i_timer_init(void)
+{
+	of_clk_init(NULL);
+	sun6i_reset_init();
+	clocksource_of_init();
+}
+
+static const char * const sun6i_board_dt_compat[] = {
+	"allwinner,sun6i-a31",
+	NULL,
+};
+
+DT_MACHINE_START(SUN6I_DT, "Allwinner sun6i (A31) Family")
+	.init_machine	= sun6i_dt_init,
+	.init_time	= sun6i_timer_init,
+	.dt_compat	= sun6i_board_dt_compat,
+	.restart	= sun6i_restart,
+	.smp		= smp_ops(sun6i_smp_ops),
+MACHINE_END
diff --git a/arch/arm/mach-sunxi/sun7i.c b/arch/arm/mach-sunxi/sun7i.c
new file mode 100644
index 000000000000..2e6a8ee1966b
--- /dev/null
+++ b/arch/arm/mach-sunxi/sun7i.c
@@ -0,0 +1,36 @@
+/*
+ * Device Tree support for Allwinner A20 SoCs
+ *
+ * Copyright (C) 2013-2014 Maxime Ripard
+ *
+ * Maxime Ripard <maxime.ripard@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/init.h>
+#include <linux/of_platform.h>
+
+#include <asm/mach/arch.h>
+
+#include "restart.h"
+
+static void __init sun7i_dt_init(void)
+{
+	sunxi_setup_restart();
+
+	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+}
+
+static const char * const sun7i_board_dt_compat[] = {
+	"allwinner,sun7i-a20",
+	NULL,
+};
+
+DT_MACHINE_START(SUN7I_DT, "Allwinner sun7i (A20) Family")
+	.init_machine	= sun7i_dt_init,
+	.dt_compat	= sun7i_board_dt_compat,
+	.restart	= sun4i_restart,
+MACHINE_END
diff --git a/arch/arm/mach-sunxi/sunxi.c b/arch/arm/mach-sunxi/sunxi.c
deleted file mode 100644
index 460b5a4962ef..000000000000
--- a/arch/arm/mach-sunxi/sunxi.c
+++ /dev/null
@@ -1,164 +0,0 @@
-/*
- * Device Tree support for Allwinner A1X SoCs
- *
- * Copyright (C) 2012 Maxime Ripard
- *
- * Maxime Ripard <maxime.ripard@free-electrons.com>
- *
- * This file is licensed under the terms of the GNU General Public
- * License version 2.  This program is licensed "as is" without any
- * warranty of any kind, whether express or implied.
- */
-
-#include <linux/clk-provider.h>
-#include <linux/clocksource.h>
-#include <linux/delay.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/of_address.h>
-#include <linux/of_irq.h>
-#include <linux/of_platform.h>
-#include <linux/io.h>
-#include <linux/reboot.h>
-
-#include <asm/mach/arch.h>
-#include <asm/mach/map.h>
-#include <asm/system_misc.h>
-
-#include "common.h"
-
-#define SUN4I_WATCHDOG_CTRL_REG		0x00
-#define SUN4I_WATCHDOG_CTRL_RESTART		BIT(0)
-#define SUN4I_WATCHDOG_MODE_REG		0x04
-#define SUN4I_WATCHDOG_MODE_ENABLE		BIT(0)
-#define SUN4I_WATCHDOG_MODE_RESET_ENABLE	BIT(1)
-
-#define SUN6I_WATCHDOG1_IRQ_REG		0x00
-#define SUN6I_WATCHDOG1_CTRL_REG	0x10
-#define SUN6I_WATCHDOG1_CTRL_RESTART		BIT(0)
-#define SUN6I_WATCHDOG1_CONFIG_REG	0x14
-#define SUN6I_WATCHDOG1_CONFIG_RESTART		BIT(0)
-#define SUN6I_WATCHDOG1_CONFIG_IRQ		BIT(1)
-#define SUN6I_WATCHDOG1_MODE_REG	0x18
-#define SUN6I_WATCHDOG1_MODE_ENABLE		BIT(0)
-
-static void __iomem *wdt_base;
-
-static void sun4i_restart(enum reboot_mode mode, const char *cmd)
-{
-	if (!wdt_base)
-		return;
-
-	/* Enable timer and set reset bit in the watchdog */
-	writel(SUN4I_WATCHDOG_MODE_ENABLE | SUN4I_WATCHDOG_MODE_RESET_ENABLE,
-	       wdt_base + SUN4I_WATCHDOG_MODE_REG);
-
-	/*
-	 * Restart the watchdog. The default (and lowest) interval
-	 * value for the watchdog is 0.5s.
-	 */
-	writel(SUN4I_WATCHDOG_CTRL_RESTART, wdt_base + SUN4I_WATCHDOG_CTRL_REG);
-
-	while (1) {
-		mdelay(5);
-		writel(SUN4I_WATCHDOG_MODE_ENABLE | SUN4I_WATCHDOG_MODE_RESET_ENABLE,
-		       wdt_base + SUN4I_WATCHDOG_MODE_REG);
-	}
-}
-
-static void sun6i_restart(enum reboot_mode mode, const char *cmd)
-{
-	if (!wdt_base)
-		return;
-
-	/* Disable interrupts */
-	writel(0, wdt_base + SUN6I_WATCHDOG1_IRQ_REG);
-
-	/* We want to disable the IRQ and just reset the whole system */
-	writel(SUN6I_WATCHDOG1_CONFIG_RESTART,
-		wdt_base + SUN6I_WATCHDOG1_CONFIG_REG);
-
-	/* Enable timer. The default and lowest interval value is 0.5s */
-	writel(SUN6I_WATCHDOG1_MODE_ENABLE,
-		wdt_base + SUN6I_WATCHDOG1_MODE_REG);
-
-	/* Restart the watchdog. */
-	writel(SUN6I_WATCHDOG1_CTRL_RESTART,
-		wdt_base + SUN6I_WATCHDOG1_CTRL_REG);
-
-	while (1) {
-		mdelay(5);
-		writel(SUN6I_WATCHDOG1_MODE_ENABLE,
-			wdt_base + SUN6I_WATCHDOG1_MODE_REG);
-	}
-}
-
-static struct of_device_id sunxi_restart_ids[] = {
-	{ .compatible = "allwinner,sun4i-a10-wdt" },
-	{ .compatible = "allwinner,sun6i-a31-wdt" },
-	{ /*sentinel*/ }
-};
-
-static void sunxi_setup_restart(void)
-{
-	struct device_node *np;
-
-	np = of_find_matching_node(NULL, sunxi_restart_ids);
-	if (WARN(!np, "unable to setup watchdog restart"))
-		return;
-
-	wdt_base = of_iomap(np, 0);
-	WARN(!wdt_base, "failed to map watchdog base address");
-}
-
-static void __init sunxi_dt_init(void)
-{
-	sunxi_setup_restart();
-
-	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
-}
-
-static const char * const sunxi_board_dt_compat[] = {
-	"allwinner,sun4i-a10",
-	"allwinner,sun5i-a10s",
-	"allwinner,sun5i-a13",
-	NULL,
-};
-
-DT_MACHINE_START(SUNXI_DT, "Allwinner A1X (Device Tree)")
-	.init_machine	= sunxi_dt_init,
-	.dt_compat	= sunxi_board_dt_compat,
-	.restart	= sun4i_restart,
-MACHINE_END
-
-static const char * const sun6i_board_dt_compat[] = {
-	"allwinner,sun6i-a31",
-	NULL,
-};
-
-extern void __init sun6i_reset_init(void);
-static void __init sun6i_timer_init(void)
-{
-	of_clk_init(NULL);
-	sun6i_reset_init();
-	clocksource_of_init();
-}
-
-DT_MACHINE_START(SUN6I_DT, "Allwinner sun6i (A31) Family")
-	.init_machine	= sunxi_dt_init,
-	.init_time	= sun6i_timer_init,
-	.dt_compat	= sun6i_board_dt_compat,
-	.restart	= sun6i_restart,
-	.smp		= smp_ops(sun6i_smp_ops),
-MACHINE_END
-
-static const char * const sun7i_board_dt_compat[] = {
-	"allwinner,sun7i-a20",
-	NULL,
-};
-
-DT_MACHINE_START(SUN7I_DT, "Allwinner sun7i (A20) Family")
-	.init_machine	= sunxi_dt_init,
-	.dt_compat	= sun7i_board_dt_compat,
-	.restart	= sun4i_restart,
-MACHINE_END
-- 
1.9.1

