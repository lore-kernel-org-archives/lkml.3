Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbbAFUsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 15:48:01 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:57468 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756570AbbAFUsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 15:48:00 -0500
Date: Tue, 6 Jan 2015 12:47:53 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Kent Overstreet <kmo@daterainc.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Chris Mason <clm@fb.com>
Subject: Re: Linux 3.19-rc3
Message-ID: <20150106204753.GI5280@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20150106110730.GA25846@kmo-pixel>
 <20150106114215.GS29390@twins.programming.kicks-ass.net>
 <20150106114842.GP10476@twins.programming.kicks-ass.net>
 <20150106120121.GB26845@kmo-pixel>
 <20150106122006.GW29390@twins.programming.kicks-ass.net>
 <54ABDB4B.7070008@hurleysoftware.com>
 <20150106173808.GB5280@linux.vnet.ibm.com>
 <54AC224C.4030903@hurleysoftware.com>
 <20150106192559.GF5280@linux.vnet.ibm.com>
 <54AC3E31.2080202@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54AC3E31.2080202@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010620-0009-0000-0000-000007BF0F1F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 02:57:37PM -0500, Peter Hurley wrote:
> On 01/06/2015 02:25 PM, Paul E. McKenney wrote:
> > On Tue, Jan 06, 2015 at 12:58:36PM -0500, Peter Hurley wrote:
> >> On 01/06/2015 12:38 PM, Paul E. McKenney wrote:
> >>> On Tue, Jan 06, 2015 at 07:55:39AM -0500, Peter Hurley wrote:
> >>>> [ +cc Paul McKenney ]
> >>>>
> >>>> On 01/06/2015 07:20 AM, Peter Zijlstra wrote:
> >>>>> On Tue, Jan 06, 2015 at 04:01:21AM -0800, Kent Overstreet wrote:
> >>>>>> On Tue, Jan 06, 2015 at 12:48:42PM +0100, Peter Zijlstra wrote:
> >>>>>>>
> >>>>>>>
> >>>>>>> Looking at that closure stuff, why is there an smp_mb() in
> >>>>>>> closure_wake_up() ? Typically wakeup only needs to imply a wmb.
> >>>>>>>
> >>>>>>> Also note that __closure_wake_up() starts with a fully serializing
> >>>>>>> instruction (xchg) and thereby already implies the full barrier.
> >>>>>>
> >>>>>> Probably no good reason, that code is pretty old :)
> >>>>>>
> >>>>>> If I was to hazard a guess, I had my own lockless linked lists before llist.h
> >>>>>> existed and perhaps I did it with atomic_xchg() - which was at least documented
> >>>>>> to not imply a barrier. I suppose it should just be dropped.
> >>>>>
> >>>>> We (probably me) should probably audit all the atomic_xchg()
> >>>>> implementations and documentation and fix that. I was very much under
> >>>>> the impression it should imply a full barrier (and it certainly does on
> >>>>> x86), the documentation should state the rule that any atomic_ function
> >>>>> that returns a result is fully serializing, therefore, because
> >>>>> atomic_xchg() has a return value, it should too.
> >>>>
> >>>> memory-barriers.txt and atomic_ops.txt appear to contradict each other here,
> >>>> but I think that's because atomic_ops.txt has drifted toward an
> >>>> arch-implementer's POV:
> >>>>
> >>>> 260:atomic_xchg requires explicit memory barriers around the operation.
> >>>>
> >>>> All the serializing atomic operations have descriptions like this.
> >>>
> >>> I am not seeing the contradiction.
> >>>
> >>> You posted the relevant line from atomic_ops.txt.  The relevant passage
> >>> from memory-barriers.txt is as follows:
> >>>
> >>> 	Any atomic operation that modifies some state in memory and
> >>> 	returns information about the state (old or new) implies an
> >>> 	SMP-conditional general memory barrier (smp_mb()) on each side
> >>> 	of the actual operation (with the exception of explicit lock
> >>> 	operations, described later).  These include:
> >>>
> >>> 		xchg();
> >>> 		...
> >>> 		atomic_xchg();			atomic_long_xchg();
> >>>
> >>> So it appears to me that both documents require full barriers before and
> >>> after any atomic exchange operation in SMP builds.  Therefore, any
> >>> SMP-capable architecture that omits these barriers is buggy.
> >>
> >> Sure, I understand that, but I think the atomic_ops.txt is easy to
> >> misinterpret.
> >>
> >>> So, what am I missing here?
> >>
> >> Well, it's a matter of the intended audience. There is a significant
> >> difference between:
> >>
> >> static inline int atomic_xchg(atomic_t *v, int new)
> >> {
> >> 	/* this arch doesn't have serializing xchg() */
> >> 	smp_mb();
> >> 	/* arch xchg */
> >> 	smp_mb();
> >> }
> >>
> >> and
> >>
> >> 	smp_mb();
> >> 	atomic_xchg(&v, 1);
> >> 	smp_mb();
> >>
> >> but both have "explicit memory barriers around the operation."
> > 
> > The atomic_ops.txt file is pretty explicit about its intended audience
> > right at the beginning of the document:
> > 
> > 	This document is intended to serve as a guide to Linux port
> > 	maintainers on how to implement atomic counter, bitops, and spinlock
> > 	interfaces properly.
> > 
> > It is intended for people implementing the atomic operations more than
> > for people making use of them.
> 
> And yet the following admonition is clearly aimed at interface users:
> 
> *** WARNING: atomic_read() and atomic_set() DO NOT IMPLY BARRIERS! ***
> 
> Some architectures may choose to use the volatile keyword, barriers, or inline
> assembly to guarantee some degree of immediacy for atomic_read() and
> atomic_set().  This is not uniformly guaranteed, and may change in the future,
> so all users of atomic_t should treat atomic_read() and atomic_set() as simple
> C statements that may be reordered or optimized away entirely by the compiler
> or processor, and explicitly invoke the appropriate compiler and/or memory
> barrier for each use case.  Failure to do so will result in code that may
> suddenly break when used with different architectures or compiler
> optimizations, or even changes in unrelated code which changes how the
> compiler optimizes the section accessing atomic_t variables.
> 
> *** YOU HAVE BEEN WARNED! ***
> 
> 
> To me, it makes sense to (also) document the arch-independent interfaces
> for the much, much larger audience actually using them (not that I'm
> suggesting this is your responsibility).

David Miller's call, actually.

But the rule is that if it is an atomic read-modify-write operation and it
returns a value, then the operation itself needs to include full memory
barriers before and after (as in the caller doesn't need to add them).
Otherwise, the operation does not need to include memory ordering.
Since xchg(), atomic_xchg(), and atomic_long_xchg() all return a value,
their implementations must include full memory barriers before and after.

Pretty straightforward.  ;-)

							Thanx, Paul

