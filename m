Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbaKOFJj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 00:09:39 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:28219 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751386AbaKOFGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 00:06:06 -0500
Message-Id: <20141115050602.986728758@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 14 Nov 2014 23:59:01 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 14/26 v5] tracing: Create seq_buf layer in trace_seq
References: <20141115045847.712848224@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0014-tracing-Create-seq_buf-layer-in-trace_seq.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Create a seq_buf layer that trace_seq sits on. The seq_buf will not
be limited to page size. This will allow other usages of seq_buf
instead of a hard set PAGE_SIZE one that trace_seq has.

Link: http://lkml.kernel.org/r/20141104160221.864997179@goodmis.org
Link: http://lkml.kernel.org/r/20141114011412.170377300@goodmis.org

Tested-by: Jiri Kosina <jkosina@suse.cz>
Acked-by: Jiri Kosina <jkosina@suse.cz>
Reviewed-by: Petr Mladek <pmladek@suse.cz>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/seq_buf.h              |  81 +++++++++
 include/linux/trace_seq.h            |  12 +-
 kernel/trace/Makefile                |   1 +
 kernel/trace/seq_buf.c               | 341 +++++++++++++++++++++++++++++++++++
 kernel/trace/trace.c                 |  39 ++--
 kernel/trace/trace_events.c          |   6 +-
 kernel/trace/trace_functions_graph.c |   6 +-
 kernel/trace/trace_seq.c             | 177 +++++++++---------
 8 files changed, 538 insertions(+), 125 deletions(-)
 create mode 100644 include/linux/seq_buf.h
 create mode 100644 kernel/trace/seq_buf.c

diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
new file mode 100644
index 000000000000..4f7a96a9d71a
--- /dev/null
+++ b/include/linux/seq_buf.h
@@ -0,0 +1,81 @@
+#ifndef _LINUX_SEQ_BUF_H
+#define _LINUX_SEQ_BUF_H
+
+#include <linux/fs.h>
+
+/*
+ * Trace sequences are used to allow a function to call several other functions
+ * to create a string of data to use.
+ */
+
+/**
+ * seq_buf - seq buffer structure
+ * @buffer:	pointer to the buffer
+ * @size:	size of the buffer
+ * @len:	the amount of data inside the buffer
+ * @readpos:	The next position to read in the buffer.
+ */
+struct seq_buf {
+	unsigned char		*buffer;
+	unsigned int		size;
+	unsigned int		len;
+	unsigned int		readpos;
+};
+
+static inline void
+seq_buf_init(struct seq_buf *s, unsigned char *buf, unsigned int size)
+{
+	s->buffer = buf;
+	s->size = size;
+	s->len = 0;
+	s->readpos = 0;
+}
+
+/*
+ * seq_buf have a buffer that might overflow. When this happens
+ * the len and size are set to be equal.
+ */
+static inline bool
+seq_buf_has_overflowed(struct seq_buf *s)
+{
+	return s->len == s->size;
+}
+
+static inline void
+seq_buf_set_overflow(struct seq_buf *s)
+{
+	s->len = s->size;
+}
+
+/*
+ * How much buffer is left on the seq_buf?
+ */
+static inline unsigned int
+seq_buf_buffer_left(struct seq_buf *s)
+{
+	if (seq_buf_has_overflowed(s))
+		return 0;
+
+	return (s->size - 1) - s->len;
+}
+
+extern __printf(2, 3)
+int seq_buf_printf(struct seq_buf *s, const char *fmt, ...);
+extern __printf(2, 0)
+int seq_buf_vprintf(struct seq_buf *s, const char *fmt, va_list args);
+extern int
+seq_buf_bprintf(struct seq_buf *s, const char *fmt, const u32 *binary);
+extern int seq_buf_print_seq(struct seq_file *m, struct seq_buf *s);
+extern int seq_buf_to_user(struct seq_buf *s, char __user *ubuf,
+			   int cnt);
+extern int seq_buf_puts(struct seq_buf *s, const char *str);
+extern int seq_buf_putc(struct seq_buf *s, unsigned char c);
+extern int seq_buf_putmem(struct seq_buf *s, const void *mem, unsigned int len);
+extern int seq_buf_putmem_hex(struct seq_buf *s, const void *mem,
+			      unsigned int len);
+extern int seq_buf_path(struct seq_buf *s, const struct path *path);
+
+extern int seq_buf_bitmask(struct seq_buf *s, const unsigned long *maskp,
+			   int nmaskbits);
+
+#endif /* _LINUX_SEQ_BUF_H */
diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
index db8a73224f1a..85d37106be3d 100644
--- a/include/linux/trace_seq.h
+++ b/include/linux/trace_seq.h
@@ -1,7 +1,7 @@
 #ifndef _LINUX_TRACE_SEQ_H
 #define _LINUX_TRACE_SEQ_H
 
