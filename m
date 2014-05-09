Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088AbaEIJON (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 05:14:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40907 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783AbaEIJOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 05:14:09 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Dave Anderson <anderson@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Kay Sievers <kay@vrfy.org>, Jiri Kosina <jkosina@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.cz>
Subject: [RFC PATCH 06/11] printk: NMI safe printk
Date: Fri,  9 May 2014 11:11:00 +0200
Message-Id: <1399626665-29817-7-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1399626665-29817-1-git-send-email-pmladek@suse.cz>
References: <1399626665-29817-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk cannot be used in NMI context safely because it uses internal locks
and thus could cause a deadlock. Unfortunately there are circumstances when
calling printk from NMI is very useful. For example, all WARN.*(in_nmi())
would be much more helpful if they didn't lockup the machine.

Another example would be arch_trigger_all_cpu_backtrace for x86 which uses NMI
to dump traces on all CPU (either triggered by sysrq+l or from RCU stall
detector).

This patch prevents from deadlock on logbuf_lock by using trylock rather than
spin_lock. If the lock can not be taken, it uses NMI specific text, cont,
and log buffers to handle the message.

In order to synchronize parallel printks from NMI context there was a new lock
introduced. This one is held only from the NMI context and it doesn't nest into
any other lock so it is safe against deadlocks.

The most funny part is the operation that merges the messages back to the main
log buffer. It is usually done in the normal context. Thus it needs to read
from NMI log buffer without taking the "nmi_logbuf_lock".

The merging is relatively easy when you allow to ignore last messages in case
of full NMI log buffer. Then it is a simple producer and consumer problem.
log_store() modifies only "next_idx", "next_seq" and merge_nmi_delayed_printk()
modifies only "first_idx", "first_seq".

But we want the last messages. Thus log_store() needs to modify all four
"first_*" and "next_*" position variables. Then it is rally hard to read
them consistently in merge_nmi_delayed_printk(). Note that the function
can be interrupted at anytime and the NMI context could rotate the NMI log
buffer even several times.

The NMI log buffer could be relatively small, so there is relatively high
chance of rotation. Thus we cannot detect it by checking the "idx" values.

It would help to compare the sequence numbers where the rotation is almost
impossible. But then it is very hard to make sure that an "idx" and "seq"
values describe the same message.

The cleanest solution seems to be to modify "idx" and "seq" values in an atomic
operation. This is why they are stored in a single "unsigned long" and accessed
by the bunch of helper functions.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 kernel/printk/printk.c | 282 +++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 261 insertions(+), 21 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 7d0d5c714f71..12435f3ef2d4 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -154,6 +154,18 @@ static int console_may_schedule;
  */
 static DEFINE_RAW_SPINLOCK(main_logbuf_lock);
 
+#ifdef CONFIG_PRINTK
+/*
+ * The nmi_logbuf_lock protects writing into the nmi_log_buf. It is used in NMI
+ * context when logbuf_lock is already taken or it is not safe to take it. NEVER
+ * EVER take this lock outside of NMI context.
+ *
+ * The messages are moved from nmi_logbuf without this lock. Be careful about
+ * racing when writing and reading, see log_store and merge_nmi_delayed_printk.
+ */
+static DEFINE_RAW_SPINLOCK(nmi_logbuf_lock);
+#endif
+
 /*
  * The printk log buffer consists of a chain of concatenated variable
  * length records. Every record starts with a record header, containing
@@ -355,6 +367,8 @@ static struct printk_log nmi_log = {
 #define seq_from_id(id) (id & NMI_SEQ_MASK)
 #define make_id(idx, seq) (((unsigned long)idx << NMI_SEQ_BYTES) | \
 			   (seq & NMI_SEQ_MASK))
+/* maximum number of sequence numbers */
+#define NMI_MAX_SEQ (1UL << NMI_SEQ_BYTES)
 /*
  * Maximum length of the allocated buffer. It has to be a power of two.
  * It can be limited either by the maximum number of indexes or
@@ -363,6 +377,13 @@ static struct printk_log nmi_log = {
 #define NMI_MAX_LEN_POWER (min(NMI_IDX_BYTES, sizeof(nmi_log.buf_len) * 8 - 1))
 #define NMI_MAX_LEN (1UL << NMI_MAX_LEN_POWER)
 
+/* maximum number of messages that fit into NMI log buffer */
+static unsigned int nmi_max_messages;
+/* temporary buffer to print the formatted string */
+static char textbuf[LOG_LINE_MAX];
+/* temporary buffer to print the formatted string in NMI context */
+static char nmi_textbuf[LOG_LINE_MAX];
+
 /*
  * Define functions needed to get the position values,
  * for example, first_idx. Possible values are:
@@ -383,7 +404,6 @@ DEFINE_GET_POS(u64, get_first_seq, first, seq)
 DEFINE_GET_POS(u32, get_next_idx, next, idx)
 DEFINE_GET_POS(u64, get_next_seq, next, seq)
 
-
 /*
  * Define functions needed to set the position values,
  * for example, first_idx. Possible values are:
@@ -415,6 +435,12 @@ static char *get_dict(const struct printk_msg *msg)
 	return (char *)msg + sizeof(struct printk_msg) + msg->text_len;
 }
 
+/* safe variant that could be used in lock-less situation */
+static char *get_dict_safely(const struct printk_msg *msg, u16 text_len)
+{
+	return (char *)msg + sizeof(struct printk_msg) + text_len;
+}
+
 /* get record by index; idx must point to valid msg */
 static struct printk_msg *msg_from_idx(struct printk_log *log, u32 idx)
 {
@@ -507,18 +533,28 @@ static int logbuf_has_space(struct printk_log *log, u32 msg_size, bool empty)
 
 static int log_make_free_space(struct printk_log *log, u32 msg_size)
 {
+	int freed = 0;
+	int ret = 0;
+
 	while (get_first_seq(log) < get_next_seq(log)) {
 		if (logbuf_has_space(log, msg_size, false))
-			return 0;
+			goto out;
+
 		/* drop old messages until we have enough continuous space */
 		inc_first_pos(log);
+		freed = 1;
 	}
 
 	/* sequence numbers are equal, so the log buffer is empty */
-	if (logbuf_has_space(log, msg_size, true))
-		return 0;
+	if (!logbuf_has_space(log, msg_size, true))
+		ret = -ENOMEM;
 
-	return -ENOMEM;
+out:
+	/* propagate the updated values before the freed space is overwritten */
+	if (unlikely(log == &nmi_log) && freed)
+		smp_wmb();
+
+	return ret;
 }
 
 /* compute the message size including the padding bytes */
@@ -614,6 +650,10 @@ static int log_store(struct printk_log *log, int facility, int level,
 	memset(get_dict(msg) + dict_len, 0, pad_len);
 	msg->len = size;
 
+	/* write the data before we move to the next position */
+	if (log == &nmi_log)
+		smp_wmb();
+
 	/* insert message */
 	inc_next_pos(log);
 
@@ -1042,6 +1082,7 @@ void __init setup_log_buf(int early)
 	if (!nmi_log.buf) {
 		if (nmi_log.buf_len > NMI_MAX_LEN)
 			nmi_log.buf_len = NMI_MAX_LEN;
+		nmi_max_messages = nmi_log.buf_len / sizeof(struct printk_msg);
 		/* zero length means that the feature is disabled */
 		if (nmi_log.buf_len)
 			nmi_log.buf = alloc_log_buf(early, nmi_log.buf_len);
@@ -1766,6 +1807,170 @@ static size_t cont_print_text(char *text, size_t size)
 	return textlen;
 }
 
+/*
+ * This function copies one message from NMI log buffer to the main one.
+ * It cannot guarantee that a valid data are copied because NMI buffer
+ * can be modified in parallel. It just do some basic checks, especially
+ * to make sure that we do not read outside of the buffer. Anyway, the
+ * caller should do more checks, for example by validating the sequence
+ * number.
+ */
+static int merge_nmi_msg(u32 merge_idx, u64 merge_seq)
+{
+	struct printk_msg *msg;
+	u16 text_len, dict_len;
+	u32 after_msg_idx, pad_len, size, counted_size;
+
+	/*
+	 * The given idx might be invalid, especially when it was read via
+	 * inc_idx() without having the related log buffer lock.
+	 */
+	if (merge_idx > nmi_log.buf_len - sizeof(struct printk_msg))
+		return -EINVAL;
+
+	/*
+	 * Get more info about the message. The values could be modified in NMI
+	 * context at any time.
+	 */
+	msg = msg_from_idx(&nmi_log, merge_idx);
+	text_len = ACCESS_ONCE(msg->text_len);
+	dict_len = ACCESS_ONCE(msg->dict_len);
+	size = ACCESS_ONCE(msg->len);
+
+	/* check a bit the consistency */
+	counted_size = msg_used_size(text_len, dict_len, &pad_len);
+	if (counted_size != size)
+		return -EINVAL;
+	/*
+	 * Make sure that we do not read outside of NMI log buf.
+	 *
+	 * First, get the real idx. The original one might have pointed to the
+	 * zero length message that signalizes the end of the buffer. Thus we
+	 * need to compute it from the "msg" pointer.
+	 */
+	merge_idx = (char *)msg - nmi_log.buf;
+	after_msg_idx = merge_idx + counted_size;
+	if (after_msg_idx > nmi_log.buf_len)
+		return -EINVAL;
+
+	log_store(&main_log, msg->facility, msg->level,
+		  msg->flags, msg->ts_nsec,
+		  get_dict_safely(msg, text_len), dict_len,
+		  get_text(msg), text_len);
+
+	return 0;
+}
+
+/*
+ * Unfortunately, we could not guarantee that a sequence number
+ * is 100% valid because the whole range can get rotated in NMI
+ * context between readings in the normal context.
+ *
+ * This is just the best guess. Any valid sequence number must in
+ * the range from first_seq to first_seq + maximum number of
+ * messages that fit the buffer.
+ *
+ * Invalid result is not critical because it will get detected
+ * by the consistency check in merge_nmi_msg(). In the worst case
+ * it will copy some mess and the inconsistency will get detected
+ * and resolved later.
+ */
+static int nmi_seq_is_invalid(u64 seq, u64 first_seq)
+{
+	if (seq >= first_seq) {
+		if (seq - first_seq > nmi_max_messages)
+			return 1;
+		else
+			return 0;
+	}
+
+	if (first_seq - seq < NMI_MAX_SEQ - nmi_max_messages)
+		return 1;
+	else
+		return 0;
+}
+
+/*
+ * Called to merge strings from NMI ring buffer into the regular ring buffer.
+ *
+ * Messages can be asynchronously added and even removed in NMI context under
+ * nmi_logbuf_lock. We need to be VERY CAUTIOUS and work with valid indexes all
+ * the time. We even might need to revert a store operation if the message
+ * gets overwritten in the meantime.
+ */
+static void merge_nmi_delayed_printk(void)
+{
+	static u64 nmi_merge_seq;
+	static u32 nmi_merge_idx;
+	unsigned long nmi_first_id, nmi_next_id;
+	u32 old_main_next_idx;
+	u64 old_main_next_seq;
+
+	while (true) {
+		/*
+		 * Refresh next_id information in every iteration. There might
+		 * be new messages.
+		 */
+		nmi_next_id = ACCESS_ONCE(nmi_log.nmi.next_id);
+
+		/* we are done when all messages have been merged already */
+		if (likely(nmi_merge_seq == seq_from_id(nmi_next_id)))
+			return;
+
+		/* check if we lost some messages */
+		nmi_first_id = ACCESS_ONCE(nmi_log.nmi.first_id);
+		if (nmi_seq_is_invalid(nmi_merge_seq,
+				       seq_from_id(nmi_first_id))) {
+restart_merge:
+			nmi_merge_seq = seq_from_id(nmi_first_id);
+			nmi_merge_idx = idx_from_id(nmi_first_id);
+		}
+
+		/*
+		 * Make sure that the whole message has been written for the
+		 * given idx.
+		 */
+		smp_rmb();
+		/* store current state of the main log buffer */
+		old_main_next_idx = get_next_idx(&main_log);
+		old_main_next_seq = get_next_seq(&main_log);
+		/* restart merge if copying fails */
+		if (merge_nmi_msg(nmi_merge_idx, nmi_merge_seq)) {
+			nmi_first_id = ACCESS_ONCE(nmi_log.nmi.first_id);
+			goto restart_merge;
+		}
+
+		/*
+		 * Make sure that the data were copied before validating. We
+		 * check that we did read correct data, so read the barrier is
+		 * enough.
+		 */
+		smp_rmb();
+		/* check if we have copied a valid message */
+		nmi_first_id = ACCESS_ONCE(nmi_log.nmi.first_id);
+		if (nmi_seq_is_invalid(nmi_merge_seq,
+				       seq_from_id(nmi_first_id))) {
+			/*
+			 * The copied message does not longer exist in the NMI
+			 * log buffer. It was most likely modified during
+			 * copying, so forget it and restart the merge.
+			 */
+			set_next_pos(&main_log,
+				     old_main_next_idx, old_main_next_seq);
+			goto restart_merge;
+		}
+
+		/*
+		 * The message was valid when copying. Go to next one. Note that
+		 * we might read broken idx here that might point outside of the
+		 * log buffer. But this will be detected in merge_nmi_msg() when
+		 * checking the index validity.
+		 */
+		nmi_merge_idx = inc_idx(&nmi_log, nmi_merge_idx);
+		nmi_merge_seq = inc_seq(&nmi_log, nmi_merge_seq);
+	}
+}
+
 asmlinkage int vprintk_emit(int facility, int level,
 			    const char *dict, size_t dictlen,
 			    const char *fmt, va_list args)
@@ -1773,7 +1978,6 @@ asmlinkage int vprintk_emit(int facility, int level,
 	struct printk_log *log = &main_log;
 	struct printk_cont *cont = main_log.cont;
 	static int recursion_bug;
-	static char textbuf[LOG_LINE_MAX];
 	char *text = textbuf;
 	size_t text_len = 0;
 	enum log_flags lflags = 0;
@@ -1799,7 +2003,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 	/*
 	 * Ouch, printk recursed into itself!
 	 */
-	if (unlikely(logbuf_cpu == this_cpu)) {
+	if (unlikely(logbuf_cpu == this_cpu) && !in_nmi()) {
 		/*
 		 * If a crash is occurring during printk() on this CPU,
 		 * then try to get the crash message out but make sure
@@ -1816,18 +2020,46 @@ asmlinkage int vprintk_emit(int facility, int level,
 	}
 
 	lockdep_off();
-	raw_spin_lock(&main_logbuf_lock);
-	logbuf_cpu = this_cpu;
 
-	if (recursion_bug) {
-		static const char recursion_msg[] =
-			"BUG: recent printk recursion!";
+	/*
+	 * Get lock for a log buffer. Make sure we are not going to deadlock
+	 * when we managed to preempt the currently running printk from NMI
+	 * context. When we are not sure, rather copy the current message
+	 * into NMI ring buffer and merge it later.
+	 */
+	if (likely(!in_nmi())) {
+		raw_spin_lock(&main_logbuf_lock);
+	} else {
+		if (!raw_spin_trylock(&main_logbuf_lock)) {
+			if (!nmi_log.buf) {
+				lockdep_on();
+				local_irq_restore(flags);
+				return 0;
+			}
 
-		recursion_bug = 0;
-		text_len = strlen(recursion_msg);
-		/* emit KERN_CRIT message */
-		printed_len += log_store(log, 0, 2, LOG_PREFIX|LOG_NEWLINE, 0,
-					 NULL, 0, recursion_msg, text_len);
+			raw_spin_lock(&nmi_logbuf_lock);
+			log = &nmi_log;
+			cont = &nmi_cont;
+			text = nmi_textbuf;
+		}
+	}
+
+	if (likely(log == &main_log)) {
+		logbuf_cpu = this_cpu;
+		merge_nmi_delayed_printk();
+
+		if (recursion_bug) {
+			static const char recursion_msg[] =
+				"BUG: recent printk recursion!";
+
+			recursion_bug = 0;
+			text_len = strlen(recursion_msg);
+			/* emit KERN_CRIT message */
+			printed_len += log_store(log, 0, 2,
+						 LOG_PREFIX|LOG_NEWLINE, 0,
+						 NULL, 0, recursion_msg,
+						 text_len);
+		}
 	}
 
 	/*
@@ -1918,13 +2150,21 @@ asmlinkage int vprintk_emit(int facility, int level,
 						 text, text_len);
 	}
 
-	logbuf_cpu = UINT_MAX;
-	raw_spin_unlock(&main_logbuf_lock);
+	if (likely(log == &main_log)) {
+		logbuf_cpu = UINT_MAX;
+		raw_spin_unlock(&main_logbuf_lock);
+	} else {
+		raw_spin_unlock(&nmi_logbuf_lock);
+	}
+
 	lockdep_on();
 	local_irq_restore(flags);
 
-	/* If called from the scheduler, we can not call up(). */
-	if (in_sched)
+	/*
+	 * If called from the scheduler or NMI context, we can not get console
+	 * without a possible deadlock.
+	 */
+	if (in_sched || in_nmi())
 		return printed_len;
 
 	/*
-- 
1.8.4

