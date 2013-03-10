Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab3CJPgD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 11:36:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14857 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab3CJPfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 11:35:32 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=3XYl7qO_xwMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=SG76jnFvL-8A:10 a=pGLkceISAAAA:8 a=S9BDfPDtfzxGG8gqhLYA:9 a=jeBq3FmKZ4MA:10 a=Zh68SRI7RUMA:10 a=MSl-tDqOz04A:10 a=Od36uVEnx13KFueC:21 a=ZJtQUacX_ndvyT_S:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130310153527.331188960@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sun, 10 Mar 2013 11:27:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [for-next][PATCH 1/4] tracing: Add trace_puts() for even faster trace_printk() tracing
References: <20130310152752.848922120@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Add-trace_puts-for-even-faster-trace_printk-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The trace_printk() is extremely fast and is very handy as it can be
used in any context (including NMIs!). But it still requires scanning
the fmt string for parsing the args. Even the trace_bprintk() requires
a scan to know what args will be saved, although it doesn't copy the
format string itself.

Several times trace_printk() has no args, and wastes cpu cycles scanning
the fmt string.

Adding trace_puts() allows the developer to use an even faster
tracing method that only saves the pointer to the string in the
ring buffer without doing any format parsing at all. This will
help remove even more of the "Heisenbug" effect, when debugging.

