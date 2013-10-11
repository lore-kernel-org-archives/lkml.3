Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab3JKAsx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 20:48:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:11959 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755715Ab3JKAsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 20:48:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1075,1371106800"; 
   d="scan'208";a="391352609"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH v10 05/12] tracing: Add 'stacktrace' event trigger command
Date: Thu, 10 Oct 2013 19:48:29 -0500
Message-Id: <efd22d6f203f9f8db63906169712b1b030e830c2.1381445299.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <cover.1381445299.git.tom.zanussi@linux.intel.com>
References: <cover.1381445299.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1381445299.git.tom.zanussi@linux.intel.com>
References: <cover.1381445299.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 include/linux/ftrace_event.h        |  1 +
 kernel/trace/trace_events_trigger.c | 79 +++++++++++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 40b517b..31750df 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -320,6 +320,7 @@ enum event_trigger_type {
 	ETT_NONE		= (0),
 	ETT_TRACE_ONOFF		= (1 << 0),
 	ETT_SNAPSHOT		= (1 << 1),
+	ETT_STACKTRACE		= (1 << 2),
 };
 
 extern void destroy_preds(struct ftrace_event_call *call);
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
1.7.11.4

