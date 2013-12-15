Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab3LOCB6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 21:01:58 -0500
Received: from dmz-mailsec-scanner-7.mit.edu ([18.7.68.36]:50892 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754440Ab3LOCB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 21:01:56 -0500
X-AuditID: 12074424-b7fa56d000000be4-19-52ad0d937618
Date: Sat, 14 Dec 2013 21:01:53 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 12/14] random: separate minimum reseed size from minimum
 /dev/random read
Message-ID: <20131215020153.GL27191@athena.dialup.mit.edu>
References: <cover.1387067223.git.price@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1387067223.git.price@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsUixCmqrTuZd22Qwd4P+haXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugStj/fxVTAWTNCr6pjxibGCcqdDFyMEhIWAisWBRSRcjJ5ApJnHh
	3nq2LkYuDiGB2UwSPf2X2SGcjYwSyz8chnJ+MUr8OHOIDaSFRUBVYsfTm+wgNpuAgsSP+euY
	QWwRAWWJVTM3MYHYzEDxX/c2sYLYwgLREp+/rwCL8wpYSfzcuQUsLiRgINE+swEqLihxcuYT
	FoheLYkb/14ygVzKLCAtsfwfB0iYU8BQ4t3Cq4wgtqiAisSUk9vYJjAKzkLSPQtJ9yyE7gWM
	zKsYZVNyq3RzEzNzilOTdYuTE/PyUot0zfVyM0v0UlNKNzGCwpTdRWUHY/MhpUOMAhyMSjy8
	Emxrg4RYE8uKK3MPMUpyMCmJ8kpxAoX4kvJTKjMSizPii0pzUosPMUpwMCuJ8O44vyZIiDcl
	sbIqtSgfJiXNwaIkznuLwz5ISCA9sSQ1OzW1ILUIJivDwaEkwfuEB2ioYFFqempFWmZOCUKa
	iYMTZDgP0PBzIDW8xQWJucWZ6RD5U4yKUuK8/iAJAZBERmkeXC8sjbxiFAd6RZj3FEgVDzAF
	wXW/AhrMBDTYe88qkMEliQgpqQbGne1PPjdzrxBkzuTnFDP7EhSyWli5X+SGzT+2A0Z7d8/O
	XmkkkH3+k/PahSV1P7bfvrhTUvDC+9A7b9fmSeyv3z/l3+zTb52VnDVlUxUeCyYeFLxxiemK
	WZ/nx/ByC++1aa9mOipqtt32F8pzOJzyn/vHfUeZnhchuz7OC/Xzun9Te/63gxNXKrEUZyQa
	ajEXFScCAD5f+n/+AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've used random_read_wakeup_bits for two quite different purposes
that may be best with different values.  The minimum number of bits
to wake up a blocked /dev/random reader has long been 64 by
default, and users may want to keep it there.  The minimum number
of bits in a seed for /dev/urandom and the kernel's general use, on
the other hand, should be at least 128 for good commercial security
and users may want it higher.

Make a new parameter for the minimum size of a reseed, and make it
128 by default.

Signed-off-by: Greg Price <price@mit.edu>
---
 drivers/char/random.c | 46 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 32 insertions(+), 14 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 1f9c69662..b354fd15f 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -292,8 +292,14 @@
 #define ENTROPY_BITS(r) ((r)->entropy_count >> ENTROPY_SHIFT)
 
 /*
+ * The minimum number of bits of estimated entropy to use in a reseed
+ * of the main output pool.
+ */
+static int min_reseed_bits = 128;
+
+/*
  * The minimum number of bits of entropy before we wake up a read on
- * /dev/random.  Should be enough to do a significant reseed.
+ * /dev/random.
  */
 static int random_read_wakeup_bits = 64;
 
@@ -594,7 +600,7 @@ random_readable(int input_entropy_bits)
 	int thresh = random_read_wakeup_bits;
 	if (!nonblocking_pool.initialized)
 		/* ... that aren't reserved for the nonblocking pool. */
-		thresh += random_read_wakeup_bits;
+		thresh += min_reseed_bits;
 	return input_entropy_bits >= thresh;
 }
 
