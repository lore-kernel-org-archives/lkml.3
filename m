Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab3CDHrq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 02:47:46 -0500
Received: from mail-da0-f54.google.com ([209.85.210.54]:33121 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425Ab3CDHrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 02:47:42 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, rickard.andersson@stericsson.com,
        fabio.baltieri@linaro.org, tj@kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 1/2] cpufreq: ondemand: Don't update sample_type if we don't evaluate load again
Date: Mon,  4 Mar 2013 15:47:23 +0800
Message-Id: <cb4ff68080e21220318cec2bb8a52d9d6090e638.1362382746.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1362382746.git.viresh.kumar@linaro.org>
References: <cover.1362382746.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1362382746.git.viresh.kumar@linaro.org>
References: <cover.1362382746.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because we have per cpu timer now, we check if we need to evaluate load again or
not (In case it is recently evaluated). Here the 2nd cpu which got timer
interrupt updates core_dbs_info->sample_type irrespective of load evaluation is
required or not. Which is wrong as the first cpu is dependent on this variable
set to an older value.

Moreover it would be best in this case to schedule 2nd cpu's timer to
sampling_rate instead of freq_lo or hi as that must be managed by the other cpu.
In case the other cpu idles in between then also we wouldn't loose much power.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq_ondemand.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index c5fd794..e76f4f8 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -224,34 +224,32 @@ static void od_dbs_timer(struct work_struct *work)
 			cpu);
 	struct dbs_data *dbs_data = dbs_info->cdbs.cur_policy->governor_data;
 	struct od_dbs_tuners *od_tuners = dbs_data->tuners;
-	int delay, sample_type = core_dbs_info->sample_type;
-	bool eval_load;
+	int delay = 0, sample_type = core_dbs_info->sample_type;
 
 	mutex_lock(&core_dbs_info->cdbs.timer_mutex);
-	eval_load = need_load_eval(&core_dbs_info->cdbs,
-			od_tuners->sampling_rate);
+	if (!need_load_eval(&core_dbs_info->cdbs, od_tuners->sampling_rate))
+		goto max_delay;
 
 	/* Common NORMAL_SAMPLE setup */
 	core_dbs_info->sample_type = OD_NORMAL_SAMPLE;
 	if (sample_type == OD_SUB_SAMPLE) {
 		delay = core_dbs_info->freq_lo_jiffies;
-		if (eval_load)
-			__cpufreq_driver_target(core_dbs_info->cdbs.cur_policy,
-						core_dbs_info->freq_lo,
-						CPUFREQ_RELATION_H);
+		__cpufreq_driver_target(core_dbs_info->cdbs.cur_policy,
+				core_dbs_info->freq_lo, CPUFREQ_RELATION_H);
 	} else {
-		if (eval_load)
-			dbs_check_cpu(dbs_data, cpu);
+		dbs_check_cpu(dbs_data, cpu);
 		if (core_dbs_info->freq_lo) {
 			/* Setup timer for SUB_SAMPLE */
 			core_dbs_info->sample_type = OD_SUB_SAMPLE;
 			delay = core_dbs_info->freq_hi_jiffies;
-		} else {
-			delay = delay_for_sampling_rate(od_tuners->sampling_rate
-						* core_dbs_info->rate_mult);
 		}
 	}
 
+max_delay:
+	if (!delay)
+		delay = delay_for_sampling_rate(od_tuners->sampling_rate
+				* core_dbs_info->rate_mult);
+
 	schedule_delayed_work_on(smp_processor_id(), dw, delay);
 	mutex_unlock(&core_dbs_info->cdbs.timer_mutex);
 }
-- 
1.7.12.rc2.18.g61b472e

