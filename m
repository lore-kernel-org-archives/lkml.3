Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab3AaMPw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:15:52 -0500
Received: from www.linutronix.de ([62.245.132.108]:56109 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab3AaMLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:11:38 -0500
Message-Id: <20130131120743.596323286@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 31 Jan 2013 12:11:37 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 31/40] sched: Convert fair nohz balancer to hotplug state
 machine
References: <20130131120348.372374706@linutronix.de>
Content-Disposition: inline;
 filename=cpuhotplug-sched-convert-fair-nohz-balancer.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Straight forward conversion which leaves the question whether this
couldn't be combined with already existing infrastructure in the
scheduler instead of having an extra state.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/cpuhotplug.h |    6 ++++++
 kernel/cpu.c               |    4 ++++
 kernel/sched/fair.c        |   16 ++--------------
 3 files changed, 12 insertions(+), 14 deletions(-)

Index: linux-2.6/include/linux/cpuhotplug.h
===================================================================
--- linux-2.6.orig/include/linux/cpuhotplug.h
+++ linux-2.6/include/linux/cpuhotplug.h
@@ -29,6 +29,7 @@ enum cpuhp_states {
 	CPUHP_AP_NOTIFY_DYING,
 	CPUHP_AP_X86_TBOOT_DYING,
 	CPUHP_AP_S390_VTIME_DYING,
+	CPUHP_AP_SCHED_NOHZ_DYING,
 	CPUHP_AP_SCHED_MIGRATE_DYING,
 	CPUHP_AP_MAX,
 	CPUHP_TEARDOWN_CPU,
@@ -126,6 +127,11 @@ int sched_migration_dead_cpu(unsigned in
 #define sched_migration_dying_cpu	NULL
 #define sched_migration_dead_cpu	NULL
 #endif
+#if defined(CONFIG_NO_HZ)
+int nohz_balance_exit_idle(unsigned int cpu);
+#else
+#define nohz_balance_exit_idle		NULL
+#endif
 
  /* Performance counter hotplug functions */
 #ifdef CONFIG_PERF_EVENTS
Index: linux-2.6/kernel/cpu.c
===================================================================
--- linux-2.6.orig/kernel/cpu.c
+++ linux-2.6/kernel/cpu.c
@@ -813,6 +813,10 @@ static struct cpuhp_step cpuhp_ap_states
 		.startup = NULL,
 		.teardown = notify_dying,
 	},
+	[CPUHP_AP_SCHED_NOHZ_DYING] = {
+		.startup = NULL,
+		.teardown = nohz_balance_exit_idle,
+	},
 	[CPUHP_AP_SCHED_MIGRATE_DYING] = {
 		.startup = NULL,
 		.teardown = sched_migration_dying_cpu,
Index: linux-2.6/kernel/sched/fair.c
===================================================================
--- linux-2.6.orig/kernel/sched/fair.c
+++ linux-2.6/kernel/sched/fair.c
@@ -5390,13 +5390,14 @@ static void nohz_balancer_kick(int cpu)
 	return;
 }
 
-static inline void nohz_balance_exit_idle(int cpu)
+int nohz_balance_exit_idle(unsigned int cpu)
 {
 	if (unlikely(test_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu)))) {
 		cpumask_clear_cpu(cpu, nohz.idle_cpus_mask);
 		atomic_dec(&nohz.nr_cpus);
 		clear_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu));
 	}
+	return 0;
 }
 
 static inline void set_cpu_sd_state_busy(void)
@@ -5448,18 +5449,6 @@ void nohz_balance_enter_idle(int cpu)
 	atomic_inc(&nohz.nr_cpus);
 	set_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu));
 }
-
-static int __cpuinit sched_ilb_notifier(struct notifier_block *nfb,
-					unsigned long action, void *hcpu)
-{
-	switch (action & ~CPU_TASKS_FROZEN) {
-	case CPU_DYING:
-		nohz_balance_exit_idle(smp_processor_id());
-		return NOTIFY_OK;
-	default:
-		return NOTIFY_DONE;
-	}
-}
 #endif
 
 static DEFINE_SPINLOCK(balancing);
@@ -6167,7 +6156,6 @@ __init void init_sched_fair_class(void)
 #ifdef CONFIG_NO_HZ
 	nohz.next_balance = jiffies;
 	zalloc_cpumask_var(&nohz.idle_cpus_mask, GFP_NOWAIT);
-	cpu_notifier(sched_ilb_notifier, 0);
 #endif
 #endif /* SMP */
 


