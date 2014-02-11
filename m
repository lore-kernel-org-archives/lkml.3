Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451AbaBKR1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:27:25 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:46369 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaBKR1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:27:22 -0500
Date: Tue, 11 Feb 2014 12:27:19 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
cc: mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        rjw@rjwysocki.net, preeti@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] idle/cpuidle: Split cpuidle_idle_call main function
 into smaller functions
In-Reply-To: <1392131491-5265-1-git-send-email-daniel.lezcano@linaro.org>
Message-ID: <alpine.LFD.2.11.1402111226370.17677@knanqh.ubzr>
References: <1392131491-5265-1-git-send-email-daniel.lezcano@linaro.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Feb 2014, Daniel Lezcano wrote:

> In order to allow better integration between the cpuidle framework and the
> scheduler, reducing the distance between these two sub-components will
> facilitate this integration by moving part of the cpuidle code in the idle
> task file and, because idle.c is in the sched directory, we have access to
> the scheduler's private structures.
> 
> This patch splits the cpuidle_idle_call main entry function into 3 calls
> to a newly added API:
>  1. select the idle state
>  2. enter the idle state
>  3. reflect the idle state
> 
> The cpuidle_idle_call calls these three functions to implement the main
> idle entry function.
> 
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>

Acked-by: Nicolas Pitre <nico@linaro.org>

