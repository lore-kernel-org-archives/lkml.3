Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab3JCTpj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 15:45:39 -0400
Received: from imap.thunk.org ([74.207.234.97]:41802 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755120Ab3JCTpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 15:45:36 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 2/2] random: convert DEBUG_ENT to tracepoints
Date: Thu,  3 Oct 2013 15:45:09 -0400
Message-Id: <1380829509-10590-2-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.12.rc0.22.gcdd159b
In-Reply-To: <1380829509-10590-1-git-send-email-tytso@mit.edu>
References: <1380829509-10590-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using the random driver's ad-hoc DEBUG_ENT() mechanism, use
tracepoints instead.  This allows for a much more fine-grained control
of which debugging mechanism which a developer might need, and unifies
the debugging messages with all of the existing tracepoints.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 drivers/char/random.c         |  52 ++++++-----------
 include/trace/events/random.h | 128 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 144 insertions(+), 36 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 84c576e..f126bd2 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -404,17 +404,6 @@ static DECLARE_WAIT_QUEUE_HEAD(random_read_wait);
 static DECLARE_WAIT_QUEUE_HEAD(random_write_wait);
 static struct fasync_struct *fasync;
 
-static bool debug;
-module_param(debug, bool, 0644);
-#define DEBUG_ENT(fmt, arg...) do { \
-	if (debug) \
-		printk(KERN_DEBUG "random %04d %04d %04d: " \
-		fmt,\
-		input_pool.entropy_count,\
-		blocking_pool.entropy_count,\
-		nonblocking_pool.entropy_count,\
-		## arg); } while (0)
-
 /**********************************************************************
  *
  * OS independent entropy store.   Here are the functions which handle
@@ -612,7 +601,6 @@ static void credit_entropy_bits(struct entropy_store *r, int nbits)
 	if (!nbits)
 		return;
 
-	DEBUG_ENT("added %d entropy credits to %s\n", nbits, r->name);
 retry:
 	entropy_count = orig = ACCESS_ONCE(r->entropy_count);
 	if (nfrac < 0) {
@@ -655,7 +643,9 @@ retry:
 	}
 
 	if (entropy_count < 0) {
-		DEBUG_ENT("negative entropy/overflow\n");
+		pr_warn("random: negative entropy/overflow: pool %s count %d\n",
+			r->name, entropy_count);
+		WARN_ON(1);
 		entropy_count = 0;
 	} else if (entropy_count > pool_size)
 		entropy_count = pool_size;
@@ -832,10 +822,10 @@ void add_input_randomness(unsigned int type, unsigned int code,
 	if (value == last_value)
 		return;
 
-	DEBUG_ENT("input event\n");
 	last_value = value;
 	add_timer_randomness(&input_timer_state,
 			     (type << 4) ^ code ^ (code >> 4) ^ value);
+	trace_add_input_randomness(ENTROPY_BITS(&input_pool));
 }
 EXPORT_SYMBOL_GPL(add_input_randomness);
 
@@ -890,10 +880,8 @@ void add_disk_randomness(struct gendisk *disk)
 	if (!disk || !disk->random)
 		return;
 	/* first major is 1, so we get >= 0x200 here */
-	DEBUG_ENT("disk event %d:%d\n",
-		  MAJOR(disk_devt(disk)), MINOR(disk_devt(disk)));
-
 	add_timer_randomness(disk->random, 0x100 + disk_devt(disk));
+	trace_add_disk_randomness(disk_devt(disk), ENTROPY_BITS(&input_pool));
 }
 #endif
 
@@ -941,10 +929,8 @@ static void _xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 	/* but never more than the buffer size */
 	bytes = min_t(int, bytes, sizeof(tmp));
 
-	DEBUG_ENT("going to reseed %s with %d bits (%zu of %d requested)\n",
-		  r->name, bytes * 8, nbytes * 8,
-		  r->entropy_count >> ENTROPY_SHIFT);
-
+	trace_xfer_secondary_pool(r->name, bytes * 8, nbytes * 8,
+				  ENTROPY_BITS(r), ENTROPY_BITS(r->pull));
 	bytes = extract_entropy(r->pull, tmp, bytes,
 				random_read_wakeup_thresh / 8, rsvd);
 	mix_pool_bytes(r, tmp, bytes, NULL);
