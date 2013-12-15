Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab3LOCCG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 21:02:06 -0500
Received: from dmz-mailsec-scanner-3.mit.edu ([18.9.25.14]:53624 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754440Ab3LOCCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 21:02:01 -0500
X-AuditID: 1209190e-b7efb6d000000bb9-bd-52ad0d986f98
Date: Sat, 14 Dec 2013 21:01:58 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 13/14] random: count only catastrophic reseeds for
 initialization
Message-ID: <20131215020158.GM27191@athena.dialup.mit.edu>
References: <cover.1387067223.git.price@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1387067223.git.price@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsUixG6nojuDd22QwcJf8haXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvjR+s8toKXWhXPJis2MF5Q6mLk5JAQMJF4c/YxI4QtJnHh3no2
	EFtIYDaTxOmNSRD2RkaJ2905XYxcQPYvRont09ezgiRYBFQlut4vZAGx2QQUJH7MX8cMYosI
	KEusmrmJCcRmBor/urcJrF5YIFhi8d+VYDW8AlYS/w6+YIRYYCDRPrOBCSIuKHFy5hMWiF4t
	iRv/XgLFOYBsaYnl/zhAwpwChhLvFl4FaxUVUJGYcnIb2wRGwVlIumch6Z6F0L2AkXkVo2xK
	bpVubmJmTnFqsm5xcmJeXmqRrrFebmaJXmpK6SZGUIhySvLtYPx6UOkQowAHoxIP7wHmtUFC
	rIllxZW5hxglOZiURHmlOIFCfEn5KZUZicUZ8UWlOanFhxglOJiVRHh3nF8TJMSbklhZlVqU
	D5OS5mBREue9yWEfJCSQnliSmp2aWpBaBJOV4eBQkuDN5AEaKliUmp5akZaZU4KQZuLgBBnO
	AzS8H6SGt7ggMbc4Mx0if4pRUUqc1x8kIQCSyCjNg+uFpZBXjOJArwjz9oBU8QDTD1z3K6DB
	TECDvfesAhlckoiQkmpgtGiVs49c59xVcDI1VURMq2zfbZWAHRdPLA3I/K+4heHlInV+Tqkj
	nPE528o1HncbBMR4p7Z9+1/VzuEaumBepfnxy9Vcl9bWsLtantV+y6rYa5B9pPmJe8XkSXJZ
	onydSwS9+s71rN0dKr1LftnknPNy7zbNP9712Irjw89Uf4dz4QY1xReUWIozEg21mIuKEwF7
	q8dq/AIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the earlier commit "random: direct all routine input via input pool",
we made sure that input comes in large reseeds which should be big
enough to prevent an attacker from brute-forcing any one of them.
This is important because a succession of small reseeds, if
interspersed with output an attacker sees, could be brute-forced one
by one.  Now update our accounting accordingly so that we track the
largest single reseed, rather than the total of potentially small
reseeds, and call ourselves initialized only with one large reseed.

This shouldn't make much difference with the current code, as we
don't make repeated small reseeds anyway, but it's best to be clear.

Rename entropy_total to seed_entropy_bits to reflect its new function.

While touching the not-yet-initialized warnings, checkpatch complains
about printk(KERN_NOTICE, ...), so switch to pr_notice etc.

