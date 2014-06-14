Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbaFNHPm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 03:15:42 -0400
Received: from imap.thunk.org ([74.207.234.97]:38706 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656AbaFNHPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 03:15:24 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, George Spelvin <linux@horizon.com>
Subject: [PATCH-v2 2/4] random: remove unneeded hash of a portion of the entropy pool
Date: Sat, 14 Jun 2014 03:15:16 -0400
Message-Id: <1402730118-23122-2-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402730118-23122-1-git-send-email-tytso@mit.edu>
References: <1402730118-23122-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We previously extracted a portion of the entropy pool in
mix_pool_bytes() and hashed it in to avoid racing CPU's from returning
duplicate random values.  Now that we are using a spinlock to prevent
this from happening, this is no longer necessary.  So remove it, to
simplify the code a bit.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: George Spelvin <linux@horizon.com>
---
 drivers/char/random.c | 51 ++++++++++++++++++++-------------------------------
 1 file changed, 20 insertions(+), 31 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 01538b4..a74c92a 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -481,9 +481,9 @@ static __u32 const twist_table[8] = {
  * the entropy is concentrated in the low-order bits.
  */
 static void _mix_pool_bytes(struct entropy_store *r, const void *in,
-			    int nbytes, __u8 out[64])
+			    int nbytes)
 {
-	unsigned long i, j, tap1, tap2, tap3, tap4, tap5;
+	unsigned long i, tap1, tap2, tap3, tap4, tap5;
 	int input_rotate;
 	int wordmask = r->poolinfo->poolwords - 1;
 	const char *bytes = in;
@@ -525,27 +525,23 @@ static void _mix_pool_bytes(struct entropy_store *r, const void *in,
 
 	r->input_rotate = input_rotate;
 	r->add_ptr = i;
-
-	if (out)
-		for (j = 0; j < 16; j++)
-			((__u32 *)out)[j] = r->pool[(i - j) & wordmask];
 }
 
 static void __mix_pool_bytes(struct entropy_store *r, const void *in,
-			     int nbytes, __u8 out[64])
+			     int nbytes)
 {
 	trace_mix_pool_bytes_nolock(r->name, nbytes, _RET_IP_);
-	_mix_pool_bytes(r, in, nbytes, out);
+	_mix_pool_bytes(r, in, nbytes);
 }
 
 static void mix_pool_bytes(struct entropy_store *r, const void *in,
-			   int nbytes, __u8 out[64])
+			   int nbytes)
 {
 	unsigned long flags;
 
 	trace_mix_pool_bytes(r->name, nbytes, _RET_IP_);
 	spin_lock_irqsave(&r->lock, flags);
-	_mix_pool_bytes(r, in, nbytes, out);
+	_mix_pool_bytes(r, in, nbytes);
 	spin_unlock_irqrestore(&r->lock, flags);
 }
 
@@ -737,13 +733,13 @@ void add_device_randomness(const void *buf, unsigned int size)
 
 	trace_add_device_randomness(size, _RET_IP_);
 	spin_lock_irqsave(&input_pool.lock, flags);
-	_mix_pool_bytes(&input_pool, buf, size, NULL);
-	_mix_pool_bytes(&input_pool, &time, sizeof(time), NULL);
+	_mix_pool_bytes(&input_pool, buf, size);
+	_mix_pool_bytes(&input_pool, &time, sizeof(time));
 	spin_unlock_irqrestore(&input_pool.lock, flags);
 
 	spin_lock_irqsave(&nonblocking_pool.lock, flags);
-	_mix_pool_bytes(&nonblocking_pool, buf, size, NULL);
-	_mix_pool_bytes(&nonblocking_pool, &time, sizeof(time), NULL);
+	_mix_pool_bytes(&nonblocking_pool, buf, size);
+	_mix_pool_bytes(&nonblocking_pool, &time, sizeof(time));
 	spin_unlock_irqrestore(&nonblocking_pool.lock, flags);
 }
 EXPORT_SYMBOL(add_device_randomness);
@@ -776,7 +772,7 @@ static void add_timer_randomness(struct timer_rand_state *state, unsigned num)
 	sample.cycles = random_get_entropy();
 	sample.num = num;
 	r = nonblocking_pool.initialized ? &input_pool : &nonblocking_pool;
