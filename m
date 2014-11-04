Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbaKDQGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:06:23 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:24663 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754551AbaKDQC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:02:28 -0500
Message-Id: <20141104160222.809349817@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 04 Nov 2014 10:52:46 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC][PATCH 09/12 v3] seq_buf: Move the seq_buf code to lib/
References: <20141104155237.228431433@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0009-seq_buf-Move-the-seq_buf-code-to-lib.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The seq_buf functions are rather useful outside of tracing. Instead
of having it be dependent on CONFIG_TRACING, move the code into lib/
and allow other users to have access to it even when tracing is not
configured.

The seq_buf utility is similar to the seq_file utility, but instead of
writing sending data back up to userland, it writes it into a buffer
defined at seq_buf_init(). This allows us to send a descriptor around
that writes printf() formatted strings into it that can be retrieved
later.

It is currently used by the tracing facility for such things like trace
events to convert its binary saved data in the ring buffer into an
ASCII human readable context to be displayed in /sys/kernel/debug/trace.

It can also be used for doing NMI prints safely from NMI context into
the seq_buf and retrieved later and dumped to printk() safely. Doing
printk() from an NMI context is dangerous because an NMI can preempt
a current printk() and deadlock on it.

Link: http://lkml.kernel.org/p/20140619213952.058255809@goodmis.org

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/Makefile  |   1 -
 kernel/trace/seq_buf.c | 342 -------------------------------------------------
 lib/Makefile           |   2 +-
 lib/seq_buf.c          | 342 +++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 343 insertions(+), 344 deletions(-)
 delete mode 100644 kernel/trace/seq_buf.c
 create mode 100644 lib/seq_buf.c

diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index edc98c72a634..67d6369ddf83 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -29,7 +29,6 @@ obj-$(CONFIG_RING_BUFFER_BENCHMARK) += ring_buffer_benchmark.o
 obj-$(CONFIG_TRACING) += trace.o
 obj-$(CONFIG_TRACING) += trace_output.o
 obj-$(CONFIG_TRACING) += trace_seq.o
-obj-$(CONFIG_TRACING) += seq_buf.o
 obj-$(CONFIG_TRACING) += trace_stat.o
 obj-$(CONFIG_TRACING) += trace_printk.o
 obj-$(CONFIG_CONTEXT_SWITCH_TRACER) += trace_sched_switch.o
