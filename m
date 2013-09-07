Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab3IGP3v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 11:29:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:29562 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731Ab3IGP3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 11:29:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,859,1371106800"; 
   d="scan'208";a="399923552"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH v9 07/10] tracing: Add and use generic set_trigger_filter() implementation
Date: Sat,  7 Sep 2013 10:29:03 -0500
Message-Id: <7db8b7605974c7dd296d5be18ef0954982aa80fe.1378565610.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <cover.1378565610.git.tom.zanussi@linux.intel.com>
References: <cover.1378565610.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1378565610.git.tom.zanussi@linux.intel.com>
References: <cover.1378565610.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a generic event_command.set_trigger_filter() op implementation and
have the current set of trigger commands use it - this essentially
gives them all support for filters.

Syntactically, filters are supported by adding 'if <filter>' just
after the command, in which case only events matching the filter will
invoke the trigger.  For example, to add a filter to an
enable/disable_event command:

    echo 'enable_event:system:event if common_pid == 999' > \
              .../othersys/otherevent/trigger

The above command will only enable the system:event event if the
common_pid field in the othersys:otherevent event is 999.

As another example, to add a filter to a stacktrace command:

    echo 'stacktrace if common_pid == 999' > \
                   .../somesys/someevent/trigger

The above command will only trigger a stacktrace if the common_pid
field in the event is 999.

The filter syntax is the same as that described in the 'Event
filtering' section of Documentation/trace/events.txt.

Because triggers can now use filters, the trigger-invoking logic needs
to be moved in those cases - e.g. for ftrace_raw_event_calls, if a
trigger has a filter associated with it, the trigger invocation now
needs to happen after the { assign; } part of the call, in order for
the trigger condition to be tested.

There's still a SOFT_DISABLED-only check at the top of e.g. the
ftrace_raw_events function, so when an event is soft disabled but not
because of the presence of a trigger, the original SOFT_DISABLED
behavior remains unchanged.

There's also a bit of trickiness in that some triggers need to avoid
being invoked while an event is currently in the process of being
logged, since the trigger may itself log data into the trace buffer.
Thus we make sure the current event is committed before invoking those
triggers.  To do that, we split the trigger invocation in two - the
first part (event_triggers_call()) checks the filter using the current
trace record; if a command has the post_trigger flag set, it sets a
bit for itself in the return value, otherwise it directly invoks the
trigger.  Once all commands have been either invoked or set their
return flag, event_triggers_call() returns.  The current record is
then either committed or discarded; if any commands have deferred
their triggers, those commands are finally invoked following the close
of the current event by event_triggers_post_call().

To simplify the above and make it more efficient, the TRIGGER_COND bit
is introduced, which is set only if a soft-disabled trigger needs to
use the log record for filter testing or needs to wait until the
current log record is closed.

The syscall event invocation code is also changed in analogous ways.

Because event triggers need to be able to create and free filters,
this also adds a couple external wrappers for the existing
create_filter and free_filter functions, which are too generic to be
made extern functions themselves.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 include/linux/ftrace_event.h        |  10 ++-
 include/trace/ftrace.h              |  53 ++++++++---
 kernel/trace/trace.h                |   5 ++
 kernel/trace/trace_events_filter.c  |  13 +++
 kernel/trace/trace_events_trigger.c | 170 +++++++++++++++++++++++++++++++++++-
 kernel/trace/trace_syscalls.c       |  50 ++++++++---
 6 files changed, 270 insertions(+), 31 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index d4957cd..eeb984c 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -1,3 +1,4 @@
+
 #ifndef _LINUX_FTRACE_EVENT_H
 #define _LINUX_FTRACE_EVENT_H
 
