Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936177Ab3DKVTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:19:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16517 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935469Ab3DKUsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:48:55 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=z6LGWOO2K4UA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=H60ab2H1WnkA:10 a=VwQbUJbxAAAA:8 a=J1Y8HTJGAAAA:8 a=gKvWI1tIjEG3_6-oQF0A:9 a=jeBq3FmKZ4MA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202610.060894585@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:27:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [ 145/171 ] tracing: Prevent buffer overwrite disabled for latency tracers
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0145-tracing-Prevent-buffer-overwrite-disabled-for-latenc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

[ Upstream commit 613f04a0f51e6e68ac6fe571ab79da3c0a5eb4da ]

The latency tracers require the buffers to be in overwrite mode,
otherwise they get screwed up. Force the buffers to stay in overwrite
mode when latency tracers are enabled.

Added a flag_changed() method to the tracer structure to allow
the tracers to see what flags are being changed, and also be able
to prevent the change from happing.

Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c              |   38 +++++++++++++++++++++++++++++++------
 kernel/trace/trace.h              |    6 ++++++
 kernel/trace/trace_irqsoff.c      |   19 ++++++++++++++-----
 kernel/trace/trace_sched_wakeup.c |   18 +++++++++++++-----
 4 files changed, 65 insertions(+), 16 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 1f84103..bf2c50b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2777,11 +2777,25 @@ static int set_tracer_option(struct tracer *trace, char *cmp, int neg)
 	return -EINVAL;
 }
 
-static void set_tracer_flags(unsigned int mask, int enabled)
+/* Some tracers require overwrite to stay enabled */
+int trace_keep_overwrite(struct tracer *tracer, u32 mask, int set)
+{
+	if (tracer->enabled && (mask & TRACE_ITER_OVERWRITE) && !set)
+		return -1;
+
+	return 0;
+}
+
+int set_tracer_flag(unsigned int mask, int enabled)
 {
 	/* do nothing if flag is already set */
 	if (!!(trace_flags & mask) == !!enabled)
-		return;
+		return 0;
+
+	/* Give the tracer a chance to approve the change */
+	if (current_trace->flag_changed)
+		if (current_trace->flag_changed(current_trace, mask, !!enabled))
+			return -EINVAL;
 
 	if (enabled)
 		trace_flags |= mask;
@@ -2797,6 +2811,8 @@ static void set_tracer_flags(unsigned int mask, int enabled)
 		ring_buffer_change_overwrite(max_tr.buffer, enabled);
 #endif
 	}
+
+	return 0;
 }
 
 static ssize_t
