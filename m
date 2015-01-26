Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722AbbAZJ4D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 04:56:03 -0500
Received: from down.free-electrons.com ([37.187.137.238]:33613 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753320AbbAZJz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 04:55:57 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v2 4/5] clocksource: sun5i: Refactor the current code
Date: Mon, 26 Jan 2015 10:50:55 +0100
Message-Id: <1422265856-27631-5-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422265856-27631-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1422265856-27631-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor the code in order to remove the global variables and split the clock
source and clock events registration in order to ease the addition of the clock
notifiers needed to handle the parent clock rate changes.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/clocksource/timer-sun5i.c | 231 +++++++++++++++++++++++++++-----------
 1 file changed, 166 insertions(+), 65 deletions(-)

diff --git a/drivers/clocksource/timer-sun5i.c b/drivers/clocksource/timer-sun5i.c
index 295bb5e1010c..377e50450781 100644
--- a/drivers/clocksource/timer-sun5i.c
+++ b/drivers/clocksource/timer-sun5i.c
@@ -18,6 +18,7 @@
 #include <linux/irqreturn.h>
 #include <linux/reset.h>
 #include <linux/sched_clock.h>
+#include <linux/slab.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
@@ -37,8 +38,27 @@
 
 #define TIMER_SYNC_TICKS	3
 
-static void __iomem *timer_base;
-static u32 ticks_per_jiffy;
+struct sun5i_timer {
+	void __iomem		*base;
+	struct clk		*clk;
+	u32			ticks_per_jiffy;
+};
+
+struct sun5i_timer_clksrc {
+	struct sun5i_timer	timer;
+	struct clocksource	clksrc;
+};
+
+#define to_sun5i_timer_clksrc(x) \
+	container_of(x, struct sun5i_timer_clksrc, clksrc)
+
+struct sun5i_timer_clkevt {
+	struct sun5i_timer		timer;
+	struct clock_event_device	clkevt;
+};
+
+#define to_sun5i_timer_clkevt(x) \
+	container_of(x, struct sun5i_timer_clkevt, clkevt)
 
 /*
  * When we disable a timer, we need to wait at least for 2 cycles of
@@ -46,30 +66,30 @@ static u32 ticks_per_jiffy;
  * that is already setup and runs at the same frequency than the other
  * timers, and we never will be disabled.
  */
-static void sun5i_clkevt_sync(void)
+static void sun5i_clkevt_sync(struct sun5i_timer_clkevt *ce)
 {
-	u32 old = readl(timer_base + TIMER_CNTVAL_LO_REG(1));
+	u32 old = readl(ce->timer.base + TIMER_CNTVAL_LO_REG(1));
 
-	while ((old - readl(timer_base + TIMER_CNTVAL_LO_REG(1))) < TIMER_SYNC_TICKS)
+	while ((old - readl(ce->timer.base + TIMER_CNTVAL_LO_REG(1))) < TIMER_SYNC_TICKS)
 		cpu_relax();
 }
 
-static void sun5i_clkevt_time_stop(u8 timer)
+static void sun5i_clkevt_time_stop(struct sun5i_timer_clkevt *ce, u8 timer)
 {
-	u32 val = readl(timer_base + TIMER_CTL_REG(timer));
-	writel(val & ~TIMER_CTL_ENABLE, timer_base + TIMER_CTL_REG(timer));
+	u32 val = readl(ce->timer.base + TIMER_CTL_REG(timer));
+	writel(val & ~TIMER_CTL_ENABLE, ce->timer.base + TIMER_CTL_REG(timer));
 
-	sun5i_clkevt_sync();
+	sun5i_clkevt_sync(ce);
 }
 
-static void sun5i_clkevt_time_setup(u8 timer, u32 delay)
+static void sun5i_clkevt_time_setup(struct sun5i_timer_clkevt *ce, u8 timer, u32 delay)
 {
-	writel(delay, timer_base + TIMER_INTVAL_LO_REG(timer));
+	writel(delay, ce->timer.base + TIMER_INTVAL_LO_REG(timer));
 }
 
