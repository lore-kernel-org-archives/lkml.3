Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab3KCNdo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 08:33:44 -0500
Received: from imap.thunk.org ([74.207.234.97]:53768 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448Ab3KCNdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 08:33:18 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 2/4] random: make add_timer_randomness() fill the nonblocking pool first
Date: Sun,  3 Nov 2013 08:33:13 -0500
Message-Id: <1383485595-2020-3-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.12.rc0.22.gcdd159b
In-Reply-To: <1383485595-2020-1-git-send-email-tytso@mit.edu>
References: <1383485595-2020-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change add_timer_randomness() so that it directs incoming entropy to
the nonblocking pool first if it hasn't been fully initialized yet.
This matches the strategy we use in add_interrupt_randomness(), which
allows us to push the randomness where we need it the most during when
the system is first booting up, so that get_random_bytes() and
/dev/urandom become safe to use as soon as possible.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 drivers/char/random.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 51153fe..b578c03 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -761,6 +761,7 @@ static struct timer_rand_state input_timer_state;
  */
 static void add_timer_randomness(struct timer_rand_state *state, unsigned num)
 {
+	struct entropy_store	*r;
 	struct {
 		long jiffies;
 		unsigned cycles;
@@ -773,7 +774,8 @@ static void add_timer_randomness(struct timer_rand_state *state, unsigned num)
 	sample.jiffies = jiffies;
 	sample.cycles = random_get_entropy();
 	sample.num = num;
-	mix_pool_bytes(&input_pool, &sample, sizeof(sample), NULL);
+	r = nonblocking_pool.initialized ? &input_pool : &nonblocking_pool;
+	mix_pool_bytes(r, &sample, sizeof(sample), NULL);
 
 	/*
 	 * Calculate number of bits of randomness we probably added.
@@ -807,8 +809,7 @@ static void add_timer_randomness(struct timer_rand_state *state, unsigned num)
 		 * Round down by 1 bit on general principles,
 		 * and limit entropy entimate to 12 bits.
 		 */
-		credit_entropy_bits(&input_pool,
-				    min_t(int, fls(delta>>1), 11));
+		credit_entropy_bits(r, min_t(int, fls(delta>>1), 11));
 	}
 	preempt_enable();
 }
-- 
1.7.12.rc0.22.gcdd159b

