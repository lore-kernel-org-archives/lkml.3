Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab3IQPu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 11:50:58 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:43557 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab3IQPu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 11:50:56 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] cpufreq: create per policy rwsem instead of per cpu cpu_policy_rwsem
Date: Tue, 17 Sep 2013 21:20:39 +0530
Message-Id: <141ec437a203e4384459abb22e393d83136f732d.1379432906.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have per-cpu cpu_policy_rwsem for cpufreq core, but we never use all of them.
We always use rwsem of policy->cpu and so we can actually make this rwsem per
policy instead.

This patch does this change. With this change other tricky situations are also
avoided now, like which lock to take while we are changing policy->cpu, etc.

Suggested-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
Can be taken for 3.13.. Tested on my thinkpad with basic suspend/resume and
hotplug tests.

Was rebased on pm/linux-next with following additional patches:
cpufreq: unlock correct rwsem while updating policy->cpu
cpufreq: make return type of lock_policy_rwsem_{read|write}() as void

 drivers/cpufreq/cpufreq.c | 110 +++++++++++++---------------------------------
 include/linux/cpufreq.h   |  16 +++++++
 2 files changed, 47 insertions(+), 79 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 28b5386..b428419 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -48,47 +48,6 @@ static DEFINE_PER_CPU(char[CPUFREQ_NAME_LEN], cpufreq_cpu_governor);
 #endif
 
 /*
- * cpu_policy_rwsem is a per CPU reader-writer semaphore designed to cure
- * all cpufreq/hotplug/workqueue/etc related lock issues.
- *
- * The rules for this semaphore:
- * - Any routine that wants to read from the policy structure will
- *   do a down_read on this semaphore.
- * - Any routine that will write to the policy structure and/or may take away
- *   the policy altogether (eg. CPU hotplug), will hold this lock in write
- *   mode before doing so.
- *
- * Additional rules:
- * - Governor routines that can be called in cpufreq hotplug path should not
- *   take this sem as top level hotplug notifier handler takes this.
- * - Lock should not be held across
- *     __cpufreq_governor(data, CPUFREQ_GOV_STOP);
- */
-static DEFINE_PER_CPU(struct rw_semaphore, cpu_policy_rwsem);
-
-#define lock_policy_rwsem(mode, cpu)					\
-static void lock_policy_rwsem_##mode(int cpu)				\
-{									\
-	struct cpufreq_policy *policy = per_cpu(cpufreq_cpu_data, cpu);	\
-	BUG_ON(!policy);						\
-	down_##mode(&per_cpu(cpu_policy_rwsem, policy->cpu));		\
-}
-
-lock_policy_rwsem(read, cpu);
-lock_policy_rwsem(write, cpu);
-
-#define unlock_policy_rwsem(mode, cpu)					\
-static void unlock_policy_rwsem_##mode(int cpu)				\
-{									\
-	struct cpufreq_policy *policy = per_cpu(cpufreq_cpu_data, cpu);	\
-	BUG_ON(!policy);						\
-	up_##mode(&per_cpu(cpu_policy_rwsem, policy->cpu));		\
-}
-
-unlock_policy_rwsem(read, cpu);
-unlock_policy_rwsem(write, cpu);
-
-/*
  * rwsem to guarantee that cpufreq driver module doesn't unload during critical
  * sections
  */
@@ -656,14 +615,14 @@ static ssize_t show(struct kobject *kobj, struct attribute *attr, char *buf)
 	if (!down_read_trylock(&cpufreq_rwsem))
 		return -EINVAL;
 
-	lock_policy_rwsem_read(policy->cpu);
+	down_read(&policy->rwsem);
 
 	if (fattr->show)
 		ret = fattr->show(policy, buf);
 	else
 		ret = -EIO;
 
-	unlock_policy_rwsem_read(policy->cpu);
+	up_read(&policy->rwsem);
 	up_read(&cpufreq_rwsem);
 
 	return ret;
@@ -684,14 +643,14 @@ static ssize_t store(struct kobject *kobj, struct attribute *attr,
 	if (!down_read_trylock(&cpufreq_rwsem))
 		goto unlock;
 
-	lock_policy_rwsem_write(policy->cpu);
+	down_write(&policy->rwsem);
 
 	if (fattr->store)
 		ret = fattr->store(policy, buf, count);
 	else
 		ret = -EIO;
 
-	unlock_policy_rwsem_write(policy->cpu);
+	up_write(&policy->rwsem);
 
 	up_read(&cpufreq_rwsem);
 unlock:
@@ -868,7 +827,7 @@ static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy,
 		}
 	}
 
