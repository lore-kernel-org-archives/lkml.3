Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab3AaMMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:12:00 -0500
Received: from www.linutronix.de ([62.245.132.108]:56205 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab3AaMLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:11:46 -0500
Message-Id: <20130131120744.178732956@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 31 Jan 2013 12:11:44 -0000
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
Subject: [patch 40/40] slab: Convert to hotplug state machine
References: <20130131120348.372374706@linutronix.de>
Content-Disposition: inline; filename=0006-cpu-hotplug-convert-slab.patch
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
 include/linux/cpuhotplug.h |   15 ++++++
 kernel/cpu.c               |    8 +++
 mm/slab.c                  |  102 ++++++++++++++++++---------------------------
 3 files changed, 64 insertions(+), 61 deletions(-)

Index: linux-2.6/include/linux/cpuhotplug.h
===================================================================
--- linux-2.6.orig/include/linux/cpuhotplug.h
+++ linux-2.6/include/linux/cpuhotplug.h
@@ -19,6 +19,7 @@ enum cpuhp_states {
 	CPUHP_X2APIC_PREPARE,
 	CPUHP_SMPCFD_PREPARE,
 	CPUHP_RELAY_PREPARE,
+	CPUHP_SLAB_PREPARE,
 	CPUHP_NOTIFY_PREPARE,
 	CPUHP_NOTIFY_DEAD,
 	CPUHP_CLOCKEVENTS_DEAD,
@@ -49,6 +50,7 @@ enum cpuhp_states {
 	CPUHP_WORKQUEUE_ONLINE,
 	CPUHP_CPUFREQ_ONLINE,
 	CPUHP_RCUTREE_ONLINE,
+	CPUHP_SLAB_ONLINE,
 	CPUHP_NOTIFY_ONLINE,
 	CPUHP_PROFILE_ONLINE,
 	CPUHP_NOTIFY_DOWN_PREPARE,
@@ -211,4 +213,17 @@ int relay_prepare_cpu(unsigned int cpu);
 #define relay_prepare_cpu	NULL
 #endif
 
+/* slab hotplug events */
+#if defined(CONFIG_SLAB) && defined(CONFIG_SMP)
+int slab_prepare_cpu(unsigned int cpu);
+int slab_online_cpu(unsigned int cpu);
+int slab_offline_cpu(unsigned int cpu);
+int slab_dead_cpu(unsigned int cpu);
+#else
+#define slab_prepare_cpu	NULL
+#define slab_online_cpu		NULL
+#define slab_offline_cpu	NULL
+#define slab_dead_cpu		NULL
+#endif
+
 #endif
Index: linux-2.6/kernel/cpu.c
===================================================================
--- linux-2.6.orig/kernel/cpu.c
+++ linux-2.6/kernel/cpu.c
@@ -772,6 +772,10 @@ static struct cpuhp_step cpuhp_bp_states
 		.startup = relay_prepare_cpu,
 		.teardown = NULL,
 	},
+	[CPUHP_SLAB_PREPARE] = {
+		.startup = slab_prepare_cpu,
+		.teardown = slab_dead_cpu,
+	},
 	[CPUHP_NOTIFY_PREPARE] = {
 		.startup = notify_prepare,
 		.teardown = NULL,
@@ -820,6 +824,10 @@ static struct cpuhp_step cpuhp_bp_states
 		.startup = profile_online_cpu,
 		.teardown = NULL,
 	},
+	[CPUHP_SLAB_ONLINE] = {
+		.startup = slab_online_cpu,
+		.teardown = slab_offline_cpu,
+	},
 	[CPUHP_NOTIFY_DOWN_PREPARE] = {
 		.startup = NULL,
 		.teardown = notify_down_prepare,
Index: linux-2.6/mm/slab.c
===================================================================
--- linux-2.6.orig/mm/slab.c
+++ linux-2.6/mm/slab.c
@@ -1426,65 +1426,51 @@ bad:
 	return -ENOMEM;
 }
 
-static int __cpuinit cpuup_callback(struct notifier_block *nfb,
-				    unsigned long action, void *hcpu)
+int __cpuinit slab_prepare_cpu(unsigned int cpu)
 {
-	long cpu = (long)hcpu;
-	int err = 0;
+	int err;
 
-	switch (action) {
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
-		mutex_lock(&slab_mutex);
-		err = cpuup_prepare(cpu);
-		mutex_unlock(&slab_mutex);
-		break;
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-		start_cpu_timer(cpu);
-		break;
-#ifdef CONFIG_HOTPLUG_CPU
-  	case CPU_DOWN_PREPARE:
-  	case CPU_DOWN_PREPARE_FROZEN:
-		/*
-		 * Shutdown cache reaper. Note that the slab_mutex is
-		 * held so that if cache_reap() is invoked it cannot do
-		 * anything expensive but will only modify reap_work
-		 * and reschedule the timer.
-		*/
-		cancel_delayed_work_sync(&per_cpu(slab_reap_work, cpu));
-		/* Now the cache_reaper is guaranteed to be not running. */
-		per_cpu(slab_reap_work, cpu).work.func = NULL;
-  		break;
-  	case CPU_DOWN_FAILED:
-  	case CPU_DOWN_FAILED_FROZEN:
-		start_cpu_timer(cpu);
-  		break;
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
-		/*
-		 * Even if all the cpus of a node are down, we don't free the
-		 * kmem_list3 of any cache. This to avoid a race between
-		 * cpu_down, and a kmalloc allocation from another cpu for
-		 * memory from the node of the cpu going down.  The list3
-		 * structure is usually allocated from kmem_cache_create() and
-		 * gets destroyed at kmem_cache_destroy().
-		 */
-		/* fall through */
-#endif
-	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
-		mutex_lock(&slab_mutex);
-		cpuup_canceled(cpu);
-		mutex_unlock(&slab_mutex);
-		break;
-	}
-	return notifier_from_errno(err);
+	mutex_lock(&slab_mutex);
+	err = cpuup_prepare(cpu);
+	mutex_unlock(&slab_mutex);
+	return err;
 }
 
-static struct notifier_block __cpuinitdata cpucache_notifier = {
-	&cpuup_callback, NULL, 0
-};
+/*
+ * This is called for a failed online attempt and for a successful
+ * offline.
+ *
+ * Even if all the cpus of a node are down, we don't free the
+ * kmem_list3 of any cache. This to avoid a race between cpu_down, and
+ * a kmalloc allocation from another cpu for memory from the node of
+ * the cpu going down.  The list3 structure is usually allocated from
+ * kmem_cache_create() and gets destroyed at kmem_cache_destroy().
+ */
+int __cpuinit slab_dead_cpu(unsigned int cpu)
+{
+	mutex_lock(&slab_mutex);
+	cpuup_canceled(cpu);
+	mutex_unlock(&slab_mutex);
+	return 0;
+}
+
+int __cpuinit slab_online_cpu(unsigned int cpu)
+{
+	start_cpu_timer(cpu);
+}
+
+int __cpuinit slab_offline_cpu(unsigned int cpu)
+{
+	/*
+	 * Shutdown cache reaper. Note that the slab_mutex is held so
+	 * that if cache_reap() is invoked it cannot do anything
+	 * expensive but will only modify reap_work and reschedule the
+	 * timer.
+	 */
+	cancel_delayed_work_sync(&per_cpu(slab_reap_work, cpu));
+	/* Now the cache_reaper is guaranteed to be not running. */
+	per_cpu(slab_reap_work, cpu).work.func = NULL;
+}
 
 #if defined(CONFIG_NUMA) && defined(CONFIG_MEMORY_HOTPLUG)
 /*
@@ -1764,12 +1750,6 @@ void __init kmem_cache_init_late(void)
 	/* Done! */
 	slab_state = FULL;
 
-	/*
-	 * Register a cpu startup notifier callback that initializes
-	 * cpu_cache_get for all new cpus
-	 */
-	register_cpu_notifier(&cpucache_notifier);
-
 #ifdef CONFIG_NUMA
 	/*
 	 * Register a memory hotplug callback that initializes and frees


