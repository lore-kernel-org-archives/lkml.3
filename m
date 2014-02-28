Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbaB1B6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 20:58:46 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:36814 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbaB1B6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 20:58:43 -0500
From: Saravana Kannan <skannan@codeaurora.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "Saravana Kannan" <skannan@codeaurora.org>
Subject: [PATCH v3 3/3] cpufreq: stats: Refactor common code into __cpufreq_stats_create_table()
Date: Thu, 27 Feb 2014 17:58:36 -0800
Message-Id: <1393552716-9754-3-git-send-email-skannan@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpufreq_frequency_get_table() is called from all callers of
__cpufreq_stats_create_table(). So, move it inside.

Suggested-by: Viresh Kumar <viresh.kumar@linaro.org>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
---
 drivers/cpufreq/cpufreq_stats.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index c52b440..eb214d8 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -180,13 +180,18 @@ static void cpufreq_stats_free_table(unsigned int cpu)
 	cpufreq_cpu_put(policy);
 }
 
-static int __cpufreq_stats_create_table(struct cpufreq_policy *policy,
-		struct cpufreq_frequency_table *table)
+static int __cpufreq_stats_create_table(struct cpufreq_policy *policy)
 {
 	unsigned int i, j, count = 0, ret = 0;
 	struct cpufreq_stats *stat;
 	unsigned int alloc_size;
 	unsigned int cpu = policy->cpu;
+	struct cpufreq_frequency_table *table;
+
+	table = cpufreq_frequency_get_table(cpu);
+	if (unlikely(!table))
+		return 0;
+
 	if (per_cpu(cpufreq_stats_table, cpu))
 		return -EBUSY;
 	stat = kzalloc(sizeof(*stat), GFP_KERNEL);
@@ -248,7 +253,6 @@ error_out:
 static void cpufreq_stats_create_table(unsigned int cpu)
 {
 	struct cpufreq_policy *policy;
-	struct cpufreq_frequency_table *table;
 
 	/*
 	 * "likely(!policy)" because normally cpufreq_stats will be registered
@@ -258,9 +262,7 @@ static void cpufreq_stats_create_table(unsigned int cpu)
 	if (likely(!policy))
 		return;
 
-	table = cpufreq_frequency_get_table(policy->cpu);
-	if (likely(table))
-		__cpufreq_stats_create_table(policy, table);
+	__cpufreq_stats_create_table(policy);
 
 	cpufreq_cpu_put(policy);
 }
@@ -283,20 +285,14 @@ static int cpufreq_stat_notifier_policy(struct notifier_block *nb,
 {
 	int ret = 0;
 	struct cpufreq_policy *policy = data;
-	struct cpufreq_frequency_table *table;
-	unsigned int cpu = policy->cpu;
 
 	if (val == CPUFREQ_UPDATE_POLICY_CPU) {
 		cpufreq_stats_update_policy_cpu(policy);
 		return 0;
 	}
 
-	table = cpufreq_frequency_get_table(cpu);
-	if (!table)
-		return 0;
-
 	if (val == CPUFREQ_CREATE_POLICY)
-		ret = __cpufreq_stats_create_table(policy, table);
+		ret = __cpufreq_stats_create_table(policy);
 	else if (val == CPUFREQ_REMOVE_POLICY)
 		__cpufreq_stats_free_table(policy);
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

