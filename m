Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbaCESh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 13:37:29 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:45016 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbaCEShX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 13:37:23 -0500
MIME-Version: 1.0
Reply-To: Peter.Sewell@cl.cam.ac.uk
In-Reply-To: <1394039718.28840.15041.camel@triegel.csb>
References: <CA+55aFyi45f7oaG4MYP41TOc=E8Ze8Om88dV2Lq4F=qebhxt4A@mail.gmail.com>
	<20140224185341.GU8264@linux.vnet.ibm.com>
	<CA+55aFzXyob0aKnv1u7Stbu0rH5Aq2jaA1rHb=TvQe9c1KY0oQ@mail.gmail.com>
	<1393515453.28840.9961.camel@triegel.csb>
	<CA+55aFyE58NokYdoU+-feHTXv+5snByu+vCyMtg2fNc7npMbDg@mail.gmail.com>
	<20140227190611.GU8264@linux.vnet.ibm.com>
	<CA+55aFzav_2ayvEgbgeAzQohJ7EQH0tgUU0WcSyvUA6hgOo_Ow@mail.gmail.com>
	<20140227205312.GX8264@linux.vnet.ibm.com>
	<20140301005047.GA14777@linux.vnet.ibm.com>
	<CAHWkzRQd7EOqM4pQCB-FaF2byJ5QM8X2WLymoqURmJb4Bd+BJA@mail.gmail.com>
	<20140301140351.GO11910@linux.vnet.ibm.com>
	<CAHWkzRRrrsVK7NdFN=mW55OuVnY82vvW_heKH9ACBPVEUchQjw@mail.gmail.com>
	<1393879459.28840.11943.camel@triegel.csb>
	<CAHWkzRRHMjji3oZx5C8S57Z+Xf9NSoK4AyeXx=NMU8JSB3-=6g@mail.gmail.com>
	<1394039718.28840.15041.camel@triegel.csb>
