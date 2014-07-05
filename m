Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608AbaGELPF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 07:15:05 -0400
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:34616 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063AbaGELOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 07:14:00 -0400
X-ME-Helo: localhost.localdomain
X-ME-Date: Sat, 05 Jul 2014 13:13:59 +0200
X-ME-IP: 86.199.194.180
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v2 2/4] clocksource: add device-tree support for PXA timer
Date: Sat,  5 Jul 2014 13:12:59 +0200
Message-Id: <1404558781-9537-2-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1404558781-9537-1-git-send-email-robert.jarzmik@free.fr>
References: <1404558781-9537-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device-tree support to PXA platforms.
The driver still needs to maintain backward non device-tree
compatibility as well, which implies :
 - a non device-tree init function
 - a static registers base address in the driver

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>

---
Since V1: Daniel's review:
      - comments for registers
      - registers clean-up
      - mach includes removed
      - panic() removed
---
 drivers/clocksource/pxa_timer.c | 129 +++++++++++++++++++++++++++++-----------
 1 file changed, 93 insertions(+), 36 deletions(-)

diff --git a/drivers/clocksource/pxa_timer.c b/drivers/clocksource/pxa_timer.c
index fca174e..5caedd3 100644
--- a/drivers/clocksource/pxa_timer.c
+++ b/drivers/clocksource/pxa_timer.c
@@ -15,14 +15,30 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/clk.h>
 #include <linux/clockchips.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
 #include <linux/sched_clock.h>
 
 #include <asm/div64.h>
-#include <asm/mach/irq.h>
-#include <asm/mach/time.h>
-#include <mach/regs-ost.h>
-#include <mach/irqs.h>
+
+#define OSMR0		0x00	/* OS Timer 0 Match Register */
+#define OSMR1		0x04	/* OS Timer 1 Match Register */
+#define OSMR2		0x08	/* OS Timer 2 Match Register */
+#define OSMR3		0x0C	/* OS Timer 3 Match Register */
+
+#define OSCR		0x10	/* OS Timer Counter Register */
+#define OSSR		0x14	/* OS Timer Status Register */
+#define OWER		0x18	/* OS Timer Watchdog Enable Register */
+#define OIER		0x1C	/* OS Timer Interrupt Enable Register */
+
+#define OSSR_M3		(1 << 3)	/* Match status channel 3 */
+#define OSSR_M2		(1 << 2)	/* Match status channel 2 */
+#define OSSR_M1		(1 << 1)	/* Match status channel 1 */
+#define OSSR_M0		(1 << 0)	/* Match status channel 0 */
+
+#define OIER_E0		(1 << 0)	/* Interrupt enable channel 0 */
 
 /*
  * This is PXA's sched_clock implementation. This has a resolution
@@ -33,9 +49,14 @@
  * calls to sched_clock() which should always be the case in practice.
  */
 
+#define timer_readl(reg) readl_relaxed(timer_base + (reg))
+#define timer_writel(val, reg) writel_relaxed((val), timer_base + (reg))
+
+static void __iomem *timer_base;
+
 static u64 notrace pxa_read_sched_clock(void)
 {
-	return readl_relaxed(OSCR);
+	return timer_readl(OSCR);
 }
 
 
@@ -47,8 +68,8 @@ pxa_ost0_interrupt(int irq, void *dev_id)
 	struct clock_event_device *c = dev_id;
 
 	/* Disarm the compare/match, signal the event. */
-	writel_relaxed(readl_relaxed(OIER) & ~OIER_E0, OIER);
-	writel_relaxed(OSSR_M0, OSSR);
+	timer_writel(timer_readl(OIER) & ~OIER_E0, OIER);
+	timer_writel(OSSR_M0, OSSR);
 	c->event_handler(c);
 
 	return IRQ_HANDLED;
@@ -59,10 +80,10 @@ pxa_osmr0_set_next_event(unsigned long delta, struct clock_event_device *dev)
 {
 	unsigned long next, oscr;
 
-	writel_relaxed(readl_relaxed(OIER) | OIER_E0, OIER);
-	next = readl_relaxed(OSCR) + delta;
-	writel_relaxed(next, OSMR0);
-	oscr = readl_relaxed(OSCR);
+	timer_writel(timer_readl(OIER) | OIER_E0, OIER);
+	next = timer_readl(OSCR) + delta;
+	timer_writel(next, OSMR0);
+	oscr = timer_readl(OSCR);
 
 	return (signed)(next - oscr) <= MIN_OSCR_DELTA ? -ETIME : 0;
 }
