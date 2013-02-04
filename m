Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab3BDWqC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 17:46:02 -0500
Received: from relay1.sgi.com ([192.48.179.29]:58195 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755938Ab3BDWp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 17:45:58 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
To: rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, Nathan Zimmer <nzimmer@sgi.com>
Subject: [PATCH 1/2] cpufreq: Convert the cpufreq_driver_lock to a rwlock
Date: Mon,  4 Feb 2013 16:45:12 -0600
Message-Id: <1360017913-25667-2-git-send-email-nzimmer@sgi.com>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1360017913-25667-1-git-send-email-nzimmer@sgi.com>
References: <1360017913-25667-1-git-send-email-nzimmer@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This completely eliminates the contention I am seeing in __cpufreq_cpu_get.
It also nicely stages the lock to be replaced by the rcu.

CC: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
---
 drivers/cpufreq/cpufreq.c | 44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 1f93dbd..13a83a2 100644
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
@@ -751,10 +751,10 @@ static int cpufreq_add_dev_policy(unsigned int cpu,
 				return -EBUSY;
 			}
 
-			spin_lock_irqsave(&cpufreq_driver_lock, flags);
+			write_lock_irqsave(&cpufreq_driver_lock, flags);
 			cpumask_copy(managed_policy->cpus, policy->cpus);
 			per_cpu(cpufreq_cpu_data, cpu) = managed_policy;
-			spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+			write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 			pr_debug("CPU already managed, adding link\n");
 			ret = sysfs_create_link(&dev->kobj,
@@ -850,14 +850,14 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
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
@@ -999,10 +999,10 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 
 
 err_out_unregister:
-	spin_lock_irqsave(&cpufreq_driver_lock, flags);
+	write_lock_irqsave(&cpufreq_driver_lock, flags);
 	for_each_cpu(j, policy->cpus)
 		per_cpu(cpufreq_cpu_data, j) = NULL;
-	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	kobject_put(&policy->kobj);
 	wait_for_completion(&policy->kobj_unregister);
@@ -1042,11 +1042,11 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 
 	pr_debug("unregistering CPU %u\n", cpu);
 
-	spin_lock_irqsave(&cpufreq_driver_lock, flags);
+	write_lock_irqsave(&cpufreq_driver_lock, flags);
 	data = per_cpu(cpufreq_cpu_data, cpu);
 
 	if (!data) {
-		spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+		write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 		unlock_policy_rwsem_write(cpu);
 		return -EINVAL;
 	}
@@ -1060,7 +1060,7 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 	if (unlikely(cpu != data->cpu)) {
 		pr_debug("removing link\n");
 		cpumask_clear_cpu(cpu, data->cpus);
-		spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+		write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 		kobj = &dev->kobj;
 		cpufreq_cpu_put(data);
 		unlock_policy_rwsem_write(cpu);
@@ -1089,7 +1089,7 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 		}
 	}
 
-	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	if (unlikely(cpumask_weight(data->cpus) > 1)) {
 		for_each_cpu(j, data->cpus) {
@@ -1109,7 +1109,7 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 		}
 	}
 #else
-	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 #endif
 
 	if (cpufreq_driver->target)
@@ -1878,13 +1878,13 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
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
@@ -1916,9 +1916,9 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
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
@@ -1944,9 +1944,9 @@ int cpufreq_unregister_driver(struct cpufreq_driver *driver)
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

