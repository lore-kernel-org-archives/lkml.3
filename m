Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260AbaJPH14 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 03:27:56 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:48730 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaJPH1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 03:27:55 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] ARM: integrator: move AP timer to clocksource
Date: Thu, 16 Oct 2014 09:27:43 +0200
Message-Id: <1413444463-15823-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves the timer/clocksource implementation for the
Integrator/AP down to drivers/clocksource and augments the
driver a little to use CLOCKSOURCE_OF_DECLARE(). Remove
the static mapping of the timer blocks while we're at it.

Tested on the Integrator/AP.

Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Daniel, Thomas: can you ACK this to be taken through ARM SoC?
---
 arch/arm/mach-integrator/integrator_ap.c  | 190 ---------------------------
 drivers/clocksource/Makefile              |   1 +
 drivers/clocksource/timer-integrator-ap.c | 210 ++++++++++++++++++++++++++++++
 3 files changed, 211 insertions(+), 190 deletions(-)
 create mode 100644 drivers/clocksource/timer-integrator-ap.c

diff --git a/arch/arm/mach-integrator/integrator_ap.c b/arch/arm/mach-integrator/integrator_ap.c
index 8ca290b479b1..8a879b654fde 100644
--- a/arch/arm/mach-integrator/integrator_ap.c
+++ b/arch/arm/mach-integrator/integrator_ap.c
@@ -27,13 +27,9 @@
 #include <linux/syscore_ops.h>
 #include <linux/amba/bus.h>
 #include <linux/amba/kmi.h>
-#include <linux/clocksource.h>
-#include <linux/clockchips.h>
-#include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/irqchip.h>
 #include <linux/mtd/physmap.h>
-#include <linux/clk.h>
 #include <linux/platform_data/clk-integrator.h>
 #include <linux/of_irq.h>
 #include <linux/of_address.h>
@@ -41,8 +37,6 @@
 #include <linux/stat.h>
 #include <linux/sys_soc.h>
 #include <linux/termios.h>
-#include <linux/sched_clock.h>
-#include <linux/clk-provider.h>
 
 #include <asm/hardware/arm_timer.h>
 #include <asm/setup.h>
