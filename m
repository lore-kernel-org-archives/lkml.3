Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631AbaDXQD2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:03:28 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:34376 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758127AbaDXQDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:03:21 -0400
Message-Id: <20140424160319.770502479@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 24 Apr 2014 12:02:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 1/8] ftrace: Remove global function list and call function directly
References: <20140424160232.271454710@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0001-ftrace-Remove-global-function-list-and-call-function.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Instead of having a list of global functions that are called,
as only one global function is allow to be enabled at a time, there's
no reason to have a list.

Instead, simply have all the users of the global ops, use the global ops
directly, instead of registering their own ftrace_ops. Just switch what
function is used before enabling the function tracer.

This removes a lot of code as well as the complexity involved with it.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h            |  20 ++---
 kernel/trace/ftrace.c             | 152 +++++++++++---------------------------
 kernel/trace/trace.c              |   2 +
 kernel/trace/trace.h              |  19 +++--
 kernel/trace/trace_functions.c    |  55 +++++---------
 kernel/trace/trace_irqsoff.c      |  33 ++++-----
 kernel/trace/trace_sched_wakeup.c |  40 +++++-----
 kernel/trace/trace_selftest.c     |  33 +++++----
 8 files changed, 133 insertions(+), 221 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 9212b01..f0ff2c2 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -62,9 +62,6 @@ typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip,
  * set in the flags member.
  *
  * ENABLED - set/unset when ftrace_ops is registered/unregistered
- * GLOBAL  - set manualy by ftrace_ops user to denote the ftrace_ops
- *           is part of the global tracers sharing the same filter
- *           via set_ftrace_* debugfs files.
  * DYNAMIC - set when ftrace_ops is registered to denote dynamically
  *           allocated ftrace_ops which need special care
  * CONTROL - set manualy by ftrace_ops user to denote the ftrace_ops
