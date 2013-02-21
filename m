Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab3BULbx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 06:31:53 -0500
Received: from sema.semaphore.gr ([78.46.194.137]:47698 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752500Ab3BULbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 06:31:51 -0500
Message-ID: <512605A1.8090106@semaphore.gr>
Date: Thu, 21 Feb 2013 13:31:45 +0200
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 linux-next] cpufreq: ondemand: Calculate gradient of
 CPU load to early increase frequency
References: <51253715.7080600@semaphore.gr> <CAOh2x=mD4DbEH245xsceS1wyhmrRPpB2LeJ9Mh+WGHUA+bZprA@mail.gmail.com>
In-Reply-To: <CAOh2x=mD4DbEH245xsceS1wyhmrRPpB2LeJ9Mh+WGHUA+bZprA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

Thank you very much for your review and your suggestions.

On 02/21/2013 06:59 AM, Viresh Kumar wrote:
> Sorry for this but i already have a patchset which has changed these files
> to some extent. Can you please rebase over them? Actually my patchset
> is already accepted, its just that rafael didn't wanted to have them for 3.9.
> 
> http://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/cpufreq-for-3.10

No problem. I rebased the patch over your tree.

> So, probably you just don't need this tunable: early_differential.
> Rather just increase the frequency without doing this calculation:
> 
> if (load_freq > od_tuners.up_threshold * policy->cur) {

I agree with your suggestion. This is simpler approach. So, if the gradient is greater than
grad_up_threshold we increase frequency immediately. i.e.

if previous load was 10 and current load is 65 the gradient will be 55 (> grad_up_theshold)
and we increase frequency

>> +       if (od_tuners.early_demand) {
>> +               if (load_freq > dbs_info->prev_load_freq) {
> 
> && (load_freq < od_tuners.up_threshold * policy->cur) ??

In my opinion this is not necessary. If load_freq is greater, then we have to increase 
frequency in anyway.

> 
>> +show_one(od, early_demand, early_demand);
> 
> What about making other two tunables rw?
> 

Of course. I added the grad_up_threshold.

Following patch v2.

Thanks again,
Stratos

------------------------8<----------------------------------------------
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
 drivers/cpufreq/cpufreq_governor.h |  6 +++-
 drivers/cpufreq/cpufreq_ondemand.c | 72 ++++++++++++++++++++++++++++++++++----
 3 files changed, 72 insertions(+), 7 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index 7722505..e737aa9 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -322,6 +322,7 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 		} else {
 			od_dbs_info->rate_mult = 1;
 			od_dbs_info->sample_type = OD_NORMAL_SAMPLE;
+			od_dbs_info->prev_load_freq = 0;
 			od_ops->powersave_bias_init_cpu(cpu);
 		}
 
diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
index 6301790..c9a237a 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -96,6 +96,7 @@ struct od_cpu_dbs_info_s {
 	unsigned int freq_hi_jiffies;
 	unsigned int rate_mult;
 	unsigned int sample_type:1;
+	unsigned int prev_load_freq;
 };
 
 struct cs_cpu_dbs_info_s {
@@ -114,6 +115,8 @@ struct od_dbs_tuners {
 	unsigned int adj_up_threshold;
 	unsigned int powersave_bias;
 	unsigned int io_is_busy;
+	unsigned int grad_up_threshold;
+	unsigned int early_demand;
 };
 
 struct cs_dbs_tuners {
@@ -160,7 +163,8 @@ struct od_ops {
 	void (*powersave_bias_init_cpu)(int cpu);
 	unsigned int (*powersave_bias_target)(struct cpufreq_policy *policy,
 			unsigned int freq_next, unsigned int relation);
-	void (*freq_increase)(struct cpufreq_policy *p, unsigned int freq);
+	void (*freq_increase)(struct od_cpu_dbs_info_s *dbs_info,
+			      struct cpufreq_policy *p, unsigned int freq);
 };
 
 struct cs_ops {
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index c5fd794..4c948af 100644
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
@@ -139,11 +140,16 @@ static void ondemand_powersave_bias_init(void)
 	}
 }
 
-static void dbs_freq_increase(struct cpufreq_policy *p, unsigned int freq)
+static void dbs_freq_increase(struct od_cpu_dbs_info_s *dbs_info,
+			      struct cpufreq_policy *p, unsigned int freq)
 {
 	struct dbs_data *dbs_data = p->governor_data;
 	struct od_dbs_tuners *od_tuners = dbs_data->tuners;
 
+	/* If switching to max speed, apply sampling_down_factor */
+	if (p->cur < p->max)
+		dbs_info->rate_mult = od_tuners->sampling_down_factor;
+
 	if (od_tuners->powersave_bias)
 		freq = powersave_bias_target(p, freq, CPUFREQ_RELATION_H);
 	else if (p->cur == p->max)
@@ -168,16 +174,29 @@ static void od_check_cpu(int cpu, unsigned int load_freq)
 	struct cpufreq_policy *policy = dbs_info->cdbs.cur_policy;
 	struct dbs_data *dbs_data = policy->governor_data;
 	struct od_dbs_tuners *od_tuners = dbs_data->tuners;
+	unsigned int prev_load_freq;
 
 	dbs_info->freq_lo = 0;
 
+	/*
+	 * Calculate the gradient of load_freq. If it is too steep we assume
+	 * that the load will go over up_threshold in next iteration(s) and
+	 * we increase the frequency immediately
+	 */
+	if (od_tuners->early_demand) {
+		prev_load_freq = dbs_info->prev_load_freq;
+		dbs_info->prev_load_freq = load_freq;
+
+		if (load_freq > prev_load_freq && (load_freq - prev_load_freq >
+		    od_tuners->grad_up_threshold * policy->cur)) {
+			dbs_freq_increase(dbs_info, policy, policy->max);
+			return;
+		}
+	}
+
 	/* Check for frequency increase */
 	if (load_freq > od_tuners->up_threshold * policy->cur) {
-		/* If switching to max speed, apply sampling_down_factor */
-		if (policy->cur < policy->max)
-			dbs_info->rate_mult =
-				od_tuners->sampling_down_factor;
-		dbs_freq_increase(policy, policy->max);
+		dbs_freq_increase(dbs_info, policy, policy->max);
 		return;
 	}
 
@@ -445,12 +464,47 @@ static ssize_t store_powersave_bias(struct cpufreq_policy *policy,
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
@@ -459,6 +513,8 @@ cpufreq_freq_attr_rw(up_threshold);
 cpufreq_freq_attr_rw(sampling_down_factor);
 cpufreq_freq_attr_rw(ignore_nice);
 cpufreq_freq_attr_rw(powersave_bias);
+cpufreq_freq_attr_rw(grad_up_threshold);
+cpufreq_freq_attr_rw(early_demand);
 cpufreq_freq_attr_ro(sampling_rate_min);
 
 static struct attribute *dbs_attributes[] = {
@@ -469,6 +525,8 @@ static struct attribute *dbs_attributes[] = {
 	&ignore_nice.attr,
 	&powersave_bias.attr,
 	&io_is_busy.attr,
+	&grad_up_threshold.attr,
+	&early_demand.attr,
 	NULL
 };
 
@@ -516,9 +574,11 @@ static int od_init(struct dbs_data *dbs_data)
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
1.8.1.2


