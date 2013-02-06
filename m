Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041Ab3BFCF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 21:05:27 -0500
Received: from relay2.sgi.com ([192.48.179.30]:49758 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755715Ab3BFCFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 21:05:23 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
To: viresh.kumar@linaro.org, rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, Nathan Zimmer <nzimmer@sgi.com>
Subject: [PATCH v2 linux-next 1/2] cpufreq: Convert the cpufreq_driver_lock to a rwlock
Date: Tue,  5 Feb 2013 20:04:49 -0600
Message-Id: <1360116290-23849-2-git-send-email-nzimmer@sgi.com>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1360116290-23849-1-git-send-email-nzimmer@sgi.com>
References: <74F10842A85F514CA8D8C487E74474BB2D2F925E@P-EXMB1-DC21.corp.sgi.com>
 <1360116290-23849-1-git-send-email-nzimmer@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This eliminates the contention I am seeing in __cpufreq_cpu_get.
It also nicely stages the lock to be replaced by the rcu.

Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
---
 drivers/cpufreq/cpufreq.c | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 9656420..ef25244 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -45,7 +45,7 @@ static DEFINE_PER_CPU(struct cpufreq_policy *, cpufreq_cpu_data);
 /* This one keeps track of the previously set governor of a removed CPU */
 static DEFINE_PER_CPU(char[CPUFREQ_NAME_LEN], cpufreq_cpu_governor);
 #endif
-static DEFINE_SPINLOCK(cpufreq_driver_lock);
+static DEFINE_RWLOCK(cpufreq_driver_lock);
 
 /*
  * cpu_policy_rwsem is a per CPU reader-writer semaphore designed to cure
@@ -149,7 +149,7 @@ static struct cpufreq_policy *__cpufreq_cpu_get(unsigned int cpu, bool sysfs)
 		goto err_out;
 
 	/* get the cpufreq driver */
-	spin_lock_irqsave(&cpufreq_driver_lock, flags);
+	read_lock_irqsave(&cpufreq_driver_lock, flags);
 
 	if (!cpufreq_driver)
 		goto err_out_unlock;
@@ -167,13 +167,13 @@ static struct cpufreq_policy *__cpufreq_cpu_get(unsigned int cpu, bool sysfs)
 	if (!sysfs && !kobject_get(&data->kobj))
 		goto err_out_put_module;
 
-	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
 	return data;
 
 err_out_put_module:
 	module_put(cpufreq_driver->owner);
 err_out_unlock:
-	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
 err_out:
 	return NULL;
 }
@@ -775,14 +775,14 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
 			goto err_out_kobj_put;
 	}
 
-	spin_lock_irqsave(&cpufreq_driver_lock, flags);
+	write_lock_irqsave(&cpufreq_driver_lock, flags);
 	for_each_cpu(j, policy->cpus) {
 		if (!cpu_online(j))
 			continue;
 		per_cpu(cpufreq_cpu_data, j) = policy;
 		per_cpu(cpufreq_policy_cpu, j) = policy->cpu;
 	}
-	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	ret = cpufreq_add_dev_symlink(cpu, policy);
 	if (ret)
@@ -827,10 +827,10 @@ static int cpufreq_add_policy_cpu(unsigned int cpu, unsigned int sibling,
 
 	__cpufreq_governor(policy, CPUFREQ_GOV_STOP);
 
-	spin_lock_irqsave(&cpufreq_driver_lock, flags);
+	write_lock_irqsave(&cpufreq_driver_lock, flags);
 	cpumask_set_cpu(cpu, policy->cpus);
 	per_cpu(cpufreq_cpu_data, cpu) = policy;
-	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	__cpufreq_governor(policy, CPUFREQ_GOV_START);
 	__cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
@@ -977,10 +977,10 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 	return 0;
 
 err_out_unregister:
-	spin_lock_irqsave(&cpufreq_driver_lock, flags);
+	write_lock_irqsave(&cpufreq_driver_lock, flags);
 	for_each_cpu(j, policy->cpus)
 		per_cpu(cpufreq_cpu_data, j) = NULL;
-	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	kobject_put(&policy->kobj);
 	wait_for_completion(&policy->kobj_unregister);
@@ -1036,12 +1036,12 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 
 	pr_debug("%s: unregistering CPU %u\n", __func__, cpu);
 
-	spin_lock_irqsave(&cpufreq_driver_lock, flags);
+	write_lock_irqsave(&cpufreq_driver_lock, flags);
 	data = per_cpu(cpufreq_cpu_data, cpu);
 
 	if (!data) {
 		pr_debug("%s: No cpu_data found\n", __func__);
-		spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+		write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 		unlock_policy_rwsem_write(cpu);
 		return -EINVAL;
 	}
@@ -1068,7 +1068,7 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 			cpumask_set_cpu(cpu, data->cpus);
 			ret = sysfs_create_link(&cpu_dev->kobj, &data->kobj,
 					"cpufreq");
-			spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+			write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 			unlock_policy_rwsem_write(cpu);
 			return -EINVAL;
 		}
@@ -1078,7 +1078,7 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 				__func__, cpu_dev->id, cpu);
 	}
 
-	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	pr_debug("%s: removing link, cpu: %d\n", __func__, cpu);
 	cpufreq_cpu_put(data);
@@ -1866,13 +1866,13 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 	if (driver_data->setpolicy)
 		driver_data->flags |= CPUFREQ_CONST_LOOPS;
 
-	spin_lock_irqsave(&cpufreq_driver_lock, flags);
+	write_lock_irqsave(&cpufreq_driver_lock, flags);
 	if (cpufreq_driver) {
-		spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+		write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 		return -EBUSY;
 	}
 	cpufreq_driver = driver_data;
-	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	ret = subsys_interface_register(&cpufreq_interface);
 	if (ret)
@@ -1904,9 +1904,9 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 err_if_unreg:
 	subsys_interface_unregister(&cpufreq_interface);
 err_null_driver:
-	spin_lock_irqsave(&cpufreq_driver_lock, flags);
+	write_lock_irqsave(&cpufreq_driver_lock, flags);
 	cpufreq_driver = NULL;
-	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(cpufreq_register_driver);
@@ -1932,9 +1932,9 @@ int cpufreq_unregister_driver(struct cpufreq_driver *driver)
 	subsys_interface_unregister(&cpufreq_interface);
 	unregister_hotcpu_notifier(&cpufreq_cpu_notifier);
 
-	spin_lock_irqsave(&cpufreq_driver_lock, flags);
+	write_lock_irqsave(&cpufreq_driver_lock, flags);
 	cpufreq_driver = NULL;
-	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	return 0;
 }
-- 
1.8.0.1

