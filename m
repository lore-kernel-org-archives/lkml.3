Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104Ab3DAULV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 16:11:21 -0400
Received: from relay2.sgi.com ([192.48.179.30]:50767 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751905Ab3DAULQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 16:11:16 -0400
From: Nathan Zimmer <nzimmer@sgi.com>
To: viresh.kumar@linaro.org, rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nathan Zimmer <nzimmer@sgi.com>
Subject: [PATCH v6 2/2] cpufreq: covert the cpufreq_data_lock to a spinlock
Date: Mon,  1 Apr 2013 15:11:09 -0500
Message-Id: <1364847069-2887-3-git-send-email-nzimmer@sgi.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364847069-2887-1-git-send-email-nzimmer@sgi.com>
References: <5159C147.70800@sgi.com>
 <1364847069-2887-1-git-send-email-nzimmer@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This eliminates the rest of the contention found in __cpufreq_cpu_get.
I am not seeing a way to use the rcu so we will have to make due with a
rwlock for now.

Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
---
 drivers/cpufreq/cpufreq.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 5139eab..7438c34 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -42,7 +42,7 @@
 static struct cpufreq_driver __rcu *cpufreq_driver;
 static DEFINE_SPINLOCK(cpufreq_driver_lock);
 
-static DEFINE_SPINLOCK(cpufreq_data_lock);
+static DEFINE_RWLOCK(cpufreq_data_lock);
 static DEFINE_PER_CPU(struct cpufreq_policy *, cpufreq_cpu_data);
 #ifdef CONFIG_HOTPLUG_CPU
 /* This one keeps track of the previously set governor of a removed CPU */
@@ -150,7 +150,7 @@ static struct cpufreq_policy *__cpufreq_cpu_get(unsigned int cpu, bool sysfs)
 		goto err_out_unlock;
 
 	/* get the CPU */
-	spin_lock_irqsave(&cpufreq_data_lock, flags);
+	read_lock_irqsave(&cpufreq_data_lock, flags);
 	data = per_cpu(cpufreq_cpu_data, cpu);
 
 	if (!data)
@@ -159,13 +159,13 @@ static struct cpufreq_policy *__cpufreq_cpu_get(unsigned int cpu, bool sysfs)
 	if (!sysfs && !kobject_get(&data->kobj))
 		goto err_out_put_module;
 
-	spin_unlock_irqrestore(&cpufreq_data_lock, flags);
+	read_unlock_irqrestore(&cpufreq_data_lock, flags);
 	rcu_read_unlock();
 	return data;
 
 err_out_put_module:
 	module_put(driver->owner);
-	spin_unlock_irqrestore(&cpufreq_data_lock, flags);
+	read_unlock_irqrestore(&cpufreq_data_lock, flags);
 err_out_unlock:
 	rcu_read_unlock();
 err_out:
@@ -276,9 +276,9 @@ void cpufreq_notify_transition(struct cpufreq_freqs *freqs, unsigned int state)
 	pr_debug("notification %u of frequency transition to %u kHz\n",
 		state, freqs->new);
 
-	spin_lock_irqsave(&cpufreq_data_lock, flags);
+	read_lock_irqsave(&cpufreq_data_lock, flags);
 	policy = per_cpu(cpufreq_cpu_data, freqs->cpu);
-	spin_unlock_irqrestore(&cpufreq_data_lock, flags);
+	read_unlock_irqrestore(&cpufreq_data_lock, flags);
 
 	switch (state) {
 
@@ -802,12 +802,12 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
 	}
 	rcu_read_unlock();
 
-	spin_lock_irqsave(&cpufreq_data_lock, flags);
+	write_lock_irqsave(&cpufreq_data_lock, flags);
 	for_each_cpu(j, policy->cpus) {
 		per_cpu(cpufreq_cpu_data, j) = policy;
 		per_cpu(cpufreq_policy_cpu, j) = policy->cpu;
 	}
-	spin_unlock_irqrestore(&cpufreq_data_lock, flags);
+	write_unlock_irqrestore(&cpufreq_data_lock, flags);
 
 	ret = cpufreq_add_dev_symlink(cpu, policy);
 	if (ret)
@@ -858,12 +858,12 @@ static int cpufreq_add_policy_cpu(unsigned int cpu, unsigned int sibling,
 
 	lock_policy_rwsem_write(sibling);
 
-	spin_lock_irqsave(&cpufreq_data_lock, flags);
+	write_lock_irqsave(&cpufreq_data_lock, flags);
 
 	cpumask_set_cpu(cpu, policy->cpus);
 	per_cpu(cpufreq_policy_cpu, cpu) = policy->cpu;
 	per_cpu(cpufreq_cpu_data, cpu) = policy;
-	spin_unlock_irqrestore(&cpufreq_data_lock, flags);
+	write_unlock_irqrestore(&cpufreq_data_lock, flags);
 
 	unlock_policy_rwsem_write(sibling);
 
@@ -918,15 +918,15 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 
 #ifdef CONFIG_HOTPLUG_CPU
 	/* Check if this cpu was hot-unplugged earlier and has siblings */
-	spin_lock_irqsave(&cpufreq_data_lock, flags);
+	read_lock_irqsave(&cpufreq_data_lock, flags);
 	for_each_online_cpu(sibling) {
 		struct cpufreq_policy *cp = per_cpu(cpufreq_cpu_data, sibling);
 		if (cp && cpumask_test_cpu(cpu, cp->related_cpus)) {
-			spin_unlock_irqrestore(&cpufreq_data_lock, flags);
+			read_unlock_irqrestore(&cpufreq_data_lock, flags);
 			return cpufreq_add_policy_cpu(cpu, sibling, dev);
 		}
 	}
-	spin_unlock_irqrestore(&cpufreq_data_lock, flags);
+	read_unlock_irqrestore(&cpufreq_data_lock, flags);
 #endif
 #endif
 
@@ -1006,10 +1006,10 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 	return 0;
 
 err_out_unregister:
-	spin_lock_irqsave(&cpufreq_data_lock, flags);
+	write_lock_irqsave(&cpufreq_data_lock, flags);
 	for_each_cpu(j, policy->cpus)
 		per_cpu(cpufreq_cpu_data, j) = NULL;
-	spin_unlock_irqrestore(&cpufreq_data_lock, flags);
+	write_unlock_irqrestore(&cpufreq_data_lock, flags);
 
 	kobject_put(&policy->kobj);
 	wait_for_completion(&policy->kobj_unregister);
@@ -1067,12 +1067,12 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 
 	pr_debug("%s: unregistering CPU %u\n", __func__, cpu);
 
-	spin_lock_irqsave(&cpufreq_data_lock, flags);
+	write_lock_irqsave(&cpufreq_data_lock, flags);
 
 	data = per_cpu(cpufreq_cpu_data, cpu);
 	per_cpu(cpufreq_cpu_data, cpu) = NULL;
 
-	spin_unlock_irqrestore(&cpufreq_data_lock, flags);
+	write_unlock_irqrestore(&cpufreq_data_lock, flags);
 
 	if (!data) {
 		pr_debug("%s: No cpu_data found\n", __func__);
@@ -1111,9 +1111,9 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 			WARN_ON(lock_policy_rwsem_write(cpu));
 			cpumask_set_cpu(cpu, data->cpus);
 
-			spin_lock_irqsave(&cpufreq_data_lock, flags);
+			write_lock_irqsave(&cpufreq_data_lock, flags);
 			per_cpu(cpufreq_cpu_data, cpu) = data;
-			spin_unlock_irqrestore(&cpufreq_data_lock, flags);
+			write_unlock_irqrestore(&cpufreq_data_lock, flags);
 
 			unlock_policy_rwsem_write(cpu);
 
-- 
1.8.1.2

