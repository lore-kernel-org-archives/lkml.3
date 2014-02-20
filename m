Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbaBTRud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 12:50:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424AbaBTRub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 12:50:31 -0500
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
In-Reply-To: <CA+55aFwwscSzwTr+xRdirtTx7HzugmMY9HrDe0GBqNhn=AuNVA@mail.gmail.com>
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
	 <CA+55aFwwscSzwTr+xRdirtTx7HzugmMY9HrDe0GBqNhn=AuNVA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Feb 2014 18:49:36 +0100
Message-ID: <1392918576.18779.10198.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-19 at 20:43 -0800, Linus Torvalds wrote:

[Paul has already answered many of your questions, and my reply to your
previous email should also answer some.]

> If the consumer of an atomic load isn't a pointer chasing operation,
> then the consume should be defined to be the same as acquire. None of
> this "conditionals break consumers". No, conditionals on the
> dependency path should turn consumers into acquire, because otherwise
> the "consume" load is dangerous as hell.

Yes, mo_consume is more tricky than mo_acquire.

However, that has an advantage because you can avoid getting stronger
barriers if you don't need them (ie, you can avoid the "auto-update to
acquire" you seem to have in mind).

The auto-upgrade would be a possible semantics, I agree.

Another option may be to let an implementation optimize the HW barriers
that it uses for mo_acquire.  That is, if the compiler sees that (1) the
result of an mo_acquire load is used on certain code paths *only* for
consumers that carry the dependency *and* (2) there are no other
operations on that code path that can possibly rely on the mo_acquire
ordering guarantees, then the compiler can use a weaker HW barrier on
archs such as PowerPC or ARM.

That is similar to the rules for mo_consume you seem to have in mind,
but makes it a compiler optimization on mo_acquire.  However, the
compiler has to be conservative here, so having a mo_consume that is
trickier to use but doesn't ever silently introduce stronger HW barriers
seems to be useful (modulo the difficulties regarding to how it's
currently specified in the standard).

> And if the definition of acquire doesn't include the control
> dependency either, then the C atomic memory model is just completely
> and utterly broken, since the above *trivial* and clearly useful
> example is broken.

In terms of the model, if you establish a synchronizes-with using a
reads-from that has (or crosses) a release/acquire memory-order pair,
then this synchronizes-with will also order other operations that it's
sequenced-before (see the composition of synchronizes-with and
sequenced-before in the inter-thread-happens-before definition in n3132
6.15).

So yes, mo_acquire does that the logical "control dependencies" /
sequenced-before into account.

