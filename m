Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965637Ab3HHNwB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 09:52:01 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:38879 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965625Ab3HHNvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 09:51:55 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 25/35] cpufreq: powernow: use cpufreq_table_validate_and_show()
Date: Thu,  8 Aug 2013 19:18:27 +0530
Message-Id: <8ddaa40a58ddff7b5e7e7b689f241136adbd422e.1375964117.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1375964117.git.viresh.kumar@linaro.org>
References: <cover.1375964117.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1375964117.git.viresh.kumar@linaro.org>
References: <cover.1375964117.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lets use cpufreq_table_validate_and_show() instead of calling
cpufreq_frequency_table_cpuinfo() and cpufreq_frequency_table_get_attr().

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/powernow-k6.c | 9 +--------
 drivers/cpufreq/powernow-k7.c | 4 +---
 drivers/cpufreq/powernow-k8.c | 4 +---
 3 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/cpufreq/powernow-k6.c b/drivers/cpufreq/powernow-k6.c
index 85f1c8c..ab1de0d 100644
--- a/drivers/cpufreq/powernow-k6.c
+++ b/drivers/cpufreq/powernow-k6.c
@@ -145,7 +145,6 @@ static int powernow_k6_target(struct cpufreq_policy *policy,
 static int powernow_k6_cpu_init(struct cpufreq_policy *policy)
 {
 	unsigned int i, f;
-	int result;
 
 	if (policy->cpu != 0)
 		return -ENODEV;
@@ -167,13 +166,7 @@ static int powernow_k6_cpu_init(struct cpufreq_policy *policy)
 	policy->cpuinfo.transition_latency = 200000;
 	policy->cur = busfreq * max_multiplier;
 
-	result = cpufreq_frequency_table_cpuinfo(policy, clock_ratio);
-	if (result)
-		return result;
-
-	cpufreq_frequency_table_get_attr(clock_ratio, policy->cpu);
-
-	return 0;
+	return cpufreq_table_validate_and_show(policy, clock_ratio);
 }
 
 
diff --git a/drivers/cpufreq/powernow-k7.c b/drivers/cpufreq/powernow-k7.c
index 14ce480..c863c13 100644
--- a/drivers/cpufreq/powernow-k7.c
+++ b/drivers/cpufreq/powernow-k7.c
@@ -680,9 +680,7 @@ static int powernow_cpu_init(struct cpufreq_policy *policy)
 
 	policy->cur = powernow_get(0);
 
-	cpufreq_frequency_table_get_attr(powernow_table, policy->cpu);
-
-	return cpufreq_frequency_table_cpuinfo(policy, powernow_table);
+	return cpufreq_table_validate_and_show(policy, powernow_table);
 }
 
 static int powernow_cpu_exit(struct cpufreq_policy *policy)
diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index 2344a9e..8d4114a 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -1156,7 +1156,7 @@ static int powernowk8_cpu_init(struct cpufreq_policy *pol)
 	pr_debug("policy current frequency %d kHz\n", pol->cur);
 
 	/* min/max the cpu is capable of */
-	if (cpufreq_frequency_table_cpuinfo(pol, data->powernow_table)) {
+	if (cpufreq_table_validate_and_show(pol, data->powernow_table)) {
 		printk(KERN_ERR FW_BUG PFX "invalid powernow_table\n");
 		powernow_k8_cpu_exit_acpi(data);
 		kfree(data->powernow_table);
@@ -1164,8 +1164,6 @@ static int powernowk8_cpu_init(struct cpufreq_policy *pol)
 		return -EINVAL;
 	}
 
-	cpufreq_frequency_table_get_attr(data->powernow_table, pol->cpu);
-
 	pr_debug("cpu_init done, current fid 0x%x, vid 0x%x\n",
 		 data->currfid, data->currvid);
 
-- 
1.7.12.rc2.18.g61b472e

