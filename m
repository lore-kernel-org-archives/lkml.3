Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933873Ab3CZJOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 05:14:18 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:51025 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932863Ab3CZJNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 05:13:37 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: kevin@allwinnertech.com, sunny@allwinnertech.com, shuge@allwinnertech.com,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/10] ARM: sunxi: Rework the restart code
Date: Tue, 26 Mar 2013 10:13:16 +0100
Message-Id: <1364289198-11589-10-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364289198-11589-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1364289198-11589-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Allwinner sun6i (A31) has a slightly different watchdog, that
doesn't allow to use the already existing restart code.

Rework a bit the restart code to allow to plug in more easily different
restart handlers depending on the device tree.

In the past, we were also meaning sunxi as a generic name covering all
Allwinner SoCs. This won't be true anymore with the A31 (sun6i) that
differs pretty much from sun4i and sun5i, and we will end up having
sunxi, for sun4i and sun5i, and sun6i, which is neither consistent nor
convenient. So, while we're at it, also change sunxi to sun4i.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 .../watchdog/{sunxi-wdt.txt => sun4i-wdt.txt}      |    6 +-
 arch/arm/mach-sunxi/sunxi.c                        |   58 ++++++++++++--------
 2 files changed, 38 insertions(+), 26 deletions(-)
 rename Documentation/devicetree/bindings/watchdog/{sunxi-wdt.txt => sun4i-wdt.txt} (57%)

diff --git a/Documentation/devicetree/bindings/watchdog/sunxi-wdt.txt b/Documentation/devicetree/bindings/watchdog/sun4i-wdt.txt
similarity index 57%
rename from Documentation/devicetree/bindings/watchdog/sunxi-wdt.txt
rename to Documentation/devicetree/bindings/watchdog/sun4i-wdt.txt
index 0b27177..ecd650a 100644
--- a/Documentation/devicetree/bindings/watchdog/sunxi-wdt.txt
+++ b/Documentation/devicetree/bindings/watchdog/sun4i-wdt.txt
@@ -1,13 +1,13 @@
-Allwinner sunXi Watchdog timer
+Allwinner sun4i Watchdog timer
 
 Required properties:
 
-- compatible : should be "allwinner,sunxi-wdt"
+- compatible : should be "allwinner,sun4i-wdt"
 - reg : Specifies base physical address and size of the registers.
 
 Example:
 
 wdt: watchdog@01c20c90 {
-	compatible = "allwinner,sunxi-wdt";
+	compatible = "allwinner,sun4i-wdt";
 	reg = <0x01c20c90 0x10>;
 };
diff --git a/arch/arm/mach-sunxi/sunxi.c b/arch/arm/mach-sunxi/sunxi.c
index c99ab1b..706ce35 100644
--- a/arch/arm/mach-sunxi/sunxi.c
+++ b/arch/arm/mach-sunxi/sunxi.c
@@ -24,50 +24,63 @@
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
+#include <asm/system_misc.h>
 
 #include "sunxi.h"
 
-#define WATCHDOG_CTRL_REG	0x00
-#define WATCHDOG_CTRL_RESTART		(1 << 0)
-#define WATCHDOG_MODE_REG	0x04
-#define WATCHDOG_MODE_ENABLE		(1 << 0)
-#define WATCHDOG_MODE_RESET_ENABLE	(1 << 1)
+#define SUN4I_WATCHDOG_CTRL_REG		0x00
+#define SUN4I_WATCHDOG_CTRL_RESTART		(1 << 0)
+#define SUN4I_WATCHDOG_MODE_REG		0x04
+#define SUN4I_WATCHDOG_MODE_ENABLE		(1 << 0)
+#define SUN4I_WATCHDOG_MODE_RESET_ENABLE	(1 << 1)
 
 static void __iomem *wdt_base;
 
-static void sunxi_setup_restart(void)
-{
-	struct device_node *np = of_find_compatible_node(NULL, NULL,
-						"allwinner,sunxi-wdt");
-	if (WARN(!np, "unable to setup watchdog restart"))
-		return;
-
-	wdt_base = of_iomap(np, 0);
-	WARN(!wdt_base, "failed to map watchdog base address");
-}
-
-static void sunxi_restart(char mode, const char *cmd)
+static void sun4i_restart(char mode, const char *cmd)
 {
 	if (!wdt_base)
 		return;
 
 	/* Enable timer and set reset bit in the watchdog */
-	writel(WATCHDOG_MODE_ENABLE | WATCHDOG_MODE_RESET_ENABLE,
-		wdt_base + WATCHDOG_MODE_REG);
+	writel(SUN4I_WATCHDOG_MODE_ENABLE | SUN4I_WATCHDOG_MODE_RESET_ENABLE,
+	       wdt_base + SUN4I_WATCHDOG_MODE_REG);
 
 	/*
 	 * Restart the watchdog. The default (and lowest) interval
 	 * value for the watchdog is 0.5s.
 	 */
-	writel(WATCHDOG_CTRL_RESTART, wdt_base + WATCHDOG_CTRL_REG);
+	writel(SUN4I_WATCHDOG_CTRL_RESTART, wdt_base + SUN4I_WATCHDOG_CTRL_REG);
 
 	while (1) {
 		mdelay(5);
-		writel(WATCHDOG_MODE_ENABLE | WATCHDOG_MODE_RESET_ENABLE,
-			wdt_base + WATCHDOG_MODE_REG);
+		writel(SUN4I_WATCHDOG_MODE_ENABLE | SUN4I_WATCHDOG_MODE_RESET_ENABLE,
+		       wdt_base + SUN4I_WATCHDOG_MODE_REG);
 	}
 }
 
+static struct of_device_id sunxi_restart_ids[] = {
+	{ .compatible = "allwinner,sun4i-wdt", .data = sun4i_restart },
+	{ /*sentinel*/ }
+};
+
+static void sunxi_setup_restart(void)
+{
+	const struct of_device_id *of_id;
+	struct device_node *np;
+
+	np = of_find_matching_node(NULL, sunxi_restart_ids);
+	if (WARN(!np, "unable to setup watchdog restart"))
+		return;
+
+	wdt_base = of_iomap(np, 0);
+	WARN(!wdt_base, "failed to map watchdog base address");
+
+	of_id = of_match_node(sunxi_restart_ids, np);
+	WARN(!of_id, "restart function not available");
+
+	arm_pm_restart = of_id->data;
+}
+
 static struct map_desc sunxi_io_desc[] __initdata = {
 	{
 		.virtual	= (unsigned long) SUNXI_REGS_VIRT_BASE,
@@ -105,7 +118,6 @@ DT_MACHINE_START(SUNXI_DT, "Allwinner A1X (Device Tree)")
 	.init_machine	= sunxi_dt_init,
 	.map_io		= sunxi_map_io,
 	.init_irq	= irqchip_init,
-	.restart	= sunxi_restart,
 	.init_time	= sunxi_timer_init,
 	.dt_compat	= sunxi_board_dt_compat,
 MACHINE_END
-- 
1.7.10.4

