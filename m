Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbaEIJMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 05:12:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40832 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756313AbaEIJM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 05:12:27 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Dave Anderson <anderson@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Kay Sievers <kay@vrfy.org>, Jiri Kosina <jkosina@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.cz>
Subject: [RFC PATCH 01/11] printk: rename struct printk_log to printk_msg
Date: Fri,  9 May 2014 11:10:55 +0200
Message-Id: <1399626665-29817-2-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1399626665-29817-1-git-send-email-pmladek@suse.cz>
References: <1399626665-29817-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just a preparation patch for NMI safe printk implementation.
We will need extra log buffer that will be used in NMI context
when the lock for the main ring buffer is already taken. We cannot
wait for the main lock because it can cause a deadlock.

Many information need to be stored into the helper ring buffer, e.g.
facility, level, text, dict, time. It makes sense to reuse the logic
already implemented for the main log buffer.

It means that the same functions will need to work with different
log buffers. The code will be more clear when we wrap the log buffer
related variables into a struct.

This patch renames struct "printk_log" to "printk_msg". The name was
pretty confusing. The struct contains information about a single message.
Pointers to this struct are called "msg". Then the original name can be
used for the struct really describing the log buffer.

To make it consistent, it also renames helper functions that manipulate
the "printk_msg" struct and starts with "log_" prefix. It means that
"log_from_idx" is renamed to "msg_from_idx". On the other hand, "log_text"
and "log_dict" are renamed to "get_text", "get_dict". It is more clear
and there will be more "set/get" functions needed for the NMI log buffer.

IMPORTANT: This change causes problems for the external tools that
are accessing the structures, e.g. crash, makedumpfile. They need to
get updated.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 kernel/printk/printk.c | 100 ++++++++++++++++++++++++-------------------------
 1 file changed, 50 insertions(+), 50 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 0fe25a11a034..e0fd7a1c0c1e 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -199,7 +199,7 @@ static int console_may_schedule;
  *         67                           "g"
  *   0032     00 00 00                  padding to next message header
  *
- * The 'struct printk_log' buffer header must never be directly exported to
+ * The 'struct printk_msg' buffer header must never be directly exported to
  * userspace, it is a kernel-private implementation detail that might
  * need to be changed in the future, when the requirements change.
  *
@@ -221,7 +221,7 @@ enum log_flags {
 	LOG_CONT	= 8,	/* text is a fragment of a continuation line */
 };
 
