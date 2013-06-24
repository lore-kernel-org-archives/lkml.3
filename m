Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab3FXTbv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:31:51 -0400
Received: from mail1.windriver.com ([147.11.146.13]:54073 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab3FXTbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:31:49 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 24/32] clocksource+irqchip: delete __cpuinit usage from all related files
Date: Mon, 24 Jun 2013 15:30:29 -0400
Message-ID: <1372102237-8757-25-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
References: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __cpuinit type of throwaway sections might have made sense
some time ago when RAM was more constrained, but now the savings
do not offset the cost and complications.  For example, the fix in
commit 5e427ec2d0 ("x86: Fix bit corruption at CPU resume time")
is a good example of the nasty type of bugs that can be created
with improper use of the various __init prefixes.

After a discussion on LKML[1] it was decided that cpuinit should go
the way of devinit and be phased out.  Once all the users are gone,
we can then finally remove the macros themselves from linux/init.h.

This removes all the drivers/clocksource and drivers/irqchip uses of
the __cpuinit macros from all C files.

[1] https://lkml.org/lkml/2013/5/20/589

Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[This commit is part of the __cpuinit removal work.  If you don't see
 any problems with it, then you don't have to do anything ; it will be
 submitted with all the rest of the __cpuinit removal work.  On the
 other hand, if you want to carry this patch in with your other pending
 changes so as to handle conflicts with other pending work yourself, then
 that is fine too, as the commits can largely be treated independently.
 For more information, please see: https://lkml.org/lkml/2013/6/20/513 ]

 drivers/clocksource/arm_arch_timer.c     | 8 ++++----
 drivers/clocksource/exynos_mct.c         | 4 ++--
 drivers/clocksource/metag_generic.c      | 6 +++---
 drivers/clocksource/time-armada-370-xp.c | 4 ++--
 drivers/clocksource/timer-marco.c        | 4 ++--
 drivers/irqchip/irq-gic.c                | 8 ++++----
 6 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 053d846..ffadd83 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -123,7 +123,7 @@ static int arch_timer_set_next_event_phys(unsigned long evt,
 	return 0;
 }
 
-static int __cpuinit arch_timer_setup(struct clock_event_device *clk)
+static int arch_timer_setup(struct clock_event_device *clk)
 {
 	clk->features = CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_C3STOP;
 	clk->name = "arch_sys_timer";
@@ -221,7 +221,7 @@ struct timecounter *arch_timer_get_timecounter(void)
 	return &timecounter;
 }
 
-static void __cpuinit arch_timer_stop(struct clock_event_device *clk)
+static void arch_timer_stop(struct clock_event_device *clk)
 {
 	pr_debug("arch_timer_teardown disable IRQ%d cpu #%d\n",
 		 clk->irq, smp_processor_id());
@@ -237,7 +237,7 @@ static void __cpuinit arch_timer_stop(struct clock_event_device *clk)
 	clk->set_mode(CLOCK_EVT_MODE_UNUSED, clk);
 }
 
-static int __cpuinit arch_timer_cpu_notify(struct notifier_block *self,
+static int arch_timer_cpu_notify(struct notifier_block *self,
 					   unsigned long action, void *hcpu)
 {
 	/*
@@ -256,7 +256,7 @@ static int __cpuinit arch_timer_cpu_notify(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block arch_timer_cpu_nb __cpuinitdata = {
+static struct notifier_block arch_timer_cpu_nb = {
 	.notifier_call = arch_timer_cpu_notify,
 };
 
diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
index a704804..b2bbc41 100644
--- a/drivers/clocksource/exynos_mct.c
+++ b/drivers/clocksource/exynos_mct.c
@@ -400,7 +400,7 @@ static irqreturn_t exynos4_mct_tick_isr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static int __cpuinit exynos4_local_timer_setup(struct clock_event_device *evt)
+static int exynos4_local_timer_setup(struct clock_event_device *evt)
 {
 	struct mct_clock_event_device *mevt;
 	unsigned int cpu = smp_processor_id();
@@ -448,7 +448,7 @@ static void exynos4_local_timer_stop(struct clock_event_device *evt)
 		disable_percpu_irq(mct_irqs[MCT_L0_IRQ]);
 }
 
-static struct local_timer_ops exynos4_mct_tick_ops __cpuinitdata = {
+static struct local_timer_ops exynos4_mct_tick_ops = {
 	.setup	= exynos4_local_timer_setup,
 	.stop	= exynos4_local_timer_stop,
 };
diff --git a/drivers/clocksource/metag_generic.c b/drivers/clocksource/metag_generic.c
index 6722f0e..9e4db41 100644
--- a/drivers/clocksource/metag_generic.c
+++ b/drivers/clocksource/metag_generic.c
@@ -109,7 +109,7 @@ unsigned long long sched_clock(void)
 	return ticks << HARDWARE_TO_NS_SHIFT;
 }
 
-static void __cpuinit arch_timer_setup(unsigned int cpu)
+static void arch_timer_setup(unsigned int cpu)
 {
 	unsigned int txdivtime;
 	struct clock_event_device *clk = &per_cpu(local_clockevent, cpu);
@@ -154,7 +154,7 @@ static void __cpuinit arch_timer_setup(unsigned int cpu)
 	}
 }
 
-static int __cpuinit arch_timer_cpu_notify(struct notifier_block *self,
+static int arch_timer_cpu_notify(struct notifier_block *self,
 					   unsigned long action, void *hcpu)
 {
 	int cpu = (long)hcpu;
@@ -169,7 +169,7 @@ static int __cpuinit arch_timer_cpu_notify(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata arch_timer_cpu_nb = {
+static struct notifier_block arch_timer_cpu_nb = {
 	.notifier_call = arch_timer_cpu_notify,
 };
 
diff --git a/drivers/clocksource/time-armada-370-xp.c b/drivers/clocksource/time-armada-370-xp.c
index efdca32..1b04b7e 100644
--- a/drivers/clocksource/time-armada-370-xp.c
+++ b/drivers/clocksource/time-armada-370-xp.c
@@ -167,7 +167,7 @@ static irqreturn_t armada_370_xp_timer_interrupt(int irq, void *dev_id)
 /*
  * Setup the local clock events for a CPU.
  */
-static int __cpuinit armada_370_xp_timer_setup(struct clock_event_device *evt)
+static int armada_370_xp_timer_setup(struct clock_event_device *evt)
 {
 	u32 u;
 	int cpu = smp_processor_id();
@@ -205,7 +205,7 @@ static void  armada_370_xp_timer_stop(struct clock_event_device *evt)
 	disable_percpu_irq(evt->irq);
 }
 
-static struct local_timer_ops armada_370_xp_local_timer_ops __cpuinitdata = {
+static struct local_timer_ops armada_370_xp_local_timer_ops = {
 	.setup	= armada_370_xp_timer_setup,
 	.stop	=  armada_370_xp_timer_stop,
 };
diff --git a/drivers/clocksource/timer-marco.c b/drivers/clocksource/timer-marco.c
index e5dc912..62876ba 100644
--- a/drivers/clocksource/timer-marco.c
+++ b/drivers/clocksource/timer-marco.c
@@ -184,7 +184,7 @@ static struct irqaction sirfsoc_timer1_irq = {
 	.handler = sirfsoc_timer_interrupt,
 };
 
-static int __cpuinit sirfsoc_local_timer_setup(struct clock_event_device *ce)
+static int sirfsoc_local_timer_setup(struct clock_event_device *ce)
 {
 	/* Use existing clock_event for cpu 0 */
 	if (!smp_processor_id())
@@ -216,7 +216,7 @@ static void sirfsoc_local_timer_stop(struct clock_event_device *ce)
 	remove_irq(sirfsoc_timer1_irq.irq, &sirfsoc_timer1_irq);
 }
 
-static struct local_timer_ops sirfsoc_local_timer_ops __cpuinitdata = {
+static struct local_timer_ops sirfsoc_local_timer_ops = {
 	.setup	= sirfsoc_local_timer_setup,
 	.stop	= sirfsoc_local_timer_stop,
 };
diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 19ceaa6..ee7c503 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -414,7 +414,7 @@ static void __init gic_dist_init(struct gic_chip_data *gic)
 	writel_relaxed(1, base + GIC_DIST_CTRL);
 }
 
-static void __cpuinit gic_cpu_init(struct gic_chip_data *gic)
+static void gic_cpu_init(struct gic_chip_data *gic)
 {
 	void __iomem *dist_base = gic_data_dist_base(gic);
 	void __iomem *base = gic_data_cpu_base(gic);
@@ -702,8 +702,8 @@ static int gic_irq_domain_xlate(struct irq_domain *d,
 }
 
 #ifdef CONFIG_SMP
-static int __cpuinit gic_secondary_init(struct notifier_block *nfb,
-					unsigned long action, void *hcpu)
+static int gic_secondary_init(struct notifier_block *nfb, unsigned long action,
+			      void *hcpu)
 {
 	if (action == CPU_STARTING || action == CPU_STARTING_FROZEN)
 		gic_cpu_init(&gic_data[0]);
@@ -714,7 +714,7 @@ static int __cpuinit gic_secondary_init(struct notifier_block *nfb,
  * Notifier for enabling the GIC CPU interface. Set an arbitrarily high
  * priority because the GIC needs to be up before the ARM generic timers.
  */
-static struct notifier_block __cpuinitdata gic_cpu_notifier = {
+static struct notifier_block gic_cpu_notifier = {
 	.notifier_call = gic_secondary_init,
 	.priority = 100,
 };
-- 
1.8.1.2