-#include <linux/fs.h>
+#include <linux/seq_buf.h>
 
 #include <asm/page.h>
 
@@ -12,16 +12,14 @@
 
 struct trace_seq {
 	unsigned char		buffer[PAGE_SIZE];
-	unsigned int		len;
-	unsigned int		readpos;
+	struct seq_buf		seq;
 	int			full;
 };
 
 static inline void
 trace_seq_init(struct trace_seq *s)
 {
-	s->len = 0;
-	s->readpos = 0;
+	seq_buf_init(&s->seq, s->buffer, PAGE_SIZE);
 	s->full = 0;
 }
 
@@ -37,7 +35,7 @@ trace_seq_init(struct trace_seq *s)
 static inline unsigned char *
 trace_seq_buffer_ptr(struct trace_seq *s)
 {
-	return s->buffer + s->len;
+	return s->buffer + s->seq.len;
 }
 
 /**
@@ -49,7 +47,7 @@ trace_seq_buffer_ptr(struct trace_seq *s)
  */
 static inline bool trace_seq_has_overflowed(struct trace_seq *s)
 {
-	return s->full || s->len > PAGE_SIZE - 1;
+	return s->full || seq_buf_has_overflowed(&s->seq);
 }
 
 /*
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 67d6369ddf83..edc98c72a634 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_RING_BUFFER_BENCHMARK) += ring_buffer_benchmark.o
 obj-$(CONFIG_TRACING) += trace.o
 obj-$(CONFIG_TRACING) += trace_output.o
 obj-$(CONFIG_TRACING) += trace_seq.o
+obj-$(CONFIG_TRACING) += seq_buf.o
 obj-$(CONFIG_TRACING) += trace_stat.o
 obj-$(CONFIG_TRACING) += trace_printk.o
 obj-$(CONFIG_CONTEXT_SWITCH_TRACER) += trace_sched_switch.o
diff --git a/kernel/trace/seq_buf.c b/kernel/trace/seq_buf.c
new file mode 100644
index 000000000000..e9a7861595d2
--- /dev/null
+++ b/kernel/trace/seq_buf.c
@@ -0,0 +1,341 @@
+/*
+ * seq_buf.c
+ *
+ * Copyright (C) 2014 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
+ *
+ * The seq_buf is a handy tool that allows you to pass a descriptor around
+ * to a buffer that other functions can write to. It is similar to the
+ * seq_file functionality but has some differences.
+ *
+ * To use it, the seq_buf must be initialized with seq_buf_init().
+ * This will set up the counters within the descriptor. You can call
+ * seq_buf_init() more than once to reset the seq_buf to start
+ * from scratch.
+ */
+#include <linux/uaccess.h>
+#include <linux/seq_file.h>
+#include <linux/seq_buf.h>
+
+/* How much buffer is written? */
+#define SEQ_BUF_USED(s) min((s)->len, (s)->size - 1)
+
+/**
+ * seq_buf_print_seq - move the contents of seq_buf into a seq_file
+ * @m: the seq_file descriptor that is the destination
+ * @s: the seq_buf descriptor that is the source.
+ *
+ * Returns zero on success, non zero otherwise
+ */
+int seq_buf_print_seq(struct seq_file *m, struct seq_buf *s)
+{
+	unsigned int len = SEQ_BUF_USED(s);
+
+	return seq_write(m, s->buffer, len);
+}
+
+/**
+ * seq_buf_vprintf - sequence printing of information.
+ * @s: seq_buf descriptor
+ * @fmt: printf format string
+ * @args: va_list of arguments from a printf() type function
+ *
+ * Writes a vnprintf() format into the sequencce buffer.
+ *
+ * Returns zero on success, -1 on overflow.
+ */
+int seq_buf_vprintf(struct seq_buf *s, const char *fmt, va_list args)
+{
+	int len;
+
+	WARN_ON(s->size == 0);
+
+	if (s->len < s->size) {
+		len = vsnprintf(s->buffer + s->len, s->size - s->len, fmt, args);
+		if (s->len + len < s->size) {
+			s->len += len;
+			return 0;
+		}
+	}
+	seq_buf_set_overflow(s);
+	return -1;
+}
+
+/**
+ * seq_buf_printf - sequence printing of information
+ * @s: seq_buf descriptor
+ * @fmt: printf format string
+ *
+ * Writes a printf() format into the sequence buffer.
+ *
+ * Returns zero on success, -1 on overflow.
+ */
+int seq_buf_printf(struct seq_buf *s, const char *fmt, ...)
+{
+	va_list ap;
+	int ret;
+
+	va_start(ap, fmt);
+	ret = seq_buf_vprintf(s, fmt, ap);
+	va_end(ap);
+
+	return ret;
+}
+
+/**
+ * seq_buf_bitmask - write a bitmask array in its ASCII representation
+ * @s:		seq_buf descriptor
+ * @maskp:	points to an array of unsigned longs that represent a bitmask
+ * @nmaskbits:	The number of bits that are valid in @maskp
+ *
+ * Writes a ASCII representation of a bitmask string into @s.
+ *
+ * Returns zero on success, -1 on overflow.
+ */
+int seq_buf_bitmask(struct seq_buf *s, const unsigned long *maskp,
+		    int nmaskbits)
+{
+	unsigned int len = seq_buf_buffer_left(s);
+	int ret;
+
+	WARN_ON(s->size == 0);
+
+	/*
+	 * The last byte of the buffer is used to determine if we
+	 * overflowed or not.
+	 */
+	if (len > 1) {
+		ret = bitmap_scnprintf(s->buffer + s->len, len, maskp, nmaskbits);
+		if (ret < len) {
+			s->len += ret;
+			return 0;
+		}
+	}
+	seq_buf_set_overflow(s);
+	return -1;
+}
+
+/**
+ * seq_buf_bprintf - Write the printf string from binary arguments
+ * @s: seq_buf descriptor
+ * @fmt: The format string for the @binary arguments
+ * @binary: The binary arguments for @fmt.
+ *
+ * When recording in a fast path, a printf may be recorded with just
+ * saving the format and the arguments as they were passed to the
+ * function, instead of wasting cycles converting the arguments into
+ * ASCII characters. Instead, the arguments are saved in a 32 bit
+ * word array that is defined by the format string constraints.
+ *
+ * This function will take the format and the binary array and finish
+ * the conversion into the ASCII string within the buffer.
+ *
+ * Returns zero on success, -1 on overflow.
+ */
+int seq_buf_bprintf(struct seq_buf *s, const char *fmt, const u32 *binary)
+{
+	unsigned int len = seq_buf_buffer_left(s);
+	int ret;
+
+	WARN_ON(s->size == 0);
+
+	if (s->len < s->size) {
+		ret = bstr_printf(s->buffer + s->len, len, fmt, binary);
+		if (s->len + ret < s->size) {
+			s->len += ret;
+			return 0;
+		}
+	}
+	seq_buf_set_overflow(s);
+	return -1;
+}
+
+/**
+ * seq_buf_puts - sequence printing of simple string
+ * @s: seq_buf descriptor
+ * @str: simple string to record
+ *
+ * Copy a simple string into the sequence buffer.
+ *
+ * Returns zero on success, -1 on overflow
+ */
+int seq_buf_puts(struct seq_buf *s, const char *str)
+{
+	unsigned int len = strlen(str);
+
+	WARN_ON(s->size == 0);
+
+	if (s->len + len < s->size) {
+		memcpy(s->buffer + s->len, str, len);
+		s->len += len;
+		return 0;
+	}
+	seq_buf_set_overflow(s);
+	return -1;
+}
+
+/**
+ * seq_buf_putc - sequence printing of simple character
+ * @s: seq_buf descriptor
+ * @c: simple character to record
+ *
+ * Copy a single character into the sequence buffer.
+ *
+ * Returns zero on success, -1 on overflow
+ */
+int seq_buf_putc(struct seq_buf *s, unsigned char c)
+{
+	WARN_ON(s->size == 0);
+
+	if (s->len + 1 < s->size) {
+		s->buffer[s->len++] = c;
+		return 0;
+	}
+	seq_buf_set_overflow(s);
+	return -1;
+}
+
+/**
+ * seq_buf_putmem - write raw data into the sequenc buffer
+ * @s: seq_buf descriptor
+ * @mem: The raw memory to copy into the buffer
+ * @len: The length of the raw memory to copy (in bytes)
+ *
+ * There may be cases where raw memory needs to be written into the
+ * buffer and a strcpy() would not work. Using this function allows
+ * for such cases.
+ *
+ * Returns zero on success, -1 on overflow
+ */
+int seq_buf_putmem(struct seq_buf *s, const void *mem, unsigned int len)
+{
+	WARN_ON(s->size == 0);
+
+	if (s->len + len < s->size) {
+		memcpy(s->buffer + s->len, mem, len);
+		s->len += len;
+		return 0;
+	}
+	seq_buf_set_overflow(s);
+	return -1;
+}
+
+#define MAX_MEMHEX_BYTES	8U
+#define HEX_CHARS		(MAX_MEMHEX_BYTES*2 + 1)
+
+/**
+ * seq_buf_putmem_hex - write raw memory into the buffer in ASCII hex
+ * @s: seq_buf descriptor
+ * @mem: The raw memory to write its hex ASCII representation of
+ * @len: The length of the raw memory to copy (in bytes)
+ *
+ * This is similar to seq_buf_putmem() except instead of just copying the
+ * raw memory into the buffer it writes its ASCII representation of it
+ * in hex characters.
+ *
+ * Returns zero on success, -1 on overflow
+ */
+int seq_buf_putmem_hex(struct seq_buf *s, const void *mem,
+		       unsigned int len)
+{
+	unsigned char hex[HEX_CHARS];
+	const unsigned char *data = mem;
+	unsigned int start_len;
+	int i, j;
+
+	WARN_ON(s->size == 0);
+
+	while (len) {
+		start_len = min(len, HEX_CHARS - 1);
+#ifdef __BIG_ENDIAN
+		for (i = 0, j = 0; i < start_len; i++) {
+#else
+		for (i = start_len-1, j = 0; i >= 0; i--) {
+#endif
+			hex[j++] = hex_asc_hi(data[i]);
+			hex[j++] = hex_asc_lo(data[i]);
+		}
+		if (WARN_ON_ONCE(j == 0 || j/2 > len))
+			break;
+
+		/* j increments twice per loop */
+		len -= j / 2;
+		hex[j++] = ' ';
+
+		seq_buf_putmem(s, hex, j);
+		if (seq_buf_has_overflowed(s))
+			return -1;
+	}
+	return 0;
+}
+
+/**
+ * seq_buf_path - copy a path into the sequence buffer
+ * @s: seq_buf descriptor
+ * @path: path to write into the sequence buffer.
+ *
+ * Write a path name into the sequence buffer.
+ *
+ * Returns zero on success, -1 on overflow
+ */
+int seq_buf_path(struct seq_buf *s, const struct path *path)
+{
+	unsigned int len = seq_buf_buffer_left(s);
+	unsigned char *p;
+
+	WARN_ON(s->size == 0);
+
+	p = d_path(path, s->buffer + s->len, len);
+	if (!IS_ERR(p)) {
+		p = mangle_path(s->buffer + s->len, p, "\n");
+		if (p) {
+			s->len = p - s->buffer;
+			return 0;
+		}
+	}
+	seq_buf_set_overflow(s);
+	return -1;
+}
+
+/**
+ * seq_buf_to_user - copy the squence buffer to user space
+ * @s: seq_buf descriptor
+ * @ubuf: The userspace memory location to copy to
+ * @cnt: The amount to copy
+ *
+ * Copies the sequence buffer into the userspace memory pointed to
+ * by @ubuf. It starts from the last read position (@s->readpos)
+ * and writes up to @cnt characters or till it reaches the end of
+ * the content in the buffer (@s->len), which ever comes first.
+ *
+ * On success, it returns a positive number of the number of bytes
+ * it copied.
+ *
+ * On failure it returns -EBUSY if all of the content in the
+ * sequence has been already read, which includes nothing in the
+ * sequence (@s->len == @s->readpos).
+ *
+ * Returns -EFAULT if the copy to userspace fails.
+ */
+int seq_buf_to_user(struct seq_buf *s, char __user *ubuf, int cnt)
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
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 3ce3c4ccfc94..7d7a07e9b9e9 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -939,19 +939,20 @@ out:
 	return ret;
 }
 
