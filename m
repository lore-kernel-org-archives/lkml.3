Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab3HFRYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 13:24:38 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:43068 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756458Ab3HFRY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 13:24:28 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 07/11] cpufreq: Use cpufreq_policy_list for iterating over policies
Date: Tue,  6 Aug 2013 22:53:09 +0530
Message-Id: <e54ce908bb964d643a2bbb945ed4a8dcb3ea00bf.1375809311.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1375809311.git.viresh.kumar@linaro.org>
References: <cover.1375809311.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1375809311.git.viresh.kumar@linaro.org>
References: <cover.1375809311.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For iterating over all policies currently we are iterating over all CPUs and
then finding their policies. Lets use the newly created infrastructure
cpufreq_policy_list.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index f5999c4..fe04b79 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -984,8 +984,8 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 	struct cpufreq_policy *policy;
 	unsigned long flags;
 #ifdef CONFIG_HOTPLUG_CPU
+	struct cpufreq_policy *tpolicy;
 	struct cpufreq_governor *gov;
-	int sibling;
 #endif
 
 	if (cpu_is_offline(cpu))
@@ -1005,11 +1005,11 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 #ifdef CONFIG_HOTPLUG_CPU
 	/* Check if this cpu was hot-unplugged earlier and has siblings */
 	read_lock_irqsave(&cpufreq_driver_lock, flags);
-	for_each_online_cpu(sibling) {
-		struct cpufreq_policy *cp = per_cpu(cpufreq_cpu_data, sibling);
-		if (cp && cpumask_test_cpu(cpu, cp->related_cpus)) {
+	list_for_each_entry(tpolicy, &cpufreq_policy_list, policy_list) {
+		if (cpumask_test_cpu(cpu, tpolicy->related_cpus)) {
 			read_unlock_irqrestore(&cpufreq_driver_lock, flags);
-			return cpufreq_add_policy_cpu(cp, cpu, dev, frozen);
+			return cpufreq_add_policy_cpu(tpolicy, cpu, dev,
+					frozen);
 		}
 	}
 	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
-- 
1.7.12.rc2.18.g61b472e

