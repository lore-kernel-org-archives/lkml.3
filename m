Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416Ab3B0L3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 06:29:33 -0500
Received: from service87.mimecast.com ([91.220.42.44]:58135 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758619Ab3B0L33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 06:29:29 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, rickard.andersson@stericsson.com,
        fabio.baltieri@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/3] cpufreq: ondemand: Don't update sample_type if we don't evaluate load again
Date: Wed, 27 Feb 2013 16:59:11 +0530
Message-Id: <d7420494c2b37fa34869a38f09abe3f8c4575448.1361964515.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <5249868a014d716eb38cc90e04ed0f6051e65fc3.1361964515.git.viresh.kumar@linaro.org>
References: <5249868a014d716eb38cc90e04ed0f6051e65fc3.1361964515.git.viresh.kumar@linaro.org>
In-Reply-To: <5249868a014d716eb38cc90e04ed0f6051e65fc3.1361964515.git.viresh.kumar@linaro.org>
References: <5249868a014d716eb38cc90e04ed0f6051e65fc3.1361964515.git.viresh.kumar@linaro.org>
X-OriginalArrivalTime: 27 Feb 2013 11:29:26.0065 (UTC) FILETIME=[B2D05A10:01CE14DD]
X-MC-Unique: 113022711292713801
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r1RBTmdm006736

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
index f3eb26c..a815c88 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -223,34 +223,32 @@ static void od_dbs_timer(struct work_struct *work)
 	unsigned int cpu = dbs_info->cdbs.cur_policy->cpu;
 	struct od_cpu_dbs_info_s *core_dbs_info = &per_cpu(od_cpu_dbs_info,
 			cpu);
-	int delay, sample_type = core_dbs_info->sample_type;
-	bool eval_load;
+	int delay = 0, sample_type = core_dbs_info->sample_type;
 
 	mutex_lock(&core_dbs_info->cdbs.timer_mutex);
-	eval_load = need_load_eval(&core_dbs_info->cdbs,
-			od_tuners.sampling_rate);
+	if (!need_load_eval(&core_dbs_info->cdbs, od_tuners.sampling_rate))
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
-			dbs_check_cpu(&od_dbs_data, cpu);
+		dbs_check_cpu(&od_dbs_data, cpu);
 		if (core_dbs_info->freq_lo) {
 			/* Setup timer for SUB_SAMPLE */
 			core_dbs_info->sample_type = OD_SUB_SAMPLE;
 			delay = core_dbs_info->freq_hi_jiffies;
-		} else {
-			delay = delay_for_sampling_rate(od_tuners.sampling_rate
-						* core_dbs_info->rate_mult);
 		}
 	}
 
+max_delay:
+	if (!delay)
+		delay = delay_for_sampling_rate(od_tuners.sampling_rate
+				* core_dbs_info->rate_mult);
+
 	schedule_delayed_work_on(smp_processor_id(), dw, delay);
 	mutex_unlock(&core_dbs_info->cdbs.timer_mutex);
 }
-- 
1.7.12.rc2.18.g61b472e


