Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab3CTWzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 18:55:37 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:58875 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab3CTWyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 18:54:38 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: Arnd Bergmann <arnd@arndb.de>, linus.walleij@linaro.org,
        Russell King <linux@arm.linux.org.uk>, haojian.zhuang@linaro.org,
        pawel.moll@arm.com, john.stultz@linaro.org, tglx@linutronix.de,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 09/11] ARM: integrator-cp: convert use CLKSRC_OF for timer init
Date: Wed, 20 Mar 2013 17:54:09 -0500
Message-Id: <1363820051-24428-10-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363820051-24428-1-git-send-email-robherring2@gmail.com>
References: <1363820051-24428-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Move the integrator-cp timer init to timer-sp.c and use CLKSRC_OF. There is
no reason to use the aliases, so drop them from the init code.

The integrator-cp timers are mistakenly called sp804 timers in the dts, but
in fact they are not sp804 dual timers, but single timers with the same
programming model. Fix the dts to reflect this.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 arch/arm/boot/dts/integratorcp.dts       |    6 +++---
 arch/arm/common/timer-sp.c               |   29 +++++++++++++++++++++++++++
 arch/arm/mach-integrator/integrator_cp.c |   32 ------------------------------
 3 files changed, 32 insertions(+), 35 deletions(-)

diff --git a/arch/arm/boot/dts/integratorcp.dts b/arch/arm/boot/dts/integratorcp.dts
index 8b11939..ff1aea0 100644
--- a/arch/arm/boot/dts/integratorcp.dts
+++ b/arch/arm/boot/dts/integratorcp.dts
@@ -24,15 +24,15 @@
 	};
 
 	timer0: timer@13000000 {
-		compatible = "arm,sp804", "arm,primecell";
+		compatible = "arm,integrator-cp-timer";
 	};
 
 	timer1: timer@13000100 {
-		compatible = "arm,sp804", "arm,primecell";
+		compatible = "arm,integrator-cp-timer";
 	};
 
 	timer2: timer@13000200 {
-		compatible = "arm,sp804", "arm,primecell";
+		compatible = "arm,integrator-cp-timer";
 	};
 
 	pic: pic@14000000 {
diff --git a/arch/arm/common/timer-sp.c b/arch/arm/common/timer-sp.c
index 3e86835..203a2b3 100644
--- a/arch/arm/common/timer-sp.c
+++ b/arch/arm/common/timer-sp.c
@@ -31,6 +31,7 @@
 
 #include <asm/sched_clock.h>
 #include <asm/hardware/arm_timer.h>
+#include <asm/hardware/timer-sp.h>
 
 static long __init sp804_get_clock_rate(struct clk *clk)
 {
@@ -255,3 +256,31 @@ static void __init sp804_of_init(struct device_node *np)
 	initialized = true;
 }
 CLOCKSOURCE_OF_DECLARE(sp804, "arm,sp804", sp804_of_init);
+
+static void __init integrator_cp_of_init(struct device_node *np)
+{
+	static int init_count = 0;
+	void __iomem *base;
+	int irq;
+	const char *name = of_get_property(np, "compatible", NULL);
+
+	if (init_count == 2 || !of_device_is_available(np))
+		return;
+
+	base = of_iomap(np, 0);
+	if (WARN_ON(!base))
+		return;
+
+	if (!init_count)
+		sp804_clocksource_init(base, name);
+	else {
+		irq = irq_of_parse_and_map(np, 0);
+		if (irq <= 0)
+			return;
+
+		sp804_clockevents_init(base, irq, name);
+	}
+
+	init_count++;
+}
+CLOCKSOURCE_OF_DECLARE(intcp, "arm,integrator-cp-timer", integrator_cp_of_init);
\ No newline at end of file
diff --git a/arch/arm/mach-integrator/integrator_cp.c b/arch/arm/mach-integrator/integrator_cp.c
index c68e7d8..5729c3d 100644
--- a/arch/arm/mach-integrator/integrator_cp.c
+++ b/arch/arm/mach-integrator/integrator_cp.c
@@ -249,37 +249,6 @@ static void __init intcp_init_early(void)
 }
 
 #ifdef CONFIG_OF
-
-static void __init cp_of_timer_init(void)
-{
-	struct device_node *node;
-	const char *path;
-	void __iomem *base;
-	int err;
-	int irq;
-
-	err = of_property_read_string(of_aliases,
-				"arm,timer-primary", &path);
-	if (WARN_ON(err))
-		return;
-	node = of_find_node_by_path(path);
-	base = of_iomap(node, 0);
-	if (WARN_ON(!base))
-		return;
-	sp804_clocksource_init(base, node->name);
-
-	err = of_property_read_string(of_aliases,
-				"arm,timer-secondary", &path);
-	if (WARN_ON(err))
-		return;
-	node = of_find_node_by_path(path);
-	base = of_iomap(node, 0);
-	if (WARN_ON(!base))
-		return;
-	irq = irq_of_parse_and_map(node, 0);
-	sp804_clockevents_init(base, irq, node->name);
-}
-
 static const struct of_device_id fpga_irq_of_match[] __initconst = {
 	{ .compatible = "arm,versatile-fpga-irq", .data = fpga_irq_of_init, },
 	{ /* Sentinel */ }
@@ -383,7 +352,6 @@ DT_MACHINE_START(INTEGRATOR_CP_DT, "ARM Integrator/CP (Device Tree)")
 	.init_early	= intcp_init_early,
 	.init_irq	= intcp_init_irq_of,
 	.handle_irq	= fpga_handle_irq,
-	.init_time	= cp_of_timer_init,
 	.init_machine	= intcp_init_of,
 	.restart	= integrator_restart,
 	.dt_compat      = intcp_dt_board_compat,
-- 
1.7.10.4