Signed-off-by: Greg Price <price@mit.edu>
---
 drivers/char/random.c         | 24 ++++++++++++------------
 include/trace/events/random.h | 13 +++++++------
 2 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index b354fd15f..855e401e5 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -432,7 +432,7 @@ struct entropy_store {
 	unsigned short input_rotate;
 	int entropy_count;
 	int entropy_since_push;
-	int entropy_total;
+	int seed_entropy_bits;
 	unsigned int initialized:1;
 	unsigned int limit:1;
 	unsigned int last_data_init:1;
@@ -670,8 +670,9 @@ retry:
 		goto retry;
 
 	if (r == &nonblocking_pool) {
-		r->entropy_total += nbits;
-		if (!r->initialized && r->entropy_total >= min_reseed_bits) {
+		r->seed_entropy_bits = max(nbits, r->seed_entropy_bits);
+		if (!r->initialized &&
+		    r->seed_entropy_bits >= min_reseed_bits) {
 			r->initialized = 1;
 			prandom_reseed_late();
 			pr_notice("random: %s pool is initialized\n", r->name);
@@ -681,7 +682,7 @@ retry:
 	trace_credit_entropy_bits(r->name, nbits,
 				  entropy_count >> ENTROPY_SHIFT,
 				  r->entropy_since_push,
-				  r->entropy_total, _RET_IP_);
+				  r->seed_entropy_bits, _RET_IP_);
 
 	if (r == &input_pool) {
 		int entropy_bits = entropy_count >> ENTROPY_SHIFT;
@@ -944,7 +945,7 @@ static void account_xfer(struct entropy_store *dest, int nbytes,
 		 * pool, except if we're hardly seeded at all, we'll
 		 * settle for enough to double what we have. */
 		*min_bytes = min(min_reseed_bits / 8,
-				 (dest->entropy_total+7) / 8);
+				 (2*dest->seed_entropy_bits + 7) / 8);
 	}
 
 	/* Reserve a reseed's worth for the nonblocking pool early on
@@ -1215,10 +1216,9 @@ void get_random_bytes(void *buf, int nbytes)
 {
 #if DEBUG_RANDOM_BOOT > 0
 	if (unlikely(nonblocking_pool.initialized == 0))
-		printk(KERN_NOTICE "random: %pF get_random_bytes called "
-		       "with %d bits of entropy available\n",
-		       (void *) _RET_IP_,
-		       nonblocking_pool.entropy_total);
+		pr_notice(
+		    "random: %pF get_random_bytes called with only %d bits of seed entropy available\n",
+		    (void *) _RET_IP_, nonblocking_pool.seed_entropy_bits);
 #endif
 	trace_get_random_bytes(nbytes, _RET_IP_);
 	extract_entropy(&nonblocking_pool, buf, nbytes, NULL, NULL);
@@ -1355,9 +1355,9 @@ urandom_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 	int ret;
 
 	if (unlikely(nonblocking_pool.initialized == 0))
-		printk_once(KERN_NOTICE "random: %s urandom read "
-			    "with %d bits of entropy available\n",
-			    current->comm, nonblocking_pool.entropy_total);
+		pr_notice_once(
+		    "random: %s urandom read with only %d bits of seed entropy available\n",
+		    current->comm, nonblocking_pool.seed_entropy_bits);
 
 	ret = extract_entropy_user(&nonblocking_pool, buf, nbytes);
 
diff --git a/include/trace/events/random.h b/include/trace/events/random.h
index 4edf5ceb5..d07a80146 100644
--- a/include/trace/events/random.h
+++ b/include/trace/events/random.h
@@ -61,17 +61,18 @@ DEFINE_EVENT(random__mix_pool_bytes, mix_pool_bytes_nolock,
 
 TRACE_EVENT(credit_entropy_bits,
 	TP_PROTO(const char *pool_name, int bits, int entropy_count,
-		 int entropy_since_push, int entropy_total, unsigned long IP),
+		 int entropy_since_push, int seed_entropy_bits,
+		 unsigned long IP),
 
 	TP_ARGS(pool_name, bits, entropy_count, entropy_since_push,
-		entropy_total, IP),
+		seed_entropy_bits, IP),
 
 	TP_STRUCT__entry(
 		__field( const char *,	pool_name		)
 		__field(	  int,	bits			)
 		__field(	  int,	entropy_count		)
 		__field(	  int,	entropy_since_push	)
-		__field(	  int,	entropy_total		)
+		__field(	  int,	seed_entropy_bits	)
 		__field(unsigned long,	IP			)
 	),
 
@@ -80,14 +81,14 @@ TRACE_EVENT(credit_entropy_bits,
 		__entry->bits			= bits;
 		__entry->entropy_count		= entropy_count;
 		__entry->entropy_since_push	= entropy_since_push;
-		__entry->entropy_total		= entropy_total;
+		__entry->seed_entropy_bits	= seed_entropy_bits;
 		__entry->IP			= IP;
 	),
 
 	TP_printk("%s pool: bits %d entropy_count %d entropy_since_push %d "
-		  "entropy_total %d caller %pF", __entry->pool_name,
+		  "seed_entropy_bits %d caller %pF", __entry->pool_name,
 		  __entry->bits, __entry->entropy_count,
-		  __entry->entropy_since_push, __entry->entropy_total,
+		  __entry->entropy_since_push, __entry->seed_entropy_bits,
 		  (void *)__entry->IP)
 );
 
-- 
1.8.3.2

