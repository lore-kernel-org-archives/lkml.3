Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934984AbaKNBUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 20:20:31 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:43207 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934692AbaKNBON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 20:14:13 -0500
Message-Id: <20141114011410.365183157@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 13 Nov 2014 20:12:46 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>
Subject: [RFC][PATCH 02/23 v4] tracing: Add trace_seq_has_overflowed() and trace_handle_return()
References: <20141114011244.256115061@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0002-tracing-Add-trace_seq_has_overflowed-and-trace_handl.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Adding a trace_seq_has_overflowed() which returns true if the trace_seq
had too much written into it allows us to simplify the code.

Instead of checking the return value of every call to trace_seq_printf()
and friends, they can all be called normally, and at the end we can
return !trace_seq_has_overflowed() instead.

Several functions also return TRACE_TYPE_PARTIAL_LINE when the trace_seq
overflowed and TRACE_TYPE_HANDLED otherwise. Another helper function
was created called trace_handle_return() which takes a trace_seq and
returns these enums. Using this helper function also simplifies the
code.

This change also makes it possible to remove the return values of
trace_seq_printf() and friends. They should instead just be
void functions.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |  11 ++
 include/linux/trace_seq.h    |  12 ++
 include/trace/ftrace.h       |   6 +-
 kernel/trace/trace.c         |  69 +++----
 kernel/trace/trace.h         |   1 +
 kernel/trace/trace_output.c  | 416 +++++++++++++++++--------------------------
 kernel/trace/trace_output.h  |  16 +-
 7 files changed, 231 insertions(+), 300 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 28672e87e910..0bebb5c348b8 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -138,6 +138,17 @@ enum print_line_t {
 	TRACE_TYPE_NO_CONSUME	= 3	/* Handled but ask to not consume */
 };
 
+/*
+ * Several functions return TRACE_TYPE_PARTIAL_LINE if the trace_seq
+ * overflowed, and TRACE_TYPE_HANDLED otherwise. This helper function
+ * simplifies those functions and keeps them in sync.
+ */
+static inline enum print_line_t trace_handle_return(struct trace_seq *s)
+{
+	return trace_seq_has_overflowed(s) ?
+		TRACE_TYPE_PARTIAL_LINE : TRACE_TYPE_HANDLED;
+}
+
 void tracing_generic_entry_update(struct trace_entry *entry,
 				  unsigned long flags,
 				  int pc);
diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
index ea6c9dea79e3..07eda413dfcf 100644
--- a/include/linux/trace_seq.h
+++ b/include/linux/trace_seq.h
@@ -40,6 +40,18 @@ trace_seq_buffer_ptr(struct trace_seq *s)
 	return s->buffer + s->len;
 }
 
+/**
+ * trace_seq_has_overflowed - return true if the trace_seq took too much
+ * @s: trace sequence descriptor
+ *
+ * Returns true if too much data was added to the trace_seq and it is
+ * now full and will not take anymore.
+ */
+static inline bool trace_seq_has_overflowed(struct trace_seq *s)
+{
+	return s->full || s->len > PAGE_SIZE - 1;
+}
+
 /*
  * Currently only defined when tracing is enabled.
  */
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 26b4f2e13275..f13471b5d27a 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -280,11 +280,9 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags,	\
 	if (ret)							\
 		return ret;						\
 									\
-	ret = trace_seq_printf(s, print);				\
-	if (!ret)							\
-		return TRACE_TYPE_PARTIAL_LINE;				\
+	trace_seq_printf(s, print);					\
 									\
-	return TRACE_TYPE_HANDLED;					\
+	return trace_handle_return(s);					\
 }									\
 static struct trace_event_functions ftrace_event_type_funcs_##call = {	\
 	.trace			= ftrace_raw_output_##call,		\
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8a528392b1f4..f5a435a6e8fb 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2648,24 +2648,21 @@ static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
 	event = ftrace_find_event(entry->type);
 
 	if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
-		if (iter->iter_flags & TRACE_FILE_LAT_FMT) {
-			if (!trace_print_lat_context(iter))
-				goto partial;
-		} else {
-			if (!trace_print_context(iter))
-				goto partial;
-		}
+		if (iter->iter_flags & TRACE_FILE_LAT_FMT)
+			trace_print_lat_context(iter);
+		else
+			trace_print_context(iter);
 	}
 
+	if (trace_seq_has_overflowed(s))
+		return TRACE_TYPE_PARTIAL_LINE;
+
 	if (event)
 		return event->funcs->trace(iter, sym_flags, event);
 
-	if (!trace_seq_printf(s, "Unknown type %d\n", entry->type))
-		goto partial;
+	trace_seq_printf(s, "Unknown type %d\n", entry->type);
 
-	return TRACE_TYPE_HANDLED;
-partial:
-	return TRACE_TYPE_PARTIAL_LINE;
+	return trace_handle_return(s);
 }
 
 static enum print_line_t print_raw_fmt(struct trace_iterator *iter)
