Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab3HCLu6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 07:50:58 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:60478 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab3HCLux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 07:50:53 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        l.majewski@samsung.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 09/10] cpufreq: Don't use cpufreq_driver->owner's refcount to protect critical sections
Date: Sat,  3 Aug 2013 17:19:27 +0530
Message-Id: <bf50a85f6c2a52c36e48bbaf06dbf79f9c8a7091.1375530162.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1375530162.git.viresh.kumar@linaro.org>
References: <cover.1375530162.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1375530162.git.viresh.kumar@linaro.org>
References: <cover.1375530162.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are protecting critical sections of cpufreq core with the help of owner's
refcount, which isn't the correct approach. As rmmod returns error when some
routine has updated the module's refcount.

Lets use rwsem for this.. Only cpufreq_unregister_driver() will use write sem
and everybody else will use read sem.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 135 ++++++++++++++++++++--------------------------
 1 file changed, 57 insertions(+), 78 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 74d4969..70399ea 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -90,6 +90,12 @@ static void unlock_policy_rwsem_##mode(int cpu)				\
 unlock_policy_rwsem(read, cpu);
 unlock_policy_rwsem(write, cpu);
 
+/*
+ * rwsem to guarantee that cpufreq driver module doesn't unload during critical
+ * sections
+ */
+static DECLARE_RWSEM(cpufreq_rwsem);
+
 /* internal prototypes */
 static int __cpufreq_governor(struct cpufreq_policy *policy,
 		unsigned int event);
@@ -177,78 +183,46 @@ u64 get_cpu_idle_time(unsigned int cpu, u64 *wall, int io_busy)
 }
 EXPORT_SYMBOL_GPL(get_cpu_idle_time);
 
-static struct cpufreq_policy *__cpufreq_cpu_get(unsigned int cpu, bool sysfs)
+struct cpufreq_policy *cpufreq_cpu_get(unsigned int cpu)
 {
-	struct cpufreq_policy *policy;
+	struct cpufreq_policy *policy = NULL;
 	unsigned long flags;
 
-	if (cpu >= nr_cpu_ids)
-		goto err_out;
+	if (cpufreq_disabled() || (cpu >= nr_cpu_ids))
+		return NULL;
+
+	if (!down_read_trylock(&cpufreq_rwsem))
+		return NULL;
 
 	/* get the cpufreq driver */
 	read_lock_irqsave(&cpufreq_driver_lock, flags);
 
-	if (!cpufreq_driver)
-		goto err_out_unlock;
-
-	if (!try_module_get(cpufreq_driver->owner))
-		goto err_out_unlock;
+	if (cpufreq_driver) {
+		/* get the CPU */
+		policy = per_cpu(cpufreq_cpu_data, cpu);
+		if (policy)
+			kobject_get(&policy->kobj);
+	}
 
-	/* get the CPU */
-	policy = per_cpu(cpufreq_cpu_data, cpu);
+	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	if (!policy)
-		goto err_out_put_module;
-
-	if (!sysfs && !kobject_get(&policy->kobj))
-		goto err_out_put_module;
+		up_read(&cpufreq_rwsem);
 
-	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
 	return policy;
-
-err_out_put_module:
-	module_put(cpufreq_driver->owner);
-err_out_unlock:
-	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
-err_out:
-	return NULL;
-}
-
-struct cpufreq_policy *cpufreq_cpu_get(unsigned int cpu)
-{
-	if (cpufreq_disabled())
-		return NULL;
-
-	return __cpufreq_cpu_get(cpu, false);
 }
 EXPORT_SYMBOL_GPL(cpufreq_cpu_get);
 
-static struct cpufreq_policy *cpufreq_cpu_get_sysfs(unsigned int cpu)
-{
-	return __cpufreq_cpu_get(cpu, true);
-}
-
-static void __cpufreq_cpu_put(struct cpufreq_policy *policy, bool sysfs)
-{
-	if (!sysfs)
-		kobject_put(&policy->kobj);
-	module_put(cpufreq_driver->owner);
-}
-
 void cpufreq_cpu_put(struct cpufreq_policy *policy)
 {
 	if (cpufreq_disabled())
 		return;
 
-	__cpufreq_cpu_put(policy, false);
+	kobject_put(&policy->kobj);
+	up_read(&cpufreq_rwsem);
 }
 EXPORT_SYMBOL_GPL(cpufreq_cpu_put);
 
-static void cpufreq_cpu_put_sysfs(struct cpufreq_policy *policy)
-{
-	__cpufreq_cpu_put(policy, true);
-}
-
 /*********************************************************************
  *            EXTERNALLY AFFECTING FREQUENCY CHANGES                 *
  *********************************************************************/
@@ -693,12 +667,12 @@ static ssize_t show(struct kobject *kobj, struct attribute *attr, char *buf)
 	struct cpufreq_policy *policy = to_policy(kobj);
 	struct freq_attr *fattr = to_attr(attr);
 	ssize_t ret = -EINVAL;