@@ -665,7 +671,7 @@ retry:
 
 	if (r == &nonblocking_pool) {
 		r->entropy_total += nbits;
-		if (!r->initialized && r->entropy_total > 128) {
+		if (!r->initialized && r->entropy_total >= min_reseed_bits) {
 			r->initialized = 1;
 			prandom_reseed_late();
 			pr_notice("random: %s pool is initialized\n", r->name);
@@ -692,7 +698,7 @@ retry:
 		 */
 		r->entropy_since_push += nbits;
 		if (entropy_bits > random_write_wakeup_bits &&
-		    r->entropy_since_push >= 2*random_read_wakeup_bits) {
+		    r->entropy_since_push >= min_reseed_bits) {
 			static struct entropy_store *last = &blocking_pool;
 			struct entropy_store *other = &blocking_pool;
 
@@ -929,15 +935,15 @@ static void xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 static void account_xfer(struct entropy_store *dest, int nbytes,
 			 int *min_bytes, int *reserved_bytes)
 {
-	/* Try to pull a full wakeup's worth if we might have just woken up
-	 * for it, and a full reseed's worth (which is controlled by the same
-	 * parameter) for the nonblocking pool... */
-	if (dest == &blocking_pool || dest->initialized) {
+	/* Try to pull a full wakeup's worth if we might have just
+	 * woken up for it... */
+	if (dest == &blocking_pool) {
 		*min_bytes = random_read_wakeup_bits / 8;
 	} else {
-		/* ... except if we're hardly seeded at all, we'll settle for
-		 * enough to double what we have. */
-		*min_bytes = min(random_read_wakeup_bits / 8,
+		/* ... or a full reseed's worth for the nonblocking
+		 * pool, except if we're hardly seeded at all, we'll
+		 * settle for enough to double what we have. */
+		*min_bytes = min(min_reseed_bits / 8,
 				 (dest->entropy_total+7) / 8);
 	}
 
@@ -945,7 +951,7 @@ static void account_xfer(struct entropy_store *dest, int nbytes,
 	 * when we really need it; later, reserve some for /dev/random */
 	*reserved_bytes = 0;
 	if (dest == &blocking_pool && !nonblocking_pool.initialized)
-		*reserved_bytes = random_read_wakeup_bits / 8;
+		*reserved_bytes = min_reseed_bits / 8;
 	else if (dest == &nonblocking_pool && dest->initialized)
 		*reserved_bytes = 2 * (random_read_wakeup_bits / 8);
 }
@@ -974,7 +980,7 @@ static void push_to_pool(struct work_struct *work)
 	struct entropy_store *r = container_of(work, struct entropy_store,
 					      push_work);
 	BUG_ON(!r);
-	_xfer_secondary_pool(r, random_read_wakeup_bits/8);
+	_xfer_secondary_pool(r, min_reseed_bits/8);
 	trace_push_to_pool(r->name, r->entropy_count >> ENTROPY_SHIFT,
 			   r->pull->entropy_count >> ENTROPY_SHIFT);
 }
@@ -1516,8 +1522,11 @@ EXPORT_SYMBOL(generate_random_uuid);
 
 #include <linux/sysctl.h>
 
-static int min_read_thresh = 8, min_write_thresh;
+static int min_min_reseed_bits = 32;
+static int max_min_reseed_bits = OUTPUT_POOL_WORDS * 32;
+static int min_read_thresh = 8;
 static int max_read_thresh = OUTPUT_POOL_WORDS * 32;
+static int min_write_thresh;
 static int max_write_thresh = INPUT_POOL_WORDS * 32;
 static char sysctl_bootid[16];
 
@@ -1592,6 +1601,15 @@ struct ctl_table random_table[] = {
 		.data		= &input_pool.entropy_count,
 	},
 	{
+		.procname	= "min_reseed_bits",
+		.data		= &min_reseed_bits,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &min_min_reseed_bits,
+		.extra2		= &max_min_reseed_bits,
+	},
+	{
 		.procname	= "read_wakeup_threshold",
 		.data		= &random_read_wakeup_bits,
 		.maxlen		= sizeof(int),
-- 
1.8.3.2