+/* TODO add a seq_buf_to_buffer() */
 static ssize_t trace_seq_to_buffer(struct trace_seq *s, void *buf, size_t cnt)
 {
 	int len;
 
-	if (s->len <= s->readpos)
+	if (s->seq.len <= s->seq.readpos)
 		return -EBUSY;
 
-	len = s->len - s->readpos;
+	len = s->seq.len - s->seq.readpos;
 	if (cnt > len)
 		cnt = len;
-	memcpy(buf, s->buffer + s->readpos, cnt);
+	memcpy(buf, s->buffer + s->seq.readpos, cnt);
 
-	s->readpos += cnt;
+	s->seq.readpos += cnt;
 	return cnt;
 }
 
@@ -4315,6 +4316,8 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
 		goto out;
 	}
 
+	trace_seq_init(&iter->seq);
+
 	/*
 	 * We make a copy of the current tracer to avoid concurrent
 	 * changes on it while we are reading.
@@ -4511,18 +4514,18 @@ waitagain:
 	trace_access_lock(iter->cpu_file);
 	while (trace_find_next_entry_inc(iter) != NULL) {
 		enum print_line_t ret;
-		int len = iter->seq.len;
+		int len = iter->seq.seq.len;
 
 		ret = print_trace_line(iter);
 		if (ret == TRACE_TYPE_PARTIAL_LINE) {
 			/* don't print partial lines */
