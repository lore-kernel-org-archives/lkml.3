Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496Ab3HFRYB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 13:24:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37123 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756308Ab3HFRX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 13:23:58 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 03/11] cpufreq: Give consistent names for struct cpufreq_policy *
Date: Tue,  6 Aug 2013 22:53:05 +0530
Message-Id: <89ada5c5bcaaa7c59c1aabe04b5d17c1e50a345f.1375809311.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1375809311.git.viresh.kumar@linaro.org>
References: <cover.1375809311.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1375809311.git.viresh.kumar@linaro.org>
References: <cover.1375809311.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are named as policy, cur_policy, new_policy, data, etc.. Just name them
poicy wherever possible.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c          | 200 ++++++++++++++++++-------------------
 drivers/cpufreq/cpufreq_governor.h |   2 +-
 drivers/cpufreq/cpufreq_ondemand.c |  10 +-
 drivers/cpufreq/cpufreq_stats.c    |  12 +--
 include/linux/cpufreq.h            |   2 +-
 5 files changed, 113 insertions(+), 113 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index aaccfa0..8b087e5 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -179,7 +179,7 @@ EXPORT_SYMBOL_GPL(get_cpu_idle_time);
 
 static struct cpufreq_policy *__cpufreq_cpu_get(unsigned int cpu, bool sysfs)
 {
-	struct cpufreq_policy *data;
+	struct cpufreq_policy *policy;
 	unsigned long flags;
 
 	if (cpu >= nr_cpu_ids)
@@ -195,16 +195,16 @@ static struct cpufreq_policy *__cpufreq_cpu_get(unsigned int cpu, bool sysfs)
 		goto err_out_unlock;
 
 	/* get the CPU */
-	data = per_cpu(cpufreq_cpu_data, cpu);
+	policy = per_cpu(cpufreq_cpu_data, cpu);
 
-	if (!data)
+	if (!policy)
 		goto err_out_put_module;
 
-	if (!sysfs && !kobject_get(&data->kobj))
+	if (!sysfs && !kobject_get(&policy->kobj))
 		goto err_out_put_module;
 
 	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
-	return data;
+	return policy;
 
 err_out_put_module:
 	module_put(cpufreq_driver->owner);
@@ -228,25 +228,25 @@ static struct cpufreq_policy *cpufreq_cpu_get_sysfs(unsigned int cpu)
 	return __cpufreq_cpu_get(cpu, true);
 }
 
-static void __cpufreq_cpu_put(struct cpufreq_policy *data, bool sysfs)
+static void __cpufreq_cpu_put(struct cpufreq_policy *policy, bool sysfs)
 {
 	if (!sysfs)
-		kobject_put(&data->kobj);
+		kobject_put(&policy->kobj);
 	module_put(cpufreq_driver->owner);
 }
 
-void cpufreq_cpu_put(struct cpufreq_policy *data)
+void cpufreq_cpu_put(struct cpufreq_policy *policy)
 {
 	if (cpufreq_disabled())
 		return;
 
-	__cpufreq_cpu_put(data, false);
+	__cpufreq_cpu_put(policy, false);
 }
 EXPORT_SYMBOL_GPL(cpufreq_cpu_put);
 
-static void cpufreq_cpu_put_sysfs(struct cpufreq_policy *data)
+static void cpufreq_cpu_put_sysfs(struct cpufreq_policy *policy)
 {
-	__cpufreq_cpu_put(data, true);
+	__cpufreq_cpu_put(policy, true);
 }
 
 /*********************************************************************
@@ -453,8 +453,8 @@ show_one(scaling_min_freq, min);
 show_one(scaling_max_freq, max);
 show_one(scaling_cur_freq, cur);
 
-static int __cpufreq_set_policy(struct cpufreq_policy *data,
-				struct cpufreq_policy *policy);
+static int __cpufreq_set_policy(struct cpufreq_policy *policy,
+				struct cpufreq_policy *new_policy);
 
 /**
  * cpufreq_per_cpu_attr_write() / store_##file_name() - sysfs write access
@@ -1142,7 +1142,7 @@ static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
 			CPUFREQ_UPDATE_POLICY_CPU, policy);
 }
 
-static int cpufreq_nominate_new_policy_cpu(struct cpufreq_policy *data,
+static int cpufreq_nominate_new_policy_cpu(struct cpufreq_policy *policy,
 					   unsigned int old_cpu, bool frozen)
 {
 	struct device *cpu_dev;
@@ -1150,27 +1150,27 @@ static int cpufreq_nominate_new_policy_cpu(struct cpufreq_policy *data,
 	int ret;
 
 	/* first sibling now owns the new sysfs dir */
