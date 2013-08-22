Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab3HVT6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 15:58:11 -0400
Received: from mga14.intel.com ([143.182.124.37]:45279 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754290Ab3HVT6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 15:58:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,935,1367996400"; 
   d="scan'208";a="350324320"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH v5 03/10] tracing: add 'traceon' and 'traceoff' event trigger commands
Date: Thu, 22 Aug 2013 14:57:36 -0500
Message-Id: <23856abbebc21b4292e36d461b3824fe50f1c11a.1377183739.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <cover.1377183739.git.tom.zanussi@linux.intel.com>
References: <cover.1377183739.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1377183739.git.tom.zanussi@linux.intel.com>
References: <cover.1377183739.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add 'traceon' and 'traceoff' ftrace_func_command commands.  traceon
and traceoff event triggers are added by the user via these commands
in a similar way and using practically the same syntax as the
analagous 'traceon' and 'traceoff' ftrace function commands, but
instead of writing to the set_ftrace_filter file, the traceon and
traceoff triggers are written to the per-event 'trigger' files:

    echo 'traceon' > .../tracing/events/somesys/someevent/trigger
    echo 'traceoff' > .../tracing/events/somesys/someevent/trigger

The above command will turn tracing on or off whenever someevent is
hit.

This also adds a 'count' version that limits the number of times the
command will be invoked:

    echo 'traceon:N' > .../tracing/events/somesys/someevent/trigger
    echo 'traceoff:N' > .../tracing/events/somesys/someevent/trigger

Where N is the number of times the command will be invoked.

The above commands will will turn tracing on or off whenever someevent
is hit, but only N times.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 include/linux/ftrace_event.h        |   1 +
 kernel/trace/trace_events_trigger.c | 182 ++++++++++++++++++++++++++++++++++++
 2 files changed, 183 insertions(+)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 06be0fe..ec50e53 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -318,6 +318,7 @@ struct ftrace_event_file {
 
 enum trigger_mode {
 	TM_NONE			= (0),
+	TM_TRACE_ONOFF		= (1 << 0),
 };
 
 extern void destroy_preds(struct ftrace_event_call *call);
diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index 7a52109..d5a10ed 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -564,7 +564,189 @@ event_trigger_callback(struct event_command *cmd_ops,
 	goto out;
 }
 
+static void
+traceon_trigger(void **_data)
+{
+	struct event_trigger_data **p = (struct event_trigger_data **)_data;
+	struct event_trigger_data *data = *p;
+
+	if (!data)
+		return;
+
+	if (tracing_is_on())
+		return;
+
+	tracing_on();
+}
+
+static void
+traceon_count_trigger(void **_data)
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
+	traceon_trigger(_data);
+}
+
+static void
+traceoff_trigger(void **_data)
+{
+	struct event_trigger_data **p = (struct event_trigger_data **)_data;
+	struct event_trigger_data *data = *p;
+
+	if (!data)
+		return;
+
+	if (!tracing_is_on())
+		return;
+
+	tracing_off();
+}
+
+static void
+traceoff_count_trigger(void **_data)
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
+	traceoff_trigger(_data);
+}
+
+static int
+traceon_trigger_print(struct seq_file *m, struct event_trigger_ops *ops,
+		      void *_data)
+{
+	struct event_trigger_data *data = _data;
+
+	return event_trigger_print("traceon", m, (void *)data->count,
+				   data->filter_str);
+}
+
+static int
+traceoff_trigger_print(struct seq_file *m, struct event_trigger_ops *ops,
+		       void *_data)
+{
+	struct event_trigger_data *data = _data;
+
+	return event_trigger_print("traceoff", m, (void *)data->count,
+				   data->filter_str);
+}
+
+static struct event_trigger_ops traceon_trigger_ops = {
+	.func			= traceon_trigger,
+	.print			= traceon_trigger_print,
+	.init			= event_trigger_init,
+	.free			= event_trigger_free,
+};
+
+static struct event_trigger_ops traceon_count_trigger_ops = {
+	.func			= traceon_count_trigger,
+	.print			= traceon_trigger_print,
+	.init			= event_trigger_init,
+	.free			= event_trigger_free,
+};
+
+static struct event_trigger_ops traceoff_trigger_ops = {
+	.func			= traceoff_trigger,
+	.print			= traceoff_trigger_print,
+	.init			= event_trigger_init,
+	.free			= event_trigger_free,
+};
+
+static struct event_trigger_ops traceoff_count_trigger_ops = {
+	.func			= traceoff_count_trigger,
+	.print			= traceoff_trigger_print,
+	.init			= event_trigger_init,
+	.free			= event_trigger_free,
+};
+
+static struct event_trigger_ops *
+onoff_get_trigger_ops(char *cmd, char *param)
+{
+	struct event_trigger_ops *ops;
+
+	/* we register both traceon and traceoff to this callback */
+	if (strcmp(cmd, "traceon") == 0)
+		ops = param ? &traceon_count_trigger_ops :
+			&traceon_trigger_ops;
+	else
+		ops = param ? &traceoff_count_trigger_ops :
+			&traceoff_trigger_ops;
+
+	return ops;
+}
+
+static struct event_command trigger_traceon_cmd = {
+	.name			= "traceon",
+	.trigger_mode		= TM_TRACE_ONOFF,
+	.func			= event_trigger_callback,
+	.reg			= register_trigger,
+	.unreg			= unregister_trigger,
+	.get_trigger_ops	= onoff_get_trigger_ops,
+};
+
+static struct event_command trigger_traceoff_cmd = {
+	.name			= "traceoff",
+	.trigger_mode		= TM_TRACE_ONOFF,
+	.func			= event_trigger_callback,
+	.reg			= register_trigger,
+	.unreg			= unregister_trigger,
+	.get_trigger_ops	= onoff_get_trigger_ops,
+};
+
+static __init void unregister_trigger_traceon_traceoff_cmds(void)
+{
+	unregister_event_command(&trigger_traceon_cmd,
+				 &trigger_commands,
+				 &trigger_cmd_mutex);
+	unregister_event_command(&trigger_traceoff_cmd,
+				 &trigger_commands,
+				 &trigger_cmd_mutex);
+}
+
+static __init int register_trigger_traceon_traceoff_cmds(void)
+{
+	int ret;
+
+	ret = register_event_command(&trigger_traceon_cmd, &trigger_commands,
+				     &trigger_cmd_mutex);
+	if (WARN_ON(ret < 0))
+		return ret;
+	ret = register_event_command(&trigger_traceoff_cmd, &trigger_commands,
+				     &trigger_cmd_mutex);
+	if (WARN_ON(ret < 0))
+		unregister_trigger_traceon_traceoff_cmds();
+
+	return ret;
+}
+
 __init int register_trigger_cmds(void)
 {
+	int ret;
+
+	ret = register_trigger_traceon_traceoff_cmds();
+	if (ret) {
+		unregister_trigger_traceon_traceoff_cmds();
+		return ret;
+	}
+
 	return 0;
 }
-- 
1.7.11.4

