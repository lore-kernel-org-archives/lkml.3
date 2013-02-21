Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab3BUCd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 21:33:26 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:64304 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab3BUCdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 21:33:24 -0500
Message-ID: <51258746.2060304@huawei.com>
Date: Thu, 21 Feb 2013 10:32:38 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] tracing: Add a helper function for event print functions
References: <51258723.2040301@huawei.com>
In-Reply-To: <51258723.2040301@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move duplicate code in event print functions to a helper function.

This shrinks the size of the kernel by ~13K.

   text    data     bss     dec     hex filename
6596137 1743966 10138672        18478775        119f6b7 vmlinux.o.old
6583002 1743849 10138672        18465523        119c2f3 vmlinux.o.new

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 include/linux/ftrace_event.h |  8 ++++++--
 include/trace/ftrace.h       | 23 ++++++-----------------
 kernel/trace/trace_output.c  | 26 ++++++++++++++++++++++++++
 3 files changed, 38 insertions(+), 19 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index a3d4895..d54d458 100644
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
@@ -93,8 +99,6 @@ enum trace_iter_flags {
 };
 
 
-struct trace_event;
-
 typedef enum print_line_t (*trace_print_func)(struct trace_iterator *iter,
 				      int flags, struct trace_event *event);
 
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 40dc5e8..20b6005 100644
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
1.8.0.2
