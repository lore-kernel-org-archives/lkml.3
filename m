Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757840AbaGYBIb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 21:08:31 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34448 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbaGYBHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 21:07:45 -0400
From: Saravana Kannan <skannan@codeaurora.org>
To: "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Todd Poynor <toddpoynor@google.com>,
        "Srivatsa S . Bhat" <srivatsa@mit.edu>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Saravana Kannan" <skannan@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH v4 5/5] cpufreq: Delete dead code related to policy save/restore
Date: Thu, 24 Jul 2014 18:07:28 -0700
Message-Id: <1406250448-470-6-git-send-email-skannan@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1406250448-470-1-git-send-email-skannan@codeaurora.org>
References: <1406250448-470-1-git-send-email-skannan@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we no longer destroy/realloc policy during logical hotplug, most of
the policy save/restore code is dead code that doesn't get executed. Remove
those.

Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
---
 drivers/cpufreq/cpufreq.c | 82 +++++++++--------------------------------------
 1 file changed, 15 insertions(+), 67 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 97edf05..b635e0e 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -37,7 +37,6 @@
  */
 static struct cpufreq_driver *cpufreq_driver;
 static DEFINE_PER_CPU(struct cpufreq_policy *, cpufreq_cpu_data);
-static DEFINE_PER_CPU(struct cpufreq_policy *, cpufreq_cpu_data_fallback);
 static DEFINE_RWLOCK(cpufreq_driver_lock);
 DEFINE_MUTEX(cpufreq_governor_lock);
 static LIST_HEAD(cpufreq_policy_list);
@@ -1006,22 +1005,6 @@ static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy,
 }
 #endif
 
-static struct cpufreq_policy *cpufreq_policy_restore(unsigned int cpu)
-{
-	struct cpufreq_policy *policy;
-	unsigned long flags;
-
-	read_lock_irqsave(&cpufreq_driver_lock, flags);
-
-	policy = per_cpu(cpufreq_cpu_data_fallback, cpu);
-
-	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
-
-	policy->governor = NULL;
-
-	return policy;
-}
-
 static struct cpufreq_policy *cpufreq_policy_alloc(void)
 {
 	struct cpufreq_policy *policy;
@@ -1104,7 +1087,6 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 	int ret = -ENOMEM;
 	struct cpufreq_policy *policy;
 	unsigned long flags;
-	bool recover_policy = cpufreq_suspended;
 
 	pr_debug("adding CPU %u\n", cpu);
 
@@ -1142,31 +1124,11 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 
 	/* If we get this far, this is the first time we are adding the
 	 * policy */
-	recover_policy = false;
-
-	/*
-	 * Restore the saved policy when doing light-weight init and fall back
-	 * to the full init if that fails.
-	 */
-	policy = recover_policy ? cpufreq_policy_restore(cpu) : NULL;
-	if (!policy) {
-		recover_policy = false;
-		policy = cpufreq_policy_alloc();
-		if (!policy)
-			goto nomem_out;
-	}
-
-	/*
-	 * In the resume path, since we restore a saved policy, the assignment
-	 * to policy->cpu is like an update of the existing policy, rather than
-	 * the creation of a brand new one. So we need to perform this update
-	 * by invoking update_policy_cpu().
-	 */
-	if (recover_policy && cpu != policy->cpu)
-		update_policy_cpu(policy, cpu);
-	else
-		policy->cpu = cpu;
+	policy = cpufreq_policy_alloc();
+	if (!policy)
+		goto nomem_out;
 
+	policy->cpu = cpu;
 	cpumask_copy(policy->cpus, cpumask_of(cpu));
 
 	init_completion(&policy->kobj_unregister);
@@ -1190,10 +1152,8 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 	 */
 	cpumask_and(policy->cpus, policy->cpus, cpu_online_mask);
 
-	if (!recover_policy) {
-		policy->user_policy.min = policy->min;
-		policy->user_policy.max = policy->max;
-	}
+	policy->user_policy.min = policy->min;
+	policy->user_policy.max = policy->max;
 
 	down_write(&policy->rwsem);
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
@@ -1252,13 +1212,11 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 	blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
 				     CPUFREQ_START, policy);
 
-	if (!recover_policy) {
-		ret = cpufreq_add_dev_interface(policy, dev);
-		if (ret)
-			goto err_out_unregister;
-		blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
-				CPUFREQ_CREATE_POLICY, policy);
-	}
+	ret = cpufreq_add_dev_interface(policy, dev);
+	if (ret)
+		goto err_out_unregister;
+	blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
+			CPUFREQ_CREATE_POLICY, policy);
 
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
 	list_add(&policy->policy_list, &cpufreq_policy_list);
@@ -1266,10 +1224,8 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 
 	cpufreq_init_policy(policy);
 
-	if (!recover_policy) {
-		policy->user_policy.policy = policy->policy;
-		policy->user_policy.governor = policy->governor;
-	}
+	policy->user_policy.policy = policy->policy;
+	policy->user_policy.governor = policy->governor;
 	up_write(&policy->rwsem);
 
 	kobject_uevent(&policy->kobj, KOBJ_ADD);
@@ -1289,13 +1245,7 @@ err_get_freq:
 	if (cpufreq_driver->exit)
 		cpufreq_driver->exit(policy);
 err_set_policy_cpu:
-	if (recover_policy) {
-		/* Do not leave stale fallback data behind. */
-		per_cpu(cpufreq_cpu_data_fallback, cpu) = NULL;
-		cpufreq_policy_put_kobj(policy);
-	}
 	cpufreq_policy_free(policy);
-
 nomem_out:
 	up_read(&cpufreq_rwsem);
 
@@ -1442,8 +1392,7 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
 			}
 		}
 
-		if (!cpufreq_suspended)
-			cpufreq_policy_put_kobj(policy);
+		cpufreq_policy_put_kobj(policy);
 
 		/*
 		 * Perform the ->exit() even during light-weight tear-down,
@@ -1458,8 +1407,7 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
 		list_del(&policy->policy_list);
 		write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
-		if (!cpufreq_suspended)
-			cpufreq_policy_free(policy);
+		cpufreq_policy_free(policy);
 	}
 
 	per_cpu(cpufreq_cpu_data, cpu) = NULL;
-- 
1.8.2.1

The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
