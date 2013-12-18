Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab3LROgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 09:36:16 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:60692 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab3LROgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 09:36:14 -0500
Date: Wed, 18 Dec 2013 15:36:11 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Stultz <john.stultz@linaro.org>, Alex Shi <alex.shi@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 09/13] nohz: Allow timekeeper's tick to stop when all
 full dynticks CPUs are idle
Message-ID: <20131218143609.GC18464@localhost.localdomain>
References: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
 <1387320692-28460-10-git-send-email-fweisbec@gmail.com>
 <20131217235117.GI19211@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131217235117.GI19211@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 03:51:17PM -0800, Paul E. McKenney wrote:
> On Tue, Dec 17, 2013 at 11:51:28PM +0100, Frederic Weisbecker wrote:
> > +/*
> > + * Fetch max deferment for the current clockevent source until it overflows.
> > + * Also in full dynticks environment, make sure the current timekeeper
> > + * stays periodic until some other CPU can take its timekeeping duty
> > + * or until all full dynticks go to sleep.
> > + */
> > +static u64 tick_timekeeping_max_deferment(struct tick_sched *ts)
> > +{
> > +	int cpu;
> > +	u64 ret = KTIME_MAX;
> > +
> > +	/*
> > +	 * Fast path for full dynticks off-case: skip to
> > +	 * clockevent max deferment
> > +	 */
> > +	if (!tick_nohz_full_enabled())
> > +		return timekeeping_max_deferment();
> > +
> > +	cpu = smp_processor_id();
> > +
> > +	/* Full dynticks CPU don't take timekeeping duty */
> > +	if (!tick_timekeeping_cpu(cpu))
> > +		return timekeeping_max_deferment();
> > +
> > +	/*
> > +	 * If we are the timekeeper and all full dynticks CPUs are idle,
> > +	 * then we can finally sleep.
> > +	 */
> > +	if (tick_do_timer_cpu == cpu ||
> > +	    (tick_do_timer_cpu == TICK_DO_TIMER_NONE &&	ts->do_timer_last == 1)) {
> > +		if (!rcu_sys_is_idle()) {
> 
> So multiple CPUs could call rcu_sys_is_idle()?  Seems like this could
> happen if tick_do_timer_cpu == TICK_DO_TIMER_NONE.  This would be OK only
> if tick_timekeeping_cpu() returns true for one and only one of the CPUs
> at any given range of time -- and also that no one calls rcu_sys_is_idle()
> during a timekeeping CPU handoff.

Hmm yeah I fear we can have concurrent callers of this at a same time range.

> 
> If two different CPUs call rcu_sys_is_idle() anywhere nearly concurrently
> on a small system (CONFIG_NO_HZ_FULL_SYSIDLE_SMALL), rcu_sys_is_idle()
> will break and you will have voided your warranty.  ;-)

So it breaks because of concurrent state machine stepping on each other toes, right?
Like one CPU has reached RCU_SYSIDLE_SHORT and another comes and see only
RCU_SYSIDLE_NONE, so it can for example overwite to SHORT while the other CPU
can be already far further the cmpxchg() sequence?

Aye, I need to think further on how to cope with that...

> 
> Also, if tick_timekeeping_cpu() doesn't think that there is a timekeeping
> CPU, rcu_sys_is_idle() will always return false.  I think that this is
> what you want to happen, just checking.

Ah right but that should be fine. tick_timekeeping_cpu() works for all potential
timekeepers. Basically it's !tick_nohz_full_cpu(cpu).

> 
> > +			/*
> > +			 * Stop tick for 1 jiffy. In practice we stay periodic
> > +			 * but that let us possibly delegate our timekeeping duty
> > +			 * to stop the tick for real in the future.
> > +			 */
> > +			ret = tick_period.tv64;
> > +		}
> 
> Do we need to set tick_do_timer_cpu to cpu?  Or is that handled elsewhere?
> (If this is the boot-safety feature deleted below, could we please have
> the comment back here?)

This is done in the patch that calls ..kick_timekeeping()  from sysidle_exit().

Do you have another case in mind?