-	lock_policy_rwsem_write(policy->cpu);
+	down_write(&policy->rwsem);
 
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
 
@@ -876,7 +835,7 @@ static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy,
 	per_cpu(cpufreq_cpu_data, cpu) = policy;
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
-	unlock_policy_rwsem_write(policy->cpu);
+	up_write(&policy->rwsem);
 
 	if (has_target) {
 		if ((ret = __cpufreq_governor(policy, CPUFREQ_GOV_START)) ||
@@ -923,6 +882,8 @@ static struct cpufreq_policy *cpufreq_policy_alloc(void)
 		goto err_free_cpumask;
 
 	INIT_LIST_HEAD(&policy->policy_list);
+	init_rwsem(&policy->rwsem);
+
 	return policy;
 
 err_free_cpumask:
@@ -945,19 +906,12 @@ static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
 	if (cpu == policy->cpu)
 		return;
 
-	/*
-	 * Take direct locks as lock_policy_rwsem_write wouldn't work here.
-	 * Also lock for last cpu is enough here as contention will happen only
-	 * after policy->cpu is changed and after it is changed, other threads
-	 * will try to acquire lock for new cpu. And policy is already updated
-	 * by then.
-	 */
-	down_write(&per_cpu(cpu_policy_rwsem, policy->cpu));
+	down_write(&policy->rwsem);
 
 	policy->last_cpu = policy->cpu;
 	policy->cpu = cpu;
 
-	up_write(&per_cpu(cpu_policy_rwsem, policy->last_cpu));
+	up_write(&policy->rwsem);
 
 #ifdef CONFIG_CPU_FREQ_TABLE
 	cpufreq_frequency_table_update_policy_cpu(policy);
@@ -1140,9 +1094,9 @@ static int cpufreq_nominate_new_policy_cpu(struct cpufreq_policy *policy,
 	if (ret) {
 		pr_err("%s: Failed to move kobj: %d", __func__, ret);
 
-		lock_policy_rwsem_write(old_cpu);
+		down_write(&policy->rwsem);
 		cpumask_set_cpu(old_cpu, policy->cpus);
-		unlock_policy_rwsem_write(old_cpu);
+		up_write(&policy->rwsem);
 
 		ret = sysfs_create_link(&cpu_dev->kobj, &policy->kobj,
 					"cpufreq");
@@ -1193,12 +1147,12 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
 			policy->governor->name, CPUFREQ_NAME_LEN);
 #endif
 
-	lock_policy_rwsem_write(cpu);
+	down_write(&policy->rwsem);
 	cpus = cpumask_weight(policy->cpus);
 
 	if (cpus > 1)
 		cpumask_clear_cpu(cpu, policy->cpus);
-	unlock_policy_rwsem_write(cpu);
+	up_write(&policy->rwsem);
 
 	if (cpu != policy->cpu) {
 		if (!frozen)
@@ -1239,9 +1193,9 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
 		return -EINVAL;
 	}
 
-	lock_policy_rwsem_read(cpu);
+	down_read(&policy->rwsem);
 	cpus = cpumask_weight(policy->cpus);
-	unlock_policy_rwsem_read(cpu);
+	up_read(&policy->rwsem);
 
 	/* If cpu is last user of policy, free policy */
 	if (cpus == 1) {
@@ -1256,10 +1210,10 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
 		}
 
 		if (!frozen) {
-			lock_policy_rwsem_read(cpu);
+			down_read(&policy->rwsem);
 			kobj = &policy->kobj;
 			cmp = &policy->kobj_unregister;
-			unlock_policy_rwsem_read(cpu);
+			up_read(&policy->rwsem);
 			kobject_put(kobj);
 
 			/*
@@ -1451,16 +1405,19 @@ static unsigned int __cpufreq_get(unsigned int cpu)
  */
 unsigned int cpufreq_get(unsigned int cpu)
 {
+	struct cpufreq_policy *policy = per_cpu(cpufreq_cpu_data, cpu);
 	unsigned int ret_freq = 0;
 
+	BUG_ON(!policy);
+
 	if (!down_read_trylock(&cpufreq_rwsem))
 		return 0;
 
-	lock_policy_rwsem_read(cpu);
+	down_read(&policy->rwsem);
 
 	ret_freq = __cpufreq_get(cpu);
 
-	unlock_policy_rwsem_read(cpu);
+	up_read(&policy->rwsem);
 	up_read(&cpufreq_rwsem);
 
 	return ret_freq;
@@ -1684,11 +1641,11 @@ int cpufreq_driver_target(struct cpufreq_policy *policy,
 {
 	int ret = -EINVAL;
 
-	lock_policy_rwsem_write(policy->cpu);
+	down_write(&policy->rwsem);
 
 	ret = __cpufreq_driver_target(policy, target_freq, relation);
 
-	unlock_policy_rwsem_write(policy->cpu);
+	up_write(&policy->rwsem);
 
 	return ret;
 }
@@ -1919,10 +1876,10 @@ static int __cpufreq_set_policy(struct cpufreq_policy *policy,
 			/* end old governor */
 			if (policy->governor) {
 				__cpufreq_governor(policy, CPUFREQ_GOV_STOP);
-				unlock_policy_rwsem_write(new_policy->cpu);
+				up_write(&new_policy->rwsem);
 				__cpufreq_governor(policy,
 						CPUFREQ_GOV_POLICY_EXIT);
-				lock_policy_rwsem_write(new_policy->cpu);
+				down_write(&new_policy->rwsem);
 			}
 
 			/* start new governor */
@@ -1931,10 +1888,10 @@ static int __cpufreq_set_policy(struct cpufreq_policy *policy,
 				if (!__cpufreq_governor(policy, CPUFREQ_GOV_START)) {
 					failed = 0;
 				} else {
-					unlock_policy_rwsem_write(new_policy->cpu);
+					up_write(&new_policy->rwsem);
 					__cpufreq_governor(policy,
 							CPUFREQ_GOV_POLICY_EXIT);
-					lock_policy_rwsem_write(new_policy->cpu);
+					down_write(&new_policy->rwsem);
 				}
 			}
 
@@ -1980,7 +1937,7 @@ int cpufreq_update_policy(unsigned int cpu)
 		goto no_policy;
 	}
 
-	lock_policy_rwsem_write(cpu);
+	down_write(&policy->rwsem);
 
 	pr_debug("updating policy for CPU %u\n", cpu);
 	memcpy(&new_policy, policy, sizeof(*policy));
@@ -2007,7 +1964,7 @@ int cpufreq_update_policy(unsigned int cpu)
 
 	ret = __cpufreq_set_policy(policy, &new_policy);
 
-	unlock_policy_rwsem_write(cpu);
+	up_write(&policy->rwsem);
 
 	cpufreq_cpu_put(policy);
 no_policy:
@@ -2164,14 +2121,9 @@ EXPORT_SYMBOL_GPL(cpufreq_unregister_driver);
 
 static int __init cpufreq_core_init(void)
 {
-	int cpu;
-
 	if (cpufreq_disabled())
 		return -ENODEV;
 
-	for_each_possible_cpu(cpu)
-		init_rwsem(&per_cpu(cpu_policy_rwsem, cpu));
-
 	cpufreq_global_kobject = kobject_create();
 	BUG_ON(!cpufreq_global_kobject);
 	register_syscore_ops(&cpufreq_syscore_ops);
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index fcabc42..03735e7 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -85,6 +85,22 @@ struct cpufreq_policy {
 	struct list_head        policy_list;
 	struct kobject		kobj;
 	struct completion	kobj_unregister;
+
+	/*
+	 * The rules for this semaphore:
+	 * - Any routine that wants to read from the policy structure will
+	 *   do a down_read on this semaphore.
+	 * - Any routine that will write to the policy structure and/or may take away
+	 *   the policy altogether (eg. CPU hotplug), will hold this lock in write
+	 *   mode before doing so.
+	 *
+	 * Additional rules:
+	 * - Governor routines that can be called in cpufreq hotplug path should not
+	 *   take this sem as top level hotplug notifier handler takes this.
+	 * - Lock should not be held across
+	 *     __cpufreq_governor(data, CPUFREQ_GOV_POLICY_EXIT);
+	 */
+	struct rw_semaphore	rwsem;
 };
 
 /* Only for ACPI */
-- 
1.7.12.rc2.18.g61b472e

