Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbaBJAHb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 19:07:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbaBJAH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 19:07:29 -0500
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
In-Reply-To: <20140207042051.GL4250@linux.vnet.ibm.com>
References: <20140206134825.305510953@infradead.org>
	 <21984.1391711149@warthog.procyon.org.uk> <52F3DA85.1060209@arm.com>
	 <20140206185910.GE27276@mudshark.cambridge.arm.com>
	 <20140206192743.GH4250@linux.vnet.ibm.com>
	 <1391721423.23421.3898.camel@triegel.csb>
	 <20140206221117.GJ4250@linux.vnet.ibm.com>
	 <1391730288.23421.4102.camel@triegel.csb>
	 <20140207042051.GL4250@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Feb 2014 01:06:48 +0100
Message-ID: <1391990808.18779.63.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-06 at 20:20 -0800, Paul E. McKenney wrote:
> On Fri, Feb 07, 2014 at 12:44:48AM +0100, Torvald Riegel wrote:
> > On Thu, 2014-02-06 at 14:11 -0800, Paul E. McKenney wrote:
> > > On Thu, Feb 06, 2014 at 10:17:03PM +0100, Torvald Riegel wrote:
> > > > On Thu, 2014-02-06 at 11:27 -0800, Paul E. McKenney wrote:
> > > > > On Thu, Feb 06, 2014 at 06:59:10PM +0000, Will Deacon wrote:
> > > > > > There are also so many ways to blow your head off it's untrue. For example,
> > > > > > cmpxchg takes a separate memory model parameter for failure and success, but
> > > > > > then there are restrictions on the sets you can use for each. It's not hard
> > > > > > to find well-known memory-ordering experts shouting "Just use
> > > > > > memory_model_seq_cst for everything, it's too hard otherwise". Then there's
> > > > > > the fun of load-consume vs load-acquire (arm64 GCC completely ignores consume
> > > > > > atm and optimises all of the data dependencies away) as well as the definition
> > > > > > of "data races", which seem to be used as an excuse to miscompile a program
> > > > > > at the earliest opportunity.
> > > > > 
> > > > > Trust me, rcu_dereference() is not going to be defined in terms of
> > > > > memory_order_consume until the compilers implement it both correctly and
> > > > > efficiently.  They are not there yet, and there is currently no shortage
> > > > > of compiler writers who would prefer to ignore memory_order_consume.
> > > > 
> > > > Do you have any input on
> > > > http://gcc.gnu.org/bugzilla/show_bug.cgi?id=59448?  In particular, the
> > > > language standard's definition of dependencies?
> > > 
> > > Let's see...  1.10p9 says that a dependency must be carried unless:
> > > 
> > > — B is an invocation of any specialization of std::kill_dependency (29.3), or
> > > — A is the left operand of a built-in logical AND (&&, see 5.14) or logical OR (||, see 5.15) operator,
> > > or
> > > — A is the left operand of a conditional (?:, see 5.16) operator, or
> > > — A is the left operand of the built-in comma (,) operator (5.18);
> > > 
> > > So the use of "flag" before the "?" is ignored.  But the "flag - flag"
> > > after the "?" will carry a dependency, so the code fragment in 59448
> > > needs to do the ordering rather than just optimizing "flag - flag" out
> > > of existence.  One way to do that on both ARM and Power is to actually
> > > emit code for "flag - flag", but there are a number of other ways to
> > > make that work.
> > 
> > And that's what would concern me, considering that these requirements
> > seem to be able to creep out easily.  Also, whereas the other atomics
> > just constrain compilers wrt. reordering across atomic accesses or
> > changes to the atomic accesses themselves, the dependencies are new
> > requirements on pieces of otherwise non-synchronizing code.  The latter
> > seems far more involved to me.
> 
> Well, the wording of 1.10p9 is pretty explicit on this point.
> There are only a few exceptions to the rule that dependencies from
> memory_order_consume loads must be tracked.  And to your point about
> requirements being placed on pieces of otherwise non-synchronizing code,
> we already have that with plain old load acquire and store release --
> both of these put ordering constraints that affect the surrounding
> non-synchronizing code.

I think there's a significant difference.  With acquire/release or more
general memory orders, it's true that we can't order _across_ the atomic
access.  However, we can reorder and optimize without additional
constraints if we do not reorder.  This is not the case with consume
memory order, as the (p + flag - flag) example shows.

> This issue got a lot of discussion, and the compromise is that
> dependencies cannot leak into or out of functions unless the relevant
> parameters or return values are annotated with [[carries_dependency]].
> This means that the compiler can see all the places where dependencies
> must be tracked.  This is described in 7.6.4.

I wasn't aware of 7.6.4 (but it isn't referred to as an additional
constraint--what it is--in 1.10, so I guess at least that should be
fixed).
Also, AFAIU, 7.6.4p3 is wrong in that the attribute does make a semantic
difference, at least if one is assuming that normal optimization of
sequential code is the default, and that maintaining things such as
(flag-flag) is not; if optimizing away (flag-flag) would require the
insertion of fences unless there is the carries_dependency attribute,
then this would be bad I think.

IMHO, the dependencies construct (carries_dependency, kill_dependency)
seem to be backwards to me.  They assume that the compiler preserves all
those dependencies including (flag-flag) by default, which prohibits
meaningful optimizations.  Instead, I guess there should be a construct
for explicitly exploiting the dependencies (e.g., a
preserve_dependencies call, whose argument will not be optimized fully).
Exploiting dependencies will be special code and isn't the common case,
so it can be require additional annotations.

> If a dependency chain
> headed by a memory_order_consume load goes into or out of a function
> without the aid of the [[carries_dependency]] attribute, the compiler
> needs to do something else to enforce ordering, e.g., emit a memory
> barrier.

I agree that this is a way to see it.  But I can't see how this will
motivate compiler implementers to not just emit a stronger barrier right
away.

> From a Linux-kernel viewpoint, this is a bit ugly, as it requires
> annotations and use of kill_dependency, but it was the best I could do
> at the time.  If things go as they usually do, there will be some other
> reason why those are needed...

Did you consider something along the "preserve_dependencies" call?  If
so, why did you go for kill_dependency?


