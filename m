Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758423AbaGYBIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 21:08:47 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34427 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbaGYBHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 21:07:44 -0400
From: Saravana Kannan <skannan@codeaurora.org>
To: "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Todd Poynor <toddpoynor@google.com>,
        "Srivatsa S . Bhat" <srivatsa@mit.edu>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Saravana Kannan" <skannan@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH v4 4/5] cpufreq: Properly handle physical CPU hot-add/hot-remove
Date: Thu, 24 Jul 2014 18:07:27 -0700
Message-Id: <1406250448-470-5-git-send-email-skannan@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1406250448-470-1-git-send-email-skannan@codeaurora.org>
References: <1406250448-470-1-git-send-email-skannan@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CPUs are physically added/removed, its cpuX sysfs directory is
dynamically added/removed. To handle this correctly, the cpufreq sysfs
nodes also need to be added/removed dynamically.

Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
---
 drivers/cpufreq/cpufreq.c | 46 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 33 insertions(+), 13 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index d9fc6e5..97edf05 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -41,6 +41,7 @@ static DEFINE_PER_CPU(struct cpufreq_policy *, cpufreq_cpu_data_fallback);
 static DEFINE_RWLOCK(cpufreq_driver_lock);
 DEFINE_MUTEX(cpufreq_governor_lock);
 static LIST_HEAD(cpufreq_policy_list);
+static cpumask_t has_symlink;
 
 /* This one keeps track of the previously set governor of a removed CPU */
 static DEFINE_PER_CPU(char[CPUFREQ_NAME_LEN], cpufreq_cpu_governor);
@@ -865,7 +866,10 @@ static int cpufreq_add_dev_symlink(struct cpufreq_policy *policy)
 	unsigned int j;
 	int ret = 0;
 
-	for_each_cpu(j, policy->related_cpus) {
+	/* Only some of the related CPUs might be present. So, create
+	 * symlinks only for those.
+	 */
+	for_each_cpu_and(j, policy->related_cpus, cpu_present_mask) {
 		struct device *cpu_dev;
 
 		if (j == policy->kobj_cpu)
@@ -877,6 +881,7 @@ static int cpufreq_add_dev_symlink(struct cpufreq_policy *policy)
 					"cpufreq");
 		if (ret)
 			break;
+		cpumask_set_cpu(j, &has_symlink);
 	}
 	return ret;
 }
@@ -1101,9 +1106,6 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 	unsigned long flags;
 	bool recover_policy = cpufreq_suspended;
 
-	if (cpu_is_offline(cpu))
-		return 0;
-
 	pr_debug("adding CPU %u\n", cpu);
 
 #ifdef CONFIG_SMP
@@ -1111,7 +1113,19 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 	 * CPU because it is in the same boat. */
 	policy = cpufreq_cpu_get(cpu);
 	if (policy) {
-		if (!cpumask_test_cpu(cpu, policy->cpus))
+		/* If a CPU gets physically plugged in after one or more of
+		 * its related CPUs are ONLINE, we need to create a symlink
+		 * for it since it wouldn't have been created when the policy
+		 * was initialized. Do this as soon as it's plugged in.
+		 */
+		if (sif && !cpumask_test_cpu(cpu, &has_symlink)) {
+			ret = sysfs_create_link(&dev->kobj, &policy->kobj,
+						"cpufreq");
+			if (!ret)
+				cpumask_set_cpu(cpu, &has_symlink);
+		}
+
+		if (!cpumask_test_cpu(cpu, policy->cpus) && cpu_online(cpu))
 			ret = cpufreq_add_policy_cpu(policy, cpu, dev);
 		else
 			ret = 0;
@@ -1120,6 +1134,9 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 	}
 #endif
 
+	if (cpu_is_offline(cpu))
+		return 0;
+
 	if (!down_read_trylock(&cpufreq_rwsem))
 		return 0;
 
@@ -1303,25 +1320,24 @@ static int cpufreq_nominate_new_policy_cpu(struct cpufreq_policy *policy,
 					   unsigned int old_cpu)
 {
 	struct device *cpu_dev;
+	unsigned int new_cpu;
 	int ret;
 
 	/* first sibling now owns the new sysfs dir */
-	cpu_dev = get_cpu_device(cpumask_any_but(policy->cpus, old_cpu));
+	for_each_cpu_and(new_cpu, policy->related_cpus, cpu_present_mask)
+		if (new_cpu != old_cpu)
+			break;
+	cpu_dev = get_cpu_device(new_cpu);
 
 	sysfs_remove_link(&cpu_dev->kobj, "cpufreq");
 	ret = kobject_move(&policy->kobj, &cpu_dev->kobj);
 	if (ret) {
 		pr_err("%s: Failed to move kobj: %d\n", __func__, ret);
-
-		down_write(&policy->rwsem);
-		cpumask_set_cpu(old_cpu, policy->cpus);
-		up_write(&policy->rwsem);
-
 		ret = sysfs_create_link(&cpu_dev->kobj, &policy->kobj,
 					"cpufreq");
-
 		return -EINVAL;
 	}
+	cpumask_clear_cpu(new_cpu, &has_symlink);
 	policy->kobj_cpu = cpu_dev->id;
 
 	return cpu_dev->id;
@@ -1407,8 +1423,12 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
 	cpus = cpumask_weight(policy->cpus);
 	up_read(&policy->rwsem);
 
-	if (cpu != policy->kobj_cpu)
+	if (cpu != policy->kobj_cpu) {
 		sysfs_remove_link(&dev->kobj, "cpufreq");
+		cpumask_clear_cpu(cpu, &has_symlink);
+	} else {
+		cpufreq_nominate_new_policy_cpu(policy, cpu);
+	}
 
 	/* If cpu is last user of policy, free policy */
 	if (cpus == 0) {
-- 
1.8.2.1

The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
