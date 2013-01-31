Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab3AaMNx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:13:53 -0500
Received: from www.linutronix.de ([62.245.132.108]:56161 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab3AaMLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:11:43 -0500
Message-Id: <20130131120743.928325077@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 31 Jan 2013 12:11:41 -0000
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
Subject: [patch 36/40] profile: Convert ot hotplug state machine
References: <20130131120348.372374706@linutronix.de>
Content-Disposition: inline; filename=0002-cpu-hotplug-convert-profile.c.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Weinberger <richard@nod.at>

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 include/linux/cpuhotplug.h |   12 +++++
 kernel/cpu.c               |    8 +++
 kernel/profile.c           |   92 +++++++++++++++++++++------------------------
 3 files changed, 63 insertions(+), 49 deletions(-)

Index: linux-2.6/include/linux/cpuhotplug.h
===================================================================
--- linux-2.6.orig/include/linux/cpuhotplug.h
+++ linux-2.6/include/linux/cpuhotplug.h
@@ -15,6 +15,7 @@ enum cpuhp_states {
 	CPUHP_RCUTREE_PREPARE,
 	CPUHP_HRTIMERS_PREPARE,
 	CPUHP_TIMERS_PREPARE,
+	CPUHP_PROFILE_PREPARE,
 	CPUHP_NOTIFY_PREPARE,
 	CPUHP_NOTIFY_DEAD,
 	CPUHP_CLOCKEVENTS_DEAD,
@@ -46,6 +47,7 @@ enum cpuhp_states {
 	CPUHP_CPUFREQ_ONLINE,
 	CPUHP_RCUTREE_ONLINE,
 	CPUHP_NOTIFY_ONLINE,
+	CPUHP_PROFILE_ONLINE,
 	CPUHP_NOTIFY_DOWN_PREPARE,
 	CPUHP_PERF_X86_UNCORE_ONLINE,
 	CPUHP_PERF_X86_ONLINE,
@@ -186,4 +188,14 @@ int timers_dead_cpu(unsigned int cpu);
 #define timers_dead_cpu		NULL
 #endif
 
+#if defined(CONFIG_PROFILING) && defined(CONFIG_HOTPLUG_CPU)
+int profile_prepare_cpu(unsigned int cpu);
+int profile_dead_cpu(unsigned int cpu);
+int profile_online_cpu(unsigned int cpu);
+#else
+#define profile_prepare_cpu	NULL
+#define profile_dead_cpu	NULL
+#define profile_online_cpu	NULL
+#endif
+
 #endif
Index: linux-2.6/kernel/cpu.c
===================================================================
--- linux-2.6.orig/kernel/cpu.c
+++ linux-2.6/kernel/cpu.c
@@ -760,6 +760,10 @@ static struct cpuhp_step cpuhp_bp_states
 		.startup = timers_prepare_cpu,
 		.teardown = timers_dead_cpu,
 	},
+	[CPUHP_PROFILE_PREPARE] = {
+		.startup = profile_prepare_cpu,
+		.teardown = profile_dead_cpu,
+	},
 	[CPUHP_NOTIFY_PREPARE] = {
 		.startup = notify_prepare,
 		.teardown = NULL,
@@ -804,6 +808,10 @@ static struct cpuhp_step cpuhp_bp_states
 		.startup = notify_online,
 		.teardown = NULL,
 	},
+	[CPUHP_PROFILE_ONLINE] = {
+		.startup = profile_online_cpu,
+		.teardown = NULL,
+	},
 	[CPUHP_NOTIFY_DOWN_PREPARE] = {
 		.startup = NULL,
 		.teardown = notify_down_prepare,
Index: linux-2.6/kernel/profile.c
===================================================================
--- linux-2.6.orig/kernel/profile.c
+++ linux-2.6/kernel/profile.c
@@ -353,68 +353,63 @@ out:
 	put_cpu();
 }
 
-static int __cpuinit profile_cpu_callback(struct notifier_block *info,
-					unsigned long action, void *__cpu)
+int __cpuinit profile_dead_cpu(unsigned int cpu)
 {
-	int node, cpu = (unsigned long)__cpu;
 	struct page *page;
+	int i;
 
-	switch (action) {
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
-		node = cpu_to_mem(cpu);
-		per_cpu(cpu_profile_flip, cpu) = 0;
-		if (!per_cpu(cpu_profile_hits, cpu)[1]) {
-			page = alloc_pages_exact_node(node,
-					GFP_KERNEL | __GFP_ZERO,
-					0);
-			if (!page)
-				return notifier_from_errno(-ENOMEM);
-			per_cpu(cpu_profile_hits, cpu)[1] = page_address(page);
-		}
-		if (!per_cpu(cpu_profile_hits, cpu)[0]) {
-			page = alloc_pages_exact_node(node,
-					GFP_KERNEL | __GFP_ZERO,
-					0);
-			if (!page)
-				goto out_free;
-			per_cpu(cpu_profile_hits, cpu)[0] = page_address(page);
-		}
-		break;
-out_free:
-		page = virt_to_page(per_cpu(cpu_profile_hits, cpu)[1]);
-		per_cpu(cpu_profile_hits, cpu)[1] = NULL;
-		__free_page(page);
-		return notifier_from_errno(-ENOMEM);
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-		if (prof_cpu_mask != NULL)
-			cpumask_set_cpu(cpu, prof_cpu_mask);
-		break;
-	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
-		if (prof_cpu_mask != NULL)
-			cpumask_clear_cpu(cpu, prof_cpu_mask);
-		if (per_cpu(cpu_profile_hits, cpu)[0]) {
-			page = virt_to_page(per_cpu(cpu_profile_hits, cpu)[0]);
-			per_cpu(cpu_profile_hits, cpu)[0] = NULL;
+	if (prof_cpu_mask != NULL)
+		cpumask_clear_cpu(cpu, prof_cpu_mask);
+
+	for (i = 0; i < 2; i++) {
+		if (per_cpu(cpu_profile_hits, cpu)[i]) {
+			page = virt_to_page(per_cpu(cpu_profile_hits, cpu)[i]);
+			per_cpu(cpu_profile_hits, cpu)[i] = NULL;
 			__free_page(page);
 		}
+
 		if (per_cpu(cpu_profile_hits, cpu)[1]) {
 			page = virt_to_page(per_cpu(cpu_profile_hits, cpu)[1]);
 			per_cpu(cpu_profile_hits, cpu)[1] = NULL;
 			__free_page(page);
 		}
-		break;
 	}
-	return NOTIFY_OK;
+	return 0;
+}
+
+int __cpuinit profile_prepare_cpu(unsigned int cpu)
+{
+	int i, node = cpu_to_mem(cpu);
+	struct page *page;
+
+	per_cpu(cpu_profile_flip, cpu) = 0;
+
+	for (i = 0; i < 2; i++) {
+		if (per_cpu(cpu_profile_hits, cpu)[i])
+			continue;
+
+		page = alloc_pages_exact_node(node, GFP_KERNEL | __GFP_ZERO, 0);
+		if (!page) {
+			profile_dead_cpu(cpu);
+			return -ENOMEM;
+		}
+		per_cpu(cpu_profile_hits, cpu)[i] = page_address(page);
+
+	}
+	return 0;
 }
+
+int __cpuinit profile_online_cpu(unsigned int cpu)
+{
+	if (prof_cpu_mask != NULL)
+		cpumask_set_cpu(cpu, prof_cpu_mask);
+
+	return 0;
+}
+
 #else /* !CONFIG_SMP */
 #define profile_flip_buffers()		do { } while (0)
 #define profile_discard_flip_buffers()	do { } while (0)
-#define profile_cpu_callback		NULL
 
 static void do_profile_hits(int type, void *__pc, unsigned int nr_hits)
 {
@@ -612,7 +607,7 @@ out_cleanup:
 #define create_hash_tables()			({ 0; })
 #endif
 
-int __ref create_proc_profile(void) /* false positive from hotcpu_notifier */
+int __init create_proc_profile(void)
 {
 	struct proc_dir_entry *entry;
 
@@ -625,7 +620,6 @@ int __ref create_proc_profile(void) /* f
 	if (!entry)
 		return 0;
 	entry->size = (1+prof_len) * sizeof(atomic_t);
-	hotcpu_notifier(profile_cpu_callback, 0);
 	return 0;
 }
 module_init(create_proc_profile);


