Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163Ab3HUDRf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 23:17:35 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:38847 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032Ab3HUDRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 23:17:34 -0400
Date: Tue, 20 Aug 2013 20:17:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [PATCH 5/8] rcu: eliminate deadlock for rcu read site
Message-ID: <20130821031727.GA21711@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1375871104-10688-1-git-send-email-laijs@cn.fujitsu.com>
 <1375871104-10688-6-git-send-email-laijs@cn.fujitsu.com>
 <20130808204020.GA31127@linux.vnet.ibm.com>
 <5205B6FF.7060502@cn.fujitsu.com>
 <20130810150715.GF29406@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130810150715.GF29406@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082103-5806-0000-0000-0000227E4160
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 10, 2013 at 08:07:15AM -0700, Paul E. McKenney wrote:
> On Sat, Aug 10, 2013 at 11:43:59AM +0800, Lai Jiangshan wrote:

[ . . . ]

> > So I have to narrow the range of suspect locks. Two choices:
> > A) don't call rt_mutex_unlock() from rcu_read_unlock(), only call it
> >    from rcu_preempt_not_context_switch(). we need to rework these
> >    two functions and it will add complexity to RCU, and it also still
> >    adds some probability of deferring.
> 
> One advantage of bh-disable locks is that enabling bh checks
> TIF_NEED_RESCHED, so that there is no deferring beyond that
> needed by bh disable.  The same of course applies to preempt_disable().
> 
> So one approach is to defer when rcu_read_unlock_special() is entered
> with either preemption or bh disabled.  Your current set_need_resched()
> trick would work fine in this case.  Unfortunately, re-enabling interrupts
> does -not- check TIF_NEED_RESCHED, which is why we have latency problems
> in that case.  (Hence my earlier question about making self-IPI safe
> on all arches, which would result in an interrupt as soon as interrupts
> were re-enabled.)
> 
> Another possibility is to defer only when preemption or bh are disabled
> on entry ro rcu_read_unlock_special(), but to retain the current
> (admittedly ugly) nesting rules for the scheduler locks.

Would you be willing to do a patch that deferred rt_mutex_unlock() in
the preempt/bh cases?  This of course does not solve the irq-disable
case, but it should at least narrow the problem to the scheduler locks.

Not a big hurry, given the testing required, this is 3.13 or 3.14 material,
I think.

If you are busy, no problem, I can do it, just figured you have priority
if you want it.

							Thanx, Paul

