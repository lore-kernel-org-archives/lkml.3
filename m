Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab3IVUk6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 16:40:58 -0400
Received: from imap.thunk.org ([74.207.234.97]:35974 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223Ab3IVUjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 16:39:18 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: hpa@zytor.com, joern@logfs.org, macro@linux-mips.org, ralf@linux-mips.org,
        dave.taht@gmail.com, blogic@openwrt.org, andrewmcgr@gmail.com,
        smueller@chronox.de, geert@linux-m68k.org, tg@mirbsd.de,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        DJ Johnston <dj.johnston@intel.com>, <stable@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH, RFC 04/12] random: Account for entropy loss due to overwrites
Date: Sun, 22 Sep 2013 16:38:50 -0400
Message-Id: <1379882338-7209-5-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.12.rc0.22.gcdd159b
In-Reply-To: <1379882338-7209-1-git-send-email-tytso@mit.edu>
References: <1379882338-7209-1-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

When we write entropy into a non-empty pool, we currently don't
account at all for the fact that we will probabilistically overwrite
some of the entropy in that pool.  This means that unless the pool is
fully empty, we are currently *guaranteed* to overestimate the amount
of entropy in the pool!

Assuming Shannon entropy with zero correlations we end up with an
exponentally decaying value of new entropy added:

	entropy <- entropy + (pool_size - entropy) *
		(1 - exp(-add_entropy/pool_size))

However, calculations involving fractional exponentials are not
practical in the kernel, so apply a piecewise linearization:

	  For add_entropy <= pool_size/2 then

	  (1 - exp(-add_entropy/pool_size)) >= (add_entropy/pool_size)*0.7869...

	  ... so we can approximate the exponential with
	  3/4*add_entropy/pool_size and still be on the
	  safe side by adding at most pool_size/2 at a time.

In order for the loop not to take arbitrary amounts of time if a bad
ioctl is received, terminate if we are within one bit of full.  This
way the loop is guaranteed to terminate after no more than
log2(poolsize) iterations, no matter what the input value is.  The
vast majority of the time the loop will be executed exactly once.

The piecewise linearization is very conservative, approaching 3/4 of
the usable input value for small inputs, however, our entropy
estimation is pretty weak at best, especially for small values; we
have no handle on correlation; and the Shannon entropy measure (Rényi
entropy of order 1) is not the correct one to use in the first place,
but rather the correct entropy measure is the min-entropy, the Rényi
entropy of infinite order.

As such, this conservatism seems more than justified.

This does introduce fractional bit values.  I have left it to have 3
bits of fraction, so that with a pool of 2^12 bits the multiply in
credit_entropy_bits() can still fit into an int, as 2*(3+12) < 31.  It
is definitely possible to allow for more fractional accounting, but
that multiply then would have to be turned into a 32*32 -> 64 multiply.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: DJ Johnston <dj.johnston@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 drivers/char/random.c | 60 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 52 insertions(+), 8 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 1547338..75f04d5 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -272,10 +272,12 @@
 /*
  * Configuration information
  */
-#define INPUT_POOL_WORDS 128
-#define OUTPUT_POOL_WORDS 32
-#define SEC_XFER_SIZE 512
-#define EXTRACT_SIZE 10
+#define INPUT_POOL_SHIFT	12
+#define INPUT_POOL_WORDS	(1 << (INPUT_POOL_SHIFT-5))
+#define OUTPUT_POOL_SHIFT	10
+#define OUTPUT_POOL_WORDS	(1 << (OUTPUT_POOL_SHIFT-5))
+#define SEC_XFER_SIZE		512
+#define EXTRACT_SIZE		10
 
 #define LONGS(x) (((x) + sizeof(unsigned long) - 1)/sizeof(unsigned long))
 
@@ -284,6 +286,9 @@
  * this many fractional bits:
  *
  * entropy_count, trickle_thresh
+ *
+ * 2*(ENTROPY_SHIFT + log2(poolbits)) must <= 31, or the multiply in
+ * credit_entropy_bits() needs to be 64 bits wide.
  */
 #define ENTROPY_SHIFT 3
 
@@ -426,7 +431,7 @@ module_param(debug, bool, 0644);
 struct entropy_store;
 struct entropy_store {
 	/* read-only data: */
-	struct poolinfo *poolinfo;
+	const struct poolinfo *poolinfo;
 	__u32 *pool;
 	const char *name;
 	struct entropy_store *pull;
@@ -595,6 +600,8 @@ static void fast_mix(struct fast_pool *f, const void *in, int nbytes)
 static void credit_entropy_bits(struct entropy_store *r, int nbits)
 {
 	int entropy_count, orig;
+	const int pool_size = r->poolinfo->poolfracbits;
+	int nfrac = nbits << ENTROPY_SHIFT;
 
 	if (!nbits)
 		return;
@@ -602,13 +609,50 @@ static void credit_entropy_bits(struct entropy_store *r, int nbits)
 	DEBUG_ENT("added %d entropy credits to %s\n", nbits, r->name);
 retry:
 	entropy_count = orig = ACCESS_ONCE(r->entropy_count);
-	entropy_count += nbits << ENTROPY_SHIFT;
+	if (nfrac < 0) {
+		/* Debit */
+		entropy_count += nfrac;
+	} else {
+		/*
+		 * Credit: we have to account for the possibility of
+		 * overwriting already present entropy.	 Even in the
+		 * ideal case of pure Shannon entropy, new contributions
+		 * approach the full value asymptotically:
+		 *
+		 * entropy <- entropy + (pool_size - entropy) *
+		 *	(1 - exp(-add_entropy/pool_size))
+		 *
+		 * For add_entropy <= pool_size/2 then
+		 * (1 - exp(-add_entropy/pool_size)) >=
+		 *    (add_entropy/pool_size)*0.7869...
+		 * so we can approximate the exponential with
+		 * 3/4*add_entropy/pool_size and still be on the
+		 * safe side by adding at most pool_size/2 at a time.
+		 *
+		 * The use of pool_size-2 in the while statement is to
+		 * prevent rounding artifacts from making the loop
+		 * arbitrarily long; this limits the loop to log2(pool_size)*2
+		 * turns no matter how large nbits is.
+		 */
+		int pnfrac = nfrac;
+		const int s = r->poolinfo->poolbitshift + ENTROPY_SHIFT + 2;
+		/* The +2 corresponds to the /4 in the denominator */
+
+		do {
+			unsigned int anfrac = min(pnfrac, pool_size/2);
+			unsigned int add =
+				((pool_size - entropy_count)*anfrac*3) >> s;
+
+			entropy_count += add;
+			pnfrac -= anfrac;
+		} while (unlikely(entropy_count < pool_size-2 && pnfrac));
+	}
 
 	if (entropy_count < 0) {
 		DEBUG_ENT("negative entropy/overflow\n");
 		entropy_count = 0;
-	} else if (entropy_count > r->poolinfo->poolfracbits)
-		entropy_count = r->poolinfo->poolfracbits;
+	} else if (entropy_count > pool_size)
+		entropy_count = pool_size;
 	if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
 		goto retry;
 
-- 
1.7.12.rc0.22.gcdd159b

