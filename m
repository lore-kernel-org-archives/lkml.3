Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933379AbaGURv5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 13:51:57 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:39877 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932647AbaGURv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 13:51:56 -0400
Date: Mon, 21 Jul 2014 10:51:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 10/10] nohz: Warn on illegal timekeeper switch in nohz
 full
Message-ID: <20140721175150.GE8690@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1405730661-9355-1-git-send-email-fweisbec@gmail.com>
 <1405730661-9355-11-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405730661-9355-11-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072117-9332-0000-0000-00000173EFD6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2014 at 02:44:21AM +0200, Frederic Weisbecker wrote:
> In full dynticks idle mode, the timekeeper should never be set to another
> CPU than 0.
> 
> Lets enforce that through a dedicated mutator.
> 
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  kernel/time/tick-common.c   | 9 ++++-----
>  kernel/time/tick-internal.h | 7 +++++++
>  kernel/time/tick-sched.c    | 7 +++----
>  3 files changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
> index cb57bce..72ccaf2 100644
> --- a/kernel/time/tick-common.c
> +++ b/kernel/time/tick-common.c
> @@ -180,9 +180,9 @@ static void tick_setup_device(struct tick_device *td,
>  		 */
>  		if (tick_do_timer_cpu == TICK_DO_TIMER_BOOT) {
>  			if (tick_nohz_full_enabled())
> -				tick_do_timer_cpu = TICK_DO_TIMER_DEFAULT;
> +				tick_do_timer_cpu_set(TICK_DO_TIMER_DEFAULT);
>  			else
> -				tick_do_timer_cpu = cpu;
> +				tick_do_timer_cpu_set(cpu);
>  			tick_next_period = ktime_get();
>  			tick_period = ktime_set(0, NSEC_PER_SEC / HZ);
>  		}
> @@ -341,9 +341,8 @@ void tick_handover_do_timer(int *cpup)
>  {
>  	if (*cpup == tick_do_timer_cpu) {
>  		int cpu = cpumask_first(cpu_online_mask);
> -
> -		tick_do_timer_cpu = (cpu < nr_cpu_ids) ? cpu :
> -			TICK_DO_TIMER_NONE;
> +		tick_do_timer_cpu_set((cpu < nr_cpu_ids) ? cpu :
> +				      TICK_DO_TIMER_NONE);
>  	}
>  }
> 
> diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
> index 6b592a8..eadfd89 100644
> --- a/kernel/time/tick-internal.h
> +++ b/kernel/time/tick-internal.h
> @@ -23,6 +23,13 @@ extern void tick_setup_periodic(struct clock_event_device *dev, int broadcast);
>  extern void tick_handle_periodic(struct clock_event_device *dev);
>  extern void tick_check_new_device(struct clock_event_device *dev);
>  extern void tick_handover_do_timer(int *cpup);
> +
> +static inline void tick_do_timer_cpu_set(int cpu)
> +{
> +	WARN_ON_ONCE(tick_nohz_full_enabled() && cpu != TICK_DO_TIMER_DEFAULT);
> +	tick_do_timer_cpu = cpu;
> +}
> +
>  extern void tick_shutdown(unsigned int *cpup);
>  extern void tick_suspend(void);
>  extern void tick_resume(void);
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 845aaff..3b5102a 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -123,7 +123,7 @@ static void tick_sched_do_timer(ktime_t now)
>  	 */
>  	if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_NONE)
>  	    && !tick_nohz_full_cpu(cpu))
> -		tick_do_timer_cpu = cpu;
> +		tick_do_timer_cpu_set(cpu);
>  #endif
> 
>  	/* Check, if the jiffies need an update */
> @@ -550,7 +550,7 @@ static u64 timekeeping_deferment(struct tick_sched *ts, int cpu)
>  		ts->do_timer_last = 1;
>  		/* In full dynticks mode, CPU 0 always keeps the duty */
>  		if (!tick_nohz_full_enabled())
> -			tick_do_timer_cpu = TICK_DO_TIMER_NONE;
> +			tick_do_timer_cpu_set(TICK_DO_TIMER_NONE);
>  	} else if (ts->do_timer_last) {
>  		if (tick_do_timer_cpu == TICK_DO_TIMER_NONE)
>  			time_delta = timekeeping_max_deferment();
> @@ -600,7 +600,6 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
>  	/* Schedule the tick, if we are at least one jiffie off */
>  	if ((long)delta_jiffies >= 1) {
>  		u64 time_delta = timekeeping_deferment(ts, cpu);
> -
>  #ifdef CONFIG_NO_HZ_FULL
>  		if (!ts->inidle) {
>  			time_delta = min(time_delta,
> @@ -717,7 +716,7 @@ static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
>  	 */
>  	if (unlikely(!cpu_online(cpu))) {
>  		if (cpu == tick_do_timer_cpu)
> -			tick_do_timer_cpu = TICK_DO_TIMER_NONE;
> +			tick_do_timer_cpu_set(TICK_DO_TIMER_NONE);
>  		return false;
>  	}
> 
> -- 
> 1.8.3.1
> 

