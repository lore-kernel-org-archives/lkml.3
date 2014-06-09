Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933446AbaFINRn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 09:17:43 -0400
Received: from ns.horizon.com ([71.41.210.147]:46966 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753348AbaFINRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 09:17:41 -0400
Date: 9 Jun 2014 09:17:38 -0400
Message-ID: <20140609131738.13625.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tytso@mit.edu
Subject: drivers/char/random.c: More futzing about
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
In-Reply-To: <20140609013553.GA1167@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just as an example of some more ambitious changes I'm playing with...

I really think the polynomial + twist has outlived its usefulness.
In particular, table lookups in infrequently accessed code are called
D-cache misses and are undesirable.  And the input_rotate is an ugly
kludge to compensate for inadequate mixing.

Here's an example of a smaller, faster, and better fast_mix() function.
The mix is invertible (thus preserving entropy), but causes each input
bit or pair of bits to avalanche to at least 43 bits after 2 rounds and
120 bit0 after 3.

For comparison, with the current linear fast_mix function, bits above
the 12th in the data words only affect 4 other bits after one repetition.

With 3 iterations, it runs in 2/3 the time of the current fast_mix
and is half the size: 84 bytes of object code as opposed to 168.

void fast_mix2(struct fast_pool *f, u32 const input[4])
{
	u32 a = f->pool[0] ^ input[0],  b = f->pool[1] ^ input[1];
	u32 c = f->pool[2] ^ input[2],  d = f->pool[3] ^ input[3];
	int i;

	for (i = 0; i < 3; i++) {
		/*
		 * Inspired by ChaCha's QuarterRound, but
		 * modified for much greater parallelism.
		 * Surprisingly, rotating a and c seems to work
		 * better than b and d.  And it runs faster.
		 */
		a += b;                 c += d;
		d ^= a;                 b ^= c;
		a = rol32(a, 15);       c = rol32(c, 21);

		a += b;                 c += d;
		d ^= a;                 b ^= c;
		a = rol32(a, 3);       c = rol32(c, 7);
	}
	f->pool[0] = a;  f->pool[1] = b;
	f->pool[2] = c;  f->pool[3] = d;
	f->count++;
}

Other good rotate sets:
score = 43/120/121: 23  6 18 11
score = 42/120/123: 17 15  4 24
score = 42/120/122:  4  7 19 17
score = 43/122/122: 24  6 16 12
score = 42/121/122: 25 22 11  8
score = 42/122/121: 16 20 11 23
score = 43/120/122:  8 11 17 19
score = 46/121/123: 15 21  3  7
score = 43/120/122:  7 11 15 21
score = 42/120/122:  7 10 17 13
score = 42/120/123: 11  3 18 23
score = 44/121/122: 20 10 26 24
score = 42/123/122: 10  5 18 21
score = 44/120/122: 26 21  7  9
score = 42/121/122: 21 11  7  8
score = 42/120/122: 11 11 27 19
score = 42/121/122:  6 18  4 27
score = 42/121/122: 13 23  3  4


If you want smaller code, or more flexibility in the number of rounds,
try (24 5 24 5) or (27 8 27 8).  The avalanche is only slightly worse,
but unrolling twice shaves a smidgen off the run time, so the extra 2
rotate constants come for free.

If you want something linear, there are better ways to get better mixing.
Here's one based on a period-2^128-1 xorshift generator:

void fast_mix3(struct fast_pool *f, u32 const input[4])
{
	u32 a = f->pool[0] ^ input[0];
	u32 b = f->pool[1] ^ input[1];
	u32 c = f->pool[2] ^ input[2];
	u32 d = f->pool[3] ^ input[3];

	/*
	 * See Marsagalia, "Xorshift RNGs".  Possible shift amounts
	 * are [5, 14, 1], [15, 4, 21], [23, 24, 3], [5, 12, 29].
	 */
	a ^= a<<15; a ^= a>>4 ^ d ^ d>>21; f->pool[0] = a;
	b ^= b<<15; b ^= b>>4 ^ a ^ a>>21; f->pool[1] = b;
	c ^= c<<15; c ^= c>>4 ^ b ^ b>>21; f->pool[2] = c;
	d ^= d<<15; d ^= d>>4 ^ c ^ c>>21; f->pool[3] = d;

	f->count++;
}

... However this is slower than 2 iterations of fast_mix2, and
doesn't avalanche as much.
