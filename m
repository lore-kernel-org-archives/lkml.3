Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbaCDDoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 22:44:21 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:57848 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046AbaCDDoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 22:44:18 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net, skannan@codeaurora.org
Cc: linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 1/3] cpufreq: move call to __find_governor() to cpufreq_init_policy()
Date: Tue,  4 Mar 2014 11:43:59 +0800
Message-Id: <98b7ae22d936456bf830aa749556a115969cfa47.1393904428.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We call __find_governor() during addition of first CPU of every policy from
__cpufreq_add_dev() to find the last governor used for this CPU before it was
hotplugged-out.

After that we call cpufreq_parse_governor() in cpufreq_init_policy() either with
this governor or default governor. And right after that policy->governor is set
to NULL.

There is no functional problem here with this code, but it is just that some of
the code required in cpufreq_init_policy() is being called by its caller, i.e.
__cpufreq_add_dev(). So, it would make more sense to get all these together at a
single place to make code more readable.

So, instead of doing this move the relevant parts to cpufreq_init_policy()
policy only and initialize policy->governor to NULL at the beginning.

In order to clean the code a bit more, some of the #ifdefs for
CONFIG_HOTPLUG_CPU are also removed which used to maintain the last governor
used for any CPU. Keeping that code wouldn't harm us much but would improve the
cleanliness of code.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
V1->V2:
- Improved commit logs
- Removed unrelated whitespace changes
- Removed some #ifdef CONFIG_HOTPLUG_CPU to clean code a bit.

 drivers/cpufreq/cpufreq.c | 38 ++++++++++++++------------------------
 1 file changed, 14 insertions(+), 24 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 56b7b1b..fff2968 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -42,10 +42,8 @@ static DEFINE_RWLOCK(cpufreq_driver_lock);
 DEFINE_MUTEX(cpufreq_governor_lock);
 static LIST_HEAD(cpufreq_policy_list);
 
-#ifdef CONFIG_HOTPLUG_CPU
 /* This one keeps track of the previously set governor of a removed CPU */
 static DEFINE_PER_CPU(char[CPUFREQ_NAME_LEN], cpufreq_cpu_governor);
-#endif
 
 static inline bool has_target(void)
 {
@@ -879,18 +877,25 @@ err_out_kobj_put:
 
 static void cpufreq_init_policy(struct cpufreq_policy *policy)
 {
+	struct cpufreq_governor *gov = NULL;
 	struct cpufreq_policy new_policy;
 	int ret = 0;
 
 	memcpy(&new_policy, policy, sizeof(*policy));
 
+	/* Update governor of new_policy to the governor used before hotplug */
+	gov = __find_governor(per_cpu(cpufreq_cpu_governor, policy->cpu));
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
@@ -949,6 +954,8 @@ static struct cpufreq_policy *cpufreq_policy_restore(unsigned int cpu)
 
 	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
+	policy->governor = NULL;
+
 	return policy;
 }
 
@@ -1036,7 +1043,6 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 	unsigned long flags;
 #ifdef CONFIG_HOTPLUG_CPU
 	struct cpufreq_policy *tpolicy;
-	struct cpufreq_governor *gov;
 #endif
 
 	if (cpu_is_offline(cpu))
@@ -1094,7 +1100,6 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 	else
 		policy->cpu = cpu;
 
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
 	cpumask_copy(policy->cpus, cpumask_of(cpu));
 
 	init_completion(&policy->kobj_unregister);
@@ -1179,15 +1184,6 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
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
@@ -1312,11 +1308,9 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
 		}
 	}
 
-#ifdef CONFIG_HOTPLUG_CPU
 	if (!cpufreq_driver->setpolicy)
 		strncpy(per_cpu(cpufreq_cpu_governor, cpu),
 			policy->governor->name, CPUFREQ_NAME_LEN);
-#endif
 
 	down_read(&policy->rwsem);
 	cpus = cpumask_weight(policy->cpus);
@@ -1955,9 +1949,7 @@ EXPORT_SYMBOL_GPL(cpufreq_register_governor);
 
 void cpufreq_unregister_governor(struct cpufreq_governor *governor)
 {
-#ifdef CONFIG_HOTPLUG_CPU
 	int cpu;
-#endif
 
 	if (!governor)
 		return;
@@ -1965,14 +1957,12 @@ void cpufreq_unregister_governor(struct cpufreq_governor *governor)
 	if (cpufreq_disabled())
 		return;
 
-#ifdef CONFIG_HOTPLUG_CPU
 	for_each_present_cpu(cpu) {
 		if (cpu_online(cpu))
 			continue;
 		if (!strcmp(per_cpu(cpufreq_cpu_governor, cpu), governor->name))
 			strcpy(per_cpu(cpufreq_cpu_governor, cpu), "\0");
 	}
-#endif
 
 	mutex_lock(&cpufreq_governor_mutex);
 	list_del(&governor->governor_list);
-- 
1.7.12.rc2.18.g61b472e