-struct printk_log {
+struct printk_msg {
 	u64 ts_nsec;		/* timestamp in nanoseconds */
 	u16 len;		/* length of entire record */
 	u16 text_len;		/* length of text buffer */
@@ -270,7 +270,7 @@ static u32 clear_idx;
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
 #define LOG_ALIGN 4
 #else
-#define LOG_ALIGN __alignof__(struct printk_log)
+#define LOG_ALIGN __alignof__(struct printk_msg)
 #endif
 #define __LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
 static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
@@ -278,35 +278,35 @@ static char *log_buf = __log_buf;
 static u32 log_buf_len = __LOG_BUF_LEN;
 
 /* human readable text of the record */
-static char *log_text(const struct printk_log *msg)
+static char *get_text(const struct printk_msg *msg)
 {
-	return (char *)msg + sizeof(struct printk_log);
+	return (char *)msg + sizeof(struct printk_msg);
 }
 
 /* optional key/value pair dictionary attached to the record */
-static char *log_dict(const struct printk_log *msg)
+static char *get_dict(const struct printk_msg *msg)
 {
-	return (char *)msg + sizeof(struct printk_log) + msg->text_len;
+	return (char *)msg + sizeof(struct printk_msg) + msg->text_len;
 }
 
 /* get record by index; idx must point to valid msg */
-static struct printk_log *log_from_idx(u32 idx)
+static struct printk_msg *msg_from_idx(u32 idx)
 {
-	struct printk_log *msg = (struct printk_log *)(log_buf + idx);
+	struct printk_msg *msg = (struct printk_msg *)(log_buf + idx);
 
 	/*
 	 * A length == 0 record is the end of buffer marker. Wrap around and
 	 * read the message at the start of the buffer.
 	 */
 	if (!msg->len)
-		return (struct printk_log *)log_buf;
+		return (struct printk_msg *)log_buf;
 	return msg;
 }
 
 /* get next record; idx must point to valid msg */
 static u32 log_next(u32 idx)
 {
-	struct printk_log *msg = (struct printk_log *)(log_buf + idx);
+	struct printk_msg *msg = (struct printk_msg *)(log_buf + idx);
 
 	/* length == 0 indicates the end of the buffer; wrap */
 	/*
@@ -315,7 +315,7 @@ static u32 log_next(u32 idx)
 	 * return the one after that.
 	 */
 	if (!msg->len) {
-		msg = (struct printk_log *)log_buf;
+		msg = (struct printk_msg *)log_buf;
 		return msg->len;
 	}
 	return idx + msg->len;
@@ -343,7 +343,7 @@ static int logbuf_has_space(u32 msg_size, bool empty)
 	 * We need space also for an empty header that signalizes wrapping
 	 * of the buffer.
 	 */
-	return free >= msg_size + sizeof(struct printk_log);
+	return free >= msg_size + sizeof(struct printk_msg);
 }
 
 static int log_make_free_space(u32 msg_size)
@@ -368,7 +368,7 @@ static u32 msg_used_size(u16 text_len, u16 dict_len, u32 *pad_len)
 {
 	u32 size;
 
-	size = sizeof(struct printk_log) + text_len + dict_len;
+	size = sizeof(struct printk_msg) + text_len + dict_len;
 	*pad_len = (-size) & (LOG_ALIGN - 1);
 	size += *pad_len;
 
@@ -407,7 +407,7 @@ static int log_store(int facility, int level,
 		     const char *dict, u16 dict_len,
 		     const char *text, u16 text_len)
 {
-	struct printk_log *msg;
+	struct printk_msg *msg;
 	u32 size, pad_len;
 	u16 trunc_msg_len = 0;
 
@@ -423,25 +423,25 @@ static int log_store(int facility, int level,
 			return 0;
 	}
 
-	if (log_next_idx + size + sizeof(struct printk_log) > log_buf_len) {
+	if (log_next_idx + size + sizeof(struct printk_msg) > log_buf_len) {
 		/*
 		 * This message + an additional empty header does not fit
 		 * at the end of the buffer. Add an empty header with len == 0
 		 * to signify a wrap around.
 		 */
-		memset(log_buf + log_next_idx, 0, sizeof(struct printk_log));
+		memset(log_buf + log_next_idx, 0, sizeof(struct printk_msg));
 		log_next_idx = 0;
 	}
 
 	/* fill message */
-	msg = (struct printk_log *)(log_buf + log_next_idx);
-	memcpy(log_text(msg), text, text_len);
+	msg = (struct printk_msg *)(log_buf + log_next_idx);
+	memcpy(get_text(msg), text, text_len);
 	msg->text_len = text_len;
 	if (trunc_msg_len) {
-		memcpy(log_text(msg) + text_len, trunc_msg, trunc_msg_len);
+		memcpy(get_text(msg) + text_len, trunc_msg, trunc_msg_len);
 		msg->text_len += trunc_msg_len;
 	}
-	memcpy(log_dict(msg), dict, dict_len);
+	memcpy(get_dict(msg), dict, dict_len);
 	msg->dict_len = dict_len;
 	msg->facility = facility;
 	msg->level = level & 7;
@@ -450,7 +450,7 @@ static int log_store(int facility, int level,
 		msg->ts_nsec = ts_nsec;
 	else
 		msg->ts_nsec = local_clock();
-	memset(log_dict(msg) + dict_len, 0, pad_len);
+	memset(get_dict(msg) + dict_len, 0, pad_len);
 	msg->len = size;
 
 	/* insert message */
@@ -576,7 +576,7 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 			    size_t count, loff_t *ppos)
 {
 	struct devkmsg_user *user = file->private_data;
-	struct printk_log *msg;
+	struct printk_msg *msg;
 	u64 ts_usec;
 	size_t i;
 	char cont = '-';
@@ -614,7 +614,7 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 		goto out;
 	}
 
-	msg = log_from_idx(user->idx);
+	msg = msg_from_idx(user->idx);
 	ts_usec = msg->ts_nsec;
 	do_div(ts_usec, 1000);
 
@@ -639,7 +639,7 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 
 	/* escape non-printable characters */
 	for (i = 0; i < msg->text_len; i++) {
-		unsigned char c = log_text(msg)[i];
+		unsigned char c = get_text(msg)[i];
 
 		if (c < ' ' || c >= 127 || c == '\\')
 			len += sprintf(user->buf + len, "\\x%02x", c);
@@ -652,7 +652,7 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 		bool line = true;
 
 		for (i = 0; i < msg->dict_len; i++) {
-			unsigned char c = log_dict(msg)[i];
+			unsigned char c = get_dict(msg)[i];
 
 			if (line) {
 				user->buf[len++] = ' ';
@@ -821,14 +821,14 @@ void log_buf_kexec_setup(void)
 	VMCOREINFO_SYMBOL(log_first_idx);
 	VMCOREINFO_SYMBOL(log_next_idx);
 	/*
-	 * Export struct printk_log size and field offsets. User space tools can
+	 * Export struct printk_msg size and field offsets. User space tools can
 	 * parse it and detect any changes to structure down the line.
 	 */
-	VMCOREINFO_STRUCT_SIZE(printk_log);
-	VMCOREINFO_OFFSET(printk_log, ts_nsec);
-	VMCOREINFO_OFFSET(printk_log, len);
-	VMCOREINFO_OFFSET(printk_log, text_len);
-	VMCOREINFO_OFFSET(printk_log, dict_len);
+	VMCOREINFO_STRUCT_SIZE(printk_msg);
+	VMCOREINFO_OFFSET(printk_msg, ts_nsec);
+	VMCOREINFO_OFFSET(printk_msg, len);
+	VMCOREINFO_OFFSET(printk_msg, text_len);
+	VMCOREINFO_OFFSET(printk_msg, dict_len);
 }
 #endif
 
@@ -977,7 +977,7 @@ static size_t print_time(u64 ts, char *buf)
 		       (unsigned long)ts, rem_nsec / 1000);
 }
 
-static size_t print_prefix(const struct printk_log *msg, bool syslog, char *buf)
+static size_t print_prefix(const struct printk_msg *msg, bool syslog, char *buf)
 {
 	size_t len = 0;
 	unsigned int prefix = (msg->facility << 3) | msg->level;
@@ -1000,10 +1000,10 @@ static size_t print_prefix(const struct printk_log *msg, bool syslog, char *buf)
 	return len;
 }
 
-static size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
+static size_t msg_print_text(const struct printk_msg *msg, enum log_flags prev,
 			     bool syslog, char *buf, size_t size)
 {
-	const char *text = log_text(msg);
+	const char *text = get_text(msg);
 	size_t text_size = msg->text_len;
 	bool prefix = true;
 	bool newline = true;
@@ -1062,7 +1062,7 @@ static size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
 static int syslog_print(char __user *buf, int size)
 {
 	char *text;
-	struct printk_log *msg;
+	struct printk_msg *msg;
 	int len = 0;
 
 	text = kmalloc(LOG_LINE_MAX + PREFIX_MAX, GFP_KERNEL);
@@ -1087,7 +1087,7 @@ static int syslog_print(char __user *buf, int size)
 		}
 
 		skip = syslog_partial;
-		msg = log_from_idx(syslog_idx);
+		msg = msg_from_idx(syslog_idx);
 		n = msg_print_text(msg, syslog_prev, true, text,
 				   LOG_LINE_MAX + PREFIX_MAX);
 		if (n - syslog_partial <= size) {
@@ -1153,7 +1153,7 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 		idx = clear_idx;
 		prev = 0;
 		while (seq < log_next_seq) {
-			struct printk_log *msg = log_from_idx(idx);
+			struct printk_msg *msg = msg_from_idx(idx);
 
 			len += msg_print_text(msg, prev, true, NULL, 0);
 			prev = msg->flags;
@@ -1166,7 +1166,7 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 		idx = clear_idx;
 		prev = 0;
 		while (len > size && seq < log_next_seq) {
-			struct printk_log *msg = log_from_idx(idx);
+			struct printk_msg *msg = msg_from_idx(idx);
 
 			len -= msg_print_text(msg, prev, true, NULL, 0);
 			prev = msg->flags;
@@ -1179,7 +1179,7 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 
 		len = 0;
 		while (len >= 0 && seq < next_seq) {
-			struct printk_log *msg = log_from_idx(idx);
+			struct printk_msg *msg = msg_from_idx(idx);
 			int textlen;
 
 			textlen = msg_print_text(msg, prev, true, text,
@@ -1325,7 +1325,7 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 
 			error = 0;
 			while (seq < log_next_seq) {
-				struct printk_log *msg = log_from_idx(idx);
+				struct printk_msg *msg = msg_from_idx(idx);
 
 				error += msg_print_text(msg, prev, true, NULL, 0);
 				idx = log_next(idx);
@@ -1833,10 +1833,10 @@ static struct cont {
 	u8 level;
 	bool flushed:1;
 } cont;
-static struct printk_log *log_from_idx(u32 idx) { return NULL; }
+static struct printk_msg *msg_from_idx(u32 idx) { return NULL; }
 static u32 log_next(u32 idx) { return 0; }
 static void call_console_drivers(int level, const char *text, size_t len) {}
-static size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
+static size_t msg_print_text(const struct printk_msg *msg, enum log_flags prev,
 			     bool syslog, char *buf, size_t size) { return 0; }
 static size_t cont_print_text(char *text, size_t size) { return 0; }
 
@@ -2146,7 +2146,7 @@ void console_unlock(void)
 	console_cont_flush(text, sizeof(text));
 again:
 	for (;;) {
-		struct printk_log *msg;
+		struct printk_msg *msg;
 		u64 console_end_seq;
 		size_t len;
 		int level;
@@ -2174,7 +2174,7 @@ skip:
 		if (console_seq == log_next_seq)
 			break;
 
-		msg = log_from_idx(console_idx);
+		msg = msg_from_idx(console_idx);
 		if (msg->flags & LOG_NOCONS) {
 			/*
 			 * Skip record we have buffered and already printed
@@ -2775,7 +2775,7 @@ void kmsg_dump(enum kmsg_dump_reason reason)
 bool kmsg_dump_get_line_nolock(struct kmsg_dumper *dumper, bool syslog,
 			       char *line, size_t size, size_t *len)
 {
-	struct printk_log *msg;
+	struct printk_msg *msg;
 	size_t l = 0;
 	bool ret = false;
 
@@ -2792,7 +2792,7 @@ bool kmsg_dump_get_line_nolock(struct kmsg_dumper *dumper, bool syslog,
 	if (dumper->cur_seq >= log_next_seq)
 		goto out;
 
-	msg = log_from_idx(dumper->cur_idx);
+	msg = msg_from_idx(dumper->cur_idx);
 	l = msg_print_text(msg, 0, syslog, line, size);
 
 	dumper->cur_idx = log_next(dumper->cur_idx);
@@ -2887,7 +2887,7 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 	idx = dumper->cur_idx;
 	prev = 0;
 	while (seq < dumper->next_seq) {
-		struct printk_log *msg = log_from_idx(idx);
+		struct printk_msg *msg = msg_from_idx(idx);
 
 		l += msg_print_text(msg, prev, true, NULL, 0);
 		idx = log_next(idx);
@@ -2900,7 +2900,7 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 	idx = dumper->cur_idx;
 	prev = 0;
 	while (l > size && seq < dumper->next_seq) {
-		struct printk_log *msg = log_from_idx(idx);
+		struct printk_msg *msg = msg_from_idx(idx);
 
 		l -= msg_print_text(msg, prev, true, NULL, 0);
 		idx = log_next(idx);
@@ -2914,7 +2914,7 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 
 	l = 0;
 	while (seq < dumper->next_seq) {
-		struct printk_log *msg = log_from_idx(idx);
+		struct printk_msg *msg = msg_from_idx(idx);
 
 		l += msg_print_text(msg, prev, syslog, buf + l, size - l);
 		idx = log_next(idx);
-- 
1.8.4