> > B) change rtmutex's lock->wait_lock to irqs-disabled.
> 
> I have to defer to Steven on this one.
> 
> 							Thanx, Paul
> 
> > 4) In the view of rtmutex, I think it will be better if ->wait_lock is irqs-disabled.
> >    A) like trylock of mutex/rw_sem, we may call rt_mutex_trylock() in irq in future.
> >    B) the critical section of ->wait_lock is short,
> >       making it irqs-disabled don't hurts responsibility/latency.
> >    C) almost all time of the critical section of ->wait_lock is irqs-disabled
> >       (due to task->pi_lock), I think converting whole time of the critical section
> >       of ->wait_lock to irqs-disabled is OK.
> > 
> > So I hope you change rtmutex's lock->wait_lock.
> > 
> > Any feedback from anyone is welcome.
> > 
> > Thanks,
> > Lai
> > 
> > On 08/09/2013 04:40 AM, Paul E. McKenney wrote:
> > > On Wed, Aug 07, 2013 at 06:25:01PM +0800, Lai Jiangshan wrote:
> > >> Background)
> > >>
> > >> Although all articles declare that rcu read site is deadlock-immunity.
> > >> It is not true for rcu-preempt, it will be deadlock if rcu read site
> > >> overlaps with scheduler lock.
> > >>
> > >> ec433f0c, 10f39bb1 and 016a8d5b just partially solve it. But rcu read site
> > >> is still not deadlock-immunity. And the problem described in 016a8d5b
> > >> is still existed(rcu_read_unlock_special() calls wake_up).
> > >>
> > >> Aim)
> > >>
> > >> We want to fix the problem forever, we want to keep rcu read site
> > >> is deadlock-immunity as books say.
> > >>
> > >> How)
> > >>
> > >> The problem is solved by "if rcu_read_unlock_special() is called inside
> > >> any lock which can be (chained) nested in rcu_read_unlock_special(),
> > >> we defer rcu_read_unlock_special()".
> > >> This kind locks include rnp->lock, scheduler locks, perf ctx->lock, locks
> > >> in printk()/WARN_ON() and all locks nested in these locks or chained nested
> > >> in these locks.
> > >>
> > >> The problem is reduced to "how to distinguish all these locks(context)",
> > >> We don't distinguish all these locks, we know that all these locks
> > >> should be nested in local_irqs_disable().
> > >>
> > >> we just consider if rcu_read_unlock_special() is called in irqs-disabled
> > >> context, it may be called in these suspect locks, we should defer
> > >> rcu_read_unlock_special().
> > >>
> > >> The algorithm enlarges the probability of deferring, but the probability
> > >> is still very very low.
> > >>
> > >> Deferring does add a small overhead, but it offers us:
> > >> 	1) really deadlock-immunity for rcu read site
> > >> 	2) remove the overhead of the irq-work(250 times per second in avg.)
> > > 
> > > One problem here -- it may take quite some time for a set_need_resched()
> > > to take effect.  This is especially a problem for RCU priority boosting,
> > > but can also needlessly delay preemptible-RCU grace periods because
> > > local_irq_restore() and friends don't check the TIF_NEED_RESCHED bit.
> > > 
> > > OK, alternatives...
> > > 
> > > o	Keep the current rule saying that if the scheduler is going
> > > 	to exit an RCU read-side critical section while holding
> > > 	one of its spinlocks, preemption has to have been disabled
> > > 	throughout the full duration of that critical section.
> > > 	Well, we can certainly do this, but it would be nice to get
> > > 	rid of this rule.
> > > 
> > > o	Use per-CPU variables, possibly injecting delay.  This has ugly
> > > 	disadvantages as noted above.
> > > 
> > > o	irq_work_queue() can wait a jiffy (or on some architectures,
> > > 	quite a bit longer) before actually doing anything.
> > > 
> > > o	raise_softirq() is more immediate and is an easy change, but
> > > 	adds a softirq vector -- which people are really trying to
> > > 	get rid of.  Also, wakeup_softirqd() calls things that acquire
> > > 	the scheduler locks, which is exactly what we were trying to
> > > 	avoid doing.
> > > 
> > > o	invoke_rcu_core() can invoke raise_softirq() as above.
> > > 
> > > o	IPI to self.  From what I can see, not all architectures
> > > 	support this.  Easy to fake if you have at least two CPUs,
> > > 	but not so good from an OS jitter viewpoint...
> > > 
> > > o	Add a check to local_irq_disable() and friends.  I would guess
> > > 	that this suggestion would not make architecture maintainers
> > > 	happy.
> > > 
> > > Other thoughts?
> > > 
> > > 							Thanx, Paul
> > > 
> > >> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > >> ---
> > >>  include/linux/rcupdate.h |    2 +-
> > >>  kernel/rcupdate.c        |    2 +-
> > >>  kernel/rcutree_plugin.h  |   47 +++++++++++++++++++++++++++++++++++++++++----
> > >>  3 files changed, 44 insertions(+), 7 deletions(-)
> > >>
> > >> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> > >> index 4b14bdc..00b4220 100644
> > >> --- a/include/linux/rcupdate.h
> > >> +++ b/include/linux/rcupdate.h
> > >> @@ -180,7 +180,7 @@ extern void synchronize_sched(void);
> > >>
> > >>  extern void __rcu_read_lock(void);
> > >>  extern void __rcu_read_unlock(void);
> > >> -extern void rcu_read_unlock_special(struct task_struct *t);
> > >> +extern void rcu_read_unlock_special(struct task_struct *t, bool unlock);
> > >>  void synchronize_rcu(void);
> > >>
> > >>  /*
> > >> diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
> > >> index cce6ba8..33b89a3 100644
> > >> --- a/kernel/rcupdate.c
> > >> +++ b/kernel/rcupdate.c
> > >> @@ -90,7 +90,7 @@ void __rcu_read_unlock(void)
> > >>  #endif /* #ifdef CONFIG_PROVE_RCU_DELAY */
> > >>  		barrier();  /* assign before ->rcu_read_unlock_special load */
> > >>  		if (unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
> > >> -			rcu_read_unlock_special(t);
> > >> +			rcu_read_unlock_special(t, true);
> > >>  		barrier();  /* ->rcu_read_unlock_special load before assign */
> > >>  		t->rcu_read_lock_nesting = 0;
> > >>  	}
> > >> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> > >> index fc8b36f..997b424 100644
> > >> --- a/kernel/rcutree_plugin.h
> > >> +++ b/kernel/rcutree_plugin.h
> > >> @@ -242,15 +242,16 @@ static void rcu_preempt_note_context_switch(int cpu)
> > >>  				       ? rnp->gpnum
> > >>  				       : rnp->gpnum + 1);
> > >>  		raw_spin_unlock_irqrestore(&rnp->lock, flags);
> > >> -	} else if (t->rcu_read_lock_nesting < 0 &&
> > >> -		   !WARN_ON_ONCE(t->rcu_read_lock_nesting != INT_MIN) &&
> > >> -		   t->rcu_read_unlock_special) {
> > >> +	} else if (t->rcu_read_lock_nesting == 0 ||
> > >> +		   (t->rcu_read_lock_nesting < 0 &&
> > >> +		   !WARN_ON_ONCE(t->rcu_read_lock_nesting != INT_MIN))) {
> > >>
> > >>  		/*
> > >>  		 * Complete exit from RCU read-side critical section on
> > >>  		 * behalf of preempted instance of __rcu_read_unlock().
> > >>  		 */
> > >> -		rcu_read_unlock_special(t);
> > >> +		if (t->rcu_read_unlock_special)
> > >> +			rcu_read_unlock_special(t, false);
> > >>  	}
> > >>
> > >>  	/*
> > >> @@ -333,7 +334,7 @@ static struct list_head *rcu_next_node_entry(struct task_struct *t,
> > >>   * notify RCU core processing or task having blocked during the RCU
> > >>   * read-side critical section.
> > >>   */
> > >> -void rcu_read_unlock_special(struct task_struct *t)
> > >> +void rcu_read_unlock_special(struct task_struct *t, bool unlock)
> > >>  {
> > >>  	int empty;
> > >>  	int empty_exp;
> > >> @@ -364,6 +365,42 @@ void rcu_read_unlock_special(struct task_struct *t)
> > >>
> > >>  	/* Clean up if blocked during RCU read-side critical section. */
> > >>  	if (special & RCU_READ_UNLOCK_BLOCKED) {
> > >> +		/*
> > >> +		 * If rcu read lock overlaps with scheduler lock,
> > >> +		 * rcu_read_unlock_special() may lead to deadlock:
> > >> +		 *
> > >> +		 * rcu_read_lock();
> > >> +		 * preempt_schedule[_irq]() (when preemption)
> > >> +		 * scheduler lock; (or some other locks can be (chained) nested
> > >> +		 *                  in rcu_read_unlock_special()/rnp->lock)
> > >> +		 * access and check rcu data
> > >> +		 * rcu_read_unlock();
> > >> +		 *   rcu_read_unlock_special();
> > >> +		 *     wake_up();                 DEAD LOCK
> > >> +		 *
> > >> +		 * To avoid all these kinds of deadlock, we should quit
> > >> +		 * rcu_read_unlock_special() here and defer it to
> > >> +		 * rcu_preempt_note_context_switch() or next outmost
> > >> +		 * rcu_read_unlock() if we consider this case may happen.
> > >> +		 *
> > >> +		 * Although we can't know whether current _special()
> > >> +		 * is nested in scheduler lock or not. But we know that
> > >> +		 * irqs are always disabled in this case. so we just quit
> > >> +		 * and defer it to rcu_preempt_note_context_switch()
> > >> +		 * when irqs are disabled.
> > >> +		 *
> > >> +		 * It means we always defer _special() when it is
> > >> +		 * nested in irqs disabled context, but
> > >> +		 *	(special & RCU_READ_UNLOCK_BLOCKED) &&
> > >> +		 *	irqs_disabled_flags(flags)
> > >> +		 * is still unlikely to be true.
> > >> +		 */
> > >> +		if (unlikely(unlock && irqs_disabled_flags(flags))) {
> > >> +			set_need_resched();
> > >> +			local_irq_restore(flags);
> > >> +			return;
> > >> +		}
> > >> +
> > >>  		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_BLOCKED;
> > >>
> > >>  		/*
> > >> -- 
> > >> 1.7.4.4
> > >>
> > > 
> > > 
> > 

