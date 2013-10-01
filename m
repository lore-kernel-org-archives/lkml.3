Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab3JACGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 22:06:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:45947 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754834Ab3JACGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 22:06:18 -0400
Message-ID: <1380593103.6396.38.camel@pasglop>
Subject: Re: Avoiding the dentry d_lock on final dput(), part deux:
 transactional memory
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael Neuling <mikey@neuling.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Waiman Long <Waiman.Long@hp.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Tue, 01 Oct 2013 12:05:03 +1000
In-Reply-To: <CA+55aFwi5sZK4mFxs3PT1wU4_vNzsLOFiocqi3g14fPamKXYsw@mail.gmail.com>
References: <CA+55aFwp-RAKEMVvbMG53C=kTMqS09NPXy1eP4xEUYZpvV8X5Q@mail.gmail.com>
	 <1380581522.6396.20.camel@pasglop> <23118.1380587771@ale.ozlabs.ibm.com>
	 <CA+55aFwi5sZK4mFxs3PT1wU4_vNzsLOFiocqi3g14fPamKXYsw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-30 at 17:56 -0700, Linus Torvalds wrote:
> On Mon, Sep 30, 2013 at 5:36 PM, Michael Neuling <mikey@neuling.org> wrote:
> >
> > The scary part is that we to make all register volatile.  You were not
> > that keen on doing this as there are a lot of places in exception
> > entry/exit where we only save/restore a subset of the registers.  We'd
> > need to catch all these.
> 
> Ugh. It's very possible it's not worth using for the kernel then. The
> example I posted is normally fine *without* any transactional support,
> since it's a very local per-dentry lock, and since we only take that
> lock when the last reference drops (so it's not some common directory
> dentry, it's a end-point file dentry). In fact, on ARM they just made
> the cmpxchg much faster by making it entirely non-serializing (since
> it only updates a reference count, there is no locking involved apart
> from checking that the lock state is unlocked)
> 
> So there is basically never any contention, and the transaction needs
> to basically be pretty much the same cost as a "cmpxchg". It's not
> clear if the intel TSX is good enough for that, and if you have to
> save a lot of registers in order to use transactions on POWER8, I
> doubt it's worthwhile.

Well we don't have to, I think Mikey wasn't totally clear about that
"making all registers volatile" business :-) This is just something we
need to handle in assembly if we are going to reclaim the suspended
transaction.

So basically, what we need is something along the lines of
enable_kernel_tm() which checks if there's a suspended user transaction
and if yes, kills/reclaims it.

Then we also need to handle in our interrupt handlers that we have an
active/suspended transaction from a kernel state, which we don't deal
with at this point, and do whatever has to be done to kill it... we
might get away with something simple if we can state that we only allow
kernel transactions at task level and not from interrupt/softirq
contexts, at least initially.

> We have very few - if any - locks where contention or even cache
> bouncing is common or normal. Sure, we have a few particular loads
> that can trigger it, but even that is becoming rare. So from a
> performance standpoint, the target always needs to be "comparable to
> hot spinlock in local cache".

I am not quite familiar with the performance profile of our
transactional hardware. I think we should definitely try to hack
something together for that dput() case and measure it.

> >> They also have interesting ordering semantics vs. locks, we need to be
> >> a tad careful (as long as we don't access a lock variable
> >> transactionally we should be ok. If we do, then spin_unlock needs a
> >> stronger barrier).
> >
> > Yep.
> 
> Well, just about any kernel transaction will at least read the state
> of a lock. Without that, it's generally totally useless. My dput()
> example sequence very much verified that the lock was not held, for
> example.
> 
> I'm not sure how that affects anything. The actual transaction had
> better not be visible inside the locked region (ie as far as any lock
> users go, transactions better all happen fully before or after the
> lock, if they read the lock and see it being unlocked).
> 
> That said, I cannot see how POWER8 could possibly violate that rule.
> The whole "transactions are atomic" is kind of the whole and only
> point of a transaction. So I'm not sure what odd lock restrictions
> POWER8 could have.

Has to do with the memory model :-(

I dug the whole story from my mbox and the situation is indeed as dire
as feared. If the transaction reads the lock, then the corresponding
spin_lock must have a full sync barrier in it instead of the current
lighter one.

Now I believe we are already "on the fence" with our locks today since
technically speaking, our unlock + lock sequence is *not* exactly a full
barrier (it is only if it's the same lock I think)

CC'ing Paul McKenney here who's been chasing that issue. In the end, we
might end up having to turn our locks into sync anyway

Yay ! The isanity^Wjoy of an OO memory model !

> > FWIW eg.
> >
> >      tbegin
> >      beq abort /* passes first time through */
> >      ....
> >      transactional stuff
> >      ....
> >      tend
> >      b pass
> >
> > abort:
> >
> > pass:
> 
> That's fine, and matches the x86 semantics fairly closely, except
> "xbegin" kind of "contains" that "jump to abort address". But we could
> definitely use the same models. Call it
> "transaction_begin/abort/end()", and it should be architecture-neutral
> naming-wise.

Right.

> Of course, if tbegin then acts basically like some crazy
> assembly-level setjmp (I'm guessing it does exactly, and presumably
> precisely that kind of compiler support - ie a function with
> "__attribute((returns_twice))" in gcc-speak), the overhead of doing it
> may kill it.

Well, all the registers are checkpointed so we *should* be ok but gcc
always makes me nervous in those circumstances ...

Ben.


>             Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


