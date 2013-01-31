Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab3AaMLu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:11:50 -0500
Received: from www.linutronix.de ([62.245.132.108]:56036 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858Ab3AaMLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:11:33 -0500
Message-Id: <20130131120743.130169311@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 31 Jan 2013 12:11:31 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 24/40] arm64: Convert generic timers to hotplug state machine
References: <20130131120348.372374706@linutronix.de>
Content-Disposition: inline; filename=arm64-generic-timer-convert.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Straight forward replacement.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/clocksource/arm_generic.c |   40 +++++++++++---------------------------
 include/linux/cpuhotplug.h        |    1 
 2 files changed, 13 insertions(+), 28 deletions(-)

Index: linux-2.6/drivers/clocksource/arm_generic.c
===================================================================
--- linux-2.6.orig/drivers/clocksource/arm_generic.c
+++ linux-2.6/drivers/clocksource/arm_generic.c
@@ -91,8 +91,10 @@ static int arch_timer_set_next_event(uns
 	return 0;
 }
 
-static void __cpuinit arch_timer_setup(struct clock_event_device *clk)
+static int __cpuinit arch_timer_cpu_starting(unsigned int cpu)
 {
+	struct clock_event_device *clk = per_cpu_ptr(&arch_timer_evt, cpu);
+
 	/* Let's make sure the timer is off before doing anything else */
 	arch_timer_stop();
 
@@ -157,34 +159,17 @@ unsigned long long notrace sched_clock(v
 	return arch_counter_get_cntvct() * sched_clock_mult;
 }
 
-static int __cpuinit arch_timer_cpu_notify(struct notifier_block *self,
-					   unsigned long action, void *hcpu)
+
+static int __cpuinit arch_timer_dying_cpu(unsigned int cpu)
 {
-	int cpu = (long)hcpu;
 	struct clock_event_device *clk = per_cpu_ptr(&arch_timer_evt, cpu);
 
-	switch(action) {
-	case CPU_STARTING:
-	case CPU_STARTING_FROZEN:
-		arch_timer_setup(clk);
-		break;
-
-	case CPU_DYING:
-	case CPU_DYING_FROZEN:
-		pr_debug("arch_timer_teardown disable IRQ%d cpu #%d\n",
-			 clk->irq, cpu);
-		disable_percpu_irq(clk->irq);
-		arch_timer_set_mode(CLOCK_EVT_MODE_UNUSED, clk);
-		break;
-	}
-
-	return NOTIFY_OK;
+	pr_debug("arch_timer_teardown disable IRQ%d cpu #%d\n", clk->irq, cpu);
+	disable_percpu_irq(clk->irq);
+	arch_timer_set_mode(CLOCK_EVT_MODE_UNUSED, clk);
+	return 0;
 }
 
-static struct notifier_block __cpuinitdata arch_timer_cpu_nb = {
-	.notifier_call = arch_timer_cpu_notify,
-};
-
 static const struct of_device_id arch_timer_of_match[] __initconst = {
 	{ .compatible = "arm,armv8-timer" },
 	{},
@@ -223,10 +208,9 @@ int __init arm_generic_timer_init(void)
 	/* Calibrate the delay loop directly */
 	lpj_fine = DIV_ROUND_CLOSEST(arch_timer_rate, HZ);
 
-	/* Immediately configure the timer on the boot CPU */
-	arch_timer_setup(this_cpu_ptr(&arch_timer_evt));
-
-	register_cpu_notifier(&arch_timer_cpu_nb);
+	/* Register and immediately configure the timer on the boot CPU */
+	return cpuhp_setup_state(CPUHP_AP_ARM64_TIMER_STARTING,
+				 arch_timer_starting_cpu, arch_timer_dying_cpu);
 
 	return 0;
 }
Index: linux-2.6/include/linux/cpuhotplug.h
===================================================================
--- linux-2.6.orig/include/linux/cpuhotplug.h
+++ linux-2.6/include/linux/cpuhotplug.h
@@ -22,6 +22,7 @@ enum cpuhp_states {
 	CPUHP_AP_PERF_X86_UNCORE_STARTING,
 	CPUHP_AP_PERF_X86_AMD_IBS_STARTING,
 	CPUHP_AP_PERF_X86_STARTING,
+	CPUHP_AP_ARM64_TIMER_STARTING,
 	CPUHP_AP_NOTIFY_STARTING,
 	CPUHP_AP_NOTIFY_DYING,
 	CPUHP_AP_SCHED_MIGRATE_DYING,


