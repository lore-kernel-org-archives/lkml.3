Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbaBGSCZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 13:02:25 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:50931 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbaBGSCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 13:02:23 -0500
Date: Fri, 7 Feb 2014 10:02:16 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Torvald Riegel <triegel@redhat.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140207180216.GP4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <52F3DA85.1060209@arm.com>
 <20140206185910.GE27276@mudshark.cambridge.arm.com>
 <20140206192743.GH4250@linux.vnet.ibm.com>
 <1391721423.23421.3898.camel@triegel.csb>
 <20140206221117.GJ4250@linux.vnet.ibm.com>
 <1391730288.23421.4102.camel@triegel.csb>
 <20140207042051.GL4250@linux.vnet.ibm.com>
 <20140207074405.GM5002@laptop.programming.kicks-ass.net>
 <20140207165028.GO4250@linux.vnet.ibm.com>
 <20140207165548.GR5976@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140207165548.GR5976@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020718-0928-0000-0000-000006572C13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 04:55:48PM +0000, Will Deacon wrote:
> Hi Paul,
> 
> On Fri, Feb 07, 2014 at 04:50:28PM +0000, Paul E. McKenney wrote:
> > On Fri, Feb 07, 2014 at 08:44:05AM +0100, Peter Zijlstra wrote:
> > > On Thu, Feb 06, 2014 at 08:20:51PM -0800, Paul E. McKenney wrote:
> > > > Hopefully some discussion of out-of-thin-air values as well.
> > > 
> > > Yes, absolutely shoot store speculation in the head already. Then drive
> > > a wooden stake through its hart.
> > > 
> > > C11/C++11 should not be allowed to claim itself a memory model until that
> > > is sorted.
> > 
> > There actually is a proposal being put forward, but it might not make ARM
> > and Power people happy because it involves adding a compare, a branch,
> > and an ISB/isync after every relaxed load...  Me, I agree with you,
> > much preferring the no-store-speculation approach.
> 
> Can you elaborate a bit on this please? We don't permit speculative stores
> in the ARM architecture, so it seems counter-intuitive that GCC needs to
> emit any additional instructions to prevent that from happening.

Requiring a compare/branch/ISB after each relaxed load enables a simple(r)
proof that out-of-thin-air values cannot be observed in the face of any
compiler optimization that refrains from reordering a prior relaxed load
with a subsequent relaxed store.

> Stores can, of course, be observed out-of-order but that's a lot more
> reasonable :)

So let me try an example.  I am sure that Torvald Riegel will jump in
with any needed corrections or amplifications:

Initial state: x == y == 0

T1:	r1 = atomic_load_explicit(x, memory_order_relaxed);
	atomic_store_explicit(r1, y, memory_order_relaxed);

T2:	r2 = atomic_load_explicit(y, memory_order_relaxed);
	atomic_store_explicit(r2, x, memory_order_relaxed);

One would intuitively expect r1 == r2 == 0 as the only possible outcome.
But suppose that the compiler used specialization optimizations, as it
would if there was a function that has a very lightweight implementation
for some values and a very heavyweight one for other.  In particular,
suppose that the lightweight implementation was for the value 42.
Then the compiler might do something like the following:

Initial state: x == y == 0

T1:	r1 = atomic_load_explicit(x, memory_order_relaxed);
	if (r1 == 42)
		atomic_store_explicit(42, y, memory_order_relaxed);
	else
		atomic_store_explicit(r1, y, memory_order_relaxed);

T2:	r2 = atomic_load_explicit(y, memory_order_relaxed);
	atomic_store_explicit(r2, x, memory_order_relaxed);

Suddenly we have an explicit constant 42 showing up.  Of course, if
the compiler carefully avoided speculative stores (as both Peter and
I believe that it should if its code generation is to be regarded as
anything other than an act of vandalism, the words in the standard
notwithstanding), there would be no problem.  But currently, a number
of compiler writers see absolutely nothing wrong with transforming
the optimized-for-42 version above with something like this:

Initial state: x == y == 0

T1:	r1 = atomic_load_explicit(x, memory_order_relaxed);
	atomic_store_explicit(42, y, memory_order_relaxed);
	if (r1 != 42)
		atomic_store_explicit(r1, y, memory_order_relaxed);

T2:	r2 = atomic_load_explicit(y, memory_order_relaxed);
	atomic_store_explicit(r2, x, memory_order_relaxed);

And then it is a short and uncontroversial step to the following:

Initial state: x == y == 0

T1:	atomic_store_explicit(42, y, memory_order_relaxed);
	r1 = atomic_load_explicit(x, memory_order_relaxed);
	if (r1 != 42)
		atomic_store_explicit(r1, y, memory_order_relaxed);

T2:	r2 = atomic_load_explicit(y, memory_order_relaxed);
	atomic_store_explicit(r2, x, memory_order_relaxed);

This can of course result in r1 == r2 == 42, even though the constant
42 never appeared in the original code.  This is one way to generate
an out-of-thin-air value.

As near as I can tell, compiler writers hate the idea of prohibiting
speculative-store optimizations because it requires them to introduce
both control and data dependency tracking into their compilers.  Many of
them seem to hate dependency tracking with a purple passion.  At least,
such a hatred would go a long way towards explaining the incomplete
and high-overhead implementations of memory_order_consume, the long
and successful use of idioms based on the memory_order_consume pattern
notwithstanding [*].  ;-)

That said, the Java guys are talking about introducing something
vaguely resembling memory_order_consume (and thus resembling the
rcu_assign_pointer() and rcu_dereference() portions of RCU) to solve Java
out-of-thin-air issues involving initialization, so perhaps there is hope.

						Thanx, Paul

[*] http://queue.acm.org/detail.cfm?id=2488549
    http://www.rdrop.com/users/paulmck/RCU/rclockpdcsproof.pdf