@@ -2676,22 +2673,20 @@ static enum print_line_t print_raw_fmt(struct trace_iterator *iter)
 
 	entry = iter->ent;
 
-	if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
-		if (!trace_seq_printf(s, "%d %d %llu ",
-				      entry->pid, iter->cpu, iter->ts))
-			goto partial;
-	}
+	if (trace_flags & TRACE_ITER_CONTEXT_INFO)
+		trace_seq_printf(s, "%d %d %llu ",
+				 entry->pid, iter->cpu, iter->ts);
+
+	if (trace_seq_has_overflowed(s))
+		return TRACE_TYPE_PARTIAL_LINE;
 
 	event = ftrace_find_event(entry->type);
 	if (event)
 		return event->funcs->raw(iter, 0, event);
 
-	if (!trace_seq_printf(s, "%d ?\n", entry->type))
-		goto partial;
+	trace_seq_printf(s, "%d ?\n", entry->type);
 
-	return TRACE_TYPE_HANDLED;
-partial:
-	return TRACE_TYPE_PARTIAL_LINE;
+	return trace_handle_return(s);
 }
 
 static enum print_line_t print_hex_fmt(struct trace_iterator *iter)
@@ -2704,9 +2699,11 @@ static enum print_line_t print_hex_fmt(struct trace_iterator *iter)
 	entry = iter->ent;
 
 	if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
-		SEQ_PUT_HEX_FIELD_RET(s, entry->pid);
-		SEQ_PUT_HEX_FIELD_RET(s, iter->cpu);
-		SEQ_PUT_HEX_FIELD_RET(s, iter->ts);
+		SEQ_PUT_HEX_FIELD(s, entry->pid);
+		SEQ_PUT_HEX_FIELD(s, iter->cpu);
+		SEQ_PUT_HEX_FIELD(s, iter->ts);
+		if (trace_seq_has_overflowed(s))
+			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
 	event = ftrace_find_event(entry->type);
@@ -2716,9 +2713,9 @@ static enum print_line_t print_hex_fmt(struct trace_iterator *iter)
 			return ret;
 	}
 
-	SEQ_PUT_FIELD_RET(s, newline);
+	SEQ_PUT_FIELD(s, newline);
 
-	return TRACE_TYPE_HANDLED;
+	return trace_handle_return(s);
 }
 
 static enum print_line_t print_bin_fmt(struct trace_iterator *iter)
@@ -2730,9 +2727,11 @@ static enum print_line_t print_bin_fmt(struct trace_iterator *iter)
 	entry = iter->ent;
 
 	if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
-		SEQ_PUT_FIELD_RET(s, entry->pid);
-		SEQ_PUT_FIELD_RET(s, iter->cpu);
-		SEQ_PUT_FIELD_RET(s, iter->ts);
+		SEQ_PUT_FIELD(s, entry->pid);
+		SEQ_PUT_FIELD(s, iter->cpu);
+		SEQ_PUT_FIELD(s, iter->ts);
+		if (trace_seq_has_overflowed(s))
+			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
 	event = ftrace_find_event(entry->type);
@@ -2778,10 +2777,12 @@ enum print_line_t print_trace_line(struct trace_iterator *iter)
 {
 	enum print_line_t ret;
 
-	if (iter->lost_events &&
-	    !trace_seq_printf(&iter->seq, "CPU:%d [LOST %lu EVENTS]\n",
-				 iter->cpu, iter->lost_events))
-		return TRACE_TYPE_PARTIAL_LINE;
+	if (iter->lost_events) {
+		trace_seq_printf(&iter->seq, "CPU:%d [LOST %lu EVENTS]\n",
+				 iter->cpu, iter->lost_events);
+		if (trace_seq_has_overflowed(&iter->seq))
+			return TRACE_TYPE_PARTIAL_LINE;
+	}
 
 	if (iter->trace && iter->trace->print_line) {
 		ret = iter->trace->print_line(iter);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 3376de623ea0..19418221b302 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -14,6 +14,7 @@
 #include <linux/trace_seq.h>
 #include <linux/ftrace_event.h>
 #include <linux/compiler.h>
+#include <linux/trace_seq.h>
 
 #ifdef CONFIG_FTRACE_SYSCALLS
 #include <asm/unistd.h>		/* For NR_SYSCALLS	     */
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index cfa91de22e27..163c11b6b8ff 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -25,15 +25,12 @@ enum print_line_t trace_print_bputs_msg_only(struct trace_iterator *iter)
 	struct trace_seq *s = &iter->seq;
 	struct trace_entry *entry = iter->ent;
 	struct bputs_entry *field;
-	int ret;
 
 	trace_assign_type(field, entry);
 
-	ret = trace_seq_puts(s, field->str);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	trace_seq_puts(s, field->str);
 
-	return TRACE_TYPE_HANDLED;
+	return trace_handle_return(s);
 }
 
 enum print_line_t trace_print_bprintk_msg_only(struct trace_iterator *iter)
@@ -41,15 +38,12 @@ enum print_line_t trace_print_bprintk_msg_only(struct trace_iterator *iter)
 	struct trace_seq *s = &iter->seq;
 	struct trace_entry *entry = iter->ent;
 	struct bprint_entry *field;
-	int ret;
 
 	trace_assign_type(field, entry);
 
-	ret = trace_seq_bprintf(s, field->fmt, field->buf);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	trace_seq_bprintf(s, field->fmt, field->buf);
 
-	return TRACE_TYPE_HANDLED;
+	return trace_handle_return(s);
 }
 
 enum print_line_t trace_print_printk_msg_only(struct trace_iterator *iter)
