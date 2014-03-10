Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbaCJJYI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 05:24:08 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:62357 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbaCJJYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 05:24:04 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V1 Resend 3/3] cpufreq: Remove unnecessary variable/parameter 'frozen'
Date: Mon, 10 Mar 2014 14:53:35 +0530
Message-Id: <a5cb16d19b6530e867a72d5d04c55b16d01a1ffa.1394431858.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1394431858.git.viresh.kumar@linaro.org>
References: <cover.1394431858.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1394431858.git.viresh.kumar@linaro.org>
References: <cover.1394431858.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have used 'frozen' variable/function parameter at many places to
differentiate CPU hotplugging on suspend/resume vs sysfs removals. We now have
another variable cpufreq_suspended which can be used in these cases and hence we
can get rid of all those variables or function parameters.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 51 ++++++++++++++++++++---------------------------
 1 file changed, 22 insertions(+), 29 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index aae9dc1..53f5d0b6 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1042,13 +1042,13 @@ static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
 			CPUFREQ_UPDATE_POLICY_CPU, policy);
 }
 
-static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
-			     bool frozen)
+static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 {
 	unsigned int j, cpu = dev->id;
 	int ret = -ENOMEM;
 	struct cpufreq_policy *policy;
 	unsigned long flags;
+	bool recover_policy = cpufreq_suspended;
 #ifdef CONFIG_HOTPLUG_CPU
 	struct cpufreq_policy *tpolicy;
 #endif
@@ -1089,9 +1089,9 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 	 * Restore the saved policy when doing light-weight init and fall back
 	 * to the full init if that fails.
 	 */
-	policy = frozen ? cpufreq_policy_restore(cpu) : NULL;
+	policy = recover_policy ? cpufreq_policy_restore(cpu) : NULL;
 	if (!policy) {
-		frozen = false;
+		recover_policy = false;
 		policy = cpufreq_policy_alloc();
 		if (!policy)
 			goto nomem_out;
@@ -1103,7 +1103,7 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 	 * the creation of a brand new one. So we need to perform this update
 	 * by invoking update_policy_cpu().
 	 */
-	if (frozen && cpu != policy->cpu)
+	if (recover_policy && cpu != policy->cpu)
 		update_policy_cpu(policy, cpu);
 	else
 		policy->cpu = cpu;
@@ -1131,7 +1131,7 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 	 */
 	cpumask_and(policy->cpus, policy->cpus, cpu_online_mask);
 
-	if (!frozen) {
+	if (!recover_policy) {
 		policy->user_policy.min = policy->min;
 		policy->user_policy.max = policy->max;
 	}
@@ -1193,7 +1193,7 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 	blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
 				     CPUFREQ_START, policy);
 
-	if (!frozen) {
+	if (!recover_policy) {
 		ret = cpufreq_add_dev_interface(policy, dev);
 		if (ret)
 			goto err_out_unregister;
@@ -1207,7 +1207,7 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 
 	cpufreq_init_policy(policy);
 
-	if (!frozen) {
+	if (!recover_policy) {
 		policy->user_policy.policy = policy->policy;
 		policy->user_policy.governor = policy->governor;
 	}
@@ -1230,7 +1230,7 @@ err_get_freq:
 	if (cpufreq_driver->exit)
 		cpufreq_driver->exit(policy);
 err_set_policy_cpu:
-	if (frozen) {
+	if (recover_policy) {
 		/* Do not leave stale fallback data behind. */
 		per_cpu(cpufreq_cpu_data_fallback, cpu) = NULL;
 		cpufreq_policy_put_kobj(policy);
@@ -1254,7 +1254,7 @@ nomem_out:
  */
 static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 {
-	return __cpufreq_add_dev(dev, sif, false);
+	return __cpufreq_add_dev(dev, sif);
 }
 
 static int cpufreq_nominate_new_policy_cpu(struct cpufreq_policy *policy,
@@ -1285,8 +1285,7 @@ static int cpufreq_nominate_new_policy_cpu(struct cpufreq_policy *policy,
 }
 
 static int __cpufreq_remove_dev_prepare(struct device *dev,
-					struct subsys_interface *sif,
-					bool frozen)
+					struct subsys_interface *sif)
 {
 	unsigned int cpu = dev->id, cpus;
 	int new_cpu, ret;
@@ -1300,7 +1299,7 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
 	policy = per_cpu(cpufreq_cpu_data, cpu);
 
 	/* Save the policy somewhere when doing a light-weight tear-down */
-	if (frozen)
+	if (cpufreq_suspended)
 		per_cpu(cpufreq_cpu_data_fallback, cpu) = policy;
 
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
@@ -1333,7 +1332,7 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
 		if (new_cpu >= 0) {
 			update_policy_cpu(policy, new_cpu);
 
-			if (!frozen) {
+			if (!cpufreq_suspended) {
 				pr_debug("%s: policy Kobject moved to cpu: %d from: %d\n",
 						__func__, new_cpu, cpu);
 			}
@@ -1344,8 +1343,7 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
 }
 
 static int __cpufreq_remove_dev_finish(struct device *dev,
-				       struct subsys_interface *sif,
-				       bool frozen)
+				       struct subsys_interface *sif)
 {
 	unsigned int cpu = dev->id, cpus;
 	int ret;
@@ -1380,7 +1378,7 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
 			}
 		}
 
-		if (!frozen)
+		if (!cpufreq_suspended)
 			cpufreq_policy_put_kobj(policy);
 
 		/*
@@ -1396,7 +1394,7 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
 		list_del(&policy->policy_list);
 		write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
-		if (!frozen)
+		if (!cpufreq_suspended)
 			cpufreq_policy_free(policy);
 	} else {
 		if (has_target()) {
@@ -1426,10 +1424,10 @@ static int cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif)
 	if (cpu_is_offline(cpu))
 		return 0;
 
-	ret = __cpufreq_remove_dev_prepare(dev, sif, false);
+	ret = __cpufreq_remove_dev_prepare(dev, sif);
 
 	if (!ret)
-		ret = __cpufreq_remove_dev_finish(dev, sif, false);
+		ret = __cpufreq_remove_dev_finish(dev, sif);
 
 	return ret;
 }
@@ -2187,29 +2185,24 @@ static int cpufreq_cpu_callback(struct notifier_block *nfb,
 {
 	unsigned int cpu = (unsigned long)hcpu;
 	struct device *dev;
-	bool frozen = false;
 
 	dev = get_cpu_device(cpu);
 	if (dev) {
-
-		if (action & CPU_TASKS_FROZEN)
-			frozen = true;
-
 		switch (action & ~CPU_TASKS_FROZEN) {
 		case CPU_ONLINE:
-			__cpufreq_add_dev(dev, NULL, frozen);
+			__cpufreq_add_dev(dev, NULL);
 			break;
 
 		case CPU_DOWN_PREPARE:
-			__cpufreq_remove_dev_prepare(dev, NULL, frozen);
+			__cpufreq_remove_dev_prepare(dev, NULL);
 			break;
 
 		case CPU_POST_DEAD:
-			__cpufreq_remove_dev_finish(dev, NULL, frozen);
+			__cpufreq_remove_dev_finish(dev, NULL);
 			break;
 
 		case CPU_DOWN_FAILED:
-			__cpufreq_add_dev(dev, NULL, frozen);
+			__cpufreq_add_dev(dev, NULL);
 			break;
 		}
 	}
-- 
1.7.12.rc2.18.g61b472e

