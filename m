Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab3F2FL5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 01:11:57 -0400
Received: from mga14.intel.com ([143.182.124.37]:6745 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab3F2FL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 01:11:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,963,1363158000"; 
   d="scan'208";a="324201311"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: masami.hiramatsu.pt@hitachi.com, jovi.zhangwei@huawei.com,
        linux-kernel@vger.kernel.org,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH v2 09/11] tracing: add 'enable_event' and 'disable_event' event trigger commands
Date: Sat, 29 Jun 2013 00:08:12 -0500
Message-Id: <8e560c59d197a6f44c3b0e57b9d27ee65ae3a187.1372479499.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <cover.1372479499.git.tom.zanussi@linux.intel.com>
References: <cover.1372479499.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1372479499.git.tom.zanussi@linux.intel.com>
References: <cover.1372479499.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add 'enable_event' and 'disable_event' event_command commands.

enable_event and disable_event event triggers are added by the user
via these commands in a similar way and using practically the same
syntax as the analagous 'enable_event' and 'disable_event' ftrace
function commands, but instead of writing to the set_ftrace_filter
file, the enable_event and disable_event triggers are written to the
per-event 'trigger' files:

    echo 'enable_event:system:event' > .../othersys/otherevent/trigger
    echo 'disable_event:system:event' > .../othersys/otherevent/trigger

The above commands will enable or disable the 'system:event' trace
events whenever the othersys:otherevent events are hit.

This also adds a 'count' version that limits the number of times the
command will be invoked:

    echo 'enable_event:system:event:N' > .../othersys/otherevent/trigger
    echo 'disable_event:system:event:N' > .../othersys/otherevent/trigger

Where N is the number of times the command will be invoked.

The above commands will will enable or disable the 'system:event'
trace events whenever the othersys:otherevent events are hit, but only
N times.

This also makes the find_event_file() helper function extern, since
it's useful to use from other places, such as the event triggers code,
so make it accessible.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 include/linux/ftrace_event.h        |   1 +
 kernel/trace/trace.h                |   4 +
 kernel/trace/trace_events.c         |   2 +-
 kernel/trace/trace_events_trigger.c | 365 ++++++++++++++++++++++++++++++++++++
 4 files changed, 371 insertions(+), 1 deletion(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 51c141e..57ca386 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -319,6 +319,7 @@ enum trigger_mode {
 	TM_TRACE_ONOFF		= (1 << 0),
 	TM_SNAPSHOT		= (1 << 1),
 	TM_STACKTRACE		= (1 << 2),
+	TM_EVENT_ENABLE		= (1 << 3),
 };
 
 extern void destroy_preds(struct ftrace_event_call *call);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index dd27b69..0dd2fc2 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1021,6 +1021,10 @@ extern void trace_event_enable_cmd_record(bool enable);
 extern int event_trace_add_tracer(struct dentry *parent, struct trace_array *tr);
 extern int event_trace_del_tracer(struct trace_array *tr);
 
+extern struct ftrace_event_file *find_event_file(struct trace_array *tr,
+						 const char *system,
+						 const char *event);
+
 extern struct mutex event_mutex;
 extern struct list_head ftrace_events;
 
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 3153389f..616a89f 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1877,7 +1877,7 @@ struct event_probe_data {
 	bool				enable;
 };
 
-static struct ftrace_event_file *
+struct ftrace_event_file *
 find_event_file(struct trace_array *tr, const char *system,  const char *event)
 {
 	struct ftrace_event_file *file;
diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index dd14e36..2300fc8 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -803,6 +803,359 @@ static __init void unregister_trigger_traceon_traceoff_cmds(void)
 				 &trigger_cmd_mutex);
 }
 
