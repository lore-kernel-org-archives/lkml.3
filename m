Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588AbaBOSHq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 13:07:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432AbaBOSHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 13:07:43 -0500
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
In-Reply-To: <CA+55aFyQTE-CzOoNn=KfDgt9bTLrUxBCXzhQ2T9kNoTy+bRQrQ@mail.gmail.com>
References: <1392183564.18779.2187.camel@triegel.csb>
	 <20140212180739.GB4250@linux.vnet.ibm.com>
	 <CA+55aFw3S82GYdtnV2nJCvBGcuZf6kXdF5b7Vp9yb21QKr49Jw@mail.gmail.com>
	 <20140213002355.GI4250@linux.vnet.ibm.com>
	 <1392321837.18779.3249.camel@triegel.csb>
	 <20140214020144.GO4250@linux.vnet.ibm.com>
	 <1392352981.18779.3800.camel@triegel.csb>
	 <20140214172920.GQ4250@linux.vnet.ibm.com>
	 <CA+55aFx9CbgrfK4rBVYD75y2KoWiO90dSYsAW83O-tYVLK-gkg@mail.gmail.com>
	 <CA+55aFypfiTFwundih8QEA6ZwVGk=g5L4sabsN0932eih5knOQ@mail.gmail.com>
	 <20140215020815.GS4250@linux.vnet.ibm.com>
	 <CA+55aFyQTE-CzOoNn=KfDgt9bTLrUxBCXzhQ2T9kNoTy+bRQrQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 15 Feb 2014 10:07:07 -0800
Message-ID: <1392487627.18779.6535.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-14 at 18:44 -0800, Linus Torvalds wrote:
> On Fri, Feb 14, 2014 at 6:08 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >
> > One way of looking at the discussion between Torvald and myself would be
> > as a seller (Torvald) and a buyer (me) haggling over the fine print in
> > a proposed contract (the standard).  Whether that makes you feel better
> > or worse about the situation I cannot say.  ;-)
> 
> Oh, I'm perfectly fine with that. But we're not desperate to buy, and
> I actually think the C11 people are - or at least should be - *way*
> more desperate to sell their model to us than we are to take it.
> 
> Which means that as a buyer you should say "this is what we want, if
> you don't give us this, we'll just walk away". Not try to see how much
> we can pay for it. Because there is very little upside for us, and
> _unless_ the C11 standard gets things right it's just extra complexity
> for us, coupled with new compiler fragility and years of code
> generation bugs.

I think there is an upside to you, mainly in that it allows compiler
testing tools, potentially verification tools for atomics, and tools
like cppmem that show allowed executions of code.

I agree that the Linux community has been working well without this, and
it's big enough to make running it's own show viable.  This will be
different for smaller projects, though.

> Why would we want that extra complexity and inevitable compiler bugs?
> If we then have to fight compiler writers that point to the standard
> and say "..but look, the standard says we can do this", then at that
> point it went from "extra complexity and compiler bugs" to a whole
> 'nother level of frustration and pain.

I see your point, but flip side of the coin is that if you get the
standard to say what you want, then you can tell the compiler writers to
look at the standard.  Or show them bugs revealed by fuzz testing and
such.

> So just walk away unless the C11 standard gives us exactly what we
> want. Not "something kind of like what we'd use". EXACTLY. Because I'm
> not in the least interested in fighting compiler people that have a
> crappy standard they can point to. Been there, done that, got the
> T-shirt and learnt my lesson.
> 
> And the thing is, I suspect that the Linux kernel is the most complete
> - and most serious - user of true atomics that the C11 people can sell
> their solution to.

I agree, but there are likely also other big projects that could make
use of C11 atomics on the userspace side (e.g., certain databases, ...).

> If we don't buy it, they have no serious user.

I disagree with that.  That obviously depends on one's definition of
"serious", but if you combine all C/C++ programs that use low-level
atomics, then this is serious use as well.  There's lots of
shared-memory synchronization in userspace as well.

> Sure, they'll have lots
> of random other one-off users for their atomics, where each user wants
> one particular thing, but I suspect that we'll have the only really
> unified portable code base

glibc is a counterexample that comes to mind, although it's a smaller
code base.  (It's currently not using C11 atomics, but transitioning
there makes sense, and some thing I want to get to eventually.)

> that handles pretty much *all* the serious
> odd cases that the C11 atomics can actually talk about to each other.

You certainly have lots of odd cases, but I would disagree with the
assumption that only the Linux kernel will do full "testing" of the
implementations.  If you have plenty of userspace programs using the
atomics, that's a pretty big test suite, and one that should help bring
the compilers up to speed.  So that might be a benefit even to the Linux
kernel if it would use the C11 atomics.

> Oh, they'll push things through with or without us, and it will be a
> collection of random stuff, where they tried to please everybody, with
> particularly compiler/architecture people who have no f*cking clue
> about how their stuff is used pushing to make it easy/efficient for
> their particular compiler/architecture.

I'll ignore this... :)

> But we have real optimized uses of pretty much all relevant cases that
> people actually care about.

You certainly cover a lot of cases.  Finding out whether you cover all
that "people care about" would require you to actually ask all people,
which I'm sure you've done ;)

> We can walk away from them, and not really lose anything but a small
> convenience (and it's a convenience *only* if the standard gets things
> right).
> 
> And conversely, the C11 people can walk away from us too. But if they
> can't make us happy (and by "make us happy", I really mean no stupid
> games on our part) I personally think they'll have a stronger
> standard, and a real use case, and real arguments. I'm assuming they
> want that.

I agree.

> That's why I complain when you talk about things like marking control
> dependencies explicitly. That's *us* bending over backwards. And as a
> buyer, we have absolutely zero reason to do that.

As I understood the situation, it was rather like the buyer trying to
wrestle in an additional feature without having a proper specification
of what the feature should actually do.  That's why we've been talking
about what it should actually do, and how ...

> Tell the C11 people: "no speculative writes". Full stop. End of story.
> Because we're not buying anything else.
> 
> Similarly, if we need to mark atomics "volatile", then now the C11
> atomics are no longer even a "small convenience", now they are just
> extra complexity wrt what we already have. So just make it clear that
> if the C11 standard needs to mark atomics volatile in order to get
> non-speculative and non-reloading behavior, then the C11 atomics are
> useless to us, and we're not buying.

I hope what I wrote previously removes those concerns.

> Remember: a compiler can *always* do "as if" optimizations - if a
> compiler writer can prove that the end result acts 100% the same using
> an optimized sequence, then they can do whatever the hell they want.
> That's not the issue.

Good to know that we agree on that.

> But if we can *ever* see semantic impact of
> speculative writes, the compiler is buggy, and the compiler writers
> need to be aware that it is buggy. No ifs, buts, maybes about it.

Agreed.

> So I'm perfectly fine with you seeing yourself as a buyer. But I want
> you to be a really *picky* and anal buyer - one that knows he has the
> upper hand, and can walk away with no downside.

FWIW, I don't see myself as being the seller.  Instead, I'm hope we can
improve the situation for everyone involved, whether that involves C11
or something else.  I see a potential mutual benefit, and I want to try
to exploit it.  Regarding the distributions I'm concerned about, the
Linux kernel and GCC are very much in the same boat.

