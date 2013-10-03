Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab3JCTpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 15:45:33 -0400
Received: from imap.thunk.org ([74.207.234.97]:41800 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755100Ab3JCTpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 15:45:32 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 1/2] random: push extra entropy to the output pools
Date: Thu,  3 Oct 2013 15:45:08 -0400
Message-Id: <1380829509-10590-1-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.12.rc0.22.gcdd159b
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the input pool gets filled, start transfering entropy to the output
pools until they get filled.  This allows us to use the output pools
to store more system entropy.  Waste not, want not....

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 drivers/char/random.c         | 118 ++++++++++++++++++++++++++++++------------
 include/trace/events/random.h |  22 ++++++++
 2 files changed, 108 insertions(+), 32 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 6da3f25..84c576e 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -255,6 +255,7 @@
 #include <linux/fips.h>
 #include <linux/ptrace.h>
 #include <linux/kmemcheck.h>
+#include <linux/workqueue.h>
 
 #ifdef CONFIG_GENERIC_HARDIRQS
 # include <linux/irq.h>
@@ -302,7 +303,7 @@ static int random_read_wakeup_thresh = 64;
  * should wake up processes which are selecting or polling on write
  * access to /dev/random.
  */
-static int random_write_wakeup_thresh = 128;
+static int random_write_wakeup_thresh = 28 * OUTPUT_POOL_WORDS;
 
 /*
  * The minimum number of seconds between urandom pool resending.  We
@@ -428,6 +429,7 @@ struct entropy_store {
 	__u32 *pool;
 	const char *name;
 	struct entropy_store *pull;
+	struct work_struct push_work;
 
 	/* read-write data: */
 	unsigned long last_pulled;
@@ -442,6 +444,7 @@ struct entropy_store {
 	__u8 last_data[EXTRACT_SIZE];
 };
 
+static void push_to_pool(struct work_struct *work);
 static __u32 input_pool_data[INPUT_POOL_WORDS];
 static __u32 blocking_pool_data[OUTPUT_POOL_WORDS];
 static __u32 nonblocking_pool_data[OUTPUT_POOL_WORDS];
