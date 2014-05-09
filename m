Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429AbaEIJMy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 05:12:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40846 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756372AbaEIJMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 05:12:48 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Dave Anderson <anderson@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Kay Sievers <kay@vrfy.org>, Jiri Kosina <jkosina@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.cz>
Subject: [RFC PATCH 02/11] printk: allow to handle more log buffers
Date: Fri,  9 May 2014 11:10:56 +0200
Message-Id: <1399626665-29817-3-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1399626665-29817-1-git-send-email-pmladek@suse.cz>
References: <1399626665-29817-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is another preparation patch for NMI safe printk implementation. An extra
log buffer will be used in NMI context when the lock for the main ring buffer
is already taken. It is not possible to wait for the main lock because it can
cause a deadlock.

This patch creates struct "printk_log" and put there all variables that are
needed to handle the log buffer, including pointer to the "cont" buffer.
This is why it renames "struct cont" to "struct printk_cont" and moves the
declaration to the top.

Unfortunately, index and sequence values will need to be modified without a lock
when the NMI log buffer will be merged back to the main log buffer. The only
safe solution is to atomically read and write both, the index and the sequence
number. It means that both values need to fit "unsigned long".

Using "unsigned long" for both "idx" and "seq" is fine for the temporary NMI
log buffer but it would limit the main log buffer too much, especially on
32-bit architectures. Therefore, we put these values into the separate
"struct printk_main_log_pos" and put it into "struct printk_log" via
an union.

The global buffers are declared as "main_cont" and "main_log". Then they
will be clearly distinguished from the NMI variant.

The patch also introduces several helper function to make it easier to access
the "idx" and "seq" values. Note that they will be more complicated once we
introduce the NMI log buffer where both values need to be updated atomically.

In addition, the function log_next() is renamed to inc_idx(). The intention
is to make it consistent with the new inc_seq(). Note that the "next_" prefix
could not be used because "next_idx" and "next_seq" is already used to mark
the last message in the ring buffer.

The followup patches will add "nmi_log" and "nmi_cont" that will be used to
temporary store messages printed in the NMI context. They will be merged into
the main log buffer when the "logbuf_lock" is available.

The functions working with console, syslog, and kmsg will work only with the
main ring buffer, so we could hardcode it there. Only the functions, that are
used to store the information into the ring buffer, will work with the selected
ring buffer and we need to pass it as a parameter.

IMPORTANT: This change causes problems for the external tools that are accessing
the structures, e.g. crash, makedumpfile. They need to get updated.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 kernel/printk/printk.c | 530 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 324 insertions(+), 206 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index e0fd7a1c0c1e..c560ebdecc04 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -148,6 +148,13 @@ EXPORT_SYMBOL(console_set_on_cmdline);
 static int console_may_schedule;
 
 /*
+ * The logbuf_lock protects kmsg buffer, indexes, counters. This can be taken
+ * within the scheduler's rq lock. It must be released before calling
+ * console_unlock() or anything else that might wake up a process.
+ */
+static DEFINE_RAW_SPINLOCK(logbuf_lock);
+
+/*
  * The printk log buffer consists of a chain of concatenated variable
  * length records. Every record starts with a record header, containing
  * the overall length of the record.
@@ -231,29 +238,51 @@ struct printk_msg {
 	u8 level:3;		/* syslog level */
 };
 
+#ifdef CONFIG_PRINTK
 /*
- * The logbuf_lock protects kmsg buffer, indices, counters.  This can be taken
- * within the scheduler's rq lock. It must be released before calling
- * console_unlock() or anything else that might wake up a process.
+ * Continuation lines are buffered, and not committed to the record buffer
+ * until the line is complete, or a race forces it. The line fragments
+ * though, are printed immediately to the consoles to ensure everything has
+ * reached the console in case of a kernel crash.
  */
-static DEFINE_RAW_SPINLOCK(logbuf_lock);
+struct printk_cont {
+	char *buf;
+	size_t len;			/* length == 0 means unused buffer */
+	size_t cons;			/* bytes written to console */
+	struct task_struct *owner;	/* task of first print*/
+	u64 ts_nsec;			/* time of first print */
+	u8 level;			/* log level of first message */
+	u8 facility;			/* log level of first message */
+	enum log_flags flags;		/* prefix, newline flags */
+	bool flushed:1;			/* buffer sealed and committed */
+};
+
+/* positions of messages in the main log buffer */
+struct printk_main_log_pos {
+	u64 first_seq;		/* sequence number of the first record */
+	u32 first_idx;		/* index of the first record */
+	u64 next_seq;		/* sequence number of the next rec. to store */
+	u32 next_idx;		/* index of the next record to store */
+};
+
+/* information needed to manipulate the log buffer */
+struct printk_log {
+	struct printk_cont *cont;	/* merging continuous message */
+	char *buf;			/* ring buffer */
+	u32 buf_len;			/* size of the ring buffer */
+	union {
+		struct printk_main_log_pos main;
+	};
+};
 
-#ifdef CONFIG_PRINTK
 DECLARE_WAIT_QUEUE_HEAD(log_wait);
+
 /* the next printk record to read by syslog(READ) or /proc/kmsg */
 static u64 syslog_seq;
 static u32 syslog_idx;
 static enum log_flags syslog_prev;
 static size_t syslog_partial;
 
-/* index and sequence number of the first record stored in the buffer */
-static u64 log_first_seq;
-static u32 log_first_idx;
-
-/* index and sequence number of the next record to store in the buffer */
-static u64 log_next_seq;
-static u32 log_next_idx;
-
 /* the next printk record to write to the console */
 static u64 console_seq;
 static u32 console_idx;
