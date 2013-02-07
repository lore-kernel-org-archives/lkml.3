Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977Ab3BGK21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 05:28:27 -0500
Received: from service87.mimecast.com ([91.220.42.44]:52974 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757750Ab3BGK2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 05:28:06 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, valdis.kletnieks@vt.edu, artem.savkov@gmail.com
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 4/4] cpufreq: Fix locking issues
Date: Thu,  7 Feb 2013 15:57:46 +0530
Message-Id: <50f6802f8dccb7bbad29010e57973d46b7e7a07e.1360232293.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1360232293.git.viresh.kumar@linaro.org>
References: <cover.1360232293.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1360232293.git.viresh.kumar@linaro.org>
References: <cover.1360232293.git.viresh.kumar@linaro.org>
X-OriginalArrivalTime: 07 Feb 2013 10:28:03.0177 (UTC) FILETIME=[CF613D90:01CE051D]
X-MC-Unique: 113020710280405501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r17ASTc4028056

cpufreq core uses two locks:
- cpufreq_driver_lock: General lock for driver and cpufreq_cpu_data array.
- cpu_policy_rwsemfix locking: per CPU reader-writer semaphore designed to cure
  all cpufreq/hotplug/workqueue/etc related lock issues.

These locks were not used properly and are placed against their principle
(present before their definition) at various places. This patch is an attempt to
fix their use.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 79 +++++++++++++++++++++++++++--------------------
 1 file changed, 45 insertions(+), 34 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index c46aed4..79511ab 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -59,8 +59,6 @@ static DEFINE_SPINLOCK(cpufreq_driver_lock);
  *   mode before doing so.
  *
  * Additional rules:
- * - All holders of the lock should check to make sure that the CPU they
- *   are concerned with are online after they get the lock.
  * - Governor routines that can be called in cpufreq hotplug path should not
  *   take this sem as top level hotplug notifier handler takes this.
  * - Lock should not be held across
