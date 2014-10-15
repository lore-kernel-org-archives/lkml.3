Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbaJOMun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 08:50:43 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:43107 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbaJOMuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 08:50:19 -0400
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 2/2] ARM: sa1100: use pxa_timer clocksource driver
Date: Wed, 15 Oct 2014 16:50:05 +0400
Message-Id: <1413377405-7503-2-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413377405-7503-1-git-send-email-dbaryshkov@gmail.com>
References: <1413377405-7503-1-git-send-email-dbaryshkov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use pxa_timer clocksource driver.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 arch/arm/mach-sa1100/Makefile  |   2 +-
 arch/arm/mach-sa1100/generic.c |   6 ++
 arch/arm/mach-sa1100/time.c    | 139 -----------------------------------------
 3 files changed, 7 insertions(+), 140 deletions(-)
 delete mode 100644 arch/arm/mach-sa1100/time.c

diff --git a/arch/arm/mach-sa1100/Makefile b/arch/arm/mach-sa1100/Makefile
index 2732eef..8eb9a6f 100644
--- a/arch/arm/mach-sa1100/Makefile
+++ b/arch/arm/mach-sa1100/Makefile
@@ -3,7 +3,7 @@
 #
 
 # Common support
-obj-y := clock.o generic.o irq.o time.o #nmi-oopser.o
+obj-y := clock.o generic.o irq.o #nmi-oopser.o
 obj-m :=
 obj-n :=
 obj-  :=
diff --git a/arch/arm/mach-sa1100/generic.c b/arch/arm/mach-sa1100/generic.c
index d4ea142..40e0d86 100644
--- a/arch/arm/mach-sa1100/generic.c
+++ b/arch/arm/mach-sa1100/generic.c
@@ -33,6 +33,7 @@
 #include <mach/irqs.h>
 
 #include "generic.h"
+#include <clocksource/pxa.h>
 
 unsigned int reset_status;
 EXPORT_SYMBOL(reset_status);
@@ -369,6 +370,11 @@ void __init sa1100_map_io(void)
 	iotable_init(standard_io_desc, ARRAY_SIZE(standard_io_desc));
 }
 
+void __init sa1100_timer_init(void)
+{
+	pxa_timer_nodt_init(IRQ_OST0, io_p2v(0x90000000), 3686400);
+}
+
 /*
  * Disable the memory bus request/grant signals on the SA1110 to
  * ensure that we don't receive spurious memory requests.  We set
diff --git a/arch/arm/mach-sa1100/time.c b/arch/arm/mach-sa1100/time.c
deleted file mode 100644
index 1dea6cf..0000000
--- a/arch/arm/mach-sa1100/time.c
+++ /dev/null
@@ -1,139 +0,0 @@
-/*
- * linux/arch/arm/mach-sa1100/time.c
- *
- * Copyright (C) 1998 Deborah Wallach.
- * Twiddles  (C) 1999 Hugo Fiennes <hugo@empeg.com>
- *
- * 2000/03/29 (C) Nicolas Pitre <nico@fluxnic.net>
- *	Rewritten: big cleanup, much simpler, better HZ accuracy.
- *
- */
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/errno.h>
-#include <linux/interrupt.h>
-#include <linux/irq.h>
-#include <linux/timex.h>
-#include <linux/clockchips.h>
-#include <linux/sched_clock.h>
-
-#include <asm/mach/time.h>
-#include <mach/hardware.h>
-#include <mach/irqs.h>
-
-#define SA1100_CLOCK_FREQ 3686400
-#define SA1100_LATCH DIV_ROUND_CLOSEST(SA1100_CLOCK_FREQ, HZ)
-
-static u64 notrace sa1100_read_sched_clock(void)
-{
-	return readl_relaxed(OSCR);
-}
-
-#define MIN_OSCR_DELTA 2
-
-static irqreturn_t sa1100_ost0_interrupt(int irq, void *dev_id)
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
-sa1100_osmr0_set_next_event(unsigned long delta, struct clock_event_device *c)
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
-sa1100_osmr0_set_mode(enum clock_event_mode mode, struct clock_event_device *c)
-{
-	switch (mode) {
-	case CLOCK_EVT_MODE_ONESHOT:
-	case CLOCK_EVT_MODE_UNUSED:
-	case CLOCK_EVT_MODE_SHUTDOWN:
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
-unsigned long osmr[4], oier;
-
-static void sa1100_timer_suspend(struct clock_event_device *cedev)
-{
-	osmr[0] = readl_relaxed(OSMR0);
-	osmr[1] = readl_relaxed(OSMR1);
-	osmr[2] = readl_relaxed(OSMR2);
-	osmr[3] = readl_relaxed(OSMR3);
-	oier = readl_relaxed(OIER);
-}
-
-static void sa1100_timer_resume(struct clock_event_device *cedev)
-{
-	writel_relaxed(0x0f, OSSR);
-	writel_relaxed(osmr[0], OSMR0);
-	writel_relaxed(osmr[1], OSMR1);
-	writel_relaxed(osmr[2], OSMR2);
-	writel_relaxed(osmr[3], OSMR3);
-	writel_relaxed(oier, OIER);
-
-	/*
-	 * OSMR0 is the system timer: make sure OSCR is sufficiently behind
-	 */
-	writel_relaxed(OSMR0 - SA1100_LATCH, OSCR);
-}
-#else
-#define sa1100_timer_suspend NULL
-#define sa1100_timer_resume NULL
-#endif
-
-static struct clock_event_device ckevt_sa1100_osmr0 = {
-	.name		= "osmr0",
-	.features	= CLOCK_EVT_FEAT_ONESHOT,
-	.rating		= 200,
-	.set_next_event	= sa1100_osmr0_set_next_event,
-	.set_mode	= sa1100_osmr0_set_mode,
-	.suspend	= sa1100_timer_suspend,
-	.resume		= sa1100_timer_resume,
-};
-
-static struct irqaction sa1100_timer_irq = {
-	.name		= "ost0",
-	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
-	.handler	= sa1100_ost0_interrupt,
-	.dev_id		= &ckevt_sa1100_osmr0,
-};
-
-void __init sa1100_timer_init(void)
-{
-	writel_relaxed(0, OIER);
-	writel_relaxed(OSSR_M0 | OSSR_M1 | OSSR_M2 | OSSR_M3, OSSR);
-
-	sched_clock_register(sa1100_read_sched_clock, 32, 3686400);
-
-	ckevt_sa1100_osmr0.cpumask = cpumask_of(0);
-
-	setup_irq(IRQ_OST0, &sa1100_timer_irq);
-
-	clocksource_mmio_init(OSCR, "oscr", SA1100_CLOCK_FREQ, 200, 32,
-		clocksource_mmio_readl_up);
-	clockevents_config_and_register(&ckevt_sa1100_osmr0, 3686400,
-					MIN_OSCR_DELTA * 2, 0x7fffffff);
-}
-- 
2.1.1

