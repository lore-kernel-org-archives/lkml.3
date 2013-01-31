Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab3AaMRi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:17:38 -0500
Received: from www.linutronix.de ([62.245.132.108]:56018 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606Ab3AaMLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:11:31 -0500
Message-Id: <20130131120742.987788095@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 31 Jan 2013 12:11:29 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 22/40] workqueue: Convert to state machine callbacks
References: <20130131120348.372374706@linutronix.de>
Content-Disposition: inline; filename=cpu-hotplug-workqueue-convert.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the prio ordering of the separate notifiers and use a
proper state callback pair.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/cpu.h        |    8 ----
 include/linux/cpuhotplug.h |    7 +++
 kernel/cpu.c               |    8 ++++
 kernel/workqueue.c         |   80 ++++++++++++++++-----------------------------
 4 files changed, 44 insertions(+), 59 deletions(-)

Index: linux-2.6/include/linux/cpu.h
===================================================================
--- linux-2.6.orig/include/linux/cpu.h
+++ linux-2.6/include/linux/cpu.h
@@ -54,14 +54,6 @@ extern ssize_t arch_print_cpu_modalias(s
 				       char *bufptr);
 #endif
 
-/*
- * CPU notifier priorities.
- */
-enum {
-	CPU_PRI_WORKQUEUE_UP	= 5,
-	CPU_PRI_WORKQUEUE_DOWN	= -5,
-};
-
 #define CPU_ONLINE		0x0002 /* CPU (unsigned)v is up */
 #define CPU_UP_PREPARE		0x0003 /* CPU (unsigned)v coming up */
 #define CPU_UP_CANCELED		0x0004 /* CPU (unsigned)v NOT coming up */
