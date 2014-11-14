Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935018AbaKNBTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 20:19:18 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:27203 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934803AbaKNBOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 20:14:14 -0500
Message-Id: <20141114011411.992510720@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 13 Nov 2014 20:12:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>
Subject: [RFC][PATCH 12/23 v4] tracing: Remove return values of most trace_seq_*() functions
References: <20141114011244.256115061@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0012-tracing-Remove-return-values-of-most-trace_seq_-func.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The trace_seq_printf() and friends are used to store strings into a buffer
that can be passed around from function to function. If the trace_seq buffer
fills up, it will not print any more. The return values were somewhat
inconsistant and using trace_seq_has_overflowed() was a better way to know
if the write to the trace_seq buffer succeeded or not.

Now that all users have removed reading the return value of the printf()
type functions, they can safely return void and keep future users of them
from reading the inconsistent values as well.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/trace_seq.h | 37 +++++++++------------
 kernel/trace/trace_seq.c  | 84 +++++++++++++----------------------------------
 2 files changed, 37 insertions(+), 84 deletions(-)

diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
index 07eda413dfcf..db8a73224f1a 100644
--- a/include/linux/trace_seq.h
+++ b/include/linux/trace_seq.h
@@ -57,40 +57,37 @@ static inline bool trace_seq_has_overflowed(struct trace_seq *s)
  */
 #ifdef CONFIG_TRACING
 extern __printf(2, 3)
-int trace_seq_printf(struct trace_seq *s, const char *fmt, ...);
+void trace_seq_printf(struct trace_seq *s, const char *fmt, ...);
 extern __printf(2, 0)
-int trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args);
-extern int
+void trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args);
+extern void
 trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary);
 extern int trace_print_seq(struct seq_file *m, struct trace_seq *s);
 extern int trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
 			     int cnt);
-extern int trace_seq_puts(struct trace_seq *s, const char *str);
-extern int trace_seq_putc(struct trace_seq *s, unsigned char c);
-extern int trace_seq_putmem(struct trace_seq *s, const void *mem, unsigned int len);
-extern int trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
+extern void trace_seq_puts(struct trace_seq *s, const char *str);
+extern void trace_seq_putc(struct trace_seq *s, unsigned char c);
+extern void trace_seq_putmem(struct trace_seq *s, const void *mem, unsigned int len);
+extern void trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
 				unsigned int len);
 extern int trace_seq_path(struct trace_seq *s, const struct path *path);
 
-extern int trace_seq_bitmask(struct trace_seq *s, const unsigned long *maskp,
+extern void trace_seq_bitmask(struct trace_seq *s, const unsigned long *maskp,
 			     int nmaskbits);
 
 #else /* CONFIG_TRACING */
-static inline int trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
+static inline void trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 {
-	return 0;
 }
-static inline int
+static inline void
 trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary)
 {
-	return 0;
 }
 
-static inline int
+static inline void
 trace_seq_bitmask(struct trace_seq *s, const unsigned long *maskp,
 		  int nmaskbits)
 {
-	return 0;
 }
 
 static inline int trace_print_seq(struct seq_file *m, struct trace_seq *s)
@@ -102,23 +99,19 @@ static inline int trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
 {
 	return 0;
 }
-static inline int trace_seq_puts(struct trace_seq *s, const char *str)
+static inline void trace_seq_puts(struct trace_seq *s, const char *str)
 {
-	return 0;
 }
-static inline int trace_seq_putc(struct trace_seq *s, unsigned char c)
+static inline void trace_seq_putc(struct trace_seq *s, unsigned char c)
 {
-	return 0;
 }
-static inline int
+static inline void
 trace_seq_putmem(struct trace_seq *s, const void *mem, unsigned int len)
 {
-	return 0;
 }
