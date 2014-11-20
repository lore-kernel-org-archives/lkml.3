Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517AbaKTP1i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 10:27:38 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:42635 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757359AbaKTP1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 10:27:19 -0500
Message-Id: <20141120152716.428445719@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 20 Nov 2014 10:21:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>
Subject: [for-next][PATCH 05/15] seq_buf: Create seq_buf_used() to find out how much was written
References: <20141120152120.168868031@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0005-seq_buf-Create-seq_buf_used-to-find-out-how-much-was.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Add a helper function seq_buf_used() that replaces the SEQ_BUF_USED()
private macro to let callers have a method to know how much of the
seq_buf was written to.

Link: http://lkml.kernel.org/r/20141114011412.170377300@goodmis.org
Link: http://lkml.kernel.org/r/20141114011413.321654244@goodmis.org

Reviewed-by: Petr Mladek <pmladek@suse.cz>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/seq_buf.h | 6 ++++++
 kernel/trace/seq_buf.c  | 5 +----
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
index 5d91262433e2..93718e570d4c 100644
--- a/include/linux/seq_buf.h
+++ b/include/linux/seq_buf.h
@@ -64,6 +64,12 @@ seq_buf_buffer_left(struct seq_buf *s)
 	return (s->size - 1) - s->len;
 }
 
+/* How much buffer was written? */
+static inline unsigned int seq_buf_used(struct seq_buf *s)
+{
+	return min(s->len, s->size);
+}
+
 extern __printf(2, 3)
 int seq_buf_printf(struct seq_buf *s, const char *fmt, ...);
 extern __printf(2, 0)
diff --git a/kernel/trace/seq_buf.c b/kernel/trace/seq_buf.c
index 7dac34d1235b..9ec5305d9da7 100644
--- a/kernel/trace/seq_buf.c
+++ b/kernel/trace/seq_buf.c
@@ -16,9 +16,6 @@
 #include <linux/seq_file.h>
 #include <linux/seq_buf.h>
 
-/* How much buffer is written? */
-#define SEQ_BUF_USED(s) min((s)->len, (s)->size - 1)
-
 /**
  * seq_buf_print_seq - move the contents of seq_buf into a seq_file
  * @m: the seq_file descriptor that is the destination
@@ -28,7 +25,7 @@
  */
 int seq_buf_print_seq(struct seq_file *m, struct seq_buf *s)
 {
-	unsigned int len = SEQ_BUF_USED(s);
+	unsigned int len = seq_buf_used(s);
 
 	return seq_write(m, s->buffer, len);
 }
-- 
2.1.1


