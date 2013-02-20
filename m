Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317Ab3BUABz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 19:01:55 -0500
Received: from relay1.sgi.com ([192.48.179.29]:59621 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038Ab3BUABx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 19:01:53 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
To: viresh.kumar@linaro.org, rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nathan Zimmer <nzimmer@sgi.com>
Subject: [PATCH v3 2/2] cpufreq: Convert the cpufreq_driver_lock to use the rcu
Date: Wed, 20 Feb 2013 17:56:23 -0600
Message-Id: <1361404583-5557-3-git-send-email-nzimmer@sgi.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361404583-5557-1-git-send-email-nzimmer@sgi.com>
References: <1360116290-23849-1-git-send-email-nzimmer@sgi.com>
 <1361404583-5557-1-git-send-email-nzimmer@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In general rwlocks are discourged so we are moving it to use the rcu instead.
This does require a bit of care since the cpufreq_driver_lock protects both
the cpufreq_driver and the cpufreq_cpu_data array.
Also since many of the function pointers on cpufreq_driver may sleep when
called we have to grab them under the rcu_read_lock but call them after
rcu_read_unlock();

Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
---
 drivers/cpufreq/cpufreq.c | 312 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 224 insertions(+), 88 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index c5996fe..110ec02 100644
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
@@ -131,18 +131,19 @@ static DEFINE_MUTEX(cpufreq_governor_mutex);
 static struct cpufreq_policy *__cpufreq_cpu_get(unsigned int cpu, bool sysfs)
 {
 	struct cpufreq_policy *data;
-	unsigned long flags;
+	struct cpufreq_driver *driver;
 
 	if (cpu >= nr_cpu_ids)
 		goto err_out;
 
 	/* get the cpufreq driver */
-	read_lock_irqsave(&cpufreq_driver_lock, flags);
+	rcu_read_lock();
+	driver = rcu_dereference(cpufreq_driver);
 
-	if (!cpufreq_driver)
+	if (!driver)
 		goto err_out_unlock;
 
-	if (!try_module_get(cpufreq_driver->owner))
+	if (!try_module_get(driver->owner))
 		goto err_out_unlock;
 
 
@@ -155,13 +156,13 @@ static struct cpufreq_policy *__cpufreq_cpu_get(unsigned int cpu, bool sysfs)
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
@@ -184,7 +185,9 @@ static void __cpufreq_cpu_put(struct cpufreq_policy *data, bool sysfs)
 {
 	if (!sysfs)
 		kobject_put(&data->kobj);
-	module_put(cpufreq_driver->owner);
+	rcu_read_lock();
+	module_put(rcu_dereference(cpufreq_driver)->owner);
+	rcu_read_unlock();
 }
 
 void cpufreq_cpu_put(struct cpufreq_policy *data)
@@ -255,20 +258,21 @@ static inline void adjust_jiffies(unsigned long val, struct cpufreq_freqs *ci)
 void cpufreq_notify_transition(struct cpufreq_freqs *freqs, unsigned int state)
 {
 	struct cpufreq_policy *policy;
-	unsigned long flags;
+	u8 flags;
 
 	BUG_ON(irqs_disabled());
 
 	if (cpufreq_disabled())
 		return;
 
-	freqs->flags = cpufreq_driver->flags;
 	pr_debug("notification %u of frequency transition to %u kHz\n",
 		state, freqs->new);
 
-	read_lock_irqsave(&cpufreq_driver_lock, flags);
+	rcu_read_lock();
+	flags = rcu_dereference(cpufreq_driver)->flags;
 	policy = per_cpu(cpufreq_cpu_data, freqs->cpu);
-	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	rcu_read_unlock();
+	freqs->flags = flags;
 
 	switch (state) {
 
@@ -277,7 +281,7 @@ void cpufreq_notify_transition(struct cpufreq_freqs *freqs, unsigned int state)
 		 * which is not equal to what the cpufreq core thinks is
 		 * "old frequency".
 		 */
-		if (!(cpufreq_driver->flags & CPUFREQ_CONST_LOOPS)) {
+		if (!(flags & CPUFREQ_CONST_LOOPS)) {
 			if ((policy) && (policy->cpu == freqs->cpu) &&
 			    (policy->cur) && (policy->cur != freqs->old)) {
 				pr_debug("Warning: CPU frequency is"
@@ -329,11 +333,23 @@ static int cpufreq_parse_governor(char *str_governor, unsigned int *policy,
 				struct cpufreq_governor **governor)
 {
 	int err = -EINVAL;
-
-	if (!cpufreq_driver)
+	struct cpufreq_driver *driver;
+	int (*setpolicy)(struct cpufreq_policy *policy);
+	int (*target)(struct cpufreq_policy *policy,
+		      unsigned int target_freq,
+		      unsigned int relation);
+
+	rcu_read_lock();
+	driver = rcu_dereference(cpufreq_driver);
+	if (!driver) {
+		rcu_read_unlock();
 		goto out;
+	}
+	setpolicy = driver->setpolicy;
+	target = driver->target;
+	rcu_read_unlock();
 
-	if (cpufreq_driver->setpolicy) {
+	if (setpolicy) {
 		if (!strnicmp(str_governor, "performance", CPUFREQ_NAME_LEN)) {
 			*policy = CPUFREQ_POLICY_PERFORMANCE;
 			err = 0;
@@ -342,7 +358,7 @@ static int cpufreq_parse_governor(char *str_governor, unsigned int *policy,
 			*policy = CPUFREQ_POLICY_POWERSAVE;
 			err = 0;
 		}
-	} else if (cpufreq_driver->target) {
+	} else if (target) {
 		struct cpufreq_governor *t;
 
 		mutex_lock(&cpufreq_governor_mutex);
@@ -493,7 +509,11 @@ static ssize_t store_scaling_governor(struct cpufreq_policy *policy,
  */
 static ssize_t show_scaling_driver(struct cpufreq_policy *policy, char *buf)
 {
-	return scnprintf(buf, CPUFREQ_NAME_PLEN, "%s\n", cpufreq_driver->name);
+	char *name;
+	rcu_read_lock();
+	name = rcu_dereference(cpufreq_driver)->name;
+	rcu_read_unlock();
+	return scnprintf(buf, CPUFREQ_NAME_PLEN, "%s\n", name);
 }
 
 /**
@@ -505,10 +525,13 @@ static ssize_t show_scaling_available_governors(struct cpufreq_policy *policy,
 	ssize_t i = 0;
 	struct cpufreq_governor *t;
 
-	if (!cpufreq_driver->target) {
+	rcu_read_lock();
+	if (!rcu_dereference(cpufreq_driver)->target) {
+		rcu_read_unlock();
 		i += sprintf(buf, "performance powersave");
 		goto out;
 	}
+	rcu_read_unlock();
 
 	list_for_each_entry(t, &cpufreq_governor_list, governor_list) {
 		if (i >= (ssize_t) ((PAGE_SIZE / sizeof(char))
@@ -587,8 +610,14 @@ static ssize_t show_bios_limit(struct cpufreq_policy *policy, char *buf)
 {
 	unsigned int limit;
 	int ret;
-	if (cpufreq_driver->bios_limit) {
-		ret = cpufreq_driver->bios_limit(policy->cpu, &limit);
+	int (*bios_limit)(int cpu, unsigned int *limit);
+
+	rcu_read_lock();
+	bios_limit = rcu_dereference(cpufreq_driver)->bios_limit;
+	rcu_read_unlock();
+
+	if (bios_limit) {
+		ret = bios_limit(policy->cpu, &limit);
 		if (!ret)
 			return sprintf(buf, "%u\n", limit);
 	}
@@ -730,6 +759,8 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
 				     struct device *dev)
 {
 	struct cpufreq_policy new_policy;
+	struct cpufreq_driver *driver;
+	int (*exit)(struct cpufreq_policy *policy);
 	struct freq_attr **drv_attr;
 	unsigned long flags;
 	int ret = 0;
@@ -742,35 +773,39 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
 		return ret;
 
 	/* set up files for this cpu device */
-	drv_attr = cpufreq_driver->attr;
+	rcu_read_lock();
+	driver = rcu_dereference(cpufreq_driver);
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
+	rcu_read_unlock();
 
-	write_lock_irqsave(&cpufreq_driver_lock, flags);
+	spin_lock_irqsave(&cpufreq_driver_lock, flags);
 	for_each_cpu(j, policy->cpus) {
 		per_cpu(cpufreq_cpu_data, j) = policy;
 		per_cpu(cpufreq_policy_cpu, j) = policy->cpu;
 	}
-	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	synchronize_rcu();
 
 	ret = cpufreq_add_dev_symlink(cpu, policy);
 	if (ret)
@@ -787,8 +822,11 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
 
 	if (ret) {
 		pr_debug("setting policy failed\n");
-		if (cpufreq_driver->exit)
-			cpufreq_driver->exit(policy);
+		rcu_read_lock();
+		exit = rcu_dereference(cpufreq_driver)->exit;
+		rcu_read_unlock();
+		if (exit)
+			exit(policy);
 	}
 	return ret;
 
@@ -813,12 +851,13 @@ static int cpufreq_add_policy_cpu(unsigned int cpu, unsigned int sibling,
 
 	lock_policy_rwsem_write(sibling);
 
-	write_lock_irqsave(&cpufreq_driver_lock, flags);
+	spin_lock_irqsave(&cpufreq_driver_lock, flags);
 
 	cpumask_set_cpu(cpu, policy->cpus);
 	per_cpu(cpufreq_policy_cpu, cpu) = policy->cpu;
 	per_cpu(cpufreq_cpu_data, cpu) = policy;
-	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	synchronize_rcu();
 
 	unlock_policy_rwsem_write(sibling);
 
@@ -849,6 +888,10 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 	unsigned int j, cpu = dev->id;
 	int ret = -ENOMEM;
 	struct cpufreq_policy *policy;
+	struct cpufreq_driver *driver;
+	int (*init)(struct cpufreq_policy *policy);
+	struct module *owner;
+
 	unsigned long flags;
 #ifdef CONFIG_HOTPLUG_CPU
 	struct cpufreq_governor *gov;
@@ -869,21 +912,24 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 		return 0;
 	}
 
+	rcu_read_lock();
 #ifdef CONFIG_HOTPLUG_CPU
 	/* Check if this cpu was hot-unplugged earlier and has siblings */
-	read_lock_irqsave(&cpufreq_driver_lock, flags);
 	for_each_online_cpu(sibling) {
 		struct cpufreq_policy *cp = per_cpu(cpufreq_cpu_data, sibling);
 		if (cp && cpumask_test_cpu(cpu, cp->related_cpus)) {
-			read_unlock_irqrestore(&cpufreq_driver_lock, flags);
+			rcu_read_unlock();
 			return cpufreq_add_policy_cpu(cpu, sibling, dev);
 		}
 	}
-	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
 #endif
 #endif
+	driver = rcu_dereference(cpufreq_driver);
+	init = driver->init;
+	owner = driver->owner;
+	rcu_read_unlock();
 
-	if (!try_module_get(cpufreq_driver->owner)) {
+	if (!try_module_get(owner)) {
 		ret = -EINVAL;
 		goto module_out;
 	}
@@ -911,7 +957,7 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 	/* call driver. From then on the cpufreq must be able
 	 * to accept all calls to ->verify and ->setpolicy for this CPU
 	 */
-	ret = cpufreq_driver->init(policy);
+	ret = init(policy);
 	if (ret) {
 		pr_debug("initialization failed\n");
 		goto err_set_policy_cpu;
@@ -946,16 +992,17 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 		goto err_out_unregister;
 
 	kobject_uevent(&policy->kobj, KOBJ_ADD);
-	module_put(cpufreq_driver->owner);
+	module_put(owner);
 	pr_debug("initialization complete\n");
 
 	return 0;
 
 err_out_unregister:
-	write_lock_irqsave(&cpufreq_driver_lock, flags);
+	spin_lock_irqsave(&cpufreq_driver_lock, flags);
 	for_each_cpu(j, policy->cpus)
 		per_cpu(cpufreq_cpu_data, j) = NULL;
-	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	synchronize_rcu();
 
 	kobject_put(&policy->kobj);
 	wait_for_completion(&policy->kobj_unregister);
@@ -968,7 +1015,7 @@ err_free_cpumask:
 err_free_policy:
 	kfree(policy);
 nomem_out:
-	module_put(cpufreq_driver->owner);
+	module_put(owner);
 module_out:
 	return ret;
 }
@@ -1002,29 +1049,46 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 	unsigned int cpu = dev->id, ret, cpus;
 	unsigned long flags;
 	struct cpufreq_policy *data;
+	struct cpufreq_driver *driver;
+	int (*target)(struct cpufreq_policy *policy,
+		       unsigned int target_freq,
+		       unsigned int relation);
+	int (*exit)(struct cpufreq_policy *policy);
+#ifdef CONFIG_HOTPLUG_CPU
+	int (*setpolicy)(struct cpufreq_policy *policy);
+#endif
 	struct kobject *kobj;
 	struct completion *cmp;
 	struct device *cpu_dev;
 
 	pr_debug("%s: unregistering CPU %u\n", __func__, cpu);
 
-	write_lock_irqsave(&cpufreq_driver_lock, flags);
+	spin_lock_irqsave(&cpufreq_driver_lock, flags);
 
 	data = per_cpu(cpufreq_cpu_data, cpu);
 	per_cpu(cpufreq_cpu_data, cpu) = NULL;
-
-	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	synchronize_rcu();
 
 	if (!data) {
 		pr_debug("%s: No cpu_data found\n", __func__);
 		return -EINVAL;
 	}
 
-	if (cpufreq_driver->target)
+	rcu_read_lock();
+	driver = rcu_dereference(cpufreq_driver);
+	target = driver->target;
+	exit = driver->exit;
+#ifdef CONFIG_HOTPLUG_CPU
+	setpolicy = driver->setpolicy;
+#endif
+	rcu_read_unlock();
+
+	if (target)
 		__cpufreq_governor(data, CPUFREQ_GOV_STOP);
 
 #ifdef CONFIG_HOTPLUG_CPU
-	if (!cpufreq_driver->setpolicy)
+	if (!setpolicy)
 		strncpy(per_cpu(cpufreq_cpu_governor, cpu),
 			data->governor->name, CPUFREQ_NAME_LEN);
 #endif
@@ -1047,9 +1111,10 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 			WARN_ON(lock_policy_rwsem_write(cpu));
 			cpumask_set_cpu(cpu, data->cpus);
 
-			write_lock_irqsave(&cpufreq_driver_lock, flags);
+			spin_lock_irqsave(&cpufreq_driver_lock, flags);
 			per_cpu(cpufreq_cpu_data, cpu) = data;
-			write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+			spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+			synchronize_rcu();
 
 			unlock_policy_rwsem_write(cpu);
 
@@ -1084,13 +1149,13 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 		wait_for_completion(cmp);
 		pr_debug("wait complete\n");
 
-		if (cpufreq_driver->exit)
-			cpufreq_driver->exit(data);
+		if (exit)
+			exit(data);
 
 		free_cpumask_var(data->related_cpus);
 		free_cpumask_var(data->cpus);
 		kfree(data);
-	} else if (cpufreq_driver->target) {
+	} else if (target) {
 		__cpufreq_governor(data, CPUFREQ_GOV_START);
 		__cpufreq_governor(data, CPUFREQ_GOV_LIMITS);
 	}
@@ -1157,10 +1222,18 @@ static void cpufreq_out_of_sync(unsigned int cpu, unsigned int old_freq,
 unsigned int cpufreq_quick_get(unsigned int cpu)
 {
 	struct cpufreq_policy *policy;
+	struct cpufreq_driver *driver;
+	unsigned int (*get)(unsigned int cpu);
 	unsigned int ret_freq = 0;
 
-	if (cpufreq_driver && cpufreq_driver->setpolicy && cpufreq_driver->get)
-		return cpufreq_driver->get(cpu);
+	rcu_read_lock();
+	driver = rcu_dereference(cpufreq_driver);
+	if (driver && driver->setpolicy && driver->get) {
+		get = driver->get;
+		rcu_read_unlock();
+		return get(cpu);
+	}
+	rcu_read_unlock();
 
 	policy = cpufreq_cpu_get(cpu);
 	if (policy) {
@@ -1197,14 +1270,23 @@ static unsigned int __cpufreq_get(unsigned int cpu)
 {
 	struct cpufreq_policy *policy = per_cpu(cpufreq_cpu_data, cpu);
 	unsigned int ret_freq = 0;
+	struct cpufreq_driver *driver;
+	unsigned int (*get)(unsigned int cpu);
+	u8 flags;
 
-	if (!cpufreq_driver->get)
+	rcu_read_lock();
+	driver = rcu_dereference(cpufreq_driver);
+	get = driver->get;
+	flags = driver->flags;
+	rcu_read_unlock();
+
+	if (!get)
 		return ret_freq;
 
-	ret_freq = cpufreq_driver->get(cpu);
+	ret_freq = get(cpu);
 
 	if (ret_freq && policy->cur &&
-		!(cpufreq_driver->flags & CPUFREQ_CONST_LOOPS)) {
+		!(flags & CPUFREQ_CONST_LOOPS)) {
 		/* verify no discrepancy between actual and
 					saved value exists */
 		if (unlikely(ret_freq != policy->cur)) {
@@ -1261,6 +1343,7 @@ static struct subsys_interface cpufreq_interface = {
 static int cpufreq_bp_suspend(void)
 {
 	int ret = 0;
+	int (*suspend)(struct cpufreq_policy *policy);
 
 	int cpu = smp_processor_id();
 	struct cpufreq_policy *cpu_policy;
@@ -1272,8 +1355,11 @@ static int cpufreq_bp_suspend(void)
 	if (!cpu_policy)
 		return 0;
 
-	if (cpufreq_driver->suspend) {
-		ret = cpufreq_driver->suspend(cpu_policy);
+	rcu_read_lock();
+	suspend = rcu_dereference(cpufreq_driver)->suspend;
+	rcu_read_unlock();
+	if (suspend) {
+		ret = suspend(cpu_policy);
 		if (ret)
 			printk(KERN_ERR "cpufreq: suspend failed in ->suspend "
 					"step on CPU %u\n", cpu_policy->cpu);
@@ -1299,6 +1385,7 @@ static int cpufreq_bp_suspend(void)
 static void cpufreq_bp_resume(void)
 {
 	int ret = 0;
+	int (*resume)(struct cpufreq_policy *policy);
 
 	int cpu = smp_processor_id();
 	struct cpufreq_policy *cpu_policy;
@@ -1310,8 +1397,11 @@ static void cpufreq_bp_resume(void)
 	if (!cpu_policy)
 		return;
 
-	if (cpufreq_driver->resume) {
-		ret = cpufreq_driver->resume(cpu_policy);
+	rcu_read_lock();
+	resume = rcu_dereference(cpufreq_driver)->resume;
+	rcu_read_unlock();
+	if (resume) {
+		ret = resume(cpu_policy);
 		if (ret) {
 			printk(KERN_ERR "cpufreq: resume failed in ->resume "
 					"step on CPU %u\n", cpu_policy->cpu);
@@ -1338,10 +1428,16 @@ static struct syscore_ops cpufreq_syscore_ops = {
  */
 const char *cpufreq_get_current_driver(void)
 {
-	if (cpufreq_driver)
-		return cpufreq_driver->name;
+	char *name = NULL;
+	struct cpufreq_driver *driver;
 
-	return NULL;
+	rcu_read_lock();
+	driver = rcu_dereference(cpufreq_driver);
+	if (driver)
+		name = driver->name;
+	rcu_read_unlock();
+
+	return name;
 }
 EXPORT_SYMBOL_GPL(cpufreq_get_current_driver);
 
@@ -1435,6 +1531,9 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
 {
 	int retval = -EINVAL;
 	unsigned int old_target_freq = target_freq;
+	int (*target)(struct cpufreq_policy *policy,
+		      unsigned int target_freq,
+		      unsigned int relation);
 
 	if (cpufreq_disabled())
 		return -ENODEV;
@@ -1451,8 +1550,11 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
 	if (target_freq == policy->cur)
 		return 0;
 
-	if (cpufreq_driver->target)
-		retval = cpufreq_driver->target(policy, target_freq, relation);
+	rcu_read_lock();
+	target = rcu_dereference(cpufreq_driver)->target;
+	rcu_read_unlock();
+	if (target)
+		retval = target(policy, target_freq, relation);
 
 	return retval;
 }
@@ -1485,18 +1587,24 @@ EXPORT_SYMBOL_GPL(cpufreq_driver_target);
 int __cpufreq_driver_getavg(struct cpufreq_policy *policy, unsigned int cpu)
 {
 	int ret = 0;
+	unsigned int (*getavg)(struct cpufreq_policy *policy,
+			       unsigned int cpu);
 
 	if (cpufreq_disabled())
 		return ret;
 
-	if (!cpufreq_driver->getavg)
+	rcu_read_lock();
+	getavg = rcu_dereference(cpufreq_driver)->getavg;
+	rcu_read_unlock();
+
+	if (!getavg)
 		return 0;
 
 	policy = cpufreq_cpu_get(policy->cpu);
 	if (!policy)
 		return -EINVAL;
 
-	ret = cpufreq_driver->getavg(policy, cpu);
+	ret = getavg(policy, cpu);
 
 	cpufreq_cpu_put(policy);
 	return ret;
@@ -1652,6 +1760,9 @@ static int __cpufreq_set_policy(struct cpufreq_policy *data,
 				struct cpufreq_policy *policy)
 {
 	int ret = 0;
+	struct cpufreq_driver *driver;
+	int (*verify)(struct cpufreq_policy *policy);
+	int (*setpolicy)(struct cpufreq_policy *policy);
 
 	pr_debug("setting new policy for CPU %u: %u - %u kHz\n", policy->cpu,
 		policy->min, policy->max);
@@ -1664,8 +1775,14 @@ static int __cpufreq_set_policy(struct cpufreq_policy *data,
 		goto error_out;
 	}
 
+	rcu_read_lock();
+	driver = rcu_dereference(cpufreq_driver);
+	verify = driver->verify;
+	setpolicy = driver->setpolicy;
+	rcu_read_unlock();
+
 	/* verify the cpu speed can be set within this limit */
-	ret = cpufreq_driver->verify(policy);
+	ret = verify(policy);
 	if (ret)
 		goto error_out;
 
@@ -1679,7 +1796,7 @@ static int __cpufreq_set_policy(struct cpufreq_policy *data,
 
 	/* verify the cpu speed can be set within this limit,
 	   which might be different to the first one */
-	ret = cpufreq_driver->verify(policy);
+	ret = verify(policy);
 	if (ret)
 		goto error_out;
 
@@ -1693,10 +1810,10 @@ static int __cpufreq_set_policy(struct cpufreq_policy *data,
 	pr_debug("new min and max freqs are %u - %u kHz\n",
 					data->min, data->max);
 
-	if (cpufreq_driver->setpolicy) {
+	if (setpolicy) {
 		data->policy = policy->policy;
 		pr_debug("setting range\n");
-		ret = cpufreq_driver->setpolicy(policy);
+		ret = setpolicy(policy);
 	} else {
 		if (policy->governor != data->governor) {
 			/* save old, working values */
@@ -1743,6 +1860,11 @@ int cpufreq_update_policy(unsigned int cpu)
 {
 	struct cpufreq_policy *data = cpufreq_cpu_get(cpu);
 	struct cpufreq_policy policy;
+	struct cpufreq_driver *driver;
+	unsigned int (*get)(unsigned int cpu);
+	int (*target)(struct cpufreq_policy *policy,
+		      unsigned int target_freq,
+		      unsigned int relation);
 	int ret;
 
 	if (!data) {
@@ -1762,15 +1884,21 @@ int cpufreq_update_policy(unsigned int cpu)
 	policy.policy = data->user_policy.policy;
 	policy.governor = data->user_policy.governor;
 
+	rcu_read_lock();
+	driver = rcu_dereference(cpufreq_driver);
+	get = driver->get;
+	target = driver->target;
+	rcu_read_unlock();
+
 	/* BIOS might change freq behind our back
 	  -> ask driver for current freq and notify governors about a change */
-	if (cpufreq_driver->get) {
-		policy.cur = cpufreq_driver->get(cpu);
+	if (get) {
+		policy.cur = get(cpu);
 		if (!data->cur) {
 			pr_debug("Driver did not initialize current freq");
 			data->cur = policy.cur;
 		} else {
-			if (data->cur != policy.cur && cpufreq_driver->target)
+			if (data->cur != policy.cur && target)
 				cpufreq_out_of_sync(cpu, data->cur,
 								policy.cur);
 		}
@@ -1848,19 +1976,20 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 	if (driver_data->setpolicy)
 		driver_data->flags |= CPUFREQ_CONST_LOOPS;
 
-	write_lock_irqsave(&cpufreq_driver_lock, flags);
-	if (cpufreq_driver) {
-		write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	spin_lock_irqsave(&cpufreq_driver_lock, flags);
+	if (rcu_access_pointer(cpufreq_driver)) {
+		spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 		return -EBUSY;
 	}
-	cpufreq_driver = driver_data;
-	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	rcu_assign_pointer(cpufreq_driver, driver_data);
+	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	synchronize_rcu();
 
 	ret = subsys_interface_register(&cpufreq_interface);
 	if (ret)
 		goto err_null_driver;
 
-	if (!(cpufreq_driver->flags & CPUFREQ_STICKY)) {
+	if (!(driver_data->flags & CPUFREQ_STICKY)) {
 		int i;
 		ret = -ENODEV;
 
@@ -1886,9 +2015,10 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 err_if_unreg:
 	subsys_interface_unregister(&cpufreq_interface);
 err_null_driver:
-	write_lock_irqsave(&cpufreq_driver_lock, flags);
-	cpufreq_driver = NULL;
-	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	spin_lock_irqsave(&cpufreq_driver_lock, flags);
+	rcu_assign_pointer(cpufreq_driver, NULL);
+	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	synchronize_rcu();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(cpufreq_register_driver);
@@ -1905,8 +2035,13 @@ EXPORT_SYMBOL_GPL(cpufreq_register_driver);
 int cpufreq_unregister_driver(struct cpufreq_driver *driver)
 {
 	unsigned long flags;
+	struct cpufreq_driver *old_driver;
+
+	rcu_read_lock();
+	old_driver = rcu_access_pointer(cpufreq_driver);
+	rcu_read_unlock();
 
-	if (!cpufreq_driver || (driver != cpufreq_driver))
+	if (!old_driver || (driver != old_driver))
 		return -EINVAL;
 
 	pr_debug("unregistering driver %s\n", driver->name);
@@ -1914,9 +2049,10 @@ int cpufreq_unregister_driver(struct cpufreq_driver *driver)
 	subsys_interface_unregister(&cpufreq_interface);
 	unregister_hotcpu_notifier(&cpufreq_cpu_notifier);
 
-	write_lock_irqsave(&cpufreq_driver_lock, flags);
-	cpufreq_driver = NULL;
-	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	spin_lock_irqsave(&cpufreq_driver_lock, flags);
+	rcu_assign_pointer(cpufreq_driver, NULL);
+	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	synchronize_rcu();
 
 	return 0;
 }
-- 
1.8.1.2