@@ -992,8 +978,6 @@ static size_t account(struct entropy_store *r, size_t nbytes, int min,
 	spin_lock_irqsave(&r->lock, flags);
 
 	BUG_ON(r->entropy_count > r->poolinfo->poolfracbits);
-	DEBUG_ENT("trying to extract %zu bits from %s\n",
-		  nbytes * 8, r->name);
 
 	/* Can we pull enough? */
 retry:
@@ -1019,12 +1003,9 @@ retry:
 		    < random_write_wakeup_thresh)
 			wakeup_write = 1;
 	}
-
-	DEBUG_ENT("debiting %zu entropy credits from %s%s\n",
-		  ibytes * 8, r->name, r->limit ? "" : " (unlimited)");
-
 	spin_unlock_irqrestore(&r->lock, flags);
 
+	trace_debit_entropy(r->name, 8 * ibytes);
 	if (wakeup_write) {
 		wake_up_interruptible(&random_write_wait);
 		kill_fasync(&fasync, SIGIO, POLL_OUT);
@@ -1303,8 +1284,6 @@ random_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 		if (n > SEC_XFER_SIZE)
 			n = SEC_XFER_SIZE;
 
-		DEBUG_ENT("reading %zu bits\n", n*8);
-
 		n = extract_entropy_user(&blocking_pool, buf, n);
 
 		if (n < 0) {
@@ -1312,8 +1291,9 @@ random_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 			break;
 		}
 
-		DEBUG_ENT("read got %zd bits (%zd still needed)\n",
-			  n*8, (nbytes-n)*8);
+		trace_random_read(n*8, (nbytes-n)*8,
+				  ENTROPY_BITS(&blocking_pool),
+				  ENTROPY_BITS(&input_pool));
 
 		if (n == 0) {
 			if (file->f_flags & O_NONBLOCK) {
@@ -1321,14 +1301,10 @@ random_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 				break;
 			}
 
-			DEBUG_ENT("sleeping?\n");
-
 			wait_event_interruptible(random_read_wait,
 				ENTROPY_BITS(&input_pool) >=
 				random_read_wakeup_thresh);
 
-			DEBUG_ENT("awake\n");
-
 			if (signal_pending(current)) {
 				retval = -ERESTARTSYS;
 				break;
@@ -1350,7 +1326,11 @@ random_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 static ssize_t
 urandom_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 {
-	return extract_entropy_user(&nonblocking_pool, buf, nbytes);
+	int ret = extract_entropy_user(&nonblocking_pool, buf, nbytes);
+
+	trace_urandom_read(8 * nbytes, ENTROPY_BITS(&nonblocking_pool),
+			   ENTROPY_BITS(&input_pool));
+	return ret;
 }
 
 static unsigned int
diff --git a/include/trace/events/random.h b/include/trace/events/random.h
index 527b5dc..805af6d 100644
--- a/include/trace/events/random.h
+++ b/include/trace/events/random.h
@@ -109,6 +109,89 @@ TRACE_EVENT(push_to_pool,
 		  __entry->input_bits)
 );
 
+TRACE_EVENT(debit_entropy,
+	TP_PROTO(const char *pool_name, int debit_bits),
+
+	TP_ARGS(pool_name, debit_bits),
+
+	TP_STRUCT__entry(
+		__field( const char *,	pool_name		)
+		__field(	  int,	debit_bits		)
+	),
+
+	TP_fast_assign(
+		__entry->pool_name	= pool_name;
+		__entry->debit_bits	= debit_bits;
+	),
+
+	TP_printk("%s: debit_bits %d", __entry->pool_name,
+		  __entry->debit_bits)
+);
+
+TRACE_EVENT(add_input_randomness,
+	TP_PROTO(int input_bits),
+
+	TP_ARGS(input_bits),
+
+	TP_STRUCT__entry(
+		__field(	  int,	input_bits		)
+	),
+
+	TP_fast_assign(
+		__entry->input_bits	= input_bits;
+	),
+
+	TP_printk("input_pool_bits %d", __entry->input_bits)
+);
+
+TRACE_EVENT(add_disk_randomness,
+	TP_PROTO(dev_t dev, int input_bits),
+
+	TP_ARGS(dev, input_bits),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	  int,	input_bits		)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= dev;
+		__entry->input_bits	= input_bits;
+	),
+
+	TP_printk("dev %d,%d input_pool_bits %d", MAJOR(__entry->dev),
+		  MINOR(__entry->dev), __entry->input_bits)
+);
+
+TRACE_EVENT(xfer_secondary_pool,
+	TP_PROTO(const char *pool_name, int xfer_bits, int request_bits,
+		 int pool_entropy, int input_entropy),
+
+	TP_ARGS(pool_name, xfer_bits, request_bits, pool_entropy,
+		input_entropy),
+
+	TP_STRUCT__entry(
+		__field( const char *,	pool_name		)
+		__field(	  int,	xfer_bits		)
+		__field(	  int,	request_bits		)
+		__field(	  int,	pool_entropy		)
+		__field(	  int,	input_entropy		)
+	),
+
+	TP_fast_assign(
+		__entry->pool_name	= pool_name;
+		__entry->xfer_bits	= xfer_bits;
+		__entry->request_bits	= request_bits;
+		__entry->pool_entropy	= pool_entropy;
+		__entry->input_entropy	= input_entropy;
+	),
+
+	TP_printk("pool %s xfer_bits %d request_bits %d pool_entropy %d "
+		  "input_entropy %d", __entry->pool_name, __entry->xfer_bits,
+		  __entry->request_bits, __entry->pool_entropy,
+		  __entry->input_entropy)
+);
+
 DECLARE_EVENT_CLASS(random__get_random_bytes,
 	TP_PROTO(int nbytes, unsigned long IP),
 
@@ -179,7 +262,52 @@ DEFINE_EVENT(random__extract_entropy, extract_entropy_user,
 	TP_ARGS(pool_name, nbytes, entropy_count, IP)
 );
 
+TRACE_EVENT(random_read,
+	TP_PROTO(int got_bits, int need_bits, int pool_left, int input_left),
 
+	TP_ARGS(got_bits, need_bits, pool_left, input_left),
+
+	TP_STRUCT__entry(
+		__field(	  int,	got_bits		)
+		__field(	  int,	need_bits		)
+		__field(	  int,	pool_left		)
+		__field(	  int,	input_left		)
+	),
+
+	TP_fast_assign(
+		__entry->got_bits	= got_bits;
+		__entry->need_bits	= need_bits;
+		__entry->pool_left	= pool_left;
+		__entry->input_left	= input_left;
+	),
+
+	TP_printk("got_bits %d still_needed_bits %d "
+		  "blocking_pool_entropy_left %d input_entropy_left %d",
+		  __entry->got_bits, __entry->got_bits, __entry->pool_left,
+		  __entry->input_left)
+);
+
+TRACE_EVENT(urandom_read,
+	TP_PROTO(int got_bits, int pool_left, int input_left),
+
+	TP_ARGS(got_bits, pool_left, input_left),
+
+	TP_STRUCT__entry(
+		__field(	  int,	got_bits		)
+		__field(	  int,	pool_left		)
+		__field(	  int,	input_left		)
+	),
+
+	TP_fast_assign(
+		__entry->got_bits	= got_bits;
+		__entry->pool_left	= pool_left;
+		__entry->input_left	= input_left;
+	),
+
+	TP_printk("got_bits %d nonblocking_pool_entropy_left %d "
+		  "input_entropy_left %d", __entry->got_bits,
+		  __entry->pool_left, __entry->input_left)
+);
 
 #endif /* _TRACE_RANDOM_H */
 
-- 
1.7.12.rc0.22.gcdd159b

