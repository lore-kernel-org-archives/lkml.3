Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaBFXpi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 18:45:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbaBFXpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 18:45:36 -0500
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Torvald Riegel <triegel@redhat.com>
To: paulmck@linux.vnet.ibm.com
Cc: Will Deacon <will.deacon@arm.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
In-Reply-To: <20140206221117.GJ4250@linux.vnet.ibm.com>
References: <20140206134825.305510953@infradead.org>
	 <21984.1391711149@warthog.procyon.org.uk> <52F3DA85.1060209@arm.com>
	 <20140206185910.GE27276@mudshark.cambridge.arm.com>
	 <20140206192743.GH4250@linux.vnet.ibm.com>
	 <1391721423.23421.3898.camel@triegel.csb>
	 <20140206221117.GJ4250@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Feb 2014 00:44:48 +0100
Message-ID: <1391730288.23421.4102.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-06 at 14:11 -0800, Paul E. McKenney wrote:
> On Thu, Feb 06, 2014 at 10:17:03PM +0100, Torvald Riegel wrote:
> > On Thu, 2014-02-06 at 11:27 -0800, Paul E. McKenney wrote:
> > > On Thu, Feb 06, 2014 at 06:59:10PM +0000, Will Deacon wrote:
> > > > There are also so many ways to blow your head off it's untrue. For example,
> > > > cmpxchg takes a separate memory model parameter for failure and success, but
> > > > then there are restrictions on the sets you can use for each. It's not hard
> > > > to find well-known memory-ordering experts shouting "Just use
> > > > memory_model_seq_cst for everything, it's too hard otherwise". Then there's
> > > > the fun of load-consume vs load-acquire (arm64 GCC completely ignores consume
> > > > atm and optimises all of the data dependencies away) as well as the definition
> > > > of "data races", which seem to be used as an excuse to miscompile a program
> > > > at the earliest opportunity.
> > > 
> > > Trust me, rcu_dereference() is not going to be defined in terms of
> > > memory_order_consume until the compilers implement it both correctly and
> > > efficiently.  They are not there yet, and there is currently no shortage
> > > of compiler writers who would prefer to ignore memory_order_consume.
> > 
> > Do you have any input on
> > http://gcc.gnu.org/bugzilla/show_bug.cgi?id=59448?  In particular, the
> > language standard's definition of dependencies?
> 
> Let's see...  1.10p9 says that a dependency must be carried unless:
> 
> — B is an invocation of any specialization of std::kill_dependency (29.3), or
> — A is the left operand of a built-in logical AND (&&, see 5.14) or logical OR (||, see 5.15) operator,
> or
> — A is the left operand of a conditional (?:, see 5.16) operator, or
> — A is the left operand of the built-in comma (,) operator (5.18);
> 
> So the use of "flag" before the "?" is ignored.  But the "flag - flag"
> after the "?" will carry a dependency, so the code fragment in 59448
> needs to do the ordering rather than just optimizing "flag - flag" out
> of existence.  One way to do that on both ARM and Power is to actually
> emit code for "flag - flag", but there are a number of other ways to
> make that work.

And that's what would concern me, considering that these requirements
seem to be able to creep out easily.  Also, whereas the other atomics
just constrain compilers wrt. reordering across atomic accesses or
changes to the atomic accesses themselves, the dependencies are new
requirements on pieces of otherwise non-synchronizing code.  The latter
seems far more involved to me.

> BTW, there is some discussion on 1.10p9's handling of && and ||, and
> that clause is likely to change.  And yes, I am behind on analyzing
> usage in the Linux kernel to find out if Linux cares...

Do you have any pointers to these discussions (e.g., LWG issues)?

> > > And rcu_dereference() will need per-arch overrides for some time during
> > > any transition to memory_order_consume.
> > > 
> > > > Trying to introduce system concepts (writes to devices, interrupts,
> > > > non-coherent agents) into this mess is going to be an uphill battle IMHO. I'd
> > > > just rather stick to the semantics we have and the asm volatile barriers.
> > > 
> > > And barrier() isn't going to go away any time soon, either.  And
> > > ACCESS_ONCE() needs to keep volatile semantics until there is some
> > > memory_order_whatever that prevents loads and stores from being coalesced.
> > 
> > I'd be happy to discuss something like this in ISO C++ SG1 (or has this
> > been discussed in the past already?).  But it needs to have a paper I
> > suppose.
> 
> The current position of the usual suspects other than me is that this
> falls into the category of forward-progress guarantees, which are
> considers (again, by the usual suspects other than me) to be out
> of scope.

But I think we need to better describe forward progress, even though
that might be tricky.  We made at least some progress on
http://cplusplus.github.io/LWG/lwg-active.html#2159 in Chicago, even
though we can't constrain the OS schedulers too much, and for lock-free
we're in this weird position that on most general-purpose schedulers and
machines, obstruction-free algorithms are likely to work just fine like
lock-free, most of the time, in practice...

We also need to discuss forward progress guarantees for any
parallelism/concurrency abstractions, I believe:
http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2014/n3874.pdf

Hopefully we'll get some more acceptance of this being in scope...

> > Will you be in Issaquah for the C++ meeting next week?
> 
> Weather permitting, I will be there!

Great, maybe we can find some time in SG1 to discuss this then.  Even if
the standard doesn't want to include it, SG1 should be a good forum to
understand everyone's concerns around that, with the hope that this
would help potential non-standard extensions to be still checked by the
same folks that did the rest of the memory model.

