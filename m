Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab3H0Tml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 15:42:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:22556 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753790Ab3H0Tkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 15:40:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,970,1367996400"; 
   d="scan'208";a="387315487"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH v7 05/10] tracing: add 'stacktrace' event trigger command
Date: Tue, 27 Aug 2013 14:40:17 -0500
Message-Id: <11346b57531e8371450b3aee4915f1c5d427f7f0.1377631572.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <cover.1377631572.git.tom.zanussi@linux.intel.com>
References: <cover.1377631572.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1377631572.git.tom.zanussi@linux.intel.com>
References: <cover.1377631572.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add 'stacktrace' ftrace_func_command.  stacktrace event triggers are
added by the user via this command in a similar way and using
practically the same syntax as the analogous 'stacktrace' ftrace
function command, but instead of writing to the set_ftrace_filter
file, the stacktrace event trigger is written to the per-event
'trigger' files:

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
 kernel/trace/trace_events_trigger.c | 90 +++++++++++++++++++++++++++++++++++++
 2 files changed, 91 insertions(+)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 21fae3d..df5eae9 100644
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
index 1c266f9..c83f56f 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -790,6 +790,85 @@ static struct event_command trigger_snapshot_cmd = {
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
+stacktrace_trigger(void **_data)
+{
+	struct event_trigger_data **p = (struct event_trigger_data **)_data;
+	struct event_trigger_data *data = *p;
+
+	if (!data)
+		return;
+
+	trace_dump_stack(STACK_SKIP);
+}
+
+static void
+stacktrace_count_trigger(void **_data)
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
+	stacktrace_trigger(_data);
+}
+
+static int
+stacktrace_trigger_print(struct seq_file *m, struct event_trigger_ops *ops,
+			 void *_data)
+{
+	struct event_trigger_data *data = _data;
+
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
@@ -834,5 +913,16 @@ __init int register_trigger_cmds(void)
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