-	mix_pool_bytes(r, &sample, sizeof(sample), NULL);
+	mix_pool_bytes(r, &sample, sizeof(sample));
 
 	/*
 	 * Calculate number of bits of randomness we probably added.
@@ -864,7 +860,7 @@ void add_interrupt_randomness(int irq, int irq_flags)
 		return;
 	}
 	fast_pool->last = now;
-	__mix_pool_bytes(r, &fast_pool->pool, sizeof(fast_pool->pool), NULL);
+	__mix_pool_bytes(r, &fast_pool->pool, sizeof(fast_pool->pool));
 
 	/*
 	 * If we have architectural seed generator, produce a seed and
@@ -872,7 +868,7 @@ void add_interrupt_randomness(int irq, int irq_flags)
 	 * 50% entropic.
 	 */
 	if (arch_get_random_seed_long(&seed)) {
-		__mix_pool_bytes(r, &seed, sizeof(seed), NULL);
+		__mix_pool_bytes(r, &seed, sizeof(seed));
 		credit += sizeof(seed) * 4;
 	}
 	spin_unlock(&r->lock);
@@ -954,7 +950,7 @@ static void _xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 				  ENTROPY_BITS(r), ENTROPY_BITS(r->pull));
 	bytes = extract_entropy(r->pull, tmp, bytes,
 				random_read_wakeup_bits / 8, rsvd_bytes);
-	mix_pool_bytes(r, tmp, bytes, NULL);
+	mix_pool_bytes(r, tmp, bytes);
 	credit_entropy_bits(r, bytes*8);
 }
 
@@ -1029,7 +1025,6 @@ static void extract_buf(struct entropy_store *r, __u8 *out)
 		unsigned long l[LONGS(20)];
 	} hash;
 	__u32 workspace[SHA_WORKSPACE_WORDS];
-	__u8 extract[64];
 	unsigned long flags;
 
 	/*
@@ -1058,15 +1053,9 @@ static void extract_buf(struct entropy_store *r, __u8 *out)
 	 * brute-forcing the feedback as hard as brute-forcing the
 	 * hash.
 	 */
-	__mix_pool_bytes(r, hash.w, sizeof(hash.w), extract);
+	__mix_pool_bytes(r, hash.w, sizeof(hash.w));
 	spin_unlock_irqrestore(&r->lock, flags);
 
-	/*
-	 * To avoid duplicates, we atomically extract a portion of the
-	 * pool while mixing, and hash one final time.
-	 */
-	sha_transform(hash.w, extract, workspace);
-	memset(extract, 0, sizeof(extract));
 	memset(workspace, 0, sizeof(workspace));
 
 	/*
@@ -1253,14 +1242,14 @@ static void init_std_data(struct entropy_store *r)
 	unsigned long rv;
 
 	r->last_pulled = jiffies;
-	mix_pool_bytes(r, &now, sizeof(now), NULL);
+	mix_pool_bytes(r, &now, sizeof(now));
 	for (i = r->poolinfo->poolbytes; i > 0; i -= sizeof(rv)) {
 		if (!arch_get_random_seed_long(&rv) &&
 		    !arch_get_random_long(&rv))
 			rv = random_get_entropy();
-		mix_pool_bytes(r, &rv, sizeof(rv), NULL);
+		mix_pool_bytes(r, &rv, sizeof(rv));
 	}
-	mix_pool_bytes(r, utsname(), sizeof(*(utsname())), NULL);
+	mix_pool_bytes(r, utsname(), sizeof(*(utsname())));
 }
 
 /*
@@ -1323,7 +1312,7 @@ static int arch_random_refill(void)
 	if (n) {
 		unsigned int rand_bytes = n * sizeof(unsigned long);
 
-		mix_pool_bytes(&input_pool, buf, rand_bytes, NULL);
+		mix_pool_bytes(&input_pool, buf, rand_bytes);
 		credit_entropy_bits(&input_pool, rand_bytes*4);
 	}
 
@@ -1413,7 +1402,7 @@ write_pool(struct entropy_store *r, const char __user *buffer, size_t count)
 		count -= bytes;
 		p += bytes;
 
-		mix_pool_bytes(r, buf, bytes, NULL);
+		mix_pool_bytes(r, buf, bytes);
 		cond_resched();
 	}
 
-- 
2.0.0

