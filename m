Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536AbaKTPaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 10:30:52 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:42635 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932147AbaKTP1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 10:27:18 -0500
Message-Id: <20141120152715.933135473@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 20 Nov 2014 10:21:22 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>
Subject: [for-next][PATCH 02/15] tracing: Convert seq_buf_path() to be like seq_path()
References: <20141120152120.168868031@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0002-tracing-Convert-seq_buf_path-to-be-like-seq_path.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Rewrite seq_buf_path() like it is done in seq_path() and allow
it to accept any escape character instead of just "\n".

Making seq_buf_path() like seq_path() will help prevent problems
when converting seq_file to use the seq_buf logic.

Link: http://lkml.kernel.org/r/20141104160222.048795666@goodmis.org
Link: http://lkml.kernel.org/r/20141114011412.338523371@goodmis.org

Tested-by: Jiri Kosina <jkosina@suse.cz>
Acked-by: Jiri Kosina <jkosina@suse.cz>
Reviewed-by: Petr Mladek <pmladek@suse.cz>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/seq_buf.h  |  2 +-
 kernel/trace/seq_buf.c   | 28 ++++++++++++++++------------
 kernel/trace/trace_seq.c |  5 ++---
 3 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
index 4f7a96a9d71a..38770688a627 100644
--- a/include/linux/seq_buf.h
+++ b/include/linux/seq_buf.h
@@ -73,7 +73,7 @@ extern int seq_buf_putc(struct seq_buf *s, unsigned char c);
 extern int seq_buf_putmem(struct seq_buf *s, const void *mem, unsigned int len);
 extern int seq_buf_putmem_hex(struct seq_buf *s, const void *mem,
 			      unsigned int len);
-extern int seq_buf_path(struct seq_buf *s, const struct path *path);
+extern int seq_buf_path(struct seq_buf *s, const struct path *path, const char *esc);
 
 extern int seq_buf_bitmask(struct seq_buf *s, const unsigned long *maskp,
 			   int nmaskbits);
diff --git a/kernel/trace/seq_buf.c b/kernel/trace/seq_buf.c
index e9a7861595d2..7dac34d1235b 100644
--- a/kernel/trace/seq_buf.c
+++ b/kernel/trace/seq_buf.c
@@ -272,28 +272,32 @@ int seq_buf_putmem_hex(struct seq_buf *s, const void *mem,
  * seq_buf_path - copy a path into the sequence buffer
  * @s: seq_buf descriptor
  * @path: path to write into the sequence buffer.
+ * @esc: set of characters to escape in the output
  *
  * Write a path name into the sequence buffer.
  *
- * Returns zero on success, -1 on overflow
+ * Returns the number of written bytes on success, -1 on overflow
  */
-int seq_buf_path(struct seq_buf *s, const struct path *path)
+int seq_buf_path(struct seq_buf *s, const struct path *path, const char *esc)
 {
-	unsigned int len = seq_buf_buffer_left(s);
-	unsigned char *p;
+	char *buf = s->buffer + s->len;
+	size_t size = seq_buf_buffer_left(s);
+	int res = -1;
 
 	WARN_ON(s->size == 0);
 
-	p = d_path(path, s->buffer + s->len, len);
-	if (!IS_ERR(p)) {
-		p = mangle_path(s->buffer + s->len, p, "\n");
-		if (p) {
-			s->len = p - s->buffer;
-			return 0;
+	if (size) {
+		char *p = d_path(path, buf, size);
+		if (!IS_ERR(p)) {
+			char *end = mangle_path(buf, p, esc);
+			if (end)
+				res = end - buf;
 		}
 	}
-	seq_buf_set_overflow(s);
-	return -1;
+	if (res > 0)
+		s->len += res;
+
+	return res;
 }
 
 /**
diff --git a/kernel/trace/trace_seq.c b/kernel/trace/trace_seq.c
index 8c0c54fe674b..74cacc930c24 100644
--- a/kernel/trace/trace_seq.c
+++ b/kernel/trace/trace_seq.c
@@ -326,7 +326,6 @@ EXPORT_SYMBOL_GPL(trace_seq_putmem_hex);
 int trace_seq_path(struct trace_seq *s, const struct path *path)
 {
 	unsigned int save_len = s->seq.len;
-	int ret;
 
 	if (s->full)
 		return 0;
@@ -338,7 +337,7 @@ int trace_seq_path(struct trace_seq *s, const struct path *path)
 		return 0;
 	}
 
-	ret = seq_buf_path(&s->seq, path);
+	seq_buf_path(&s->seq, path, "\n");
 
 	if (unlikely(seq_buf_has_overflowed(&s->seq))) {
 		s->seq.len = save_len;
@@ -346,7 +345,7 @@ int trace_seq_path(struct trace_seq *s, const struct path *path)
 		return 0;
 	}
 
-	return ret;
+	return 1;
 }
 EXPORT_SYMBOL_GPL(trace_seq_path);
 
-- 
2.1.1


