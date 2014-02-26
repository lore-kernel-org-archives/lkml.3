Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829AbaBZBrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 20:47:09 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:42171 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbaBZBrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 20:47:06 -0500
MIME-Version: 1.0
In-Reply-To: <20140225060021.GM8264@linux.vnet.ibm.com>
References: <CA+55aFyjzR_Ga_HOKnBXpKYbuesqovj1-sFTVisD9UwA6JuJtw@mail.gmail.com>
	<20140223063426.GT4250@linux.vnet.ibm.com>
	<CA+55aFxMJvaQhoEwqgN=XA6gDOdZwoZQHdcAnB-FhAri_hK-6Q@mail.gmail.com>
	<CA+55aFw5tdjmNyHCdcyZ8NPpd1wCgOjLRzstRhp0Njs9azpi8Q@mail.gmail.com>
	<20140224172110.GO8264@linux.vnet.ibm.com>
	<CA+55aFyi45f7oaG4MYP41TOc=E8Ze8Om88dV2Lq4F=qebhxt4A@mail.gmail.com>
	<20140224185341.GU8264@linux.vnet.ibm.com>
	<CA+55aFzXyob0aKnv1u7Stbu0rH5Aq2jaA1rHb=TvQe9c1KY0oQ@mail.gmail.com>
	<20140224223701.GC8264@linux.vnet.ibm.com>
	<CA+55aFxGaKtvx5YnOFC5hU9+ischxn=LN_yWiqjXwpNZePvWmw@mail.gmail.com>
	<20140225060021.GM8264@linux.vnet.ibm.com>
Date: Tue, 25 Feb 2014 17:47:03 -0800
X-Google-Sender-Auth: tjzwSRKU6YhQEZLjiRtvBZHjaZc
Message-ID: <CA+55aFx18K=kQR-wwv-cZHnQeiP18zrsD_gwXUByeQP+-Tp=xw@mail.gmail.com>
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

On Mon, Feb 24, 2014 at 10:00 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> So let me see if I understand your reasoning.  My best guess is that it
> goes something like this:
>
> 1.      The Linux kernel contains code that passes pointers from
>         rcu_dereference() through external functions.

No, actually, it's not so much Linux-specific at all.

I'm actually thinking about what I'd do as a compiler writer, and as a
defender the "C is a high-level assembler" concept.

I love C. I'm a huge fan. I think it's a great language, and I think
it's a great language not because of some theoretical issues, but
because it is the only language around that actually maps fairly well
to what machines really do.

And it's a *simple* language. Sure, it's not quite as simple as it
used to be, but look at how thin the "K&R book" is. Which pretty much
describes it - still.

That's the real strength of C, and why it's the only language serious
people use for system programming.  Ignore C++ for a while (Jesus
Xavier Christ, I've had to do C++ programming for subsurface), and
just think about what makes _C_ a good language.

I can look at C code, and I can understand what the code generation
is, and what it will really *do*. And I think that's important.
Abstractions that hide what the compiler will actually generate are
bad abstractions.

And ok, so this is obviously Linux-specific in that it's generally
only Linux where I really care about the code generation, but I do
think it's a bigger issue too.

So I want C features to *map* to the hardware features they implement.
The abstractions should match each other, not fight each other.

> Actually, the fact that there are more potential optimizations than I can
> think of is a big reason for my insistence on the carries-a-dependency
> crap.  My lack of optimization omniscience makes me very nervous about
> relying on there never ever being a reasonable way of computing a given
> result without preserving the ordering.

But if I can give two clear examples that are basically identical from
a syntactic standpoint, and one clearly can be trivially optimized to
the point where the ordering guarantee goes away, and the other
cannot, and you cannot describe the difference, then I think your
description is seriously lacking.

And I do *not* think the C language should be defined by how it can be
described. Leave that to things like Haskell or LISP, where the goal
is some kind of completeness of the language that is about the
language, not about the machines it will run on.

>> So the code sequence I already mentioned is *not* ordered:
>>
>> Litmus test 1:
>>
>>     p = atomic_read(pp, consume);
>>     if (p == &variable)
>>         return p->val;
>>
>>    is *NOT* ordered, because the compiler can trivially turn this into
>> "return variable.val", and break the data dependency.
>
> Right, given your model, the compiler is free to produce code that
> doesn't order the load from pp against the load from p->val.

Yes. Note also that that is what existing compilers would actually do.

And they'd do it "by mistake": they'd load the address of the variable
into a register, and then compare the two registers, and then end up
using _one_ of the registers as the base pointer for the "p->val"
access, but I can almost *guarantee* that there are going to be
sequences where some compiler will choose one register over the other
based on some random detail.

So my model isn't just a "model", it also happens to descibe reality.

> Indeed, it won't work across different compilation units unless
> the compiler is told about it, which is of course the whole point of
> [[carries_dependency]].  Understood, though, the Linux kernel currently
> does not have anything that could reasonably automatically generate those
> [[carries_dependency]] attributes.  (Or are there other reasons why you
> believe [[carries_dependency]] is problematic?)

So I think carries_dependency is problematic because:

 - it's not actually in C11 afaik

 - it requires the programmer to solve the problem of the standard not
matching the hardware.

 - I think it's just insanely ugly, *especially* if it's actually
meant to work so that the current carries-a-dependency works even for
insane expressions like "a-a".

in practice, it's one of those things where I guess nobody actually
would ever use it.

> Of course, I cannot resist putting forward a third litmus test:
>
>         static struct foo variable1;
>         static struct foo variable2;
>         static struct foo *pp = &variable1;
>
> T1:     initialize_foo(&variable2);
>         atomic_store_explicit(&pp, &variable2, memory_order_release);
>         /* The above is the only store to pp in this translation unit,
>          * and the address of pp is not exported in any way.
>          */
>
> T2:     if (p == &variable1)
>                 return p->val1; /* Must be variable1.val1. */
>         else
>                 return p->val2; /* Must be variable2.val2. */
>
> My guess is that your approach would not provide ordering in this
> case, either.  Or am I missing something?

I actually agree.

If you write insane code to "trick" the compiler into generating
optimizations that break the dependency, then you get what you
deserve.

Now, realistically, I doubt a compiler will notice, but if it does,
I'd go "well, that's your own fault for writing code that makes no
sense".

Basically, the above uses a pointer as a boolean flag.  The compiler
noticed it was really a boolean flag, and "consume" doesn't work on
boolean flags. Tough.

             Linus

              Linus
