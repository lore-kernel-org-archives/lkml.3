Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751091Ab3IFS7e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 14:59:34 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:44254 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab3IFS7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 14:59:32 -0400
Date: Fri, 6 Sep 2013 20:59:29 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130906185927.GE2706@somewhere>
References: <20130905195234.GA20555@linux.vnet.ibm.com>
 <20130906105934.GF20519@somewhere>
 <20130906151851.GQ3966@linux.vnet.ibm.com>
 <1378488088.31445.39.camel@edumazet-glaptop>
 <20130906174117.GU3966@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130906174117.GU3966@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 10:41:17AM -0700, Paul E. McKenney wrote:
> On Fri, Sep 06, 2013 at 10:21:28AM -0700, Eric Dumazet wrote:
> > On Fri, 2013-09-06 at 08:18 -0700, Paul E. McKenney wrote:
> > 
> > > int rcu_is_cpu_idle(void)
> > > {
> > > 	int ret;
> > > 
> > > 	preempt_disable();
> > > 	ret = (atomic_read(&__get_cpu_var(rcu_dynticks).dynticks) & 0x1) == 0;
> > > 	preempt_enable();
> > > 	return ret;
> > > }
> > 
> > Paul I find this very confusing.
> > 
> > If caller doesn't have preemption disabled, what could be the meaning of
> > this rcu_is_cpu_idle() call ?
> > 
> > Its result is meaningless if suddenly thread is preempted, so what is
> > the point ?
> > 
> > Sorry if this is obvious to you.
> 
> It is a completely fair question.  In fact, this might well now be
> pointing to a bug given NO_HZ_FULL.
> 
> The assumption is that if you don't have preemption disabled, you had
> better be running on a CPU that RCU is paying attention to.  The rationale
> involves preemptible RCU.
> 
> Suppose that you just did rcu_read_lock() on a CPU that RCU is paying
> attention to.  All is well, and rcu_is_cpu_idle() will return false, as
> expected.  Suppose now that it is possible to be preempted and suddenly
> find yourself running on a CPU that RCU is not paying attention to.
> This would have the effect of making your RCU read-side critical section
> be ignored.  Therefore, it had better not be possible to be preempted
> from a CPU to which RCU is paying attention to a CPU that RCU is ignoring.
> 
> So if rcu_is_cpu_idle() returns false, you had better be guaranteed
> that whatever CPU you are running on (which might well be a different
> one than the rcu_is_cpu_idle() was running on) is being watched by RCU.
> 
> So, Frederic, does this still work with NO_HZ_FULL?  If not, I believe
> we have a bigger problem than the preempt_disable() in rcu_is_cpu_idle()!

Sure it works well, because the scheduler task entrypoints exit those RCU
extended quiescent states.

Imagine that you're running on an rcu read side critical section on CPU 0, which
is not in extended quiescent state. Now you get preempted in the middle of your
RCU read side critical section (you called rcu_read_lock() but not yet rcu_read_unlock()).

Later on, the task is woken up to be scheduled in CPU 1. If CPU 1 is in extended
quiescent state because it runs is userspace, it receives a scheduler IPI,
then schedule_user() is called by the end of the interrupt and in turns calls rcu_user_exit()
before the task is resumed to the code it was running on CPU 0, in the middle of
the rcu read side extended quiescent state.

See, the key here is the rcu_user_exit() that restore the CPU on RCU's state machine.
There are other possible scheduler entrypoints when a CPU runs in user extended quiescent
state: exception and syscall entries or even preempt_schedule_irq() in case we receive an irq
in the kernel while we haven't yet reached the call to rcu_user_exit()... All of these should
be covered, otherwise you bet RCU would be prompt to warn.

That's why when we call rcu_is_cpu_idle() from an RCU read side critical section, it's legit even
if we can be preempted anytime around it.
And preempt_disable() is probably not even necessary, except perhaps if __get_cpu_var() itself
relies on non-preemptibility for its own correctness on the address calculation.

Thanks.
