Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbaBXTyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:54:50 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:59688 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbaBXTyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:54:47 -0500
MIME-Version: 1.0
In-Reply-To: <20140224185341.GU8264@linux.vnet.ibm.com>
References: <CA+55aFwos2Gwd2LEvht4ymVxHb6GRVjtZ9wwJSaj1p--FqNUWw@mail.gmail.com>
	<1393095223.28840.4914.camel@triegel.csb>
	<CA+55aFz9=RQoMO2ipyZgNPNzWGVXi_R9Ar5=o9VBWwXzDDz6jg@mail.gmail.com>
	<20140223003933.GQ4250@linux.vnet.ibm.com>
	<CA+55aFyjzR_Ga_HOKnBXpKYbuesqovj1-sFTVisD9UwA6JuJtw@mail.gmail.com>
	<20140223063426.GT4250@linux.vnet.ibm.com>
	<CA+55aFxMJvaQhoEwqgN=XA6gDOdZwoZQHdcAnB-FhAri_hK-6Q@mail.gmail.com>
	<CA+55aFw5tdjmNyHCdcyZ8NPpd1wCgOjLRzstRhp0Njs9azpi8Q@mail.gmail.com>
	<20140224172110.GO8264@linux.vnet.ibm.com>
	<CA+55aFyi45f7oaG4MYP41TOc=E8Ze8Om88dV2Lq4F=qebhxt4A@mail.gmail.com>
	<20140224185341.GU8264@linux.vnet.ibm.com>
Date: Mon, 24 Feb 2014 11:54:46 -0800
X-Google-Sender-Auth: Mbv6eocMqcyXJQggqlo6KhTlft8
Message-ID: <CA+55aFzXyob0aKnv1u7Stbu0rH5Aq2jaA1rHb=TvQe9c1KY0oQ@mail.gmail.com>
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

On Mon, Feb 24, 2014 at 10:53 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> Good points.  How about the following replacements?
>
> 3.      Adding or subtracting an integer to/from a chained pointer
>         results in another chained pointer in that same pointer chain.
>         The results of addition and subtraction operations that cancel
>         the chained pointer's value (for example, "p-(long)p" where "p"
>         is a pointer to char) are implementation defined.
>
> 4.      Bitwise operators ("&", "|", "^", and I suppose also "~")
>         applied to a chained pointer and an integer for the purposes
>         of alignment and pointer translation results in another
>         chained pointer in that same pointer chain.  Other uses
>         of bitwise operators on chained pointers (for example,
>         "p|~0") are implementation defined.

Quite frankly, I think all of this language that is about the actual
operations is irrelevant and wrong.

It's not going to help compiler writers, and it sure isn't going to
help users that read this.

Why not just talk about "value chains" and that any operations that
restrict the value range severely end up breaking the chain. There is
no point in listing the operations individually, because every single
operation *can* restrict things. Listing individual operations and
depdendencies is just fundamentally wrong.

For example, let's look at this obvious case:

   int q,*p = atomic_read(&pp, consume);
   .. nothing modifies 'p' ..
   q = *p;

and there are literally *zero* operations that modify the value
change, so obviously the two operations are ordered, right?

Wrong.

What if the "nothing modifies 'p'" part looks like this:

    if (p != &myvariable)
        return;

and now any sane compiler will happily optimize "q = *p" into "q =
myvariable", and we're all done - nothing invalid was ever

So my earlier suggestion tried to avoid this by having the restrict
thing, so the above wouldn't work.

But your (and the current C standards) attempt to define this with
some kind of syntactic dependency carrying chain will _inevitably_ get
this wrong, and/or be too horribly complex to actually be useful.

Seriously, don't do it. I claim that all your attempts to do this
crazy syntactic "these operations maintain the chained pointers" is
broken. The fact that you have changed "carries a dependency" to
"chained pointer" changes NOTHING.

So just give it up. It's a fundamentally broken model. It's *wrong*,
but even more importantly, it's not even *useful*, since it ends up
being too complicated for a compiler writer or a programmer to
understand.

I really really really think you need to do this at a higher
conceptual level, get away from all these idiotic "these operations
maintain the chain" crap. Because there *is* no such list.

Quite frankly, any standards text that has that
"[[carries_dependency]]" or "[[kill_dependency]]" or whatever
attribute is broken. It's broken because the whole concept is TOTALLY
ALIEN to the compiler writer or the programmer. It makes no sense.
It's purely legalistic language that has zero reason to exist. It's
non-intuitive for everybody.

And *any* language that talks about the individual operations only
encourages people to play legalistic games that actually defeat the
whole purpose (namely that all relevant CPU's are going to implement
that consume ordering guarantee natively, with no extra code
generation rules AT ALL). So any time you talk about some random
detail of some operation, somebody is going to come up with a "trick"
that defeats things. So don't do it. There is absolutely ZERO
difference between any of the arithmetic operations, be they bitwise,
additive, multiplicative, shifts, whatever.

The *only* thing that matters for all of them is whether they are
"value-preserving", or whether they drop so much information that the
compiler might decide to use a control dependency instead. That's true
for every single one of them.

Similarly, actual true control dependencies that limit the problem
space sufficiently that the actual pointer value no longer has
significant information in it (see the above example) are also things
that remove information to the point that only a control dependency
remains. Even when the value itself is not modified in any way at all.

              Linus
