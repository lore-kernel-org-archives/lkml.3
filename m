Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633AbaGYBIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 21:08:48 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34436 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbaGYBHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 21:07:44 -0400
From: Saravana Kannan <skannan@codeaurora.org>
To: "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Todd Poynor <toddpoynor@google.com>,
        "Srivatsa S . Bhat" <srivatsa@mit.edu>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Saravana Kannan" <skannan@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH v4 3/5] cpufreq: Don't destroy/realloc policy/sysfs on hotplug/suspend
Date: Thu, 24 Jul 2014 18:07:26 -0700
Message-Id: <1406250448-470-4-git-send-email-skannan@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1406250448-470-1-git-send-email-skannan@codeaurora.org>
References: <1406250448-470-1-git-send-email-skannan@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch simplifies a lot of the hotplug/suspend code by not
adding/removing/moving the policy/sysfs/kobj during hotplug and just leaves
the cpufreq directory and policy in place irrespective of whether the CPUs
are ONLINE/OFFLINE.

Leaving the policy, sysfs and kobject in place also brings these additional
benefits:
* Faster suspend/resume
* Faster hotplug
* Sysfs file permissions maintained across hotplug
* Policy settings and governor tunables maintained across hotplug
* Cpufreq stats would be maintained across hotplug for all CPUs and can be
  queried even after CPU goes OFFLINE

Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
---
 drivers/cpufreq/cpufreq.c | 83 ++++++++++++++++-------------------------------
 1 file changed, 28 insertions(+), 55 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index af4f291..d9fc6e5 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -865,7 +865,7 @@ static int cpufreq_add_dev_symlink(struct cpufreq_policy *policy)
 	unsigned int j;
 	int ret = 0;
 
