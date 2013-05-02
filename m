Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761608Ab3EBS0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 14:26:38 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:35447 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932776Ab3EBS0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 14:26:04 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] ARM: dove: add DT parsing for legacy timer
Date: Thu,  2 May 2013 20:25:39 +0200
Message-Id: <1367519140-19716-3-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1367519140-19716-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1367519140-19716-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To allow to move to orion irqchip driver, existing legacy devices
have to map their irqs. This patch adds a node for orion timer and
some init code to map the corresponding irqs. While the device tree
node can stay, the init code will vanish as soon as there is true
device tree support for orion timer.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Jean-Francois Moine <moinejf@free.fr>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/dove.dtsi   |    7 ++++++
 arch/arm/mach-dove/board-dt.c |   42 +++++++++++++++++++++++++++++++++++-----
 2 files changed, 43 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/dove.dtsi b/arch/arm/boot/dts/dove.dtsi
index ea7c5da..433cca1 100644
--- a/arch/arm/boot/dts/dove.dtsi
+++ b/arch/arm/boot/dts/dove.dtsi
@@ -30,6 +30,13 @@
 			marvell,tauros2-cache-features = <0>;
 		};
 
+		timer: timer {
+			compatible = "marvell,orion-timer";
+			reg = <0x20300 0x20>;
+			interrupts = <0>;
+			clocks = <&core_clk 0>;
+		};
+
 		intc: interrupt-controller {
 			compatible = "marvell,orion-intc";
 			interrupt-controller;
diff --git a/arch/arm/mach-dove/board-dt.c b/arch/arm/mach-dove/board-dt.c
index 9df6dd7..cea65b7 100644
--- a/arch/arm/mach-dove/board-dt.c
+++ b/arch/arm/mach-dove/board-dt.c
@@ -12,6 +12,7 @@
 #include <linux/clk-provider.h>
 #include <linux/clk/mvebu.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/platform_data/usb-ehci-orion.h>
@@ -20,6 +21,7 @@
 #include <mach/pm.h>
 #include <plat/common.h>
 #include <plat/irq.h>
+#include <plat/time.h>
 #include "common.h"
 
 /*
@@ -48,10 +50,42 @@ static void __init dove_legacy_clk_init(void)
 			 of_clk_get_from_provider(&clkspec));
 }
 
-static void __init dove_of_clk_init(void)
+#define BRIDGE_INT_TIMER1_CLR	(~0x0004)
+
+static void __init dove_legacy_timer_init(void)
 {
+	struct device_node *np = of_find_compatible_node(NULL, NULL,
+					 "marvell,orion-timer");
+	struct clk *clk;
+	void __iomem *base;
+	unsigned int tclk, irq;
+
+	/* Setup root of clk tree */
 	mvebu_clocks_init();
 	dove_legacy_clk_init();
+
+	if (!np)
+		panic("missing timer node\n");
+
+	base = of_iomap(np, 0);
+	if (!base)
+		panic("%s: missing reg base for timer\n", np->full_name);
+
+	irq = irq_of_parse_and_map(np, 0);
+	if (!irq)
+		panic("%s: missing irq for timer\n", np->full_name);
+
+	clk = of_clk_get(np, 0);
+	if (IS_ERR(clk))
+		panic("%s: missing clock for timer\n", np->full_name);
+
+	clk_prepare_enable(clk);
+	tclk = clk_get_rate(clk);
+	clk_put(clk);
+
+	orion_time_set_base(base);
+	/* legacy timer init gets bridge reg base */
+	orion_time_init(base - 0x300, BRIDGE_INT_TIMER1_CLR, irq, tclk);
 }
 
 static struct mv643xx_eth_platform_data dove_dt_ge00_data = {
@@ -95,9 +129,6 @@ static void __init dove_dt_init(void)
 #endif
 	dove_setup_cpu_mbus();
 
-	/* Setup root of clk tree */
-	dove_of_clk_init();
-
 	/* Internal devices not ported to DT yet */
 	dove_legacy_ge00_init();
 	dove_pcie_init(1, 1);
@@ -112,9 +143,8 @@ static const char * const dove_dt_board_compat[] = {
 
 DT_MACHINE_START(DOVE_DT, "Marvell Dove (Flattened Device Tree)")
 	.map_io		= dove_map_io,
-	.init_early	= dove_init_early,
 	.init_irq	= orion_dt_init_irq,
-	.init_time	= dove_timer_init,
+	.init_time	= dove_legacy_timer_init,
 	.init_machine	= dove_dt_init,
 	.restart	= dove_restart,
 	.dt_compat	= dove_dt_board_compat,
-- 
1.7.2.5

