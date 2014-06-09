Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbaFIAFc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 20:05:32 -0400
Received: from ns.horizon.com ([71.41.210.147]:11244 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753102AbaFIAFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 20:05:25 -0400
Date: 8 Jun 2014 20:05:24 -0400
Message-ID: <20140609000524.19476.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: hpa@linux.intel.com, price@mit.edu, tytso@mit.edu
Subject: [RFC PATCH] drivers/char/random.c: Is reducing locking range like this safe?
Cc: linux@horizon.com, linux-kernel@vger.kernel.org, mingo@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a few assorted cleanups in-work, but I was thinking about the
following and it's led to some thinking about the (non-)usefulness
of the out[] buffer from _mix_pool_bytes.

The problem I started trying to solve is readers (entropy extractors)
monopolizing the pool lock and stalling writers (entropy mixers), which
are supposed to be fast and low overhead.

So I thought I could rely on the "out" buffer returned from
_mix_pool_bytes to make concurrent extractors produce different output.
That led to the patch below, which drops the lock during the main pool
hash and only locks around the mix-back.  (Using the mix_pool_bytes
wrapper rather than explicit locking and __mix_pool_bytes.)
But I'm not sure it's quite right.

Suppose we have a pool that's mostly all-zero, but has a small dense
high-entropy section, and no arch_get_random_long().  Narrowing the
lock lets concurrent readers get to the __mix_pool_bytes() mix-back
(last hunk of the diff) with identical SHA states.

With the original code, which fills out[] with data from just *after*
the add_ptr (i.e. the oldest portion of the pool), it's possible for
multiple readers to obtain all-zero out[] buffers and return identical
hashes.

(Or, in a less extreme case, very low-entropy out[] buffers and
strongly correlated outputs.  I'll keep using "all-zero" to make
the examples simpler, and assume people can see the extrapolation.)

Well, okay, I think, easily fixed (included in the patch below):
change it to return the most recently modified section just *before*
the add_ptr, which includes the previus extractor's SHA hash.  That
way, I'm guaranteed to get different data on multiple concurrent
calls and everything is okay.

But is it?

Suppose I have three concurrent callers.  (I need three because the
hash folding covers up the problem with two.)  The pool contains
30 bytes of entropy, so it should be possible to return uncorrelated
outputs to each of them, but as mentioned that's in a small dense
region of the pool and the area around add_ptr is all zeros.

Each hashes the pool to obtain identical 20-byte SHA-1 hashes.  Then they
serialize arond calls to _mix_pool_bytes.  The first gets zeros in out[],
the second gets the first's SHA-1 hash and so generates a different hash,
and the third gets the second's SHA-1 hash.

So they all produce different outputs, but the outputs (totalling 30
bytes) passed through a 20-byte choke point and so have at most 20 bytes
of entropy between them.  This violates the /dev/random security goals.


Here are the solutions I've been thinking about:

1) Continue to lock the entire hashing operation.

   As long as we do this, the out[] parameter to _mix_pool_bytes is
   unnecessary and should be deleted.  Since the pool can't change
   between the bulk hash and the hash of out[], there's no point to
   re-hashing some data that was just hashed.  (You are sampling the
   add_ptr, which differs between callers, but that's negligible.)

   One way to address my concern would be to split r->lock into
   r->mix_lock and r->extract_lock.  Extractors would obtain the
   latter for the entire hash, and only obtain the mix_lock
   for the brief mix-back operation.

   The downside, of course, is a second lock on the extract path, but
   given that the efficiency of the extract path is not a design goal,
   perhaps that's fine.

2) Shrink the lock and add a nonce (like a CPUID) to the *initial* SHA state.

   This is fun because of its greater cryptographic cleverness,
   but that means it should be discussed carefully first.

   Due to the non-linearity of SHA hashing, this would result in
   the concurrent hashes sampling different parts of the pool's
   entropy, and the 20-byte entropy bottleneck would disappear.

   But in this case, the out[] buffer also does not contribute to
   the security guarantee and could also disappear.

Thoughts, anyone?

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 102c50d..d847367 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -499,6 +499,15 @@ static void _mix_pool_bytes(struct entropy_store *r, const void *in,
 	input_rotate = ACCESS_ONCE(r->input_rotate);
 	i = ACCESS_ONCE(r->add_ptr);
 
+	/*
+	 * Out gets a copy of the portion of the pool most recently
+	 * modified by previous writers.  Since add_ptr counts down,
+	 * this is at positive offsets from the initial value.
+	 */
+	if (out)
+		for (j = 0; j < 16; j++)
+			((__u32 *)out)[j] = r->pool[(i + j) & wordmask];
+
 	/* mix one byte at a time to simplify size handling and churn faster */
 	while (nbytes--) {
 		w = rol32(*bytes++, input_rotate);
@@ -527,10 +536,6 @@ static void _mix_pool_bytes(struct entropy_store *r, const void *in,
 	ACCESS_ONCE(r->input_rotate) = input_rotate;
 	ACCESS_ONCE(r->add_ptr) = i;
 	smp_wmb();
-
-	if (out)
-		for (j = 0; j < 16; j++)
-			((__u32 *)out)[j] = r->pool[(i - j) & wordmask];
 }
 
 static void __mix_pool_bytes(struct entropy_store *r, const void *in,
@@ -1043,7 +1048,6 @@ static void extract_buf(struct entropy_store *r, __u8 *out)
 	}
 
 	/* Generate a hash across the pool, 16 words (512 bits) at a time */
-	spin_lock_irqsave(&r->lock, flags);
 	for (i = 0; i < r->poolinfo->poolwords; i += 16)
 		sha_transform(hash.w, (__u8 *)(r->pool + i), workspace);
 
@@ -1056,8 +1060,7 @@ static void extract_buf(struct entropy_store *r, __u8 *out)
 	 * brute-forcing the feedback as hard as brute-forcing the
 	 * hash.
 	 */
-	__mix_pool_bytes(r, hash.w, sizeof(hash.w), extract);
-	spin_unlock_irqrestore(&r->lock, flags);
+	mix_pool_bytes(r, hash.w, sizeof(hash.w), extract);
 
 	/*
 	 * To avoid duplicates, we atomically extract a portion of the
