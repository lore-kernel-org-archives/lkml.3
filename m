Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001Ab3IGP3r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 11:29:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:29562 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703Ab3IGP3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 11:29:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,859,1371106800"; 
   d="scan'208";a="399923548"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH v9 06/10] tracing: Add 'enable_event' and 'disable_event' event trigger commands
Date: Sat,  7 Sep 2013 10:29:02 -0500
Message-Id: <09ca405cd3b8fb7a7bb172bba551676cc220a615.1378565610.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <cover.1378565610.git.tom.zanussi@linux.intel.com>
References: <cover.1378565610.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1378565610.git.tom.zanussi@linux.intel.com>
References: <cover.1378565610.git.tom.zanussi@linux.intel.com>
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
 kernel/trace/trace_events_trigger.c | 366 ++++++++++++++++++++++++++++++++++++
 4 files changed, 372 insertions(+), 1 deletion(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 7b44c9e..d4957cd 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -321,6 +321,7 @@ enum event_trigger_type {
 	ETT_TRACE_ONOFF		= (1 << 0),
 	ETT_SNAPSHOT		= (1 << 1),
 	ETT_STACKTRACE		= (1 << 2),
+	ETT_EVENT_ENABLE	= (1 << 3),
 };
 
 extern void destroy_preds(struct ftrace_event_call *call);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index e2afe25..255c87c 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1017,6 +1017,10 @@ extern void trace_event_enable_cmd_record(bool enable);
 extern int event_trace_add_tracer(struct dentry *parent, struct trace_array *tr);
 extern int event_trace_del_tracer(struct trace_array *tr);
 
+extern struct ftrace_event_file *find_event_file(struct trace_array *tr,
+						 const char *system,
+						 const char *event);
+
 static inline void *event_file_data(struct file *filp)
 {
 	return ACCESS_ONCE(file_inode(filp)->i_private);
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 7d8eb8a..25b2c86 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1860,7 +1860,7 @@ struct event_probe_data {
 	bool				enable;
 };
 
-static struct ftrace_event_file *
+struct ftrace_event_file *
 find_event_file(struct trace_array *tr, const char *system,  const char *event)
 {
 	struct ftrace_event_file *file;
diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index e44fbc5..4d82b7b 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -835,6 +835,364 @@ static __init void unregister_trigger_traceon_traceoff_cmds(void)
 	unregister_event_command(&trigger_traceoff_cmd);
 }
 
+/* Avoid typos */
+#define ENABLE_EVENT_STR	"enable_event"
+#define DISABLE_EVENT_STR	"disable_event"
+
+struct enable_trigger_data {
+	struct ftrace_event_file	*file;
+	bool				enable;
+};
+
+static void
+event_enable_trigger(struct event_trigger_data *data)
+{
+	struct enable_trigger_data *enable_data = data->private_data;
+
+	if (enable_data->enable)
+		clear_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &enable_data->file->flags);
+	else
+		set_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &enable_data->file->flags);
+}
+
+static void
+event_enable_count_trigger(struct event_trigger_data *data)
+{
+	struct enable_trigger_data *enable_data = data->private_data;
+
+	if (!data->count)
+		return;
+
+	/* Skip if the event is in a state we want to switch to */
+	if (enable_data->enable == !(enable_data->file->flags & FTRACE_EVENT_FL_SOFT_DISABLED))
+		return;
+
+	if (data->count != -1)
+		(data->count)--;
+
+	event_enable_trigger(data);
+}
+
+static int
+event_enable_trigger_print(struct seq_file *m, struct event_trigger_ops *ops,
+			   struct event_trigger_data *data)
+{
+	struct enable_trigger_data *enable_data = data->private_data;
+
+	seq_printf(m, "%s:%s:%s",
+		   enable_data->enable ? ENABLE_EVENT_STR : DISABLE_EVENT_STR,
+		   enable_data->file->event_call->class->system,
+		   enable_data->file->event_call->name);
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
+event_enable_trigger_free(struct event_trigger_ops *ops,
+			  struct event_trigger_data *data)
+{
+	struct enable_trigger_data *enable_data = data->private_data;
+
+	if (WARN_ON_ONCE(data->ref <= 0))
+		return;
+
+	data->ref--;
+	if (!data->ref) {
+		/* Remove the SOFT_MODE flag */
+		trace_event_enable_disable(enable_data->file, 0, 1);
+		module_put(enable_data->file->event_call->mod);
+		trigger_data_free(data);
+		kfree(enable_data);
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
+event_enable_trigger_func(struct event_command *cmd_ops,
+			  struct ftrace_event_file *file,
+			  char *glob, char *cmd, char *param)
+{
+	struct ftrace_event_file *event_enable_file;
+	struct enable_trigger_data *enable_data;
+	struct event_trigger_data *trigger_data;
+	struct event_trigger_ops *trigger_ops;
+	struct trace_array *tr = file->tr;
+	const char *system;
+	const char *event;
+	char *trigger;
+	char *number;
+	bool enable;
+	int ret;
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
+	ret = -EINVAL;
+	event_enable_file = find_event_file(tr, system, event);
+	if (!event_enable_file)
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
+	enable_data = kzalloc(sizeof(*enable_data), GFP_KERNEL);
+	if (!enable_data) {
+		kfree(trigger_data);
+		goto out;
+	}
+
+	trigger_data->count = -1;
+	trigger_data->ops = trigger_ops;
+	trigger_data->cmd_ops = cmd_ops;
+	INIT_LIST_HEAD(&trigger_data->list);
+	RCU_INIT_POINTER(trigger_data->filter, NULL);
+
+	enable_data->enable = enable;
+	enable_data->file = event_enable_file;
+	trigger_data->private_data = enable_data;
+
+	if (glob[0] == '!') {
+		cmd_ops->unreg(glob+1, trigger_ops, trigger_data, file);
+		kfree(trigger_data);
+		kfree(enable_data);
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
+	ret = cmd_ops->set_filter(param, trigger_data, file);
+	if (ret < 0)
+		goto out_free;
+
+ out_reg:
+	/* Don't let event modules unload while probe registered */
+	ret = try_module_get(event_enable_file->event_call->mod);
+	if (!ret) {
+		ret = -EBUSY;
+		goto out_free;
+	}
+
+	ret = trace_event_enable_disable(event_enable_file, 1, 1);
+	if (ret < 0)
+		goto out_put;
+	ret = cmd_ops->reg(glob, trigger_ops, trigger_data, file);
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
+	return ret;
+
+ out_disable:
+	trace_event_enable_disable(event_enable_file, 0, 1);
+ out_put:
+	module_put(event_enable_file->event_call->mod);
+ out_free:
+	kfree(trigger_data);
+	kfree(enable_data);
+	goto out;
+}
+
+static int event_enable_register_trigger(char *glob,
+					 struct event_trigger_ops *ops,
+					 struct event_trigger_data *data,
+					 struct ftrace_event_file *file)
+{
+	struct enable_trigger_data *enable_data = data->private_data;
+	struct enable_trigger_data *test_enable_data;
+	struct event_trigger_data *test;
+	int ret = 0;
+
+	list_for_each_entry_rcu(test, &file->triggers, list) {
+		test_enable_data = test->private_data;
+		if (test_enable_data &&
+		    (test_enable_data->file == enable_data->file)) {
+			ret = -EEXIST;
+			goto out;
+		}
+	}
+
+	if (data->ops->init) {
+		ret = data->ops->init(data->ops, data);
+		if (ret < 0)
+			goto out;
+	}
+
+	list_add_rcu(&data->list, &file->triggers);
+	ret++;
+
+	if (trace_event_trigger_enable_disable(file, 1) < 0) {
+		list_del_rcu(&data->list);
+		ret--;
+	}
+out:
+	return ret;
+}
+
+static void event_enable_unregister_trigger(char *glob,
+					    struct event_trigger_ops *ops,
+					    struct event_trigger_data *test,
+					    struct ftrace_event_file *file)
+{
+	struct enable_trigger_data *test_enable_data = test->private_data;
+	struct enable_trigger_data *enable_data;
+	struct event_trigger_data *data;
+	bool unregistered = false;
+
+	list_for_each_entry_rcu(data, &file->triggers, list) {
+		enable_data = data->private_data;
+		if (enable_data &&
+		    (enable_data->file == test_enable_data->file)) {
+			unregistered = true;
+			list_del_rcu(&data->list);
+			trace_event_trigger_enable_disable(file, 0);
+			break;
+		}
+	}
+
+	if (unregistered && data->ops->free)
+		data->ops->free(data->ops, data);
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
+	.trigger_type		= ETT_EVENT_ENABLE,
+	.func			= event_enable_trigger_func,
+	.reg			= event_enable_register_trigger,
+	.unreg			= event_enable_unregister_trigger,
+	.get_trigger_ops	= event_enable_get_trigger_ops,
+};
+
+static struct event_command trigger_disable_cmd = {
+	.name			= DISABLE_EVENT_STR,
+	.trigger_type		= ETT_EVENT_ENABLE,
+	.func			= event_enable_trigger_func,
+	.reg			= event_enable_register_trigger,
+	.unreg			= event_enable_unregister_trigger,
+	.get_trigger_ops	= event_enable_get_trigger_ops,
+};
+
+static __init void unregister_trigger_enable_disable_cmds(void)
+{
+	unregister_event_command(&trigger_enable_cmd);
+	unregister_event_command(&trigger_disable_cmd);
+}
+
+static __init int register_trigger_enable_disable_cmds(void)
+{
+	int ret;
+
+	ret = register_event_command(&trigger_enable_cmd);
+	if (WARN_ON(ret < 0))
+		return ret;
+	ret = register_event_command(&trigger_disable_cmd);
+	if (WARN_ON(ret < 0))
+		unregister_trigger_enable_disable_cmds();
+
+	return ret;
+}
+
 static __init int register_trigger_traceon_traceoff_cmds(void)
 {
 	int ret;
@@ -872,5 +1230,13 @@ __init int register_trigger_cmds(void)
 		return ret;
 	}
 
+	ret = register_trigger_enable_disable_cmds();
+	if (ret) {
+		unregister_trigger_traceon_traceoff_cmds();
+		unregister_event_command(&trigger_snapshot_cmd);
+		unregister_event_command(&trigger_stacktrace_cmd);
+		return ret;
+	}
+
 	return 0;
 }
-- 
1.7.11.4

