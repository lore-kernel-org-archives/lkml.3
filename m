Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab3A3NBD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 08:01:03 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:43909 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969Ab3A3NA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 08:00:56 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, swarren@wwwdotorg.org,
        linaro-dev@lists.linaro.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        mathieu.poirier@linaro.org, Joseph Lo <josephl@nvidia.com>,
        linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH v7 3/4] cpufreq: conservative: call dbs_check_cpu only when necessary
Date: Wed, 30 Jan 2013 14:00:02 +0100
Message-Id: <1359550803-18577-4-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1359550803-18577-1-git-send-email-fabio.baltieri@linaro.org>
References: <1359550803-18577-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify conservative timer to not resample CPU utilization if recently
sampled from another SW coordinated core.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/cpufreq/cpufreq_conservative.c | 47 +++++++++++++++++++++++++++++-----
 1 file changed, 41 insertions(+), 6 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index b9d7f14..5d8e894 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -111,22 +111,57 @@ static void cs_check_cpu(int cpu, unsigned int load)
 	}
 }
 
-static void cs_dbs_timer(struct work_struct *work)
+static void cs_timer_update(struct cs_cpu_dbs_info_s *dbs_info, bool sample,
+			    struct delayed_work *dw)
 {
-	struct cs_cpu_dbs_info_s *dbs_info = container_of(work,
-			struct cs_cpu_dbs_info_s, cdbs.work.work);
 	unsigned int cpu = dbs_info->cdbs.cpu;
 	int delay = delay_for_sampling_rate(cs_tuners.sampling_rate);
 
+	if (sample)
+		dbs_check_cpu(&cs_dbs_data, cpu);
+
+	schedule_delayed_work_on(smp_processor_id(), dw, delay);
+}
+
+static void cs_timer_coordinated(struct cs_cpu_dbs_info_s *dbs_info_local,
+				 struct delayed_work *dw)
+{
+	struct cs_cpu_dbs_info_s *dbs_info;
+	ktime_t time_now;
+	s64 delta_us;
+	bool sample = true;
+
+	/* use leader CPU's dbs_info */
+	dbs_info = &per_cpu(cs_cpu_dbs_info, dbs_info_local->cdbs.cpu);
 	mutex_lock(&dbs_info->cdbs.timer_mutex);
 
-	dbs_check_cpu(&cs_dbs_data, cpu);
+	time_now = ktime_get();
+	delta_us = ktime_us_delta(time_now, dbs_info->cdbs.time_stamp);
 
-	schedule_delayed_work_on(smp_processor_id(), &dbs_info->cdbs.work,
-			delay);
+	/* Do nothing if we recently have sampled */
+	if (delta_us < (s64)(cs_tuners.sampling_rate / 2))
+		sample = false;
+	else
+		dbs_info->cdbs.time_stamp = time_now;
+
+	cs_timer_update(dbs_info, sample, dw);
 	mutex_unlock(&dbs_info->cdbs.timer_mutex);
 }
 
+static void cs_dbs_timer(struct work_struct *work)
+{
+	struct delayed_work *dw = to_delayed_work(work);
+	struct cs_cpu_dbs_info_s *dbs_info = container_of(work,
+			struct cs_cpu_dbs_info_s, cdbs.work.work);
+
+	if (dbs_sw_coordinated_cpus(&dbs_info->cdbs)) {
+		cs_timer_coordinated(dbs_info, dw);
+	} else {
+		mutex_lock(&dbs_info->cdbs.timer_mutex);
+		cs_timer_update(dbs_info, true, dw);
+		mutex_unlock(&dbs_info->cdbs.timer_mutex);
+	}
+}
 static int dbs_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
 		void *data)
 {
-- 
1.7.12.1