Date: Wed, 5 Mar 2014 18:37:22 +0000
X-Google-Sender-Auth: 9sibvMYqOiJgHuzy4cH6_yxIFJc
Message-ID: <CAHWkzRT=hEODSX9CnUZpQDXfdO81fbOmXFttfTdd9FKM34kSKg@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Peter Sewell <Peter.Sewell@cl.cam.ac.uk>
To: Torvald Riegel <triegel@redhat.com>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 March 2014 17:15, Torvald Riegel <triegel@redhat.com> wrote:
> On Tue, 2014-03-04 at 22:11 +0000, Peter Sewell wrote:
>> On 3 March 2014 20:44, Torvald Riegel <triegel@redhat.com> wrote:
>> > On Sun, 2014-03-02 at 04:05 -0600, Peter Sewell wrote:
>> >> On 1 March 2014 08:03, Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
>> >> > On Sat, Mar 01, 2014 at 04:06:34AM -0600, Peter Sewell wrote:
>> >> >> Hi Paul,
>> >> >>
>> >> >> On 28 February 2014 18:50, Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
>> >> >> > On Thu, Feb 27, 2014 at 12:53:12PM -0800, Paul E. McKenney wrote:
>> >> >> >> On Thu, Feb 27, 2014 at 11:47:08AM -0800, Linus Torvalds wrote:
>> >> >> >> > On Thu, Feb 27, 2014 at 11:06 AM, Paul E. McKenney
>> >> >> >> > <paulmck@linux.vnet.ibm.com> wrote:
>> >> >> >> > >
>> >> >> >> > > 3.      The comparison was against another RCU-protected pointer,
>> >> >> >> > >         where that other pointer was properly fetched using one
>> >> >> >> > >         of the RCU primitives.  Here it doesn't matter which pointer
>> >> >> >> > >         you use.  At least as long as the rcu_assign_pointer() for
>> >> >> >> > >         that other pointer happened after the last update to the
>> >> >> >> > >         pointed-to structure.
>> >> >> >> > >
>> >> >> >> > > I am a bit nervous about #3.  Any thoughts on it?
>> >> >> >> >
>> >> >> >> > I think that it might be worth pointing out as an example, and saying
>> >> >> >> > that code like
>> >> >> >> >
>> >> >> >> >    p = atomic_read(consume);
>> >> >> >> >    X;
>> >> >> >> >    q = atomic_read(consume);
>> >> >> >> >    Y;
>> >> >> >> >    if (p == q)
>> >> >> >> >         data = p->val;
>> >> >> >> >
>> >> >> >> > then the access of "p->val" is constrained to be data-dependent on
>> >> >> >> > *either* p or q, but you can't really tell which, since the compiler
>> >> >> >> > can decide that the values are interchangeable.
>> >> >> >> >
>> >> >> >> > I cannot for the life of me come up with a situation where this would
>> >> >> >> > matter, though. If "X" contains a fence, then that fence will be a
>> >> >> >> > stronger ordering than anything the consume through "p" would
>> >> >> >> > guarantee anyway. And if "X" does *not* contain a fence, then the
>> >> >> >> > atomic reads of p and q are unordered *anyway*, so then whether the
>> >> >> >> > ordering to the access through "p" is through p or q is kind of
>> >> >> >> > irrelevant. No?
>> >> >> >>
>> >> >> >> I can make a contrived litmus test for it, but you are right, the only
>> >> >> >> time you can see it happen is when X has no barriers, in which case
>> >> >> >> you don't have any ordering anyway -- both the compiler and the CPU can
>> >> >> >> reorder the loads into p and q, and the read from p->val can, as you say,
>> >> >> >> come from either pointer.
>> >> >> >>
>> >> >> >> For whatever it is worth, hear is the litmus test:
>> >> >> >>
>> >> >> >> T1:   p = kmalloc(...);
>> >> >> >>       if (p == NULL)
>> >> >> >>               deal_with_it();
>> >> >> >>       p->a = 42;  /* Each field in its own cache line. */
>> >> >> >>       p->b = 43;
>> >> >> >>       p->c = 44;
>> >> >> >>       atomic_store_explicit(&gp1, p, memory_order_release);
>> >> >> >>       p->b = 143;
>> >> >> >>       p->c = 144;
>> >> >> >>       atomic_store_explicit(&gp2, p, memory_order_release);
>> >> >> >>
>> >> >> >> T2:   p = atomic_load_explicit(&gp2, memory_order_consume);
>> >> >> >>       r1 = p->b;  /* Guaranteed to get 143. */
>> >> >> >>       q = atomic_load_explicit(&gp1, memory_order_consume);
>> >> >> >>       if (p == q) {
>> >> >> >>               /* The compiler decides that q->c is same as p->c. */
>> >> >> >>               r2 = p->c; /* Could get 44 on weakly order system. */
>> >> >> >>       }
>> >> >> >>
>> >> >> >> The loads from gp1 and gp2 are, as you say, unordered, so you get what
>> >> >> >> you get.
>> >> >> >>
>> >> >> >> And publishing a structure via one RCU-protected pointer, updating it,
>> >> >> >> then publishing it via another pointer seems to me to be asking for
>> >> >> >> trouble anyway.  If you really want to do something like that and still
>> >> >> >> see consistency across all the fields in the structure, please put a lock
>> >> >> >> in the structure and use it to guard updates and accesses to those fields.
>> >> >> >
>> >> >> > And here is a patch documenting the restrictions for the current Linux
>> >> >> > kernel.  The rules change a bit due to rcu_dereference() acting a bit
>> >> >> > differently than atomic_load_explicit(&p, memory_order_consume).
>> >> >> >
>> >> >> > Thoughts?
>> >> >>
>> >> >> That might serve as informal documentation for linux kernel
>> >> >> programmers about the bounds on the optimisations that you expect
>> >> >> compilers to do for common-case RCU code - and I guess that's what you
>> >> >> intend it to be for.   But I don't see how one can make it precise
>> >> >> enough to serve as a language definition, so that compiler people
>> >> >> could confidently say "yes, we respect that", which I guess is what
>> >> >> you really need.  As a useful criterion, we should aim for something
>> >> >> precise enough that in a verified-compiler context you can
>> >> >> mathematically prove that the compiler will satisfy it  (even though
>> >> >> that won't happen anytime soon for GCC), and that analysis tool
>> >> >> authors can actually know what they're working with.   All this stuff
>> >> >> about "you should avoid cancellation", and "avoid masking with just a
>> >> >> small number of bits" is just too vague.
>> >> >
>> >> > Understood, and yes, this is intended to document current compiler
>> >> > behavior for the Linux kernel community.  It would not make sense to show
>> >> > it to the C11 or C++11 communities, except perhaps as an informational
>> >> > piece on current practice.
>> >> >
>> >> >> The basic problem is that the compiler may be doing sophisticated
>> >> >> reasoning with a bunch of non-local knowledge that it's deduced from
>> >> >> the code, neither of which are well-understood, and here we have to
>> >> >> identify some envelope, expressive enough for RCU idioms, in which
>> >> >> that reasoning doesn't allow data/address dependencies to be removed
>> >> >> (and hence the hardware guarantee about them will be maintained at the
>> >> >> source level).
>> >> >>
>> >> >> The C11 syntactic notion of dependency, whatever its faults, was at
>> >> >> least precise, could be reasoned about locally (just looking at the
>> >> >> syntactic code in question), and did do that.  The fact that current
>> >> >> compilers do optimisations that remove dependencies and will likely
>> >> >> have many bugs at present is besides the point - this was surely
>> >> >> intended as a *new* constraint on what they are allowed to do.  The
>> >> >> interesting question is really whether the compiler writers think that
>> >> >> they *could* implement it in a reasonable way - I'd like to hear
>> >> >> Torvald and his colleagues' opinion on that.
>> >> >>
>> >> >> What you're doing above seems to be basically a very cut-down version
>> >> >> of that, but with a fuzzy boundary.   If you want it to be precise,
>> >> >> maybe it needs to be much simpler (which might force you into ruling
>> >> >> out some current code idioms).
>> >> >
>> >> > I hope that Torvald Riegel's proposal (https://lkml.org/lkml/2014/2/27/806)
>> >> > can be developed to serve this purpose.
>> >>
>> >> (I missed that mail when it first came past, sorry)
>> >>
>> >> That's also going to be tricky, I'm afraid.  The key condition there is:
>> >>
>> >> "* at the time of execution of E, L       [PS: I assume that L is a
>> >> typo and should be E]
>> >
>> > No, L was intended. (But see below.)
>>
>> then I misunderstood...
>>
>> >>         can possibly have returned at
>> >>         least two different values under the assumption that L itself
>> >>         could have returned any value allowed by L's type."
>> >>
>> >> First, the evaluation of E might be nondeterministic  - e.g., for an
>> >> artificial example, if it's just a nondeterministic value obtained
>> >> from the result of a race on SC atomics.  The above doesn't
>> >> distinguish between that (which doesn't have a real dependency on L)
>> >> and that XOR'd with L (which does).  And it does so in the wrong
>> >> direction: it'll say there the former has a dependency on L.
>> >
>> > I'm not quite sure I understand the examples you want to point out
>> > (could you add brief code snippets, perhaps?) -- but the informal
>> > definition I proposed also says that E must have used L in some way to
>> > make it's computation.  That's pretty vague, and the way I phrased the
>> > requirement is probably not optimal.
>>
>> ...so this example isn't so relevant, but it's maybe interesting
>> anyway. In free-wheeling psuedocode:
>>
>> x = read_consume(L)     // a memory_order_consume read of a 1-bit value from L
>> y = nondet()                     // some code that
>> nondeterministically produces another 1-bit value, eg by spawning two
>> threads that each do an SC-atomic write to some other location,
>> returning 0 or 1 depending on which wins
>>
>> then evaluate either just
>>
>> z=y
>>
>> or
>>
>> z = x XOR y
>>
>> In my misinterpretation of what you wrote, your definition would say
>> there's a dependency from the load of L to the evalution of y, even
>> though there isn't.
>
> The evaluations "z==y" or "z=y" wouldn't depend on L, assuming nondet()
> doesn't depend on L (e.g., by using x).  They don't use x's value.  (And
> I don't have a precise definition for this, unfortunately, but I hope
> the intent is clear.)
>
> "x XOR y" would depend on L, because this does take x into account, and
> x's value remains relevant irrespective of which value y has.  y would
> be non-vdp, and the compiler could have specialized the code into two
> branches for both 1 and 0 values of y; but it would still need x to
> compute z in the last evaluation.
>
>>
>> > So let me expand a bit on the background first.  What I tried to capture
>> > with the rules is that an evaluation (ie, E), really uses the value
>> > returned by L, and not just a, for example, constant value that can be
>> > inferred from whatever was executed between L and E.  This (is intended
>> > to) prevent value prediction and such by programmers.  The compiler in
>> > turn knows what a real program is allowed to do that still wants to rely
>> > on the ordering by the consume.  Basing all of this on the values seemed
>> > to be helpful because basing it on *purely* syntax didn't seem
>> > implementable; for the latter, we'd need to disallow cases such as x-x
>> > or require compilers to include artificial dependencies if a program
>> > indeed does value speculation.  IOW, it didn't seem possible to draw a
>> > clear distinction between a data dependency defined purely based on
>> > syntax and control dependencies.
>> >
>> > Another way to perhaps phrase the requirement might be to construct it
>> > inductively, so that "E uses the value returned by L" becomes clearer.
>> > However, I currently don't really know how to do that without any holes.
>> >
>> > For example, let's say that an atomic mo_consume load has a value
>> > dependency to itself; the dependency has an associated set of values,
>> > which is equal to all values allowed by the type (but see also below).
>> > Then, an evaluation A that uses B as operand has a value dependency on B
>> > if the associated set of values can still have more than one element.
>> > Whether that's the case depends on the operation, and the other
>> > operands, including their values at the time of execution.
>> > However, it's not just results of evaluations that effectively constrain
>> > the set of values.  Conditional execution does as well, because the
>> > condition being true might establish a constraint on L, which might
>> > remove any dependency when L (or a result of a computation involving L)
>> > is used.  So I'm not sure the inductive approach would work.
>> >
>> > You said you thought I might have wanted to say that:
>> > "E  really-depends on L if there exist two different values that (just
>> > according to typing) might be read for L that give rise to two
>> > different values for E".
>> >
>> > Which should follow from the above, or at least should not conflict with
>> > it.  My "definition" tried to capture that the program must not
>> > establish so many constraints between E and L that the value of L is
>> > clear in the sense of having exactly one value.  If we dereference such
>> > an E whose execution in fact constrains L to one value, there is no real
>> > dependency anymore.
>> > However, by itself, this doesn't cover that E must use L in it's
>> > computation -- which your formulation does, I think.
>>
>> unfortunately not - that's what the example above shows.
>
> Now I think I understand.
>
>> > Another way might be to try to define which constraints established by
>> > an execution (based on the executed code's semantics) actually remove
>> > value dependencies on L.
>> >
>> > Do you have any suggestions for how to define this (ie, true value
>> > dependencies) in a better way?
>>
>> not at the moment.  I need to think some more about your vdps, though.
>>  As I understand it, you're agreeing with the general intent of the
>> original C11 design that some new mechanism to tell the compiler not
>> to optimise in certain places in required, but differing in the way
>> you identify those?
>
> Yes, we still need such a mechanism because we need to prevent the
> compiler from doing value prediction or something similar that uses
> control dependencies to avoid data dependencies.  For example, it could
> use a large switch statement to add code specialized for each possible
> value returned from an mo_consume load.  Thus, at least for the
> standard, we need some mechanism that prevents certain compiler
> optimizations.
>
> Where it differs to C11 is that we're not trying to use just such a
> mechanism built on syntax to try to define when we actually have a real
> value dependency.
>
>>
>> >> Second, it involves reasoning about counterfactual executions.  That
>> >> doesn't necessarily make it wrong, per se, but probably makes it hard
>> >> to work with.  For example, suppose that in all the actual
>> >> whole-program executions, a runtime occurrence of L only ever returns
>> >> one particular value (perhaps because of some simple #define'd
>> >> configuration)
>> >
>> > Right, or just because it's a deterministic program.
>> >
>> > This is a problem for the definition of value dependencies, AFAICT,
>> > because where do you put the line for what the compiler is allowed to
>> > speculate about?  When does the program indeed "reveal" the value of a
>> > load, and when does it not?  Is a compiler to do out-of-band tracking
>> > for certain memory locations, and thus predict the value?
>> >
>> > Adding the assumption that L, at least conceptually, might return any
>> > value seemed to be a simple way to remove that uncertainty regarding
>> > what the compiler might know about.
>>
>> ...but it brings in a lot of baggage.
>
> Which baggage do you mean?  In terms of verification, or definitions in
> the standard, or effects on compilers?

At least the first two.  I'm not in a position to comment on the last,
but I'd hate to try to do compiler verification based on a semantics
that involves substantial quantification over counterfactual
hypothetical executions.

>> >> , and that the code used in the evaluation of E depends
>> >> on some invariant which is related to that configuration.
>> >
>> > A related issue that I've been thinking about is whether things like
>> > divide-by-zero (ie, operations that give rise to undefined behavior)
>> > should be considered as constraints on the values or not.  I guess they
>> > should, but then this seems closer what you mention, invariants
>> > established by the whole program.
>> >
>> >> The
>> >> hypothetical execution used above in which a different value is used
>> >> is one in the code is being run in a situation with broken invariants.
>> >>    Then there will be technical difficulties in using the definition:
>> >> I don't see how one would persuade oneself that a compiler always
>> >> satisfies it, because these hypothetical executions are far removed
>> >> from what it's actually working on.
>> >
>> > I think the above is easy to implement for a compiler.  At the
>> > mo_consume load, you simply forget any information you have about this
>> > value / memory location; for operations on value_dep_preserving types,
>>
>> are all the subexpressions likewise forced to be of vdp types?
>
> I'd like to avoid that if possible.  Things like "vdp-pointer + int"
> should Just Work in the sense of being still vdp-typed without requiring
> an explicit cast for the int operand.  Operators ||, &&, ?: might
> justify more fine-grained rules, but I guess it's better to just make
> more stuff vdp if that's easier.  vdp is not a sufficient condition for
> there being a value-dependency anyway, and the few optimizations it
> prevents on expressions containing some vdp-typed operands probably
> don't matter much.  Also, as I mentioned in the reply to Paul, I believe
> that if the compiler can prove that there's no value-dependency, it can
> ignore the vdp-annotation (IOW, as-if is still possible).
>
