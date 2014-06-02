Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbaFBI1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 04:27:19 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:44491 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbaFBI1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 04:27:16 -0400
Message-ID: <538C32AA.5020401@linux.vnet.ibm.com>
Date: Mon, 02 Jun 2014 13:45:38 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: ego@linux.vnet.ibm.com
CC: rjw@rjwysocki.net, viresh.kumar@linaro.org, svaidy@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq: governor: Be friendly towards latency-sensitive
 bursty workloads
References: <20140526205337.1100.55275.stgit@srivatsabhat.in.ibm.com> <20140602073306.GA5220@in.ibm.com>
In-Reply-To: <20140602073306.GA5220@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060208-2000-0000-0000-00000050768E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2014 01:03 PM, Gautham R Shenoy wrote:
> Hi,
> 
> On Tue, May 27, 2014 at 02:23:38AM +0530, Srivatsa S. Bhat wrote:
> 
> [..snip..]
>>
>> Experimental results:
>> ====================
>>
>> I ran a modified version of ebizzy (called 'sleeping-ebizzy') that sleeps in
>> between its execution such that its total utilization can be a user-defined
>> value, say 10% or 20% (higher the utilization specified, lesser the amount of
>> sleeps injected). This ebizzy was run with a single-thread, tied to CPU 8.
>>
>> Behavior observed with tracing (sample taken from 40% utilization runs):
>> ------------------------------------------------------------------------
>>
>> Without patch:
>> ~~~~~~~~~~~~~~
>> kworker/8:2-12137  416.335742: cpu_frequency: state=2061000 cpu_id=8
>> kworker/8:2-12137  416.335744: sched_switch: prev_comm=kworker/8:2 ==> next_comm=ebizzy
>>       <...>-40753  416.345741: sched_switch: prev_comm=ebizzy ==> next_comm=kworker/8:2
>> kworker/8:2-12137  416.345744: cpu_frequency: state=4123000 cpu_id=8
>> kworker/8:2-12137  416.345746: sched_switch: prev_comm=kworker/8:2 ==> next_comm=ebizzy
>>       <...>-40753  416.355738: sched_switch: prev_comm=ebizzy ==> next_comm=kworker/8:2
>> <snip>  ---------------------------------------------------------------------  <snip>
>>       <...>-40753  416.402202: sched_switch: prev_comm=ebizzy ==> next_comm=swapper/8
>>      <idle>-0      416.502130: sched_switch: prev_comm=swapper/8 ==> next_comm=ebizzy
>>       <...>-40753  416.505738: sched_switch: prev_comm=ebizzy ==> next_comm=kworker/8:2
>> kworker/8:2-12137  416.505739: cpu_frequency: state=2061000 cpu_id=8
>> kworker/8:2-12137  416.505741: sched_switch: prev_comm=kworker/8:2 ==> next_comm=ebizzy
>>       <...>-40753  416.515739: sched_switch: prev_comm=ebizzy ==> next_comm=kworker/8:2
>> kworker/8:2-12137  416.515742: cpu_frequency: state=4123000 cpu_id=8
>> kworker/8:2-12137  416.515744: sched_switch: prev_comm=kworker/8:2 ==> next_comm=ebizzy
>>
>> Observation: Ebizzy went idle at 416.402202, and started running again at
>> 416.502130. But cpufreq noticed the long idle period, and dropped the frequency
>> at 416.505739, only to increase it back again at 416.515742, realizing that the
>> workload is in-fact CPU bound. Thus ebizzy needlessly ran at the lowest frequency
>> for almost 13 milliseconds (almost 1 full sample period), and this pattern
>> repeats on every sleep-wakeup. This could hurt latency-sensitive workloads quite
>> a lot.
>>
>> With patch:
>> ~~~~~~~~~~~
>>
>> kworker/8:2-29802  464.832535: cpu_frequency: state=2061000 cpu_id=8
>> <snip>  ---------------------------------------------------------------------  <snip>
>> kworker/8:2-29802  464.962538: sched_switch: prev_comm=kworker/8:2 ==> next_comm=ebizzy
>>       <...>-40738  464.972533: sched_switch: prev_comm=ebizzy ==> next_comm=kworker/8:2
>> kworker/8:2-29802  464.972536: cpu_frequency: state=4123000 cpu_id=8
>> kworker/8:2-29802  464.972538: sched_switch: prev_comm=kworker/8:2 ==> next_comm=ebizzy
>>       <...>-40738  464.982531: sched_switch: prev_comm=ebizzy ==> next_comm=kworker/8:2
>> <snip>  ---------------------------------------------------------------------  <snip>
>> kworker/8:2-29802  465.022533: sched_switch: prev_comm=kworker/8:2 ==> next_comm=ebizzy
>>       <...>-40738  465.032531: sched_switch: prev_comm=ebizzy ==> next_comm=kworker/8:2
>> kworker/8:2-29802  465.032532: sched_switch: prev_comm=kworker/8:2 ==> next_comm=ebizzy
>>       <...>-40738  465.035797: sched_switch: prev_comm=ebizzy ==> next_comm=swapper/8
>>      <idle>-0      465.240178: sched_switch: prev_comm=swapper/8 ==> next_comm=ebizzy
>>       <...>-40738  465.242533: sched_switch: prev_comm=ebizzy ==> next_comm=kworker/8:2
>> kworker/8:2-29802  465.242535: sched_switch: prev_comm=kworker/8:2 ==> next_comm=ebizzy
>>       <...>-40738  465.252531: sched_switch: prev_comm=ebizzy ==> next_comm=kworker/8:2
>>
> 
> Have the log entries emmitted by kworker/8 to report about the
> cpu_frequency states been snipped out in the entries post the
> "465.032531" mark ?
> 

