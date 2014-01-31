Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714AbaAaTEA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 14:04:00 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:42126 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236AbaAaTD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 14:03:59 -0500
Date: Fri, 31 Jan 2014 11:03:54 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 2/2] timer: really raise softirq if there is irq_work to
 do
Message-ID: <20140131190354.GO9012@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1391178845-15837-1-git-send-email-bigeasy@linutronix.de>
 <1391178845-15837-2-git-send-email-bigeasy@linutronix.de>
 <20140131120757.594e24d6@gandalf.local.home>
 <20140131174227.GN9012@linux.vnet.ibm.com>
 <20140131125719.73340f6e@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140131125719.73340f6e@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14013119-3532-0000-0000-0000052CFAB0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 12:57:19PM -0500, Steven Rostedt wrote:
> On Fri, 31 Jan 2014 09:42:27 -0800
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > On Fri, Jan 31, 2014 at 12:07:57PM -0500, Steven Rostedt wrote:
> > > On Fri, 31 Jan 2014 15:34:05 +0100
> > > Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> > > 
> > > > from looking at the code, it seems that the softirq is only raised (in
> > > > the !base->active_timers case) if we have also an expired timer
> > > > (time_before_eq() is true). This patch ensures that the timer softirq is
> > > > also raised in the !base->active_timers && no timer expired.
> > > 
> > > A couple of things. If there is no active timers, we do not need to
> > > check the expired timers. That may contain a deferred timer that does
> > > not need to be raised if the system is idle. This will just
> > > re-introduce the problems that other people have been seeing.
> > > 
> > > The bug that I found is that if there *are* active timers, but they
> > > have not expired yet. Why is this a problem? Because in that case we do
> > > not check if there is irq_work to be done. That means the irq_work will
> > > have to wait till the timer expires, and since RCU depends on this,
> > > that can take a while. I've had a synchronize_sched() take up to 5
> > > seconds to complete due to this!
> > > 
> > > 
> > > The real fix is the following:
> > > 
> > > timer/rt: Always raise the softirq if there's irq_work to be done
> > > 
> > > It was previously discovered that some systems would hang on boot up
> > > with a previous version of 3.12-rt. This was due to RCU using irq_work,
> > > and RT defers the irq_work to a softirq. But if there's no active
> > > timers, the softirq will not be raised, and RCU work will not get done,
> > > causing the system to hang.  The fix was to check that if there was no
> > > active timers but irq_work to be done, then we should raise the softirq.
> > > 
> > > But this fix was not 100% correct. It left out the case that there were
> > > active timers that were not expired yet. This would have the softirq
> > > not get raised even if there was irq work to be done.
> > > 
> > > If there is irq_work to be done, then we must raise the timer softirq
> > > regardless of if there is active timers or whether they are expired or
> > > not. The softirq can handle those cases. But we can never ignore
> > > irq_work.
> > > 
> > > As it is only PREEMPT_RT_FULL that requires irq_work to be done in the
> > > softirq, we can pull out the check in the active_timers condition, and
> > > make the code a bit cleaner by having the irq_work check separate, and
> > > put the code in with the other #ifdef PREEMPT_RT. If there is irq_work
> > > to be done, there's no need to check the active timers or if they are
> > > expired. Just raise the time softirq and be done with it. Otherwise, we
> > > can do the timer checks just like we do with non -rt.
> > > 
> > > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > > 
> > > diff --git a/kernel/timer.c b/kernel/timer.c
> > > index 106968f..426d114 100644
> > > --- a/kernel/timer.c
> > > +++ b/kernel/timer.c
> > > @@ -1461,18 +1461,20 @@ void run_local_timers(void)
> > >  	 * the timer softirq.
> > >  	 */
> > >  #ifdef CONFIG_PREEMPT_RT_FULL
> > > +	/* On RT, irq work runs from softirq */
> > > +	if (irq_work_needs_cpu()) {
> > > +		raise_softirq(TIMER_SOFTIRQ);
> > 
> > OK, I'll bite...  What if the IRQ work that needs doing is something
> > other than TIMER_SOFTIRQ?
> 
> Heh, don't let the timer part confuse you. The only reason that softirq
> is relevant to irq_work is that is the softirq that we placed the
> irq_work to be done. If you look at the code that is called for that
> softirq (in -rt) you'll see:
> 
> static void run_timer_softirq(struct softirq_action *h)
> {
> 	struct tvec_base *base = __this_cpu_read(tvec_bases);
> 
> #if defined(CONFIG_IRQ_WORK) && defined(CONFIG_PREEMPT_RT_FULL)
> 	irq_work_run();
> #endif
> 
> 	if (time_after_eq(jiffies, base->timer_jiffies))
> 		__run_timers(base);
> }
> 
> And we also have:
> 
> void update_process_times(int user_tick)
> {
> 	struct task_struct *p = current;
> 	int cpu = smp_processor_id();
> 
> 	/* Note: this timer irq context must be accounted for as well. */
> 	account_process_tick(p, user_tick);
> 	scheduler_tick();
> 	run_local_timers();
> 	rcu_check_callbacks(cpu, user_tick);
> #if defined(CONFIG_IRQ_WORK) && !defined(CONFIG_PREEMPT_RT_FULL)
> 	if (in_irq())
> 		irq_work_run();
> #endif
> 	run_posix_cpu_timers(p);
> }
> 
> 
> In vanilla Linux, irq_work_run() is called from update_process_times()
> when it is called from the timer interrupt. In -rt, there's reasons we
> can't do the irq work from hard irq, so we push it off to the timer
> softirq, and run it there.
> 
> That means if we have *any* irq work to do, we raise the timer softirq,
> even if the work to be done has nothing to do with timers. As you can
> see from the softirq timer code, in -rt, irq_work_run() is always
> called, without having to look at any timers.

OK, got it!  Thank you for the tutorial.  ;-)

							Thanx, Paul

