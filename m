Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab3I1ST7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 14:19:59 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:50398 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab3I1ST5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 14:19:57 -0400
Date: Sat, 28 Sep 2013 20:19:53 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [GIT PULL] timer fixes
Message-ID: <20130928181953.GA7020@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-urgent-for-linus

   HEAD: 2199a5574b6d94b9ca26c6345356f45ec60fef8b clocksource: em_sti: Set cpu_possible_mask to fix SMP broadcast

A handful of ARM clocksource/clockevent driver fixes.

Thanks,

	Ingo

------------------>
Jean Pihet (1):
      arm: clocksource: mvebu: Use the main timer as clock source from DT

Magnus Damm (1):
      clocksource: em_sti: Set cpu_possible_mask to fix SMP broadcast

Sebastian Hesselbarth (1):
      clocksource: of: Respect device tree node status

Tomasz Figa (1):
      clocksource: exynos_mct: Set IRQ affinity when the CPU goes online


 drivers/clocksource/Kconfig      |  1 +
 drivers/clocksource/clksrc-of.c  |  3 +++
 drivers/clocksource/em_sti.c     |  2 +-
 drivers/clocksource/exynos_mct.c | 10 +++++++++-
 4 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 41c6946..971d796 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -26,6 +26,7 @@ config DW_APB_TIMER_OF
 
 config ARMADA_370_XP_TIMER
 	bool
+	select CLKSRC_OF
 
 config ORION_TIMER
 	select CLKSRC_OF
diff --git a/drivers/clocksource/clksrc-of.c b/drivers/clocksource/clksrc-of.c
index 37f5325..b9ddd9e 100644
--- a/drivers/clocksource/clksrc-of.c
+++ b/drivers/clocksource/clksrc-of.c
@@ -30,6 +30,9 @@ void __init clocksource_of_init(void)
 	clocksource_of_init_fn init_func;
 
 	for_each_matching_node_and_match(np, __clksrc_of_table, &match) {
+		if (!of_device_is_available(np))
+			continue;
+
 		init_func = match->data;
 		init_func(np);
 	}
diff --git a/drivers/clocksource/em_sti.c b/drivers/clocksource/em_sti.c
index b9c81b7..3a5909c 100644
--- a/drivers/clocksource/em_sti.c
+++ b/drivers/clocksource/em_sti.c
@@ -301,7 +301,7 @@ static void em_sti_register_clockevent(struct em_sti_priv *p)
 	ced->name = dev_name(&p->pdev->dev);
 	ced->features = CLOCK_EVT_FEAT_ONESHOT;
 	ced->rating = 200;
-	ced->cpumask = cpumask_of(0);
+	ced->cpumask = cpu_possible_mask;
 	ced->set_next_event = em_sti_clock_event_next;
 	ced->set_mode = em_sti_clock_event_mode;
 
diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
index 5b34768..62b0de6 100644
--- a/drivers/clocksource/exynos_mct.c
+++ b/drivers/clocksource/exynos_mct.c
@@ -428,7 +428,6 @@ static int exynos4_local_timer_setup(struct clock_event_device *evt)
 				evt->irq);
 			return -EIO;
 		}
-		irq_set_affinity(evt->irq, cpumask_of(cpu));
 	} else {
 		enable_percpu_irq(mct_irqs[MCT_L0_IRQ], 0);
 	}
@@ -449,6 +448,7 @@ static int exynos4_mct_cpu_notify(struct notifier_block *self,
 					   unsigned long action, void *hcpu)
 {
 	struct mct_clock_event_device *mevt;
+	unsigned int cpu;
 
 	/*
 	 * Grab cpu pointer in each case to avoid spurious
@@ -459,6 +459,12 @@ static int exynos4_mct_cpu_notify(struct notifier_block *self,
 		mevt = this_cpu_ptr(&percpu_mct_tick);
 		exynos4_local_timer_setup(&mevt->evt);
 		break;
+	case CPU_ONLINE:
+		cpu = (unsigned long)hcpu;
+		if (mct_int_type == MCT_INT_SPI)
+			irq_set_affinity(mct_irqs[MCT_L0_IRQ + cpu],
+						cpumask_of(cpu));
+		break;
 	case CPU_DYING:
 		mevt = this_cpu_ptr(&percpu_mct_tick);
 		exynos4_local_timer_stop(&mevt->evt);
@@ -500,6 +506,8 @@ static void __init exynos4_timer_resources(struct device_node *np, void __iomem
 					 &percpu_mct_tick);
 		WARN(err, "MCT: can't request IRQ %d (%d)\n",
 		     mct_irqs[MCT_L0_IRQ], err);
+	} else {
+		irq_set_affinity(mct_irqs[MCT_L0_IRQ], cpumask_of(0));
 	}
 
 	err = register_cpu_notifier(&exynos4_mct_cpu_nb);
