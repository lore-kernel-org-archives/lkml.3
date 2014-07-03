Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030242AbaGCQSU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:18:20 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:16237 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759167AbaGCQM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:12:27 -0400
Message-Id: <20140703161224.977161041@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 03 Jul 2014 12:05:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 09/21] tracing: Clean up trace_seq.c
References: <20140703160503.006976702@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0009-tracing-Clean-up-trace_seq.c.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

For using trace_seq_*() functions in NMI context, I posted a patch to move
it to the lib/ directory. This caused Andrew Morton to take a look at the code.
He went through and gave a lot of comments about missing kernel doc,
inconsistent types for the save variable, mix match of EXPORT_SYMBOL_GPL()
and EXPORT_SYMBOL() as well as missing EXPORT_SYMBOL*()s. There were
a few comments about the way variables were being compared (int vs uint).

All these were good review comments and should be implemented regardless of
if trace_seq.c should be moved to lib/ or not.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/trace_seq.h |  20 ++---
 kernel/trace/trace_seq.c  | 207 +++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 185 insertions(+), 42 deletions(-)

diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
index 66ea365acf01..1f05317f51c4 100644
--- a/include/linux/trace_seq.h
+++ b/include/linux/trace_seq.h
@@ -38,14 +38,14 @@ int trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args);
 extern int
 trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary);
 extern int trace_print_seq(struct seq_file *m, struct trace_seq *s);
-extern ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
-				 size_t cnt);
+extern int trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
+			     int cnt);
 extern int trace_seq_puts(struct trace_seq *s, const char *str);
 extern int trace_seq_putc(struct trace_seq *s, unsigned char c);
-extern int trace_seq_putmem(struct trace_seq *s, const void *mem, size_t len);
+extern int trace_seq_putmem(struct trace_seq *s, const void *mem, unsigned int len);
 extern int trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
-				size_t len);
-extern void *trace_seq_reserve(struct trace_seq *s, size_t len);
+				unsigned int len);
+extern void *trace_seq_reserve(struct trace_seq *s, unsigned int len);
 extern int trace_seq_path(struct trace_seq *s, const struct path *path);
 
 extern int trace_seq_bitmask(struct trace_seq *s, const unsigned long *maskp,
@@ -73,8 +73,8 @@ static inline int trace_print_seq(struct seq_file *m, struct trace_seq *s)
 {
 	return 0;
 }
-static inline ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
-				 size_t cnt)
+static inline int trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
+				    int cnt)
 {
 	return 0;
 }
@@ -87,16 +87,16 @@ static inline int trace_seq_putc(struct trace_seq *s, unsigned char c)
 	return 0;
 }
 static inline int
-trace_seq_putmem(struct trace_seq *s, const void *mem, size_t len)
+trace_seq_putmem(struct trace_seq *s, const void *mem, unsigned int len)
 {
 	return 0;
 }
 static inline int trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
-				       size_t len)
+				       unsigned int len)
 {
 	return 0;
 }
-static inline void *trace_seq_reserve(struct trace_seq *s, size_t len)
+static inline void *trace_seq_reserve(struct trace_seq *s, unsigned int len)
 {
 	return NULL;
 }
diff --git a/kernel/trace/trace_seq.c b/kernel/trace/trace_seq.c
index 5ba99c6cf834..0fabca773e51 100644
--- a/kernel/trace/trace_seq.c
+++ b/kernel/trace/trace_seq.c
@@ -3,21 +3,55 @@
  *
  * Copyright (C) 2008-2014 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
  *
+ * The trace_seq is a handy tool that allows you to pass a descriptor around
+ * to a buffer that other functions can write to. It is similar to the
+ * seq_file functionality but has some differences.
+ *
+ * To use it, the trace_seq must be initialized with trace_seq_init().
+ * This will set up the counters within the descriptor. You can call
+ * trace_seq_init() more than once to reset the trace_seq to start
+ * from scratch.
+ * 
+ * The buffer size is currently PAGE_SIZE, although it may become dynamic
+ * in the future.
+ *
+ * A write to the buffer will either succed or fail. That is, unlike
+ * sprintf() there will not be a partial write (well it may write into
+ * the buffer but it wont update the pointers). This allows users to
+ * try to write something into the trace_seq buffer and if it fails
+ * they can flush it and try again.
+ *
  */
 #include <linux/uaccess.h>
 #include <linux/seq_file.h>
 #include <linux/trace_seq.h>
 
