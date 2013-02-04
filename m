Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316Ab3BDWqL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 17:46:11 -0500
Received: from relay1.sgi.com ([192.48.179.29]:58201 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756219Ab3BDWqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 17:46:01 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
To: rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, Nathan Zimmer <nzimmer@sgi.com>
Subject: [PATCH 2/2] cpufreq: Convert the cpufreq_driver_lock to use the rcu
Date: Mon,  4 Feb 2013 16:45:13 -0600
Message-Id: <1360017913-25667-3-git-send-email-nzimmer@sgi.com>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1360017913-25667-1-git-send-email-nzimmer@sgi.com>
References: <1360017913-25667-1-git-send-email-nzimmer@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In general rwlocks are discourged so we are moving it to use the rcu instead.

CC: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
---
 drivers/cpufreq/cpufreq.c | 177 +++++++++++++++++++++++++---------------------
 1 file changed, 98 insertions(+), 79 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 13a83a2..5c5b9f4 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -39,13 +39,13 @@
  * level driver of CPUFreq support, and its spinlock. This lock
  * also protects the cpufreq_cpu_data array.
  */
-static struct cpufreq_driver *cpufreq_driver;
+static struct cpufreq_driver __rcu *cpufreq_driver;
 static DEFINE_PER_CPU(struct cpufreq_policy *, cpufreq_cpu_data);
 #ifdef CONFIG_HOTPLUG_CPU
 /* This one keeps track of the previously set governor of a removed CPU */
 static DEFINE_PER_CPU(char[CPUFREQ_NAME_LEN], cpufreq_cpu_governor);
 #endif
-static DEFINE_RWLOCK(cpufreq_driver_lock);
+static DEFINE_SPINLOCK(cpufreq_driver_lock);
 
 /*
  * cpu_policy_rwsem is a per CPU reader-writer semaphore designed to cure
@@ -143,21 +143,20 @@ static DEFINE_MUTEX(cpufreq_governor_mutex);
 static struct cpufreq_policy *__cpufreq_cpu_get(unsigned int cpu, bool sysfs)
 {
 	struct cpufreq_policy *data;
-	unsigned long flags;
+	struct cpufreq_driver *driver;
 
 	if (cpu >= nr_cpu_ids)
 		goto err_out;
 
 	/* get the cpufreq driver */
-	read_lock_irqsave(&cpufreq_driver_lock, flags);
-
-	if (!cpufreq_driver)
+	rcu_read_lock();
+	driver = rcu_dereference(cpufreq_driver);
+	if (!driver)
 		goto err_out_unlock;
 
-	if (!try_module_get(cpufreq_driver->owner))
+	if (!try_module_get(driver->owner))
 		goto err_out_unlock;
 
-
 	/* get the CPU */
 	data = per_cpu(cpufreq_cpu_data, cpu);
 
@@ -167,13 +166,13 @@ static struct cpufreq_policy *__cpufreq_cpu_get(unsigned int cpu, bool sysfs)
 	if (!sysfs && !kobject_get(&data->kobj))
 		goto err_out_put_module;
 
-	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	rcu_read_unlock();
 	return data;
 
 err_out_put_module:
-	module_put(cpufreq_driver->owner);
+	module_put(driver->owner);
 err_out_unlock:
-	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	rcu_read_unlock();
 err_out:
 	return NULL;
 }
@@ -193,7 +192,7 @@ static void __cpufreq_cpu_put(struct cpufreq_policy *data, bool sysfs)
 {
 	if (!sysfs)
 		kobject_put(&data->kobj);
-	module_put(cpufreq_driver->owner);
+	module_put(rcu_dereference(cpufreq_driver)->owner);
 }
 
 void cpufreq_cpu_put(struct cpufreq_policy *data)
