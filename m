Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933260AbaGURur (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 13:50:47 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:39385 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932647AbaGURuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 13:50:46 -0400
Date: Mon, 21 Jul 2014 10:50:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 09/10] nohz: Switch nohz full timekeeper to dynticks idle
 on top of sysidle detection
Message-ID: <20140721175039.GD8690@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1405730661-9355-1-git-send-email-fweisbec@gmail.com>
 <1405730661-9355-10-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405730661-9355-10-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072117-9332-0000-0000-00000173EEB3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2014 at 02:44:20AM +0200, Frederic Weisbecker wrote:
> In full dynticks, the CPU 0 carries the timekeeping duty on behalf
> of all other CPUs in the system. This way full dynticks are left
> undisturbed on this regard.
> 
> Of course this prevents CPU 0 from entering in dynticks idle mode
> because any CPU may need uptodate timekeeping at any time.
> 
> Theoretically though, we could put CPU 0 in dynticks idle mode once we
> are sure that all other CPUs are dynticks idle as well. Then when a
> CPU wakes up and finds the timekeeper idle, it would send an IPI to
> wake it up on its duty.
> 
> Such a machine state needs to take care of all the races in the way, make
> sure that CPU 0 is neither stuck accidentally to sleep for ever, nor
> stuck in periodic mode when it could sleep. Also given the amount of
> shared data this involves and their access frequency, this must be built
> on top of lockless low-overhead state machine.
> 
> This is what sysidle provides. The feature is ready for a while, we
> were just waiting for the nohz susbsystem to support it. And we just
> reached that state.
> 
> So lets defer the last call for CPU 0 to enter in dynticks idle to when
> we find a full system idle state. And lets wake it up when its duty is
> needed.
> 
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

OK, it looks like this calls rcu_sys_is_idle() only if there actually
are some nohz_full= CPUs, which is good.  I therefore only need
tick_nohz_full_enabled() checks on the internal sysidle machinery, and
even then these checks only have effect on performance, not on semantics.
Which is also good.  ;-)

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  kernel/time/tick-sched.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index bcba79d..845aaff 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -547,8 +547,10 @@ static u64 timekeeping_deferment(struct tick_sched *ts, int cpu)
> 
>  	if (tick_do_timer_cpu == cpu) {
>  		time_delta = timekeeping_max_deferment();
> -		tick_do_timer_cpu = TICK_DO_TIMER_NONE;
>  		ts->do_timer_last = 1;
> +		/* In full dynticks mode, CPU 0 always keeps the duty */
> +		if (!tick_nohz_full_enabled())
> +			tick_do_timer_cpu = TICK_DO_TIMER_NONE;
>  	} else if (ts->do_timer_last) {
>  		if (tick_do_timer_cpu == TICK_DO_TIMER_NONE)
>  			time_delta = timekeeping_max_deferment();
> @@ -745,7 +747,7 @@ static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
>  		 * if there are full dynticks CPUs around
>  		 */
>  		if (tick_do_timer_cpu == cpu)
> -			return false;
> +			return rcu_sys_is_idle();
>  	}
> 
>  	return true;
> -- 
> 1.8.3.1
> 

