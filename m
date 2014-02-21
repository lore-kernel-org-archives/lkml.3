Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbaBUCyA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 21:54:00 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:65361 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753215AbaBUCuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 21:50:05 -0500
Message-Id: <20140221025002.389106025@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 20 Feb 2014 21:49:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH 09/18] ftrace: Allow instances to use function tracing
References: <20140221024906.901631810@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0009-ftrace-Allow-instances-to-use-function-tracing.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Allow instances (sub-buffers) to enable function tracing.
Each instance will have its own function tracing capability.
For now, instances will not have function stack tracing, or will
they be able to pick and choose what functions they can trace.

Picking and choosing their own functions will come later.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h           |   5 ++
 kernel/trace/trace_functions.c | 116 +++++++++++++++++++++++++++--------------
 2 files changed, 81 insertions(+), 40 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 86915b2..35cca05 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -210,6 +210,11 @@ struct trace_array {
 	struct list_head	events;
 	cpumask_var_t		tracing_cpumask; /* only trace on set CPUs */
 	int			ref;
+#ifdef CONFIG_FUNCTION_TRACER
+	struct ftrace_ops	*ops;
+	/* function tracing enabled */
+	int			function_enabled;
+#endif
 };
 
 enum {
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 85e517e..3f8dc1c 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -13,33 +13,83 @@
 #include <linux/debugfs.h>
 #include <linux/uaccess.h>
 #include <linux/ftrace.h>
+#include <linux/slab.h>
 #include <linux/fs.h>
 
 #include "trace.h"
 
-/* function tracing enabled */
-static int			ftrace_function_enabled;
+static void tracing_start_function_trace(struct trace_array *tr);
+static void tracing_stop_function_trace(struct trace_array *tr);
+static void
+function_trace_call(unsigned long ip, unsigned long parent_ip,
+		    struct ftrace_ops *op, struct pt_regs *pt_regs);
+static void
+function_stack_trace_call(unsigned long ip, unsigned long parent_ip,
+			  struct ftrace_ops *op, struct pt_regs *pt_regs);
+static struct ftrace_ops trace_ops;
+static struct ftrace_ops trace_stack_ops;
+static struct tracer_flags func_flags;
+
+/* Our option */
+enum {
+	TRACE_FUNC_OPT_STACK	= 0x1,
+};
+
+static int allocate_ftrace_ops(struct trace_array *tr)
+{
+	struct ftrace_ops *ops;
 
-static struct trace_array	*func_trace;
+	ops = kzalloc(sizeof(*ops), GFP_KERNEL);
+	if (!ops)
+		return -ENOMEM;
 
-static void tracing_start_function_trace(void);
-static void tracing_stop_function_trace(void);
+	/* Currently only the non stack verision is supported */
+	ops->func = function_trace_call;
+	ops->flags = FTRACE_OPS_FL_RECURSION_SAFE;
+
+	tr->ops = ops;
+	ops->private = tr;
+	return 0;
+}
 
 static int function_trace_init(struct trace_array *tr)
 {
-	func_trace = tr;
+	struct ftrace_ops *ops;
+	int ret;
+
+	if (tr->flags & TRACE_ARRAY_FL_GLOBAL) {
+		/* There's only one global tr */
+		if (!trace_ops.private) {
+			trace_ops.private = tr;
+			trace_stack_ops.private = tr;
+		}
+
+		if (func_flags.val & TRACE_FUNC_OPT_STACK)
+			ops = &trace_stack_ops;
+		else
+			ops = &trace_ops;
+		tr->ops = ops;
+	} else {
+		ret = allocate_ftrace_ops(tr);
+		if (ret)
+			return ret;
+	}
+
 	tr->trace_buffer.cpu = get_cpu();
 	put_cpu();
 
 	tracing_start_cmdline_record();
-	tracing_start_function_trace();
+	tracing_start_function_trace(tr);
 	return 0;
 }
 
 static void function_trace_reset(struct trace_array *tr)
 {
-	tracing_stop_function_trace();
+	tracing_stop_function_trace(tr);
 	tracing_stop_cmdline_record();
+	if (!(tr->flags & TRACE_ARRAY_FL_GLOBAL))
+		kfree(tr->ops);
+	tr->ops = NULL;
 }
 
 static void function_trace_start(struct trace_array *tr)
@@ -47,25 +97,18 @@ static void function_trace_start(struct trace_array *tr)
 	tracing_reset_online_cpus(&tr->trace_buffer);
 }
 