@@ -274,8 +303,50 @@ static u32 clear_idx;
 #endif
 #define __LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
 static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
-static char *log_buf = __log_buf;
-static u32 log_buf_len = __LOG_BUF_LEN;
+static char __main_cont_buf[LOG_LINE_MAX];
+
+static struct printk_cont main_cont = {
+	.buf = __main_cont_buf,
+};
+
+static struct printk_log main_log = {
+	.buf = __log_buf,
+	.buf_len = __LOG_BUF_LEN,
+	.cont = &main_cont,
+};
+
+/*
+ * Define functions needed to get the position values,
+ * for example, first_idx. Possible values are:
+ *	+ side: "first", "next"
+ *	+ pos: "idx", "seq"
+ */
+#define DEFINE_GET_POS(rettype, funcname, side, pos)		\
+static rettype funcname(const struct printk_log *log)		\
+{								\
+	return log->main.side##_##pos;				\
+}
+
+DEFINE_GET_POS(u32, get_first_idx, first, idx)
+DEFINE_GET_POS(u64, get_first_seq, first, seq)
+DEFINE_GET_POS(u32, get_next_idx, next, idx)
+DEFINE_GET_POS(u64, get_next_seq, next, seq)
+
+
+/*
+ * Define functions needed to set the position values,
+ * for example, first_idx. Possible values are:
+ *	+ side: "first", "next"
+ */
+#define DEFINE_SET_POS(funcname, side)					\
+static void funcname(struct printk_log *log, u32 idx, u64 seq)		\
+{									\
+	log->main.side##_idx = idx;					\
+	log->main.side##_seq = seq;				\
+}
+
+DEFINE_SET_POS(set_first_pos, first)
+DEFINE_SET_POS(set_next_pos, next)
 
 /* human readable text of the record */
 static char *get_text(const struct printk_msg *msg)
@@ -290,23 +361,23 @@ static char *get_dict(const struct printk_msg *msg)
 }
 
 /* get record by index; idx must point to valid msg */
-static struct printk_msg *msg_from_idx(u32 idx)
+static struct printk_msg *msg_from_idx(struct printk_log *log, u32 idx)
 {
-	struct printk_msg *msg = (struct printk_msg *)(log_buf + idx);
+	struct printk_msg *msg = (struct printk_msg *)(log->buf + idx);
 
 	/*
 	 * A length == 0 record is the end of buffer marker. Wrap around and
 	 * read the message at the start of the buffer.
 	 */
 	if (!msg->len)
-		return (struct printk_msg *)log_buf;
+		return (struct printk_msg *)log->buf;
 	return msg;
 }
 
 /* get next record; idx must point to valid msg */
-static u32 log_next(u32 idx)
+static u32 inc_idx(struct printk_log *log, u32 idx)
 {
-	struct printk_msg *msg = (struct printk_msg *)(log_buf + idx);
+	struct printk_msg *msg = (struct printk_msg *)(log->buf + idx);
 
 	/* length == 0 indicates the end of the buffer; wrap */
 	/*
@@ -315,12 +386,41 @@ static u32 log_next(u32 idx)
 	 * return the one after that.
 	 */
 	if (!msg->len) {
-		msg = (struct printk_msg *)log_buf;
+		msg = (struct printk_msg *)log->buf;
 		return msg->len;
 	}
 	return idx + msg->len;
 }
 
+/* get next sequence number for the given one */
+static u64 inc_seq(struct printk_log *log, u64 seq)
+{
+	return ++seq;
+}
+
+/*
+ * Define helper functions to move the position to the next message
+ * a safe way. Possible values are:
+ *	+ side: "first", "next"
+ */
+#define GENERATE_INC_POS(funcname, side)	\
+static void funcname(struct printk_log *log)	\
+{						\
+	u32 idx;				\
+	u64 seq;				\
+						\
+	idx = get_##side##_idx(log);		\
+	seq = get_##side##_seq(log);		\
+						\
+	idx = inc_idx(log, idx);		\
+	seq = inc_seq(log, seq);		\
+						\
+	set_##side##_pos(log, idx, seq);	\
+}
+
+GENERATE_INC_POS(inc_first_pos, first)
+GENERATE_INC_POS(inc_next_pos, next)
+
 /*
  * Check whether there is enough free space for the given message.
  *
@@ -330,14 +430,15 @@ static u32 log_next(u32 idx)
  * If the buffer is empty, we must respect the position of the indexes.
  * They cannot be reset to the beginning of the buffer.
  */
-static int logbuf_has_space(u32 msg_size, bool empty)
+static int logbuf_has_space(struct printk_log *log, u32 msg_size, bool empty)
 {
 	u32 free;
 
-	if (log_next_idx > log_first_idx || empty)
-		free = max(log_buf_len - log_next_idx, log_first_idx);
+	if (get_next_idx(log) > get_first_idx(log) || empty)
+		free = max(log->buf_len - get_next_idx(log),
+			   get_first_idx(log));
 	else
-		free = log_first_idx - log_next_idx;
+		free = get_first_idx(log) - get_next_idx(log);
 
 	/*
 	 * We need space also for an empty header that signalizes wrapping
@@ -346,18 +447,17 @@ static int logbuf_has_space(u32 msg_size, bool empty)
 	return free >= msg_size + sizeof(struct printk_msg);
 }
 
-static int log_make_free_space(u32 msg_size)
+static int log_make_free_space(struct printk_log *log, u32 msg_size)
 {
-	while (log_first_seq < log_next_seq) {
-		if (logbuf_has_space(msg_size, false))
+	while (get_first_seq(log) < get_next_seq(log)) {
+		if (logbuf_has_space(log, msg_size, false))
 			return 0;
 		/* drop old messages until we have enough continuous space */
-		log_first_idx = log_next(log_first_idx);
-		log_first_seq++;
+		inc_first_pos(log);
 	}
 
 	/* sequence numbers are equal, so the log buffer is empty */
