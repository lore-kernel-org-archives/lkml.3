Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbaFIFYz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 01:24:55 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:34357 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbaFIFYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 01:24:52 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        srivatsa.bhat@linux.vnet.ibm.com, svaidy@linux.vnet.ibm.com,
        ego@linux.vnet.ibm.com, pavel@ucw.cz,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] cpufreq: governor: remove copy_prev_load from 'struct cpu_dbs_common_info'
Date: Mon,  9 Jun 2014 10:54:17 +0530
Message-Id: <d4241c6ef57c901dde270380cce74e24effa4852.1402291351.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'copy_prev_load' was recently added by commit: 18b46ab (cpufreq: governor: Be
friendly towards latency-sensitive bursty workloads).

It actually is a bit redundant as we also have 'prev_load' which can store any
integer value and can be used instead of 'copy_prev_load' by setting it to zero
when we don't want to use previous load.

So, drop 'copy_prev_load' and use 'prev_load' instead.

Update comments as well to make it more clear.

There is another change here which was probably missed by Srivatsa during the
last version of updates he made. The unlikely in the 'if' statement was covering
only half of the condition and the whole line should actually come under it.

Also checkpatch is made more silent as it was reporting this (--strict option):

CHECK: Alignment should match open parenthesis
+		if (unlikely(wall_time > (2 * sampling_rate) &&
+						j_cdbs->prev_load)) {

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq_governor.c | 13 ++++++++-----
 drivers/cpufreq/cpufreq_governor.h |  8 ++++----
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index 9004450..a1ad804 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -132,14 +132,18 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
 		 * an unusually large 'wall_time' (as compared to the sampling
 		 * rate) indicates this scenario.
 		 */
-		if (unlikely(wall_time > (2 * sampling_rate)) &&
-						j_cdbs->copy_prev_load) {
+		if (unlikely(wall_time > (2 * sampling_rate) &&
+			     j_cdbs->prev_load)) {
 			load = j_cdbs->prev_load;
-			j_cdbs->copy_prev_load = false;
+
+			/*
+			 * Ensure that we copy the previous load only once, upon
+			 * the first wake-up from idle.
+			 */
+			j_cdbs->prev_load = 0;
 		} else {
 			load = 100 * (wall_time - idle_time) / wall_time;
 			j_cdbs->prev_load = load;
-			j_cdbs->copy_prev_load = true;
 		}
 
 		if (load > max_load)
@@ -373,7 +377,6 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 				(j_cdbs->prev_cpu_wall - j_cdbs->prev_cpu_idle);
 			j_cdbs->prev_load = 100 * prev_load /
 					(unsigned int) j_cdbs->prev_cpu_wall;
-			j_cdbs->copy_prev_load = true;
 
 			if (ignore_nice)
 				j_cdbs->prev_cpu_nice =
diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
index c2a5b7e..d3082ee 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -134,12 +134,12 @@ struct cpu_dbs_common_info {
 	u64 prev_cpu_idle;
 	u64 prev_cpu_wall;
 	u64 prev_cpu_nice;
-	unsigned int prev_load;
 	/*
-	 * Flag to ensure that we copy the previous load only once, upon the
-	 * first wake-up from idle.
+	 * Used to store system load before going into idle, when set to zero:
+	 * used as a flag to ensure that we copy the previous load only once,
+	 * upon the first wake-up from idle.
 	 */
-	bool copy_prev_load;
+	unsigned int prev_load;
 	struct cpufreq_policy *cur_policy;
 	struct delayed_work work;
 	/*
-- 
2.0.0.rc2