@@ -256,6 +257,7 @@ enum {
 	FTRACE_EVENT_FL_SOFT_MODE_BIT,
 	FTRACE_EVENT_FL_SOFT_DISABLED_BIT,
 	FTRACE_EVENT_FL_TRIGGER_MODE_BIT,
+	FTRACE_EVENT_FL_TRIGGER_COND_BIT,
 };
 
 /*
@@ -266,6 +268,7 @@ enum {
  *  SOFT_DISABLED - When set, do not trace the event (even though its
  *                   tracepoint may be enabled)
  *  TRIGGER_MODE  - When set, invoke the triggers associated with the event
+ *  TRIGGER_COND  - When set, one or more triggers has an associated filter
  */
 enum {
 	FTRACE_EVENT_FL_ENABLED		= (1 << FTRACE_EVENT_FL_ENABLED_BIT),
@@ -273,6 +276,7 @@ enum {
 	FTRACE_EVENT_FL_SOFT_MODE	= (1 << FTRACE_EVENT_FL_SOFT_MODE_BIT),
 	FTRACE_EVENT_FL_SOFT_DISABLED	= (1 << FTRACE_EVENT_FL_SOFT_DISABLED_BIT),
 	FTRACE_EVENT_FL_TRIGGER_MODE	= (1 << FTRACE_EVENT_FL_TRIGGER_MODE_BIT),
+	FTRACE_EVENT_FL_TRIGGER_COND	= (1 << FTRACE_EVENT_FL_TRIGGER_COND_BIT),
 };
 
 struct ftrace_event_file {
@@ -326,11 +330,15 @@ enum event_trigger_type {
 
 extern void destroy_preds(struct ftrace_event_call *call);
 extern int filter_match_preds(struct event_filter *filter, void *rec);
+
 extern int filter_current_check_discard(struct ring_buffer *buffer,
 					struct ftrace_event_call *call,
 					void *rec,
 					struct ring_buffer_event *event);
-extern void event_triggers_call(struct ftrace_event_file *file);
+extern enum event_trigger_type event_triggers_call(struct ftrace_event_file *file,
+						   void *rec);
+extern void event_triggers_post_call(struct ftrace_event_file *file,
+				     enum event_trigger_type tt);
 
 enum {
 	FILTER_OTHER = 0,
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 326ba32..ef69ab30 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -410,6 +410,8 @@ static inline notrace int ftrace_get_offsets_##call(			\
  *	struct ftrace_event_file *ftrace_file = __data;
  *	struct ftrace_event_call *event_call = ftrace_file->event_call;
  *	struct ftrace_data_offsets_<call> __maybe_unused __data_offsets;
+ *	unsigned long eflags = ftrace_file->flags;
+ *	enum event_trigger_type __tt = ETT_NONE;
  *	struct ring_buffer_event *event;
  *	struct ftrace_raw_<call> *entry; <-- defined in stage 1
  *	struct ring_buffer *buffer;
@@ -417,9 +419,12 @@ static inline notrace int ftrace_get_offsets_##call(			\
  *	int __data_size;
  *	int pc;
  *
- *	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,
- *		     &ftrace_file->flags))
- *		return;
+ *	if (!(eflags & FTRACE_EVENT_FL_TRIGGER_COND)) {
+ *		if (eflags & FTRACE_EVENT_FL_TRIGGER_MODE)
+ *			event_triggers_call(ftrace_file, NULL);
+ *		if (eflags & FTRACE_EVENT_FL_SOFT_DISABLED)
+ *			return;
+ *	}
  *
  *	local_save_flags(irq_flags);
  *	pc = preempt_count();
@@ -437,9 +442,18 @@ static inline notrace int ftrace_get_offsets_##call(			\
  *	{ <assign>; }  <-- Here we assign the entries by the __field and
  *			   __array macros.
  *
- *	if (!filter_current_check_discard(buffer, event_call, entry, event))
- *		trace_nowake_buffer_unlock_commit(buffer,
- *						   event, irq_flags, pc);
+ *	if (eflags & FTRACE_EVENT_FL_TRIGGER_COND)
+ *		__tt = event_triggers_call(ftrace_file, entry);
+ *
+ *	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,
+ *		     &ftrace_file->flags))
+ *		ring_buffer_discard_commit(buffer, event);
+ *	else if (!filter_current_check_discard(buffer, event_call,
+ *					       entry, event))
+ *		trace_buffer_unlock_commit(buffer, event, irq_flags, pc);
+ *
+ *	if (__tt)
+ *		event_triggers_post_call(ftrace_file, __tt);
  * }
  *
  * static struct trace_event ftrace_event_type_<call> = {
@@ -519,6 +533,8 @@ ftrace_raw_event_##call(void *__data, proto)				\
 	struct ftrace_event_file *ftrace_file = __data;			\
 	struct ftrace_event_call *event_call = ftrace_file->event_call;	\
 	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
+	unsigned long eflags = ftrace_file->flags;			\
+	enum event_trigger_type __tt = ETT_NONE;			\
 	struct ring_buffer_event *event;				\
 	struct ftrace_raw_##call *entry;				\
 	struct ring_buffer *buffer;					\
@@ -526,13 +542,12 @@ ftrace_raw_event_##call(void *__data, proto)				\
 	int __data_size;						\
 	int pc;								\
 									\
-	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT,			\
-		     &ftrace_file->flags))				\
-		event_triggers_call(ftrace_file);			\
-									\
-	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,			\
-		     &ftrace_file->flags))				\
-		return;							\
+	if (!(eflags & FTRACE_EVENT_FL_TRIGGER_COND)) {			\
+		if (eflags & FTRACE_EVENT_FL_TRIGGER_MODE)		\
+			event_triggers_call(ftrace_file, NULL);		\
+		if (eflags & FTRACE_EVENT_FL_SOFT_DISABLED)		\
+			return;						\
+	}								\
 									\
 	local_save_flags(irq_flags);					\
 	pc = preempt_count();						\
