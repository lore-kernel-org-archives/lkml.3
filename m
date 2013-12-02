Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107Ab3LBGUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 01:20:45 -0500
Received: from mail-qe0-f49.google.com ([209.85.128.49]:60809 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab3LBGUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 01:20:40 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 3/3] cpufreq: Remove unnecessary variable/parameter 'frozen'
Date: Mon,  2 Dec 2013 11:48:30 +0530
Message-Id: <0ba44ae1bad46cb18967a679b25a574894df36a6.1385964947.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1385964947.git.viresh.kumar@linaro.org>
References: <cover.1385964947.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1385964947.git.viresh.kumar@linaro.org>
References: <cover.1385964947.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have used 'frozen' variable/function parameter at many places to
differentiate CPU hotplugging on suspend/resume vs sysfs removals. We now have
another variable cpufreq_suspended which can be used in these cases and hence we
can get rid of all those variables or function parameters.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 60 ++++++++++++++++++++---------------------------
 1 file changed, 25 insertions(+), 35 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index e7586e6..e2196f3 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -882,8 +882,7 @@ static void cpufreq_init_policy(struct cpufreq_policy *policy)
 
 #ifdef CONFIG_HOTPLUG_CPU
 static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy,
-				  unsigned int cpu, struct device *dev,
-				  bool frozen)
+				  unsigned int cpu, struct device *dev)
 {
 	int ret = 0;
 	unsigned long flags;
@@ -915,7 +914,7 @@ static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy,
 	}
 
 	/* Don't touch sysfs links during light-weight init */
-	if (!frozen)
+	if (!cpufreq_suspended)
 		ret = sysfs_create_link(&dev->kobj, &policy->kobj, "cpufreq");
 
 	return ret;
@@ -986,8 +985,7 @@ static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
 			CPUFREQ_UPDATE_POLICY_CPU, policy);
 }
 
