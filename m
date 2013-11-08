Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242Ab3KHVVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 16:21:43 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:55404 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932173Ab3KHVVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 16:21:38 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 6/7] clocksource/cadence_ttc: Use only one counter
Date: Fri,  8 Nov 2013 13:21:16 -0800
Message-Id: <1383945677-29674-7-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1383945677-29674-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1383945677-29674-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the driver uses two of the three counters the TTC provides to
implement a clocksource and a clockevent device. By using the TTC's
match feature we can implement both use cases using a single counter
only.
The old approach is to use timer over-/underflow to generate an
interrupt. Using the match register allows to generate an interrupt on
arbitrary counter values. This way a dedicated clockevent counter can be
avoided.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/clocksource/cadence_ttc_timer.c | 92 +++++++++++----------------------
 1 file changed, 31 insertions(+), 61 deletions(-)

diff --git a/drivers/clocksource/cadence_ttc_timer.c b/drivers/clocksource/cadence_ttc_timer.c
index 421b942dd707..01dba97cee84 100644
--- a/drivers/clocksource/cadence_ttc_timer.c
+++ b/drivers/clocksource/cadence_ttc_timer.c
@@ -48,6 +48,7 @@
 #define TTC_CNT_CNTRL_OFFSET		0x0C /* Counter Control Reg, RW */
 #define TTC_COUNT_VAL_OFFSET		0x18 /* Counter Value Reg, RO */
 #define TTC_INTR_VAL_OFFSET		0x24 /* Interval Count Reg, RW */
+#define TTC_MATCH1_OFFSET	0x30 /* Match reg, RW */
 #define TTC_ISR_OFFSET		0x54 /* Interrupt Status Reg, RO */
 #define TTC_IER_OFFSET		0x60 /* Interrupt Enable Reg, RW */
 
@@ -65,7 +66,10 @@
 #define PRESCALE		2048	/* The exponent must match this */
 #define CLK_CNTRL_PRESCALE	((PRESCALE_EXPONENT - 1) << 1)
 #define CLK_CNTRL_PRESCALE_EN	1
-#define CNT_CNTRL_RESET		(1 << 4)
+#define CNT_CNTRL_RESET		BIT(4)
+#define CNT_CNTRL_MATCH		BIT(3)
+
+#define TTC_INTERRUPT_MATCH1	BIT(1)
 
 #define MAX_F_ERR 50
 
