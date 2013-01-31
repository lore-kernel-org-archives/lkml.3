Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab3AaMRl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:17:41 -0500
Received: from www.linutronix.de ([62.245.132.108]:56008 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab3AaMLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:11:30 -0500
Message-Id: <20130131120742.927310907@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 31 Jan 2013 12:11:28 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 21/40] sched: Convert the migration callback to hotplug states
References: <20130131120348.372374706@linutronix.de>
Content-Disposition: inline; filename=cpuhotplug-sched-convert-migration.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not clear why the ordering needs to be this way, but for the time
being we just keep the current working state. Want's to be revisited.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/cpu.h        |    2 
 include/linux/cpuhotplug.h |   12 +++++
 kernel/cpu.c               |   12 +++++
 kernel/sched/core.c        |  103 +++++++++++++++++++--------------------------
 4 files changed, 68 insertions(+), 61 deletions(-)

Index: linux-2.6/include/linux/cpu.h
===================================================================
--- linux-2.6.orig/include/linux/cpu.h
+++ linux-2.6/include/linux/cpu.h
@@ -58,8 +58,6 @@ extern ssize_t arch_print_cpu_modalias(s
  * CPU notifier priorities.
  */
 enum {
-	CPU_PRI_MIGRATION	= 10,
-	/* bring up workqueues before normal notifiers and down after */
 	CPU_PRI_WORKQUEUE_UP	= 5,
 	CPU_PRI_WORKQUEUE_DOWN	= -5,
 };
Index: linux-2.6/include/linux/cpuhotplug.h
===================================================================
--- linux-2.6.orig/include/linux/cpuhotplug.h
+++ linux-2.6/include/linux/cpuhotplug.h
@@ -10,6 +10,7 @@ enum cpuhp_states {
 	CPUHP_PERF_POWER,
 	CPUHP_PERF_SUPERH,
 	CPUHP_PERF_PREPARE,
+	CPUHP_SCHED_MIGRATE_PREP,
 	CPUHP_NOTIFY_PREPARE,
 	CPUHP_NOTIFY_DEAD,
 	CPUHP_SCHED_DEAD,
@@ -21,11 +22,13 @@ enum cpuhp_states {
 	CPUHP_AP_PERF_X86_STARTING,
 	CPUHP_AP_NOTIFY_STARTING,
 	CPUHP_AP_NOTIFY_DYING,
+	CPUHP_AP_SCHED_MIGRATE_DYING,
 	CPUHP_AP_MAX,
 	CPUHP_TEARDOWN_CPU,
 	CPUHP_PERCPU_THREADS,
 	CPUHP_SCHED_ONLINE,
 	CPUHP_PERF_ONLINE,
+	CPUHP_SCHED_MIGRATE_ONLINE,
 	CPUHP_NOTIFY_ONLINE,
 	CPUHP_NOTIFY_DOWN_PREPARE,
 	CPUHP_PERF_X86_UNCORE_ONLINE,
@@ -105,6 +108,15 @@ static inline void cpuhp_remove_state_no
 
 /* Compiled in scheduler hotplug functions */
 int sched_starting_cpu(unsigned int cpu);
+int sched_migration_prepare_cpu(unsigned int cpu);
+int sched_migration_online_cpu(unsigned int cpu);
+#ifdef CONFIG_HOTPLUG_CPU
+int sched_migration_dying_cpu(unsigned int cpu);
+int sched_migration_dead_cpu(unsigned int cpu);
+#else
+#define sched_migration_dying_cpu	NULL
+#define sched_migration_dead_cpu	NULL
+#endif
 
  /* Performance counter hotplug functions */
 #ifdef CONFIG_PERF_EVENTS
Index: linux-2.6/kernel/cpu.c
===================================================================
--- linux-2.6.orig/kernel/cpu.c
+++ linux-2.6/kernel/cpu.c
@@ -754,6 +754,10 @@ static struct cpuhp_step cpuhp_bp_states
 		.startup = perf_event_init_cpu,
 		.teardown = perf_event_exit_cpu,
 	},
+	[CPUHP_SCHED_MIGRATE_PREP] = {
+		.startup = sched_migration_prepare_cpu,
+		.teardown = sched_migration_dead_cpu,
+	},
 	[CPUHP_NOTIFY_PREPARE] = {
 		.startup = notify_prepare,
 		.teardown = NULL,
@@ -778,6 +782,10 @@ static struct cpuhp_step cpuhp_bp_states
 		.startup = perf_event_init_cpu,
 		.teardown = perf_event_exit_cpu,
 	},
+	[CPUHP_SCHED_MIGRATE_ONLINE] = {
+		.startup = sched_migration_online_cpu,
+		.teardown = NULL,
+	},
 	[CPUHP_NOTIFY_ONLINE] = {
 		.startup = notify_online,
 		.teardown = NULL,
@@ -808,6 +816,10 @@ static struct cpuhp_step cpuhp_ap_states
 		.startup = NULL,
 		.teardown = notify_dying,
 	},
+	[CPUHP_AP_SCHED_MIGRATE_DYING] = {
+		.startup = NULL,
+		.teardown = sched_migration_dying_cpu,
+	},
 #endif
 	[CPUHP_MAX] = {
 		.startup = NULL,
Index: linux-2.6/kernel/sched/core.c
===================================================================
--- linux-2.6.orig/kernel/sched/core.c
+++ linux-2.6/kernel/sched/core.c
@@ -5104,80 +5104,65 @@ static void set_rq_offline(struct rq *rq
 	}
 }
 
-/*
- * migration_call - callback that gets triggered when a CPU is added.
- * Here we can start up the necessary migration thread for the new CPU.
- */
-static int __cpuinit
-migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
+int __cpuinit sched_migration_prepare_cpu(unsigned int cpu)
 {
-	int cpu = (long)hcpu;
-	unsigned long flags;
 	struct rq *rq = cpu_rq(cpu);
 
-	switch (action & ~CPU_TASKS_FROZEN) {
-
-	case CPU_UP_PREPARE:
-		rq->calc_load_update = calc_load_update;
-		break;
+	rq->calc_load_update = calc_load_update;
+	update_max_interval();
+	return 0;
+}
 
-	case CPU_ONLINE:
-		/* Update our root-domain */
-		raw_spin_lock_irqsave(&rq->lock, flags);
-		if (rq->rd) {
-			BUG_ON(!cpumask_test_cpu(cpu, rq->rd->span));
+int __cpuinit sched_migration_online_cpu(unsigned int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	unsigned long flags;
 
-			set_rq_online(rq);
-		}
-		raw_spin_unlock_irqrestore(&rq->lock, flags);
-		break;
+	/* Update our root-domain */
+	raw_spin_lock_irqsave(&rq->lock, flags);
+	if (rq->rd) {
+		BUG_ON(!cpumask_test_cpu(cpu, rq->rd->span));
+		set_rq_online(rq);
+	}
+	raw_spin_unlock_irqrestore(&rq->lock, flags);
+	update_max_interval();
+	return 0;
+}
 
 #ifdef CONFIG_HOTPLUG_CPU
-	case CPU_DYING:
-		sched_ttwu_pending();
-		/* Update our root-domain */
-		raw_spin_lock_irqsave(&rq->lock, flags);
-		if (rq->rd) {
-			BUG_ON(!cpumask_test_cpu(cpu, rq->rd->span));
-			set_rq_offline(rq);
-		}
-		migrate_tasks(cpu);
-		BUG_ON(rq->nr_running != 1); /* the migration thread */
-		raw_spin_unlock_irqrestore(&rq->lock, flags);
-		break;
+int __cpuinit sched_migration_dying_cpu(unsigned int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	unsigned long flags;
 
-	case CPU_DEAD:
-		calc_load_migrate(rq);
-		break;
-#endif
+	sched_ttwu_pending();
+	/* Update our root-domain */
+	raw_spin_lock_irqsave(&rq->lock, flags);
+	if (rq->rd) {
+		BUG_ON(!cpumask_test_cpu(cpu, rq->rd->span));
+		set_rq_offline(rq);
 	}
-
+	migrate_tasks(cpu);
+	BUG_ON(rq->nr_running != 1); /* the migration thread */
+	raw_spin_unlock_irqrestore(&rq->lock, flags);
 	update_max_interval();
-
-	return NOTIFY_OK;
+	return 0;
 }
 
-/*
- * Register at high priority so that task migration (migrate_all_tasks)
- * happens before everything else.  This has to be lower priority than
- * the notifier in the perf_event subsystem, though.
- */
-static struct notifier_block __cpuinitdata migration_notifier = {
-	.notifier_call = migration_call,
-	.priority = CPU_PRI_MIGRATION,
-};
-
-static int __init migration_init(void)
+int __cpuinit sched_migration_dead_cpu(unsigned int cpu)
 {
-	void *cpu = (void *)(long)smp_processor_id();
-	int err;
+	struct rq *rq = cpu_rq(cpu);
 
-	/* Initialize migration for the boot CPU */
-	err = migration_call(&migration_notifier, CPU_UP_PREPARE, cpu);
-	BUG_ON(err == NOTIFY_BAD);
-	migration_call(&migration_notifier, CPU_ONLINE, cpu);
-	register_cpu_notifier(&migration_notifier);
+	calc_load_migrate(rq);
+	update_max_interval();
+	return 0;
+}
+#endif
 
+static int __init migration_init(void)
+{
+	sched_migration_prepare_cpu(smp_processor_id());
+	sched_migration_online_cpu(smp_processor_id());
 	return 0;
 }
 early_initcall(migration_init);