@@ -57,15 +51,12 @@ enum print_line_t trace_print_printk_msg_only(struct trace_iterator *iter)
 	struct trace_seq *s = &iter->seq;
 	struct trace_entry *entry = iter->ent;
 	struct print_entry *field;
-	int ret;
 
 	trace_assign_type(field, entry);
 
-	ret = trace_seq_puts(s, field->buf);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	trace_seq_puts(s, field->buf);
 
-	return TRACE_TYPE_HANDLED;
+	return trace_handle_return(s);
 }
 
 const char *
@@ -193,7 +184,6 @@ int ftrace_raw_output_prep(struct trace_iterator *iter,
 	struct trace_seq *s = &iter->seq;
 	struct trace_seq *p = &iter->tmp_seq;
 	struct trace_entry *entry;
-	int ret;
 
 	event = container_of(trace_event, struct ftrace_event_call, event);
 	entry = iter->ent;
@@ -204,8 +194,9 @@ int ftrace_raw_output_prep(struct trace_iterator *iter,
 	}
 
 	trace_seq_init(p);
-	ret = trace_seq_printf(s, "%s: ", ftrace_event_name(event));
-	if (!ret)
+	trace_seq_printf(s, "%s: ", ftrace_event_name(event));
+
+	if (trace_seq_has_overflowed(s))
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	return 0;
@@ -216,18 +207,11 @@ static int ftrace_output_raw(struct trace_iterator *iter, char *name,
 			     char *fmt, va_list ap)
 {
 	struct trace_seq *s = &iter->seq;
-	int ret;
 
-	ret = trace_seq_printf(s, "%s: ", name);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	ret = trace_seq_vprintf(s, fmt, ap);
+	trace_seq_printf(s, "%s: ", name);
+	trace_seq_vprintf(s, fmt, ap);
 
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	return TRACE_TYPE_HANDLED;
+	return trace_handle_return(s);
 }
 
 int ftrace_output_call(struct trace_iterator *iter, char *name, char *fmt, ...)
@@ -260,7 +244,7 @@ static inline const char *kretprobed(const char *name)
 }
 #endif /* CONFIG_KRETPROBES */
 
-static int
+static void
 seq_print_sym_short(struct trace_seq *s, const char *fmt, unsigned long address)
 {
 #ifdef CONFIG_KALLSYMS
@@ -271,12 +255,11 @@ seq_print_sym_short(struct trace_seq *s, const char *fmt, unsigned long address)
 
 	name = kretprobed(str);
 
-	return trace_seq_printf(s, fmt, name);
+	trace_seq_printf(s, fmt, name);
 #endif
-	return 1;
 }
 
-static int
+static void
 seq_print_sym_offset(struct trace_seq *s, const char *fmt,
 		     unsigned long address)
 {
@@ -287,9 +270,8 @@ seq_print_sym_offset(struct trace_seq *s, const char *fmt,
 	sprint_symbol(str, address);
 	name = kretprobed(str);
 
-	return trace_seq_printf(s, fmt, name);
+	trace_seq_printf(s, fmt, name);
 #endif
-	return 1;
 }
 
 #ifndef CONFIG_64BIT
@@ -320,14 +302,14 @@ int seq_print_user_ip(struct trace_seq *s, struct mm_struct *mm,
 		if (file) {
 			ret = trace_seq_path(s, &file->f_path);
 			if (ret)
-				ret = trace_seq_printf(s, "[+0x%lx]",
-						       ip - vmstart);
+				trace_seq_printf(s, "[+0x%lx]",
+						 ip - vmstart);
 		}
 		up_read(&mm->mmap_sem);
 	}
 	if (ret && ((sym_flags & TRACE_ITER_SYM_ADDR) || !file))
-		ret = trace_seq_printf(s, " <" IP_FMT ">", ip);
-	return ret;
+		trace_seq_printf(s, " <" IP_FMT ">", ip);
+	return !trace_seq_has_overflowed(s);
 }
 
 int
