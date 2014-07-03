Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759314AbaGCQMk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:12:40 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:62039 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759135AbaGCQMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:12:25 -0400
Message-Id: <20140703161224.790651202@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 03 Jul 2014 12:05:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 08/21] tracing: Move the trace_seq_* functions into its own trace_seq.c file
References: <20140703160503.006976702@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0008-tracing-Move-the-trace_seq_-functions-into-its-own-t.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The trace_seq_*() functions are a nice utility that allows users to manipulate
buffers with printf() like formats. It has its own trace_seq.h header in
include/linux and should be in its own file. Being tied with trace_output.c
is rather awkward.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/trace_seq.h   |   2 +
 kernel/trace/Makefile       |   1 +
 kernel/trace/trace.c        |  24 ----
 kernel/trace/trace_output.c | 268 ---------------------------------------
 kernel/trace/trace_output.h |   3 -
 kernel/trace/trace_seq.c    | 303 ++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 306 insertions(+), 295 deletions(-)
 create mode 100644 kernel/trace/trace_seq.c

diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
index 136116924d8d..66ea365acf01 100644
--- a/include/linux/trace_seq.h
+++ b/include/linux/trace_seq.h
@@ -25,6 +25,8 @@ trace_seq_init(struct trace_seq *s)
 	s->full = 0;
 }
 
+#define MAX_MEMHEX_BYTES	8
+
 /*
  * Currently only defined when tracing is enabled.
  */
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 2611613f14f1..67d6369ddf83 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_RING_BUFFER_BENCHMARK) += ring_buffer_benchmark.o
 
 obj-$(CONFIG_TRACING) += trace.o
 obj-$(CONFIG_TRACING) += trace_output.o
+obj-$(CONFIG_TRACING) += trace_seq.o
 obj-$(CONFIG_TRACING) += trace_stat.o
 obj-$(CONFIG_TRACING) += trace_printk.o
 obj-$(CONFIG_CONTEXT_SWITCH_TRACER) += trace_sched_switch.o
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
index 127a9d8c8357..bf7daf2237ed 100644
--- a/kernel/trace/trace_output.h
+++ b/kernel/trace/trace_output.h
@@ -35,9 +35,6 @@ trace_print_lat_fmt(struct trace_seq *s, struct trace_entry *entry);
 extern int __unregister_ftrace_event(struct trace_event *event);
 extern struct rw_semaphore trace_event_sem;
 
-#define MAX_MEMHEX_BYTES	8
-#define HEX_CHARS		(MAX_MEMHEX_BYTES*2 + 1)
-
 #define SEQ_PUT_FIELD_RET(s, x)				\
 do {							\
 	if (!trace_seq_putmem(s, &(x), sizeof(x)))	\
diff --git a/kernel/trace/trace_seq.c b/kernel/trace/trace_seq.c
new file mode 100644
index 000000000000..5ba99c6cf834
--- /dev/null
+++ b/kernel/trace/trace_seq.c
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
2.0.0


