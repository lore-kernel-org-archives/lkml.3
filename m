Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642AbaGQKEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 06:04:22 -0400
Received: from imap.thunk.org ([74.207.234.97]:40465 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755374AbaGQKES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 06:04:18 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: linux-crypto@vger.kernel.org, hpa@zytor.com,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH] random: limit the contribution of the hw rng to at most half
Date: Thu, 17 Jul 2014 06:03:56 -0400
Message-Id: <1405591436-15445-1-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 2.0.0
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For people who don't trust a hardware RNG which can not be audited,
the changes to add support for RDSEED can be troubling since 97% or
more of the entropy will be contributed from the in-CPU hardware RNG.

We now have a in-kernel khwrngd, so for those people who do want to
implicitly trust the CPU-based system, we could create an arch-rng
hw_random driver, and allow khwrng refill the entropy pool.  This
allows system administrator whether or not they trust the CPU (I
assume the NSA will trust RDRAND/RDSEED implicitly :-), and if so,
what level of entropy derating they want to use.

The reason why this is a really good idea is that if different people
use different levels of entropy derating, it will make it much more
difficult to design a backdoor'ed hwrng that can be generally
exploited in terms of the output of /dev/random when different attack
targets are using differing levels of entropy derating.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 drivers/char/random.c | 43 ++++---------------------------------------
 1 file changed, 4 insertions(+), 39 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 76a56f6..e7d7ac1 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -911,12 +911,13 @@ void add_interrupt_randomness(int irq, int irq_flags)
 
 	/*
 	 * If we have architectural seed generator, produce a seed and
-	 * add it to the pool.  For the sake of paranoia count it as
-	 * 50% entropic.
+	 * add it to the pool.  For the sake of paranoia don't let the
+	 * architectural seed generator dominate the input from the
+	 * interrupt noise.
 	 */
 	if (arch_get_random_seed_long(&seed)) {
 		__mix_pool_bytes(r, &seed, sizeof(seed));
-		credit += sizeof(seed) * 4;
+		credit = 1;
 	}
 	spin_unlock(&r->lock);
 
@@ -1328,37 +1329,6 @@ void rand_initialize_disk(struct gendisk *disk)
 }
 #endif
 
-/*
- * Attempt an emergency refill using arch_get_random_seed_long().
- *
- * As with add_interrupt_randomness() be paranoid and only
- * credit the output as 50% entropic.
- */
-static int arch_random_refill(void)
-{
-	const unsigned int nlongs = 64;	/* Arbitrary number */
-	unsigned int n = 0;
-	unsigned int i;
-	unsigned long buf[nlongs];
-
-	if (!arch_has_random_seed())
-		return 0;
-
-	for (i = 0; i < nlongs; i++) {
-		if (arch_get_random_seed_long(&buf[n]))
-			n++;
-	}
-
-	if (n) {
-		unsigned int rand_bytes = n * sizeof(unsigned long);
-
-		mix_pool_bytes(&input_pool, buf, rand_bytes);
-		credit_entropy_bits(&input_pool, rand_bytes*4);
-	}
-
-	return n;
-}
-
 static ssize_t
 _random_read(int nonblock, char __user *buf, size_t nbytes)
 {
@@ -1379,11 +1349,6 @@ _random_read(int nonblock, char __user *buf, size_t nbytes)
 			return n;
 
 		/* Pool is (near) empty.  Maybe wait and retry. */
-
-		/* First try an emergency refill */
-		if (arch_random_refill())
-			continue;
-
 		if (nonblock)
 			return -EAGAIN;
 
-- 
2.0.0

