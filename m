Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbaBYDvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 22:51:41 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:59131 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaBYDvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 22:51:40 -0500
Message-ID: <530C126B.4060105@linux.vnet.ibm.com>
Date: Tue, 25 Feb 2014 09:17:55 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        rjw@rjwysocki.net, nicolas.pitre@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/5] idle/cpuidle: Split cpuidle_idle_call main function
 into smaller functions
References: <1393250151-6982-1-git-send-email-daniel.lezcano@linaro.org>
In-Reply-To: <1393250151-6982-1-git-send-email-daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022503-0928-0000-0000-0000070A2207
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On 02/24/2014 07:25 PM, Daniel Lezcano wrote:
> ---
>  drivers/cpuidle/cpuidle.c |  114 ++++++++++++++++++++++++++++++++++------------
>  include/linux/cpuidle.h   |   19 +++++++
>  2 files changed, 105 insertions(+), 28 deletions(-)
> 
> Index: cpuidle-next/drivers/cpuidle/cpuidle.c
> ===================================================================
> --- cpuidle-next.orig/drivers/cpuidle/cpuidle.c
> +++ cpuidle-next/drivers/cpuidle/cpuidle.c
> @@ -65,6 +65,26 @@ int cpuidle_play_dead(void)
>  }
> 
>  /**
> + * cpuidle_enabled - check if the cpuidle framework is ready
> + * @dev: cpuidle device for this cpu
> + * @drv: cpuidle driver for this cpu
> + *
> + * Return 0 on success, otherwise:
> + * -NODEV : the cpuidle framework is not available
> + * -EBUSY : the cpuidle framework is not initialized
> + */
> +int cpuidle_enabled(struct cpuidle_driver *drv, struct cpuidle_device *dev)
> +{
> +	if (off || !initialized)
> +		return -ENODEV;
> +
> +	if (!drv || !dev || !dev->enabled)
> +		return -EBUSY;
> +
> +	return 0;
> +}
> +
> +/**
>   * cpuidle_enter_state - enter the state and update stats
>   * @dev: cpuidle device for this cpu
>   * @drv: cpuidle driver for this cpu
> @@ -108,6 +128,63 @@ int cpuidle_enter_state(struct cpuidle_d
>  }
> 
>  /**
> + * cpuidle_select - ask the cpuidle framework to choose an idle state
> + *
> + * @drv: the cpuidle driver
> + * @dev: the cpuidle device
> + *
> + * Returns the index of the idle state.
> + */
> +int cpuidle_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
> +{
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
> @@ -116,51 +193,32 @@ int cpuidle_enter_state(struct cpuidle_d
>  int cpuidle_idle_call(void)
>  {
>  	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
> -	struct cpuidle_driver *drv;
> +	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
>  	int next_state, entered_state;
> -	bool broadcast;
> 
> -	if (off || !initialized)
> -		return -ENODEV;
> -
> -	/* check if the device is ready */
> -	if (!dev || !dev->enabled)
> -		return -EBUSY;
> -
> -	drv = cpuidle_get_cpu_driver(dev);
> +	next_state = cpuidle_enabled(drv, dev);

Accepting the return of cpuidle_enabled() into a parameter named
"next_state" looks misleading. You are not returning any idle state. You
could use ret/enabled to accept the return value here perhaps?

> +	if (next_state < 0)
> +		return next_state;
> 
>  	/* ask the governor for the next state */
> -	next_state = cpuidle_curr_governor->select(drv, dev);
> +	next_state = cpuidle_select(drv, dev);
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

Shouldn't the return value be checked here, considering you are
expecting the driver to return an error code. Another reason I mention
this is that since you would have done BROADCAST_ENTRY and if this call
to the broadcast framework succeeds, you will have to do a
BROADCAST_EXIT irrespective of if the driver could put the CPU to that
idle state or not. So even if cpuidle_enter() fails, you will need to do
a clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu),
although you will have to skip over cpuidle_reflect().

So are there drivers which can return an error code when we call into
the enter function of the idle states? If not, you can probably avoid
checking the error code return value of cpuidle_enter() altogether and
make it simpler. Its not being checked in the current code too.

Thanks

Regards
Preeti U Murthy
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

