Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742AbaAGBkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 20:40:33 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49494 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756703AbaAGBka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 20:40:30 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH Resend 2/4] cpufreq: stats: remove hotplug notifiers
Date: Tue,  7 Jan 2014 07:10:11 +0530
Message-Id: <2c5f1ca1f88407ad9b6938915409ce3a8df7d4c9.1389058746.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <b4c2b7c1f5e480e6ae6fcbc737ae52c1e0a88549.1389058746.git.viresh.kumar@linaro.org>
References: <b4c2b7c1f5e480e6ae6fcbc737ae52c1e0a88549.1389058746.git.viresh.kumar@linaro.org>
In-Reply-To: <b4c2b7c1f5e480e6ae6fcbc737ae52c1e0a88549.1389058746.git.viresh.kumar@linaro.org>
References: <b4c2b7c1f5e480e6ae6fcbc737ae52c1e0a88549.1389058746.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Either CPUs are hot-unplugged or suspend/resume occurs, cpufreq core will send
notifications to cpufreq-stats and stats structure and sysfs entries would be
correctly handled..

And so we don't actually need hotcpu notifiers in cpufreq-stats anymore. We were
only handling cpu hot-unplug events here and that are already taken care of by
POLICY notifiers.

Acked-and-tested-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq_stats.c | 38 ++------------------------------------
 1 file changed, 2 insertions(+), 36 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index 0f71562..8fa5844 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -294,11 +294,8 @@ static int cpufreq_stat_notifier_policy(struct notifier_block *nb,
 	if (val == CPUFREQ_CREATE_POLICY)
 		ret = cpufreq_stats_create_table(policy, table);
 	else if (val == CPUFREQ_REMOVE_POLICY) {
-		/* This might already be freed by cpu hotplug notifier */
-		if (per_cpu(cpufreq_stats_table, cpu)) {
-			cpufreq_stats_free_sysfs(cpu);
-			cpufreq_stats_free_table(cpu);
-		}
+		cpufreq_stats_free_sysfs(cpu);
+		cpufreq_stats_free_table(cpu);
 	}
 
 	return ret;
@@ -340,33 +337,6 @@ static int cpufreq_stat_notifier_trans(struct notifier_block *nb,
 	return 0;
 }
 
-static int cpufreq_stat_cpu_callback(struct notifier_block *nfb,
-					       unsigned long action,
-					       void *hcpu)
-{
-	unsigned int cpu = (unsigned long)hcpu;
-
-	/* Don't free/allocate stats during suspend/resume */
-	if (action & CPU_TASKS_FROZEN)
-		return 0;
-
-	switch (action) {
-	case CPU_DOWN_PREPARE:
-		cpufreq_stats_free_sysfs(cpu);
-		break;
-	case CPU_DEAD:
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
@@ -386,14 +356,11 @@ static int __init cpufreq_stats_init(void)
 	if (ret)
 		return ret;
 
-	register_hotcpu_notifier(&cpufreq_stat_cpu_notifier);
-
 	ret = cpufreq_register_notifier(&notifier_trans_block,
 				CPUFREQ_TRANSITION_NOTIFIER);
 	if (ret) {
 		cpufreq_unregister_notifier(&notifier_policy_block,
 				CPUFREQ_POLICY_NOTIFIER);
-		unregister_hotcpu_notifier(&cpufreq_stat_cpu_notifier);
 		for_each_online_cpu(cpu)
 			cpufreq_stats_free_table(cpu);
 		return ret;
@@ -409,7 +376,6 @@ static void __exit cpufreq_stats_exit(void)
 			CPUFREQ_POLICY_NOTIFIER);
 	cpufreq_unregister_notifier(&notifier_trans_block,
 			CPUFREQ_TRANSITION_NOTIFIER);
-	unregister_hotcpu_notifier(&cpufreq_stat_cpu_notifier);
 	for_each_online_cpu(cpu) {
 		cpufreq_stats_free_table(cpu);
 		cpufreq_stats_free_sysfs(cpu);
-- 
1.7.12.rc2.18.g61b472e

