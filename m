Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab3ILLgw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 07:36:52 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:38154 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab3ILLgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 07:36:50 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2] cpufreq: use correct values of cpus in __cpufreq_remove_dev_finish()
Date: Thu, 12 Sep 2013 17:06:33 +0530
Message-Id: <01cdf0d2a0523bd0c2bc73d63055df0bf477b5fb.1378984168.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This broke after a recent change "cedb70a cpufreq: Split __cpufreq_remove_dev()
into two parts" from Srivatsa..

Consider a scenario where we have two CPUs in a policy (0 & 1) and we are
removing cpu 1. On the call to __cpufreq_remove_dev_prepare() we have cleared 1
from policy->cpus and now on a call to __cpufreq_remove_dev_finish() we read
cpumask_weight of policy->cpus, which will come as 1 and this code will behave
as if we are removing the last cpu from policy :)

Fix it by clearing cpu mask in __cpufreq_remove_dev_finish() instead of
__cpufreq_remove_dev_prepare().

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
V1->V2:
- sent separately without cleanup patches
- use cpumask_any_but() instead of cpumask_first()

 drivers/cpufreq/cpufreq.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 43c24aa..dbfe219 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1125,7 +1125,7 @@ static int cpufreq_nominate_new_policy_cpu(struct cpufreq_policy *policy,
 	int ret;
 
 	/* first sibling now owns the new sysfs dir */
-	cpu_dev = get_cpu_device(cpumask_first(policy->cpus));
+	cpu_dev = get_cpu_device(cpumask_any_but(policy->cpus, old_cpu));
 
 	/* Don't touch sysfs files during light-weight tear-down */
 	if (frozen)
@@ -1189,12 +1189,9 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
 			policy->governor->name, CPUFREQ_NAME_LEN);
 #endif
 
-	WARN_ON(lock_policy_rwsem_write(cpu));
+	lock_policy_rwsem_read(cpu);
 	cpus = cpumask_weight(policy->cpus);
-
-	if (cpus > 1)
-		cpumask_clear_cpu(cpu, policy->cpus);
-	unlock_policy_rwsem_write(cpu);
+	unlock_policy_rwsem_read(cpu);
 
 	if (cpu != policy->cpu) {
 		if (!frozen)
@@ -1237,9 +1234,12 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
 		return -EINVAL;
 	}
 
-	lock_policy_rwsem_read(cpu);
+	WARN_ON(lock_policy_rwsem_write(cpu));
 	cpus = cpumask_weight(policy->cpus);
-	unlock_policy_rwsem_read(cpu);
+
+	if (cpus > 1)
+		cpumask_clear_cpu(cpu, policy->cpus);
+	unlock_policy_rwsem_write(cpu);
 
 	/* If cpu is last user of policy, free policy */
 	if (cpus == 1) {
-- 
1.7.12.rc2.18.g61b472e

