Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733Ab3AaIOq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 03:14:46 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:62178 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218Ab3AaIOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 03:14:43 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH] cpufreq: governors: implement generic policy_is_shared
Date: Thu, 31 Jan 2013 09:14:24 +0100
Message-Id: <1359620064-14751-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement a generic helper function policy_is_shared() to replace the
current dbs_sw_coordinated_cpus() at cpufreq level, so that it can be
used by code other than cpufreq governors.

Suggested-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/cpufreq/cpufreq_conservative.c | 2 +-
 drivers/cpufreq/cpufreq_governor.c     | 8 --------
 drivers/cpufreq/cpufreq_governor.h     | 1 -
 drivers/cpufreq/cpufreq_ondemand.c     | 2 +-
 include/linux/cpufreq.h                | 5 +++++
 5 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index 5d8e894..653fb06 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -154,7 +154,7 @@ static void cs_dbs_timer(struct work_struct *work)
 	struct cs_cpu_dbs_info_s *dbs_info = container_of(work,
 			struct cs_cpu_dbs_info_s, cdbs.work.work);
 
-	if (dbs_sw_coordinated_cpus(&dbs_info->cdbs)) {
+	if (policy_is_shared(dbs_info->cdbs.cur_policy)) {
 		cs_timer_coordinated(dbs_info, dw);
 	} else {
 		mutex_lock(&dbs_info->cdbs.timer_mutex);
diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index 46f96a4..67e235a 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -161,14 +161,6 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
 }
 EXPORT_SYMBOL_GPL(dbs_check_cpu);
 
-bool dbs_sw_coordinated_cpus(struct cpu_dbs_common_info *cdbs)
-{
-	struct cpufreq_policy *policy = cdbs->cur_policy;
-
-	return cpumask_weight(policy->cpus) > 1;
-}
-EXPORT_SYMBOL_GPL(dbs_sw_coordinated_cpus);
-
 static inline void dbs_timer_init(struct dbs_data *dbs_data, int cpu,
 				  unsigned int sampling_rate)
 {
diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
index aaf073d..b72e628 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -172,7 +172,6 @@ static inline int delay_for_sampling_rate(unsigned int sampling_rate)
 
 u64 get_cpu_idle_time(unsigned int cpu, u64 *wall);
 void dbs_check_cpu(struct dbs_data *dbs_data, int cpu);
-bool dbs_sw_coordinated_cpus(struct cpu_dbs_common_info *cdbs);
 int cpufreq_governor_dbs(struct dbs_data *dbs_data,
 		struct cpufreq_policy *policy, unsigned int event);
 #endif /* _CPUFREQ_GOVERNER_H */
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 1017b90..5ae84ff 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -277,7 +277,7 @@ static void od_dbs_timer(struct work_struct *work)
 	struct od_cpu_dbs_info_s *dbs_info =
 		container_of(work, struct od_cpu_dbs_info_s, cdbs.work.work);
 
-	if (dbs_sw_coordinated_cpus(&dbs_info->cdbs)) {
+	if (policy_is_shared(dbs_info->cdbs.cur_policy)) {
 		od_timer_coordinated(dbs_info, dw);
 	} else {
 		mutex_lock(&dbs_info->cdbs.timer_mutex);
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 5fdc6c6..f106406 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -125,6 +125,11 @@ struct cpufreq_policy {
 #define CPUFREQ_SHARED_TYPE_ALL	 (2) /* All dependent CPUs should set freq */
 #define CPUFREQ_SHARED_TYPE_ANY	 (3) /* Freq can be set from any dependent CPU*/
 
+static inline bool policy_is_shared(struct cpufreq_policy *policy)
+{
+	return cpumask_weight(policy->cpus) > 1;
+}
+
 /******************** cpufreq transition notifiers *******************/
 
 #define CPUFREQ_PRECHANGE	(0)
-- 
1.7.12.1

