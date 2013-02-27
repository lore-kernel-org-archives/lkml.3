Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609Ab3B0L3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 06:29:36 -0500
Received: from service87.mimecast.com ([91.220.42.44]:58389 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759361Ab3B0L3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 06:29:34 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, rickard.andersson@stericsson.com,
        fabio.baltieri@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 3/3] cpufreq: governors: Avoid unnecessary per cpu timer interrupts
Date: Wed, 27 Feb 2013 16:59:12 +0530
Message-Id: <a7469422cc31973c889fd01f1b4541e7ec5dd2d5.1361964515.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <5249868a014d716eb38cc90e04ed0f6051e65fc3.1361964515.git.viresh.kumar@linaro.org>
References: <5249868a014d716eb38cc90e04ed0f6051e65fc3.1361964515.git.viresh.kumar@linaro.org>
In-Reply-To: <5249868a014d716eb38cc90e04ed0f6051e65fc3.1361964515.git.viresh.kumar@linaro.org>
References: <5249868a014d716eb38cc90e04ed0f6051e65fc3.1361964515.git.viresh.kumar@linaro.org>
X-OriginalArrivalTime: 27 Feb 2013 11:29:29.0456 (UTC) FILETIME=[B4D5C700:01CE14DD]
X-MC-Unique: 113022711293201901
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r1RBTZsh006731

Following patch has introduced per cpu timers or works for ondemand and
conservative governors.

	commit 2abfa876f1117b0ab45f191fb1f82c41b1cbc8fe
	Author: Rickard Andersson <rickard.andersson@stericsson.com>
	Date:   Thu Dec 27 14:55:38 2012 +0000

	    cpufreq: handle SW coordinated CPUs

This causes additional unnecessary interrupts on all cpus when the load is
recently evaluated by any other cpu. i.e. When load is recently evaluated by cpu
x, we don't really need any other cpu to evaluate this load again for the next
sampling_rate time.

Some sort of code is present to avoid that but we are still getting timer
interrupts for all cpus. A good way of avoiding this would be to modify delays
for all cpus (policy->cpus) whenever any cpu has evaluated load.

This patch does this change and some related code cleanup.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq_conservative.c | 10 ++++++---
 drivers/cpufreq/cpufreq_governor.c     | 38 ++++++++++++++++++++++++----------
 drivers/cpufreq/cpufreq_governor.h     |  2 ++
 drivers/cpufreq/cpufreq_ondemand.c     | 13 +++++++-----
 4 files changed, 44 insertions(+), 19 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index 4fd0006..de5f66a 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -113,19 +113,23 @@ static void cs_check_cpu(int cpu, unsigned int load)
 
 static void cs_dbs_timer(struct work_struct *work)
 {
-	struct delayed_work *dw = to_delayed_work(work);
 	struct cs_cpu_dbs_info_s *dbs_info = container_of(work,
 			struct cs_cpu_dbs_info_s, cdbs.work.work);
 	unsigned int cpu = dbs_info->cdbs.cur_policy->cpu;
 	struct cs_cpu_dbs_info_s *core_dbs_info = &per_cpu(cs_cpu_dbs_info,
 			cpu);
 	int delay = delay_for_sampling_rate(cs_tuners.sampling_rate);
+	bool modify_all = true;
 
 	mutex_lock(&core_dbs_info->cdbs.timer_mutex);
-	if (need_load_eval(&core_dbs_info->cdbs, cs_tuners.sampling_rate))
+	if (!need_load_eval(&core_dbs_info->cdbs, cs_tuners.sampling_rate))
+		modify_all = false;
+	else
 		dbs_check_cpu(&cs_dbs_data, cpu);
 
-	schedule_delayed_work_on(smp_processor_id(), dw, delay);
+	gov_queue_work(&cs_dbs_data, dbs_info->cdbs.cur_policy, delay,
+			modify_all);
+
 	mutex_unlock(&core_dbs_info->cdbs.timer_mutex);
 }
 
diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index 5a76086..f0747f1 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -161,20 +161,37 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
 }
 EXPORT_SYMBOL_GPL(dbs_check_cpu);
 
-static inline void dbs_timer_init(struct dbs_data *dbs_data, int cpu,
-				  unsigned int sampling_rate)
+static inline void __gov_queue_work(int cpu, struct dbs_data *dbs_data,
+		unsigned int delay)
 {
-	int delay = delay_for_sampling_rate(sampling_rate);
 	struct cpu_dbs_common_info *cdbs = dbs_data->get_cpu_cdbs(cpu);
 
-	schedule_delayed_work_on(cpu, &cdbs->work, delay);
+	mod_scheduled_delayed_work_on(cpu, &cdbs->work, delay);
 }
 
