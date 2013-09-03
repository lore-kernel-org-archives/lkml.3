Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289Ab3ICDwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 23:52:46 -0400
Received: from mga14.intel.com ([143.182.124.37]:9807 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759356Ab3ICDwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 23:52:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1011,1367996400"; 
   d="scan'208";a="355054723"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH v8 03/10] tracing: Add 'traceon' and 'traceoff' event trigger commands
Date: Mon,  2 Sep 2013 22:52:19 -0500
Message-Id: <33cc30439cc2c729abb1644c2696d54d03ac6548.1378176577.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <cover.1378176577.git.tom.zanussi@linux.intel.com>
References: <cover.1378176577.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1378176577.git.tom.zanussi@linux.intel.com>
References: <cover.1378176577.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add 'traceon' and 'traceoff' event_command commands.  traceon and
traceoff event triggers are added by the user via these commands in a
similar way and using practically the same syntax as the analagous
'traceon' and 'traceoff' ftrace function commands, but instead of
writing to the set_ftrace_filter file, the traceon and traceoff
triggers are written to the per-event 'trigger' files:

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

Some common register/unregister_trigger() implementations of the
event_command reg()/unreg() callbacks are also provided, which add and
remove trigger instances to the per-event list of triggers, and
arm/disarm them as appropriate.  event_trigger_callback() is a
general-purpose event_command func() implementation that orchestrates
command parsing and registration for most normal commands.

Most event commands will use these, but some will override and
possibly reuse them.

The event_trigger_init(), event_trigger_free(), and
event_trigger_print() functions are meant to be common implementations
of the event_trigger_ops init(), free(), and print() ops,
respectively.