@@ -551,8 +566,18 @@ ftrace_raw_event_##call(void *__data, proto)				\
 									\
 	{ assign; }							\
 									\
-	if (!filter_current_check_discard(buffer, event_call, entry, event)) \
+	if (eflags & FTRACE_EVENT_FL_TRIGGER_COND)			\
+		__tt = event_triggers_call(ftrace_file, entry);		\
+									\
+	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,                 \
+		     &ftrace_file->flags))                              \
+		ring_buffer_discard_commit(buffer, event);              \
+	else if (!filter_current_check_discard(buffer, event_call,      \
+					       entry, event))		\
 		trace_buffer_unlock_commit(buffer, event, irq_flags, pc); \
+									\
+	if (__tt)							\
+		event_triggers_post_call(ftrace_file, __tt);		\
 }
 /*
  * The ftrace_test_probe is compiled out, it is only here as a build time check
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 255c87c..c7e2005 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1,3 +1,4 @@
+
 #ifndef _LINUX_KERNEL_TRACE_H
 #define _LINUX_KERNEL_TRACE_H
 
@@ -995,6 +996,10 @@ extern int apply_subsystem_event_filter(struct ftrace_subsystem_dir *dir,
 extern void print_subsystem_event_filter(struct event_subsystem *system,
 					 struct trace_seq *s);
 extern int filter_assign_type(const char *type);
+extern int create_event_filter(struct ftrace_event_call *call,
+			       char *filter_str, bool set_str,
+			       struct event_filter **filterp);
+extern void free_event_filter(struct event_filter *filter);
 
 struct ftrace_event_field *
 trace_find_event_field(struct ftrace_event_call *call, char *name);
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 97daa8c..0c45aa1 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -781,6 +781,11 @@ static void __free_filter(struct event_filter *filter)
 	kfree(filter);
 }
 
+void free_event_filter(struct event_filter *filter)
+{
+	__free_filter(filter);
+}
+
 /*
  * Called when destroying the ftrace_event_call.
  * The call is being freed, so we do not need to worry about
@@ -1806,6 +1811,14 @@ static int create_filter(struct ftrace_event_call *call,
 	return err;
 }
 
+int create_event_filter(struct ftrace_event_call *call,
+			char *filter_str, bool set_str,
+			struct event_filter **filterp)
+{
+	return create_filter(call, filter_str, set_str, filterp);
+}
+
+
 /**
  * create_system_filter - create a filter for an event_subsystem
  * @system: event_subsystem to create a filter for
diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index 4d82b7b..c6e2392 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -31,6 +31,9 @@ static DEFINE_MUTEX(trigger_cmd_mutex);
 static void
 trigger_data_free(struct event_trigger_data *data)
 {
+	if (data->cmd_ops->set_filter)
+		data->cmd_ops->set_filter(NULL, data, NULL);
+
 	synchronize_sched(); /* make sure current triggers exit before free */
 	kfree(data);
 }
