Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654AbaBTRfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 12:35:01 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:37841 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbaBTRe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 12:34:58 -0500
MIME-Version: 1.0
In-Reply-To: <1392916492.18779.10136.camel@triegel.csb>
References: <1392321837.18779.3249.camel@triegel.csb>
	<20140214020144.GO4250@linux.vnet.ibm.com>
	<1392352981.18779.3800.camel@triegel.csb>
	<20140214172920.GQ4250@linux.vnet.ibm.com>
	<CA+55aFx9CbgrfK4rBVYD75y2KoWiO90dSYsAW83O-tYVLK-gkg@mail.gmail.com>
	<CA+55aFypfiTFwundih8QEA6ZwVGk=g5L4sabsN0932eih5knOQ@mail.gmail.com>
	<1392486310.18779.6447.camel@triegel.csb>
	<CA+55aFwTrt_6m1inNHQkk74i7uPkHNnacwHiBgioZSXieAs5Sw@mail.gmail.com>
	<1392666947.18779.6838.camel@triegel.csb>
	<CA+55aFwUnRVk6q3VZeYjWfduoHcExW=Pht6jgp=4bBSaLHNPMA@mail.gmail.com>
	<20140218030002.GA15857@linux.vnet.ibm.com>
	<CA+55aFyqLrj4d2TA+2aazRqXnbVsUvs0yaBL2D5rXF1G=Kiu_g@mail.gmail.com>
	<CA+55aFwsq5E8kMoEeHJJ1f2=+QAUCu_HndfPxHNz8fUBprS-jQ@mail.gmail.com>
	<1392740258.18779.7732.camel@triegel.csb>
	<CA+55aFw7QYEMFs0BCxqRJW3Cz=tLbaku-tmN6hLXPKP9jbom7Q@mail.gmail.com>
	<1392752867.18779.8120.camel@triegel.csb>
	<CA+55aFxQPxQ8WOaZL8yAqBA=Y4k2gDn4r4oepMyi0uL6XLzv3w@mail.gmail.com>
	<1392916492.18779.10136.camel@triegel.csb>
Date: Thu, 20 Feb 2014 09:34:57 -0800
X-Google-Sender-Auth: 6SNDSLXxR_-y1Dul7UmmhgtxYxk
Message-ID: <CA+55aFyEEUrAz2r=nKxZxUtPVs7zoER9HukQq11UixnrYWbsjA@mail.gmail.com>
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
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>, Mark Batty <mbatty@cl.cam.ac.uk>,
        Peter Sewell <Peter.Sewell@cl.cam.ac.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 9:14 AM, Torvald Riegel <triegel@redhat.com> wrote:
>>
>> So the clarification is basically to the statement that the "if
>> (consume(p)) a" version *would* have an ordering guarantee between the
>> read of "p" and "a", but the "consume(p) ? a : b" would *not* have
>> such an ordering guarantee. Yes?
>
> Not as I understand it.  If my reply above wasn't clear, let me know and
> I'll try to rephrase it into something that is.

Yeah, so you and Paul agree. And as I mentioned in the email that
crossed with yours, I think that means that the standard is overly
complex, hard to understand, fragile, and all *pointlessly* so.

Btw, there are many ways that "use a consume as an input to a
conditional" can happen. In particular, even if the result is actually
*used* like a pointer as far as the programmer is concerned, tricks
like pointer compression etc can well mean that the "pointer" is
actually at least partly implemented using conditionals, so that some
paths end up being only dependent through a comparison of the pointer
value.

So I very much did *not* want to complicate the "litmus test" code
snippet when Paul tried to make it more complex, but I do think that
there are cases where code that "looks" like pure pointer chasing
actually is not for some cases, and then can become basically that
litmus test for some path.

Just to give you an example: in simple list handling it is not at all
unusual to have a special node that is discovered by comparing the
address, not by just loading from the pointer and following the list
itself. Examples of that would be a HEAD node in a doubly linked list
(Linux uses this concept quite widely, it's our default list
implementation), or it could be a place-marker ("cursor" entry) in the
list for safe traversal in the presence of concurrent deletes etc.

And obviously there is the already much earlier mentioned
compiler-induced compare, due to value speculation, that can basically
create such sequences even wherethey did not originally exist in the
source code itself.

So even if you work with "pointer dereferences", and thus match that
particular consume pattern, I really don't see why anybody would think
that "hey, we can ignore any control dependencies" is a good idea.
It's a *TERRIBLE* idea.

And as mentioned, it's a terrible idea with no upsides. It doesn't
help compiler optimizations for the case it's *intended* to help,
since those optimizations can still be done without the horribly
broken semantics. It doesn't help compiler writers, it just confuses
them.

And it sure as hell doesn't help users.

                  Linus
