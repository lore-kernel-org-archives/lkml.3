Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966107AbaFSVky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:40:54 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:59802 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965703AbaFSVjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:39:55 -0400
Message-Id: <20140619213952.058255809@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 19 Jun 2014 17:33:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Jan Kara <jack@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>, Petr Mladek <pmladek@suse.cz>
Subject: [RFC][PATCH 1/3] trace_seq: Move the trace_seq code to lib/
References: <20140619213329.478113470@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0001-trace_seq-Move-the-trace_seq-code-to-lib.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The trace_seq functions are rather useful outside of tracing. Instead
of having it be dependent on CONFIG_TRACING, move the code into lib/
and allow other users to have access to it even when tracing is not
configured.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/trace_seq.h   |  68 ++--------
 kernel/trace/trace.c        |  24 ----
 kernel/trace/trace_output.c | 268 ---------------------------------------
 kernel/trace/trace_output.h |  16 ---
 lib/Makefile                |   2 +-
 lib/trace_seq.c             | 303 ++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 316 insertions(+), 365 deletions(-)
 create mode 100644 lib/trace_seq.c

diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
index 136116924d8d..3fc21ee71389 100644
--- a/include/linux/trace_seq.h
+++ b/include/linux/trace_seq.h
@@ -25,10 +25,6 @@ trace_seq_init(struct trace_seq *s)
 	s->full = 0;
 }
 
-/*
- * Currently only defined when tracing is enabled.
- */
-#ifdef CONFIG_TRACING
 extern __printf(2, 3)
 int trace_seq_printf(struct trace_seq *s, const char *fmt, ...);
 extern __printf(2, 0)
@@ -49,59 +45,19 @@ extern int trace_seq_path(struct trace_seq *s, const struct path *path);
 extern int trace_seq_bitmask(struct trace_seq *s, const unsigned long *maskp,
 			     int nmaskbits);
 
-#else /* CONFIG_TRACING */
-static inline int trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
-{
-	return 0;
-}
-static inline int
-trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary)
-{
-	return 0;
-}
+#define MAX_MEMHEX_BYTES	8
 
-static inline int
-trace_seq_bitmask(struct trace_seq *s, const unsigned long *maskp,
-		  int nmaskbits)
-{
-	return 0;
-}
+#define SEQ_PUT_FIELD_RET(s, x)				\
+do {							\
+	if (!trace_seq_putmem(s, &(x), sizeof(x)))	\
+		return TRACE_TYPE_PARTIAL_LINE;		\
+} while (0)
 
-static inline int trace_print_seq(struct seq_file *m, struct trace_seq *s)
-{
-	return 0;
-}
-static inline ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
-				 size_t cnt)
-{
-	return 0;
-}
-static inline int trace_seq_puts(struct trace_seq *s, const char *str)
-{
-	return 0;
-}
-static inline int trace_seq_putc(struct trace_seq *s, unsigned char c)
-{
-	return 0;
-}
-static inline int
-trace_seq_putmem(struct trace_seq *s, const void *mem, size_t len)
-{
-	return 0;
-}
-static inline int trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
-				       size_t len)
-{
-	return 0;
-}
-static inline void *trace_seq_reserve(struct trace_seq *s, size_t len)
-{
-	return NULL;
-}
-static inline int trace_seq_path(struct trace_seq *s, const struct path *path)
-{
-	return 0;
-}
-#endif /* CONFIG_TRACING */
+#define SEQ_PUT_HEX_FIELD_RET(s, x)			\
+do {							\
+	BUILD_BUG_ON(sizeof(x) > MAX_MEMHEX_BYTES);	\
+	if (!trace_seq_putmem_hex(s, &(x), sizeof(x)))	\
+		return TRACE_TYPE_PARTIAL_LINE;		\
+} while (0)
 
 #endif /* _LINUX_TRACE_SEQ_H */
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 384ede311717..eeb233cbac4f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -923,30 +923,6 @@ out:
 	return ret;
 }
 
-ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf, size_t cnt)
-{
-	int len;
-	int ret;
-
-	if (!cnt)
-		return 0;
-
-	if (s->len <= s->readpos)
-		return -EBUSY;
-
-	len = s->len - s->readpos;
-	if (cnt > len)
-		cnt = len;
-	ret = copy_to_user(ubuf, s->buffer + s->readpos, cnt);
-	if (ret == cnt)
-		return -EFAULT;
-
-	cnt -= ret;
-
-	s->readpos += cnt;
-	return cnt;
-}
-
 static ssize_t trace_seq_to_buffer(struct trace_seq *s, void *buf, size_t cnt)
 {
 	int len;
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index f3dad80c20b2..b8930f79a04b 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -20,23 +20,6 @@ static struct hlist_head event_hash[EVENT_HASHSIZE] __read_mostly;
 
 static int next_event_type = __TRACE_LAST_TYPE + 1;
 
-int trace_print_seq(struct seq_file *m, struct trace_seq *s)
-{
-	int len = s->len >= PAGE_SIZE ? PAGE_SIZE - 1 : s->len;
-	int ret;
-
-	ret = seq_write(m, s->buffer, len);
-
-	/*
-	 * Only reset this buffer if we successfully wrote to the
-	 * seq_file buffer.
-	 */
-	if (!ret)
-		trace_seq_init(s);
-
-	return ret;
-}
-
 enum print_line_t trace_print_bputs_msg_only(struct trace_iterator *iter)
 {
 	struct trace_seq *s = &iter->seq;
@@ -85,257 +68,6 @@ enum print_line_t trace_print_printk_msg_only(struct trace_iterator *iter)
 	return TRACE_TYPE_HANDLED;
 }
 
-/**
- * trace_seq_printf - sequence printing of trace information
- * @s: trace sequence descriptor
- * @fmt: printf format string
- *
- * It returns 0 if the trace oversizes the buffer's free
- * space, 1 otherwise.
- *
- * The tracer may use either sequence operations or its own
- * copy to user routines. To simplify formating of a trace
- * trace_seq_printf is used to store strings into a special
- * buffer (@s). Then the output may be either used by
- * the sequencer or pulled into another buffer.
- */
-int
-trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
-{
-	int len = (PAGE_SIZE - 1) - s->len;
-	va_list ap;
-	int ret;
-
-	if (s->full || !len)
-		return 0;
-
-	va_start(ap, fmt);
-	ret = vsnprintf(s->buffer + s->len, len, fmt, ap);
-	va_end(ap);
-
-	/* If we can't write it all, don't bother writing anything */
-	if (ret >= len) {
-		s->full = 1;
-		return 0;
-	}
-
-	s->len += ret;
-
-	return 1;
-}
-EXPORT_SYMBOL_GPL(trace_seq_printf);
-
-/**
- * trace_seq_bitmask - put a list of longs as a bitmask print output
- * @s:		trace sequence descriptor
- * @maskp:	points to an array of unsigned longs that represent a bitmask
- * @nmaskbits:	The number of bits that are valid in @maskp
- *
- * It returns 0 if the trace oversizes the buffer's free
- * space, 1 otherwise.
- *
- * Writes a ASCII representation of a bitmask string into @s.
- */
-int
-trace_seq_bitmask(struct trace_seq *s, const unsigned long *maskp,
-		  int nmaskbits)
-{
-	int len = (PAGE_SIZE - 1) - s->len;
-	int ret;
-
-	if (s->full || !len)
-		return 0;
-
-	ret = bitmap_scnprintf(s->buffer, len, maskp, nmaskbits);
-	s->len += ret;
-
-	return 1;
-}
-EXPORT_SYMBOL_GPL(trace_seq_bitmask);
-
-/**
- * trace_seq_vprintf - sequence printing of trace information
- * @s: trace sequence descriptor
- * @fmt: printf format string
- *
- * The tracer may use either sequence operations or its own
- * copy to user routines. To simplify formating of a trace
- * trace_seq_printf is used to store strings into a special
- * buffer (@s). Then the output may be either used by
- * the sequencer or pulled into another buffer.
- */
-int
-trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
-{
-	int len = (PAGE_SIZE - 1) - s->len;
-	int ret;
-
-	if (s->full || !len)
-		return 0;
-
-	ret = vsnprintf(s->buffer + s->len, len, fmt, args);
-
-	/* If we can't write it all, don't bother writing anything */
-	if (ret >= len) {
-		s->full = 1;
-		return 0;
-	}
-
-	s->len += ret;
-
-	return len;
-}
-EXPORT_SYMBOL_GPL(trace_seq_vprintf);
-
-int trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary)
-{
-	int len = (PAGE_SIZE - 1) - s->len;
-	int ret;
-
-	if (s->full || !len)
-		return 0;
-
-	ret = bstr_printf(s->buffer + s->len, len, fmt, binary);
-
-	/* If we can't write it all, don't bother writing anything */
-	if (ret >= len) {
-		s->full = 1;
-		return 0;
-	}
-
-	s->len += ret;
-
-	return len;
-}
-
-/**
- * trace_seq_puts - trace sequence printing of simple string
- * @s: trace sequence descriptor
- * @str: simple string to record
- *
- * The tracer may use either the sequence operations or its own
- * copy to user routines. This function records a simple string
- * into a special buffer (@s) for later retrieval by a sequencer
- * or other mechanism.
- */
-int trace_seq_puts(struct trace_seq *s, const char *str)
-{
-	int len = strlen(str);
-
-	if (s->full)
-		return 0;
-
-	if (len > ((PAGE_SIZE - 1) - s->len)) {
-		s->full = 1;
-		return 0;
-	}
-
-	memcpy(s->buffer + s->len, str, len);
-	s->len += len;
-
-	return len;
-}
-
-int trace_seq_putc(struct trace_seq *s, unsigned char c)
-{
-	if (s->full)
-		return 0;
-
-	if (s->len >= (PAGE_SIZE - 1)) {
-		s->full = 1;
-		return 0;
-	}
-
-	s->buffer[s->len++] = c;
-
-	return 1;
-}
-EXPORT_SYMBOL(trace_seq_putc);
-
-int trace_seq_putmem(struct trace_seq *s, const void *mem, size_t len)
-{
-	if (s->full)
-		return 0;
-
-	if (len > ((PAGE_SIZE - 1) - s->len)) {
-		s->full = 1;
-		return 0;
-	}
-
-	memcpy(s->buffer + s->len, mem, len);
-	s->len += len;
-
-	return len;
-}
-
-int trace_seq_putmem_hex(struct trace_seq *s, const void *mem, size_t len)
-{
-	unsigned char hex[HEX_CHARS];
-	const unsigned char *data = mem;
-	int i, j;
-
-	if (s->full)
-		return 0;
-
-#ifdef __BIG_ENDIAN
-	for (i = 0, j = 0; i < len; i++) {
-#else
-	for (i = len-1, j = 0; i >= 0; i--) {
-#endif
-		hex[j++] = hex_asc_hi(data[i]);
-		hex[j++] = hex_asc_lo(data[i]);
-	}
-	hex[j++] = ' ';
-
-	return trace_seq_putmem(s, hex, j);
-}
-
-void *trace_seq_reserve(struct trace_seq *s, size_t len)
-{
-	void *ret;
-
-	if (s->full)
-		return NULL;
-
-	if (len > ((PAGE_SIZE - 1) - s->len)) {
-		s->full = 1;
-		return NULL;
-	}
-
-	ret = s->buffer + s->len;
-	s->len += len;
-
-	return ret;
-}
-
-int trace_seq_path(struct trace_seq *s, const struct path *path)
-{
-	unsigned char *p;
-
-	if (s->full)
-		return 0;
-
-	if (s->len >= (PAGE_SIZE - 1)) {
-		s->full = 1;
-		return 0;
-	}
-
-	p = d_path(path, s->buffer + s->len, PAGE_SIZE - s->len);
-	if (!IS_ERR(p)) {
-		p = mangle_path(s->buffer + s->len, p, "\n");
-		if (p) {
-			s->len = p - s->buffer;
-			return 1;
-		}
-	} else {
-		s->buffer[s->len++] = '?';
-		return 1;
-	}
-
-	s->full = 1;
-	return 0;
-}
-
 const char *
 ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
 		       unsigned long flags,
diff --git a/kernel/trace/trace_output.h b/kernel/trace/trace_output.h
index 127a9d8c8357..89e904540509 100644
--- a/kernel/trace/trace_output.h
+++ b/kernel/trace/trace_output.h
@@ -35,21 +35,5 @@ trace_print_lat_fmt(struct trace_seq *s, struct trace_entry *entry);
 extern int __unregister_ftrace_event(struct trace_event *event);
 extern struct rw_semaphore trace_event_sem;
 
-#define MAX_MEMHEX_BYTES	8
-#define HEX_CHARS		(MAX_MEMHEX_BYTES*2 + 1)
-
-#define SEQ_PUT_FIELD_RET(s, x)				\
-do {							\
-	if (!trace_seq_putmem(s, &(x), sizeof(x)))	\
-		return TRACE_TYPE_PARTIAL_LINE;		\
-} while (0)
-
-#define SEQ_PUT_HEX_FIELD_RET(s, x)			\
-do {							\
-	BUILD_BUG_ON(sizeof(x) > MAX_MEMHEX_BYTES);	\
-	if (!trace_seq_putmem_hex(s, &(x), sizeof(x)))	\
-		return TRACE_TYPE_PARTIAL_LINE;		\
-} while (0)
-
 #endif
 
diff --git a/lib/Makefile b/lib/Makefile
index ba967a19edba..fe8d8c1b04aa 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -13,7 +13,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o flex_proportions.o prio_heap.o ratelimit.o show_mem.o \
 	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
-	 earlycpio.o
+	 earlycpio.o trace_seq.o
 
 obj-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
 lib-$(CONFIG_MMU) += ioremap.o
diff --git a/lib/trace_seq.c b/lib/trace_seq.c
new file mode 100644
index 000000000000..5ba99c6cf834
--- /dev/null
+++ b/lib/trace_seq.c
@@ -0,0 +1,303 @@
+/*
+ * trace_seq.c
+ *
+ * Copyright (C) 2008-2014 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
+ *
+ */
+#include <linux/uaccess.h>
+#include <linux/seq_file.h>
+#include <linux/trace_seq.h>
+
+int trace_print_seq(struct seq_file *m, struct trace_seq *s)
+{
+	int len = s->len >= PAGE_SIZE ? PAGE_SIZE - 1 : s->len;
+	int ret;
+
+	ret = seq_write(m, s->buffer, len);
+
+	/*
+	 * Only reset this buffer if we successfully wrote to the
+	 * seq_file buffer.
+	 */
+	if (!ret)
+		trace_seq_init(s);
+
+	return ret;
+}
+
+/**
+ * trace_seq_printf - sequence printing of trace information
+ * @s: trace sequence descriptor
+ * @fmt: printf format string
+ *
+ * It returns 0 if the trace oversizes the buffer's free
+ * space, 1 otherwise.
+ *
+ * The tracer may use either sequence operations or its own
+ * copy to user routines. To simplify formating of a trace
+ * trace_seq_printf is used to store strings into a special
+ * buffer (@s). Then the output may be either used by
+ * the sequencer or pulled into another buffer.
+ */
+int
+trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
+{
+	int len = (PAGE_SIZE - 1) - s->len;
+	va_list ap;
+	int ret;
+
+	if (s->full || !len)
+		return 0;
+
+	va_start(ap, fmt);
+	ret = vsnprintf(s->buffer + s->len, len, fmt, ap);
+	va_end(ap);
+
+	/* If we can't write it all, don't bother writing anything */
+	if (ret >= len) {
+		s->full = 1;
+		return 0;
+	}
+
+	s->len += ret;
+
+	return 1;
+}
+EXPORT_SYMBOL_GPL(trace_seq_printf);
+
+/**
+ * trace_seq_bitmask - put a list of longs as a bitmask print output
+ * @s:		trace sequence descriptor
+ * @maskp:	points to an array of unsigned longs that represent a bitmask
+ * @nmaskbits:	The number of bits that are valid in @maskp
+ *
+ * It returns 0 if the trace oversizes the buffer's free
+ * space, 1 otherwise.
+ *
+ * Writes a ASCII representation of a bitmask string into @s.
+ */
+int
+trace_seq_bitmask(struct trace_seq *s, const unsigned long *maskp,
+		  int nmaskbits)
+{
+	int len = (PAGE_SIZE - 1) - s->len;
+	int ret;
+
+	if (s->full || !len)
+		return 0;
+
+	ret = bitmap_scnprintf(s->buffer, len, maskp, nmaskbits);
+	s->len += ret;
+
+	return 1;
+}
+EXPORT_SYMBOL_GPL(trace_seq_bitmask);
+
+/**
+ * trace_seq_vprintf - sequence printing of trace information
+ * @s: trace sequence descriptor
+ * @fmt: printf format string
+ *
+ * The tracer may use either sequence operations or its own
+ * copy to user routines. To simplify formating of a trace
+ * trace_seq_printf is used to store strings into a special
+ * buffer (@s). Then the output may be either used by
+ * the sequencer or pulled into another buffer.
+ */
+int
+trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
+{
+	int len = (PAGE_SIZE - 1) - s->len;
+	int ret;
+
+	if (s->full || !len)
+		return 0;
+
+	ret = vsnprintf(s->buffer + s->len, len, fmt, args);
+
+	/* If we can't write it all, don't bother writing anything */
+	if (ret >= len) {
+		s->full = 1;
+		return 0;
+	}
+
+	s->len += ret;
+
+	return len;
+}
+EXPORT_SYMBOL_GPL(trace_seq_vprintf);
+
+int trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary)
+{
+	int len = (PAGE_SIZE - 1) - s->len;
+	int ret;
+
+	if (s->full || !len)
+		return 0;
+
+	ret = bstr_printf(s->buffer + s->len, len, fmt, binary);
+
+	/* If we can't write it all, don't bother writing anything */
+	if (ret >= len) {
+		s->full = 1;
+		return 0;
+	}
+
+	s->len += ret;
+
+	return len;
+}
+
+/**
+ * trace_seq_puts - trace sequence printing of simple string
+ * @s: trace sequence descriptor
+ * @str: simple string to record
+ *
+ * The tracer may use either the sequence operations or its own
+ * copy to user routines. This function records a simple string
+ * into a special buffer (@s) for later retrieval by a sequencer
+ * or other mechanism.
+ */
+int trace_seq_puts(struct trace_seq *s, const char *str)
+{
+	int len = strlen(str);
+
+	if (s->full)
+		return 0;
+
+	if (len > ((PAGE_SIZE - 1) - s->len)) {
+		s->full = 1;
+		return 0;
+	}
+
+	memcpy(s->buffer + s->len, str, len);
+	s->len += len;
+
+	return len;
+}
+
+int trace_seq_putc(struct trace_seq *s, unsigned char c)
+{
+	if (s->full)
+		return 0;
+
+	if (s->len >= (PAGE_SIZE - 1)) {
+		s->full = 1;
+		return 0;
+	}
+
+	s->buffer[s->len++] = c;
+
+	return 1;
+}
+EXPORT_SYMBOL(trace_seq_putc);
+
+int trace_seq_putmem(struct trace_seq *s, const void *mem, size_t len)
+{
+	if (s->full)
+		return 0;
+
+	if (len > ((PAGE_SIZE - 1) - s->len)) {
+		s->full = 1;
+		return 0;
+	}
+
+	memcpy(s->buffer + s->len, mem, len);
+	s->len += len;
+
+	return len;
+}
+
+#define HEX_CHARS		(MAX_MEMHEX_BYTES*2 + 1)
+
+int trace_seq_putmem_hex(struct trace_seq *s, const void *mem, size_t len)
+{
+	unsigned char hex[HEX_CHARS];
+	const unsigned char *data = mem;
+	int i, j;
+
+	if (s->full)
+		return 0;
+
+#ifdef __BIG_ENDIAN
+	for (i = 0, j = 0; i < len; i++) {
+#else
+	for (i = len-1, j = 0; i >= 0; i--) {
+#endif
+		hex[j++] = hex_asc_hi(data[i]);
+		hex[j++] = hex_asc_lo(data[i]);
+	}
+	hex[j++] = ' ';
+
+	return trace_seq_putmem(s, hex, j);
+}
+
+void *trace_seq_reserve(struct trace_seq *s, size_t len)
+{
+	void *ret;
+
+	if (s->full)
+		return NULL;
+
+	if (len > ((PAGE_SIZE - 1) - s->len)) {
+		s->full = 1;
+		return NULL;
+	}
+
+	ret = s->buffer + s->len;
+	s->len += len;
+
+	return ret;
+}
+
+int trace_seq_path(struct trace_seq *s, const struct path *path)
+{
+	unsigned char *p;
+
+	if (s->full)
+		return 0;
+
+	if (s->len >= (PAGE_SIZE - 1)) {
+		s->full = 1;
+		return 0;
+	}
+
+	p = d_path(path, s->buffer + s->len, PAGE_SIZE - s->len);
+	if (!IS_ERR(p)) {
+		p = mangle_path(s->buffer + s->len, p, "\n");
+		if (p) {
+			s->len = p - s->buffer;
+			return 1;
+		}
+	} else {
+		s->buffer[s->len++] = '?';
+		return 1;
+	}
+
+	s->full = 1;
+	return 0;
+}
+
+ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf, size_t cnt)
+{
+	int len;
+	int ret;
+
+	if (!cnt)
+		return 0;
+
+	if (s->len <= s->readpos)
+		return -EBUSY;
+
+	len = s->len - s->readpos;
+	if (cnt > len)
+		cnt = len;
+	ret = copy_to_user(ubuf, s->buffer + s->readpos, cnt);
+	if (ret == cnt)
+		return -EFAULT;
+
+	cnt -= ret;
+
+	s->readpos += cnt;
+	return cnt;
+}
-- 
2.0.0.rc2


