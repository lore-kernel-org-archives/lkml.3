Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267AbaFKDa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 23:30:28 -0400
Received: from imap.thunk.org ([74.207.234.97]:60944 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755400AbaFKDaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 23:30:25 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-kernel@vger.kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>, George Spelvin <linux@horizon.com>
Subject: [PATCH 1/3] random: always update the entropy pool under the spinlock
Date: Tue, 10 Jun 2014 23:30:18 -0400
Message-Id: <1402457420-2527-2-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402457420-2527-1-git-send-email-tytso@mit.edu>
References: <1402457420-2527-1-git-send-email-tytso@mit.edu>
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
 drivers/char/random.c | 40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 102c50d..76d2f53 100644
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
@@ -860,17 +858,31 @@ void add_interrupt_randomness(int irq, int irq_flags)
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
+	credit = 1;
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
 	if (cycles == 0) {
 		if (irq_flags & __IRQF_TIMER) {
 			if (fast_pool->last_timer_intr)
@@ -880,16 +892,6 @@ void add_interrupt_randomness(int irq, int irq_flags)
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

