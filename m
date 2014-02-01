Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486AbaBAXWz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 18:22:55 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:56720 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbaBAXWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 18:22:53 -0500
Date: Sat, 1 Feb 2014 15:22:45 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: George Spelvin <linux@horizon.com>, Waiman.Long@hp.com,
        akpm@linux-foundation.org, andi@firstfloor.org, arnd@arndb.de,
        aswin@hp.com, hpa@zytor.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        raghavendra.kt@linux.vnet.ibm.com, riel@redhat.com,
        rostedt@goodmis.org, scott.norton@hp.com, tglx@linutronix.de,
        tim.c.chen@linux.intel.com, torvalds@linux-foundation.org,
        walken@google.com, x86@kernel.org
Subject: Re: [PATCH v11 0/4] Introducing a queue read/write lock
 implementation
Message-ID: <20140201232245.GB4333@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140131092616.GC5126@laptop.programming.kicks-ass.net>
 <20140131100348.8867.qmail@science.horizon.com>
 <20140131101729.GA8874@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140131101729.GA8874@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020123-3532-0000-0000-00000533ABEF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 11:17:29AM +0100, Peter Zijlstra wrote:
> On Fri, Jan 31, 2014 at 05:03:48AM -0500, George Spelvin wrote:
> > How about getting rid of that TICKET_MSB mess and doing something like:
> > 
> > #define TICKET_MASK	0xFFFF
> > 
> > static inline void ticket_spin_unlock(atomic_t *tickets)
> > {
> > 	u32 t = *tickets;
> > 
> > 	smp_mb__before_atomic_inc();
> > 
> > 	/* Increment the low 16 bits without affecting the upper. */
> > 	if (unlikely((~t & TICKET_MASK) == 0))
> > 		atomic_add(-(atomic_t)TICKET_MASK, tickets);
> > 	else
> > 		atomic_inc(tickets);
> > }
> > 
> > That also allows up to 2^16 waiters, up from 2^15.
> > (Minus one on both cases, if you want to be fussy.)
> 
> Ah indeed. That'll work. That said, any arch that can single-copy
> address shorts can probably do better than this generic atomic_t thing.
> 
> My main point was that we should seriously look at a ticket lock instead
> of the MCS one, because while the MCS has better contention behaviour,
> we shouldn't optimize locks for the worst contention.

We do need to articulate what we -are- optimizing for, or more generally,
what we are trying to accomplish with these locking primitives.  Here
are some of the traditional goals:

1.	Avoid performance collapse under heavy load.  Here the goal is
	to have throughput level off rather than decreasing when load
	exceeds saturation levels.

2.	Avoid starvation of requesters.  Here the goal is a very
	minimal level of fairness.

3.	Achieve some reasonable level of fairness if the underlying
	hardware provides fair access to memory.  Here "reasonable"
	might mean that lock-grant probabilities not differ by more
	than (say) a factor of two.

4.	Achieve some reasonable level of fairness even if the underlying
	hardware is unfair.  Rumor has it that some of the very large
	systems in use today do not guarantee fair access to cache lines
	under heavy memory contention.

5.	Achieve some minimal level of scalability, so that throughput
	increases monotonically with increasing load.  Preferably
	without penalizing small-system performance.

6.	Achieve some reasonable level of scalability, so that adding
	a given CPU provides at least some fraction (say, 80%) of
	one CPU's worth of incremental throughput.

7.	Achieve linear scalability.

Ticket locking has problems with #1 on some systems due to the thundering
herd of reads following each invalidation.  (Yes, it is not as bad
as the atomic-operation thundering herd associated with test-and-set
spinlocks, but it can neverthelless be a problem on larger systems.)
Achieving #4 requires some sort of queued lock as far as I can see.
Although you -might- get #5 with a very clever NUMA-aware lock, #6 and
#7 will require some level of redesign.

Fancy locks can help if the common code path is fully parallelized,
but where some rare error path is not worth the effort.  In this case,
using a fancy lock on the error path can at least keep the system moving
during the time that the error condition is in force, and hopefully
permit returning to full throughput once the error condition is gone.

So, what exactly are we trying to achieve with all this?  ;-)

							Thanx, Paul