Most trigger_ops implementations will use these, but some will
override and possibly reuse them.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 include/linux/ftrace_event.h        |   1 +
 kernel/trace/trace_events_trigger.c | 436 ++++++++++++++++++++++++++++++++++++
 2 files changed, 437 insertions(+)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 34ae1d4..a14650b 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -318,6 +318,7 @@ struct ftrace_event_file {
 
 enum event_trigger_type {
 	ETT_NONE		= (0),
+	ETT_TRACE_ONOFF		= (1 << 0),
 };
 
 extern void destroy_preds(struct ftrace_event_call *call);
diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index 85319cf..5388d55 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -28,6 +28,13 @@
 static LIST_HEAD(trigger_commands);
 static DEFINE_MUTEX(trigger_cmd_mutex);
 
+static void
+trigger_data_free(struct event_trigger_data *data)
+{
+	synchronize_sched(); /* make sure current triggers exit before free */
+	kfree(data);
+}
+
 void event_triggers_call(struct ftrace_event_file *file)
 {
 	struct event_trigger_data *data;
@@ -215,6 +222,121 @@ const struct file_operations event_trigger_fops = {
 	.release = event_trigger_release,
 };
 
+/*
+ * Currently we only register event commands from __init, so mark this
+ * __init too.
+ */
+static __init int register_event_command(struct event_command *cmd,
+					 struct list_head *cmd_list,
+					 struct mutex *cmd_list_mutex)
+{
+	struct event_command *p;
+	int ret = 0;
+
+	mutex_lock(cmd_list_mutex);
+	list_for_each_entry(p, cmd_list, list) {
+		if (strcmp(cmd->name, p->name) == 0) {
+			ret = -EBUSY;
+			goto out_unlock;
+		}
+	}
+	list_add(&cmd->list, cmd_list);
+ out_unlock:
+	mutex_unlock(cmd_list_mutex);
+
+	return ret;
+}
+
+/*
+ * Currently we only unregister event commands from __init, so mark
+ * this __init too.
+ */
+static __init int unregister_event_command(struct event_command *cmd,
+					   struct list_head *cmd_list,
+					   struct mutex *cmd_list_mutex)
+{
+	struct event_command *p, *n;
+	int ret = -ENODEV;
+
+	mutex_lock(cmd_list_mutex);
+	list_for_each_entry_safe(p, n, cmd_list, list) {
+		if (strcmp(cmd->name, p->name) == 0) {
+			ret = 0;
+			list_del_init(&p->list);
+			goto out_unlock;
+		}
+	}
+ out_unlock:
+	mutex_unlock(cmd_list_mutex);
+
+	return ret;
+}
+
+/**
+ * event_trigger_print - generic event_trigger_ops @print implementation
+ *
+ * Common implementation for event triggers to print themselves.
+ *
+ * Usually wrapped by a function that simply sets the @name of the
+ * trigger command and then invokes this.
+ */
+static int
+event_trigger_print(const char *name, struct seq_file *m,
+		    void *data, char *filter_str)
+{
+	long count = (long)data;
+
+	seq_printf(m, "%s", name);
+
+	if (count == -1)
+		seq_puts(m, ":unlimited");
+	else
+		seq_printf(m, ":count=%ld", count);
+
+	if (filter_str)
+		seq_printf(m, " if %s\n", filter_str);
+	else
+		seq_puts(m, "\n");
+
+	return 0;
+}
+
+/**
+ * event_trigger_init - generic event_trigger_ops @init implementation
+ *
+ * Common implementation of event trigger initialization.
+ *
+ * Usually used directly as the @init method in event trigger
+ * implementations.
+ */
+static int
+event_trigger_init(struct event_trigger_ops *ops,
+		   struct event_trigger_data *data)
+{
+	data->ref++;
+	return 0;
+}
+
+/**
+ * event_trigger_free - generic event_trigger_ops @free implementation
+ *
+ * Common implementation of event trigger de-initialization.
+ *
+ * Usually used directly as the @free method in event trigger
+ * implementations.
+ */
+static void
+event_trigger_free(struct event_trigger_ops *ops,
+		   struct event_trigger_data *data)
+{
+	if (WARN_ON_ONCE(data->ref <= 0))
+		return;
+
+	data->ref--;
+	if (!data->ref)
+		trigger_data_free(data);
+}
+
 static int trace_event_trigger_enable_disable(struct ftrace_event_file *file,
 					      int trigger_enable)
 {
@@ -262,7 +384,321 @@ clear_event_triggers(struct trace_array *tr)
 	}
 }
 
+/**
+ * register_trigger - generic event_command @reg implementation
+ *
+ * Common implementation for event trigger registration.
+ *
+ * Usually used directly as the @reg method in event command
+ * implementations.
+ */
+static int register_trigger(char *glob, struct event_trigger_ops *ops,
+			    struct event_trigger_data *data,
+			    struct ftrace_event_file *file)
+{
+	struct event_trigger_data *test;
+	int ret = 0;
+
+	list_for_each_entry_rcu(test, &file->triggers, list) {
+		if (test->cmd_ops->trigger_type == data->cmd_ops->trigger_type) {
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
+/**
+ * unregister_trigger - generic event_command @unreg implementation
+ *
+ * Common implementation for event trigger unregistration.
+ *
+ * Usually used directly as the @unreg method in event command
+ * implementations.
+ */
+static void unregister_trigger(char *glob, struct event_trigger_ops *ops,
+			       struct event_trigger_data *test,
+			       struct ftrace_event_file *file)
+{
+	struct event_trigger_data *data;
+	bool unregistered = false;
+
+	list_for_each_entry_rcu(data, &file->triggers, list) {
+		if (data->cmd_ops->trigger_type == test->cmd_ops->trigger_type) {
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
+/**
+ * event_trigger_callback - generic event_command @func implementation
+ *
+ * Common implementation for event command parsing and trigger
+ * instantiation.
+ *
+ * Usually used directly as the @func method in event command
+ * implementations.
+ */
+static int
+event_trigger_callback(struct event_command *cmd_ops,
+		       struct ftrace_event_file *file,
+		       char *glob, char *cmd, char *param, int enabled)
+{
+	struct event_trigger_data *trigger_data;
+	struct event_trigger_ops *trigger_ops;
+	char *trigger = NULL;
+	char *number;
+	int ret;
+
+	if (!enabled)
+		return -EINVAL;
+
+	/* separate the trigger from the filter (t:n [if filter]) */
+	if (param && isdigit(param[0]))
+		trigger = strsep(&param, " \t");
+
+	trigger_ops = cmd_ops->get_trigger_ops(cmd, trigger);
+
+	ret = -ENOMEM;
+	trigger_data = kzalloc(sizeof(*trigger_data), GFP_KERNEL);
+	if (!trigger_data)
+		goto out;
+
+	trigger_data->count = -1;
+	trigger_data->ops = trigger_ops;
+	trigger_data->cmd_ops = cmd_ops;
+	INIT_LIST_HEAD(&trigger_data->list);
+
+	if (glob[0] == '!') {
+		cmd_ops->unreg(glob+1, trigger_ops, trigger_data, file);
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
+	ret = cmd_ops->set_filter(param, trigger_data, file);
+	if (ret < 0)
+		goto out_free;
+
+ out_reg:
+	ret = cmd_ops->reg(glob, trigger_ops, trigger_data, file);
+	/*
+	 * The above returns on success the # of functions enabled,
+	 * but if it didn't find any functions it returns zero.
+	 * Consider no functions a failure too.
+	 */
+	if (!ret) {
+		ret = -ENOENT;
+		goto out_free;
+	} else if (ret < 0)
+		goto out_free;
+	ret = 0;
+ out:
+	return ret;
+
+ out_free:
+	kfree(trigger_data);
+	goto out;
+}
+
+static void
+traceon_trigger(struct event_trigger_data *data)
+{
+	if (tracing_is_on())
+		return;
+
+	tracing_on();
+}
+
+static void
+traceon_count_trigger(struct event_trigger_data *data)
+{
+	if (!data->count)
+		return;
+
+	if (data->count != -1)
+		(data->count)--;
+
+	traceon_trigger(data);
+}
+
+static void
+traceoff_trigger(struct event_trigger_data *data)
+{
+	if (!tracing_is_on())
+		return;
+
+	tracing_off();
+}
+
+static void
+traceoff_count_trigger(struct event_trigger_data *data)
+{
+	if (!data->count)
+		return;
+
+	if (data->count != -1)
+		(data->count)--;
+
+	traceoff_trigger(data);
+}
+
+static int
+traceon_trigger_print(struct seq_file *m, struct event_trigger_ops *ops,
+		      struct event_trigger_data *data)
+{
+	return event_trigger_print("traceon", m, (void *)data->count,
+				   data->filter_str);
+}
+
+static int
+traceoff_trigger_print(struct seq_file *m, struct event_trigger_ops *ops,
+		       struct event_trigger_data *data)
+{
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
+	.trigger_type		= ETT_TRACE_ONOFF,
+	.func			= event_trigger_callback,
+	.reg			= register_trigger,
+	.unreg			= unregister_trigger,
+	.get_trigger_ops	= onoff_get_trigger_ops,
+};
+
+static struct event_command trigger_traceoff_cmd = {
+	.name			= "traceoff",
+	.trigger_type		= ETT_TRACE_ONOFF,
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

