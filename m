Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab3BDLjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:39:19 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33615 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261Ab3BDLjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:39:15 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/4] cpufreq: Don't check cpu_online(policy->cpu)
Date: Mon,  4 Feb 2013 17:08:51 +0530
Message-Id: <ffce01244332df80c46fcfed744c066f3044e84f.1359976493.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1359976493.git.viresh.kumar@linaro.org>
References: <cover.1359976493.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1359976493.git.viresh.kumar@linaro.org>
References: <cover.1359976493.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

policy->cpu or cpus in policy->cpus can't be offline anymore. And so we don't
need to check if they are online or not.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c           | 17 +++--------------
 drivers/cpufreq/cpufreq_governor.c  |  2 +-
 drivers/cpufreq/cpufreq_userspace.c |  2 --
 drivers/cpufreq/freq_table.c        |  6 ------
 4 files changed, 4 insertions(+), 23 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 9656420..e619f4f 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -76,10 +76,6 @@ static int lock_policy_rwsem_##mode					\
 	int policy_cpu = per_cpu(cpufreq_policy_cpu, cpu);		\
 	BUG_ON(policy_cpu == -1);					\
 	down_##mode(&per_cpu(cpu_policy_rwsem, policy_cpu));		\
-	if (unlikely(!cpu_online(cpu))) {				\
-		up_##mode(&per_cpu(cpu_policy_rwsem, policy_cpu));	\
-		return -1;						\
-	}								\
 									\
 	return 0;							\
 }
@@ -719,8 +715,6 @@ static int cpufreq_add_dev_symlink(unsigned int cpu,
 
 		if (j == cpu)
 			continue;
-		if (!cpu_online(j))
-			continue;
 
 		pr_debug("CPU %u already managed, adding link\n", j);
 		managed_policy = cpufreq_cpu_get(cpu);
@@ -777,8 +771,6 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
 
 	spin_lock_irqsave(&cpufreq_driver_lock, flags);
 	for_each_cpu(j, policy->cpus) {
-		if (!cpu_online(j))
-			continue;
 		per_cpu(cpufreq_cpu_data, j) = policy;
 		per_cpu(cpufreq_policy_cpu, j) = policy->cpu;
 	}
@@ -1005,11 +997,8 @@ static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
 	policy->last_cpu = policy->cpu;
 	policy->cpu = cpu;
 
-	for_each_cpu(j, policy->cpus) {
-		if (!cpu_online(j))
-			continue;
+	for_each_cpu(j, policy->cpus)
 		per_cpu(cpufreq_policy_cpu, j) = cpu;
-	}
 
 #ifdef CONFIG_CPU_FREQ_TABLE
 	cpufreq_frequency_table_update_policy_cpu(policy);
@@ -1468,7 +1457,7 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
 	if (target_freq == policy->cur)
 		return 0;
 
-	if (cpu_online(policy->cpu) && cpufreq_driver->target)
+	if (cpufreq_driver->target)
 		retval = cpufreq_driver->target(policy, target_freq, relation);
 
 	return retval;
@@ -1506,7 +1495,7 @@ int __cpufreq_driver_getavg(struct cpufreq_policy *policy, unsigned int cpu)
 	if (cpufreq_disabled())
 		return ret;
 
-	if (!(cpu_online(cpu) && cpufreq_driver->getavg))
+	if (!cpufreq_driver->getavg)
 		return 0;
 
 	policy = cpufreq_cpu_get(policy->cpu);
diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index 79795c4..e4a306c 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -225,7 +225,7 @@ int cpufreq_governor_dbs(struct dbs_data *dbs_data,
 
 	switch (event) {
 	case CPUFREQ_GOV_START:
-		if ((!cpu_online(cpu)) || (!policy->cur))
+		if (!policy->cur)
 			return -EINVAL;
 
 		mutex_lock(&dbs_data->mutex);
diff --git a/drivers/cpufreq/cpufreq_userspace.c b/drivers/cpufreq/cpufreq_userspace.c
index c8c3d29..bbeb9c0 100644
--- a/drivers/cpufreq/cpufreq_userspace.c
+++ b/drivers/cpufreq/cpufreq_userspace.c
@@ -118,8 +118,6 @@ static int cpufreq_governor_userspace(struct cpufreq_policy *policy,
 
 	switch (event) {
 	case CPUFREQ_GOV_START:
-		if (!cpu_online(cpu))
-			return -EINVAL;
 		BUG_ON(!policy->cur);
 		mutex_lock(&userspace_mutex);
 
diff --git a/drivers/cpufreq/freq_table.c b/drivers/cpufreq/freq_table.c
index aa5bd39..d7a7966 100644
--- a/drivers/cpufreq/freq_table.c
+++ b/drivers/cpufreq/freq_table.c
@@ -63,9 +63,6 @@ int cpufreq_frequency_table_verify(struct cpufreq_policy *policy,
 	pr_debug("request for verification of policy (%u - %u kHz) for cpu %u\n",
 					policy->min, policy->max, policy->cpu);
 
-	if (!cpu_online(policy->cpu))
-		return -EINVAL;
-
 	cpufreq_verify_within_limits(policy, policy->cpuinfo.min_freq,
 				     policy->cpuinfo.max_freq);
 
@@ -121,9 +118,6 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
 		break;
 	}
 
-	if (!cpu_online(policy->cpu))
-		return -EINVAL;
-
 	for (i = 0; (table[i].frequency != CPUFREQ_TABLE_END); i++) {
 		unsigned int freq = table[i].frequency;
 		if (freq == CPUFREQ_ENTRY_INVALID)
-- 
1.7.12.rc2.18.g61b472e

