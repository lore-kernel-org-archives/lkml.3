Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbaKOFHe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 00:07:34 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:4037 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752339AbaKOFGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 00:06:08 -0500
Message-Id: <20141115050604.230341966@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 14 Nov 2014 23:59:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 21/26 v5] tracing: Have seq_buf use full buffer
References: <20141115045847.712848224@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0021-tracing-Have-seq_buf-use-full-buffer.patch
X-RR-Connecting-IP: 107.14.168.118:25
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

Link: http://lkml.kernel.org/r/20141104160222.502133196@goodmis.org
Link: http://lkml.kernel.org/r/20141114011412.811957882@goodmis.org

Tested-by: Jiri Kosina <jkosina@suse.cz>
Acked-by: Jiri Kosina <jkosina@suse.cz>
Reviewed-by: Petr Mladek <pmladek@suse.cz>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/seq_buf.h | 6 +++---
 kernel/trace/seq_buf.c  | 9 ++++++---
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
index 93718e570d4c..0800a24b4348 100644
--- a/include/linux/seq_buf.h
+++ b/include/linux/seq_buf.h
@@ -43,13 +43,13 @@ seq_buf_init(struct seq_buf *s, unsigned char *buf, unsigned int size)
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
 
 /*
@@ -61,7 +61,7 @@ seq_buf_buffer_left(struct seq_buf *s)
 	if (seq_buf_has_overflowed(s))
 		return 0;
 
-	return (s->size - 1) - s->len;
+	return s->size - s->len;
 }
 
 /* How much buffer was written? */
diff --git a/kernel/trace/seq_buf.c b/kernel/trace/seq_buf.c
index 89d1bd5c27fe..27e48348ae67 100644
--- a/kernel/trace/seq_buf.c
+++ b/kernel/trace/seq_buf.c
@@ -18,7 +18,7 @@
 
 static bool seq_buf_can_fit(struct seq_buf *s, size_t len)
 {
-	return s->len + len < s->size;
+	return s->len + len <= s->size;
 }
 
 /**
@@ -102,8 +102,11 @@ int seq_buf_bitmask(struct seq_buf *s, const unsigned long *maskp,
 	WARN_ON(s->size == 0);
 
 	/*
-	 * The last byte of the buffer is used to determine if we
-	 * overflowed or not.
+	 * Note, because bitmap_scnprintf() only returns the number of bytes
+	 * written and not the number that would be written, we use the last
+	 * byte of the buffer to let us know if we overflowed. There's a small
+	 * chance that the bitmap could have fit exactly inside the buffer, but
+	 * it's not that critical if that does happen.
 	 */
 	if (len > 1) {
 		ret = bitmap_scnprintf(s->buffer + s->len, len, maskp, nmaskbits);
-- 
2.1.1


