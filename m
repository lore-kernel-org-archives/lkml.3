Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbaKGShc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 13:37:32 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:48008 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751569AbaKGShb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 13:37:31 -0500
Date: Fri, 7 Nov 2014 13:37:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 07/12 v3] tracing: Have seq_buf use full buffer
Message-ID: <20141107133729.503c9b5d@gandalf.local.home>
In-Reply-To: <20141107091107.GA1136@dhcp128.suse.cz>
References: <20141104155237.228431433@goodmis.org>
	<20141104160222.502133196@goodmis.org>
	<20141105163150.GI4570@pathway.suse.cz>
	<20141105152130.09779ccf@gandalf.local.home>
	<20141105160618.6c684f23@gandalf.local.home>
	<20141106153107.GH2001@dhcp128.suse.cz>
	<20141106142402.0daada65@gandalf.local.home>
	<20141107091107.GA1136@dhcp128.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some more touch ups.

-- Steve

>From 7e724556c21178a9890b31ff57f69761b41f435a Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Date: Wed, 29 Oct 2014 15:26:09 -0400
Subject: [PATCH] tracing: Have seq_buf use full buffer

Currently seq_buf is full when all but one byte of the buffer is
filled. Change it so that the seq_buf is full when all of the
buffer is filled.

Some of the functions would fill the buffer completely and report
everything was fine. This was inconsistent with the max of size - 1.
Changing this to be max of size makes all functions consistent.

Link: http://lkml.kernel.org/r/20141104160222.502133196@goodmis.org

Tested-by: Jiri Kosina <jkosina@suse.cz>
Acked-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/seq_buf.h |  6 +++---
 kernel/trace/seq_buf.c  | 19 +++++++++++--------
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
index f68fde850ef7..4aab47d10760 100644
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
@@ -58,7 +58,7 @@ seq_buf_set_overflow(struct seq_buf *s)
 static inline unsigned int
 seq_buf_buffer_left(struct seq_buf *s)
 {
-	return (s->size - 1) - s->len;
+	return s->size - s->len;
 }
 
 extern __printf(2, 3)
diff --git a/kernel/trace/seq_buf.c b/kernel/trace/seq_buf.c
index ac6eb864c946..8e60b5c1b9f3 100644
--- a/kernel/trace/seq_buf.c
+++ b/kernel/trace/seq_buf.c
@@ -17,7 +17,7 @@
 #include <linux/seq_buf.h>
 
 /* How much buffer is written? */
-#define SEQ_BUF_USED(s) min((s)->len, (s)->size - 1)
+#define SEQ_BUF_USED(s) min((s)->len, (s)->size)
 
 /**
  * seq_buf_print_seq - move the contents of seq_buf into a seq_file
@@ -51,7 +51,7 @@ int seq_buf_vprintf(struct seq_buf *s, const char *fmt, va_list args)
 
 	if (s->len < s->size) {
 		len = vsnprintf(s->buffer + s->len, s->size - s->len, fmt, args);
-		if (s->len + len < s->size) {
+		if (s->len + len <= s->size) {
 			s->len += len;
 			return 0;
 		}
@@ -100,8 +100,11 @@ int seq_buf_bitmask(struct seq_buf *s, const unsigned long *maskp,
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
 		ret = bitmap_scnprintf(s->buffer, len, maskp, nmaskbits);
@@ -140,7 +143,7 @@ int seq_buf_bprintf(struct seq_buf *s, const char *fmt, const u32 *binary)
 
 	if (s->len < s->size) {
 		ret = bstr_printf(s->buffer + s->len, len, fmt, binary);
-		if (s->len + ret < s->size) {
+		if (s->len + ret <= s->size) {
 			s->len += ret;
 			return 0;
 		}
@@ -164,7 +167,7 @@ int seq_buf_puts(struct seq_buf *s, const char *str)
 
 	WARN_ON(s->size == 0);
 
-	if (s->len + len < s->size) {
+	if (s->len + len <= s->size) {
 		memcpy(s->buffer + s->len, str, len);
 		s->len += len;
 		return 0;
@@ -186,7 +189,7 @@ int seq_buf_putc(struct seq_buf *s, unsigned char c)
 {
 	WARN_ON(s->size == 0);
 
-	if (s->len + 1 < s->size) {
+	if (s->len + 1 <= s->size) {
 		s->buffer[s->len++] = c;
 		return 0;
 	}
@@ -210,7 +213,7 @@ int seq_buf_putmem(struct seq_buf *s, const void *mem, unsigned int len)
 {
 	WARN_ON(s->size == 0);
 
-	if (s->len + len < s->size) {
+	if (s->len + len <= s->size) {
 		memcpy(s->buffer + s->len, mem, len);
 		s->len += len;
 		return 0;
-- 
2.1.1

