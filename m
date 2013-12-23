Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932373Ab3LWVla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 16:41:30 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:60833 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758120Ab3LWVjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:39:16 -0500
Message-Id: <20131223213914.222772764@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 23 Dec 2013 16:38:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 03/10] tracing: Add snapshot event trigger command
References: <20131223213810.967436536@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Add-snapshot-event-trigger-command.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tom.zanussi@linux.intel.com>

Add 'snapshot' event_command.  snapshot event triggers are added by
the user via this command in a similar way and using practically the
same syntax as the analogous 'snapshot' ftrace function command, but
instead of writing to the set_ftrace_filter file, the snapshot event
trigger is written to the per-event 'trigger' files:

    echo 'snapshot' > .../somesys/someevent/trigger

The above command will turn on snapshots for someevent i.e. whenever
someevent is hit, a snapshot will be done.

This also adds a 'count' version that limits the number of times the
command will be invoked:

    echo 'snapshot:N' > .../somesys/someevent/trigger

Where N is the number of times the command will be invoked.

The above command will snapshot N times for someevent i.e. whenever
someevent is hit N times, a snapshot will be done.

Also adds a new tracing_alloc_snapshot() function - the existing
tracing_snapshot_alloc() function is a special version of
tracing_snapshot() that also does the snapshot allocation - the
snapshot triggers would like to be able to do just the allocation but
not take a snapshot; the existing tracing_snapshot_alloc() in turn now
also calls tracing_alloc_snapshot() underneath to do that allocation.

Link: http://lkml.kernel.org/r/c9524dd07ce01f9dcbd59011290e0a8d5b47d7ad.1382622043.git.tom.zanussi@linux.intel.com

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
[ fix up from kbuild test robot <fengguang.wu@intel.com report ]
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h        |  1 +
 kernel/trace/trace.c                | 33 ++++++++++++--
 kernel/trace/trace.h                |  1 +
 kernel/trace/trace_events_trigger.c | 85 +++++++++++++++++++++++++++++++++++++
 4 files changed, 117 insertions(+), 3 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 711c4dc..6efa8c2 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -346,6 +346,7 @@ struct ftrace_event_file {
 enum event_trigger_type {
 	ETT_NONE		= (0),
 	ETT_TRACE_ONOFF		= (1 << 0),
+	ETT_SNAPSHOT		= (1 << 1),
 };
 
 extern void destroy_preds(struct ftrace_event_file *file);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9d20cd9..59bf5b5 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -595,6 +595,28 @@ void free_snapshot(struct trace_array *tr)
 }
 
 /**
+ * tracing_alloc_snapshot - allocate snapshot buffer.
+ *
+ * This only allocates the snapshot buffer if it isn't already
+ * allocated - it doesn't also take a snapshot.
+ *
+ * This is meant to be used in cases where the snapshot buffer needs
+ * to be set up for events that can't sleep but need to be able to
+ * trigger a snapshot.
+ */
+int tracing_alloc_snapshot(void)
+{
+	struct trace_array *tr = &global_trace;
+	int ret;
+
+	ret = alloc_snapshot(tr);
+	WARN_ON(ret < 0);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tracing_alloc_snapshot);
+
+/**
  * trace_snapshot_alloc - allocate and take a snapshot of the current buffer.
  *
  * This is similar to trace_snapshot(), but it will allocate the
@@ -607,11 +629,10 @@ void free_snapshot(struct trace_array *tr)
  */
 void tracing_snapshot_alloc(void)
 {
-	struct trace_array *tr = &global_trace;
 	int ret;
 
-	ret = alloc_snapshot(tr);
-	if (WARN_ON(ret < 0))
+	ret = tracing_alloc_snapshot();
+	if (ret < 0)
 		return;
 
 	tracing_snapshot();
@@ -623,6 +644,12 @@ void tracing_snapshot(void)
 	WARN_ONCE(1, "Snapshot feature not enabled, but internal snapshot used");
 }
 EXPORT_SYMBOL_GPL(tracing_snapshot);