-static inline void dbs_timer_exit(struct dbs_data *dbs_data, int cpu)
+void gov_queue_work(struct dbs_data *dbs_data, struct cpufreq_policy *policy,
+		unsigned int delay, bool all_cpus)
 {
-	struct cpu_dbs_common_info *cdbs = dbs_data->get_cpu_cdbs(cpu);
+	int i;
+
+	if (!all_cpus) {
+		__gov_queue_work(smp_processor_id(), dbs_data, delay);
+	} else {
+		for_each_cpu(i, policy->cpus)
+			__gov_queue_work(i, dbs_data, delay);
+	}
+}
+EXPORT_SYMBOL_GPL(gov_queue_work);
+
+void gov_cancel_work(struct dbs_data *dbs_data, struct cpufreq_policy *policy)
+{
+	struct cpu_dbs_common_info *cdbs;
+	int i;
 
-	cancel_delayed_work_sync(&cdbs->work);
+	for_each_cpu(i, policy->cpus) {
+		cdbs = dbs_data->get_cpu_cdbs(i);
+		cancel_delayed_work_sync(&cdbs->work);
+	}
 }
 
 /* Will return if we need to evaluate cpu load again or not */
@@ -301,16 +318,15 @@ unlock:
 		/* Initiate timer time stamp */
 		cpu_cdbs->time_stamp = ktime_get();
 
-		for_each_cpu(j, policy->cpus)
-			dbs_timer_init(dbs_data, j, *sampling_rate);
+		gov_queue_work(dbs_data, policy,
+				delay_for_sampling_rate(*sampling_rate), true);
 		break;
 
 	case CPUFREQ_GOV_STOP:
 		if (dbs_data->governor == GOV_CONSERVATIVE)
 			cs_dbs_info->enable = 0;
 
-		for_each_cpu(j, policy->cpus)
-			dbs_timer_exit(dbs_data, j);
+		gov_cancel_work(dbs_data, policy);
 
 		mutex_lock(&dbs_data->mutex);
 		mutex_destroy(&cpu_cdbs->timer_mutex);
diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
index d2ac911..8c0116e 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -175,4 +175,6 @@ bool need_load_eval(struct cpu_dbs_common_info *cdbs,
 		unsigned int sampling_rate);
 int cpufreq_governor_dbs(struct dbs_data *dbs_data,
 		struct cpufreq_policy *policy, unsigned int event);
+void gov_queue_work(struct dbs_data *dbs_data, struct cpufreq_policy *policy,
+		unsigned int delay, bool all_cpus);
 #endif /* _CPUFREQ_GOVERNER_H */
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index a815c88..7d9cfdb 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -217,17 +217,19 @@ static void od_check_cpu(int cpu, unsigned int load_freq)
 
 static void od_dbs_timer(struct work_struct *work)
 {
-	struct delayed_work *dw = to_delayed_work(work);
 	struct od_cpu_dbs_info_s *dbs_info =
 		container_of(work, struct od_cpu_dbs_info_s, cdbs.work.work);
 	unsigned int cpu = dbs_info->cdbs.cur_policy->cpu;
 	struct od_cpu_dbs_info_s *core_dbs_info = &per_cpu(od_cpu_dbs_info,
 			cpu);
 	int delay = 0, sample_type = core_dbs_info->sample_type;
+	bool modify_all = true;
 
 	mutex_lock(&core_dbs_info->cdbs.timer_mutex);
-	if (!need_load_eval(&core_dbs_info->cdbs, od_tuners.sampling_rate))
+	if (!need_load_eval(&core_dbs_info->cdbs, od_tuners.sampling_rate)) {
+		modify_all = false;
 		goto max_delay;
+	}
 
 	/* Common NORMAL_SAMPLE setup */
 	core_dbs_info->sample_type = OD_NORMAL_SAMPLE;
@@ -249,7 +251,8 @@ max_delay:
 		delay = delay_for_sampling_rate(od_tuners.sampling_rate
 				* core_dbs_info->rate_mult);
 
-	schedule_delayed_work_on(smp_processor_id(), dw, delay);
+	gov_queue_work(&od_dbs_data, dbs_info->cdbs.cur_policy, delay,
+			modify_all);
 	mutex_unlock(&core_dbs_info->cdbs.timer_mutex);
 }
 
@@ -312,8 +315,8 @@ static void update_sampling_rate(unsigned int new_rate)
 			cancel_delayed_work_sync(&dbs_info->cdbs.work);
 			mutex_lock(&dbs_info->cdbs.timer_mutex);
 
-			schedule_delayed_work_on(cpu, &dbs_info->cdbs.work,
-					usecs_to_jiffies(new_rate));
+			gov_queue_work(&od_dbs_data, dbs_info->cdbs.cur_policy,
+					usecs_to_jiffies(new_rate), true);
 
 		}
 		mutex_unlock(&dbs_info->cdbs.timer_mutex);
-- 
1.7.12.rc2.18.g61b472e


