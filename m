Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab3IZKcX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 06:32:23 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:53209 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756114Ab3IZKcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 06:32:20 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        nicolas.pitre@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 3/4] cpufreq: stats: free table and remove sysfs entry in a single routine
Date: Thu, 26 Sep 2013 15:59:53 +0530
Message-Id: <0564543fdd76697816de4cbeaedf823fb709f12d.1380190886.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1380190886.git.viresh.kumar@linaro.org>
References: <cover.1380190886.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1380190886.git.viresh.kumar@linaro.org>
References: <cover.1380190886.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't have code paths now, where we need to do these two things separately
and so better do them in a single routine. Just as they are allocated in a
single routine.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq_stats.c | 50 ++++++++++++++++-------------------------
 1 file changed, 19 insertions(+), 31 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index 8fa5844..9dd5883 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -151,40 +151,32 @@ static int freq_table_get_index(struct cpufreq_stats *stat, unsigned int freq)
 	return -1;
 }
 
-/* should be called late in the CPU removal sequence so that the stats
- * memory is still available in case someone tries to use it.
- */
-static void cpufreq_stats_free_table(unsigned int cpu)
+static void __cpufreq_stats_free_table(struct cpufreq_policy *policy)
 {
-	struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table, cpu);
+	struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table, policy->cpu);
 
-	if (stat) {
-		pr_debug("%s: Free stat table\n", __func__);
-		kfree(stat->time_in_state);
-		kfree(stat);
-		per_cpu(cpufreq_stats_table, cpu) = NULL;
-	}
+	if (!stat)
+		return;
+
+	pr_debug("%s: Free stat table\n", __func__);
+
+	sysfs_remove_group(&policy->kobj, &stats_attr_group);
+	kfree(stat->time_in_state);
+	kfree(stat);
+	per_cpu(cpufreq_stats_table, policy->cpu) = NULL;
 }
 
-/* must be called early in the CPU removal sequence (before
- * cpufreq_remove_dev) so that policy is still valid.
- */
-static void cpufreq_stats_free_sysfs(unsigned int cpu)
+static void cpufreq_stats_free_table(unsigned int cpu)
 {
-	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
+	struct cpufreq_policy *policy;
 
+	policy = cpufreq_cpu_get(cpu);
 	if (!policy)
 		return;
 
-	if (!cpufreq_frequency_get_table(cpu))
-		goto put_ref;
-
-	if (!policy_is_shared(policy)) {
-		pr_debug("%s: Free sysfs stat\n", __func__);
-		sysfs_remove_group(&policy->kobj, &stats_attr_group);
-	}
+	if (cpufreq_frequency_get_table(policy->cpu))
+		__cpufreq_stats_free_table(policy);
 
-put_ref:
 	cpufreq_cpu_put(policy);
 }
 
@@ -293,10 +285,8 @@ static int cpufreq_stat_notifier_policy(struct notifier_block *nb,
 
 	if (val == CPUFREQ_CREATE_POLICY)
 		ret = cpufreq_stats_create_table(policy, table);
-	else if (val == CPUFREQ_REMOVE_POLICY) {
-		cpufreq_stats_free_sysfs(cpu);
-		cpufreq_stats_free_table(cpu);
-	}
+	else if (val == CPUFREQ_REMOVE_POLICY)
+		__cpufreq_stats_free_table(policy);
 
 	return ret;
 }
@@ -376,10 +366,8 @@ static void __exit cpufreq_stats_exit(void)
 			CPUFREQ_POLICY_NOTIFIER);
 	cpufreq_unregister_notifier(&notifier_trans_block,
 			CPUFREQ_TRANSITION_NOTIFIER);
-	for_each_online_cpu(cpu) {
+	for_each_online_cpu(cpu)
 		cpufreq_stats_free_table(cpu);
-		cpufreq_stats_free_sysfs(cpu);
-	}
 }
 
 MODULE_AUTHOR("Zou Nan hai <nanhai.zou@intel.com>");
-- 
1.7.12.rc2.18.g61b472e