+int tracing_alloc_snapshot(void)
+{
+	WARN_ONCE(1, "Snapshot feature not enabled, but snapshot allocation used");
+	return -ENODEV;
+}
+EXPORT_SYMBOL_GPL(tracing_alloc_snapshot);
 void tracing_snapshot_alloc(void)
 {
 	/* Give warning */
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 9775e51..50723e5 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1211,6 +1211,7 @@ struct event_command {
 
 extern int trace_event_enable_disable(struct ftrace_event_file *file,
 				      int enable, int soft_disable);
+extern int tracing_alloc_snapshot(void);
 
 extern const char *__start___trace_bprintk_fmt[];
 extern const char *__stop___trace_bprintk_fmt[];
diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index 4ea72ee..d775c3d 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -696,6 +696,90 @@ static struct event_command trigger_traceoff_cmd = {
 	.get_trigger_ops	= onoff_get_trigger_ops,
 };
 
+#ifdef CONFIG_TRACER_SNAPSHOT
+static void
+snapshot_trigger(struct event_trigger_data *data)
+{
+	tracing_snapshot();
+}
+
+static void
+snapshot_count_trigger(struct event_trigger_data *data)
+{
+	if (!data->count)
+		return;
+
+	if (data->count != -1)
+		(data->count)--;
+
+	snapshot_trigger(data);
+}
+
+static int
+register_snapshot_trigger(char *glob, struct event_trigger_ops *ops,
+			  struct event_trigger_data *data,
+			  struct ftrace_event_file *file)
+{
+	int ret = register_trigger(glob, ops, data, file);
+
+	if (ret > 0 && tracing_alloc_snapshot() != 0) {
+		unregister_trigger(glob, ops, data, file);
+		ret = 0;
+	}
+
+	return ret;
+}
+
+static int
+snapshot_trigger_print(struct seq_file *m, struct event_trigger_ops *ops,
+		       struct event_trigger_data *data)
+{
+	return event_trigger_print("snapshot", m, (void *)data->count,
+				   data->filter_str);
+}
+
+static struct event_trigger_ops snapshot_trigger_ops = {
+	.func			= snapshot_trigger,
+	.print			= snapshot_trigger_print,
+	.init			= event_trigger_init,
+	.free			= event_trigger_free,
+};
+
+static struct event_trigger_ops snapshot_count_trigger_ops = {
+	.func			= snapshot_count_trigger,
+	.print			= snapshot_trigger_print,
+	.init			= event_trigger_init,
+	.free			= event_trigger_free,
+};
+
+static struct event_trigger_ops *
+snapshot_get_trigger_ops(char *cmd, char *param)
+{
+	return param ? &snapshot_count_trigger_ops : &snapshot_trigger_ops;
+}
+
+static struct event_command trigger_snapshot_cmd = {
+	.name			= "snapshot",
+	.trigger_type		= ETT_SNAPSHOT,
+	.func			= event_trigger_callback,
+	.reg			= register_snapshot_trigger,
+	.unreg			= unregister_trigger,
+	.get_trigger_ops	= snapshot_get_trigger_ops,
+};
+
+static __init int register_trigger_snapshot_cmd(void)
+{
+	int ret;
+
+	ret = register_event_command(&trigger_snapshot_cmd);
+	WARN_ON(ret < 0);
+
+	return ret;
+}
+#else
+static __init int register_trigger_snapshot_cmd(void) { return 0; }
+#endif /* CONFIG_TRACER_SNAPSHOT */
+
 static __init void unregister_trigger_traceon_traceoff_cmds(void)
 {
 	unregister_event_command(&trigger_traceon_cmd);
@@ -719,6 +803,7 @@ static __init int register_trigger_traceon_traceoff_cmds(void)
 __init int register_trigger_cmds(void)
 {
 	register_trigger_traceon_traceoff_cmds();
+	register_trigger_snapshot_cmd();
 
 	return 0;
 }
-- 
1.8.4.3