Index: linux-2.6/include/linux/cpuhotplug.h
===================================================================
--- linux-2.6.orig/include/linux/cpuhotplug.h
+++ linux-2.6/include/linux/cpuhotplug.h
@@ -11,6 +11,7 @@ enum cpuhp_states {
 	CPUHP_PERF_SUPERH,
 	CPUHP_PERF_PREPARE,
 	CPUHP_SCHED_MIGRATE_PREP,
+	CPUHP_WORKQUEUE_PREP,
 	CPUHP_NOTIFY_PREPARE,
 	CPUHP_NOTIFY_DEAD,
 	CPUHP_SCHED_DEAD,
@@ -29,6 +30,7 @@ enum cpuhp_states {
 	CPUHP_SCHED_ONLINE,
 	CPUHP_PERF_ONLINE,
 	CPUHP_SCHED_MIGRATE_ONLINE,
+	CPUHP_WORKQUEUE_ONLINE,
 	CPUHP_NOTIFY_ONLINE,
 	CPUHP_NOTIFY_DOWN_PREPARE,
 	CPUHP_PERF_X86_UNCORE_ONLINE,
@@ -127,4 +129,9 @@ int perf_event_exit_cpu(unsigned int cpu
 #define perf_event_exit_cpu	NULL
 #endif
 
+/* Workqueue related hotplug events */
+int workqueue_prepare_cpu(unsigned int cpu);
+int workqueue_online_cpu(unsigned int cpu);
+int workqueue_offline_cpu(unsigned int cpu);
+
 #endif
Index: linux-2.6/kernel/cpu.c
===================================================================
--- linux-2.6.orig/kernel/cpu.c
+++ linux-2.6/kernel/cpu.c
@@ -758,6 +758,10 @@ static struct cpuhp_step cpuhp_bp_states
 		.startup = sched_migration_prepare_cpu,
 		.teardown = sched_migration_dead_cpu,
 	},
+	[CPUHP_WORKQUEUE_PREP] = {
+		.startup = workqueue_prepare_cpu,
+		.teardown = NULL,
+	},
 	[CPUHP_NOTIFY_PREPARE] = {
 		.startup = notify_prepare,
 		.teardown = NULL,
@@ -786,6 +790,10 @@ static struct cpuhp_step cpuhp_bp_states
 		.startup = sched_migration_online_cpu,
 		.teardown = NULL,
 	},
+	[CPUHP_WORKQUEUE_ONLINE] = {
+		.startup = workqueue_online_cpu,
+		.teardown = workqueue_offline_cpu,
+	},
 	[CPUHP_NOTIFY_ONLINE] = {
 		.startup = notify_online,
 		.teardown = NULL,
Index: linux-2.6/kernel/workqueue.c
===================================================================
--- linux-2.6.orig/kernel/workqueue.c
+++ linux-2.6/kernel/workqueue.c
@@ -3588,67 +3588,48 @@ static void gcwq_unbind_fn(struct work_s
 		atomic_set(get_pool_nr_running(pool), 0);
 }
 
-/*
- * Workqueues should be brought up before normal priority CPU notifiers.
- * This will be registered high priority CPU notifier.
- */
-static int __cpuinit workqueue_cpu_up_callback(struct notifier_block *nfb,
-					       unsigned long action,
-					       void *hcpu)
+int __cpuinit workqueue_prepare_cpu(unsigned int cpu)
 {
-	unsigned int cpu = (unsigned long)hcpu;
 	struct global_cwq *gcwq = get_gcwq(cpu);
 	struct worker_pool *pool;
 
-	switch (action & ~CPU_TASKS_FROZEN) {
-	case CPU_UP_PREPARE:
-		for_each_worker_pool(pool, gcwq) {
-			struct worker *worker;
-
-			if (pool->nr_workers)
-				continue;
+	for_each_worker_pool(pool, gcwq) {
+		struct worker *worker;
 
-			worker = create_worker(pool);
-			if (!worker)
-				return NOTIFY_BAD;
+		if (pool->nr_workers)
+			continue;
 
-			spin_lock_irq(&gcwq->lock);
-			start_worker(worker);
-			spin_unlock_irq(&gcwq->lock);
-		}
-		break;
+		worker = create_worker(pool);
+		if (!worker)
+			return -ENOMEM;
 
-	case CPU_DOWN_FAILED:
-	case CPU_ONLINE:
-		gcwq_claim_assoc_and_lock(gcwq);
-		gcwq->flags &= ~GCWQ_DISASSOCIATED;
-		rebind_workers(gcwq);
-		gcwq_release_assoc_and_unlock(gcwq);
-		break;
+		spin_lock_irq(&gcwq->lock);
+		start_worker(worker);
+		spin_unlock_irq(&gcwq->lock);
 	}
-	return NOTIFY_OK;
+	return 0;
 }
 
-/*
- * Workqueues should be brought down after normal priority CPU notifiers.
- * This will be registered as low priority CPU notifier.
- */
-static int __cpuinit workqueue_cpu_down_callback(struct notifier_block *nfb,
-						 unsigned long action,
-						 void *hcpu)
+int __cpuinit workqueue_online_cpu(unsigned int cpu)
+{
+	struct global_cwq *gcwq = get_gcwq(cpu);
+
+	gcwq_claim_assoc_and_lock(gcwq);
+	gcwq->flags &= ~GCWQ_DISASSOCIATED;
+	rebind_workers(gcwq);
+	gcwq_release_assoc_and_unlock(gcwq);
+	return 0;
+}
+
+int __cpuinit workqueue_offline_cpu(unsigned int cpu)
 {
-	unsigned int cpu = (unsigned long)hcpu;
 	struct work_struct unbind_work;
 
-	switch (action & ~CPU_TASKS_FROZEN) {
-	case CPU_DOWN_PREPARE:
-		/* unbinding should happen on the local CPU */
-		INIT_WORK_ONSTACK(&unbind_work, gcwq_unbind_fn);
-		queue_work_on(cpu, system_highpri_wq, &unbind_work);
-		flush_work(&unbind_work);
-		break;
-	}
-	return NOTIFY_OK;
+	/* unbinding should happen on the local CPU */
+	INIT_WORK_ONSTACK(&unbind_work, gcwq_unbind_fn);
+	queue_work_on(cpu, system_highpri_wq, &unbind_work);
+	flush_work(&unbind_work);
+	return 0;
 }
 
 #ifdef CONFIG_SMP
@@ -3837,9 +3818,6 @@ static int __init init_workqueues(void)
 	BUILD_BUG_ON((1LU << (BITS_PER_LONG - WORK_OFFQ_CPU_SHIFT)) <
 		     WORK_CPU_LAST);
 
-	cpu_notifier(workqueue_cpu_up_callback, CPU_PRI_WORKQUEUE_UP);
-	hotcpu_notifier(workqueue_cpu_down_callback, CPU_PRI_WORKQUEUE_DOWN);
-
 	/* initialize gcwqs */
 	for_each_gcwq_cpu(cpu) {
 		struct global_cwq *gcwq = get_gcwq(cpu);