-			iter->seq.len = len;
+			iter->seq.seq.len = len;
 			break;
 		}
 		if (ret != TRACE_TYPE_NO_CONSUME)
 			trace_consume(iter);
 
-		if (iter->seq.len >= cnt)
+		if (iter->seq.seq.len >= cnt)
 			break;
 
 		/*
@@ -4538,7 +4541,7 @@ waitagain:
 
 	/* Now copy what we have to the user */
 	sret = trace_seq_to_user(&iter->seq, ubuf, cnt);
-	if (iter->seq.readpos >= iter->seq.len)
+	if (iter->seq.seq.readpos >= iter->seq.seq.len)
 		trace_seq_init(&iter->seq);
 
 	/*
@@ -4576,16 +4579,16 @@ tracing_fill_pipe_page(size_t rem, struct trace_iterator *iter)
 
 	/* Seq buffer is page-sized, exactly what we need. */
 	for (;;) {
-		count = iter->seq.len;
+		count = iter->seq.seq.len;
 		ret = print_trace_line(iter);
-		count = iter->seq.len - count;
+		count = iter->seq.seq.len - count;
 		if (rem < count) {
 			rem = 0;
-			iter->seq.len -= count;
+			iter->seq.seq.len -= count;
 			break;
 		}
 		if (ret == TRACE_TYPE_PARTIAL_LINE) {
-			iter->seq.len -= count;
+			iter->seq.seq.len -= count;
 			break;
 		}
 
@@ -4666,13 +4669,13 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
 		/* Copy the data into the page, so we can start over. */
 		ret = trace_seq_to_buffer(&iter->seq,
 					  page_address(spd.pages[i]),
-					  iter->seq.len);
+					  iter->seq.seq.len);
 		if (ret < 0) {
 			__free_page(spd.pages[i]);
 			break;
 		}
 		spd.partial[i].offset = 0;
