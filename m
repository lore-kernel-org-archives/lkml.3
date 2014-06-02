Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbaFBHdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 03:33:21 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:48837 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535AbaFBHdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 03:33:19 -0400
Date: Mon, 2 Jun 2014 13:03:07 +0530
From: Gautham R Shenoy <ego@linux.vnet.ibm.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: rjw@rjwysocki.net, viresh.kumar@linaro.org, svaidy@linux.vnet.ibm.com,
        ego@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq: governor: Be friendly towards latency-sensitive
 bursty workloads
Message-ID: <20140602073306.GA5220@in.ibm.com>
Reply-To: ego@linux.vnet.ibm.com
References: <20140526205337.1100.55275.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140526205337.1100.55275.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060207-5806-0000-0000-00002506B87B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, May 27, 2014 at 02:23:38AM +0530, Srivatsa S. Bhat wrote:

[..snip..]
> 
> Experimental results:
> ====================
> 
> I ran a modified version of ebizzy (called 'sleeping-ebizzy') that sleeps in
> between its execution such that its total utilization can be a user-defined
> value, say 10% or 20% (higher the utilization specified, lesser the amount of
> sleeps injected). This ebizzy was run with a single-thread, tied to CPU 8.
> 
> Behavior observed with tracing (sample taken from 40% utilization runs):
> ------------------------------------------------------------------------
> 
> Without patch:
> ~~~~~~~~~~~~~~
> kworker/8:2-12137  416.335742: cpu_frequency: state=2061000 cpu_id=8
> kworker/8:2-12137  416.335744: sched_switch: prev_comm=kworker/8:2 ==> next_comm=ebizzy
>       <...>-40753  416.345741: sched_switch: prev_comm=ebizzy ==> next_comm=kworker/8:2
> kworker/8:2-12137  416.345744: cpu_frequency: state=4123000 cpu_id=8
> kworker/8:2-12137  416.345746: sched_switch: prev_comm=kworker/8:2 ==> next_comm=ebizzy
>       <...>-40753  416.355738: sched_switch: prev_comm=ebizzy ==> next_comm=kworker/8:2
> <snip>  ---------------------------------------------------------------------  <snip>
>       <...>-40753  416.402202: sched_switch: prev_comm=ebizzy ==> next_comm=swapper/8
>      <idle>-0      416.502130: sched_switch: prev_comm=swapper/8 ==> next_comm=ebizzy
>       <...>-40753  416.505738: sched_switch: prev_comm=ebizzy ==> next_comm=kworker/8:2
> kworker/8:2-12137  416.505739: cpu_frequency: state=2061000 cpu_id=8
> kworker/8:2-12137  416.505741: sched_switch: prev_comm=kworker/8:2 ==> next_comm=ebizzy
>       <...>-40753  416.515739: sched_switch: prev_comm=ebizzy ==> next_comm=kworker/8:2
> kworker/8:2-12137  416.515742: cpu_frequency: state=4123000 cpu_id=8
> kworker/8:2-12137  416.515744: sched_switch: prev_comm=kworker/8:2 ==> next_comm=ebizzy
> 
> Observation: Ebizzy went idle at 416.402202, and started running again at
> 416.502130. But cpufreq noticed the long idle period, and dropped the frequency
> at 416.505739, only to increase it back again at 416.515742, realizing that the
> workload is in-fact CPU bound. Thus ebizzy needlessly ran at the lowest frequency
> for almost 13 milliseconds (almost 1 full sample period), and this pattern
> repeats on every sleep-wakeup. This could hurt latency-sensitive workloads quite
> a lot.
> 
> With patch:
> ~~~~~~~~~~~
> 
> kworker/8:2-29802  464.832535: cpu_frequency: state=2061000 cpu_id=8
> <snip>  ---------------------------------------------------------------------  <snip>
> kworker/8:2-29802  464.962538: sched_switch: prev_comm=kworker/8:2 ==> next_comm=ebizzy
>       <...>-40738  464.972533: sched_switch: prev_comm=ebizzy ==> next_comm=kworker/8:2
> kworker/8:2-29802  464.972536: cpu_frequency: state=4123000 cpu_id=8
> kworker/8:2-29802  464.972538: sched_switch: prev_comm=kworker/8:2 ==> next_comm=ebizzy
>       <...>-40738  464.982531: sched_switch: prev_comm=ebizzy ==> next_comm=kworker/8:2
> <snip>  ---------------------------------------------------------------------  <snip>
> kworker/8:2-29802  465.022533: sched_switch: prev_comm=kworker/8:2 ==> next_comm=ebizzy
>       <...>-40738  465.032531: sched_switch: prev_comm=ebizzy ==> next_comm=kworker/8:2
> kworker/8:2-29802  465.032532: sched_switch: prev_comm=kworker/8:2 ==> next_comm=ebizzy
>       <...>-40738  465.035797: sched_switch: prev_comm=ebizzy ==> next_comm=swapper/8
>      <idle>-0      465.240178: sched_switch: prev_comm=swapper/8 ==> next_comm=ebizzy
>       <...>-40738  465.242533: sched_switch: prev_comm=ebizzy ==> next_comm=kworker/8:2
> kworker/8:2-29802  465.242535: sched_switch: prev_comm=kworker/8:2 ==> next_comm=ebizzy
>       <...>-40738  465.252531: sched_switch: prev_comm=ebizzy ==> next_comm=kworker/8:2
> 

