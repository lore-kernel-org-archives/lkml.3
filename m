Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab3LOCCM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 21:02:12 -0500
Received: from dmz-mailsec-scanner-3.mit.edu ([18.9.25.14]:53624 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754533Ab3LOCCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 21:02:06 -0500
X-AuditID: 1209190e-b7efb6d000000bb9-ca-52ad0d9db7ca
Date: Sat, 14 Dec 2013 21:02:03 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 14/14] random: target giant reseeds, to be conservative
Message-ID: <20131215020202.GN27191@athena.dialup.mit.edu>
References: <cover.1387067223.git.price@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1387067223.git.price@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsUixCmqrTuXd22QwZo9shaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugStj/p1lzAULVSs2NzxnbWB8L9vFyMkhIWAi0XjqCTuELSZx4d56
	ti5GLg4hgdlMEpMbV7NAOBsZJZp7dzJBOL8YJf5v+c4C0sIioCrx8cgqVhCbTUBB4sf8dcwg
	toiAssSqmZuYQGxmoPive5vAaoQF3CWmdp1hA7F5BawkFj9ZDhYXEjCQaJ/ZwAQRF5Q4OfMJ
	C0SvlsSNfy+B4hxAtrTE8n8cIGFOAUOJdwuvMoLYogIqElNObmObwCg4C0n3LCTdsxC6FzAy
	r2KUTcmt0s1NzMwpTk3WLU5OzMtLLdI11svNLNFLTSndxAgOVEm+HYxfDyodYhTgYFTi4T3A
	vDZIiDWxrLgy9xCjJAeTkiivFCdQiC8pP6UyI7E4I76oNCe1+BCjBAezkgjvjvNrgoR4UxIr
	q1KL8mFS0hwsSuK8Nznsg4QE0hNLUrNTUwtSi2CyMhwcShK8mTxAQwWLUtNTK9Iyc0oQ0kwc
	nCDDeYCG94PU8BYXJOYWZ6ZD5E8xKkqJ8/qDJARAEhmleXC9sETyilEc6BVh3h6QKh5gEoLr
	fgU0mAlosPeeVSCDSxIRUlINjLXpHybnyJW3v7+xPU7o75T99nt/FeZ+ezc781b4cr9qYduV
	7m1mORIs371OJs1Qs++rY5t4dMF3x/Ipb0ocuuc7iiny2p5X/hNknKGtZ/Fyr4ts08OJpq8f
	RL8xvD3lx7xli3Jc9RqVrl67F2L7uSyg46ZE9m3myGc10/cdnnDcJWWJcObKh0osxRmJhlrM
	RcWJAFgYRIj/AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A 128-bit seed provides reasonable security.  We don't consider
ourselves initialized until we get a seed which we estimate has
entropy min_reseed_bits, by default 128.  Our entropy estimates
are generally conservative (see e.g. the empirical analysis in
http://eprint.iacr.org/2012/251.pdf), but entropy estimation is
unavoidably heuristic and there may be circumstances where they
are too optimistic.

To hedge against this risk, even after getting a seed of minimum
size we continue taking bigger reseeds until we reach by default
512 bits of estimated entropy per reseed.  Hopefully it should be
difficult to make our entropy estimates a factor of 4 too high.
As a bonus, when the estimates are good, this gives us seeds which
can't be brute-forced within the universe under the known laws of
physics, which ought to really be enough for anybody.

This hedging addresses the same issue that motivates systems like
Fortuna.  Our change doesn't go as far in that direction as Fortuna,
but it's much simpler.

The cost is that reseeds will happen about four times (by default)
less often.  This is not really a critical issue, as frequent reseeds
mainly help us "recover" if someone glimpses the internal state --
which is largely an academic question, given what an attacker who can
read kernel memory is usually able to do.  We still take a
regular-sized seed up front so as not to delay getting initialized.

Signed-off-by: Greg Price <price@mit.edu>
---
 drivers/char/random.c | 38 ++++++++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 10 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 855e401e5..79aee65fe 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -293,11 +293,20 @@
 
 /*
  * The minimum number of bits of estimated entropy to use in a reseed
- * of the main output pool.
+ * of the main output pool (for /dev/urandom and the kernel's internal
+ * use) before considering it secure.
  */
 static int min_reseed_bits = 128;
 
 /*
+ * The number of bits of estimated entropy to use in a reseed of the
+ * main output pool in the steady state.  If this is larger than
+ * min_reseed_bits, then it serves as a hedge against situations where
+ * our entropy estimates are for whatever reason too optimistic.
+ */
+static int target_reseed_bits = 512;
+
+/*
  * The minimum number of bits of entropy before we wake up a read on
  * /dev/random.
  */
@@ -699,7 +708,7 @@ retry:
 		 */
 		r->entropy_since_push += nbits;
 		if (entropy_bits > random_write_wakeup_bits &&
-		    r->entropy_since_push >= min_reseed_bits) {
+		    r->entropy_since_push >= target_reseed_bits) {
 			static struct entropy_store *last = &blocking_pool;
 			struct entropy_store *other = &blocking_pool;
 
@@ -942,9 +951,9 @@ static void account_xfer(struct entropy_store *dest, int nbytes,
 		*min_bytes = random_read_wakeup_bits / 8;
 	} else {
 		/* ... or a full reseed's worth for the nonblocking
-		 * pool, except if we're hardly seeded at all, we'll
-		 * settle for enough to double what we have. */
-		*min_bytes = min(min_reseed_bits / 8,
+		 * pool, except early on we'll settle for enough to
+		 * double what we have. */
+		*min_bytes = min(target_reseed_bits / 8,
 				 (2*dest->seed_entropy_bits + 7) / 8);
 	}
 
@@ -981,7 +990,7 @@ static void push_to_pool(struct work_struct *work)
 	struct entropy_store *r = container_of(work, struct entropy_store,
 					      push_work);
 	BUG_ON(!r);
-	_xfer_secondary_pool(r, min_reseed_bits/8);
+	_xfer_secondary_pool(r, target_reseed_bits/8);
 	trace_push_to_pool(r->name, r->entropy_count >> ENTROPY_SHIFT,
 			   r->pull->entropy_count >> ENTROPY_SHIFT);
 }
@@ -1522,8 +1531,8 @@ EXPORT_SYMBOL(generate_random_uuid);
 
 #include <linux/sysctl.h>
 
-static int min_min_reseed_bits = 32;
-static int max_min_reseed_bits = OUTPUT_POOL_WORDS * 32;
+static int hard_min_reseed_bits = 32;
+static int max_reseed_bits = OUTPUT_POOL_WORDS * 32;
 static int min_read_thresh = 8;
 static int max_read_thresh = OUTPUT_POOL_WORDS * 32;
 static int min_write_thresh;
@@ -1606,8 +1615,17 @@ struct ctl_table random_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &min_min_reseed_bits,
-		.extra2		= &max_min_reseed_bits,
+		.extra1		= &hard_min_reseed_bits,
+		.extra2		= &target_reseed_bits,
+	},
+	{
+		.procname	= "target_reseed_bits",
+		.data		= &target_reseed_bits,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &min_reseed_bits,
+		.extra2		= &max_reseed_bits,
 	},
 	{
 		.procname	= "read_wakeup_threshold",
-- 
1.8.3.2
