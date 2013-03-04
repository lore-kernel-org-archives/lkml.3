Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab3CDHrv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 02:47:51 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:57089 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425Ab3CDHrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 02:47:48 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, rickard.andersson@stericsson.com,
        fabio.baltieri@linaro.org, tj@kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 2/2] cpufreq: governors: Avoid unnecessary per cpu timer interrupts
Date: Mon,  4 Mar 2013 15:47:24 +0800
Message-Id: <15bb56be43dd72924b734ea66775bb50bfe42fa5.1362382746.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1362382746.git.viresh.kumar@linaro.org>
References: <cover.1362382746.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1362382746.git.viresh.kumar@linaro.org>
References: <cover.1362382746.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 drivers/cpufreq/cpufreq_conservative.c |  8 ++++---
 drivers/cpufreq/cpufreq_governor.c     | 39 ++++++++++++++++++++++++----------
 drivers/cpufreq/cpufreq_governor.h     |  2 ++
 drivers/cpufreq/cpufreq_ondemand.c     | 12 ++++++-----
 4 files changed, 42 insertions(+), 19 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index d86577f..77b60a7 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -107,7 +107,6 @@ static void cs_check_cpu(int cpu, unsigned int load)
 
 static void cs_dbs_timer(struct work_struct *work)
 {
-	struct delayed_work *dw = to_delayed_work(work);
 	struct cs_cpu_dbs_info_s *dbs_info = container_of(work,
 			struct cs_cpu_dbs_info_s, cdbs.work.work);
 	unsigned int cpu = dbs_info->cdbs.cur_policy->cpu;
@@ -116,12 +115,15 @@ static void cs_dbs_timer(struct work_struct *work)
 	struct dbs_data *dbs_data = dbs_info->cdbs.cur_policy->governor_data;
 	struct cs_dbs_tuners *cs_tuners = dbs_data->tuners;
 	int delay = delay_for_sampling_rate(cs_tuners->sampling_rate);
+	bool modify_all = true;
 
 	mutex_lock(&core_dbs_info->cdbs.timer_mutex);
-	if (need_load_eval(&core_dbs_info->cdbs, cs_tuners->sampling_rate))
+	if (!need_load_eval(&core_dbs_info->cdbs, cs_tuners->sampling_rate))
+		modify_all = false;
+	else
 		dbs_check_cpu(dbs_data, cpu);
 
-	schedule_delayed_work_on(smp_processor_id(), dw, delay);
+	gov_queue_work(dbs_data, dbs_info->cdbs.cur_policy, delay, modify_all);
 	mutex_unlock(&core_dbs_info->cdbs.timer_mutex);
 }
 
diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index 7722505..f592f71 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -162,20 +162,38 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
 }
 EXPORT_SYMBOL_GPL(dbs_check_cpu);
 
-static inline void dbs_timer_init(struct dbs_data *dbs_data, int cpu,
-				  unsigned int sampling_rate)
+static inline void __gov_queue_work(int cpu, struct dbs_data *dbs_data,
+		unsigned int delay)
 {
-	int delay = delay_for_sampling_rate(sampling_rate);
 	struct cpu_dbs_common_info *cdbs = dbs_data->cdata->get_cpu_cdbs(cpu);
 
-	schedule_delayed_work_on(cpu, &cdbs->work, delay);
+	mod_delayed_work_on(cpu, system_wq, &cdbs->work, delay);
 }
 