-		spd.partial[i].len = iter->seq.len;
+		spd.partial[i].len = iter->seq.seq.len;
 
 		trace_seq_init(&iter->seq);
 	}
@@ -5673,7 +5676,7 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
 	cnt = ring_buffer_read_events_cpu(trace_buf->buffer, cpu);
 	trace_seq_printf(s, "read events: %ld\n", cnt);
 
-	count = simple_read_from_buffer(ubuf, count, ppos, s->buffer, s->len);
+	count = simple_read_from_buffer(ubuf, count, ppos, s->buffer, s->seq.len);
 
 	kfree(s);
 
@@ -6636,11 +6639,11 @@ void
 trace_printk_seq(struct trace_seq *s)
 {
 	/* Probably should print a warning here. */
-	if (s->len >= TRACE_MAX_PRINT)
-		s->len = TRACE_MAX_PRINT;
+	if (s->seq.len >= TRACE_MAX_PRINT)
+		s->seq.len = TRACE_MAX_PRINT;
 
 	/* should be zero ended, but we are paranoid. */
-	s->buffer[s->len] = 0;
+	s->buffer[s->seq.len] = 0;
 
 	printk(KERN_TRACE "%s", s->buffer);
 
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index f9d0cbe014b7..4d0067dd7f88 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1044,7 +1044,7 @@ event_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
 	mutex_unlock(&event_mutex);
 
 	if (file)
-		r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
+		r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->seq.len);
 
 	kfree(s);
 
