Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690Ab3LQXfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 18:35:00 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:41725 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab3LQXe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 18:34:59 -0500
Date: Tue, 17 Dec 2013 15:34:54 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Stultz <john.stultz@linaro.org>, Alex Shi <alex.shi@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 11/13] nohz: Wake up timekeeper on exit from sysidle state
Message-ID: <20131217233454.GG19211@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
 <1387320692-28460-12-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387320692-28460-12-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121723-1344-0000-0000-0000043610EC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 11:51:30PM +0100, Frederic Weisbecker wrote:
> When a full dynticks CPU wakes up from sysidle state, which means that
> all full dynticks CPUs were previously sleeping, it's possible that
> all the potential timekeeping CPUs are sleeping as well and nobody
> maintains the associated duty.
> 
> But full dynticks CPUs don't run the tick by definition so we need
> to wake up a timekeeper such that it can handle the timekeeping
> duty on behalf of the freshly awoken full dyntick CPU.
> 
> To achieve this and ensure that this CPU won't deal with stale
> jiffies values, lets wake up the default timekeeper using the right
> API.
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
>  kernel/rcu/tree_plugin.h | 2 +-
>  kernel/time/tick-sched.c | 3 ++-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index 1795265..b43e32d 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -2488,7 +2488,7 @@ void rcu_sysidle_force_exit(void)
>  				      oldstate, RCU_SYSIDLE_NOT);
>  		if (oldstate == newoldstate &&
>  		    oldstate == RCU_SYSIDLE_FULL_NOTED) {
> -			smp_send_reschedule(tick_timekeeping_default_cpu());
> +			tick_nohz_full_kick_timekeeping();

OK, I guess I should look at the patches in order.  So yes, it is no
longer safe to just kick tick_do_timer_cpu.  ;-)

Never mind my question on patch 12/13 in this series.

							Thanx, Paul

>  			return; /* We cleared it, done! */
>  		}
>  		oldstate = newoldstate;
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 94b6901..f5ae69f 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -302,7 +302,8 @@ void tick_nohz_full_kick_all(void)
>  /**
>   * tick_nohz_full_kick_timekeeping - kick the default timekeeper
>   *
> - * kick the default timekeeper when a secondary timekeeper goes offline.
> + * kick the default timekeeper when full dynticks CPUs exit full
> + * system idle state or when a secondary timekeeper goes offline.
>   */
>  void tick_nohz_full_kick_timekeeping(void)
>  {
> -- 
> 1.8.3.1
> 