-static inline int trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
+static inline void trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
 				       unsigned int len)
 {
-	return 0;
 }
 static inline int trace_seq_path(struct trace_seq *s, const struct path *path)
 {
diff --git a/kernel/trace/trace_seq.c b/kernel/trace/trace_seq.c
index b100994a17fe..e54c0a1fb3f0 100644
--- a/kernel/trace/trace_seq.c
+++ b/kernel/trace/trace_seq.c
@@ -69,20 +69,15 @@ int trace_print_seq(struct seq_file *m, struct trace_seq *s)
  * trace_seq_printf() is used to store strings into a special
  * buffer (@s). Then the output may be either used by
  * the sequencer or pulled into another buffer.
- *
- * Returns 1 if we successfully written all the contents to
- *   the buffer.
-  * Returns 0 if we the length to write is bigger than the
- *   reserved buffer space. In this case, nothing gets written.
  */
-int trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
+void trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 {
 	unsigned int len = TRACE_SEQ_BUF_LEFT(s);
 	va_list ap;
 	int ret;
 
 	if (s->full || !len)
-		return 0;
+		return;
 
 	va_start(ap, fmt);
 	ret = vsnprintf(s->buffer + s->len, len, fmt, ap);
@@ -91,12 +86,10 @@ int trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 	/* If we can't write it all, don't bother writing anything */
 	if (ret >= len) {
 		s->full = 1;
-		return 0;
+		return;
 	}
 
 	s->len += ret;
-
-	return 1;
 }
 EXPORT_SYMBOL_GPL(trace_seq_printf);
 
@@ -107,25 +100,18 @@ EXPORT_SYMBOL_GPL(trace_seq_printf);
  * @nmaskbits:	The number of bits that are valid in @maskp
  *
  * Writes a ASCII representation of a bitmask string into @s.
- *
- * Returns 1 if we successfully written all the contents to
- *   the buffer.
- * Returns 0 if we the length to write is bigger than the
- *   reserved buffer space. In this case, nothing gets written.
  */
-int trace_seq_bitmask(struct trace_seq *s, const unsigned long *maskp,
+void trace_seq_bitmask(struct trace_seq *s, const unsigned long *maskp,
 		      int nmaskbits)
 {
 	unsigned int len = TRACE_SEQ_BUF_LEFT(s);
 	int ret;
 
 	if (s->full || !len)
-		return 0;
+		return;
 
 	ret = bitmap_scnprintf(s->buffer + s->len, len, maskp, nmaskbits);
 	s->len += ret;
-
-	return 1;
 }
 EXPORT_SYMBOL_GPL(trace_seq_bitmask);
 
@@ -139,28 +125,24 @@ EXPORT_SYMBOL_GPL(trace_seq_bitmask);
  * trace_seq_printf is used to store strings into a special
  * buffer (@s). Then the output may be either used by
  * the sequencer or pulled into another buffer.
- *
- * Returns how much it wrote to the buffer.
  */
-int trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
+void trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
 {
 	unsigned int len = TRACE_SEQ_BUF_LEFT(s);
 	int ret;
 
 	if (s->full || !len)
-		return 0;
+		return;
 
 	ret = vsnprintf(s->buffer + s->len, len, fmt, args);
 
 	/* If we can't write it all, don't bother writing anything */
 	if (ret >= len) {
 		s->full = 1;
-		return 0;
+		return;
 	}
 
 	s->len += ret;
-
-	return len;
 }
 EXPORT_SYMBOL_GPL(trace_seq_vprintf);
 
@@ -178,28 +160,24 @@ EXPORT_SYMBOL_GPL(trace_seq_vprintf);
  *
  * This function will take the format and the binary array and finish
  * the conversion into the ASCII string within the buffer.
- *
- * Returns how much it wrote to the buffer.
  */
-int trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary)
+void trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary)
 {
 	unsigned int len = TRACE_SEQ_BUF_LEFT(s);
 	int ret;
 
 	if (s->full || !len)
-		return 0;
+		return;
 
 	ret = bstr_printf(s->buffer + s->len, len, fmt, binary);
 
 	/* If we can't write it all, don't bother writing anything */
 	if (ret >= len) {
 		s->full = 1;
-		return 0;
+		return;
 	}
 
 	s->len += ret;
-
-	return len;
 }
 EXPORT_SYMBOL_GPL(trace_seq_bprintf);
 
