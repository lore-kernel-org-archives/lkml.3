Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab3BVH2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 02:28:36 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59123 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015Ab3BVH1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 02:27:25 -0500
X-IronPort-AV: E=Sophos;i="4.84,713,1355126400"; 
   d="scan'208";a="26221329"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 2/8] ARM: smp_twd: Divorce smp_twd from local timer API
Date: Thu, 21 Feb 2013 23:27:13 -0800
Message-Id: <1361518039-16663-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2.rc0.16.g20a599e
In-Reply-To: <1361518039-16663-1-git-send-email-sboyd@codeaurora.org>
References: <1361518039-16663-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate the smp_twd timers from the local timer API. This will
allow us to remove ARM local timer support in the near future and
gets us closer to moving this driver to drivers/clocksource.

Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/kernel/smp_twd.c | 48 +++++++++++++++++++++++++++++++----------------
 1 file changed, 32 insertions(+), 16 deletions(-)

diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
index c092115..2439843 100644
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
@@ -23,7 +24,6 @@
 #include <linux/of_address.h>
 
 #include <asm/smp_twd.h>
-#include <asm/localtimer.h>
 
 /* set up by the platform code */
 static void __iomem *twd_base;
@@ -32,7 +32,7 @@ static struct clk *twd_clk;
 static unsigned long twd_timer_rate;
 static DEFINE_PER_CPU(bool, percpu_setup_called);
 
-static struct clock_event_device __percpu **twd_evt;
+static struct clock_event_device __percpu *twd_evt;
 static int twd_ppi;
 
 static void twd_set_mode(enum clock_event_mode mode,
@@ -105,7 +105,7 @@ static void twd_update_frequency(void *new_rate)
 {
 	twd_timer_rate = *((unsigned long *) new_rate);
 
-	clockevents_update_freq(*__this_cpu_ptr(twd_evt), twd_timer_rate);
+	clockevents_update_freq(__this_cpu_ptr(twd_evt), twd_timer_rate);
 }
 
 static int twd_rate_change(struct notifier_block *nb,
@@ -131,7 +131,7 @@ static struct notifier_block twd_clk_nb = {
 
 static int twd_clk_init(void)
 {
-	if (twd_evt && *__this_cpu_ptr(twd_evt) && !IS_ERR(twd_clk))
+	if (twd_evt && __this_cpu_ptr(twd_evt) && !IS_ERR(twd_clk))
 		return clk_notifier_register(twd_clk, &twd_clk_nb);
 
 	return 0;
@@ -150,7 +150,7 @@ static void twd_update_frequency(void *data)
 {
 	twd_timer_rate = clk_get_rate(twd_clk);
 
-	clockevents_update_freq(*__this_cpu_ptr(twd_evt), twd_timer_rate);
+	clockevents_update_freq(__this_cpu_ptr(twd_evt), twd_timer_rate);
 }
 
 static int twd_cpufreq_transition(struct notifier_block *nb,
@@ -176,7 +176,7 @@ static struct notifier_block twd_cpufreq_nb = {
 
 static int twd_cpufreq_init(void)
 {
-	if (twd_evt && *__this_cpu_ptr(twd_evt) && !IS_ERR(twd_clk))
+	if (twd_evt && __this_cpu_ptr(twd_evt) && !IS_ERR(twd_clk))
 		return cpufreq_register_notifier(&twd_cpufreq_nb,
 			CPUFREQ_TRANSITION_NOTIFIER);
 
@@ -266,7 +266,6 @@ static void twd_get_clock(struct device_node *np)
  */
 static int __cpuinit twd_timer_setup(struct clock_event_device *clk)
 {
-	struct clock_event_device **this_cpu_clk;
 	int cpu = smp_processor_id();
 
 	/*
@@ -275,7 +274,7 @@ static int __cpuinit twd_timer_setup(struct clock_event_device *clk)
 	 */
 	if (per_cpu(percpu_setup_called, cpu)) {
 		__raw_writel(0, twd_base + TWD_TIMER_CONTROL);
-		clockevents_register_device(*__this_cpu_ptr(twd_evt));
+		clockevents_register_device(__this_cpu_ptr(twd_evt));
 		enable_percpu_irq(clk->irq, 0);
 		return 0;
 	}
@@ -296,9 +295,7 @@ static int __cpuinit twd_timer_setup(struct clock_event_device *clk)
 	clk->set_mode = twd_set_mode;
 	clk->set_next_event = twd_set_next_event;
 	clk->irq = twd_ppi;
-
-	this_cpu_clk = __this_cpu_ptr(twd_evt);
-	*this_cpu_clk = clk;
+	clk->cpumask = cpumask_of(cpu);
 
 	clockevents_config_and_register(clk, twd_timer_rate,
 					0xf, 0xffffffff);
@@ -307,16 +304,32 @@ static int __cpuinit twd_timer_setup(struct clock_event_device *clk)
 	return 0;
 }
 
-static struct local_timer_ops twd_lt_ops __cpuinitdata = {
-	.setup	= twd_timer_setup,
-	.stop	= twd_timer_stop,
+static int __cpuinit twd_timer_cpu_notify(struct notifier_block *self,
+					   unsigned long action, void *hcpu)
+{
+	struct clock_event_device *evt = this_cpu_ptr(twd_evt);
+
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_STARTING:
+		twd_timer_setup(evt);
+		break;
+	case CPU_DYING:
+		twd_timer_stop(evt);
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
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
@@ -328,10 +341,13 @@ static int __init twd_local_timer_common_register(struct device_node *np)
 		goto out_free;
 	}
 
-	err = local_timer_register(&twd_lt_ops);
+	err = register_cpu_notifier(&twd_timer_cpu_nb);
 	if (err)
 		goto out_irq;
 
+	/* Immediately configure the timer on the boot CPU */
+	twd_timer_setup(this_cpu_ptr(twd_evt));
+
 	twd_get_clock(np);
 
 	return 0;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

