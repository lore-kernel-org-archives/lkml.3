Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab3G0SNy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 14:13:54 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:60789 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab3G0SNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 14:13:52 -0400
Date: Sat, 27 Jul 2013 20:13:46 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC nohz_full 6/7] nohz_full: Add full-system-idle state
 machine
Message-ID: <20130727181343.GA4006@somewhere>
References: <20130718142450.GB7398@somewhere>
 <20130718164749.GV4161@linux.vnet.ibm.com>
 <20130718224620.GF7398@somewhere>
 <20130719002408.GB21367@linux.vnet.ibm.com>
 <20130719021207.GA19491@somewhere>
 <20130719050625.GC21367@linux.vnet.ibm.com>
 <20130724180903.GB23431@somewhere>
 <20130724220902.GA3889@linux.vnet.ibm.com>
 <20130724232642.GB30349@somewhere>
 <20130726225212.GZ3889@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130726225212.GZ3889@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 03:52:12PM -0700, Paul E. McKenney wrote:
> On Thu, Jul 25, 2013 at 01:26:44AM +0200, Frederic Weisbecker wrote:
> > I don't know because I encountered some troubles to build it, I'm seeing thousand
> > lines like this:
> > 
> > Name "main::opt_help" used only once: possible typo at /usr/bin/a2ping line 534.
> > /usr/bin/a2ping: not a GS output from gs -dSAFER
> > ./cartoons/whippersnapper300.eps -> ./cartoons/whippersnapper300.pdf
> > Name "main::opt_extra" used only once: possible typo at /usr/bin/a2ping line 546.
> > Name "main::opt_help" used only once: possible typo at /usr/bin/a2ping line 534.
> > /usr/bin/a2ping: not a GS output from gs -dSAFER
> > make: *** [embedfonts] Error 1
> 
> Strange.  My version of a2ping is Ubuntu 12.04's:
> 
> a2ping.pl 2.77p, 2006-11-15 -- Written by <pts@fazekas.hu> from April 2003.
> 
> You have something more recent?

I run Fedora 15 (yeah, too lazy to upgrade), and:

a2ping.pl 2.77p, 2004-04-28 -- Written by <pts@fazekas.hu> from April 2003

> > So back to the issue, I think we made nice progresses with my rusty brain ;-)
> > But just to be clear, I'm pasting that again for just a few precisions:
> > 
> >         CPU 0                                CPU 1
> > 
> >        cmpxchg(&full_sysidle_state,          //CPU 1 wakes up
> >                 RCU_SYSIDLE_SHORT,           atomic_inc(rdtp(1)->dynticks_idle)
> >                 RCU_SYSIDLE_LONG);
> > 
> >        smp_mb() //cmpxchg                    smp_mb()
> >        atomic_read(rdtp(1)->dynticks_idle)   ACCESS_ONCE(full_sysidle_state
> >       //CPU 0 goes to sleep
> > 
> > 
> > 
> > 1) If CPU 0 sets RCU_SYSIDLE_LONG and sees dynticks_idle as even, do we have the _guarantee_
> > that later CPU 1 sees full_sysidle_state == RCU_SYSIDLE_LONG (or any later full_sysidle_state value)
> > due to the connection between atomic_read / atomic_inc and the barriers that come along?
> 
> No, we do not have this guarantee.
> 
> What happens instead is that CPU 0 later sets RCU_SYSIDLE_FULL after
> having again seen CPU 1's ->dynticks_idle having an even (idle) value.
> If CPU 1 later increments its ->dynticks_idle to an odd (non-idle) value,
> then does a memory barrier, and then reads full_sysidle_state, then CPU
> 1 is guaranteed to see RCU_SYSIDLE_LONG.  Please note that CPU 1 is -not-
> obligated to see RCU_SYSIDLE_FULL, much less RCU_SYSIDLE_NOTED.

Aah. I think I got it now. So lay this out like what follows:

  void cpu_0(int old, int new)
  {
       cmpxchg(&full_sysidle_state, old, new);
       smp_mb()
       atomic_read(rdtp(1)->dynticks_idle)
  }

  void cpu_1(void)
  {
       atomic_inc(rdtp(1)->dynticks_idle)
       smp_mb()
       ACCESS_ONCE(full_sysidle_stat)
  }


And this scenario:

  CPU 0                                              CPU 1

  cpu_0(RCU_SYSIDLE_NOT, RCU_SYSIDLE_SHORT)
  cpu_0(RCU_SYSIDLE_SHORT, RCU_SYSIDLE_LONG)
                                                     cpu_1() // guaranteed to see at least RCU_SYSIDLE_SHORT
  cpu_0(RCU_SYSIDLE_LONG, RCU_SYSIDLE_FULL)
                                                     cpu_1() // guaranteed to see at least RCU_SYSIDLE_LONG

IIUC, the double slah comments should be true.
If so I can observe that even if we don't have memory commit guarantees, there seem to be some
forward progress guarantee against the update and read sequences.

What usually guarantees such forward progress on the sequences is when we have
some locking or atomic ops updates that also return a value (inc_return, cmpxchg, ...)
mirroring on both sides.

I can't find anything in atomic_ops.txt or in your book (ok sorry I only read a few pages
on the barriers chapter :o) that describes such forward progress guarantee.

Would I retrieve such a guarantee on a generic sequence like this?

