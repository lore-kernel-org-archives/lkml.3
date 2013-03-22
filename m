Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933410Ab3CVKOI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 06:14:08 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:56005 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933110Ab3CVKOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 06:14:05 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: arvind.chauhan@arm.com, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Liviu.Dudau@arm.com, charles.garcia-tobin@arm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] cpufreq: stats: do cpufreq_cpu_put() corresponding to cpufreq_cpu_get
Date: Fri, 22 Mar 2013 15:43:52 +0530
Message-Id: <234906745c34fb72b0c450d897f261a22ed18d40.1363947023.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In cpufreq_stats_free_sysfs() we aren't balancing calls to cpufreq_cpu_get()
with cpufreq_cpu_put(). This will never let us have ref count to policy->kobj as
zero.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq_stats.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index 2fd779e..bfd6273 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -180,15 +180,19 @@ static void cpufreq_stats_free_sysfs(unsigned int cpu)
 {
 	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
 
-	if (!cpufreq_frequency_get_table(cpu))
+	if (!policy)
 		return;
 
-	if (policy && !policy_is_shared(policy)) {
+	if (!cpufreq_frequency_get_table(cpu))
+		goto put_ref;
+
+	if (!policy_is_shared(policy)) {
 		pr_debug("%s: Free sysfs stat\n", __func__);
 		sysfs_remove_group(&policy->kobj, &stats_attr_group);
 	}
-	if (policy)
-		cpufreq_cpu_put(policy);
+
+put_ref:
+	cpufreq_cpu_put(policy);
 }
 
 static int cpufreq_stats_create_table(struct cpufreq_policy *policy,
-- 
1.7.12.rc2.18.g61b472e

