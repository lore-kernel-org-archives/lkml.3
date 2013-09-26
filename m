Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab3IZKcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 06:32:46 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35624 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756114Ab3IZKco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 06:32:44 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        nicolas.pitre@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 4/4] cpufreq: stats: create sysfs entries when cpufreq_stats is a module
Date: Thu, 26 Sep 2013 15:59:54 +0530
Message-Id: <ddc1b65b5fa7a84fa12d620d7a94675f70a819d1.1380190886.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1380190886.git.viresh.kumar@linaro.org>
References: <cover.1380190886.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1380190886.git.viresh.kumar@linaro.org>
References: <cover.1380190886.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When cpufreq_stats is compiled in as a module, cpufreq driver would have already
been registered. And so the CPUFREQ_CREATE_POLICY notifiers wouldn't be called
for it. Hence no sysfs entries for stats. :(

This patch calls cpufreq_stats_create_table() for each online cpu from
cpufreq_stats_init() and so if policy is already created for CPUx then we will
register sysfs stats for it.

When its not compiled as module, we will return early as policy wouldn't be
found for any of the CPUs.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq_stats.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index 9dd5883..5793e14 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -180,7 +180,7 @@ static void cpufreq_stats_free_table(unsigned int cpu)
 	cpufreq_cpu_put(policy);
 }
 
-static int cpufreq_stats_create_table(struct cpufreq_policy *policy,
+static int __cpufreq_stats_create_table(struct cpufreq_policy *policy,
 		struct cpufreq_frequency_table *table)
 {
 	unsigned int i, j, count = 0, ret = 0;
@@ -253,6 +253,26 @@ error_get_fail:
 	return ret;
 }
 
+static void cpufreq_stats_create_table(unsigned int cpu)
+{
+	struct cpufreq_policy *policy;
+	struct cpufreq_frequency_table *table;
+
+	/*
+	 * "likely(!policy)" because normally cpufreq_stats will be registered
+	 * before cpufreq driver
+	 */
+	policy = cpufreq_cpu_get(cpu);
+	if (likely(!policy))
+		return;
+
+	table = cpufreq_frequency_get_table(policy->cpu);
+	if (likely(table))
+		__cpufreq_stats_create_table(policy, table);
+
+	cpufreq_cpu_put(policy);
+}
+
 static void cpufreq_stats_update_policy_cpu(struct cpufreq_policy *policy)
 {
 	struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table,
@@ -284,7 +304,7 @@ static int cpufreq_stat_notifier_policy(struct notifier_block *nb,
 		return 0;
 
 	if (val == CPUFREQ_CREATE_POLICY)
-		ret = cpufreq_stats_create_table(policy, table);
+		ret = __cpufreq_stats_create_table(policy, table);
 	else if (val == CPUFREQ_REMOVE_POLICY)
 		__cpufreq_stats_free_table(policy);
 
@@ -346,6 +366,9 @@ static int __init cpufreq_stats_init(void)
 	if (ret)
 		return ret;
 
+	for_each_online_cpu(cpu)
+		cpufreq_stats_create_table(cpu);
+
 	ret = cpufreq_register_notifier(&notifier_trans_block,
 				CPUFREQ_TRANSITION_NOTIFIER);
 	if (ret) {
-- 
1.7.12.rc2.18.g61b472e

