Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544AbaBRPcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 10:32:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755870AbaBRPcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 10:32:17 -0500
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Torvald Riegel <triegel@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
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
In-Reply-To: <CA+55aFyi8QWge7QR0M+ABH-kEiwvoEyMhK6GWRvN1YNKJAFuSQ@mail.gmail.com>
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
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Feb 2014 16:31:05 +0100
Message-ID: <1392737465.18779.7644.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-17 at 16:05 -0800, Linus Torvalds wrote:
> And exactly because I know enough, I would *really* like atomics to be
> well-defined, and have very clear - and *local* - rules about how they
> can be combined and optimized.

"Local"?

> None of this "if you can prove that the read has value X" stuff. And
> things like value speculation should simply not be allowed, because
> that actually breaks the dependency chain that the CPU architects give
> guarantees for. Instead, make the rules be very clear, and very
> simple, like my suggestion. You can never remove a load because you
> can "prove" it has some value, but you can combine two consecutive
> atomic accesses/

Sorry, but the rules *are* very clear.  I *really* suggest to look at
the formalization by Batty et al.  And in these rules, proving that a
read will always return value X has a well-defined meaning, and you can
use it.  That simply follows from how the model is built.

What you seem to want just isn't covered by the model as it is today --
you can't infer from that that the model itself would be wrong.  The
dependency chains aren't modeled in the way you envision it (except in
what consume_mo tries, but that seems to be hard to implement); they are
there on the level of the program logic as modeled by the abstract
machine and the respective execution/output rules, but they are not
built to represent those specific ordering guarantees the HW gives you.

I would also be cautious claiming that the rules you suggested would be
very clear and very simple.  I haven't seen a memory model spec from you
that would be viable as the standard model for C/C++, nor have I seen
proof that this would actually be easier to understand for programmers
in general.

> For example, CPU people actually do tend to give guarantees for
> certain things, like stores that are causally related being visible in
> a particular order.

Yes, but that's not part of the model so far.  If you want to exploit
this, please make a suggestion for how to extend the model to cover
this.

You certainly expect compilers to actually optimize code, which usually
removes or reorders stuff.  Now, we could say that we just don't want
that for atomic accesses, but even this isn't as clear-cut: How do we
actually detect where non-atomic code is intended by the programmer to
express (1) a dependency that needs to be transformed into a dependency
in the generated code from (2) a dependency that is just program logic?

IOW, consider the consume_mo example "*(p + flag - flag)", where flag is
coming from a consume_mo load: Can you give a complete set of rules (for
a full program) for when the compiler is allowed to optimize out
flag-flag and when not?  (And it should be practically implementable in
a compiler, and not prevent optimizations where people expect them.)

> If the compiler starts doing value speculation on
> atomic accesses, you are quite possibly breaking things like that.
> It's just not a good idea. Don't do it. Write the standard so that it
> clearly is disallowed.

You never want value speculation for anything possibly originating from
an atomic load?  Or what are the concrete rules you have in mind?

> Because you may think that a C standard is machine-independent, but
> that isn't really the case. The people who write code still write code
> for a particular machine. Our code works (in the general case) on
> different byte orderings, different register sizes, different memory
> ordering models. But in each *instance* we still end up actually
> coding for each machine.

That's how *you* do it.  I'm sure you are aware that for lots of
programmers, having a machine-dependent standard is not helpful at all.
As the standard is written, code is portable.  It can certainly be
beneficial for programmers to optimize for different machines, but the
core of the memory model will always remain portable, because that's
what arguably most programmers need.  That doesn't prevent
machine-dependent extensions, but those then should be well integrated
with the rest of the model.

> So the rules for atomics should be simple and *specific* enough that
> when you write code for a particular architecture, you can take the
> architecture memory ordering *and* the C atomics orderings into
> account, and do the right thing for that architecture.

That would be an extension, but not viable as a *general* requirement as
far as the standard is concerned.

> And that very much means that doing things like value speculation MUST
> NOT HAPPEN. See? Even if you can prove that your code is "equivalent",
> it isn't.

I'm kind of puzzled why you keep stating generalizations of assertions
that clearly aren't well-founded (ie, which might be true for the kernel
or your wishes for how the world should be, but aren't true in general
or for the objectives of others).

It's not helpful to just pretend other people's opinions or worlds
didn't exist in discussions such as this one.  It's clear that the
standard has to consider all users of C/C++.  The kernel is a big user
of it, but also just that.

