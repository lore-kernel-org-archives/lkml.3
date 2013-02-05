Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723Ab3BEVEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 16:04:40 -0500
Received: from sema.semaphore.gr ([78.46.194.137]:46964 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755778Ab3BEVEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 16:04:35 -0500
Message-ID: <511173DF.8060308@semaphore.gr>
Date: Tue, 05 Feb 2013 23:04:31 +0200
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] cpufreq: ondemand: Replace down_differential tuner with adj_up_threshold
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to avoid the calculation of up_threshold - down_differential
every time that the frequency must be decreased, we replace the
down_differential tuner with the adj_up_threshold which keeps the
difference across multiple checks.

Update the adj_up_threshold only when the up_theshold is also updated.

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 drivers/cpufreq/cpufreq_governor.h |  2 +-
 drivers/cpufreq/cpufreq_ondemand.c | 16 ++++++++++------
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
index f661654..4250944 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -108,7 +108,7 @@ struct od_dbs_tuners {
 	unsigned int sampling_rate;
 	unsigned int sampling_down_factor;
 	unsigned int up_threshold;
-	unsigned int down_differential;
+	unsigned int adj_up_threshold;
 	unsigned int powersave_bias;
 	unsigned int io_is_busy;
 };
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 7731f7c..2cc76ad 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -47,7 +47,8 @@ static struct cpufreq_governor cpufreq_gov_ondemand;
 static struct od_dbs_tuners od_tuners = {
 	.up_threshold = DEF_FREQUENCY_UP_THRESHOLD,
 	.sampling_down_factor = DEF_SAMPLING_DOWN_FACTOR,
-	.down_differential = DEF_FREQUENCY_DOWN_DIFFERENTIAL,
+	.adj_up_threshold = DEF_FREQUENCY_UP_THRESHOLD -
+			    DEF_FREQUENCY_DOWN_DIFFERENTIAL,
 	.ignore_nice = 0,
 	.powersave_bias = 0,
 };
@@ -192,11 +193,9 @@ static void od_check_cpu(int cpu, unsigned int load_freq)
 	 * support the current CPU usage without triggering the up policy. To be
 	 * safe, we focus 10 points under the threshold.
 	 */
-	if (load_freq < (od_tuners.up_threshold - od_tuners.down_differential) *
-			policy->cur) {
+	if (load_freq < od_tuners.adj_up_threshold * policy->cur) {
 		unsigned int freq_next;
-		freq_next = load_freq / (od_tuners.up_threshold -
-				od_tuners.down_differential);
+		freq_next = load_freq / od_tuners.adj_up_threshold;
 
 		/* No longer fully busy, reset rate_mult */
 		dbs_info->rate_mult = 1;
@@ -351,6 +350,10 @@ static ssize_t store_up_threshold(struct kobject *a, struct attribute *b,
 			input < MIN_FREQUENCY_UP_THRESHOLD) {
 		return -EINVAL;
 	}
+	/* Calculate the new adj_up_threshold */
+	od_tuners.adj_up_threshold += input;
+	od_tuners.adj_up_threshold -= od_tuners.up_threshold;
+
 	od_tuners.up_threshold = input;
 	return count;
 }
@@ -507,7 +510,8 @@ static int __init cpufreq_gov_dbs_init(void)
 	if (idle_time != -1ULL) {
 		/* Idle micro accounting is supported. Use finer thresholds */
 		od_tuners.up_threshold = MICRO_FREQUENCY_UP_THRESHOLD;
-		od_tuners.down_differential = MICRO_FREQUENCY_DOWN_DIFFERENTIAL;
+		od_tuners.adj_up_threshold = MICRO_FREQUENCY_UP_THRESHOLD -
+					     MICRO_FREQUENCY_DOWN_DIFFERENTIAL;
 		/*
 		 * In nohz/micro accounting case we set the minimum frequency
 		 * not depending on HZ, but fixed (very low). The deferred
-- 
1.8.1

