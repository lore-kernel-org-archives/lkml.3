Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab3AaMOD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:14:03 -0500
Received: from www.linutronix.de ([62.245.132.108]:56148 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270Ab3AaMLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:11:42 -0500
Message-Id: <20130131120743.858099613@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 31 Jan 2013 12:11:40 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>,
        Richard Weinberger <richard@nod.at>
Subject: [patch 35/40] timers: Convert to hotplug state machine
References: <20130131120348.372374706@linutronix.de>
Content-Disposition: inline; filename=0001-cpu-hotplug-convert-timers.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Weinberger <richard@nod.at>

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/cpuhotplug.h |    4 ++++
 kernel/cpu.c               |    4 ++++
 kernel/timer.c             |   43 +++++--------------------------------------
 3 files changed, 13 insertions(+), 38 deletions(-)

Index: linux-2.6/include/linux/cpuhotplug.h
===================================================================
--- linux-2.6.orig/include/linux/cpuhotplug.h
+++ linux-2.6/include/linux/cpuhotplug.h
@@ -14,6 +14,7 @@ enum cpuhp_states {
 	CPUHP_WORKQUEUE_PREP,
 	CPUHP_RCUTREE_PREPARE,
 	CPUHP_HRTIMERS_PREPARE,
+	CPUHP_TIMERS_PREPARE,
 	CPUHP_NOTIFY_PREPARE,
 	CPUHP_NOTIFY_DEAD,
 	CPUHP_CLOCKEVENTS_DEAD,
@@ -176,10 +177,13 @@ int clockevents_dead_cpu(unsigned int cp
 #endif
 
 int hrtimers_prepare_cpu(unsigned int cpu);
+int timers_prepare_cpu(unsigned int cpu);
 #ifdef CONFIG_HOTPLUG_CPU
 int hrtimers_dead_cpu(unsigned int cpu);
+int timers_dead_cpu(unsigned int cpu);
 #else
 #define hrtimers_dead_cpu	NULL
+#define timers_dead_cpu		NULL
 #endif
 
 #endif
Index: linux-2.6/kernel/cpu.c
===================================================================
--- linux-2.6.orig/kernel/cpu.c
+++ linux-2.6/kernel/cpu.c
@@ -756,6 +756,10 @@ static struct cpuhp_step cpuhp_bp_states
 		.startup = hrtimers_prepare_cpu,
 		.teardown = hrtimers_dead_cpu,
 	},
+	[CPUHP_TIMERS_PREPARE] = {
+		.startup = timers_prepare_cpu,
+		.teardown = timers_dead_cpu,
+	},
 	[CPUHP_NOTIFY_PREPARE] = {
 		.startup = notify_prepare,
 		.teardown = NULL,
Index: linux-2.6/kernel/timer.c
===================================================================
--- linux-2.6.orig/kernel/timer.c
+++ linux-2.6/kernel/timer.c
@@ -1642,7 +1642,7 @@ SYSCALL_DEFINE1(sysinfo, struct sysinfo 
 	return 0;
 }
 
-static int __cpuinit init_timers_cpu(int cpu)
+int __cpuinit timers_prepare_cpu(unsigned int cpu)
 {
 	int j;
 	struct tvec_base *base;
@@ -1714,7 +1714,7 @@ static void migrate_timer_list(struct tv
 	}
 }
 
-static void __cpuinit migrate_timers(int cpu)
+int __cpuinit timers_dead_cpu(unsigned int cpu)
 {
 	struct tvec_base *old_base;
 	struct tvec_base *new_base;
@@ -1744,52 +1744,19 @@ static void __cpuinit migrate_timers(int
 	spin_unlock(&old_base->lock);
 	spin_unlock_irq(&new_base->lock);
 	put_cpu_var(tvec_bases);
-}
-#endif /* CONFIG_HOTPLUG_CPU */
-
-static int __cpuinit timer_cpu_notify(struct notifier_block *self,
-				unsigned long action, void *hcpu)
-{
-	long cpu = (long)hcpu;
-	int err;
 
-	switch(action) {
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
-		err = init_timers_cpu(cpu);
-		if (err < 0)
-			return notifier_from_errno(err);
-		break;
-#ifdef CONFIG_HOTPLUG_CPU
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
-		migrate_timers(cpu);
-		break;
-#endif
-	default:
-		break;
-	}
-	return NOTIFY_OK;
+	return 0;
 }
-
-static struct notifier_block __cpuinitdata timers_nb = {
-	.notifier_call	= timer_cpu_notify,
-};
-
+#endif /* CONFIG_HOTPLUG_CPU */
 
 void __init init_timers(void)
 {
-	int err;
-
 	/* ensure there are enough low bits for flags in timer->base pointer */
 	BUILD_BUG_ON(__alignof__(struct tvec_base) & TIMER_FLAG_MASK);
 
-	err = timer_cpu_notify(&timers_nb, (unsigned long)CPU_UP_PREPARE,
-			       (void *)(long)smp_processor_id());
 	init_timer_stats();
+	BUG_ON(timers_prepare_cpu(smp_processor_id()));
 
-	BUG_ON(err != NOTIFY_OK);
-	register_cpu_notifier(&timers_nb);
 	open_softirq(TIMER_SOFTIRQ, run_timer_softirq);
 }
 


