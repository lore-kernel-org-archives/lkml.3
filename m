Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006AbaGWKyl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 06:54:41 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:34161 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757623AbaGWKyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 06:54:33 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 20/25] clocksource: pxa: Move PXA timer to clocksource framework
Date: Wed, 23 Jul 2014 12:54:02 +0200
Message-Id: <1406112847-26275-20-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406112847-26275-1-git-send-email-daniel.lezcano@linaro.org>
References: <53CF93B2.6040903@linaro.org>
 <1406112847-26275-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Jarzmik <robert.jarzmik@free.fr>

Move time.c from arch/arm/mach-pxa/time.c to
drivers/clocksource/pxa_timer.c.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 arch/arm/mach-pxa/Makefile      |    2 +-
 arch/arm/mach-pxa/time.c        |  162 ---------------------------------------
 drivers/clocksource/Makefile    |    1 +
 drivers/clocksource/pxa_timer.c |  162 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 164 insertions(+), 163 deletions(-)
 delete mode 100644 arch/arm/mach-pxa/time.c
 create mode 100644 drivers/clocksource/pxa_timer.c

diff --git a/arch/arm/mach-pxa/Makefile b/arch/arm/mach-pxa/Makefile
index 648867a..2fe1824 100644
--- a/arch/arm/mach-pxa/Makefile
+++ b/arch/arm/mach-pxa/Makefile
@@ -4,7 +4,7 @@
 
 # Common support (must be linked before board specific support)
 obj-y				+= clock.o devices.o generic.o irq.o \
-				   time.o reset.o
+				   reset.o
 obj-$(CONFIG_PM)		+= pm.o sleep.o standby.o
 
 # Generic drivers that other drivers may depend upon
