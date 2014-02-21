Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbaBUCxD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 21:53:03 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:65424 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753275AbaBUCuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 21:50:06 -0500
Message-Id: <20140221025002.680098231@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 20 Feb 2014 21:49:17 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH 11/18] ftrace: Allow for function tracing instance to filter functions
References: <20140221024906.901631810@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0011-ftrace-Allow-for-function-tracing-instance-to-filter.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Create a "set_ftrace_filter" and "set_ftrace_notrace" files in the instance
directories to let users filter of functions to trace for the given instance.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h         |  2 ++
 kernel/trace/ftrace.c          | 39 ++++++++++++++++++++++++++++++++++-----
 kernel/trace/trace.c           |  4 ++++
 kernel/trace/trace.h           | 25 ++++++++++++++++++++++++-
 kernel/trace/trace_functions.c | 40 ++++++++++++++++++++++++++++++++--------
 5 files changed, 96 insertions(+), 14 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index ef1607e..e6141be 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -92,6 +92,7 @@ typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip,
  * STUB   - The ftrace_ops is just a place holder.
  * INITIALIZED - The ftrace_ops has already been initialized (first use time
  *            register_ftrace_function() is called, it will initialized the ops)
+ * DELETED - The ops are being deleted, do not let them be registered again.
  */
 enum {
 	FTRACE_OPS_FL_ENABLED			= 1 << 0,
@@ -103,6 +104,7 @@ enum {
 	FTRACE_OPS_FL_RECURSION_SAFE		= 1 << 6,
 	FTRACE_OPS_FL_STUB			= 1 << 7,
 	FTRACE_OPS_FL_INITIALIZED		= 1 << 8,
+	FTRACE_OPS_FL_DELETED			= 1 << 9,
 };
 
 /*
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 2b3e239..dcee546 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -436,6 +436,9 @@ static int remove_ftrace_list_ops(struct ftrace_ops **list,
 
 static int __register_ftrace_function(struct ftrace_ops *ops)
 {
+	if (ops->flags & FTRACE_OPS_FL_DELETED)
+		return -EINVAL;
+
 	if (FTRACE_WARN_ON(ops == &global_ops))
 		return -EINVAL;
 
@@ -4112,6 +4115,36 @@ static const struct file_operations ftrace_graph_notrace_fops = {
 };
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
+void ftrace_create_filter_files(struct ftrace_ops *ops,
+				struct dentry *parent)
+{
+
+	trace_create_file("set_ftrace_filter", 0644, parent,
+			  ops, &ftrace_filter_fops);
+
+	trace_create_file("set_ftrace_notrace", 0644, parent,
+			  ops, &ftrace_notrace_fops);
+}
+
+/*
+ * The name "destroy_filter_files" is really a misnomer. Although
+ * in the future, it may actualy delete the files, but this is
+ * really intended to make sure the ops passed in are disabled
+ * and that when this function returns, the caller is free to
+ * free the ops.
+ *
+ * The "destroy" name is only to match the "create" name that this
+ * should be paired with.
+ */
+void ftrace_destroy_filter_files(struct ftrace_ops *ops)
+{
+	mutex_lock(&ftrace_lock);
+	if (ops->flags & FTRACE_OPS_FL_ENABLED)
+		ftrace_shutdown(ops, 0);
+	ops->flags |= FTRACE_OPS_FL_DELETED;
+	mutex_unlock(&ftrace_lock);
+}
+
 static __init int ftrace_init_dyn_debugfs(struct dentry *d_tracer)
 {
 
@@ -4121,11 +4154,7 @@ static __init int ftrace_init_dyn_debugfs(struct dentry *d_tracer)
 	trace_create_file("enabled_functions", 0444,
 			d_tracer, NULL, &ftrace_enabled_fops);
 
-	trace_create_file("set_ftrace_filter", 0644, d_tracer,
-			&global_ops, &ftrace_filter_fops);
-
-	trace_create_file("set_ftrace_notrace", 0644, d_tracer,
-				    &global_ops, &ftrace_notrace_fops);
+	ftrace_create_filter_files(&global_ops, d_tracer);
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	trace_create_file("set_graph_function", 0444, d_tracer,
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f9f22c4..d95ec28 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6161,6 +6161,7 @@ static int instance_delete(const char *name)
 
 	tracing_set_nop(tr);
 	event_trace_del_tracer(tr);
+	ftrace_destroy_function_files(tr);
 	debugfs_remove_recursive(tr->dir);
 	free_percpu(tr->trace_buffer.data);
 	ring_buffer_free(tr->trace_buffer.buffer);
@@ -6291,6 +6292,9 @@ init_tracer_debugfs(struct trace_array *tr, struct dentry *d_tracer)
 	trace_create_file("tracing_on", 0644, d_tracer,
 			  tr, &rb_simple_fops);
 
+	if (ftrace_create_function_files(tr, d_tracer))
+		WARN(1, "Could not allocate function filter files");
+
 #ifdef CONFIG_TRACER_SNAPSHOT
 	trace_create_file("snapshot", 0644, d_tracer,
 			  tr, &snapshot_fops);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 35cca05..ffc314b 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -819,13 +819,36 @@ static inline int ftrace_trace_task(struct task_struct *task)
 	return test_tsk_trace_trace(task);
 }
 extern int ftrace_is_dead(void);
+int ftrace_create_function_files(struct trace_array *tr,
+				 struct dentry *parent);
+void ftrace_destroy_function_files(struct trace_array *tr);
 #else
 static inline int ftrace_trace_task(struct task_struct *task)
 {
 	return 1;
 }
 static inline int ftrace_is_dead(void) { return 0; }
-#endif
+static inline int
+ftrace_create_function_files(struct trace_array *tr,
+			     struct dentry *parent)
+{
+	return 0;
+}
+static inline void ftrace_destroy_function_files(struct trace_array *tr) { }
+#endif /* CONFIG_FUNCTION_TRACER */
+
+#if defined(CONFIG_FUNCTION_TRACER) && defined(CONFIG_DYNAMIC_FTRACE)
+void ftrace_create_filter_files(struct ftrace_ops *ops,
+				struct dentry *parent);
+void ftrace_destroy_filter_files(struct ftrace_ops *ops);
+#else
+/*
+ * The ops parameter passed in is usually undefined.
+ * This must be a macro.
+ */
+#define ftrace_create_filter_files(ops, parent) do { } while (0)
+#define ftrace_destroy_filter_files(ops) do { } while (0)
+#endif /* CONFIG_FUNCTION_TRACER && CONFIG_DYNAMIC_FTRACE */
 
 int ftrace_event_is_function(struct ftrace_event_call *call);
 
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 3f8dc1c..5b781d2 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -52,10 +52,34 @@ static int allocate_ftrace_ops(struct trace_array *tr)
 	return 0;
 }
 
+
+int ftrace_create_function_files(struct trace_array *tr,
+				 struct dentry *parent)
+{
+	int ret;
+
+	/* The top level array uses the "global_ops". */
+	if (!(tr->flags & TRACE_ARRAY_FL_GLOBAL)) {
+		ret = allocate_ftrace_ops(tr);
+		if (ret)
+			return ret;
+	}
+
+	ftrace_create_filter_files(tr->ops, parent);
+
+	return 0;
+}
+
+void ftrace_destroy_function_files(struct trace_array *tr)
+{
+	ftrace_destroy_filter_files(tr->ops);
+	kfree(tr->ops);
+	tr->ops = NULL;
+}
+
 static int function_trace_init(struct trace_array *tr)
 {
 	struct ftrace_ops *ops;
-	int ret;
 
 	if (tr->flags & TRACE_ARRAY_FL_GLOBAL) {
 		/* There's only one global tr */
@@ -69,10 +93,13 @@ static int function_trace_init(struct trace_array *tr)
 		else
 			ops = &trace_ops;
 		tr->ops = ops;
-	} else {
-		ret = allocate_ftrace_ops(tr);
-		if (ret)
-			return ret;
+	} else if (!tr->ops) {
+		/*
+		 * Instance trace_arrays get their ops allocated
+		 * at instance creation. Unless it failed
+		 * the allocation.
+		 */
+		return -ENOMEM;
 	}
 
 	tr->trace_buffer.cpu = get_cpu();
@@ -87,9 +114,6 @@ static void function_trace_reset(struct trace_array *tr)
 {
 	tracing_stop_function_trace(tr);
 	tracing_stop_cmdline_record();
-	if (!(tr->flags & TRACE_ARRAY_FL_GLOBAL))
-		kfree(tr->ops);
-	tr->ops = NULL;
 }
 
 static void function_trace_start(struct trace_array *tr)
-- 
1.8.5.3


