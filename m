Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964831AbaFIPEa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 11:04:30 -0400
Received: from ns.horizon.com ([71.41.210.147]:45765 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S964810AbaFIPE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 11:04:28 -0400
Date: 9 Jun 2014 11:04:26 -0400
Message-ID: <20140609150426.3885.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tytso@mit.edu
Subject: Re: [RFC PATCH] drivers/char/random.c: Is reducing locking range like this safe?
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
In-Reply-To: <20140609133448.GA8418@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Actually, if you look very closely, or take a look at the commit
> description for 902c098a3663de, you'll see that we're actually
> updating the entropy pool from add_interrupt_randomness() w/o taking
> any locks.  So that's actually not a problem.

Arrgh... I could swear I saw a path that locked, but now that I look
again I can't see it.  I think you're right and I was hallucinating.

Nice work on credit_entropy_bits, BTW.

> What could be a problem is if we get really unlucky (an interrupt
> update happening at the same time as an update from rngd), it's
> possible we could end up with an entropy addition getting lost.  It's
> not such a big deal if a contribution from add_interrupt_randomness()
> gets lost, since we only giving one bit worth of entropy credit.  But
> it's possible than a much larger input from rngd could potentially end
> up getting overwritten from the fast_pool contribution.

What I can't see in the code is how that case is detected and the entropy
credit suppressed.

I just want to be sure I understand your use of the word "overwritten".
There's the entropy itself, and the associated credit.

I'm taking about the fact that _mix_pool_bytes can cause the
actual entropy bits to get overwritten in the pool if two writers
race each other.

As you say, it's always possible to fall back to zero credit,
but you have to *detect* the situation, and I'm not sure how
that happens.

While it's easy enough to have a special case for one interrupt handler,
there's one per processor that can be trying to write.  The obvious way
is to do a trylock of some sort from the interrupt handler and hold off
spilling the fast_pool if the attempt fails.  So there's a lock
of a sort, but no spinning on it.

> This isn't a disaster per se, but it probably means that it's worth
> taking a closer look at how we do the entropy pool mixing input to see
> if we can actually a make a fully lockless add_entropy work correctly.
> One approach might be to use atomics but of course then we have to
> balance the increased overhead of using atomic_t types versus the
> locking overhead.

Doing it really right, including clamping at the endpoints, is
extremely tricky in the face of concurrent access.

Consider the case of a full pool, and a concurrent write and read
of a full pool's worth of entropy.

If the write wins the race, it overfills the pool, so may not give
any credit, and the read them empties it.

If the read wins the race, it empties the pool, and then the write
refills it.

But if there's no enforced serialization, the final condition is
that the amount of entropy in the pool is completely unknown;
it could be anything.


The implementation that seems most obvious to me, if we can have the
readers and the writers cooperating at least, uses monotonically
increasing head and tail counters, with (head - tail) being the current
entropy budget.

To handle concurrent update, the head counter is split in two,
into head_max and head_min.  The "max" is incremented before the
pool itself is accessed, and the "min" is incremented after.

When adding, the writer looks at the tail and chooses an amount
to credit that will not overflow the pool.  Then increments head_max,
mixes in to the pool, and finally lets head_min catch up.

When extracting, the reader first blocks (if desired) on head_min.

Then the extractor does the extract and advances the tail by the
amount extracted, but no more than head_max after the extract.



Oh!  I just realized that concurrent mix_pool_bytes can be handled with
a similar scheme.  (To be clear, I've jumped from talking about entropy
accounting back to pool mixing.)

*If* we can bound the total number of bytes to be concurrently
mixed in to the pool to the size of the pool, then you can
assign ranges of bytes to write using a osrt of ticket lock.

Each adder bumps the add_ptr atomically by the amount of data they
want to add, masks the pre-incrmeent counter value, and uses that
to determine the area of the pool they will be updating.

What gets nasty is if you have a large SMP system and more writers
than can be handled thus.  Because there's no guarantee on the
order that writers will *finish*, there's no simple way to keep
track of adds completed and thereby know if an additional writer
has room to work.

I can't just atomically increment the completed index when I finish adding,
because that could be misleading.  If processor A reads the add_ptr
as 10 and increments it to 20, then processor B reads the add_ptr as
20 and increments it to 30, everything is fine so far.

But if processor B finishes first and increments the adds_completetd
index to 20, it's lying: the range from 10 to 20 is still busy and
attempting to access it will lead to trouble.

Ah!  It turns out that there is a simple technique after all.
I have three add counters, and due to lack of imagination thinking
of good descriptive names, I'll call them add1, add2 and add3.

add1-add2 is the amount of outstanding writes in progress.  The location
of the writes is not known, excpe that it's somewhere between add3 and add1.

The invariant is add3 <= add2 <= add1.

add1 is the ticket lock.  A would-be writer checks that it is
not trying to increment add1 to more than add3+POOLSIZE, and
if so does an atomic fetch-and-add on add1.

This tells it the range of the pool it's allowed to write to.  All good,
and it does the appropriate update.

When the write complete, atomically bump add2.  Then check if add2 ==
add1.  If not, return.  If they are equal, set add3 to the shared value,
collapsing the "writes in progress somewhere in this range" window.

This would be bad TCP, preiodically collapsing the window, but it
should be fine for an entropy pool.
