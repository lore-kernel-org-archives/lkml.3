Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab3AaJpS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 04:45:18 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:44040 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab3AaJpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 04:45:11 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH v2] cpufreq: governors: implement generic policy_is_shared
Date: Thu, 31 Jan 2013 10:44:40 +0100
Message-Id: <1359625480-16688-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <CAOh2x==1ru3bddHnJOge=1rbpc6xwzKV5F5isJhAgwX_R=2TCw@mail.gmail.com>
References: <CAOh2x==1ru3bddHnJOge=1rbpc6xwzKV5F5isJhAgwX_R=2TCw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement a generic helper function policy_is_shared() to replace the
current dbs_sw_coordinated_cpus() at cpufreq level, so that it can be
used by code other than cpufreq governors.

Suggested-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---

Changes from v1:
- replaced cpumask_weight in acpi-cpufreq.c and cpufreq_stats.c, through the
  actual check is different the semantic should be the same.

Fabio

 drivers/cpufreq/acpi-cpufreq.c         | 2 +-
 drivers/cpufreq/cpufreq_conservative.c | 2 +-
 drivers/cpufreq/cpufreq_governor.c     | 8 --------
 drivers/cpufreq/cpufreq_governor.h     | 1 -
 drivers/cpufreq/cpufreq_ondemand.c     | 2 +-
 drivers/cpufreq/cpufreq_stats.c        | 2 +-
 include/linux/cpufreq.h                | 5 +++++
 7 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 22f9b47..937bc28 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -734,7 +734,7 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 
 #ifdef CONFIG_SMP
 	dmi_check_system(sw_any_bug_dmi_table);
-	if (bios_with_sw_any_bug && cpumask_weight(policy->cpus) == 1) {
+	if (bios_with_sw_any_bug && !policy_is_shared(policy)) {
 		policy->shared_type = CPUFREQ_SHARED_TYPE_ALL;
 		cpumask_copy(policy->cpus, cpu_core_mask(cpu));
 	}
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
diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index beef6b5..572124c 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -185,7 +185,7 @@ static void cpufreq_stats_free_table(unsigned int cpu)
 static void cpufreq_stats_free_sysfs(unsigned int cpu)
 {
 	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
-	if (policy && (cpumask_weight(policy->cpus) == 1)) {
+	if (policy && !policy_is_shared(policy)) {
 		pr_debug("%s: Free sysfs stat\n", __func__);
 		sysfs_remove_group(&policy->kobj, &stats_attr_group);
 	}
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