Also fixed up the F_printk()s for the ftrace internal bprint and print events.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/kernel.h       |   41 ++++++++++++++++++++++-
 kernel/trace/trace.c         |   76 ++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace.h         |    2 ++
 kernel/trace/trace_entries.h |   23 ++++++++++---
 kernel/trace/trace_output.c  |   75 +++++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace_output.h  |    2 ++
 6 files changed, 214 insertions(+), 5 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index bc5392a..a3a5574 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -514,7 +514,8 @@ do {									\
  *
  * This is intended as a debugging tool for the developer only.
  * Please refrain from leaving trace_printks scattered around in
- * your code.
+ * your code. (Extra memory is used for special buffers that are
+ * allocated when trace_printk() is used)
  */
 
 #define trace_printk(fmt, args...)					\
@@ -537,6 +538,44 @@ int __trace_bprintk(unsigned long ip, const char *fmt, ...);
 extern __printf(2, 3)
 int __trace_printk(unsigned long ip, const char *fmt, ...);
 
+/**
+ * trace_puts - write a string into the ftrace buffer
+ * @str: the string to record
+ *
+ * Note: __trace_bputs is an internal function for trace_puts and
+ *       the @ip is passed in via the trace_puts macro.
+ *
+ * This is similar to trace_printk() but is made for those really fast
+ * paths that a developer wants the least amount of "Heisenbug" affects,
+ * where the processing of the print format is still too much.
+ *
+ * This function allows a kernel developer to debug fast path sections
+ * that printk is not appropriate for. By scattering in various
+ * printk like tracing in the code, a developer can quickly see
+ * where problems are occurring.
+ *
+ * This is intended as a debugging tool for the developer only.
+ * Please refrain from leaving trace_puts scattered around in
+ * your code. (Extra memory is used for special buffers that are
+ * allocated when trace_puts() is used)
+ *
+ * Returns: 0 if nothing was written, positive # if string was.
+ *  (1 when __trace_bputs is used, strlen(str) when __trace_puts is used)
+ */
+
+extern int __trace_bputs(unsigned long ip, const char *str);
+extern int __trace_puts(unsigned long ip, const char *str, int size);
+#define trace_puts(str) ({						\
+	static const char *trace_printk_fmt				\
+		__attribute__((section("__trace_printk_fmt"))) =	\
+		__builtin_constant_p(str) ? str : NULL;			\
+									\
+	if (__builtin_constant_p(str))					\
+		__trace_bputs(_THIS_IP_, trace_printk_fmt);		\
+	else								\
+		__trace_puts(_THIS_IP_, str, strlen(str));		\
+})
+
 extern void trace_dump_stack(void);
 
 /*
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 02064f8..1b9a791 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -350,6 +350,77 @@ void tracing_on(void)
 }
 EXPORT_SYMBOL_GPL(tracing_on);
 
+/**
+ * __trace_puts - write a constant string into the trace buffer.
+ * @ip:	   The address of the caller
+ * @str:   The constant string to write
+ * @size:  The size of the string.
+ */
+int __trace_puts(unsigned long ip, const char *str, int size)
+{
+	struct ring_buffer_event *event;
+	struct ring_buffer *buffer;
+	struct print_entry *entry;
+	unsigned long irq_flags;
+	int alloc;
+
+	alloc = sizeof(*entry) + size + 2; /* possible \n added */
+
+	local_save_flags(irq_flags);
+	buffer = global_trace.trace_buffer.buffer;
+	event = trace_buffer_lock_reserve(buffer, TRACE_PRINT, alloc, 
+					  irq_flags, preempt_count());
+	if (!event)
+		return 0;
+
+	entry = ring_buffer_event_data(event);
+	entry->ip = ip;
+
+	memcpy(&entry->buf, str, size);
+
+	/* Add a newline if necessary */
+	if (entry->buf[size - 1] != '\n') {
+		entry->buf[size] = '\n';
+		entry->buf[size + 1] = '\0';
+	} else
+		entry->buf[size] = '\0';
+
+	__buffer_unlock_commit(buffer, event);
+
+	return size;
+}
+EXPORT_SYMBOL_GPL(__trace_puts);
+
+/**
+ * __trace_bputs - write the pointer to a constant string into trace buffer
+ * @ip:	   The address of the caller
+ * @str:   The constant string to write to the buffer to
+ */
+int __trace_bputs(unsigned long ip, const char *str)
+{
+	struct ring_buffer_event *event;
+	struct ring_buffer *buffer;
+	struct bputs_entry *entry;
+	unsigned long irq_flags;
+	int size = sizeof(struct bputs_entry);
+
+	local_save_flags(irq_flags);
+	buffer = global_trace.trace_buffer.buffer;
+	event = trace_buffer_lock_reserve(buffer, TRACE_BPUTS, size,
+					  irq_flags, preempt_count());
+	if (!event)
+		return 0;
+
+	entry = ring_buffer_event_data(event);
+	entry->ip			= ip;
+	entry->str			= str;
+
+	__buffer_unlock_commit(buffer, event);
+
+	return 1;
+}
+EXPORT_SYMBOL_GPL(__trace_bputs);
+
 #ifdef CONFIG_TRACER_SNAPSHOT
 /**
  * trace_snapshot - take a snapshot of the current buffer.
@@ -2474,6 +2545,11 @@ enum print_line_t print_trace_line(struct trace_iterator *iter)
 			return ret;
 	}
 
+	if (iter->ent->type == TRACE_BPUTS &&
+			trace_flags & TRACE_ITER_PRINTK &&
+			trace_flags & TRACE_ITER_PRINTK_MSGONLY)
+		return trace_print_bputs_msg_only(iter);
+
 	if (iter->ent->type == TRACE_BPRINT &&
 			trace_flags & TRACE_ITER_PRINTK &&
 			trace_flags & TRACE_ITER_PRINTK_MSGONLY)
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 0b7f424..98dd79d 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -34,6 +34,7 @@ enum trace_type {
 	TRACE_GRAPH_ENT,
 	TRACE_USER_STACK,
 	TRACE_BLK,
+	TRACE_BPUTS,
 
 	__TRACE_LAST_TYPE,
 };
@@ -277,6 +278,7 @@ extern void __ftrace_bad_type(void);
 		IF_ASSIGN(var, ent, struct userstack_entry, TRACE_USER_STACK);\
 		IF_ASSIGN(var, ent, struct print_entry, TRACE_PRINT);	\
 		IF_ASSIGN(var, ent, struct bprint_entry, TRACE_BPRINT);	\
+		IF_ASSIGN(var, ent, struct bputs_entry, TRACE_BPUTS);	\
 		IF_ASSIGN(var, ent, struct trace_mmiotrace_rw,		\
 			  TRACE_MMIO_RW);				\
 		IF_ASSIGN(var, ent, struct trace_mmiotrace_map,		\
diff --git a/kernel/trace/trace_entries.h b/kernel/trace/trace_entries.h
index 4108e12..e2d027a 100644
--- a/kernel/trace/trace_entries.h
+++ b/kernel/trace/trace_entries.h
@@ -223,8 +223,8 @@ FTRACE_ENTRY(bprint, bprint_entry,
 		__dynamic_array(	u32,	buf	)
 	),
 
-	F_printk("%08lx fmt:%p",
-		 __entry->ip, __entry->fmt),
+	F_printk("%pf: %s",
+		 (void *)__entry->ip, __entry->fmt),
 
 	FILTER_OTHER
 );
@@ -238,8 +238,23 @@ FTRACE_ENTRY(print, print_entry,
 		__dynamic_array(	char,	buf	)
 	),
 
-	F_printk("%08lx %s",
-		 __entry->ip, __entry->buf),
+	F_printk("%pf: %s",
+		 (void *)__entry->ip, __entry->buf),
+
+	FILTER_OTHER
+);
+
+FTRACE_ENTRY(bputs, bputs_entry,
+
+	TRACE_BPUTS,
+
+	F_STRUCT(
+		__field(	unsigned long,	ip	)
+		__field(	const char *,	str	)
+	),
+
+	F_printk("%pf: %s",
+		 (void *)__entry->ip, __entry->str),
 
 	FILTER_OTHER
 );
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 2edc722..19f48e7 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -37,6 +37,22 @@ int trace_print_seq(struct seq_file *m, struct trace_seq *s)
 	return ret;
 }
 
+enum print_line_t trace_print_bputs_msg_only(struct trace_iterator *iter)
+{
+	struct trace_seq *s = &iter->seq;
+	struct trace_entry *entry = iter->ent;
+	struct bputs_entry *field;
+	int ret;
+
+	trace_assign_type(field, entry);
+
+	ret = trace_seq_puts(s, field->str);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	return TRACE_TYPE_HANDLED;
+}
+
 enum print_line_t trace_print_bprintk_msg_only(struct trace_iterator *iter)
 {
 	struct trace_seq *s = &iter->seq;
@@ -1244,6 +1260,64 @@ static struct trace_event trace_user_stack_event = {
 	.funcs		= &trace_user_stack_funcs,
 };
 
+/* TRACE_BPUTS */
+static enum print_line_t
+trace_bputs_print(struct trace_iterator *iter, int flags,
+		   struct trace_event *event)
+{
+	struct trace_entry *entry = iter->ent;
+	struct trace_seq *s = &iter->seq;
+	struct bputs_entry *field;
+
+	trace_assign_type(field, entry);
+
+	if (!seq_print_ip_sym(s, field->ip, flags))
+		goto partial;
+
+	if (!trace_seq_puts(s, ": "))
+		goto partial;
+
+	if (!trace_seq_puts(s, field->str))
+		goto partial;
+
+	return TRACE_TYPE_HANDLED;
+
+ partial:
+	return TRACE_TYPE_PARTIAL_LINE;
+}
+
+
+static enum print_line_t
+trace_bputs_raw(struct trace_iterator *iter, int flags,
+		struct trace_event *event)
+{
+	struct bputs_entry *field;
+	struct trace_seq *s = &iter->seq;
+
+	trace_assign_type(field, iter->ent);
+
+	if (!trace_seq_printf(s, ": %lx : ", field->ip))
+		goto partial;
+
+	if (!trace_seq_puts(s, field->str))
+		goto partial;
+
+	return TRACE_TYPE_HANDLED;
+
+ partial:
+	return TRACE_TYPE_PARTIAL_LINE;
+}
+
+static struct trace_event_functions trace_bputs_funcs = {
+	.trace		= trace_bputs_print,
+	.raw		= trace_bputs_raw,
+};
+
+static struct trace_event trace_bputs_event = {
+	.type		= TRACE_BPUTS,
+	.funcs		= &trace_bputs_funcs,
+};
+
 /* TRACE_BPRINT */
 static enum print_line_t
 trace_bprint_print(struct trace_iterator *iter, int flags,
@@ -1356,6 +1430,7 @@ static struct trace_event *events[] __initdata = {
 	&trace_wake_event,
 	&trace_stack_event,
 	&trace_user_stack_event,
+	&trace_bputs_event,
 	&trace_bprint_event,
 	&trace_print_event,
 	NULL
diff --git a/kernel/trace/trace_output.h b/kernel/trace/trace_output.h
index c038eba..af77870 100644
--- a/kernel/trace/trace_output.h
+++ b/kernel/trace/trace_output.h
@@ -5,6 +5,8 @@
 #include "trace.h"
 
 extern enum print_line_t
+trace_print_bputs_msg_only(struct trace_iterator *iter);
+extern enum print_line_t
 trace_print_bprintk_msg_only(struct trace_iterator *iter);
 extern enum print_line_t
 trace_print_printk_msg_only(struct trace_iterator *iter);
-- 
1.7.10.4