-	cpu_dev = get_cpu_device(cpumask_first(data->cpus));
+	cpu_dev = get_cpu_device(cpumask_first(policy->cpus));
 
 	/* Don't touch sysfs files during light-weight tear-down */
 	if (frozen)
 		return cpu_dev->id;
 
 	sysfs_remove_link(&cpu_dev->kobj, "cpufreq");
-	ret = kobject_move(&data->kobj, &cpu_dev->kobj);
+	ret = kobject_move(&policy->kobj, &cpu_dev->kobj);
 	if (ret) {
 		pr_err("%s: Failed to move kobj: %d", __func__, ret);
 
 		WARN_ON(lock_policy_rwsem_write(old_cpu));
-		cpumask_set_cpu(old_cpu, data->cpus);
+		cpumask_set_cpu(old_cpu, policy->cpus);
 
 		write_lock_irqsave(&cpufreq_driver_lock, flags);
-		per_cpu(cpufreq_cpu_data, old_cpu) = data;
+		per_cpu(cpufreq_cpu_data, old_cpu) = policy;
 		write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 		unlock_policy_rwsem_write(old_cpu);
 
-		ret = sysfs_create_link(&cpu_dev->kobj, &data->kobj,
+		ret = sysfs_create_link(&cpu_dev->kobj, &policy->kobj,
 					"cpufreq");
 
 		return -EINVAL;
@@ -1192,7 +1192,7 @@ static int __cpufreq_remove_dev(struct device *dev,
 	unsigned int cpu = dev->id, cpus;
 	int new_cpu;
 	unsigned long flags;
-	struct cpufreq_policy *data;
+	struct cpufreq_policy *policy;
 	struct kobject *kobj;
 	struct completion *cmp;
 
@@ -1200,44 +1200,44 @@ static int __cpufreq_remove_dev(struct device *dev,
 
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
 
-	data = per_cpu(cpufreq_cpu_data, cpu);
+	policy = per_cpu(cpufreq_cpu_data, cpu);
 	per_cpu(cpufreq_cpu_data, cpu) = NULL;
 
 	/* Save the policy somewhere when doing a light-weight tear-down */
 	if (frozen)
-		per_cpu(cpufreq_cpu_data_fallback, cpu) = data;
+		per_cpu(cpufreq_cpu_data_fallback, cpu) = policy;
 
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
-	if (!data) {
+	if (!policy) {
 		pr_debug("%s: No cpu_data found\n", __func__);
 		return -EINVAL;
 	}
 
 	if (cpufreq_driver->target)
-		__cpufreq_governor(data, CPUFREQ_GOV_STOP);
+		__cpufreq_governor(policy, CPUFREQ_GOV_STOP);
 
 #ifdef CONFIG_HOTPLUG_CPU
 	if (!cpufreq_driver->setpolicy)
 		strncpy(per_cpu(cpufreq_cpu_governor, cpu),
-			data->governor->name, CPUFREQ_NAME_LEN);
+			policy->governor->name, CPUFREQ_NAME_LEN);
 #endif
 
 	WARN_ON(lock_policy_rwsem_write(cpu));
-	cpus = cpumask_weight(data->cpus);
+	cpus = cpumask_weight(policy->cpus);
 
 	if (cpus > 1)
-		cpumask_clear_cpu(cpu, data->cpus);
+		cpumask_clear_cpu(cpu, policy->cpus);
 	unlock_policy_rwsem_write(cpu);
 
-	if (cpu != data->cpu && !frozen) {
+	if (cpu != policy->cpu && !frozen) {
 		sysfs_remove_link(&dev->kobj, "cpufreq");
 	} else if (cpus > 1) {
 
-		new_cpu = cpufreq_nominate_new_policy_cpu(data, cpu, frozen);
+		new_cpu = cpufreq_nominate_new_policy_cpu(policy, cpu, frozen);
 		if (new_cpu >= 0) {
 			WARN_ON(lock_policy_rwsem_write(cpu));
-			update_policy_cpu(data, new_cpu);
+			update_policy_cpu(policy, new_cpu);
 			unlock_policy_rwsem_write(cpu);
 
 			if (!frozen) {
@@ -1250,12 +1250,12 @@ static int __cpufreq_remove_dev(struct device *dev,
 	/* If cpu is last user of policy, free policy */
 	if (cpus == 1) {
 		if (cpufreq_driver->target)
-			__cpufreq_governor(data, CPUFREQ_GOV_POLICY_EXIT);
+			__cpufreq_governor(policy, CPUFREQ_GOV_POLICY_EXIT);
 
 		if (!frozen) {
 			lock_policy_rwsem_read(cpu);
-			kobj = &data->kobj;
-			cmp = &data->kobj_unregister;
+			kobj = &policy->kobj;
+			cmp = &policy->kobj_unregister;
 			unlock_policy_rwsem_read(cpu);
 			kobject_put(kobj);
 
@@ -1275,14 +1275,14 @@ static int __cpufreq_remove_dev(struct device *dev,
 		 * subsequent light-weight ->init() to succeed.
 		 */
 		if (cpufreq_driver->exit)
-			cpufreq_driver->exit(data);
+			cpufreq_driver->exit(policy);
 
 		if (!frozen)
-			cpufreq_policy_free(data);
+			cpufreq_policy_free(policy);
 	} else {
 		if (cpufreq_driver->target) {
-			__cpufreq_governor(data, CPUFREQ_GOV_START);
-			__cpufreq_governor(data, CPUFREQ_GOV_LIMITS);
+			__cpufreq_governor(policy, CPUFREQ_GOV_START);
+			__cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
 		}
 	}
 
@@ -1456,23 +1456,23 @@ static int cpufreq_bp_suspend(void)
 	int ret = 0;
 
 	int cpu = smp_processor_id();
-	struct cpufreq_policy *cpu_policy;
+	struct cpufreq_policy *policy;
 
 	pr_debug("suspending cpu %u\n", cpu);
 
 	/* If there's no policy for the boot CPU, we have nothing to do. */
-	cpu_policy = cpufreq_cpu_get(cpu);
-	if (!cpu_policy)
+	policy = cpufreq_cpu_get(cpu);
+	if (!policy)
 		return 0;
 
 	if (cpufreq_driver->suspend) {
-		ret = cpufreq_driver->suspend(cpu_policy);
+		ret = cpufreq_driver->suspend(policy);
 		if (ret)
 			printk(KERN_ERR "cpufreq: suspend failed in ->suspend "
-					"step on CPU %u\n", cpu_policy->cpu);
+					"step on CPU %u\n", policy->cpu);
 	}
 
-	cpufreq_cpu_put(cpu_policy);
+	cpufreq_cpu_put(policy);
 	return ret;
 }
 
@@ -1494,28 +1494,28 @@ static void cpufreq_bp_resume(void)
 	int ret = 0;
 
 	int cpu = smp_processor_id();
-	struct cpufreq_policy *cpu_policy;
+	struct cpufreq_policy *policy;
 
 	pr_debug("resuming cpu %u\n", cpu);
 
 	/* If there's no policy for the boot CPU, we have nothing to do. */
-	cpu_policy = cpufreq_cpu_get(cpu);
-	if (!cpu_policy)
+	policy = cpufreq_cpu_get(cpu);
+	if (!policy)
 		return;
 
 	if (cpufreq_driver->resume) {
-		ret = cpufreq_driver->resume(cpu_policy);
+		ret = cpufreq_driver->resume(policy);
 		if (ret) {
 			printk(KERN_ERR "cpufreq: resume failed in ->resume "
-					"step on CPU %u\n", cpu_policy->cpu);
+					"step on CPU %u\n", policy->cpu);
 			goto fail;
 		}
 	}
 
-	schedule_work(&cpu_policy->update);
+	schedule_work(&policy->update);
 
 fail:
-	cpufreq_cpu_put(cpu_policy);
+	cpufreq_cpu_put(policy);
 }
 
 static struct syscore_ops cpufreq_syscore_ops = {
@@ -1835,95 +1835,95 @@ EXPORT_SYMBOL(cpufreq_get_policy);
  * data   : current policy.
  * policy : policy to be set.
  */
-static int __cpufreq_set_policy(struct cpufreq_policy *data,
-				struct cpufreq_policy *policy)
+static int __cpufreq_set_policy(struct cpufreq_policy *policy,
+				struct cpufreq_policy *new_policy)
 {
 	int ret = 0, failed = 1;
 
-	pr_debug("setting new policy for CPU %u: %u - %u kHz\n", policy->cpu,
-		policy->min, policy->max);
+	pr_debug("setting new policy for CPU %u: %u - %u kHz\n", new_policy->cpu,
+		new_policy->min, new_policy->max);
 
-	memcpy(&policy->cpuinfo, &data->cpuinfo,
+	memcpy(&new_policy->cpuinfo, &policy->cpuinfo,
 				sizeof(struct cpufreq_cpuinfo));
 
-	if (policy->min > data->max || policy->max < data->min) {
+	if (new_policy->min > policy->max || new_policy->max < policy->min) {
 		ret = -EINVAL;
 		goto error_out;
 	}
 
 	/* verify the cpu speed can be set within this limit */
-	ret = cpufreq_driver->verify(policy);
+	ret = cpufreq_driver->verify(new_policy);
 	if (ret)
 		goto error_out;
 
 	/* adjust if necessary - all reasons */
 	blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
-			CPUFREQ_ADJUST, policy);
+			CPUFREQ_ADJUST, new_policy);
 
 	/* adjust if necessary - hardware incompatibility*/
 	blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
-			CPUFREQ_INCOMPATIBLE, policy);
+			CPUFREQ_INCOMPATIBLE, new_policy);
 
 	/*
 	 * verify the cpu speed can be set within this limit, which might be
 	 * different to the first one
 	 */
-	ret = cpufreq_driver->verify(policy);
+	ret = cpufreq_driver->verify(new_policy);
 	if (ret)
 		goto error_out;
 
 	/* notification of the new policy */
 	blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
-			CPUFREQ_NOTIFY, policy);
+			CPUFREQ_NOTIFY, new_policy);
 
-	data->min = policy->min;
-	data->max = policy->max;
+	policy->min = new_policy->min;
+	policy->max = new_policy->max;
 
 	pr_debug("new min and max freqs are %u - %u kHz\n",
-					data->min, data->max);
+					policy->min, policy->max);
 
 	if (cpufreq_driver->setpolicy) {
-		data->policy = policy->policy;
+		policy->policy = new_policy->policy;
 		pr_debug("setting range\n");
-		ret = cpufreq_driver->setpolicy(policy);
+		ret = cpufreq_driver->setpolicy(new_policy);
 	} else {
-		if (policy->governor != data->governor) {
+		if (new_policy->governor != policy->governor) {
 			/* save old, working values */
-			struct cpufreq_governor *old_gov = data->governor;
+			struct cpufreq_governor *old_gov = policy->governor;
 
 			pr_debug("governor switch\n");
 
 			/* end old governor */
-			if (data->governor) {
-				__cpufreq_governor(data, CPUFREQ_GOV_STOP);
-				unlock_policy_rwsem_write(policy->cpu);
-				__cpufreq_governor(data,
+			if (policy->governor) {
+				__cpufreq_governor(policy, CPUFREQ_GOV_STOP);
+				unlock_policy_rwsem_write(new_policy->cpu);
+				__cpufreq_governor(policy,
 						CPUFREQ_GOV_POLICY_EXIT);
-				lock_policy_rwsem_write(policy->cpu);
+				lock_policy_rwsem_write(new_policy->cpu);
 			}
 
 			/* start new governor */
-			data->governor = policy->governor;
-			if (!__cpufreq_governor(data, CPUFREQ_GOV_POLICY_INIT)) {
-				if (!__cpufreq_governor(data, CPUFREQ_GOV_START)) {
+			policy->governor = new_policy->governor;
+			if (!__cpufreq_governor(policy, CPUFREQ_GOV_POLICY_INIT)) {
+				if (!__cpufreq_governor(policy, CPUFREQ_GOV_START)) {
 					failed = 0;
 				} else {
-					unlock_policy_rwsem_write(policy->cpu);
-					__cpufreq_governor(data,
+					unlock_policy_rwsem_write(new_policy->cpu);
+					__cpufreq_governor(policy,
 							CPUFREQ_GOV_POLICY_EXIT);
-					lock_policy_rwsem_write(policy->cpu);
+					lock_policy_rwsem_write(new_policy->cpu);
 				}
 			}
 
 			if (failed) {
 				/* new governor failed, so re-start old one */
 				pr_debug("starting governor %s failed\n",
-							data->governor->name);
+							policy->governor->name);
 				if (old_gov) {
-					data->governor = old_gov;
-					__cpufreq_governor(data,
+					policy->governor = old_gov;
+					__cpufreq_governor(policy,
 							CPUFREQ_GOV_POLICY_INIT);
-					__cpufreq_governor(data,
+					__cpufreq_governor(policy,
 							   CPUFREQ_GOV_START);
 				}
 				ret = -EINVAL;
@@ -1932,7 +1932,7 @@ static int __cpufreq_set_policy(struct cpufreq_policy *data,
 			/* might be a policy change, too, so fall through */
 		}
 		pr_debug("governor: change or update limits\n");
-		__cpufreq_governor(data, CPUFREQ_GOV_LIMITS);
+		__cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
 	}
 
 error_out:
@@ -1948,11 +1948,11 @@ error_out:
  */
 int cpufreq_update_policy(unsigned int cpu)
 {
-	struct cpufreq_policy *data = cpufreq_cpu_get(cpu);
-	struct cpufreq_policy policy;
+	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
+	struct cpufreq_policy new_policy;
 	int ret;
 
-	if (!data) {
+	if (!policy) {
 		ret = -ENODEV;
 		goto no_policy;
 	}
@@ -1963,34 +1963,34 @@ int cpufreq_update_policy(unsigned int cpu)
 	}
 
 	pr_debug("updating policy for CPU %u\n", cpu);
-	memcpy(&policy, data, sizeof(struct cpufreq_policy));
-	policy.min = data->user_policy.min;
-	policy.max = data->user_policy.max;
-	policy.policy = data->user_policy.policy;
-	policy.governor = data->user_policy.governor;
+	memcpy(&new_policy, policy, sizeof(struct cpufreq_policy));
+	new_policy.min = policy->user_policy.min;
+	new_policy.max = policy->user_policy.max;
+	new_policy.policy = policy->user_policy.policy;
+	new_policy.governor = policy->user_policy.governor;
 
 	/*
 	 * BIOS might change freq behind our back
 	 * -> ask driver for current freq and notify governors about a change
 	 */
 	if (cpufreq_driver->get) {
-		policy.cur = cpufreq_driver->get(cpu);
-		if (!data->cur) {
+		new_policy.cur = cpufreq_driver->get(cpu);
+		if (!policy->cur) {
 			pr_debug("Driver did not initialize current freq");
-			data->cur = policy.cur;
+			policy->cur = new_policy.cur;
 		} else {
-			if (data->cur != policy.cur && cpufreq_driver->target)
-				cpufreq_out_of_sync(cpu, data->cur,
-								policy.cur);
+			if (policy->cur != new_policy.cur && cpufreq_driver->target)
+				cpufreq_out_of_sync(cpu, policy->cur,
+								new_policy.cur);
 		}
 	}
 
-	ret = __cpufreq_set_policy(data, &policy);
+	ret = __cpufreq_set_policy(policy, &new_policy);
 
 	unlock_policy_rwsem_write(cpu);
 
 fail:
-	cpufreq_cpu_put(data);
+	cpufreq_cpu_put(policy);
 no_policy:
 	return ret;
 }
diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
index 7db4373..a02d78b 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -221,7 +221,7 @@ struct od_ops {
 	void (*powersave_bias_init_cpu)(int cpu);
 	unsigned int (*powersave_bias_target)(struct cpufreq_policy *policy,
 			unsigned int freq_next, unsigned int relation);
-	void (*freq_increase)(struct cpufreq_policy *p, unsigned int freq);
+	void (*freq_increase)(struct cpufreq_policy *policy, unsigned int freq);
 };
 
 struct cs_ops {
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 232de60..8f134b3 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -132,18 +132,18 @@ static void ondemand_powersave_bias_init(void)
 	}
 }
 
-static void dbs_freq_increase(struct cpufreq_policy *p, unsigned int freq)
+static void dbs_freq_increase(struct cpufreq_policy *policy, unsigned int freq)
 {
-	struct dbs_data *dbs_data = p->governor_data;
+	struct dbs_data *dbs_data = policy->governor_data;
 	struct od_dbs_tuners *od_tuners = dbs_data->tuners;
 
 	if (od_tuners->powersave_bias)
-		freq = od_ops.powersave_bias_target(p, freq,
+		freq = od_ops.powersave_bias_target(policy, freq,
 				CPUFREQ_RELATION_H);
-	else if (p->cur == p->max)
+	else if (policy->cur == policy->max)
 		return;
 
-	__cpufreq_driver_target(p, freq, od_tuners->powersave_bias ?
+	__cpufreq_driver_target(policy, freq, od_tuners->powersave_bias ?
 			CPUFREQ_RELATION_L : CPUFREQ_RELATION_H);
 }
 
diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index a7143b0..a17b14e 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -193,7 +193,7 @@ static int cpufreq_stats_create_table(struct cpufreq_policy *policy,
 {
 	unsigned int i, j, count = 0, ret = 0;
 	struct cpufreq_stats *stat;
-	struct cpufreq_policy *data;
+	struct cpufreq_policy *current_policy;
 	unsigned int alloc_size;
 	unsigned int cpu = policy->cpu;
 	if (per_cpu(cpufreq_stats_table, cpu))
@@ -202,13 +202,13 @@ static int cpufreq_stats_create_table(struct cpufreq_policy *policy,
 	if ((stat) == NULL)
 		return -ENOMEM;
 
-	data = cpufreq_cpu_get(cpu);
-	if (data == NULL) {
+	current_policy = cpufreq_cpu_get(cpu);
+	if (current_policy == NULL) {
 		ret = -EINVAL;
 		goto error_get_fail;
 	}
 
-	ret = sysfs_create_group(&data->kobj, &stats_attr_group);
+	ret = sysfs_create_group(&current_policy->kobj, &stats_attr_group);
 	if (ret)
 		goto error_out;
 
@@ -251,10 +251,10 @@ static int cpufreq_stats_create_table(struct cpufreq_policy *policy,
 	stat->last_time = get_jiffies_64();
 	stat->last_index = freq_table_get_index(stat, policy->cur);
 	spin_unlock(&cpufreq_stats_lock);
-	cpufreq_cpu_put(data);
+	cpufreq_cpu_put(current_policy);
 	return 0;
 error_out:
-	cpufreq_cpu_put(data);
+	cpufreq_cpu_put(current_policy);
 error_get_fail:
 	kfree(stat);
 	per_cpu(cpufreq_stats_table, cpu) = NULL;
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 0d3b026..2920892 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -94,7 +94,7 @@ struct cpufreq_policy {
 #define CPUFREQ_SHARED_TYPE_ANY	 (3) /* Freq can be set from any dependent CPU*/
 
 struct cpufreq_policy *cpufreq_cpu_get(unsigned int cpu);
-void cpufreq_cpu_put(struct cpufreq_policy *data);
+void cpufreq_cpu_put(struct cpufreq_policy *policy);
 
 static inline bool policy_is_shared(struct cpufreq_policy *policy)
 {
-- 
1.7.12.rc2.18.g61b472e

