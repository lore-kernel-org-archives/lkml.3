Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbaKGSjc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 13:39:32 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:13823 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753092AbaKGSjb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 13:39:31 -0500
Date: Fri, 7 Nov 2014 13:39:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 08/12 v3] tracing: Add seq_buf_get_buf() and
 seq_buf_commit() helper functions
Message-ID: <20141107133929.7aa1dfe9@gandalf.local.home>
In-Reply-To: <20141105165125.GJ4570@pathway.suse.cz>
References: <20141104155237.228431433@goodmis.org>
	<20141104160222.644881406@goodmis.org>
	<20141105165125.GJ4570@pathway.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More updates. Hmm, maybe I should have posted the full series ;-)

-- Steve

>From 41a3f3f5e772ca26ef4441a0312d3f108693d7dc Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Date: Wed, 29 Oct 2014 17:30:50 -0400
Subject: [PATCH] tracing: Add seq_buf_get_buf() and seq_buf_commit() helper
 functions

Add two helper functions; seq_buf_get_buf() and seq_buf_commit() that
are used by seq_buf_path(). This makes the code similar to the
seq_file: seq_path() function, and will help to be able to consolidate
the functions between seq_file and trace_seq.

Link: http://lkml.kernel.org/r/20141104160222.644881406@goodmis.org

Tested-by: Jiri Kosina <jkosina@suse.cz>
Acked-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/seq_buf.h | 40 ++++++++++++++++++++++++++++++++++++++++
 kernel/trace/seq_buf.c  |  7 +++----
 2 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
index 4aab47d10760..7dacdc791225 100644
--- a/include/linux/seq_buf.h
+++ b/include/linux/seq_buf.h
@@ -61,6 +61,46 @@ seq_buf_buffer_left(struct seq_buf *s)
 	return s->size - s->len;
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
+		seq_buf_set_overflow(s);
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
index 8e60b5c1b9f3..25090f81ea8a 100644
--- a/kernel/trace/seq_buf.c
+++ b/kernel/trace/seq_buf.c
@@ -283,8 +283,8 @@ int seq_buf_putmem_hex(struct seq_buf *s, const void *mem,
  */
 int seq_buf_path(struct seq_buf *s, const struct path *path, const char *esc)
 {
-	char *buf = s->buffer + s->len;
-	size_t size = seq_buf_buffer_left(s);
+	char *buf;
+	size_t size = seq_buf_get_buf(s, &buf);
 	int res = -1;
 
 	WARN_ON(s->size == 0);
@@ -297,8 +297,7 @@ int seq_buf_path(struct seq_buf *s, const struct path *path, const char *esc)
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

