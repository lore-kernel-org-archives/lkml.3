Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbaKDQCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:02:52 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:24656 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754644AbaKDQCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:02:30 -0500
Message-Id: <20141104160222.502133196@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 04 Nov 2014 10:52:44 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC][PATCH 07/12 v3] tracing: Have seq_buf use full buffer
References: <20141104155237.228431433@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0007-tracing-Have-seq_buf-use-full-buffer.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Currently seq_buf is full when all but one byte of the buffer is
filled. Change it so that the seq_buf is full when all of the
buffer is filled.

Some of the functions would fill the buffer completely and report
everything was fine. This was inconsistent with the max of size - 1.
Changing this to be max of size makes all functions consistent.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/seq_buf.h |  4 ++--
 kernel/trace/seq_buf.c  | 18 +++++++++---------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
index 064a8604ad33..3cd25038cb5e 100644
--- a/include/linux/seq_buf.h
+++ b/include/linux/seq_buf.h
@@ -46,13 +46,13 @@ seq_buf_init(struct seq_buf *s, unsigned char *buf, unsigned int size)
 static inline bool
 seq_buf_has_overflowed(struct seq_buf *s)
 {
-	return s->len == s->size;
+	return s->len > s->size;
 }
 
 static inline void
 seq_buf_set_overflow(struct seq_buf *s)
 {
-	s->len = s->size;
+	s->len = s->size + 1;
 }
 
 extern __printf(2, 3)
diff --git a/kernel/trace/seq_buf.c b/kernel/trace/seq_buf.c
index 243123b12d16..06fd1833e692 100644
--- a/kernel/trace/seq_buf.c
+++ b/kernel/trace/seq_buf.c
@@ -11,17 +11,17 @@
  * This will set up the counters within the descriptor. You can call
  * seq_buf_init() more than once to reset the seq_buf to start
  * from scratch.
- * 
+ *
  */
 #include <linux/uaccess.h>
 #include <linux/seq_file.h>
 #include <linux/seq_buf.h>
 
 /* How much buffer is left on the seq_buf? */
-#define SEQ_BUF_LEFT(s) (((s)->size - 1) - (s)->len)
+#define SEQ_BUF_LEFT(s) ((s)->size - (s)->len)
 
 /* How much buffer is written? */
-#define SEQ_BUF_USED(s) min((s)->len, (s)->size - 1)
+#define SEQ_BUF_USED(s) min((s)->len, (s)->size)
 
 /**
  * seq_buf_print_seq - move the contents of seq_buf into a seq_file
@@ -55,7 +55,7 @@ int seq_buf_vprintf(struct seq_buf *s, const char *fmt, va_list args)
 
 	if (s->len < s->size) {
 		len = vsnprintf(s->buffer + s->len, s->size - s->len, fmt, args);
-		if (s->len + len < s->size) {
+		if (s->len + len <= s->size) {
 			s->len += len;
 			return 0;
 		}
@@ -105,7 +105,7 @@ int seq_buf_bitmask(struct seq_buf *s, const unsigned long *maskp,
 
 	if (s->len < s->size) {
 		ret = bitmap_scnprintf(s->buffer, len, maskp, nmaskbits);
-		if (s->len + ret < s->size) {
+		if (s->len + ret <= s->size) {
 			s->len += ret;
 			return 0;
 		}
@@ -140,7 +140,7 @@ int seq_buf_bprintf(struct seq_buf *s, const char *fmt, const u32 *binary)
 
 	if (s->len < s->size) {
 		ret = bstr_printf(s->buffer + s->len, len, fmt, binary);
-		if (s->len + ret < s->size) {
+		if (s->len + ret <= s->size) {
 			s->len += ret;
 			return 0;
 		}
@@ -164,7 +164,7 @@ int seq_buf_puts(struct seq_buf *s, const char *str)
 
 	WARN_ON(s->size == 0);
 
-	if (s->len + len < s->size) {
+	if (s->len + len <= s->size) {
 		memcpy(s->buffer + s->len, str, len);
 		s->len += len;
 		return 0;
@@ -186,7 +186,7 @@ int seq_buf_putc(struct seq_buf *s, unsigned char c)
 {
 	WARN_ON(s->size == 0);
 
-	if (s->len + 1 < s->size) {
+	if (s->len + 1 <= s->size) {
 		s->buffer[s->len++] = c;
 		return 0;
 	}
@@ -210,7 +210,7 @@ int seq_buf_putmem(struct seq_buf *s, const void *mem, unsigned int len)
 {
 	WARN_ON(s->size == 0);
 
-	if (s->len + len < s->size) {
+	if (s->len + len <= s->size) {
 		memcpy(s->buffer + s->len, mem, len);
 		s->len += len;
 		return 0;
-- 
2.1.1


