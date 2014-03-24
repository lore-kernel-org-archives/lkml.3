Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbaCXSPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 14:15:17 -0400
Received: from mail-ie0-f202.google.com ([209.85.223.202]:34815 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748AbaCXSOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 14:14:09 -0400
From: Bharath Ravi <rbharath@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>,
        David Sharp <dhsharp@google.com>, Bharath Ravi <rbharath@google.com>,
        Laurent Chavey <chavey@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] tracing: Allow instances to have independent trace flags/trace options.
Date: Mon, 24 Mar 2014 11:13:45 -0700
Message-Id: <1395684826-22931-3-git-send-email-rbharath@google.com>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
In-Reply-To: <1395684826-22931-1-git-send-email-rbharath@google.com>
References: <1395684826-22931-1-git-send-email-rbharath@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the trace options are global, and shared among all
instances. This change divides the set of trace options into global
options and instance specific options. This division is done by using a
"global_flags_start" offset in the list of available trace options, that
marks the first global trace option, and is preceded by options that are
instance specific.

Instance specific options may be set independently by an instance
without affecting either the global tracer or other instances. Global
options are viewable and modifiable only from the global tracer,
preventing instances from modifying shared flags.

Currently, there are no instance specific options (global_flags_start is
set to 0). This patch only adds the infrastructure for allowing instance
specific trace options. Subsequently, options may be made instance
specific by changing global_flags_start and moving the option to a
position less than global_flags_start in the trace_options list.

Signed-off-by: Bharath Ravi <rbharath@google.com>
---
 kernel/trace/trace.c | 73 ++++++++++++++++++++++++++++++++++++++++------------
 kernel/trace/trace.h |  2 +-
 2 files changed, 57 insertions(+), 18 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9f0a5f9..61f2301 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -406,20 +406,24 @@ static inline void trace_access_lock_init(void)
 
 #endif
 
-/* trace_flags holds trace_options default values */
-unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
-	TRACE_ITER_ANNOTATE | TRACE_ITER_CONTEXT_INFO |	TRACE_ITER_SLEEP_TIME |
-	TRACE_ITER_GRAPH_TIME |	TRACE_ITER_RECORD_CMD | TRACE_ITER_OVERWRITE |
-	TRACE_ITER_IRQ_INFO | TRACE_ITER_MARKERS | TRACE_ITER_FUNCTION;
+/* Sets default values for a tracer's  trace_options */
+static inline void init_trace_flags(unsigned long *trace_flags)
+{
+	*trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
+		TRACE_ITER_ANNOTATE | TRACE_ITER_CONTEXT_INFO |
+		TRACE_ITER_SLEEP_TIME |	TRACE_ITER_GRAPH_TIME |
+		TRACE_ITER_RECORD_CMD | TRACE_ITER_OVERWRITE |
+		TRACE_ITER_IRQ_INFO | TRACE_ITER_MARKERS | TRACE_ITER_FUNCTION;
+}
 
 unsigned long global_trace_flags(void)
 {
-	return trace_flags;
+	return global_trace.trace_flags;
 }
 
 void set_global_trace_flags(unsigned long flags)
 {
-	trace_flags = flags;
+	global_trace.trace_flags = flags;
 }
 
 static void tracer_tracing_on(struct trace_array *tr)
@@ -799,6 +803,13 @@ static const char *trace_options[] = {
 	NULL
 };
 