-/* Our option */
-enum {
-	TRACE_FUNC_OPT_STACK	= 0x1,
-};
-
-static struct tracer_flags func_flags;
-
 static void
 function_trace_call(unsigned long ip, unsigned long parent_ip,
 		    struct ftrace_ops *op, struct pt_regs *pt_regs)
 {
-	struct trace_array *tr = func_trace;
+	struct trace_array *tr = op->private;
 	struct trace_array_cpu *data;
 	unsigned long flags;
 	int bit;
 	int cpu;
 	int pc;
 
-	if (unlikely(!ftrace_function_enabled))
+	if (unlikely(!tr->function_enabled))
 		return;
 
 	pc = preempt_count();
@@ -91,14 +134,14 @@ static void
 function_stack_trace_call(unsigned long ip, unsigned long parent_ip,
 			  struct ftrace_ops *op, struct pt_regs *pt_regs)
 {
-	struct trace_array *tr = func_trace;
+	struct trace_array *tr = op->private;
 	struct trace_array_cpu *data;
 	unsigned long flags;
 	long disabled;
 	int cpu;
 	int pc;
 
-	if (unlikely(!ftrace_function_enabled))
+	if (unlikely(!tr->function_enabled))
 		return;
 
 	/*
@@ -128,7 +171,6 @@ function_stack_trace_call(unsigned long ip, unsigned long parent_ip,
 	local_irq_restore(flags);
 }
 
-
 static struct ftrace_ops trace_ops __read_mostly =
 {
 	.func = function_trace_call,
@@ -153,26 +195,17 @@ static struct tracer_flags func_flags = {
 	.opts = func_opts
 };
 
-static void tracing_start_function_trace(void)
+static void tracing_start_function_trace(struct trace_array *tr)
 {
-	ftrace_function_enabled = 0;
-
-	if (func_flags.val & TRACE_FUNC_OPT_STACK)
-		register_ftrace_function(&trace_stack_ops);
-	else
-		register_ftrace_function(&trace_ops);
-
-	ftrace_function_enabled = 1;
+	tr->function_enabled = 0;
+	register_ftrace_function(tr->ops);
+	tr->function_enabled = 1;
 }
 
-static void tracing_stop_function_trace(void)
+static void tracing_stop_function_trace(struct trace_array *tr)
 {
-	ftrace_function_enabled = 0;
-
-	if (func_flags.val & TRACE_FUNC_OPT_STACK)
-		unregister_ftrace_function(&trace_stack_ops);
-	else
-		unregister_ftrace_function(&trace_ops);
+	tr->function_enabled = 0;
+	unregister_ftrace_function(tr->ops);
 }
 
 static int
@@ -184,12 +217,14 @@ func_set_flag(struct trace_array *tr, u32 old_flags, u32 bit, int set)
 		if (!!set == !!(func_flags.val & TRACE_FUNC_OPT_STACK))
 			break;
 
+		unregister_ftrace_function(tr->ops);
+
 		if (set) {
-			unregister_ftrace_function(&trace_ops);
-			register_ftrace_function(&trace_stack_ops);
+			tr->ops = &trace_stack_ops;
+			register_ftrace_function(tr->ops);
 		} else {
-			unregister_ftrace_function(&trace_stack_ops);
-			register_ftrace_function(&trace_ops);
+			tr->ops = &trace_ops;
+			register_ftrace_function(tr->ops);
 		}
 
 		break;
@@ -209,6 +244,7 @@ static struct tracer function_trace __tracer_data =
 	.wait_pipe	= poll_wait_pipe,
 	.flags		= &func_flags,
 	.set_flag	= func_set_flag,
+	.allow_instances = true,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest	= trace_selftest_startup_function,
 #endif
-- 
1.8.5.3


