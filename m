Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259AbaBFW7M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 17:59:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757220AbaBFW7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 17:59:11 -0500
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
In-Reply-To: <20140206215521.GI4250@linux.vnet.ibm.com>
References: <20140206134825.305510953@infradead.org>
	 <21984.1391711149@warthog.procyon.org.uk> <52F3DA85.1060209@arm.com>
	 <20140206185910.GE27276@mudshark.cambridge.arm.com>
	 <1391720965.23421.3884.camel@triegel.csb>
	 <20140206215521.GI4250@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Feb 2014 23:58:22 +0100
Message-ID: <1391727502.23421.4017.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-06 at 13:55 -0800, Paul E. McKenney wrote:
> On Thu, Feb 06, 2014 at 10:09:25PM +0100, Torvald Riegel wrote:
> > On Thu, 2014-02-06 at 18:59 +0000, Will Deacon wrote:
> > > On Thu, Feb 06, 2014 at 06:55:01PM +0000, Ramana Radhakrishnan wrote:
> > > > On 02/06/14 18:25, David Howells wrote:
> > > > >
> > > > > Is it worth considering a move towards using C11 atomics and barriers and
> > > > > compiler intrinsics inside the kernel?  The compiler _ought_ to be able to do
> > > > > these.
> > > > 
> > > > 
> > > > It sounds interesting to me, if we can make it work properly and 
> > > > reliably. + gcc@gcc.gnu.org for others in the GCC community to chip in.
> > > 
> > > Given my (albeit limited) experience playing with the C11 spec and GCC, I
> > > really think this is a bad idea for the kernel.
> > 
> > I'm not going to comment on what's best for the kernel (simply because I
> > don't work on it), but I disagree with several of your statements.
> > 
> > > It seems that nobody really
> > > agrees on exactly how the C11 atomics map to real architectural
> > > instructions on anything but the trivial architectures.
> > 
> > There's certainly different ways to implement the memory model and those
> > have to be specified elsewhere, but I don't see how this differs much
> > from other things specified in the ABI(s) for each architecture.
> > 
> > > For example, should
> > > the following code fire the assert?
> > 
> > I don't see how your example (which is about what the language requires
> > or not) relates to the statement about the mapping above?
> > 
> > > 
> > > extern atomic<int> foo, bar, baz;
> > > 
> > > void thread1(void)
> > > {
> > > 	foo.store(42, memory_order_relaxed);
> > > 	bar.fetch_add(1, memory_order_seq_cst);
> > > 	baz.store(42, memory_order_relaxed);
> > > }
> > > 
> > > void thread2(void)
> > > {
> > > 	while (baz.load(memory_order_seq_cst) != 42) {
> > > 		/* do nothing */
> > > 	}
> > > 
> > > 	assert(foo.load(memory_order_seq_cst) == 42);
> > > }
> > > 
> > 
> > It's a good example.  My first gut feeling was that the assertion should
> > never fire, but that was wrong because (as I seem to usually forget) the
> > seq-cst total order is just a constraint but doesn't itself contribute
> > to synchronizes-with -- but this is different for seq-cst fences.
> 
> From what I can see, Will's point is that mapping the Linux kernel's
> atomic_add_return() primitive into fetch_add() does not work because
> atomic_add_return()'s ordering properties require that the assert()
> never fire.
> 
> Augmenting the fetch_add() with a seq_cst fence would work on many
> architectures, but not for all similar examples.  The reason is that
> the C11 seq_cst fence is deliberately weak compared to ARM's dmb or
> Power's sync.  To your point, I believe that it would make the above
> example work, but there are some IRIW-like examples that would fail
> according to the standard (though a number of specific implementations
> would in fact work correctly).

Thanks for the background.  I don't read LKML, and it wasn't obvious
from reading just the part of the thread posted to gcc@ that achieving
these semantics is the goal.

