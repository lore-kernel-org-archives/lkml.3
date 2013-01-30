Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab3A3Nx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 08:53:58 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:58355 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449Ab3A3Nxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 08:53:55 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, swarren@wwwdotorg.org,
        linaro-dev@lists.linaro.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        mathieu.poirier@linaro.org, Joseph Lo <josephl@nvidia.com>,
        linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH] cpufreq: governors: clean timer init and exit code
Date: Wed, 30 Jan 2013 14:53:37 +0100
Message-Id: <1359554017-28620-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop unused arguments from dbs_timer_init and clean dbs_timer_exit and
cpufreq_governor_dbs to remove non necessary special cases.

Reported-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---

Hello Rafael,

that's the cleanup on top of "cpufreq: handle SW coordinated CPUs".

Thanks,
Fabio

 drivers/cpufreq/cpufreq_governor.c | 43 ++++++++++++--------------------------
 1 file changed, 13 insertions(+), 30 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index ee8b7ca..46f96a4 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -169,19 +169,19 @@ bool dbs_sw_coordinated_cpus(struct cpu_dbs_common_info *cdbs)
 }
 EXPORT_SYMBOL_GPL(dbs_sw_coordinated_cpus);
 
-static inline void dbs_timer_init(struct dbs_data *dbs_data,
-				  struct cpu_dbs_common_info *cdbs,
-				  unsigned int sampling_rate,
-				  int cpu)
+static inline void dbs_timer_init(struct dbs_data *dbs_data, int cpu,
+				  unsigned int sampling_rate)
 {
 	int delay = delay_for_sampling_rate(sampling_rate);
-	struct cpu_dbs_common_info *cdbs_local = dbs_data->get_cpu_cdbs(cpu);
+	struct cpu_dbs_common_info *cdbs = dbs_data->get_cpu_cdbs(cpu);
 
-	schedule_delayed_work_on(cpu, &cdbs_local->work, delay);
+	schedule_delayed_work_on(cpu, &cdbs->work, delay);
 }
 
-static inline void dbs_timer_exit(struct cpu_dbs_common_info *cdbs)
+static inline void dbs_timer_exit(struct dbs_data *dbs_data, int cpu)
 {
+	struct cpu_dbs_common_info *cdbs = dbs_data->get_cpu_cdbs(cpu);
+
 	cancel_delayed_work_sync(&cdbs->work);
 }
 
@@ -289,36 +289,19 @@ second_time:
 		}
 		mutex_unlock(&dbs_data->mutex);
 
-		if (dbs_sw_coordinated_cpus(cpu_cdbs)) {
-			/* Initiate timer time stamp */
-			cpu_cdbs->time_stamp = ktime_get();
+		/* Initiate timer time stamp */
+		cpu_cdbs->time_stamp = ktime_get();
 
-			for_each_cpu(j, policy->cpus) {
-				struct cpu_dbs_common_info *j_cdbs;
-
-				j_cdbs = dbs_data->get_cpu_cdbs(j);
-				dbs_timer_init(dbs_data, j_cdbs,
-					       *sampling_rate, j);
-			}
-		} else {
-			dbs_timer_init(dbs_data, cpu_cdbs, *sampling_rate, cpu);
-		}
+		for_each_cpu(j, policy->cpus)
+			dbs_timer_init(dbs_data, j, *sampling_rate);
 		break;
 
 	case CPUFREQ_GOV_STOP:
 		if (dbs_data->governor == GOV_CONSERVATIVE)
 			cs_dbs_info->enable = 0;
 
-		if (dbs_sw_coordinated_cpus(cpu_cdbs)) {
-			for_each_cpu(j, policy->cpus) {
-				struct cpu_dbs_common_info *j_cdbs;
-
-				j_cdbs = dbs_data->get_cpu_cdbs(j);
-				dbs_timer_exit(j_cdbs);
-			}
-		} else {
-			dbs_timer_exit(cpu_cdbs);
-		}
+		for_each_cpu(j, policy->cpus)
+			dbs_timer_exit(dbs_data, j);
 
 		mutex_lock(&dbs_data->mutex);
 		mutex_destroy(&cpu_cdbs->timer_mutex);
-- 
1.7.12.1

