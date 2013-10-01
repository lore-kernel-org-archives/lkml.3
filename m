Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab3JADOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 23:14:08 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:45099 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585Ab3JADOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 23:14:03 -0400
Date: Mon, 30 Sep 2013 20:13:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Michael Neuling <mikey@neuling.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Waiman Long <Waiman.Long@hp.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: Avoiding the dentry d_lock on final dput(), part deux:
 transactional memory
Message-ID: <20131001031356.GP19582@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+55aFwp-RAKEMVvbMG53C=kTMqS09NPXy1eP4xEUYZpvV8X5Q@mail.gmail.com>
 <1380581522.6396.20.camel@pasglop>
 <23118.1380587771@ale.ozlabs.ibm.com>
 <CA+55aFwi5sZK4mFxs3PT1wU4_vNzsLOFiocqi3g14fPamKXYsw@mail.gmail.com>
 <1380593103.6396.38.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380593103.6396.38.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100103-1542-0000-0000-000001E1D03A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 12:05:03PM +1000, Benjamin Herrenschmidt wrote:
> On Mon, 2013-09-30 at 17:56 -0700, Linus Torvalds wrote:
> > On Mon, Sep 30, 2013 at 5:36 PM, Michael Neuling <mikey@neuling.org> wrote:
> > >
> > > The scary part is that we to make all register volatile.  You were not
> > > that keen on doing this as there are a lot of places in exception
> > > entry/exit where we only save/restore a subset of the registers.  We'd
> > > need to catch all these.
> > 
> > Ugh. It's very possible it's not worth using for the kernel then. The
> > example I posted is normally fine *without* any transactional support,
> > since it's a very local per-dentry lock, and since we only take that
> > lock when the last reference drops (so it's not some common directory
> > dentry, it's a end-point file dentry). In fact, on ARM they just made
> > the cmpxchg much faster by making it entirely non-serializing (since
> > it only updates a reference count, there is no locking involved apart
> > from checking that the lock state is unlocked)

A memory-barrier-free cmpxchg() would be easy on Power as well.

> > So there is basically never any contention, and the transaction needs
> > to basically be pretty much the same cost as a "cmpxchg". It's not
> > clear if the intel TSX is good enough for that, and if you have to
> > save a lot of registers in order to use transactions on POWER8, I
> > doubt it's worthwhile.
> 
> Well we don't have to, I think Mikey wasn't totally clear about that
> "making all registers volatile" business :-) This is just something we
> need to handle in assembly if we are going to reclaim the suspended
> transaction.
> 
> So basically, what we need is something along the lines of
> enable_kernel_tm() which checks if there's a suspended user transaction
> and if yes, kills/reclaims it.
> 
> Then we also need to handle in our interrupt handlers that we have an
> active/suspended transaction from a kernel state, which we don't deal
> with at this point, and do whatever has to be done to kill it... we
> might get away with something simple if we can state that we only allow
> kernel transactions at task level and not from interrupt/softirq
> contexts, at least initially.

Call me a coward, but this is starting to sound a bit scary.  ;-)

> > We have very few - if any - locks where contention or even cache
> > bouncing is common or normal. Sure, we have a few particular loads
> > that can trigger it, but even that is becoming rare. So from a
> > performance standpoint, the target always needs to be "comparable to
> > hot spinlock in local cache".
> 
> I am not quite familiar with the performance profile of our
> transactional hardware. I think we should definitely try to hack
> something together for that dput() case and measure it.
> 
> > >> They also have interesting ordering semantics vs. locks, we need to be
> > >> a tad careful (as long as we don't access a lock variable
> > >> transactionally we should be ok. If we do, then spin_unlock needs a
> > >> stronger barrier).
> > >
> > > Yep.
> > 
> > Well, just about any kernel transaction will at least read the state
> > of a lock. Without that, it's generally totally useless. My dput()
> > example sequence very much verified that the lock was not held, for
> > example.
> > 
> > I'm not sure how that affects anything. The actual transaction had
> > better not be visible inside the locked region (ie as far as any lock
> > users go, transactions better all happen fully before or after the
> > lock, if they read the lock and see it being unlocked).
> > 
> > That said, I cannot see how POWER8 could possibly violate that rule.
> > The whole "transactions are atomic" is kind of the whole and only
> > point of a transaction. So I'm not sure what odd lock restrictions
> > POWER8 could have.
> 
> Has to do with the memory model :-(
> 
> I dug the whole story from my mbox and the situation is indeed as dire
> as feared. If the transaction reads the lock, then the corresponding
> spin_lock must have a full sync barrier in it instead of the current
> lighter one.
> 
> Now I believe we are already "on the fence" with our locks today since
> technically speaking, our unlock + lock sequence is *not* exactly a full
> barrier (it is only if it's the same lock I think)
> 
> CC'ing Paul McKenney here who's been chasing that issue. In the end, we
> might end up having to turn our locks into sync anyway

Well, there have been a lot of fixed software bugs since the last
suspicious sighting, but on the other hand, I am just now getting my
RCU testing going again on Power.  I would certainly feel better
about things if unlock-lock was really truly a full barrier, but
this clearly needs a clean sighting.

> Yay ! The isanity^Wjoy of an OO memory model !

;-) ;-) ;-)

							Thanx, Paul

> > > FWIW eg.
> > >
> > >      tbegin
> > >      beq abort /* passes first time through */
> > >      ....
> > >      transactional stuff
> > >      ....
> > >      tend
> > >      b pass
> > >
> > > abort:
> > >
> > > pass:
> > 
> > That's fine, and matches the x86 semantics fairly closely, except
> > "xbegin" kind of "contains" that "jump to abort address". But we could
> > definitely use the same models. Call it
> > "transaction_begin/abort/end()", and it should be architecture-neutral
> > naming-wise.
> 
> Right.
> 
> > Of course, if tbegin then acts basically like some crazy
> > assembly-level setjmp (I'm guessing it does exactly, and presumably
> > precisely that kind of compiler support - ie a function with
> > "__attribute((returns_twice))" in gcc-speak), the overhead of doing it
> > may kill it.
> 
> Well, all the registers are checkpointed so we *should* be ok but gcc
> always makes me nervous in those circumstances ...
> 
> Ben.
> 
> 
> >             Linus
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

