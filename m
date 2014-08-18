Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796AbaHRPyI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 11:54:08 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:54891 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaHRPyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 11:54:05 -0400
Date: Mon, 18 Aug 2014 11:54:00 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
cc: alex.shi@intel.com, vincent.guittot@linaro.org, peterz@infradead.org,
        pjt@google.com, efault@gmx.de, rjw@rjwysocki.net,
        morten.rasmussen@arm.com, svaidy@linux.vnet.ibm.com,
        arjan@linux.intel.com, mingo@kernel.org, len.brown@intel.com,
        yuyang.du@intel.com, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org, corbet@lwn.net, catalin.marinas@arm.com,
        markgross@thegnar.org, sundar.iyer@intel.com,
        linux-kernel@vger.kernel.org, dietmar.eggemann@arm.com,
        Lorenzo.Pieralisi@arm.com, mike.turquette@linaro.org,
        akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de
Subject: Re: [RFC PATCH V2 02/19] sched/power: Move idle state selection into
 the scheduler
In-Reply-To: <20140811113246.31956.49929.stgit@preeti.in.ibm.com>
Message-ID: <alpine.LFD.2.11.1408181140190.29347@knanqh.ubzr>
References: <20140811113000.31956.52857.stgit@preeti.in.ibm.com> <20140811113246.31956.49929.stgit@preeti.in.ibm.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Aug 2014, Preeti U Murthy wrote:

> The goal of the power aware scheduling design is to integrate all
> policy, metrics and averaging into the scheduler. Today the
> cpu power management is fragmented and hence inconsistent.
> 
> As a first step towards this integration, rid the cpuidle state management
> of the governors. Retain only the cpuidle driver in the cpu idle
> susbsystem which acts as an interface between the scheduler and low
> level platform specific cpuidle drivers. For all decision making around
> selection of idle states,the cpuidle driver falls back to the scheduler.
> 
> The current algorithm for idle state selection is the same as the logic used
> by the menu governor. However going ahead the heuristics will be tuned and
> improved upon with metrics better known to the scheduler.

I'd strongly suggest a different approach here.  Instead of copying the 
menu governor code and tweaking it afterwards, it would be cleaner to 
literally start from scratch with a new governor.  Said new governor 
would grow inside the scheduler with more design freedom instead of 
being strapped on the side.

By copying existing code, the chance for cruft to remain for a long time 
is close to 100%. We already have one copy of it, let's keep it working 
and start afresh instead.

By starting clean it is way easier to explain and justify additions to a 
new design than convincing ourselves about the removal of no longer 
needed pieces from a legacy design.


