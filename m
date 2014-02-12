Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbaBLKmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 05:42:13 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:51973 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbaBLKmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 05:42:10 -0500
Message-ID: <52FB4F1D.9030303@linux.vnet.ibm.com>
Date: Wed, 12 Feb 2014 16:08:21 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        rjw@rjwysocki.net, nicolas.pitre@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] idle/cpuidle: Split cpuidle_idle_call main function
 into smaller functions
References: <1392131491-5265-1-git-send-email-daniel.lezcano@linaro.org>
In-Reply-To: <1392131491-5265-1-git-send-email-daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021210-5490-0000-0000-000004EFC2D2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On 02/11/2014 08:41 PM, Daniel Lezcano wrote:
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

I would suggest moving the above two conditions under another function,
cpuidle_enabled() maybe? The reason is, cpuidle_select() indicates that,
it is invoked to select an idle state. While you are expecting this
function to return an idle state, it seems counter-intuitive to return a
ENODEV/EBUSY. This function is expected to be a call into the governor
specific code and the same function should not be used to verify if
cpuidle is enabled/not IMHO.

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

The tip tree, timers/core branch has the patch,
tick: Introduce hrtimer based broadcast. In the problem scenario that
this patchset is addressing, the call to broadcast framework may return
an error indicating that the idle state in question cannot be entered
into. I wanted to bring it to your notice, so that early on you can take
care of this. You will need to add code below in the invocation of
cpuidle_enter() to verify if the idle state was entered into or not. If
it was not, then you will need to skip tracing and reflecting of the
idle state and directly exit the cpuidle loop with a failed status.

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

Thanks

Regards
Preeti U Murthy

