Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933122Ab3E1LfF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 07:35:05 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:53225 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932878Ab3E1LfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 07:35:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] cpufreq: ondemand: Increase frequency to any value proportional to load
Date: Tue, 28 May 2013 13:43:55 +0200
Message-ID: <1733890.jTHBU7EacK@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51A3C6CF.6080104@semaphore.gr>
References: <51A3C6CF.6080104@semaphore.gr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 27, 2013 11:49:19 PM Stratos Karafotis wrote:
> Ondemand increases frequency only if the load_freq is greater than
> up_threshold. This seems to produce oscillations of frequency between
> min and max because a relatively small load can easily saturate minimum
> frequency and lead the CPU to max. Then, the CPU will decrease back to
> min due to a small load_freq.

I think this is a correct observation.

> With this patch the frequency can be increased to any value,

What exactly does "any value" mean here?

> proportional to load, if the load is below up_threshold. Thus, middle
> frequencies are used more. Absolute load is used for the calculation of
> frequency.
> 
> Phoronix benchmark results of Linux Kernel Compilation 3.1 tests are
> attached with and without this patch. cpufreq_stats (time_in_state) are
> also included. Tested on Intel i7-3770 CPU @ 3.40GH and on 
> Quad core 1500 MHz Krait.

Can you please comment the results in the changelog?  Attachments don't
show up in git logs. :-)

> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> ---
>  drivers/cpufreq/cpufreq_governor.c | 10 +---------
>  drivers/cpufreq/cpufreq_governor.h |  1 -
>  drivers/cpufreq/cpufreq_ondemand.c | 39 ++++++++------------------------------
>  3 files changed, 9 insertions(+), 41 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> index 5af40ad..eeab30a 100644
> --- a/drivers/cpufreq/cpufreq_governor.c
> +++ b/drivers/cpufreq/cpufreq_governor.c
> @@ -97,7 +97,7 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
>  
>  	policy = cdbs->cur_policy;
>  
> -	/* Get Absolute Load (in terms of freq for ondemand gov) */
> +	/* Get Absolute Load */
>  	for_each_cpu(j, policy->cpus) {
>  		struct cpu_dbs_common_info *j_cdbs;
>  		u64 cur_wall_time, cur_idle_time;
> @@ -148,14 +148,6 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
>  
>  		load = 100 * (wall_time - idle_time) / wall_time;
>  
> -		if (dbs_data->cdata->governor == GOV_ONDEMAND) {
> -			int freq_avg = __cpufreq_driver_getavg(policy, j);
> -			if (freq_avg <= 0)
> -				freq_avg = policy->cur;
> -
> -			load *= freq_avg;
> -		}
> -
>  		if (load > max_load)
>  			max_load = load;
>  	}
> diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
> index e16a961..e899c11 100644
> --- a/drivers/cpufreq/cpufreq_governor.h
> +++ b/drivers/cpufreq/cpufreq_governor.h
> @@ -169,7 +169,6 @@ struct od_dbs_tuners {
>  	unsigned int sampling_rate;
>  	unsigned int sampling_down_factor;
>  	unsigned int up_threshold;
> -	unsigned int adj_up_threshold;
>  	unsigned int powersave_bias;
>  	unsigned int io_is_busy;
>  };
> diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
> index 4b9bb5d..bf2ae64 100644
> --- a/drivers/cpufreq/cpufreq_ondemand.c
> +++ b/drivers/cpufreq/cpufreq_ondemand.c
> @@ -29,11 +29,9 @@
>  #include "cpufreq_governor.h"
>  
>  /* On-demand governor macros */
> -#define DEF_FREQUENCY_DOWN_DIFFERENTIAL		(10)
>  #define DEF_FREQUENCY_UP_THRESHOLD		(80)
>  #define DEF_SAMPLING_DOWN_FACTOR		(1)
>  #define MAX_SAMPLING_DOWN_FACTOR		(100000)
> -#define MICRO_FREQUENCY_DOWN_DIFFERENTIAL	(3)
>  #define MICRO_FREQUENCY_UP_THRESHOLD		(95)
>  #define MICRO_FREQUENCY_MIN_SAMPLE_RATE		(10000)
>  #define MIN_FREQUENCY_UP_THRESHOLD		(11)
> @@ -159,14 +157,12 @@ static void dbs_freq_increase(struct cpufreq_policy *p, unsigned int freq)
>  
>  /*
>   * Every sampling_rate, we check, if current idle time is less than 20%
> - * (default), then we try to increase frequency. Every sampling_rate, we look
> - * for the lowest frequency which can sustain the load while keeping idle time
> - * over 30%. If such a frequency exist, we try to decrease to this frequency.
> + * (default), then we try to increase frequency. Else, we adjust the frequency
> + * proportional to load.
>   *
> - * Any frequency increase takes it to the maximum frequency. Frequency reduction
> - * happens at minimum steps of 5% (default) of current frequency
> + * Any frequency increase takes it to the maximum frequency.
>   */
> -static void od_check_cpu(int cpu, unsigned int load_freq)
> +static void od_check_cpu(int cpu, unsigned int load)
>  {
>  	struct od_cpu_dbs_info_s *dbs_info = &per_cpu(od_cpu_dbs_info, cpu);
>  	struct cpufreq_policy *policy = dbs_info->cdbs.cur_policy;
> @@ -176,29 +172,17 @@ static void od_check_cpu(int cpu, unsigned int load_freq)
>  	dbs_info->freq_lo = 0;
>  
>  	/* Check for frequency increase */
> -	if (load_freq > od_tuners->up_threshold * policy->cur) {
> +	if (load > od_tuners->up_threshold) {
>  		/* If switching to max speed, apply sampling_down_factor */
>  		if (policy->cur < policy->max)
>  			dbs_info->rate_mult =
>  				od_tuners->sampling_down_factor;
>  		dbs_freq_increase(policy, policy->max);
>  		return;
> -	}
> -
> -	/* Check for frequency decrease */
> -	/* if we cannot reduce the frequency anymore, break out early */
> -	if (policy->cur == policy->min)
> -		return;
> -
> -	/*
> -	 * The optimal frequency is the frequency that is the lowest that can
> -	 * support the current CPU usage without triggering the up policy. To be
> -	 * safe, we focus 10 points under the threshold.
> -	 */
> -	if (load_freq < od_tuners->adj_up_threshold
> -			* policy->cur) {
> +	} else {
> +		/* Calculate the next frequency proportional to load */
>  		unsigned int freq_next;
> -		freq_next = load_freq / od_tuners->adj_up_threshold;
> +		freq_next = load * policy->max / 100;

Can you please explain why this is the right formula?

>  		/* No longer fully busy, reset rate_mult */
>  		dbs_info->rate_mult = 1;
> @@ -372,9 +356,6 @@ static ssize_t store_up_threshold(struct dbs_data *dbs_data, const char *buf,
>  			input < MIN_FREQUENCY_UP_THRESHOLD) {
>  		return -EINVAL;
>  	}
> -	/* Calculate the new adj_up_threshold */
> -	od_tuners->adj_up_threshold += input;
> -	od_tuners->adj_up_threshold -= od_tuners->up_threshold;
>  
>  	od_tuners->up_threshold = input;
>  	return count;
> @@ -523,8 +504,6 @@ static int od_init(struct dbs_data *dbs_data)
>  	if (idle_time != -1ULL) {
>  		/* Idle micro accounting is supported. Use finer thresholds */
>  		tuners->up_threshold = MICRO_FREQUENCY_UP_THRESHOLD;
> -		tuners->adj_up_threshold = MICRO_FREQUENCY_UP_THRESHOLD -
> -			MICRO_FREQUENCY_DOWN_DIFFERENTIAL;
>  		/*
>  		 * In nohz/micro accounting case we set the minimum frequency
>  		 * not depending on HZ, but fixed (very low). The deferred
> @@ -533,8 +512,6 @@ static int od_init(struct dbs_data *dbs_data)
>  		dbs_data->min_sampling_rate = MICRO_FREQUENCY_MIN_SAMPLE_RATE;
>  	} else {
>  		tuners->up_threshold = DEF_FREQUENCY_UP_THRESHOLD;
> -		tuners->adj_up_threshold = DEF_FREQUENCY_UP_THRESHOLD -
> -			DEF_FREQUENCY_DOWN_DIFFERENTIAL;
>  
>  		/* For correct statistics, we need 10 ticks for each measure */
>  		dbs_data->min_sampling_rate = MIN_SAMPLING_RATE_RATIO *

Overall it looks like an improvement.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
