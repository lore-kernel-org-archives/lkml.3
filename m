Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759503Ab3GRWq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 18:46:27 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:60968 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759182Ab3GRWqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 18:46:25 -0400
Date: Fri, 19 Jul 2013 00:46:21 +0200
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
Message-ID: <20130718224620.GF7398@somewhere>
References: <20130709012934.GA26058@linux.vnet.ibm.com>
 <1373333406-26979-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1373333406-26979-6-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130717233119.GA2801@somewhere>
 <20130718004141.GI4161@linux.vnet.ibm.com>
 <20130718013259.GA7398@somewhere>
 <20130718033921.GL4161@linux.vnet.ibm.com>
 <20130718142450.GB7398@somewhere>
 <20130718164749.GV4161@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130718164749.GV4161@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 09:47:49AM -0700, Paul E. McKenney wrote:
> On Thu, Jul 18, 2013 at 04:24:51PM +0200, Frederic Weisbecker wrote:
> > On Wed, Jul 17, 2013 at 08:39:21PM -0700, Paul E. McKenney wrote:
> > > On Thu, Jul 18, 2013 at 03:33:01AM +0200, Frederic Weisbecker wrote:
> > > > So it's like:
> > > > 
> > > >     CPU 0                                              CPU 1
> > > > 
> > > >     read I                                             write I
> > > >     smp_mb()                                           smp_mb()
> > > >     cmpxchg S                                          read S
> > > > 
> > > > I still can't find what guarantees we don't read a value in CPU 1 that is way below
> > > > what we want.
> > > 
> > > One key point is that there is a second cycle from LONG to FULL.
> > > 
> > > (Not saying that there is not a bug -- there might well be.  In fact,
> > > I am starting to think that I need to do another Promela model...
> > 
> > Now I'm very confused :)
> 
> To quote a Nobel Laureate who presented at an ISEF here in Portland some
> years back, "Confusion is the most productive state of mind."  ;-)

Then I must be a very productive guy!

> 
> > I'm far from being a specialist on these matters but I would really love to
> > understand this patchset. Is there any documentation somewhere I can read
> > that could help, something about cycles of committed memory or something?
> 
> Documentation/memory-barriers.txt should suffice for this.  If you want
> more rigor, http://www.cl.cam.ac.uk/~pes20/ppc-supplemental/test7.pdf
> 
> But memory-barrier pairing suffices here.  Here is case 2 from my
> earlier email in more detail.  The comments with capital letters
> mark important memory barriers, some of which are buried in atomic
> operations.
> 
> 1. Some CPU coming out of idle:
> 
> o	rcu_sysidle_exit():
> 
> 	smp_mb__before_atomic_inc();
> 	atomic_inc(&rdtp->dynticks_idle);
> 	smp_mb__after_atomic_inc(); /* A */
> 
> o	rcu_sysidle_force_exit():
> 
> 	oldstate = ACCESS_ONCE(full_sysidle_state);
> 
> 2. RCU GP kthread:
> 
> o	rcu_sysidle():
> 
> 	cmpxchg(&full_sysidle_state, RCU_SYSIDLE_SHORT, RCU_SYSIDLE_LONG);
> 		/* B */
> 
> o	rcu_sysidle_check_cpu():
> 
> 	cur = atomic_read(&rdtp->dynticks_idle);
> 
> Memory barrier A pairs with memory barrier B, so that if #1's load
> from full_sysidle_state sees RCU_SYSIDLE_SHORT, we know that #1's
> atomic_inc() must be visible to #2's atomic_read().  This will cause #2
> to recognize that the CPU came out of idle, which will in turn cause it
> to invoke rcu_sysidle_cancel() instead of rcu_sysidle(), resulting in
> full_sysidle_state being set to RCU_SYSIDLE_NOT.

Ok I get it for that direction.
Now imagine CPU 0 is the RCU GP kthread (#2) and CPU 1 is idle and stays
so.

CPU 0 then rounds and see that all CPUs are idle, until it finally sets
up RCU_SYSIDLE_SHORT_FULL and finally goes to sleep.

Then CPU 1 wakes up. It really has to see a value above RCU_SYSIDLE_SHORT
otherwise it won't do the cmpxchg and see the FULL_NOTED that makes it send
the IPI.

What provides the guarantee that CPU 1 sees a value above RCU_SYSIDLE_SHORT?
Not on the cmpxchg but when it first dereference with ACCESS_ONCE.