@@ -257,6 +255,7 @@ void cpufreq_notify_transition(struct cpufreq_freqs *freqs, unsigned int state)
 {
 	struct cpufreq_policy *policy;
 	struct cpufreq_driver *driver;
+	unsigned long flags;
 
 	BUG_ON(irqs_disabled());
 
@@ -269,7 +268,10 @@ void cpufreq_notify_transition(struct cpufreq_freqs *freqs, unsigned int state)
 	pr_debug("notification %u of frequency transition to %u kHz\n",
 		state, freqs->new);
 
+	spin_lock_irqsave(&cpufreq_driver_lock, flags);
 	policy = per_cpu(cpufreq_cpu_data, freqs->cpu);
+	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+
 	switch (state) {
 
 	case CPUFREQ_PRECHANGE:
@@ -792,8 +794,10 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
 
 	if (ret) {
 		pr_debug("setting policy failed\n");
+		spin_lock_irqsave(&cpufreq_driver_lock, flags);
 		if (driver->exit)
 			driver->exit(policy);
+		spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 	}
 	return ret;
 
@@ -814,22 +818,22 @@ static int cpufreq_add_policy_cpu(unsigned int cpu, unsigned int sibling,
 	policy = cpufreq_cpu_get(sibling);
 	WARN_ON(!policy);
 
-	per_cpu(cpufreq_policy_cpu, cpu) = policy->cpu;
-
-	lock_policy_rwsem_write(cpu);
-
 	__cpufreq_governor(policy, CPUFREQ_GOV_STOP);
 
+	lock_policy_rwsem_write(sibling);
+
 	spin_lock_irqsave(&cpufreq_driver_lock, flags);
+
 	cpumask_set_cpu(cpu, policy->cpus);
+	per_cpu(cpufreq_policy_cpu, cpu) = policy->cpu;
 	per_cpu(cpufreq_cpu_data, cpu) = policy;
 	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
+	unlock_policy_rwsem_write(sibling);
+
 	__cpufreq_governor(policy, CPUFREQ_GOV_START);
 	__cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
 
-	unlock_policy_rwsem_write(cpu);
-
 	ret = sysfs_create_link(&dev->kobj, &policy->kobj, "cpufreq");
 	if (ret) {
 		cpufreq_cpu_put(policy);
@@ -878,11 +882,15 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 
 #ifdef CONFIG_HOTPLUG_CPU
 	/* Check if this cpu was hot-unplugged earlier and has siblings */
+	spin_lock_irqsave(&cpufreq_driver_lock, flags);
 	for_each_online_cpu(sibling) {
 		struct cpufreq_policy *cp = per_cpu(cpufreq_cpu_data, sibling);
-		if (cp && cpumask_test_cpu(cpu, cp->related_cpus))
+		if (cp && cpumask_test_cpu(cpu, cp->related_cpus)) {
+			spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 			return cpufreq_add_policy_cpu(cpu, sibling, dev);
+		}
 	}
+	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 #endif
 #endif
 
@@ -907,20 +915,21 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 
 	/* Initially set CPU itself as the policy_cpu */
 	per_cpu(cpufreq_policy_cpu, cpu) = cpu;
-	ret = (lock_policy_rwsem_write(cpu) < 0);
-	WARN_ON(ret);
 
 	init_completion(&policy->kobj_unregister);
 	INIT_WORK(&policy->update, handle_update);
 
+	spin_lock_irqsave(&cpufreq_driver_lock, flags);
 	/* call driver. From then on the cpufreq must be able
 	 * to accept all calls to ->verify and ->setpolicy for this CPU
 	 */
 	ret = driver->init(policy);
 	if (ret) {
 		pr_debug("initialization failed\n");
-		goto err_unlock_policy;
+		spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+		goto err_set_policy_cpu;
 	}
+	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	/* related cpus should atleast have policy->cpus */
 	cpumask_or(policy->related_cpus, policy->related_cpus, policy->cpus);
@@ -950,8 +959,6 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 	if (ret)
 		goto err_out_unregister;
 
-	unlock_policy_rwsem_write(cpu);
-
 	kobject_uevent(&policy->kobj, KOBJ_ADD);
 	module_put(rcu_dereference(cpufreq_driver)->owner);
 	pr_debug("initialization complete\n");
@@ -967,8 +974,8 @@ err_out_unregister:
 	kobject_put(&policy->kobj);
 	wait_for_completion(&policy->kobj_unregister);
 
-err_unlock_policy:
-	unlock_policy_rwsem_write(cpu);
+err_set_policy_cpu:
+	per_cpu(cpufreq_policy_cpu, cpu) = -1;
 	free_cpumask_var(policy->related_cpus);
 err_free_cpumask:
 	free_cpumask_var(policy->cpus);
@@ -1017,12 +1024,14 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 	pr_debug("%s: unregistering CPU %u\n", __func__, cpu);
 
 	spin_lock_irqsave(&cpufreq_driver_lock, flags);
+
 	data = per_cpu(cpufreq_cpu_data, cpu);
+	per_cpu(cpufreq_cpu_data, cpu) = NULL;
+
+	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	if (!data) {
 		pr_debug("%s: No cpu_data found\n", __func__);
-		spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
-		unlock_policy_rwsem_write(cpu);
 		return -EINVAL;
 	}
 
@@ -1034,9 +1043,10 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 			CPUFREQ_NAME_LEN);
 #endif
 
-	per_cpu(cpufreq_cpu_data, cpu) = NULL;
+	WARN_ON(lock_policy_rwsem_write(cpu));
 	cpus = cpumask_weight(data->cpus);
 	cpumask_clear_cpu(cpu, data->cpus);
+	unlock_policy_rwsem_write(cpu);
 
 	if (cpu != data->cpu) {
 		sysfs_remove_link(&dev->kobj, "cpufreq");
@@ -1047,31 +1057,37 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 		ret = kobject_move(&data->kobj, &cpu_dev->kobj);
 		if (ret) {
 			pr_err("%s: Failed to move kobj: %d", __func__, ret);
+
+			WARN_ON(lock_policy_rwsem_write(cpu));
 			cpumask_set_cpu(cpu, data->cpus);
-			ret = sysfs_create_link(&cpu_dev->kobj, &data->kobj,
-					"cpufreq");
+
+			spin_lock_irqsave(&cpufreq_driver_lock, flags);
+			per_cpu(cpufreq_cpu_data, cpu) = data;
 			spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+
 			unlock_policy_rwsem_write(cpu);
+
+			ret = sysfs_create_link(&cpu_dev->kobj, &data->kobj,
+					"cpufreq");
 			return -EINVAL;
 		}
 
+		WARN_ON(lock_policy_rwsem_write(cpu));
 		update_policy_cpu(data, cpu_dev->id);
+		unlock_policy_rwsem_write(cpu);
 		pr_debug("%s: policy Kobject moved to cpu: %d from: %d\n",
 				__func__, cpu_dev->id, cpu);
 	}
 
-	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
-
 	pr_debug("%s: removing link, cpu: %d\n", __func__, cpu);
 	cpufreq_cpu_put(data);
-	unlock_policy_rwsem_write(cpu);
 
 	/* If cpu is last user of policy, free policy */
 	if (cpus == 1) {
-		lock_policy_rwsem_write(cpu);
+		lock_policy_rwsem_read(cpu);
 		kobj = &data->kobj;
 		cmp = &data->kobj_unregister;
-		unlock_policy_rwsem_write(cpu);
+		unlock_policy_rwsem_read(cpu);
 		kobject_put(kobj);
 
 		/* we need to make sure that the underlying kobj is actually
@@ -1082,10 +1098,10 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 		wait_for_completion(cmp);
 		pr_debug("wait complete\n");
 
-		lock_policy_rwsem_write(cpu);
+		spin_lock_irqsave(&cpufreq_driver_lock, flags);
 		if (driver->exit)
 			driver->exit(data);
-		unlock_policy_rwsem_write(cpu);
+		spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 		free_cpumask_var(data->related_cpus);
 		free_cpumask_var(data->cpus);
@@ -1095,6 +1111,7 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 		__cpufreq_governor(data, CPUFREQ_GOV_LIMITS);
 	}
 
+	per_cpu(cpufreq_policy_cpu, cpu) = -1;
 	return 0;
 }
 
@@ -1107,9 +1124,6 @@ static int cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif)
 	if (cpu_is_offline(cpu))
 		return 0;
 
-	if (unlikely(lock_policy_rwsem_write(cpu)))
-		BUG();
-
 	retval = __cpufreq_remove_dev(dev, sif);
 	return retval;
 }
@@ -1808,9 +1822,6 @@ static int __cpuinit cpufreq_cpu_callback(struct notifier_block *nfb,
 			break;
 		case CPU_DOWN_PREPARE:
 		case CPU_DOWN_PREPARE_FROZEN:
-			if (unlikely(lock_policy_rwsem_write(cpu)))
-				BUG();
-
 			__cpufreq_remove_dev(dev, NULL);
 			break;
 		case CPU_DOWN_FAILED:
-- 
1.7.12.rc2.18.g61b472e