@@ -103,6 +107,7 @@ struct ttc_timer_clocksource {
 struct ttc_timer_clockevent {
 	struct ttc_timer		ttc;
 	struct clock_event_device	ce;
+	unsigned long			interval;
 };
 
 #define to_ttc_timer_clkevent(x) \
@@ -116,25 +121,20 @@ static void __iomem *ttc_sched_clock_val_reg;
  * @timer:	Pointer to the timer instance
  * @cycles:	Timer interval ticks
  **/
-static void ttc_set_interval(struct ttc_timer *timer,
-					unsigned long cycles)
+static void ttc_set_interval(struct ttc_timer *timer, unsigned long cycles)
 {
-	u32 ctrl_reg;
+	struct ttc_timer_clockevent *ttcce = container_of(timer,
+			struct ttc_timer_clockevent, ttc);
 
-	/* Disable the counter, set the counter value  and re-enable counter */
-	ctrl_reg = __raw_readl(timer->base_addr + TTC_CNT_CNTRL_OFFSET);
-	ctrl_reg |= TTC_CNT_CNTRL_DISABLE_MASK;
-	__raw_writel(ctrl_reg, timer->base_addr + TTC_CNT_CNTRL_OFFSET);
+	/* set interval */
+	u32 reg = __raw_readl(timer->base_addr + TTC_COUNT_VAL_OFFSET);
+	reg += cycles;
+	__raw_writel(reg, timer->base_addr + TTC_MATCH1_OFFSET);
 
-	__raw_writel(cycles, timer->base_addr + TTC_INTR_VAL_OFFSET);
+	/* enable match interrupt */
+	__raw_writel(TTC_INTERRUPT_MATCH1, timer->base_addr + TTC_IER_OFFSET);
 
-	/*
-	 * Reset the counter (0x10) so that it starts from 0, one-shot
-	 * mode makes this needed for timing to be right.
-	 */
-	ctrl_reg |= CNT_CNTRL_RESET;
-	ctrl_reg &= ~TTC_CNT_CNTRL_DISABLE_MASK;
-	__raw_writel(ctrl_reg, timer->base_addr + TTC_CNT_CNTRL_OFFSET);
+	ttcce->interval = cycles;
 }
 
 /**
@@ -152,6 +152,8 @@ static irqreturn_t ttc_clock_event_interrupt(int irq, void *dev_id)
 
 	/* Acknowledge the interrupt and call event handler */
 	__raw_readl(timer->base_addr + TTC_ISR_OFFSET);
+	if (ttce->ce.mode == CLOCK_EVT_MODE_PERIODIC)
+		ttc_set_interval(timer, ttce->interval);
 
 	ttce->ce.event_handler(&ttce->ce);
 
@@ -205,7 +207,6 @@ static void ttc_set_mode(enum clock_event_mode mode,
 {
 	struct ttc_timer_clockevent *ttce = to_ttc_timer_clkevent(evt);
 	struct ttc_timer *timer = &ttce->ttc;
-	u32 ctrl_reg;
 
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
@@ -215,18 +216,9 @@ static void ttc_set_mode(enum clock_event_mode mode,
 	case CLOCK_EVT_MODE_ONESHOT:
 	case CLOCK_EVT_MODE_UNUSED:
 	case CLOCK_EVT_MODE_SHUTDOWN:
-		ctrl_reg = __raw_readl(timer->base_addr +
-					TTC_CNT_CNTRL_OFFSET);
-		ctrl_reg |= TTC_CNT_CNTRL_DISABLE_MASK;
-		__raw_writel(ctrl_reg,
-				timer->base_addr + TTC_CNT_CNTRL_OFFSET);
+		__raw_writel(0, timer->base_addr + TTC_IER_OFFSET);
 		break;
 	case CLOCK_EVT_MODE_RESUME:
-		ctrl_reg = __raw_readl(timer->base_addr +
-					TTC_CNT_CNTRL_OFFSET);
-		ctrl_reg &= ~TTC_CNT_CNTRL_DISABLE_MASK;
-		__raw_writel(ctrl_reg,
-				timer->base_addr + TTC_CNT_CNTRL_OFFSET);
 		break;
 	}
 }
@@ -392,17 +384,6 @@ static void __init ttc_setup_clocksource(struct clk *clk, void __iomem *base)
 	ttccs->cs.mask = CLOCKSOURCE_MASK(16);
 	ttccs->cs.flags = CLOCK_SOURCE_IS_CONTINUOUS;
 
-	/*
-	 * Setup the clock source counter to be an incrementing counter
-	 * with no interrupt and it rolls over at 0xFFFF. Pre-scale
-	 * it by 32 also. Let it start running now.
-	 */
-	__raw_writel(0x0,  ttccs->ttc.base_addr + TTC_IER_OFFSET);
-	__raw_writel(CLK_CNTRL_PRESCALE | CLK_CNTRL_PRESCALE_EN,
-		     ttccs->ttc.base_addr + TTC_CLK_CNTRL_OFFSET);
-	__raw_writel(CNT_CNTRL_RESET,
-		     ttccs->ttc.base_addr + TTC_CNT_CNTRL_OFFSET);
-
 	err = clocksource_register_hz(&ttccs->cs, ttccs->ttc.freq / PRESCALE);
 	if (WARN_ON(err)) {
 		kfree(ttccs);
@@ -488,16 +469,6 @@ static void __init ttc_setup_clockevent(struct clk *clk,
 	ttcce->ce.irq = irq;
 	ttcce->ce.cpumask = cpu_possible_mask;
 
-	/*
-	 * Setup the clock event timer to be an interval timer which
-	 * is prescaled by 32 using the interval interrupt. Leave it
-	 * disabled for now.
-	 */
-	__raw_writel(0x23, ttcce->ttc.base_addr + TTC_CNT_CNTRL_OFFSET);
-	__raw_writel(CLK_CNTRL_PRESCALE | CLK_CNTRL_PRESCALE_EN,
-		     ttcce->ttc.base_addr + TTC_CLK_CNTRL_OFFSET);
-	__raw_writel(0x1,  ttcce->ttc.base_addr + TTC_IER_OFFSET);
-
 	err = request_irq(irq, ttc_clock_event_interrupt,
 			  IRQF_DISABLED | IRQF_TIMER,
 			  ttcce->ce.name, ttcce);
@@ -520,7 +491,7 @@ static void __init ttc_timer_init(struct device_node *timer)
 {
 	unsigned int irq;
 	void __iomem *timer_baseaddr;
-	struct clk *clk_cs, *clk_ce;
+	struct clk *clk;
 	static int initialized;
 	int clksel;
 
@@ -540,7 +511,7 @@ static void __init ttc_timer_init(struct device_node *timer)
 		BUG();
 	}
 
-	irq = irq_of_parse_and_map(timer, 1);
+	irq = irq_of_parse_and_map(timer, 0);
 	if (irq <= 0) {
 		pr_err("ERROR: invalid interrupt number\n");
 		BUG();
@@ -548,22 +519,21 @@ static void __init ttc_timer_init(struct device_node *timer)
 
 	clksel = __raw_readl(timer_baseaddr + TTC_CLK_CNTRL_OFFSET);
 	clksel = !!(clksel & TTC_CLK_CNTRL_CSRC_MASK);
-	clk_cs = of_clk_get(timer, clksel);
-	if (IS_ERR(clk_cs)) {
+	clk = of_clk_get(timer, clksel);
+	if (IS_ERR(clk)) {
 		pr_err("ERROR: timer input clock not found\n");
 		BUG();
 	}
 
-	clksel = __raw_readl(timer_baseaddr + 4 + TTC_CLK_CNTRL_OFFSET);
-	clksel = !!(clksel & TTC_CLK_CNTRL_CSRC_MASK);
-	clk_ce = of_clk_get(timer, clksel);
-	if (IS_ERR(clk_ce)) {
-		pr_err("ERROR: timer input clock not found\n");
-		BUG();
-	}
+	__raw_writel(CLK_CNTRL_PRESCALE | CLK_CNTRL_PRESCALE_EN,
+			timer_baseaddr + TTC_CLK_CNTRL_OFFSET);
+
+	/* start timer in overflow and match mode */
+	__raw_writel(CNT_CNTRL_RESET | CNT_CNTRL_MATCH,
+			timer_baseaddr + TTC_CNT_CNTRL_OFFSET);
 
-	ttc_setup_clocksource(clk_cs, timer_baseaddr);
-	ttc_setup_clockevent(clk_ce, timer_baseaddr + 4, irq);
+	ttc_setup_clocksource(clk, timer_baseaddr);
+	ttc_setup_clockevent(clk, timer_baseaddr, irq);
 
 	pr_info("%s #0 at %p, irq=%d\n", timer->name, timer_baseaddr, irq);
 }
-- 
1.8.4.2

