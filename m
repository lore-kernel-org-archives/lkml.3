Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab3EMT2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 15:28:09 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47461 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab3EMT0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 15:26:18 -0400
X-IronPort-AV: E=Sophos;i="4.87,663,1363158000"; 
   d="scan'208";a="46754214"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Barry Song <baohua.song@csr.com>
Subject: [PATCHv6 07/11] ARM: PRIMA2: Divorce timer-marco from local timer API
Date: Mon, 13 May 2013 12:26:11 -0700
Message-Id: <1368473175-4841-8-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.rc1.25.g423ecb0.dirty
In-Reply-To: <1368473175-4841-1-git-send-email-sboyd@codeaurora.org>
References: <1368473175-4841-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate the marco local timers from the local timer API. This
will allow us to remove ARM local timer support in the near future
and gets us closer to moving this driver to drivers/clocksource.

Cc: Barry Song <baohua.song@csr.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clocksource/timer-marco.c | 100 ++++++++++++++++++++------------------
 1 file changed, 54 insertions(+), 46 deletions(-)

diff --git a/drivers/clocksource/timer-marco.c b/drivers/clocksource/timer-marco.c
index 97738db..ba97bc1 100644
--- a/drivers/clocksource/timer-marco.c
+++ b/drivers/clocksource/timer-marco.c
@@ -10,6 +10,7 @@
 #include <linux/interrupt.h>
 #include <linux/clockchips.h>
 #include <linux/clocksource.h>
+#include <linux/cpu.h>
 #include <linux/bitops.h>
 #include <linux/irq.h>
 #include <linux/clk.h>
@@ -18,7 +19,6 @@
 #include <linux/of_irq.h>
 #include <linux/of_address.h>
 #include <asm/sched_clock.h>
-#include <asm/localtimer.h>
 #include <asm/mach/time.h>
 
 #define SIRFSOC_TIMER_32COUNTER_0_CTRL			0x0000
@@ -151,13 +151,7 @@ static void sirfsoc_clocksource_resume(struct clocksource *cs)
 		BIT(1) | BIT(0), sirfsoc_timer_base + SIRFSOC_TIMER_64COUNTER_CTRL);
 }
 