diff --git a/arch/arm/mach-pxa/time.c b/arch/arm/mach-pxa/time.c
deleted file mode 100644
index fca174e..0000000
--- a/arch/arm/mach-pxa/time.c
+++ /dev/null
@@ -1,162 +0,0 @@
-/*
- * arch/arm/mach-pxa/time.c
- *
- * PXA clocksource, clockevents, and OST interrupt handlers.
- * Copyright (c) 2007 by Bill Gatliff <bgat@billgatliff.com>.
- *
- * Derived from Nicolas Pitre's PXA timer handler Copyright (c) 2001
- * by MontaVista Software, Inc.  (Nico, your code rocks!)
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/interrupt.h>
-#include <linux/clockchips.h>
-#include <linux/sched_clock.h>
-
-#include <asm/div64.h>
-#include <asm/mach/irq.h>
-#include <asm/mach/time.h>
-#include <mach/regs-ost.h>
-#include <mach/irqs.h>
-
-/*
- * This is PXA's sched_clock implementation. This has a resolution
- * of at least 308 ns and a maximum value of 208 days.
- *
- * The return value is guaranteed to be monotonic in that range as
- * long as there is always less than 582 seconds between successive
- * calls to sched_clock() which should always be the case in practice.
- */
-
-static u64 notrace pxa_read_sched_clock(void)
-{
-	return readl_relaxed(OSCR);
-}
-
-
-#define MIN_OSCR_DELTA 16
-
-static irqreturn_t
-pxa_ost0_interrupt(int irq, void *dev_id)
-{
-	struct clock_event_device *c = dev_id;
-
-	/* Disarm the compare/match, signal the event. */
-	writel_relaxed(readl_relaxed(OIER) & ~OIER_E0, OIER);
-	writel_relaxed(OSSR_M0, OSSR);
-	c->event_handler(c);
-
-	return IRQ_HANDLED;
-}
-
-static int
-pxa_osmr0_set_next_event(unsigned long delta, struct clock_event_device *dev)
-{
-	unsigned long next, oscr;
-
-	writel_relaxed(readl_relaxed(OIER) | OIER_E0, OIER);
-	next = readl_relaxed(OSCR) + delta;
-	writel_relaxed(next, OSMR0);
-	oscr = readl_relaxed(OSCR);
-
-	return (signed)(next - oscr) <= MIN_OSCR_DELTA ? -ETIME : 0;
-}
-
-static void
-pxa_osmr0_set_mode(enum clock_event_mode mode, struct clock_event_device *dev)
-{
-	switch (mode) {
-	case CLOCK_EVT_MODE_ONESHOT:
-		writel_relaxed(readl_relaxed(OIER) & ~OIER_E0, OIER);
-		writel_relaxed(OSSR_M0, OSSR);
-		break;
-
-	case CLOCK_EVT_MODE_UNUSED:
-	case CLOCK_EVT_MODE_SHUTDOWN:
-		/* initializing, released, or preparing for suspend */
-		writel_relaxed(readl_relaxed(OIER) & ~OIER_E0, OIER);
-		writel_relaxed(OSSR_M0, OSSR);
-		break;
-
-	case CLOCK_EVT_MODE_RESUME:
-	case CLOCK_EVT_MODE_PERIODIC:
-		break;
-	}
-}
-
-#ifdef CONFIG_PM
-static unsigned long osmr[4], oier, oscr;
-
-static void pxa_timer_suspend(struct clock_event_device *cedev)
-{
-	osmr[0] = readl_relaxed(OSMR0);
-	osmr[1] = readl_relaxed(OSMR1);
-	osmr[2] = readl_relaxed(OSMR2);
-	osmr[3] = readl_relaxed(OSMR3);
-	oier = readl_relaxed(OIER);
-	oscr = readl_relaxed(OSCR);
-}
-
-static void pxa_timer_resume(struct clock_event_device *cedev)
-{
-	/*
-	 * Ensure that we have at least MIN_OSCR_DELTA between match
-	 * register 0 and the OSCR, to guarantee that we will receive
-	 * the one-shot timer interrupt.  We adjust OSMR0 in preference
-	 * to OSCR to guarantee that OSCR is monotonically incrementing.
-	 */
-	if (osmr[0] - oscr < MIN_OSCR_DELTA)
-		osmr[0] += MIN_OSCR_DELTA;
-
-	writel_relaxed(osmr[0], OSMR0);
-	writel_relaxed(osmr[1], OSMR1);
-	writel_relaxed(osmr[2], OSMR2);
-	writel_relaxed(osmr[3], OSMR3);
-	writel_relaxed(oier, OIER);
-	writel_relaxed(oscr, OSCR);
-}
-#else
-#define pxa_timer_suspend NULL
-#define pxa_timer_resume NULL
-#endif
-
-static struct clock_event_device ckevt_pxa_osmr0 = {
-	.name		= "osmr0",
-	.features	= CLOCK_EVT_FEAT_ONESHOT,
-	.rating		= 200,
-	.set_next_event	= pxa_osmr0_set_next_event,
-	.set_mode	= pxa_osmr0_set_mode,
-	.suspend	= pxa_timer_suspend,
-	.resume		= pxa_timer_resume,
-};
-
-static struct irqaction pxa_ost0_irq = {
-	.name		= "ost0",
-	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
-	.handler	= pxa_ost0_interrupt,
-	.dev_id		= &ckevt_pxa_osmr0,
-};
-
-void __init pxa_timer_init(void)
-{
-	unsigned long clock_tick_rate = get_clock_tick_rate();
-
-	writel_relaxed(0, OIER);
-	writel_relaxed(OSSR_M0 | OSSR_M1 | OSSR_M2 | OSSR_M3, OSSR);
-
-	sched_clock_register(pxa_read_sched_clock, 32, clock_tick_rate);
-
-	ckevt_pxa_osmr0.cpumask = cpumask_of(0);
-
-	setup_irq(IRQ_OST0, &pxa_ost0_irq);
-
-	clocksource_mmio_init(OSCR, "oscr0", clock_tick_rate, 200, 32,
-		clocksource_mmio_readl_up);
-	clockevents_config_and_register(&ckevt_pxa_osmr0, clock_tick_rate,
-		MIN_OSCR_DELTA * 2, 0x7fffffff);
-}
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index e40435d..7fd9fd1 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_ARCH_CLPS711X)	+= clps711x-timer.o
 obj-$(CONFIG_ARCH_MARCO)	+= timer-marco.o
 obj-$(CONFIG_ARCH_MOXART)	+= moxart_timer.o
 obj-$(CONFIG_ARCH_MXS)		+= mxs_timer.o
+obj-$(CONFIG_ARCH_PXA)		+= pxa_timer.o
 obj-$(CONFIG_ARCH_PRIMA2)	+= timer-prima2.o
 obj-$(CONFIG_ARCH_U300)		+= timer-u300.o
 obj-$(CONFIG_SUN4I_TIMER)	+= sun4i_timer.o
