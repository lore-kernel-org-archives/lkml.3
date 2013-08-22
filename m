Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab3HVT62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 15:58:28 -0400
Received: from mga14.intel.com ([143.182.124.37]:45279 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754363Ab3HVT6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 15:58:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,935,1367996400"; 
   d="scan'208";a="385101016"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH v5 07/10] tracing: add and use generic set_trigger_filter() implementation
Date: Thu, 22 Aug 2013 14:57:40 -0500
Message-Id: <60472f2b4911e675dd9596a28d51d9723188b18c.1377183739.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <cover.1377183739.git.tom.zanussi@linux.intel.com>
References: <cover.1377183739.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1377183739.git.tom.zanussi@linux.intel.com>
References: <cover.1377183739.git.tom.zanussi@linux.intel.com>
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
to be moved - for ftrace_raw_event_calls, trigger invocation now needs
to happen after the { assign; } part of the call.

Also, because triggers need to be invoked even for soft-disabled
events, the SOFT_DISABLED check and return needs to be moved from the
top of the call to a point following the trigger check, which means
that soft-disabled events actually get discarded instead of simply
skipped.  There's still a SOFT_DISABLED-only check at the top of the
function, so when an event is soft disabled but not because of the
presence of a trigger, the original SOFT_DISABLED behavior remains
unchanged.

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

The syscall event invocation code is also changed in analogous ways.

Because event triggers need to be able to create and free filters,
this also adds a couple external wrappers for the existing
create_filter and free_filter functions, which are too generic to be
made extern functions themselves.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 include/linux/ftrace_event.h        |   6 ++-
 include/trace/ftrace.h              |  45 +++++++++++-----
 kernel/trace/trace.h                |   4 ++
 kernel/trace/trace_events_filter.c  |  13 +++++
 kernel/trace/trace_events_trigger.c | 103 ++++++++++++++++++++++++++++++++++--
 kernel/trace/trace_syscalls.c       |  36 +++++++++----
 6 files changed, 180 insertions(+), 27 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 72cadbc..cd5326a8 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -330,7 +330,11 @@ extern int filter_current_check_discard(struct ring_buffer *buffer,
 					struct ftrace_event_call *call,
 					void *rec,
 					struct ring_buffer_event *event);
-extern void event_triggers_call(struct ftrace_event_file *file);
+extern enum trigger_mode event_triggers_call(struct ftrace_event_file *file,
+					     void *rec);
+extern void event_triggers_post_call(struct ftrace_event_file *file,
+				     enum trigger_mode tm);
+
 
 enum {
 	FILTER_OTHER = 0,
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 326ba32..be913f1 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -412,13 +412,15 @@ static inline notrace int ftrace_get_offsets_##call(			\
  *	struct ftrace_data_offsets_<call> __maybe_unused __data_offsets;
  *	struct ring_buffer_event *event;
  *	struct ftrace_raw_<call> *entry; <-- defined in stage 1
+ *	enum trigger_mode __tm = TM_NONE;
  *	struct ring_buffer *buffer;
  *	unsigned long irq_flags;
  *	int __data_size;
  *	int pc;
  *
- *	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,
- *		     &ftrace_file->flags))
+ *	if ((ftrace_file->flags & (FTRACE_EVENT_FL_SOFT_DISABLED |
+ *	     FTRACE_EVENT_FL_TRIGGER_MODE)) ==
+ *	    FTRACE_EVENT_FL_SOFT_DISABLED)
  *		return;
  *
  *	local_save_flags(irq_flags);
@@ -437,9 +439,19 @@ static inline notrace int ftrace_get_offsets_##call(			\
  *	{ <assign>; }  <-- Here we assign the entries by the __field and
  *			   __array macros.
  *
- *	if (!filter_current_check_discard(buffer, event_call, entry, event))
- *		trace_nowake_buffer_unlock_commit(buffer,
- *						   event, irq_flags, pc);
+ *	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT,
+ *		     &ftrace_file->flags))
+ *		__tm = event_triggers_call(ftrace_file, entry);
+ *
+ *	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,
+ *		     &ftrace_file->flags))
+ *		ring_buffer_discard_commit(buffer, event);
+ *	else if (!filter_current_check_discard(buffer, event_call,
+ *					       entry, event))
+ *		trace_buffer_unlock_commit(buffer, event, irq_flags, pc);
+ *
+ *	if (__tm)
+ *		event_triggers_post_call(ftrace_file, __tm);
  * }
  *
  * static struct trace_event ftrace_event_type_<call> = {
@@ -521,17 +533,15 @@ ftrace_raw_event_##call(void *__data, proto)				\
 	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
 	struct ring_buffer_event *event;				\
 	struct ftrace_raw_##call *entry;				\
+	enum trigger_mode __tm = TM_NONE;				\
 	struct ring_buffer *buffer;					\
 	unsigned long irq_flags;					\
 	int __data_size;						\
 	int pc;								\
 									\
-	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT,			\
-		     &ftrace_file->flags))				\
-		event_triggers_call(ftrace_file);			\
-									\
-	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,			\
-		     &ftrace_file->flags))				\
+	if ((ftrace_file->flags & (FTRACE_EVENT_FL_SOFT_DISABLED |	\
+	     FTRACE_EVENT_FL_TRIGGER_MODE)) ==				\
+	    FTRACE_EVENT_FL_SOFT_DISABLED)				\
 		return;							\
 									\
 	local_save_flags(irq_flags);					\
