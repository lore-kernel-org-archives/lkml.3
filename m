Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbaBORbT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 12:31:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753443AbaBORbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 12:31:16 -0500
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Torvald Riegel <triegel@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
In-Reply-To: <CA+55aFx9CbgrfK4rBVYD75y2KoWiO90dSYsAW83O-tYVLK-gkg@mail.gmail.com>
References: <20140207180216.GP4250@linux.vnet.ibm.com>
	 <1391992071.18779.99.camel@triegel.csb>
	 <CA+55aFwTwCPMpYTL_vCgNNP0hE8s2sgB0iw-79=xoj99V0JUNA@mail.gmail.com>
	 <1392183564.18779.2187.camel@triegel.csb>
	 <20140212180739.GB4250@linux.vnet.ibm.com>
	 <CA+55aFw3S82GYdtnV2nJCvBGcuZf6kXdF5b7Vp9yb21QKr49Jw@mail.gmail.com>
	 <20140213002355.GI4250@linux.vnet.ibm.com>
	 <1392321837.18779.3249.camel@triegel.csb>
	 <20140214020144.GO4250@linux.vnet.ibm.com>
	 <1392352981.18779.3800.camel@triegel.csb>
	 <20140214172920.GQ4250@linux.vnet.ibm.com>
	 <CA+55aFx9CbgrfK4rBVYD75y2KoWiO90dSYsAW83O-tYVLK-gkg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 15 Feb 2014 09:30:28 -0800
Message-ID: <1392485428.18779.6387.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-14 at 11:50 -0800, Linus Torvalds wrote:
> On Fri, Feb 14, 2014 at 9:29 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >
> > Linus, Peter, any objections to marking places where we are relying on
> > ordering from control dependencies against later stores?  This approach
> > seems to me to have significant documentation benefits.
> 
> Quite frankly, I think it's stupid, and the "documentation" is not a
> benefit, it's just wrong.

I think the example is easy to misunderstand, because the context isn't
clear.  Therefore, let me first try to clarify the background.

(1) The abstract machine does not write speculatively.
(2) Emitting a branch instruction and executing a branch at runtime is
not part of the specified behavior of the abstract machine.  Of course,
the abstract machine performs conditional execution, but that just
specifies the output / side effects that it must produce (e.g., volatile
stores) -- not with which hardware instructions it is producing this.
(3) A compiled program must produce the same output as if executed by
the abstract machine.

Thus, we need to be careful what "speculative store" is meant to refer
to.  A few examples:

if (atomic_load(&x, mo_relaxed) == 1)
  atomic_store(&y, 3, mo_relaxed));

Here, the requirement is that in terms of program logic, y is assigned 3
if x equals 1.  It's not specified how an implementation does that.
* If the compiler can prove that x is always 1, then it can remove the
branch.  This is because of (2).  Because of the proof, (1) is not
violated.
* If the compiler can prove that the store to y is never observed or
does not change the program's output, the store can be removed.

if (atomic_load(&x, mo_relaxed) == 1)
  { atomic_store(&y, 3, mo_relaxed)); other_a(); }
else
  { atomic_store(&y, 3, mo_relaxed)); other_b(); }

Here, y will be assigned to regardless of the value of x.
* The compiler can hoist the store out of the two branches.  This is
because the store and the branch instruction aren't observable outcomes
of the abstract machine.
* The compiler can even move the store to y before the load from x
(unless this affects logical program order of this thread in some way.)
This is because the load/store are ordered by sequenced-before
(intra-thread), but mo_relaxed allows the hardware to reorder, so the
compiler can do it as well (IOW, other threads can't expect a particular
order).

if (atomic_load(&x, mo_acquire) == 1)
  atomic_store(&y, 3, mo_relaxed));

