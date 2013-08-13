Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab3HMHKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 03:10:35 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:37306 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753043Ab3HMHK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 03:10:28 -0400
From: Xiaoguang Chen <chenxg@marvell.com>
To: <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <viresh.kumar@linaro.org>, <rjw@sisk.pl>, <chenxg.marvell@gmail.com>,
        <chenxg@marvell.com>
Subject: [PATCH 2/2] cpufreq: Only do governor start after successful stop
Date: Tue, 13 Aug 2013 15:09:26 +0800
Message-ID: <1376377766-2594-2-git-send-email-chenxg@marvell.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1376377766-2594-1-git-send-email-chenxg@marvell.com>
References: <1376377766-2594-1-git-send-email-chenxg@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpufreq_add_policy_cpu, __cpufreq_remove_dev and __cpufreq_set_policy
have operations for governor stop and start.
Only do the start operation when the previous stop operation succeeds.

Signed-off-by: Xiaoguang Chen <chenxg@marvell.com>
---
 drivers/cpufreq/cpufreq.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index dfe0b86..2e0b17f 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -916,7 +916,7 @@ static int cpufreq_add_policy_cpu(unsigned int cpu, unsigned int sibling,
 	WARN_ON(!policy);
 
 	if (has_target)
-		__cpufreq_governor(policy, CPUFREQ_GOV_STOP);
+		ret = __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
 
 	lock_policy_rwsem_write(sibling);
 
@@ -930,7 +930,8 @@ static int cpufreq_add_policy_cpu(unsigned int cpu, unsigned int sibling,
 	unlock_policy_rwsem_write(sibling);
 
 	if (has_target) {
-		__cpufreq_governor(policy, CPUFREQ_GOV_START);
+		if (!ret)
+			__cpufreq_governor(policy, CPUFREQ_GOV_START);
 		__cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
 	}
 
@@ -1109,7 +1110,7 @@ static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
 static int __cpufreq_remove_dev(struct device *dev,
 		struct subsys_interface *sif)
 {
-	unsigned int cpu = dev->id, ret, cpus;
+	unsigned int cpu = dev->id, ret, opsret = 0, cpus;
 	unsigned long flags;
 	struct cpufreq_policy *data;
 	struct kobject *kobj;
@@ -1131,7 +1132,7 @@ static int __cpufreq_remove_dev(struct device *dev,
 	}
 
 	if (cpufreq_driver->target)
-		__cpufreq_governor(data, CPUFREQ_GOV_STOP);
+		opsret = __cpufreq_governor(data, CPUFREQ_GOV_STOP);
 
 #ifdef CONFIG_HOTPLUG_CPU
 	if (!cpufreq_driver->setpolicy)
@@ -1206,7 +1207,8 @@ static int __cpufreq_remove_dev(struct device *dev,
 		pr_debug("%s: removing link, cpu: %d\n", __func__, cpu);
 		cpufreq_cpu_put(data);
 		if (cpufreq_driver->target) {
-			__cpufreq_governor(data, CPUFREQ_GOV_START);
+			if (!opsret)
+				__cpufreq_governor(data, CPUFREQ_GOV_START);
 			__cpufreq_governor(data, CPUFREQ_GOV_LIMITS);
 		}
 	}
@@ -1784,7 +1786,7 @@ EXPORT_SYMBOL(cpufreq_get_policy);
 static int __cpufreq_set_policy(struct cpufreq_policy *data,
 				struct cpufreq_policy *policy)
 {
-	int ret = 0, failed = 1;
+	int ret = 0, failed = 1, opsret = 0;
 
 	pr_debug("setting new policy for CPU %u: %u - %u kHz\n", policy->cpu,
 		policy->min, policy->max);
@@ -1841,7 +1843,8 @@ static int __cpufreq_set_policy(struct cpufreq_policy *data,
 
 			/* end old governor */
 			if (data->governor) {
-				__cpufreq_governor(data, CPUFREQ_GOV_STOP);
+				opsret = __cpufreq_governor(data,
+							    CPUFREQ_GOV_STOP);
 				unlock_policy_rwsem_write(policy->cpu);
 				__cpufreq_governor(data,
 						CPUFREQ_GOV_POLICY_EXIT);
@@ -1851,7 +1854,8 @@ static int __cpufreq_set_policy(struct cpufreq_policy *data,
 			/* start new governor */
 			data->governor = policy->governor;
 			if (!__cpufreq_governor(data, CPUFREQ_GOV_POLICY_INIT)) {
-				if (!__cpufreq_governor(data, CPUFREQ_GOV_START)) {
+				if (!opsret && !__cpufreq_governor(
+					data, CPUFREQ_GOV_START)) {
 					failed = 0;
 				} else {
 					unlock_policy_rwsem_write(policy->cpu);
@@ -1869,8 +1873,9 @@ static int __cpufreq_set_policy(struct cpufreq_policy *data,
 					data->governor = old_gov;
 					__cpufreq_governor(data,
 							CPUFREQ_GOV_POLICY_INIT);
-					__cpufreq_governor(data,
-							   CPUFREQ_GOV_START);
+					if (!opsret)
+						__cpufreq_governor(data,
+							CPUFREQ_GOV_START);
 				}
 				ret = -EINVAL;
 				goto error_out;
-- 
1.8.0