@@ -38,27 +41,78 @@ trigger_data_free(struct event_trigger_data *data)
 /**
  * event_triggers_call - Call triggers associated with a trace event
  * @file: The ftrace_event_file associated with the event
+ * @rec: The trace entry for the event, NULL for unconditional invocation
  *
  * For each trigger associated with an event, invoke the trigger
- * function registered with the associated trigger command.
+ * function registered with the associated trigger command.  If rec is
+ * non-NULL, it means that the trigger requires further processing and
+ * shouldn't be unconditionally invoked.  If rec is non-NULL and the
+ * trigger has a filter associated with it, rec will checked against
+ * the filter and if the record matches the trigger will be invoked.
+ * If the trigger is a 'post_trigger', meaning it shouldn't be invoked
+ * in any case until the current event is written, the trigger
+ * function isn't invoked but the bit associated with the deferred
+ * trigger is set in the return value.
+ *
+ * Returns an enum event_trigger_type value containing a set bit for
+ * any trigger that should be deferred, ETT_NONE if nothing to defer.
  *
  * Called from tracepoint handlers (with rcu_read_lock_sched() held).
  *
  * Return: an enum event_trigger_type value containing a set bit for
  * any trigger that should be deferred, ETT_NONE if nothing to defer.
  */
-void event_triggers_call(struct ftrace_event_file *file)
+enum event_trigger_type
+event_triggers_call(struct ftrace_event_file *file, void *rec)
 {
 	struct event_trigger_data *data;
+	enum event_trigger_type tt = ETT_NONE;
 
 	if (list_empty(&file->triggers))
-		return;
+		return tt;
 
-	list_for_each_entry_rcu(data, &file->triggers, list)
+	list_for_each_entry_rcu(data, &file->triggers, list) {
+		if (!rec) {
+			data->ops->func(data);
+			continue;
+		}
+		if (data->filter && !filter_match_preds(data->filter, rec))
+			continue;
+		if (data->cmd_ops->post_trigger) {
+			tt |= data->cmd_ops->trigger_type;
+			continue;
+		}
 		data->ops->func(data);
+	}
+	return tt;
 }
 EXPORT_SYMBOL_GPL(event_triggers_call);
 
