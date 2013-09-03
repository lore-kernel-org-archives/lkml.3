Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327Ab3ICDw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 23:52:57 -0400
Received: from mga14.intel.com ([143.182.124.37]:9807 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759365Ab3ICDwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 23:52:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1011,1367996400"; 
   d="scan'208";a="355054751"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH v8 05/10] tracing: Add 'stacktrace' event trigger command
Date: Mon,  2 Sep 2013 22:52:21 -0500
Message-Id: <d9fce1a71bc3bcfb298d6c837c7892e12147257e.1378176577.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <cover.1378176577.git.tom.zanussi@linux.intel.com>
References: <cover.1378176577.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1378176577.git.tom.zanussi@linux.intel.com>
References: <cover.1378176577.git.tom.zanussi@linux.intel.com>
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
 kernel/trace/trace_events_trigger.c | 76 +++++++++++++++++++++++++++++++++++++
 2 files changed, 77 insertions(+)

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
index 9bdcc38..36b6601 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -732,6 +732,71 @@ static struct event_command trigger_snapshot_cmd = {
 	.get_trigger_ops	= snapshot_get_trigger_ops,
 };
 
+/*
+ * Skip 4:
+ *   ftrace_stacktrace()
+ *   function_trace_probe_call()
+ *   ftrace_ops_list_func()
+ *   ftrace_call()
+ */
+#define STACK_SKIP 4
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
 static __init void unregister_trigger_traceon_traceoff_cmds(void)
 {
 	unregister_event_command(&trigger_traceon_cmd,
@@ -776,5 +841,16 @@ __init int register_trigger_cmds(void)
 		return ret;
 	}
 
+	ret = register_event_command(&trigger_stacktrace_cmd,
+				      &trigger_commands,
+				      &trigger_cmd_mutex);
+	if (WARN_ON(ret < 0)) {
+		unregister_trigger_traceon_traceoff_cmds();
+		unregister_event_command(&trigger_snapshot_cmd,
+					 &trigger_commands,
+					 &trigger_cmd_mutex);
+		return ret;
+	}
+
 	return 0;
 }
-- 
1.7.11.4