-static struct clock_event_device sirfsoc_clockevent = {
-	.name = "sirfsoc_clockevent",
-	.rating = 200,
-	.features = CLOCK_EVT_FEAT_ONESHOT,
-	.set_mode = sirfsoc_timer_set_mode,
-	.set_next_event = sirfsoc_timer_set_next_event,
-};
+static struct clock_event_device __percpu *sirfsoc_clockevent;
 
 static struct clocksource sirfsoc_clocksource = {
 	.name = "sirfsoc_clocksource",
@@ -173,11 +167,8 @@ static struct irqaction sirfsoc_timer_irq = {
 	.name = "sirfsoc_timer0",
 	.flags = IRQF_TIMER | IRQF_NOBALANCING,
 	.handler = sirfsoc_timer_interrupt,
-	.dev_id = &sirfsoc_clockevent,
 };
 
-#ifdef CONFIG_LOCAL_TIMERS
-
 static struct irqaction sirfsoc_timer1_irq = {
 	.name = "sirfsoc_timer1",
 	.flags = IRQF_TIMER | IRQF_NOBALANCING,
@@ -186,56 +177,77 @@ static struct irqaction sirfsoc_timer1_irq = {
 
 static int __cpuinit sirfsoc_local_timer_setup(struct clock_event_device *ce)
 {
-	/* Use existing clock_event for cpu 0 */
-	if (!smp_processor_id())
-		return 0;
+	int cpu = smp_processor_id();
+	struct irqaction *action;
+
+	if (cpu == 0)
+		action = &sirfsoc_timer_irq;
+	else
+		action = &sirfsoc_timer1_irq;
 
-	ce->irq = sirfsoc_timer1_irq.irq;
+	ce->irq = action->irq;
 	ce->name = "local_timer";
-	ce->features = sirfsoc_clockevent.features;
-	ce->rating = sirfsoc_clockevent.rating;
+	ce->features = CLOCK_EVT_FEAT_ONESHOT;
+	ce->rating = 200;
 	ce->set_mode = sirfsoc_timer_set_mode;
 	ce->set_next_event = sirfsoc_timer_set_next_event;
-	ce->shift = sirfsoc_clockevent.shift;
-	ce->mult = sirfsoc_clockevent.mult;
-	ce->max_delta_ns = sirfsoc_clockevent.max_delta_ns;
-	ce->min_delta_ns = sirfsoc_clockevent.min_delta_ns;
+	clockevents_calc_mult_shift(ce, CLOCK_TICK_RATE, 60);
+	ce->max_delta_ns = clockevent_delta2ns(-2, ce);
+	ce->min_delta_ns = clockevent_delta2ns(2, ce);
+	ce->cpumask = cpumask_of(cpu);
 
-	sirfsoc_timer1_irq.dev_id = ce;
-	BUG_ON(setup_irq(ce->irq, &sirfsoc_timer1_irq));
-	irq_set_affinity(sirfsoc_timer1_irq.irq, cpumask_of(1));
+	action->dev_id = ce;
+	BUG_ON(setup_irq(ce->irq, action));
+	irq_set_affinity(action->irq, cpumask_of(cpu));
 
 	clockevents_register_device(ce);
 	return 0;
 }
 
-static void sirfsoc_local_timer_stop(struct clock_event_device *ce)
+static void __cpuinit sirfsoc_local_timer_stop(struct clock_event_device *ce)
 {
+	int cpu = smp_processor_id();
+
 	sirfsoc_timer_count_disable(1);
 
-	remove_irq(sirfsoc_timer1_irq.irq, &sirfsoc_timer1_irq);
+	if (cpu == 0)
+		remove_irq(sirfsoc_timer_irq.irq, &sirfsoc_timer_irq);
+	else
+		remove_irq(sirfsoc_timer1_irq.irq, &sirfsoc_timer1_irq);
 }
 
-static struct local_timer_ops sirfsoc_local_timer_ops __cpuinitdata = {
-	.setup	= sirfsoc_local_timer_setup,
-	.stop	= sirfsoc_local_timer_stop,
+static int __cpuinit sirfsoc_cpu_notify(struct notifier_block *self,
+					   unsigned long action, void *hcpu)
+{
+	/*
+	 * Grab cpu pointer in each case to avoid spurious
+	 * preemptible warnings
+	 */
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_STARTING:
+		sirfsoc_local_timer_setup(this_cpu_ptr(sirfsoc_clockevent));
+		break;
+	case CPU_DYING:
+		sirfsoc_local_timer_stop(this_cpu_ptr(sirfsoc_clockevent));
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block sirfsoc_cpu_nb __cpuinitdata = {
+	.notifier_call = sirfsoc_cpu_notify,
 };
-#endif /* CONFIG_LOCAL_TIMERS */
 
 static void __init sirfsoc_clockevent_init(void)
 {
-	clockevents_calc_mult_shift(&sirfsoc_clockevent, CLOCK_TICK_RATE, 60);
-
-	sirfsoc_clockevent.max_delta_ns =
-		clockevent_delta2ns(-2, &sirfsoc_clockevent);
-	sirfsoc_clockevent.min_delta_ns =
-		clockevent_delta2ns(2, &sirfsoc_clockevent);
-
-	sirfsoc_clockevent.cpumask = cpumask_of(0);
-	clockevents_register_device(&sirfsoc_clockevent);
-#ifdef CONFIG_LOCAL_TIMERS
-	local_timer_register(&sirfsoc_local_timer_ops);
-#endif
+	sirfsoc_clockevent = alloc_percpu(struct clock_event_device);
+	BUG_ON(!sirfsoc_clockevent);
+
+	BUG_ON(register_cpu_notifier(&sirfsoc_cpu_nb));
+
+	/* Immediately configure the timer on the boot CPU */
+	sirfsoc_local_timer_setup(this_cpu_ptr(sirfsoc_clockevent));
 }
 
 /* initialize the kernel jiffy timer source */
@@ -273,8 +285,6 @@ static void __init sirfsoc_marco_timer_init(void)
 
 	BUG_ON(clocksource_register_hz(&sirfsoc_clocksource, CLOCK_TICK_RATE));
 
-	BUG_ON(setup_irq(sirfsoc_timer_irq.irq, &sirfsoc_timer_irq));
-
 	sirfsoc_clockevent_init();
 }
 
@@ -288,11 +298,9 @@ static void __init sirfsoc_of_timer_init(struct device_node *np)
 	if (!sirfsoc_timer_irq.irq)
 		panic("No irq passed for timer0 via DT\n");
 
-#ifdef CONFIG_LOCAL_TIMERS
 	sirfsoc_timer1_irq.irq = irq_of_parse_and_map(np, 1);
 	if (!sirfsoc_timer1_irq.irq)
 		panic("No irq passed for timer1 via DT\n");
-#endif
 
 	sirfsoc_marco_timer_init();
 }
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

