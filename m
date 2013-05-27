Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692Ab3E0UtY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 16:49:24 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:38637 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757527Ab3E0UtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 16:49:22 -0400
Message-ID: <51A3C6CF.6080104@semaphore.gr>
Date: Mon, 27 May 2013 23:49:19 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>
CC: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH] cpufreq: ondemand: Increase frequency to any value proportional
 to load
Content-Type: multipart/mixed;
 boundary="------------060007010208090601050100"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060007010208090601050100
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Ondemand increases frequency only if the load_freq is greater than
up_threshold. This seems to produce oscillations of frequency between
min and max because a relatively small load can easily saturate minimum
frequency and lead the CPU to max. Then, the CPU will decrease back to
min due to a small load_freq.

With this patch the frequency can be increased to any value,
proportional to load, if the load is below up_threshold. Thus, middle
frequencies are used more. Absolute load is used for the calculation of
frequency.

Phoronix benchmark results of Linux Kernel Compilation 3.1 tests are
attached with and without this patch. cpufreq_stats (time_in_state) are
also included. Tested on Intel i7-3770 CPU @ 3.40GH and on 
Quad core 1500 MHz Krait.

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 drivers/cpufreq/cpufreq_governor.c | 10 +---------
 drivers/cpufreq/cpufreq_governor.h |  1 -
 drivers/cpufreq/cpufreq_ondemand.c | 39 ++++++++------------------------------
 3 files changed, 9 insertions(+), 41 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index 5af40ad..eeab30a 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -97,7 +97,7 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
 
 	policy = cdbs->cur_policy;
 
-	/* Get Absolute Load (in terms of freq for ondemand gov) */
+	/* Get Absolute Load */
 	for_each_cpu(j, policy->cpus) {
 		struct cpu_dbs_common_info *j_cdbs;
 		u64 cur_wall_time, cur_idle_time;
@@ -148,14 +148,6 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
 
 		load = 100 * (wall_time - idle_time) / wall_time;
 
-		if (dbs_data->cdata->governor == GOV_ONDEMAND) {
-			int freq_avg = __cpufreq_driver_getavg(policy, j);
-			if (freq_avg <= 0)
-				freq_avg = policy->cur;
-
-			load *= freq_avg;
-		}
-
 		if (load > max_load)
 			max_load = load;
 	}
diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
index e16a961..e899c11 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -169,7 +169,6 @@ struct od_dbs_tuners {
 	unsigned int sampling_rate;
 	unsigned int sampling_down_factor;
 	unsigned int up_threshold;
-	unsigned int adj_up_threshold;
 	unsigned int powersave_bias;
 	unsigned int io_is_busy;
 };
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 4b9bb5d..bf2ae64 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -29,11 +29,9 @@
 #include "cpufreq_governor.h"
 
 /* On-demand governor macros */
-#define DEF_FREQUENCY_DOWN_DIFFERENTIAL		(10)
 #define DEF_FREQUENCY_UP_THRESHOLD		(80)
 #define DEF_SAMPLING_DOWN_FACTOR		(1)
 #define MAX_SAMPLING_DOWN_FACTOR		(100000)
-#define MICRO_FREQUENCY_DOWN_DIFFERENTIAL	(3)
 #define MICRO_FREQUENCY_UP_THRESHOLD		(95)
 #define MICRO_FREQUENCY_MIN_SAMPLE_RATE		(10000)
 #define MIN_FREQUENCY_UP_THRESHOLD		(11)
@@ -159,14 +157,12 @@ static void dbs_freq_increase(struct cpufreq_policy *p, unsigned int freq)
 
 /*
  * Every sampling_rate, we check, if current idle time is less than 20%
- * (default), then we try to increase frequency. Every sampling_rate, we look
- * for the lowest frequency which can sustain the load while keeping idle time
- * over 30%. If such a frequency exist, we try to decrease to this frequency.
+ * (default), then we try to increase frequency. Else, we adjust the frequency
+ * proportional to load.
  *
- * Any frequency increase takes it to the maximum frequency. Frequency reduction
- * happens at minimum steps of 5% (default) of current frequency
+ * Any frequency increase takes it to the maximum frequency.
  */
