Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab3LQXyY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 18:54:24 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:39105 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab3LQXyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 18:54:22 -0500
Date: Tue, 17 Dec 2013 15:54:18 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Stultz <john.stultz@linaro.org>, Alex Shi <alex.shi@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 06/13] nohz: Introduce full dynticks' default timekeeping
 target
Message-ID: <20131217235418.GK19211@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
 <1387320692-28460-7-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387320692-28460-7-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121723-1542-0000-0000-0000045B29B6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 11:51:25PM +0100, Frederic Weisbecker wrote:
> When a full dynticks CPU wakes up while the whole rest of the system
> is idle, we need to wake up the CPU in charge of the timekeeping duty
> handling.
> 
> As of today, the CPU that maintains this duty is CPU 0 when
> CONFIG_NO_HZ_FULL=y. So referring to tick_do_timer_cpu like we
> currently do is correct. But this behaviour is subject to change
> in the future because we want to balance the timekeeping duty over all
> the CPUs outside the full dynticks range.
> 
> As such we now need to define a default timekeeping CPU which receives
> the timekeeping wakeup IPIs and which can't be offlined so that it's
> guaranteed to always be present for full dynticks CPUs housekeeping.
> 
> So lets stick to CPU 0 for this purpose. It's convenient because
> rejecting any other CPU's offlining request may result in suspend
> failure.

OK, so not multiple CPUs yet.  Whew!

Well, at least you know some of my concerns with multiple timekeeping
CPUs beforehand, which would not have happened had I reviewed the
patches in order.  ;-)

							Thanx, Paul

> We can optimize this solution later by adaptively sending the IPI
> to a potential timekeeping CPU that is already running a non idle task.
> 
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
>  include/linux/tick.h     | 16 ++++++++++++++++
>  kernel/rcu/tree_plugin.h |  4 ++--
>  kernel/time/tick-sched.c |  2 +-
>  3 files changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/tick.h b/include/linux/tick.h
> index cf2fd34..af98d2c 100644
> --- a/include/linux/tick.h
> +++ b/include/linux/tick.h
> @@ -180,6 +180,22 @@ static inline bool tick_nohz_full_cpu(int cpu)
>  }
> 
>  /**
> + * tick_timekeeping_default_cpu - seek timekeeping default CPU
> +
> + * @return the default target which we send an IPI to
> + * when a full dynticks CPU wakes up and exits from full
> + * system idle state.
> + *
> + * This target is always CPU 0 in full dynticks environment.
> + * If we were to pick up any other CPU, that would result in suspend
> + * failures due to rejected offlining request.
> + */
> +static inline int tick_timekeeping_default_cpu(void)
> +{
> +	return 0;
> +}
> +
> +/**
>   * tick_timeeping_cpu - check if a CPU is elligble to handle timekeeping duty
>   * @cpu:	the cpu to check
>   *
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index 84d90c8..1795265 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -2488,7 +2488,7 @@ void rcu_sysidle_force_exit(void)
>  				      oldstate, RCU_SYSIDLE_NOT);
>  		if (oldstate == newoldstate &&
>  		    oldstate == RCU_SYSIDLE_FULL_NOTED) {
> -			smp_send_reschedule(tick_do_timer_cpu);
> +			smp_send_reschedule(tick_timekeeping_default_cpu());
>  			return; /* We cleared it, done! */
>  		}
>  		oldstate = newoldstate;
> @@ -2597,7 +2597,7 @@ static bool is_sysidle_rcu_state(struct rcu_state *rsp)
>   */
>  static void rcu_bind_gp_kthread(void)
>  {
> -	int cpu = ACCESS_ONCE(tick_do_timer_cpu);
> +	int cpu = tick_timekeeping_default_cpu();
> 
>  	if (cpu < 0 || cpu >= nr_cpu_ids)
>  		return;
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index ea0d411..9a91c31 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -305,7 +305,7 @@ static int tick_nohz_cpu_down_callback(struct notifier_block *nfb,
>  		 * If we handle the timekeeping duty for full dynticks CPUs,
>  		 * we can't safely shutdown that CPU.
>  		 */
> -		if (tick_nohz_full_running && tick_do_timer_cpu == cpu)
> +		if (tick_nohz_full_running && tick_timekeeping_default_cpu() == cpu)
>  			return NOTIFY_BAD;
>  		break;
>  	}
> -- 
> 1.8.3.1
> 

