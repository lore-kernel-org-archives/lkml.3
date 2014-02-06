Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428AbaBFMgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 07:36:21 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56171 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756128AbaBFMgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 07:36:19 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: rafael.j.wysocki@intel.com, linux-pm@vger.kernel.org, peterz@infradead.org,
        fweisbec@gmail.com, daniel.lezcano@linaro.org,
        linux-kernel@vger.kernel.org, paulus@samba.org,
        benh@kernel.crashing.org, tglx@linutronix.de,
        linuxppc-dev@lists.ozlabs.org, mingo@kernel.org,
        deepthi@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, srivatsa.bhat@linux.vnet.ibm.com
Subject: Re: [PATCH V3 3/3] time/cpuidle:Handle failed call to BROADCAST_ENTER on archs with CPUIDLE_FLAG_TIMER_STOP set
Date: Thu, 06 Feb 2014 13:50:50 +0100
Message-ID: <5055510.EE1aECadbX@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <20140206055036.4595.86947.stgit@preeti>
References: <20140206054158.4595.17827.stgit@preeti> <20140206055036.4595.86947.stgit@preeti>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 06, 2014 11:20:37 AM Preeti U Murthy wrote:
> Some archs set the CPUIDLE_FLAG_TIMER_STOP flag for idle states in which the
> local timers stop. The cpuidle_idle_call() currently handles such idle states
> by calling into the broadcast framework so as to wakeup CPUs at their next
> wakeup event. With the hrtimer mode of broadcast, the BROADCAST_ENTER call
> into the broadcast frameowork can fail for archs that do not have an external
> clock device to handle wakeups and the CPU in question has to thus be made
> the stand by CPU. This patch handles such cases by failing the call into
> cpuidle so that the arch can take some default action. The arch will certainly
> not enter a similar idle state because a failed cpuidle call will also implicitly
> indicate that the broadcast framework has not registered this CPU to be woken up.
> Hence we are safe if we fail the cpuidle call.
> 
> In the process move the functions that trace idle statistics just before and
> after the entry and exit into idle states respectively. In other
> scenarios where the call to cpuidle fails, we end up not tracing idle
> entry and exit since a decision on an idle state could not be taken. Similarly
> when the call to broadcast framework fails, we skip tracing idle statistics
> because we are in no further position to take a decision on an alternative
> idle state to enter into.
> 
> Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>

The cpuidle changes in this patch look reasonable to me, but I guess you'd
like it to go in via tip along with the rest of the series, so

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
> 
>  drivers/cpuidle/cpuidle.c |   38 +++++++++++++++++++++++---------------
>  1 file changed, 23 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index a55e68f..8f42033 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -117,15 +117,19 @@ int cpuidle_idle_call(void)
>  {
>  	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
>  	struct cpuidle_driver *drv;
> -	int next_state, entered_state;
> -	bool broadcast;
> +	int next_state, entered_state, ret = 0;
> +	bool broadcast = false;
>  
> -	if (off || !initialized)
> -		return -ENODEV;
> +	if (off || !initialized) {
> +		ret = -ENODEV;
> +		goto out;
> +	}
>  
>  	/* check if the device is ready */
> -	if (!dev || !dev->enabled)
> -		return -EBUSY;
> +	if (!dev || !dev->enabled) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
>  
>  	drv = cpuidle_get_cpu_driver(dev);
>  
> @@ -137,15 +141,18 @@ int cpuidle_idle_call(void)
>  		if (cpuidle_curr_governor->reflect)
>  			cpuidle_curr_governor->reflect(dev, next_state);
>  		local_irq_enable();
> -		return 0;
> +		goto out;
>  	}
>  
> -	trace_cpu_idle_rcuidle(next_state, dev->cpu);
> -
>  	broadcast = !!(drv->states[next_state].flags & CPUIDLE_FLAG_TIMER_STOP);
>  
> -	if (broadcast)
> -		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu);
> +	if (broadcast) {
> +		ret = clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu);
> +		if (ret)
> +			goto out;
> +	}
> +
> +	trace_cpu_idle_rcuidle(next_state, dev->cpu);
>  
>  	if (cpuidle_state_is_coupled(dev, drv, next_state))
>  		entered_state = cpuidle_enter_state_coupled(dev, drv,
> @@ -153,16 +160,17 @@ int cpuidle_idle_call(void)
>  	else
>  		entered_state = cpuidle_enter_state(dev, drv, next_state);
>  
> -	if (broadcast)
> -		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
> -
>  	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
>  
>  	/* give the governor an opportunity to reflect on the outcome */
>  	if (cpuidle_curr_governor->reflect)
>  		cpuidle_curr_governor->reflect(dev, entered_state);
>  
> -	return 0;
> +out:	if (broadcast)
> +		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
> +
> +
> +	return ret;
>  }
>  
>  /**
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