This is similar to the first case, but with stronger memory order.
* If the compiler proves that x is always 1, then it does so by showing
that the load will always be able to read from a particular store (or
several of them) that (all) assigned 1 to x -- as specified by the
abstract machine and taking the forward progress guarantees into
account.  In general, it still has to establish the synchronized-with
edge if any of those stores used release_mo (or other fences resulting
in the same situation), so it can't just get rid of the acquire "fence"
in this case.  (There are probably situations in which this can be done,
but I can't characterize them easily at the moment.)


These examples all rely on the abstract machine as specified in the
current standard.  In contrast, the example that Paul (and Peter, I
assume) where looking at is not currently modeled by the standard.
AFAIU, they want to exploit that control dependencies, when encountered
in binary code, can result in the hardware giving certain ordering
guarantees.

This is vaguely similar to mo_consume which is about data dependencies.
mo_consume is, partially due to how it's specified, pretty hard to
implement for compilers in a way that actually exploits and preserves
data dependencies and not just substitutes mo_consume for a stronger
memory order.

Part of this problem is that the standard takes an opt-out approach
regarding the code that should track dependencies (e.g., certain
operators are specified as not preserving them), instead of cleanly
carving out meaningful operators where one can track dependencies
without obstructing generally useful compiler optimizations (i.e.,
"opt-in").  This leads to cases such as that in "*(p + f - f)", the
compiler either has to keep f - f or emit a stronger fence if f is
originating from a mo_consume load.  Furthermore, dependencies are
supposed to be tracked across any load and store, so the compiler needs
to do points-to if it wants to optimize this as much as possible.

Paul and I have been thinking about alternatives, and one of them was
doing the opt-in by demarcating code that needs explicit dependency
tracking because it wants to exploit mo_consume.

Back to HW control dependencies, this lead to the idea of marking the
"control dependencies" in the source code (ie, on the abstract machine
level), that need to be preserved in the generated binary code, even if
they have no semantic meaning on the abstract machine level.  So, this
is something extra that isn't modeled in the standard currently, because
of (1) and (2) above.

(Note that it's clearly possible that I misunderstand the goals of
Paul/Peter.  But then this would just indicate that working on precise
specifications does help :)

> How would you figure out whether your added "documentation" holds true
> for particular branches but not others?
> 
> How could you *ever* trust a compiler that makes the dependency meaningful?

Does the above clarify the situation?  If not, can you perhaps rephrase
any remaining questions?

> Again, let's keep this simple and sane:
> 
>  - if a compiler ever generates code where an atomic store movement is
> "visible" in any way, then that compiler is broken shit.

Unless volatile, the store is not part of the "visible" output of the
abstract machine, and such an implementation "detail".  In turn, any
correct store movement must not affect the output of the program, so the
implementation detail remains invisible.

> I don't understand why you even argue this. Seriously, Paul, you seem
> to *want* to think that "broken shit" is acceptable, and that we
> should then add magic markers to say "now you need to *not* be broken
> shit".
> 
> Here's a magic marker for you: DON'T USE THAT BROKEN COMPILER.
> 
> And if a compiler can *prove* that whatever code movement it does
> cannot make a difference, then let it do so. No amount of
> "documentation" should matter.

Enabling that is certainly a goal of how the standard specifies all
this.  I'll let you sort out whether you want to exploit the control
dependency thing :)

> Seriously, this whole discussion has been completely moronic. I don't
> understand why you even bring shit like this up:
> 
> > >     r1 = atomic_load(x, memory_order_control);
> > >     if (control_dependency(r1))
> > >             atomic_store(y, memory_order_relaxed);
> 
> I mean, really? Anybody who writes code like that, or any compiler
> where that "control_dependency()" marker makes any difference
> what-so-ever for code generation should just be retroactively aborted.

It doesn't make a difference in the standard as specified (well, there's
no control_dependency :).  I hope the background above clarifies the
discussed extension idea this originated from.

> There is absolutely *zero* reason for that "control_dependency()"
> crap. If you ever find a reason for it, it is either because the
> compiler is buggy, or because the standard is so shit that we should
> never *ever* use the atomics.
> 
> Seriously. This thread has devolved into some kind of "just what kind
> of idiotic compiler cesspool crap could we accept". Get away from that
> f*cking mindset. We don't accept *any* crap.
> 
> Why are we still discussing this idiocy? It's irrelevant. If the
> standard really allows random store speculation, the standard doesn't
> matter, and sane people shouldn't waste their time arguing about it.

It disallows it if this changes program semantics as specified by the
abstract machine.  Does that answer your concerns?  (Or, IOW, do you
still wonder whether it's crap? ;)

