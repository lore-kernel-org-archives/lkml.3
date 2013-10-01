Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab3JAA4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 20:56:19 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:56055 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561Ab3JAA4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 20:56:17 -0400
MIME-Version: 1.0
In-Reply-To: <23118.1380587771@ale.ozlabs.ibm.com>
References: <CA+55aFwp-RAKEMVvbMG53C=kTMqS09NPXy1eP4xEUYZpvV8X5Q@mail.gmail.com>
	<1380581522.6396.20.camel@pasglop>
	<23118.1380587771@ale.ozlabs.ibm.com>
Date: Mon, 30 Sep 2013 17:56:15 -0700
X-Google-Sender-Auth: rlp7_nUL9u1hxEU_MNyS10gDu7Q
Message-ID: <CA+55aFwi5sZK4mFxs3PT1wU4_vNzsLOFiocqi3g14fPamKXYsw@mail.gmail.com>
Subject: Re: Avoiding the dentry d_lock on final dput(), part deux:
 transactional memory
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michael Neuling <mikey@neuling.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Waiman Long <Waiman.Long@hp.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 5:36 PM, Michael Neuling <mikey@neuling.org> wrote:
>
> The scary part is that we to make all register volatile.  You were not
> that keen on doing this as there are a lot of places in exception
> entry/exit where we only save/restore a subset of the registers.  We'd
> need to catch all these.

Ugh. It's very possible it's not worth using for the kernel then. The
example I posted is normally fine *without* any transactional support,
since it's a very local per-dentry lock, and since we only take that
lock when the last reference drops (so it's not some common directory
dentry, it's a end-point file dentry). In fact, on ARM they just made
the cmpxchg much faster by making it entirely non-serializing (since
it only updates a reference count, there is no locking involved apart
from checking that the lock state is unlocked)

So there is basically never any contention, and the transaction needs
to basically be pretty much the same cost as a "cmpxchg". It's not
clear if the intel TSX is good enough for that, and if you have to
save a lot of registers in order to use transactions on POWER8, I
doubt it's worthwhile.

We have very few - if any - locks where contention or even cache
bouncing is common or normal. Sure, we have a few particular loads
that can trigger it, but even that is becoming rare. So from a
performance standpoint, the target always needs to be "comparable to
hot spinlock in local cache".

>> They also have interesting ordering semantics vs. locks, we need to be
>> a tad careful (as long as we don't access a lock variable
>> transactionally we should be ok. If we do, then spin_unlock needs a
>> stronger barrier).
>
> Yep.

Well, just about any kernel transaction will at least read the state
of a lock. Without that, it's generally totally useless. My dput()
example sequence very much verified that the lock was not held, for
example.

I'm not sure how that affects anything. The actual transaction had
better not be visible inside the locked region (ie as far as any lock
users go, transactions better all happen fully before or after the
lock, if they read the lock and see it being unlocked).

That said, I cannot see how POWER8 could possibly violate that rule.
The whole "transactions are atomic" is kind of the whole and only
point of a transaction. So I'm not sure what odd lock restrictions
POWER8 could have.

> FWIW eg.
>
>      tbegin
>      beq abort /* passes first time through */
>      ....
>      transactional stuff
>      ....
>      tend
>      b pass
>
> abort:
>
> pass:

That's fine, and matches the x86 semantics fairly closely, except
"xbegin" kind of "contains" that "jump to abort address". But we could
definitely use the same models. Call it
"transaction_begin/abort/end()", and it should be architecture-neutral
naming-wise.

Of course, if tbegin then acts basically like some crazy
assembly-level setjmp (I'm guessing it does exactly, and presumably
precisely that kind of compiler support - ie a function with
"__attribute((returns_twice))" in gcc-speak), the overhead of doing it
may kill it.

            Linus
