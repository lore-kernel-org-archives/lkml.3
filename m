Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965149AbaD3Wa5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 18:30:57 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:56298 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933813AbaD3Waz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 18:30:55 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: peterz@infradead.org, mingo@elte.hu, amit.kucheria@linaro.org,
        linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/2] sched: idle: Encapsulate the code to compile it out
Date: Thu, 01 May 2014 00:47:25 +0200
Message-ID: <2783362.8r7SvVhudq@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1398859263-7632-1-git-send-email-daniel.lezcano@linaro.org>
References: <1398859263-7632-1-git-send-email-daniel.lezcano@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 30, 2014 02:01:02 PM Daniel Lezcano wrote:
> Encapsulate the large portion of cpuidle_idle_call inside another
> function so when CONFIG_CPU_IDLE=n, the code will be compiled out.
> Also that is benefitial for the clarity of the code as it removes
> a nested indentation level.
> 
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>

Well, this conflicts with

https://patchwork.kernel.org/patch/4071541/

which you haven't commented on and I still want cpuidle_select() to be able to
return negative values because of

https://patchwork.kernel.org/patch/4089631/

(and I have one more patch on top of these two that requires this).

Any ideas how to resolve that?


> ---
>  kernel/sched/idle.c |  161 +++++++++++++++++++++++++++------------------------
>  1 file changed, 86 insertions(+), 75 deletions(-)
> 
> diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
> index b8cd302..f2f4bc9 100644
> --- a/kernel/sched/idle.c
> +++ b/kernel/sched/idle.c
> @@ -63,6 +63,90 @@ void __weak arch_cpu_idle(void)
>  	local_irq_enable();
>  }
>  
> +#ifdef CONFIG_CPU_IDLE
> +static int __cpuidle_idle_call(void)
> +{
> +	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
> +	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
> +	int next_state, entered_state, ret;
> +	bool broadcast;
> +
> +	/*
> +	 * Check if the cpuidle framework is ready, otherwise fallback
> +	 * to the default arch specific idle method
> +	 */
> +	ret = cpuidle_enabled(drv, dev);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * Ask the governor to choose an idle state it thinks
> +	 * it is convenient to go to. There is *always* a
> +	 * convenient idle state
> +	 */
> +	next_state = cpuidle_select(drv, dev);
> +
> +	/*
> +	 * The idle task must be scheduled, it is pointless to
> +	 * go to idle, just update no idle residency and get
> +	 * out of this function
> +	 */
> +	if (current_clr_polling_and_test()) {
> +		dev->last_residency = 0;
> +		entered_state = next_state;
> +		local_irq_enable();
> +	} else {
> +		broadcast = !!(drv->states[next_state].flags &
> +			       CPUIDLE_FLAG_TIMER_STOP);
> +
> +		if (broadcast)
> +			/*
> +			 * Tell the time framework to switch to a
> +			 * broadcast timer because our local timer
> +			 * will be shutdown. If a local timer is used
> +			 * from another cpu as a broadcast timer, this
> +			 * call may fail if it is not available
> +			 */
> +			ret = clockevents_notify(
> +				CLOCK_EVT_NOTIFY_BROADCAST_ENTER,
> +				&dev->cpu);
> +
> +		if (!ret) {
> +			trace_cpu_idle_rcuidle(next_state, dev->cpu);
> +
> +			/*
> +			 * Enter the idle state previously returned by
> +			 * the governor decision. This function will
> +			 * block until an interrupt occurs and will
> +			 * take care of re-enabling the local
> +			 * interrupts
> +			 */
> +			entered_state = cpuidle_enter(drv, dev, next_state);
> +
> +			trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
> +
> +			if (broadcast)
> +				clockevents_notify(
> +					CLOCK_EVT_NOTIFY_BROADCAST_EXIT,
> +					&dev->cpu);
> +
> +			/*
> +			 * Give the governor an opportunity to reflect
> +			 * on the outcome
> +			 */
> +			cpuidle_reflect(dev, entered_state);
> +		}
> +	}
> +
> +	return 0;
> +}
> +#else
> +static int inline __cpuidle_idle_call(void)
> +{
> +	return -ENOSYS;
> +}
> +#endif
> +
>  /**
>   * cpuidle_idle_call - the main idle function
>   *
> @@ -70,10 +154,7 @@ void __weak arch_cpu_idle(void)
>   */
>  static void cpuidle_idle_call(void)
>  {
> -	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
> -	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
> -	int next_state, entered_state, ret;
> -	bool broadcast;
> +	int ret;
>  
>  	/*
>  	 * Check if the idle task must be rescheduled. If it is the
> @@ -100,80 +181,10 @@ static void cpuidle_idle_call(void)
>  	rcu_idle_enter();
>  
>  	/*
> -	 * Check if the cpuidle framework is ready, otherwise fallback
> -	 * to the default arch specific idle method
> -	 */
> -	ret = cpuidle_enabled(drv, dev);
> -
> -	if (!ret) {
> -		/*
> -		 * Ask the governor to choose an idle state it thinks
> -		 * it is convenient to go to. There is *always* a
> -		 * convenient idle state
> -		 */
> -		next_state = cpuidle_select(drv, dev);
> -
> -		/*
> -		 * The idle task must be scheduled, it is pointless to
> -		 * go to idle, just update no idle residency and get
> -		 * out of this function
> -		 */
> -		if (current_clr_polling_and_test()) {
> -			dev->last_residency = 0;
> -			entered_state = next_state;
> -			local_irq_enable();
> -		} else {
> -			broadcast = !!(drv->states[next_state].flags &
> -				       CPUIDLE_FLAG_TIMER_STOP);
> -
> -			if (broadcast)
> -				/*
> -				 * Tell the time framework to switch
> -				 * to a broadcast timer because our
> -				 * local timer will be shutdown. If a
> -				 * local timer is used from another
> -				 * cpu as a broadcast timer, this call
> -				 * may fail if it is not available
> -				 */
> -				ret = clockevents_notify(
> -					CLOCK_EVT_NOTIFY_BROADCAST_ENTER,
> -					&dev->cpu);
> -
> -			if (!ret) {
> -				trace_cpu_idle_rcuidle(next_state, dev->cpu);
> -
> -				/*
> -				 * Enter the idle state previously
> -				 * returned by the governor
> -				 * decision. This function will block
> -				 * until an interrupt occurs and will
> -				 * take care of re-enabling the local
> -				 * interrupts
> -				 */
> -				entered_state = cpuidle_enter(drv, dev,
> -							      next_state);
> -
> -				trace_cpu_idle_rcuidle(PWR_EVENT_EXIT,
> -						       dev->cpu);
> -
> -				if (broadcast)
> -					clockevents_notify(
> -						CLOCK_EVT_NOTIFY_BROADCAST_EXIT,
> -						&dev->cpu);
> -
> -				/*
> -				 * Give the governor an opportunity to reflect on the
> -				 * outcome
> -				 */
> -				cpuidle_reflect(dev, entered_state);
> -			}
> -		}
> -	}
> -
> -	/*
>  	 * We can't use the cpuidle framework, let's use the default
>  	 * idle routine
>  	 */
> +	ret = __cpuidle_idle_call();
>  	if (ret)
>  		arch_cpu_idle();
>  
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