@@ -335,7 +317,6 @@ seq_print_userip_objs(const struct userstack_entry *entry, struct trace_seq *s,
 		      unsigned long sym_flags)
 {
 	struct mm_struct *mm = NULL;
-	int ret = 1;
 	unsigned int i;
 
 	if (trace_flags & TRACE_ITER_SYM_USEROBJ) {
@@ -354,48 +335,45 @@ seq_print_userip_objs(const struct userstack_entry *entry, struct trace_seq *s,
 	for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
 		unsigned long ip = entry->caller[i];
 
-		if (ip == ULONG_MAX || !ret)
+		if (ip == ULONG_MAX || trace_seq_has_overflowed(s))
 			break;
-		if (ret)
-			ret = trace_seq_puts(s, " => ");
+
+		trace_seq_puts(s, " => ");
+
 		if (!ip) {
-			if (ret)
-				ret = trace_seq_puts(s, "??");
-			if (ret)
-				ret = trace_seq_putc(s, '\n');
+			trace_seq_puts(s, "??");
+			trace_seq_putc(s, '\n');
 			continue;
 		}
-		if (!ret)
-			break;
-		if (ret)
-			ret = seq_print_user_ip(s, mm, ip, sym_flags);
-		ret = trace_seq_putc(s, '\n');
+
+		seq_print_user_ip(s, mm, ip, sym_flags);
+		trace_seq_putc(s, '\n');
 	}
 
 	if (mm)
 		mmput(mm);
-	return ret;
+
+	return !trace_seq_has_overflowed(s);
 }
 
 int
 seq_print_ip_sym(struct trace_seq *s, unsigned long ip, unsigned long sym_flags)
 {
-	int ret;
-
-	if (!ip)
-		return trace_seq_putc(s, '0');
+	if (!ip) {
+		trace_seq_putc(s, '0');
+		goto out;
+	}
 
 	if (sym_flags & TRACE_ITER_SYM_OFFSET)
-		ret = seq_print_sym_offset(s, "%s", ip);
+		seq_print_sym_offset(s, "%s", ip);
 	else
-		ret = seq_print_sym_short(s, "%s", ip);
-
-	if (!ret)
-		return 0;
+		seq_print_sym_short(s, "%s", ip);
 
 	if (sym_flags & TRACE_ITER_SYM_ADDR)
-		ret = trace_seq_printf(s, " <" IP_FMT ">", ip);
-	return ret;
+		trace_seq_printf(s, " <" IP_FMT ">", ip);
+
+ out:
+	return !trace_seq_has_overflowed(s);
 }
 
 /**
@@ -413,7 +391,6 @@ int trace_print_lat_fmt(struct trace_seq *s, struct trace_entry *entry)
 	char irqs_off;
 	int hardirq;
 	int softirq;
-	int ret;
 
 	hardirq = entry->flags & TRACE_FLAG_HARDIRQ;
 	softirq = entry->flags & TRACE_FLAG_SOFTIRQ;
@@ -445,16 +422,15 @@ int trace_print_lat_fmt(struct trace_seq *s, struct trace_entry *entry)
 		softirq ? 's' :
 		'.';
 
-	if (!trace_seq_printf(s, "%c%c%c",
-			      irqs_off, need_resched, hardsoft_irq))
-		return 0;
+	trace_seq_printf(s, "%c%c%c",
+			 irqs_off, need_resched, hardsoft_irq);
 
 	if (entry->preempt_count)
-		ret = trace_seq_printf(s, "%x", entry->preempt_count);
+		trace_seq_printf(s, "%x", entry->preempt_count);
 	else
-		ret = trace_seq_putc(s, '.');
+		trace_seq_putc(s, '.');
 
-	return ret;
+	return !trace_seq_has_overflowed(s);
 }
 
 static int
@@ -464,9 +440,8 @@ lat_print_generic(struct trace_seq *s, struct trace_entry *entry, int cpu)
 
 	trace_find_cmdline(entry->pid, comm);
 
-	if (!trace_seq_printf(s, "%8.8s-%-5d %3d",
-			      comm, entry->pid, cpu))
-		return 0;
+	trace_seq_printf(s, "%8.8s-%-5d %3d",
+			 comm, entry->pid, cpu);
 
 	return trace_print_lat_fmt(s, entry);
 }
@@ -493,24 +468,29 @@ lat_print_timestamp(struct trace_iterator *iter, u64 next_ts)
 		unsigned long rel_usec = do_div(rel_ts, USEC_PER_MSEC);
 		unsigned long rel_msec = (unsigned long)rel_ts;
 
-		return trace_seq_printf(
-				s, "[%08llx] %ld.%03ldms (+%ld.%03ldms): ",
-				ns2usecs(iter->ts),
-				abs_msec, abs_usec,
-				rel_msec, rel_usec);
+		trace_seq_printf(
+			s, "[%08llx] %ld.%03ldms (+%ld.%03ldms): ",
+			ns2usecs(iter->ts),
+			abs_msec, abs_usec,
+			rel_msec, rel_usec);
+
 	} else if (verbose && !in_ns) {
-		return trace_seq_printf(
-				s, "[%016llx] %lld (+%lld): ",
-				iter->ts, abs_ts, rel_ts);
+		trace_seq_printf(
+			s, "[%016llx] %lld (+%lld): ",
+			iter->ts, abs_ts, rel_ts);
+
 	} else if (!verbose && in_ns) {
-		return trace_seq_printf(
-				s, " %4lldus%c: ",
-				abs_ts,
-				rel_ts > preempt_mark_thresh_us ? '!' :
-				  rel_ts > 1 ? '+' : ' ');
+		trace_seq_printf(
+			s, " %4lldus%c: ",
+			abs_ts,
+			rel_ts > preempt_mark_thresh_us ? '!' :
+			rel_ts > 1 ? '+' : ' ');
+
 	} else { /* !verbose && !in_ns */
-		return trace_seq_printf(s, " %4lld: ", abs_ts);
+		trace_seq_printf(s, " %4lld: ", abs_ts);
 	}
