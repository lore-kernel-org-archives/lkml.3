Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab3JCCFT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 22:05:19 -0400
Received: from imap.thunk.org ([74.207.234.97]:41477 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279Ab3JCCFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 22:05:17 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: cryptography@metzdowd.com, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH] random: drop trickle mode
Date: Wed,  2 Oct 2013 22:05:15 -0400
Message-Id: <1380765915-31530-1-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.12.rc0.22.gcdd159b
In-Reply-To: <20131003020403.GA31463@thunk.org>
References: <20131003020403.GA31463@thunk.org>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The add_timer_randomness() used to drop into trickle mode when entropy
pool was estimated to be 87.5% full.  This was important when
add_timer_randomness() was used to sample interrupts.  It's not used
for this any more --- add_interrupt_randomness() now uses fast_mix()
instead.  By elimitating trickle mode, it allows us to fully utilize
entropy provided by add_input_randomness() and add_disk_randomness()
even when the input pool is above the old trickle threshold of 87.5%.

This helps to answer the criticism in [1] in their hypothetical
scenario where our entropy estimator was inaccurate, even though the
measurements in [2] seem to indicate that our entropy estimator given
real-life entropy collection is actually pretty good, albeit on the
conservative side (which was as it was designed).

[1] http://eprint.iacr.org/2013/338.pdf
[2] http://eprint.iacr.org/2012/251.pdf

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 drivers/char/random.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 790ce8d..8661c5c 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -282,10 +282,8 @@
 #define LONGS(x) (((x) + sizeof(unsigned long) - 1)/sizeof(unsigned long))
 
 /*
- * To allow fractional bits to be tracked, the following fields contain
- * this many fractional bits:
- *
- * entropy_count, trickle_thresh
+ * To allow fractional bits to be tracked, the entropy_count field is
+ * denominated in units of 1/8th bits.
  *
  * 2*(ENTROPY_SHIFT + log2(poolbits)) must <= 31, or the multiply in
  * credit_entropy_bits() needs to be 64 bits wide.
@@ -314,14 +312,6 @@ static int random_write_wakeup_thresh = 128;
 static int random_min_urandom_seed = 60;
 
 /*
- * When the input pool goes over trickle_thresh, start dropping most
- * samples to avoid wasting CPU time and reduce lock contention.
- */
-static const int trickle_thresh = (INPUT_POOL_WORDS * 28) << ENTROPY_SHIFT;
-
-static DEFINE_PER_CPU(int, trickle_count);
-
-/*
  * Originally, we used a primitive polynomial of degree .poolwords
  * over GF(2).  The taps for various sizes are defined below.  They
  * were chosen to be evenly spaced except for the last tap, which is 1
@@ -755,10 +745,6 @@ static void add_timer_randomness(struct timer_rand_state *state, unsigned num)
 	long delta, delta2, delta3;
 
 	preempt_disable();
-	/* if over the trickle threshold, use only 1 in 4096 samples */
-	if (ENTROPY_BITS(&input_pool) > trickle_thresh &&
-	    ((__this_cpu_inc_return(trickle_count) - 1) & 0xfff))
-		goto out;
 
 	sample.jiffies = jiffies;
 	sample.cycles = random_get_entropy();
-- 
1.7.12.rc0.22.gcdd159b

