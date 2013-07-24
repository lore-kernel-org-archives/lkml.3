Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab3GXSJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 14:09:11 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:47187 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab3GXSJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 14:09:09 -0400
Date: Wed, 24 Jul 2013 20:09:04 +0200
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
Message-ID: <20130724180903.GB23431@somewhere>
References: <20130717233119.GA2801@somewhere>
 <20130718004141.GI4161@linux.vnet.ibm.com>
 <20130718013259.GA7398@somewhere>
 <20130718033921.GL4161@linux.vnet.ibm.com>
 <20130718142450.GB7398@somewhere>
 <20130718164749.GV4161@linux.vnet.ibm.com>
 <20130718224620.GF7398@somewhere>
 <20130719002408.GB21367@linux.vnet.ibm.com>
 <20130719021207.GA19491@somewhere>
 <20130719050625.GC21367@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130719050625.GC21367@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 10:06:25PM -0700, Paul E. McKenney wrote:
> > Lets summarize the last sequence, the following happens ordered by time:
> > 
> >         CPU 0                          CPU 1
> > 
> >      cmpxchg(&full_sysidle_state,
> >              RCU_SYSIDLE_SHORT,
> >              RCU_SYSIDLE_LONG);
> > 
> >      smp_mb() //cmpxchg
> > 
> >      atomic_read(rdtp(1)->dynticks_idle)
> > 
> >      //CPU 0 goes to sleep
> >                                        //CPU 1 wakes up
> >                                        atomic_inc(rdtp(1)->dynticks_idle)
> > 
> >                                        smp_mb()
> > 
> >                                        ACCESS_ONCE(full_sysidle_state)
> > 
> > 
> > Are you suggesting that because the CPU 1 executes its atomic_inc() _after_ (in terms
> > of absolute time) the atomic_read of CPU 0, the ordering settled in both sides guarantees
> > that the value read from CPU 1 is the one from the cmpxchg that precedes the atomic_read,
> > or FULL or FULL_NOTED that happen later.
> > 
> > If so that's a big lesson for me.                                     
> 
> It is not absolute time that matters.  Instead, it is the fact that
> CPU 0, when reading from ->dynticks_idle, read the old value before the
> atomic_inc().  Therefore, anything CPU 0 did before that memory barrier
> preceding CPU 0's read must come before anything CPU 1 did after that
> memory barrier following the atomic_inc().  For this to work, there
> must be some access to the same variable on each CPU.

Aren't we in the following situation?

    CPU 0                          CPU 1

    STORE A                        STORE B
    LOAD B                         LOAD A


If so and referring to your perfbook, this is an "ears to mouth" situation.
And it seems to describe there is no strong guarantee in that situation.

> 
> Or, if you must think in terms of time, you need a separate independent
> timeline for each variable, with no direct mapping from one timeline to
> another, except resulting from memory-barrier interactions.
> 
> 							Thanx, Paul
> 
