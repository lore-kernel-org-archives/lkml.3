Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab3LQXwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 18:52:44 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:47631 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab3LQXwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 18:52:42 -0500
Date: Wed, 18 Dec 2013 00:52:34 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Stultz <john.stultz@linaro.org>, Alex Shi <alex.shi@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 11/13] nohz: Wake up timekeeper on exit from sysidle state
Message-ID: <20131217235233.GC18689@localhost.localdomain>
References: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
 <1387320692-28460-12-git-send-email-fweisbec@gmail.com>
 <20131217233454.GG19211@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131217233454.GG19211@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 03:34:54PM -0800, Paul E. McKenney wrote:
> On Tue, Dec 17, 2013 at 11:51:30PM +0100, Frederic Weisbecker wrote:
> > When a full dynticks CPU wakes up from sysidle state, which means that
> > all full dynticks CPUs were previously sleeping, it's possible that
> > all the potential timekeeping CPUs are sleeping as well and nobody
> > maintains the associated duty.
> > 
> > But full dynticks CPUs don't run the tick by definition so we need
> > to wake up a timekeeper such that it can handle the timekeeping
> > duty on behalf of the freshly awoken full dyntick CPU.
> > 
> > To achieve this and ensure that this CPU won't deal with stale
> > jiffies values, lets wake up the default timekeeper using the right
> > API.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: John Stultz <john.stultz@linaro.org>
> > Cc: Alex Shi <alex.shi@linaro.org>
> > Cc: Kevin Hilman <khilman@linaro.org>
> > ---
> >  kernel/rcu/tree_plugin.h | 2 +-
> >  kernel/time/tick-sched.c | 3 ++-
> >  2 files changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> > index 1795265..b43e32d 100644
> > --- a/kernel/rcu/tree_plugin.h
> > +++ b/kernel/rcu/tree_plugin.h
> > @@ -2488,7 +2488,7 @@ void rcu_sysidle_force_exit(void)
> >  				      oldstate, RCU_SYSIDLE_NOT);
> >  		if (oldstate == newoldstate &&
> >  		    oldstate == RCU_SYSIDLE_FULL_NOTED) {
> > -			smp_send_reschedule(tick_timekeeping_default_cpu());
> > +			tick_nohz_full_kick_timekeeping();
> 
> OK, I guess I should look at the patches in order.  So yes, it is no
> longer safe to just kick tick_do_timer_cpu.  ;-)

Hehe, I do linear reviews as well ;)

Indeed it's no longer safe, especially since tick_do_timer_cpu can be TICK_DO_TIMER_NONE.
So this always kick CPU 0 instead (for now).
