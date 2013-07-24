Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab3GXX0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 19:26:50 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59166 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805Ab3GXX0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 19:26:49 -0400
Date: Thu, 25 Jul 2013 01:26:44 +0200
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
Message-ID: <20130724232642.GB30349@somewhere>
References: <20130718013259.GA7398@somewhere>
 <20130718033921.GL4161@linux.vnet.ibm.com>
 <20130718142450.GB7398@somewhere>
 <20130718164749.GV4161@linux.vnet.ibm.com>
 <20130718224620.GF7398@somewhere>
 <20130719002408.GB21367@linux.vnet.ibm.com>
 <20130719021207.GA19491@somewhere>
 <20130719050625.GC21367@linux.vnet.ibm.com>
 <20130724180903.GB23431@somewhere>
 <20130724220902.GA3889@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130724220902.GA3889@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 03:09:02PM -0700, Paul E. McKenney wrote:
> On Wed, Jul 24, 2013 at 08:09:04PM +0200, Frederic Weisbecker wrote:
> > On Thu, Jul 18, 2013 at 10:06:25PM -0700, Paul E. McKenney wrote:
> > > > Lets summarize the last sequence, the following happens ordered by time:
> > > > 
> > > >         CPU 0                          CPU 1
> > > > 
> > > >      cmpxchg(&full_sysidle_state,
> > > >              RCU_SYSIDLE_SHORT,
> > > >              RCU_SYSIDLE_LONG);
> > > > 
> > > >      smp_mb() //cmpxchg
> > > > 
> > > >      atomic_read(rdtp(1)->dynticks_idle)
> > > > 
> > > >      //CPU 0 goes to sleep
> > > >                                        //CPU 1 wakes up
> > > >                                        atomic_inc(rdtp(1)->dynticks_idle)
> > > > 
> > > >                                        smp_mb()
> > > > 
> > > >                                        ACCESS_ONCE(full_sysidle_state)
> > > > 
> > > > 
> > > > Are you suggesting that because the CPU 1 executes its atomic_inc() _after_ (in terms
> > > > of absolute time) the atomic_read of CPU 0, the ordering settled in both sides guarantees
> > > > that the value read from CPU 1 is the one from the cmpxchg that precedes the atomic_read,
> > > > or FULL or FULL_NOTED that happen later.
> > > > 
> > > > If so that's a big lesson for me.                                     
> > > 
> > > It is not absolute time that matters.  Instead, it is the fact that
> > > CPU 0, when reading from ->dynticks_idle, read the old value before the
> > > atomic_inc().  Therefore, anything CPU 0 did before that memory barrier
> > > preceding CPU 0's read must come before anything CPU 1 did after that
> > > memory barrier following the atomic_inc().  For this to work, there
> > > must be some access to the same variable on each CPU.
> > 
> > Aren't we in the following situation?
> > 
> >     CPU 0                          CPU 1
> > 
> >     STORE A                        STORE B
> >     LOAD B                         LOAD A
> > 
> > 
> > If so and referring to your perfbook, this is an "ears to mouth" situation.
> > And it seems to describe there is no strong guarantee in that situation.
> 
> "Yes" to the first, but on modern hardware, "no" to the second.  The key
> paragraph is Section 12.2.4.5:
> 
> 	The following pairings from Table 12.1 can be used on modern
> 	hardware, but might fail on some systems that were produced in
> 	the 1990s. However, these can safely be used on all mainstream
> 	hardware introduced since the year 2000.

Right I missed that!

> 
> That said, you are not the first to be confused by this, so I might need
> to rework this section to make it clear that each can in fact be used on
> modern hardware.
> 
> If you happen to have an old Sequent NUMA-Q or Symmetry box lying around,
> things are a bit different.  On the other hand, I don't believe that any
> of these old boxes are still running Linux.  (Hey, I am as sentimental as
> the next guy, but there are limits!)
> 
> I updated this section and pushed it, please let me know if this helps!

I don't know because I encountered some troubles to build it, I'm seeing thousand
lines like this:

Name "main::opt_help" used only once: possible typo at /usr/bin/a2ping line 534.
/usr/bin/a2ping: not a GS output from gs -dSAFER
./cartoons/whippersnapper300.eps -> ./cartoons/whippersnapper300.pdf
Name "main::opt_extra" used only once: possible typo at /usr/bin/a2ping line 546.
Name "main::opt_help" used only once: possible typo at /usr/bin/a2ping line 534.
/usr/bin/a2ping: not a GS output from gs -dSAFER
make: *** [embedfonts] Error 1

Anyway I looked at the diff and it looks indeed clearer, thanks!

So back to the issue, I think we made nice progresses with my rusty brain ;-)
But just to be clear, I'm pasting that again for just a few precisions:

        CPU 0                                CPU 1

       cmpxchg(&full_sysidle_state,          //CPU 1 wakes up
                RCU_SYSIDLE_SHORT,           atomic_inc(rdtp(1)->dynticks_idle)
                RCU_SYSIDLE_LONG);

       smp_mb() //cmpxchg                    smp_mb()
       atomic_read(rdtp(1)->dynticks_idle)   ACCESS_ONCE(full_sysidle_state
      //CPU 0 goes to sleep



1) If CPU 0 sets RCU_SYSIDLE_LONG and sees dynticks_idle as even, do we have the _guarantee_
that later CPU 1 sees full_sysidle_state == RCU_SYSIDLE_LONG (or any later full_sysidle_state value)
due to the connection between atomic_read / atomic_inc and the barriers that come along?

2) You taught me once that barrier != memory committed, and it has been one of the hardest trauma
in my life. How can we be sure that CPU 1 sees memory as committed from CPU 0? The only fact that
we read an even value from CPU 0 is enough for the connection between the atomic_read() and atomic_inc()
and all the barriers that come along?

3) In your book it says: "recent hardware would guarantee that at least one of the loads saw the value
stored by the corresponding store".

At least one? So in our example, CPU 0 could see dynticks_idle as even (success to see some prior store done in
CPU 1) but following the above statement reasoning, CPU 1 might not see the corresponding store and see, for example
RCU_SYSIDLE_SHORT?

I'm really sorry to bother you with that... :-(
