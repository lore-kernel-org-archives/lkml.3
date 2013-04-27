Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685Ab3D0Wo6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 18:44:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52227 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591Ab3D0Woy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 18:44:54 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        DJ Johnston <dj.johnston@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, <stable@vger.kernel.org>
Subject: [PATCH 2/3] random: Allow fractional bits to be tracked
Date: Sat, 27 Apr 2013 15:44:38 -0700
Message-Id: <1367102679-5178-3-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1367102679-5178-1-git-send-email-hpa@zytor.com>
References: <1367102679-5178-1-git-send-email-hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

Allow fractional bits of entropy to be tracked by scaling the entropy
counter (fixed point).  This will be used in a subsequent patch that
accounts for entropy lost due to overwrites.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: <stable@vger.kernel.org>
---
 drivers/char/random.c | 92 +++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 68 insertions(+), 24 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 106b9b2..5cc8e86 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -280,6 +280,14 @@
 #define LONGS(x) (((x) + sizeof(unsigned long) - 1)/sizeof(unsigned long))
 
 /*
+ * To allow fractional bits to be tracked, the following fields contain
+ * this many fractional bits:
+ *
+ * entropy_count, trickle_thresh
+ */
+#define ENTROPY_SHIFT 3
+
+/*
  * The minimum number of bits of entropy before we wake up a read on
  * /dev/random.  Should be enough to do a significant reseed.
  */
@@ -296,8 +304,7 @@ static int random_write_wakeup_thresh = 128;
  * When the input pool goes over trickle_thresh, start dropping most
  * samples to avoid wasting CPU time and reduce lock contention.
  */
-
-static int trickle_thresh __read_mostly = INPUT_POOL_WORDS * 28;
+static const int trickle_thresh = (INPUT_POOL_WORDS * 28) << ENTROPY_SHIFT;
 
 static DEFINE_PER_CPU(int, trickle_count);
 
@@ -311,8 +318,8 @@ static DEFINE_PER_CPU(int, trickle_count);
  */
 
 static struct poolinfo {
-	int poolbitshift, poolwords, poolbytes, poolbits;
-#define S(x) ilog2(x)+5, (x), (x)*4, (x)*32
+	int poolbitshift, poolwords, poolbytes, poolbits, poolfracbits;
+#define S(x) ilog2(x)+5, (x), (x)*4, (x)*32, (x) << (ENTROPY_SHIFT+5)
 	int tap1, tap2, tap3, tap4, tap5;
 } poolinfo_table[] = {
 	/* x^128 + x^103 + x^76 + x^51 +x^25 + x + 1 -- 105 */
@@ -581,7 +588,9 @@ static void fast_mix(struct fast_pool *f, const void *in, int nbytes)
 }
 
 /*
- * Credit (or debit) the entropy store with n bits of entropy
+ * Credit (or debit) the entropy store with n bits of entropy.
+ * Use credit_entropy_bits_safe() if the value comes from userspace
+ * or otherwise should be checked for extreme values.
  */
 static void credit_entropy_bits(struct entropy_store *r, int nbits)
 {
@@ -593,13 +602,13 @@ static void credit_entropy_bits(struct entropy_store *r, int nbits)
 	DEBUG_ENT("added %d entropy credits to %s\n", nbits, r->name);
 retry:
 	entropy_count = orig = ACCESS_ONCE(r->entropy_count);
-	entropy_count += nbits;
+	entropy_count += nbits << ENTROPY_SHIFT;
 
 	if (entropy_count < 0) {
 		DEBUG_ENT("negative entropy/overflow\n");
 		entropy_count = 0;
-	} else if (entropy_count > r->poolinfo->poolbits)
-		entropy_count = r->poolinfo->poolbits;
+	} else if (entropy_count > r->poolinfo->poolfracbits)
+		entropy_count = r->poolinfo->poolfracbits;
 	if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
 		goto retry;
 
@@ -613,12 +622,24 @@ retry:
 				  r->entropy_total, _RET_IP_);
 
 	/* should we wake readers? */
-	if (r == &input_pool && entropy_count >= random_read_wakeup_thresh) {
+	if (r == &input_pool &&
+	    (entropy_count >> ENTROPY_SHIFT) >= random_read_wakeup_thresh) {
 		wake_up_interruptible(&random_read_wait);
 		kill_fasync(&fasync, SIGIO, POLL_IN);
 	}
 }
 
+static void credit_entropy_bits_safe(struct entropy_store *r, int nbits)
+{
+	const int nbits_max = (int)(~0U >> (ENTROPY_SHIFT + 1));
+
+	/* Cap the value to avoid overflows */
+	nbits = min(nbits,  nbits_max);
+	nbits = max(nbits, -nbits_max);
+
+	credit_entropy_bits(r, nbits);
+}
+
 /*********************************************************************
  *
  * Entropy input management
@@ -813,8 +834,9 @@ static void xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 {
 	__u32	tmp[OUTPUT_POOL_WORDS];
 
-	if (r->pull && r->entropy_count < nbytes * 8 &&
-	    r->entropy_count < r->poolinfo->poolbits) {
+	if (r->pull &&
+	    r->entropy_count < (nbytes << (ENTROPY_SHIFT + 3)) &&
+	    r->entropy_count < r->poolinfo->poolfracbits) {
 		/* If we're limited, always leave two wakeup worth's BITS */
 		int rsvd = r->limit ? 0 : random_read_wakeup_thresh/4;
 		int bytes = nbytes;