+/* Avoid typos */
+#define ENABLE_EVENT_STR	"enable_event"
+#define DISABLE_EVENT_STR	"disable_event"
+
+static void
+event_enable_trigger(void **_data)
+{
+	struct event_trigger_data **p = (struct event_trigger_data **)_data;
+	struct event_trigger_data *data = *p;
+
+	if (!data)
+		return;
+
+	if (data->enable)
+		clear_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &data->file->flags);
+	else
+		set_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &data->file->flags);
+}
+
+static void
+event_enable_count_trigger(void **_data)
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
+	/* Skip if the event is in a state we want to switch to */
+	if (data->enable == !(data->file->flags & FTRACE_EVENT_FL_SOFT_DISABLED))
+		return;
+
+	if (data->count != -1)
+		(data->count)--;
+
+	event_enable_trigger(_data);
+}
+
+static int
+event_enable_trigger_print(struct seq_file *m, struct event_trigger_ops *ops,
+			   void *_data)
+{
+	struct event_trigger_data *data = _data;
+
+	seq_printf(m, "%s:%s:%s",
+		   data->enable ? ENABLE_EVENT_STR : DISABLE_EVENT_STR,
+		   data->file->event_call->class->system,
+		   data->file->event_call->name);
+
+	if (data->count == -1)
+		seq_puts(m, ":unlimited");
+	else
+		seq_printf(m, ":count=%ld", data->count);
+
+	if (data->filter_str)
+		seq_printf(m, " if %s\n", data->filter_str);
+	else
+		seq_puts(m, "\n");
+
+	return 0;
+}
+
+static void
+event_enable_trigger_free(struct event_trigger_ops *ops, void **_data)
+{
+	struct event_trigger_data **p = (struct event_trigger_data **)_data;
+	struct event_trigger_data *data = *p;
+
+	if (WARN_ON_ONCE(data->ref <= 0))
+		return;
+
+	data->ref--;
+	if (!data->ref) {
+		/* Remove the TRIGGER_MODE flag */
+		trace_event_trigger_enable_disable(data->file, 0);
+		module_put(data->file->event_call->mod);
+		kfree(data);
+	}
+}
+
+static struct event_trigger_ops event_enable_trigger_ops = {
+	.func			= event_enable_trigger,
+	.print			= event_enable_trigger_print,
+	.init			= event_trigger_init,
+	.free			= event_enable_trigger_free,
+};
+
+static struct event_trigger_ops event_enable_count_trigger_ops = {
+	.func			= event_enable_count_trigger,
+	.print			= event_enable_trigger_print,
+	.init			= event_trigger_init,
+	.free			= event_enable_trigger_free,
+};
+
+static struct event_trigger_ops event_disable_trigger_ops = {
+	.func			= event_enable_trigger,
+	.print			= event_enable_trigger_print,
+	.init			= event_trigger_init,
+	.free			= event_enable_trigger_free,
+};
+
+static struct event_trigger_ops event_disable_count_trigger_ops = {
+	.func			= event_enable_count_trigger,
+	.print			= event_enable_trigger_print,
+	.init			= event_trigger_init,
+	.free			= event_enable_trigger_free,
+};
+
+static int
+event_enable_trigger_func(struct event_command *cmd_ops, void *cmd_data,
+			  char *glob, char *cmd, char *param, int enabled)
+{
+	struct trace_array *tr = top_trace_array();
+	struct ftrace_event_file *file;
+	struct event_trigger_ops *trigger_ops;
+	struct event_trigger_data *trigger_data;
+	const char *system;
+	const char *event;
+	char *trigger;
+	char *number;
+	bool enable;
+	int ret;
+
+	if (!enabled)
+		return -EINVAL;
+
+	if (!param)
+		return -EINVAL;
+
+	/* separate the trigger from the filter (s:e:n [if filter]) */
+	trigger = strsep(&param, " \t");
+	if (!trigger)
+		return -EINVAL;
+
+	system = strsep(&trigger, ":");
+	if (!trigger)
+		return -EINVAL;
+
+	event = strsep(&trigger, ":");
+
+	mutex_lock(&event_mutex);
+
+	ret = -EINVAL;
+	file = find_event_file(tr, system, event);
+	if (!file)
+		goto out;
+
+	enable = strcmp(cmd, ENABLE_EVENT_STR) == 0;
+
+	trigger_ops = cmd_ops->get_trigger_ops(cmd, trigger);
+
+	ret = -ENOMEM;
+	trigger_data = kzalloc(sizeof(*trigger_data), GFP_KERNEL);
+	if (!trigger_data)
+		goto out;
+
+	trigger_data->enable = enable;
+	trigger_data->count = -1;
+	trigger_data->file = file;
+	trigger_data->ops = trigger_ops;
+	INIT_LIST_HEAD(&trigger_data->list);
+	RCU_INIT_POINTER(trigger_data->filter, NULL);
+
+	if (glob[0] == '!') {
+		cmd_ops->unreg(glob+1, trigger_ops, trigger_data, cmd_data);
+		kfree(trigger_data);
+		ret = 0;
+		goto out;
+	}
+
+	if (trigger) {
+		number = strsep(&trigger, ":");
+
+		ret = -EINVAL;
+		if (!strlen(number))
+			goto out_free;
+
+		/*
+		 * We use the callback data field (which is a pointer)
+		 * as our counter.
+		 */
+		ret = kstrtoul(number, 0, &trigger_data->count);
+		if (ret)
+			goto out_free;
+	}
+
+	if (!param) /* if param is non-empty, it's supposed to be a filter */
+		goto out_reg;
+
+	if (!cmd_ops->set_filter)
+		goto out_reg;
+
+	ret = cmd_ops->set_filter(param, trigger_data, cmd_data);
+	if (ret < 0)
+		goto out_free;
+
+ out_reg:
+	/* Don't let event modules unload while probe registered */
+	ret = try_module_get(file->event_call->mod);
+	if (!ret) {
+		ret = -EBUSY;
+		goto out_free;
+	}
+
+	ret = trace_event_enable_disable(file, 1, 1);
+	if (ret < 0)
+		goto out_put;
+	ret = cmd_ops->reg(glob, trigger_ops, trigger_data, cmd_data);
+	/*
+	 * The above returns on success the # of functions enabled,
+	 * but if it didn't find any functions it returns zero.
+	 * Consider no functions a failure too.
+	 */
+	if (!ret) {
+		ret = -ENOENT;
+		goto out_disable;
+	} else if (ret < 0)
+		goto out_disable;
+	/* Just return zero, not the number of enabled functions */
+	ret = 0;
+ out:
+	mutex_unlock(&event_mutex);
+	return ret;
+
+ out_disable:
+	trace_event_enable_disable(file, 0, 1);
+ out_put:
+	module_put(file->event_call->mod);
+ out_free:
+	kfree(trigger_data);
+	goto out;
+}
+
+static int event_enable_register_trigger(char *glob,
+					 struct event_trigger_ops *ops,
+					 void *trigger_data, void *cmd_data)
+{
+	struct trigger_iterator *iter = cmd_data;
+	struct event_trigger_data *data = trigger_data;
+	struct event_trigger_data *test;
+	int ret = 0;
+
+	list_for_each_entry_rcu(test, &iter->file->triggers, list) {
+		if (test->file == data->file) {
+			ret = -EEXIST;
+			goto out;
+		}
+	}
+
+	if (data->ops->init) {
+		ret = data->ops->init(data->ops, (void **)&data);
+		if (ret < 0)
+			goto out;
+	}
+
+	list_add_rcu(&data->list, &iter->file->triggers);
+	ret++;
+
+	if (trace_event_trigger_enable_disable(iter->file, 1) < 0) {
+		list_del_rcu(&data->list);
+		ret--;
+	}
+out:
+	return ret;
+}
+
+static void event_enable_unregister_trigger(char *glob,
+					    struct event_trigger_ops *ops,
+					    void *trigger_data, void *cmd_data)
+{
+	struct trigger_iterator *iter = cmd_data;
+	struct event_trigger_data *test = trigger_data;
+	struct event_trigger_data *data;
+	bool unregistered = false;
+
+	list_for_each_entry_rcu(data, &iter->file->triggers, list) {
+		if (data->file == test->file) {
+			unregistered = true;
+			list_del_rcu(&data->list);
+			trace_event_trigger_enable_disable(iter->file, 0);
+			break;
+		}
+	}
+
+	if (unregistered && data->ops->free)
+		data->ops->free(data->ops, (void **)&data);
+}
+
+static struct event_trigger_ops *
+event_enable_get_trigger_ops(char *cmd, char *param)
+{
+	struct event_trigger_ops *ops;
+	bool enable;
+
+	enable = strcmp(cmd, ENABLE_EVENT_STR) == 0;
+
+	if (enable)
+		ops = param ? &event_enable_count_trigger_ops :
+			&event_enable_trigger_ops;
+	else
+		ops = param ? &event_disable_count_trigger_ops :
+			&event_disable_trigger_ops;
+
+	return ops;
+}
+
+static struct event_command trigger_enable_cmd = {
+	.name			= ENABLE_EVENT_STR,
+	.trigger_mode		= TM_EVENT_ENABLE,
+	.func			= event_enable_trigger_func,
+	.reg			= event_enable_register_trigger,
+	.unreg			= event_enable_unregister_trigger,
+	.get_trigger_ops	= event_enable_get_trigger_ops,
+};
+
+static struct event_command trigger_disable_cmd = {
+	.name			= DISABLE_EVENT_STR,
+	.trigger_mode		= TM_EVENT_ENABLE,
+	.func			= event_enable_trigger_func,
+	.reg			= event_enable_register_trigger,
+	.unreg			= event_enable_unregister_trigger,
+	.get_trigger_ops	= event_enable_get_trigger_ops,
+};
+
+static __init void unregister_trigger_enable_disable_cmds(void)
+{
+	unregister_event_command(&trigger_enable_cmd,
+				 &trigger_commands,
+				 &trigger_cmd_mutex);
+	unregister_event_command(&trigger_disable_cmd,
+				 &trigger_commands,
+				 &trigger_cmd_mutex);
+}
+
+static __init int register_trigger_enable_disable_cmds(void)
+{
+	int ret;
+
+	ret = register_event_command(&trigger_enable_cmd, &trigger_commands,
+				     &trigger_cmd_mutex);
+	if (WARN_ON(ret < 0))
+		return ret;
+	ret = register_event_command(&trigger_disable_cmd, &trigger_commands,
+				     &trigger_cmd_mutex);
+	if (WARN_ON(ret < 0))
+		unregister_trigger_enable_disable_cmds();
+
+	return ret;
+}
+
 static __init int register_trigger_traceon_traceoff_cmds(void)
 {
 	int ret;
@@ -848,5 +1201,17 @@ __init int register_trigger_cmds(void)
 		return ret;
 	}
 
+	ret = register_trigger_enable_disable_cmds();
+	if (ret) {
+		unregister_trigger_traceon_traceoff_cmds();
+		unregister_event_command(&trigger_snapshot_cmd,
+					 &trigger_commands,
+					 &trigger_cmd_mutex);
+		unregister_event_command(&trigger_stacktrace_cmd,
+					 &trigger_commands,
+					 &trigger_cmd_mutex);
+		return ret;
+	}
+
 	return 0;
 }
-- 
1.7.11.4