-static void od_check_cpu(int cpu, unsigned int load_freq)
+static void od_check_cpu(int cpu, unsigned int load)
 {
 	struct od_cpu_dbs_info_s *dbs_info = &per_cpu(od_cpu_dbs_info, cpu);
 	struct cpufreq_policy *policy = dbs_info->cdbs.cur_policy;
@@ -176,29 +172,17 @@ static void od_check_cpu(int cpu, unsigned int load_freq)
 	dbs_info->freq_lo = 0;
 
 	/* Check for frequency increase */
-	if (load_freq > od_tuners->up_threshold * policy->cur) {
+	if (load > od_tuners->up_threshold) {
 		/* If switching to max speed, apply sampling_down_factor */
 		if (policy->cur < policy->max)
 			dbs_info->rate_mult =
 				od_tuners->sampling_down_factor;
 		dbs_freq_increase(policy, policy->max);
 		return;
-	}
-
-	/* Check for frequency decrease */
-	/* if we cannot reduce the frequency anymore, break out early */
-	if (policy->cur == policy->min)
-		return;
-
-	/*
-	 * The optimal frequency is the frequency that is the lowest that can
-	 * support the current CPU usage without triggering the up policy. To be
-	 * safe, we focus 10 points under the threshold.
-	 */
-	if (load_freq < od_tuners->adj_up_threshold
-			* policy->cur) {
+	} else {
+		/* Calculate the next frequency proportional to load */
 		unsigned int freq_next;
-		freq_next = load_freq / od_tuners->adj_up_threshold;
+		freq_next = load * policy->max / 100;
 
 		/* No longer fully busy, reset rate_mult */
 		dbs_info->rate_mult = 1;
@@ -372,9 +356,6 @@ static ssize_t store_up_threshold(struct dbs_data *dbs_data, const char *buf,
 			input < MIN_FREQUENCY_UP_THRESHOLD) {
 		return -EINVAL;
 	}
-	/* Calculate the new adj_up_threshold */
-	od_tuners->adj_up_threshold += input;
-	od_tuners->adj_up_threshold -= od_tuners->up_threshold;
 
 	od_tuners->up_threshold = input;
 	return count;
@@ -523,8 +504,6 @@ static int od_init(struct dbs_data *dbs_data)
 	if (idle_time != -1ULL) {
 		/* Idle micro accounting is supported. Use finer thresholds */
 		tuners->up_threshold = MICRO_FREQUENCY_UP_THRESHOLD;
-		tuners->adj_up_threshold = MICRO_FREQUENCY_UP_THRESHOLD -
-			MICRO_FREQUENCY_DOWN_DIFFERENTIAL;
 		/*
 		 * In nohz/micro accounting case we set the minimum frequency
 		 * not depending on HZ, but fixed (very low). The deferred
@@ -533,8 +512,6 @@ static int od_init(struct dbs_data *dbs_data)
 		dbs_data->min_sampling_rate = MICRO_FREQUENCY_MIN_SAMPLE_RATE;
 	} else {
 		tuners->up_threshold = DEF_FREQUENCY_UP_THRESHOLD;
-		tuners->adj_up_threshold = DEF_FREQUENCY_UP_THRESHOLD -
-			DEF_FREQUENCY_DOWN_DIFFERENTIAL;
 
 		/* For correct statistics, we need 10 ticks for each measure */
 		dbs_data->min_sampling_rate = MIN_SAMPLING_RATE_RATIO *
-- 
1.8.1.4


--------------060007010208090601050100
Content-Type: text/plain; charset=UTF-8;
 name="test_results_with"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="test_results_with"

Timed Linux Kernel Compilation 3.1:
    pts/build-linux-kernel-1.3.0
    Test 1 of 1
    Estimated Trial Run Count:    3
    Estimated Time To Completion: 2 Minutes
        Running Pre-Test Script @ 22:39:56
        Started Run 1 @ 22:40:06
        Running Interim Test Script @ 22:40:20
        Started Run 2 @ 22:40:23
        Running Interim Test Script @ 22:40:33
        Started Run 3 @ 22:40:36
        Running Interim Test Script @ 22:40:46  [Std. Dev: 3.99%]
        Started Run 4 @ 22:40:49
        Running Interim Test Script @ 22:40:59  [Std. Dev: 3.73%]
        Started Run 5 @ 22:41:02
        Running Interim Test Script @ 22:41:12  [Std. Dev: 3.54%]
        Started Run 6 @ 22:41:15  [Std. Dev: 3.34%]
        Running Post-Test Script @ 22:41:25

    Test Results:
        10.175578832626
        9.4103870391846
        9.668200969696
        9.4109489917755
        9.3668100833893
        9.3667180538177

    Average: 9.57 Seconds


cpufreq_stats time_in_state

3401000 3340
3400000 0
3300000 27
3100000 17
3000000 14
2900000 8
2800000 17
2600000 7
2500000 8
2400000 10
2200000 5
2100000 7
2000000 8
1900000 28
1700000 5
1600000 5854


--------------060007010208090601050100
Content-Type: text/plain; charset=UTF-8;
 name="test_results_without"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="test_results_without"

Linux Kernel Compilation 3.1:
    pts/build-linux-kernel-1.3.0
    Test 1 of 1
    Estimated Trial Run Count:    3
    Estimated Time To Completion: 3 Minutes
        Running Pre-Test Script @ 22:28:26
        Started Run 1 @ 22:28:38
        Running Interim Test Script @ 22:28:51
        Started Run 2 @ 22:28:55
        Running Interim Test Script @ 22:29:05
        Started Run 3 @ 22:29:10
        Running Interim Test Script @ 22:29:20  [Std. Dev: 5.10%]
        Started Run 4 @ 22:29:23
        Running Interim Test Script @ 22:29:33  [Std. Dev: 4.73%]
        Started Run 5 @ 22:29:37
        Running Interim Test Script @ 22:29:46  [Std. Dev: 4.23%]
        Started Run 6 @ 22:29:50  [Std. Dev: 4.01%]
        Running Post-Test Script @ 22:30:00

    Test Results:
        10.521644830704
        9.7866048812866
        9.5475811958313
        9.5281581878662
        9.6297731399536
        9.497542142868

    Average: 9.75 Seconds


cpufreq_stats time_in_state

3401000 3594
3400000 3
3300000 10
3100000 6
3000000 3
2900000 5
2800000 7
2600000 3
2500000 2
2400000 18
2200000 6
2100000 1
2000000 2
1900000 64
1700000 2
1600000 6522


--------------060007010208090601050100--
