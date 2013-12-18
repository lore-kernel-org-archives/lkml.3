Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab3LRFaq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 00:30:46 -0500
Received: from imap.thunk.org ([74.207.234.97]:41177 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753370Ab3LRFan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 00:30:43 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-kernel@vger.kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH] random: use the architectural HWRNG for the SHA's IV in extract_buf()
Date: Wed, 18 Dec 2013 00:30:14 -0500
Message-Id: <1387344614-19544-1-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.8.5.rc3.362.gdf10213
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To help assuage the fears of those who think the NSA can introduce a
massive hack into the instruction decode and out of order execution
engine in the CPU without hundreds of Intel engineers knowing about
it (only one of which woud need to have the conscience and courage of
Edward Snowden to spill the beans to the public), use the HWRNG to
initialize the SHA starting value, instead of xor'ing it in
afterwards.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 drivers/char/random.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 8cc7d65..d07575c 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1012,23 +1012,23 @@ static void extract_buf(struct entropy_store *r, __u8 *out)
 	__u8 extract[64];
 	unsigned long flags;
 
-	/* Generate a hash across the pool, 16 words (512 bits) at a time */
-	sha_init(hash.w);
-	spin_lock_irqsave(&r->lock, flags);
-	for (i = 0; i < r->poolinfo->poolwords; i += 16)
-		sha_transform(hash.w, (__u8 *)(r->pool + i), workspace);
-
 	/*
 	 * If we have an architectural hardware random number
-	 * generator, mix that in, too.
+	 * generator, use it for SHA's initial vector
 	 */
+	sha_init(hash.w);
 	for (i = 0; i < LONGS(20); i++) {
 		unsigned long v;
 		if (!arch_get_random_long(&v))
 			break;
-		hash.l[i] ^= v;
+		hash.l[i] = v;
 	}
 
+	/* Generate a hash across the pool, 16 words (512 bits) at a time */
+	spin_lock_irqsave(&r->lock, flags);
+	for (i = 0; i < r->poolinfo->poolwords; i += 16)
+		sha_transform(hash.w, (__u8 *)(r->pool + i), workspace);
+
 	/*
 	 * We mix the hash back into the pool to prevent backtracking
 	 * attacks (where the attacker knows the state of the pool
-- 
1.8.5.rc3.362.gdf10213