Why don't you just say that you do not *want* value speculation to
happen, because it does X and you'd like to exploit HW guarantee Y etc.?
That would be constructive, and actually correct in contrast to those
other broad claims.

(FWIW: Personally, I don't care whether you say something in a nice tone
or in some other way WITH BIG LETTERS.  I scan both for logically
consistent reasoning, and filter out the rest.  Therefore, avoiding
excessive amounts of the rest would make the discussion more efficient
for me, and I'd appreciate if everyone could work towards making it
efficient.  It's a tricky topic we're discussing, so I'd like to use my
brain for the actual technical bits and not for all the noise.)

> So for example, let's say that you have a pointer, and you have some
> reason to believe that the pointer has a particular value. So you
> rewrite following the pointer from this:
> 
>   value = ptr->val;
> 
> into
> 
>   value = speculated->value;
>   tmp = ptr;
>   if (unlikely(tmp != speculated))
>     value = tmp->value;
> 
> and maybe you can now make the critical code-path for the speculated
> case go faster (since now there is no data dependency for the
> speculated case, and the actual pointer chasing load is now no longer
> in the critical path), and you made things faster because your
> profiling showed that the speculated case was true 99% of the time.
> Wonderful, right? And clearly, the code "provably" does the same
> thing.

Please try to see that any proof is based on the language semantics as
specified.  Thus, you have to distinguish between (1) disagreeing with
the proof being correct and (2) disliking the language semantics.

I believe you mean the latter (let me know if you actually mean (1)); in
that case, it's the language semantics you want to be different, and we
need to discuss this.

> EXCEPT THAT IS NOT TRUE AT ALL.
> 
> It very much does not do the same thing at all, and by doing value
> speculation and "proving" something was true, the only thing you did
> was to make incorrect code run faster. Because now the causally
> related load of value from the pointer isn't actually causally related
> at all, and you broke the memory ordering.

That's not how the language is specified, sorry.

> This is why I don't like it when I see Torvald talk about "proving"
> things. It's bullshit. You can "prove" pretty much anything, and in
> the process lose sight of the bigger issue, namely that there is code
> that depends on

Depends on what?

We really need to keep separate things separate here.  We started the
discussion with the topic of what behavior the memory model *as
specified today* allows.  In that model, the proofs are correct.

This model does not let programmers exploit the control dependencies and
such that you have in mind.  It does let programmers write correct code,
but this code might be somewhat less efficient (e.g., because it would
use memory_order_acquire instead of a weaker MO and control
dependencies).  If you want to discuss that, fine; we'd then need to see
how we can specify this properly and offer to programmers, and how to
extend the specification of the language semantics accordingly.

That Paul is looking through the uses of synchronization and how they
could (or could not) map to the memory model will be good input to this
discussion.

> When it comes to atomic accesses, you don't play those kinds of games,
> exactly because the ordering of the accesses matter in ways that are
> not really sanely describable at a source code level.

They obviously need to be specifiable for a language that wants to
provide portable atomics.  For machine-dependent extensions, this could
take machine properties into accout, of course.  But even those need to
be modeled properly, at the source code level.  How else is a C/C++
compiler make sense out of it?

> The *only* kinds
> of games you play are like the ones I described - combining accesses
> under very strict local rules.
> 
> And the strict local rules really should be of the type "a store
> followed by a load to the same location with the same memory ordering
> constraints can be combined". Never *ever* of the kind "if you can
> prove X".

I doubt that's a better way to put it.  For example, you haven't defined
"followed" -- if you'd do that in a complete way, you'd inevitably come
to situations where something is checked for being provably correct.
What you do, in fact, is relying on the proof that the adjacent
store/load pair could always be executed atomically by the machine,
without preventing forward progress.

> I hope my example made it clear *why* I react so strongly when Torvald
> starts talking about "if you can prove the value is 1".

It's getting clearer to me, but as far as I can understand, from my
perspective, you're objecting to a straw man while not requesting the
thing you actually want.

It seems you're coming from a bottom-up perspective, seeing C code as
something defined like high-level assembler, which still has
machine-dependent parts and such.  The standard defines the language
semantics kind of the other way around, top-down from an abstract
machine, with memory_orders that at least to some extent allow one to
exploit different HW mechanisms with different costs for enforcing
ordering.

I can see why you have this perspective, but the standard needs the
top-down approach to suite all it's users.  I believe we should continue
discussing how we can bridge the gap between both views.  None of those
views is inherently wrong, they are just different.  No strong opinion
will change that, but I'm still hopeful that constructive discussion can
help bridge the gap.

