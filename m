Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933501AbaFIPuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 11:50:54 -0400
Received: from imap.thunk.org ([74.207.234.97]:57647 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932675AbaFIPuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 11:50:52 -0400
Date: Mon, 9 Jun 2014 11:50:46 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: George Spelvin <linux@horizon.com>
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
Subject: Re: [RFC PATCH] drivers/char/random.c: Is reducing locking range
 like this safe?
Message-ID: <20140609155046.GA8993@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	George Spelvin <linux@horizon.com>, hpa@linux.intel.com,
	linux-kernel@vger.kernel.org, mingo@kernel.org, price@MIT.EDU
References: <20140609133448.GA8418@thunk.org>
 <20140609150426.3885.qmail@ns.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140609150426.3885.qmail@ns.horizon.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 11:04:26AM -0400, George Spelvin wrote:
> > What could be a problem is if we get really unlucky (an interrupt
> > update happening at the same time as an update from rngd), it's
> > possible we could end up with an entropy addition getting lost.  It's
> > not such a big deal if a contribution from add_interrupt_randomness()
> > gets lost, since we only giving one bit worth of entropy credit.  But
> > it's possible than a much larger input from rngd could potentially end
> > up getting overwritten from the fast_pool contribution.
> 
> What I can't see in the code is how that case is detected and the entropy
> credit suppressed.

Sorry, I didn't make myself clear.  In the common case where we don't
have rngd running, and so we only have add_interrupt_randomness()
racing with itself, what's at stake is only one bit of entropy credit.
In the absolute worse case, where two CPU's run
add_interrupt_randomness() at the the exact same time (after servicing
different irq's), what can happen is that both cpu's will get the same
add_ptr, and so both CPU's will end up updating the same portion of
the entropy pool, and so one CPU's worth of add_interrupt_randomness()
will get lost by being overwritten by the other CPU's updates.  This
means that we will have given two bits worth of entropy credit, but
only one add_interrupt_randomness()'s worth of updates.  Given that
the single bit of entropy bit credits was being very conservative to
begin with, it's not such a big deal.

However, and this is the case I failed to consider when I made this
change almost two years ago, is what happens if you have one updater
coming from add_interrupt_randomness(), and another one coming from
rngd calling RNGADDENTROPY ioctl.  Now if add_interrupt_randomness()
wins the race and all of the entropy pool updates are coming from it,
then the entropy credit coming from RNDADDENTROPY will be credited to
the pool without the contribution from rngd being actually added to
the pool, since those contributions might have gotten overwritten by
add_interrupt_randomness().

So I was't saying that we could detect the situation; it's just that
in cases where we aren't adding any credit anyway, or as in the case
of add_interrupt_randomness() racing with each other, it's 50-50 with
CPU will win the race, and so an adversary which can't predict which
CPU's contribution to the entropy pool will actually "win" has to
explore both possibilities, and that mitigates the fact that entropy
count might be bumped without the corresponding entropy having been
added.

But there is the RNGADDENTROPY icotl case where this reasoning doesn't
hold, and that's the case which I'm now worried about.

> Consider the case of a full pool, and a concurrent write and read
> of a full pool's worth of entropy.
> 
> If the write wins the race, it overfills the pool, so may not give
> any credit, and the read them empties it.
> 
> If the read wins the race, it empties the pool, and then the write
> refills it.

Yes, but again, if we're only adding a single bit's worth of entropy
credit, then at worst we'll only be off by one.  And if the race is a
50-50 proposition (and I know life is not that simple; for example, it
doesn't deal with N-way races), then we might not even be off by one.  :-)

One other thing to consider is that we don't really need to care about
how efficient RNGADDENTROPY needs to be.  So if necessary, we can put
a mutex around that so that we know that there's only a single
RNGADDENTROPY being processed at a time.  So if we need to play
cmpxchg games to make sure the RNGADDENTROPY contribution doesn't get
lost, and retry the input mixing multiple times if necessary, that's
quite acceptable, so long as we can minimize the overhead on the
add_interrupt_randomness() side of the path (and where again, if there
is a 50-50 change that we lose the contribution from
add_interrupt_randomness(), that's probably acceptable so long as we
don't lose the RNGADDENTROPY contribution).

Come to think of it, something that we 

> Ah!  It turns out that there is a simple technique after all.
> I have three add counters, and due to lack of imagination thinking
> of good descriptive names, I'll call them add1, add2 and add3.
> 
> add1-add2 is the amount of outstanding writes in progress.  The location
> of the writes is not known, excpe that it's somewhere between add3 and add1.
> 
> The invariant is add3 <= add2 <= add1.
> 
> add1 is the ticket lock.  A would-be writer checks that it is
> not trying to increment add1 to more than add3+POOLSIZE, and
> if so does an atomic fetch-and-add on add1.
> 
> This tells it the range of the pool it's allowed to write to.  All good,
> and it does the appropriate update.
> 
> When the write complete, atomically bump add2.  Then check if add2 ==
> add1.  If not, return.  If they are equal, set add3 to the shared value,
> collapsing the "writes in progress somewhere in this range" window.

I need to think about this more, but that's clever!  And if we end up
having to throw away a contribution from add_interrupt_entropy(),
that's fine.

Speaking of which, there's an even simpler solution that I've failed
to consider.  We could simply use a trylock in
add_interrupt_randomness(), and if we can't get the lock, decrement
fast_pool->count so we try to transfer the entropy from the fast_pool
to the entropy pool on the next interrupt.

Doh!  That solves all of the problems, and it's much simpler and
easier to reason about.

						- Ted
