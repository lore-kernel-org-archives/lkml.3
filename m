Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936488Ab3DHVaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 17:30:46 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41237 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936219Ab3DHV1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 17:27:37 -0400
X-IronPort-AV: E=Sophos;i="4.87,433,1363158000"; 
   d="scan'208";a="36848516"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCHv4 04/11] ARM: smp_twd: Divorce smp_twd from local timer API
Date: Mon,  8 Apr 2013 14:27:26 -0700
Message-Id: <1365456453-16297-5-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1365456453-16297-1-git-send-email-sboyd@codeaurora.org>
References: <1365456453-16297-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate the smp_twd timers from the local timer API. This will
allow us to remove ARM local timer support in the near future and
gets us closer to moving this driver to drivers/clocksource.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Tony Lindgren <tony@atomide.com>
Tested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/Kconfig          |  2 +-
 arch/arm/kernel/smp_twd.c | 64 +++++++++++++++++++++++++++++++----------------
 2 files changed, 44 insertions(+), 22 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 13b7394..ee6bb9d 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1523,6 +1523,7 @@ config SMP
 	depends on HAVE_SMP
 	depends on MMU
 	select HAVE_ARM_SCU if !ARCH_MSM_SCORPIONMP
+	select HAVE_ARM_TWD if (!ARCH_MSM_SCORPIONMP && !EXYNOS4_MCT)
 	select USE_GENERIC_SMP_HELPERS
 	help
 	  This enables support for systems with more than one CPU. If you have
@@ -1646,7 +1647,6 @@ config LOCAL_TIMERS
 	bool "Use local timer interrupts"
 	depends on SMP
 	default y
-	select HAVE_ARM_TWD if (!ARCH_MSM_SCORPIONMP && !EXYNOS4_MCT)
 	help
 	  Enable support for local timers on SMP platforms, rather then the
 	  legacy IPI broadcast method.  Local timers allows the system
diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
index 3f25650..a79476d 100644
--- a/arch/arm/kernel/smp_twd.c
+++ b/arch/arm/kernel/smp_twd.c
@@ -11,6 +11,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/clk.h>
+#include <linux/cpu.h>
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/err.h>
@@ -24,7 +25,6 @@
 
 #include <asm/smp_plat.h>
 #include <asm/smp_twd.h>
-#include <asm/localtimer.h>
 
 /* set up by the platform code */
 static void __iomem *twd_base;
@@ -33,7 +33,7 @@ static struct clk *twd_clk;
 static unsigned long twd_timer_rate;
 static DEFINE_PER_CPU(bool, percpu_setup_called);
 
-static struct clock_event_device __percpu **twd_evt;
+static struct clock_event_device __percpu *twd_evt;
 static int twd_ppi;
 
 static void twd_set_mode(enum clock_event_mode mode,
@@ -90,8 +90,10 @@ static int twd_timer_ack(void)
 	return 0;
 }
 
-static void twd_timer_stop(struct clock_event_device *clk)
+static void twd_timer_stop(void)
 {
+	struct clock_event_device *clk = __this_cpu_ptr(twd_evt);
+
 	twd_set_mode(CLOCK_EVT_MODE_UNUSED, clk);
 	disable_percpu_irq(clk->irq);
 }
