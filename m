Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab3IVUjy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 16:39:54 -0400
Received: from imap.thunk.org ([74.207.234.97]:35984 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027Ab3IVUjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 16:39:19 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: hpa@zytor.com, joern@logfs.org, macro@linux-mips.org, ralf@linux-mips.org,
        dave.taht@gmail.com, blogic@openwrt.org, andrewmcgr@gmail.com,
        smueller@chronox.de, geert@linux-m68k.org, tg@mirbsd.de,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH, RFC 08/12] random: mix in architectural randomness earlier in extract_buf()
Date: Sun, 22 Sep 2013 16:38:54 -0400
Message-Id: <1379882338-7209-9-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.12.rc0.22.gcdd159b
In-Reply-To: <1379882338-7209-1-git-send-email-tytso@mit.edu>
References: <1379882338-7209-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously if CPU chip had a built-in random number generator (i.e.,
RDRAND on newer x86 chips), we mixed it in at the very end of
extract_buf() using an XOR operation.

We now mix it in right after the calculate a hash across the entire
pool.  This has the advantage that any contribution of entropy from
the CPU's HWRNG will get mixed back into the pool.  In addition, it
means that if the HWRNG has any defects (either accidentally or
maliciously introduced), this will be mitigated via the non-linear
transform of the SHA-1 hash function before we hand out generated
output.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 drivers/char/random.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index ba23d5c..6d5e8e6 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -993,6 +993,17 @@ static void extract_buf(struct entropy_store *r, __u8 *out)
 		sha_transform(hash.w, (__u8 *)(r->pool + i), workspace);
 
 	/*
+	 * If we have a architectural hardware random number
+	 * generator, mix that in, too.
+	 */
+	for (i = 0; i < LONGS(EXTRACT_SIZE); i++) {
+		unsigned long v;
+		if (!arch_get_random_long(&v))
+			break;
+		hash.l[i] ^= v;
+	}
+
+	/*
 	 * We mix the hash back into the pool to prevent backtracking
 	 * attacks (where the attacker knows the state of the pool
 	 * plus the current outputs, and attempts to find previous
@@ -1021,17 +1032,6 @@ static void extract_buf(struct entropy_store *r, __u8 *out)
 	hash.w[1] ^= hash.w[4];
 	hash.w[2] ^= rol32(hash.w[2], 16);
 
-	/*
-	 * If we have a architectural hardware random number
-	 * generator, mix that in, too.
-	 */
-	for (i = 0; i < LONGS(EXTRACT_SIZE); i++) {
-		unsigned long v;
-		if (!arch_get_random_long(&v))
-			break;
-		hash.l[i] ^= v;
-	}
-
 	memcpy(out, &hash, EXTRACT_SIZE);
 	memset(&hash, 0, sizeof(hash));
 }
-- 
1.7.12.rc0.22.gcdd159b

