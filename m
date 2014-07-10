Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbaGJChl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 22:37:41 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43537 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaGJChj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 22:37:39 -0400
From: Saravana Kannan <skannan@codeaurora.org>
To: "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Todd Poynor <toddpoynor@google.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Saravana Kannan" <skannan@codeaurora.org>
Subject: [PATCH] cpufreq: Don't destroy/realloc policy/sysfs on hotplug/suspend
Date: Wed,  9 Jul 2014 19:37:30 -0700
Message-Id: <1404959850-11617-1-git-send-email-skannan@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preliminary patch. Not tested. Just sending out to give an idea of what I'm
looking to do. Expect a lot more simplification when it's done.

Benefits:
* A lot more simpler code.
* Less stability issues.
* Suspend/resume time would improve.
* Hotplug time would improve.
* Sysfs file permissions would be maintained.
* More policy settings would be maintained across suspend/resume.
* cpufreq stats would be maintained across hotplug for all CPUs.

Change-Id: I39c395e1fee8731880c0fd7c8a9c1d83e2e4b8d0
Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
---
 drivers/cpufreq/cpufreq.c | 293 +++++++++-------------------------------------
 1 file changed, 55 insertions(+), 238 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 62259d2..8ca1b6f 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -859,13 +859,13 @@ void cpufreq_sysfs_remove_file(const struct attribute *attr)
 }
 EXPORT_SYMBOL(cpufreq_sysfs_remove_file);
 
-/* symlink affected CPUs */
+/* symlink related CPUs */
 static int cpufreq_add_dev_symlink(struct cpufreq_policy *policy)
 {
 	unsigned int j;
 	int ret = 0;
 
-	for_each_cpu(j, policy->cpus) {
+	for_each_cpu(j, policy->related_cpus) {
 		struct device *cpu_dev;
 
 		if (j == policy->cpu)
@@ -881,12 +881,16 @@ static int cpufreq_add_dev_symlink(struct cpufreq_policy *policy)
 	return ret;
 }
 
-static int cpufreq_add_dev_interface(struct cpufreq_policy *policy,
-				     struct device *dev)
+static int cpufreq_add_dev_interface(struct cpufreq_policy *policy)
 {
 	struct freq_attr **drv_attr;
+	struct device *dev;
 	int ret = 0;
 
+	dev = get_cpu_device(policy->cpu);
+	if (!dev)
+		return -EINVAL;
+
 	/* prepare interface data */
 	ret = kobject_init_and_add(&policy->kobj, &ktype_cpufreq,
 				   &dev->kobj, "cpufreq");
@@ -961,12 +965,13 @@ static void cpufreq_init_policy(struct cpufreq_policy *policy)
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy,
-				  unsigned int cpu, struct device *dev)
+static int cpufreq_change_policy_cpus(struct cpufreq_policy *policy,
+				  unsigned int cpu, bool add)
 {
 	int ret = 0;
 	unsigned long flags;
 
+	/* FIXME: Don't send START/STOP when going from/to 0 cpus */
 	if (has_target()) {
 		ret = __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
 		if (ret) {
@@ -979,7 +984,11 @@ static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy,
 
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
 
-	cpumask_set_cpu(cpu, policy->cpus);
+	if (add)
+		cpumask_set_cpu(cpu, policy->cpus);
+	else
+		cpumask_clear_cpu(cpu, policy->cpus);
+
 	per_cpu(cpufreq_cpu_data, cpu) = policy;
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
@@ -995,27 +1004,9 @@ static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy,
 			return ret;
 		}
 	}
-
-	return sysfs_create_link(&dev->kobj, &policy->kobj, "cpufreq");
 }
 #endif
 
-static struct cpufreq_policy *cpufreq_policy_restore(unsigned int cpu)
-{
-	struct cpufreq_policy *policy;
-	unsigned long flags;
-
-	read_lock_irqsave(&cpufreq_driver_lock, flags);
-
-	policy = per_cpu(cpufreq_cpu_data_fallback, cpu);
-
-	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
-
-	policy->governor = NULL;
-
-	return policy;
-}
-
 static struct cpufreq_policy *cpufreq_policy_alloc(void)
 {
 	struct cpufreq_policy *policy;
@@ -1076,22 +1067,6 @@ static void cpufreq_policy_free(struct cpufreq_policy *policy)
 	kfree(policy);
 }
 
-static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
-{
-	if (WARN_ON(cpu == policy->cpu))
-		return;
-
-	down_write(&policy->rwsem);
-
-	policy->last_cpu = policy->cpu;
-	policy->cpu = cpu;
-
-	up_write(&policy->rwsem);
-
-	blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
-			CPUFREQ_UPDATE_POLICY_CPU, policy);
-}
-
 static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 {
 	unsigned int j, cpu = dev->id;
@@ -1111,55 +1086,28 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 #ifdef CONFIG_SMP
 	/* check whether a different CPU already registered this
 	 * CPU because it is in the same boat. */
+	/* FIXME: This probably needs fixing to avoid "try lock" from
+	 * returning NULL. Also, change to likely() */
 	policy = cpufreq_cpu_get(cpu);
 	if (unlikely(policy)) {
+		cpufreq_change_policy_cpus(policy, cpu, true);
 		cpufreq_cpu_put(policy);
 		return 0;
 	}
 #endif
 
+	/* FIXME: Is returning 0 the right thing to do?! Existing code */
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
-
-	/*
-	 * Restore the saved policy when doing light-weight init and fall back
-	 * to the full init if that fails.
-	 */
-	policy = recover_policy ? cpufreq_policy_restore(cpu) : NULL;
-	if (!policy) {
-		recover_policy = false;
-		policy = cpufreq_policy_alloc();
-		if (!policy)
-			goto nomem_out;
-	}
-
-	/*
-	 * In the resume path, since we restore a saved policy, the assignment
-	 * to policy->cpu is like an update of the existing policy, rather than
-	 * the creation of a brand new one. So we need to perform this update
-	 * by invoking update_policy_cpu().
-	 */
-	if (recover_policy && cpu != policy->cpu)
-		update_policy_cpu(policy, cpu);
-	else
-		policy->cpu = cpu;
+	/* If we get this far, this is the first time we are adding the
+	 * policy */
+	policy = cpufreq_policy_alloc();
+	if (!policy)
+		goto nomem_out;
+	policy->cpu = cpu;
 
 	cpumask_copy(policy->cpus, cpumask_of(cpu));
-
 	init_completion(&policy->kobj_unregister);
 	INIT_WORK(&policy->update, handle_update);
 
@@ -1175,20 +1123,23 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 	/* related cpus should atleast have policy->cpus */
 	cpumask_or(policy->related_cpus, policy->related_cpus, policy->cpus);
 
+	/* Weed out impossible CPUs. */
+	cpumask_and(policy->related_cpus, policy->related_cpus,
+			cpu_possible_mask);
+
+	/* Just make the first CPU in the policy as the permanent owner of
+	 * the sysfs nodes. It doesn't need to be online to host the nodes */
+	policy->cpu = cpumask_first(policy->related_cpus);
+
 	/*
 	 * affected cpus must always be the one, which are online. We aren't
 	 * managing offline cpus here.
 	 */
 	cpumask_and(policy->cpus, policy->cpus, cpu_online_mask);
 
-	if (!recover_policy) {
-		policy->user_policy.min = policy->min;
-		policy->user_policy.max = policy->max;
-	}
-
 	down_write(&policy->rwsem);
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
-	for_each_cpu(j, policy->cpus)
+	for_each_cpu(j, policy->related_cpus)
 		per_cpu(cpufreq_cpu_data, j) = policy;
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
@@ -1243,13 +1194,11 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 	blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
 				     CPUFREQ_START, policy);
 
-	if (!recover_policy) {
-		ret = cpufreq_add_dev_interface(policy, dev);
-		if (ret)
-			goto err_out_unregister;
-		blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
-				CPUFREQ_CREATE_POLICY, policy);
-	}
+	ret = cpufreq_add_dev_interface(policy);
+	if (ret)
+		goto err_out_unregister;
+	blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
+			CPUFREQ_CREATE_POLICY, policy);
 
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
 	list_add(&policy->policy_list, &cpufreq_policy_list);
