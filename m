Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270Ab3C2W1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 18:27:40 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:48494 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757084Ab3C2W1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 18:27:38 -0400
Message-ID: <51561556.7020904@semaphore.gr>
Date: Sat, 30 Mar 2013 00:27:34 +0200
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 linux-next] cpufreq: ondemand: Calculate gradient of
 CPU load to early increase frequency
References: <51253715.7080600@semaphore.gr> <CAOh2x=mD4DbEH245xsceS1wyhmrRPpB2LeJ9Mh+WGHUA+bZprA@mail.gmail.com> <512605A1.8090106@semaphore.gr> <CAOh2x=m82jKMf+xgg+fjnCUHLpCQ_NgYqw4auyAidokt_z=uOw@mail.gmail.com> <51265BC6.8030601@semaphore.gr> <CAKohpokKCrvMYWQCRWccDJHbBNO7km5-vP=d3TwhDyU7HGX-YA@mail.gmail.com>
In-Reply-To: <CAKohpokKCrvMYWQCRWccDJHbBNO7km5-vP=d3TwhDyU7HGX-YA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2013 03:56 AM, Viresh Kumar wrote:
> On 21 February 2013 23:09, Stratos Karafotis <stratosk@semaphore.gr> wrote:
>
>> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> 

Hi Rafael,

In case you are interested in this patch I rebased it to the latest linux-pm/bleeding-edge.

Thanks,
Stratos

------------------------------------------
Instead of checking only the absolute value of CPU load_freq to increase
frequency, we detect forthcoming CPU load rise and increase frequency
earlier.

Every sampling rate, we calculate the gradient of load_freq. If it is
too steep we assume that the load most probably will go over
up_threshold in next iteration(s) and we increase frequency immediately.

New tuners are introduced:
- early_demand: to enable this functionality (disabled by default).
- grad_up_threshold: over this gradient of load we will increase
frequency immediately.

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 drivers/cpufreq/cpufreq_governor.c |  1 +
 drivers/cpufreq/cpufreq_governor.h |  3 ++
 drivers/cpufreq/cpufreq_ondemand.c | 59 +++++++++++++++++++++++++++++++++++++-
 3 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index 41e5e56..1d9abc4 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -328,6 +328,7 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 		} else {
 			od_dbs_info->rate_mult = 1;
 			od_dbs_info->sample_type = OD_NORMAL_SAMPLE;
+			od_dbs_info->prev_load_freq = 0;
 			od_ops->powersave_bias_init_cpu(cpu);
 		}
 
diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
index 1f7de13..c33b37a 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -95,6 +95,7 @@ struct od_cpu_dbs_info_s {
 	unsigned int freq_hi_jiffies;
 	unsigned int rate_mult;
 	unsigned int sample_type:1;
+	unsigned int prev_load_freq;
 };
 
 struct cs_cpu_dbs_info_s {
@@ -113,6 +114,8 @@ struct od_dbs_tuners {
 	unsigned int adj_up_threshold;
 	unsigned int powersave_bias;
 	unsigned int io_is_busy;
+	unsigned int grad_up_threshold;
+	unsigned int early_demand;
 };
 
 struct cs_dbs_tuners {
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 29ed48a..6cd59a7 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -31,6 +31,7 @@
 #define DEF_FREQUENCY_DOWN_DIFFERENTIAL		(10)
 #define DEF_FREQUENCY_UP_THRESHOLD		(80)
 #define DEF_SAMPLING_DOWN_FACTOR		(1)
+#define DEF_GRAD_UP_THRESHOLD			(50)
 #define MAX_SAMPLING_DOWN_FACTOR		(100000)
 #define MICRO_FREQUENCY_DOWN_DIFFERENTIAL	(3)
 #define MICRO_FREQUENCY_UP_THRESHOLD		(95)
@@ -168,11 +169,26 @@ static void od_check_cpu(int cpu, unsigned int load_freq)
 	struct cpufreq_policy *policy = dbs_info->cdbs.cur_policy;
 	struct dbs_data *dbs_data = policy->governor_data;
 	struct od_dbs_tuners *od_tuners = dbs_data->tuners;
+	int boost_freq = 0;
 
 	dbs_info->freq_lo = 0;
 
+	/*
+	 * Calculate the gradient of load_freq. If it is too steep we assume
+	 * that the load will go over up_threshold in next iteration(s) and
+	 * we increase the frequency immediately
+	 */
+	if (od_tuners->early_demand) {
+		if (load_freq > dbs_info->prev_load_freq &&
+		   (load_freq - dbs_info->prev_load_freq >
+		    od_tuners->grad_up_threshold * policy->cur))
+			boost_freq = 1;
+
+		dbs_info->prev_load_freq = load_freq;
+	}
+
 	/* Check for frequency increase */
-	if (load_freq > od_tuners->up_threshold * policy->cur) {
+	if (boost_freq || load_freq > od_tuners->up_threshold * policy->cur) {
 		/* If switching to max speed, apply sampling_down_factor */
 		if (policy->cur < policy->max)
 			dbs_info->rate_mult =
@@ -454,12 +470,47 @@ static ssize_t store_powersave_bias(struct cpufreq_policy *policy,
 	return count;
 }
 
+static ssize_t store_grad_up_threshold(struct cpufreq_policy *policy,
+		const char *buf, size_t count)
+{
+	struct dbs_data *dbs_data = policy->governor_data;
+	struct od_dbs_tuners *od_tuners = dbs_data->tuners;
+	unsigned int input;
+	int ret;
+	ret = sscanf(buf, "%u", &input);
+
+	if (ret != 1 || input > MAX_FREQUENCY_UP_THRESHOLD ||
+			input < MIN_FREQUENCY_UP_THRESHOLD) {
+		return -EINVAL;
+	}
+
+	od_tuners->grad_up_threshold = input;
+	return count;
+}
+
+static ssize_t store_early_demand(struct cpufreq_policy *policy,
+		const char *buf, size_t count)
+{
+	struct dbs_data *dbs_data = policy->governor_data;
+	struct od_dbs_tuners *od_tuners = dbs_data->tuners;
+	unsigned int input;
+	int ret;
+
+	ret = sscanf(buf, "%u", &input);
+	if (ret != 1)
+		return -EINVAL;
+	od_tuners->early_demand = !!input;
+	return count;
+}
+
 show_one(od, sampling_rate, sampling_rate);
 show_one(od, io_is_busy, io_is_busy);
 show_one(od, up_threshold, up_threshold);
 show_one(od, sampling_down_factor, sampling_down_factor);
 show_one(od, ignore_nice, ignore_nice);
 show_one(od, powersave_bias, powersave_bias);
+show_one(od, grad_up_threshold, grad_up_threshold);
+show_one(od, early_demand, early_demand);
 declare_show_sampling_rate_min();
 
 cpufreq_freq_attr_rw(sampling_rate);
@@ -468,6 +519,8 @@ cpufreq_freq_attr_rw(up_threshold);
 cpufreq_freq_attr_rw(sampling_down_factor);
 cpufreq_freq_attr_rw(ignore_nice);
 cpufreq_freq_attr_rw(powersave_bias);
+cpufreq_freq_attr_rw(grad_up_threshold);
+cpufreq_freq_attr_rw(early_demand);
 cpufreq_freq_attr_ro(sampling_rate_min);
 
 static struct attribute *dbs_attributes[] = {
@@ -478,6 +531,8 @@ static struct attribute *dbs_attributes[] = {
 	&ignore_nice.attr,
 	&powersave_bias.attr,
 	&io_is_busy.attr,
+	&grad_up_threshold.attr,
+	&early_demand.attr,
 	NULL
 };
 
@@ -525,9 +580,11 @@ static int od_init(struct dbs_data *dbs_data)
 	}
 
 	tuners->sampling_down_factor = DEF_SAMPLING_DOWN_FACTOR;
+	tuners->grad_up_threshold = DEF_GRAD_UP_THRESHOLD;
 	tuners->ignore_nice = 0;
 	tuners->powersave_bias = 0;
 	tuners->io_is_busy = should_io_be_busy();
+	tuners->early_demand = 0;
 
 	dbs_data->tuners = tuners;
 	mutex_init(&dbs_data->mutex);
-- 
1.8.1.4


