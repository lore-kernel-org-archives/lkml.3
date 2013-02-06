Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757094Ab3BFCFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 21:05:50 -0500
Received: from relay1.sgi.com ([192.48.179.29]:35803 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754731Ab3BFCFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 21:05:23 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
To: viresh.kumar@linaro.org, rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, Nathan Zimmer <nzimmer@sgi.com>
Subject: [PATCH v2 linux-next 2/2] cpufreq: Convert the cpufreq_driver_lock to use the rcu
Date: Tue,  5 Feb 2013 20:04:50 -0600
Message-Id: <1360116290-23849-3-git-send-email-nzimmer@sgi.com>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1360116290-23849-1-git-send-email-nzimmer@sgi.com>
References: <74F10842A85F514CA8D8C487E74474BB2D2F925E@P-EXMB1-DC21.corp.sgi.com>
 <1360116290-23849-1-git-send-email-nzimmer@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In general rwlocks are discourged so we are moving it to use the rcu instead.

Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
---
 drivers/cpufreq/cpufreq.c | 173 +++++++++++++++++++++++++---------------------
 1 file changed, 96 insertions(+), 77 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index ef25244..a04ceb9 100644
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
@@ -196,7 +195,7 @@ static void __cpufreq_cpu_put(struct cpufreq_policy *data, bool sysfs)
 {
 	if (!sysfs)
 		kobject_put(&data->kobj);
-	module_put(cpufreq_driver->owner);
+	module_put(rcu_dereference(cpufreq_driver)->owner);
 }
 
 void cpufreq_cpu_put(struct cpufreq_policy *data)
@@ -267,13 +266,16 @@ static inline void adjust_jiffies(unsigned long val, struct cpufreq_freqs *ci)
 void cpufreq_notify_transition(struct cpufreq_freqs *freqs, unsigned int state)
 {
 	struct cpufreq_policy *policy;
+	struct cpufreq_driver *driver;
 
 	BUG_ON(irqs_disabled());
 
 	if (cpufreq_disabled())
 		return;
 
-	freqs->flags = cpufreq_driver->flags;
+	driver = rcu_dereference(cpufreq_driver);
+
+	freqs->flags = driver->flags;
 	pr_debug("notification %u of frequency transition to %u kHz\n",
 		state, freqs->new);
 
@@ -285,7 +287,7 @@ void cpufreq_notify_transition(struct cpufreq_freqs *freqs, unsigned int state)
 		 * which is not equal to what the cpufreq core thinks is
 		 * "old frequency".
 		 */
-		if (!(cpufreq_driver->flags & CPUFREQ_CONST_LOOPS)) {
+		if (!(driver->flags & CPUFREQ_CONST_LOOPS)) {
 			if ((policy) && (policy->cpu == freqs->cpu) &&
 			    (policy->cur) && (policy->cur != freqs->old)) {
 				pr_debug("Warning: CPU frequency is"
@@ -337,11 +339,12 @@ static int cpufreq_parse_governor(char *str_governor, unsigned int *policy,
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
@@ -350,7 +353,7 @@ static int cpufreq_parse_governor(char *str_governor, unsigned int *policy,
 			*policy = CPUFREQ_POLICY_POWERSAVE;
 			err = 0;
 		}
-	} else if (cpufreq_driver->target) {
+	} else if (driver->target) {
 		struct cpufreq_governor *t;
 
 		mutex_lock(&cpufreq_governor_mutex);
@@ -501,7 +504,8 @@ static ssize_t store_scaling_governor(struct cpufreq_policy *policy,
  */
 static ssize_t show_scaling_driver(struct cpufreq_policy *policy, char *buf)
 {
-	return scnprintf(buf, CPUFREQ_NAME_PLEN, "%s\n", cpufreq_driver->name);
+	return scnprintf(buf, CPUFREQ_NAME_PLEN, "%s\n",
+			 rcu_dereference(cpufreq_driver)->name);
 }
 
 /**
@@ -513,7 +517,7 @@ static ssize_t show_scaling_available_governors(struct cpufreq_policy *policy,
 	ssize_t i = 0;
 	struct cpufreq_governor *t;
 
-	if (!cpufreq_driver->target) {
+	if (!rcu_dereference(cpufreq_driver)->target) {
 		i += sprintf(buf, "performance powersave");
 		goto out;
 	}
@@ -595,8 +599,10 @@ static ssize_t show_bios_limit(struct cpufreq_policy *policy, char *buf)
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
@@ -744,6 +750,7 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
 	unsigned long flags;
 	int ret = 0;
 	unsigned int j;
+	struct cpufreq_driver *driver = rcu_dereference(cpufreq_driver);
 
 	/* prepare interface data */
 	ret = kobject_init_and_add(&policy->kobj, &ktype_cpufreq,
@@ -752,37 +759,37 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
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
@@ -799,8 +806,8 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
 
 	if (ret) {
 		pr_debug("setting policy failed\n");
-		if (cpufreq_driver->exit)
-			cpufreq_driver->exit(policy);
+		if (driver->exit)
+			driver->exit(policy);
 	}
 	return ret;
 
@@ -827,10 +834,10 @@ static int cpufreq_add_policy_cpu(unsigned int cpu, unsigned int sibling,
 
 	__cpufreq_governor(policy, CPUFREQ_GOV_STOP);
 
-	write_lock_irqsave(&cpufreq_driver_lock, flags);
+	spin_lock_irqsave(&cpufreq_driver_lock, flags);
 	cpumask_set_cpu(cpu, policy->cpus);
 	per_cpu(cpufreq_cpu_data, cpu) = policy;
-	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	__cpufreq_governor(policy, CPUFREQ_GOV_START);
 	__cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
@@ -861,6 +868,7 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 	unsigned int j, cpu = dev->id;
 	int ret = -ENOMEM, found = 0;
 	struct cpufreq_policy *policy;
+	struct cpufreq_driver *driver;
 	unsigned long flags;
 #ifdef CONFIG_HOTPLUG_CPU
 	struct cpufreq_governor *gov;
@@ -871,6 +879,7 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 		return 0;
 
 	pr_debug("adding CPU %u\n", cpu);
+	driver = rcu_dereference(cpufreq_driver);
 
 #ifdef CONFIG_SMP
 	/* check whether a different CPU already registered this
@@ -891,7 +900,7 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 #endif
 #endif
 
-	if (!try_module_get(cpufreq_driver->owner)) {
+	if (!try_module_get(driver->owner)) {
 		ret = -EINVAL;
 		goto module_out;
 	}
@@ -934,7 +943,7 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 	/* call driver. From then on the cpufreq must be able
 	 * to accept all calls to ->verify and ->setpolicy for this CPU
 	 */
-	ret = cpufreq_driver->init(policy);
+	ret = driver->init(policy);
 	if (ret) {
 		pr_debug("initialization failed\n");
 		goto err_unlock_policy;
@@ -971,16 +980,16 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 	unlock_policy_rwsem_write(cpu);
 
 	kobject_uevent(&policy->kobj, KOBJ_ADD);
-	module_put(cpufreq_driver->owner);
+	module_put(rcu_dereference(cpufreq_driver)->owner);
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
@@ -993,7 +1002,7 @@ err_free_cpumask:
 err_free_policy:
 	kfree(policy);
 nomem_out:
-	module_put(cpufreq_driver->owner);
+	module_put(driver->owner);
 module_out:
 	return ret;
 }
@@ -1033,20 +1042,21 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 	struct kobject *kobj;
 	struct completion *cmp;
 	struct device *cpu_dev;
+	struct cpufreq_driver *driver = rcu_dereference(cpufreq_driver);
 
 	pr_debug("%s: unregistering CPU %u\n", __func__, cpu);
 
-	write_lock_irqsave(&cpufreq_driver_lock, flags);
+	spin_lock_irqsave(&cpufreq_driver_lock, flags);
 	data = per_cpu(cpufreq_cpu_data, cpu);
 
 	if (!data) {
 		pr_debug("%s: No cpu_data found\n", __func__);
-		write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+		spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 		unlock_policy_rwsem_write(cpu);
 		return -EINVAL;
 	}
 
-	if (cpufreq_driver->target)
+	if (driver->target)
 		__cpufreq_governor(data, CPUFREQ_GOV_STOP);
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -1068,7 +1078,7 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 			cpumask_set_cpu(cpu, data->cpus);
 			ret = sysfs_create_link(&cpu_dev->kobj, &data->kobj,
 					"cpufreq");
-			write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+			spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 			unlock_policy_rwsem_write(cpu);
 			return -EINVAL;
 		}
@@ -1078,7 +1088,7 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 				__func__, cpu_dev->id, cpu);
 	}
 
-	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	pr_debug("%s: removing link, cpu: %d\n", __func__, cpu);
 	cpufreq_cpu_put(data);
@@ -1102,14 +1112,14 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 		pr_debug("wait complete\n");
 
 		lock_policy_rwsem_write(cpu);
-		if (cpufreq_driver->exit)
-			cpufreq_driver->exit(data);
+		if (driver->exit)
+			driver->exit(data);
 		unlock_policy_rwsem_write(cpu);
 
 		free_cpumask_var(data->related_cpus);
 		free_cpumask_var(data->cpus);
 		kfree(data);
-	} else if (cpufreq_driver->target) {
+	} else if (driver->target) {
 		__cpufreq_governor(data, CPUFREQ_GOV_START);
 		__cpufreq_governor(data, CPUFREQ_GOV_LIMITS);
 	}
@@ -1214,14 +1224,15 @@ static unsigned int __cpufreq_get(unsigned int cpu)
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
@@ -1281,6 +1292,7 @@ static int cpufreq_bp_suspend(void)
 
 	int cpu = smp_processor_id();
 	struct cpufreq_policy *cpu_policy;
+	struct cpufreq_driver *driver = rcu_dereference(cpufreq_driver);
 
 	pr_debug("suspending cpu %u\n", cpu);
 
@@ -1289,8 +1301,8 @@ static int cpufreq_bp_suspend(void)
 	if (!cpu_policy)
 		return 0;
 
-	if (cpufreq_driver->suspend) {
-		ret = cpufreq_driver->suspend(cpu_policy);
+	if (driver->suspend) {
+		ret = driver->suspend(cpu_policy);
 		if (ret)
 			printk(KERN_ERR "cpufreq: suspend failed in ->suspend "
 					"step on CPU %u\n", cpu_policy->cpu);
@@ -1319,6 +1331,7 @@ static void cpufreq_bp_resume(void)
 
 	int cpu = smp_processor_id();
 	struct cpufreq_policy *cpu_policy;
+	struct cpufreq_driver *driver = rcu_dereference(cpufreq_driver);
 
 	pr_debug("resuming cpu %u\n", cpu);
 
@@ -1327,8 +1340,8 @@ static void cpufreq_bp_resume(void)
 	if (!cpu_policy)
 		return;
 
-	if (cpufreq_driver->resume) {
-		ret = cpufreq_driver->resume(cpu_policy);
+	if (driver->resume) {
+		ret = driver->resume(cpu_policy);
 		if (ret) {
 			printk(KERN_ERR "cpufreq: resume failed in ->resume "
 					"step on CPU %u\n", cpu_policy->cpu);
@@ -1355,8 +1368,9 @@ static struct syscore_ops cpufreq_syscore_ops = {
  */
 const char *cpufreq_get_current_driver(void)
 {
-	if (cpufreq_driver)
-		return cpufreq_driver->name;
+	struct cpufreq_driver *driver = rcu_dereference(cpufreq_driver);
+	if (driver)
+		return driver->name;
 
 	return NULL;
 }
@@ -1452,6 +1466,7 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
 {
 	int retval = -EINVAL;
 	unsigned int old_target_freq = target_freq;
+	struct cpufreq_driver *driver = rcu_dereference(cpufreq_driver);
 
 	if (cpufreq_disabled())
 		return -ENODEV;
@@ -1468,8 +1483,8 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
 	if (target_freq == policy->cur)
 		return 0;
 
-	if (cpu_online(policy->cpu) && cpufreq_driver->target)
-		retval = cpufreq_driver->target(policy, target_freq, relation);
+	if (cpu_online(policy->cpu) && driver->target)
+		retval = driver->target(policy, target_freq, relation);
 
 	return retval;
 }
@@ -1502,18 +1517,19 @@ EXPORT_SYMBOL_GPL(cpufreq_driver_target);
 int __cpufreq_driver_getavg(struct cpufreq_policy *policy, unsigned int cpu)
 {
 	int ret = 0;
+	struct cpufreq_driver *driver = rcu_dereference(cpufreq_driver);
 
 	if (cpufreq_disabled())
 		return ret;
 
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
@@ -1667,6 +1683,7 @@ static int __cpufreq_set_policy(struct cpufreq_policy *data,
 				struct cpufreq_policy *policy)
 {
 	int ret = 0;
+	struct cpufreq_driver *driver = rcu_dereference(cpufreq_driver);
 
 	pr_debug("setting new policy for CPU %u: %u - %u kHz\n", policy->cpu,
 		policy->min, policy->max);
@@ -1680,7 +1697,7 @@ static int __cpufreq_set_policy(struct cpufreq_policy *data,
 	}
 
 	/* verify the cpu speed can be set within this limit */
-	ret = cpufreq_driver->verify(policy);
+	ret = driver->verify(policy);
 	if (ret)
 		goto error_out;
 
@@ -1694,7 +1711,7 @@ static int __cpufreq_set_policy(struct cpufreq_policy *data,
 
 	/* verify the cpu speed can be set within this limit,
 	   which might be different to the first one */
-	ret = cpufreq_driver->verify(policy);
+	ret = driver->verify(policy);
 	if (ret)
 		goto error_out;
 
@@ -1708,10 +1725,10 @@ static int __cpufreq_set_policy(struct cpufreq_policy *data,
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
@@ -1759,6 +1776,7 @@ int cpufreq_update_policy(unsigned int cpu)
 	struct cpufreq_policy *data = cpufreq_cpu_get(cpu);
 	struct cpufreq_policy policy;
 	int ret;
+	struct cpufreq_driver *driver = rcu_dereference(cpufreq_driver);
 
 	if (!data) {
 		ret = -ENODEV;
@@ -1779,8 +1797,8 @@ int cpufreq_update_policy(unsigned int cpu)
 
 	/* BIOS might change freq behind our back
 	  -> ask driver for current freq and notify governors about a change */
-	if (cpufreq_driver->get) {
-		policy.cur = cpufreq_driver->get(cpu);
+	if (driver->get) {
+		policy.cur = driver->get(cpu);
 		if (!data->cur) {
 			pr_debug("Driver did not initialize current freq");
 			data->cur = policy.cur;
@@ -1866,19 +1884,19 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
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
 
@@ -1904,9 +1922,9 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
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
@@ -1923,8 +1941,9 @@ EXPORT_SYMBOL_GPL(cpufreq_register_driver);
 int cpufreq_unregister_driver(struct cpufreq_driver *driver)
 {
 	unsigned long flags;
+	struct cpufreq_driver *old_driver = rcu_dereference(cpufreq_driver);
 
-	if (!cpufreq_driver || (driver != cpufreq_driver))
+	if (!old_driver || (driver != old_driver))
 		return -EINVAL;
 
 	pr_debug("unregistering driver %s\n", driver->name);
@@ -1932,9 +1951,9 @@ int cpufreq_unregister_driver(struct cpufreq_driver *driver)
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