-static void sun5i_clkevt_time_start(u8 timer, bool periodic)
+static void sun5i_clkevt_time_start(struct sun5i_timer_clkevt *ce, u8 timer, bool periodic)
 {
-	u32 val = readl(timer_base + TIMER_CTL_REG(timer));
+	u32 val = readl(ce->timer.base + TIMER_CTL_REG(timer));
 
 	if (periodic)
 		val &= ~TIMER_CTL_ONESHOT;
@@ -77,66 +97,170 @@ static void sun5i_clkevt_time_start(u8 timer, bool periodic)
 		val |= TIMER_CTL_ONESHOT;
 
 	writel(val | TIMER_CTL_ENABLE | TIMER_CTL_RELOAD,
-	       timer_base + TIMER_CTL_REG(timer));
+	       ce->timer.base + TIMER_CTL_REG(timer));
 }
 
 static void sun5i_clkevt_mode(enum clock_event_mode mode,
-			      struct clock_event_device *clk)
+			      struct clock_event_device *clkevt)
 {
+	struct sun5i_timer_clkevt *ce = to_sun5i_timer_clkevt(clkevt);
+
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
-		sun5i_clkevt_time_stop(0);
-		sun5i_clkevt_time_setup(0, ticks_per_jiffy);
-		sun5i_clkevt_time_start(0, true);
+		sun5i_clkevt_time_stop(ce, 0);
+		sun5i_clkevt_time_setup(ce, 0, ce->timer.ticks_per_jiffy);
+		sun5i_clkevt_time_start(ce, 0, true);
 		break;
 	case CLOCK_EVT_MODE_ONESHOT:
-		sun5i_clkevt_time_stop(0);
-		sun5i_clkevt_time_start(0, false);
+		sun5i_clkevt_time_stop(ce, 0);
+		sun5i_clkevt_time_start(ce, 0, false);
 		break;
 	case CLOCK_EVT_MODE_UNUSED:
 	case CLOCK_EVT_MODE_SHUTDOWN:
 	default:
-		sun5i_clkevt_time_stop(0);
+		sun5i_clkevt_time_stop(ce, 0);
 		break;
 	}
 }
 
 static int sun5i_clkevt_next_event(unsigned long evt,
-				   struct clock_event_device *unused)
+				   struct clock_event_device *clkevt)
 {
-	sun5i_clkevt_time_stop(0);
-	sun5i_clkevt_time_setup(0, evt - TIMER_SYNC_TICKS);
-	sun5i_clkevt_time_start(0, false);
+	struct sun5i_timer_clkevt *ce = to_sun5i_timer_clkevt(clkevt);
+
+	sun5i_clkevt_time_stop(ce, 0);
+	sun5i_clkevt_time_setup(ce, 0, evt - TIMER_SYNC_TICKS);
+	sun5i_clkevt_time_start(ce, 0, false);
 
 	return 0;
 }
 
-static struct clock_event_device sun5i_clockevent = {
-	.name = "sun5i_tick",
-	.rating = 340,
-	.features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
-	.set_mode = sun5i_clkevt_mode,
-	.set_next_event = sun5i_clkevt_next_event,
-};
-
-
 static irqreturn_t sun5i_timer_interrupt(int irq, void *dev_id)
 {
-	struct clock_event_device *evt = (struct clock_event_device *)dev_id;
+	struct sun5i_timer_clkevt *ce = (struct sun5i_timer_clkevt *)dev_id;
 
-	writel(0x1, timer_base + TIMER_IRQ_ST_REG);
-	evt->event_handler(evt);
+	writel(0x1, ce->timer.base + TIMER_IRQ_ST_REG);
+	ce->clkevt.event_handler(&ce->clkevt);
 
 	return IRQ_HANDLED;
 }
 