@@ -551,8 +561,19 @@ ftrace_raw_event_##call(void *__data, proto)				\
 									\
 	{ assign; }							\
 									\
-	if (!filter_current_check_discard(buffer, event_call, entry, event)) \
+	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT,			\
+		     &ftrace_file->flags))				\
+		__tm = event_triggers_call(ftrace_file, entry);		\
+									\
+	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,                 \
+		     &ftrace_file->flags))                              \
+		ring_buffer_discard_commit(buffer, event);              \
+	else if (!filter_current_check_discard(buffer, event_call,      \
+					       entry, event))		\
 		trace_buffer_unlock_commit(buffer, event, irq_flags, pc); \
+									\
+	if (__tm)							\
+		event_triggers_post_call(ftrace_file, __tm);		\
 }
 /*
  * The ftrace_test_probe is compiled out, it is only here as a build time check
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 578a38e..5cf3eb2 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -994,6 +994,10 @@ extern int apply_subsystem_event_filter(struct ftrace_subsystem_dir *dir,
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
index 94074d8..4b5504a 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -36,6 +36,7 @@ struct event_trigger_data {
 	struct event_trigger_ops	*ops;
 	struct event_command *		cmd_ops;
 	enum trigger_mode		mode;
+	bool				post_trigger;
 	struct event_filter		*filter;
 	char				*filter_str;
 	struct list_head		list;
@@ -44,24 +45,52 @@ struct event_trigger_data {
 static void
 trigger_data_free(struct event_trigger_data *data)
 {
+	if (data->cmd_ops->set_filter)
+		data->cmd_ops->set_filter(NULL, data, NULL);
+
 	synchronize_sched(); /* make sure current triggers exit before free */
 	kfree(data);
 }
 
-void event_triggers_call(struct ftrace_event_file *file)
+enum trigger_mode
+event_triggers_call(struct ftrace_event_file *file, void *rec)
 {
 	struct event_trigger_data *data;
+	enum trigger_mode tm = TM_NONE;
 
 	if (list_empty(&file->triggers))
-		return;
+		return tm;
 
 	preempt_disable_notrace();
-	list_for_each_entry_rcu(data, &file->triggers, list)
+	list_for_each_entry_rcu(data, &file->triggers, list) {
+		if (data->filter && !filter_match_preds(data->filter, rec))
+			continue;
+		if (data->post_trigger) {
+			tm |= data->mode;
+			continue;
+		}
 		data->ops->func((void **)&data);
+	}
 	preempt_enable_notrace();
+
+	return tm;
 }
 EXPORT_SYMBOL_GPL(event_triggers_call);
 
