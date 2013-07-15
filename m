Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab3GOId2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 04:33:28 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:15415 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315Ab3GOId0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 04:33:26 -0400
Message-ID: <51E3B3AC.1000605@huawei.com>
Date: Mon, 15 Jul 2013 16:32:44 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] tracing: use trace_seq_puts()/trace_seq_putc() where
 possible
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For string without format specifiers, use trace_seq_puts()
or trace_seq_putc().

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
---
 kernel/trace/ring_buffer.c           |   10 +++----
 kernel/trace/trace_events_filter.c   |    4 +--
 kernel/trace/trace_functions_graph.c |   52 +++++++++++++++++-----------------
 kernel/trace/trace_mmiotrace.c       |    8 +++---
 kernel/trace/trace_output.c          |   14 ++++-----
 kernel/trace/trace_syscalls.c        |    2 +-
 6 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index e444ff8..eef2e56 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -36,11 +36,11 @@ int ring_buffer_print_entry_header(struct trace_seq *s)
 {
 	int ret;

-	ret = trace_seq_printf(s, "# compressed entry header\n");
-	ret = trace_seq_printf(s, "\ttype_len    :    5 bits\n");
-	ret = trace_seq_printf(s, "\ttime_delta  :   27 bits\n");
-	ret = trace_seq_printf(s, "\tarray       :   32 bits\n");
-	ret = trace_seq_printf(s, "\n");
+	ret = trace_seq_puts(s, "# compressed entry header\n");
+	ret = trace_seq_puts(s, "\ttype_len    :    5 bits\n");
+	ret = trace_seq_puts(s, "\ttime_delta  :   27 bits\n");
+	ret = trace_seq_puts(s, "\tarray       :   32 bits\n");
+	ret = trace_seq_putc(s, '\n');
 	ret = trace_seq_printf(s, "\tpadding     : type == %d\n",
 			       RINGBUF_TYPE_PADDING);
 	ret = trace_seq_printf(s, "\ttime_extend : type == %d\n",
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index e1b653f..8af0489 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -640,7 +640,7 @@ void print_event_filter(struct ftrace_event_call *call, struct trace_seq *s)
 	if (filter && filter->filter_string)
 		trace_seq_printf(s, "%s\n", filter->filter_string);
 	else
-		trace_seq_printf(s, "none\n");
+		trace_seq_puts(s, "none\n");
 	mutex_unlock(&event_mutex);
 }

@@ -654,7 +654,7 @@ void print_subsystem_event_filter(struct event_subsystem *system,
 	if (filter && filter->filter_string)
 		trace_seq_printf(s, "%s\n", filter->filter_string);
 	else
-		trace_seq_printf(s, DEFAULT_SYS_FILTER_MESSAGE "\n");
+		trace_seq_puts(s, DEFAULT_SYS_FILTER_MESSAGE "\n");
 	mutex_unlock(&event_mutex);
 }

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 8388bc9..3793f90 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -446,7 +446,7 @@ print_graph_proc(struct trace_seq *s, pid_t pid)

 	/* First spaces to align center */
 	for (i = 0; i < spaces / 2; i++) {
-		ret = trace_seq_printf(s, " ");
+		ret = trace_seq_putc(s, ' ');
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
@@ -457,7 +457,7 @@ print_graph_proc(struct trace_seq *s, pid_t pid)

 	/* Last spaces to align center */
 	for (i = 0; i < spaces - (spaces / 2); i++) {
-		ret = trace_seq_printf(s, " ");
+		ret = trace_seq_putc(s, " ");
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
@@ -503,7 +503,7 @@ verif_pid(struct trace_seq *s, pid_t pid, int cpu, struct fgraph_data *data)
  ------------------------------------------

  */
-	ret = trace_seq_printf(s,
+	ret = trace_seq_puts(s,
 		" ------------------------------------------\n");
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
@@ -516,7 +516,7 @@ verif_pid(struct trace_seq *s, pid_t pid, int cpu, struct fgraph_data *data)
 	if (ret == TRACE_TYPE_PARTIAL_LINE)
 		return TRACE_TYPE_PARTIAL_LINE;

-	ret = trace_seq_printf(s, " => ");
+	ret = trace_seq_puts(s, " => ");
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;

@@ -524,7 +524,7 @@ verif_pid(struct trace_seq *s, pid_t pid, int cpu, struct fgraph_data *data)
 	if (ret == TRACE_TYPE_PARTIAL_LINE)
 		return TRACE_TYPE_PARTIAL_LINE;

-	ret = trace_seq_printf(s,
+	ret = trace_seq_puts(s,
 		"\n ------------------------------------------\n\n");
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
@@ -645,7 +645,7 @@ print_graph_irq(struct trace_iterator *iter, unsigned long addr,
 			ret = print_graph_proc(s, pid);
 			if (ret == TRACE_TYPE_PARTIAL_LINE)
 				return TRACE_TYPE_PARTIAL_LINE;
-			ret = trace_seq_printf(s, " | ");
+			ret = trace_seq_puts(s, " | ");
 			if (!ret)
 				return TRACE_TYPE_PARTIAL_LINE;
 		}
@@ -657,9 +657,9 @@ print_graph_irq(struct trace_iterator *iter, unsigned long addr,
 		return ret;

 	if (type == TRACE_GRAPH_ENT)
-		ret = trace_seq_printf(s, "==========>");
+		ret = trace_seq_puts(s, "==========>");
 	else
-		ret = trace_seq_printf(s, "<==========");
+		ret = trace_seq_puts(s, "<==========");

 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
@@ -668,7 +668,7 @@ print_graph_irq(struct trace_iterator *iter, unsigned long addr,
 	if (ret != TRACE_TYPE_HANDLED)
 		return ret;

-	ret = trace_seq_printf(s, "\n");
+	ret = trace_seq_putc(s, '\n');

 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
@@ -705,13 +705,13 @@ trace_print_graph_duration(unsigned long long duration, struct trace_seq *s)
 		len += strlen(nsecs_str);
 	}

-	ret = trace_seq_printf(s, " us ");
+	ret = trace_seq_puts(s, " us ");
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;

 	/* Print remaining spaces to fit the row's width */
 	for (i = len; i < 7; i++) {
-		ret = trace_seq_printf(s, " ");
+		ret = trace_seq_putc(s, ' ');
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
@@ -731,13 +731,13 @@ print_graph_duration(unsigned long long duration, struct trace_seq *s,
 	/* No real adata, just filling the column with spaces */
 	switch (duration) {
 	case DURATION_FILL_FULL:
-		ret = trace_seq_printf(s, "              |  ");
+		ret = trace_seq_puts(s, "              |  ");
 		return ret ? TRACE_TYPE_HANDLED : TRACE_TYPE_PARTIAL_LINE;
 	case DURATION_FILL_START:
-		ret = trace_seq_printf(s, "  ");
+		ret = trace_seq_puts(s, "  ");
 		return ret ? TRACE_TYPE_HANDLED : TRACE_TYPE_PARTIAL_LINE;
 	case DURATION_FILL_END:
-		ret = trace_seq_printf(s, " |");
+		ret = trace_seq_puts(s, " |");
 		return ret ? TRACE_TYPE_HANDLED : TRACE_TYPE_PARTIAL_LINE;
 	}

@@ -745,10 +745,10 @@ print_graph_duration(unsigned long long duration, struct trace_seq *s,
 	if (flags & TRACE_GRAPH_PRINT_OVERHEAD) {
 		/* Duration exceeded 100 msecs */
 		if (duration > 100000ULL)
-			ret = trace_seq_printf(s, "! ");
+			ret = trace_seq_puts(s, "! ");
 		/* Duration exceeded 10 msecs */
 		else if (duration > 10000ULL)
-			ret = trace_seq_printf(s, "+ ");
+			ret = trace_seq_puts(s, "+ ");
 	}

 	/*
@@ -757,7 +757,7 @@ print_graph_duration(unsigned long long duration, struct trace_seq *s,
 	 * to fill out the space.
 	 */
 	if (ret == -1)
-		ret = trace_seq_printf(s, "  ");
+		ret = trace_seq_puts(s, "  ");

 	/* Catching here any failure happenned above */
 	if (!ret)
@@ -767,7 +767,7 @@ print_graph_duration(unsigned long long duration, struct trace_seq *s,
 	if (ret != TRACE_TYPE_HANDLED)
 		return ret;

-	ret = trace_seq_printf(s, "|  ");
+	ret = trace_seq_puts(s, "|  ");
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;

@@ -817,7 +817,7 @@ print_graph_entry_leaf(struct trace_iterator *iter,

 	/* Function */
 	for (i = 0; i < call->depth * TRACE_GRAPH_INDENT; i++) {
-		ret = trace_seq_printf(s, " ");
+		ret = trace_seq_putc(s, ' ');
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
@@ -858,7 +858,7 @@ print_graph_entry_nested(struct trace_iterator *iter,

 	/* Function */
 	for (i = 0; i < call->depth * TRACE_GRAPH_INDENT; i++) {
-		ret = trace_seq_printf(s, " ");
+		ret = trace_seq_putc(s, ' ');
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
@@ -917,7 +917,7 @@ print_graph_prologue(struct trace_iterator *iter, struct trace_seq *s,
 		if (ret == TRACE_TYPE_PARTIAL_LINE)
 			return TRACE_TYPE_PARTIAL_LINE;

-		ret = trace_seq_printf(s, " | ");
+		ret = trace_seq_puts(s, " | ");
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
@@ -1117,7 +1117,7 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,

 	/* Closing brace */
 	for (i = 0; i < trace->depth * TRACE_GRAPH_INDENT; i++) {
-		ret = trace_seq_printf(s, " ");
+		ret = trace_seq_putc(s, ' ');
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
@@ -1129,7 +1129,7 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 	 * belongs to, write out the function name.
 	 */
 	if (func_match) {
-		ret = trace_seq_printf(s, "}\n");
+		ret = trace_seq_puts(s, "}\n");
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
 	} else {
@@ -1179,13 +1179,13 @@ print_graph_comment(struct trace_seq *s, struct trace_entry *ent,
 	/* Indentation */
 	if (depth > 0)
 		for (i = 0; i < (depth + 1) * TRACE_GRAPH_INDENT; i++) {
-			ret = trace_seq_printf(s, " ");
+			ret = trace_seq_putc(s, ' ');
 			if (!ret)
 				return TRACE_TYPE_PARTIAL_LINE;
 		}

 	/* The comment */
-	ret = trace_seq_printf(s, "/* ");
+	ret = trace_seq_puts(s, "/* ");
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;

@@ -1216,7 +1216,7 @@ print_graph_comment(struct trace_seq *s, struct trace_entry *ent,
 		s->len--;
 	}

-	ret = trace_seq_printf(s, " */\n");
+	ret = trace_seq_puts(s, " */\n");
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;

diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index a5e8f48..b3dcfb2 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -90,7 +90,7 @@ static int mmio_print_pcidev(struct trace_seq *s, const struct pci_dev *dev)
 	if (drv)
 		ret += trace_seq_printf(s, " %s\n", drv->name);
 	else
-		ret += trace_seq_printf(s, " \n");
+		ret += trace_seq_puts(s, " \n");
 	return ret;
 }

@@ -107,7 +107,7 @@ static void mmio_pipe_open(struct trace_iterator *iter)
 	struct header_iter *hiter;
 	struct trace_seq *s = &iter->seq;

-	trace_seq_printf(s, "VERSION 20070824\n");
+	trace_seq_puts(s, "VERSION 20070824\n");

 	hiter = kzalloc(sizeof(*hiter), GFP_KERNEL);
 	if (!hiter)
@@ -209,7 +209,7 @@ static enum print_line_t mmio_print_rw(struct trace_iterator *iter)
 			(rw->value >> 0) & 0xff, rw->pc, 0);
 		break;
 	default:
-		ret = trace_seq_printf(s, "rw what?\n");
+		ret = trace_seq_puts(s, "rw what?\n");
 		break;
 	}
 	if (ret)
@@ -245,7 +245,7 @@ static enum print_line_t mmio_print_map(struct trace_iterator *iter)
 			secs, usec_rem, m->map_id, 0UL, 0);
 		break;
 	default:
-		ret = trace_seq_printf(s, "map what?\n");
+		ret = trace_seq_puts(s, "map what?\n");
 		break;
 	}
 	if (ret)
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index bb922d9..34e7cba 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -78,7 +78,7 @@ enum print_line_t trace_print_printk_msg_only(struct trace_iterator *iter)

 	trace_assign_type(field, entry);

-	ret = trace_seq_printf(s, "%s", field->buf);
+	ret = trace_seq_puts(s, field->buf);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;

@@ -558,14 +558,14 @@ seq_print_userip_objs(const struct userstack_entry *entry, struct trace_seq *s,
 			if (ret)
 				ret = trace_seq_puts(s, "??");
 			if (ret)
-				ret = trace_seq_puts(s, "\n");
+				ret = trace_seq_putc(s, '\n');
 			continue;
 		}
 		if (!ret)
 			break;
 		if (ret)
 			ret = seq_print_user_ip(s, mm, ip, sym_flags);
-		ret = trace_seq_puts(s, "\n");
+		ret = trace_seq_putc(s, '\n');
 	}

 	if (mm)
@@ -579,7 +579,7 @@ seq_print_ip_sym(struct trace_seq *s, unsigned long ip, unsigned long sym_flags)
 	int ret;

 	if (!ip)
-		return trace_seq_printf(s, "0");
+		return trace_seq_putc(s, '0');

 	if (sym_flags & TRACE_ITER_SYM_OFFSET)
 		ret = seq_print_sym_offset(s, "%s", ip);
@@ -964,14 +964,14 @@ static enum print_line_t trace_fn_trace(struct trace_iterator *iter, int flags,
 		goto partial;

 	if ((flags & TRACE_ITER_PRINT_PARENT) && field->parent_ip) {
-		if (!trace_seq_printf(s, " <-"))
+		if (!trace_seq_puts(s, " <-"))
 			goto partial;
 		if (!seq_print_ip_sym(s,
 				      field->parent_ip,
 				      flags))
 			goto partial;
 	}
-	if (!trace_seq_printf(s, "\n"))
+	if (!trace_seq_putc(s, '\n'))
 		goto partial;

 	return TRACE_TYPE_HANDLED;
@@ -1210,7 +1210,7 @@ static enum print_line_t trace_stack_print(struct trace_iterator *iter,

 		if (!seq_print_ip_sym(s, *p, flags))
 			goto partial;
-		if (!trace_seq_puts(s, "\n"))
+		if (!trace_seq_putc(s, '\n'))
 			goto partial;
 	}

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 8f2ac73..f87a0da 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -175,7 +175,7 @@ print_syscall_exit(struct trace_iterator *iter, int flags,
 	entry = syscall_nr_to_meta(syscall);

 	if (!entry) {
-		trace_seq_printf(s, "\n");
+		trace_seq_putc(s, '\n');
 		return TRACE_TYPE_HANDLED;
 	}

-- 
1.7.9.7


