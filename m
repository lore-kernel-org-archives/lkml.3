Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab3HTGki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 02:40:38 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:47393 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab3HTGkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 02:40:36 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 4/5] cpufreq: remove cpufreq_policy_cpu per-cpu variable
Date: Tue, 20 Aug 2013 12:08:25 +0530
Message-Id: <3c2f4624ca6f5688036c2fd59fceb1798fd8c0ee.1376979090.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1376979090.git.viresh.kumar@linaro.org>
References: <cover.1376979090.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1376979090.git.viresh.kumar@linaro.org>
References: <cover.1376979090.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpufreq_policy_cpu per-cpu variables are used for storing cpu that manages a cpu
or its policy->cpu. We are also storing policy for each cpu in cpufreq_cpu_data
and so this information is just redundant.

Better use cpufreq_cpu_data to retrieve policy and get policy->cpu from there.
And so this patch removes cpufreq_policy_cpu per-cpu variable.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 45 ++++++++++-----------------------------------
 1 file changed, 10 insertions(+), 35 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index b03a851..0586bd2 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -64,15 +64,14 @@ static DEFINE_PER_CPU(char[CPUFREQ_NAME_LEN], cpufreq_cpu_governor);
  * - Lock should not be held across
  *     __cpufreq_governor(data, CPUFREQ_GOV_STOP);
  */
-static DEFINE_PER_CPU(int, cpufreq_policy_cpu);
 static DEFINE_PER_CPU(struct rw_semaphore, cpu_policy_rwsem);
 
 #define lock_policy_rwsem(mode, cpu)					\
 static int lock_policy_rwsem_##mode(int cpu)				\
 {									\
-	int policy_cpu = per_cpu(cpufreq_policy_cpu, cpu);		\
-	BUG_ON(policy_cpu == -1);					\
-	down_##mode(&per_cpu(cpu_policy_rwsem, policy_cpu));		\
+	struct cpufreq_policy *policy = per_cpu(cpufreq_cpu_data, cpu);	\
+	BUG_ON(!policy);						\
+	down_##mode(&per_cpu(cpu_policy_rwsem, policy->cpu));		\
 									\
 	return 0;							\
 }
@@ -83,9 +82,9 @@ lock_policy_rwsem(write, cpu);
 #define unlock_policy_rwsem(mode, cpu)					\
 static void unlock_policy_rwsem_##mode(int cpu)				\
 {									\
-	int policy_cpu = per_cpu(cpufreq_policy_cpu, cpu);		\
-	BUG_ON(policy_cpu == -1);					\
-	up_##mode(&per_cpu(cpu_policy_rwsem, policy_cpu));		\
+	struct cpufreq_policy *policy = per_cpu(cpufreq_cpu_data, cpu);	\
+	BUG_ON(!policy);						\
+	up_##mode(&per_cpu(cpu_policy_rwsem, policy->cpu));		\
 }
 
 unlock_policy_rwsem(read, cpu);
@@ -887,7 +886,6 @@ static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy,
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
 
 	cpumask_set_cpu(cpu, policy->cpus);
-	per_cpu(cpufreq_policy_cpu, cpu) = policy->cpu;
 	per_cpu(cpufreq_cpu_data, cpu) = policy;
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
@@ -1013,9 +1011,6 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
 	cpumask_copy(policy->cpus, cpumask_of(cpu));
 
-	/* Initially set CPU itself as the policy_cpu */
-	per_cpu(cpufreq_policy_cpu, cpu) = cpu;
-
 	init_completion(&policy->kobj_unregister);
 	INIT_WORK(&policy->update, handle_update);
 
@@ -1053,10 +1048,8 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 #endif
 
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
-	for_each_cpu(j, policy->cpus) {
+	for_each_cpu(j, policy->cpus)
 		per_cpu(cpufreq_cpu_data, j) = policy;
-		per_cpu(cpufreq_policy_cpu, j) = policy->cpu;
-	}
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	if (!frozen) {
@@ -1080,15 +1073,11 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 
 err_out_unregister:
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
-	for_each_cpu(j, policy->cpus) {
+	for_each_cpu(j, policy->cpus)
 		per_cpu(cpufreq_cpu_data, j) = NULL;
-		if (j != cpu)
-			per_cpu(cpufreq_policy_cpu, j) = -1;
-	}
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 err_set_policy_cpu:
-	per_cpu(cpufreq_policy_cpu, cpu) = -1;
 	cpufreq_policy_free(policy);
 nomem_out:
 	up_read(&cpufreq_rwsem);
@@ -1112,14 +1101,9 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 
 static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
 {
-	int j;
-
 	policy->last_cpu = policy->cpu;
 	policy->cpu = cpu;
 
-	for_each_cpu(j, policy->cpus)
-		per_cpu(cpufreq_policy_cpu, j) = cpu;
-
 #ifdef CONFIG_CPU_FREQ_TABLE
 	cpufreq_frequency_table_update_policy_cpu(policy);
 #endif
@@ -1131,7 +1115,6 @@ static int cpufreq_nominate_new_policy_cpu(struct cpufreq_policy *policy,
 					   unsigned int old_cpu, bool frozen)
 {
 	struct device *cpu_dev;
-	unsigned long flags;
 	int ret;
 
 	/* first sibling now owns the new sysfs dir */
@@ -1148,11 +1131,6 @@ static int cpufreq_nominate_new_policy_cpu(struct cpufreq_policy *policy,
 
 		WARN_ON(lock_policy_rwsem_write(old_cpu));
 		cpumask_set_cpu(old_cpu, policy->cpus);
-
-		write_lock_irqsave(&cpufreq_driver_lock, flags);
-		per_cpu(cpufreq_cpu_data, old_cpu) = policy;
-		write_unlock_irqrestore(&cpufreq_driver_lock, flags);
-
 		unlock_policy_rwsem_write(old_cpu);
 
 		ret = sysfs_create_link(&cpu_dev->kobj, &policy->kobj,
@@ -1186,7 +1164,6 @@ static int __cpufreq_remove_dev(struct device *dev,
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
 
 	policy = per_cpu(cpufreq_cpu_data, cpu);
-	per_cpu(cpufreq_cpu_data, cpu) = NULL;
 
 	/* Save the policy somewhere when doing a light-weight tear-down */
 	if (frozen)
@@ -1292,7 +1269,7 @@ static int __cpufreq_remove_dev(struct device *dev,
 		}
 	}
 
-	per_cpu(cpufreq_policy_cpu, cpu) = -1;
+	per_cpu(cpufreq_cpu_data, cpu) = NULL;
 	return 0;
 }
 
@@ -2148,10 +2125,8 @@ static int __init cpufreq_core_init(void)
 	if (cpufreq_disabled())
 		return -ENODEV;
 
-	for_each_possible_cpu(cpu) {
-		per_cpu(cpufreq_policy_cpu, cpu) = -1;
+	for_each_possible_cpu(cpu)
 		init_rwsem(&per_cpu(cpu_policy_rwsem, cpu));
-	}
 
 	cpufreq_global_kobject = kobject_create();
 	BUG_ON(!cpufreq_global_kobject);
-- 
1.7.12.rc2.18.g61b472e

