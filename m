Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240AbaFNHP2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 03:15:28 -0400
Received: from imap.thunk.org ([74.207.234.97]:38704 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbaFNHPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 03:15:24 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, George Spelvin <linux@horizon.com>
Subject: [PATCH-v2 1/4] random: always update the entropy pool under the spinlock
Date: Sat, 14 Jun 2014 03:15:15 -0400
Message-Id: <1402730118-23122-1-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 2.0.0
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using lockless techniques introduced in commit
902c098a3663, use spin_trylock to try to grab entropy pool's lock.  If
we can't get the lock, then just try again on the next interrupt.

Based on discussions with George Spelvin.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: George Spelvin <linux@horizon.com>
---
 drivers/char/random.c | 44 +++++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 102c50d..01538b4 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -495,9 +495,8 @@ static void _mix_pool_bytes(struct entropy_store *r, const void *in,
 	tap4 = r->poolinfo->tap4;
 	tap5 = r->poolinfo->tap5;
 
-	smp_rmb();
-	input_rotate = ACCESS_ONCE(r->input_rotate);
-	i = ACCESS_ONCE(r->add_ptr);
+	input_rotate = r->input_rotate;
+	i = r->add_ptr;
 
 	/* mix one byte at a time to simplify size handling and churn faster */
 	while (nbytes--) {
@@ -524,9 +523,8 @@ static void _mix_pool_bytes(struct entropy_store *r, const void *in,
 		input_rotate = (input_rotate + (i ? 7 : 14)) & 31;
 	}
 
-	ACCESS_ONCE(r->input_rotate) = input_rotate;
-	ACCESS_ONCE(r->add_ptr) = i;
-	smp_wmb();
+	r->input_rotate = input_rotate;
+	r->add_ptr = i;
 
 	if (out)
 		for (j = 0; j < 16; j++)
@@ -845,7 +843,7 @@ void add_interrupt_randomness(int irq, int irq_flags)
 	__u32			input[4], c_high, j_high;
 	__u64			ip;
 	unsigned long		seed;
-	int			credit;
+	int			credit = 0;
 
 	c_high = (sizeof(cycles) > 4) ? cycles >> 32 : 0;
 	j_high = (sizeof(now) > 4) ? now >> 32 : 0;
@@ -860,36 +858,40 @@ void add_interrupt_randomness(int irq, int irq_flags)
 	if ((fast_pool->count & 63) && !time_after(now, fast_pool->last + HZ))
 		return;
 
-	fast_pool->last = now;
-
 	r = nonblocking_pool.initialized ? &input_pool : &nonblocking_pool;
+	if (!spin_trylock(&r->lock)) {
+		fast_pool->count--;
+		return;
+	}
+	fast_pool->last = now;
 	__mix_pool_bytes(r, &fast_pool->pool, sizeof(fast_pool->pool), NULL);
 
 	/*
+	 * If we have architectural seed generator, produce a seed and
+	 * add it to the pool.  For the sake of paranoia count it as
+	 * 50% entropic.
+	 */
+	if (arch_get_random_seed_long(&seed)) {
+		__mix_pool_bytes(r, &seed, sizeof(seed), NULL);
+		credit += sizeof(seed) * 4;
+	}
+	spin_unlock(&r->lock);
+
+	/*
 	 * If we don't have a valid cycle counter, and we see
 	 * back-to-back timer interrupts, then skip giving credit for
 	 * any entropy, otherwise credit 1 bit.
 	 */
-	credit = 1;
+	credit++;
 	if (cycles == 0) {
 		if (irq_flags & __IRQF_TIMER) {
 			if (fast_pool->last_timer_intr)
-				credit = 0;
+				credit--;
 			fast_pool->last_timer_intr = 1;
 		} else
 			fast_pool->last_timer_intr = 0;
 	}
 
-	/*
-	 * If we have architectural seed generator, produce a seed and
-	 * add it to the pool.  For the sake of paranoia count it as
-	 * 50% entropic.
-	 */
-	if (arch_get_random_seed_long(&seed)) {
-		__mix_pool_bytes(r, &seed, sizeof(seed), NULL);
-		credit += sizeof(seed) * 4;
-	}
-
 	credit_entropy_bits(r, credit);
 }
 
-- 
2.0.0