@@ -212,25 +190,21 @@ EXPORT_SYMBOL_GPL(trace_seq_bprintf);
  * copy to user routines. This function records a simple string
  * into a special buffer (@s) for later retrieval by a sequencer
  * or other mechanism.
- *
- * Returns how much it wrote to the buffer.
  */
-int trace_seq_puts(struct trace_seq *s, const char *str)
+void trace_seq_puts(struct trace_seq *s, const char *str)
 {
 	unsigned int len = strlen(str);
 
 	if (s->full)
-		return 0;
+		return;
 
 	if (len > TRACE_SEQ_BUF_LEFT(s)) {
 		s->full = 1;
-		return 0;
+		return;
 	}
 
 	memcpy(s->buffer + s->len, str, len);
 	s->len += len;
-
-	return len;
 }
 EXPORT_SYMBOL_GPL(trace_seq_puts);
 
@@ -243,22 +217,18 @@ EXPORT_SYMBOL_GPL(trace_seq_puts);
  * copy to user routines. This function records a simple charater
  * into a special buffer (@s) for later retrieval by a sequencer
  * or other mechanism.
- *
- * Returns how much it wrote to the buffer.
  */
-int trace_seq_putc(struct trace_seq *s, unsigned char c)
+void trace_seq_putc(struct trace_seq *s, unsigned char c)
 {
 	if (s->full)
-		return 0;
+		return;
 
 	if (TRACE_SEQ_BUF_LEFT(s) < 1) {
 		s->full = 1;
-		return 0;
+		return;
 	}
 
 	s->buffer[s->len++] = c;
-
-	return 1;
 }
 EXPORT_SYMBOL_GPL(trace_seq_putc);
 
@@ -271,23 +241,19 @@ EXPORT_SYMBOL_GPL(trace_seq_putc);
  * There may be cases where raw memory needs to be written into the
  * buffer and a strcpy() would not work. Using this function allows
  * for such cases.
- *
- * Returns how much it wrote to the buffer.
  */
-int trace_seq_putmem(struct trace_seq *s, const void *mem, unsigned int len)
+void trace_seq_putmem(struct trace_seq *s, const void *mem, unsigned int len)
 {
 	if (s->full)
-		return 0;
+		return;
 
 	if (len > TRACE_SEQ_BUF_LEFT(s)) {
 		s->full = 1;
-		return 0;
+		return;
 	}
 
 	memcpy(s->buffer + s->len, mem, len);
 	s->len += len;
-
-	return len;
 }
 EXPORT_SYMBOL_GPL(trace_seq_putmem);
 
@@ -303,20 +269,17 @@ EXPORT_SYMBOL_GPL(trace_seq_putmem);
  * This is similar to trace_seq_putmem() except instead of just copying the
  * raw memory into the buffer it writes its ASCII representation of it
  * in hex characters.
- *
- * Returns how much it wrote to the buffer.
  */
-int trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
+void trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
 			 unsigned int len)
 {
 	unsigned char hex[HEX_CHARS];
 	const unsigned char *data = mem;
 	unsigned int start_len;
 	int i, j;
-	int cnt = 0;
 
 	if (s->full)
-		return 0;
+		return;
 
 	while (len) {
 		start_len = min(len, HEX_CHARS - 1);
@@ -334,10 +297,7 @@ int trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
 		/* j increments twice per loop */
 		len -= j / 2;
 		hex[j++] = ' ';
-
-		cnt += trace_seq_putmem(s, hex, j);
 	}
-	return cnt;
 }
 EXPORT_SYMBOL_GPL(trace_seq_putmem_hex);
 
-- 
2.1.1


