Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933636AbaFIQLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 12:11:47 -0400
Received: from ns.horizon.com ([71.41.210.147]:64604 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752880AbaFIQLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 12:11:45 -0400
Date: 9 Jun 2014 12:11:43 -0400
Message-ID: <20140609161143.18566.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tytso@mit.edu
Subject: Re: [RFC PATCH] drivers/char/random.c: Is reducing locking range like this safe?
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
In-Reply-To: <20140609155046.GA8993@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, but again, if we're only adding a single bit's worth of entropy
> credit, then at worst we'll only be off by one.  And if the race is a
> 50-50 proposition (and I know life is not that simple; for example, it
> doesn't deal with N-way races), then we might not even be off by one.  :-)

Indeed.

> One other thing to consider is that we don't really need to care about
> how efficient RNGADDENTROPY needs to be.  So if necessary, we can put
> a mutex around that so that we know that there's only a single
> RNGADDENTROPY being processed at a time.  So if we need to play
> cmpxchg games to make sure the RNGADDENTROPY contribution doesn't get
> lost, and retry the input mixing multiple times if necessary, that's
> quite acceptable, so long as we can minimize the overhead on the
> add_interrupt_randomness() side of the path (and where again, if there
> is a 50-50 change that we lose the contribution from
> add_interrupt_randomness(), that's probably acceptable so long as we
> don't lose the RNGADDENTROPY contribution).

Yes, that was something I was thinking: if you can just *detect*
the collision, you can always retry the mixing in.

But getting the entropy accounting right is tricky.  I completely fail
to see how the current RNDADDENTROPY is race-free.  There's no attempt
at locking between the write_pool() and credit_entropy_bits_safe().
So a reader could sneak in and drain the pool, only to have us credit
it back up later.

Crediting either before or after the write_pool is unsafe; you
have to either wrap mutual exclusion around the whole thing,
or do a sort of 2-phase commit.

> Speaking of which, there's an even simpler solution that I've failed
> to consider.  We could simply use a trylock in
> add_interrupt_randomness(), and if we can't get the lock, decrement
> fast_pool->count so we try to transfer the entropy from the fast_pool
> to the entropy pool on the next interrupt.
> 
> Doh!  That solves all of the problems, and it's much simpler and
> easier to reason about.

That's exacty what I was talking about when I wrote (two e-mails ago):

>> While it's easy enough to have a special case for one interrupt handler,
>> there's one per processor that can be trying to write.  The obvious way
>> is to do a trylock of some sort from the interrupt handler and hold off
>> spilling the fast_pool if the attempt fails.  So there's a lock
>> of a sort, but no spinning on it.

We just used different terminology.  I used the more abstract "hold off
spilling the fast_pool" and you described a specific implementation technique
with "decrement fast_pool->count".

The whole "multiple concurrent writers" thing is probably overkill, but
it's fun to figure out how to do some of these things anyway.
