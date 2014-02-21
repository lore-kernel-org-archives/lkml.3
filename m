Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbaBUCzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 21:55:43 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:3567 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753194AbaBUCuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 21:50:04 -0500
Message-Id: <20140221025001.045878429@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 20 Feb 2014 21:49:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH 01/18] tracing: Pass trace_array to set_flag callback
References: <20140221024906.901631810@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0001-tracing-Pass-trace_array-to-set_flag-callback.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

As options (flags) may affect instances instead of being global
the set_flag() callbacks need to receive the trace_array descriptor
of the instance they will be modifying.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/blktrace.c              |  3 ++-
 kernel/trace/trace.c                 | 18 ++++++++++--------
 kernel/trace/trace.h                 |  3 ++-
 kernel/trace/trace_functions.c       |  3 ++-
 kernel/trace/trace_functions_graph.c |  3 ++-
 kernel/trace/trace_irqsoff.c         |  6 ++++--
 kernel/trace/trace_nop.c             |  2 +-
 kernel/trace/trace_sched_wakeup.c    |  6 ++++--
 8 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index b418cb0..0d758ca 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1427,7 +1427,8 @@ static enum print_line_t blk_tracer_print_line(struct trace_iterator *iter)
 	return print_one_line(iter, true);
 }
 
-static int blk_tracer_set_flag(u32 old_flags, u32 bit, int set)
+static int
+blk_tracer_set_flag(struct trace_array *tr, u32 old_flags, u32 bit, int set)
 {
 	/* don't output context-info for blk_classic output */
 	if (bit == TRACE_BLK_OPT_CLASSIC) {
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 815c878..d7dfc7e 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -73,7 +73,8 @@ static struct tracer_flags dummy_tracer_flags = {
 	.opts = dummy_tracer_opt
 };
 
-static int dummy_set_flag(u32 old_flags, u32 bit, int set)
+static int
+dummy_set_flag(struct trace_array *tr, u32 old_flags, u32 bit, int set)
 {
 	return 0;
 }
@@ -3339,13 +3340,14 @@ static int tracing_trace_options_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int __set_tracer_option(struct tracer *trace,
+static int __set_tracer_option(struct trace_array *tr,
 			       struct tracer_flags *tracer_flags,
 			       struct tracer_opt *opts, int neg)
 {
+	struct tracer *trace = tr->current_trace;
 	int ret;
 
-	ret = trace->set_flag(tracer_flags->val, opts->bit, !neg);
+	ret = trace->set_flag(tr, tracer_flags->val, opts->bit, !neg);
 	if (ret)
 		return ret;
 
@@ -3357,8 +3359,9 @@ static int __set_tracer_option(struct tracer *trace,
 }
 
 /* Try to assign a tracer specific option */
-static int set_tracer_option(struct tracer *trace, char *cmp, int neg)
+static int set_tracer_option(struct trace_array *tr, char *cmp, int neg)
 {
+	struct tracer *trace = tr->current_trace;
 	struct tracer_flags *tracer_flags = trace->flags;
 	struct tracer_opt *opts = NULL;
 	int i;
@@ -3367,8 +3370,7 @@ static int set_tracer_option(struct tracer *trace, char *cmp, int neg)
 		opts = &tracer_flags->opts[i];
 
 		if (strcmp(cmp, opts->name) == 0)
-			return __set_tracer_option(trace, trace->flags,
-						   opts, neg);
+			return __set_tracer_option(tr, trace->flags, opts, neg);
 	}
 
 	return -EINVAL;
@@ -3440,7 +3442,7 @@ static int trace_set_options(struct trace_array *tr, char *option)
 
 	/* If no option could be set, test the specific tracer options */
 	if (!trace_options[i])
-		ret = set_tracer_option(tr->current_trace, cmp, neg);
+		ret = set_tracer_option(tr, cmp, neg);
 
 	mutex_unlock(&trace_types_lock);
 
@@ -5689,7 +5691,7 @@ trace_options_write(struct file *filp, const char __user *ubuf, size_t cnt,
 
 	if (!!(topt->flags->val & topt->opt->bit) != val) {
 		mutex_lock(&trace_types_lock);
-		ret = __set_tracer_option(topt->tr->current_trace, topt->flags,
+		ret = __set_tracer_option(topt->tr, topt->flags,
 					  topt->opt, !val);
 		mutex_unlock(&trace_types_lock);
 		if (ret)
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 02b592f..649a23d 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -355,7 +355,8 @@ struct tracer {
 	void			(*print_header)(struct seq_file *m);
 	enum print_line_t	(*print_line)(struct trace_iterator *iter);
 	/* If you handled the flag setting, return 0 */
-	int			(*set_flag)(u32 old_flags, u32 bit, int set);
+	int			(*set_flag)(struct trace_array *tr,
+					    u32 old_flags, u32 bit, int set);
 	/* Return 0 if OK with change, else return non-zero */
 	int			(*flag_changed)(struct tracer *tracer,
 						u32 mask, int set);
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 38fe148..85e517e 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -175,7 +175,8 @@ static void tracing_stop_function_trace(void)
 		unregister_ftrace_function(&trace_ops);
 }
 
-static int func_set_flag(u32 old_flags, u32 bit, int set)
+static int
+func_set_flag(struct trace_array *tr, u32 old_flags, u32 bit, int set)
 {
 	switch (bit) {
 	case TRACE_FUNC_OPT_STACK:
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 0b99120..deff112 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -1476,7 +1476,8 @@ void graph_trace_close(struct trace_iterator *iter)
 	}
 }
 
-static int func_graph_set_flag(u32 old_flags, u32 bit, int set)
+static int
+func_graph_set_flag(struct trace_array *tr, u32 old_flags, u32 bit, int set)
 {
 	if (bit == TRACE_GRAPH_PRINT_IRQS)
 		ftrace_graph_skip_irqs = !set;
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 2aefbee..fd99b0c 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -160,7 +160,8 @@ static struct ftrace_ops trace_ops __read_mostly =
 #endif /* CONFIG_FUNCTION_TRACER */
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-static int irqsoff_set_flag(u32 old_flags, u32 bit, int set)
+static int
+irqsoff_set_flag(struct trace_array *tr, u32 old_flags, u32 bit, int set)
 {
 	int cpu;
 
@@ -266,7 +267,8 @@ __trace_function(struct trace_array *tr,
 #else
 #define __trace_function trace_function
 
-static int irqsoff_set_flag(u32 old_flags, u32 bit, int set)
+static int
+irqsoff_set_flag(struct trace_array *tr, u32 old_flags, u32 bit, int set)
 {
 	return -EINVAL;
 }
diff --git a/kernel/trace/trace_nop.c b/kernel/trace/trace_nop.c
index 394f944..f398409 100644
--- a/kernel/trace/trace_nop.c
+++ b/kernel/trace/trace_nop.c
@@ -62,7 +62,7 @@ static void nop_trace_reset(struct trace_array *tr)
  * If you don't implement it, then the flag setting will be
  * automatically accepted.
  */
-static int nop_set_flag(u32 old_flags, u32 bit, int set)
+static int nop_set_flag(struct trace_array *tr, u32 old_flags, u32 bit, int set)
 {
 	/*
 	 * Note that you don't need to update nop_flags.val yourself.
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 6e32635..f0bbdc2 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -209,7 +209,8 @@ static void stop_func_tracer(int graph)
 }
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-static int wakeup_set_flag(u32 old_flags, u32 bit, int set)
+static int
+wakeup_set_flag(struct trace_array *tr, u32 old_flags, u32 bit, int set)
 {
 
 	if (!(bit & TRACE_DISPLAY_GRAPH))
@@ -311,7 +312,8 @@ __trace_function(struct trace_array *tr,
 #else
 #define __trace_function trace_function
 
-static int wakeup_set_flag(u32 old_flags, u32 bit, int set)
+static int
+wakeup_set_flag(struct trace_array *tr, u32 old_flags, u32 bit, int set)
 {
 	return -EINVAL;
 }
-- 
1.8.5.3


