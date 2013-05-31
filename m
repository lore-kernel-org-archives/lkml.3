Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565Ab3EaGPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 02:15:47 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:50551 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab3EaGPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 02:15:39 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] cpufreq: remove unnecessary cpufreq_cpu_{get|put}() calls
Date: Fri, 31 May 2013 11:45:08 +0530
Message-Id: <40258fb25d164a4923251d20b6d6604f190a5a32.1369980833.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct cpufreq_policy is already passed as argument to some routines like:
__cpufreq_driver_getavg() and so we don't really need to do cpufreq_cpu_get()
before and cpufreq_cpu_put() in them to get policy structure.

Remove them.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index ce9273a7..f8c2860 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1572,10 +1572,6 @@ int cpufreq_driver_target(struct cpufreq_policy *policy,
 {
 	int ret = -EINVAL;
 
-	policy = cpufreq_cpu_get(policy->cpu);
-	if (!policy)
-		goto no_policy;
-
 	if (unlikely(lock_policy_rwsem_write(policy->cpu)))
 		goto fail;
 
@@ -1584,30 +1580,19 @@ int cpufreq_driver_target(struct cpufreq_policy *policy,
 	unlock_policy_rwsem_write(policy->cpu);
 
 fail:
-	cpufreq_cpu_put(policy);
-no_policy:
 	return ret;
 }
 EXPORT_SYMBOL_GPL(cpufreq_driver_target);
 
 int __cpufreq_driver_getavg(struct cpufreq_policy *policy, unsigned int cpu)
 {
-	int ret = 0;
-
 	if (cpufreq_disabled())
-		return ret;
+		return 0;
 
 	if (!cpufreq_driver->getavg)
 		return 0;
 
-	policy = cpufreq_cpu_get(policy->cpu);
-	if (!policy)
-		return -EINVAL;
-
-	ret = cpufreq_driver->getavg(policy, cpu);
-
-	cpufreq_cpu_put(policy);
-	return ret;
+	return cpufreq_driver->getavg(policy, cpu);
 }
 EXPORT_SYMBOL_GPL(__cpufreq_driver_getavg);
 
-- 
1.7.12.rc2.18.g61b472e