diff --git a/drivers/clocksource/pxa_timer.c b/drivers/clocksource/pxa_timer.c
new file mode 100644
index 0000000..fca174e
--- /dev/null
+++ b/drivers/clocksource/pxa_timer.c
@@ -0,0 +1,162 @@
+/*
+ * arch/arm/mach-pxa/time.c
+ *
+ * PXA clocksource, clockevents, and OST interrupt handlers.
+ * Copyright (c) 2007 by Bill Gatliff <bgat@billgatliff.com>.
+ *
+ * Derived from Nicolas Pitre's PXA timer handler Copyright (c) 2001
+ * by MontaVista Software, Inc.  (Nico, your code rocks!)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/clockchips.h>
+#include <linux/sched_clock.h>
+
+#include <asm/div64.h>
+#include <asm/mach/irq.h>
+#include <asm/mach/time.h>
+#include <mach/regs-ost.h>
+#include <mach/irqs.h>
+
+/*
+ * This is PXA's sched_clock implementation. This has a resolution
+ * of at least 308 ns and a maximum value of 208 days.
+ *
+ * The return value is guaranteed to be monotonic in that range as
+ * long as there is always less than 582 seconds between successive
+ * calls to sched_clock() which should always be the case in practice.
+ */
+
+static u64 notrace pxa_read_sched_clock(void)
+{
+	return readl_relaxed(OSCR);
+}
+
+
+#define MIN_OSCR_DELTA 16
+
+static irqreturn_t
+pxa_ost0_interrupt(int irq, void *dev_id)
+{
+	struct clock_event_device *c = dev_id;
+
+	/* Disarm the compare/match, signal the event. */
+	writel_relaxed(readl_relaxed(OIER) & ~OIER_E0, OIER);
+	writel_relaxed(OSSR_M0, OSSR);
+	c->event_handler(c);
+
+	return IRQ_HANDLED;
+}
+
+static int
+pxa_osmr0_set_next_event(unsigned long delta, struct clock_event_device *dev)
+{
+	unsigned long next, oscr;
+
+	writel_relaxed(readl_relaxed(OIER) | OIER_E0, OIER);
+	next = readl_relaxed(OSCR) + delta;
+	writel_relaxed(next, OSMR0);
+	oscr = readl_relaxed(OSCR);
+
+	return (signed)(next - oscr) <= MIN_OSCR_DELTA ? -ETIME : 0;
+}
+
+static void
+pxa_osmr0_set_mode(enum clock_event_mode mode, struct clock_event_device *dev)
+{
+	switch (mode) {
+	case CLOCK_EVT_MODE_ONESHOT:
+		writel_relaxed(readl_relaxed(OIER) & ~OIER_E0, OIER);
+		writel_relaxed(OSSR_M0, OSSR);
+		break;
+
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+		/* initializing, released, or preparing for suspend */
+		writel_relaxed(readl_relaxed(OIER) & ~OIER_E0, OIER);
+		writel_relaxed(OSSR_M0, OSSR);
+		break;
+
+	case CLOCK_EVT_MODE_RESUME:
+	case CLOCK_EVT_MODE_PERIODIC:
+		break;
+	}
+}
+
+#ifdef CONFIG_PM
+static unsigned long osmr[4], oier, oscr;
+
+static void pxa_timer_suspend(struct clock_event_device *cedev)
+{
+	osmr[0] = readl_relaxed(OSMR0);
+	osmr[1] = readl_relaxed(OSMR1);
+	osmr[2] = readl_relaxed(OSMR2);
+	osmr[3] = readl_relaxed(OSMR3);
+	oier = readl_relaxed(OIER);
+	oscr = readl_relaxed(OSCR);
+}
+
+static void pxa_timer_resume(struct clock_event_device *cedev)
+{
+	/*
+	 * Ensure that we have at least MIN_OSCR_DELTA between match
+	 * register 0 and the OSCR, to guarantee that we will receive
+	 * the one-shot timer interrupt.  We adjust OSMR0 in preference
+	 * to OSCR to guarantee that OSCR is monotonically incrementing.
+	 */
+	if (osmr[0] - oscr < MIN_OSCR_DELTA)
+		osmr[0] += MIN_OSCR_DELTA;
+
+	writel_relaxed(osmr[0], OSMR0);
+	writel_relaxed(osmr[1], OSMR1);
+	writel_relaxed(osmr[2], OSMR2);
+	writel_relaxed(osmr[3], OSMR3);
+	writel_relaxed(oier, OIER);
+	writel_relaxed(oscr, OSCR);
+}
+#else
+#define pxa_timer_suspend NULL
+#define pxa_timer_resume NULL
+#endif
+
+static struct clock_event_device ckevt_pxa_osmr0 = {
+	.name		= "osmr0",
+	.features	= CLOCK_EVT_FEAT_ONESHOT,
+	.rating		= 200,
+	.set_next_event	= pxa_osmr0_set_next_event,
+	.set_mode	= pxa_osmr0_set_mode,
+	.suspend	= pxa_timer_suspend,
+	.resume		= pxa_timer_resume,
+};
+
+static struct irqaction pxa_ost0_irq = {
+	.name		= "ost0",
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
+	.handler	= pxa_ost0_interrupt,
+	.dev_id		= &ckevt_pxa_osmr0,
+};
+
+void __init pxa_timer_init(void)
+{
+	unsigned long clock_tick_rate = get_clock_tick_rate();
+
+	writel_relaxed(0, OIER);
+	writel_relaxed(OSSR_M0 | OSSR_M1 | OSSR_M2 | OSSR_M3, OSSR);
+
+	sched_clock_register(pxa_read_sched_clock, 32, clock_tick_rate);
+
+	ckevt_pxa_osmr0.cpumask = cpumask_of(0);
+
+	setup_irq(IRQ_OST0, &pxa_ost0_irq);
+
+	clocksource_mmio_init(OSCR, "oscr0", clock_tick_rate, 200, 32,
+		clocksource_mmio_readl_up);
+	clockevents_config_and_register(&ckevt_pxa_osmr0, clock_tick_rate,
+		MIN_OSCR_DELTA * 2, 0x7fffffff);
+}
-- 
1.7.9.5

