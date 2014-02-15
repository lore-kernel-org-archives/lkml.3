Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbaBOCoW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 21:44:22 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:62005 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbaBOCoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 21:44:20 -0500
MIME-Version: 1.0
In-Reply-To: <20140215020815.GS4250@linux.vnet.ibm.com>
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
Date: Fri, 14 Feb 2014 18:44:19 -0800
X-Google-Sender-Auth: n3emLw1Mkui7nSkkB579P_kVloQ
Message-ID: <CA+55aFyQTE-CzOoNn=KfDgt9bTLrUxBCXzhQ2T9kNoTy+bRQrQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Torvald Riegel <triegel@redhat.com>, Will Deacon <will.deacon@arm.com>,
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

On Fri, Feb 14, 2014 at 6:08 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> One way of looking at the discussion between Torvald and myself would be
> as a seller (Torvald) and a buyer (me) haggling over the fine print in
> a proposed contract (the standard).  Whether that makes you feel better
> or worse about the situation I cannot say.  ;-)

Oh, I'm perfectly fine with that. But we're not desperate to buy, and
I actually think the C11 people are - or at least should be - *way*
more desperate to sell their model to us than we are to take it.

Which means that as a buyer you should say "this is what we want, if
you don't give us this, we'll just walk away". Not try to see how much
we can pay for it. Because there is very little upside for us, and
_unless_ the C11 standard gets things right it's just extra complexity
for us, coupled with new compiler fragility and years of code
generation bugs.

Why would we want that extra complexity and inevitable compiler bugs?
If we then have to fight compiler writers that point to the standard
and say "..but look, the standard says we can do this", then at that
point it went from "extra complexity and compiler bugs" to a whole
'nother level of frustration and pain.

So just walk away unless the C11 standard gives us exactly what we
want. Not "something kind of like what we'd use". EXACTLY. Because I'm
not in the least interested in fighting compiler people that have a
crappy standard they can point to. Been there, done that, got the
T-shirt and learnt my lesson.

And the thing is, I suspect that the Linux kernel is the most complete
- and most serious - user of true atomics that the C11 people can sell
their solution to.

If we don't buy it, they have no serious user. Sure, they'll have lots
of random other one-off users for their atomics, where each user wants
one particular thing, but I suspect that we'll have the only really
unified portable code base that handles pretty much *all* the serious
odd cases that the C11 atomics can actually talk about to each other.

Oh, they'll push things through with or without us, and it will be a
collection of random stuff, where they tried to please everybody, with
particularly compiler/architecture people who have no f*cking clue
about how their stuff is used pushing to make it easy/efficient for
their particular compiler/architecture.

But we have real optimized uses of pretty much all relevant cases that
people actually care about.

We can walk away from them, and not really lose anything but a small
convenience (and it's a convenience *only* if the standard gets things
right).

And conversely, the C11 people can walk away from us too. But if they
can't make us happy (and by "make us happy", I really mean no stupid
games on our part) I personally think they'll have a stronger
standard, and a real use case, and real arguments. I'm assuming they
want that.

That's why I complain when you talk about things like marking control
dependencies explicitly. That's *us* bending over backwards. And as a
buyer, we have absolutely zero reason to do that.

Tell the C11 people: "no speculative writes". Full stop. End of story.
Because we're not buying anything else.

Similarly, if we need to mark atomics "volatile", then now the C11
atomics are no longer even a "small convenience", now they are just
extra complexity wrt what we already have. So just make it clear that
if the C11 standard needs to mark atomics volatile in order to get
non-speculative and non-reloading behavior, then the C11 atomics are
useless to us, and we're not buying.

Remember: a compiler can *always* do "as if" optimizations - if a
compiler writer can prove that the end result acts 100% the same using
an optimized sequence, then they can do whatever the hell they want.
That's not the issue. But if we can *ever* see semantic impact of
speculative writes, the compiler is buggy, and the compiler writers
need to be aware that it is buggy. No ifs, buts, maybes about it.

So I'm perfectly fine with you seeing yourself as a buyer. But I want
you to be a really *picky* and anal buyer - one that knows he has the
upper hand, and can walk away with no downside.

                    Linus