-	policy = cpufreq_cpu_get_sysfs(policy->cpu);
-	if (!policy)
-		goto no_policy;
+
+	if (!down_read_trylock(&cpufreq_rwsem))
+		goto exit;
 
 	if (lock_policy_rwsem_read(policy->cpu) < 0)
-		goto fail;
+		goto up_read;
 
 	if (fattr->show)
 		ret = fattr->show(policy, buf);
@@ -706,9 +680,10 @@ static ssize_t show(struct kobject *kobj, struct attribute *attr, char *buf)
 		ret = -EIO;
 
 	unlock_policy_rwsem_read(policy->cpu);
-fail:
-	cpufreq_cpu_put_sysfs(policy);
-no_policy:
+
+up_read:
+	up_read(&cpufreq_rwsem);
+exit:
 	return ret;
 }
 
@@ -718,12 +693,12 @@ static ssize_t store(struct kobject *kobj, struct attribute *attr,
 	struct cpufreq_policy *policy = to_policy(kobj);
 	struct freq_attr *fattr = to_attr(attr);
 	ssize_t ret = -EINVAL;
-	policy = cpufreq_cpu_get_sysfs(policy->cpu);
-	if (!policy)
-		goto no_policy;
+
+	if (!down_read_trylock(&cpufreq_rwsem))
+		goto exit;
 
 	if (lock_policy_rwsem_write(policy->cpu) < 0)
-		goto fail;
+		goto up_read;
 
 	if (fattr->store)
 		ret = fattr->store(policy, buf, count);
@@ -731,9 +706,10 @@ static ssize_t store(struct kobject *kobj, struct attribute *attr,
 		ret = -EIO;
 
 	unlock_policy_rwsem_write(policy->cpu);
-fail:
-	cpufreq_cpu_put_sysfs(policy);
-no_policy:
+
+up_read:
+	up_read(&cpufreq_rwsem);
+exit:
 	return ret;
 }
 
@@ -1001,25 +977,24 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 		return 0;
 	}
 
+	if (!down_read_trylock(&cpufreq_rwsem))
+		return 0;
+
 #ifdef CONFIG_HOTPLUG_CPU
 	/* Check if this cpu was hot-unplugged earlier and has siblings */
 	read_lock_irqsave(&cpufreq_driver_lock, flags);
 	list_for_each_entry(tpolicy, &cpufreq_policy_list, policy_list) {
 		if (cpumask_test_cpu(cpu, tpolicy->related_cpus)) {
 			read_unlock_irqrestore(&cpufreq_driver_lock, flags);
-			return cpufreq_add_policy_cpu(tpolicy, cpu, dev,
-					frozen);
+			ret = cpufreq_add_policy_cpu(tpolicy, cpu, dev, frozen);
+			up_read(&cpufreq_rwsem);
+			return ret;
 		}
 	}
 	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
 #endif
 #endif
 
-	if (!try_module_get(cpufreq_driver->owner)) {
-		ret = -EINVAL;
-		goto module_out;
-	}
-
 	if (frozen)
 		/* Restore the saved policy when doing light-weight init */
 		policy = cpufreq_policy_restore(cpu);
@@ -1092,7 +1067,8 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 	cpufreq_init_policy(policy);
 
 	kobject_uevent(&policy->kobj, KOBJ_ADD);
-	module_put(cpufreq_driver->owner);
+	up_read(&cpufreq_rwsem);
+
 	pr_debug("initialization complete\n");
 
 	return 0;
@@ -1110,8 +1086,8 @@ err_set_policy_cpu:
 	per_cpu(cpufreq_policy_cpu, cpu) = -1;
 	cpufreq_policy_free(policy);
 nomem_out:
-	module_put(cpufreq_driver->owner);
-module_out:
+	up_read(&cpufreq_rwsem);
+
 	return ret;
 }
 
@@ -1423,10 +1399,9 @@ static unsigned int __cpufreq_get(unsigned int cpu)
 unsigned int cpufreq_get(unsigned int cpu)
 {
 	unsigned int ret_freq = 0;
-	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
 
-	if (!policy)
-		goto out;
+	if (!down_read_trylock(&cpufreq_rwsem))
+		return 0;
 
 	if (unlikely(lock_policy_rwsem_read(cpu)))
 		goto out_policy;
@@ -1436,8 +1411,8 @@ unsigned int cpufreq_get(unsigned int cpu)
 	unlock_policy_rwsem_read(cpu);
 
 out_policy:
-	cpufreq_cpu_put(policy);
-out:
+	up_read(&cpufreq_rwsem);
+
 	return ret_freq;
 }
 EXPORT_SYMBOL(cpufreq_get);
@@ -2130,9 +2105,13 @@ int cpufreq_unregister_driver(struct cpufreq_driver *driver)
 	subsys_interface_unregister(&cpufreq_interface);
 	unregister_hotcpu_notifier(&cpufreq_cpu_notifier);
 
+	down_write(&cpufreq_rwsem);
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
+
 	cpufreq_driver = NULL;
+
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	up_write(&cpufreq_rwsem);
 
 	return 0;
 }
-- 
1.7.12.rc2.18.g61b472e