+
+	return !trace_seq_has_overflowed(s);
 }
 
 int trace_print_context(struct trace_iterator *iter)
@@ -520,34 +500,29 @@ int trace_print_context(struct trace_iterator *iter)
 	unsigned long long t;
 	unsigned long secs, usec_rem;
 	char comm[TASK_COMM_LEN];
-	int ret;
 
 	trace_find_cmdline(entry->pid, comm);
 
-	ret = trace_seq_printf(s, "%16s-%-5d [%03d] ",
+	trace_seq_printf(s, "%16s-%-5d [%03d] ",
 			       comm, entry->pid, iter->cpu);
-	if (!ret)
-		return 0;
 
-	if (trace_flags & TRACE_ITER_IRQ_INFO) {
-		ret = trace_print_lat_fmt(s, entry);
-		if (!ret)
-			return 0;
-	}
+	if (trace_flags & TRACE_ITER_IRQ_INFO)
+		trace_print_lat_fmt(s, entry);
 
 	if (iter->iter_flags & TRACE_FILE_TIME_IN_NS) {
 		t = ns2usecs(iter->ts);
 		usec_rem = do_div(t, USEC_PER_SEC);
 		secs = (unsigned long)t;
-		return trace_seq_printf(s, " %5lu.%06lu: ", secs, usec_rem);
+		trace_seq_printf(s, " %5lu.%06lu: ", secs, usec_rem);
 	} else
-		return trace_seq_printf(s, " %12llu: ", iter->ts);
+		trace_seq_printf(s, " %12llu: ", iter->ts);
+
+	return !trace_seq_has_overflowed(s);
 }
 
 int trace_print_lat_context(struct trace_iterator *iter)
 {
 	u64 next_ts;
-	int ret;
 	/* trace_find_next_entry will reset ent_size */
 	int ent_size = iter->ent_size;
 	struct trace_seq *s = &iter->seq;
@@ -567,18 +542,17 @@ int trace_print_lat_context(struct trace_iterator *iter)
 
 		trace_find_cmdline(entry->pid, comm);
 
-		ret = trace_seq_printf(
-				s, "%16s %5d %3d %d %08x %08lx ",
-				comm, entry->pid, iter->cpu, entry->flags,
-				entry->preempt_count, iter->idx);
+		trace_seq_printf(
+			s, "%16s %5d %3d %d %08x %08lx ",
+			comm, entry->pid, iter->cpu, entry->flags,
+			entry->preempt_count, iter->idx);
 	} else {
-		ret = lat_print_generic(s, entry, iter->cpu);
+		lat_print_generic(s, entry, iter->cpu);
 	}
 
-	if (ret)
-		ret = lat_print_timestamp(iter, next_ts);
+	lat_print_timestamp(iter, next_ts);
 
-	return ret;
+	return !trace_seq_has_overflowed(s);
 }
 
 static const char state_to_char[] = TASK_STATE_TO_CHAR_STR;
@@ -764,10 +738,9 @@ EXPORT_SYMBOL_GPL(unregister_ftrace_event);
 enum print_line_t trace_nop_print(struct trace_iterator *iter, int flags,
 				  struct trace_event *event)
 {
-	if (!trace_seq_printf(&iter->seq, "type: %d\n", iter->ent->type))
-		return TRACE_TYPE_PARTIAL_LINE;
+	trace_seq_printf(&iter->seq, "type: %d\n", iter->ent->type);
 
-	return TRACE_TYPE_HANDLED;
+	return trace_handle_return(&iter->seq);
 }
 
 /* TRACE_FN */