@@ -1210,7 +1210,7 @@ subsystem_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
 	trace_seq_init(s);
 
 	print_subsystem_event_filter(system, s);
-	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
+	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->seq.len);
 
 	kfree(s);
 
@@ -1265,7 +1265,7 @@ show_header(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
 	trace_seq_init(s);
 
 	func(s);
-	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
+	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->seq.len);
 
 	kfree(s);
 
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 100288d10e1f..6d1342ae7a44 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -1154,9 +1154,9 @@ print_graph_comment(struct trace_seq *s, struct trace_entry *ent,
 	}
 
 	/* Strip ending newline */
-	if (s->buffer[s->len - 1] == '\n') {
-		s->buffer[s->len - 1] = '\0';
-		s->len--;
+	if (s->buffer[s->seq.len - 1] == '\n') {
+		s->buffer[s->seq.len - 1] = '\0';
+		s->seq.len--;
 	}
 
 	trace_seq_puts(s, " */\n");
diff --git a/kernel/trace/trace_seq.c b/kernel/trace/trace_seq.c
index fabfa0f190a3..b623b7295864 100644
--- a/kernel/trace/trace_seq.c
+++ b/kernel/trace/trace_seq.c
@@ -27,10 +27,19 @@
 #include <linux/trace_seq.h>
 
 /* How much buffer is left on the trace_seq? */
-#define TRACE_SEQ_BUF_LEFT(s) ((PAGE_SIZE - 1) - (s)->len)
+#define TRACE_SEQ_BUF_LEFT(s) seq_buf_buffer_left(&(s)->seq)
 
 /* How much buffer is written? */
-#define TRACE_SEQ_BUF_USED(s) min((s)->len, (unsigned int)(PAGE_SIZE - 1))
+#define TRACE_SEQ_BUF_USED(s) min((s)->seq.len, (unsigned int)(PAGE_SIZE - 1))
+
+/*
+ * trace_seq should work with being initialized with 0s.
+ */
+static inline void __trace_seq_init(struct trace_seq *s)
+{
+	if (unlikely(!s->seq.size))
+		trace_seq_init(s);
+}
 
 /**
  * trace_print_seq - move the contents of trace_seq into a seq_file
@@ -43,10 +52,11 @@
  */
 int trace_print_seq(struct seq_file *m, struct trace_seq *s)
 {
-	unsigned int len = TRACE_SEQ_BUF_USED(s);
 	int ret;
 
-	ret = seq_write(m, s->buffer, len);
+	__trace_seq_init(s);
+
+	ret = seq_buf_print_seq(m, &s->seq);
 
 	/*
 	 * Only reset this buffer if we successfully wrote to the
@@ -72,24 +82,23 @@ int trace_print_seq(struct seq_file *m, struct trace_seq *s)
  */
 void trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 {
-	unsigned int len = TRACE_SEQ_BUF_LEFT(s);
+	unsigned int save_len = s->seq.len;
 	va_list ap;
-	int ret;
 
-	if (s->full || !len)
+	if (s->full)
 		return;
 
+	__trace_seq_init(s);
+
 	va_start(ap, fmt);
-	ret = vsnprintf(s->buffer + s->len, len, fmt, ap);
+	seq_buf_vprintf(&s->seq, fmt, ap);
 	va_end(ap);
 
 	/* If we can't write it all, don't bother writing anything */
-	if (ret >= len) {
+	if (unlikely(seq_buf_has_overflowed(&s->seq))) {
+		s->seq.len = save_len;
 		s->full = 1;
-		return;
 	}
-
-	s->len += ret;
 }
 EXPORT_SYMBOL_GPL(trace_seq_printf);
 
@@ -104,14 +113,19 @@ EXPORT_SYMBOL_GPL(trace_seq_printf);
 void trace_seq_bitmask(struct trace_seq *s, const unsigned long *maskp,
 		      int nmaskbits)
 {
-	unsigned int len = TRACE_SEQ_BUF_LEFT(s);
-	int ret;
+	unsigned int save_len = s->seq.len;
 
-	if (s->full || !len)
+	if (s->full)
 		return;
 
-	ret = bitmap_scnprintf(s->buffer + s->len, len, maskp, nmaskbits);
-	s->len += ret;
+	__trace_seq_init(s);
+
+	seq_buf_bitmask(&s->seq, maskp, nmaskbits);
+
+	if (unlikely(seq_buf_has_overflowed(&s->seq))) {
+		s->seq.len = save_len;
+		s->full = 1;
+	}
 }
 EXPORT_SYMBOL_GPL(trace_seq_bitmask);
 
@@ -128,21 +142,20 @@ EXPORT_SYMBOL_GPL(trace_seq_bitmask);
  */
 void trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
 {
-	unsigned int len = TRACE_SEQ_BUF_LEFT(s);
-	int ret;
+	unsigned int save_len = s->seq.len;
 
-	if (s->full || !len)
+	if (s->full)
 		return;
 
-	ret = vsnprintf(s->buffer + s->len, len, fmt, args);
+	__trace_seq_init(s);
+
+	seq_buf_vprintf(&s->seq, fmt, args);
 
 	/* If we can't write it all, don't bother writing anything */
-	if (ret >= len) {
+	if (unlikely(seq_buf_has_overflowed(&s->seq))) {
+		s->seq.len = save_len;
 		s->full = 1;
-		return;
 	}
-
-	s->len += ret;
 }
 EXPORT_SYMBOL_GPL(trace_seq_vprintf);
 
@@ -163,21 +176,22 @@ EXPORT_SYMBOL_GPL(trace_seq_vprintf);
  */
 void trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary)
 {
-	unsigned int len = TRACE_SEQ_BUF_LEFT(s);
+	unsigned int save_len = s->seq.len;
 	int ret;
 
-	if (s->full || !len)
+	if (s->full)
 		return;
 
-	ret = bstr_printf(s->buffer + s->len, len, fmt, binary);
+	__trace_seq_init(s);
+
+	ret = seq_buf_bprintf(&s->seq, fmt, binary);
 
 	/* If we can't write it all, don't bother writing anything */
-	if (ret >= len) {
+	if (unlikely(seq_buf_has_overflowed(&s->seq))) {
+		s->seq.len = save_len;
 		s->full = 1;
 		return;
 	}
-
-	s->len += ret;
 }
 EXPORT_SYMBOL_GPL(trace_seq_bprintf);
 
@@ -198,13 +212,14 @@ void trace_seq_puts(struct trace_seq *s, const char *str)
 	if (s->full)
 		return;
 
+	__trace_seq_init(s);
+
 	if (len > TRACE_SEQ_BUF_LEFT(s)) {
 		s->full = 1;
 		return;
 	}
 
-	memcpy(s->buffer + s->len, str, len);
-	s->len += len;
+	seq_buf_putmem(&s->seq, str, len);
 }
 EXPORT_SYMBOL_GPL(trace_seq_puts);
 
@@ -223,12 +238,14 @@ void trace_seq_putc(struct trace_seq *s, unsigned char c)
 	if (s->full)
 		return;
 
+	__trace_seq_init(s);
+
 	if (TRACE_SEQ_BUF_LEFT(s) < 1) {
 		s->full = 1;
 		return;
 	}
 
-	s->buffer[s->len++] = c;
+	seq_buf_putc(&s->seq, c);
 }
 EXPORT_SYMBOL_GPL(trace_seq_putc);
 
@@ -247,19 +264,17 @@ void trace_seq_putmem(struct trace_seq *s, const void *mem, unsigned int len)
 	if (s->full)
 		return;
 
+	__trace_seq_init(s);
+
 	if (len > TRACE_SEQ_BUF_LEFT(s)) {
 		s->full = 1;
 		return;
 	}
 
-	memcpy(s->buffer + s->len, mem, len);
-	s->len += len;
+	seq_buf_putmem(&s->seq, mem, len);
 }
 EXPORT_SYMBOL_GPL(trace_seq_putmem);
 
-#define MAX_MEMHEX_BYTES	8U
-#define HEX_CHARS		(MAX_MEMHEX_BYTES*2 + 1)
-
 /**
  * trace_seq_putmem_hex - write raw memory into the buffer in ASCII hex
  * @s: trace sequence descriptor
@@ -273,32 +288,26 @@ EXPORT_SYMBOL_GPL(trace_seq_putmem);
 void trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
 			 unsigned int len)
 {
-	unsigned char hex[HEX_CHARS];
-	const unsigned char *data = mem;
-	unsigned int start_len;
-	int i, j;
+	unsigned int save_len = s->seq.len;
 
 	if (s->full)
 		return;
 
-	while (len) {
-		start_len = min(len, HEX_CHARS - 1);
-#ifdef __BIG_ENDIAN
-		for (i = 0, j = 0; i < start_len; i++) {
-#else
-		for (i = start_len-1, j = 0; i >= 0; i--) {
-#endif
-			hex[j++] = hex_asc_hi(data[i]);
-			hex[j++] = hex_asc_lo(data[i]);
-		}
-		if (WARN_ON_ONCE(j == 0 || j/2 > len))
-			break;
-
-		/* j increments twice per loop */
-		len -= j / 2;
-		hex[j++] = ' ';
-
-		trace_seq_putmem(s, hex, j);
+	__trace_seq_init(s);
+
+	/* Each byte is represented by two chars */
+	if (len * 2 > TRACE_SEQ_BUF_LEFT(s)) {
+		s->full = 1;
+		return;
+	}
+
+	/* The added spaces can still cause an overflow */
+	seq_buf_putmem_hex(&s->seq, mem, len);
+
+	if (unlikely(seq_buf_has_overflowed(&s->seq))) {
+		s->seq.len = save_len;
+		s->full = 1;
+		return;
 	}
 }
 EXPORT_SYMBOL_GPL(trace_seq_putmem_hex);
@@ -317,30 +326,28 @@ EXPORT_SYMBOL_GPL(trace_seq_putmem_hex);
  */
 int trace_seq_path(struct trace_seq *s, const struct path *path)
 {
-	unsigned char *p;
+	unsigned int save_len = s->seq.len;
+	int ret;
 
 	if (s->full)
 		return 0;
 
+	__trace_seq_init(s);
+
 	if (TRACE_SEQ_BUF_LEFT(s) < 1) {
 		s->full = 1;
 		return 0;
 	}
 
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
+	ret = seq_buf_path(&s->seq, path);
+
+	if (unlikely(seq_buf_has_overflowed(&s->seq))) {
+		s->seq.len = save_len;
+		s->full = 1;
+		return 0;
 	}
 
-	s->full = 1;
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(trace_seq_path);
 
@@ -366,25 +373,7 @@ EXPORT_SYMBOL_GPL(trace_seq_path);
  */
 int trace_seq_to_user(struct trace_seq *s, char __user *ubuf, int cnt)
 {
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
+	__trace_seq_init(s);
+	return seq_buf_to_user(&s->seq, ubuf, cnt);
 }
 EXPORT_SYMBOL_GPL(trace_seq_to_user);
-- 
2.1.1


