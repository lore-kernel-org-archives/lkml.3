Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab3LNV4X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 16:56:23 -0500
Received: from science.horizon.com ([71.41.210.146]:19193 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753906Ab3LNV4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 16:56:03 -0500
Date: 14 Dec 2013 16:55:59 -0500
Message-ID: <20131214215559.10128.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tytso@mit.edu
Subject: Re: Replace /dev/random input mix polynomial with Brent's xorgen?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20131214192307.GA10457@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The mixing function doesn't have to be a good quality PRNG, since
> that's not its function.  One of the things that is highly desirable,
> though, is that it "smears" recently mixed in data across the entire
> pool as quickly as possible.  The above algorithm is more efficient
> because it only needs to touch two memory locations --- but for our
> use case, we want to be able to read from multiple memory locations.

Actually, there is one aspect in which it is desirable that it is a
good-quality PRNG, but it's something of an inversion of the usual
PRNG goal.

It doesn't actually matter how large an effect input entropy has on
the pool.  Just toggling one bit is the same as affecting many bits;
achieving avalanche is the *output* hash's job.

What's critical for the input hash is that seed additions don't cancel
each other.  That is, XORing in some new seed material doesn't hit
the same bits as older seed material.  What's key is not exactly that
additions affect lots of bits as that *different* additions affect
*different* groups of bits.  In other words, differentials rather than
single-bit avalanches,

A "good-quality PRNG" is a way of expressing this property.  Good
distribution and avoidance of correlation of outputs turns into good
distribution of *inputs* and avoidance of cancellation.

I agree that *maximal* period is not particularly important; all that's
needed is "long enough".  But it's not exactly an *undesirable* property,
either.

> In particular, it's important that when we mix the hash back into pool
> to prevent backtracking attacks, and extract from the pool again and
> re-hash (see extract_entropy), it's important that when we mix in the
> hash, it affects the portion of the pool that we rehash.  We could
> work around this if we changed the mixing function, true, but I'm not
> sure I see the benefit of making this change.

Er, yes, I wasn't planning on breaking that...
(Although I do have some code cleanup patches in that area that have
been sitting in my tree for a long time that I should submit,)

> I'm much more inclined to think about changing how we generate random
> numbers from the output pool by switching from using SHA to AES in
> some one-way random function mode (i.e., such as the Davies-Meyer
> construction), since that is where we are spending most of our CPU
> time in the random driver at the moment.

The SHA-3 competition has given us lots of random permutations and
random functions.  Keccak, Salsa20/ChaCha, Skein/Threefish and SipHash
are all interesting looking.  AES/Rijndael is actually less so, unless
you're planning on using hardware support, because of cache timing
attacks on the lookup tables it needs for software implementation.

I've also ported the Skein rotate function finding program to 32 bits
(it's not as simple as changing the BITS_PER_WORD define at the top
of the file!) and have been finding 32-bit threefish rotate values.