@@ -96,15 +93,14 @@ typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip,
  */
 enum {
 	FTRACE_OPS_FL_ENABLED			= 1 << 0,
-	FTRACE_OPS_FL_GLOBAL			= 1 << 1,
-	FTRACE_OPS_FL_DYNAMIC			= 1 << 2,
-	FTRACE_OPS_FL_CONTROL			= 1 << 3,
-	FTRACE_OPS_FL_SAVE_REGS			= 1 << 4,
-	FTRACE_OPS_FL_SAVE_REGS_IF_SUPPORTED	= 1 << 5,
-	FTRACE_OPS_FL_RECURSION_SAFE		= 1 << 6,
-	FTRACE_OPS_FL_STUB			= 1 << 7,
-	FTRACE_OPS_FL_INITIALIZED		= 1 << 8,
-	FTRACE_OPS_FL_DELETED			= 1 << 9,
+	FTRACE_OPS_FL_DYNAMIC			= 1 << 1,
+	FTRACE_OPS_FL_CONTROL			= 1 << 2,
+	FTRACE_OPS_FL_SAVE_REGS			= 1 << 3,
+	FTRACE_OPS_FL_SAVE_REGS_IF_SUPPORTED	= 1 << 4,
+	FTRACE_OPS_FL_RECURSION_SAFE		= 1 << 5,
+	FTRACE_OPS_FL_STUB			= 1 << 6,
+	FTRACE_OPS_FL_INITIALIZED		= 1 << 7,
+	FTRACE_OPS_FL_DELETED			= 1 << 8,
 };
 
 /*
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 1fd4b94..8f61ef7 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -62,7 +62,7 @@
 #define FTRACE_HASH_DEFAULT_BITS 10
 #define FTRACE_HASH_MAX_BITS 12
 
-#define FL_GLOBAL_CONTROL_MASK (FTRACE_OPS_FL_GLOBAL | FTRACE_OPS_FL_CONTROL)
+#define FL_GLOBAL_CONTROL_MASK (FTRACE_OPS_FL_CONTROL)
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 #define INIT_REGEX_LOCK(opsname)	\
@@ -103,7 +103,6 @@ static int ftrace_disabled __read_mostly;
 
 static DEFINE_MUTEX(ftrace_lock);
 
-static struct ftrace_ops *ftrace_global_list __read_mostly = &ftrace_list_end;
 static struct ftrace_ops *ftrace_control_list __read_mostly = &ftrace_list_end;
 static struct ftrace_ops *ftrace_ops_list __read_mostly = &ftrace_list_end;
 ftrace_func_t ftrace_trace_function __read_mostly = ftrace_stub;
@@ -171,23 +170,6 @@ int ftrace_nr_registered_ops(void)
 	return cnt;
 }
 
-static void
-ftrace_global_list_func(unsigned long ip, unsigned long parent_ip,
-			struct ftrace_ops *op, struct pt_regs *regs)
-{
-	int bit;
-
-	bit = trace_test_and_set_recursion(TRACE_GLOBAL_START, TRACE_GLOBAL_MAX);
-	if (bit < 0)
-		return;
-
-	do_for_each_ftrace_op(op, ftrace_global_list) {
-		op->func(ip, parent_ip, op, regs);
-	} while_for_each_ftrace_op(op);
-
-	trace_clear_recursion(bit);
-}
-
 static void ftrace_pid_func(unsigned long ip, unsigned long parent_ip,
 			    struct ftrace_ops *op, struct pt_regs *regs)
 {
@@ -237,43 +219,6 @@ static int control_ops_alloc(struct ftrace_ops *ops)
 	return 0;
 }
 
-static void update_global_ops(void)
-{
-	ftrace_func_t func = ftrace_global_list_func;
-	void *private = NULL;
-
-	/* The list has its own recursion protection. */
-	global_ops.flags |= FTRACE_OPS_FL_RECURSION_SAFE;
-
-	/*
-	 * If there's only one function registered, then call that
-	 * function directly. Otherwise, we need to iterate over the
-	 * registered callers.
-	 */
-	if (ftrace_global_list == &ftrace_list_end ||
-	    ftrace_global_list->next == &ftrace_list_end) {
-		func = ftrace_global_list->func;
-		private = ftrace_global_list->private;
-		/*
-		 * As we are calling the function directly.
-		 * If it does not have recursion protection,
-		 * the function_trace_op needs to be updated
-		 * accordingly.
-		 */
-		if (!(ftrace_global_list->flags & FTRACE_OPS_FL_RECURSION_SAFE))
-			global_ops.flags &= ~FTRACE_OPS_FL_RECURSION_SAFE;
-	}
-
-	/* If we filter on pids, update to use the pid function */
-	if (!list_empty(&ftrace_pids)) {
-		set_ftrace_pid_function(func);
-		func = ftrace_pid_func;
-	}
-
-	global_ops.func = func;
-	global_ops.private = private;
-}
-
 static void ftrace_sync(struct work_struct *work)
 {
 	/*
@@ -301,8 +246,6 @@ static void update_ftrace_function(void)
 {
 	ftrace_func_t func;
 
-	update_global_ops();
-
 	/*
 	 * If we are at the end of the list and this ops is
 	 * recursion safe and not dynamic and the arch supports passing ops,
@@ -314,10 +257,7 @@ static void update_ftrace_function(void)
 	     (ftrace_ops_list->flags & FTRACE_OPS_FL_RECURSION_SAFE) &&
 	     !FTRACE_FORCE_LIST_FUNC)) {
 		/* Set the ftrace_ops that the arch callback uses */
-		if (ftrace_ops_list == &global_ops)
-			set_function_trace_op = ftrace_global_list;
-		else
-			set_function_trace_op = ftrace_ops_list;
+		set_function_trace_op = ftrace_ops_list;
 		func = ftrace_ops_list->func;
 	} else {
 		/* Just use the default ftrace_ops */
@@ -434,16 +374,9 @@ static int __register_ftrace_function(struct ftrace_ops *ops)
 	if (ops->flags & FTRACE_OPS_FL_DELETED)
 		return -EINVAL;
 
-	if (FTRACE_WARN_ON(ops == &global_ops))
-		return -EINVAL;
-
 	if (WARN_ON(ops->flags & FTRACE_OPS_FL_ENABLED))
 		return -EBUSY;
 
-	/* We don't support both control and global flags set. */
-	if ((ops->flags & FL_GLOBAL_CONTROL_MASK) == FL_GLOBAL_CONTROL_MASK)
-		return -EINVAL;
-
 #ifndef CONFIG_DYNAMIC_FTRACE_WITH_REGS
 	/*
 	 * If the ftrace_ops specifies SAVE_REGS, then it only can be used
@@ -461,10 +394,7 @@ static int __register_ftrace_function(struct ftrace_ops *ops)
 	if (!core_kernel_data((unsigned long)ops))
 		ops->flags |= FTRACE_OPS_FL_DYNAMIC;
 
-	if (ops->flags & FTRACE_OPS_FL_GLOBAL) {
-		add_ftrace_list_ops(&ftrace_global_list, &global_ops, ops);
-		ops->flags |= FTRACE_OPS_FL_ENABLED;
-	} else if (ops->flags & FTRACE_OPS_FL_CONTROL) {
+	if (ops->flags & FTRACE_OPS_FL_CONTROL) {
 		if (control_ops_alloc(ops))
 			return -ENOMEM;
 		add_ftrace_list_ops(&ftrace_control_list, &control_ops, ops);
@@ -484,15 +414,7 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
 	if (WARN_ON(!(ops->flags & FTRACE_OPS_FL_ENABLED)))
 		return -EBUSY;
 
-	if (FTRACE_WARN_ON(ops == &global_ops))
-		return -EINVAL;
-
-	if (ops->flags & FTRACE_OPS_FL_GLOBAL) {
-		ret = remove_ftrace_list_ops(&ftrace_global_list,
-					     &global_ops, ops);
-		if (!ret)
-			ops->flags &= ~FTRACE_OPS_FL_ENABLED;
-	} else if (ops->flags & FTRACE_OPS_FL_CONTROL) {
+	if (ops->flags & FTRACE_OPS_FL_CONTROL) {
 		ret = remove_ftrace_list_ops(&ftrace_control_list,
 					     &control_ops, ops);
 	} else
@@ -2128,15 +2050,6 @@ static int ftrace_startup(struct ftrace_ops *ops, int command)
 	ftrace_start_up++;
 	command |= FTRACE_UPDATE_CALLS;
 
-	/* ops marked global share the filter hashes */
-	if (ops->flags & FTRACE_OPS_FL_GLOBAL) {
-		ops = &global_ops;
-		/* Don't update hash if global is already set */
-		if (global_start_up)
-			hash_enable = false;
-		global_start_up++;
-	}
-
 	ops->flags |= FTRACE_OPS_FL_ENABLED;
 	if (hash_enable)
 		ftrace_hash_rec_enable(ops, 1);
@@ -2166,21 +2079,10 @@ static int ftrace_shutdown(struct ftrace_ops *ops, int command)
 	 */
 	WARN_ON_ONCE(ftrace_start_up < 0);
 
-	if (ops->flags & FTRACE_OPS_FL_GLOBAL) {
-		ops = &global_ops;
-		global_start_up--;
-		WARN_ON_ONCE(global_start_up < 0);
-		/* Don't update hash if global still has users */
-		if (global_start_up) {
-			WARN_ON_ONCE(!ftrace_start_up);
-			hash_disable = false;
-		}
-	}
-
 	if (hash_disable)
 		ftrace_hash_rec_disable(ops, 1);
 
-	if (ops != &global_ops || !global_start_up)
+	if (!global_start_up)
 		ops->flags &= ~FTRACE_OPS_FL_ENABLED;
 
 	command |= FTRACE_UPDATE_CALLS;
@@ -3524,10 +3426,6 @@ ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
 	struct ftrace_hash *hash;
 	int ret;
 
-	/* All global ops uses the global ops filters */
-	if (ops->flags & FTRACE_OPS_FL_GLOBAL)
-		ops = &global_ops;
-
 	if (unlikely(ftrace_disabled))
 		return -ENODEV;
 
@@ -4462,6 +4360,34 @@ ftrace_ops_test(struct ftrace_ops *ops, unsigned long ip, void *regs)
 
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
+__init void ftrace_init_global_array_ops(struct trace_array *tr)
+{
+	tr->ops = &global_ops;
+	tr->ops->private = tr;
+}
+
+void ftrace_init_array_ops(struct trace_array *tr, ftrace_func_t func)
+{
+	/* If we filter on pids, update to use the pid function */
+	if (tr->flags & TRACE_ARRAY_FL_GLOBAL) {
+		if (WARN_ON(tr->ops->func != ftrace_stub))
+			printk("ftrace ops had %pS for function\n",
+			       tr->ops->func);
+		/* Only the top level instance does pid tracing */
+		if (!list_empty(&ftrace_pids)) {
+			set_ftrace_pid_function(func);
+			func = ftrace_pid_func;
+		}
+	}
+	tr->ops->func = func;
+	tr->ops->private = tr;
+}
+
+void ftrace_reset_array_ops(struct trace_array *tr)
+{
+	tr->ops->func = ftrace_stub;
+}
+
 static void
 ftrace_ops_control_func(unsigned long ip, unsigned long parent_ip,
 			struct ftrace_ops *op, struct pt_regs *regs)
@@ -4520,9 +4446,16 @@ __ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
 	 */
 	preempt_disable_notrace();
 	do_for_each_ftrace_op(op, ftrace_ops_list) {
-		if (ftrace_ops_test(op, ip, regs))
+		if (ftrace_ops_test(op, ip, regs)) {
+			if (WARN_ON(!op->func)) {
+				function_trace_stop = 1;
+				printk("op=%p %pS\n", op, op);
+				goto out;
+			}
 			op->func(ip, parent_ip, op, regs);
+		}
 	} while_for_each_ftrace_op(op);
+out:
 	preempt_enable_notrace();
 	trace_clear_recursion(bit);
 }
