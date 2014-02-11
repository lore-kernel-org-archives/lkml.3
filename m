Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbaBKP74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 10:59:56 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:52888 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbaBKP7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 10:59:54 -0500
Date: Tue, 11 Feb 2014 07:59:42 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Torvald Riegel <triegel@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140211155941.GU4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1391721423.23421.3898.camel@triegel.csb>
 <20140206221117.GJ4250@linux.vnet.ibm.com>
 <1391730288.23421.4102.camel@triegel.csb>
 <20140207042051.GL4250@linux.vnet.ibm.com>
 <20140207074405.GM5002@laptop.programming.kicks-ass.net>
 <20140207165028.GO4250@linux.vnet.ibm.com>
 <20140207165548.GR5976@mudshark.cambridge.arm.com>
 <20140207180216.GP4250@linux.vnet.ibm.com>
 <1391992071.18779.99.camel@triegel.csb>
 <CA+55aFwTwCPMpYTL_vCgNNP0hE8s2sgB0iw-79=xoj99V0JUNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwTwCPMpYTL_vCgNNP0hE8s2sgB0iw-79=xoj99V0JUNA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021115-0928-0000-0000-0000067E79E9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 11:09:24AM -0800, Linus Torvalds wrote:
> On Sun, Feb 9, 2014 at 4:27 PM, Torvald Riegel <triegel@redhat.com> wrote:
> >
> > Intuitively, this is wrong because this let's the program take a step
> > the abstract machine wouldn't do.  This is different to the sequential
> > code that Peter posted because it uses atomics, and thus one can't
> > easily assume that the difference is not observable.
> 
> Btw, what is the definition of "observable" for the atomics?
> 
> Because I'm hoping that it's not the same as for volatiles, where
> "observable" is about the virtual machine itself, and as such volatile
> accesses cannot be combined or optimized at all.
> 
> Now, I claim that atomic accesses cannot be done speculatively for
> writes, and not re-done for reads (because the value could change),
> but *combining* them would be possible and good.
> 
> For example, we often have multiple independent atomic accesses that
> could certainly be combined: testing the individual bits of an atomic
> value with helper functions, causing things like "load atomic, test
> bit, load same atomic, test another bit". The two atomic loads could
> be done as a single load without possibly changing semantics on a real
> machine, but if "visibility" is defined in the same way it is for
> "volatile", that wouldn't be a valid transformation. Right now we use
> "volatile" semantics for these kinds of things, and they really can
> hurt.
> 
> Same goes for multiple writes (possibly due to setting bits):
> combining multiple accesses into a single one is generally fine, it's
> *adding* write accesses speculatively that is broken by design..
> 
> At the same time, you can't combine atomic loads or stores infinitely
> - "visibility" on a real machine definitely is about timeliness.
> Removing all but the last write when there are multiple consecutive
> writes is generally fine, even if you unroll a loop to generate those
> writes. But if what remains is a loop, it might be a busy-loop
> basically waiting for something, so it would be wrong ("untimely") to
> hoist a store in a loop entirely past the end of the loop, or hoist a
> load in a loop to before the loop.
> 
> Does the standard allow for that kind of behavior?

You asked!  ;-)

So the current standard allows merging of both loads and stores, unless of
course ordring constraints prevent the merging.  Volatile semantics may be
used to prevent this merging, if desired, for example, for real-time code.
Infinite merging is intended to be prohibited, but I am not certain that
the current wording is bullet-proof (1.10p24 and 1.10p25).

The only prohibition against speculative stores that I can see is in a
non-normative note, and it can be argued to apply only to things that are
not atomics (1.10p22).  I don't see any prohibition against reordering
a store to precede a load preceding a conditional branch -- which would
not be speculative if the branch was know to be taken and the load
hit in the store buffer.  In a system where stores could be reordered,
some other CPU might perceive the store as happening before the load
that controlled the conditional branch.  This needs to be addressed.

Why this hole?  At the time, the current formalizations of popular
CPU architectures did not exist, and it was not clear that all popular
hardware avoided speculative stores.  

There is also fun with "out of thin air" values, which everyone agrees
should be prohibited, but where there is not agreement on how to prohibit
them in a mathematically constructive manner.  The current draft contains
a clause simply stating that out-of-thin-air values are prohibited,
which doesn't help someone constructing tools to analyze C++ code.
One proposal requires that subsequent atomic stores never be reordered
before prior atomic loads, which requires useless ordering code to be
emitted on ARM and PowerPC (you may have seen Will Deacon's and Peter
Zijlstra's reaction to this proposal a few days ago).  Note that Itanium
already pays this price in order to provide full single-variable cache
coherence.  This out-of-thin-air discussion is also happening in the
Java community in preparation for a new rev of the Java memory model.

There will also be some discussions on memory_order_consume, which is
intended to (eventually) implement rcu_dereference().  The compiler
writers don't like tracking dependencies, but there may be some ways
of constraining optimizations to preserve the common dependencies that,
while providing some syntax to force preservation of dependencies that
would normally be optimized out.  One example of this is where you have an
RCU-protected array that might sometimes contain only a single element.
In the single-element case, the compiler knows a priori which element
will be used, and will therefore optimize the dependency away, so that
the reader might see pre-initialization state.  But this is rare, so
if added syntax needs to be added in this case, I believe we should be
OK with it.  (If syntax is needed for plain old dereferences, it is
thumbs down all the way as far as I am concerned.  Ditto for things
like stripping the bottom bits off of a decorated pointer.)

No doubt other memory-model issues will come up, but those are the ones
I know about at the moment.

As I said to begin with, hey, you asked!

That said, I would very much appreciate any thoughts or suggestions on
handling these issues.

							Thanx, Paul

