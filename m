Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762307Ab3DDOxf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 10:53:35 -0400
Received: from relay2.sgi.com ([192.48.179.30]:55161 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761990Ab3DDOxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 10:53:34 -0400
From: Nathan Zimmer <nzimmer@sgi.com>
To: viresh.kumar@linaro.org, rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nathan Zimmer <nzimmer@sgi.com>
Subject: [PATCH linux-next v8] cpufreq: convert the cpufreq_driver to use the rcu
Date: Thu,  4 Apr 2013 09:53:25 -0500
Message-Id: <1365087205-8708-1-git-send-email-nzimmer@sgi.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <515C5AB6.5090109@sgi.com>
References: <515C5AB6.5090109@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We eventually would like to remove the rwlock cpufreq_driver_lock or convert
it back to a spinlock and protect the read sections with RCU.  The first step in
that is moving the cpufreq_driver to use the rcu.
I don't see an easy wasy to protect the cpufreq_cpu_data structure with the
RCU, so I am leaving it with the rwlock for now since under certain configs
__cpufreq_cpu_get is hot spot with 256+ cores.

v5: Go a different way and split up the lock and use the rcu
v6: use bools instead of checking function pointers
    covert the cpufreq_data_lock to a rwlock
v7: Rebase to use the already accepted half
v8: Correct have_governor_per_policy
    Reviewed location of rcu_read_(un)lock in several spots

Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
---
 drivers/cpufreq/cpufreq.c | 277 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 209 insertions(+), 68 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 85963fc..a13358b 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -39,7 +39,7 @@
  * level driver of CPUFreq support, and its spinlock. This lock
  * also protects the cpufreq_cpu_data array.
  */
-static struct cpufreq_driver *cpufreq_driver;
+static struct cpufreq_driver __rcu *cpufreq_driver;
 static DEFINE_PER_CPU(struct cpufreq_policy *, cpufreq_cpu_data);
 #ifdef CONFIG_HOTPLUG_CPU
 /* This one keeps track of the previously set governor of a removed CPU */
@@ -130,26 +130,34 @@ static DEFINE_MUTEX(cpufreq_governor_mutex);
 
 bool have_governor_per_policy(void)
 {
-	return cpufreq_driver->have_governor_per_policy;
+	bool have_governor_per_policy;
+	rcu_read_lock();
+	have_governor_per_policy = 
+		rcu_dereference(cpufreq_driver)->have_governor_per_policy;
+	rcu_read_unlock();
+	return have_governor_per_policy;
 }
 
 static struct cpufreq_policy *__cpufreq_cpu_get(unsigned int cpu, bool sysfs)
 {
 	struct cpufreq_policy *data;
+ 	struct cpufreq_driver *driver;
 	unsigned long flags;
 
 	if (cpu >= nr_cpu_ids)
 		goto err_out;
 
 	/* get the cpufreq driver */
-	read_lock_irqsave(&cpufreq_driver_lock, flags);
+	rcu_read_lock();
+ 	driver = rcu_dereference(cpufreq_driver);
 
-	if (!cpufreq_driver)
+	if (!driver)
 		goto err_out_unlock;
 
-	if (!try_module_get(cpufreq_driver->owner))
+	if (!try_module_get(driver->owner))
 		goto err_out_unlock;
 
+	read_lock_irqsave(&cpufreq_driver_lock, flags);
 
 	/* get the CPU */
 	data = per_cpu(cpufreq_cpu_data, cpu);
@@ -161,12 +169,14 @@ static struct cpufreq_policy *__cpufreq_cpu_get(unsigned int cpu, bool sysfs)
 		goto err_out_put_module;
 
 	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	rcu_read_unlock();
 	return data;
 
 err_out_put_module:
-	module_put(cpufreq_driver->owner);
-err_out_unlock:
+	module_put(driver->owner);
 	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
+err_out_unlock:
+	rcu_read_unlock();
 err_out:
 	return NULL;
 }
@@ -189,7 +199,9 @@ static void __cpufreq_cpu_put(struct cpufreq_policy *data, bool sysfs)
 {
 	if (!sysfs)
 		kobject_put(&data->kobj);
-	module_put(cpufreq_driver->owner);
+	rcu_read_lock();
+	module_put(rcu_dereference(cpufreq_driver)->owner);
+	rcu_read_unlock();
 }
 
 void cpufreq_cpu_put(struct cpufreq_policy *data)
@@ -267,7 +279,9 @@ void cpufreq_notify_transition(struct cpufreq_freqs *freqs, unsigned int state)
 	if (cpufreq_disabled())
 		return;
 
-	freqs->flags = cpufreq_driver->flags;
+	rcu_read_lock();
+	freqs->flags = rcu_dereference(cpufreq_driver)->flags;
+	rcu_read_unlock();
 	pr_debug("notification %u of frequency transition to %u kHz\n",
 		state, freqs->new);
 
@@ -282,7 +296,7 @@ void cpufreq_notify_transition(struct cpufreq_freqs *freqs, unsigned int state)
 		 * which is not equal to what the cpufreq core thinks is
 		 * "old frequency".
 		 */
-		if (!(cpufreq_driver->flags & CPUFREQ_CONST_LOOPS)) {
+		if (!(freqs->flags & CPUFREQ_CONST_LOOPS)) {
 			if ((policy) && (policy->cpu == freqs->cpu) &&
 			    (policy->cur) && (policy->cur != freqs->old)) {
 				pr_debug("Warning: CPU frequency is"
@@ -334,11 +348,21 @@ static int cpufreq_parse_governor(char *str_governor, unsigned int *policy,
 				struct cpufreq_governor **governor)
 {
 	int err = -EINVAL;
-
-	if (!cpufreq_driver)
+	struct cpufreq_driver *driver;
+	bool has_setpolicy;
+	bool has_target;
+
+	rcu_read_lock();
+	driver = rcu_dereference(cpufreq_driver);
+	if (!driver) {
+		rcu_read_unlock();
 		goto out;
+	}
+	has_setpolicy = driver->setpolicy ? true : false;
+	has_target = driver->target ? true : false;
+	rcu_read_unlock();
 
-	if (cpufreq_driver->setpolicy) {
+	if (has_setpolicy) {
 		if (!strnicmp(str_governor, "performance", CPUFREQ_NAME_LEN)) {
 			*policy = CPUFREQ_POLICY_PERFORMANCE;
 			err = 0;
@@ -347,7 +371,7 @@ static int cpufreq_parse_governor(char *str_governor, unsigned int *policy,
 			*policy = CPUFREQ_POLICY_POWERSAVE;
 			err = 0;
 		}
-	} else if (cpufreq_driver->target) {
+	} else if (has_target) {
 		struct cpufreq_governor *t;
 
 		mutex_lock(&cpufreq_governor_mutex);
@@ -498,7 +522,12 @@ static ssize_t store_scaling_governor(struct cpufreq_policy *policy,
  */
 static ssize_t show_scaling_driver(struct cpufreq_policy *policy, char *buf)
 {
-	return scnprintf(buf, CPUFREQ_NAME_PLEN, "%s\n", cpufreq_driver->name);
+	ssize_t size;
+	rcu_read_lock();
+	size = scnprintf(buf, CPUFREQ_NAME_PLEN, "%s\n", 
+		rcu_dereference(cpufreq_driver)->name); 
+	rcu_read_unlock();
+	return size;
 }
 
 /**
@@ -510,10 +539,13 @@ static ssize_t show_scaling_available_governors(struct cpufreq_policy *policy,
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
@@ -591,9 +623,15 @@ static ssize_t show_scaling_setspeed(struct cpufreq_policy *policy, char *buf)
 static ssize_t show_bios_limit(struct cpufreq_policy *policy, char *buf)
 {
 	unsigned int limit;
+	int (*bios_limit)(int cpu, unsigned int *limit);
 	int ret;
-	if (cpufreq_driver->bios_limit) {
-		ret = cpufreq_driver->bios_limit(policy->cpu, &limit);
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
@@ -736,6 +774,7 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
 {
 	struct cpufreq_policy new_policy;
 	struct freq_attr **drv_attr;
+	struct cpufreq_driver *driver;
 	unsigned long flags;
 	int ret = 0;
 	unsigned int j;
@@ -747,28 +786,31 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
 		return ret;
 
 	/* set up files for this cpu device */
-	drv_attr = cpufreq_driver->attr;
+	rcu_read_lock();
+	driver = rcu_dereference(cpufreq_driver);
+	drv_attr = driver->attr;
 	while ((drv_attr) && (*drv_attr)) {
 		ret = sysfs_create_file(&policy->kobj, &((*drv_attr)->attr));
 		if (ret)
-			goto err_out_kobj_put;
+			goto err_out_unlock;
 		drv_attr++;
 	}
-	if (cpufreq_driver->get) {
+	if (driver->get) {
 		ret = sysfs_create_file(&policy->kobj, &cpuinfo_cur_freq.attr);
 		if (ret)
-			goto err_out_kobj_put;
+			goto err_out_unlock;
 	}
-	if (cpufreq_driver->target) {
+	if (driver->target) {
 		ret = sysfs_create_file(&policy->kobj, &scaling_cur_freq.attr);
 		if (ret)
-			goto err_out_kobj_put;
+			goto err_out_unlock;
 	}
-	if (cpufreq_driver->bios_limit) {
+	if (driver->bios_limit) {
 		ret = sysfs_create_file(&policy->kobj, &bios_limit.attr);
 		if (ret)
-			goto err_out_kobj_put;
+			goto err_out_unlock;
 	}
+	rcu_read_unlock();
 
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
 	for_each_cpu(j, policy->cpus) {
@@ -791,12 +833,20 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
 	policy->user_policy.governor = policy->governor;
 
 	if (ret) {
+		int (*exit)(struct cpufreq_policy *policy);
+
 		pr_debug("setting policy failed\n");
-		if (cpufreq_driver->exit)
-			cpufreq_driver->exit(policy);
+		rcu_read_lock();
+		exit = rcu_dereference(cpufreq_driver)->exit;
+		rcu_read_unlock();
+		if (exit)
+			exit(policy);
+
 	}
 	return ret;
 
+err_out_unlock:
+	rcu_read_unlock();
 err_out_kobj_put:
 	kobject_put(&policy->kobj);
 	wait_for_completion(&policy->kobj_unregister);
@@ -854,6 +904,8 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 	unsigned int j, cpu = dev->id;
 	int ret = -ENOMEM;
 	struct cpufreq_policy *policy;
+	struct cpufreq_driver *driver;
+	int (*init)(struct cpufreq_policy *policy);
 	unsigned long flags;
 #ifdef CONFIG_HOTPLUG_CPU
 	struct cpufreq_governor *gov;
@@ -888,10 +940,15 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 #endif
 #endif
 
-	if (!try_module_get(cpufreq_driver->owner)) {
+	rcu_read_lock();
+	driver = rcu_dereference(cpufreq_driver);
+	if (!try_module_get(driver->owner)) {
+		rcu_read_unlock();
 		ret = -EINVAL;
 		goto module_out;
 	}
+	init = driver->init;
+	rcu_read_unlock();
 
 	policy = kzalloc(sizeof(struct cpufreq_policy), GFP_KERNEL);
 	if (!policy)
@@ -916,7 +973,7 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 	/* call driver. From then on the cpufreq must be able
 	 * to accept all calls to ->verify and ->setpolicy for this CPU
 	 */
-	ret = cpufreq_driver->init(policy);
+	ret = init(policy);
 	if (ret) {
 		pr_debug("initialization failed\n");
 		goto err_set_policy_cpu;
@@ -951,7 +1008,9 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 		goto err_out_unregister;
 
 	kobject_uevent(&policy->kobj, KOBJ_ADD);
-	module_put(cpufreq_driver->owner);
+	rcu_read_lock();
+	module_put(rcu_dereference(cpufreq_driver)->owner);
+	rcu_read_unlock();
 	pr_debug("initialization complete\n");
 
 	return 0;
@@ -973,7 +1032,9 @@ err_free_cpumask:
 err_free_policy:
 	kfree(policy);
 nomem_out:
-	module_put(cpufreq_driver->owner);
+	rcu_read_lock();
+	module_put(rcu_dereference(cpufreq_driver)->owner);
+	rcu_read_unlock();
 module_out:
 	return ret;
 }
@@ -1007,9 +1068,12 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 	unsigned int cpu = dev->id, ret, cpus;
 	unsigned long flags;
 	struct cpufreq_policy *data;
+	struct cpufreq_driver *driver;
 	struct kobject *kobj;
 	struct completion *cmp;
 	struct device *cpu_dev;
+ 	bool has_target;
+ 	int (*exit)(struct cpufreq_policy *policy);
 
 	pr_debug("%s: unregistering CPU %u\n", __func__, cpu);
 
@@ -1025,14 +1089,19 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 		return -EINVAL;
 	}
 
-	if (cpufreq_driver->target)
+	rcu_read_lock();
+	driver = rcu_dereference(cpufreq_driver);
+	has_target = driver->target ? true : false;
+	exit = driver->exit;
+	if (has_target)
 		__cpufreq_governor(data, CPUFREQ_GOV_STOP);
 
 #ifdef CONFIG_HOTPLUG_CPU
-	if (!cpufreq_driver->setpolicy)
+	if (!driver->setpolicy)
 		strncpy(per_cpu(cpufreq_cpu_governor, cpu),
 			data->governor->name, CPUFREQ_NAME_LEN);
 #endif
+	rcu_read_unlock();
 
 	WARN_ON(lock_policy_rwsem_write(cpu));
 	cpus = cpumask_weight(data->cpus);
@@ -1091,13 +1160,13 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
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
+	} else if (has_target) {
 		__cpufreq_governor(data, CPUFREQ_GOV_START);
 		__cpufreq_governor(data, CPUFREQ_GOV_LIMITS);
 	}
@@ -1164,10 +1233,18 @@ static void cpufreq_out_of_sync(unsigned int cpu, unsigned int old_freq,
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
@@ -1203,15 +1280,26 @@ EXPORT_SYMBOL(cpufreq_quick_get_max);
 static unsigned int __cpufreq_get(unsigned int cpu)
 {
 	struct cpufreq_policy *policy = per_cpu(cpufreq_cpu_data, cpu);
+	struct cpufreq_driver *driver;
+	unsigned int (*get)(unsigned int cpu);
 	unsigned int ret_freq = 0;
+	u8 flags;
+
 
-	if (!cpufreq_driver->get)
+	rcu_read_lock();
+	driver = rcu_dereference(cpufreq_driver);
+	if (!driver->get) {
+		rcu_read_unlock();
 		return ret_freq;
+	}
+	flags = driver->flags;
+	get = driver->get;
+	rcu_read_unlock();
 
-	ret_freq = cpufreq_driver->get(cpu);
+	ret_freq = get(cpu);
 
 	if (ret_freq && policy->cur &&
-		!(cpufreq_driver->flags & CPUFREQ_CONST_LOOPS)) {
+		!(flags & CPUFREQ_CONST_LOOPS)) {
 		/* verify no discrepancy between actual and
 					saved value exists */
 		if (unlikely(ret_freq != policy->cur)) {
@@ -1267,6 +1355,7 @@ static struct subsys_interface cpufreq_interface = {
  */
 static int cpufreq_bp_suspend(void)
 {
+	int (*suspend)(struct cpufreq_policy *policy);
 	int ret = 0;
 
 	int cpu = smp_processor_id();
@@ -1279,8 +1368,11 @@ static int cpufreq_bp_suspend(void)
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
@@ -1306,6 +1398,7 @@ static int cpufreq_bp_suspend(void)
 static void cpufreq_bp_resume(void)
 {
 	int ret = 0;
+	int (*resume)(struct cpufreq_policy *policy);
 
 	int cpu = smp_processor_id();
 	struct cpufreq_policy *cpu_policy;
@@ -1317,8 +1410,12 @@ static void cpufreq_bp_resume(void)
 	if (!cpu_policy)
 		return;
 
-	if (cpufreq_driver->resume) {
-		ret = cpufreq_driver->resume(cpu_policy);
+	rcu_read_lock();
+	resume = rcu_dereference(cpufreq_driver)->resume;
+	rcu_read_unlock();
+
+	if (resume) {
+		ret = resume(cpu_policy);
 		if (ret) {
 			printk(KERN_ERR "cpufreq: resume failed in ->resume "
 					"step on CPU %u\n", cpu_policy->cpu);
@@ -1345,10 +1442,14 @@ static struct syscore_ops cpufreq_syscore_ops = {
  */
 const char *cpufreq_get_current_driver(void)
 {
-	if (cpufreq_driver)
-		return cpufreq_driver->name;
-
-	return NULL;
+	struct cpufreq_driver *driver;
+	const char *name = NULL;
+	rcu_read_lock();
+	driver = rcu_dereference(cpufreq_driver);
+	if (driver)
+		name = driver->name;
+	rcu_read_unlock();
+	return name;
 }
 EXPORT_SYMBOL_GPL(cpufreq_get_current_driver);
 
@@ -1442,6 +1543,9 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
 {
 	int retval = -EINVAL;
 	unsigned int old_target_freq = target_freq;
+	int (*target)(struct cpufreq_policy *policy,
+		      unsigned int target_freq,
+		      unsigned int relation);
 
 	if (cpufreq_disabled())
 		return -ENODEV;
@@ -1458,8 +1562,11 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
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
@@ -1492,18 +1599,24 @@ EXPORT_SYMBOL_GPL(cpufreq_driver_target);
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
@@ -1661,6 +1774,9 @@ static int __cpufreq_set_policy(struct cpufreq_policy *data,
 				struct cpufreq_policy *policy)
 {
 	int ret = 0, failed = 1;
+	struct cpufreq_driver *driver;
+ 	int (*verify)(struct cpufreq_policy *policy);
+ 	int (*setpolicy)(struct cpufreq_policy *policy);
 
 	pr_debug("setting new policy for CPU %u: %u - %u kHz\n", policy->cpu,
 		policy->min, policy->max);
@@ -1674,7 +1790,13 @@ static int __cpufreq_set_policy(struct cpufreq_policy *data,
 	}
 
 	/* verify the cpu speed can be set within this limit */
-	ret = cpufreq_driver->verify(policy);
+	rcu_read_lock();
+	driver = rcu_dereference(cpufreq_driver);
+	verify = driver->verify;
+	setpolicy = driver->setpolicy;
+	rcu_read_unlock();
+
+	ret = verify(policy);
 	if (ret)
 		goto error_out;
 
@@ -1688,7 +1810,7 @@ static int __cpufreq_set_policy(struct cpufreq_policy *data,
 
 	/* verify the cpu speed can be set within this limit,
 	   which might be different to the first one */
-	ret = cpufreq_driver->verify(policy);
+	ret = verify(policy);
 	if (ret)
 		goto error_out;
 
@@ -1702,10 +1824,10 @@ static int __cpufreq_set_policy(struct cpufreq_policy *data,
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
@@ -1765,6 +1887,11 @@ int cpufreq_update_policy(unsigned int cpu)
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
@@ -1786,13 +1913,18 @@ int cpufreq_update_policy(unsigned int cpu)
 
 	/* BIOS might change freq behind our back
 	  -> ask driver for current freq and notify governors about a change */
-	if (cpufreq_driver->get) {
-		policy.cur = cpufreq_driver->get(cpu);
+	rcu_read_lock();
+	driver = rcu_access_pointer(cpufreq_driver);
+	get = driver->get;
+	target = driver->target;
+	rcu_read_unlock();
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
@@ -1869,20 +2001,21 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 
 	if (driver_data->setpolicy)
 		driver_data->flags |= CPUFREQ_CONST_LOOPS;
-
+	
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
-	if (cpufreq_driver) {
+	if (rcu_access_pointer(cpufreq_driver)) {
 		write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 		return -EBUSY;
 	}
-	cpufreq_driver = driver_data;
+	rcu_assign_pointer(cpufreq_driver, driver_data);;
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	synchronize_rcu();
 
 	ret = subsys_interface_register(&cpufreq_interface);
 	if (ret)
 		goto err_null_driver;
 
-	if (!(cpufreq_driver->flags & CPUFREQ_STICKY)) {
+	if (!(driver_data->flags & CPUFREQ_STICKY)) {
 		int i;
 		ret = -ENODEV;
 
@@ -1909,8 +2042,9 @@ err_if_unreg:
 	subsys_interface_unregister(&cpufreq_interface);
 err_null_driver:
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
-	cpufreq_driver = NULL;
+	rcu_assign_pointer(cpufreq_driver, NULL);
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	synchronize_rcu();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(cpufreq_register_driver);
@@ -1927,9 +2061,15 @@ EXPORT_SYMBOL_GPL(cpufreq_register_driver);
 int cpufreq_unregister_driver(struct cpufreq_driver *driver)
 {
 	unsigned long flags;
+	struct cpufreq_driver *old_driver;
 
-	if (!cpufreq_driver || (driver != cpufreq_driver))
+	rcu_read_lock();
+	old_driver = rcu_access_pointer(cpufreq_driver);
+	if (!old_driver || (driver != old_driver)) {
+		rcu_read_unlock();
 		return -EINVAL;
+	}
+	rcu_read_unlock();
 
 	pr_debug("unregistering driver %s\n", driver->name);
 
@@ -1937,8 +2077,9 @@ int cpufreq_unregister_driver(struct cpufreq_driver *driver)
 	unregister_hotcpu_notifier(&cpufreq_cpu_notifier);
 
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
-	cpufreq_driver = NULL;
+	rcu_assign_pointer(cpufreq_driver, NULL);
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	synchronize_rcu();
 
 	return 0;
 }
-- 
1.8.1.2