diff --git a/kernel/trace/seq_buf.c b/kernel/trace/seq_buf.c
deleted file mode 100644
index d118d0d6c956..000000000000
--- a/kernel/trace/seq_buf.c
+++ /dev/null
@@ -1,342 +0,0 @@
-/*
- * seq_buf.c
- *
- * Copyright (C) 2014 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
- *
- * The seq_buf is a handy tool that allows you to pass a descriptor around
- * to a buffer that other functions can write to. It is similar to the
- * seq_file functionality but has some differences.
- *
- * To use it, the seq_buf must be initialized with seq_buf_init().
- * This will set up the counters within the descriptor. You can call
- * seq_buf_init() more than once to reset the seq_buf to start
- * from scratch.
- *
- */
-#include <linux/uaccess.h>
-#include <linux/seq_file.h>
-#include <linux/seq_buf.h>
-
-/* How much buffer is left on the seq_buf? */
-#define SEQ_BUF_LEFT(s) ((s)->size - (s)->len)
-
-/* How much buffer is written? */
-#define SEQ_BUF_USED(s) min((s)->len, (s)->size)
-
-/**
- * seq_buf_print_seq - move the contents of seq_buf into a seq_file
- * @m: the seq_file descriptor that is the destination
- * @s: the seq_buf descriptor that is the source.
- *
- * Returns zero on success, non zero otherwise
- */
-int seq_buf_print_seq(struct seq_file *m, struct seq_buf *s)
-{
-	unsigned int len = SEQ_BUF_USED(s);
-
-	return seq_write(m, s->buffer, len);
-}
-
-/**
- * seq_buf_vprintf - sequence printing of information.
- * @s: seq_buf descriptor
- * @fmt: printf format string
- * @args: va_list of arguments from a printf() type function
- *
- * Writes a vnprintf() format into the sequencce buffer.
- *
- * Returns zero on success, -1 on overflow.
- */
-int seq_buf_vprintf(struct seq_buf *s, const char *fmt, va_list args)
-{
-	int len;
-
-	WARN_ON(s->size == 0);
-
-	if (s->len < s->size) {
-		len = vsnprintf(s->buffer + s->len, s->size - s->len, fmt, args);
-		if (s->len + len <= s->size) {
-			s->len += len;
-			return 0;
-		}
-	}
-	seq_buf_set_overflow(s);
-	return -1;
-}
-
-/**
- * seq_buf_printf - sequence printing of information
- * @s: seq_buf descriptor
- * @fmt: printf format string
- *
- * Writes a printf() format into the sequence buffer.
- *
- * Returns zero on success, -1 on overflow.
- */
-int seq_buf_printf(struct seq_buf *s, const char *fmt, ...)
-{
-	va_list ap;
-	int ret;
-
-	va_start(ap, fmt);
-	ret = seq_buf_vprintf(s, fmt, ap);
-	va_end(ap);
-
-	return ret;
-}
-
-/**
- * seq_buf_bitmask - write a bitmask array in its ASCII representation
- * @s:		seq_buf descriptor
- * @maskp:	points to an array of unsigned longs that represent a bitmask
- * @nmaskbits:	The number of bits that are valid in @maskp
- *
- * Writes a ASCII representation of a bitmask string into @s.
- *
- * Returns the number of bytes written.
- */
-int seq_buf_bitmask(struct seq_buf *s, const unsigned long *maskp,
-		    int nmaskbits)
-{
-	unsigned int len = SEQ_BUF_LEFT(s);
-	int ret;
-
-	WARN_ON(s->size == 0);
-
-	if (s->len < s->size) {
-		ret = bitmap_scnprintf(s->buffer, len, maskp, nmaskbits);
-		if (s->len + ret <= s->size) {
-			s->len += ret;
-			return 0;
-		}
-	}
-	seq_buf_set_overflow(s);
-	return -1;
-}
-
-/**
- * seq_buf_bprintf - Write the printf string from binary arguments
- * @s: seq_buf descriptor
- * @fmt: The format string for the @binary arguments
- * @binary: The binary arguments for @fmt.
- *
- * When recording in a fast path, a printf may be recorded with just
- * saving the format and the arguments as they were passed to the
- * function, instead of wasting cycles converting the arguments into
- * ASCII characters. Instead, the arguments are saved in a 32 bit
- * word array that is defined by the format string constraints.
- *
- * This function will take the format and the binary array and finish
- * the conversion into the ASCII string within the buffer.
- *
- * Returns zero on success, -1 on overflow.
- */
-int seq_buf_bprintf(struct seq_buf *s, const char *fmt, const u32 *binary)
-{
-	unsigned int len = SEQ_BUF_LEFT(s);
-	int ret;
-
-	WARN_ON(s->size == 0);
-
-	if (s->len < s->size) {
-		ret = bstr_printf(s->buffer + s->len, len, fmt, binary);
-		if (s->len + ret <= s->size) {
-			s->len += ret;
-			return 0;
-		}
-	}
-	seq_buf_set_overflow(s);
-	return -1;
-}
-
-/**
- * seq_buf_puts - sequence printing of simple string
- * @s: seq_buf descriptor
- * @str: simple string to record
- *
- * Copy a simple string into the sequence buffer.
- *
- * Returns zero on success, -1 on overflow
- */
-int seq_buf_puts(struct seq_buf *s, const char *str)
-{
-	unsigned int len = strlen(str);
-
-	WARN_ON(s->size == 0);
-
-	if (s->len + len <= s->size) {
-		memcpy(s->buffer + s->len, str, len);
-		s->len += len;
-		return 0;
-	}
-	seq_buf_set_overflow(s);
-	return -1;
-}
-
-/**
- * seq_buf_putc - sequence printing of simple character
- * @s: seq_buf descriptor
- * @c: simple character to record
- *
- * Copy a single character into the sequence buffer.
- *
- * Returns zero on success, -1 on overflow
- */
-int seq_buf_putc(struct seq_buf *s, unsigned char c)
-{
-	WARN_ON(s->size == 0);
-
-	if (s->len + 1 <= s->size) {
-		s->buffer[s->len++] = c;
-		return 0;
-	}
-	seq_buf_set_overflow(s);
-	return -1;
-}
-
-/**
- * seq_buf_putmem - write raw data into the sequenc buffer
- * @s: seq_buf descriptor
- * @mem: The raw memory to copy into the buffer
- * @len: The length of the raw memory to copy (in bytes)
- *
- * There may be cases where raw memory needs to be written into the
- * buffer and a strcpy() would not work. Using this function allows
- * for such cases.
- *
- * Returns zero on success, -1 on overflow
- */
-int seq_buf_putmem(struct seq_buf *s, const void *mem, unsigned int len)
-{
-	WARN_ON(s->size == 0);
-
-	if (s->len + len <= s->size) {
-		memcpy(s->buffer + s->len, mem, len);
-		s->len += len;
-		return 0;
-	}
-	seq_buf_set_overflow(s);
-	return -1;
-}
-
-#define MAX_MEMHEX_BYTES	8U
-#define HEX_CHARS		(MAX_MEMHEX_BYTES*2 + 1)
-
-/**
- * seq_buf_putmem_hex - write raw memory into the buffer in ASCII hex
- * @s: seq_buf descriptor
- * @mem: The raw memory to write its hex ASCII representation of
- * @len: The length of the raw memory to copy (in bytes)
- *
- * This is similar to seq_buf_putmem() except instead of just copying the
- * raw memory into the buffer it writes its ASCII representation of it
- * in hex characters.
- *
- * Returns zero on success, -1 on overflow
- */
-int seq_buf_putmem_hex(struct seq_buf *s, const void *mem,
-		       unsigned int len)
-{
-	unsigned char hex[HEX_CHARS];
-	const unsigned char *data = mem;
-	unsigned int start_len;
-	int i, j;
-
-	WARN_ON(s->size == 0);
-
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
-		seq_buf_putmem(s, hex, j);
-		if (seq_buf_has_overflowed(s))
-			return -1;
-	}
-	return 0;
-}
-
-/**
- * seq_buf_path - copy a path into the sequence buffer
- * @s: seq_buf descriptor
- * @path: path to write into the sequence buffer.
- * @esc: set of characters to escape in the output
- *
- * Write a path name into the sequence buffer.
- *
- * Returns zero on success, -1 on overflow
- */
-int seq_buf_path(struct seq_buf *s, const struct path *path, const char *esc)
-{
-	char *buf;
-	size_t size = seq_buf_get_buf(s, &buf);
-	int res = -1;
-
-	if (size) {
-		char *p = d_path(path, buf, size);
-		if (!IS_ERR(p)) {
-			char *end = mangle_path(buf, p, esc);
-			if (end)
-				res = end - buf;
-		}
-	}
-	seq_buf_commit(s, res);
-
-	return res;
-}
-
-/**
- * seq_buf_to_user - copy the squence buffer to user space
- * @s: seq_buf descriptor
- * @ubuf: The userspace memory location to copy to
- * @cnt: The amount to copy
- *
- * Copies the sequence buffer into the userspace memory pointed to
- * by @ubuf. It starts from the last read position (@s->readpos)
- * and writes up to @cnt characters or till it reaches the end of
- * the content in the buffer (@s->len), which ever comes first.
- *
- * On success, it returns a positive number of the number of bytes
- * it copied.
- *
- * On failure it returns -EBUSY if all of the content in the
- * sequence has been already read, which includes nothing in the
- * sequenc (@s->len == @s->readpos).
- *
- * Returns -EFAULT if the copy to userspace fails.
- */
-int seq_buf_to_user(struct seq_buf *s, char __user *ubuf, int cnt)
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
diff --git a/lib/Makefile b/lib/Makefile
index 7512dc978f18..a1aa1e81ed36 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -13,7 +13,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o flex_proportions.o ratelimit.o show_mem.o \
 	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