@@ -826,7 +848,8 @@ static void xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 
 		DEBUG_ENT("going to reseed %s with %d bits "
 			  "(%zu of %d requested)\n",
-			  r->name, bytes * 8, nbytes * 8, r->entropy_count);
+			  r->name, bytes * 8, nbytes * 8,
+			  r->entropy_count >> ENTROPY_SHIFT);
 
 		bytes = extract_entropy(r->pull, tmp, bytes,
 					random_read_wakeup_thresh / 8, rsvd);
@@ -852,28 +875,31 @@ static size_t account(struct entropy_store *r, size_t nbytes, int min,
 {
 	unsigned long flags;
 	int wakeup_write = 0;
+	int have_bytes;
 
 	/* Hold lock while accounting */
 	spin_lock_irqsave(&r->lock, flags);
 
-	BUG_ON(r->entropy_count > r->poolinfo->poolbits);
+	BUG_ON(r->entropy_count > r->poolinfo->poolfracbits);
 	DEBUG_ENT("trying to extract %zu bits from %s\n",
 		  nbytes * 8, r->name);
 
 	/* Can we pull enough? */
-	if (r->entropy_count / 8 < min + reserved) {
+	have_bytes = r->entropy_count >> (ENTROPY_SHIFT + 3);
+	if (have_bytes < min + reserved) {
 		nbytes = 0;
 	} else {
 		/* If limited, never pull more than available */
-		if (r->limit && nbytes + reserved >= r->entropy_count / 8)
-			nbytes = r->entropy_count/8 - reserved;
+		if (r->limit && nbytes + reserved >= have_bytes)
+			nbytes = have_bytes - reserved;
 
-		if (r->entropy_count / 8 >= nbytes + reserved)
-			r->entropy_count -= nbytes*8;
+		if (have_bytes >= nbytes + reserved)
+			r->entropy_count -= nbytes << (ENTROPY_SHIFT + 3);
 		else
-			r->entropy_count = reserved;
+			r->entropy_count = reserved << (ENTROPY_SHIFT + 3);
 
-		if (r->entropy_count < random_write_wakeup_thresh)
+		if ((r->entropy_count >> ENTROPY_SHIFT)
+		    < random_write_wakeup_thresh)
 			wakeup_write = 1;
 	}
 
@@ -1269,7 +1295,8 @@ static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 	switch (cmd) {
 	case RNDGETENTCNT:
 		/* inherently racy, no point locking */
-		if (put_user(input_pool.entropy_count, p))
+		ent_count = input_pool.entropy_count >> ENTROPY_SHIFT;
+		if (put_user(ent_count, p))
 			return -EFAULT;
 		return 0;
 	case RNDADDTOENTCNT:
@@ -1277,7 +1304,7 @@ static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 			return -EPERM;
 		if (get_user(ent_count, p))
 			return -EFAULT;
-		credit_entropy_bits(&input_pool, ent_count);
+		credit_entropy_bits_safe(&input_pool, ent_count);
 		return 0;
 	case RNDADDENTROPY:
 		if (!capable(CAP_SYS_ADMIN))
@@ -1292,7 +1319,7 @@ static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 				    size);
 		if (retval < 0)
 			return retval;
-		credit_entropy_bits(&input_pool, ent_count);
+		credit_entropy_bits_safe(&input_pool, ent_count);
 		return 0;
 	case RNDZAPENTCNT:
 	case RNDCLEARPOOL:
@@ -1399,6 +1426,23 @@ static int proc_do_uuid(ctl_table *table, int write,
 	return proc_dostring(&fake_table, write, buffer, lenp, ppos);
 }
 
+/*
+ * Return entropy available scaled to integral bits
+ */
+static int proc_do_entropy(ctl_table *table, int write,
+			   void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	ctl_table fake_table;
+	int entropy_count;
+
+	entropy_count = *(int *)table->data >> ENTROPY_SHIFT;
+
+	fake_table.data = &entropy_count;
+	fake_table.maxlen = sizeof(entropy_count);
+
+	return proc_dointvec(&fake_table, write, buffer, lenp, ppos);
+}
+
 static int sysctl_poolsize = INPUT_POOL_WORDS * 32;
 extern ctl_table random_table[];
 ctl_table random_table[] = {
@@ -1413,7 +1457,7 @@ ctl_table random_table[] = {
 		.procname	= "entropy_avail",
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_do_entropy,
 		.data		= &input_pool.entropy_count,
 	},
 	{
-- 
1.7.11.7

