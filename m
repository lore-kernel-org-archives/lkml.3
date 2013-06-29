Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab3F2FIe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 01:08:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:2506 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab3F2FIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 01:08:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,963,1363158000"; 
   d="scan'208";a="361494163"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: masami.hiramatsu.pt@hitachi.com, jovi.zhangwei@huawei.com,
        linux-kernel@vger.kernel.org,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH v2 07/11] tracing: add 'snapshot' event trigger command
Date: Sat, 29 Jun 2013 00:08:10 -0500
Message-Id: <e8eab2c531ff633de06fdba0415422bd96faa992.1372479499.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <cover.1372479499.git.tom.zanussi@linux.intel.com>
References: <cover.1372479499.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1372479499.git.tom.zanussi@linux.intel.com>
References: <cover.1372479499.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add 'snapshot' ftrace_func_command.  snapshot event triggers are added
by the user via this command in a similar way and using practically
the same syntax as the analogous 'snapshot' ftrace function command,
but instead of writing to the set_ftrace_filter file, the snapshot
event trigger is written to the per-event 'trigger' files:

    echo 'snapshot' > .../somesys/someevent/trigger

The above command will turn on snapshots for someevent i.e. whenever
someevent is hit, a snapshot will be done.

This also adds a 'count' version that limits the number of times the
command will be invoked:

    echo 'snapshot:N' > .../somesys/someevent/trigger

Where N is the number of times the command will be invoked.

The above command will snapshot N times for someevent i.e. whenever
someevent is hit N times, a snapshot will be done.

Also adds a new ftrace_alloc_snapshot() function - the ftrace snapshot
command defines code that allocates a snapshot, which would be nice to
be able to reuse, which this does.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 include/linux/ftrace_event.h        |  1 +
 kernel/trace/trace.c                |  9 ++++
 kernel/trace/trace.h                |  1 +
 kernel/trace/trace_events_trigger.c | 89 +++++++++++++++++++++++++++++++++++++
 4 files changed, 100 insertions(+)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index c794686..a25daf3 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -317,6 +317,7 @@ struct ftrace_event_file {
 enum trigger_mode {
 	TM_NONE			= (0),
 	TM_TRACE_ONOFF		= (1 << 0),
+	TM_SNAPSHOT		= (1 << 1),
 };
 
 extern void destroy_preds(struct ftrace_event_call *call);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e71a8be..96f3cdc 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5169,6 +5169,15 @@ static const struct file_operations tracing_dyn_info_fops = {
 };
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
+#if defined(CONFIG_TRACER_SNAPSHOT)
+int ftrace_alloc_snapshot(void)
+{
+	return alloc_snapshot(&global_trace);
+}
+#else
+int ftrace_alloc_snapshot(void) { return -ENOSYS; }
+#endif
+
 #if defined(CONFIG_TRACER_SNAPSHOT) && defined(CONFIG_DYNAMIC_FTRACE)
 static void
 ftrace_snapshot(unsigned long ip, unsigned long parent_ip, void **data)
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 7dace36..dd27b69 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1060,6 +1060,7 @@ struct event_command {
 
 extern int trace_event_enable_disable(struct ftrace_event_file *file,
 				      int enable, int soft_disable);
+extern int ftrace_alloc_snapshot(void);
 
 extern const char *__start___trace_bprintk_fmt[];
 extern const char *__stop___trace_bprintk_fmt[];
diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index f2b97b6..90a59dc 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -634,6 +634,87 @@ static struct event_command trigger_traceoff_cmd = {
 	.get_trigger_ops	= onoff_get_trigger_ops,
 };
 
+static void
+snapshot_trigger(void **_data)
+{
+	struct event_trigger_data **p = (struct event_trigger_data **)_data;
+	struct event_trigger_data *data = *p;
+
+	if (!data)
+		return;
+
+	tracing_snapshot();
+}
+
+static void
+snapshot_count_trigger(void **_data)
+{
+	struct event_trigger_data **p = (struct event_trigger_data **)_data;
+	struct event_trigger_data *data = *p;
+
+	if (!data)
+		return;
+
+	if (!data->count)
+		return;
+
+	if (data->count != -1)
+		(data->count)--;
+
+	snapshot_trigger(_data);
+}
+
+static int
+register_snapshot_trigger(char *glob, struct event_trigger_ops *ops,
+			  void *data, void *cmd_data)
+{
+	int ret = register_trigger(glob, ops, data, cmd_data);
+
+	if (ret > 0)
+		ftrace_alloc_snapshot();
+
+	return ret;
+}
+
+static int
+snapshot_trigger_print(struct seq_file *m, struct event_trigger_ops *ops,
+		       void *_data)
+{
+	struct event_trigger_data *data = _data;
+
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
+	.trigger_mode		= TM_SNAPSHOT,
+	.func			= event_trigger_callback,
+	.reg			= register_snapshot_trigger,
+	.unreg			= unregister_trigger,
+	.get_trigger_ops	= snapshot_get_trigger_ops,
+};
+
 static __init void unregister_trigger_traceon_traceoff_cmds(void)
 {
 	unregister_event_command(&trigger_traceon_cmd,
@@ -670,5 +751,13 @@ __init int register_trigger_cmds(void)
 		return ret;
 	}
 
+	ret = register_event_command(&trigger_snapshot_cmd,
+				     &trigger_commands,
+				     &trigger_cmd_mutex);
+	if (WARN_ON(ret < 0)) {
+		unregister_trigger_traceon_traceoff_cmds();
+		return ret;
+	}
+
 	return 0;
 }
-- 
1.7.11.4