@@ -1257,10 +1206,6 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 
 	cpufreq_init_policy(policy);
 
-	if (!recover_policy) {
-		policy->user_policy.policy = policy->policy;
-		policy->user_policy.governor = policy->governor;
-	}
 	up_write(&policy->rwsem);
 
 	kobject_uevent(&policy->kobj, KOBJ_ADD);
@@ -1307,161 +1252,43 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 	return __cpufreq_add_dev(dev, sif);
 }
 
-static int cpufreq_nominate_new_policy_cpu(struct cpufreq_policy *policy,
-					   unsigned int old_cpu)
-{
-	struct device *cpu_dev;
-	int ret;
-
-	/* first sibling now owns the new sysfs dir */
-	cpu_dev = get_cpu_device(cpumask_any_but(policy->cpus, old_cpu));
-
-	sysfs_remove_link(&cpu_dev->kobj, "cpufreq");
-	ret = kobject_move(&policy->kobj, &cpu_dev->kobj);
-	if (ret) {
-		pr_err("%s: Failed to move kobj: %d\n", __func__, ret);
-
-		down_write(&policy->rwsem);
-		cpumask_set_cpu(old_cpu, policy->cpus);
-		up_write(&policy->rwsem);
-
-		ret = sysfs_create_link(&cpu_dev->kobj, &policy->kobj,
-					"cpufreq");
-
-		return -EINVAL;
-	}
-
-	return cpu_dev->id;
-}
-
-static int __cpufreq_remove_dev_prepare(struct device *dev,
-					struct subsys_interface *sif)
+static int __cpufreq_remove_dev(struct device *dev,
+				struct subsys_interface *sif)
 {
 	unsigned int cpu = dev->id, cpus;
-	int new_cpu, ret;
+	int ret;
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
 		return -EINVAL;
 	}
 
