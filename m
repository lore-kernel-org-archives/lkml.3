Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503Ab3CDR0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 12:26:18 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2574 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758085Ab3CDR0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 12:26:17 -0500
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=S33FLR0-PXUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=MvX-L73VwkEA:10 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=jeAMEvoXDBbaFZrlGm4A:9 a=hPjdaMEvmhQA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130304172615.396123797@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 12:20:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizefan@huawei.com>
Subject: [for-next][PATCH 1/6] tracing: Add a helper function for event print functions
References: <20130304172005.362537932@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Add-a-helper-function-for-event-print-functi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizefan@huawei.com>

Move duplicate code in event print functions to a helper function.

This shrinks the size of the kernel by ~13K.

   text    data     bss     dec     hex filename
6596137 1743966 10138672        18478775        119f6b7 vmlinux.o.old
6583002 1743849 10138672        18465523        119c2f3 vmlinux.o.new

Link: http://lkml.kernel.org/r/51258746.2060304@huawei.com

Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |    8 ++++++--
 include/trace/ftrace.h       |   23 ++++++-----------------
 kernel/trace/trace_output.c  |   26 ++++++++++++++++++++++++++
 3 files changed, 38 insertions(+), 19 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index fd28c17..4d79d2d 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -38,6 +38,12 @@ const char *ftrace_print_symbols_seq_u64(struct trace_seq *p,
 const char *ftrace_print_hex_seq(struct trace_seq *p,
 				 const unsigned char *buf, int len);
 
+struct trace_iterator;
+struct trace_event;
+
+int ftrace_raw_output_prep(struct trace_iterator *iter,
+			   struct trace_event *event);
+
 /*
  * The trace entry - the most basic unit of tracing. This is what
  * is printed in the end as a single line in the trace output, such as:
@@ -95,8 +101,6 @@ enum trace_iter_flags {
 };
 
 
-struct trace_event;
-
 typedef enum print_line_t (*trace_print_func)(struct trace_iterator *iter,
 				      int flags, struct trace_event *event);
 
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index e5d140a..17a77fc 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -227,29 +227,18 @@ static notrace enum print_line_t					\
 ftrace_raw_output_##call(struct trace_iterator *iter, int flags,	\
 			 struct trace_event *trace_event)		\
 {									\
-	struct ftrace_event_call *event;				\
 	struct trace_seq *s = &iter->seq;				\
+	struct trace_seq __maybe_unused *p = &iter->tmp_seq;		\
 	struct ftrace_raw_##call *field;				\
-	struct trace_entry *entry;					\
-	struct trace_seq *p = &iter->tmp_seq;				\
 	int ret;							\
 									\
-	event = container_of(trace_event, struct ftrace_event_call,	\
-			     event);					\
-									\
-	entry = iter->ent;						\
+	field = (typeof(field))iter->ent;				\
 									\
-	if (entry->type != event->event.type) {				\
-		WARN_ON_ONCE(1);					\
-		return TRACE_TYPE_UNHANDLED;				\
-	}								\
-									\
-	field = (typeof(field))entry;					\
-									\
-	trace_seq_init(p);						\
-	ret = trace_seq_printf(s, "%s: ", event->name);			\
+	ret = ftrace_raw_output_prep(iter, trace_event);		\
 	if (ret)							\
-		ret = trace_seq_printf(s, print);			\
+		return ret;						\
+									\
+	ret = trace_seq_printf(s, print);				\
 	if (!ret)							\
 		return TRACE_TYPE_PARTIAL_LINE;				\
 									\
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 194d796..aa92ac3 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -397,6 +397,32 @@ ftrace_print_hex_seq(struct trace_seq *p, const unsigned char *buf, int buf_len)
 }
 EXPORT_SYMBOL(ftrace_print_hex_seq);
 
+int ftrace_raw_output_prep(struct trace_iterator *iter,
+			   struct trace_event *trace_event)
+{
+	struct ftrace_event_call *event;
+	struct trace_seq *s = &iter->seq;
+	struct trace_seq *p = &iter->tmp_seq;
+	struct trace_entry *entry;
+	int ret;
+
+	event = container_of(trace_event, struct ftrace_event_call, event);
+	entry = iter->ent;
+
+	if (entry->type != event->event.type) {
+		WARN_ON_ONCE(1);
+		return TRACE_TYPE_UNHANDLED;
+	}
+
+	trace_seq_init(p);
+	ret = trace_seq_printf(s, "%s: ", event->name);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	return 0;
+}
+EXPORT_SYMBOL(ftrace_raw_output_prep);
+
 #ifdef CONFIG_KRETPROBES
 static inline const char *kretprobed(const char *name)
 {
-- 
1.7.10.4


