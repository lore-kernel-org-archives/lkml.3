Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbaBQWK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:10:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbaBQWK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:10:26 -0500
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
In-Reply-To: <CA+55aFw5v8Zc818YoxazFhP0btN1faofNbED=qrpi3VrtRA39w@mail.gmail.com>
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
	 <1392485428.18779.6387.camel@triegel.csb>
	 <CA+55aFw5v8Zc818YoxazFhP0btN1faofNbED=qrpi3VrtRA39w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Feb 2014 23:09:46 +0100
Message-ID: <1392674986.18779.7038.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-02-15 at 11:15 -0800, Linus Torvalds wrote:
> On Sat, Feb 15, 2014 at 9:30 AM, Torvald Riegel <triegel@redhat.com> wrote:
> >
> > I think the example is easy to misunderstand, because the context isn't
> > clear.  Therefore, let me first try to clarify the background.
> >
> > (1) The abstract machine does not write speculatively.
> > (2) Emitting a branch instruction and executing a branch at runtime is
> > not part of the specified behavior of the abstract machine.  Of course,
> > the abstract machine performs conditional execution, but that just
> > specifies the output / side effects that it must produce (e.g., volatile
> > stores) -- not with which hardware instructions it is producing this.
> > (3) A compiled program must produce the same output as if executed by
> > the abstract machine.
> 
> Ok, I'm fine with that.
> 
> > Thus, we need to be careful what "speculative store" is meant to refer
> > to.  A few examples:
> >
> > if (atomic_load(&x, mo_relaxed) == 1)
> >   atomic_store(&y, 3, mo_relaxed));
> 
> No, please don't use this idiotic example. It is wrong.

It won't be useful in practice in a lot of cases, but that doesn't mean
it's wrong.  It's clearly not illegal code.  It also serves a purpose: a
simple example to reason about a few aspects of the memory model.

> The fact is, if a compiler generates anything but the obvious sequence
> (read/cmp/branch/store - where branch/store might obviously be done
> with some other machine conditional like a predicate), the compiler is
> wrong.

Why?  I've reasoned why (1) to (3) above allow in certain cases (i.e.,
the first load always returning 1) for the branch (or other machine
conditional) to not be emitted.  So please either poke holes into this
reasoning, or clarify that you don't in fact, contrary to what you wrote
above, agree with (1) to (3).

> Anybody who argues anything else is wrong, or confused, or confusing.

I appreciate your opinion, and maybe I'm just one of the three things
above (my vote is on "confusing").  But without you saying why doesn't
help me see what's the misunderstanding here.

> Instead, argue about *other* sequences where the compiler can do something.

I'd prefer if we could clarify the misunderstanding for the simple case
first that doesn't involve stronger ordering requirements in the form of
non-relaxed MOs.

> For example, this sequence:
> 
>    atomic_store(&x, a, mo_relaxed);
>    b = atomic_load(&x, mo_relaxed);
> 
> can validly be transformed to
> 
>    atomic_store(&x, a, mo_relaxed);
>    b = (typeof(x)) a;
> 
> and I think everybody agrees about that. In fact, that optimization
> can be done even for mo_strict.

Yes.

> But even that "obvious" optimization has subtle cases. What if the
> store is relaxed, but the load is strict? You can't do the
> optimization without a lot of though, because dropping the strict load
> would drop an ordering point. So even the "store followed by exact
> same load" case has subtle issues.

Yes if a compiler wants to optimize that, it has to give it more
thought.  My gut feeling is that either the store should get the
stronger ordering, or the accesses should be merged.  But I'd have to
think more about that one (which I can do on request).

> With similar caveats, it is perfectly valid to merge two consecutive
> loads, and to merge two consecutive stores.
> 
> Now that means that the sequence
> 
>     atomic_store(&x, 1, mo_relaxed);
>     if (atomic_load(&x, mo_relaxed) == 1)
>         atomic_store(&y, 3, mo_relaxed);
> 
> can first be optimized to
> 
>     atomic_store(&x, 1, mo_relaxed);
>     if (1 == 1)
>         atomic_store(&y, 3, mo_relaxed);
> 
> and then you get the end result that you wanted in the first place
> (including the ability to re-order the two stores due to the relaxed
> ordering, assuming they can be proven to not alias - and please don't
> use the idiotic type-based aliasing rules).
> 
> Bringing up your first example is pure and utter confusion.

Sorry if it was confusing.  But then maybe we need to talk about it
more, because it shouldn't be confusing if we agree on what the memory
model allows and what not.  I had originally picked the example because
it was related to the example Paul/Peter brought up.

> Don't do
> it. Instead, show what are obvious and valid transformations, and then
> you can bring up these kinds of combinations as "look, this is
> obviously also correct".

I have my doubts whether the best way to reason about the memory model
is by thinking about specific compiler transformations.  YMMV,
obviously.

The -- kind of vague -- reason is that the allowed transformations will
be more complicated to reason about than the allowed output of a
concurrent program when understanding the memory model (ie, ordering and
interleaving of memory accesses, etc.).  However, I can see that when
trying to optimize with a hardware memory model in mind, this might look
appealing.

