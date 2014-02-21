Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbaBUCuK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 21:50:10 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:23983 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753141AbaBUCuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 21:50:03 -0500
Message-Id: <20140221025001.339974677@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 20 Feb 2014 21:49:09 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH 03/18] tracing: Set up infrastructure to allow tracers for instances
References: <20140221024906.901631810@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0003-tracing-Set-up-infrastructure-to-allow-tracers-for-i.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Currently the tracers (function, function_graph, irqsoff, etc) can only
be used by the top level tracing directory (not for instances).

This sets up the infrastructure to allow instances to be able to
run a separate tracer apart from the what the top level tracing is
doing.

As tracers need to adapt for being used by instances, the tracers
must flag if they can be used by instances or not. Currently only the
'nop' tracer can be used by all instances.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c     | 72 ++++++++++++++++++++++++++++++++++++++----------
 kernel/trace/trace.h     |  1 +
 kernel/trace/trace_nop.c |  3 +-
 3 files changed, 60 insertions(+), 16 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ee8da93..944cd02 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -119,7 +119,7 @@ enum ftrace_dump_mode ftrace_dump_on_oops;
 /* When set, tracing will stop when a WARN*() is hit */
 int __disable_trace_on_warning;
 
-static int tracing_set_tracer(const char *buf);
+static int tracing_set_tracer(struct trace_array *tr, const char *buf);
 
 #define MAX_TRACER_SIZE		100
 static char bootup_tracer_buf[MAX_TRACER_SIZE] __initdata;
@@ -1231,7 +1231,7 @@ int register_tracer(struct tracer *type)
 
 	printk(KERN_INFO "Starting tracer '%s'\n", type->name);
 	/* Do we want this tracer to start on bootup? */
-	tracing_set_tracer(type->name);
+	tracing_set_tracer(&global_trace, type->name);
 	default_bootup_tracer = NULL;
 	/* disable other selftests, since this will break it. */
 	tracing_selftest_disabled = true;
@@ -3122,27 +3122,52 @@ static int tracing_open(struct inode *inode, struct file *file)
 	return ret;
 }
 
+/*
+ * Some tracers are not suitable for instance buffers.
+ * A tracer is always available for the global array (toplevel)
+ * or if it explicitly states that it is.
+ */
+static bool
+trace_ok_for_array(struct tracer *t, struct trace_array *tr)
+{
+	return (tr->flags & TRACE_ARRAY_FL_GLOBAL) || t->allow_instances;
+}
+
+/* Find the next tracer that this trace array may use */
+static struct tracer *
+get_tracer_for_array(struct trace_array *tr, struct tracer *t)
+{
+	while (t && !trace_ok_for_array(t, tr))
+		t = t->next;
+
+	return t;
+}
+
 static void *
 t_next(struct seq_file *m, void *v, loff_t *pos)
 {
+	struct trace_array *tr = m->private;
 	struct tracer *t = v;
 
 	(*pos)++;
 
 	if (t)
-		t = t->next;
+		t = get_tracer_for_array(tr, t->next);
 
 	return t;
 }
 
 static void *t_start(struct seq_file *m, loff_t *pos)
 {
+	struct trace_array *tr = m->private;
 	struct tracer *t;
 	loff_t l = 0;
 
 	mutex_lock(&trace_types_lock);
-	for (t = trace_types; t && l < *pos; t = t_next(m, t, &l))
-		;
+
+	t = get_tracer_for_array(tr, trace_types);
+	for (; t && l < *pos; t = t_next(m, t, &l))
+			;
 
 	return t;
 }
