Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731AbaBYIuX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 03:50:23 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:62838 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaBYIuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 03:50:21 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net, skannan@codeaurora.org
Cc: linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/3] cpufreq: move call to __find_governor() to cpufreq_init_policy()
Date: Tue, 25 Feb 2014 14:20:09 +0530
Message-Id: <9f9546137135103556c69815c72b81ed93cc1ca2.1393318100.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We call __find_governor() during addition of first CPU of every policy to find
the last governor used for this CPU before it was hotplugged-out.

After that we call cpufreq_parse_governor() in cpufreq_init_policy() either with
this governor or default governor. And right after that policy->governor is set
to NULL.

So, instead of doing this move the relevant parts to cpufreq_init_policy()
policy only and initialize policy->governor to NULL at the beginning.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---

Hi Saravana,

I hope only the first two patches would fix things for you but probably you can
test all three.

@Rafael: We might need to get these in next rc only as these are more or less
fixes.

 drivers/cpufreq/cpufreq.c | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index c755b5f..cc4f244 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -879,18 +879,27 @@ err_out_kobj_put:
 
 static void cpufreq_init_policy(struct cpufreq_policy *policy)
 {
+	struct cpufreq_governor *gov = NULL;
 	struct cpufreq_policy new_policy;
 	int ret = 0;
 
 	memcpy(&new_policy, policy, sizeof(*policy));
 
+	/* Update governor of new_policy to the governor used before hotplug */
+#ifdef CONFIG_HOTPLUG_CPU
+	gov = __find_governor(per_cpu(cpufreq_cpu_governor, policy->cpu));
+#endif
+	if (gov)
+		pr_debug("Restoring governor %s for cpu %d\n",
+				policy->governor->name, policy->cpu);
+	else
+		gov = CPUFREQ_DEFAULT_GOVERNOR;
+
+	new_policy.governor = gov;
+
 	/* Use the default policy if its valid. */
 	if (cpufreq_driver->setpolicy)
-		cpufreq_parse_governor(policy->governor->name,
-					&new_policy.policy, NULL);
-
-	/* assure that the starting sequence is run in cpufreq_set_policy */
-	policy->governor = NULL;
+		cpufreq_parse_governor(gov->name, &new_policy.policy, NULL);
 
 	/* set default policy */
 	ret = cpufreq_set_policy(policy, &new_policy);
@@ -944,11 +953,11 @@ static struct cpufreq_policy *cpufreq_policy_restore(unsigned int cpu)
 	unsigned long flags;
 
 	read_lock_irqsave(&cpufreq_driver_lock, flags);
-
 	policy = per_cpu(cpufreq_cpu_data_fallback, cpu);
-
 	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
+	policy->governor = NULL;
+
 	return policy;
 }
 
@@ -1036,7 +1045,6 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 	unsigned long flags;
 #ifdef CONFIG_HOTPLUG_CPU
 	struct cpufreq_policy *tpolicy;
-	struct cpufreq_governor *gov;
 #endif
 
 	if (cpu_is_offline(cpu))
@@ -1094,7 +1102,6 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 	else
 		policy->cpu = cpu;
 
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
 	cpumask_copy(policy->cpus, cpumask_of(cpu));
 
 	init_completion(&policy->kobj_unregister);
@@ -1179,15 +1186,6 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 	blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
 				     CPUFREQ_START, policy);
 
-#ifdef CONFIG_HOTPLUG_CPU
-	gov = __find_governor(per_cpu(cpufreq_cpu_governor, cpu));
-	if (gov) {
-		policy->governor = gov;
-		pr_debug("Restoring governor %s for cpu %d\n",
-		       policy->governor->name, cpu);
-	}
-#endif
-
 	if (!frozen) {
 		ret = cpufreq_add_dev_interface(policy, dev);
 		if (ret)
-- 
1.7.12.rc2.18.g61b472e