@@ -5076,8 +5009,7 @@ ftrace_suspend_notifier_call(struct notifier_block *bl, unsigned long state,
 /* Just a place holder for function graph */
 static struct ftrace_ops fgraph_ops __read_mostly = {
 	.func		= ftrace_stub,
-	.flags		= FTRACE_OPS_FL_STUB | FTRACE_OPS_FL_GLOBAL |
-				FTRACE_OPS_FL_RECURSION_SAFE,
+	.flags		= FTRACE_OPS_FL_STUB | FTRACE_OPS_FL_RECURSION_SAFE,
 };
 
 static int ftrace_graph_entry_test(struct ftrace_graph_ent *trace)
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 737b0ef..fdd33aa 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6629,6 +6629,8 @@ __init static int tracer_alloc_buffers(void)
 	 */
 	global_trace.current_trace = &nop_trace;
 
+	ftrace_init_global_array_ops(&global_trace);
+
 	register_tracer(&nop_trace);
 
 	/* All seems OK, enable tracing */
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 2e29d7b..df5256b 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -416,13 +416,7 @@ enum {
 	TRACE_FTRACE_IRQ_BIT,
 	TRACE_FTRACE_SIRQ_BIT,
 
-	/* GLOBAL_BITs must be greater than FTRACE_BITs */
-	TRACE_GLOBAL_BIT,
-	TRACE_GLOBAL_NMI_BIT,
-	TRACE_GLOBAL_IRQ_BIT,
-	TRACE_GLOBAL_SIRQ_BIT,
-
-	/* INTERNAL_BITs must be greater than GLOBAL_BITs */
+	/* INTERNAL_BITs must be greater than FTRACE_BITs */
 	TRACE_INTERNAL_BIT,
 	TRACE_INTERNAL_NMI_BIT,
 	TRACE_INTERNAL_IRQ_BIT,
@@ -449,9 +443,6 @@ enum {
 #define TRACE_FTRACE_START	TRACE_FTRACE_BIT
 #define TRACE_FTRACE_MAX	((1 << (TRACE_FTRACE_START + TRACE_CONTEXT_BITS)) - 1)
 
-#define TRACE_GLOBAL_START	TRACE_GLOBAL_BIT
-#define TRACE_GLOBAL_MAX	((1 << (TRACE_GLOBAL_START + TRACE_CONTEXT_BITS)) - 1)
-
 #define TRACE_LIST_START	TRACE_INTERNAL_BIT
 #define TRACE_LIST_MAX		((1 << (TRACE_LIST_START + TRACE_CONTEXT_BITS)) - 1)
 
@@ -823,6 +814,9 @@ extern int ftrace_is_dead(void);
 int ftrace_create_function_files(struct trace_array *tr,
 				 struct dentry *parent);
 void ftrace_destroy_function_files(struct trace_array *tr);
+void ftrace_init_global_array_ops(struct trace_array *tr);
+void ftrace_init_array_ops(struct trace_array *tr, ftrace_func_t func);
+void ftrace_reset_array_ops(struct trace_array *tr);
 #else
 static inline int ftrace_trace_task(struct task_struct *task)
 {
@@ -836,6 +830,11 @@ ftrace_create_function_files(struct trace_array *tr,
 	return 0;
 }
 static inline void ftrace_destroy_function_files(struct trace_array *tr) { }
+static inline __init void
+ftrace_init_global_array_ops(struct trace_array *tr) { }
+static inline void ftrace_reset_array_ops(struct trace_array *tr) { }
+/* ftace_func_t type is not defined, use macro instead of static inline */
+#define ftrace_init_array_ops(tr, func) do { } while (0)
 #endif /* CONFIG_FUNCTION_TRACER */
 
 #if defined(CONFIG_FUNCTION_TRACER) && defined(CONFIG_DYNAMIC_FTRACE)
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index ffd5635..2d9482b 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -26,8 +26,6 @@ function_trace_call(unsigned long ip, unsigned long parent_ip,
 static void
 function_stack_trace_call(unsigned long ip, unsigned long parent_ip,
 			  struct ftrace_ops *op, struct pt_regs *pt_regs);
-static struct ftrace_ops trace_ops;
-static struct ftrace_ops trace_stack_ops;
 static struct tracer_flags func_flags;
 
 /* Our option */
@@ -83,28 +81,24 @@ void ftrace_destroy_function_files(struct trace_array *tr)
 
 static int function_trace_init(struct trace_array *tr)
 {
-	struct ftrace_ops *ops;
-
-	if (tr->flags & TRACE_ARRAY_FL_GLOBAL) {
-		/* There's only one global tr */
-		if (!trace_ops.private) {
-			trace_ops.private = tr;
-			trace_stack_ops.private = tr;
-		}
+	ftrace_func_t func;
 
-		if (func_flags.val & TRACE_FUNC_OPT_STACK)
-			ops = &trace_stack_ops;
-		else
-			ops = &trace_ops;
-		tr->ops = ops;
-	} else if (!tr->ops) {
-		/*
-		 * Instance trace_arrays get their ops allocated
-		 * at instance creation. Unless it failed
-		 * the allocation.
-		 */
+	/*
+	 * Instance trace_arrays get their ops allocated
+	 * at instance creation. Unless it failed
+	 * the allocation.
+	 */
+	if (!tr->ops)
 		return -ENOMEM;
-	}
+
+	/* Currently only the global instance can do stack tracing */
+	if (tr->flags & TRACE_ARRAY_FL_GLOBAL &&
+	    func_flags.val & TRACE_FUNC_OPT_STACK)
+		func = function_stack_trace_call;
+	else
+		func = function_trace_call;
+
+	ftrace_init_array_ops(tr, func);
 
 	tr->trace_buffer.cpu = get_cpu();
 	put_cpu();
@@ -118,6 +112,7 @@ static void function_trace_reset(struct trace_array *tr)
 {
 	tracing_stop_function_trace(tr);
 	tracing_stop_cmdline_record();
+	ftrace_reset_array_ops(tr);
 }
 
 static void function_trace_start(struct trace_array *tr)
@@ -199,18 +194,6 @@ function_stack_trace_call(unsigned long ip, unsigned long parent_ip,
 	local_irq_restore(flags);
 }
 
-static struct ftrace_ops trace_ops __read_mostly =
-{
-	.func = function_trace_call,
-	.flags = FTRACE_OPS_FL_GLOBAL | FTRACE_OPS_FL_RECURSION_SAFE,
-};
-
-static struct ftrace_ops trace_stack_ops __read_mostly =
-{
-	.func = function_stack_trace_call,
-	.flags = FTRACE_OPS_FL_GLOBAL | FTRACE_OPS_FL_RECURSION_SAFE,
-};
-
 static struct tracer_opt func_opts[] = {
 #ifdef CONFIG_STACKTRACE
 	{ TRACER_OPT(func_stack_trace, TRACE_FUNC_OPT_STACK) },
@@ -248,10 +231,10 @@ func_set_flag(struct trace_array *tr, u32 old_flags, u32 bit, int set)
 		unregister_ftrace_function(tr->ops);
 
 		if (set) {
-			tr->ops = &trace_stack_ops;
+			tr->ops->func = function_stack_trace_call;
 			register_ftrace_function(tr->ops);
 		} else {
-			tr->ops = &trace_ops;
+			tr->ops->func = function_trace_call;
 			register_ftrace_function(tr->ops);
 		}
 
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 8ff02cb..b5cb047 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -151,12 +151,6 @@ irqsoff_tracer_call(unsigned long ip, unsigned long parent_ip,
 
 	atomic_dec(&data->disabled);
 }
-
-static struct ftrace_ops trace_ops __read_mostly =
-{
-	.func = irqsoff_tracer_call,
-	.flags = FTRACE_OPS_FL_GLOBAL | FTRACE_OPS_FL_RECURSION_SAFE,
-};
 #endif /* CONFIG_FUNCTION_TRACER */
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
@@ -531,7 +525,7 @@ void trace_preempt_off(unsigned long a0, unsigned long a1)
 }
 #endif /* CONFIG_PREEMPT_TRACER */
 
-static int register_irqsoff_function(int graph, int set)
+static int register_irqsoff_function(struct trace_array *tr, int graph, int set)
 {
 	int ret;
 
@@ -543,7 +537,7 @@ static int register_irqsoff_function(int graph, int set)
 		ret = register_ftrace_graph(&irqsoff_graph_return,
 					    &irqsoff_graph_entry);
 	else
-		ret = register_ftrace_function(&trace_ops);
+		ret = register_ftrace_function(tr->ops);
 
 	if (!ret)
 		function_enabled = true;
@@ -551,7 +545,7 @@ static int register_irqsoff_function(int graph, int set)
 	return ret;
 }
 
-static void unregister_irqsoff_function(int graph)
+static void unregister_irqsoff_function(struct trace_array *tr, int graph)
 {
 	if (!function_enabled)
 		return;
@@ -559,17 +553,17 @@ static void unregister_irqsoff_function(int graph)
 	if (graph)
 		unregister_ftrace_graph();
 	else
-		unregister_ftrace_function(&trace_ops);
+		unregister_ftrace_function(tr->ops);
 
 	function_enabled = false;
 }
 
-static void irqsoff_function_set(int set)
+static void irqsoff_function_set(struct trace_array *tr, int set)
 {
 	if (set)
-		register_irqsoff_function(is_graph(), 1);
+		register_irqsoff_function(tr, is_graph(), 1);
 	else
-		unregister_irqsoff_function(is_graph());
+		unregister_irqsoff_function(tr, is_graph());
 }
 
 static int irqsoff_flag_changed(struct trace_array *tr, u32 mask, int set)
@@ -577,7 +571,7 @@ static int irqsoff_flag_changed(struct trace_array *tr, u32 mask, int set)
 	struct tracer *tracer = tr->current_trace;
 
 	if (mask & TRACE_ITER_FUNCTION)
-		irqsoff_function_set(set);
+		irqsoff_function_set(tr, set);
 
 	return trace_keep_overwrite(tracer, mask, set);
 }
@@ -586,7 +580,7 @@ static int start_irqsoff_tracer(struct trace_array *tr, int graph)
 {
 	int ret;
 
-	ret = register_irqsoff_function(graph, 0);
+	ret = register_irqsoff_function(tr, graph, 0);
 
 	if (!ret && tracing_is_enabled())
 		tracer_enabled = 1;
@@ -600,7 +594,7 @@ static void stop_irqsoff_tracer(struct trace_array *tr, int graph)
 {
 	tracer_enabled = 0;
 
-	unregister_irqsoff_function(graph);
+	unregister_irqsoff_function(tr, graph);
 }
 
 static void __irqsoff_tracer_init(struct trace_array *tr)
@@ -617,7 +611,11 @@ static void __irqsoff_tracer_init(struct trace_array *tr)
 	smp_wmb();
 	tracing_reset_online_cpus(&tr->trace_buffer);
 
-	if (start_irqsoff_tracer(tr, is_graph()))
+	ftrace_init_array_ops(tr, irqsoff_tracer_call);
+
+	/* Only toplevel instance supports graph tracing */
+	if (start_irqsoff_tracer(tr, (tr->flags & TRACE_ARRAY_FL_GLOBAL &&
+				      is_graph())))
 		printk(KERN_ERR "failed to start irqsoff tracer\n");
 }
 
@@ -630,6 +628,7 @@ static void irqsoff_tracer_reset(struct trace_array *tr)
 
 	set_tracer_flag(tr, TRACE_ITER_LATENCY_FMT, lat_flag);
 	set_tracer_flag(tr, TRACE_ITER_OVERWRITE, overwrite_flag);
+	ftrace_reset_array_ops(tr);
 }
 
 static void irqsoff_tracer_start(struct trace_array *tr)
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index e14da5e..4dd986d 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -130,15 +130,9 @@ wakeup_tracer_call(unsigned long ip, unsigned long parent_ip,
 	atomic_dec(&data->disabled);
 	preempt_enable_notrace();
 }
-
-static struct ftrace_ops trace_ops __read_mostly =
-{
-	.func = wakeup_tracer_call,
-	.flags = FTRACE_OPS_FL_GLOBAL | FTRACE_OPS_FL_RECURSION_SAFE,
-};
 #endif /* CONFIG_FUNCTION_TRACER */
 
-static int register_wakeup_function(int graph, int set)
+static int register_wakeup_function(struct trace_array *tr, int graph, int set)
 {
 	int ret;
 
@@ -150,7 +144,7 @@ static int register_wakeup_function(int graph, int set)
 		ret = register_ftrace_graph(&wakeup_graph_return,
 					    &wakeup_graph_entry);
 	else
-		ret = register_ftrace_function(&trace_ops);
+		ret = register_ftrace_function(tr->ops);
 
 	if (!ret)
 		function_enabled = true;
@@ -158,7 +152,7 @@ static int register_wakeup_function(int graph, int set)
 	return ret;
 }
 
-static void unregister_wakeup_function(int graph)
+static void unregister_wakeup_function(struct trace_array *tr, int graph)
 {
 	if (!function_enabled)
 		return;
@@ -166,17 +160,17 @@ static void unregister_wakeup_function(int graph)
 	if (graph)
 		unregister_ftrace_graph();
 	else
-		unregister_ftrace_function(&trace_ops);
+		unregister_ftrace_function(tr->ops);
 
 	function_enabled = false;
 }
 
-static void wakeup_function_set(int set)
+static void wakeup_function_set(struct trace_array *tr, int set)
 {
 	if (set)
-		register_wakeup_function(is_graph(), 1);
+		register_wakeup_function(tr, is_graph(), 1);
 	else
-		unregister_wakeup_function(is_graph());
+		unregister_wakeup_function(tr, is_graph());
 }
 
 static int wakeup_flag_changed(struct trace_array *tr, u32 mask, int set)
@@ -184,16 +178,16 @@ static int wakeup_flag_changed(struct trace_array *tr, u32 mask, int set)
 	struct tracer *tracer = tr->current_trace;
 
 	if (mask & TRACE_ITER_FUNCTION)
-		wakeup_function_set(set);
+		wakeup_function_set(tr, set);
 
 	return trace_keep_overwrite(tracer, mask, set);
 }
 
-static int start_func_tracer(int graph)
+static int start_func_tracer(struct trace_array *tr, int graph)
 {
 	int ret;
 
-	ret = register_wakeup_function(graph, 0);
+	ret = register_wakeup_function(tr, graph, 0);
 
 	if (!ret && tracing_is_enabled())
 		tracer_enabled = 1;
@@ -203,11 +197,11 @@ static int start_func_tracer(int graph)
 	return ret;
 }
 
-static void stop_func_tracer(int graph)
+static void stop_func_tracer(struct trace_array *tr, int graph)
 {
 	tracer_enabled = 0;
 
-	unregister_wakeup_function(graph);
+	unregister_wakeup_function(tr, graph);
 }
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
@@ -221,12 +215,12 @@ wakeup_set_flag(struct trace_array *tr, u32 old_flags, u32 bit, int set)
 	if (!(is_graph() ^ set))
 		return 0;
 
-	stop_func_tracer(!set);
+	stop_func_tracer(tr, !set);
 
 	wakeup_reset(wakeup_trace);
 	tracing_max_latency = 0;
 
-	return start_func_tracer(set);
+	return start_func_tracer(tr, set);
 }
 
 static int wakeup_graph_entry(struct ftrace_graph_ent *trace)
@@ -587,7 +581,7 @@ static void start_wakeup_tracer(struct trace_array *tr)
 	 */
 	smp_wmb();
 
-	if (start_func_tracer(is_graph()))
+	if (start_func_tracer(tr, is_graph()))
 		printk(KERN_ERR "failed to start wakeup tracer\n");
 
 	return;
@@ -600,7 +594,7 @@ fail_deprobe:
 static void stop_wakeup_tracer(struct trace_array *tr)
 {
 	tracer_enabled = 0;
-	stop_func_tracer(is_graph());
+	stop_func_tracer(tr, is_graph());
 	unregister_trace_sched_switch(probe_wakeup_sched_switch, NULL);
 	unregister_trace_sched_wakeup_new(probe_wakeup, NULL);
 	unregister_trace_sched_wakeup(probe_wakeup, NULL);
@@ -617,6 +611,7 @@ static int __wakeup_tracer_init(struct trace_array *tr)
 
 	tracing_max_latency = 0;
 	wakeup_trace = tr;
+	ftrace_init_array_ops(tr, wakeup_tracer_call);
 	start_wakeup_tracer(tr);
 	return 0;
 }
@@ -653,6 +648,7 @@ static void wakeup_tracer_reset(struct trace_array *tr)
 
 	set_tracer_flag(tr, TRACE_ITER_LATENCY_FMT, lat_flag);
 	set_tracer_flag(tr, TRACE_ITER_OVERWRITE, overwrite_flag);
+	ftrace_reset_array_ops(tr);
 }
 
 static void wakeup_tracer_start(struct trace_array *tr)
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index e98fca6..519d04a 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -161,11 +161,6 @@ static struct ftrace_ops test_probe3 = {
 	.flags			= FTRACE_OPS_FL_RECURSION_SAFE,
 };
 
-static struct ftrace_ops test_global = {
-	.func		= trace_selftest_test_global_func,
-	.flags		= FTRACE_OPS_FL_GLOBAL | FTRACE_OPS_FL_RECURSION_SAFE,
-};
-
 static void print_counts(void)
 {
 	printk("(%d %d %d %d %d) ",
@@ -185,7 +180,7 @@ static void reset_counts(void)
 	trace_selftest_test_dyn_cnt = 0;
 }
 
-static int trace_selftest_ops(int cnt)
+static int trace_selftest_ops(struct trace_array *tr, int cnt)
 {
 	int save_ftrace_enabled = ftrace_enabled;
 	struct ftrace_ops *dyn_ops;
@@ -220,7 +215,11 @@ static int trace_selftest_ops(int cnt)
 	register_ftrace_function(&test_probe1);
 	register_ftrace_function(&test_probe2);
 	register_ftrace_function(&test_probe3);
-	register_ftrace_function(&test_global);
+	/* First time we are running with main function */
+	if (cnt > 1) {
+		ftrace_init_array_ops(tr, trace_selftest_test_global_func);
+		register_ftrace_function(tr->ops);
+	}
 
 	DYN_FTRACE_TEST_NAME();
 
@@ -232,8 +231,10 @@ static int trace_selftest_ops(int cnt)
 		goto out;
 	if (trace_selftest_test_probe3_cnt != 1)
 		goto out;
-	if (trace_selftest_test_global_cnt == 0)
-		goto out;
+	if (cnt > 1) {
+		if (trace_selftest_test_global_cnt == 0)
+			goto out;
+	}
 
 	DYN_FTRACE_TEST_NAME2();
 
@@ -269,8 +270,10 @@ static int trace_selftest_ops(int cnt)
 		goto out_free;
 	if (trace_selftest_test_probe3_cnt != 3)
 		goto out_free;
-	if (trace_selftest_test_global_cnt == 0)
-		goto out;
+	if (cnt > 1) {
+		if (trace_selftest_test_global_cnt == 0)
+			goto out;
+	}
 	if (trace_selftest_test_dyn_cnt == 0)
 		goto out_free;
 
@@ -295,7 +298,9 @@ static int trace_selftest_ops(int cnt)
 	unregister_ftrace_function(&test_probe1);
 	unregister_ftrace_function(&test_probe2);
 	unregister_ftrace_function(&test_probe3);
-	unregister_ftrace_function(&test_global);
+	if (cnt > 1)
+		unregister_ftrace_function(tr->ops);
+	ftrace_reset_array_ops(tr);
 
 	/* Make sure everything is off */
 	reset_counts();
@@ -388,7 +393,7 @@ int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
 	}
 
 	/* Test the ops with global tracing running */
-	ret = trace_selftest_ops(1);
+	ret = trace_selftest_ops(tr, 1);
 	trace->reset(tr);
 
  out:
@@ -399,7 +404,7 @@ int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
 
 	/* Test the ops with global tracing off */
 	if (!ret)
-		ret = trace_selftest_ops(2);
+		ret = trace_selftest_ops(tr, 2);
 
 	return ret;
 }
-- 
1.8.5.3


