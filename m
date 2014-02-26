Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685AbaBZDiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 22:38:46 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:42617 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaBZDin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 22:38:43 -0500
From: Saravana Kannan <skannan@codeaurora.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Saravana Kannan" <skannan@codeaurora.org>
Subject: [PATCH 1/3] cpufreq: stats: Remove redundant cpufreq_cpu_get() call
Date: Tue, 25 Feb 2014 19:38:33 -0800
Message-Id: <1393385915-19138-1-git-send-email-skannan@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1789244.B5CzWbcp6h@vostro.rjw.lan>
References: <1789244.B5CzWbcp6h@vostro.rjw.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__cpufreq_stats_create_table always gets pass the valid and real policy
struct. So, there's no need to call cpufreq_cpu_get() to get the policy
again.

Change-Id: I0136b3e67018ee3af2335906407f55d8c6219f71
Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
---

Viresh/Rafael,

These 3 patches is the approximate code I have in mind.

Approximate because:
* I inserted one question as a comment into the code.
* If the patch doesn't have any bugs, the plan is to remove
  cpufreq_generic_get() and references to it.

This takes care of the "don't advertise before it's ready for use" rule.

Viresh,

I think the locking updates needs to be done in addition to this.

Regards,
Saravana

 drivers/cpufreq/cpufreq_stats.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index 5793e14..e4bd27f 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -185,7 +185,6 @@ static int __cpufreq_stats_create_table(struct cpufreq_policy *policy,
 {
 	unsigned int i, j, count = 0, ret = 0;
 	struct cpufreq_stats *stat;
-	struct cpufreq_policy *current_policy;
 	unsigned int alloc_size;
 	unsigned int cpu = policy->cpu;
 	if (per_cpu(cpufreq_stats_table, cpu))
@@ -194,13 +193,7 @@ static int __cpufreq_stats_create_table(struct cpufreq_policy *policy,
 	if ((stat) == NULL)
 		return -ENOMEM;
 
-	current_policy = cpufreq_cpu_get(cpu);
-	if (current_policy == NULL) {
-		ret = -EINVAL;
-		goto error_get_fail;
-	}
-
-	ret = sysfs_create_group(&current_policy->kobj, &stats_attr_group);
+	ret = sysfs_create_group(&policy->kobj, &stats_attr_group);
 	if (ret)
 		goto error_out;
 
@@ -243,11 +236,8 @@ static int __cpufreq_stats_create_table(struct cpufreq_policy *policy,
 	stat->last_time = get_jiffies_64();
 	stat->last_index = freq_table_get_index(stat, policy->cur);
 	spin_unlock(&cpufreq_stats_lock);
-	cpufreq_cpu_put(current_policy);
 	return 0;
 error_out:
-	cpufreq_cpu_put(current_policy);
-error_get_fail:
 	kfree(stat);
 	per_cpu(cpufreq_stats_table, cpu) = NULL;
 	return ret;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

