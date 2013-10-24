Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab3JXN7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 09:59:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:44468 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754709Ab3JXN7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 09:59:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="379441379"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH v11 3/7] tracing: Add 'snapshot' event trigger command
Date: Thu, 24 Oct 2013 08:59:26 -0500
Message-Id: <c9524dd07ce01f9dcbd59011290e0a8d5b47d7ad.1382622043.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1382622043.git.tom.zanussi@linux.intel.com>
References: <cover.1382622043.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1382622043.git.tom.zanussi@linux.intel.com>
References: <cover.1382622043.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 include/linux/ftrace_event.h        |  1 +
 include/linux/kernel.h              |  2 +
 kernel/trace/trace.c                | 33 ++++++++++++--
 kernel/trace/trace_events_trigger.c | 85 +++++++++++++++++++++++++++++++++++++
 4 files changed, 118 insertions(+), 3 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 061205b..b5925b0 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -330,6 +330,7 @@ struct ftrace_event_file {
 enum event_trigger_type {
 	ETT_NONE		= (0),
 	ETT_TRACE_ONOFF		= (1 << 0),
+	ETT_SNAPSHOT		= (1 << 1),
 };
 
 extern void destroy_preds(struct ftrace_event_file *file);
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 672ddc4..51d6e90 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -497,6 +497,7 @@ void tracing_on(void);
 void tracing_off(void);
 int tracing_is_on(void);
 void tracing_snapshot(void);
+int tracing_alloc_snapshot(void);
 void tracing_snapshot_alloc(void);
 
 extern void tracing_start(void);
@@ -646,6 +647,7 @@ static inline void tracing_on(void) { }
 static inline void tracing_off(void) { }
 static inline int tracing_is_on(void) { return 0; }
 static inline void tracing_snapshot(void) { }
+static inline int tracing_alloc_snapshot(void) { return -ENODEV; }
 static inline void tracing_snapshot_alloc(void) { }
 
 static inline __printf(1, 2)
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f9fa42b..0238c5f 100644
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
1.8.3.1