+/*
+ * The index of the first global flag in trace_options. Indices higher than or
+ * equal to this are global flags, while indices smaller than this are
+ * per-instance flags.
+ */
+static const int global_flags_start;
+
 static struct {
 	u64 (*func)(void);
 	const char *name;
@@ -3333,13 +3344,23 @@ static int tracing_trace_options_show(struct seq_file *m, void *v)
 	tracer_flags = tr->current_trace->flags->val;
 	trace_opts = tr->current_trace->flags->opts;
 
-	for (i = 0; trace_options[i]; i++) {
-		if (global_trace_flags() & (1 << i))
+	for (i = 0; i < global_flags_start; i++) {
+		if (tr->trace_flags & (1 << i))
 			seq_printf(m, "%s\n", trace_options[i]);
 		else
 			seq_printf(m, "no%s\n", trace_options[i]);
 	}
 
+	/* For the global trace, also display global options*/
+	if (tr->flags & TRACE_ARRAY_FL_GLOBAL) {
+		for (i = global_flags_start; trace_options[i]; i++) {
+			if (global_trace_flags() & (1 << i))
+				seq_printf(m, "%s\n", trace_options[i]);
+			else
+				seq_printf(m, "no%s\n", trace_options[i]);
+		}
+	}
+
 	for (i = 0; trace_opts[i].name; i++) {
 		if (tracer_flags & trace_opts[i].bit)
 			seq_printf(m, "%s\n", trace_opts[i].name);
@@ -3397,9 +3418,14 @@ int trace_keep_overwrite(struct tracer *tracer, u32 mask, int set)
 
 int set_tracer_flag(struct trace_array *tr, unsigned int mask, int enabled)
 {
-	unsigned long trace_flags = global_trace_flags();
+	/* If this is a global flag, disallow instances from modifying it. */
+	if (mask >= (1 << global_flags_start) &&
+	    !(tr->flags & TRACE_ARRAY_FL_GLOBAL))
+		return -EINVAL;
+
+
 	/* do nothing if flag is already set */
-	if (!!(trace_flags & mask) == !!enabled)
+	if (!!(tr->trace_flags & mask) == !!enabled)
 		return 0;
 
 	/* Give the tracer a chance to approve the change */
@@ -3408,9 +3434,9 @@ int set_tracer_flag(struct trace_array *tr, unsigned int mask, int enabled)
 			return -EINVAL;
 
 	if (enabled)
-		trace_flags |= mask;
+		tr->trace_flags |= mask;
 	else
-		trace_flags &= ~mask;
+		tr->trace_flags &= ~mask;
 
 	if (mask == TRACE_ITER_RECORD_CMD)
 		trace_event_enable_cmd_record(enabled);
@@ -3434,6 +3460,7 @@ static int trace_set_options(struct trace_array *tr, char *option)
 	int neg = 0;
 	int ret = -ENODEV;
 	int i;
+	bool option_found = false;
 
 	cmp = strstrip(option);
 
@@ -3444,15 +3471,26 @@ static int trace_set_options(struct trace_array *tr, char *option)
 
 	mutex_lock(&trace_types_lock);
 
-	for (i = 0; trace_options[i]; i++) {
+	for (i = 0; i < global_flags_start; i++) {
 		if (strcmp(cmp, trace_options[i]) == 0) {
 			ret = set_tracer_flag(tr, 1 << i, !neg);
 			break;
 		}
 	}
 
+	if (i < global_flags_start) {
+		option_found = true;
+	} else if (tr->flags & TRACE_ARRAY_FL_GLOBAL) {
+		/* If this is the global trace, try the global options */
+		for (i = global_flags_start; trace_options[i]; i++) {
+			ret = set_tracer_flag(tr, 1 << i, !neg);
+			break;
+		}
+		option_found = trace_options[i];
+	}
+
 	/* If no option could be set, test the specific tracer options */
-	if (!trace_options[i])
+	if (!option_found)
 		ret = set_tracer_option(tr->current_trace, cmp, neg);
 
 	mutex_unlock(&trace_types_lock);
@@ -5967,9 +6005,8 @@ static int
 allocate_trace_buffer(struct trace_array *tr, struct trace_buffer *buf, int size)
 {
 	enum ring_buffer_flags rb_flags;
-	unsigned long trace_flags = global_trace_flags();
 
-	rb_flags = trace_flags & TRACE_ITER_OVERWRITE ? RB_FL_OVERWRITE : 0;
+	rb_flags = tr->trace_flags & TRACE_ITER_OVERWRITE ? RB_FL_OVERWRITE : 0;
 
 	buf->tr = tr;
 
@@ -6045,6 +6082,7 @@ static int new_instance_create(const char *name)
 	cpumask_copy(tr->tracing_cpumask, cpu_all_mask);
 
 	raw_spin_lock_init(&tr->start_lock);
+	init_trace_flags(&(tr->trace_flags));
 
 	tr->current_trace = &nop_trace;
 
@@ -6507,6 +6545,7 @@ __init static int tracer_alloc_buffers(void)
 	cpumask_copy(global_trace.tracing_cpumask, cpu_all_mask);
 
 	raw_spin_lock_init(&global_trace.start_lock);
+	init_trace_flags(&global_trace.trace_flags);
 
 	/* TODO: make the number of buffers hot pluggable with CPUS */
 	if (allocate_trace_buffers(&global_trace, ring_buf_size) < 0) {
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 82b50a0..38b511a 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -201,6 +201,7 @@ struct trace_array {
 	int			clock_id;
 	struct tracer		*current_trace;
 	unsigned int		flags;
+	unsigned long		trace_flags;
 	raw_spinlock_t		start_lock;
 	struct dentry		*dir;
 	struct dentry		*options;
@@ -704,7 +705,6 @@ int trace_array_printk_buf(struct ring_buffer *buffer,
 void trace_printk_seq(struct trace_seq *s);
 enum print_line_t print_trace_line(struct trace_iterator *iter);
 
-extern unsigned long trace_flags;
 unsigned long global_trace_flags(void);
 void set_global_trace_flags(unsigned long flags);
 
-- 
1.9.1.423.g4596e3a

