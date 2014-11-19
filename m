Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933145AbaKSX2q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:28:46 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:10043 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756924AbaKSX1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:27:14 -0500
Message-Id: <20141119232711.288518275@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 19 Nov 2014 18:26:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Petr Mladek <pmladek@suse.cz>
Subject: [for-next][PATCH 11/18] tracing: Have function_graph use trace_seq_has_overflowed()
References: <20141119232632.737569526@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0011-tracing-Have-function_graph-use-trace_seq_has_overfl.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Instead of doing individual checks all over the place that makes the code
very messy. Just check trace_seq_has_overflowed() at the end or in
strategic places.

This makes the code much cleaner and also helps with getting closer
to removing the return values of trace_seq_printf() and friends.

Link: http://lkml.kernel.org/r/20141114011410.987913836@goodmis.org

Reviewed-by: Petr Mladek <pmladek@suse.cz>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h                 |   2 +-
 kernel/trace/trace_functions_graph.c | 382 +++++++++++------------------------
 2 files changed, 118 insertions(+), 266 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 19418221b302..c3a37e55ec8b 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -726,7 +726,7 @@ extern unsigned long trace_flags;
 extern enum print_line_t
 print_graph_function_flags(struct trace_iterator *iter, u32 flags);
 extern void print_graph_headers_flags(struct seq_file *s, u32 flags);
-extern enum print_line_t
+extern void
 trace_print_graph_duration(unsigned long long duration, struct trace_seq *s);
 extern void graph_trace_open(struct trace_iterator *iter);
 extern void graph_trace_close(struct trace_iterator *iter);
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 55bdf9d7f714..100288d10e1f 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -107,7 +107,7 @@ enum {
 	FLAGS_FILL_END   = 3 << TRACE_GRAPH_PRINT_FILL_SHIFT,
 };
 
-static enum print_line_t
+static void
 print_graph_duration(unsigned long long duration, struct trace_seq *s,
 		     u32 flags);
 
@@ -483,33 +483,24 @@ static int graph_trace_update_thresh(struct trace_array *tr)
 
 static int max_bytes_for_cpu;
 
-static enum print_line_t
-print_graph_cpu(struct trace_seq *s, int cpu)
+static void print_graph_cpu(struct trace_seq *s, int cpu)
 {
-	int ret;
-
 	/*
 	 * Start with a space character - to make it stand out
 	 * to the right a bit when trace output is pasted into
 	 * email:
 	 */
-	ret = trace_seq_printf(s, " %*d) ", max_bytes_for_cpu, cpu);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	return TRACE_TYPE_HANDLED;
+	trace_seq_printf(s, " %*d) ", max_bytes_for_cpu, cpu);
 }
 
 #define TRACE_GRAPH_PROCINFO_LENGTH	14
 
