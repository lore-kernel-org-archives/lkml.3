Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935401Ab3BTUug (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 15:50:36 -0500
Received: from sema.semaphore.gr ([78.46.194.137]:43165 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S935134Ab3BTUue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 15:50:34 -0500
Message-ID: <51253715.7080600@semaphore.gr>
Date: Wed, 20 Feb 2013 22:50:29 +0200
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH linux-next] cpufreq: ondemand: Calculate gradient of CPU load
 to early increase frequency
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of checking only the absolute value of CPU load_freq to increase
frequency, we detect forthcoming CPU load rise and increase frequency
earlier.

Every sampling rate, we calculate the gradient of load_freq.
If it is too steep we assume that the load most probably will
go over up_threshold in next iteration(s). We reduce up_threshold
by early_differential to achieve frequency increase in the current
iteration.

A new tuner early_demand is introduced to enable this functionality
(disabled by default). Also we use new tuners to control early demand:

	- early_differential: controls the final up_threshold
	- grad_up_threshold: over this gradient of load we will decrease
		up_threshold by early_differential.

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 drivers/cpufreq/cpufreq_governor.c |  1 +
 drivers/cpufreq/cpufreq_governor.h |  4 ++++
 drivers/cpufreq/cpufreq_ondemand.c | 41 +++++++++++++++++++++++++++++++++++++-
 3 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index 5a76086..348cb80 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -276,6 +276,7 @@ int cpufreq_governor_dbs(struct dbs_data *dbs_data,
 		} else {
 			od_dbs_info->rate_mult = 1;
 			od_dbs_info->sample_type = OD_NORMAL_SAMPLE;
+			od_dbs_info->prev_load_freq = 0;
 			od_ops->powersave_bias_init_cpu(cpu);
 
 			if (!policy->governor->initialized)
diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
index d2ac911..d1425a7 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -94,6 +94,7 @@ struct od_cpu_dbs_info_s {
 	unsigned int freq_hi_jiffies;
 	unsigned int rate_mult;
 	unsigned int sample_type:1;
+	unsigned int prev_load_freq;
 };
 
 struct cs_cpu_dbs_info_s {
@@ -112,6 +113,9 @@ struct od_dbs_tuners {
 	unsigned int adj_up_threshold;
 	unsigned int powersave_bias;
 	unsigned int io_is_busy;
+	unsigned int early_differential;
+	unsigned int grad_up_threshold;
+	unsigned int early_demand;
 };
 
 struct cs_dbs_tuners {
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index f3eb26c..458806f 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -30,6 +30,8 @@
 #define DEF_FREQUENCY_DOWN_DIFFERENTIAL		(10)
 #define DEF_FREQUENCY_UP_THRESHOLD		(80)
 #define DEF_SAMPLING_DOWN_FACTOR		(1)
+#define DEF_GRAD_UP_THESHOLD			(50)
+#define DEF_EARLY_DIFFERENTIAL			(45)
 #define MAX_SAMPLING_DOWN_FACTOR		(100000)
 #define MICRO_FREQUENCY_DOWN_DIFFERENTIAL	(3)
 #define MICRO_FREQUENCY_UP_THRESHOLD		(95)
@@ -49,8 +51,11 @@ static struct od_dbs_tuners od_tuners = {
 	.sampling_down_factor = DEF_SAMPLING_DOWN_FACTOR,
 	.adj_up_threshold = DEF_FREQUENCY_UP_THRESHOLD -
 			    DEF_FREQUENCY_DOWN_DIFFERENTIAL,
+	.early_differential = DEF_EARLY_DIFFERENTIAL,
+	.grad_up_threshold = DEF_GRAD_UP_THESHOLD,
 	.ignore_nice = 0,
 	.powersave_bias = 0,
+	.early_demand = 0,
 };
 
 static void ondemand_powersave_bias_init_cpu(int cpu)
@@ -170,11 +175,29 @@ static void od_check_cpu(int cpu, unsigned int load_freq)
 {
 	struct od_cpu_dbs_info_s *dbs_info = &per_cpu(od_cpu_dbs_info, cpu);
 	struct cpufreq_policy *policy = dbs_info->cdbs.cur_policy;
+	unsigned int up_threshold = od_tuners.up_threshold;
+	unsigned int grad;
 
 	dbs_info->freq_lo = 0;
 
+	/*
+	 * Calculate the gradient of load_freq. If it is too steep we assume
+	 * that the load will go over up_threshold in next iteration(s). We
+	 * reduce up_threshold by early_differential to achieve frequency
+	 * increase earlier
+	 */
+	if (od_tuners.early_demand) {
+		if (load_freq > dbs_info->prev_load_freq) {
+			grad = load_freq - dbs_info->prev_load_freq;
+
+			if (grad > od_tuners.grad_up_threshold * policy->cur)
+				up_threshold -= od_tuners.early_differential;
+		}
+		dbs_info->prev_load_freq = load_freq;
+	}
+
 	/* Check for frequency increase */
-	if (load_freq > od_tuners.up_threshold * policy->cur) {
+	if (load_freq > up_threshold * policy->cur) {
 		/* If switching to max speed, apply sampling_down_factor */
 		if (policy->cur < policy->max)
 			dbs_info->rate_mult =
@@ -438,12 +461,26 @@ static ssize_t store_powersave_bias(struct kobject *a, struct attribute *b,
 	return count;
 }
 
+static ssize_t store_early_demand(struct kobject *a, struct attribute *b,
+				  const char *buf, size_t count)
+{
+	unsigned int input;
+	int ret;
+
+	ret = sscanf(buf, "%u", &input);
+	if (ret != 1)
+		return -EINVAL;
+	od_tuners.early_demand = !!input;
+	return count;
+}
+
 show_one(od, sampling_rate, sampling_rate);
 show_one(od, io_is_busy, io_is_busy);
 show_one(od, up_threshold, up_threshold);
 show_one(od, sampling_down_factor, sampling_down_factor);
 show_one(od, ignore_nice_load, ignore_nice);
 show_one(od, powersave_bias, powersave_bias);
+show_one(od, early_demand, early_demand);
 
 define_one_global_rw(sampling_rate);
 define_one_global_rw(io_is_busy);
@@ -452,6 +489,7 @@ define_one_global_rw(sampling_down_factor);
 define_one_global_rw(ignore_nice_load);
 define_one_global_rw(powersave_bias);
 define_one_global_ro(sampling_rate_min);
+define_one_global_rw(early_demand);
 
 static struct attribute *dbs_attributes[] = {
 	&sampling_rate_min.attr,
@@ -461,6 +499,7 @@ static struct attribute *dbs_attributes[] = {
 	&ignore_nice_load.attr,
 	&powersave_bias.attr,
 	&io_is_busy.attr,
+	&early_demand.attr,
 	NULL
 };
 
-- 
1.8.1.2

