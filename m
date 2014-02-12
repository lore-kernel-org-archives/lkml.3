Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbaBLRuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 12:50:08 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:34331 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbaBLRuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 12:50:05 -0500
Date: Wed, 12 Feb 2014 09:39:30 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Torvald Riegel <triegel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140212173930.GZ4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1391730288.23421.4102.camel@triegel.csb>
 <20140207042051.GL4250@linux.vnet.ibm.com>
 <20140207074405.GM5002@laptop.programming.kicks-ass.net>
 <20140207165028.GO4250@linux.vnet.ibm.com>
 <20140207165548.GR5976@mudshark.cambridge.arm.com>
 <20140207180216.GP4250@linux.vnet.ibm.com>
 <1391992071.18779.99.camel@triegel.csb>
 <CA+55aFwTwCPMpYTL_vCgNNP0hE8s2sgB0iw-79=xoj99V0JUNA@mail.gmail.com>
 <20140211155941.GU4250@linux.vnet.ibm.com>
 <1392185194.18779.2239.camel@triegel.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392185194.18779.2239.camel@triegel.csb>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021217-6688-0000-0000-0000066B3040
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 10:06:34PM -0800, Torvald Riegel wrote:
> On Tue, 2014-02-11 at 07:59 -0800, Paul E. McKenney wrote:
> > On Mon, Feb 10, 2014 at 11:09:24AM -0800, Linus Torvalds wrote:
> > > On Sun, Feb 9, 2014 at 4:27 PM, Torvald Riegel <triegel@redhat.com> wrote:
> > > >
> > > > Intuitively, this is wrong because this let's the program take a step
> > > > the abstract machine wouldn't do.  This is different to the sequential
> > > > code that Peter posted because it uses atomics, and thus one can't
> > > > easily assume that the difference is not observable.
> > > 
> > > Btw, what is the definition of "observable" for the atomics?
> > > 
> > > Because I'm hoping that it's not the same as for volatiles, where
> > > "observable" is about the virtual machine itself, and as such volatile
> > > accesses cannot be combined or optimized at all.
> > > 
> > > Now, I claim that atomic accesses cannot be done speculatively for
> > > writes, and not re-done for reads (because the value could change),
> > > but *combining* them would be possible and good.
> > > 
> > > For example, we often have multiple independent atomic accesses that
> > > could certainly be combined: testing the individual bits of an atomic
> > > value with helper functions, causing things like "load atomic, test
> > > bit, load same atomic, test another bit". The two atomic loads could
> > > be done as a single load without possibly changing semantics on a real
> > > machine, but if "visibility" is defined in the same way it is for
> > > "volatile", that wouldn't be a valid transformation. Right now we use
> > > "volatile" semantics for these kinds of things, and they really can
> > > hurt.
> > > 
> > > Same goes for multiple writes (possibly due to setting bits):
> > > combining multiple accesses into a single one is generally fine, it's
> > > *adding* write accesses speculatively that is broken by design..
> > > 
> > > At the same time, you can't combine atomic loads or stores infinitely
> > > - "visibility" on a real machine definitely is about timeliness.
> > > Removing all but the last write when there are multiple consecutive
> > > writes is generally fine, even if you unroll a loop to generate those
> > > writes. But if what remains is a loop, it might be a busy-loop
> > > basically waiting for something, so it would be wrong ("untimely") to
> > > hoist a store in a loop entirely past the end of the loop, or hoist a
> > > load in a loop to before the loop.
> > > 
> > > Does the standard allow for that kind of behavior?
> > 
> > You asked!  ;-)
> > 
> > So the current standard allows merging of both loads and stores, unless of
> > course ordring constraints prevent the merging.  Volatile semantics may be
> > used to prevent this merging, if desired, for example, for real-time code.
> 
> Agreed.
> 
> > Infinite merging is intended to be prohibited, but I am not certain that
> > the current wording is bullet-proof (1.10p24 and 1.10p25).
> 
> Yeah, maybe not.  But it at least seems to rather clearly indicate the
> intent ;)

That is my hope.  ;-)

> > The only prohibition against speculative stores that I can see is in a
> > non-normative note, and it can be argued to apply only to things that are
> > not atomics (1.10p22).
> 
> I think this one is specifically about speculative stores that would
> affect memory locations that the abstract machine would not write to,
> and that might be observable or create data races.  While a compiler
> could potentially prove that such stores aren't leading to a difference
> in the behavior of the program (e.g., by proving that there are no
> observers anywhere and this isn't overlapping with any volatile
> locations), I think that this is hard in general and most compilers will
> just not do such things.  In GCC, bugs in that category were fixed after
> researchers doing fuzz-testing found them (IIRC, speculative stores by
> loops).

And that is my fear.  ;-)

> > I don't see any prohibition against reordering
> > a store to precede a load preceding a conditional branch -- which would
> > not be speculative if the branch was know to be taken and the load
> > hit in the store buffer.  In a system where stores could be reordered,
> > some other CPU might perceive the store as happening before the load
> > that controlled the conditional branch.  This needs to be addressed.
> 
> I don't know the specifics of your example, but from how I understand
> it, I don't see a problem if the compiler can prove that the store will
> always happen.

The current Documentation/memory-barriers.txt formulation requires
that both the load and the store have volatile semantics.  Does
that help?

> To be more specific, if the compiler can prove that the store will
> happen anyway, and the region of code can be assumed to always run
> atomically (e.g., there's no loop or such in there), then it is known
> that we have one atomic region of code that will always perform the
> store, so we might as well do the stuff in the region in some order.

And it would be very hard to write a program that proved that the
store had been reordered prior to the load in this case.

> Now, if any of the memory accesses are atomic, then the whole region of
> code containing those accesses is often not atomic because other threads
> might observe intermediate results in a data-race-free way.
> 
> (I know that this isn't a very precise formulation, but I hope it brings
> my line of reasoning across.)
> 
> > Why this hole?  At the time, the current formalizations of popular
> > CPU architectures did not exist, and it was not clear that all popular
> > hardware avoided speculative stores.  
> 
> I'm not quite sure which hole you see there.  Can you elaborate?

Here is one attempt, based on Peter's example later in this thread:

	#define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))

	atomic_int x, y;  /* Default initialization to zero. */
	int r1;

	void T0(void)
	{
		if (atomic_load(&ACCESS_ONCE(x), memory_order_relaxed))
			atomic_store(&ACCESS_ONCE(y), 1, memory_order_relaxed);
	}

	void T1(void)
	{
		r1 = atomic_load(y, memory_order_seq_cst);
		/* Might also need an atomic_thread_fence() here... */
		atomic_store(x, 1, memory_order_seq_cst);
	}

	assert(r1 == 0);

Peter and I would like the assertion to never trigger in this case,
but the current C11 does not seem to guarantee this.  I believe that
the volatile casts forbid the compiler from deciding to omit T0's "if"
even in cases where it could prove that x was always zero.  And given
the store to x, it should not be able to prove constant x here, right?

Again, I believe that current C11 does not guarantee that the assertion
will never trigger, but it would be good if one of the successors to
C11 did make that guarantee.  ;-)

							Thanx, Paul