@@ -106,7 +108,7 @@ static void twd_update_frequency(void *new_rate)
 {
 	twd_timer_rate = *((unsigned long *) new_rate);
 
-	clockevents_update_freq(*__this_cpu_ptr(twd_evt), twd_timer_rate);
+	clockevents_update_freq(__this_cpu_ptr(twd_evt), twd_timer_rate);
 }
 
 static int twd_rate_change(struct notifier_block *nb,
@@ -132,7 +134,7 @@ static struct notifier_block twd_clk_nb = {
 
 static int twd_clk_init(void)
 {
-	if (twd_evt && *__this_cpu_ptr(twd_evt) && !IS_ERR(twd_clk))
+	if (twd_evt && __this_cpu_ptr(twd_evt) && !IS_ERR(twd_clk))
 		return clk_notifier_register(twd_clk, &twd_clk_nb);
 
 	return 0;
@@ -151,7 +153,7 @@ static void twd_update_frequency(void *data)
 {
 	twd_timer_rate = clk_get_rate(twd_clk);
 
-	clockevents_update_freq(*__this_cpu_ptr(twd_evt), twd_timer_rate);
+	clockevents_update_freq(__this_cpu_ptr(twd_evt), twd_timer_rate);
 }
 
 static int twd_cpufreq_transition(struct notifier_block *nb,
@@ -177,7 +179,7 @@ static struct notifier_block twd_cpufreq_nb = {
 
 static int twd_cpufreq_init(void)
 {
-	if (twd_evt && *__this_cpu_ptr(twd_evt) && !IS_ERR(twd_clk))
+	if (twd_evt && __this_cpu_ptr(twd_evt) && !IS_ERR(twd_clk))
 		return cpufreq_register_notifier(&twd_cpufreq_nb,
 			CPUFREQ_TRANSITION_NOTIFIER);
 
@@ -228,7 +230,7 @@ static void __cpuinit twd_calibrate_rate(void)
 
 static irqreturn_t twd_handler(int irq, void *dev_id)
 {
-	struct clock_event_device *evt = *(struct clock_event_device **)dev_id;
+	struct clock_event_device *evt = dev_id;
 
 	if (twd_timer_ack()) {
 		evt->event_handler(evt);
@@ -265,9 +267,9 @@ static void twd_get_clock(struct device_node *np)
 /*
  * Setup the local clock events for a CPU.
  */
-static int __cpuinit twd_timer_setup(struct clock_event_device *clk)
+static void __cpuinit twd_timer_setup(void)
 {
-	struct clock_event_device **this_cpu_clk;
+	struct clock_event_device *clk = __this_cpu_ptr(twd_evt);
 	int cpu = smp_processor_id();
 
 	/*
@@ -276,9 +278,9 @@ static int __cpuinit twd_timer_setup(struct clock_event_device *clk)
 	 */
 	if (per_cpu(percpu_setup_called, cpu)) {
 		__raw_writel(0, twd_base + TWD_TIMER_CONTROL);
-		clockevents_register_device(*__this_cpu_ptr(twd_evt));
+		clockevents_register_device(clk);
 		enable_percpu_irq(clk->irq, 0);
-		return 0;
+		return;
 	}
 	per_cpu(percpu_setup_called, cpu) = true;
 
@@ -297,27 +299,37 @@ static int __cpuinit twd_timer_setup(struct clock_event_device *clk)
 	clk->set_mode = twd_set_mode;
 	clk->set_next_event = twd_set_next_event;
 	clk->irq = twd_ppi;
-
-	this_cpu_clk = __this_cpu_ptr(twd_evt);
-	*this_cpu_clk = clk;
+	clk->cpumask = cpumask_of(cpu);
 
 	clockevents_config_and_register(clk, twd_timer_rate,
 					0xf, 0xffffffff);
 	enable_percpu_irq(clk->irq, 0);
+}
 
-	return 0;
+static int __cpuinit twd_timer_cpu_notify(struct notifier_block *self,
+					   unsigned long action, void *hcpu)
+{
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_STARTING:
+		twd_timer_setup();
+		break;
+	case CPU_DYING:
+		twd_timer_stop();
+		break;
+	}
+
+	return NOTIFY_OK;
 }
 
-static struct local_timer_ops twd_lt_ops __cpuinitdata = {
-	.setup	= twd_timer_setup,
-	.stop	= twd_timer_stop,
+static struct notifier_block twd_timer_cpu_nb __cpuinitdata = {
+	.notifier_call = twd_timer_cpu_notify,
 };
 
 static int __init twd_local_timer_common_register(struct device_node *np)
 {
 	int err;
 
-	twd_evt = alloc_percpu(struct clock_event_device *);
+	twd_evt = alloc_percpu(struct clock_event_device);
 	if (!twd_evt) {
 		err = -ENOMEM;
 		goto out_free;
@@ -329,12 +341,22 @@ static int __init twd_local_timer_common_register(struct device_node *np)
 		goto out_free;
 	}
 
-	err = local_timer_register(&twd_lt_ops);
+	err = register_cpu_notifier(&twd_timer_cpu_nb);
 	if (err)
 		goto out_irq;
 
 	twd_get_clock(np);
 
+	/*
+	 * Immediately configure the timer on the boot CPU, unless we need
+	 * jiffies to be incrementing to calibrate the rate in which case
+	 * setup the timer in late_time_init.
+	 */
+	if (twd_timer_rate)
+		twd_timer_setup();
+	else
+		late_time_init = twd_timer_setup;
+
 	return 0;
 
 out_irq:
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