> > > To answer that question, you need to go and look at the definitions of
> > > synchronises-with, happens-before, dependency_ordered_before and a whole
> > > pile of vaguely written waffle to realise that you don't know.
> > 
> > Are you familiar with the formalization of the C11/C++11 model by Batty
> > et al.?
> > http://www.cl.cam.ac.uk/~mjb220/popl085ap-sewell.pdf
> > http://www.cl.cam.ac.uk/~mjb220/n3132.pdf
> > 
> > They also have a nice tool that can run condensed examples and show you
> > all allowed (and forbidden) executions (it runs in the browser, so is
> > slow for larger examples), including nice annotated graphs for those:
> > http://svr-pes20-cppmem.cl.cam.ac.uk/cppmem/
> > 
> > It requires somewhat special syntax, but the following, which should be
> > equivalent to your example above, runs just fine:
> > 
> > int main() {
> >   atomic_int foo = 0; 
> >   atomic_int bar = 0; 
> >   atomic_int baz = 0; 
> >   {{{ {
> >         foo.store(42, memory_order_relaxed);
> >         bar.store(1, memory_order_seq_cst);
> >         baz.store(42, memory_order_relaxed);
> >       }
> >   ||| {
> >         r1=baz.load(memory_order_seq_cst).readsvalue(42);
> >         r2=foo.load(memory_order_seq_cst).readsvalue(0);
> >       }
> >   }}};
> >   return 0; }
> > 
> > That yields 3 consistent executions for me, and likewise if the last
> > readsvalue() is using 42 as argument.
> > 
> > If you add a "fence(memory_order_seq_cst);" after the store to foo, the
> > program can't observe != 42 for foo anymore, because the seq-cst fence
> > is adding a synchronizes-with edge via the baz reads-from.
> > 
> > I think this is a really neat tool, and very helpful to answer such
> > questions as in your example.
> 
> Hmmm...  The tool doesn't seem to like fetch_add().  But let's assume that
> your substitution of store() for fetch_add() is correct.  Then this shows
> that we cannot substitute fetch_add() for atomic_add_return().

It should be in this example, I believe.

The tool also supports CAS:
cas_strong_explicit(bar,0,1,memory_order_seq_cst,memory_order_seq_cst);
cas_strong(bar,0,1);
cas_weak likewise...

With that change, I get a few more executions but still the 3 consistent
ones for either outcome.

> > > It's not hard
> > > to find well-known memory-ordering experts shouting "Just use
> > > memory_model_seq_cst for everything, it's too hard otherwise".
> > 
> > Everyone I've heard saying this meant this as advice to people new to
> > synchronization or just dealing infrequently with it.  The advice is the
> > simple and safe fallback, and I don't think it's meant as an
> > acknowledgment that the model itself would be too hard.  If the
> > language's memory model is supposed to represent weak HW memory models
> > to at least some extent, there's only so much you can do in terms of
> > keeping it simple.  If all architectures had x86-like models, the
> > language's model would certainly be simpler... :)
> 
> That is said a lot, but there was a recent Linux-kernel example that
> turned out to be quite hard to prove for x86.  ;-)
> 
> > > Then there's
> > > the fun of load-consume vs load-acquire (arm64 GCC completely ignores consume
> > > atm and optimises all of the data dependencies away)
> > 
> > AFAIK consume memory order was added to model Power/ARM-specific
> > behavior.  I agree that the way the standard specifies how dependencies
> > are to be preserved is kind of vague (as far as I understand it).  See
> > GCC PR 59448.
> 
> This one? http://gcc.gnu.org/ml/gcc-bugs/2013-12/msg01083.html

Yes, this bug, and I'd like to get feedback on the implementability of
this: http://gcc.gnu.org/bugzilla/show_bug.cgi?id=59448#c10

> That does indeed look to match what Will was calling out as a problem.
> 
> > > as well as the definition
> > > of "data races", which seem to be used as an excuse to miscompile a program
> > > at the earliest opportunity.
> > 
> > No.  The purpose of this is to *not disallow* every optimization on
> > non-synchronizing code.  Due to the assumption of data-race-free
> > programs, the compiler can assume a sequential code sequence when no
> > atomics are involved (and thus, keep applying optimizations for
> > sequential code).
> > 
> > Or is there something particular that you dislike about the
> > specification of data races?
> 
> Cut Will a break, Torvald!  ;-)

Sorry if my comment came across too harsh.  I've observed a couple of
times that people forget about the compiler's role in this, and it might
not be obvious, so I wanted to point out just that.