+/**
+ * event_triggers_post_call - Call 'post_triggers' for a trace event
+ * @file: The ftrace_event_file associated with the event
+ * @tt: enum event_trigger_type containing a set bit for each trigger to invoke
+ *
+ * For each trigger associated with an event, invoke the trigger
+ * function registered with the associated trigger command, if the
+ * corresponding bit is set in the tt enum passed into this function.
+ * See @event_triggers_call for details on how those bits are set.
+ *
+ * Called from tracepoint handlers (with rcu_read_lock_sched() held).
+ */
+void
+event_triggers_post_call(struct ftrace_event_file *file,
+			 enum event_trigger_type tt)
+{
+	struct event_trigger_data *data;
+
+	list_for_each_entry_rcu(data, &file->triggers, list) {
+		if (data->cmd_ops->trigger_type & tt)
+			data->ops->func(data);
+	}
+}
+EXPORT_SYMBOL_GPL(event_triggers_post_call);
+
 static void *trigger_next(struct seq_file *m, void *t, loff_t *pos)
 {
 	struct ftrace_event_file *event_file = event_file_data(m->private);
@@ -403,6 +457,34 @@ clear_event_triggers(struct trace_array *tr)
 }
 
 /**
+ * update_cond_flag - Set or reset the TRIGGER_COND bit
+ * @file: The ftrace_event_file associated with the event
+ *
+ * If an event has triggers and any of those triggers has a filter or
+ * a post_trigger, trigger invocation needs to be deferred until after
+ * the current event has logged its data, and the event should have
+ * its TRIGGER_COND bit set, otherwise the TRIGGER_COND bit should be
+ * cleared.
+ */
+static void update_cond_flag(struct ftrace_event_file *file)
+{
+	struct event_trigger_data *data;
+	bool set_cond = false;
+
+	list_for_each_entry_rcu(data, &file->triggers, list) {
+		if (data->filter || data->cmd_ops->post_trigger) {
+			set_cond = true;
+			break;
+		}
+	}
+
+	if (set_cond)
+		set_bit(FTRACE_EVENT_FL_TRIGGER_COND_BIT, &file->flags);
+	else
+		clear_bit(FTRACE_EVENT_FL_TRIGGER_COND_BIT, &file->flags);
+}
+
+/**
  * register_trigger - Generic event_command @reg implementation
  * @glob: The raw string used to register the trigger
  * @ops: The trigger ops associated with the trigger
@@ -443,6 +525,7 @@ static int register_trigger(char *glob, struct event_trigger_ops *ops,
 		list_del_rcu(&data->list);
 		ret--;
 	}
+	update_cond_flag(file);
 out:
 	return ret;
 }
@@ -470,6 +553,7 @@ static void unregister_trigger(char *glob, struct event_trigger_ops *ops,
 		if (data->cmd_ops->trigger_type == test->cmd_ops->trigger_type) {
 			unregistered = true;
 			list_del_rcu(&data->list);
+			update_cond_flag(file);
 			trace_event_trigger_enable_disable(file, 0);
 			break;
 		}
@@ -572,10 +656,78 @@ event_trigger_callback(struct event_command *cmd_ops,
 	return ret;
 
  out_free:
+	if (cmd_ops->set_filter)
+		cmd_ops->set_filter(NULL, trigger_data, NULL);
 	kfree(trigger_data);
 	goto out;
 }
 
+/**
+ * set_trigger_filter - Generic event_command @set_filter implementation
+ * @filter_str: The filter string for the trigger, NULL to remove filter
+ * @trigger_data: Trigger-specific data
+ * @file: The ftrace_event_file associated with the event
+ *
+ * Common implementation for event command filter parsing and filter
+ * instantiation.
+ *
+ * Usually used directly as the @set_filter method in event command
+ * implementations.
+ *
+ * Also used to remove a filter (if filter_str = NULL).
+ *
+ * Return: 0 on success, errno otherwise
+ */
+static int set_trigger_filter(char *filter_str,
+			      struct event_trigger_data *trigger_data,
+			      struct ftrace_event_file *file)
+{
+	struct event_trigger_data *data = trigger_data;
+	struct event_filter *filter = NULL, *tmp;
+	int ret = -EINVAL;
+	char *s;
+
+	if (!filter_str) /* clear the current filter */
+		goto assign;
+
+	s = strsep(&filter_str, " \t");
+
+	if (!strlen(s) || strcmp(s, "if") != 0)
+		goto out;
+
+	if (!filter_str)
+		goto out;
+
+	/* The filter is for the 'trigger' event, not the triggered event */
+	ret = create_event_filter(file->event_call, filter_str, false, &filter);
+	if (ret)
+		goto out;
+ assign:
+	tmp = data->filter;
+
+	rcu_assign_pointer(data->filter, filter);
+
+	if (tmp) {
+		/* Make sure the call is done with the filter */
+		synchronize_sched();
+		free_event_filter(tmp);
+	}
+
+	kfree(data->filter_str);
+	data->filter_str = NULL;
+
+	if (filter_str) {
+		data->filter_str = kstrdup(filter_str, GFP_KERNEL);
+		if (!data->filter_str) {
+			free_event_filter(data->filter);
+			data->filter = NULL;
+			ret = -ENOMEM;
+		}
+	}
+ out:
+	return ret;
+}
+
 static void
 traceon_trigger(struct event_trigger_data *data)
 {
@@ -685,6 +837,7 @@ static struct event_command trigger_traceon_cmd = {
 	.reg			= register_trigger,
 	.unreg			= unregister_trigger,
 	.get_trigger_ops	= onoff_get_trigger_ops,
+	.set_filter		= set_trigger_filter,
 };
 
 static struct event_command trigger_traceoff_cmd = {
@@ -694,6 +847,7 @@ static struct event_command trigger_traceoff_cmd = {
 	.reg			= register_trigger,
 	.unreg			= unregister_trigger,
 	.get_trigger_ops	= onoff_get_trigger_ops,
+	.set_filter		= set_trigger_filter,
 };
 
 static void
@@ -762,6 +916,7 @@ static struct event_command trigger_snapshot_cmd = {
 	.reg			= register_snapshot_trigger,
 	.unreg			= unregister_trigger,
 	.get_trigger_ops	= snapshot_get_trigger_ops,
+	.set_filter		= set_trigger_filter,
 };
 
 /*
@@ -827,6 +982,7 @@ static struct event_command trigger_stacktrace_cmd = {
 	.reg			= register_trigger,
 	.unreg			= unregister_trigger,
 	.get_trigger_ops	= stacktrace_get_trigger_ops,
+	.set_filter		= set_trigger_filter,
 };
 
 static __init void unregister_trigger_traceon_traceoff_cmds(void)
@@ -1071,6 +1227,8 @@ event_enable_trigger_func(struct event_command *cmd_ops,
  out_put:
 	module_put(event_enable_file->event_call->mod);
  out_free:
+	if (cmd_ops->set_filter)
+		cmd_ops->set_filter(NULL, trigger_data, NULL);
 	kfree(trigger_data);
 	kfree(enable_data);
 	goto out;
@@ -1108,6 +1266,7 @@ static int event_enable_register_trigger(char *glob,
 		list_del_rcu(&data->list);
 		ret--;
 	}
+	update_cond_flag(file);
 out:
 	return ret;
 }
@@ -1128,6 +1287,7 @@ static void event_enable_unregister_trigger(char *glob,
 		    (enable_data->file == test_enable_data->file)) {
 			unregistered = true;
 			list_del_rcu(&data->list);
+			update_cond_flag(file);
 			trace_event_trigger_enable_disable(file, 0);
 			break;
 		}
@@ -1162,6 +1322,7 @@ static struct event_command trigger_enable_cmd = {
 	.reg			= event_enable_register_trigger,
 	.unreg			= event_enable_unregister_trigger,
 	.get_trigger_ops	= event_enable_get_trigger_ops,
+	.set_filter		= set_trigger_filter,
 };
 
 static struct event_command trigger_disable_cmd = {
@@ -1171,6 +1332,7 @@ static struct event_command trigger_disable_cmd = {
 	.reg			= event_enable_register_trigger,
 	.unreg			= event_enable_unregister_trigger,
 	.get_trigger_ops	= event_enable_get_trigger_ops,
+	.set_filter		= set_trigger_filter,
 };
 
 static __init void unregister_trigger_enable_disable_cmds(void)
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 0081cdd..5cfd2df 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -306,8 +306,10 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 	struct syscall_trace_enter *entry;
 	struct syscall_metadata *sys_data;
 	struct ring_buffer_event *event;
+	enum event_trigger_type __tt = ETT_NONE;
 	struct ring_buffer *buffer;
 	unsigned long irq_flags;
+	unsigned long eflags;
 	int pc;
 	int syscall_nr;
 	int size;
@@ -321,10 +323,14 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 	if (!ftrace_file)
 		return;
 
-	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT, &ftrace_file->flags))
-		event_triggers_call(ftrace_file);
-	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
-		return;
+	eflags = ftrace_file->flags;
+
+	if (!(eflags & FTRACE_EVENT_FL_TRIGGER_COND)) {
+		if (eflags & FTRACE_EVENT_FL_TRIGGER_MODE)
+			event_triggers_call(ftrace_file, NULL);
+		if (eflags & FTRACE_EVENT_FL_SOFT_DISABLED)
+			return;
+	}
 
 	sys_data = syscall_nr_to_meta(syscall_nr);
 	if (!sys_data)
@@ -345,10 +351,17 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 	entry->nr = syscall_nr;
 	syscall_get_arguments(current, regs, 0, sys_data->nb_args, entry->args);
 
-	if (!filter_current_check_discard(buffer, sys_data->enter_event,
-					  entry, event))
+	if (eflags & FTRACE_EVENT_FL_TRIGGER_COND)
+		__tt = event_triggers_call(ftrace_file, entry);
+
+	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
+		ring_buffer_discard_commit(buffer, event);
+	else if (!filter_current_check_discard(buffer, sys_data->enter_event,
+					       entry, event))
 		trace_current_buffer_unlock_commit(buffer, event,
 						   irq_flags, pc);
+	if (__tt)
+		event_triggers_post_call(ftrace_file, __tt);
 }
 
 static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
@@ -358,8 +371,10 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	struct syscall_trace_exit *entry;
 	struct syscall_metadata *sys_data;
 	struct ring_buffer_event *event;
+	enum event_trigger_type __tt = ETT_NONE;
 	struct ring_buffer *buffer;
 	unsigned long irq_flags;
+	unsigned long eflags;
 	int pc;
 	int syscall_nr;
 
@@ -372,10 +387,14 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	if (!ftrace_file)
 		return;
 
-	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT, &ftrace_file->flags))
-		event_triggers_call(ftrace_file);
-	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
-		return;
+	eflags = ftrace_file->flags;
+
+	if (!(eflags & FTRACE_EVENT_FL_TRIGGER_COND)) {
+		if (eflags & FTRACE_EVENT_FL_TRIGGER_MODE)
+			event_triggers_call(ftrace_file, NULL);
+		if (eflags & FTRACE_EVENT_FL_SOFT_DISABLED)
+			return;
+	}
 
 	sys_data = syscall_nr_to_meta(syscall_nr);
 	if (!sys_data)
@@ -395,10 +414,17 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	entry->nr = syscall_nr;
 	entry->ret = syscall_get_return_value(current, regs);
 
-	if (!filter_current_check_discard(buffer, sys_data->exit_event,
-					  entry, event))
+	if (eflags & FTRACE_EVENT_FL_TRIGGER_COND)
+		__tt = event_triggers_call(ftrace_file, entry);
+
+	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
+		ring_buffer_discard_commit(buffer, event);
+	else if (!filter_current_check_discard(buffer, sys_data->exit_event,
+					       entry, event))
 		trace_current_buffer_unlock_commit(buffer, event,
 						   irq_flags, pc);
+	if (__tt)
+		event_triggers_post_call(ftrace_file, __tt);
 }
 
 static int reg_event_syscall_enter(struct ftrace_event_file *file,
-- 
1.7.11.4

