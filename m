Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab3AaMTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:19:46 -0500
Received: from www.linutronix.de ([62.245.132.108]:55922 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab3AaMLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:11:24 -0500
Message-Id: <20130131120742.378274339@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 31 Jan 2013 12:11:22 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 13/40] perf: Convert to hotplug state machine
References: <20130131120348.372374706@linutronix.de>
Content-Disposition: inline; filename=cpuhotplug-perf-core-convert.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually a nice symetric startup/teardown pair which fits proper in
the state machine concept. In the long run we should be able to invoke
the startup callback for the boot cpu via the state machine and get
rid of the init function which invokes it on the boot cpu.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/cpuhotplug.h |   11 +++++++++++
 kernel/cpu.c               |    8 ++++++++
 kernel/events/core.c       |   36 +++++++-----------------------------
 3 files changed, 26 insertions(+), 29 deletions(-)

Index: linux-2.6/include/linux/cpuhotplug.h
===================================================================
--- linux-2.6.orig/include/linux/cpuhotplug.h
+++ linux-2.6/include/linux/cpuhotplug.h
@@ -5,6 +5,7 @@ enum cpuhp_states {
 	CPUHP_OFFLINE,
 	CPUHP_CREATE_THREADS,
 	CPUHP_PERF_X86_UNCORE_PREP,
+	CPUHP_PERF_PREPARE,
 	CPUHP_NOTIFY_PREPARE,
 	CPUHP_NOTIFY_DEAD,
 	CPUHP_SCHED_DEAD,
@@ -18,6 +19,7 @@ enum cpuhp_states {
 	CPUHP_TEARDOWN_CPU,
 	CPUHP_PERCPU_THREADS,
 	CPUHP_SCHED_ONLINE,
+	CPUHP_PERF_ONLINE,
 	CPUHP_NOTIFY_ONLINE,
 	CPUHP_NOTIFY_DOWN_PREPARE,
 	CPUHP_PERF_X86_UNCORE_ONLINE,
@@ -96,4 +98,13 @@ static inline void cpuhp_remove_state_no
 /* Compiled in scheduler hotplug functions */
 int sched_starting_cpu(unsigned int cpu);
 
+ /* Performance counter hotplug functions */
+#ifdef CONFIG_PERF_EVENTS
+int perf_event_init_cpu(unsigned int cpu);
+int perf_event_exit_cpu(unsigned int cpu);
+#else
+#define perf_event_init_cpu	NULL
+#define perf_event_exit_cpu	NULL
+#endif
+
 #endif
Index: linux-2.6/kernel/cpu.c
===================================================================
--- linux-2.6.orig/kernel/cpu.c
+++ linux-2.6/kernel/cpu.c
@@ -750,6 +750,10 @@ static struct cpuhp_step cpuhp_bp_states
 		.startup = smpboot_create_threads,
 		.teardown = NULL,
 	},
+	[CPUHP_PERF_PREPARE] = {
+		.startup = perf_event_init_cpu,
+		.teardown = perf_event_exit_cpu,
+	},
 	[CPUHP_NOTIFY_PREPARE] = {
 		.startup = notify_prepare,
 		.teardown = NULL,
@@ -770,6 +774,10 @@ static struct cpuhp_step cpuhp_bp_states
 		.startup = smpboot_unpark_threads,
 		.teardown = smpboot_park_threads,
 	},
+	[CPUHP_PERF_ONLINE] = {
+		.startup = perf_event_init_cpu,
+		.teardown = perf_event_exit_cpu,
+	},
 	[CPUHP_NOTIFY_ONLINE] = {
 		.startup = notify_online,
 		.teardown = NULL,
Index: linux-2.6/kernel/events/core.c
===================================================================
--- linux-2.6.orig/kernel/events/core.c
+++ linux-2.6/kernel/events/core.c
@@ -5261,7 +5261,7 @@ static int swevent_hlist_get_cpu(struct 
 	if (!swevent_hlist_deref(swhash) && cpu_online(cpu)) {
 		struct swevent_hlist *hlist;
 
-		hlist = kzalloc(sizeof(*hlist), GFP_KERNEL);
+		hlist = kzalloc_node(sizeof(*hlist), GFP_KERNEL, cpu_to_node(cpu));
 		if (!hlist) {
 			err = -ENOMEM;
 			goto exit;
@@ -7263,12 +7263,12 @@ static void __init perf_event_init_all_c
 	}
 }
 
-static void __cpuinit perf_event_init_cpu(int cpu)
+int __cpuinit perf_event_init_cpu(unsigned int cpu)
 {
 	struct swevent_htable *swhash = &per_cpu(swevent_htable, cpu);
 
 	mutex_lock(&swhash->hlist_mutex);
-	if (swhash->hlist_refcount > 0) {
+	if (swhash->hlist_refcount > 0 && !swevent_hlist_deref(swhash)) {
 		struct swevent_hlist *hlist;
 
 		hlist = kzalloc_node(sizeof(*hlist), GFP_KERNEL, cpu_to_node(cpu));
@@ -7276,6 +7276,7 @@ static void __cpuinit perf_event_init_cp
 		rcu_assign_pointer(swhash->swevent_hlist, hlist);
 	}
 	mutex_unlock(&swhash->hlist_mutex);
+	return 0;
 }
 
 #if defined CONFIG_HOTPLUG_CPU || defined CONFIG_KEXEC
@@ -7318,7 +7319,7 @@ static void perf_event_exit_cpu_context(
 	srcu_read_unlock(&pmus_srcu, idx);
 }
 
-static void perf_event_exit_cpu(int cpu)
+int perf_event_exit_cpu(unsigned int cpu)
 {
 	struct swevent_htable *swhash = &per_cpu(swevent_htable, cpu);
 
@@ -7327,6 +7328,7 @@ static void perf_event_exit_cpu(int cpu)
 	mutex_unlock(&swhash->hlist_mutex);
 
 	perf_event_exit_cpu_context(cpu);
+	return 0;
 }
 #else
 static inline void perf_event_exit_cpu(int cpu) { }
@@ -7352,30 +7354,6 @@ static struct notifier_block perf_reboot
 	.priority = INT_MIN,
 };
 
-static int __cpuinit
-perf_cpu_notify(struct notifier_block *self, unsigned long action, void *hcpu)
-{
-	unsigned int cpu = (long)hcpu;
-
-	switch (action & ~CPU_TASKS_FROZEN) {
-
-	case CPU_UP_PREPARE:
-	case CPU_DOWN_FAILED:
-		perf_event_init_cpu(cpu);
-		break;
-
-	case CPU_UP_CANCELED:
-	case CPU_DOWN_PREPARE:
-		perf_event_exit_cpu(cpu);
-		break;
-
-	default:
-		break;
-	}
-
-	return NOTIFY_OK;
-}
-
 void __init perf_event_init(void)
 {
 	int ret;
@@ -7388,7 +7366,7 @@ void __init perf_event_init(void)
 	perf_pmu_register(&perf_cpu_clock, NULL, -1);
 	perf_pmu_register(&perf_task_clock, NULL, -1);
 	perf_tp_register();
-	perf_cpu_notifier(perf_cpu_notify);
+	perf_event_init_cpu(smp_processor_id());
 	register_reboot_notifier(&perf_reboot_notifier);
 
 	ret = init_hw_breakpoint();


