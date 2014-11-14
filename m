Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964848AbaKNBOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 20:14:21 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:19028 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934664AbaKNBOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 20:14:12 -0500
Message-Id: <20141114011410.668946743@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 13 Nov 2014 20:12:48 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>
Subject: [RFC][PATCH 04/23 v4] ring-buffer: Remove check of trace_seq_{puts,printf}() return values
References: <20141114011244.256115061@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0004-ring-buffer-Remove-check-of-trace_seq_-puts-printf-r.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Remove checking the return value of all trace_seq_puts(). It was wrong
anyway as only the last return value mattered. But as the trace_seq_puts()
is going to be a void function in the future, we should not be checking
the return value of it anyway.

Just return !trace_seq_has_overflowed() instead.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c | 75 ++++++++++++++++++++++------------------------
 1 file changed, 36 insertions(+), 39 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 2d75c94ae87d..a28bdd17c853 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -34,21 +34,19 @@ static void update_pages_handler(struct work_struct *work);
  */
 int ring_buffer_print_entry_header(struct trace_seq *s)
 {
-	int ret;
-
-	ret = trace_seq_puts(s, "# compressed entry header\n");
-	ret = trace_seq_puts(s, "\ttype_len    :    5 bits\n");
-	ret = trace_seq_puts(s, "\ttime_delta  :   27 bits\n");
-	ret = trace_seq_puts(s, "\tarray       :   32 bits\n");
-	ret = trace_seq_putc(s, '\n');
-	ret = trace_seq_printf(s, "\tpadding     : type == %d\n",
-			       RINGBUF_TYPE_PADDING);
-	ret = trace_seq_printf(s, "\ttime_extend : type == %d\n",
-			       RINGBUF_TYPE_TIME_EXTEND);
-	ret = trace_seq_printf(s, "\tdata max type_len  == %d\n",
-			       RINGBUF_TYPE_DATA_TYPE_LEN_MAX);
+	trace_seq_puts(s, "# compressed entry header\n");
+	trace_seq_puts(s, "\ttype_len    :    5 bits\n");
+	trace_seq_puts(s, "\ttime_delta  :   27 bits\n");
+	trace_seq_puts(s, "\tarray       :   32 bits\n");
+	trace_seq_putc(s, '\n');
+	trace_seq_printf(s, "\tpadding     : type == %d\n",
+			 RINGBUF_TYPE_PADDING);
+	trace_seq_printf(s, "\ttime_extend : type == %d\n",
+			 RINGBUF_TYPE_TIME_EXTEND);
+	trace_seq_printf(s, "\tdata max type_len  == %d\n",
+			 RINGBUF_TYPE_DATA_TYPE_LEN_MAX);
 
-	return ret;
+	return !trace_seq_has_overflowed(s);
 }
 
 /*
@@ -419,32 +417,31 @@ static inline int test_time_stamp(u64 delta)
 int ring_buffer_print_page_header(struct trace_seq *s)
 {
 	struct buffer_data_page field;
-	int ret;
-
-	ret = trace_seq_printf(s, "\tfield: u64 timestamp;\t"
-			       "offset:0;\tsize:%u;\tsigned:%u;\n",
-			       (unsigned int)sizeof(field.time_stamp),
-			       (unsigned int)is_signed_type(u64));
-
-	ret = trace_seq_printf(s, "\tfield: local_t commit;\t"
-			       "offset:%u;\tsize:%u;\tsigned:%u;\n",
-			       (unsigned int)offsetof(typeof(field), commit),
-			       (unsigned int)sizeof(field.commit),
-			       (unsigned int)is_signed_type(long));
-
-	ret = trace_seq_printf(s, "\tfield: int overwrite;\t"
-			       "offset:%u;\tsize:%u;\tsigned:%u;\n",
-			       (unsigned int)offsetof(typeof(field), commit),
-			       1,
-			       (unsigned int)is_signed_type(long));
-
-	ret = trace_seq_printf(s, "\tfield: char data;\t"
-			       "offset:%u;\tsize:%u;\tsigned:%u;\n",
-			       (unsigned int)offsetof(typeof(field), data),
-			       (unsigned int)BUF_PAGE_SIZE,
-			       (unsigned int)is_signed_type(char));
 
-	return ret;
+	trace_seq_printf(s, "\tfield: u64 timestamp;\t"
+			 "offset:0;\tsize:%u;\tsigned:%u;\n",
+			 (unsigned int)sizeof(field.time_stamp),
+			 (unsigned int)is_signed_type(u64));
+
+	trace_seq_printf(s, "\tfield: local_t commit;\t"
+			 "offset:%u;\tsize:%u;\tsigned:%u;\n",
+			 (unsigned int)offsetof(typeof(field), commit),
+			 (unsigned int)sizeof(field.commit),
+			 (unsigned int)is_signed_type(long));
+
+	trace_seq_printf(s, "\tfield: int overwrite;\t"
+			 "offset:%u;\tsize:%u;\tsigned:%u;\n",
+			 (unsigned int)offsetof(typeof(field), commit),
+			 1,
+			 (unsigned int)is_signed_type(long));
+
+	trace_seq_printf(s, "\tfield: char data;\t"
+			 "offset:%u;\tsize:%u;\tsigned:%u;\n",
+			 (unsigned int)offsetof(typeof(field), data),
+			 (unsigned int)BUF_PAGE_SIZE,
+			 (unsigned int)is_signed_type(char));
+
+	return !trace_seq_has_overflowed(s);
 }
 
 struct rb_irq_work {
-- 
2.1.1