-static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
-			     bool frozen)
+static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 {
 	unsigned int j, cpu = dev->id;
 	int ret = -ENOMEM;
@@ -1022,7 +1020,7 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 	list_for_each_entry(tpolicy, &cpufreq_policy_list, policy_list) {
 		if (cpumask_test_cpu(cpu, tpolicy->related_cpus)) {
 			read_unlock_irqrestore(&cpufreq_driver_lock, flags);
-			ret = cpufreq_add_policy_cpu(tpolicy, cpu, dev, frozen);
+			ret = cpufreq_add_policy_cpu(tpolicy, cpu, dev);
 			up_read(&cpufreq_rwsem);
 			return ret;
 		}
@@ -1030,7 +1028,7 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
 #endif
 
-	if (frozen)
+	if (cpufreq_suspended)
 		/* Restore the saved policy when doing light-weight init */
 		policy = cpufreq_policy_restore(cpu);
 	else
@@ -1039,14 +1037,13 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 	if (!policy)
 		goto nomem_out;
 
-
 	/*
 	 * In the resume path, since we restore a saved policy, the assignment
 	 * to policy->cpu is like an update of the existing policy, rather than
 	 * the creation of a brand new one. So we need to perform this update
 	 * by invoking update_policy_cpu().
 	 */
-	if (frozen && cpu != policy->cpu)
+	if (cpufreq_suspended && cpu != policy->cpu)
 		update_policy_cpu(policy, cpu);
 	else
 		policy->cpu = cpu;
@@ -1140,7 +1137,7 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 	}
 #endif
 
-	if (!frozen) {
+	if (!cpufreq_suspended) {
 		ret = cpufreq_add_dev_interface(policy, dev);
 		if (ret)
 			goto err_out_unregister;
@@ -1187,11 +1184,11 @@ nomem_out:
  */
 static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 {
-	return __cpufreq_add_dev(dev, sif, false);
+	return __cpufreq_add_dev(dev, sif);
 }
 
 static int cpufreq_nominate_new_policy_cpu(struct cpufreq_policy *policy,
-					   unsigned int old_cpu, bool frozen)
+					   unsigned int old_cpu)
 {
 	struct device *cpu_dev;
 	int ret;
@@ -1200,7 +1197,7 @@ static int cpufreq_nominate_new_policy_cpu(struct cpufreq_policy *policy,
 	cpu_dev = get_cpu_device(cpumask_any_but(policy->cpus, old_cpu));
 
 	/* Don't touch sysfs files during light-weight tear-down */
-	if (frozen)
+	if (cpufreq_suspended)
 		return cpu_dev->id;
 
 	sysfs_remove_link(&cpu_dev->kobj, "cpufreq");
@@ -1222,8 +1219,7 @@ static int cpufreq_nominate_new_policy_cpu(struct cpufreq_policy *policy,
 }
 
 static int __cpufreq_remove_dev_prepare(struct device *dev,
-					struct subsys_interface *sif,
-					bool frozen)
+					struct subsys_interface *sif)
 {
 	unsigned int cpu = dev->id, cpus;
 	int new_cpu, ret;
@@ -1237,7 +1233,7 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
 	policy = per_cpu(cpufreq_cpu_data, cpu);
 
 	/* Save the policy somewhere when doing a light-weight tear-down */
-	if (frozen)
+	if (cpufreq_suspended)
 		per_cpu(cpufreq_cpu_data_fallback, cpu) = policy;
 
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
@@ -1266,14 +1262,14 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
 	up_read(&policy->rwsem);
 
 	if (cpu != policy->cpu) {
-		if (!frozen)
+		if (!cpufreq_suspended)
 			sysfs_remove_link(&dev->kobj, "cpufreq");
 	} else if (cpus > 1) {
-		new_cpu = cpufreq_nominate_new_policy_cpu(policy, cpu, frozen);
+		new_cpu = cpufreq_nominate_new_policy_cpu(policy, cpu);
 		if (new_cpu >= 0) {
 			update_policy_cpu(policy, new_cpu);
 
-			if (!frozen) {
+			if (!cpufreq_suspended) {
 				pr_debug("%s: policy Kobject moved to cpu: %d from: %d\n",
 						__func__, new_cpu, cpu);
 			}
@@ -1284,8 +1280,7 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
 }
 
 static int __cpufreq_remove_dev_finish(struct device *dev,
-				       struct subsys_interface *sif,
-				       bool frozen)
+				       struct subsys_interface *sif)
 {
 	unsigned int cpu = dev->id, cpus;
 	int ret;
@@ -1322,7 +1317,7 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
 			}
 		}
 
-		if (!frozen) {
+		if (!cpufreq_suspended) {
 			down_read(&policy->rwsem);
 			kobj = &policy->kobj;
 			cmp = &policy->kobj_unregister;
@@ -1352,7 +1347,7 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
 		list_del(&policy->policy_list);
 		write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
-		if (!frozen)
+		if (!cpufreq_suspended)
 			cpufreq_policy_free(policy);
 	} else {
 		if (has_target()) {
@@ -1382,10 +1377,10 @@ static int cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif)
 	if (cpu_is_offline(cpu))
 		return 0;
 
-	ret = __cpufreq_remove_dev_prepare(dev, sif, false);
+	ret = __cpufreq_remove_dev_prepare(dev, sif);
 
 	if (!ret)
-		ret = __cpufreq_remove_dev_finish(dev, sif, false);
+		ret = __cpufreq_remove_dev_finish(dev, sif);
 
 	return ret;
 }
@@ -2153,30 +2148,25 @@ static int cpufreq_cpu_callback(struct notifier_block *nfb,
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
-		switch (action & ~CPU_TASKS_FROZEN) {
+		switch (action) {
 		case CPU_ONLINE:
-			__cpufreq_add_dev(dev, NULL, frozen);
+			__cpufreq_add_dev(dev, NULL);
 			cpufreq_update_policy(cpu);
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

