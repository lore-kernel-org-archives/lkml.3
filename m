Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297Ab3LQXvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 18:51:22 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:37866 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab3LQXvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 18:51:21 -0500
Date: Tue, 17 Dec 2013 15:51:17 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Stultz <john.stultz@linaro.org>, Alex Shi <alex.shi@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 09/13] nohz: Allow timekeeper's tick to stop when all
 full dynticks CPUs are idle
Message-ID: <20131217235117.GI19211@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
 <1387320692-28460-10-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387320692-28460-10-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121723-9332-0000-0000-0000028752B9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 11:51:28PM +0100, Frederic Weisbecker wrote:
> When all full dynticks CPUs are idle, as detected by RCU's sysidle
> detection, there is no need to keep the timekeeping CPU's tick alive
> anymore. So lets shut it down when we meet this favourable state. The
> timekeeper will be notified with an IPI if any full dynticks CPU
> wakes up.
> 
> Also, since we plan to allow every CPUs outside the full dynticks range
> to handle the timekeeping duty, lets also allow the timekeeping duty
> to be balanced. The only requirement is that the last timekeeper can't
> shut down its idle tick further than 1 jiffie until some other CPU
> takes its duty or until all full dynticks CPUs go to sleep.

Some questions below...

							Thanx, Paul

> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Alex Shi <alex.shi@linaro.org>
> Cc: Kevin Hilman <khilman@linaro.org>
> ---
>  kernel/time/tick-sched.c | 67 ++++++++++++++++++++++++++++++++++++------------
>  1 file changed, 50 insertions(+), 17 deletions(-)
> 
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 0d2d774..527b501 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -192,6 +192,49 @@ static bool can_stop_full_tick(void)
>  	return true;
>  }
> 
> +/*
> + * Fetch max deferment for the current clockevent source until it overflows.
> + * Also in full dynticks environment, make sure the current timekeeper
> + * stays periodic until some other CPU can take its timekeeping duty
> + * or until all full dynticks go to sleep.
> + */
> +static u64 tick_timekeeping_max_deferment(struct tick_sched *ts)
> +{
> +	int cpu;
> +	u64 ret = KTIME_MAX;
> +
> +	/*
> +	 * Fast path for full dynticks off-case: skip to
> +	 * clockevent max deferment
> +	 */
> +	if (!tick_nohz_full_enabled())
> +		return timekeeping_max_deferment();
> +
> +	cpu = smp_processor_id();
> +
> +	/* Full dynticks CPU don't take timekeeping duty */
> +	if (!tick_timekeeping_cpu(cpu))
> +		return timekeeping_max_deferment();
> +
> +	/*
> +	 * If we are the timekeeper and all full dynticks CPUs are idle,
> +	 * then we can finally sleep.
> +	 */
> +	if (tick_do_timer_cpu == cpu ||
> +	    (tick_do_timer_cpu == TICK_DO_TIMER_NONE &&	ts->do_timer_last == 1)) {
> +		if (!rcu_sys_is_idle()) {

So multiple CPUs could call rcu_sys_is_idle()?  Seems like this could
happen if tick_do_timer_cpu == TICK_DO_TIMER_NONE.  This would be OK only
if tick_timekeeping_cpu() returns true for one and only one of the CPUs
at any given range of time -- and also that no one calls rcu_sys_is_idle()
during a timekeeping CPU handoff.

If two different CPUs call rcu_sys_is_idle() anywhere nearly concurrently
on a small system (CONFIG_NO_HZ_FULL_SYSIDLE_SMALL), rcu_sys_is_idle()
will break and you will have voided your warranty.  ;-)

Also, if tick_timekeeping_cpu() doesn't think that there is a timekeeping
CPU, rcu_sys_is_idle() will always return false.  I think that this is
what you want to happen, just checking.

> +			/*
> +			 * Stop tick for 1 jiffy. In practice we stay periodic
> +			 * but that let us possibly delegate our timekeeping duty
> +			 * to stop the tick for real in the future.
> +			 */
> +			ret = tick_period.tv64;
> +		}

Do we need to set tick_do_timer_cpu to cpu?  Or is that handled elsewhere?
(If this is the boot-safety feature deleted below, could we please have
the comment back here?)

> +	}
> +
> +	return min_t(u64, ret, timekeeping_max_deferment());
> +}
> +
>  static void tick_nohz_restart_sched_tick(struct tick_sched *ts, ktime_t now);
> 
>  /*
> @@ -352,7 +395,12 @@ void __init tick_nohz_init(void)
>  	cpulist_scnprintf(nohz_full_buf, sizeof(nohz_full_buf), tick_nohz_full_mask);
>  	pr_info("NO_HZ: Full dynticks CPUs: %s.\n", nohz_full_buf);
>  }
> -#endif
> +# else /* CONFIG_NO_HZ_FULL */
> +static u64 tick_timekeeping_max_deferment(struct tick_sched *ts)
> +{
> +	return timekeeping_max_deferment();
> +}
> +#endif /* CONFIG_NO_HZ_FULL */
> 
>  /*
>   * NOHZ - aka dynamic tick functionality
> @@ -532,7 +580,7 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
>  	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
>  	u64 time_delta;
> 
> -	time_delta = timekeeping_max_deferment();
> +	time_delta = tick_timekeeping_max_deferment(ts);
> 
>  	/* Read jiffies and the time when jiffies were updated last */
>  	do {
> @@ -726,21 +774,6 @@ static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
>  		return false;
>  	}
> 
> -	if (tick_nohz_full_enabled()) {
> -		/*
> -		 * Keep the tick alive to guarantee timekeeping progression
> -		 * if there are full dynticks CPUs around
> -		 */
> -		if (tick_do_timer_cpu == cpu)
> -			return false;
> -		/*
> -		 * Boot safety: make sure the timekeeping duty has been
> -		 * assigned before entering dyntick-idle mode,
> -		 */
> -		if (tick_do_timer_cpu == TICK_DO_TIMER_NONE)
> -			return false;
> -	}
> -
>  	return true;
>  }
> 
> -- 
> 1.8.3.1
> 