-	 earlycpio.o
+	 earlycpio.o seq_buf.o
 
 obj-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
 lib-$(CONFIG_MMU) += ioremap.o
diff --git a/lib/seq_buf.c b/lib/seq_buf.c
new file mode 100644
index 000000000000..d118d0d6c956
--- /dev/null
+++ b/lib/seq_buf.c
@@ -0,0 +1,342 @@
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
+ *
+ */
+#include <linux/uaccess.h>
+#include <linux/seq_file.h>
+#include <linux/seq_buf.h>
+
+/* How much buffer is left on the seq_buf? */
+#define SEQ_BUF_LEFT(s) ((s)->size - (s)->len)
+
+/* How much buffer is written? */
+#define SEQ_BUF_USED(s) min((s)->len, (s)->size)
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
+		if (s->len + len <= s->size) {
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
+ * Returns the number of bytes written.
+ */
+int seq_buf_bitmask(struct seq_buf *s, const unsigned long *maskp,
+		    int nmaskbits)
+{
+	unsigned int len = SEQ_BUF_LEFT(s);
+	int ret;
+
+	WARN_ON(s->size == 0);
+
+	if (s->len < s->size) {
+		ret = bitmap_scnprintf(s->buffer, len, maskp, nmaskbits);
+		if (s->len + ret <= s->size) {
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
+	unsigned int len = SEQ_BUF_LEFT(s);
+	int ret;
+
+	WARN_ON(s->size == 0);
+
+	if (s->len < s->size) {
+		ret = bstr_printf(s->buffer + s->len, len, fmt, binary);
+		if (s->len + ret <= s->size) {
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
+	if (s->len + len <= s->size) {
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
+	if (s->len + 1 <= s->size) {
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
+	if (s->len + len <= s->size) {
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
+ * @esc: set of characters to escape in the output
+ *
+ * Write a path name into the sequence buffer.
+ *
+ * Returns zero on success, -1 on overflow
+ */
+int seq_buf_path(struct seq_buf *s, const struct path *path, const char *esc)
+{
+	char *buf;
+	size_t size = seq_buf_get_buf(s, &buf);
+	int res = -1;
+
+	if (size) {
+		char *p = d_path(path, buf, size);
+		if (!IS_ERR(p)) {
+			char *end = mangle_path(buf, p, esc);
+			if (end)
+				res = end - buf;
+		}
+	}
+	seq_buf_commit(s, res);
+
+	return res;
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
+ * sequenc (@s->len == @s->readpos).
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
-- 
2.1.1