+/* How much buffer is left on the trace_seq? */
+#define TRACE_SEQ_BUF_LEFT(s) ((PAGE_SIZE - 1) - (s)->len)
+
+/* How much buffer is written? */
+#define TRACE_SEQ_BUF_USED(s) min((s)->len, (unsigned int)(PAGE_SIZE - 1))
+
+/**
+ * trace_print_seq - move the contents of trace_seq into a seq_file
+ * @m: the seq_file descriptor that is the destination
+ * @s: the trace_seq descriptor that is the source.
+ *
+ * Returns 0 on success and non zero on error. If it succeeds to
+ * write to the seq_file it will reset the trace_seq, otherwise
+ * it does not modify the trace_seq to let the caller try again.
+ */
 int trace_print_seq(struct seq_file *m, struct trace_seq *s)
 {
-	int len = s->len >= PAGE_SIZE ? PAGE_SIZE - 1 : s->len;
+	unsigned int len = TRACE_SEQ_BUF_USED(s);
 	int ret;
 
 	ret = seq_write(m, s->buffer, len);
 
 	/*
 	 * Only reset this buffer if we successfully wrote to the
-	 * seq_file buffer.
+	 * seq_file buffer. This lets the caller try again or
+	 * do something else with the contents.
 	 */
 	if (!ret)
 		trace_seq_init(s);
@@ -30,19 +64,20 @@ int trace_print_seq(struct seq_file *m, struct trace_seq *s)
  * @s: trace sequence descriptor
  * @fmt: printf format string
  *
- * It returns 0 if the trace oversizes the buffer's free
- * space, 1 otherwise.
- *
  * The tracer may use either sequence operations or its own
  * copy to user routines. To simplify formating of a trace
- * trace_seq_printf is used to store strings into a special
+ * trace_seq_printf() is used to store strings into a special
  * buffer (@s). Then the output may be either used by
  * the sequencer or pulled into another buffer.
+ *
+ * Returns 1 if we successfully written all the contents to
+ *   the buffer.
+  * Returns 0 if we the length to write is bigger than the
+ *   reserved buffer space. In this case, nothing gets written.
  */
-int
-trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
+int trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 {
-	int len = (PAGE_SIZE - 1) - s->len;
+	unsigned int len = TRACE_SEQ_BUF_LEFT(s);
 	va_list ap;
 	int ret;
 
@@ -66,21 +101,22 @@ trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 EXPORT_SYMBOL_GPL(trace_seq_printf);
 
 /**
- * trace_seq_bitmask - put a list of longs as a bitmask print output
+ * trace_seq_bitmask - write a bitmask array in its ASCII representation
  * @s:		trace sequence descriptor
  * @maskp:	points to an array of unsigned longs that represent a bitmask
  * @nmaskbits:	The number of bits that are valid in @maskp
  *
- * It returns 0 if the trace oversizes the buffer's free
- * space, 1 otherwise.
- *
  * Writes a ASCII representation of a bitmask string into @s.
+ *
+ * Returns 1 if we successfully written all the contents to
+ *   the buffer.
+ * Returns 0 if we the length to write is bigger than the
+ *   reserved buffer space. In this case, nothing gets written.
  */
-int
-trace_seq_bitmask(struct trace_seq *s, const unsigned long *maskp,
-		  int nmaskbits)
+int trace_seq_bitmask(struct trace_seq *s, const unsigned long *maskp,
+		      int nmaskbits)
 {
-	int len = (PAGE_SIZE - 1) - s->len;
+	unsigned int len = TRACE_SEQ_BUF_LEFT(s);
 	int ret;
 
 	if (s->full || !len)
@@ -103,11 +139,12 @@ EXPORT_SYMBOL_GPL(trace_seq_bitmask);
  * trace_seq_printf is used to store strings into a special
  * buffer (@s). Then the output may be either used by
  * the sequencer or pulled into another buffer.
+ *
+ * Returns how much it wrote to the buffer.
  */
-int
-trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
+int trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
 {
-	int len = (PAGE_SIZE - 1) - s->len;
+	unsigned int len = TRACE_SEQ_BUF_LEFT(s);
 	int ret;
 
 	if (s->full || !len)
@@ -127,9 +164,26 @@ trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
 }
 EXPORT_SYMBOL_GPL(trace_seq_vprintf);
 
+/**
+ * trace_seq_bprintf - Write the printf string from binary arguments
+ * @s: trace sequence descriptor
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
+ * Returns how much it wrote to the buffer.
+ */
 int trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary)
 {
-	int len = (PAGE_SIZE - 1) - s->len;
+	unsigned int len = TRACE_SEQ_BUF_LEFT(s);
 	int ret;
 
 	if (s->full || !len)
@@ -147,6 +201,7 @@ int trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary)
 
 	return len;
 }
+EXPORT_SYMBOL_GPL(trace_seq_bprintf);
 
 /**
  * trace_seq_puts - trace sequence printing of simple string
@@ -157,15 +212,17 @@ int trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary)
  * copy to user routines. This function records a simple string
  * into a special buffer (@s) for later retrieval by a sequencer
  * or other mechanism.
+ *
+ * Returns how much it wrote to the buffer.
  */
 int trace_seq_puts(struct trace_seq *s, const char *str)
 {
-	int len = strlen(str);
+	unsigned int len = strlen(str);
 
 	if (s->full)
 		return 0;
 
-	if (len > ((PAGE_SIZE - 1) - s->len)) {
+	if (len > TRACE_SEQ_BUF_LEFT(s)) {
 		s->full = 1;
 		return 0;
 	}
@@ -175,13 +232,26 @@ int trace_seq_puts(struct trace_seq *s, const char *str)
 
 	return len;
 }
+EXPORT_SYMBOL_GPL(trace_seq_puts);
 
+/**
+ * trace_seq_putc - trace sequence printing of simple character
+ * @s: trace sequence descriptor
+ * @c: simple character to record
+ *
+ * The tracer may use either the sequence operations or its own
+ * copy to user routines. This function records a simple charater
+ * into a special buffer (@s) for later retrieval by a sequencer
+ * or other mechanism.
+ *
+ * Returns how much it wrote to the buffer.
+ */
 int trace_seq_putc(struct trace_seq *s, unsigned char c)
 {
 	if (s->full)
 		return 0;
 
-	if (s->len >= (PAGE_SIZE - 1)) {
+	if (TRACE_SEQ_BUF_LEFT(s) < 1) {
 		s->full = 1;
 		return 0;
 	}
@@ -190,14 +260,26 @@ int trace_seq_putc(struct trace_seq *s, unsigned char c)
 
 	return 1;
 }
-EXPORT_SYMBOL(trace_seq_putc);
+EXPORT_SYMBOL_GPL(trace_seq_putc);
 
-int trace_seq_putmem(struct trace_seq *s, const void *mem, size_t len)
+/**
+ * trace_seq_putmem - write raw data into the trace_seq buffer
+ * @s: trace sequence descriptor
+ * @mem: The raw memory to copy into the buffer
+ * @len: The length of the raw memory to copy (in bytes)
+ *
+ * There may be cases where raw memory needs to be written into the
+ * buffer and a strcpy() would not work. Using this function allows
+ * for such cases.
+ *
+ * Returns how much it wrote to the buffer.
+ */
+int trace_seq_putmem(struct trace_seq *s, const void *mem, unsigned int len)
 {
 	if (s->full)
 		return 0;
 
-	if (len > ((PAGE_SIZE - 1) - s->len)) {
+	if (len > TRACE_SEQ_BUF_LEFT(s)) {
 		s->full = 1;
 		return 0;
 	}
@@ -207,10 +289,24 @@ int trace_seq_putmem(struct trace_seq *s, const void *mem, size_t len)
 
 	return len;
 }
+EXPORT_SYMBOL_GPL(trace_seq_putmem);
 
 #define HEX_CHARS		(MAX_MEMHEX_BYTES*2 + 1)
 
-int trace_seq_putmem_hex(struct trace_seq *s, const void *mem, size_t len)
+/**
+ * trace_seq_putmem_hex - write raw memory into the buffer in ASCII hex
+ * @s: trace sequence descriptor
+ * @mem: The raw memory to write its hex ASCII representation of
+ * @len: The length of the raw memory to copy (in bytes)
+ *
+ * This is similar to trace_seq_putmem() except instead of just copying the
+ * raw memory into the buffer it writes its ASCII representation of it
+ * in hex characters.
+ *
+ * Returns how much it wrote to the buffer.
+ */
+int trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
+			 unsigned int len)
 {
 	unsigned char hex[HEX_CHARS];
 	const unsigned char *data = mem;
@@ -231,15 +327,27 @@ int trace_seq_putmem_hex(struct trace_seq *s, const void *mem, size_t len)
 
 	return trace_seq_putmem(s, hex, j);
 }
+EXPORT_SYMBOL_GPL(trace_seq_putmem_hex);
 
-void *trace_seq_reserve(struct trace_seq *s, size_t len)
+/**
+ * trace_seq_reserve - reserve space on the sequence buffer
+ * @s: trace sequence descriptor
+ * @len: The amount to reserver.
+ *
+ * If for some reason there is a need to save some space on the
+ * buffer to fill in later, this function is used for that purpose.
+ * The given length will be reserved and the pointer to that
+ * location on the buffer is returned, unless there is not enough
+ * buffer left to hold the given length then NULL is returned.
+ */
+void *trace_seq_reserve(struct trace_seq *s, unsigned int len)
 {
 	void *ret;
 
 	if (s->full)
 		return NULL;
 
-	if (len > ((PAGE_SIZE - 1) - s->len)) {
+	if (len > TRACE_SEQ_BUF_LEFT(s)) {
 		s->full = 1;
 		return NULL;
 	}
@@ -249,7 +357,20 @@ void *trace_seq_reserve(struct trace_seq *s, size_t len)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(trace_seq_reserve);
 
+/**
+ * trace_seq_path - copy a path into the sequence buffer
+ * @s: trace sequence descriptor
+ * @path: path to write into the sequence buffer.
+ *
+ * Write a path name into the sequence buffer.
+ *
+ * Returns 1 if we successfully written all the contents to
+ *   the buffer.
+ * Returns 0 if we the length to write is bigger than the
+ *   reserved buffer space. In this case, nothing gets written.
+ */
 int trace_seq_path(struct trace_seq *s, const struct path *path)
 {
 	unsigned char *p;
@@ -257,7 +378,7 @@ int trace_seq_path(struct trace_seq *s, const struct path *path)
 	if (s->full)
 		return 0;
 
-	if (s->len >= (PAGE_SIZE - 1)) {
+	if (TRACE_SEQ_BUF_LEFT(s) < 1) {
 		s->full = 1;
 		return 0;
 	}
@@ -277,8 +398,29 @@ int trace_seq_path(struct trace_seq *s, const struct path *path)
 	s->full = 1;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(trace_seq_path);
 
-ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf, size_t cnt)
+/**
+ * trace_seq_to_user - copy the squence buffer to user space
+ * @s: trace sequence descriptor
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
+int trace_seq_to_user(struct trace_seq *s, char __user *ubuf, int cnt)
 {
 	int len;
 	int ret;
@@ -301,3 +443,4 @@ ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf, size_t cnt)
 	s->readpos += cnt;
 	return cnt;
 }
+EXPORT_SYMBOL_GPL(trace_seq_to_user);
-- 
2.0.0