-static enum print_line_t
-print_graph_proc(struct trace_seq *s, pid_t pid)
+static void print_graph_proc(struct trace_seq *s, pid_t pid)
 {
 	char comm[TASK_COMM_LEN];
 	/* sign + log10(MAX_INT) + '\0' */
 	char pid_str[11];
 	int spaces = 0;
-	int ret;
 	int len;
 	int i;
 
@@ -524,56 +515,43 @@ print_graph_proc(struct trace_seq *s, pid_t pid)
 		spaces = TRACE_GRAPH_PROCINFO_LENGTH - len;
 
 	/* First spaces to align center */
-	for (i = 0; i < spaces / 2; i++) {
-		ret = trace_seq_putc(s, ' ');
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
+	for (i = 0; i < spaces / 2; i++)
+		trace_seq_putc(s, ' ');
 
-	ret = trace_seq_printf(s, "%s-%s", comm, pid_str);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	trace_seq_printf(s, "%s-%s", comm, pid_str);
 
 	/* Last spaces to align center */
-	for (i = 0; i < spaces - (spaces / 2); i++) {
-		ret = trace_seq_putc(s, ' ');
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
-	return TRACE_TYPE_HANDLED;
+	for (i = 0; i < spaces - (spaces / 2); i++)
+		trace_seq_putc(s, ' ');
 }
 
 
-static enum print_line_t
-print_graph_lat_fmt(struct trace_seq *s, struct trace_entry *entry)
+static void print_graph_lat_fmt(struct trace_seq *s, struct trace_entry *entry)
 {
-	if (!trace_seq_putc(s, ' '))
-		return 0;
-
-	return trace_print_lat_fmt(s, entry);
+	trace_seq_putc(s, ' ');
+	trace_print_lat_fmt(s, entry);
 }
 
 /* If the pid changed since the last trace, output this event */
-static enum print_line_t
+static void
 verif_pid(struct trace_seq *s, pid_t pid, int cpu, struct fgraph_data *data)
 {
 	pid_t prev_pid;
 	pid_t *last_pid;
-	int ret;
 
 	if (!data)
-		return TRACE_TYPE_HANDLED;
+		return;
 
 	last_pid = &(per_cpu_ptr(data->cpu_data, cpu)->last_pid);
 
 	if (*last_pid == pid)
-		return TRACE_TYPE_HANDLED;
+		return;
 
 	prev_pid = *last_pid;
 	*last_pid = pid;
 
 	if (prev_pid == -1)
-		return TRACE_TYPE_HANDLED;
+		return;
 /*
  * Context-switch trace line:
 
@@ -582,33 +560,12 @@ verif_pid(struct trace_seq *s, pid_t pid, int cpu, struct fgraph_data *data)
  ------------------------------------------
 
  */
-	ret = trace_seq_puts(s,
-		" ------------------------------------------\n");
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	ret = print_graph_cpu(s, cpu);
-	if (ret == TRACE_TYPE_PARTIAL_LINE)
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	ret = print_graph_proc(s, prev_pid);
-	if (ret == TRACE_TYPE_PARTIAL_LINE)
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	ret = trace_seq_puts(s, " => ");
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	ret = print_graph_proc(s, pid);
-	if (ret == TRACE_TYPE_PARTIAL_LINE)
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	ret = trace_seq_puts(s,
-		"\n ------------------------------------------\n\n");
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	return TRACE_TYPE_HANDLED;
+	trace_seq_puts(s, " ------------------------------------------\n");
+	print_graph_cpu(s, cpu);
+	print_graph_proc(s, prev_pid);
+	trace_seq_puts(s, " => ");
+	print_graph_proc(s, pid);
+	trace_seq_puts(s, "\n ------------------------------------------\n\n");
 }
 
 static struct ftrace_graph_ret_entry *
@@ -682,103 +639,74 @@ get_return_for_leaf(struct trace_iterator *iter,
 	return next;
 }
 
-static int print_graph_abs_time(u64 t, struct trace_seq *s)
+static void print_graph_abs_time(u64 t, struct trace_seq *s)
 {
 	unsigned long usecs_rem;
 
 	usecs_rem = do_div(t, NSEC_PER_SEC);
 	usecs_rem /= 1000;
 
-	return trace_seq_printf(s, "%5lu.%06lu |  ",
-			(unsigned long)t, usecs_rem);
+	trace_seq_printf(s, "%5lu.%06lu |  ",
+			 (unsigned long)t, usecs_rem);
 }
 
-static enum print_line_t
+static void
 print_graph_irq(struct trace_iterator *iter, unsigned long addr,
 		enum trace_type type, int cpu, pid_t pid, u32 flags)
 {
-	int ret;
 	struct trace_seq *s = &iter->seq;
 	struct trace_entry *ent = iter->ent;
 
 	if (addr < (unsigned long)__irqentry_text_start ||
 		addr >= (unsigned long)__irqentry_text_end)
-		return TRACE_TYPE_UNHANDLED;
+		return;
 
 	if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
 		/* Absolute time */
-		if (flags & TRACE_GRAPH_PRINT_ABS_TIME) {
-			ret = print_graph_abs_time(iter->ts, s);
-			if (!ret)
-				return TRACE_TYPE_PARTIAL_LINE;
-		}
+		if (flags & TRACE_GRAPH_PRINT_ABS_TIME)
+			print_graph_abs_time(iter->ts, s);
 
 		/* Cpu */
-		if (flags & TRACE_GRAPH_PRINT_CPU) {
-			ret = print_graph_cpu(s, cpu);
-			if (ret == TRACE_TYPE_PARTIAL_LINE)
-				return TRACE_TYPE_PARTIAL_LINE;
-		}
+		if (flags & TRACE_GRAPH_PRINT_CPU)
+			print_graph_cpu(s, cpu);
 
 		/* Proc */
 		if (flags & TRACE_GRAPH_PRINT_PROC) {
-			ret = print_graph_proc(s, pid);
-			if (ret == TRACE_TYPE_PARTIAL_LINE)
-				return TRACE_TYPE_PARTIAL_LINE;
-			ret = trace_seq_puts(s, " | ");
-			if (!ret)
-				return TRACE_TYPE_PARTIAL_LINE;
+			print_graph_proc(s, pid);
+			trace_seq_puts(s, " | ");
 		}
 
 		/* Latency format */
-		if (trace_flags & TRACE_ITER_LATENCY_FMT) {
-			ret = print_graph_lat_fmt(s, ent);
-			if (ret == TRACE_TYPE_PARTIAL_LINE)
-				return TRACE_TYPE_PARTIAL_LINE;
-		}
-
+		if (trace_flags & TRACE_ITER_LATENCY_FMT)
+			print_graph_lat_fmt(s, ent);
 	}
 
 	/* No overhead */
-	ret = print_graph_duration(0, s, flags | FLAGS_FILL_START);
-	if (ret != TRACE_TYPE_HANDLED)
-		return ret;
+	print_graph_duration(0, s, flags | FLAGS_FILL_START);
 
 	if (type == TRACE_GRAPH_ENT)
-		ret = trace_seq_puts(s, "==========>");
+		trace_seq_puts(s, "==========>");
 	else
-		ret = trace_seq_puts(s, "<==========");
-
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	ret = print_graph_duration(0, s, flags | FLAGS_FILL_END);
-	if (ret != TRACE_TYPE_HANDLED)
-		return ret;
+		trace_seq_puts(s, "<==========");
 
-	ret = trace_seq_putc(s, '\n');
-
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-	return TRACE_TYPE_HANDLED;
+	print_graph_duration(0, s, flags | FLAGS_FILL_END);
+	trace_seq_putc(s, '\n');
 }
 
-enum print_line_t
+void
 trace_print_graph_duration(unsigned long long duration, struct trace_seq *s)
 {
 	unsigned long nsecs_rem = do_div(duration, 1000);
 	/* log10(ULONG_MAX) + '\0' */
 	char usecs_str[21];
 	char nsecs_str[5];
-	int ret, len;
+	int len;
 	int i;
 
 	sprintf(usecs_str, "%lu", (unsigned long) duration);
 
 	/* Print msecs */
-	ret = trace_seq_printf(s, "%s", usecs_str);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	trace_seq_printf(s, "%s", usecs_str);
 
 	len = strlen(usecs_str);
 
@@ -787,79 +715,63 @@ trace_print_graph_duration(unsigned long long duration, struct trace_seq *s)
 		size_t slen = min_t(size_t, sizeof(nsecs_str), 8UL - len);
 
 		snprintf(nsecs_str, slen, "%03lu", nsecs_rem);
-		ret = trace_seq_printf(s, ".%s", nsecs_str);
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
+		trace_seq_printf(s, ".%s", nsecs_str);
 		len += strlen(nsecs_str);
 	}
 
-	ret = trace_seq_puts(s, " us ");
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	trace_seq_puts(s, " us ");
 
 	/* Print remaining spaces to fit the row's width */
-	for (i = len; i < 7; i++) {
-		ret = trace_seq_putc(s, ' ');
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
-	return TRACE_TYPE_HANDLED;
+	for (i = len; i < 7; i++)
+		trace_seq_putc(s, ' ');
 }
 
-static enum print_line_t
+static void
 print_graph_duration(unsigned long long duration, struct trace_seq *s,
 		     u32 flags)
 {
-	int ret = -1;
+	bool duration_printed = false;
 
 	if (!(flags & TRACE_GRAPH_PRINT_DURATION) ||
 	    !(trace_flags & TRACE_ITER_CONTEXT_INFO))
-			return TRACE_TYPE_HANDLED;
+		return;
 
 	/* No real adata, just filling the column with spaces */
 	switch (flags & TRACE_GRAPH_PRINT_FILL_MASK) {
 	case FLAGS_FILL_FULL:
-		ret = trace_seq_puts(s, "              |  ");
-		return ret ? TRACE_TYPE_HANDLED : TRACE_TYPE_PARTIAL_LINE;
+		trace_seq_puts(s, "              |  ");
+		return;
 	case FLAGS_FILL_START:
-		ret = trace_seq_puts(s, "  ");
-		return ret ? TRACE_TYPE_HANDLED : TRACE_TYPE_PARTIAL_LINE;
+		trace_seq_puts(s, "  ");
+		return;
 	case FLAGS_FILL_END:
-		ret = trace_seq_puts(s, " |");
-		return ret ? TRACE_TYPE_HANDLED : TRACE_TYPE_PARTIAL_LINE;
+		trace_seq_puts(s, " |");
+		return;
 	}
 
 	/* Signal a overhead of time execution to the output */
 	if (flags & TRACE_GRAPH_PRINT_OVERHEAD) {
 		/* Duration exceeded 100 usecs */
-		if (duration > 100000ULL)
-			ret = trace_seq_puts(s, "! ");
+		if (duration > 100000ULL) {
+			trace_seq_puts(s, "! ");
+			duration_printed = true;
+
 		/* Duration exceeded 10 usecs */
-		else if (duration > 10000ULL)
-			ret = trace_seq_puts(s, "+ ");
+		} else if (duration > 10000ULL) {
+			trace_seq_puts(s, "+ ");
+			duration_printed = true;
+		}
 	}
 
 	/*
-	 * The -1 means we either did not exceed the duration tresholds
-	 * or we dont want to print out the overhead. Either way we need
-	 * to fill out the space.
+	 * If we did not exceed the duration tresholds or we dont want
+	 * to print out the overhead. Either way we need to fill out the space.
 	 */
-	if (ret == -1)
-		ret = trace_seq_puts(s, "  ");
-
-	/* Catching here any failure happenned above */
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	ret = trace_print_graph_duration(duration, s);
-	if (ret != TRACE_TYPE_HANDLED)
-		return ret;
+	if (!duration_printed)
+		trace_seq_puts(s, "  ");
 
-	ret = trace_seq_puts(s, "|  ");
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	return TRACE_TYPE_HANDLED;
+	trace_print_graph_duration(duration, s);
+	trace_seq_puts(s, "|  ");
 }
 
 /* Case of a leaf function on its call entry */
@@ -873,7 +785,6 @@ print_graph_entry_leaf(struct trace_iterator *iter,
 	struct ftrace_graph_ret *graph_ret;
 	struct ftrace_graph_ent *call;
 	unsigned long long duration;
-	int ret;
 	int i;
 
 	graph_ret = &ret_entry->ret;
@@ -899,22 +810,15 @@ print_graph_entry_leaf(struct trace_iterator *iter,
 	}
 
 	/* Overhead and duration */
-	ret = print_graph_duration(duration, s, flags);
-	if (ret == TRACE_TYPE_PARTIAL_LINE)
-		return TRACE_TYPE_PARTIAL_LINE;
+	print_graph_duration(duration, s, flags);
 
 	/* Function */
-	for (i = 0; i < call->depth * TRACE_GRAPH_INDENT; i++) {
-		ret = trace_seq_putc(s, ' ');
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
+	for (i = 0; i < call->depth * TRACE_GRAPH_INDENT; i++)
+		trace_seq_putc(s, ' ');
 
-	ret = trace_seq_printf(s, "%ps();\n", (void *)call->func);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	trace_seq_printf(s, "%ps();\n", (void *)call->func);
 
-	return TRACE_TYPE_HANDLED;
+	return trace_handle_return(s);
 }
 
 static enum print_line_t
@@ -924,7 +828,6 @@ print_graph_entry_nested(struct trace_iterator *iter,
 {
 	struct ftrace_graph_ent *call = &entry->graph_ent;
 	struct fgraph_data *data = iter->private;
-	int ret;
 	int i;
 
 	if (data) {
@@ -940,19 +843,15 @@ print_graph_entry_nested(struct trace_iterator *iter,
 	}
 
 	/* No time */
-	ret = print_graph_duration(0, s, flags | FLAGS_FILL_FULL);
-	if (ret != TRACE_TYPE_HANDLED)
-		return ret;
+	print_graph_duration(0, s, flags | FLAGS_FILL_FULL);
 
 	/* Function */
-	for (i = 0; i < call->depth * TRACE_GRAPH_INDENT; i++) {
-		ret = trace_seq_putc(s, ' ');
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
+	for (i = 0; i < call->depth * TRACE_GRAPH_INDENT; i++)
+		trace_seq_putc(s, ' ');
+
+	trace_seq_printf(s, "%ps() {\n", (void *)call->func);
 
-	ret = trace_seq_printf(s, "%ps() {\n", (void *)call->func);
-	if (!ret)
+	if (trace_seq_has_overflowed(s))
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	/*
@@ -962,62 +861,43 @@ print_graph_entry_nested(struct trace_iterator *iter,
 	return TRACE_TYPE_NO_CONSUME;
 }
 
-static enum print_line_t
+static void
 print_graph_prologue(struct trace_iterator *iter, struct trace_seq *s,
 		     int type, unsigned long addr, u32 flags)
 {
 	struct fgraph_data *data = iter->private;
 	struct trace_entry *ent = iter->ent;
 	int cpu = iter->cpu;
-	int ret;
 
 	/* Pid */
-	if (verif_pid(s, ent->pid, cpu, data) == TRACE_TYPE_PARTIAL_LINE)
-		return TRACE_TYPE_PARTIAL_LINE;
+	verif_pid(s, ent->pid, cpu, data);
 
-	if (type) {
+	if (type)
 		/* Interrupt */
-		ret = print_graph_irq(iter, addr, type, cpu, ent->pid, flags);
-		if (ret == TRACE_TYPE_PARTIAL_LINE)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
+		print_graph_irq(iter, addr, type, cpu, ent->pid, flags);
 
 	if (!(trace_flags & TRACE_ITER_CONTEXT_INFO))
-		return 0;
+		return;
 
 	/* Absolute time */
-	if (flags & TRACE_GRAPH_PRINT_ABS_TIME) {
-		ret = print_graph_abs_time(iter->ts, s);
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
+	if (flags & TRACE_GRAPH_PRINT_ABS_TIME)
+		print_graph_abs_time(iter->ts, s);
 
 	/* Cpu */
-	if (flags & TRACE_GRAPH_PRINT_CPU) {
-		ret = print_graph_cpu(s, cpu);
-		if (ret == TRACE_TYPE_PARTIAL_LINE)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
+	if (flags & TRACE_GRAPH_PRINT_CPU)
+		print_graph_cpu(s, cpu);
 
 	/* Proc */
 	if (flags & TRACE_GRAPH_PRINT_PROC) {
-		ret = print_graph_proc(s, ent->pid);
-		if (ret == TRACE_TYPE_PARTIAL_LINE)
-			return TRACE_TYPE_PARTIAL_LINE;
-
-		ret = trace_seq_puts(s, " | ");
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
+		print_graph_proc(s, ent->pid);
+		trace_seq_puts(s, " | ");
 	}
 
 	/* Latency format */
-	if (trace_flags & TRACE_ITER_LATENCY_FMT) {
-		ret = print_graph_lat_fmt(s, ent);
-		if (ret == TRACE_TYPE_PARTIAL_LINE)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
+	if (trace_flags & TRACE_ITER_LATENCY_FMT)
+		print_graph_lat_fmt(s, ent);
 
-	return 0;
+	return;
 }
 
 /*
@@ -1135,8 +1015,7 @@ print_graph_entry(struct ftrace_graph_ent_entry *field, struct trace_seq *s,
 	if (check_irq_entry(iter, flags, call->func, call->depth))
 		return TRACE_TYPE_HANDLED;
 
-	if (print_graph_prologue(iter, s, TRACE_GRAPH_ENT, call->func, flags))
-		return TRACE_TYPE_PARTIAL_LINE;
+	print_graph_prologue(iter, s, TRACE_GRAPH_ENT, call->func, flags);
 
 	leaf_ret = get_return_for_leaf(iter, field);
 	if (leaf_ret)
@@ -1169,7 +1048,6 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 	pid_t pid = ent->pid;
 	int cpu = iter->cpu;
 	int func_match = 1;
-	int ret;
 	int i;
 
 	if (check_irq_return(iter, flags, trace->depth))
@@ -1195,20 +1073,14 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 		}
 	}
 
-	if (print_graph_prologue(iter, s, 0, 0, flags))
-		return TRACE_TYPE_PARTIAL_LINE;
+	print_graph_prologue(iter, s, 0, 0, flags);
 
 	/* Overhead and duration */
-	ret = print_graph_duration(duration, s, flags);
-	if (ret == TRACE_TYPE_PARTIAL_LINE)
-		return TRACE_TYPE_PARTIAL_LINE;
+	print_graph_duration(duration, s, flags);
 
 	/* Closing brace */
-	for (i = 0; i < trace->depth * TRACE_GRAPH_INDENT; i++) {
-		ret = trace_seq_putc(s, ' ');
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
+	for (i = 0; i < trace->depth * TRACE_GRAPH_INDENT; i++)
+		trace_seq_putc(s, ' ');
 
 	/*
 	 * If the return function does not have a matching entry,
@@ -1217,30 +1089,20 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 	 * belongs to, write out the function name. Always do
 	 * that if the funcgraph-tail option is enabled.
 	 */
-	if (func_match && !(flags & TRACE_GRAPH_PRINT_TAIL)) {
-		ret = trace_seq_puts(s, "}\n");
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-	} else {
-		ret = trace_seq_printf(s, "} /* %ps */\n", (void *)trace->func);
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
+	if (func_match && !(flags & TRACE_GRAPH_PRINT_TAIL))
+		trace_seq_puts(s, "}\n");
+	else
+		trace_seq_printf(s, "} /* %ps */\n", (void *)trace->func);
 
 	/* Overrun */
-	if (flags & TRACE_GRAPH_PRINT_OVERRUN) {
-		ret = trace_seq_printf(s, " (Overruns: %lu)\n",
-					trace->overrun);
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
+	if (flags & TRACE_GRAPH_PRINT_OVERRUN)
+		trace_seq_printf(s, " (Overruns: %lu)\n",
+				 trace->overrun);
 
-	ret = print_graph_irq(iter, trace->func, TRACE_GRAPH_RET,
-			      cpu, pid, flags);
-	if (ret == TRACE_TYPE_PARTIAL_LINE)
-		return TRACE_TYPE_PARTIAL_LINE;
+	print_graph_irq(iter, trace->func, TRACE_GRAPH_RET,
+			cpu, pid, flags);
 
-	return TRACE_TYPE_HANDLED;
+	return trace_handle_return(s);
 }
 
 static enum print_line_t
@@ -1257,26 +1119,18 @@ print_graph_comment(struct trace_seq *s, struct trace_entry *ent,
 	if (data)
 		depth = per_cpu_ptr(data->cpu_data, iter->cpu)->depth;
 
-	if (print_graph_prologue(iter, s, 0, 0, flags))
-		return TRACE_TYPE_PARTIAL_LINE;
+	print_graph_prologue(iter, s, 0, 0, flags);
 
 	/* No time */
-	ret = print_graph_duration(0, s, flags | FLAGS_FILL_FULL);
-	if (ret != TRACE_TYPE_HANDLED)
-		return ret;
+	print_graph_duration(0, s, flags | FLAGS_FILL_FULL);
 
 	/* Indentation */
 	if (depth > 0)
-		for (i = 0; i < (depth + 1) * TRACE_GRAPH_INDENT; i++) {
-			ret = trace_seq_putc(s, ' ');
-			if (!ret)
-				return TRACE_TYPE_PARTIAL_LINE;
-		}
+		for (i = 0; i < (depth + 1) * TRACE_GRAPH_INDENT; i++)
+			trace_seq_putc(s, ' ');
 
 	/* The comment */
-	ret = trace_seq_puts(s, "/* ");
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	trace_seq_puts(s, "/* ");
 
 	switch (iter->ent->type) {
 	case TRACE_BPRINT:
@@ -1305,11 +1159,9 @@ print_graph_comment(struct trace_seq *s, struct trace_entry *ent,
 		s->len--;
 	}
 
-	ret = trace_seq_puts(s, " */\n");
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	trace_seq_puts(s, " */\n");
 
-	return TRACE_TYPE_HANDLED;
+	return trace_handle_return(s);
 }
 
 
-- 
2.1.1


