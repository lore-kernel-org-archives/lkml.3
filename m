Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbaBXXfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 18:35:09 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:54573 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbaBXXfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 18:35:05 -0500
MIME-Version: 1.0
In-Reply-To: <20140224223701.GC8264@linux.vnet.ibm.com>
References: <CA+55aFz9=RQoMO2ipyZgNPNzWGVXi_R9Ar5=o9VBWwXzDDz6jg@mail.gmail.com>
	<20140223003933.GQ4250@linux.vnet.ibm.com>
	<CA+55aFyjzR_Ga_HOKnBXpKYbuesqovj1-sFTVisD9UwA6JuJtw@mail.gmail.com>
	<20140223063426.GT4250@linux.vnet.ibm.com>
	<CA+55aFxMJvaQhoEwqgN=XA6gDOdZwoZQHdcAnB-FhAri_hK-6Q@mail.gmail.com>
	<CA+55aFw5tdjmNyHCdcyZ8NPpd1wCgOjLRzstRhp0Njs9azpi8Q@mail.gmail.com>
	<20140224172110.GO8264@linux.vnet.ibm.com>
	<CA+55aFyi45f7oaG4MYP41TOc=E8Ze8Om88dV2Lq4F=qebhxt4A@mail.gmail.com>
	<20140224185341.GU8264@linux.vnet.ibm.com>
	<CA+55aFzXyob0aKnv1u7Stbu0rH5Aq2jaA1rHb=TvQe9c1KY0oQ@mail.gmail.com>
	<20140224223701.GC8264@linux.vnet.ibm.com>
Date: Mon, 24 Feb 2014 15:35:04 -0800
X-Google-Sender-Auth: oW9UchbKKSFu-wr6LJFNa0ZOte0
Message-ID: <CA+55aFxGaKtvx5YnOFC5hU9+ischxn=LN_yWiqjXwpNZePvWmw@mail.gmail.com>
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

On Mon, Feb 24, 2014 at 2:37 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>>
>> What if the "nothing modifies 'p'" part looks like this:
>>
>>     if (p != &myvariable)
>>         return;
>>
>> and now any sane compiler will happily optimize "q = *p" into "q =
>> myvariable", and we're all done - nothing invalid was ever
>
> Yes, the compiler could do that.  But it would still be required to
> carry a dependency from the memory_order_consume read to the "*p",

But that's *BS*. You didn't actually listen to the main issue.

Paul, why do you insist on this carries-a-dependency crap?

It's broken. If you don't believe me, then believe the compiler person
who already piped up and told you so.

The "carries a dependency" model is broken. Get over it.

No sane compiler will ever distinguish two different registers that
have the same value from each other. No sane compiler will ever say
"ok, register r1 has the exact same value as register r2, but r2
carries the dependency, so I need to make sure to pass r2 to that
function or use it as a base pointer".

And nobody sane should *expect* a compiler to distinguish two
registers with the same value that way.

So the whole model is broken.

I gave an alternate model (the "restrict"), and you didn't seem to
understand the really fundamental difference. It's not a language
difference, it's a conceptual difference.

In the broken "carries a dependency" model, you have fight all those
aliases that can have the same value, and it is not a fight you can
win. We've had the "p-p" examples, we've had the "p&0" examples, but
the fact is, that "p==&myvariable" example IS EXACTLY THE SAME THING.

All three of those things: "p-p", "p&0", and "p==&myvariable" mean
that any compiler worth its salt now know that "p" carries no
information, and will optimize it away.

So please stop arguing against that. Whenever you argue against that
simple fact, you are arguing against sane compilers.

So *accept* the fact that some operations (and I guarantee that there
are more of those than you can think of, and you can create them with
various tricks using pretty much *any* feature in the C language)
essentially take the data information away. And just accept the fact
that then the ordering goes away too.

So give up on "carries a dependency". Because there will be cases
where that dependency *isn't* carried.

The language of the standard needs to get *away* from the broken
model, because otherwise the standard is broken.

I suggest we instead talk about "litmus tests" and why certain code
sequences are ordered, and others are not.

So the code sequence I already mentioned is *not* ordered:

Litmus test 1:

    p = atomic_read(pp, consume);
    if (p == &variable)
        return p->val;

   is *NOT* ordered, because the compiler can trivially turn this into
"return variable.val", and break the data dependency.

   This is true *regardless* of any "carries a dependency" language,
because that language is insane, and doesn't work when the different
pieces here may be in different compilation units.

BUT:

Litmus test 2:

    p = atomic_read(pp, consume);
    if (p != &variable)
        return p->val;

  *IS* ordered, because while it looks syntactically a lot like
"Litmus test 1", there is no sane way a compiler can use the knowledge
that "p is not a pointer to a particular location" to break the data
dependency.

There is no way in hell that any sane "carries a dependency" model can
get the simple tests above right.

So give up on it already. "Carries a dependency" cannot work. It's a
bad model. You're trying to describe the problem using the wrong
tools.

Note that my "restrict+pointer to object" language actually got this
*right*. The "restrict" part made Litmus test 1 not ordered, because
that "p == &variable" success case means that the pointer wasn't
restricted, so the pre-requisite for ordering didn't exist.

See? The "carries a dependency" is a broken model for this, but there
are _other_ models that can work.

You tried to rewrite my model into "carries a dependency". That
*CANNOT* work. It's like trying to rewrite quantum physics into the
Greek model of the four elements. They are not compatible models, and
one of them can be shown to not work.

              Linus
