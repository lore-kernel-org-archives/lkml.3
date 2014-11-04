Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbaKDQCu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:02:50 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:24656 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932068AbaKDQCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:02:32 -0500
Message-Id: <20141104160222.644881406@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 04 Nov 2014 10:52:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC][PATCH 08/12 v3] tracing: Add seq_buf_get_buf() and seq_buf_commit() helper functions
References: <20141104155237.228431433@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0008-tracing-Add-seq_buf_get_buf-and-seq_buf_commit-helpe.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Add two helper functions; seq_buf_get_buf() and seq_buf_commit() that
are used by seq_buf_path(). This makes the code similar to the
seq_file: seq_path() function, and will help to be able to consolidate
the functions between seq_file and trace_seq.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/seq_buf.h | 40 ++++++++++++++++++++++++++++++++++++++++
 kernel/trace/seq_buf.c  |  7 +++----
 2 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
index 3cd25038cb5e..10c17c61c7a4 100644
--- a/include/linux/seq_buf.h
+++ b/include/linux/seq_buf.h
@@ -55,6 +55,46 @@ seq_buf_set_overflow(struct seq_buf *s)
 	s->len = s->size + 1;
 }
 
+/**
+ * seq_buf_get_buf - get buffer to write arbitrary data to
+ * @s: the seq_buf handle
+ * @bufp: the beginning of the buffer is stored here
+ *
+ * Return the number of bytes available in the buffer, or zero if
+ * there's no space.
+ */
+static inline size_t seq_buf_get_buf(struct seq_buf *s, char **bufp)
+{
+	BUG_ON(s->len > s->size + 1);
+
+	if (s->len < s->size) {
+		*bufp = s->buffer + s->len;
+		return s->size - s->len;
+	}
+
+	*bufp = NULL;
+	return 0;
+}
+
+/**
+ * seq_buf_commit - commit data to the buffer
+ * @s: the seq_buf handle
+ * @num: the number of bytes to commit
+ *
+ * Commit @num bytes of data written to a buffer previously acquired
+ * by seq_buf_get.  To signal an error condition, or that the data
+ * didn't fit in the available space, pass a negative @num value.
+ */
+static inline void seq_buf_commit(struct seq_buf *s, int num)
+{
+	if (num < 0) {
+		s->len = s->size;
+	} else {
+		BUG_ON(s->len + num > s->size + 1);
+		s->len += num;
+	}
+}
+
 extern __printf(2, 3)
 int seq_buf_printf(struct seq_buf *s, const char *fmt, ...);
 extern __printf(2, 0)
diff --git a/kernel/trace/seq_buf.c b/kernel/trace/seq_buf.c
index 06fd1833e692..d118d0d6c956 100644
--- a/kernel/trace/seq_buf.c
+++ b/kernel/trace/seq_buf.c
@@ -280,8 +280,8 @@ int seq_buf_putmem_hex(struct seq_buf *s, const void *mem,
  */
 int seq_buf_path(struct seq_buf *s, const struct path *path, const char *esc)
 {
-	char *buf = s->buffer + s->len;
-	size_t size = SEQ_BUF_LEFT(s);
+	char *buf;
+	size_t size = seq_buf_get_buf(s, &buf);
 	int res = -1;
 
 	if (size) {
@@ -292,8 +292,7 @@ int seq_buf_path(struct seq_buf *s, const struct path *path, const char *esc)
 				res = end - buf;
 		}
 	}
-	if (res > 0)
-		s->len += res;
+	seq_buf_commit(s, res);
 
 	return res;
 }
-- 
2.1.1


