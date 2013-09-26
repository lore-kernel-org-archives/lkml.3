Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab3IZKbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 06:31:23 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:50676 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564Ab3IZKbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 06:31:20 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        nicolas.pitre@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/4] cpufreq: stats: handle cpufreq_unregister_driver() and suspend/resume properly
Date: Thu, 26 Sep 2013 15:59:51 +0530
Message-Id: <4e5eacadb26c3a17f8f04fe344bd3cd6ea5a8a48.1380190886.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1380190886.git.viresh.kumar@linaro.org>
References: <cover.1380190886.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1380190886.git.viresh.kumar@linaro.org>
References: <cover.1380190886.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are several problems cpufreq stats in the way it handles
cpufreq_unregister_driver() and suspend/resume..

- We must not loose data collected so far when suspend/resume happens and so
  stats directories must not be removed/allocated during these operations, Which
  is done currently.

- cpufreq_stat has registered notifiers with both cpufreq and hotplug. It adds
  sysfs stats directory with a cpufreq notifier: CPUFREQ_NOTIFY and removes this
  directory with a notifier from hotplug core.

  In case cpufreq_unregister_driver() is called (on rmmod cpufreq driver), stats
  directories per cpu aren't removed as CPUs are still online. The only call
  cpufreq_stats gets is cpufreq_stats_update_policy_cpu for all CPUs except the
  last of each policy. And pointer to stat information is stored in the entry
  for last cpu in per-cpu cpufreq_stats_table. But policy structure would be
  freed inside cpufreq core and so that will result in memory leak inside
  cpufreq stats (as we are never freeing memory for stats).

  Now if we again insert the module cpufreq_register_driver() will be called and
  we will again allocate stats data and put it on for first cpu of every policy.
  In case we only have a single cpu per policy we will return with a error from
  cpufreq_stats_create_table() due to below code:

	if (per_cpu(cpufreq_stats_table, cpu))
		return -EBUSY;

  And so probably cpufreq stats directory would show up anymore (as it was added
  inside last policies->kobj which doesn't exist anymore). I haven't tested it
  though. Also the values in stats files wouldn't be refreshed as we are using
  the earlier stats structure.

- CPUFREQ_NOTIFY is called from cpufreq_set_policy() which is called for
  scenarios where we don't really want cpufreq_stat_notifier_policy() to get
  called. For example whenever we are changing anything related to a policy:
  min/max/current freq, etc.. cpufreq_set_policy() is called and so cpufreq
  stats is notified. Where we don't do any useful stuff other than simply
  returning with -EBUSY from cpufreq_stats_create_table(). And so this isn't the
  right notifier that cpufreq stats..

Due to all above reasons this patch does following changes:
- Add new notifiers CPUFREQ_CREATE_POLICY and CPUFREQ_REMOVE_POLICY, which are
  only called when policy is created/destroyed. They aren't called for
  suspend/resume paths..
- Use these notifiers in cpufreq_stat_notifier_policy() to create/destory stats
  sysfs entries. And so cpufreq_unregister_driver() or suspend/resume shouldn't
  be a problem for cpufreq_stats.
- Return early from cpufreq_stat_cpu_callback() for suspend/resume sequence, so
  that we don't free stats structure.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c       |  5 +++++
 drivers/cpufreq/cpufreq_stats.c | 24 +++++++++++++++++-------
 include/linux/cpufreq.h         |  2 ++
 3 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 89b3c52..ab56531 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1086,6 +1086,8 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 		ret = cpufreq_add_dev_interface(policy, dev);
 		if (ret)
 			goto err_out_unregister;
+		blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
+				CPUFREQ_CREATE_POLICY, policy);
 	}
 
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
@@ -1263,6 +1265,9 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
 		}
 
 		if (!frozen) {
+			blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
+					CPUFREQ_REMOVE_POLICY, policy);
+
 			lock_policy_rwsem_read(cpu);
 			kobj = &policy->kobj;
 			cmp = &policy->kobj_unregister;
diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index 4cf0d28..0f71562 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -277,7 +277,7 @@ static void cpufreq_stats_update_policy_cpu(struct cpufreq_policy *policy)
 static int cpufreq_stat_notifier_policy(struct notifier_block *nb,
 		unsigned long val, void *data)
 {
-	int ret;
+	int ret = 0;
 	struct cpufreq_policy *policy = data;
 	struct cpufreq_frequency_table *table;
 	unsigned int cpu = policy->cpu;
@@ -287,15 +287,21 @@ static int cpufreq_stat_notifier_policy(struct notifier_block *nb,
 		return 0;
 	}
 
-	if (val != CPUFREQ_NOTIFY)
-		return 0;
 	table = cpufreq_frequency_get_table(cpu);
 	if (!table)
 		return 0;
-	ret = cpufreq_stats_create_table(policy, table);
-	if (ret)
-		return ret;
-	return 0;
+
+	if (val == CPUFREQ_CREATE_POLICY)
+		ret = cpufreq_stats_create_table(policy, table);
+	else if (val == CPUFREQ_REMOVE_POLICY) {
+		/* This might already be freed by cpu hotplug notifier */
+		if (per_cpu(cpufreq_stats_table, cpu)) {
+			cpufreq_stats_free_sysfs(cpu);
+			cpufreq_stats_free_table(cpu);
+		}
+	}
+
+	return ret;
 }
 
 static int cpufreq_stat_notifier_trans(struct notifier_block *nb,
@@ -340,6 +346,10 @@ static int cpufreq_stat_cpu_callback(struct notifier_block *nfb,
 {
 	unsigned int cpu = (unsigned long)hcpu;
 
+	/* Don't free/allocate stats during suspend/resume */
+	if (action & CPU_TASKS_FROZEN)
+		return 0;
+
 	switch (action) {
 	case CPU_DOWN_PREPARE:
 		cpufreq_stats_free_sysfs(cpu);
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index fcabc42..9132fa3 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -259,6 +259,8 @@ static inline void cpufreq_verify_within_limits(struct cpufreq_policy *policy,
 #define CPUFREQ_NOTIFY			(2)
 #define CPUFREQ_START			(3)
 #define CPUFREQ_UPDATE_POLICY_CPU	(4)
+#define CPUFREQ_CREATE_POLICY		(5)
+#define CPUFREQ_REMOVE_POLICY		(6)
 
 #ifdef CONFIG_CPU_FREQ
 int cpufreq_register_notifier(struct notifier_block *nb, unsigned int list);
-- 
1.7.12.rc2.18.g61b472e

