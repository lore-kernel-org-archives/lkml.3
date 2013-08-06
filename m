Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab3HFRYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 13:24:16 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:52374 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756458Ab3HFRYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 13:24:12 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 05/11] cpufreq: Pass policy to cpufreq_add_policy_cpu()
Date: Tue,  6 Aug 2013 22:53:07 +0530
Message-Id: <f70873b5140dcbe028c4ef9111e9a73d3568a893.1375809311.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1375809311.git.viresh.kumar@linaro.org>
References: <cover.1375809311.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1375809311.git.viresh.kumar@linaro.org>
References: <cover.1375809311.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Caller of cpufreq_add_policy_cpu() already has pointer to policy structure and
so there is no need to find it again in cpufreq_add_policy_cpu(). Lets pass it
directly.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 7864a90..9e83d91 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -890,21 +890,17 @@ static void cpufreq_init_policy(struct cpufreq_policy *policy)
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-static int cpufreq_add_policy_cpu(unsigned int cpu, unsigned int sibling,
-				  struct device *dev, bool frozen)
+static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy,
+				  unsigned int cpu, struct device *dev,
+				  bool frozen)
 {
-	struct cpufreq_policy *policy;
 	int ret = 0, has_target = !!cpufreq_driver->target;
 	unsigned long flags;
 
-	policy = cpufreq_cpu_get(sibling);
-	if (WARN_ON_ONCE(!policy))
-		return -ENODATA;
-
 	if (has_target)
 		__cpufreq_governor(policy, CPUFREQ_GOV_STOP);
 
-	lock_policy_rwsem_write(sibling);
+	lock_policy_rwsem_write(policy->cpu);
 
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
 
@@ -913,7 +909,7 @@ static int cpufreq_add_policy_cpu(unsigned int cpu, unsigned int sibling,
 	per_cpu(cpufreq_cpu_data, cpu) = policy;
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
-	unlock_policy_rwsem_write(sibling);
+	unlock_policy_rwsem_write(policy->cpu);
 
 	if (has_target) {
 		__cpufreq_governor(policy, CPUFREQ_GOV_START);
@@ -924,7 +920,6 @@ static int cpufreq_add_policy_cpu(unsigned int cpu, unsigned int sibling,
 	if (!frozen)
 		ret = sysfs_create_link(&dev->kobj, &policy->kobj, "cpufreq");
 
-	cpufreq_cpu_put(policy);
 	return ret;
 }
 #endif
@@ -1007,8 +1002,7 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 		struct cpufreq_policy *cp = per_cpu(cpufreq_cpu_data, sibling);
 		if (cp && cpumask_test_cpu(cpu, cp->related_cpus)) {
 			read_unlock_irqrestore(&cpufreq_driver_lock, flags);
-			return cpufreq_add_policy_cpu(cpu, sibling, dev,
-						      frozen);
+			return cpufreq_add_policy_cpu(cp, cpu, dev, frozen);
 		}
 	}
 	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
-- 
1.7.12.rc2.18.g61b472e