+void
+event_triggers_post_call(struct ftrace_event_file *file, enum trigger_mode tm)
+{
+	struct event_trigger_data *data;
+
+	preempt_disable_notrace();
+	list_for_each_entry_rcu(data, &file->triggers, list) {
+		if (data->mode & tm)
+			data->ops->func((void **)&data);
+	}
+	preempt_enable_notrace();
+}
+EXPORT_SYMBOL_GPL(event_triggers_post_call);
+
 static void *trigger_next(struct seq_file *m, void *t, loff_t *pos)
 {
 	struct ftrace_event_file *event_file = event_file_data(m->private);
@@ -564,6 +593,66 @@ event_trigger_callback(struct event_command *cmd_ops,
 	goto out;
 }
 
+/**
+ * set_trigger_filter - generic event_command @set_filter
+ * implementation
+ *
+ * Common implementation for event command filter parsing and filter
+ * instantiation.
+ *
+ * Usually used directly as the @set_filter method in event command
+ * implementations.
+ *
+ * Also used to remove a filter (if filter_str = NULL).
+ */
+static int set_trigger_filter(char *filter_str, void *trigger_data,
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
 traceon_trigger(void **_data)
 {
@@ -701,6 +790,7 @@ static struct event_command trigger_traceon_cmd = {
 	.reg			= register_trigger,
 	.unreg			= unregister_trigger,
 	.get_trigger_ops	= onoff_get_trigger_ops,
+	.set_filter		= set_trigger_filter,
 };
 
 static struct event_command trigger_traceoff_cmd = {
@@ -710,6 +800,7 @@ static struct event_command trigger_traceoff_cmd = {
 	.reg			= register_trigger,
 	.unreg			= unregister_trigger,
 	.get_trigger_ops	= onoff_get_trigger_ops,
+	.set_filter		= set_trigger_filter,
 };
 
 static void
@@ -791,6 +882,7 @@ static struct event_command trigger_snapshot_cmd = {
 	.reg			= register_snapshot_trigger,
 	.unreg			= unregister_trigger,
 	.get_trigger_ops	= snapshot_get_trigger_ops,
+	.set_filter		= set_trigger_filter,
 };
 
 /*
@@ -879,9 +971,10 @@ static struct event_command trigger_stacktrace_cmd = {
 	.trigger_mode		= TM_STACKTRACE,
 	.post_trigger		= true,
 	.func			= event_trigger_callback,
-	.reg			= register_trigger,
+	.reg			= stacktrace_register_trigger,
 	.unreg			= unregister_trigger,
 	.get_trigger_ops	= stacktrace_get_trigger_ops,
+	.set_filter		= set_trigger_filter,
 };
 
 static __init void unregister_trigger_traceon_traceoff_cmds(void)
@@ -1209,6 +1302,7 @@ static struct event_command trigger_enable_cmd = {
 	.reg			= event_enable_register_trigger,
 	.unreg			= event_enable_unregister_trigger,
 	.get_trigger_ops	= event_enable_get_trigger_ops,
+	.set_filter		= set_trigger_filter,
 };
 
 static struct event_command trigger_disable_cmd = {
@@ -1218,6 +1312,7 @@ static struct event_command trigger_disable_cmd = {
 	.reg			= event_enable_register_trigger,
 	.unreg			= event_enable_unregister_trigger,
 	.get_trigger_ops	= event_enable_get_trigger_ops,
+	.set_filter		= set_trigger_filter,
 };
 
 static __init void unregister_trigger_enable_disable_cmds(void)
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index bb40a8d..879285f 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -306,6 +306,7 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 	struct syscall_trace_enter *entry;
 	struct syscall_metadata *sys_data;
 	struct ring_buffer_event *event;
+	enum trigger_mode __tm = TM_NONE;
 	struct ring_buffer *buffer;
 	unsigned long irq_flags;
 	int pc;
@@ -321,9 +322,9 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 	if (!ftrace_file)
 		return;
 
-	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT, &ftrace_file->flags))
-		event_triggers_call(ftrace_file);
-	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
+	if ((ftrace_file->flags &
+	     (FTRACE_EVENT_FL_SOFT_DISABLED | FTRACE_EVENT_FL_TRIGGER_MODE)) ==
+	    FTRACE_EVENT_FL_SOFT_DISABLED)
 		return;
 
 	sys_data = syscall_nr_to_meta(syscall_nr);
@@ -345,10 +346,17 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 	entry->nr = syscall_nr;
 	syscall_get_arguments(current, regs, 0, sys_data->nb_args, entry->args);
 
-	if (!filter_current_check_discard(buffer, sys_data->enter_event,
-					  entry, event))
+	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT, &ftrace_file->flags))
+		__tm = event_triggers_call(ftrace_file, entry);
+
+	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
+		ring_buffer_discard_commit(buffer, event);
+	else if (!filter_current_check_discard(buffer, sys_data->enter_event,
+					       entry, event))
 		trace_current_buffer_unlock_commit(buffer, event,
 						   irq_flags, pc);
+	if (__tm)
+		event_triggers_post_call(ftrace_file, __tm);
 }
 
 static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
@@ -358,6 +366,7 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	struct syscall_trace_exit *entry;
 	struct syscall_metadata *sys_data;
 	struct ring_buffer_event *event;
+	enum trigger_mode __tm = TM_NONE;
 	struct ring_buffer *buffer;
 	unsigned long irq_flags;
 	int pc;
@@ -372,9 +381,9 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	if (!ftrace_file)
 		return;
 
-	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT, &ftrace_file->flags))
-		event_triggers_call(ftrace_file);
-	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
+	if ((ftrace_file->flags &
+	     (FTRACE_EVENT_FL_SOFT_DISABLED | FTRACE_EVENT_FL_TRIGGER_MODE)) ==
+	    FTRACE_EVENT_FL_SOFT_DISABLED)
 		return;
 
 	sys_data = syscall_nr_to_meta(syscall_nr);
@@ -395,10 +404,17 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	entry->nr = syscall_nr;
 	entry->ret = syscall_get_return_value(current, regs);
 
-	if (!filter_current_check_discard(buffer, sys_data->exit_event,
-					  entry, event))
+	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT, &ftrace_file->flags))
+		__tm = event_triggers_call(ftrace_file, entry);
+
+	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
+		ring_buffer_discard_commit(buffer, event);
+	else if (!filter_current_check_discard(buffer, sys_data->exit_event,
+					       entry, event))
 		trace_current_buffer_unlock_commit(buffer, event,
 						   irq_flags, pc);
+	if (__tm)
+		event_triggers_post_call(ftrace_file, __tm);
 }
 
 static int reg_event_syscall_enter(struct ftrace_event_file *file,
-- 
1.7.11.4