-	if (has_target()) {
-		ret = __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
-		if (ret) {
-			pr_err("%s: Failed to stop governor\n", __func__);
-			return ret;
-		}
-	}
-
-	if (!cpufreq_driver->setpolicy)
-		strncpy(per_cpu(cpufreq_cpu_governor, cpu),
-			policy->governor->name, CPUFREQ_NAME_LEN);
+#ifdef CONFIG_HOTPLUG_CPU
+	ret = cpufreq_change_policy_cpus(policy, cpu, false);
+	/* FIXME: Handle error */
+#endif
 
+	/* FIXME: This stuff below would get pulled into change_policy_cpus.
+	 * Keeping it here just for the RFC diff to be easy to read. */
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
-		}
-	} else if (cpufreq_driver->stop_cpu && cpufreq_driver->setpolicy) {
+	if (cpus < 1 && cpufreq_driver->stop_cpu && cpufreq_driver->setpolicy) {
 		cpufreq_driver->stop_cpu(policy);
 	}
 
 	return 0;
 }
 
-static int __cpufreq_remove_dev_finish(struct device *dev,
-				       struct subsys_interface *sif)
-{
-	unsigned int cpu = dev->id, cpus;
-	int ret;
-	unsigned long flags;
-	struct cpufreq_policy *policy;
-
-	read_lock_irqsave(&cpufreq_driver_lock, flags);
-	policy = per_cpu(cpufreq_cpu_data, cpu);
-	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
-
-	if (!policy) {
-		pr_debug("%s: No cpu_data found\n", __func__);
-		return -EINVAL;
-	}
-
-	down_write(&policy->rwsem);
-	cpus = cpumask_weight(policy->cpus);
-
-	if (cpus > 1)
-		cpumask_clear_cpu(cpu, policy->cpus);
-	up_write(&policy->rwsem);
-
-	/* If cpu is last user of policy, free policy */
-	if (cpus == 1) {
-		if (has_target()) {
-			ret = __cpufreq_governor(policy,
-					CPUFREQ_GOV_POLICY_EXIT);
-			if (ret) {
-				pr_err("%s: Failed to exit governor\n",
-				       __func__);
-				return ret;
-			}
-		}
-
-		if (!cpufreq_suspended)
-			cpufreq_policy_put_kobj(policy);
-
-		/*
-		 * Perform the ->exit() even during light-weight tear-down,
-		 * since this is a core component, and is essential for the
-		 * subsequent light-weight ->init() to succeed.
-		 */
-		if (cpufreq_driver->exit)
-			cpufreq_driver->exit(policy);
-
-		/* Remove policy from list of active policies */
-		write_lock_irqsave(&cpufreq_driver_lock, flags);
-		list_del(&policy->policy_list);
-		write_unlock_irqrestore(&cpufreq_driver_lock, flags);
-
-		if (!cpufreq_suspended)
-			cpufreq_policy_free(policy);
-	} else if (has_target()) {
-		ret = __cpufreq_governor(policy, CPUFREQ_GOV_START);
-		if (!ret)
-			ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
-
-		if (ret) {
-			pr_err("%s: Failed to start governor\n", __func__);
-			return ret;
-		}
-	}
-
-	per_cpu(cpufreq_cpu_data, cpu) = NULL;
-	return 0;
-}
-
 /**
  * cpufreq_remove_dev - remove a CPU device
  *
@@ -1475,10 +1302,7 @@ static int cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif)
 	if (cpu_is_offline(cpu))
 		return 0;
 
-	ret = __cpufreq_remove_dev_prepare(dev, sif);
-
-	if (!ret)
-		ret = __cpufreq_remove_dev_finish(dev, sif);
+	ret = __cpufreq_remove_dev(dev, sif);
 
 	return ret;
 }
@@ -2295,19 +2119,12 @@ static int cpufreq_cpu_callback(struct notifier_block *nfb,
 	if (dev) {
 		switch (action & ~CPU_TASKS_FROZEN) {
 		case CPU_ONLINE:
+		case CPU_DOWN_FAILED:
 			__cpufreq_add_dev(dev, NULL);
 			break;
 
 		case CPU_DOWN_PREPARE:
-			__cpufreq_remove_dev_prepare(dev, NULL);
-			break;
-
-		case CPU_POST_DEAD:
-			__cpufreq_remove_dev_finish(dev, NULL);
-			break;
-
-		case CPU_DOWN_FAILED:
-			__cpufreq_add_dev(dev, NULL);
+			__cpufreq_remove_dev(dev, NULL);
 			break;
 		}
 	}
-- 
1.8.2.1

The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
