Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab3AaMOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:14:51 -0500
Received: from www.linutronix.de ([62.245.132.108]:56130 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab3AaMLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:11:40 -0500
Message-Id: <20130131120743.715755822@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 31 Jan 2013 12:11:38 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 33/40] hrtimer: Convert to hotplug state machine
References: <20130131120348.372374706@linutronix.de>
Content-Disposition: inline; filename=hrtimer-convert-to-statemachine.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split out the clockevents callbacks instead of piggypacking them on
hrtimers.

This gets rid of a POST_DEAD user. See commit 54e88fad. We just move
the callback state to the proper place in the state machine.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/cpuhotplug.h |   18 +++++++++++++++++
 kernel/cpu.c               |   12 +++++++++++
 kernel/hrtimer.c           |   47 ++++-----------------------------------------
 kernel/time/clockevents.c  |   13 ++++++++++++
 4 files changed, 48 insertions(+), 42 deletions(-)

Index: linux-2.6/include/linux/cpuhotplug.h
===================================================================
--- linux-2.6.orig/include/linux/cpuhotplug.h
+++ linux-2.6/include/linux/cpuhotplug.h
@@ -13,8 +13,10 @@ enum cpuhp_states {
 	CPUHP_SCHED_MIGRATE_PREP,
 	CPUHP_WORKQUEUE_PREP,
 	CPUHP_RCUTREE_PREPARE,
+	CPUHP_HRTIMERS_PREPARE,
 	CPUHP_NOTIFY_PREPARE,
 	CPUHP_NOTIFY_DEAD,
+	CPUHP_CLOCKEVENTS_DEAD,
 	CPUHP_CPUFREQ_DEAD,
 	CPUHP_SCHED_DEAD,
 	CPUHP_BRINGUP_CPU,
@@ -28,6 +30,7 @@ enum cpuhp_states {
 	CPUHP_AP_ARM64_TIMER_STARTING,
 	CPUHP_AP_KVM_STARTING,
 	CPUHP_AP_NOTIFY_DYING,
+	CPUHP_AP_CLOCKEVENTS_DYING,
 	CPUHP_AP_RCUTREE_DYING,
 	CPUHP_AP_X86_TBOOT_DYING,
 	CPUHP_AP_S390_VTIME_DYING,
@@ -165,4 +168,19 @@ int rcutree_dying_cpu(unsigned int cpu);
 #define rcutree_dying_cpu	NULL
 #endif
 
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+int clockevents_dying_cpu(unsigned int cpu);
+int clockevents_dead_cpu(unsigned int cpu);
+#else
+#define clockevents_dying_cpu	NULL
+#define clockevents_dead_cpu	NULL
+#endif
+
+int hrtimers_prepare_cpu(unsigned int cpu);
+#ifdef CONFIG_HOTPLUG_CPU
+int hrtimers_dead_cpu(unsigned int cpu);
+#else
+#define hrtimers_dead_cpu	NULL
+#endif
+
 #endif
Index: linux-2.6/kernel/cpu.c
===================================================================
--- linux-2.6.orig/kernel/cpu.c
+++ linux-2.6/kernel/cpu.c
@@ -759,6 +759,10 @@ static struct cpuhp_step cpuhp_bp_states
 		.startup = rcutree_prepare_cpu,
 		.teardown = rcutree_dead_cpu,
 	},
+	[CPUHP_HRTIMERS_PREPARE] = {
+		.startup = hrtimers_prepare_cpu,
+		.teardown = hrtimers_dead_cpu,
+	},
 	[CPUHP_NOTIFY_PREPARE] = {
 		.startup = notify_prepare,
 		.teardown = NULL,
@@ -767,6 +771,10 @@ static struct cpuhp_step cpuhp_bp_states
 		.startup = NULL,
 		.teardown = notify_dead,
 	},
+	[CPUHP_CLOCKEVENTS_DEAD] = {
+		.startup = NULL,
+		.teardown = clockevents_dead_cpu,
+	},
 	[CPUHP_BRINGUP_CPU] = {
 		.startup = bringup_cpu,
 		.teardown = NULL,
@@ -821,6 +829,10 @@ static struct cpuhp_step cpuhp_ap_states
 		.startup = NULL,
 		.teardown = notify_dying,
 	},
+	[CPUHP_AP_CLOCKEVENTS_DYING] = {
+		.startup = NULL,
+		.teardown = clockevents_dying_cpu,
+	},
 	[CPUHP_AP_RCUTREE_DYING] = {
 		.startup = NULL,
 		.teardown = rcutree_dying_cpu,
Index: linux-2.6/kernel/hrtimer.c
===================================================================
--- linux-2.6.orig/kernel/hrtimer.c
+++ linux-2.6/kernel/hrtimer.c
@@ -1635,7 +1635,7 @@ SYSCALL_DEFINE2(nanosleep, struct timesp
 /*
  * Functions related to boot-time initialization:
  */
-static void __cpuinit init_hrtimers_cpu(int cpu)
+int __cpuinit hrtimers_prepare_cpu(unsigned int cpu)
 {
 	struct hrtimer_cpu_base *cpu_base = &per_cpu(hrtimer_bases, cpu);
 	int i;
@@ -1648,6 +1648,7 @@ static void __cpuinit init_hrtimers_cpu(
 	}
 
 	hrtimer_init_hres(cpu_base);
+	return 0;
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -1685,7 +1686,7 @@ static void migrate_hrtimer_list(struct 
 	}
 }
 
-static void migrate_hrtimers(int scpu)
+int __cpuinit hrtimers_dead_cpu(unsigned int scpu)
 {
 	struct hrtimer_cpu_base *old_base, *new_base;
 	int i;
@@ -1714,52 +1715,14 @@ static void migrate_hrtimers(int scpu)
 	/* Check, if we got expired work to do */
 	__hrtimer_peek_ahead_timers();
 	local_irq_enable();
+	return 0;
 }
 
 #endif /* CONFIG_HOTPLUG_CPU */
 
-static int __cpuinit hrtimer_cpu_notify(struct notifier_block *self,
-					unsigned long action, void *hcpu)
-{
-	int scpu = (long)hcpu;
-
-	switch (action) {
-
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
-		init_hrtimers_cpu(scpu);
-		break;
-
-#ifdef CONFIG_HOTPLUG_CPU
-	case CPU_DYING:
-	case CPU_DYING_FROZEN:
-		clockevents_notify(CLOCK_EVT_NOTIFY_CPU_DYING, &scpu);
-		break;
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
-	{
-		clockevents_notify(CLOCK_EVT_NOTIFY_CPU_DEAD, &scpu);
-		migrate_hrtimers(scpu);
-		break;
-	}
-#endif
-
-	default:
-		break;
-	}
-
-	return NOTIFY_OK;
-}
-
-static struct notifier_block __cpuinitdata hrtimers_nb = {
-	.notifier_call = hrtimer_cpu_notify,
-};
-
 void __init hrtimers_init(void)
 {
-	hrtimer_cpu_notify(&hrtimers_nb, (unsigned long)CPU_UP_PREPARE,
-			  (void *)(long)smp_processor_id());
-	register_cpu_notifier(&hrtimers_nb);
+	hrtimers_prepare_cpu(smp_processor_id());
 #ifdef CONFIG_HIGH_RES_TIMERS
 	open_softirq(HRTIMER_SOFTIRQ, run_hrtimer_softirq);
 #endif
Index: linux-2.6/kernel/time/clockevents.c
===================================================================
--- linux-2.6.orig/kernel/time/clockevents.c
+++ linux-2.6/kernel/time/clockevents.c
@@ -461,4 +461,17 @@ void clockevents_notify(unsigned long re
 	raw_spin_unlock_irqrestore(&clockevents_lock, flags);
 }
 EXPORT_SYMBOL_GPL(clockevents_notify);
+
+int __cpuinit clockevents_dying_cpu(unsigned int cpu)
+{
+	clockevents_notify(CLOCK_EVT_NOTIFY_CPU_DYING, &cpu);
+	return 0;
+}
+
+int __cpuinit clockevents_dead_cpu(unsigned int cpu)
+{
+	clockevents_notify(CLOCK_EVT_NOTIFY_CPU_DEAD, &cpu);
+	return 0;
+}
+
 #endif