Have the log entries emmitted by kworker/8 to report about the
cpu_frequency states been snipped out in the entries post the
"465.032531" mark ?


> Observation: Ebizzy went idle at 465.035797, and started running again at
> 465.240178. Since ebizzy was the only real workload running on this CPU,
> cpufreq retained the frequency at 4.1Ghz throughout the run of ebizzy, no
> matter how many times ebizzy slept and woke-up in-between. Thus, ebizzy
> got the 10ms worth of 4.1 Ghz benefit during every sleep-wakeup (as compared
> to the run without the patch) and this boost gave a modest improvement in total
> throughput, as shown below.
> 
> Sleeping-ebizzy records-per-second:
> -----------------------------------
> 
> Utilization  Without patch  With patch  Difference (Absolute and % values)
>     10%         274767        277046        +  2279 (+0.829%)
>     20%         543429        553484        + 10055 (+1.850%)
>     40%        1090744       1107959        + 17215 (+1.578%)
>     60%        1634908       1662018        + 27110 (+1.658%)
> 
> A rudimentary and somewhat approximately latency-sensitive workload such as
> sleeping-ebizzy itself showed a consistent, noticeable performance improvement
> with this patch. Hence, workloads that are truly latency-sensitive will benefit
> quite a bit from this change. Moreover, this is an overall win-win since this
> patch does not hurt power-savings at all (because, this patch does not reduce
> the idle time or idle residency; and the high frequency of the CPU when it goes
> to cpu-idle does not affect/hurt the power-savings of deep idle states).
> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
> 
>  drivers/cpufreq/cpufreq_conservative.c |    2 +-
>  drivers/cpufreq/cpufreq_governor.c     |   32 +++++++++++++++++++++++++++++---
>  drivers/cpufreq/cpufreq_governor.h     |    4 +++-
>  drivers/cpufreq/cpufreq_ondemand.c     |    9 ++++++++-
>  4 files changed, 41 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
> index 25a70d0..65c9905 100644
> --- a/drivers/cpufreq/cpufreq_conservative.c
> +++ b/drivers/cpufreq/cpufreq_conservative.c
> @@ -118,7 +118,7 @@ static void cs_dbs_timer(struct work_struct *work)
>  	if (!need_load_eval(&core_dbs_info->cdbs, cs_tuners->sampling_rate))
>  		modify_all = false;
>  	else
> -		dbs_check_cpu(dbs_data, cpu);
> +		dbs_check_cpu(dbs_data, cpu, cs_tuners->sampling_rate);
> 
>  	gov_queue_work(dbs_data, dbs_info->cdbs.cur_policy, delay, modify_all);
>  	mutex_unlock(&core_dbs_info->cdbs.timer_mutex);
> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> index e1c6433..910d472 100644
> --- a/drivers/cpufreq/cpufreq_governor.c
> +++ b/drivers/cpufreq/cpufreq_governor.c
> @@ -30,7 +30,8 @@ static struct attribute_group *get_sysfs_attr(struct dbs_data *dbs_data)
>  		return dbs_data->cdata->attr_group_gov_sys;
>  }
> 
> -void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
> +void dbs_check_cpu(struct dbs_data *dbs_data, int cpu,
> +		   unsigned int sampling_rate)
>  {
>  	struct cpu_dbs_common_info *cdbs = dbs_data->cdata->get_cpu_cdbs(cpu);
>  	struct od_dbs_tuners *od_tuners = dbs_data->tuners;
> @@ -96,7 +97,28 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
>  		if (unlikely(!wall_time || wall_time < idle_time))
>  			continue;
> 
> -		load = 100 * (wall_time - idle_time) / wall_time;
> +		/*
> +		 * If the CPU had gone completely idle, and a task just woke up
> +		 * on this CPU now, it would be unfair to calculate 'load' the
> +		 * usual way for this elapsed time-window, because it will show
> +		 * near-zero load, irrespective of how CPU intensive the new
> +		 * task is. This is undesirable for latency-sensitive bursty
> +		 * workloads.
> +		 *
> +		 * To avoid this, we reuse the 'load' from the previous
> +		 * time-window and give this task a chance to start with a
> +		 * reasonably high CPU frequency.
> +		 *
> +		 * Detecting this situation is easy: the governor's deferrable
> +		 * timer would not have fired during CPU-idle periods. Hence
> +		 * an unusually large 'wall_time' indicates this scenario.
> +		 */
> +		if (unlikely(wall_time > (2 * sampling_rate))) {
					     ^^^^^^^^^^^^^^^^^^

The sampling rate that you've passed is already multiplied by
core_dbs_info->rate_mult. Wouldn't that be sufficient ?

The reason why I am mentioning this is that we could have performed
all the scaling-up at one place.


Other than this, the patch looks good.

Reviewed-by: Gautham R. Shenoy <ego@linux.vnet.ibm.com>

> +			load = j_cdbs->prev_load;
> +		} else {
> +			load = 100 * (wall_time - idle_time) / wall_time;
> +			j_cdbs->prev_load = load;
> +		}
> 
>  		if (load > max_load)
>  			max_load = load;
> @@ -323,6 +345,10 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>  			j_cdbs->cur_policy = policy;
>  			j_cdbs->prev_cpu_idle = get_cpu_idle_time(j,
>  					       &j_cdbs->prev_cpu_wall, io_busy);
> +			j_cdbs->prev_load = 100 * (j_cdbs->prev_cpu_wall -
> +						   j_cdbs->prev_cpu_idle) /
> +						   j_cdbs->prev_cpu_wall;
> +
>  			if (ignore_nice)
>  				j_cdbs->prev_cpu_nice =
>  					kcpustat_cpu(j).cpustat[CPUTIME_NICE];
> @@ -378,7 +404,7 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>  		else if (policy->min > cpu_cdbs->cur_policy->cur)
>  			__cpufreq_driver_target(cpu_cdbs->cur_policy,
>  					policy->min, CPUFREQ_RELATION_L);
> -		dbs_check_cpu(dbs_data, cpu);
> +		dbs_check_cpu(dbs_data, cpu, sampling_rate);
>  		mutex_unlock(&cpu_cdbs->timer_mutex);
>  		mutex_unlock(&dbs_data->mutex);
>  		break;
> diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
> index bfb9ae1..2fbf878 100644
> --- a/drivers/cpufreq/cpufreq_governor.h
> +++ b/drivers/cpufreq/cpufreq_governor.h
> @@ -134,6 +134,7 @@ struct cpu_dbs_common_info {
>  	u64 prev_cpu_idle;
>  	u64 prev_cpu_wall;
>  	u64 prev_cpu_nice;
> +	unsigned int prev_load;
>  	struct cpufreq_policy *cur_policy;
>  	struct delayed_work work;
>  	/*
> @@ -259,7 +260,8 @@ static ssize_t show_sampling_rate_min_gov_pol				\
> 
>  extern struct mutex cpufreq_governor_lock;
> 
> -void dbs_check_cpu(struct dbs_data *dbs_data, int cpu);
> +void dbs_check_cpu(struct dbs_data *dbs_data, int cpu,
> +		   unsigned int sampling_rate);
>  bool need_load_eval(struct cpu_dbs_common_info *cdbs,
>  		unsigned int sampling_rate);
>  int cpufreq_governor_dbs(struct cpufreq_policy *policy,
> diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
> index 18d4091..b1f054a 100644
> --- a/drivers/cpufreq/cpufreq_ondemand.c
> +++ b/drivers/cpufreq/cpufreq_ondemand.c
> @@ -213,7 +213,14 @@ static void od_dbs_timer(struct work_struct *work)
>  		__cpufreq_driver_target(core_dbs_info->cdbs.cur_policy,
>  				core_dbs_info->freq_lo, CPUFREQ_RELATION_H);
>  	} else {
> -		dbs_check_cpu(dbs_data, cpu);
> +		/*
> +		 * Provide maximum delay as the sampling_rate hint to
> +		 * dbs_check_cpu, to keep its wake-up-from-cpu-idle detection
> +		 * logic a bit conservative.
> +		 */
> +		dbs_check_cpu(dbs_data, cpu,
> +			od_tuners->sampling_rate * core_dbs_info->rate_mult);
> +
>  		if (core_dbs_info->freq_lo) {
>  			/* Setup timer for SUB_SAMPLE */
>  			core_dbs_info->sample_type = OD_SUB_SAMPLE;
> 