-	if (logbuf_has_space(msg_size, true))
+	if (logbuf_has_space(log, msg_size, true))
 		return 0;
 
 	return -ENOMEM;
@@ -383,14 +483,15 @@ static u32 msg_used_size(u16 text_len, u16 dict_len, u32 *pad_len)
 #define MAX_LOG_TAKE_PART 4
 static const char trunc_msg[] = "<truncated>";
 
-static u32 truncate_msg(u16 *text_len, u16 *trunc_msg_len,
+static u32 truncate_msg(struct printk_log *log,
+			u16 *text_len, u16 *trunc_msg_len,
 			u16 *dict_len, u32 *pad_len)
 {
 	/*
 	 * The message should not take the whole buffer. Otherwise, it might
 	 * get removed too soon.
 	 */
-	u32 max_text_len = log_buf_len / MAX_LOG_TAKE_PART;
+	u32 max_text_len = log->buf_len / MAX_LOG_TAKE_PART;
 	if (*text_len > max_text_len)
 		*text_len = max_text_len;
 	/* enable the warning message */
@@ -402,7 +503,7 @@ static u32 truncate_msg(u16 *text_len, u16 *trunc_msg_len,
 }
 
 /* insert record into the buffer, discard old ones, update heads */
-static int log_store(int facility, int level,
+static int log_store(struct printk_log *log, int facility, int level,
 		     enum log_flags flags, u64 ts_nsec,
 		     const char *dict, u16 dict_len,
 		     const char *text, u16 text_len)
@@ -414,27 +515,29 @@ static int log_store(int facility, int level,
 	/* number of '\0' padding bytes to next message */
 	size = msg_used_size(text_len, dict_len, &pad_len);
 
-	if (log_make_free_space(size)) {
+	if (log_make_free_space(log, size)) {
 		/* truncate the message if it is too long for empty buffer */
-		size = truncate_msg(&text_len, &trunc_msg_len,
+		size = truncate_msg(log, &text_len, &trunc_msg_len,
 				    &dict_len, &pad_len);
 		/* survive when the log buffer is too small for trunc_msg */
-		if (log_make_free_space(size))
+		if (log_make_free_space(log, size))
 			return 0;
 	}
 
-	if (log_next_idx + size + sizeof(struct printk_msg) > log_buf_len) {
+	if (get_next_idx(log) + size + sizeof(struct printk_msg) >
+	    log->buf_len) {
 		/*
 		 * This message + an additional empty header does not fit
 		 * at the end of the buffer. Add an empty header with len == 0
 		 * to signify a wrap around.
 		 */
-		memset(log_buf + log_next_idx, 0, sizeof(struct printk_msg));
-		log_next_idx = 0;
+		memset(log->buf + get_next_idx(log), 0,
+		       sizeof(struct printk_msg));
+		set_next_pos(log, 0, get_next_seq(log));
 	}
 
 	/* fill message */
-	msg = (struct printk_msg *)(log_buf + log_next_idx);
+	msg = (struct printk_msg *)(log->buf + get_next_idx(log));
 	memcpy(get_text(msg), text, text_len);
 	msg->text_len = text_len;
 	if (trunc_msg_len) {
@@ -454,8 +557,7 @@ static int log_store(int facility, int level,
 	msg->len = size;
 
 	/* insert message */
-	log_next_idx += msg->len;
-	log_next_seq++;
+	inc_next_pos(log);
 
 	return msg->text_len;
 }
@@ -590,7 +692,7 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 	if (ret)
 		return ret;
 	raw_spin_lock_irq(&logbuf_lock);
-	while (user->seq == log_next_seq) {
+	while (user->seq == get_next_seq(&main_log)) {
 		if (file->f_flags & O_NONBLOCK) {
 			ret = -EAGAIN;
 			raw_spin_unlock_irq(&logbuf_lock);
@@ -599,22 +701,23 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 
 		raw_spin_unlock_irq(&logbuf_lock);
 		ret = wait_event_interruptible(log_wait,
-					       user->seq != log_next_seq);
+					       user->seq !=
+					       get_next_seq(&main_log));
 		if (ret)
 			goto out;
 		raw_spin_lock_irq(&logbuf_lock);
 	}
 
-	if (user->seq < log_first_seq) {
+	if (user->seq < get_first_seq(&main_log)) {
 		/* our last seen message is gone, return error and reset */
-		user->idx = log_first_idx;
-		user->seq = log_first_seq;
+		user->idx = get_first_idx(&main_log);
+		user->seq = get_first_seq(&main_log);
 		ret = -EPIPE;
 		raw_spin_unlock_irq(&logbuf_lock);
 		goto out;
 	}
 
-	msg = msg_from_idx(user->idx);
+	msg = msg_from_idx(&main_log, user->idx);
 	ts_usec = msg->ts_nsec;
 	do_div(ts_usec, 1000);
 
@@ -675,7 +778,7 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 		user->buf[len++] = '\n';
 	}
 
-	user->idx = log_next(user->idx);
+	user->idx = inc_idx(&main_log, user->idx);
 	user->seq++;
 	raw_spin_unlock_irq(&logbuf_lock);
 
@@ -708,8 +811,8 @@ static loff_t devkmsg_llseek(struct file *file, loff_t offset, int whence)
 	switch (whence) {
 	case SEEK_SET:
 		/* the first record */
-		user->idx = log_first_idx;
-		user->seq = log_first_seq;
+		user->idx = get_first_idx(&main_log);
+		user->seq = get_first_seq(&main_log);
 		break;
 	case SEEK_DATA:
 		/*
@@ -722,8 +825,8 @@ static loff_t devkmsg_llseek(struct file *file, loff_t offset, int whence)
 		break;
 	case SEEK_END:
 		/* after the last record */
-		user->idx = log_next_idx;
-		user->seq = log_next_seq;
+		user->idx = get_next_idx(&main_log);
+		user->seq = get_next_seq(&main_log);
 		break;
 	default:
 		ret = -EINVAL;
@@ -743,9 +846,9 @@ static unsigned int devkmsg_poll(struct file *file, poll_table *wait)
 	poll_wait(file, &log_wait, wait);
 
 	raw_spin_lock_irq(&logbuf_lock);
-	if (user->seq < log_next_seq) {
+	if (user->seq < get_next_seq(&main_log)) {
 		/* return error when data has vanished underneath us */
-		if (user->seq < log_first_seq)
+		if (user->seq < get_first_seq(&main_log))
 			ret = POLLIN|POLLRDNORM|POLLERR|POLLPRI;
 		else
 			ret = POLLIN|POLLRDNORM;
@@ -776,8 +879,8 @@ static int devkmsg_open(struct inode *inode, struct file *file)
 	mutex_init(&user->lock);
 
 	raw_spin_lock_irq(&logbuf_lock);
-	user->idx = log_first_idx;
-	user->seq = log_first_seq;
+	user->idx = get_first_idx(&main_log);
+	user->seq = get_first_seq(&main_log);
 	raw_spin_unlock_irq(&logbuf_lock);
 
 	file->private_data = user;
@@ -816,10 +919,13 @@ const struct file_operations kmsg_fops = {
  */
 void log_buf_kexec_setup(void)
 {
-	VMCOREINFO_SYMBOL(log_buf);
-	VMCOREINFO_SYMBOL(log_buf_len);
-	VMCOREINFO_SYMBOL(log_first_idx);
-	VMCOREINFO_SYMBOL(log_next_idx);
+	VMCOREINFO_STRUCT_SIZE(printk_log);
+	VMCOREINFO_OFFSET(printk_log, buf);
+	VMCOREINFO_OFFSET(printk_log, buf_len);
+	VMCOREINFO_OFFSET(printk_log, main);
+	VMCOREINFO_STRUCT_SIZE(printk_main_log_pos);
+	VMCOREINFO_OFFSET(printk_main_log_pos, first_idx);
+	VMCOREINFO_OFFSET(printk_main_log_pos, next_idx);
 	/*
 	 * Export struct printk_msg size and field offsets. User space tools can
 	 * parse it and detect any changes to structure down the line.
@@ -842,7 +948,7 @@ static int __init log_buf_len_setup(char *str)
 
 	if (size)
 		size = roundup_pow_of_two(size);
-	if (size > log_buf_len)
+	if (size > main_log.buf_len)
 		new_log_buf_len = size;
 
 	return 0;
@@ -872,14 +978,14 @@ void __init setup_log_buf(int early)
 	}
 
 	raw_spin_lock_irqsave(&logbuf_lock, flags);
-	log_buf_len = new_log_buf_len;
-	log_buf = new_log_buf;
+	main_log.buf_len = new_log_buf_len;
+	main_log.buf = new_log_buf;
 	new_log_buf_len = 0;
-	free = __LOG_BUF_LEN - log_next_idx;
-	memcpy(log_buf, __log_buf, __LOG_BUF_LEN);
+	free = __LOG_BUF_LEN - get_next_idx(&main_log);
+	memcpy(main_log.buf, __log_buf, __LOG_BUF_LEN);
 	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 
-	pr_info("log_buf_len: %d\n", log_buf_len);
+	pr_info("log_buf_len: %d\n", main_log.buf_len);
 	pr_info("early log buf free: %d(%d%%)\n",
 		free, (free * 100) / __LOG_BUF_LEN);
 }
@@ -1074,25 +1180,25 @@ static int syslog_print(char __user *buf, int size)
 		size_t skip;
 
 		raw_spin_lock_irq(&logbuf_lock);
-		if (syslog_seq < log_first_seq) {
+		if (syslog_seq < get_first_seq(&main_log)) {
 			/* messages are gone, move to first one */
-			syslog_seq = log_first_seq;
-			syslog_idx = log_first_idx;
+			syslog_seq = get_first_seq(&main_log);
+			syslog_idx = get_first_idx(&main_log);
 			syslog_prev = 0;
 			syslog_partial = 0;
 		}
-		if (syslog_seq == log_next_seq) {
+		if (syslog_seq == get_next_seq(&main_log)) {
 			raw_spin_unlock_irq(&logbuf_lock);
 			break;
 		}
 
 		skip = syslog_partial;
-		msg = msg_from_idx(syslog_idx);
+		msg = msg_from_idx(&main_log, syslog_idx);
 		n = msg_print_text(msg, syslog_prev, true, text,
 				   LOG_LINE_MAX + PREFIX_MAX);
 		if (n - syslog_partial <= size) {
 			/* message fits into buffer, move forward */
-			syslog_idx = log_next(syslog_idx);
+			syslog_idx = inc_idx(&main_log, syslog_idx);
 			syslog_seq++;
 			syslog_prev = msg->flags;
 			n -= syslog_partial;
@@ -1139,10 +1245,10 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 		u32 idx;
 		enum log_flags prev;
 
-		if (clear_seq < log_first_seq) {
+		if (clear_seq < get_first_seq(&main_log)) {
 			/* messages are gone, move to first available one */
-			clear_seq = log_first_seq;
-			clear_idx = log_first_idx;
+			clear_seq = get_first_seq(&main_log);
+			clear_idx = get_first_idx(&main_log);
 		}
 
 		/*
@@ -1152,12 +1258,12 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 		seq = clear_seq;
 		idx = clear_idx;
 		prev = 0;
-		while (seq < log_next_seq) {
-			struct printk_msg *msg = msg_from_idx(idx);
+		while (seq < get_next_seq(&main_log)) {
+			struct printk_msg *msg = msg_from_idx(&main_log, idx);
 
 			len += msg_print_text(msg, prev, true, NULL, 0);
 			prev = msg->flags;
-			idx = log_next(idx);
+			idx = inc_idx(&main_log, idx);
 			seq++;
 		}
 
@@ -1165,21 +1271,21 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 		seq = clear_seq;
 		idx = clear_idx;
 		prev = 0;
-		while (len > size && seq < log_next_seq) {
-			struct printk_msg *msg = msg_from_idx(idx);
+		while (len > size && seq < get_next_seq(&main_log)) {
+			struct printk_msg *msg = msg_from_idx(&main_log, idx);
 
 			len -= msg_print_text(msg, prev, true, NULL, 0);
 			prev = msg->flags;
-			idx = log_next(idx);
+			idx = inc_idx(&main_log, idx);
 			seq++;
 		}
 
 		/* last message fitting into this dump */
-		next_seq = log_next_seq;
+		next_seq = get_next_seq(&main_log);
 
 		len = 0;
 		while (len >= 0 && seq < next_seq) {
-			struct printk_msg *msg = msg_from_idx(idx);
+			struct printk_msg *msg = msg_from_idx(&main_log, idx);
 			int textlen;
 
 			textlen = msg_print_text(msg, prev, true, text,
@@ -1188,7 +1294,7 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 				len = textlen;
 				break;
 			}
-			idx = log_next(idx);
+			idx = inc_idx(&main_log, idx);
 			seq++;
 			prev = msg->flags;
 
@@ -1199,18 +1305,18 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 				len += textlen;
 			raw_spin_lock_irq(&logbuf_lock);
 
-			if (seq < log_first_seq) {
+			if (seq < get_first_seq(&main_log)) {
 				/* messages are gone, move to next one */
-				seq = log_first_seq;
-				idx = log_first_idx;
+				seq = get_first_seq(&main_log);
+				idx = get_first_idx(&main_log);
 				prev = 0;
 			}
 		}
 	}
 
 	if (clear) {
-		clear_seq = log_next_seq;
-		clear_idx = log_next_idx;
+		clear_seq = get_next_seq(&main_log);
+		clear_idx = get_next_idx(&main_log);
 	}
 	raw_spin_unlock_irq(&logbuf_lock);
 
@@ -1249,7 +1355,8 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 			goto out;
 		}
 		error = wait_event_interruptible(log_wait,
-						 syslog_seq != log_next_seq);
+						 syslog_seq !=
+						 get_next_seq(&main_log));
 		if (error)
 			goto out;
 		error = syslog_print(buf, len);
@@ -1304,10 +1411,10 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 	/* Number of chars in the log buffer */
 	case SYSLOG_ACTION_SIZE_UNREAD:
 		raw_spin_lock_irq(&logbuf_lock);
-		if (syslog_seq < log_first_seq) {
+		if (syslog_seq < get_first_seq(&main_log)) {
 			/* messages are gone, move to first one */
-			syslog_seq = log_first_seq;
-			syslog_idx = log_first_idx;
+			syslog_seq = get_first_seq(&main_log);
+			syslog_idx = get_first_idx(&main_log);
 			syslog_prev = 0;
 			syslog_partial = 0;
 		}
@@ -1317,18 +1424,20 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 			 * for pending data, not the size; return the count of
 			 * records, not the length.
 			 */
-			error = log_next_idx - syslog_idx;
+			error = get_next_idx(&main_log) - syslog_idx;
 		} else {
 			u64 seq = syslog_seq;
 			u32 idx = syslog_idx;
 			enum log_flags prev = syslog_prev;
 
 			error = 0;
-			while (seq < log_next_seq) {
-				struct printk_msg *msg = msg_from_idx(idx);
+			while (seq < get_next_seq(&main_log)) {
+				struct printk_msg *msg = msg_from_idx(&main_log,
+								      idx);
 
-				error += msg_print_text(msg, prev, true, NULL, 0);
-				idx = log_next(idx);
+				error += msg_print_text(msg, prev, true,
+							NULL, 0);
+				idx = inc_idx(&main_log, idx);
 				seq++;
 				prev = msg->flags;
 			}
@@ -1338,7 +1447,7 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 		break;
 	/* Size of the log buffer */
 	case SYSLOG_ACTION_SIZE_BUFFER:
-		error = log_buf_len;
+		error = main_log.buf_len;
 		break;
 	default:
 		error = -EINVAL;
@@ -1471,106 +1580,98 @@ static inline void printk_delay(void)
 	}
 }
 
-/*
- * Continuation lines are buffered, and not committed to the record buffer
- * until the line is complete, or a race forces it. The line fragments
- * though, are printed immediately to the consoles to ensure everything has
- * reached the console in case of a kernel crash.
- */
-static struct cont {
-	char buf[LOG_LINE_MAX];
-	size_t len;			/* length == 0 means unused buffer */
-	size_t cons;			/* bytes written to console */
-	struct task_struct *owner;	/* task of first print*/
-	u64 ts_nsec;			/* time of first print */
-	u8 level;			/* log level of first message */
-	u8 facility;			/* log level of first message */
-	enum log_flags flags;		/* prefix, newline flags */
-	bool flushed:1;			/* buffer sealed and committed */
-} cont;
-
-static void cont_flush(enum log_flags flags)
+static void cont_flush(struct printk_log *log, enum log_flags flags)
 {
-	if (cont.flushed)
+	struct printk_cont *cont = log->cont;
+
+	if (cont->flushed)
 		return;
-	if (cont.len == 0)
+	if (cont->len == 0)
 		return;
 
-	if (cont.cons) {
+	if (cont->cons) {
 		/*
 		 * If a fragment of this line was directly flushed to the
 		 * console; wait for the console to pick up the rest of the
 		 * line. LOG_NOCONS suppresses a duplicated output.
 		 */
-		log_store(cont.facility, cont.level, flags | LOG_NOCONS,
-			  cont.ts_nsec, NULL, 0, cont.buf, cont.len);
-		cont.flags = flags;
-		cont.flushed = true;
+		log_store(log, cont->facility, cont->level, flags | LOG_NOCONS,
+			  cont->ts_nsec, NULL, 0, cont->buf, cont->len);
+		cont->flags = flags;
+		cont->flushed = true;
 	} else {
 		/*
 		 * If no fragment of this line ever reached the console,
 		 * just submit it to the store and free the buffer.
 		 */
-		log_store(cont.facility, cont.level, flags, 0,
-			  NULL, 0, cont.buf, cont.len);
-		cont.len = 0;
+		log_store(log, cont->facility, cont->level, flags, 0,
+			  NULL, 0, cont->buf, cont->len);
+		cont->len = 0;
 	}
 }
 
-static bool cont_add(int facility, int level, const char *text, size_t len)
+static bool cont_add(struct printk_log *log, int facility, int level,
+		     const char *text, size_t len)
 {
-	if (cont.len && cont.flushed)
+	struct printk_cont *cont = log->cont;
+
+	if (cont->len && cont->flushed)
 		return false;
 
-	if (cont.len + len > sizeof(cont.buf)) {
+	if (cont->len + len > sizeof(cont->buf)) {
 		/* the line gets too long, split it up in separate records */
-		cont_flush(LOG_CONT);
+		cont_flush(log, LOG_CONT);
 		return false;
 	}
 
-	if (!cont.len) {
-		cont.facility = facility;
-		cont.level = level;
-		cont.owner = current;
-		cont.ts_nsec = local_clock();
-		cont.flags = 0;
-		cont.cons = 0;
-		cont.flushed = false;
+	if (!cont->len) {
+		cont->facility = facility;
+		cont->level = level;
+		cont->owner = current;
+		cont->ts_nsec = local_clock();
+		cont->flags = 0;
+		cont->cons = 0;
+		cont->flushed = false;
 	}
 
-	memcpy(cont.buf + cont.len, text, len);
-	cont.len += len;
+	memcpy(cont->buf + cont->len, text, len);
+	cont->len += len;
 
-	if (cont.len > (sizeof(cont.buf) * 80) / 100)
-		cont_flush(LOG_CONT);
+	if (cont->len > (sizeof(cont->buf) * 80) / 100)
+		cont_flush(log, LOG_CONT);
 
 	return true;
 }
 
+/*
+ * Only messages from the main log buffer are printed directly to
+ * the console. Therefore this function operates directly with the main
+ * continuous buffer.
+ */
 static size_t cont_print_text(char *text, size_t size)
 {
 	size_t textlen = 0;
 	size_t len;
 
-	if (cont.cons == 0 && (console_prev & LOG_NEWLINE)) {
-		textlen += print_time(cont.ts_nsec, text);
+	if (main_cont.cons == 0 && (console_prev & LOG_NEWLINE)) {
+		textlen += print_time(main_cont.ts_nsec, text);
 		size -= textlen;
 	}
 
-	len = cont.len - cont.cons;
+	len = main_cont.len - main_cont.cons;
 	if (len > 0) {
 		if (len+1 > size)
 			len = size-1;
-		memcpy(text + textlen, cont.buf + cont.cons, len);
+		memcpy(text + textlen, main_cont.buf + main_cont.cons, len);
 		textlen += len;
-		cont.cons = cont.len;
+		main_cont.cons = main_cont.len;
 	}
 
-	if (cont.flushed) {
-		if (cont.flags & LOG_NEWLINE)
+	if (main_cont.flushed) {
+		if (main_cont.flags & LOG_NEWLINE)
 			text[textlen++] = '\n';
 		/* got everything, release buffer */
-		cont.len = 0;
+		main_cont.len = 0;
 	}
 	return textlen;
 }
@@ -1579,6 +1680,8 @@ asmlinkage int vprintk_emit(int facility, int level,
 			    const char *dict, size_t dictlen,
 			    const char *fmt, va_list args)
 {
+	struct printk_log *log = &main_log;
+	struct printk_cont *cont = main_log.cont;
 	static int recursion_bug;
 	static char textbuf[LOG_LINE_MAX];
 	char *text = textbuf;
@@ -1633,7 +1736,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 		recursion_bug = 0;
 		text_len = strlen(recursion_msg);
 		/* emit KERN_CRIT message */
-		printed_len += log_store(0, 2, LOG_PREFIX|LOG_NEWLINE, 0,
+		printed_len += log_store(log, 0, 2, LOG_PREFIX|LOG_NEWLINE, 0,
 					 NULL, 0, recursion_msg, text_len);
 	}
 
@@ -1688,14 +1791,15 @@ asmlinkage int vprintk_emit(int facility, int level,
 		 * Flush the conflicting buffer. An earlier newline was missing,
 		 * or another task also prints continuation lines.
 		 */
-		if (cont.len && (lflags & LOG_PREFIX || cont.owner != current))
-			cont_flush(LOG_NEWLINE);
+		if (cont->len &&
+		    (lflags & LOG_PREFIX || cont->owner != current))
+			cont_flush(log, LOG_NEWLINE);
 
 		/* buffer line if possible, otherwise store it right away */
-		if (cont_add(facility, level, text, text_len))
+		if (cont_add(log, facility, level, text, text_len))
 			printed_len += text_len;
 		else
-			printed_len += log_store(facility, level,
+			printed_len += log_store(log, facility, level,
 						 lflags | LOG_CONT, 0,
 						 dict, dictlen, text, text_len);
 	} else {
@@ -1709,18 +1813,19 @@ asmlinkage int vprintk_emit(int facility, int level,
 		 * If the preceding printk was from a different task and missed
 		 * a newline, flush and append the newline.
 		 */
-		if (cont.len) {
-			if (cont.owner == current && !(lflags & LOG_PREFIX))
-				stored = cont_add(facility, level, text,
+		if (cont->len) {
+			if (cont->owner == current && !(lflags & LOG_PREFIX))
+				stored = cont_add(log, facility, level, text,
 						  text_len);
-			cont_flush(LOG_NEWLINE);
+			cont_flush(log, LOG_NEWLINE);
 		}
 
 		if (stored)
 			printed_len += text_len;
 		else
-			printed_len += log_store(facility, level, lflags, 0,
-						 dict, dictlen, text, text_len);
+			printed_len += log_store(log, facility, level, lflags,
+						 0, dict, dictlen,
+						 text, text_len);
 	}
 
 	logbuf_cpu = UINT_MAX;
@@ -1823,18 +1928,29 @@ static u32 syslog_idx;
 static u64 console_seq;
 static u32 console_idx;
 static enum log_flags syslog_prev;
-static u64 log_first_seq;
-static u32 log_first_idx;
-static u64 log_next_seq;
 static enum log_flags console_prev;
-static struct cont {
+static struct printk_cont {
 	size_t len;
 	size_t cons;
 	u8 level;
 	bool flushed:1;
-} cont;
-static struct printk_msg *msg_from_idx(u32 idx) { return NULL; }
-static u32 log_next(u32 idx) { return 0; }
+} main_cont;
+static struct printk_log {
+	u64 first_seq;
+	u32 first_idx;
+	u64 next_seq;
+} main_log;
+#define DEFINE_GET_POS(rettype, funcname)		\
+static rettype funcname(const struct printk_log *log)	\
+{							\
+	return 0;					\
+}
+DEFINE_GET_POS(u32, get_first_idx)
+DEFINE_GET_POS(u64, get_first_seq)
+DEFINE_GET_POS(u64, get_next_seq)
+static struct printk_msg *msg_from_idx(struct printk_log *log,
+				       u32 idx) { return NULL; }
+static u32 inc_idx(struct printk_log *log, u32 idx) { return 0; }
 static void call_console_drivers(int level, const char *text, size_t len) {}
 static size_t msg_print_text(const struct printk_msg *msg, enum log_flags prev,
 			     bool syslog, char *buf, size_t size) { return 0; }
@@ -2084,6 +2200,7 @@ int is_console_locked(void)
 	return console_locked;
 }
 
+/* only messages from the main cont buffer are flushed directly */
 static void console_cont_flush(char *text, size_t size)
 {
 	unsigned long flags;
@@ -2091,7 +2208,7 @@ static void console_cont_flush(char *text, size_t size)
 
 	raw_spin_lock_irqsave(&logbuf_lock, flags);
 
-	if (!cont.len)
+	if (!main_cont.len)
 		goto out;
 
 	/*
@@ -2099,13 +2216,13 @@ static void console_cont_flush(char *text, size_t size)
 	 * busy. The earlier ones need to be printed before this one, we
 	 * did not flush any fragment so far, so just let it queue up.
 	 */
-	if (console_seq < log_next_seq && !cont.cons)
+	if (console_seq < get_next_seq(&main_log) && !main_cont.cons)
 		goto out;
 
 	len = cont_print_text(text, size);
 	raw_spin_unlock(&logbuf_lock);
 	stop_critical_timings();
-	call_console_drivers(cont.level, text, len);
+	call_console_drivers(main_cont.level, text, len);
 	start_critical_timings();
 	local_irq_restore(flags);
 	return;
@@ -2152,35 +2269,36 @@ again:
 		int level;
 
 		raw_spin_lock_irqsave(&logbuf_lock, flags);
-		console_end_seq = log_next_seq;
+		console_end_seq = get_next_seq(&main_log);
 again_noirq:
-		if (seen_seq != log_next_seq) {
+		if (seen_seq != get_next_seq(&main_log)) {
 			wake_klogd = true;
-			seen_seq = log_next_seq;
+			seen_seq = get_next_seq(&main_log);
 		}
 
-		if (console_seq < log_first_seq) {
+		if (console_seq < get_first_seq(&main_log)) {
 			len = sprintf(text, "** %u printk messages dropped ** ",
-				      (unsigned)(log_first_seq - console_seq));
+				      (unsigned)(get_first_seq(&main_log) -
+						 console_seq));
 
 			/* messages are gone, move to first one */
-			console_seq = log_first_seq;
-			console_idx = log_first_idx;
+			console_seq = get_first_seq(&main_log);
+			console_idx = get_first_idx(&main_log);
 			console_prev = 0;
 		} else {
 			len = 0;
 		}
 skip:
-		if (console_seq == log_next_seq)
+		if (console_seq == get_next_seq(&main_log))
 			break;
 
-		msg = msg_from_idx(console_idx);
+		msg = msg_from_idx(&main_log, console_idx);
 		if (msg->flags & LOG_NOCONS) {
 			/*
 			 * Skip record we have buffered and already printed
 			 * directly to the console when we received it.
 			 */
-			console_idx = log_next(console_idx);
+			console_idx = inc_idx(&main_log, console_idx);
 			console_seq++;
 			/*
 			 * We will get here again when we register a new
@@ -2195,7 +2313,7 @@ skip:
 		level = msg->level;
 		len += msg_print_text(msg, console_prev, false,
 				      text + len, sizeof(text) - len);
-		console_idx = log_next(console_idx);
+		console_idx = inc_idx(&main_log, console_idx);
 		console_seq++;
 		console_prev = msg->flags;
 		raw_spin_unlock(&logbuf_lock);
@@ -2228,7 +2346,7 @@ skip:
 	 * flush, no worries.
 	 */
 	raw_spin_lock(&logbuf_lock);
-	retry = console_seq != log_next_seq;
+	retry = console_seq != get_next_seq(&main_log);
 	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 
 	if (retry && console_trylock())
@@ -2740,8 +2858,8 @@ void kmsg_dump(enum kmsg_dump_reason reason)
 		raw_spin_lock_irqsave(&logbuf_lock, flags);
 		dumper->cur_seq = clear_seq;
 		dumper->cur_idx = clear_idx;
-		dumper->next_seq = log_next_seq;
-		dumper->next_idx = log_next_idx;
+		dumper->next_seq = get_next_seq(&main_log);
+		dumper->next_idx = get_next_idx(&main_log);
 		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 
 		/* invoke dumper which will iterate over records */
@@ -2782,20 +2900,20 @@ bool kmsg_dump_get_line_nolock(struct kmsg_dumper *dumper, bool syslog,
 	if (!dumper->active)
 		goto out;
 
-	if (dumper->cur_seq < log_first_seq) {
+	if (dumper->cur_seq < get_first_seq(&main_log)) {
 		/* messages are gone, move to first available one */
-		dumper->cur_seq = log_first_seq;
-		dumper->cur_idx = log_first_idx;
+		dumper->cur_seq = get_first_seq(&main_log);
+		dumper->cur_idx = get_first_idx(&main_log);
 	}
 
 	/* last entry */
-	if (dumper->cur_seq >= log_next_seq)
+	if (dumper->cur_seq >= get_next_seq(&main_log))
 		goto out;
 
-	msg = msg_from_idx(dumper->cur_idx);
+	msg = msg_from_idx(&main_log, dumper->cur_idx);
 	l = msg_print_text(msg, 0, syslog, line, size);
 
-	dumper->cur_idx = log_next(dumper->cur_idx);
+	dumper->cur_idx = inc_idx(&main_log, dumper->cur_idx);
 	dumper->cur_seq++;
 	ret = true;
 out:
@@ -2870,10 +2988,10 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 		goto out;
 
 	raw_spin_lock_irqsave(&logbuf_lock, flags);
-	if (dumper->cur_seq < log_first_seq) {
+	if (dumper->cur_seq < get_first_seq(&main_log)) {
 		/* messages are gone, move to first available one */
-		dumper->cur_seq = log_first_seq;
-		dumper->cur_idx = log_first_idx;
+		dumper->cur_seq = get_first_seq(&main_log);
+		dumper->cur_idx = get_first_idx(&main_log);
 	}
 
 	/* last entry */
@@ -2887,10 +3005,10 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 	idx = dumper->cur_idx;
 	prev = 0;
 	while (seq < dumper->next_seq) {
-		struct printk_msg *msg = msg_from_idx(idx);
+		struct printk_msg *msg = msg_from_idx(&main_log, idx);
 
 		l += msg_print_text(msg, prev, true, NULL, 0);
-		idx = log_next(idx);
+		idx = inc_idx(&main_log, idx);
 		seq++;
 		prev = msg->flags;
 	}
@@ -2900,10 +3018,10 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 	idx = dumper->cur_idx;
 	prev = 0;
 	while (l > size && seq < dumper->next_seq) {
-		struct printk_msg *msg = msg_from_idx(idx);
+		struct printk_msg *msg = msg_from_idx(&main_log, idx);
 
 		l -= msg_print_text(msg, prev, true, NULL, 0);
-		idx = log_next(idx);
+		idx = inc_idx(&main_log, idx);
 		seq++;
 		prev = msg->flags;
 	}
@@ -2914,10 +3032,10 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 
 	l = 0;
 	while (seq < dumper->next_seq) {
-		struct printk_msg *msg = msg_from_idx(idx);
+		struct printk_msg *msg = msg_from_idx(&main_log, idx);
 
 		l += msg_print_text(msg, prev, syslog, buf + l, size - l);
-		idx = log_next(idx);
+		idx = inc_idx(&main_log, idx);
 		seq++;
 		prev = msg->flags;
 	}
@@ -2947,8 +3065,8 @@ void kmsg_dump_rewind_nolock(struct kmsg_dumper *dumper)
 {
 	dumper->cur_seq = clear_seq;
 	dumper->cur_idx = clear_idx;
-	dumper->next_seq = log_next_seq;
-	dumper->next_idx = log_next_idx;
+	dumper->next_seq = get_next_seq(&main_log);
+	dumper->next_idx = get_next_idx(&main_log);
 }
 
 /**
-- 
1.8.4

