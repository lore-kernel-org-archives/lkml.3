Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbaKOFHo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 00:07:44 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:15523 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752058AbaKOFGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 00:06:07 -0500
Message-Id: <20141115050604.073390701@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 14 Nov 2014 23:59:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 20/26 v5] seq_buf: Add seq_buf_can_fit() helper function
References: <20141115045847.712848224@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0020-seq_buf-Add-seq_buf_can_fit-helper-function.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Add a seq_buf_can_fit() helper function that removes the possible mistakes
of comparing the seq_buf length plus added data compared to the size of
the buffer.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/seq_buf.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/seq_buf.c b/kernel/trace/seq_buf.c
index ce17f65268ed..89d1bd5c27fe 100644
--- a/kernel/trace/seq_buf.c
+++ b/kernel/trace/seq_buf.c
@@ -16,6 +16,11 @@
 #include <linux/seq_file.h>
 #include <linux/seq_buf.h>
 
+static bool seq_buf_can_fit(struct seq_buf *s, size_t len)
+{
+	return s->len + len < s->size;
+}
+
 /**
  * seq_buf_print_seq - move the contents of seq_buf into a seq_file
  * @m: the seq_file descriptor that is the destination
@@ -48,7 +53,7 @@ int seq_buf_vprintf(struct seq_buf *s, const char *fmt, va_list args)
 
 	if (s->len < s->size) {
 		len = vsnprintf(s->buffer + s->len, s->size - s->len, fmt, args);
-		if (s->len + len < s->size) {
+		if (seq_buf_can_fit(s, len)) {
 			s->len += len;
 			return 0;
 		}
@@ -137,7 +142,7 @@ int seq_buf_bprintf(struct seq_buf *s, const char *fmt, const u32 *binary)
 
 	if (s->len < s->size) {
 		ret = bstr_printf(s->buffer + s->len, len, fmt, binary);
-		if (s->len + ret < s->size) {
+		if (seq_buf_can_fit(s, ret)) {
 			s->len += ret;
 			return 0;
 		}
@@ -161,7 +166,7 @@ int seq_buf_puts(struct seq_buf *s, const char *str)
 
 	WARN_ON(s->size == 0);
 
-	if (s->len + len < s->size) {
+	if (seq_buf_can_fit(s, len)) {
 		memcpy(s->buffer + s->len, str, len);
 		s->len += len;
 		return 0;
@@ -183,7 +188,7 @@ int seq_buf_putc(struct seq_buf *s, unsigned char c)
 {
 	WARN_ON(s->size == 0);
 
-	if (s->len + 1 < s->size) {
+	if (seq_buf_can_fit(s, 1)) {
 		s->buffer[s->len++] = c;
 		return 0;
 	}
@@ -207,7 +212,7 @@ int seq_buf_putmem(struct seq_buf *s, const void *mem, unsigned int len)
 {
 	WARN_ON(s->size == 0);
 
-	if (s->len + len < s->size) {
+	if (seq_buf_can_fit(s, len)) {
 		memcpy(s->buffer + s->len, mem, len);
 		s->len += len;
 		return 0;
-- 
2.1.1