@@ -89,11 +83,6 @@ static void __iomem *ebi_base;
 
 static struct map_desc ap_io_desc[] __initdata __maybe_unused = {
 	{
-		.virtual	= IO_ADDRESS(INTEGRATOR_CT_BASE),
-		.pfn		= __phys_to_pfn(INTEGRATOR_CT_BASE),
-		.length		= SZ_4K,
-		.type		= MT_DEVICE
-	}, {
 		.virtual	= IO_ADDRESS(INTEGRATOR_IC_BASE),
 		.pfn		= __phys_to_pfn(INTEGRATOR_IC_BASE),
 		.length		= SZ_4K,
@@ -257,188 +246,10 @@ struct amba_pl010_data ap_uart_data = {
 	.set_mctrl = integrator_uart_set_mctrl,
 };
 
-/*
- * Where is the timer (VA)?
- */
-#define TIMER0_VA_BASE __io_address(INTEGRATOR_TIMER0_BASE)
-#define TIMER1_VA_BASE __io_address(INTEGRATOR_TIMER1_BASE)
-#define TIMER2_VA_BASE __io_address(INTEGRATOR_TIMER2_BASE)
-
-static unsigned long timer_reload;
-
-static u64 notrace integrator_read_sched_clock(void)
-{
-	return -readl((void __iomem *) TIMER2_VA_BASE + TIMER_VALUE);
-}
-
-static void integrator_clocksource_init(unsigned long inrate,
-					void __iomem *base)
-{
-	u32 ctrl = TIMER_CTRL_ENABLE | TIMER_CTRL_PERIODIC;
-	unsigned long rate = inrate;
-
-	if (rate >= 1500000) {
-		rate /= 16;
-		ctrl |= TIMER_CTRL_DIV16;
-	}
-
-	writel(0xffff, base + TIMER_LOAD);
-	writel(ctrl, base + TIMER_CTRL);
-
-	clocksource_mmio_init(base + TIMER_VALUE, "timer2",
-			rate, 200, 16, clocksource_mmio_readl_down);
-	sched_clock_register(integrator_read_sched_clock, 16, rate);
-}
-
-static void __iomem * clkevt_base;
-
-/*
- * IRQ handler for the timer
- */
-static irqreturn_t integrator_timer_interrupt(int irq, void *dev_id)
-{
-	struct clock_event_device *evt = dev_id;
-
-	/* clear the interrupt */
-	writel(1, clkevt_base + TIMER_INTCLR);
-
-	evt->event_handler(evt);
-
-	return IRQ_HANDLED;
-}
-
-static void clkevt_set_mode(enum clock_event_mode mode, struct clock_event_device *evt)
-{
-	u32 ctrl = readl(clkevt_base + TIMER_CTRL) & ~TIMER_CTRL_ENABLE;
-
-	/* Disable timer */
-	writel(ctrl, clkevt_base + TIMER_CTRL);
-
-	switch (mode) {
-	case CLOCK_EVT_MODE_PERIODIC:
-		/* Enable the timer and start the periodic tick */
-		writel(timer_reload, clkevt_base + TIMER_LOAD);
-		ctrl |= TIMER_CTRL_PERIODIC | TIMER_CTRL_ENABLE;
-		writel(ctrl, clkevt_base + TIMER_CTRL);
-		break;
-	case CLOCK_EVT_MODE_ONESHOT:
-		/* Leave the timer disabled, .set_next_event will enable it */
-		ctrl &= ~TIMER_CTRL_PERIODIC;
-		writel(ctrl, clkevt_base + TIMER_CTRL);
-		break;
-	case CLOCK_EVT_MODE_UNUSED:
-	case CLOCK_EVT_MODE_SHUTDOWN:
-	case CLOCK_EVT_MODE_RESUME:
-	default:
-		/* Just leave in disabled state */
-		break;
-	}
-
-}
-
-static int clkevt_set_next_event(unsigned long next, struct clock_event_device *evt)
-{
-	unsigned long ctrl = readl(clkevt_base + TIMER_CTRL);
-
-	writel(ctrl & ~TIMER_CTRL_ENABLE, clkevt_base + TIMER_CTRL);
-	writel(next, clkevt_base + TIMER_LOAD);
-	writel(ctrl | TIMER_CTRL_ENABLE, clkevt_base + TIMER_CTRL);
-
-	return 0;
-}
-
-static struct clock_event_device integrator_clockevent = {
-	.name		= "timer1",
-	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
-	.set_mode	= clkevt_set_mode,
-	.set_next_event	= clkevt_set_next_event,
-	.rating		= 300,
-};
-
-static struct irqaction integrator_timer_irq = {
-	.name		= "timer",
-	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
-	.handler	= integrator_timer_interrupt,
-	.dev_id		= &integrator_clockevent,
-};
-
-static void integrator_clockevent_init(unsigned long inrate,
-				void __iomem *base, int irq)
-{
-	unsigned long rate = inrate;
-	unsigned int ctrl = 0;
-
-	clkevt_base = base;
-	/* Calculate and program a divisor */
-	if (rate > 0x100000 * HZ) {
-		rate /= 256;
-		ctrl |= TIMER_CTRL_DIV256;
-	} else if (rate > 0x10000 * HZ) {
-		rate /= 16;
-		ctrl |= TIMER_CTRL_DIV16;
-	}
-	timer_reload = rate / HZ;
-	writel(ctrl, clkevt_base + TIMER_CTRL);
-
-	setup_irq(irq, &integrator_timer_irq);
-	clockevents_config_and_register(&integrator_clockevent,
-					rate,
-					1,
-					0xffffU);
-}
-
 void __init ap_init_early(void)
 {
 }
 
-static void __init ap_of_timer_init(void)
-{
-	struct device_node *node;
-	const char *path;
-	void __iomem *base;
-	int err;
-	int irq;
-	struct clk *clk;
-	unsigned long rate;
-
-	of_clk_init(NULL);
-
-	err = of_property_read_string(of_aliases,
-				"arm,timer-primary", &path);
-	if (WARN_ON(err))
-		return;
-	node = of_find_node_by_path(path);
-	base = of_iomap(node, 0);
-	if (WARN_ON(!base))
-		return;
-
-	clk = of_clk_get(node, 0);
-	BUG_ON(IS_ERR(clk));
-	clk_prepare_enable(clk);
-	rate = clk_get_rate(clk);
-
-	writel(0, base + TIMER_CTRL);
-	integrator_clocksource_init(rate, base);
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
-
-	clk = of_clk_get(node, 0);
-	BUG_ON(IS_ERR(clk));
-	clk_prepare_enable(clk);
-	rate = clk_get_rate(clk);
-
-	writel(0, base + TIMER_CTRL);
-	integrator_clockevent_init(rate, base, irq);
-}
-
 static void __init ap_init_irq_of(void)
 {
 	cm_init();
@@ -553,7 +364,6 @@ DT_MACHINE_START(INTEGRATOR_AP_DT, "ARM Integrator/AP (Device Tree)")
 	.map_io		= ap_map_io,
 	.init_early	= ap_init_early,
 	.init_irq	= ap_init_irq_of,
-	.init_time	= ap_of_timer_init,
 	.init_machine	= ap_init_of,
 	.restart	= integrator_restart,
 	.dt_compat      = ap_dt_board_compat,
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 756f6f10efa0..fae0435cc23d 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -45,4 +45,5 @@ obj-$(CONFIG_ARM_GLOBAL_TIMER)		+= arm_global_timer.o
 obj-$(CONFIG_CLKSRC_METAG_GENERIC)	+= metag_generic.o
 obj-$(CONFIG_ARCH_HAS_TICK_BROADCAST)	+= dummy_timer.o
 obj-$(CONFIG_ARCH_KEYSTONE)		+= timer-keystone.o
+obj-$(CONFIG_ARCH_INTEGRATOR_AP)	+= timer-integrator-ap.o
 obj-$(CONFIG_CLKSRC_VERSATILE)		+= versatile.o
diff --git a/drivers/clocksource/timer-integrator-ap.c b/drivers/clocksource/timer-integrator-ap.c
new file mode 100644
index 000000000000..b9efd30513d5
--- /dev/null
+++ b/drivers/clocksource/timer-integrator-ap.c
@@ -0,0 +1,210 @@
+/*
+ * Integrator/AP timer driver
+ * Copyright (C) 2000-2003 Deep Blue Solutions Ltd
+ * Copyright (c) 2014, Linaro Limited
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
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/clk.h>
+#include <linux/clocksource.h>
+#include <linux/of_irq.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
+#include <linux/clockchips.h>
+#include <linux/interrupt.h>
+#include <linux/sched_clock.h>
+#include <asm/hardware/arm_timer.h>
+
+static void __iomem * sched_clk_base;
+
+static u64 notrace integrator_read_sched_clock(void)
+{
+	return -readl(sched_clk_base + TIMER_VALUE);
+}
+
+static void integrator_clocksource_init(unsigned long inrate,
+					void __iomem *base)
+{
+	u32 ctrl = TIMER_CTRL_ENABLE | TIMER_CTRL_PERIODIC;
+	unsigned long rate = inrate;
+
+	if (rate >= 1500000) {
+		rate /= 16;
+		ctrl |= TIMER_CTRL_DIV16;
+	}
+
+	writel(0xffff, base + TIMER_LOAD);
+	writel(ctrl, base + TIMER_CTRL);
+
+	clocksource_mmio_init(base + TIMER_VALUE, "timer2",
+			rate, 200, 16, clocksource_mmio_readl_down);
+
+	sched_clk_base = base;
+	sched_clock_register(integrator_read_sched_clock, 16, rate);
+}
+
+static unsigned long timer_reload;
+static void __iomem * clkevt_base;
+
+/*
+ * IRQ handler for the timer
+ */
+static irqreturn_t integrator_timer_interrupt(int irq, void *dev_id)
+{
+	struct clock_event_device *evt = dev_id;
+
+	/* clear the interrupt */
+	writel(1, clkevt_base + TIMER_INTCLR);
+
+	evt->event_handler(evt);
+
+	return IRQ_HANDLED;
+}
+
+static void clkevt_set_mode(enum clock_event_mode mode, struct clock_event_device *evt)
+{
+	u32 ctrl = readl(clkevt_base + TIMER_CTRL) & ~TIMER_CTRL_ENABLE;
+
+	/* Disable timer */
+	writel(ctrl, clkevt_base + TIMER_CTRL);
+
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+		/* Enable the timer and start the periodic tick */
+		writel(timer_reload, clkevt_base + TIMER_LOAD);
+		ctrl |= TIMER_CTRL_PERIODIC | TIMER_CTRL_ENABLE;
+		writel(ctrl, clkevt_base + TIMER_CTRL);
+		break;
+	case CLOCK_EVT_MODE_ONESHOT:
+		/* Leave the timer disabled, .set_next_event will enable it */
+		ctrl &= ~TIMER_CTRL_PERIODIC;
+		writel(ctrl, clkevt_base + TIMER_CTRL);
+		break;
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+	case CLOCK_EVT_MODE_RESUME:
+	default:
+		/* Just leave in disabled state */
+		break;
+	}
+
+}
+
+static int clkevt_set_next_event(unsigned long next, struct clock_event_device *evt)
+{
+	unsigned long ctrl = readl(clkevt_base + TIMER_CTRL);
+
+	writel(ctrl & ~TIMER_CTRL_ENABLE, clkevt_base + TIMER_CTRL);
+	writel(next, clkevt_base + TIMER_LOAD);
+	writel(ctrl | TIMER_CTRL_ENABLE, clkevt_base + TIMER_CTRL);
+
+	return 0;
+}
+
+static struct clock_event_device integrator_clockevent = {
+	.name		= "timer1",
+	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
+	.set_mode	= clkevt_set_mode,
+	.set_next_event	= clkevt_set_next_event,
+	.rating		= 300,
+};
+
+static struct irqaction integrator_timer_irq = {
+	.name		= "timer",
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
+	.handler	= integrator_timer_interrupt,
+	.dev_id		= &integrator_clockevent,
+};
+
+static void integrator_clockevent_init(unsigned long inrate,
+				void __iomem *base, int irq)
+{
+	unsigned long rate = inrate;
+	unsigned int ctrl = 0;
+
+	clkevt_base = base;
+	/* Calculate and program a divisor */
+	if (rate > 0x100000 * HZ) {
+		rate /= 256;
+		ctrl |= TIMER_CTRL_DIV256;
+	} else if (rate > 0x10000 * HZ) {
+		rate /= 16;
+		ctrl |= TIMER_CTRL_DIV16;
+	}
+	timer_reload = rate / HZ;
+	writel(ctrl, clkevt_base + TIMER_CTRL);
+
+	setup_irq(irq, &integrator_timer_irq);
+	clockevents_config_and_register(&integrator_clockevent,
+					rate,
+					1,
+					0xffffU);
+}
+
+static void __init integrator_ap_timer_init_of(struct device_node *node)
+{
+	const char *path;
+	void __iomem *base;
+	int err;
+	int irq;
+	struct clk *clk;
+	unsigned long rate;
+	struct device_node *pri_node;
+	struct device_node *sec_node;
+
+	base = of_io_request_and_map(node, 0, "integrator-timer");
+	if (!base)
+		return;
+
+	clk = of_clk_get(node, 0);
+	if (IS_ERR(clk)) {
+		pr_err("No clock for %s\n", node->name);
+		return;
+	}
+	clk_prepare_enable(clk);
+	rate = clk_get_rate(clk);
+	writel(0, base + TIMER_CTRL);
+
+	err = of_property_read_string(of_aliases,
+				"arm,timer-primary", &path);
+	if (WARN_ON(err))
+		return;
+	pri_node = of_find_node_by_path(path);
+	err = of_property_read_string(of_aliases,
+				"arm,timer-secondary", &path);
+	if (WARN_ON(err))
+		return;
+	sec_node = of_find_node_by_path(path);
+
+	if (node == pri_node) {
+		/* The primary timer lacks IRQ, use as clocksource */
+		integrator_clocksource_init(rate, base);
+		return;
+	}
+
+	if (node == sec_node) {
+		/* The secondary timer will drive the clock event */
+		irq = irq_of_parse_and_map(node, 0);
+		integrator_clockevent_init(rate, base, irq);
+		return;
+	}
+
+	pr_info("Timer @%p unused\n", base);
+	clk_disable_unprepare(clk);
+}
+
+CLOCKSOURCE_OF_DECLARE(integrator_ap_timer, "arm,integrator-timer",
+		       integrator_ap_timer_init_of);
-- 
1.9.3