-static inline void dbs_timer_exit(struct dbs_data *dbs_data, int cpu)
+void gov_queue_work(struct dbs_data *dbs_data, struct cpufreq_policy *policy,
+		unsigned int delay, bool all_cpus)
 {
-	struct cpu_dbs_common_info *cdbs = dbs_data->cdata->get_cpu_cdbs(cpu);
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
+static inline void gov_cancel_work(struct dbs_data *dbs_data,
+		struct cpufreq_policy *policy)
+{
+	struct cpu_dbs_common_info *cdbs;
+	int i;
 
-	cancel_delayed_work_sync(&cdbs->work);
+	for_each_cpu(i, policy->cpus) {
+		cdbs = dbs_data->cdata->get_cpu_cdbs(i);
+		cancel_delayed_work_sync(&cdbs->work);
+	}
 }
 
 /* Will return if we need to evaluate cpu load again or not */
@@ -330,16 +348,15 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 		/* Initiate timer time stamp */
 		cpu_cdbs->time_stamp = ktime_get();
 
-		for_each_cpu(j, policy->cpus)
-			dbs_timer_init(dbs_data, j, sampling_rate);
+		gov_queue_work(dbs_data, policy,
+				delay_for_sampling_rate(sampling_rate), true);
 		break;
 
 	case CPUFREQ_GOV_STOP:
 		if (dbs_data->cdata->governor == GOV_CONSERVATIVE)
 			cs_dbs_info->enable = 0;
 
-		for_each_cpu(j, policy->cpus)
-			dbs_timer_exit(dbs_data, j);
+		gov_cancel_work(dbs_data, policy);
 
 		mutex_lock(&dbs_data->mutex);
 		mutex_destroy(&cpu_cdbs->timer_mutex);
diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
index 6301790..9e3d310 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -192,4 +192,6 @@ bool need_load_eval(struct cpu_dbs_common_info *cdbs,
 		unsigned int sampling_rate);
 int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 		struct common_dbs_data *cdata, unsigned int event);
+void gov_queue_work(struct dbs_data *dbs_data, struct cpufreq_policy *policy,
+		unsigned int delay, bool all_cpus);
 #endif /* _CPUFREQ_GOVERNER_H */
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index e76f4f8..04f81d8 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -216,7 +216,6 @@ static void od_check_cpu(int cpu, unsigned int load_freq)
 
 static void od_dbs_timer(struct work_struct *work)
 {
-	struct delayed_work *dw = to_delayed_work(work);
 	struct od_cpu_dbs_info_s *dbs_info =
 		container_of(work, struct od_cpu_dbs_info_s, cdbs.work.work);
 	unsigned int cpu = dbs_info->cdbs.cur_policy->cpu;
@@ -225,10 +224,13 @@ static void od_dbs_timer(struct work_struct *work)
 	struct dbs_data *dbs_data = dbs_info->cdbs.cur_policy->governor_data;
 	struct od_dbs_tuners *od_tuners = dbs_data->tuners;
 	int delay = 0, sample_type = core_dbs_info->sample_type;
+	bool modify_all = true;
 
 	mutex_lock(&core_dbs_info->cdbs.timer_mutex);
-	if (!need_load_eval(&core_dbs_info->cdbs, od_tuners->sampling_rate))
+	if (!need_load_eval(&core_dbs_info->cdbs, od_tuners->sampling_rate)) {
+		modify_all = false;
 		goto max_delay;
+	}
 
 	/* Common NORMAL_SAMPLE setup */
 	core_dbs_info->sample_type = OD_NORMAL_SAMPLE;
@@ -250,7 +252,7 @@ max_delay:
 		delay = delay_for_sampling_rate(od_tuners->sampling_rate
 				* core_dbs_info->rate_mult);
 
-	schedule_delayed_work_on(smp_processor_id(), dw, delay);
+	gov_queue_work(dbs_data, dbs_info->cdbs.cur_policy, delay, modify_all);
 	mutex_unlock(&core_dbs_info->cdbs.timer_mutex);
 }
 
@@ -308,8 +310,8 @@ static void update_sampling_rate(struct dbs_data *dbs_data,
 			cancel_delayed_work_sync(&dbs_info->cdbs.work);
 			mutex_lock(&dbs_info->cdbs.timer_mutex);
 
-			schedule_delayed_work_on(cpu, &dbs_info->cdbs.work,
-					usecs_to_jiffies(new_rate));
+			gov_queue_work(dbs_data, dbs_info->cdbs.cur_policy,
+					usecs_to_jiffies(new_rate), true);
 
 		}
 		mutex_unlock(&dbs_info->cdbs.timer_mutex);
-- 
1.7.12.rc2.18.g61b472e