What the compiler will do is exploiting knowledge about all possible
executions.  For example, if it knows that x is always 1, it will do the
transform.  The user would need to consider that case anyway, but he/she
can do without thinking about all potentially allowed compiler
optimizations.

> Now, the reason I want to make it clear that the code example you
> point to is a crap example is that because it doesn't talk about the
> *real* issue, it also misses a lot of really important details.
> 
> For example, when you say "if the compiler can prove that the
> conditional is always true" then YOU ARE TOTALLY WRONG.

What are you trying to say?  That a compiler can't prove that this is
the case in any program?  Or that it won't be likely it can?  Or what
else?

> So why do I say you are wrong, after I just gave you an example of how
> it happens? Because my example went back to the *real* issue, and
> there are actual real semantically meaningful details with doing
> things like load merging.
> 
> To give an example, let's rewrite things a bit more to use an extra variable:
> 
>     atomic_store(&x, 1, mo_relaxed);
>     a = atomic_load(&1, mo_relaxed);
>     if (a == 1)
>         atomic_store(&y, 3, mo_relaxed);
> 
> which looks exactly the same.

I'm confused.  Is this a new example?

Or is it supposed to be a compiler's rewrite of the following?

    atomic_store(&x, 1, mo_relaxed);
    if (atomic_load(&x, mo_relaxed) == 1)
       atomic_store(&y, 3, mo_relaxed);

If that's supposed to be the case this is the same.

If it is supposed to be a rewrite of the original example with *just*
two stores, this is obviously an incorrect transformation (unless it can
be proven that no other thread writes to x).  The compiler can't make
stuff conditional that wasn't conditional before.  That would change the
allowed behavior of the abstract machine.

> If you now say "if you can prove the
> conditional is always true, you can make the store unconditional", YOU
> ARE WRONG.
> 
> Why?
> 
> This sequence:
> 
>     atomic_store(&x, 1, mo_relaxed);
>     a = atomic_load(&x, mo_relaxed);
>     atomic_store(&y, 3, mo_relaxed);
> 
> is actually - and very seriously - buggy.
> 
> Why? Because you have effectively split the atomic_load into two loads
> - one for the value of 'a', and one for your 'proof' that the store is
> unconditional.

I can't follow that, because it isn't clear to me which code sequences
are meant to belong together, and which transformations the compiler is
supposed to make.  If you would clarify that, then I can reply to this
part.

> Maybe you go "Nobody sane would do that", and you'd be right. But
> compilers aren't "sane" (and compiler _writers_ I have some serious
> doubts about), and how you describe the problem really does affect the
> solution.

To me, that sounds like a strong argument for a strong and precise
specification, and formal methods.  If we have that, stuff can be
resolved without having to rely on "sane" people, as long as they can
follow logic.  Because this removes the problem from "hopefully all of
us want the same" (which is sometimes called "sane", from both sides of
a disagreement) to "just stick to the specification".

> My description ("you can combine two subsequent atomic accesses, if
> you are careful about still having the same ordering points") doesn't
> have the confusion.

I'd much rather take the memory model's specification.  One example is
that it separates safety/correctness guarantees from liveness/progress
guarantees.  "the same ordering points" can be understood as not being
able to merge subsequent loads to the same memory location.  Both
progress guarantees and correctness guarantees can affect this, but they
have different consequences.  For example, if it may be perfectly fine
to assume that two subsequent loads to the same memory location may
always execute atomically (and thus join them), you don't want to do
this to all such loads in a spin-wait loop (or you'll likely prevent
forward progress).

In the end, we need to define "are careful about" and similar clauses.
Eventually, after defining everything, we'll end up with a memory model
that is specified in as much detail as C11's is.

> It makes it clear that no, you can't speculate
> writes, but yes, obviously you can combine certain things (think
> "write buffers" and "memory caches"), and that may make you able to
> remove the conditional. Which is very different from speculating
> writes.

It's equally fine to reason about executions and allowed interleavings
on the level of the source program (ie, the memory model and abstract
machine).  For example, combining certain things is essentially assuming
the atomic execution of those things; it will be clear from the program,
without thinking write buffers and caches, whether that's possible or
not in the source program.  If it is, the compiler can do it too.  The
compiler must not loose anything (eg, memory orders) when doing that; if
it wants to remove memory orders, it must show that this doesn't result
in executions not possible before.  Also, it must not prevent executions
that ensure forward progress (e.g., a spin-wait loop should better not
be atomic wrt. everything else, or you'll block forever).

> But my description also makes it clear that the transformation above
> was buggy, but that rewriting it as
> 
>     a = 1;
>     atomic_store(&y, 3, mo_relaxed);
>     atomic_store(&x, a, mo_relaxed);
> 
> is fine (doing the re-ordering here just to make a point).

Oh, so you were assuming that a is actually used afterwards?

> So I suspect we actually agree, I just think that the "example" that
> has been floating around, and the explanation for it, has been
> actively bad and misleading.

I do hope we agree.  I'm still confused why you think the branch needs
to be emitted in the first example I brought up, but other than that, we
seem to be on the same page.  I'm hopeful we can clarify the other
points if we keep talking about different examples.


