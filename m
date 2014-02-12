Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbaBLLDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 06:03:54 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:35047 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaBLLDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 06:03:51 -0500
Message-ID: <52FB543B.2060105@linux.vnet.ibm.com>
Date: Wed, 12 Feb 2014 16:30:11 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        rjw@rjwysocki.net, nicolas.pitre@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] idle: Reorganize the idle loop
References: <1392131491-5265-1-git-send-email-daniel.lezcano@linaro.org> <1392131491-5265-3-git-send-email-daniel.lezcano@linaro.org>
In-Reply-To: <1392131491-5265-3-git-send-email-daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021211-1618-0000-0000-0000056E28C5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

Find below a couple of comments.

On 02/11/2014 08:41 PM, Daniel Lezcano wrote:
> Now that we have the main cpuidle function in idle.c, move some code from
> the idle mainloop to this function for the sake of clarity.
> 
> That removes if then else indentation difficult to follow when looking at the
> code. This patch does not the change the current behavior.
> 
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> ---
>  include/linux/cpuidle.h |    2 ++
>  kernel/sched/idle.c     |   39 ++++++++++++++++++++-------------------
>  2 files changed, 22 insertions(+), 19 deletions(-)
> 
> diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
> index 0befaff..a8d5bd3 100644
> --- a/include/linux/cpuidle.h
> +++ b/include/linux/cpuidle.h
> @@ -175,6 +175,8 @@ static inline int cpuidle_enable_device(struct cpuidle_device *dev)
>  {return -ENODEV; }
>  static inline void cpuidle_disable_device(struct cpuidle_device *dev) { }
>  static inline int cpuidle_play_dead(void) {return -ENODEV; }
> +static inline struct cpuidle_driver *cpuidle_get_cpu_driver(
> +	struct cpuidle_device *dev) {return NULL; }
>  #endif
> 
>  #ifdef CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED
> diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
> index 6963822..8b10891 100644
> --- a/kernel/sched/idle.c
> +++ b/kernel/sched/idle.c
> @@ -63,7 +63,6 @@ void __weak arch_cpu_idle(void)
>  	local_irq_enable();
>  }
> 
> -#ifdef CONFIG_CPU_IDLE
>  /**
>   * cpuidle_idle_call - the main idle function
>   *
> @@ -76,17 +75,26 @@ static int cpuidle_idle_call(void)
>  	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
>  	int next_state, entered_state;
> 
> -	/* ask the governor for the next state */
> +	stop_critical_timings();
> +	rcu_idle_enter();
> +
> +	/* Ask the governor for the next state, this call can fail for
> +	 * different reasons: cpuidle is not enabled or an idle state
> +	 * fulfilling the constraints was not found. In this case, we fall
> +	 * back to the default idle function
> +	 */
>  	next_state = cpuidle_select(drv, dev);
> -	if (next_state < 0)
> -		return next_state;
> +	if (next_state < 0) {
> +		arch_cpu_idle();
> +		goto out;
> +	}
> 
>  	if (need_resched()) {
>  		dev->last_residency = 0;
>  		/* give the governor an opportunity to reflect on the outcome */
>  		cpuidle_reflect(dev, next_state);
>  		local_irq_enable();
> -		return 0;
> +		goto out;
>  	}
> 
>  	trace_cpu_idle_rcuidle(next_state, dev->cpu);
> @@ -97,15 +105,15 @@ static int cpuidle_idle_call(void)
> 
>  	/* give the governor an opportunity to reflect on the outcome */
>  	cpuidle_reflect(dev, entered_state);
> +out:
> +	if (WARN_ON_ONCE(irqs_disabled()))
> +		local_irq_enable();
> +
> +	rcu_idle_exit();
> +	start_critical_timings();
> 
>  	return 0;
>  }
> -#else
> -static inline int cpuidle_idle_call(void)
> -{
> -	return -ENODEV;
> -}
> -#endif
> 
>  /*
>   * Generic idle loop implementation
> @@ -138,14 +146,7 @@ static void cpu_idle_loop(void)
>  				cpu_idle_poll();
>  			} else {
>  				if (!current_clr_polling_and_test()) {
> -					stop_critical_timings();
> -					rcu_idle_enter();
> -					if (cpuidle_idle_call())
> -						arch_cpu_idle();
> -					if (WARN_ON_ONCE(irqs_disabled()))
> -						local_irq_enable();
> -					rcu_idle_exit();
> -					start_critical_timings();
> +					cpuidle_idle_call();
>  				} else {
>  					local_irq_enable();
>  				}

Is this really necessary? It seems better to let the cpuidle_idle_loop()
to handle the cpuidle specific tasks and the generic idle loop to handle
the peripheral functions like stop_critical_timings(), rcu_idle_enter()
and their counterparts. I am unable to see what we are gaining by doing
this.

Besides, cpuidle_idle_call() is expected to just call into the cpuidle
governor and driver. What I would have expected this patchset to do is
simply move this call under kernel/sched like you have done in your
first two patches so as to gain the benefit of using the parameters that
the scheduler keeps track of to make better cpuidle state entry decisions.

But going one step too far by moving the other idle handling functions
into it would result in some confusion and add more code than it is
meant to handle. This will avoid having to add  comments in the
cpuidle_idle_call() function as currently being done in Patch[5/5], to
clarify what each function is meant to do.

So IMO, Patches[1/5] and [2/5] by themselves are sufficient to increase
the proximity between scheduler and cpuidle.


Thanks

Regards
Preeti U Murthy
> 

