Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759219Ab3GRQtE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 12:49:04 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:33395 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758572Ab3GRQtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 12:49:01 -0400
Date: Thu, 18 Jul 2013 09:47:49 -0700
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
Message-ID: <20130718164749.GV4161@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130709012934.GA26058@linux.vnet.ibm.com>
 <1373333406-26979-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1373333406-26979-6-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130717233119.GA2801@somewhere>
 <20130718004141.GI4161@linux.vnet.ibm.com>
 <20130718013259.GA7398@somewhere>
 <20130718033921.GL4161@linux.vnet.ibm.com>
 <20130718142450.GB7398@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130718142450.GB7398@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071816-5406-0000-0000-00000A9561FC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 04:24:51PM +0200, Frederic Weisbecker wrote:
> On Wed, Jul 17, 2013 at 08:39:21PM -0700, Paul E. McKenney wrote:
> > On Thu, Jul 18, 2013 at 03:33:01AM +0200, Frederic Weisbecker wrote:
> > > So it's like:
> > > 
> > >     CPU 0                                              CPU 1
> > > 
> > >     read I                                             write I
> > >     smp_mb()                                           smp_mb()
> > >     cmpxchg S                                          read S
> > > 
> > > I still can't find what guarantees we don't read a value in CPU 1 that is way below
> > > what we want.
> > 
> > One key point is that there is a second cycle from LONG to FULL.
> > 
> > (Not saying that there is not a bug -- there might well be.  In fact,
> > I am starting to think that I need to do another Promela model...
> 
> Now I'm very confused :)

To quote a Nobel Laureate who presented at an ISEF here in Portland some
years back, "Confusion is the most productive state of mind."  ;-)

> I'm far from being a specialist on these matters but I would really love to
> understand this patchset. Is there any documentation somewhere I can read
> that could help, something about cycles of committed memory or something?

Documentation/memory-barriers.txt should suffice for this.  If you want
more rigor, http://www.cl.cam.ac.uk/~pes20/ppc-supplemental/test7.pdf

But memory-barrier pairing suffices here.  Here is case 2 from my
earlier email in more detail.  The comments with capital letters
mark important memory barriers, some of which are buried in atomic
operations.

1. Some CPU coming out of idle:

o	rcu_sysidle_exit():

	smp_mb__before_atomic_inc();
	atomic_inc(&rdtp->dynticks_idle);
	smp_mb__after_atomic_inc(); /* A */

o	rcu_sysidle_force_exit():

	oldstate = ACCESS_ONCE(full_sysidle_state);

2. RCU GP kthread:

o	rcu_sysidle():

	cmpxchg(&full_sysidle_state, RCU_SYSIDLE_SHORT, RCU_SYSIDLE_LONG);
		/* B */

o	rcu_sysidle_check_cpu():

	cur = atomic_read(&rdtp->dynticks_idle);

Memory barrier A pairs with memory barrier B, so that if #1's load
from full_sysidle_state sees RCU_SYSIDLE_SHORT, we know that #1's
atomic_inc() must be visible to #2's atomic_read().  This will cause #2
to recognize that the CPU came out of idle, which will in turn cause it
to invoke rcu_sysidle_cancel() instead of rcu_sysidle(), resulting in
full_sysidle_state being set to RCU_SYSIDLE_NOT.

							Thanx, Paul

> > > > Unfortunately, the reasoning in #2 above does not hold in the small-CPU
> > > > case because there is the possibility of both the timekeeping CPU and
> > > > the RCU grace-period kthread concurrently advancing the state machine.
> > > > This would be bad, good catch!!!
> > > 
> > > It's not like I spotted anything myself but you're welcome :)
> > 
> > I will take them any way I can get them.  ;-)
> > 
> > > > The patch below (untested) is an attempt to fix this.  If it actually
> > > > works, I will merge it in with 6/7.
> > > > 
> > > > Anything else I missed?  ;-)
> > > 
> > > Well I guess I'll wait one more night before trying to understand
> > > the below ;)
> > 
> > The key point is that the added check means that either the timekeeping
> > CPU is advancing the state machine (if there are few CPUs) or the
> > RCU grace-period kthread is (if there are many CPUs), but never both.
> > Or that is the intent, anyway!
> 
> Yeah got that.
> 
> Thanks!
> 

