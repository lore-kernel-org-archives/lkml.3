Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab3AaR2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 12:28:17 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:38651 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab3AaR2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 12:28:12 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, fabio.baltieri@linaro.org
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/2] cpufreq: governors: Get rid of dbs_data->enable field
Date: Thu, 31 Jan 2013 22:58:01 +0530
Message-Id: <09a94ff044ff6a6f7a5d953c3b1f3102c1dc50cf.1359653181.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPUFREQ_GOV_START/STOP are called only once for all policy->cpus and hence we
don't need to adapt cpufreq_governor_dbs() routine for multiple calls.

So, this patch removes dbs_data->enable field entirely. And rearrange code a
bit.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
Hi Fabio,

I have fixed all the pending issues, but haven't checked these patches. Can you
please add your tested-by (obviously after testing them) ?

Compile tested only.

 drivers/cpufreq/cpufreq_governor.c | 58 +++++++++++++-------------------------
 drivers/cpufreq/cpufreq_governor.h |  1 -
 2 files changed, 20 insertions(+), 39 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index 46f1c78..29d6a59 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -182,6 +182,8 @@ int cpufreq_governor_dbs(struct dbs_data *dbs_data,
 {
 	struct od_cpu_dbs_info_s *od_dbs_info = NULL;
 	struct cs_cpu_dbs_info_s *cs_dbs_info = NULL;
+	struct cs_ops *cs_ops = NULL;
+	struct od_ops *od_ops = NULL;
 	struct od_dbs_tuners *od_tuners = dbs_data->tuners;
 	struct cs_dbs_tuners *cs_tuners = dbs_data->tuners;
 	struct cpu_dbs_common_info *cpu_cdbs;
@@ -194,10 +196,12 @@ int cpufreq_governor_dbs(struct dbs_data *dbs_data,
 		cs_dbs_info = dbs_data->get_cpu_dbs_info_s(cpu);
 		sampling_rate = &cs_tuners->sampling_rate;
 		ignore_nice = cs_tuners->ignore_nice;
+		cs_ops = dbs_data->gov_ops;
 	} else {
 		od_dbs_info = dbs_data->get_cpu_dbs_info_s(cpu);
 		sampling_rate = &od_tuners->sampling_rate;
 		ignore_nice = od_tuners->ignore_nice;
+		od_ops = dbs_data->gov_ops;
 	}
 
 	switch (event) {
@@ -207,10 +211,9 @@ int cpufreq_governor_dbs(struct dbs_data *dbs_data,
 
 		mutex_lock(&dbs_data->mutex);
 
-		dbs_data->enable++;
 		for_each_cpu(j, policy->cpus) {
-			struct cpu_dbs_common_info *j_cdbs;
-			j_cdbs = dbs_data->get_cpu_cdbs(j);
+			struct cpu_dbs_common_info *j_cdbs =
+				dbs_data->get_cpu_cdbs(j);
 
 			j_cdbs->cpu = j;
 			j_cdbs->cur_policy = policy;
@@ -225,13 +228,6 @@ int cpufreq_governor_dbs(struct dbs_data *dbs_data,
 					     dbs_data->gov_dbs_timer);
 		}
 
-		/*
-		 * Start the timerschedule work, when this governor is used for
-		 * first time
-		 */
-		if (dbs_data->enable != 1)
-			goto second_time;
-
 		rc = sysfs_create_group(cpufreq_global_kobject,
 				dbs_data->attr_group);
 		if (rc) {
@@ -249,17 +245,19 @@ int cpufreq_governor_dbs(struct dbs_data *dbs_data,
 		 * governor, thus we are bound to jiffes/HZ
 		 */
 		if (dbs_data->governor == GOV_CONSERVATIVE) {
-			struct cs_ops *ops = dbs_data->gov_ops;
-
-			cpufreq_register_notifier(ops->notifier_block,
+			cs_dbs_info->down_skip = 0;
+			cs_dbs_info->enable = 1;
+			cs_dbs_info->requested_freq = policy->cur;
+			cpufreq_register_notifier(cs_ops->notifier_block,
 					CPUFREQ_TRANSITION_NOTIFIER);
 
 			dbs_data->min_sampling_rate = MIN_SAMPLING_RATE_RATIO *
 				jiffies_to_usecs(10);
 		} else {
-			struct od_ops *ops = dbs_data->gov_ops;
-
-			od_tuners->io_is_busy = ops->io_busy();
+			od_dbs_info->rate_mult = 1;
+			od_dbs_info->sample_type = OD_NORMAL_SAMPLE;
+			od_ops->powersave_bias_init_cpu(cpu);
+			od_tuners->io_is_busy = od_ops->io_busy();
 		}
 
 		/* Bring kernel and HW constraints together */
@@ -267,18 +265,6 @@ int cpufreq_governor_dbs(struct dbs_data *dbs_data,
 				MIN_LATENCY_MULTIPLIER * latency);
 		*sampling_rate = max(dbs_data->min_sampling_rate, latency *
 				LATENCY_MULTIPLIER);
-
-second_time:
-		if (dbs_data->governor == GOV_CONSERVATIVE) {
-			cs_dbs_info->down_skip = 0;
-			cs_dbs_info->enable = 1;
-			cs_dbs_info->requested_freq = policy->cur;
-		} else {
-			struct od_ops *ops = dbs_data->gov_ops;
-			od_dbs_info->rate_mult = 1;
-			od_dbs_info->sample_type = OD_NORMAL_SAMPLE;
-			ops->powersave_bias_init_cpu(cpu);
-		}
 		mutex_unlock(&dbs_data->mutex);
 
 		/* Initiate timer time stamp */
@@ -297,16 +283,12 @@ second_time:
 
 		mutex_lock(&dbs_data->mutex);
 		mutex_destroy(&cpu_cdbs->timer_mutex);
-		dbs_data->enable--;
-		if (!dbs_data->enable) {
-			struct cs_ops *ops = dbs_data->gov_ops;
-
-			sysfs_remove_group(cpufreq_global_kobject,
-					dbs_data->attr_group);
-			if (dbs_data->governor == GOV_CONSERVATIVE)
-				cpufreq_unregister_notifier(ops->notifier_block,
-						CPUFREQ_TRANSITION_NOTIFIER);
-		}
+
+		sysfs_remove_group(cpufreq_global_kobject,
+				dbs_data->attr_group);
+		if (dbs_data->governor == GOV_CONSERVATIVE)
+			cpufreq_unregister_notifier(cs_ops->notifier_block,
+					CPUFREQ_TRANSITION_NOTIFIER);
 		mutex_unlock(&dbs_data->mutex);
 
 		break;
diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
index b72e628..c19a16c 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -130,7 +130,6 @@ struct dbs_data {
 	#define GOV_CONSERVATIVE	1
 	int governor;
 	unsigned int min_sampling_rate;
-	unsigned int enable; /* number of CPUs using this policy */
 	struct attribute_group *attr_group;
 	void *tuners;
 
-- 
1.7.12.rc2.18.g61b472e

