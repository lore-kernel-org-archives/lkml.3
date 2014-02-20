Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbaBTAxy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 19:53:54 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:35029 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbaBTAxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 19:53:50 -0500
MIME-Version: 1.0
In-Reply-To: <1392752867.18779.8120.camel@triegel.csb>
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
Date: Wed, 19 Feb 2014 16:53:49 -0800
X-Google-Sender-Auth: MsmXOfxHt8Tx_kb22dkg_bWmqBQ
Message-ID: <CA+55aFxQPxQ8WOaZL8yAqBA=Y4k2gDn4r4oepMyi0uL6XLzv3w@mail.gmail.com>
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

On Tue, Feb 18, 2014 at 11:47 AM, Torvald Riegel <triegel@redhat.com> wrote:
> On Tue, 2014-02-18 at 09:44 -0800, Linus Torvalds wrote:
>>
>> Can you point to it? Because I can find a draft standard, and it sure
>> as hell does *not* contain any clarity of the model. It has a *lot* of
>> verbiage, but it's pretty much impossible to actually understand, even
>> for somebody who really understands memory ordering.
>
> http://www.cl.cam.ac.uk/~mjb220/n3132.pdf
> This has an explanation of the model up front, and then the detailed
> formulae in Section 6.  This is from 2010, and there might have been
> smaller changes since then, but I'm not aware of any bigger ones.

Ahh, this is different from what others pointed at. Same people,
similar name, but not the same paper.

I will read this version too, but from reading the other one and the
standard in parallel and trying to make sense of it, it seems that I
may have originally misunderstood part of the whole control dependency
chain.

The fact that the left side of "? :", "&&" and "||" breaks data
dependencies made me originally think that the standard tried very
hard to break any control dependencies. Which I felt was insane, when
then some of the examples literally were about the testing of the
value of an atomic read. The data dependency matters quite a bit. The
fact that the other "Mathematical" paper then very much talked about
consume only in the sense of following a pointer made me think so even
more.

But reading it some more, I now think that the whole "data dependency"
logic (which is where the special left-hand side rule of the ternary
and logical operators come in) are basically an exception to the rule
that sequence points end up being also meaningful for ordering (ok, so
C11 seems to have renamed "sequence points" to "sequenced before").

So while an expression like

    atomic_read(p, consume) ? a : b;

doesn't have a data dependency from the atomic read that forces
serialization, writing

   if (atomic_read(p, consume))
      a;
   else
      b;

the standard *does* imply that the atomic read is "happens-before" wrt
"a", and I'm hoping that there is no question that the control
dependency still acts as an ordering point.

THAT was one of my big confusions, the discussion about control
dependencies and the fact that the logical ops broke the data
dependency made me believe that the standard tried to actively avoid
the whole issue with "control dependencies can break ordering
dependencies on some CPU's due to branch prediction and memory
re-ordering by the CPU".

But after all the reading, I'm starting to think that that was never
actually the implication at all, and the "logical ops breaks the data
dependency rule" is simply an exception to the sequence point rule.
All other sequence points still do exist, and do imply an ordering
that matters for "consume"

Am I now reading it right?

So the clarification is basically to the statement that the "if
(consume(p)) a" version *would* have an ordering guarantee between the
read of "p" and "a", but the "consume(p) ? a : b" would *not* have
such an ordering guarantee. Yes?

                       Linus
