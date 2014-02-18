Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591AbaBRAFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 19:05:46 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:55981 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbaBRAFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 19:05:44 -0500
MIME-Version: 1.0
In-Reply-To: <530296CD.5050503@warwick.ac.uk>
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
Date: Mon, 17 Feb 2014 16:05:43 -0800
X-Google-Sender-Auth: WPvy3sN6IgibVhaL3G0N0FR9yiw
Message-ID: <CA+55aFyi8QWge7QR0M+ABH-kEiwvoEyMhK6GWRvN1YNKJAFuSQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alec Teal <a.teal@warwick.ac.uk>
Cc: Torvald Riegel <triegel@redhat.com>,
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

On Mon, Feb 17, 2014 at 3:10 PM, Alec Teal <a.teal@warwick.ac.uk> wrote:
>
> You mean "unambiguous" - try reading a patent (Apple have 1000s of trivial
> ones, I tried reading one once thinking "how could they have phrased it so
> this got approved", their technique was to make the reader want to start
> cutting themselves to prove they wern't numb to everything)

Oh, I agree, patent language is worse.

> I'm not going to teach you what rvalues and lvalues, but!

I know what lvalues and rvalues are. I *understand* the thinking that
goes on behind the "let's not do the access, because it's not an
rvalue, so there is no 'access' to the object".

I understand it from a technical perspective.

I don't understand the compiler writer that uses a *technicality* to
argue against generating sane code that is obviously what the user
actually asked for.

See the difference?

> So start again, what is the serious problem, have you got any code that
> would let me replicate it, what is your version of GCC?

The volatile problem is long fixed. The people who argued for the
"legalistically correct", but insane behavior lost (and as mentioned,
I think C++11 actually fixed the legalistic reading too).

I'm bringing it up because I've had too many cases where compiler
writers pointed to standard and said "that is ambiguous or undefined,
so we can do whatever the hell we want, regardless of whether that's
sensible, or regardless of whether there is a sensible way to get the
behavior you want or not".


> Oh and lastly! Optimisations are not as casual as "oh, we could do this and
> it'd work better" unlike kernel work or any other software that is being
> improved, it is very formal (and rightfully so)

Alec, I know compilers. I don't do code generation (quite frankly,
register allocation and instruction choice is when I give up), but I
did actually write my own for static analysis, including turning
things into SSA etc.

No, I'm not a "compiler person", but I actually do know enough that I
understand what goes on.

And exactly because I know enough, I would *really* like atomics to be
well-defined, and have very clear - and *local* - rules about how they
can be combined and optimized.

None of this "if you can prove that the read has value X" stuff. And
things like value speculation should simply not be allowed, because
that actually breaks the dependency chain that the CPU architects give
guarantees for. Instead, make the rules be very clear, and very
simple, like my suggestion. You can never remove a load because you
can "prove" it has some value, but you can combine two consecutive
atomic accesses/

For example, CPU people actually do tend to give guarantees for
certain things, like stores that are causally related being visible in
a particular order. If the compiler starts doing value speculation on
atomic accesses, you are quite possibly breaking things like that.
It's just not a good idea. Don't do it. Write the standard so that it
clearly is disallowed.

Because you may think that a C standard is machine-independent, but
that isn't really the case. The people who write code still write code
for a particular machine. Our code works (in the general case) on
different byte orderings, different register sizes, different memory
ordering models. But in each *instance* we still end up actually
coding for each machine.

So the rules for atomics should be simple and *specific* enough that
when you write code for a particular architecture, you can take the
architecture memory ordering *and* the C atomics orderings into
account, and do the right thing for that architecture.

And that very much means that doing things like value speculation MUST
NOT HAPPEN. See? Even if you can prove that your code is "equivalent",
it isn't.

So for example, let's say that you have a pointer, and you have some
reason to believe that the pointer has a particular value. So you
rewrite following the pointer from this:

  value = ptr->val;

into

  value = speculated->value;
  tmp = ptr;
  if (unlikely(tmp != speculated))
    value = tmp->value;

and maybe you can now make the critical code-path for the speculated
case go faster (since now there is no data dependency for the
speculated case, and the actual pointer chasing load is now no longer
in the critical path), and you made things faster because your
profiling showed that the speculated case was true 99% of the time.
Wonderful, right? And clearly, the code "provably" does the same
thing.

EXCEPT THAT IS NOT TRUE AT ALL.

It very much does not do the same thing at all, and by doing value
speculation and "proving" something was true, the only thing you did
was to make incorrect code run faster. Because now the causally
related load of value from the pointer isn't actually causally related
at all, and you broke the memory ordering.

This is why I don't like it when I see Torvald talk about "proving"
things. It's bullshit. You can "prove" pretty much anything, and in
the process lose sight of the bigger issue, namely that there is code
that depends on

When it comes to atomic accesses, you don't play those kinds of games,
exactly because the ordering of the accesses matter in ways that are
not really sanely describable at a source code level. The *only* kinds
of games you play are like the ones I described - combining accesses
under very strict local rules.

And the strict local rules really should be of the type "a store
followed by a load to the same location with the same memory ordering
constraints can be combined". Never *ever* of the kind "if you can
prove X".

I hope my example made it clear *why* I react so strongly when Torvald
starts talking about "if you can prove the value is 1".

                     Linus
