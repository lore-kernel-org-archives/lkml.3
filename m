Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900Ab3HHESf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 00:18:35 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:51345 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab3HHESd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 00:18:33 -0400
Date: Wed, 7 Aug 2013 21:18:25 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        C.Emde@osadl.org
Subject: Re: [PATCH 0/8] rcu: Ensure rcu read site is deadlock-immunity
Message-ID: <20130808041825.GH4306@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1375871104-10688-1-git-send-email-laijs@cn.fujitsu.com>
 <20130807123827.GB4306@linux.vnet.ibm.com>
 <20130808003635.GA9487@linux.vnet.ibm.com>
 <5202F8CC.2020703@cn.fujitsu.com>
 <1375927932.6848.33.camel@gandalf.local.home>
 <5203036B.2080606@cn.fujitsu.com>
 <20130808023356.GG4306@linux.vnet.ibm.com>
 <52030C37.3000106@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52030C37.3000106@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080804-3620-0000-0000-000003DBEA37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 08, 2013 at 11:10:47AM +0800, Lai Jiangshan wrote:
> On 08/08/2013 10:33 AM, Paul E. McKenney wrote:
> > On Thu, Aug 08, 2013 at 10:33:15AM +0800, Lai Jiangshan wrote:
> >> On 08/08/2013 10:12 AM, Steven Rostedt wrote:
> >>> On Thu, 2013-08-08 at 09:47 +0800, Lai Jiangshan wrote:
> >>>
> >>>>> [  393.641012]        CPU0
> >>>>> [  393.641012]        ----
> >>>>> [  393.641012]   lock(&lock->wait_lock);
> >>>>> [  393.641012]   <Interrupt>
> >>>>> [  393.641012]     lock(&lock->wait_lock);
> >>>>
> >>>> Patch2 causes it!
> >>>> When I found all lock which can (chained) nested in rcu_read_unlock_special(),
> >>>> I didn't notice rtmutex's lock->wait_lock is not nested in irq-disabled.
> >>>>
> >>>> Two ways to fix it:
> >>>> 1) change rtmutex's lock->wait_lock, make it alwasys irq-disabled.
> >>>> 2) revert my patch2
> >>>
> >>> Your patch 2 states:
> >>>
> >>> "After patch 10f39bb1, "special & RCU_READ_UNLOCK_BLOCKED" can't be true
> >>> in irq nor softirq.(due to RCU_READ_UNLOCK_BLOCKED can only be set
> >>> when preemption)"
> >>
> >> Patch5 adds "special & RCU_READ_UNLOCK_BLOCKED" back in irq nor softirq.
> >> This new thing is handle in patch5 if I did not do wrong things in patch5.
> >> (I don't notice rtmutex's lock->wait_lock is not irqs-disabled in patch5)
> >>
> >>>
> >>> But then below we have:
> >>>
> >>>
> >>>>
> >>>>> [  393.641012] 
> >>>>> [  393.641012]  *** DEADLOCK ***
> >>>>> [  393.641012] 
> >>>>> [  393.641012] no locks held by rcu_torture_rea/697.
> >>>>> [  393.641012] 
> >>>>> [  393.641012] stack backtrace:
> >>>>> [  393.641012] CPU: 3 PID: 697 Comm: rcu_torture_rea Not tainted 3.11.0-rc1+ #1
> >>>>> [  393.641012] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> >>>>> [  393.641012]  ffffffff8586fea0 ffff88001fcc3a78 ffffffff8187b4cb ffffffff8104a261
> >>>>> [  393.641012]  ffff88001e1a20c0 ffff88001fcc3ad8 ffffffff818773e4 0000000000000000
> >>>>> [  393.641012]  ffff880000000000 ffff880000000001 ffffffff81010a0a 0000000000000001
> >>>>> [  393.641012] Call Trace:
> >>>>> [  393.641012]  <IRQ>  [<ffffffff8187b4cb>] dump_stack+0x4f/0x84
> >>>>> [  393.641012]  [<ffffffff8104a261>] ? console_unlock+0x291/0x410
> >>>>> [  393.641012]  [<ffffffff818773e4>] print_usage_bug+0x1f5/0x206
> >>>>> [  393.641012]  [<ffffffff81010a0a>] ? save_stack_trace+0x2a/0x50
> >>>>> [  393.641012]  [<ffffffff810ae603>] mark_lock+0x283/0x2e0
> >>>>> [  393.641012]  [<ffffffff810ada10>] ? print_irq_inversion_bug.part.40+0x1f0/0x1f0
> >>>>> [  393.641012]  [<ffffffff810aef66>] __lock_acquire+0x906/0x1d40
> >>>>> [  393.641012]  [<ffffffff810ae94b>] ? __lock_acquire+0x2eb/0x1d40
> >>>>> [  393.641012]  [<ffffffff810ae94b>] ? __lock_acquire+0x2eb/0x1d40
> >>>>> [  393.641012]  [<ffffffff810b0a65>] lock_acquire+0x95/0x210
> >>>>> [  393.641012]  [<ffffffff818860f3>] ? rt_mutex_unlock+0x53/0x100
> >>>>> [  393.641012]  [<ffffffff81886d26>] _raw_spin_lock+0x36/0x50
> >>>>> [  393.641012]  [<ffffffff818860f3>] ? rt_mutex_unlock+0x53/0x100
> >>>>> [  393.641012]  [<ffffffff818860f3>] rt_mutex_unlock+0x53/0x100