-	for_each_cpu(j, policy->cpus) {
+	for_each_cpu(j, policy->related_cpus) {
 		struct device *cpu_dev;
 
 		if (j == policy->kobj_cpu)
@@ -968,7 +968,7 @@ static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy,
 	int ret = 0;
 	unsigned long flags;
 
-	if (has_target()) {
+	if (cpumask_weight(policy->cpus) && has_target()) {
 		ret = __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
 		if (ret) {
 			pr_err("%s: Failed to stop governor\n", __func__);
@@ -997,7 +997,7 @@ static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy,
 		}
 	}
 
-	return sysfs_create_link(&dev->kobj, &policy->kobj, "cpufreq");
+	return 0;
 }
 #endif
 
@@ -1100,9 +1100,6 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 	struct cpufreq_policy *policy;
 	unsigned long flags;
 	bool recover_policy = cpufreq_suspended;
-#ifdef CONFIG_HOTPLUG_CPU
-	struct cpufreq_policy *tpolicy;
-#endif
 
 	if (cpu_is_offline(cpu))
 		return 0;
@@ -1113,28 +1110,22 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 	/* check whether a different CPU already registered this
 	 * CPU because it is in the same boat. */
 	policy = cpufreq_cpu_get(cpu);
-	if (unlikely(policy)) {
+	if (policy) {
+		if (!cpumask_test_cpu(cpu, policy->cpus))
+			ret = cpufreq_add_policy_cpu(policy, cpu, dev);
+		else
+			ret = 0;
 		cpufreq_cpu_put(policy);
-		return 0;
+		return ret;
 	}
 #endif
 
 	if (!down_read_trylock(&cpufreq_rwsem))
 		return 0;
 
-#ifdef CONFIG_HOTPLUG_CPU
-	/* Check if this cpu was hot-unplugged earlier and has siblings */
-	read_lock_irqsave(&cpufreq_driver_lock, flags);
-	list_for_each_entry(tpolicy, &cpufreq_policy_list, policy_list) {
-		if (cpumask_test_cpu(cpu, tpolicy->related_cpus)) {
-			read_unlock_irqrestore(&cpufreq_driver_lock, flags);
-			ret = cpufreq_add_policy_cpu(tpolicy, cpu, dev);
-			up_read(&cpufreq_rwsem);
-			return ret;
-		}
-	}
-	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
-#endif
+	/* If we get this far, this is the first time we are adding the
+	 * policy */
+	recover_policy = false;
 
 	/*
 	 * Restore the saved policy when doing light-weight init and fall back
@@ -1189,7 +1180,7 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 
 	down_write(&policy->rwsem);
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
-	for_each_cpu(j, policy->cpus)
+	for_each_cpu(j, policy->related_cpus)
 		per_cpu(cpufreq_cpu_data, j) = policy;
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
@@ -1274,7 +1265,7 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 err_out_unregister:
 err_get_freq:
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
-	for_each_cpu(j, policy->cpus)
+	for_each_cpu(j, policy->related_cpus)
 		per_cpu(cpufreq_cpu_data, j) = NULL;
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
@@ -1340,21 +1331,15 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
 					struct subsys_interface *sif)
 {
 	unsigned int cpu = dev->id, cpus;
-	int new_cpu, ret;
+	int new_cpu, ret = 0;
 	unsigned long flags;
 	struct cpufreq_policy *policy;
 
 	pr_debug("%s: unregistering CPU %u\n", __func__, cpu);
 
-	write_lock_irqsave(&cpufreq_driver_lock, flags);
-
+	read_lock_irqsave(&cpufreq_driver_lock, flags);
 	policy = per_cpu(cpufreq_cpu_data, cpu);
-
-	/* Save the policy somewhere when doing a light-weight tear-down */
-	if (cpufreq_suspended)
-		per_cpu(cpufreq_cpu_data_fallback, cpu) = policy;
-
-	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	if (!policy) {
 		pr_debug("%s: No cpu_data found\n", __func__);
@@ -1369,24 +1354,15 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
 		}
 	}
 
-	if (!cpufreq_driver->setpolicy)
-		strncpy(per_cpu(cpufreq_cpu_governor, cpu),
-			policy->governor->name, CPUFREQ_NAME_LEN);
-
 	down_read(&policy->rwsem);
 	cpus = cpumask_weight(policy->cpus);
 	up_read(&policy->rwsem);
 
-	if (cpu != policy->cpu) {
-		sysfs_remove_link(&dev->kobj, "cpufreq");
-	} else if (cpus > 1) {
-		new_cpu = cpufreq_nominate_new_policy_cpu(policy, cpu);
-		if (new_cpu >= 0) {
-			update_policy_cpu(policy, new_cpu);
-
-			if (!cpufreq_suspended)
-				pr_debug("%s: policy Kobject moved to cpu: %d from: %d\n",
-					 __func__, new_cpu, cpu);
+	if (cpus > 1) {
+		if (cpu == policy->cpu) {
+			new_cpu = cpumask_any_but(policy->cpus, cpu);
+			if (new_cpu >= 0)
+				update_policy_cpu(policy, new_cpu);
 		}
 	} else if (cpufreq_driver->stop_cpu && cpufreq_driver->setpolicy) {
 		cpufreq_driver->stop_cpu(policy);
@@ -1431,6 +1407,9 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
 	cpus = cpumask_weight(policy->cpus);
 	up_read(&policy->rwsem);
 
+	if (cpu != policy->kobj_cpu)
+		sysfs_remove_link(&dev->kobj, "cpufreq");
+
 	/* If cpu is last user of policy, free policy */
 	if (cpus == 0) {
 		if (has_target()) {
@@ -1475,12 +1454,10 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
 static int cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif)
 {
 	unsigned int cpu = dev->id;
-	int ret;
-
-	if (cpu_is_offline(cpu))
-		return 0;
+	int ret = 0;
 
-	ret = __cpufreq_remove_dev_prepare(dev, sif);
+	if (cpu_online(cpu))
+		ret = __cpufreq_remove_dev_prepare(dev, sif);
 
 	if (!ret)
 		ret = __cpufreq_remove_dev_finish(dev, sif);
@@ -2307,10 +2284,6 @@ static int cpufreq_cpu_callback(struct notifier_block *nfb,
 			__cpufreq_remove_dev_prepare(dev, NULL);
 			break;
 
-		case CPU_POST_DEAD:
-			__cpufreq_remove_dev_finish(dev, NULL);
-			break;
-
 		case CPU_DOWN_FAILED:
 			__cpufreq_add_dev(dev, NULL);
 			break;
-- 
1.8.2.1

The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
