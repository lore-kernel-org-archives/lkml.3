Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677AbbAWVve (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 16:51:34 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:54315 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756609AbbAWVv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 16:51:29 -0500
Message-Id: <20150123215126.077518088@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 23 Jan 2015 16:50:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] tracing: Use IS_ERR() check for return value of tracing_init_dentry()
References: <20150123215010.626661716@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0002-tracing-Use-IS_ERR-check-for-return-value-of-tracing.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

tracing_init_dentry() will soon return NULL as a valid pointer for the
top level tracing directroy. NULL can not be used as an error value.
Instead, switch to ERR_PTR() and check the return status with
IS_ERR().

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c                | 2 +-
 kernel/trace/trace.c                 | 8 ++++----
 kernel/trace/trace_events.c          | 2 +-
 kernel/trace/trace_functions_graph.c | 2 +-
 kernel/trace/trace_kprobe.c          | 2 +-
 kernel/trace/trace_printk.c          | 2 +-
 kernel/trace/trace_stack.c           | 2 +-
 kernel/trace/trace_stat.c            | 2 +-
 kernel/trace/trace_uprobe.c          | 2 +-
 9 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 929a733d302e..80c9d34540dd 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5419,7 +5419,7 @@ static __init int ftrace_init_debugfs(void)
 	struct dentry *d_tracer;
 
 	d_tracer = tracing_init_dentry();
-	if (!d_tracer)
+	if (IS_ERR(d_tracer))
 		return 0;
 
 	ftrace_init_dyn_debugfs(d_tracer);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 7669b1f3234e..acd27555dc5b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5820,7 +5820,7 @@ struct dentry *tracing_init_dentry_tr(struct trace_array *tr)
 		return tr->dir;
 
 	if (!debugfs_initialized())
-		return NULL;
+		return ERR_PTR(-ENODEV);
 
 	if (tr->flags & TRACE_ARRAY_FL_GLOBAL)
 		tr->dir = debugfs_create_dir("tracing", NULL);
@@ -5844,7 +5844,7 @@ static struct dentry *tracing_dentry_percpu(struct trace_array *tr, int cpu)
 		return tr->percpu_dir;
 
 	d_tracer = tracing_init_dentry_tr(tr);
-	if (!d_tracer)
+	if (IS_ERR(d_tracer))
 		return NULL;
 
 	tr->percpu_dir = debugfs_create_dir("per_cpu", d_tracer);
@@ -6047,7 +6047,7 @@ static struct dentry *trace_options_init_dentry(struct trace_array *tr)
 		return tr->options;
 
 	d_tracer = tracing_init_dentry_tr(tr);
-	if (!d_tracer)
+	if (IS_ERR(d_tracer))
 		return NULL;
 
 	tr->options = debugfs_create_dir("options", d_tracer);
@@ -6538,7 +6538,7 @@ static __init int tracer_init_debugfs(void)
 	trace_access_lock_init();
 
 	d_tracer = tracing_init_dentry();
-	if (!d_tracer)
+	if (IS_ERR(d_tracer))
 		return 0;
 
 	init_tracer_debugfs(&global_trace, d_tracer);
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 366a78a3e61e..4ff8c1394017 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2490,7 +2490,7 @@ static __init int event_trace_init(void)
 		return -ENODEV;
 
 	d_tracer = tracing_init_dentry();
-	if (!d_tracer)
+	if (IS_ERR(d_tracer))
 		return 0;
 
 	entry = debugfs_create_file("available_events", 0444, d_tracer,
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index ba476009e5de..2d25ad1526bb 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -1437,7 +1437,7 @@ static __init int init_graph_debugfs(void)
 	struct dentry *d_tracer;
 
 	d_tracer = tracing_init_dentry();
-	if (!d_tracer)
+	if (IS_ERR(d_tracer))
 		return 0;
 
 	trace_create_file("max_graph_depth", 0644, d_tracer,
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 5edb518be345..b4a00def88f5 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1320,7 +1320,7 @@ static __init int init_kprobe_trace(void)
 		return -EINVAL;
 
 	d_tracer = tracing_init_dentry();
-	if (!d_tracer)
+	if (IS_ERR(d_tracer))
 		return 0;
 
 	entry = debugfs_create_file("kprobe_events", 0644, d_tracer,
diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
index 7ee4b5cc1ce5..36c1455b7567 100644
--- a/kernel/trace/trace_printk.c
+++ b/kernel/trace/trace_printk.c
@@ -347,7 +347,7 @@ static __init int init_trace_printk_function_export(void)
 	struct dentry *d_tracer;
 
 	d_tracer = tracing_init_dentry();
-	if (!d_tracer)
+	if (IS_ERR(d_tracer))
 		return 0;
 
 	trace_create_file("printk_formats", 0444, d_tracer,
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index e80927b88eb0..c3e4fcfddd45 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -460,7 +460,7 @@ static __init int stack_trace_init(void)
 	struct dentry *d_tracer;
 
 	d_tracer = tracing_init_dentry();
-	if (!d_tracer)
+	if (IS_ERR(d_tracer))
 		return 0;
 
 	trace_create_file("stack_max_size", 0644, d_tracer,
diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index 7af67360b330..75e19e86c954 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -276,7 +276,7 @@ static int tracing_stat_init(void)
 	struct dentry *d_tracing;
 
 	d_tracing = tracing_init_dentry();
-	if (!d_tracing)
+	if (IS_ERR(d_tracing))
 		return 0;
 
 	stat_dir = debugfs_create_dir("trace_stat", d_tracing);
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 8520acc34b18..5f0eba9e5e6b 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -1321,7 +1321,7 @@ static __init int init_uprobe_trace(void)
 	struct dentry *d_tracer;
 
 	d_tracer = tracing_init_dentry();
-	if (!d_tracer)
+	if (IS_ERR(d_tracer))
 		return 0;
 
 	trace_create_file("uprobe_events", 0644, d_tracer,
-- 
2.1.4