//A = B = 0

 CPU 0                CPU 1

 store A = 1          store B = 1
 mb()                 mb()
 read B               read A
 ----------------------------
 store A = 2          store B = 2
 mb()                 mb()
 read B               read A

On the second sequence can I deduce that A and B as respectively read by CPU 0 and CPU 1
are at least 1 and might be 2?

> 
> However, when CPU 1 does an atomic operation on full_sysidle_state that
> returns the old value, CPU 1 is guaranteed to get the most recent state.
> (Without this guarantee, we could have a cactus state of values for
> full_sysidle_state, which might make alternate-universe fans happy,
> but which would be really hard to program.)

Haha! Yeah for the cmpxchg I'm ok.

> 
> This is why we need an RCU_SYSIDLE_LONG state in addition to
> RCU_SYSIDLE_SHORT and RCU_SYSIDLE_FULL.
> 
> > 2) You taught me once that barrier != memory committed, and it has been one of the hardest trauma
> > in my life. How can we be sure that CPU 1 sees memory as committed from CPU 0? The only fact that
> > we read an even value from CPU 0 is enough for the connection between the atomic_read() and atomic_inc()
> > and all the barriers that come along?
> 
> My condolences on the trauma!  Now, if you will look directly into the
> light...  ;-)
> 
> We cannot be sure.  All we can be sure of is the memory-barrier
> relationships and coherence order of each individual memory location.
> 
> The basic memory-barrier relationships are of the following form:
> 
> 	CPU 0		CPU 1
> 	ref A		ref C
> 	smp_mb()	smp_mb()
> 	ref B		ref D
> 
> If the results of these references show that ref C saw the results of
> ref B, then you know that ref D is guaranteed to see the results of
> ref A.  There are no guarantees on time delay.  At least there are no
> guarantees on time delay that the various hardware vendors are willing
> to tell us about.
> 
> For the coherence order of each individual memory location, let's focus
> on full_sysidle_state.  Suppose that CPU 0 uses cmpxchg() to advance
> it from RCU_SYSIDLE_NOT to RCU_SYSIDLE_SHORT to RCU_SYSIDLE_LONG to
> RCU_SYSIDLE_FULL and finally to RCU_SYSIDLE_NOTED.  When CPU 1 uses
> a normal load to access full_sysidle_state, it is only guaranteed to
> see RCU_SYSIDLE_LONG, because RCU_SYSIDLE_LONG is the value that
> CPU 0 last wrote prior to an access of CPU 1's ->dynticks_idle counter.

Yeah I see.

> 
> However, CPU 1 then uses a cmpxchg() loop to change the value of
> full_sysidle_state back to RCU_SYSIDLE_NOT in rcu_sysidle_force_exit().
> At this point, CPU 1 cannot be allowed to see an old value of
> full_sysidle_state, because this would contradict the cmpxchg() return
> values that CPU 0 saw in rcu_sysidle().  Therefore, the cmpxchg()
> in rcu_sysidle_force_exit() is obligated to return the most recent
> value.

Right.

> How does the hardware do this?  Well, for loads, the hardware can look
> just in its own cache, which might well contain an outdated value.
> In contrast, for cmpxchg(), the CPU must invalidate full_sysidle_state
> from all other caches, which ensures that the most recent value becomes
> available.

Doing a cmpxchg invalidates the copy in the cacheline of all other
CPUs?

> 
> So one way to guarantee most-recent results is to always
> use atomic instructions to access the variables, for example,
> atomic_add(&full_sysidle_state, 0) instead of a simple load instruction.
> Might be some performance degradation, but you know what they way about
> free lunches.  ;-)

Right :)

> 
> > 3) In your book it says: "recent hardware would guarantee that at least one of the loads saw the value
> > stored by the corresponding store".
> > 
> > At least one? So in our example, CPU 0 could see dynticks_idle as even (success to see some prior store done in
> > CPU 1) but following the above statement reasoning, CPU 1 might not see the corresponding store and see, for example
> > RCU_SYSIDLE_SHORT?
> 
> Ah, yes, the kernel of Dekker's algorithm.  ;-)
> 
> 	CPU 0		CPU 1
> 
> 	A=1		B=1
> 	smp_mb()	smp_mb()
> 	r1=B		r2=A
> 
> The initial values of both A and B are zero.
> 
> And yes, this does have the same form as the manipulations of
> full_sysidle_state and ->dynticks_idle.
> 
> Let's suppose that neither CPU saw the results of either CPU's store.
> The after both CPUs finished, we would have r1==0&&r2==0.  Let's start
> with the r1==0.
> 
> The r1==0 means that CPU 0 loaded from B before CPU 1 stored to B:
> After all, otherwise, we would have r1==1.  But because of memory-barrier
> pairing, this means that CPU 1's load from A must see the results of
> CPU 0's store to A, and therefore r2==1.
> 
> The procedure starting with r2==0 follows the same line of reasoning.
> Therefore, r1==0&&r2==0 cannot happen, which implies that at least
> one of the CPU's loads must see the other CPU's store.

Hmm, ok I'll read that again tomorrow with a fresher brain :)

> 
> > I'm really sorry to bother you with that... :-(
> 
> Absolutely not a problem!  In fact, the above discussion is now yet
> another infamous Quick Quiz in perfbook.  ;-)
> 
> 							Thanx, Paul
> 