> ---
>  drivers/cpuidle/cpuidle.c |  102 ++++++++++++++++++++++++++++++++-------------
>  include/linux/cpuidle.h   |   14 +++++++
>  2 files changed, 87 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index a55e68f..172ab6a 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -108,6 +108,71 @@ int cpuidle_enter_state(struct cpuidle_device *dev, struct cpuidle_driver *drv,
>  }
>  
>  /**
> + * cpuidle_select - ask the cpuidle framework to choose an idle state
> + *
> + * @drv: the cpuidle driver
> + * @dev: the cpuidle device
> + *
> + * Returns the index of the idle state. On error it returns:
> + * -NODEV : the cpuidle framework is not available
> + * -EBUSY : the cpuidle framework is not initialized
> + */
> +int cpuidle_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
> +{
> +	if (off || !initialized)
> +		return -ENODEV;
> +
> +	if (!drv || !dev || !dev->enabled)
> +		return -EBUSY;
> +
> +	return cpuidle_curr_governor->select(drv, dev);
> +}
> +
> +/**
> + * cpuidle_enter - enter into the specified idle state
> + *
> + * @drv:   the cpuidle driver tied with the cpu
> + * @dev:   the cpuidle device
> + * @index: the index in the idle state table
> + *
> + * Returns the index in the idle state, < 0 in case of error.
> + * The error code depends on the backend driver
> + */
> +int cpuidle_enter(struct cpuidle_driver *drv, struct cpuidle_device *dev,
> +		  int index)
> +{
> +	int entered_state;
> +	bool broadcast = !!(drv->states[index].flags & CPUIDLE_FLAG_TIMER_STOP);
> +
> +	if (broadcast)
> +		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu);
> +
> +	if (cpuidle_state_is_coupled(dev, drv, index))
> +		entered_state = cpuidle_enter_state_coupled(dev, drv, index);
> +	else
> +		entered_state = cpuidle_enter_state(dev, drv, index);
> +
> +	if (broadcast)
> +		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
> +
> +	return entered_state;
> +}
> +
> +/**
> + * cpuidle_reflect - tell the underlying governor what was the state
> + * we were in
> + *
> + * @dev  : the cpuidle device
> + * @index: the index in the idle state table
> + *
> + */
> +void cpuidle_reflect(struct cpuidle_device *dev, int index)
> +{
> +	if (cpuidle_curr_governor->reflect)
> +		cpuidle_curr_governor->reflect(dev, index);
> +}
> +
> +/**
>   * cpuidle_idle_call - the main idle loop
>   *
>   * NOTE: no locks or semaphores should be used here
> @@ -116,51 +181,30 @@ int cpuidle_enter_state(struct cpuidle_device *dev, struct cpuidle_driver *drv,
>  int cpuidle_idle_call(void)
>  {
>  	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
> -	struct cpuidle_driver *drv;
> +	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
>  	int next_state, entered_state;
> -	bool broadcast;
> -
> -	if (off || !initialized)
> -		return -ENODEV;
> -
> -	/* check if the device is ready */
> -	if (!dev || !dev->enabled)
> -		return -EBUSY;
> -
> -	drv = cpuidle_get_cpu_driver(dev);
>  
>  	/* ask the governor for the next state */
> -	next_state = cpuidle_curr_governor->select(drv, dev);
> +	next_state = cpuidle_select(drv, dev);
> +	if (next_state < 0)
> +		return next_state;
> +
>  	if (need_resched()) {
>  		dev->last_residency = 0;
>  		/* give the governor an opportunity to reflect on the outcome */
> -		if (cpuidle_curr_governor->reflect)
> -			cpuidle_curr_governor->reflect(dev, next_state);
> +		cpuidle_reflect(dev, next_state);
>  		local_irq_enable();
>  		return 0;
>  	}
>  
>  	trace_cpu_idle_rcuidle(next_state, dev->cpu);
>  
> -	broadcast = !!(drv->states[next_state].flags & CPUIDLE_FLAG_TIMER_STOP);
> -
> -	if (broadcast)
> -		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu);
> -
> -	if (cpuidle_state_is_coupled(dev, drv, next_state))
> -		entered_state = cpuidle_enter_state_coupled(dev, drv,
> -							    next_state);
> -	else
> -		entered_state = cpuidle_enter_state(dev, drv, next_state);
> -
> -	if (broadcast)
> -		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
> +	entered_state = cpuidle_enter(drv, dev, next_state);
>  
>  	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
>  
>  	/* give the governor an opportunity to reflect on the outcome */
> -	if (cpuidle_curr_governor->reflect)
> -		cpuidle_curr_governor->reflect(dev, entered_state);
> +	cpuidle_reflect(dev, entered_state);
>  
>  	return 0;
>  }
> diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
> index 50fcbb0..bf06f37 100644
> --- a/include/linux/cpuidle.h
> +++ b/include/linux/cpuidle.h
> @@ -119,6 +119,13 @@ struct cpuidle_driver {
>  
>  #ifdef CONFIG_CPU_IDLE
>  extern void disable_cpuidle(void);
> +
> +extern int cpuidle_select(struct cpuidle_driver *drv,
> +			  struct cpuidle_device *dev);
> +extern int cpuidle_enter(struct cpuidle_driver *drv,
> +			 struct cpuidle_device *dev, int index);
> +extern void cpuidle_reflect(struct cpuidle_device *dev, int index);
> +
>  extern int cpuidle_idle_call(void);
>  extern int cpuidle_register_driver(struct cpuidle_driver *drv);
>  extern struct cpuidle_driver *cpuidle_get_driver(void);
> @@ -141,6 +148,13 @@ extern int cpuidle_play_dead(void);
>  extern struct cpuidle_driver *cpuidle_get_cpu_driver(struct cpuidle_device *dev);
>  #else
>  static inline void disable_cpuidle(void) { }
> +static inline int cpuidle_select(struct cpuidle_driver *drv,
> +				 struct cpuidle_device *dev)
> +{return -ENODEV; }
> +static inline int cpuidle_enter(struct cpuidle_driver *drv,
> +				struct cpuidle_device *dev, int index)
> +{return -ENODEV; }
> +static inline void cpuidle_reflect(struct cpuidle_device *dev, int index) { }
>  static inline int cpuidle_idle_call(void) { return -ENODEV; }
>  static inline int cpuidle_register_driver(struct cpuidle_driver *drv)
>  {return -ENODEV; }
> -- 
> 1.7.9.5
> 
