Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab3AaMLx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:11:53 -0500
Received: from www.linutronix.de ([62.245.132.108]:56029 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740Ab3AaMLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:11:32 -0500
Message-Id: <20130131120743.064902597@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 31 Jan 2013 12:11:30 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 23/40] cpufreq: Convert to hotplug state machine
References: <20130131120348.372374706@linutronix.de>
Content-Disposition: inline; filename=drivers-cpufreq-convert.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Straight forward conversion to state machine callbacks w/o fixing the
obvious brokeness of the asymetric state invocations.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/cpufreq/cpufreq_stats.c |   55 +++++++++-------------------------------
 include/linux/cpuhotplug.h      |    2 +
 2 files changed, 15 insertions(+), 42 deletions(-)

Index: linux-2.6/drivers/cpufreq/cpufreq_stats.c
===================================================================
--- linux-2.6.orig/drivers/cpufreq/cpufreq_stats.c
+++ linux-2.6/drivers/cpufreq/cpufreq_stats.c
@@ -167,7 +167,7 @@ static int freq_table_get_index(struct c
 /* should be called late in the CPU removal sequence so that the stats
  * memory is still available in case someone tries to use it.
  */
-static void cpufreq_stats_free_table(unsigned int cpu)
+static int cpufreq_stats_free_table(unsigned int cpu)
 {
 	struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table, cpu);
 	if (stat) {
@@ -175,18 +175,20 @@ static void cpufreq_stats_free_table(uns
 		kfree(stat);
 	}
 	per_cpu(cpufreq_stats_table, cpu) = NULL;
+	return 0;
 }
 
 /* must be called early in the CPU removal sequence (before
  * cpufreq_remove_dev) so that policy is still valid.
  */
-static void cpufreq_stats_free_sysfs(unsigned int cpu)
+static int cpufreq_stats_free_sysfs(unsigned int cpu)
 {
 	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
 	if (policy && policy->cpu == cpu)
 		sysfs_remove_group(&policy->kobj, &stats_attr_group);
 	if (policy)
 		cpufreq_cpu_put(policy);
+	return 0;
 }
 
 static int cpufreq_stats_create_table(struct cpufreq_policy *policy,
@@ -316,35 +318,6 @@ static int cpufreq_stat_notifier_trans(s
 	return 0;
 }
 
-static int __cpuinit cpufreq_stat_cpu_callback(struct notifier_block *nfb,
-					       unsigned long action,
-					       void *hcpu)
-{
-	unsigned int cpu = (unsigned long)hcpu;
-
-	switch (action) {
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-		cpufreq_update_policy(cpu);
-		break;
-	case CPU_DOWN_PREPARE:
-	case CPU_DOWN_PREPARE_FROZEN:
-		cpufreq_stats_free_sysfs(cpu);
-		break;
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
-		cpufreq_stats_free_table(cpu);
-		break;
-	}
-	return NOTIFY_OK;
-}
-
-/* priority=1 so this will get called before cpufreq_remove_dev */
-static struct notifier_block cpufreq_stat_cpu_notifier __refdata = {
-	.notifier_call = cpufreq_stat_cpu_callback,
-	.priority = 1,
-};
-
 static struct notifier_block notifier_policy_block = {
 	.notifier_call = cpufreq_stat_notifier_policy
 };
@@ -364,18 +337,19 @@ static int __init cpufreq_stats_init(voi
 	if (ret)
 		return ret;
 
-	register_hotcpu_notifier(&cpufreq_stat_cpu_notifier);
-	for_each_online_cpu(cpu)
-		cpufreq_update_policy(cpu);
+	/* Install callbacks. Core will call them for each online cpu */
+	cpuhp_setup_state(CPUHP_CPUFREQ_DEAD, NULL, cpufreq_stats_free_table);
+	/* CHECKME: This is pretty broken versus failures in up/down! */
+	cpuhp_setup_state(CPUHP_CPUFREQ_ONLINE, cpufreq_update_policy,
+			  cpufreq_stats_free_sysfs);
 
 	ret = cpufreq_register_notifier(&notifier_trans_block,
 				CPUFREQ_TRANSITION_NOTIFIER);
 	if (ret) {
 		cpufreq_unregister_notifier(&notifier_policy_block,
 				CPUFREQ_POLICY_NOTIFIER);
-		unregister_hotcpu_notifier(&cpufreq_stat_cpu_notifier);
-		for_each_online_cpu(cpu)
-			cpufreq_stats_free_table(cpu);
+		cpuhp_uninstall_callbacks(cpufreq_stats_cbs,
+					  ARRAY_SIZE(cpufreq_stats_cbs));
 		return ret;
 	}
 
@@ -389,11 +363,8 @@ static void __exit cpufreq_stats_exit(vo
 			CPUFREQ_POLICY_NOTIFIER);
 	cpufreq_unregister_notifier(&notifier_trans_block,
 			CPUFREQ_TRANSITION_NOTIFIER);
-	unregister_hotcpu_notifier(&cpufreq_stat_cpu_notifier);
-	for_each_online_cpu(cpu) {
-		cpufreq_stats_free_table(cpu);
-		cpufreq_stats_free_sysfs(cpu);
-	}
+	cpuhp_uninstall_callbacks(cpufreq_stats_cbs,
+				  ARRAY_SIZE(cpufreq_stats_cbs));
 }
 
 MODULE_AUTHOR("Zou Nan hai <nanhai.zou@intel.com>");
Index: linux-2.6/include/linux/cpuhotplug.h
===================================================================
--- linux-2.6.orig/include/linux/cpuhotplug.h
+++ linux-2.6/include/linux/cpuhotplug.h
@@ -14,6 +14,7 @@ enum cpuhp_states {
 	CPUHP_WORKQUEUE_PREP,
 	CPUHP_NOTIFY_PREPARE,
 	CPUHP_NOTIFY_DEAD,
+	CPUHP_CPUFREQ_DEAD,
 	CPUHP_SCHED_DEAD,
 	CPUHP_BRINGUP_CPU,
 	CPUHP_AP_OFFLINE,
@@ -31,6 +32,7 @@ enum cpuhp_states {
 	CPUHP_PERF_ONLINE,
 	CPUHP_SCHED_MIGRATE_ONLINE,
 	CPUHP_WORKQUEUE_ONLINE,
+	CPUHP_CPUFREQ_ONLINE,
 	CPUHP_NOTIFY_ONLINE,
 	CPUHP_NOTIFY_DOWN_PREPARE,
 	CPUHP_PERF_X86_UNCORE_ONLINE,