The really strange thing here is that I thought that your passing false
in as the new second parameter to rcu_read_unlock_special() was supposed
to prevent rt_mutex_unlock() from being called.

But then why is the call from rcu_preempt_note_context_switch() also
passing false?  I would have expected that one to pass true.  Probably
I don't understand your intent with the "unlock" argument.

> >>>>> [  393.641012]  [<ffffffff810ee3ca>] rcu_read_unlock_special+0x17a/0x2a0
> >>>>> [  393.641012]  [<ffffffff810ee803>] rcu_check_callbacks+0x313/0x950
> >>>>> [  393.641012]  [<ffffffff8107a6bd>] ? hrtimer_run_queues+0x1d/0x180
> >>>>> [  393.641012]  [<ffffffff810abb9d>] ? trace_hardirqs_off+0xd/0x10
> >>>>> [  393.641012]  [<ffffffff8105bae3>] update_process_times+0x43/0x80
> >>>>> [  393.641012]  [<ffffffff810a9801>] tick_sched_handle.isra.10+0x31/0x40
> >>>>> [  393.641012]  [<ffffffff810a98f7>] tick_sched_timer+0x47/0x70
> >>>>> [  393.641012]  [<ffffffff8107941c>] __run_hrtimer+0x7c/0x490
> >>>>> [  393.641012]  [<ffffffff810a260d>] ? ktime_get_update_offsets+0x4d/0xe0
> >>>>> [  393.641012]  [<ffffffff810a98b0>] ? tick_nohz_handler+0xa0/0xa0
> >>>>> [  393.641012]  [<ffffffff8107a017>] hrtimer_interrupt+0x107/0x260
> >>>
> >>> The hrtimer_interrupt is calling a rt_mutex_unlock? How did that happen?
> >>> Did it first call a rt_mutex_lock?
> >>>
> >>> If patch two was the culprit, I'm thinking the idea behind patch two is
> >>> wrong. The only option is to remove patch number two!
> >>
> >> removing patch number two can solve the problem found be Paul, but it is not the best.
> >> because I can't declare that rcu is deadlock-immunity
> >> (it will be deadlock if rcu read site overlaps with rtmutex's lock->wait_lock
> >> if I only remove patch2)
> >> I must do more things, but I think it is still better than changing rtmutex's lock->wait_lock.
> > 
> > NP, I will remove your current patches and wait for an updated set.
> 
> Hi, Paul
> 
> Could you agree that moving the rt_mutex_unlock() to rcu_preempt_note_context_switch()?

My guess is that changing rcu_preempt_note_context_switch()'s call to
rcu_read_unlock_special(t, true) would accomplish this in a nicer way.
Except that I would first need to understand why rcu_check_callbacks()'s
call to rcu_read_unlock_special() resulted in rt_mutex_unlock() being
called.

Oh!

In rcu_read_unlock_special, shouldn't the:

	if (unlikely(unlock && irqs_disabled_flags(flags))) {

Instead be:

	if (unlikely(!unlock || irqs_disabled_flags(flags))) {

Here I am guessing that the "unlock" parameter means "It is OK for
rcu_read_unlock_special() to invoke rt_mutex_unlock()", so it would be
passed in as false from rcu_check_callbacks() and true everywhere else.
If it means something else, please let me know what that might be.

Though at this point, it is not clear to me how it helps to call
rcu_read_unlock_special() from rcu_check_callbacks().  After all,
rcu_check_callbacks() has interrupts disabled always, and so it is never
safe for anything that it calls to invoke rt_mutex_unlock().

In any case, the opinion that really matters is not mine, but rather
that of the hundreds of millions of computer systems that might soon be
executing this code.  As RCU maintainer, I just try my best to predict
what their opinions will be.  ;-)

							Thanx, Paul

> thanks,
> Lai
> 
> > 
> > 							Thanx, Paul
> > 
> > 
> 

