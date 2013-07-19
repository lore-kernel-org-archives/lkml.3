Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933816Ab3GSFHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:07:05 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:36246 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933103Ab3GSFHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:07:03 -0400
Date: Thu, 18 Jul 2013 22:06:25 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC nohz_full 6/7] nohz_full: Add full-system-idle state
 machine
Message-ID: <20130719050625.GC21367@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1373333406-26979-6-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130717233119.GA2801@somewhere>
 <20130718004141.GI4161@linux.vnet.ibm.com>
 <20130718013259.GA7398@somewhere>
 <20130718033921.GL4161@linux.vnet.ibm.com>
 <20130718142450.GB7398@somewhere>
 <20130718164749.GV4161@linux.vnet.ibm.com>
 <20130718224620.GF7398@somewhere>
 <20130719002408.GB21367@linux.vnet.ibm.com>
 <20130719021207.GA19491@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130719021207.GA19491@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071905-5518-0000-0000-000010799459
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 04:12:08AM +0200, Frederic Weisbecker wrote:
> On Thu, Jul 18, 2013 at 05:24:08PM -0700, Paul E. McKenney wrote:
> > On Fri, Jul 19, 2013 at 12:46:21AM +0200, Frederic Weisbecker wrote:
> > > On Thu, Jul 18, 2013 at 09:47:49AM -0700, Paul E. McKenney wrote:
> > > > 1. Some CPU coming out of idle:
> > > > 
> > > > o	rcu_sysidle_exit():
> > > > 
> > > > 	smp_mb__before_atomic_inc();
> > > > 	atomic_inc(&rdtp->dynticks_idle);
> > > > 	smp_mb__after_atomic_inc(); /* A */
> > > > 
> > > > o	rcu_sysidle_force_exit():
> > > > 
> > > > 	oldstate = ACCESS_ONCE(full_sysidle_state);
> > > > 
> > > > 2. RCU GP kthread:
> > > > 
> > > > o	rcu_sysidle():
> > > > 
> > > > 	cmpxchg(&full_sysidle_state, RCU_SYSIDLE_SHORT, RCU_SYSIDLE_LONG);
> > > > 		/* B */
> > > > 
> > > > o	rcu_sysidle_check_cpu():
> > > > 
> > > > 	cur = atomic_read(&rdtp->dynticks_idle);
> > > > 
> > > > Memory barrier A pairs with memory barrier B, so that if #1's load
> > > > from full_sysidle_state sees RCU_SYSIDLE_SHORT, we know that #1's
> > > > atomic_inc() must be visible to #2's atomic_read().  This will cause #2
> > > > to recognize that the CPU came out of idle, which will in turn cause it
> > > > to invoke rcu_sysidle_cancel() instead of rcu_sysidle(), resulting in
> > > > full_sysidle_state being set to RCU_SYSIDLE_NOT.
> > > 
> > > Ok I get it for that direction.
> > > Now imagine CPU 0 is the RCU GP kthread (#2) and CPU 1 is idle and stays
> > > so.
> > > 
> > > CPU 0 then rounds and see that all CPUs are idle, until it finally sets
> > > up RCU_SYSIDLE_SHORT_FULL and finally goes to sleep.
> > > 
> > > Then CPU 1 wakes up. It really has to see a value above RCU_SYSIDLE_SHORT
> > > otherwise it won't do the cmpxchg and see the FULL_NOTED that makes it send
> > > the IPI.
> > > 
> > > What provides the guarantee that CPU 1 sees a value above RCU_SYSIDLE_SHORT?
> > > Not on the cmpxchg but when it first dereference with ACCESS_ONCE.
> > 
> > The trick is that CPU 0 will have scanned, moved to RCU_SYSIDLE_SHORT,
> > scanned, moved to RCU_SYSIDLE_LONG, then scanned again before moving
> > to RCU_SYSIDLE_FULL.  Given CPU 1 has been idle all this time, CPU 0
> > will have read its ->dynticks_idle counter on each scan and seen it
> > having an even value.  When CPU 1 comes out of idle, it will atomically
> > increment its ->dyntick_idle(), which will happen after CPU 0's read of
> > ->dyntick_idle() during its last scan.
> > 
> > Because of the memory-barrier pairing above, this means that CPU
> > 1's read from full_sysidle_state must follow the cmpxchg() that
> > set full_sysidle_state to RCU_SYSIDLE_LONG (though not necessarily
> > the two later cmpxchg()s that set it to RCU_SYSIDLE_FULL and
> > RCU_SYSIDLE_FULL_NOTED).  But because RCU_SYSIDLE_LONG is greater than
> > RCU_SYSIDLE_SHORT, CPU 1 will take action to end the idle period.
> 
> Lets summarize the last sequence, the following happens ordered by time:
> 
>         CPU 0                          CPU 1
> 
>      cmpxchg(&full_sysidle_state,
>              RCU_SYSIDLE_SHORT,
>              RCU_SYSIDLE_LONG);
> 
>      smp_mb() //cmpxchg
> 
>      atomic_read(rdtp(1)->dynticks_idle)
> 
>      //CPU 0 goes to sleep
>                                        //CPU 1 wakes up
>                                        atomic_inc(rdtp(1)->dynticks_idle)
> 
>                                        smp_mb()
> 
>                                        ACCESS_ONCE(full_sysidle_state)
> 
> 
> Are you suggesting that because the CPU 1 executes its atomic_inc() _after_ (in terms
> of absolute time) the atomic_read of CPU 0, the ordering settled in both sides guarantees
> that the value read from CPU 1 is the one from the cmpxchg that precedes the atomic_read,
> or FULL or FULL_NOTED that happen later.
> 
> If so that's a big lesson for me.                                     

It is not absolute time that matters.  Instead, it is the fact that
CPU 0, when reading from ->dynticks_idle, read the old value before the
atomic_inc().  Therefore, anything CPU 0 did before that memory barrier
preceding CPU 0's read must come before anything CPU 1 did after that
memory barrier following the atomic_inc().  For this to work, there
must be some access to the same variable on each CPU.

Or, if you must think in terms of time, you need a separate independent
timeline for each variable, with no direct mapping from one timeline to
another, except resulting from memory-barrier interactions.

							Thanx, Paul