No, why? Anything looks odd at that point?

Note that the CPU went idle from 465.035797 to 465.240178, and hence cpufreq's
deferrable timer didn't fire (and hence kworker didn't run). But once the CPU
became busy again at 465.240178, the kworker got scheduled on the CPU within
2 ms (at 465.242533).

> 
>> Observation: Ebizzy went idle at 465.035797, and started running again at
>> 465.240178. Since ebizzy was the only real workload running on this CPU,
>> cpufreq retained the frequency at 4.1Ghz throughout the run of ebizzy, no
>> matter how many times ebizzy slept and woke-up in-between. Thus, ebizzy
>> got the 10ms worth of 4.1 Ghz benefit during every sleep-wakeup (as compared
>> to the run without the patch) and this boost gave a modest improvement in total
>> throughput, as shown below.
>>
>> Sleeping-ebizzy records-per-second:
>> -----------------------------------
>>
>> Utilization  Without patch  With patch  Difference (Absolute and % values)
>>     10%         274767        277046        +  2279 (+0.829%)
>>     20%         543429        553484        + 10055 (+1.850%)
>>     40%        1090744       1107959        + 17215 (+1.578%)
>>     60%        1634908       1662018        + 27110 (+1.658%)
>>
>> A rudimentary and somewhat approximately latency-sensitive workload such as
>> sleeping-ebizzy itself showed a consistent, noticeable performance improvement
>> with this patch. Hence, workloads that are truly latency-sensitive will benefit
>> quite a bit from this change. Moreover, this is an overall win-win since this
>> patch does not hurt power-savings at all (because, this patch does not reduce
>> the idle time or idle residency; and the high frequency of the CPU when it goes
>> to cpu-idle does not affect/hurt the power-savings of deep idle states).
>>
>> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>> ---
>>
>>  drivers/cpufreq/cpufreq_conservative.c |    2 +-
>>  drivers/cpufreq/cpufreq_governor.c     |   32 +++++++++++++++++++++++++++++---
>>  drivers/cpufreq/cpufreq_governor.h     |    4 +++-
>>  drivers/cpufreq/cpufreq_ondemand.c     |    9 ++++++++-
>>  4 files changed, 41 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
>> index 25a70d0..65c9905 100644
>> --- a/drivers/cpufreq/cpufreq_conservative.c
>> +++ b/drivers/cpufreq/cpufreq_conservative.c
>> @@ -118,7 +118,7 @@ static void cs_dbs_timer(struct work_struct *work)
>>  	if (!need_load_eval(&core_dbs_info->cdbs, cs_tuners->sampling_rate))
>>  		modify_all = false;
>>  	else
>> -		dbs_check_cpu(dbs_data, cpu);
>> +		dbs_check_cpu(dbs_data, cpu, cs_tuners->sampling_rate);
>>
>>  	gov_queue_work(dbs_data, dbs_info->cdbs.cur_policy, delay, modify_all);
>>  	mutex_unlock(&core_dbs_info->cdbs.timer_mutex);
>> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
>> index e1c6433..910d472 100644
>> --- a/drivers/cpufreq/cpufreq_governor.c
>> +++ b/drivers/cpufreq/cpufreq_governor.c
>> @@ -30,7 +30,8 @@ static struct attribute_group *get_sysfs_attr(struct dbs_data *dbs_data)
>>  		return dbs_data->cdata->attr_group_gov_sys;
>>  }
>>
>> -void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
>> +void dbs_check_cpu(struct dbs_data *dbs_data, int cpu,
>> +		   unsigned int sampling_rate)
>>  {
>>  	struct cpu_dbs_common_info *cdbs = dbs_data->cdata->get_cpu_cdbs(cpu);
>>  	struct od_dbs_tuners *od_tuners = dbs_data->tuners;
>> @@ -96,7 +97,28 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
>>  		if (unlikely(!wall_time || wall_time < idle_time))
>>  			continue;
>>
>> -		load = 100 * (wall_time - idle_time) / wall_time;
>> +		/*
>> +		 * If the CPU had gone completely idle, and a task just woke up
>> +		 * on this CPU now, it would be unfair to calculate 'load' the
>> +		 * usual way for this elapsed time-window, because it will show
>> +		 * near-zero load, irrespective of how CPU intensive the new
>> +		 * task is. This is undesirable for latency-sensitive bursty
>> +		 * workloads.
>> +		 *
>> +		 * To avoid this, we reuse the 'load' from the previous
>> +		 * time-window and give this task a chance to start with a
>> +		 * reasonably high CPU frequency.
>> +		 *
>> +		 * Detecting this situation is easy: the governor's deferrable
>> +		 * timer would not have fired during CPU-idle periods. Hence
>> +		 * an unusually large 'wall_time' indicates this scenario.
>> +		 */
>> +		if (unlikely(wall_time > (2 * sampling_rate))) {
> 					     ^^^^^^^^^^^^^^^^^^
> 
> The sampling rate that you've passed is already multiplied by
> core_dbs_info->rate_mult. Wouldn't that be sufficient ?
>

Hmm, no. Strictly speaking, the sampling rate is not a constant in the ondemand
governor. It gets multiplied with ->rate_mult to dynamically change the sampling
rate (whenever that is desired). So in the core cpufreq governor code, we should
use this value (i.e., whatever the ondemand governor passes to dbs_check_cpu()
as the sampling_rate, _after_ multiplying with ->rate_mult), since that represents
the maximum sampling rate of the ondemand cpufreq governor.

However, the additional multiplication by 2 in this code is to ensure that we
give sufficient buffer or gap, before we start the new "were we idle for very
long?" logic that this patch introduces.

I didn't want to check for 'wall_time > sampling_rate' because the timer can fire
slightly after the expiration of the sampling period, during regular operation
as well. So we don't want to treat those instances as "very long idle periods",
because that would be incorrect. Hence I decided to give an additional buffer
of a full sampling-period.
 
> The reason why I am mentioning this is that we could have performed
> all the scaling-up at one place.
> 

Indeed, the scaling-up is performed at only this one place: dbs_check_cpu().
This is not "scaling-up" per-se, but rather a means to ensure that we don't
kick off the "copy-previous-load" logic if the CPU wasn't actually idle for long.

And the multiplication with ->rate_mult in the ondemand governor is to avoid the
complication arising from the dynamic behaviour of the sampling-period, by simply
assuming the worst-case (largest) sampling period, all the time. This helps us
accurately recognize the true idle periods in dbs_check_cpu().

> 
> Other than this, the patch looks good.
> 
> Reviewed-by: Gautham R. Shenoy <ego@linux.vnet.ibm.com>

Thank you!

Regards,
Srivatsa S. Bhat

> 
>> +			load = j_cdbs->prev_load;
>> +		} else {
>> +			load = 100 * (wall_time - idle_time) / wall_time;
>> +			j_cdbs->prev_load = load;
>> +		}
>>
>>  		if (load > max_load)
>>  			max_load = load;
>> @@ -323,6 +345,10 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>>  			j_cdbs->cur_policy = policy;
>>  			j_cdbs->prev_cpu_idle = get_cpu_idle_time(j,
>>  					       &j_cdbs->prev_cpu_wall, io_busy);
>> +			j_cdbs->prev_load = 100 * (j_cdbs->prev_cpu_wall -
>> +						   j_cdbs->prev_cpu_idle) /
>> +						   j_cdbs->prev_cpu_wall;
>> +
>>  			if (ignore_nice)
>>  				j_cdbs->prev_cpu_nice =
>>  					kcpustat_cpu(j).cpustat[CPUTIME_NICE];
>> @@ -378,7 +404,7 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>>  		else if (policy->min > cpu_cdbs->cur_policy->cur)
>>  			__cpufreq_driver_target(cpu_cdbs->cur_policy,
>>  					policy->min, CPUFREQ_RELATION_L);
>> -		dbs_check_cpu(dbs_data, cpu);
>> +		dbs_check_cpu(dbs_data, cpu, sampling_rate);
>>  		mutex_unlock(&cpu_cdbs->timer_mutex);
>>  		mutex_unlock(&dbs_data->mutex);
>>  		break;
>> diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
>> index bfb9ae1..2fbf878 100644
>> --- a/drivers/cpufreq/cpufreq_governor.h
>> +++ b/drivers/cpufreq/cpufreq_governor.h
>> @@ -134,6 +134,7 @@ struct cpu_dbs_common_info {
>>  	u64 prev_cpu_idle;
>>  	u64 prev_cpu_wall;
>>  	u64 prev_cpu_nice;
>> +	unsigned int prev_load;
>>  	struct cpufreq_policy *cur_policy;
>>  	struct delayed_work work;
>>  	/*
>> @@ -259,7 +260,8 @@ static ssize_t show_sampling_rate_min_gov_pol				\
>>
>>  extern struct mutex cpufreq_governor_lock;
>>
>> -void dbs_check_cpu(struct dbs_data *dbs_data, int cpu);
>> +void dbs_check_cpu(struct dbs_data *dbs_data, int cpu,
>> +		   unsigned int sampling_rate);
>>  bool need_load_eval(struct cpu_dbs_common_info *cdbs,
>>  		unsigned int sampling_rate);
>>  int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>> diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
>> index 18d4091..b1f054a 100644
>> --- a/drivers/cpufreq/cpufreq_ondemand.c
>> +++ b/drivers/cpufreq/cpufreq_ondemand.c
>> @@ -213,7 +213,14 @@ static void od_dbs_timer(struct work_struct *work)
>>  		__cpufreq_driver_target(core_dbs_info->cdbs.cur_policy,
>>  				core_dbs_info->freq_lo, CPUFREQ_RELATION_H);
>>  	} else {
>> -		dbs_check_cpu(dbs_data, cpu);
>> +		/*
>> +		 * Provide maximum delay as the sampling_rate hint to
>> +		 * dbs_check_cpu, to keep its wake-up-from-cpu-idle detection
>> +		 * logic a bit conservative.
>> +		 */
>> +		dbs_check_cpu(dbs_data, cpu,
>> +			od_tuners->sampling_rate * core_dbs_info->rate_mult);
>> +
>>  		if (core_dbs_info->freq_lo) {
>>  			/* Setup timer for SUB_SAMPLE */
>>  			core_dbs_info->sample_type = OD_SUB_SAMPLE;
>>


-- 
Regards,
Srivatsa S. Bhat