@@ -261,10 +260,13 @@ static inline void adjust_jiffies(unsigned long val, struct cpufreq_freqs *ci)
 void cpufreq_notify_transition(struct cpufreq_freqs *freqs, unsigned int state)
 {
 	struct cpufreq_policy *policy;
+	struct cpufreq_driver *driver;
 
 	BUG_ON(irqs_disabled());
 
-	freqs->flags = cpufreq_driver->flags;
+	driver = rcu_dereference(cpufreq_driver);
+
+	freqs->flags = driver->flags;
 	pr_debug("notification %u of frequency transition to %u kHz\n",
 		state, freqs->new);
 
@@ -276,7 +278,7 @@ void cpufreq_notify_transition(struct cpufreq_freqs *freqs, unsigned int state)
 		 * which is not equal to what the cpufreq core thinks is
 		 * "old frequency".
 		 */
-		if (!(cpufreq_driver->flags & CPUFREQ_CONST_LOOPS)) {
+		if (!(driver->flags & CPUFREQ_CONST_LOOPS)) {
 			if ((policy) && (policy->cpu == freqs->cpu) &&
 			    (policy->cur) && (policy->cur != freqs->old)) {
 				pr_debug("Warning: CPU frequency is"
@@ -329,11 +331,12 @@ static int cpufreq_parse_governor(char *str_governor, unsigned int *policy,
 				struct cpufreq_governor **governor)
 {
 	int err = -EINVAL;
+	struct cpufreq_driver *driver = rcu_dereference(cpufreq_driver);
 
-	if (!cpufreq_driver)
+	if (!driver)
 		goto out;
 
-	if (cpufreq_driver->setpolicy) {
+	if (driver->setpolicy) {
 		if (!strnicmp(str_governor, "performance", CPUFREQ_NAME_LEN)) {
 			*policy = CPUFREQ_POLICY_PERFORMANCE;
 			err = 0;
@@ -342,7 +345,7 @@ static int cpufreq_parse_governor(char *str_governor, unsigned int *policy,
 			*policy = CPUFREQ_POLICY_POWERSAVE;
 			err = 0;
 		}
-	} else if (cpufreq_driver->target) {
+	} else if (driver->target) {
 		struct cpufreq_governor *t;
 
 		mutex_lock(&cpufreq_governor_mutex);
@@ -493,7 +496,8 @@ static ssize_t store_scaling_governor(struct cpufreq_policy *policy,
  */
 static ssize_t show_scaling_driver(struct cpufreq_policy *policy, char *buf)
 {
-	return scnprintf(buf, CPUFREQ_NAME_PLEN, "%s\n", cpufreq_driver->name);
+	return scnprintf(buf, CPUFREQ_NAME_PLEN, "%s\n",
+			 rcu_dereference(cpufreq_driver)->name);
 }
 
 /**
@@ -505,7 +509,7 @@ static ssize_t show_scaling_available_governors(struct cpufreq_policy *policy,
 	ssize_t i = 0;
 	struct cpufreq_governor *t;
 
-	if (!cpufreq_driver->target) {
+	if (!rcu_dereference(cpufreq_driver)->target) {
 		i += sprintf(buf, "performance powersave");
 		goto out;
 	}
@@ -589,8 +593,10 @@ static ssize_t show_bios_limit(struct cpufreq_policy *policy, char *buf)
 {
 	unsigned int limit;
 	int ret;
-	if (cpufreq_driver->bios_limit) {
-		ret = cpufreq_driver->bios_limit(policy->cpu, &limit);
+	struct cpufreq_driver *driver = rcu_dereference(cpufreq_driver);
+
+	if (driver->bios_limit) {
+		ret = driver->bios_limit(policy->cpu, &limit);
 		if (!ret)
 			return sprintf(buf, "%u\n", limit);
 	}
@@ -711,6 +717,7 @@ static int cpufreq_add_dev_policy(unsigned int cpu,
 				  struct device *dev)
 {
 	int ret = 0;
+	struct cpufreq_driver *driver;
 #ifdef CONFIG_SMP
 	unsigned long flags;
 	unsigned int j;
@@ -724,6 +731,7 @@ static int cpufreq_add_dev_policy(unsigned int cpu,
 		       policy->governor->name, cpu);
 	}
 #endif
+	driver = rcu_dereference(cpufreq_driver);
 
 	for_each_cpu(j, policy->cpus) {
 		struct cpufreq_policy *managed_policy;
@@ -745,16 +753,16 @@ static int cpufreq_add_dev_policy(unsigned int cpu,
 
 			if (lock_policy_rwsem_write(cpu) < 0) {
 				/* Should not go through policy unlock path */
-				if (cpufreq_driver->exit)
-					cpufreq_driver->exit(policy);
+				if (driver->exit)
+					driver->exit(policy);
 				cpufreq_cpu_put(managed_policy);
 				return -EBUSY;
 			}
 
-			write_lock_irqsave(&cpufreq_driver_lock, flags);
+			spin_lock_irqsave(&cpufreq_driver_lock, flags);
 			cpumask_copy(managed_policy->cpus, policy->cpus);
 			per_cpu(cpufreq_cpu_data, cpu) = managed_policy;
-			write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+			spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 			pr_debug("CPU already managed, adding link\n");
 			ret = sysfs_create_link(&dev->kobj,
@@ -767,8 +775,8 @@ static int cpufreq_add_dev_policy(unsigned int cpu,
 			 * Call driver->exit() because only the cpu parent of
 			 * the kobj needed to call init().
 			 */
-			if (cpufreq_driver->exit)
-				cpufreq_driver->exit(policy);
+			if (driver->exit)
+				driver->exit(policy);
 
 			if (!ret)
 				return 1;
@@ -819,6 +827,7 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
 	unsigned long flags;
 	int ret = 0;
 	unsigned int j;
+	struct cpufreq_driver *driver = rcu_dereference(cpufreq_driver);
 
 	/* prepare interface data */
 	ret = kobject_init_and_add(&policy->kobj, &ktype_cpufreq,
@@ -827,37 +836,37 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
 		return ret;
 
 	/* set up files for this cpu device */
-	drv_attr = cpufreq_driver->attr;
+	drv_attr = driver->attr;
 	while ((drv_attr) && (*drv_attr)) {
 		ret = sysfs_create_file(&policy->kobj, &((*drv_attr)->attr));
 		if (ret)
 			goto err_out_kobj_put;
 		drv_attr++;
 	}
-	if (cpufreq_driver->get) {
+	if (driver->get) {
 		ret = sysfs_create_file(&policy->kobj, &cpuinfo_cur_freq.attr);
 		if (ret)
 			goto err_out_kobj_put;
 	}
-	if (cpufreq_driver->target) {
+	if (driver->target) {
 		ret = sysfs_create_file(&policy->kobj, &scaling_cur_freq.attr);
 		if (ret)
 			goto err_out_kobj_put;
 	}
-	if (cpufreq_driver->bios_limit) {
+	if (driver->bios_limit) {
 		ret = sysfs_create_file(&policy->kobj, &bios_limit.attr);
 		if (ret)
 			goto err_out_kobj_put;
 	}
 
-	write_lock_irqsave(&cpufreq_driver_lock, flags);
+	spin_lock_irqsave(&cpufreq_driver_lock, flags);
 	for_each_cpu(j, policy->cpus) {
 		if (!cpu_online(j))
 			continue;
 		per_cpu(cpufreq_cpu_data, j) = policy;
 		per_cpu(cpufreq_policy_cpu, j) = policy->cpu;
 	}
-	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	ret = cpufreq_add_dev_symlink(cpu, policy);
 	if (ret)
@@ -874,8 +883,8 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
 
 	if (ret) {
 		pr_debug("setting policy failed\n");
-		if (cpufreq_driver->exit)
-			cpufreq_driver->exit(policy);
+		if (driver->exit)
+			driver->exit(policy);
 	}
 	return ret;
 
@@ -905,6 +914,7 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 #ifdef CONFIG_HOTPLUG_CPU
 	int sibling;
 #endif
+	struct cpufreq_driver *driver = rcu_dereference(cpufreq_driver);
 
 	if (cpu_is_offline(cpu))
 		return 0;
@@ -921,7 +931,7 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 	}
 #endif
 
-	if (!try_module_get(cpufreq_driver->owner)) {
+	if (!try_module_get(driver->owner)) {
 		ret = -EINVAL;
 		goto module_out;
 	}
@@ -965,7 +975,7 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 	/* call driver. From then on the cpufreq must be able
 	 * to accept all calls to ->verify and ->setpolicy for this CPU
 	 */
-	ret = cpufreq_driver->init(policy);
+	ret = driver->init(policy);
 	if (ret) {
 		pr_debug("initialization failed\n");
 		goto err_unlock_policy;
@@ -992,17 +1002,17 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 	unlock_policy_rwsem_write(cpu);
 
 	kobject_uevent(&policy->kobj, KOBJ_ADD);
-	module_put(cpufreq_driver->owner);
+	module_put(driver->owner);
 	pr_debug("initialization complete\n");
 
 	return 0;
 
 
 err_out_unregister:
-	write_lock_irqsave(&cpufreq_driver_lock, flags);
+	spin_lock_irqsave(&cpufreq_driver_lock, flags);
 	for_each_cpu(j, policy->cpus)
 		per_cpu(cpufreq_cpu_data, j) = NULL;
-	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	kobject_put(&policy->kobj);
 	wait_for_completion(&policy->kobj_unregister);
@@ -1015,7 +1025,7 @@ err_free_cpumask:
 err_free_policy:
 	kfree(policy);
 nomem_out:
-	module_put(cpufreq_driver->owner);
+	module_put(driver->owner);
 module_out:
 	return ret;
 }
@@ -1039,14 +1049,15 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 	struct device *cpu_dev;
 	unsigned int j;
 #endif
+	struct cpufreq_driver *driver = rcu_dereference(cpufreq_driver);
 
 	pr_debug("unregistering CPU %u\n", cpu);
 
-	write_lock_irqsave(&cpufreq_driver_lock, flags);
+	spin_lock_irqsave(&cpufreq_driver_lock, flags);
 	data = per_cpu(cpufreq_cpu_data, cpu);
 
 	if (!data) {
-		write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+		spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 		unlock_policy_rwsem_write(cpu);
 		return -EINVAL;
 	}
@@ -1060,7 +1071,7 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 	if (unlikely(cpu != data->cpu)) {
 		pr_debug("removing link\n");
 		cpumask_clear_cpu(cpu, data->cpus);
-		write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+		spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 		kobj = &dev->kobj;
 		cpufreq_cpu_put(data);
 		unlock_policy_rwsem_write(cpu);
@@ -1089,7 +1100,7 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 		}
 	}
 
-	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	if (unlikely(cpumask_weight(data->cpus) > 1)) {
 		for_each_cpu(j, data->cpus) {
@@ -1109,10 +1120,10 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 		}
 	}
 #else
-	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 #endif
 
-	if (cpufreq_driver->target)
+	if (driver->target)
 		__cpufreq_governor(data, CPUFREQ_GOV_STOP);
 
 	kobj = &data->kobj;
@@ -1129,8 +1140,8 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 	pr_debug("wait complete\n");
 
 	lock_policy_rwsem_write(cpu);
-	if (cpufreq_driver->exit)
-		cpufreq_driver->exit(data);
+	if (driver->exit)
+		driver->exit(data);
 	unlock_policy_rwsem_write(cpu);
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -1253,14 +1264,15 @@ static unsigned int __cpufreq_get(unsigned int cpu)
 {
 	struct cpufreq_policy *policy = per_cpu(cpufreq_cpu_data, cpu);
 	unsigned int ret_freq = 0;
+	struct cpufreq_driver *driver = rcu_dereference(cpufreq_driver);
 
-	if (!cpufreq_driver->get)
+	if (!driver->get)
 		return ret_freq;
 
-	ret_freq = cpufreq_driver->get(cpu);
+	ret_freq = driver->get(cpu);
 
 	if (ret_freq && policy->cur &&
-		!(cpufreq_driver->flags & CPUFREQ_CONST_LOOPS)) {
+		!(driver->flags & CPUFREQ_CONST_LOOPS)) {
 		/* verify no discrepancy between actual and
 					saved value exists */
 		if (unlikely(ret_freq != policy->cur)) {
@@ -1320,6 +1332,7 @@ static int cpufreq_bp_suspend(void)
 
 	int cpu = smp_processor_id();
 	struct cpufreq_policy *cpu_policy;
+	struct cpufreq_driver *driver = rcu_dereference(cpufreq_driver);
 
 	pr_debug("suspending cpu %u\n", cpu);
 
@@ -1328,8 +1341,8 @@ static int cpufreq_bp_suspend(void)
 	if (!cpu_policy)
 		return 0;
 
-	if (cpufreq_driver->suspend) {
-		ret = cpufreq_driver->suspend(cpu_policy);
+	if (driver->suspend) {
+		ret = driver->suspend(cpu_policy);
 		if (ret)
 			printk(KERN_ERR "cpufreq: suspend failed in ->suspend "
 					"step on CPU %u\n", cpu_policy->cpu);
@@ -1358,6 +1371,7 @@ static void cpufreq_bp_resume(void)
 
 	int cpu = smp_processor_id();
 	struct cpufreq_policy *cpu_policy;
+	struct cpufreq_driver *driver = rcu_dereference(cpufreq_driver);
 
 	pr_debug("resuming cpu %u\n", cpu);
 
@@ -1366,8 +1380,8 @@ static void cpufreq_bp_resume(void)
 	if (!cpu_policy)
 		return;
 
-	if (cpufreq_driver->resume) {
-		ret = cpufreq_driver->resume(cpu_policy);
+	if (driver->resume) {
+		ret = driver->resume(cpu_policy);
 		if (ret) {
 			printk(KERN_ERR "cpufreq: resume failed in ->resume "
 					"step on CPU %u\n", cpu_policy->cpu);
@@ -1471,6 +1485,7 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
 {
 	int retval = -EINVAL;
 	unsigned int old_target_freq = target_freq;
+	struct cpufreq_driver *driver = rcu_dereference(cpufreq_driver);
 
 	if (cpufreq_disabled())
 		return -ENODEV;
@@ -1487,8 +1502,8 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
 	if (target_freq == policy->cur)
 		return 0;
 
-	if (cpu_online(policy->cpu) && cpufreq_driver->target)
-		retval = cpufreq_driver->target(policy, target_freq, relation);
+	if (cpu_online(policy->cpu) && driver->target)
+		retval = driver->target(policy, target_freq, relation);
 
 	return retval;
 }
@@ -1521,15 +1536,16 @@ EXPORT_SYMBOL_GPL(cpufreq_driver_target);
 int __cpufreq_driver_getavg(struct cpufreq_policy *policy, unsigned int cpu)
 {
 	int ret = 0;
+	struct cpufreq_driver *driver = rcu_dereference(cpufreq_driver);
 
-	if (!(cpu_online(cpu) && cpufreq_driver->getavg))
+	if (!(cpu_online(cpu) && driver->getavg))
 		return 0;
 
 	policy = cpufreq_cpu_get(policy->cpu);
 	if (!policy)
 		return -EINVAL;
 
-	ret = cpufreq_driver->getavg(policy, cpu);
+	ret = driver->getavg(policy, cpu);
 
 	cpufreq_cpu_put(policy);
 	return ret;
@@ -1679,6 +1695,7 @@ static int __cpufreq_set_policy(struct cpufreq_policy *data,
 				struct cpufreq_policy *policy)
 {
 	int ret = 0;
+	struct cpufreq_driver *driver = rcu_dereference(cpufreq_driver);
 
 	pr_debug("setting new policy for CPU %u: %u - %u kHz\n", policy->cpu,
 		policy->min, policy->max);
@@ -1692,7 +1709,7 @@ static int __cpufreq_set_policy(struct cpufreq_policy *data,
 	}
 
 	/* verify the cpu speed can be set within this limit */
-	ret = cpufreq_driver->verify(policy);
+	ret = driver->verify(policy);
 	if (ret)
 		goto error_out;
 
@@ -1706,7 +1723,7 @@ static int __cpufreq_set_policy(struct cpufreq_policy *data,
 
 	/* verify the cpu speed can be set within this limit,
 	   which might be different to the first one */
-	ret = cpufreq_driver->verify(policy);
+	ret = driver->verify(policy);
 	if (ret)
 		goto error_out;
 
@@ -1720,10 +1737,10 @@ static int __cpufreq_set_policy(struct cpufreq_policy *data,
 	pr_debug("new min and max freqs are %u - %u kHz\n",
 					data->min, data->max);
 
-	if (cpufreq_driver->setpolicy) {
+	if (driver->setpolicy) {
 		data->policy = policy->policy;
 		pr_debug("setting range\n");
-		ret = cpufreq_driver->setpolicy(policy);
+		ret = driver->setpolicy(policy);
 	} else {
 		if (policy->governor != data->governor) {
 			/* save old, working values */
@@ -1771,6 +1788,7 @@ int cpufreq_update_policy(unsigned int cpu)
 	struct cpufreq_policy *data = cpufreq_cpu_get(cpu);
 	struct cpufreq_policy policy;
 	int ret;
+	struct cpufreq_driver *driver = rcu_dereference(cpufreq_driver);
 
 	if (!data) {
 		ret = -ENODEV;
@@ -1791,8 +1809,8 @@ int cpufreq_update_policy(unsigned int cpu)
 
 	/* BIOS might change freq behind our back
 	  -> ask driver for current freq and notify governors about a change */
-	if (cpufreq_driver->get) {
-		policy.cur = cpufreq_driver->get(cpu);
+	if (driver->get) {
+		policy.cur = driver->get(cpu);
 		if (!data->cur) {
 			pr_debug("Driver did not initialize current freq");
 			data->cur = policy.cur;
@@ -1878,19 +1896,19 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 	if (driver_data->setpolicy)
 		driver_data->flags |= CPUFREQ_CONST_LOOPS;
 
-	write_lock_irqsave(&cpufreq_driver_lock, flags);
-	if (cpufreq_driver) {
-		write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	spin_lock_irqsave(&cpufreq_driver_lock, flags);
+	if (rcu_dereference(cpufreq_driver)) {
+		spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 		return -EBUSY;
 	}
-	cpufreq_driver = driver_data;
-	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	rcu_assign_pointer(cpufreq_driver, driver_data);
+	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	ret = subsys_interface_register(&cpufreq_interface);
 	if (ret)
 		goto err_null_driver;
 
-	if (!(cpufreq_driver->flags & CPUFREQ_STICKY)) {
+	if (!(rcu_dereference(cpufreq_driver)->flags & CPUFREQ_STICKY)) {
 		int i;
 		ret = -ENODEV;
 
@@ -1916,9 +1934,9 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 err_if_unreg:
 	subsys_interface_unregister(&cpufreq_interface);
 err_null_driver:
-	write_lock_irqsave(&cpufreq_driver_lock, flags);
-	cpufreq_driver = NULL;
-	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	spin_lock_irqsave(&cpufreq_driver_lock, flags);
+	rcu_assign_pointer(cpufreq_driver, NULL);
+	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(cpufreq_register_driver);
@@ -1935,8 +1953,9 @@ EXPORT_SYMBOL_GPL(cpufreq_register_driver);
 int cpufreq_unregister_driver(struct cpufreq_driver *driver)
 {
 	unsigned long flags;
+	struct cpufreq_driver *old_driver = rcu_dereference(cpufreq_driver);
 
-	if (!cpufreq_driver || (driver != cpufreq_driver))
+	if (!old_driver || (driver != old_driver))
 		return -EINVAL;
 
 	pr_debug("unregistering driver %s\n", driver->name);
@@ -1944,9 +1963,9 @@ int cpufreq_unregister_driver(struct cpufreq_driver *driver)
 	subsys_interface_unregister(&cpufreq_interface);
 	unregister_hotcpu_notifier(&cpufreq_cpu_notifier);
 
-	write_lock_irqsave(&cpufreq_driver_lock, flags);
-	cpufreq_driver = NULL;
-	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	spin_lock_irqsave(&cpufreq_driver_lock, flags);
+	rcu_assign_pointer(cpufreq_driver, NULL);
+	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	return 0;
 }
-- 
1.8.0.1

