Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab3LUJMs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 04:12:48 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:49341 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab3LUJMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 04:12:37 -0500
Message-ID: <1387617104.30230.7.camel@marge.simpson.net>
Subject: Re: CONFIG_NO_HZ_FULL + CONFIG_PREEMPT_RT_FULL = nogo
From: Mike Galbraith <bitbucket@online.de>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Sat, 21 Dec 2013 10:11:44 +0100
In-Reply-To: <20131220154146.GA18672@breakpoint.cc>
References: <1383228427.5272.36.camel@marge.simpson.net>
	 <alpine.DEB.2.02.1311061842160.23353@ionos.tec.linutronix.de>
	 <1383794799.5441.16.camel@marge.simpson.net>
	 <1383798668.5441.25.camel@marge.simpson.net>
	 <alpine.DEB.2.02.1311071158350.23353@ionos.tec.linutronix.de>
	 <20131220154146.GA18672@breakpoint.cc>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:RvW4vB0QNs6e6j5kk1v39SBUo/qr03T970ao3gvX552
 pQuSCHljTH4jDpYwtNmuVZX0iWHuSUl/fXLMHxrG9E0wK3xbVq
 BEWYnhqzbjqH1gaLEObMcL7xAAIuXTmNDhsTn0GpjLbZk8cgfG
 s7wYlq8gjw47a+n83J2+2n1QiaPcg7IHhEU2dyrgsLkyP0i1Mh
 UHnmwJGXhEHaxx+voL94N6cEvW7YFnE3CJO79UxQ/iuLOK9M52
 IxWSMHIqUFvH2VOp9AIkbKxoc+yXs44IyqoK0KeOf0w5XjCks7
 KYsKVS5a2foZ5A+wxzGsJI5ff9VPknAtF8tU40kzKWRB+ePHBJ
 8rDEzmV/5Dare932o8KmkANYtqPAIt8O1RzdqjYbQ7x3e2LI09
 9YDiko+/AEcWg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-12-20 at 16:41 +0100, Sebastian Andrzej Siewior wrote: 
> On 07.11.13, Thomas Gleixner wrote:
> > below should address that issue. If that works on mainline we can
> > adapt it for RT (needs a trylock(&base->lock) there).
> 
> okay, so this is waht I'm going to take for -RT:

Works, modulo noisy workqueues.

rtbox:~ # sleep 35 && killall pert& cgexec -g cpuset:rtcpus taskset -c 3 pert 5
[1] 5660
2400.05 MHZ CPU
perturbation threshold 0.018 usecs.
pert/s:       33 >15.75us:        2 min:  0.04 max: 24.14 avg:  2.51 sum/s:    84us overhead: 0.01%
pert/s:       35 >15.54us:        3 min:  0.04 max: 24.89 avg:  2.39 sum/s:    84us overhead: 0.01%
pert/s:       30 >15.27us:        2 min:  0.04 max: 23.03 avg:  2.64 sum/s:    80us overhead: 0.01%
pert/s:       34 >15.12us:        3 min:  0.04 max: 25.03 avg:  2.51 sum/s:    86us overhead: 0.01%
pert/s:       31 >14.93us:        2 min:  0.04 max: 23.86 avg:  2.60 sum/s:    83us overhead: 0.01%
Terminated

> diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
> index 79a7a35..bdbf77db 100644
> --- a/include/linux/hrtimer.h
> +++ b/include/linux/hrtimer.h
> @@ -461,9 +461,8 @@ extern int schedule_hrtimeout_range_clock(ktime_t *expires,
>  		unsigned long delta, const enum hrtimer_mode mode, int clock);
>  extern int schedule_hrtimeout(ktime_t *expires, const enum hrtimer_mode mode);
>  
> -/* Soft interrupt function to run the hrtimer queues: */
> +/* Called from the periodic timer tick */
>  extern void hrtimer_run_queues(void);
> -extern void hrtimer_run_pending(void);
>  
>  /* Bootup initialization: */
>  extern void __init hrtimers_init(void);
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index c383841..7aa442e 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -1694,30 +1694,6 @@ static void run_hrtimer_softirq(struct softirq_action *h)
>  }
>  
>  /*
> - * Called from timer softirq every jiffy, expire hrtimers:
> - *
> - * For HRT its the fall back code to run the softirq in the timer
> - * softirq context in case the hrtimer initialization failed or has
> - * not been done yet.
> - */
> -void hrtimer_run_pending(void)
> -{
> -	if (hrtimer_hres_active())
> -		return;
> -
> -	/*
> -	 * This _is_ ugly: We have to check in the softirq context,
> -	 * whether we can switch to highres and / or nohz mode. The
> -	 * clocksource switch happens in the timer interrupt with
> -	 * xtime_lock held. Notification from there only sets the
> -	 * check bit in the tick_oneshot code, otherwise we might
> -	 * deadlock vs. xtime_lock.
> -	 */
> -	if (tick_check_oneshot_change(!hrtimer_is_hres_enabled()))
> -		hrtimer_switch_to_hres();
> -}
> -
> -/*
>   * Called from hardirq context every jiffy
>   */
>  void hrtimer_run_queues(void)
> @@ -1730,6 +1706,13 @@ void hrtimer_run_queues(void)
>  	if (hrtimer_hres_active())
>  		return;
>  
> +	/*
> +	 * Check whether we can switch to highres mode.
> +	 */
> +	if (tick_check_oneshot_change(!hrtimer_is_hres_enabled())
> +	    && hrtimer_switch_to_hres())
> +		return;
> +
>  	for (index = 0; index < HRTIMER_MAX_CLOCK_BASES; index++) {
>  		base = &cpu_base->clock_base[index];
>  		if (!timerqueue_getnext(&base->active))
> diff --git a/kernel/timer.c b/kernel/timer.c
> index b06c647..46467be 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -1443,8 +1443,6 @@ static void run_timer_softirq(struct softirq_action *h)
>  	irq_work_run();
>  #endif
>  
> -	hrtimer_run_pending();
> -
>  	if (time_after_eq(jiffies, base->timer_jiffies))
>  		__run_timers(base);
>  }
> @@ -1454,8 +1452,27 @@ static void run_timer_softirq(struct softirq_action *h)
>   */
>  void run_local_timers(void)
>  {
> +	struct tvec_base *base = __this_cpu_read(tvec_bases);
> +
>  	hrtimer_run_queues();
> -	raise_softirq(TIMER_SOFTIRQ);
> +	/*
> +	 * We can access this lockless as we are in the timer
> +	 * interrupt. If there are no timers queued, nothing to do in
> +	 * the timer softirq.
> +	 */
> +	if (!spin_do_trylock(&base->lock)) {
> +		raise_softirq(TIMER_SOFTIRQ);
> +		return;
> +	}
> +	if (!base->active_timers)
> +		goto out;
> +
> +	/* Check whether the next pending timer has expired */
> +	if (time_before_eq(base->next_timer, jiffies))
> +		raise_softirq(TIMER_SOFTIRQ);
> +out:
> +	rt_spin_unlock_after_trylock_in_irq(&base->lock);
> +
>  }
>  
>  #ifdef __ARCH_WANT_SYS_ALARM


