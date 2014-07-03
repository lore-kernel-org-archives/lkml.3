Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030269AbaGCQSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:18:21 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:3745 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759155AbaGCQM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:12:27 -0400
Message-Id: <20140703161225.192042202@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 03 Jul 2014 12:05:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 10/21] tracing: Make trace_seq_putmem_hex() more robust
References: <20140703160503.006976702@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0010-tracing-Make-trace_seq_putmem_hex-more-robust.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Currently trace_seq_putmem_hex() can only take as a parameter a pointer
to something that is 8 bytes or less, otherwise it will overflow the
buffer. This is protected by a macro that encompasses the call to
trace_seq_putmem_hex() that has a BUILD_BUG_ON() for the variable before
it is passed in. This is not very robust and if trace_seq_putmem_hex() ever
gets used outside that macro it will cause issues.

Instead of only being able to produce a hex output of memory that is for
a single word, change it to be more robust and allow any size input.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/trace_seq.h   |  2 --
 kernel/trace/trace_output.h |  1 -
 kernel/trace/trace_seq.c    | 26 +++++++++++++++++++-------
 3 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
index 1f05317f51c4..8283762ab7ef 100644
--- a/include/linux/trace_seq.h
+++ b/include/linux/trace_seq.h
@@ -25,8 +25,6 @@ trace_seq_init(struct trace_seq *s)
 	s->full = 0;
 }
 
-#define MAX_MEMHEX_BYTES	8
-
 /*
  * Currently only defined when tracing is enabled.
  */
diff --git a/kernel/trace/trace_output.h b/kernel/trace/trace_output.h
index bf7daf2237ed..80b25b585a70 100644
--- a/kernel/trace/trace_output.h
+++ b/kernel/trace/trace_output.h
@@ -43,7 +43,6 @@ do {							\
 
 #define SEQ_PUT_HEX_FIELD_RET(s, x)			\
 do {							\
-	BUILD_BUG_ON(sizeof(x) > MAX_MEMHEX_BYTES);	\
 	if (!trace_seq_putmem_hex(s, &(x), sizeof(x)))	\
 		return TRACE_TYPE_PARTIAL_LINE;		\
 } while (0)
diff --git a/kernel/trace/trace_seq.c b/kernel/trace/trace_seq.c
index 0fabca773e51..88c0f80f0a1f 100644
--- a/kernel/trace/trace_seq.c
+++ b/kernel/trace/trace_seq.c
@@ -291,6 +291,7 @@ int trace_seq_putmem(struct trace_seq *s, const void *mem, unsigned int len)
 }
 EXPORT_SYMBOL_GPL(trace_seq_putmem);
 
+#define MAX_MEMHEX_BYTES	8U
 #define HEX_CHARS		(MAX_MEMHEX_BYTES*2 + 1)
 
 /**
@@ -310,22 +311,33 @@ int trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
 {
 	unsigned char hex[HEX_CHARS];
 	const unsigned char *data = mem;
+	unsigned int start_len;
 	int i, j;
+	int cnt = 0;
 
 	if (s->full)
 		return 0;
 
+	while (len) {
+		start_len = min(len, HEX_CHARS - 1);
 #ifdef __BIG_ENDIAN
-	for (i = 0, j = 0; i < len; i++) {
+		for (i = 0, j = 0; i < start_len; i++) {
 #else
-	for (i = len-1, j = 0; i >= 0; i--) {
+		for (i = start_len-1, j = 0; i >= 0; i--) {
 #endif
-		hex[j++] = hex_asc_hi(data[i]);
-		hex[j++] = hex_asc_lo(data[i]);
-	}
-	hex[j++] = ' ';
+			hex[j++] = hex_asc_hi(data[i]);
+			hex[j++] = hex_asc_lo(data[i]);
+		}
+		if (WARN_ON_ONCE(j == 0 || j/2 > len))
+			break;
+
+		/* j increments twice per loop */
+		len -= j / 2;
+		hex[j++] = ' ';
 
-	return trace_seq_putmem(s, hex, j);
+		cnt += trace_seq_putmem(s, hex, j);
+	}
+	return cnt;
 }
 EXPORT_SYMBOL_GPL(trace_seq_putmem_hex);
 
-- 
2.0.0