@@ -3177,10 +3202,21 @@ static const struct seq_operations show_traces_seq_ops = {
 
 static int show_traces_open(struct inode *inode, struct file *file)
 {
+	struct trace_array *tr = inode->i_private;
+	struct seq_file *m;
+	int ret;
+
 	if (tracing_disabled)
 		return -ENODEV;
 
-	return seq_open(file, &show_traces_seq_ops);
+	ret = seq_open(file, &show_traces_seq_ops);
+	if (ret)
+		return ret;
+
+	m = file->private_data;
+	m->private = tr;
+
+	return 0;
 }
 
 static ssize_t
@@ -3871,10 +3907,9 @@ create_trace_option_files(struct trace_array *tr, struct tracer *tracer);
 static void
 destroy_trace_option_files(struct trace_option_dentry *topts);
 
-static int tracing_set_tracer(const char *buf)
+static int tracing_set_tracer(struct trace_array *tr, const char *buf)
 {
 	static struct trace_option_dentry *topts;
-	struct trace_array *tr = &global_trace;
 	struct tracer *t;
 #ifdef CONFIG_TRACER_MAX_TRACE
 	bool had_max_tr;
@@ -3902,6 +3937,12 @@ static int tracing_set_tracer(const char *buf)
 	if (t == tr->current_trace)
 		goto out;
 
+	/* Some tracers are only allowed for the top level buffer */
+	if (!trace_ok_for_array(t, tr)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	trace_branch_disable();
 
 	tr->current_trace->enabled = false;
@@ -3958,6 +3999,7 @@ static ssize_t
 tracing_set_trace_write(struct file *filp, const char __user *ubuf,
 			size_t cnt, loff_t *ppos)
 {
+	struct trace_array *tr = filp->private_data;
 	char buf[MAX_TRACER_SIZE+1];
 	int i;
 	size_t ret;
@@ -3977,7 +4019,7 @@ tracing_set_trace_write(struct file *filp, const char __user *ubuf,
 	for (i = cnt - 1; i > 0 && isspace(buf[i]); i--)
 		buf[i] = 0;
 
-	err = tracing_set_tracer(buf);
+	err = tracing_set_tracer(tr, buf);
 	if (err)
 		return err;
 
@@ -6193,6 +6235,12 @@ init_tracer_debugfs(struct trace_array *tr, struct dentry *d_tracer)
 {
 	int cpu;
 
+	trace_create_file("available_tracers", 0444, d_tracer,
+			tr, &show_traces_fops);
+
+	trace_create_file("current_tracer", 0644, d_tracer,
+			tr, &set_tracer_fops);
+
 	trace_create_file("tracing_cpumask", 0644, d_tracer,
 			  tr, &tracing_cpumask_fops);
 
@@ -6245,12 +6293,6 @@ static __init int tracer_init_debugfs(void)
 
 	init_tracer_debugfs(&global_trace, d_tracer);
 
-	trace_create_file("available_tracers", 0444, d_tracer,
-			&global_trace, &show_traces_fops);
-
-	trace_create_file("current_tracer", 0644, d_tracer,
-			&global_trace, &set_tracer_fops);
-
 #ifdef CONFIG_TRACER_MAX_TRACE
 	trace_create_file("tracing_max_latency", 0644, d_tracer,
 			&tracing_max_latency, &tracing_max_lat_fops);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 36e4473..ea51bb2 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -364,6 +364,7 @@ struct tracer {
 	struct tracer_flags	*flags;
 	bool			print_max;
 	bool			enabled;
+	bool			allow_instances;
 #ifdef CONFIG_TRACER_MAX_TRACE
 	bool			use_max_tr;
 #endif
diff --git a/kernel/trace/trace_nop.c b/kernel/trace/trace_nop.c
index f398409..69a5cc9 100644
--- a/kernel/trace/trace_nop.c
+++ b/kernel/trace/trace_nop.c
@@ -96,6 +96,7 @@ struct tracer nop_trace __read_mostly =
 	.selftest	= trace_selftest_startup_nop,
 #endif
 	.flags		= &nop_flags,
-	.set_flag	= nop_set_flag
+	.set_flag	= nop_set_flag,
+	.allow_instances = true,
 };
 
-- 
1.8.5.3


