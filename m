Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab3HTGlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 02:41:05 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:57907 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab3HTGlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 02:41:03 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 5/5] cpufreq: Use cpufreq_policy_list for iterating over policies
Date: Tue, 20 Aug 2013 12:08:26 +0530
Message-Id: <41cb4f97aed084ff3f851c820f23283a02a02d42.1376979090.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1376979090.git.viresh.kumar@linaro.org>
References: <cover.1376979090.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1376979090.git.viresh.kumar@linaro.org>
References: <cover.1376979090.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To iterate over all policies we currently iterate over all CPUs and
then get the policy for each of them.  Let's use the newly created
cpufreq_policy_list for this purpose.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 0586bd2..81ceea6 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -961,8 +961,8 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 	struct cpufreq_policy *policy;
 	unsigned long flags;
 #ifdef CONFIG_HOTPLUG_CPU
+	struct cpufreq_policy *tpolicy;
 	struct cpufreq_governor *gov;
-	int sibling;
 #endif
 
 	if (cpu_is_offline(cpu))
@@ -985,11 +985,10 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 #ifdef CONFIG_HOTPLUG_CPU
 	/* Check if this cpu was hot-unplugged earlier and has siblings */
 	read_lock_irqsave(&cpufreq_driver_lock, flags);
-	for_each_online_cpu(sibling) {
-		struct cpufreq_policy *cp = per_cpu(cpufreq_cpu_data, sibling);
-		if (cp && cpumask_test_cpu(cpu, cp->related_cpus)) {
+	list_for_each_entry(tpolicy, &cpufreq_policy_list, policy_list) {
+		if (cpumask_test_cpu(cpu, tpolicy->related_cpus)) {
 			read_unlock_irqrestore(&cpufreq_driver_lock, flags);
-			ret = cpufreq_add_policy_cpu(cp, cpu, dev, frozen);
+			ret = cpufreq_add_policy_cpu(tpolicy, cpu, dev, frozen);
 			up_read(&cpufreq_rwsem);
 			return ret;
 		}
-- 
1.7.12.rc2.18.g61b472e

