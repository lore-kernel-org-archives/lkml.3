Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbaBRQtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 11:49:18 -0500
Received: from mail-ve0-f170.google.com ([209.85.128.170]:48761 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbaBRQtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 11:49:16 -0500
MIME-Version: 1.0
In-Reply-To: <1392737465.18779.7644.camel@triegel.csb>
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
	<CA+55aFypfiTFwundih8QEA6ZwVGk=g5L4sabsN0932eih5knOQ@mail.gmail.com>
	<1392486310.18779.6447.camel@triegel.csb>
	<CA+55aFwTrt_6m1inNHQkk74i7uPkHNnacwHiBgioZSXieAs5Sw@mail.gmail.com>
	<1392666947.18779.6838.camel@triegel.csb>
	<CA+55aFwUnRVk6q3VZeYjWfduoHcExW=Pht6jgp=4bBSaLHNPMA@mail.gmail.com>
	<530296CD.5050503@warwick.ac.uk>
	<CA+55aFyi8QWge7QR0M+ABH-kEiwvoEyMhK6GWRvN1YNKJAFuSQ@mail.gmail.com>
	<1392737465.18779.7644.camel@triegel.csb>
Date: Tue, 18 Feb 2014 08:49:13 -0800
X-Google-Sender-Auth: of4Wjk283HTL78Q6HMXRZuFmWW4
Message-ID: <CA+55aFxn2KRXDQ91xRs=bO_6d_nA_PSQvoY1_=OxyJ86+KOO9Q@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Torvald Riegel <triegel@redhat.com>
Cc: Alec Teal <a.teal@warwick.ac.uk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 7:31 AM, Torvald Riegel <triegel@redhat.com> wrote:
> On Mon, 2014-02-17 at 16:05 -0800, Linus Torvalds wrote:
>> And exactly because I know enough, I would *really* like atomics to be
>> well-defined, and have very clear - and *local* - rules about how they
>> can be combined and optimized.
>
> "Local"?

Yes.

So I think that one of the big advantages of atomics over volatile is
that they *can* be optimized, and as such I'm not at all against
trying to generate much better code than for volatile accesses.

But at the same time, that can go too far. For example, one of the
things we'd want to use atomics for is page table accesses, where it
is very important that we don't generate multiple accesses to the
values, because parts of the values can be change *by*hardware* (ie
accessed and dirty bits).

So imagine that you have some clever global optimizer that sees that
the program never ever actually sets the dirty bit at all in any
thread, and then uses that kind of non-local knowledge to make
optimization decisions. THAT WOULD BE BAD.

Do you see what I'm aiming for? Any optimization that tries to prove
anything from more than local state is by definition broken, because
it assumes that everything is described by the program.

But *local* optimizations are fine, as long as they follow the obvious
rule of not actually making changes that are semantically visible.

(In practice, I'd be impressed as hell for that particular example,
and we actually do end up setting the dirty bit by hand in some
situations, so the example is slightly made up, but there are other
cases that might be more realistic in that sometimes we do things that
are hidden from the compiler - in assembly etc - and the compiler
might *think* it knows what is going on, but it doesn't actually see
all accesses).

> Sorry, but the rules *are* very clear.  I *really* suggest to look at
> the formalization by Batty et al.  And in these rules, proving that a
> read will always return value X has a well-defined meaning, and you can
> use it.  That simply follows from how the model is built.

What "model"?

That's the thing. I have tried to figure out whether the model is some
abstract C model, or a model based on the actual hardware that the
compiler is compiling for, and whether the model is one that assumes
the compiler has complete knowledge of the system (see the example
above).

And it seems to be a mixture of it all. The definitions of the various
orderings obviously very much imply that the compiler has to insert
the proper barriers or sequence markers for that architecture, but
then there is no apparent way to depend on any *other* architecture
ordering guarantees. Like our knowledge that all architectures (with
the exception of alpha, which really doesn't end up being something we
worry about any more) end up having the load dependency ordering
guarantee.

> What you seem to want just isn't covered by the model as it is today --
> you can't infer from that that the model itself would be wrong.  The
> dependency chains aren't modeled in the way you envision it (except in
> what consume_mo tries, but that seems to be hard to implement); they are
> there on the level of the program logic as modeled by the abstract
> machine and the respective execution/output rules, but they are not
> built to represent those specific ordering guarantees the HW gives you.

So this is a problem. It basically means that we cannot do the kinds
of things we do now, which very much involve knowing what the memory
ordering of a particular machine is, and combining that knowledge with
our knowledge of code generation.

Now, *most* of what we do is protected by locking and is all fine. But
we do have a few rather subtle places in RCU and in the scheduler
where we depend on the actual dependency chain.

In *practice*, I seriously doubt any reasonable compiler can actually
make a mess of it. The kinds of optimizations that would actually
defeat the dependency chain are simply not realistic. And I suspect
that will end up being what we rely on - there being no actual sane
sequence that a compiler would ever do, even if we wouldn't have
guarantees for some of it.

And I suspect  I can live with that. We _have_ lived with that for the
longest time, after all. We very much do things that aren't covered by
any existing C standard, and just basically use tricks to coax the
compiler into never generating code that doesn't work (with our inline
asm barriers etc being a prime example).

> I would also be cautious claiming that the rules you suggested would be
> very clear and very simple.  I haven't seen a memory model spec from you
> that would be viable as the standard model for C/C++, nor have I seen
> proof that this would actually be easier to understand for programmers
> in general.

So personally, if I were to write the spec, I would have taken a
completely different approach from what the standard obviously does.

I'd have taken the approach of specifying the required semantics each
atomic op (ie the memory operations would end up having to be
annotated with their ordering constraints), and then said that the
compiler can generate any code that is equivalent to that
_on_the_target_machine_.

Why? Just to avoid the whole "ok, which set of rules applies now" problem.

>> For example, CPU people actually do tend to give guarantees for
>> certain things, like stores that are causally related being visible in
>> a particular order.
>
> Yes, but that's not part of the model so far.  If you want to exploit
> this, please make a suggestion for how to extend the model to cover
> this.

See above. This is exactly why I detest the C "model" thing. Now you
need ways to describe those CPU guarantees, because if you can't
describe them, you can't express them in the model.

I would *much* have preferred the C standard to say that you have to
generate code that is guaranteed to act the same way - on that machine
- as the "naive direct unoptimized translation".

IOW, I would *revel* in the fact that different machines are
different, and basically just describe the "stupid" code generation.
You'd get the guaranteed semantic baseline, but you'd *also* be able
to know that whatever architecture guarantees you have would remain.
Without having to describe those architecture issues.

It would be *so* nice if the C standard had done that for pretty much
everything that is "implementation dependent". Not just atomics.

[ will look at the rest of your email later ]

                 Linus
