Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbaBTEnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 23:43:18 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:42268 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbaBTEnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 23:43:15 -0500
MIME-Version: 1.0
In-Reply-To: <20140220040102.GM4250@linux.vnet.ibm.com>
References: <CA+55aFwTrt_6m1inNHQkk74i7uPkHNnacwHiBgioZSXieAs5Sw@mail.gmail.com>
	<1392666947.18779.6838.camel@triegel.csb>
	<CA+55aFwUnRVk6q3VZeYjWfduoHcExW=Pht6jgp=4bBSaLHNPMA@mail.gmail.com>
	<20140218030002.GA15857@linux.vnet.ibm.com>
	<CA+55aFyqLrj4d2TA+2aazRqXnbVsUvs0yaBL2D5rXF1G=Kiu_g@mail.gmail.com>
	<CA+55aFwsq5E8kMoEeHJJ1f2=+QAUCu_HndfPxHNz8fUBprS-jQ@mail.gmail.com>
	<1392740258.18779.7732.camel@triegel.csb>
	<CA+55aFw7QYEMFs0BCxqRJW3Cz=tLbaku-tmN6hLXPKP9jbom7Q@mail.gmail.com>
	<1392752867.18779.8120.camel@triegel.csb>
	<CA+55aFxQPxQ8WOaZL8yAqBA=Y4k2gDn4r4oepMyi0uL6XLzv3w@mail.gmail.com>
	<20140220040102.GM4250@linux.vnet.ibm.com>
Date: Wed, 19 Feb 2014 20:43:14 -0800
X-Google-Sender-Auth: xLSHglHCUPy9gVGcHngARpKjtqY
Message-ID: <CA+55aFwwscSzwTr+xRdirtTx7HzugmMY9HrDe0GBqNhn=AuNVA@mail.gmail.com>
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

On Wed, Feb 19, 2014 at 8:01 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> The control dependency should order subsequent stores, at least assuming
> that "a" and "b" don't start off with identical stores that the compiler
> could pull out of the "if" and merge.  The same might also be true for ?:
> for all I know.  (But see below)

Stores I don't worry about so much because

 (a) you can't sanely move stores up in a compiler anyway
 (b) no sane CPU or moves stores up, since they aren't on the critical path

so a read->cmp->store is actually really hard to make anything sane
re-order. I'm sure it can be done, and I'm sure it's stupid as hell.

But that "it's hard to screw up" is *not* true for a load->cmp->load.

So lets make this really simple: if you have a consume->cmp->read, is
the ordering of the two reads guaranteed?

> As long as there is an unbroken chain of -data- dependencies from the
> consume to the later access in question, and as long as that chain
> doesn't go through the excluded operations, yes.

So let's make it *really* specific, and make it real code doing a real
operation, that is actually realistic and reasonable in a threaded
environment, and may even be in some critical code.

The issue is the read-side ordering guarantee for 'a' and 'b', for this case:

 - Initial state:

   a = b = 0;

 - Thread 1 ("consumer"):

    if (atomic_read(&a, consume))
         return b;
    /* not yet initialized */
    return -1;

 - Thread 2 ("initializer"):

     b = some_value_lets_say_42;
     /* We are now ready to party */
     atomic_write(&a, 1, release);

and quite frankly, if there is no ordering guarantee between the read
of "a" and the read of "b" in the consumer thread, then the C atomics
standard is broken.

Put another way: I claim that if "thread 1" ever sees a return value
other than -1 or 42, then the whole definition of atomics is broken.

Question 2: and what changes if the atomic_read() is turned into an
acquire, and why? Does it start working?

> Neither has a data-dependency guarantee, because there is no data
> dependency from the load to either "a" or "b".  After all, the value
> loaded got absorbed into the "if" condition.  However, according to
> discussions earlier in this thread, the "if" variant would have a
> control-dependency ordering guarantee for any stores in "a" and "b"
> (but not loads!).

So exactly what part of the standard allows the loads to be
re-ordered, and why? Quite frankly, I'd think that any sane person
will agree that the above code snippet is realistic, and that my
requirement that thread 1 sees either -1 or 42 is valid.

And if the C standards body has said that control dependencies break
the read ordering, then I really think that the C standards committee
has screwed up.

If the consumer of an atomic load isn't a pointer chasing operation,
then the consume should be defined to be the same as acquire. None of
this "conditionals break consumers". No, conditionals on the
dependency path should turn consumers into acquire, because otherwise
the "consume" load is dangerous as hell.

And if the definition of acquire doesn't include the control
dependency either, then the C atomic memory model is just completely
and utterly broken, since the above *trivial* and clearly useful
example is broken.

I really think the above example is pretty damn black-and-white.
Either it works, or the standard isn't worth wiping your ass with.

          Linus