@@ -2827,7 +2843,7 @@ tracing_trace_options_write(struct file *filp, const char __user *ubuf,
 
 	for (i = 0; trace_options[i]; i++) {
 		if (strcmp(cmp, trace_options[i]) == 0) {
-			set_tracer_flags(1 << i, !neg);
+			ret = set_tracer_flag(1 << i, !neg);
 			break;
 		}
 	}
@@ -2838,6 +2854,9 @@ tracing_trace_options_write(struct file *filp, const char __user *ubuf,
 
 	mutex_unlock(&trace_types_lock);
 
+	if (ret < 0)
+		return ret;
+
 	*ppos += cnt;
 
 	return cnt;
@@ -3178,8 +3197,11 @@ static int tracing_set_tracer(const char *buf)
 		goto out;
 
 	trace_branch_disable();
-	if (current_trace && current_trace->reset)
-		current_trace->reset(tr);
+	if (current_trace) {
+		current_trace->enabled = false;
+		if (current_trace->reset)
+			current_trace->reset(tr);
+	}
 	if (current_trace && current_trace->use_max_tr) {
 		/*
 		 * We don't free the ring buffer. instead, resize it because
@@ -3215,6 +3237,7 @@ static int tracing_set_tracer(const char *buf)
 	}
 
 	current_trace = t;
+	current_trace->enabled = true;
 	trace_branch_enable(tr);
  out:
 	mutex_unlock(&trace_types_lock);
@@ -4618,9 +4641,12 @@ trace_options_core_write(struct file *filp, const char __user *ubuf, size_t cnt,
 		return -EINVAL;
 
 	mutex_lock(&trace_types_lock);
-	set_tracer_flags(1 << index, val);
+	ret = set_tracer_flag(1 << index, val);
 	mutex_unlock(&trace_types_lock);
 
+	if (ret < 0)
+		return ret;
+
 	*ppos += cnt;
 
 	return cnt;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 55e1f7f..1dd9fe7 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -283,10 +283,14 @@ struct tracer {
 	enum print_line_t	(*print_line)(struct trace_iterator *iter);
 	/* If you handled the flag setting, return 0 */
 	int			(*set_flag)(u32 old_flags, u32 bit, int set);
+	/* Return 0 if OK with change, else return non-zero */
+	int			(*flag_changed)(struct tracer *tracer,
+						u32 mask, int set);
 	struct tracer		*next;
 	struct tracer_flags	*flags;
 	int			print_max;
 	int			use_max_tr;
+	bool			enabled;
 };
 
 
@@ -840,6 +844,8 @@ extern const char *__start___trace_bprintk_fmt[];
 extern const char *__stop___trace_bprintk_fmt[];
 
 void trace_printk_init_buffers(void);
+int trace_keep_overwrite(struct tracer *tracer, u32 mask, int set);
+int set_tracer_flag(unsigned int mask, int enabled);
 
 #undef FTRACE_ENTRY
 #define FTRACE_ENTRY(call, struct_name, id, tstruct, print, filter)	\
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 99d20e9..8dd139a 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -32,7 +32,7 @@ enum {
 
 static int trace_type __read_mostly;
 
-static int save_lat_flag;
+static int save_flags;
 
 static void stop_irqsoff_tracer(struct trace_array *tr, int graph);
 static int start_irqsoff_tracer(struct trace_array *tr, int graph);
@@ -557,8 +557,11 @@ static void stop_irqsoff_tracer(struct trace_array *tr, int graph)
 
 static void __irqsoff_tracer_init(struct trace_array *tr)
 {
-	save_lat_flag = trace_flags & TRACE_ITER_LATENCY_FMT;
-	trace_flags |= TRACE_ITER_LATENCY_FMT;
+	save_flags = trace_flags;
+
+	/* non overwrite screws up the latency tracers */
+	set_tracer_flag(TRACE_ITER_OVERWRITE, 1);
+	set_tracer_flag(TRACE_ITER_LATENCY_FMT, 1);
 
 	tracing_max_latency = 0;
 	irqsoff_trace = tr;
@@ -572,10 +575,13 @@ static void __irqsoff_tracer_init(struct trace_array *tr)
 
 static void irqsoff_tracer_reset(struct trace_array *tr)
 {
+	int lat_flag = save_flags & TRACE_ITER_LATENCY_FMT;
+	int overwrite_flag = save_flags & TRACE_ITER_OVERWRITE;
+
 	stop_irqsoff_tracer(tr, is_graph());
 
-	if (!save_lat_flag)
-		trace_flags &= ~TRACE_ITER_LATENCY_FMT;
+	set_tracer_flag(TRACE_ITER_LATENCY_FMT, lat_flag);
+	set_tracer_flag(TRACE_ITER_OVERWRITE, overwrite_flag);
 }
 
 static void irqsoff_tracer_start(struct trace_array *tr)
@@ -608,6 +614,7 @@ static struct tracer irqsoff_tracer __read_mostly =
 	.print_line     = irqsoff_print_line,
 	.flags		= &tracer_flags,
 	.set_flag	= irqsoff_set_flag,
+	.flag_changed	= trace_keep_overwrite,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_irqsoff,
 #endif
@@ -641,6 +648,7 @@ static struct tracer preemptoff_tracer __read_mostly =
 	.print_line     = irqsoff_print_line,
 	.flags		= &tracer_flags,
 	.set_flag	= irqsoff_set_flag,
+	.flag_changed	= trace_keep_overwrite,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_preemptoff,
 #endif
@@ -676,6 +684,7 @@ static struct tracer preemptirqsoff_tracer __read_mostly =
 	.print_line     = irqsoff_print_line,
 	.flags		= &tracer_flags,
 	.set_flag	= irqsoff_set_flag,
+	.flag_changed	= trace_keep_overwrite,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_preemptirqsoff,
 #endif
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index ff791ea..9eadedc 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -36,7 +36,7 @@ static void __wakeup_reset(struct trace_array *tr);
 static int wakeup_graph_entry(struct ftrace_graph_ent *trace);
 static void wakeup_graph_return(struct ftrace_graph_ret *trace);
 
-static int save_lat_flag;
+static int save_flags;
 
 #define TRACE_DISPLAY_GRAPH     1
 
@@ -539,8 +539,11 @@ static void stop_wakeup_tracer(struct trace_array *tr)
 
 static int __wakeup_tracer_init(struct trace_array *tr)
 {
-	save_lat_flag = trace_flags & TRACE_ITER_LATENCY_FMT;
-	trace_flags |= TRACE_ITER_LATENCY_FMT;
+	save_flags = trace_flags;
+
+	/* non overwrite screws up the latency tracers */
+	set_tracer_flag(TRACE_ITER_OVERWRITE, 1);
+	set_tracer_flag(TRACE_ITER_LATENCY_FMT, 1);
 
 	tracing_max_latency = 0;
 	wakeup_trace = tr;
@@ -562,12 +565,15 @@ static int wakeup_rt_tracer_init(struct trace_array *tr)
 
 static void wakeup_tracer_reset(struct trace_array *tr)
 {
+	int lat_flag = save_flags & TRACE_ITER_LATENCY_FMT;
+	int overwrite_flag = save_flags & TRACE_ITER_OVERWRITE;
+
 	stop_wakeup_tracer(tr);
 	/* make sure we put back any tasks we are tracing */
 	wakeup_reset(tr);
 
-	if (!save_lat_flag)
-		trace_flags &= ~TRACE_ITER_LATENCY_FMT;
+	set_tracer_flag(TRACE_ITER_LATENCY_FMT, lat_flag);
+	set_tracer_flag(TRACE_ITER_OVERWRITE, overwrite_flag);
 }
 
 static void wakeup_tracer_start(struct trace_array *tr)
@@ -593,6 +599,7 @@ static struct tracer wakeup_tracer __read_mostly =
 	.print_line	= wakeup_print_line,
 	.flags		= &tracer_flags,
 	.set_flag	= wakeup_set_flag,
+	.flag_changed	= trace_keep_overwrite,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_wakeup,
 #endif
@@ -614,6 +621,7 @@ static struct tracer wakeup_rt_tracer __read_mostly =
 	.print_line	= wakeup_print_line,
 	.flags		= &tracer_flags,
 	.set_flag	= wakeup_set_flag,
+	.flag_changed	= trace_keep_overwrite,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_wakeup,
 #endif
-- 
1.7.10.4


