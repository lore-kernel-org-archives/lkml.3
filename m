Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492AbaBNFId (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 00:08:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbaBNFIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 00:08:31 -0500
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Torvald Riegel <triegel@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: paulmck@linux.vnet.ibm.com, Linus Torvalds <torvalds@linux-foundation.org>,
        Will Deacon <will.deacon@arm.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
In-Reply-To: <20140212091907.GA3545@laptop.programming.kicks-ass.net>
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
	 <20140212091907.GA3545@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Feb 2014 21:07:55 -0800
Message-ID: <1392354475.18779.3849.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-12 at 10:19 +0100, Peter Zijlstra wrote:
> > I don't know the specifics of your example, but from how I understand
> > it, I don't see a problem if the compiler can prove that the store will
> > always happen.
> > 
> > To be more specific, if the compiler can prove that the store will
> > happen anyway, and the region of code can be assumed to always run
> > atomically (e.g., there's no loop or such in there), then it is known
> > that we have one atomic region of code that will always perform the
> > store, so we might as well do the stuff in the region in some order.
> > 
> > Now, if any of the memory accesses are atomic, then the whole region of
> > code containing those accesses is often not atomic because other threads
> > might observe intermediate results in a data-race-free way.
> > 
> > (I know that this isn't a very precise formulation, but I hope it brings
> > my line of reasoning across.)
> 
> So given something like:
> 
> 	if (x)
> 		y = 3;
> 
> assuming both x and y are atomic (so don't gimme crap for now knowing
> the C11 atomic incantations); and you can prove x is always true; you
> don't see a problem with not emitting the conditional?

That depends on what your goal is.  It would be correct as far as the
standard is specified; this makes sense if all you want is indeed a
program that does what the abstract machine might do, and produces the
same output / side effects.

If you're trying to preserve the branch in the code emitted / executed
by the implementation, then it would not be correct.  But those branches
aren't specified as being part of the observable side effects.  In the
common case, this makes sense because it enables optimizations that are
useful; this line of reasoning also allows the compiler to merge some
atomic accesses in the way that Linus would like to see it.

> Avoiding the conditional changes the result; see that control dependency
> email from earlier.

It does not regarding how the standard defines "result".

> In the above example the load of X and the store to
> Y are strictly ordered, due to control dependencies. Not emitting the
> condition and maybe not even emitting the load completely wrecks this.

I think you're trying to solve this backwards.  You are looking at this
with an implicit wishlist of what the compiler should do (or how you
want to use the hardware), but this is not a viable specification that
one can write a compiler against.

We do need clear rules for what the compiler is allowed to do or not
(e.g., a memory model that models multi-threaded executions).  Otherwise
it's all hand-waving, and we're getting nowhere.  Thus, the way to
approach this is to propose a feature or change to the standard, make
sure that this is consistent and has no unintended side effects for
other aspects of compilation or other code, and then ask the compiler to
implement it.  IOW, we need a patch for where this all starts: in the
rules and requirements for compilation.

Paul and I are at the C++ meeting currently, and we had sessions in
which the concurrency study group talked about memory model issues like
dependency tracking and memory_order_consume.  Paul shared uses of
atomics (or likewise) in the kernel, and we discussed how the memory
model currently handles various cases and why, how one could express
other requirements consistently, and what is actually implementable in
practice.  I can't speak for Paul, but I thought those discussions were
productive.

> Its therefore an invalid optimization to take out the conditional or
> speculate the store, since it takes out the dependency.