@@ -779,24 +752,16 @@ static enum print_line_t trace_fn_trace(struct trace_iterator *iter, int flags,
 
 	trace_assign_type(field, iter->ent);
 
-	if (!seq_print_ip_sym(s, field->ip, flags))
-		goto partial;
+	seq_print_ip_sym(s, field->ip, flags);
 
 	if ((flags & TRACE_ITER_PRINT_PARENT) && field->parent_ip) {
-		if (!trace_seq_puts(s, " <-"))
-			goto partial;
-		if (!seq_print_ip_sym(s,
-				      field->parent_ip,
-				      flags))
-			goto partial;
+		trace_seq_puts(s, " <-");
+		seq_print_ip_sym(s, field->parent_ip, flags);
 	}
-	if (!trace_seq_putc(s, '\n'))
-		goto partial;
 
-	return TRACE_TYPE_HANDLED;
+	trace_seq_putc(s, '\n');
 
- partial:
-	return TRACE_TYPE_PARTIAL_LINE;
+	return trace_handle_return(s);
 }
 
 static enum print_line_t trace_fn_raw(struct trace_iterator *iter, int flags,
@@ -806,12 +771,11 @@ static enum print_line_t trace_fn_raw(struct trace_iterator *iter, int flags,
 
 	trace_assign_type(field, iter->ent);
 
-	if (!trace_seq_printf(&iter->seq, "%lx %lx\n",
-			      field->ip,
-			      field->parent_ip))
-		return TRACE_TYPE_PARTIAL_LINE;
+	trace_seq_printf(&iter->seq, "%lx %lx\n",
+			 field->ip,
+			 field->parent_ip);
 
-	return TRACE_TYPE_HANDLED;
+	return trace_handle_return(&iter->seq);
 }
 
 static enum print_line_t trace_fn_hex(struct trace_iterator *iter, int flags,
@@ -822,10 +786,10 @@ static enum print_line_t trace_fn_hex(struct trace_iterator *iter, int flags,
 
 	trace_assign_type(field, iter->ent);
 
-	SEQ_PUT_HEX_FIELD_RET(s, field->ip);
-	SEQ_PUT_HEX_FIELD_RET(s, field->parent_ip);
+	SEQ_PUT_HEX_FIELD(s, field->ip);
+	SEQ_PUT_HEX_FIELD(s, field->parent_ip);
 
-	return TRACE_TYPE_HANDLED;
+	return trace_handle_return(s);
 }
 
 static enum print_line_t trace_fn_bin(struct trace_iterator *iter, int flags,
@@ -836,10 +800,10 @@ static enum print_line_t trace_fn_bin(struct trace_iterator *iter, int flags,
 
 	trace_assign_type(field, iter->ent);
 
-	SEQ_PUT_FIELD_RET(s, field->ip);
-	SEQ_PUT_FIELD_RET(s, field->parent_ip);
+	SEQ_PUT_FIELD(s, field->ip);
+	SEQ_PUT_FIELD(s, field->parent_ip);
 
-	return TRACE_TYPE_HANDLED;
+	return trace_handle_return(s);
 }
 
 static struct trace_event_functions trace_fn_funcs = {
@@ -868,18 +832,17 @@ static enum print_line_t trace_ctxwake_print(struct trace_iterator *iter,
 	T = task_state_char(field->next_state);
 	S = task_state_char(field->prev_state);
 	trace_find_cmdline(field->next_pid, comm);
-	if (!trace_seq_printf(&iter->seq,
-			      " %5d:%3d:%c %s [%03d] %5d:%3d:%c %s\n",
-			      field->prev_pid,
-			      field->prev_prio,
-			      S, delim,
-			      field->next_cpu,
-			      field->next_pid,
-			      field->next_prio,
-			      T, comm))
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	return TRACE_TYPE_HANDLED;
+	trace_seq_printf(&iter->seq,
+			 " %5d:%3d:%c %s [%03d] %5d:%3d:%c %s\n",
+			 field->prev_pid,
+			 field->prev_prio,
+			 S, delim,
+			 field->next_cpu,
+			 field->next_pid,
+			 field->next_prio,
+			 T, comm);
+
+	return trace_handle_return(&iter->seq);
 }
 
 static enum print_line_t trace_ctx_print(struct trace_iterator *iter, int flags,
@@ -904,17 +867,16 @@ static int trace_ctxwake_raw(struct trace_iterator *iter, char S)
 	if (!S)
 		S = task_state_char(field->prev_state);
 	T = task_state_char(field->next_state);
-	if (!trace_seq_printf(&iter->seq, "%d %d %c %d %d %d %c\n",
-			      field->prev_pid,
-			      field->prev_prio,
-			      S,
-			      field->next_cpu,
-			      field->next_pid,
-			      field->next_prio,
-			      T))
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	return TRACE_TYPE_HANDLED;
+	trace_seq_printf(&iter->seq, "%d %d %c %d %d %d %c\n",
+			 field->prev_pid,
+			 field->prev_prio,
+			 S,
+			 field->next_cpu,
+			 field->next_pid,
+			 field->next_prio,
+			 T);
+
+	return trace_handle_return(&iter->seq);
 }
 
 static enum print_line_t trace_ctx_raw(struct trace_iterator *iter, int flags,
@@ -942,15 +904,15 @@ static int trace_ctxwake_hex(struct trace_iterator *iter, char S)
 		S = task_state_char(field->prev_state);
 	T = task_state_char(field->next_state);
 
-	SEQ_PUT_HEX_FIELD_RET(s, field->prev_pid);
-	SEQ_PUT_HEX_FIELD_RET(s, field->prev_prio);
-	SEQ_PUT_HEX_FIELD_RET(s, S);
-	SEQ_PUT_HEX_FIELD_RET(s, field->next_cpu);
-	SEQ_PUT_HEX_FIELD_RET(s, field->next_pid);
-	SEQ_PUT_HEX_FIELD_RET(s, field->next_prio);
-	SEQ_PUT_HEX_FIELD_RET(s, T);
+	SEQ_PUT_HEX_FIELD(s, field->prev_pid);
+	SEQ_PUT_HEX_FIELD(s, field->prev_prio);
+	SEQ_PUT_HEX_FIELD(s, S);
+	SEQ_PUT_HEX_FIELD(s, field->next_cpu);
+	SEQ_PUT_HEX_FIELD(s, field->next_pid);
+	SEQ_PUT_HEX_FIELD(s, field->next_prio);
+	SEQ_PUT_HEX_FIELD(s, T);
 
-	return TRACE_TYPE_HANDLED;
+	return trace_handle_return(s);
 }
 
 static enum print_line_t trace_ctx_hex(struct trace_iterator *iter, int flags,
@@ -973,15 +935,15 @@ static enum print_line_t trace_ctxwake_bin(struct trace_iterator *iter,
 
 	trace_assign_type(field, iter->ent);
 
-	SEQ_PUT_FIELD_RET(s, field->prev_pid);
-	SEQ_PUT_FIELD_RET(s, field->prev_prio);
-	SEQ_PUT_FIELD_RET(s, field->prev_state);
-	SEQ_PUT_FIELD_RET(s, field->next_cpu);
-	SEQ_PUT_FIELD_RET(s, field->next_pid);
-	SEQ_PUT_FIELD_RET(s, field->next_prio);
-	SEQ_PUT_FIELD_RET(s, field->next_state);
+	SEQ_PUT_FIELD(s, field->prev_pid);
+	SEQ_PUT_FIELD(s, field->prev_prio);
+	SEQ_PUT_FIELD(s, field->prev_state);
+	SEQ_PUT_FIELD(s, field->next_cpu);
+	SEQ_PUT_FIELD(s, field->next_pid);
+	SEQ_PUT_FIELD(s, field->next_prio);
+	SEQ_PUT_FIELD(s, field->next_state);
 
-	return TRACE_TYPE_HANDLED;
+	return trace_handle_return(s);
 }
 
 static struct trace_event_functions trace_ctx_funcs = {
@@ -1021,23 +983,19 @@ static enum print_line_t trace_stack_print(struct trace_iterator *iter,
 	trace_assign_type(field, iter->ent);
 	end = (unsigned long *)((long)iter->ent + iter->ent_size);
 
-	if (!trace_seq_puts(s, "<stack trace>\n"))
-		goto partial;
+	trace_seq_puts(s, "<stack trace>\n");
 
 	for (p = field->caller; p && *p != ULONG_MAX && p < end; p++) {
-		if (!trace_seq_puts(s, " => "))
-			goto partial;
 
-		if (!seq_print_ip_sym(s, *p, flags))
-			goto partial;
-		if (!trace_seq_putc(s, '\n'))
-			goto partial;
-	}
+		if (trace_seq_has_overflowed(s))
+			break;
 
-	return TRACE_TYPE_HANDLED;
+		trace_seq_puts(s, " => ");
+		seq_print_ip_sym(s, *p, flags);
+		trace_seq_putc(s, '\n');
+	}
 
- partial:
-	return TRACE_TYPE_PARTIAL_LINE;
+	return trace_handle_return(s);
 }
 
 static struct trace_event_functions trace_stack_funcs = {
@@ -1058,16 +1016,10 @@ static enum print_line_t trace_user_stack_print(struct trace_iterator *iter,
 
 	trace_assign_type(field, iter->ent);
 
-	if (!trace_seq_puts(s, "<user stack trace>\n"))
-		goto partial;
-
-	if (!seq_print_userip_objs(field, s, flags))
-		goto partial;
-
-	return TRACE_TYPE_HANDLED;
+	trace_seq_puts(s, "<user stack trace>\n");
+	seq_print_userip_objs(field, s, flags);
 
- partial:
-	return TRACE_TYPE_PARTIAL_LINE;
+	return trace_handle_return(s);
 }
 
 static struct trace_event_functions trace_user_stack_funcs = {
@@ -1090,19 +1042,11 @@ trace_bputs_print(struct trace_iterator *iter, int flags,
 
 	trace_assign_type(field, entry);
 
-	if (!seq_print_ip_sym(s, field->ip, flags))
-		goto partial;
+	seq_print_ip_sym(s, field->ip, flags);
+	trace_seq_puts(s, ": ");
+	trace_seq_puts(s, field->str);
 
-	if (!trace_seq_puts(s, ": "))
-		goto partial;
-
-	if (!trace_seq_puts(s, field->str))
-		goto partial;
-
-	return TRACE_TYPE_HANDLED;
-
- partial:
-	return TRACE_TYPE_PARTIAL_LINE;
+	return trace_handle_return(s);
 }
 
 
@@ -1115,16 +1059,10 @@ trace_bputs_raw(struct trace_iterator *iter, int flags,
 
 	trace_assign_type(field, iter->ent);
 
-	if (!trace_seq_printf(s, ": %lx : ", field->ip))
-		goto partial;
-
-	if (!trace_seq_puts(s, field->str))
-		goto partial;
+	trace_seq_printf(s, ": %lx : ", field->ip);
+	trace_seq_puts(s, field->str);
 
-	return TRACE_TYPE_HANDLED;
-
- partial:
-	return TRACE_TYPE_PARTIAL_LINE;
+	return trace_handle_return(s);
 }
 
 static struct trace_event_functions trace_bputs_funcs = {
@@ -1148,19 +1086,11 @@ trace_bprint_print(struct trace_iterator *iter, int flags,
 
 	trace_assign_type(field, entry);
 
-	if (!seq_print_ip_sym(s, field->ip, flags))
-		goto partial;
-
-	if (!trace_seq_puts(s, ": "))
-		goto partial;
-
-	if (!trace_seq_bprintf(s, field->fmt, field->buf))
-		goto partial;
+	seq_print_ip_sym(s, field->ip, flags);
+	trace_seq_puts(s, ": ");
+	trace_seq_bprintf(s, field->fmt, field->buf);
 
-	return TRACE_TYPE_HANDLED;
-
- partial:
-	return TRACE_TYPE_PARTIAL_LINE;
+	return trace_handle_return(s);
 }
 
 
@@ -1173,16 +1103,10 @@ trace_bprint_raw(struct trace_iterator *iter, int flags,
 
 	trace_assign_type(field, iter->ent);
 
-	if (!trace_seq_printf(s, ": %lx : ", field->ip))
-		goto partial;
-
-	if (!trace_seq_bprintf(s, field->fmt, field->buf))
-		goto partial;
+	trace_seq_printf(s, ": %lx : ", field->ip);
+	trace_seq_bprintf(s, field->fmt, field->buf);
 
-	return TRACE_TYPE_HANDLED;
-
- partial:
-	return TRACE_TYPE_PARTIAL_LINE;
+	return trace_handle_return(s);
 }
 
 static struct trace_event_functions trace_bprint_funcs = {
@@ -1204,16 +1128,10 @@ static enum print_line_t trace_print_print(struct trace_iterator *iter,
 
 	trace_assign_type(field, iter->ent);
 
-	if (!seq_print_ip_sym(s, field->ip, flags))
-		goto partial;
-
-	if (!trace_seq_printf(s, ": %s", field->buf))
-		goto partial;
+	seq_print_ip_sym(s, field->ip, flags);
+	trace_seq_printf(s, ": %s", field->buf);
 
-	return TRACE_TYPE_HANDLED;
-
- partial:
-	return TRACE_TYPE_PARTIAL_LINE;
+	return trace_handle_return(s);
 }
 
 static enum print_line_t trace_print_raw(struct trace_iterator *iter, int flags,
@@ -1223,13 +1141,9 @@ static enum print_line_t trace_print_raw(struct trace_iterator *iter, int flags,
 
 	trace_assign_type(field, iter->ent);
 
-	if (!trace_seq_printf(&iter->seq, "# %lx %s", field->ip, field->buf))
-		goto partial;
-
-	return TRACE_TYPE_HANDLED;
+	trace_seq_printf(&iter->seq, "# %lx %s", field->ip, field->buf);
 
- partial:
-	return TRACE_TYPE_PARTIAL_LINE;
+	return trace_handle_return(&iter->seq);
 }
 
 static struct trace_event_functions trace_print_funcs = {
diff --git a/kernel/trace/trace_output.h b/kernel/trace/trace_output.h
index 80b25b585a70..8ef2c40efb3c 100644
--- a/kernel/trace/trace_output.h
+++ b/kernel/trace/trace_output.h
@@ -35,17 +35,11 @@ trace_print_lat_fmt(struct trace_seq *s, struct trace_entry *entry);
 extern int __unregister_ftrace_event(struct trace_event *event);
 extern struct rw_semaphore trace_event_sem;
 
-#define SEQ_PUT_FIELD_RET(s, x)				\
-do {							\
-	if (!trace_seq_putmem(s, &(x), sizeof(x)))	\
-		return TRACE_TYPE_PARTIAL_LINE;		\
-} while (0)
-
-#define SEQ_PUT_HEX_FIELD_RET(s, x)			\
-do {							\
-	if (!trace_seq_putmem_hex(s, &(x), sizeof(x)))	\
-		return TRACE_TYPE_PARTIAL_LINE;		\
-} while (0)
+#define SEQ_PUT_FIELD(s, x)				\
+	trace_seq_putmem(s, &(x), sizeof(x))
+
+#define SEQ_PUT_HEX_FIELD(s, x)				\
+	trace_seq_putmem_hex(s, &(x), sizeof(x))
 
 #endif
 
-- 
2.1.1