+static cycle_t sun5i_clksrc_read(struct clocksource *clksrc)
+{
+	struct sun5i_timer_clksrc *cs = to_sun5i_timer_clksrc(clksrc);
+
+	return ~readl(cs->timer.base + TIMER_CNTVAL_LO_REG(1));
+}
+
+static int __init sun5i_setup_clocksource(struct device_node *node,
+					  void __iomem *base,
+					  struct clk *clk, int irq)
+{
+	struct sun5i_timer_clksrc *cs;
+	unsigned long rate;
+	int ret;
+
+	cs = kzalloc(sizeof(*cs), GFP_KERNEL);
+	if (!cs)
+		return -ENOMEM;
+
+	ret = clk_prepare_enable(clk);
+	if (ret) {
+		pr_err("Couldn't enable parent clock\n");
+		goto err_free;
+	}
+
+	rate = clk_get_rate(clk);
+
+	cs->timer.base = base;
+	cs->timer.clk = clk;
+
+	writel(~0, base + TIMER_INTVAL_LO_REG(1));
+	writel(TIMER_CTL_ENABLE | TIMER_CTL_RELOAD,
+	       base + TIMER_CTL_REG(1));
+
+	cs->clksrc.name = node->name;
+	cs->clksrc.rating = 340;
+	cs->clksrc.read = sun5i_clksrc_read;
+	cs->clksrc.mask = CLOCKSOURCE_MASK(32);
+	cs->clksrc.flags = CLOCK_SOURCE_IS_CONTINUOUS;
+
+	ret = clocksource_register_hz(&cs->clksrc, rate);
+	if (ret) {
+		pr_err("Couldn't register clock source.\n");
+		goto err_disable_clk;
+	}
+
+	return 0;
+
+err_disable_clk:
+	clk_disable_unprepare(clk);
+err_free:
+	kfree(cs);
+	return ret;
+}
+
+static int __init sun5i_setup_clockevent(struct device_node *node, void __iomem *base,
+					 struct clk *clk, int irq)
+{
+	struct sun5i_timer_clkevt *ce;
+	unsigned long rate;
+	int ret;
+	u32 val;
+
+	ce = kzalloc(sizeof(*ce), GFP_KERNEL);
+	if (!ce)
+		return -ENOMEM;
+
+	ret = clk_prepare_enable(clk);
+	if (ret) {
+		pr_err("Couldn't enable parent clock\n");
+		goto err_free;
+	}
+
+	rate = clk_get_rate(clk);
+
+	ce->timer.base = base;
+	ce->timer.ticks_per_jiffy = DIV_ROUND_UP(rate, HZ);
+	ce->timer.clk = clk;
+
+	ce->clkevt.name = node->name;
+	ce->clkevt.features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT;
+	ce->clkevt.set_next_event = sun5i_clkevt_next_event;
+	ce->clkevt.set_mode = sun5i_clkevt_mode;
+	ce->clkevt.rating = 340;
+	ce->clkevt.irq = irq;
+	ce->clkevt.cpumask = cpu_possible_mask;
+
+	/* Enable timer0 interrupt */
+	val = readl(base + TIMER_IRQ_EN_REG);
+	writel(val | TIMER_IRQ_EN(0), base + TIMER_IRQ_EN_REG);
+
+	ret = request_irq(irq, sun5i_timer_interrupt, IRQF_TIMER | IRQF_IRQPOLL,
+			  "sun5i_timer0", ce);
+	if (ret) {
+		pr_err("Unable to register interrupt\n");
+		goto err_disable_clk;
+	}
+
+	clockevents_config_and_register(&ce->clkevt, rate,
+					TIMER_SYNC_TICKS, 0xffffffff);
+
+	return 0;
+
+err_disable_clk:
+	clk_disable_unprepare(clk);
+err_free:
+	kfree(ce);
+	return ret;
+}
+
 static void __init sun5i_timer_init(struct device_node *node)
 {
 	struct reset_control *rstc;
-	unsigned long rate;
+	void __iomem *timer_base;
 	struct clk *clk;
-	int ret, irq;
-	u32 val;
+	int irq;
 
 	timer_base = of_io_request_and_map(node, 0,
 					   of_node_full_name(node));
@@ -150,36 +274,13 @@ static void __init sun5i_timer_init(struct device_node *node)
 	clk = of_clk_get(node, 0);
 	if (IS_ERR(clk))
 		panic("Can't get timer clock");
-	clk_prepare_enable(clk);
-	rate = clk_get_rate(clk);
 
 	rstc = of_reset_control_get(node, NULL);
 	if (!IS_ERR(rstc))
 		reset_control_deassert(rstc);
 
-	writel(~0, timer_base + TIMER_INTVAL_LO_REG(1));
-	writel(TIMER_CTL_ENABLE | TIMER_CTL_RELOAD,
-	       timer_base + TIMER_CTL_REG(1));
-
-	clocksource_mmio_init(timer_base + TIMER_CNTVAL_LO_REG(1), node->name,
-			      rate, 340, 32, clocksource_mmio_readl_down);
-
-	ticks_per_jiffy = DIV_ROUND_UP(rate, HZ);
-
-	ret = request_irq(irq, sun5i_timer_interrupt, IRQF_TIMER | IRQF_IRQPOLL,
-			  "sun5i_timer0", &sun5i_clockevent);
-	if (ret)
-		pr_warn("failed to setup irq %d\n", irq);
-
-	/* Enable timer0 interrupt */
-	val = readl(timer_base + TIMER_IRQ_EN_REG);
-	writel(val | TIMER_IRQ_EN(0), timer_base + TIMER_IRQ_EN_REG);
-
-	sun5i_clockevent.cpumask = cpu_possible_mask;
-	sun5i_clockevent.irq = irq;
-
-	clockevents_config_and_register(&sun5i_clockevent, rate,
-					TIMER_SYNC_TICKS, 0xffffffff);
+	sun5i_setup_clocksource(node, timer_base, clk, irq);
+	sun5i_setup_clockevent(node, timer_base, clk, irq);
 }
 CLOCKSOURCE_OF_DECLARE(sun5i_a13, "allwinner,sun5i-a13-hstimer",
 		       sun5i_timer_init);
-- 
2.2.2

