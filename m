Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab3BUACR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 19:02:17 -0500
Received: from relay3.sgi.com ([192.48.152.1]:51217 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751637Ab3BUABv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 19:01:51 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
To: viresh.kumar@linaro.org, rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nathan Zimmer <nzimmer@sgi.com>
Subject: [PATCH v3 1/2] cpufreq: Convert the cpufreq_driver_lock to a rwlock
Date: Wed, 20 Feb 2013 17:56:22 -0600
Message-Id: <1361404583-5557-2-git-send-email-nzimmer@sgi.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361404583-5557-1-git-send-email-nzimmer@sgi.com>
References: <1360116290-23849-1-git-send-email-nzimmer@sgi.com>
 <1361404583-5557-1-git-send-email-nzimmer@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This eliminates the contention I am seeing in __cpufreq_cpu_get.
It also nicely stages the lock to be replaced by the rcu.

Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
---
 drivers/cpufreq/cpufreq.c | 52 +++++++++++++++++++++++------------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index b02824d..c5996fe 100644
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
@@ -137,7 +137,7 @@ static struct cpufreq_policy *__cpufreq_cpu_get(unsigned int cpu, bool sysfs)
 		goto err_out;
 
 	/* get the cpufreq driver */
-	spin_lock_irqsave(&cpufreq_driver_lock, flags);
+	read_lock_irqsave(&cpufreq_driver_lock, flags);
 
 	if (!cpufreq_driver)
 		goto err_out_unlock;
@@ -155,13 +155,13 @@ static struct cpufreq_policy *__cpufreq_cpu_get(unsigned int cpu, bool sysfs)
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
@@ -266,9 +266,9 @@ void cpufreq_notify_transition(struct cpufreq_freqs *freqs, unsigned int state)
 	pr_debug("notification %u of frequency transition to %u kHz\n",
 		state, freqs->new);
 
-	spin_lock_irqsave(&cpufreq_driver_lock, flags);
+	read_lock_irqsave(&cpufreq_driver_lock, flags);
 	policy = per_cpu(cpufreq_cpu_data, freqs->cpu);
-	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	switch (state) {
 
@@ -765,12 +765,12 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
 			goto err_out_kobj_put;
 	}
 
-	spin_lock_irqsave(&cpufreq_driver_lock, flags);
+	write_lock_irqsave(&cpufreq_driver_lock, flags);
 	for_each_cpu(j, policy->cpus) {
 		per_cpu(cpufreq_cpu_data, j) = policy;
 		per_cpu(cpufreq_policy_cpu, j) = policy->cpu;
 	}
-	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	ret = cpufreq_add_dev_symlink(cpu, policy);
 	if (ret)
@@ -813,12 +813,12 @@ static int cpufreq_add_policy_cpu(unsigned int cpu, unsigned int sibling,
 
 	lock_policy_rwsem_write(sibling);
 
-	spin_lock_irqsave(&cpufreq_driver_lock, flags);
+	write_lock_irqsave(&cpufreq_driver_lock, flags);
 
 	cpumask_set_cpu(cpu, policy->cpus);
 	per_cpu(cpufreq_policy_cpu, cpu) = policy->cpu;
 	per_cpu(cpufreq_cpu_data, cpu) = policy;
-	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	unlock_policy_rwsem_write(sibling);
 
@@ -871,15 +871,15 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 
 #ifdef CONFIG_HOTPLUG_CPU
 	/* Check if this cpu was hot-unplugged earlier and has siblings */
-	spin_lock_irqsave(&cpufreq_driver_lock, flags);
+	read_lock_irqsave(&cpufreq_driver_lock, flags);
 	for_each_online_cpu(sibling) {
 		struct cpufreq_policy *cp = per_cpu(cpufreq_cpu_data, sibling);
 		if (cp && cpumask_test_cpu(cpu, cp->related_cpus)) {
-			spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+			read_unlock_irqrestore(&cpufreq_driver_lock, flags);
 			return cpufreq_add_policy_cpu(cpu, sibling, dev);
 		}
 	}
-	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
 #endif
 #endif
 
@@ -952,10 +952,10 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
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
@@ -1008,12 +1008,12 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 
 	pr_debug("%s: unregistering CPU %u\n", __func__, cpu);
 
-	spin_lock_irqsave(&cpufreq_driver_lock, flags);
+	write_lock_irqsave(&cpufreq_driver_lock, flags);
 
 	data = per_cpu(cpufreq_cpu_data, cpu);
 	per_cpu(cpufreq_cpu_data, cpu) = NULL;
 
-	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	if (!data) {
 		pr_debug("%s: No cpu_data found\n", __func__);
@@ -1047,9 +1047,9 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 			WARN_ON(lock_policy_rwsem_write(cpu));
 			cpumask_set_cpu(cpu, data->cpus);
 
-			spin_lock_irqsave(&cpufreq_driver_lock, flags);
+			write_lock_irqsave(&cpufreq_driver_lock, flags);
 			per_cpu(cpufreq_cpu_data, cpu) = data;
-			spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+			write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 			unlock_policy_rwsem_write(cpu);
 
@@ -1848,13 +1848,13 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
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
@@ -1886,9 +1886,9 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
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
@@ -1914,9 +1914,9 @@ int cpufreq_unregister_driver(struct cpufreq_driver *driver)
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
1.8.1.2

