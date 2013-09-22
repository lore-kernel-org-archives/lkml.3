Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab3IVUju (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 16:39:50 -0400
Received: from imap.thunk.org ([74.207.234.97]:35985 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041Ab3IVUjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 16:39:19 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: hpa@zytor.com, joern@logfs.org, macro@linux-mips.org, ralf@linux-mips.org,
        dave.taht@gmail.com, blogic@openwrt.org, andrewmcgr@gmail.com,
        smueller@chronox.de, geert@linux-m68k.org, tg@mirbsd.de,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH, RFC 12/12] random: adjust the generator polynomials in the mixing function slightly
Date: Sun, 22 Sep 2013 16:38:58 -0400
Message-Id: <1379882338-7209-13-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.12.rc0.22.gcdd159b
In-Reply-To: <1379882338-7209-1-git-send-email-tytso@mit.edu>
References: <1379882338-7209-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Our mixing functions were analyzed by Lacharme, Roeck, Strubel, and
Videau in their paper, "The Linux Pseudorandom Number Generator
Revisited" (see: http://eprint.iacr.org/2012/251.pdf).

They suggested a slight change to improve our mixing functions
slightly.  I also adjusted the comments to better explain what is
going on, and to document why the polynomials were changed.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 drivers/char/random.c | 104 ++++++++++++++++++++++++--------------------------
 1 file changed, 50 insertions(+), 54 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 86879d1..5726ff6 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -321,23 +321,62 @@ static const int trickle_thresh = (INPUT_POOL_WORDS * 28) << ENTROPY_SHIFT;
 static DEFINE_PER_CPU(int, trickle_count);
 
 /*
- * A pool of size .poolwords is stirred with a primitive polynomial
- * of degree .poolwords over GF(2).  The taps for various sizes are
- * defined below.  They are chosen to be evenly spaced (minimum RMS
- * distance from evenly spaced; the numbers in the comments are a
- * scaled squared error sum) except for the last tap, which is 1 to
- * get the twisting happening as fast as possible.
+ * Originally, we used a primitive polynomial of degree .poolwords
+ * over GF(2).  The taps for various sizes are defined below.  They
+ * were chosen to be evenly spaced except for the last tap, which is 1
+ * to get the twisting happening as fast as possible.
+ *
+ * For the purposes of better mixing, we use the CRC-32 polynomial as
+ * well to make a (modified) twisted Generalized Feedback Shift
+ * Reigster
+ *
+ * (See M. Matsumoto & Y. Kurita, 1992.  Twisted GFSR generators.  ACM
+ * Transactions on Modeling and Computer Simulation 2(3):179-194.
+ * Also see M. Matsumoto & Y. Kurita, 1994.  Twisted GFSR generators
+ * II.  ACM Transactions on Mdeling and Computer Simulation 4:254-266)
+ *
+ * Thanks to Colin Plumb for suggesting this.
+ *
+ * The mixing operation is much less sensitive than the output hash,
+ * where we use SHA-1.  All that we want of mixing operation is that
+ * it be a good non-cryptographic hash; i.e. it not produce collisions
+ * when fed "random" data of the sort we expect to see.  As long as
+ * the pool state differs for different inputs, we have preserved the
+ * input entropy and done a good job.  The fact that an intelligent
+ * attacker can construct inputs that will produce controlled
+ * alterations to the pool's state is not important because we don't
+ * consider such inputs to contribute any randomness.  The only
+ * property we need with respect to them is that the attacker can't
+ * increase his/her knowledge of the pool's state.  Since all
+ * additions are reversible (knowing the final state and the input,
+ * you can reconstruct the initial state), if an attacker has any
+ * uncertainty about the initial state, he/she can only shuffle that
+ * uncertainty about, but never cause any collisions (which would
+ * decrease the uncertainty).
+ *
+ * Our mixing functions were analyzed by Lacharme, Roeck, Strubel, and
+ * Videau in their paper, "The Linux Pseudorandom Number Generator
+ * Revisited" (see: http://eprint.iacr.org/2012/251.pdf).  In their
+ * paper, they point out that we are not using a true Twisted GFSR,
+ * since Matsumoto & Kurita used a trinomial feedback polynomial (that
+ * is, with only three taps, instead of the six that we are using).
+ * As a result, the resulting polynomial is neither primitive nor
+ * irreducible, and hence does not have a maximal period over
+ * GF(2**32).  They suggest a slight change to the generator
+ * polynomial which improves the resulting TGFSR polynomial to be
+ * irreducible, which we have made here.
  */
-
 static struct poolinfo {
 	int poolbitshift, poolwords, poolbytes, poolbits, poolfracbits;
 #define S(x) ilog2(x)+5, (x), (x)*4, (x)*32, (x) << (ENTROPY_SHIFT+5)
 	int tap1, tap2, tap3, tap4, tap5;
 } poolinfo_table[] = {
-	/* x^128 + x^103 + x^76 + x^51 +x^25 + x + 1 -- 105 */
-	{ S(128),	103,	76,	51,	25,	1 },
-	/* x^32 + x^26 + x^20 + x^14 + x^7 + x + 1 -- 15 */
-	{ S(32),	26,	20,	14,	7,	1 },
+	/* was: x^128 + x^103 + x^76 + x^51 +x^25 + x + 1 */
+	/* x^128 + x^104 + x^76 + x^51 +x^25 + x + 1 */
+	{ S(128),	104,	76,	51,	25,	1 },
+	/* was: x^32 + x^26 + x^20 + x^14 + x^7 + x + 1 */
+	/* x^32 + x^26 + x^19 + x^14 + x^7 + x + 1 */
+	{ S(32),	26,	19,	14,	7,	1 },
 #if 0
 	/* x^2048 + x^1638 + x^1231 + x^819 + x^411 + x + 1  -- 115 */
 	{ S(2048),	1638,	1231,	819,	411,	1 },
@@ -368,49 +407,6 @@ static struct poolinfo {
 };
 
 /*
- * For the purposes of better mixing, we use the CRC-32 polynomial as
- * well to make a twisted Generalized Feedback Shift Reigster
- *
- * (See M. Matsumoto & Y. Kurita, 1992.  Twisted GFSR generators.  ACM
- * Transactions on Modeling and Computer Simulation 2(3):179-194.
- * Also see M. Matsumoto & Y. Kurita, 1994.  Twisted GFSR generators
- * II.  ACM Transactions on Mdeling and Computer Simulation 4:254-266)
- *
- * Thanks to Colin Plumb for suggesting this.
- *
- * We have not analyzed the resultant polynomial to prove it primitive;
- * in fact it almost certainly isn't.  Nonetheless, the irreducible factors
- * of a random large-degree polynomial over GF(2) are more than large enough
- * that periodicity is not a concern.
- *
- * The input hash is much less sensitive than the output hash.  All
- * that we want of it is that it be a good non-cryptographic hash;
- * i.e. it not produce collisions when fed "random" data of the sort
- * we expect to see.  As long as the pool state differs for different
- * inputs, we have preserved the input entropy and done a good job.
- * The fact that an intelligent attacker can construct inputs that
- * will produce controlled alterations to the pool's state is not
- * important because we don't consider such inputs to contribute any
- * randomness.  The only property we need with respect to them is that
- * the attacker can't increase his/her knowledge of the pool's state.
- * Since all additions are reversible (knowing the final state and the
- * input, you can reconstruct the initial state), if an attacker has
- * any uncertainty about the initial state, he/she can only shuffle
- * that uncertainty about, but never cause any collisions (which would
- * decrease the uncertainty).
- *
- * The chosen system lets the state of the pool be (essentially) the input
- * modulo the generator polymnomial.  Now, for random primitive polynomials,
- * this is a universal class of hash functions, meaning that the chance
- * of a collision is limited by the attacker's knowledge of the generator
- * polynomail, so if it is chosen at random, an attacker can never force
- * a collision.  Here, we use a fixed polynomial, but we *can* assume that
- * ###--> it is unknown to the processes generating the input entropy. <-###
- * Because of this important property, this is a good, collision-resistant
- * hash; hash collisions will occur no more often than chance.
- */
-
-/*
  * Static global variables
  */
 static DECLARE_WAIT_QUEUE_HEAD(random_read_wait);
-- 
1.7.12.rc0.22.gcdd159b