@@ -460,7 +463,9 @@ static struct entropy_store blocking_pool = {
 	.limit = 1,
 	.pull = &input_pool,
 	.lock = __SPIN_LOCK_UNLOCKED(blocking_pool.lock),
-	.pool = blocking_pool_data
+	.pool = blocking_pool_data,
+	.push_work = __WORK_INITIALIZER(blocking_pool.push_work,
+					push_to_pool),
 };
 
 static struct entropy_store nonblocking_pool = {
@@ -468,7 +473,9 @@ static struct entropy_store nonblocking_pool = {
 	.name = "nonblocking",
 	.pull = &input_pool,
 	.lock = __SPIN_LOCK_UNLOCKED(nonblocking_pool.lock),
-	.pool = nonblocking_pool_data
+	.pool = nonblocking_pool_data,
+	.push_work = __WORK_INITIALIZER(nonblocking_pool.push_work,
+					push_to_pool),
 };
 
 static __u32 const twist_table[8] = {
@@ -655,21 +662,48 @@ retry:
 	if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
 		goto retry;
 
+	r->entropy_total += nbits;
 	if (!r->initialized && nbits > 0) {
-		r->entropy_total += nbits;
-		if (r->entropy_total > 128)
+		if (r->entropy_total > 128) {
 			r->initialized = 1;
+			r->entropy_total = 0;
+		}
 	}
 
 	trace_credit_entropy_bits(r->name, nbits,
 				  entropy_count >> ENTROPY_SHIFT,
 				  r->entropy_total, _RET_IP_);
 
-	/* should we wake readers? */
-	if (r == &input_pool &&
-	    (entropy_count >> ENTROPY_SHIFT) >= random_read_wakeup_thresh) {
-		wake_up_interruptible(&random_read_wait);
-		kill_fasync(&fasync, SIGIO, POLL_IN);
+	if (r == &input_pool) {
+		int entropy_bytes = entropy_count >> ENTROPY_SHIFT;
+
+		/* should we wake readers? */
+		if (entropy_bytes >= random_read_wakeup_thresh) {
+			wake_up_interruptible(&random_read_wait);
+			kill_fasync(&fasync, SIGIO, POLL_IN);
+		}
+		/* If the input pool is getting full, send some
+		 * entropy to the two output pools, flipping back and
+		 * forth between them, until the output pools are 75%
+		 * full.
+		 */
+		if (entropy_bytes > random_write_wakeup_thresh &&
+		    r->initialized &&
+		    r->entropy_total >= 2*random_read_wakeup_thresh) {
+			static struct entropy_store *last = &blocking_pool;
+			struct entropy_store *other = &blocking_pool;
+
+			if (last == &blocking_pool)
+				other = &nonblocking_pool;
+			if (other->entropy_count <=
+			    3 * other->poolinfo->poolfracbits / 4)
+				last = other;
+			if (last->entropy_count <=
+			    3 * last->poolinfo->poolfracbits / 4) {
+				schedule_work(&last->push_work);
+				r->entropy_total = 0;
+			}
+		}
 	}
 }
 
@@ -877,10 +911,9 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
  * from the primary pool to the secondary extraction pool. We make
  * sure we pull enough for a 'catastrophic reseed'.
  */
+static void _xfer_secondary_pool(struct entropy_store *r, size_t nbytes);
 static void xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 {
-	__u32	tmp[OUTPUT_POOL_WORDS];
-
 	if (r->limit == 0 && random_min_urandom_seed) {
 		unsigned long now = jiffies;
 
@@ -891,26 +924,47 @@ static void xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 	}
 	if (r->pull &&
 	    r->entropy_count < (nbytes << (ENTROPY_SHIFT + 3)) &&
-	    r->entropy_count < r->poolinfo->poolfracbits) {
-		/* If we're limited, always leave two wakeup worth's BITS */
-		int rsvd = r->limit ? 0 : random_read_wakeup_thresh/4;
-		int bytes = nbytes;
-
-		/* pull at least as many as BYTES as wakeup BITS */
-		bytes = max_t(int, bytes, random_read_wakeup_thresh / 8);
-		/* but never more than the buffer size */
-		bytes = min_t(int, bytes, sizeof(tmp));
-
-		DEBUG_ENT("going to reseed %s with %d bits "
-			  "(%zu of %d requested)\n",
-			  r->name, bytes * 8, nbytes * 8,
-			  r->entropy_count >> ENTROPY_SHIFT);
-
-		bytes = extract_entropy(r->pull, tmp, bytes,
-					random_read_wakeup_thresh / 8, rsvd);
-		mix_pool_bytes(r, tmp, bytes, NULL);
-		credit_entropy_bits(r, bytes*8);
-	}
+	    r->entropy_count < r->poolinfo->poolfracbits)
+		_xfer_secondary_pool(r, nbytes);
+}
+
+static void _xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
+{
+	__u32	tmp[OUTPUT_POOL_WORDS];
+
+	/* For /dev/random's pool, always leave two wakeup worth's BITS */
+	int rsvd = r->limit ? 0 : random_read_wakeup_thresh/4;
+	int bytes = nbytes;
+
+	/* pull at least as many as BYTES as wakeup BITS */
+	bytes = max_t(int, bytes, random_read_wakeup_thresh / 8);
+	/* but never more than the buffer size */
+	bytes = min_t(int, bytes, sizeof(tmp));
+
+	DEBUG_ENT("going to reseed %s with %d bits (%zu of %d requested)\n",
+		  r->name, bytes * 8, nbytes * 8,
+		  r->entropy_count >> ENTROPY_SHIFT);
+
+	bytes = extract_entropy(r->pull, tmp, bytes,
+				random_read_wakeup_thresh / 8, rsvd);
+	mix_pool_bytes(r, tmp, bytes, NULL);
+	credit_entropy_bits(r, bytes*8);
+}
+
+/*
+ * Used as a workqueue function so that when the input pool is getting
+ * full, we can "spill over" some entropy to the output pools.  That
+ * way the output pools can store some of the excess entropy instead
+ * of letting it go to waste.
+ */
+static void push_to_pool(struct work_struct *work)
+{
+	struct entropy_store *r = container_of(work, struct entropy_store,
+					      push_work);
+	BUG_ON(!r);
+	_xfer_secondary_pool(r, random_read_wakeup_thresh/8);
+	trace_push_to_pool(r->name, r->entropy_count >> ENTROPY_SHIFT,
+			   r->pull->entropy_count >> ENTROPY_SHIFT);
 }
 
 /*
diff --git a/include/trace/events/random.h b/include/trace/events/random.h
index 2ffcaec..527b5dc 100644
--- a/include/trace/events/random.h
+++ b/include/trace/events/random.h
@@ -87,6 +87,28 @@ TRACE_EVENT(credit_entropy_bits,
 		  (void *)__entry->IP)
 );
 
+TRACE_EVENT(push_to_pool,
+	TP_PROTO(const char *pool_name, int pool_bits, int input_bits),
+
+	TP_ARGS(pool_name, pool_bits, input_bits),
+
+	TP_STRUCT__entry(
+		__field( const char *,	pool_name		)
+		__field(	  int,	pool_bits		)
+		__field(	  int,	input_bits		)
+	),
+
+	TP_fast_assign(
+		__entry->pool_name	= pool_name;
+		__entry->pool_bits	= pool_bits;
+		__entry->input_bits	= input_bits;
+	),
+
+	TP_printk("%s: pool_bits %d input_pool_bits %d",
+		  __entry->pool_name, __entry->pool_bits,
+		  __entry->input_bits)
+);
+
 DECLARE_EVENT_CLASS(random__get_random_bytes,
 	TP_PROTO(int nbytes, unsigned long IP),
 
-- 
1.7.12.rc0.22.gcdd159b