@@ -72,15 +93,15 @@ pxa_osmr0_set_mode(enum clock_event_mode mode, struct clock_event_device *dev)
 {
 	switch (mode) {
 	case CLOCK_EVT_MODE_ONESHOT:
-		writel_relaxed(readl_relaxed(OIER) & ~OIER_E0, OIER);
-		writel_relaxed(OSSR_M0, OSSR);
+		timer_writel(timer_readl(OIER) & ~OIER_E0, OIER);
+		timer_writel(OSSR_M0, OSSR);
 		break;
 
 	case CLOCK_EVT_MODE_UNUSED:
 	case CLOCK_EVT_MODE_SHUTDOWN:
 		/* initializing, released, or preparing for suspend */
-		writel_relaxed(readl_relaxed(OIER) & ~OIER_E0, OIER);
-		writel_relaxed(OSSR_M0, OSSR);
+		timer_writel(timer_readl(OIER) & ~OIER_E0, OIER);
+		timer_writel(OSSR_M0, OSSR);
 		break;
 
 	case CLOCK_EVT_MODE_RESUME:
@@ -94,12 +115,12 @@ static unsigned long osmr[4], oier, oscr;
 
 static void pxa_timer_suspend(struct clock_event_device *cedev)
 {
-	osmr[0] = readl_relaxed(OSMR0);
-	osmr[1] = readl_relaxed(OSMR1);
-	osmr[2] = readl_relaxed(OSMR2);
-	osmr[3] = readl_relaxed(OSMR3);
-	oier = readl_relaxed(OIER);
-	oscr = readl_relaxed(OSCR);
+	osmr[0] = timer_readl(OSMR0);
+	osmr[1] = timer_readl(OSMR1);
+	osmr[2] = timer_readl(OSMR2);
+	osmr[3] = timer_readl(OSMR3);
+	oier = timer_readl(OIER);
+	oscr = timer_readl(OSCR);
 }
 
 static void pxa_timer_resume(struct clock_event_device *cedev)
@@ -113,12 +134,12 @@ static void pxa_timer_resume(struct clock_event_device *cedev)
 	if (osmr[0] - oscr < MIN_OSCR_DELTA)
 		osmr[0] += MIN_OSCR_DELTA;
 
-	writel_relaxed(osmr[0], OSMR0);
-	writel_relaxed(osmr[1], OSMR1);
-	writel_relaxed(osmr[2], OSMR2);
-	writel_relaxed(osmr[3], OSMR3);
-	writel_relaxed(oier, OIER);
-	writel_relaxed(oscr, OSCR);
+	timer_writel(osmr[0], OSMR0);
+	timer_writel(osmr[1], OSMR1);
+	timer_writel(osmr[2], OSMR2);
+	timer_writel(osmr[3], OSMR3);
+	timer_writel(oier, OIER);
+	timer_writel(oscr, OSCR);
 }
 #else
 #define pxa_timer_suspend NULL
@@ -142,21 +163,57 @@ static struct irqaction pxa_ost0_irq = {
 	.dev_id		= &ckevt_pxa_osmr0,
 };
 
-void __init pxa_timer_init(void)
+static void pxa_timer_common_init(int irq, unsigned long clock_tick_rate)
 {
-	unsigned long clock_tick_rate = get_clock_tick_rate();
-
-	writel_relaxed(0, OIER);
-	writel_relaxed(OSSR_M0 | OSSR_M1 | OSSR_M2 | OSSR_M3, OSSR);
+	timer_writel(0, OIER);
+	timer_writel(OSSR_M0 | OSSR_M1 | OSSR_M2 | OSSR_M3, OSSR);
 
 	sched_clock_register(pxa_read_sched_clock, 32, clock_tick_rate);
 
 	ckevt_pxa_osmr0.cpumask = cpumask_of(0);
 
-	setup_irq(IRQ_OST0, &pxa_ost0_irq);
+	setup_irq(irq, &pxa_ost0_irq);
 
-	clocksource_mmio_init(OSCR, "oscr0", clock_tick_rate, 200, 32,
-		clocksource_mmio_readl_up);
+	clocksource_mmio_init(timer_base + OSCR, "oscr0", clock_tick_rate, 200,
+			      32, clocksource_mmio_readl_up);
 	clockevents_config_and_register(&ckevt_pxa_osmr0, clock_tick_rate,
-		MIN_OSCR_DELTA * 2, 0x7fffffff);
+					MIN_OSCR_DELTA * 2, 0x7fffffff);
+}
+
+static void __init pxa_timer_dt_init(struct device_node *np)
+{
+	struct clk *clk;
+	int irq;
+
+	/* timer registers are shared with watchdog timer */
+	timer_base = of_iomap(np, 0);
+	if (!timer_base)
+		panic("%s: unable to map resource\n", np->name);
+
+	clk = of_clk_get(np, 0);
+	if (IS_ERR(clk)) {
+		pr_crit("%s: unable to get clk\n", np->name);
+		return;
+	}
+	clk_prepare_enable(clk);
+
+	/* we are only interested in OS-timer0 irq */
+	irq = irq_of_parse_and_map(np, 0);
+	if (irq <= 0) {
+		pr_crit("%s: unable to parse OS-timer0 irq\n", np->name);
+		return;
+	}
+
+	pxa_timer_common_init(irq, clk_get_rate(clk));
+}
+CLOCKSOURCE_OF_DECLARE(pxa_timer, "marvell,pxa-timer", pxa_timer_dt_init);
+
+/*
+ * Legacy timer init for non device-tree boards.
+ */
+void __init pxa_timer_nodt_init(int irq, void __iomem *base,
+	unsigned long clock_tick_rate)
+{
+	timer_base = base;
+	pxa_timer_common_init(irq, clock_tick_rate);
 }
-- 
2.0.0.rc2

