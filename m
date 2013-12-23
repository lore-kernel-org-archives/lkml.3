Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203Ab3LWVko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 16:40:44 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:60833 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758131Ab3LWVjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:39:19 -0500
Message-Id: <20131223213914.366238969@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 23 Dec 2013 16:38:14 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 04/10] tracing: Add stacktrace event trigger command
References: <20131223213810.967436536@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-Add-stacktrace-event-trigger-command.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tom.zanussi@linux.intel.com>

Add 'stacktrace' event_command.  stacktrace event triggers are added
by the user via this command in a similar way and using practically
the same syntax as the analogous 'stacktrace' ftrace function command,
but instead of writing to the set_ftrace_filter file, the stacktrace
event trigger is written to the per-event 'trigger' files:

    echo 'stacktrace' > .../tracing/events/somesys/someevent/trigger

The above command will turn on stacktraces for someevent i.e. whenever
someevent is hit, a stacktrace will be logged.

This also adds a 'count' version that limits the number of times the
command will be invoked:

    echo 'stacktrace:N' > .../tracing/events/somesys/someevent/trigger

Where N is the number of times the command will be invoked.

The above command will log N stacktraces for someevent i.e. whenever
someevent is hit N times, a stacktrace will be logged.

Link: http://lkml.kernel.org/r/0c30c008a0828c660aa0e1bbd3255cf179ed5c30.1382622043.git.tom.zanussi@linux.intel.com

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h        |  1 +
 kernel/trace/trace_events_trigger.c | 79 +++++++++++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 6efa8c2..65caee4 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -347,6 +347,7 @@ enum event_trigger_type {
 	ETT_NONE		= (0),
 	ETT_TRACE_ONOFF		= (1 << 0),
 	ETT_SNAPSHOT		= (1 << 1),
+	ETT_STACKTRACE		= (1 << 2),
 };
 
 extern void destroy_preds(struct ftrace_event_file *file);
diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index d775c3d..a3bd1da 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -780,6 +780,84 @@ static __init int register_trigger_snapshot_cmd(void)
 static __init int register_trigger_snapshot_cmd(void) { return 0; }
 #endif /* CONFIG_TRACER_SNAPSHOT */
 
+#ifdef CONFIG_STACKTRACE
+/*
+ * Skip 3:
+ *   stacktrace_trigger()
+ *   event_triggers_post_call()
+ *   ftrace_raw_event_xxx()
+ */
+#define STACK_SKIP 3
+
+static void
+stacktrace_trigger(struct event_trigger_data *data)
+{
+	trace_dump_stack(STACK_SKIP);
+}
+
+static void
+stacktrace_count_trigger(struct event_trigger_data *data)
+{
+	if (!data->count)
+		return;
+
+	if (data->count != -1)
+		(data->count)--;
+
+	stacktrace_trigger(data);
+}
+
+static int
+stacktrace_trigger_print(struct seq_file *m, struct event_trigger_ops *ops,
+			 struct event_trigger_data *data)
+{
+	return event_trigger_print("stacktrace", m, (void *)data->count,
+				   data->filter_str);
+}
+
+static struct event_trigger_ops stacktrace_trigger_ops = {
+	.func			= stacktrace_trigger,
+	.print			= stacktrace_trigger_print,
+	.init			= event_trigger_init,
+	.free			= event_trigger_free,
+};
+
+static struct event_trigger_ops stacktrace_count_trigger_ops = {
+	.func			= stacktrace_count_trigger,
+	.print			= stacktrace_trigger_print,
+	.init			= event_trigger_init,
+	.free			= event_trigger_free,
+};
+
+static struct event_trigger_ops *
+stacktrace_get_trigger_ops(char *cmd, char *param)
+{
+	return param ? &stacktrace_count_trigger_ops : &stacktrace_trigger_ops;
+}
+
+static struct event_command trigger_stacktrace_cmd = {
+	.name			= "stacktrace",
+	.trigger_type		= ETT_STACKTRACE,
+	.post_trigger		= true,
+	.func			= event_trigger_callback,
+	.reg			= register_trigger,
+	.unreg			= unregister_trigger,
+	.get_trigger_ops	= stacktrace_get_trigger_ops,
+};
+
+static __init int register_trigger_stacktrace_cmd(void)
+{
+	int ret;
+
+	ret = register_event_command(&trigger_stacktrace_cmd);
+	WARN_ON(ret < 0);
+
+	return ret;
+}
+#else
+static __init int register_trigger_stacktrace_cmd(void) { return 0; }
+#endif /* CONFIG_STACKTRACE */
+
 static __init void unregister_trigger_traceon_traceoff_cmds(void)
 {
 	unregister_event_command(&trigger_traceon_cmd);
@@ -804,6 +882,7 @@ __init int register_trigger_cmds(void)
 {
 	register_trigger_traceon_traceoff_cmds();
 	register_trigger_snapshot_cmd();
+	register_trigger_stacktrace_cmd();
 
 	return 0;
 }
-- 
1.8.4.3


