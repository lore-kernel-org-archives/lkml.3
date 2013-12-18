Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071Ab3LROWs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 09:22:48 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:54872 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573Ab3LROWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 09:22:46 -0500
Date: Wed, 18 Dec 2013 06:22:40 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Stultz <john.stultz@linaro.org>, Alex Shi <alex.shi@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 05/13] rcu: Fix unraised IPI to timekeeping CPU
Message-ID: <20131218142240.GP19211@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
 <1387320692-28460-6-git-send-email-fweisbec@gmail.com>
 <20131217232100.GC19211@linux.vnet.ibm.com>
 <20131218141348.GA18464@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218141348.GA18464@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121814-3532-0000-0000-000003F43DB7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 03:13:52PM +0100, Frederic Weisbecker wrote:
> On Tue, Dec 17, 2013 at 03:21:00PM -0800, Paul E. McKenney wrote:
> > On Tue, Dec 17, 2013 at 11:51:24PM +0100, Frederic Weisbecker wrote:
> > > The plan with full system idle detection is to allow the timekeeper
> > > to sleep when all full dynticks CPUs are sleeping.
> > > 
> > > Then when a full dynticks CPU wakes up while the whole system is idle,
> > > it sends an IPI to the timekeeping CPU which then restarts its tick
> > > and polls on its timekeeping duty on behalf of all other CPUs in the
> > > system.
> > > 
> > > But we are using rcu_kick_nohz_cpu() to raise this IPI, which is wrong
> > > because this function is used to kick full dynticks CPUs when they run
> > > in the kernel for too long without reporting a quiescent state. And
> > > this function ignores targets that are not full dynticks, like our
> > > timekeeper.
> > > 
> > > To fix this, use the smp_send_reschedule() function directly.
> > 
> > I guess the fact that you needed some change is reassuring.  You know
> > the old saying, "no bugs, no users".  ;-)
> 
> ;-)
> 
> > 
> > > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > Cc: Ingo Molnar <mingo@kernel.org>
> > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > Cc: Steven Rostedt <rostedt@goodmis.org>
> > > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > Cc: John Stultz <john.stultz@linaro.org>
> > > Cc: Alex Shi <alex.shi@linaro.org>
> > > Cc: Kevin Hilman <khilman@linaro.org>
> > > ---
> > >  kernel/rcu/tree_plugin.h | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> > > index 08004da..84d90c8 100644
> > > --- a/kernel/rcu/tree_plugin.h
> > > +++ b/kernel/rcu/tree_plugin.h
> > > @@ -2488,7 +2488,7 @@ void rcu_sysidle_force_exit(void)
> > >  				      oldstate, RCU_SYSIDLE_NOT);
> > >  		if (oldstate == newoldstate &&
> > >  		    oldstate == RCU_SYSIDLE_FULL_NOTED) {
> > > -			rcu_kick_nohz_cpu(tick_do_timer_cpu);
> > > +			smp_send_reschedule(tick_do_timer_cpu);
> > 
> > Hmmm...
> > 
> > We haven't done any sort of wakeup, and tick_nohz_full_cpu() should
> > return false for tick_do_timer_cpu, and I don't see that we have
> > done anything to make got_nohz_idle_kick() return true.
> > 
> > So the idea is that the fact of the interrupt is sufficient, and
> > the target CPU will figure out that it must turn its scheduling-clock
> > interrupt when returning from interrupt?
> 
> Exactly, the interrupt alone is sufficient and the tick is reevaluated
> on irq_exit().

But if that is the case, why do you need the change to scheduler_ipi()
in patch 07/13?  Just having received any sort of IPI should suffice.

							Thanx, Paul

> > Or is something else going on here?
> > 
> > 							Thanx, Paul
> > 
> > >  			return; /* We cleared it, done! */
> > >  		}
> > >  		oldstate = newoldstate;
> > > -- 
> > > 1.8.3.1
> > > 
> > 
> 

