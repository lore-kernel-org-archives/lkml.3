Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab3AaKji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 05:39:38 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:59894 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab3AaKjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 05:39:35 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH] cpufreq: governors: fix misuse of cdbs.cpu
Date: Thu, 31 Jan 2013 11:39:19 +0100
Message-Id: <1359628759-15006-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix governors code to set all cpu's cdbs->cpu to the the actual cpu id
and use cur_policy->cpu istead of cdbs->cpu to track current governor's
leader cpu.

Reported-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/cpufreq/cpufreq_conservative.c | 5 +++--
 drivers/cpufreq/cpufreq_governor.c     | 2 +-
 drivers/cpufreq/cpufreq_ondemand.c     | 5 +++--
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index 653fb06..c18a304 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -114,7 +114,7 @@ static void cs_check_cpu(int cpu, unsigned int load)
 static void cs_timer_update(struct cs_cpu_dbs_info_s *dbs_info, bool sample,
 			    struct delayed_work *dw)
 {
-	unsigned int cpu = dbs_info->cdbs.cpu;
+	unsigned int cpu = dbs_info->cdbs.cur_policy->cpu;
 	int delay = delay_for_sampling_rate(cs_tuners.sampling_rate);
 
 	if (sample)
@@ -132,7 +132,8 @@ static void cs_timer_coordinated(struct cs_cpu_dbs_info_s *dbs_info_local,
 	bool sample = true;
 
 	/* use leader CPU's dbs_info */
-	dbs_info = &per_cpu(cs_cpu_dbs_info, dbs_info_local->cdbs.cpu);
+	dbs_info = &per_cpu(cs_cpu_dbs_info,
+			    dbs_info_local->cdbs.cur_policy->cpu);
 	mutex_lock(&dbs_info->cdbs.timer_mutex);
 
 	time_now = ktime_get();
diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index 67e235a..46f1c78 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -208,11 +208,11 @@ int cpufreq_governor_dbs(struct dbs_data *dbs_data,
 		mutex_lock(&dbs_data->mutex);
 
 		dbs_data->enable++;
-		cpu_cdbs->cpu = cpu;
 		for_each_cpu(j, policy->cpus) {
 			struct cpu_dbs_common_info *j_cdbs;
 			j_cdbs = dbs_data->get_cpu_cdbs(j);
 
+			j_cdbs->cpu = j;
 			j_cdbs->cur_policy = policy;
 			j_cdbs->prev_cpu_idle = get_cpu_idle_time(j,
 					&j_cdbs->prev_cpu_wall);
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 5ae84ff..75efd5e 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -219,7 +219,7 @@ static void od_check_cpu(int cpu, unsigned int load_freq)
 static void od_timer_update(struct od_cpu_dbs_info_s *dbs_info, bool sample,
 			    struct delayed_work *dw)
 {
-	unsigned int cpu = dbs_info->cdbs.cpu;
+	unsigned int cpu = dbs_info->cdbs.cur_policy->cpu;
 	int delay, sample_type = dbs_info->sample_type;
 
 	/* Common NORMAL_SAMPLE setup */
@@ -255,7 +255,8 @@ static void od_timer_coordinated(struct od_cpu_dbs_info_s *dbs_info_local,
 	bool sample = true;
 
 	/* use leader CPU's dbs_info */
-	dbs_info = &per_cpu(od_cpu_dbs_info, dbs_info_local->cdbs.cpu);
+	dbs_info = &per_cpu(od_cpu_dbs_info,
+			    dbs_info_local->cdbs.cur_policy->cpu);
 	mutex_lock(&dbs_info->cdbs.timer_mutex);
 
 	time_now = ktime_get();
-- 
1.7.12.1

