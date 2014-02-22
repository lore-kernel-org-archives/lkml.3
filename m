Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbaBVVxe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 16:53:34 -0500
Received: from mail-ve0-f179.google.com ([209.85.128.179]:52603 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbaBVVxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 16:53:32 -0500
MIME-Version: 1.0
In-Reply-To: <1393095223.28840.4914.camel@triegel.csb>
References: <CA+55aFyqLrj4d2TA+2aazRqXnbVsUvs0yaBL2D5rXF1G=Kiu_g@mail.gmail.com>
	<CA+55aFwsq5E8kMoEeHJJ1f2=+QAUCu_HndfPxHNz8fUBprS-jQ@mail.gmail.com>
	<1392740258.18779.7732.camel@triegel.csb>
	<CA+55aFw7QYEMFs0BCxqRJW3Cz=tLbaku-tmN6hLXPKP9jbom7Q@mail.gmail.com>
	<1392752867.18779.8120.camel@triegel.csb>
	<CA+55aFxQPxQ8WOaZL8yAqBA=Y4k2gDn4r4oepMyi0uL6XLzv3w@mail.gmail.com>
	<20140220040102.GM4250@linux.vnet.ibm.com>
	<CA+55aFwwscSzwTr+xRdirtTx7HzugmMY9HrDe0GBqNhn=AuNVA@mail.gmail.com>
	<20140220083032.GN4250@linux.vnet.ibm.com>
	<CA+55aFwfx==u7o1NZ66aPbkOgsvGqW3UscGqrQkGuzOkjSpm6Q@mail.gmail.com>
	<20140220181116.GT4250@linux.vnet.ibm.com>
	<CA+55aFwn9gXWVq_GL=tPPP63vsqs-9QB4ii4s06xqG4UscCV5w@mail.gmail.com>
	<1392922421.28840.36.camel@triegel.csb>
	<CA+55aFwos2Gwd2LEvht4ymVxHb6GRVjtZ9wwJSaj1p--FqNUWw@mail.gmail.com>
	<1393095223.28840.4914.camel@triegel.csb>
Date: Sat, 22 Feb 2014 13:53:30 -0800
X-Google-Sender-Auth: mK_dGsRwrvxIbY9K5v4BNFRRHhE
Message-ID: <CA+55aFz9=RQoMO2ipyZgNPNzWGVXi_R9Ar5=o9VBWwXzDDz6jg@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Torvald Riegel <triegel@redhat.com>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 22, 2014 at 10:53 AM, Torvald Riegel <triegel@redhat.com> wrote:
>
> Stating that (1) "the standard is wrong" and (2) that you think that
> mo_consume semantics are not good is two different things.

I do agree. They are two independent things.

I think the standard is wrong, because it's overly complex, hard to
understand, and nigh unimplementable. As shown by the bugzilla
example, "carries a dependency" encompasses things that are *not* just
synchronizing things just through a pointer, and as a result it's
actually very complicated, since they could have been optimized away,
or done in non-local code that wasn't even aware of the dependency
carrying.

That said, I'm reconsidering my suggested stricter semantics, because
for RCU we actually do want to test the resulting pointer against NULL
_without_ any implied serialization.

So I still feel that the standard as written is fragile and confusing
(and the bugzilla entry pretty much proves that it is also practically
unimplementable as written), but strengthening the serialization may
be the wrong thing.

Within the kernel, the RCU use for this is literally purely about
loading a pointer, and doing either:

 - testing its value against NULL (without any implied synchronization at all)

 - using it as a pointer to an object, and expecting that any accesses
to that object are ordered wrt the consuming load.

So I actually have a suggested *very* different model that people
might find more acceptable.

How about saying that the result of a "atomic_read(&a, mo_consume)" is
required to be a _restricted_ pointer type, and that the consume
ordering guarantees the ordering between that atomic read and the
accesses to the object that the pointer points to.

No "carries a dependency", no nothing.

Now, there's two things to note in there:

 - the "restricted pointer" part means that the compiler does not need
to worry about serialization to that object through other possible
pointers - we have basically promised that the *only* pointer to that
object comes from the mo_consume. So that part makes it clear that the
"consume" ordering really only is valid wrt that particular pointer
load.

 - the "to the object that the pointer points to" makes it clear that
you can't use the pointer to generate arbitrary other values and claim
to serialize that way.

IOW, with those alternate semantics, that gcc bugzilla example is
utterly bogus, and a compiler can ignore it, because while it tries to
synchronize through the "dependency chain" created with that "p-i+i"
expression, that is completely irrelevant when you use the above rules
instead.

In the bugzilla example, the object that "*(p-i+i)" accesses isn't
actually the object pointed to by the pointer, so no serialization is
implied. And if it actually *were* to be the same object, because "p"
happens to have the same value as "i", then the "restrict" part of the
rule pops up and the compiler can again say that there is no ordering
guarantee, since the programmer lied to it and used a restricted
pointer that aliased with another one.

So the above suggestion basically tightens the semantics of "consume"
in a totally different way - it doesn't make it serialize more, in
fact it weakens the serialization guarantees a lot, but it weakens
them in a way that makes the semantics a lot simpler and clearer.

                 Linus