> 
> Note: cpufrequency is still left disabled when CONFIG_SCHED_POWER is selected.
> 
> Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
> ---
> 
>  drivers/cpuidle/Kconfig           |   12 +
>  drivers/cpuidle/cpuidle-powernv.c |    2 
>  drivers/cpuidle/cpuidle.c         |   65 ++++-
>  include/linux/sched.h             |    9 +
>  kernel/sched/Makefile             |    1 
>  kernel/sched/power.c              |  480 +++++++++++++++++++++++++++++++++++++
>  6 files changed, 554 insertions(+), 15 deletions(-)
>  create mode 100644 kernel/sched/power.c
> 
> diff --git a/drivers/cpuidle/Kconfig b/drivers/cpuidle/Kconfig
> index 2c4ac79..4fa4cb1 100644
> --- a/drivers/cpuidle/Kconfig
> +++ b/drivers/cpuidle/Kconfig
> @@ -3,16 +3,14 @@ menu "CPU Idle"
>  config CPU_IDLE
>  	bool "CPU idle PM support"
>  	default y if ACPI || PPC_PSERIES
> -	depends on !SCHED_POWER
> -	select CPU_IDLE_GOV_LADDER if (!NO_HZ && !NO_HZ_IDLE)
> -	select CPU_IDLE_GOV_MENU if (NO_HZ || NO_HZ_IDLE)
> +	select CPU_IDLE_GOV_LADDER if (!NO_HZ && !NO_HZ_IDLE && !SCHED_POWER)
> +	select CPU_IDLE_GOV_MENU if ((NO_HZ || NO_HZ_IDLE) && !SCHED_POWER)
>  	help
>  	  CPU idle is a generic framework for supporting software-controlled
>  	  idle processor power management.  It includes modular cross-platform
>  	  governors that can be swapped during runtime.
>  
>  	  If you're using an ACPI-enabled platform, you should say Y here.
> -	  This feature will turn off if power aware scheduling is enabled.
>  
>  if CPU_IDLE
>  
> @@ -22,10 +20,16 @@ config CPU_IDLE_MULTIPLE_DRIVERS
>  config CPU_IDLE_GOV_LADDER
>  	bool "Ladder governor (for periodic timer tick)"
>  	default y
> +	depends on !SCHED_POWER
> +	help
> +	  This feature will turn off if power aware scheduling is enabled.
>  
>  config CPU_IDLE_GOV_MENU
>  	bool "Menu governor (for tickless system)"
>  	default y
> +	depends on !SCHED_POWER
> +	help
> +	  This feature will turn off if power aware scheduling is enabled.
>  
>  menu "ARM CPU Idle Drivers"
>  depends on ARM
> diff --git a/drivers/cpuidle/cpuidle-powernv.c b/drivers/cpuidle/cpuidle-powernv.c
> index fa79392..95ef533 100644
> --- a/drivers/cpuidle/cpuidle-powernv.c
> +++ b/drivers/cpuidle/cpuidle-powernv.c
> @@ -70,7 +70,7 @@ static int fastsleep_loop(struct cpuidle_device *dev,
>  	unsigned long new_lpcr;
>  
>  	if (powersave_nap < 2)
> -		return;
> +		return 0;
>  	if (unlikely(system_state < SYSTEM_RUNNING))
>  		return index;
>  
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index ee9df5e..38fb213 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -150,6 +150,19 @@ int cpuidle_enter_state(struct cpuidle_device *dev, struct cpuidle_driver *drv,
>  	return entered_state;
>  }
>  
> +#ifdef CONFIG_SCHED_POWER
> +static int __cpuidle_select(struct cpuidle_driver *drv,
> +				struct cpuidle_device *dev)
> +{
> +	return cpuidle_sched_select(drv, dev);
> +}
> +#else
> +static int __cpuidle_select(struct cpuidle_driver *drv,
> +				struct cpuidle_device *dev)
> +{
> +	return cpuidle_curr_governor->select(drv, dev);	
> +}
> +#endif
>  /**
>   * cpuidle_select - ask the cpuidle framework to choose an idle state
>   *
> @@ -169,7 +182,7 @@ int cpuidle_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
>  	if (unlikely(use_deepest_state))
>  		return cpuidle_find_deepest_state(drv, dev);
>  
> -	return cpuidle_curr_governor->select(drv, dev);
> +	return __cpuidle_select(drv, dev);
>  }
>  
>  /**
> @@ -190,6 +203,18 @@ int cpuidle_enter(struct cpuidle_driver *drv, struct cpuidle_device *dev,
>  	return cpuidle_enter_state(dev, drv, index);
>  }
>  
> +#ifdef CONFIG_SCHED_POWER
> +static void __cpuidle_reflect(struct cpuidle_device *dev, int index)
> +{
> +	cpuidle_sched_reflect(dev, index);
> +}
> +#else
> +static void __cpuidle_reflect(struct cpuidle_device *dev, int index)
> +{
> +	if (cpuidle_curr_governor->reflect && !unlikely(use_deepest_state))
> +		cpuidle_curr_governor->reflect(dev, index);
> +}
> +#endif
>  /**
>   * cpuidle_reflect - tell the underlying governor what was the state
>   * we were in
> @@ -200,8 +225,7 @@ int cpuidle_enter(struct cpuidle_driver *drv, struct cpuidle_device *dev,
>   */
>  void cpuidle_reflect(struct cpuidle_device *dev, int index)
>  {
> -	if (cpuidle_curr_governor->reflect && !unlikely(use_deepest_state))
> -		cpuidle_curr_governor->reflect(dev, index);
> +	__cpuidle_reflect(dev, index);
>  }
>  
>  /**
> @@ -265,6 +289,28 @@ void cpuidle_resume(void)
>  	mutex_unlock(&cpuidle_lock);
>  }
>  
> +#ifdef CONFIG_SCHED_POWER
> +static int cpuidle_check_governor(struct cpuidle_driver *drv,
> +					struct cpuidle_device *dev, int enable)
> +{
> +	if (enable)
> +		return cpuidle_sched_enable_device(drv, dev);
> +	else
> +		return 0;
> +}
> +#else
> +static int cpuidle_check_governor(struct cpuidle_driver *drv,
> +					struct cpuidle_device *dev, int enable)
> +{
> +	if (!cpuidle_curr_governor)
> +		return -EIO;
> +
> +	if (enable && cpuidle_curr_governor->enable)
> +		return cpuidle_curr_governor->enable(drv, dev);
> +	else if (cpuidle_curr_governor->disable)
> +		cpuidle_curr_governor->disable(drv, dev);
> +}
> +#endif
>  /**
>   * cpuidle_enable_device - enables idle PM for a CPU
>   * @dev: the CPU
> @@ -285,7 +331,7 @@ int cpuidle_enable_device(struct cpuidle_device *dev)
>  
>  	drv = cpuidle_get_cpu_driver(dev);
>  
> -	if (!drv || !cpuidle_curr_governor)
> +	if (!drv)
>  		return -EIO;
>  
>  	if (!dev->registered)
> @@ -298,8 +344,8 @@ int cpuidle_enable_device(struct cpuidle_device *dev)
>  	if (ret)
>  		return ret;
>  
> -	if (cpuidle_curr_governor->enable &&
> -	    (ret = cpuidle_curr_governor->enable(drv, dev)))
> +	ret = cpuidle_check_governor(drv, dev, 1);
> +	if (ret)
>  		goto fail_sysfs;
>  
>  	smp_wmb();
> @@ -331,13 +377,12 @@ void cpuidle_disable_device(struct cpuidle_device *dev)
>  	if (!dev || !dev->enabled)
>  		return;
>  
> -	if (!drv || !cpuidle_curr_governor)
> +	if (!drv)
>  		return;
> -
> +	
>  	dev->enabled = 0;
>  
> -	if (cpuidle_curr_governor->disable)
> -		cpuidle_curr_governor->disable(drv, dev);
> +	cpuidle_check_governor(drv, dev, 0);
>  
>  	cpuidle_remove_device_sysfs(dev);
>  	enabled_devices--;
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 7c19d55..5dd99b5 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -26,6 +26,7 @@ struct sched_param {
>  #include <linux/nodemask.h>
>  #include <linux/mm_types.h>
>  #include <linux/preempt_mask.h>
> +#include <linux/cpuidle.h>
>  
>  #include <asm/page.h>
>  #include <asm/ptrace.h>
> @@ -846,6 +847,14 @@ enum cpu_idle_type {
>  	CPU_MAX_IDLE_TYPES
>  };
>  
> +#ifdef CONFIG_SCHED_POWER
> +extern void cpuidle_sched_reflect(struct cpuidle_device *dev, int index);
> +extern int cpuidle_sched_select(struct cpuidle_driver *drv,
> +					struct cpuidle_device *dev);
> +extern int cpuidle_sched_enable_device(struct cpuidle_driver *drv,
> +						struct cpuidle_device *dev);
> +#endif
> +
>  /*
>   * Increase resolution of cpu_capacity calculations
>   */
> diff --git a/kernel/sched/Makefile b/kernel/sched/Makefile
> index ab32b7b..5b8e469 100644
> --- a/kernel/sched/Makefile
> +++ b/kernel/sched/Makefile
> @@ -19,3 +19,4 @@ obj-$(CONFIG_SCHED_AUTOGROUP) += auto_group.o
>  obj-$(CONFIG_SCHEDSTATS) += stats.o
>  obj-$(CONFIG_SCHED_DEBUG) += debug.o
>  obj-$(CONFIG_CGROUP_CPUACCT) += cpuacct.o
> +obj-$(CONFIG_SCHED_POWER) += power.o
> diff --git a/kernel/sched/power.c b/kernel/sched/power.c
> new file mode 100644
> index 0000000..63c9276
> --- /dev/null
> +++ b/kernel/sched/power.c
> @@ -0,0 +1,480 @@
> +/*
> + * power.c - the power aware scheduler
> + *
> + * Author:
> + *        Preeti U. Murthy <preeti@linux.vnet.ibm.com>
> + *
> + * This code is a replica of drivers/cpuidle/governors/menu.c
> + * To make the transition to power aware scheduler away from
> + * the cpuidle governor model easy, we do exactly what the
> + * governors do for now. Going ahead the heuristics will be
> + * tuned and improved upon.
> + *
> + * This code is licenced under the GPL version 2 as described
> + * in the COPYING file that acompanies the Linux Kernel.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/cpuidle.h>
> +#include <linux/pm_qos.h>
> +#include <linux/time.h>
> +#include <linux/ktime.h>
> +#include <linux/hrtimer.h>
> +#include <linux/tick.h>
> +#include <linux/sched.h>
> +#include <linux/math64.h>
> +#include <linux/module.h>
> +
> +/*
> + * Please note when changing the tuning values:
> + * If (MAX_INTERESTING-1) * RESOLUTION > UINT_MAX, the result of
> + * a scaling operation multiplication may overflow on 32 bit platforms.
> + * In that case, #define RESOLUTION as ULL to get 64 bit result:
> + * #define RESOLUTION 1024ULL
> + *
> + * The default values do not overflow.
> + */
> +#define BUCKETS 12
> +#define INTERVALS 8
> +#define RESOLUTION 1024
> +#define DECAY 8
> +#define MAX_INTERESTING 50000
> +
> +
> +/*
> + * Concepts and ideas behind the power aware scheduler
> + *
> + * For the power aware scheduler, there are 3 decision factors for picking a C
> + * state:
> + * 1) Energy break even point
> + * 2) Performance impact
> + * 3) Latency tolerance (from pmqos infrastructure)
> + * These these three factors are treated independently.
> + *
> + * Energy break even point
> + * -----------------------
> + * C state entry and exit have an energy cost, and a certain amount of time in
> + * the  C state is required to actually break even on this cost. CPUIDLE
> + * provides us this duration in the "target_residency" field. So all that we
> + * need is a good prediction of how long we'll be idle. Like the traditional
> + * governors, we start with the actual known "next timer event" time.
> + *
> + * Since there are other source of wakeups (interrupts for example) than
> + * the next timer event, this estimation is rather optimistic. To get a
> + * more realistic estimate, a correction factor is applied to the estimate,
> + * that is based on historic behavior. For example, if in the past the actual
> + * duration always was 50% of the next timer tick, the correction factor will
> + * be 0.5.
> + *
> + * power aware scheduler uses a running average for this correction factor,
> + * however it uses a set of factors, not just a single factor. This stems from
> + * the realization that the ratio is dependent on the order of magnitude of the
> + * expected duration; if we expect 500 milliseconds of idle time the likelihood of
> + * getting an interrupt very early is much higher than if we expect 50 micro
> + * seconds of idle time. A second independent factor that has big impact on
> + * the actual factor is if there is (disk) IO outstanding or not.
> + * (as a special twist, we consider every sleep longer than 50 milliseconds
> + * as perfect; there are no power gains for sleeping longer than this)
> + *
> + * For these two reasons we keep an array of 12 independent factors, that gets
> + * indexed based on the magnitude of the expected duration as well as the
> + * "is IO outstanding" property.
> + *
> + * Repeatable-interval-detector
> + * ----------------------------
> + * There are some cases where "next timer" is a completely unusable predictor:
> + * Those cases where the interval is fixed, for example due to hardware
> + * interrupt mitigation, but also due to fixed transfer rate devices such as
> + * mice.
> + * For this, we use a different predictor: We track the duration of the last 8
> + * intervals and if the stand deviation of these 8 intervals is below a
> + * threshold value, we use the average of these intervals as prediction.
> + *
> + * Limiting Performance Impact
> + * ---------------------------
> + * C states, especially those with large exit latencies, can have a real
> + * noticeable impact on workloads, which is not acceptable for most sysadmins,
> + * and in addition, less performance has a power price of its own.
> + *
> + * As a general rule of thumb, power aware sched assumes that the following
> + * heuristic holds:
> + *     The busier the system, the less impact of C states is acceptable
> + *
> + * This rule-of-thumb is implemented using a performance-multiplier:
> + * If the exit latency times the performance multiplier is longer than
> + * the predicted duration, the C state is not considered a candidate
> + * for selection due to a too high performance impact. So the higher
> + * this multiplier is, the longer we need to be idle to pick a deep C
> + * state, and thus the less likely a busy CPU will hit such a deep
> + * C state.
> + *
> + * Two factors are used in determing this multiplier:
> + * a value of 10 is added for each point of "per cpu load average" we have.
> + * a value of 5 points is added for each process that is waiting for
> + * IO on this CPU.
> + * (these values are experimentally determined)
> + *
> + * The load average factor gives a longer term (few seconds) input to the
> + * decision, while the iowait value gives a cpu local instantanious input.
> + * The iowait factor may look low, but realize that this is also already
> + * represented in the system load average.
> + *
> + */
> +
> +struct sched_cpuidle_info {
> +	int		last_state_idx;
> +	int             needs_update;
> +
> +	unsigned int	next_timer_us;
> +	unsigned int	predicted_us;
> +	unsigned int	bucket;
> +	unsigned int	correction_factor[BUCKETS];
> +	unsigned int	intervals[INTERVALS];
> +	int		interval_ptr;
> +};
> +
> +
> +#define LOAD_INT(x) ((x) >> FSHIFT)
> +#define LOAD_FRAC(x) LOAD_INT(((x) & (FIXED_1-1)) * 100)
> +
> +static int get_loadavg(void)
> +{
> +	unsigned long this = this_cpu_load();
> +
> +
> +	return LOAD_INT(this) * 10 + LOAD_FRAC(this) / 10;
> +}
> +
> +static inline int which_bucket(unsigned int duration)
> +{
> +	int bucket = 0;
> +
> +	/*
> +	 * We keep two groups of stats; one with no
> +	 * IO pending, one without.
> +	 * This allows us to calculate
> +	 * E(duration)|iowait
> +	 */
> +	if (nr_iowait_cpu(smp_processor_id()))
> +		bucket = BUCKETS/2;
> +
> +	if (duration < 10)
> +		return bucket;
> +	if (duration < 100)
> +		return bucket + 1;
> +	if (duration < 1000)
> +		return bucket + 2;
> +	if (duration < 10000)
> +		return bucket + 3;
> +	if (duration < 100000)
> +		return bucket + 4;
> +	return bucket + 5;
> +}
> +
> +/*
> + * Return a multiplier for the exit latency that is intended
> + * to take performance requirements into account.
> + * The more performance critical we estimate the system
> + * to be, the higher this multiplier, and thus the higher
> + * the barrier to go to an expensive C state.
> + */
> +static inline int performance_multiplier(void)
> +{
> +	int mult = 1;
> +
> +	/* for higher loadavg, we are more reluctant */
> +
> +	mult += 2 * get_loadavg();
> +
> +	/* for IO wait tasks (per cpu!) we add 5x each */
> +	mult += 10 * nr_iowait_cpu(smp_processor_id());
> +
> +	return mult;
> +}
> +
> +static DEFINE_PER_CPU(struct sched_cpuidle_info, cpuidle_info );
> +
> +static void cpuidle_sched_update(struct cpuidle_driver *drv,
> +					struct cpuidle_device *dev);
> +
> +/* This implements DIV_ROUND_CLOSEST but avoids 64 bit division */
> +static u64 div_round64(u64 dividend, u32 divisor)
> +{
> +	return div_u64(dividend + (divisor / 2), divisor);
> +}
> +
> +/*
> + * Try detecting repeating patterns by keeping track of the last 8
> + * intervals, and checking if the standard deviation of that set
> + * of points is below a threshold. If it is... then use the
> + * average of these 8 points as the estimated value.
> + */
> +static void get_typical_interval(struct sched_cpuidle_info *data)
> +{
> +	int i, divisor;
> +	unsigned int max, thresh;
> +	uint64_t avg, stddev;
> +
> +	thresh = UINT_MAX; /* Discard outliers above this value */
> +
> +again:
> +
> +	/* First calculate the average of past intervals */
> +	max = 0;
> +	avg = 0;
> +	divisor = 0;
> +	for (i = 0; i < INTERVALS; i++) {
> +		unsigned int value = data->intervals[i];
> +		if (value <= thresh) {
> +			avg += value;
> +			divisor++;
> +			if (value > max)
> +				max = value;
> +		}
> +	}
> +	do_div(avg, divisor);
> +
> +	/* Then try to determine standard deviation */
> +	stddev = 0;
> +	for (i = 0; i < INTERVALS; i++) {
> +		unsigned int value = data->intervals[i];
> +		if (value <= thresh) {
> +			int64_t diff = value - avg;
> +			stddev += diff * diff;
> +		}
> +	}
> +	do_div(stddev, divisor);
> +	/*
> +	 * The typical interval is obtained when standard deviation is small
> +	 * or standard deviation is small compared to the average interval.
> +	 *
> +	 * int_sqrt() formal parameter type is unsigned long. When the
> +	 * greatest difference to an outlier exceeds ~65 ms * sqrt(divisor)
> +	 * the resulting squared standard deviation exceeds the input domain
> +	 * of int_sqrt on platforms where unsigned long is 32 bits in size.
> +	 * In such case reject the candidate average.
> +	 *
> +	 * Use this result only if there is no timer to wake us up sooner.
> +	 */
> +	if (likely(stddev <= ULONG_MAX)) {
> +		stddev = int_sqrt(stddev);
> +		if (((avg > stddev * 6) && (divisor * 4 >= INTERVALS * 3))
> +							|| stddev <= 20) {
> +			if (data->next_timer_us > avg)
> +				data->predicted_us = avg;
> +			return;
> +		}
> +	}
> +
> +	/*
> +	 * If we have outliers to the upside in our distribution, discard
> +	 * those by setting the threshold to exclude these outliers, then
> +	 * calculate the average and standard deviation again. Once we get
> +	 * down to the bottom 3/4 of our samples, stop excluding samples.
> +	 *
> +	 * This can deal with workloads that have long pauses interspersed
> +	 * with sporadic activity with a bunch of short pauses.
> +	 */
> +	if ((divisor * 4) <= INTERVALS * 3)
> +		return;
> +
> +	thresh = max - 1;
> +	goto again;
> +}
> +
> +/**
> + * cpuidle_sched_select - selects the next idle state to enter
> + * @drv: cpuidle driver containing state data
> + * @dev: the CPU
> + */
> +int cpuidle_sched_select(struct cpuidle_driver *drv,
> +				struct cpuidle_device *dev)
> +{
> +	struct sched_cpuidle_info *data = &__get_cpu_var(cpuidle_info);
> +	int latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
> +	int i;
> +	unsigned int interactivity_req;
> +	struct timespec t;
> +
> +	if (data->needs_update) {
> +		cpuidle_sched_update(drv, dev);
> +		data->needs_update = 0;
> +	}
> +
> +	data->last_state_idx = CPUIDLE_DRIVER_STATE_START - 1;
> +
> +	/* Special case when user has set very strict latency requirement */
> +	if (unlikely(latency_req == 0))
> +		return 0;
> +
> +	/* determine the expected residency time, round up */
> +	t = ktime_to_timespec(tick_nohz_get_sleep_length());
> +	data->next_timer_us =
> +		t.tv_sec * USEC_PER_SEC + t.tv_nsec / NSEC_PER_USEC;
> +
> +
> +	data->bucket = which_bucket(data->next_timer_us);
> +
> +	/*
> +	 * Force the result of multiplication to be 64 bits even if both
> +	 * operands are 32 bits.
> +	 * Make sure to round up for half microseconds.
> +	 */
> +	data->predicted_us = div_round64((uint64_t)data->next_timer_us *
> +					 data->correction_factor[data->bucket],
> +					 RESOLUTION * DECAY);
> +
> +	get_typical_interval(data);
> +
> +	/*
> +	 * Performance multiplier defines a minimum predicted idle
> +	 * duration / latency ratio. Adjust the latency limit if
> +	 * necessary.
> +	 */
> +	interactivity_req = data->predicted_us / performance_multiplier();
> +	if (latency_req > interactivity_req)
> +		latency_req = interactivity_req;
> +
> +	/*
> +	 * We want to default to C1 (hlt), not to busy polling
> +	 * unless the timer is happening really really soon.
> +	 */
> +	if (data->next_timer_us > 5 &&
> +	    !drv->states[CPUIDLE_DRIVER_STATE_START].disabled &&
> +		dev->states_usage[CPUIDLE_DRIVER_STATE_START].disable == 0)
> +		data->last_state_idx = CPUIDLE_DRIVER_STATE_START;
> +
> +	/*
> +	 * Find the idle state with the lowest power while satisfying
> +	 * our constraints.
> +	 */
> +	for (i = CPUIDLE_DRIVER_STATE_START; i < drv->state_count; i++) {
> +		struct cpuidle_state *s = &drv->states[i];
> +		struct cpuidle_state_usage *su = &dev->states_usage[i];
> +
> +		if (s->disabled || su->disable)
> +			continue;
> +		if (s->target_residency > data->predicted_us)
> +			continue;
> +		if (s->exit_latency > latency_req)
> +			continue;
> +
> +		data->last_state_idx = i;
> +	}
> +
> +	return data->last_state_idx;
> +}
> +
> +/**
> + * cpuidle_sched_reflect - records that data structures need update
> + * @dev: the CPU
> + * @index: the index of actual entered state
> + *
> + * NOTE: it's important to be fast here because this operation will add to
> + *       the overall exit latency.
> + */
> +void cpuidle_sched_reflect(struct cpuidle_device *dev, int index)
> +{
> +	struct sched_cpuidle_info *data = &__get_cpu_var(cpuidle_info);
> +	data->last_state_idx = index;
> +	if (index >= 0)
> +		data->needs_update = 1;
> +}
> +
> +/**
> + * cpuidle_sched_update - attempts to guess what happened after entry
> + * @drv: cpuidle driver containing state data
> + * @dev: the CPU
> + */
> +static void cpuidle_sched_update(struct cpuidle_driver *drv, struct cpuidle_device *dev)
> +{
> +	struct sched_cpuidle_info *data = &__get_cpu_var(cpuidle_info);
> +	int last_idx = data->last_state_idx;
> +	struct cpuidle_state *target = &drv->states[last_idx];
> +	unsigned int measured_us;
> +	unsigned int new_factor;
> +
> +	/*
> +	 * Try to figure out how much time passed between entry to low
> +	 * power state and occurrence of the wakeup event.
> +	 *
> +	 * If the entered idle state didn't support residency measurements,
> +	 * we are basically lost in the dark how much time passed.
> +	 * As a compromise, assume we slept for the whole expected time.
> +	 *
> +	 * Any measured amount of time will include the exit latency.
> +	 * Since we are interested in when the wakeup begun, not when it
> +	 * was completed, we must subtract the exit latency. However, if
> +	 * the measured amount of time is less than the exit latency,
> +	 * assume the state was never reached and the exit latency is 0.
> +	 */
> +	if (unlikely(!(target->flags & CPUIDLE_FLAG_TIME_VALID))) {
> +		/* Use timer value as is */
> +		measured_us = data->next_timer_us;
> +
> +	} else {
> +		/* Use measured value */
> +		measured_us = cpuidle_get_last_residency(dev);
> +
> +		/* Deduct exit latency */
> +		if (measured_us > target->exit_latency)
> +			measured_us -= target->exit_latency;
> +
> +		/* Make sure our coefficients do not exceed unity */
> +		if (measured_us > data->next_timer_us)
> +			measured_us = data->next_timer_us;
> +	}
> +
> +	/* Update our correction ratio */
> +	new_factor = data->correction_factor[data->bucket];
> +	new_factor -= new_factor / DECAY;
> +
> +	if (data->next_timer_us > 0 && measured_us < MAX_INTERESTING)
> +		new_factor += RESOLUTION * measured_us / data->next_timer_us;
> +	else
> +		/*
> +		 * we were idle so long that we count it as a perfect
> +		 * prediction
> +		 */
> +		new_factor += RESOLUTION;
> +
> +	/*
> +	 * We don't want 0 as factor; we always want at least
> +	 * a tiny bit of estimated time. Fortunately, due to rounding,
> +	 * new_factor will stay nonzero regardless of measured_us values
> +	 * and the compiler can eliminate this test as long as DECAY > 1.
> +	 */
> +	if (DECAY == 1 && unlikely(new_factor == 0))
> +		new_factor = 1;
> +
> +	data->correction_factor[data->bucket] = new_factor;
> +
> +	/* update the repeating-pattern data */
> +	data->intervals[data->interval_ptr++] = measured_us;
> +	if (data->interval_ptr >= INTERVALS)
> +		data->interval_ptr = 0;
> +}
> +
> +/**
> + * cpuidle_sched_enable_device - scans a CPU's states and does setup
> + * @drv: cpuidle driver
> + * @dev: the CPU
> + */
> +int cpuidle_sched_enable_device(struct cpuidle_driver *drv,
> +				struct cpuidle_device *dev)
> +{
> +	struct sched_cpuidle_info *data = &per_cpu(cpuidle_info, dev->cpu);
> +	int i;
> +
> +	memset(data, 0, sizeof(struct sched_cpuidle_info));
> +
> +	/*
> +	 * if the correction factor is 0 (eg first time init or cpu hotplug
> +	 * etc), we actually want to start out with a unity factor.
> +	 */
> +	for(i = 0; i < BUCKETS; i++)
> +		data->correction_factor[i] = RESOLUTION * DECAY;
> +
> +	return 0;
> +}
> +
> 
> 
