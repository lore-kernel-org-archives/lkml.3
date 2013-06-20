Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030426Ab3FTScB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 14:32:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:43476 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030414Ab3FTSb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 14:31:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,906,1363158000"; 
   d="scan'208";a="332914360"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH 10/11] tracing: add and use generic set_trigger_filter() implementation
Date: Thu, 20 Jun 2013 13:31:34 -0500
Message-Id: <8fe2c1ceb63a6375b56f046de835742f18b955ce.1371751701.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <cover.1371751701.git.tom.zanussi@linux.intel.com>
References: <cover.1371751701.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1371751701.git.tom.zanussi@linux.intel.com>
References: <cover.1371751701.git.tom.zanussi@linux.intel.com>
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
skipped.

There's also a bit of trickiness in that the triggers need to avoid
being invoked while an event is currently in the process of being
logged, since the trigger may itself log data into the trace buffer.
Thus we make sure the current event is committed before invoking
triggers.

The syscall event invocation code is also changed in analogous ways.

Because event triggers need to be able to create and free filters,
this also adds a couple external wrappers for the existing
create_filter and free_filter functions, which are too generic to be
made extern functions themselves.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 include/linux/ftrace_event.h        |  2 +-
 include/trace/ftrace.h              | 22 +++++++++-----
 kernel/trace/trace.h                |  4 +++
 kernel/trace/trace_events_filter.c  | 13 ++++++++
 kernel/trace/trace_events_trigger.c | 59 +++++++++++++++++++++++++++++++++++--
 kernel/trace/trace_syscalls.c       | 44 +++++++++++++++++----------
 6 files changed, 117 insertions(+), 27 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 10a5fa4..ebaa48a 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -320,7 +320,7 @@ extern int filter_current_check_discard(struct ring_buffer *buffer,
 					struct ftrace_event_call *call,
 					void *rec,
 					struct ring_buffer_event *event);
-extern void event_triggers_call(struct ftrace_event_file *file);
+extern void event_triggers_call(struct ftrace_event_file *file, void *rec);
 
 enum {
 	FILTER_OTHER = 0,
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 88ac7da..7c5627f 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -522,14 +522,6 @@ ftrace_raw_event_##call(void *__data, proto)				\
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
-									\
 	local_save_flags(irq_flags);					\
 	pc = preempt_count();						\
 									\
@@ -547,8 +539,22 @@ ftrace_raw_event_##call(void *__data, proto)				\
 									\
 	{ assign; }							\
 									\
+	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,			\
+		     &ftrace_file->flags)) {				\
+		ring_buffer_discard_commit(buffer, event);		\
+									\
+		if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT,		\
+			     &ftrace_file->flags))			\
+			event_triggers_call(ftrace_file, entry);	\
+		return;							\
+	}								\
+									\
 	if (!filter_current_check_discard(buffer, event_call, entry, event)) \
 		trace_buffer_unlock_commit(buffer, event, irq_flags, pc); \
+									\
+	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT,			\
+		     &ftrace_file->flags))				\
+		event_triggers_call(ftrace_file, entry);		\
 }
 /*
  * The ftrace_test_probe is compiled out, it is only here as a build time check
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 94b33ec..36d03bd 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -999,6 +999,10 @@ extern int apply_subsystem_event_filter(struct ftrace_subsystem_dir *dir,
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
index e1b653f..06fa00c 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -777,6 +777,11 @@ static void __free_filter(struct event_filter *filter)
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
@@ -1802,6 +1807,14 @@ static int create_filter(struct ftrace_event_call *call,
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
index 9a2daa75..a972c82 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -43,7 +43,7 @@ struct trigger_iterator {
 	struct ftrace_event_file	*file;
 };
 
-void event_triggers_call(struct ftrace_event_file *file)
+void event_triggers_call(struct ftrace_event_file *file, void *rec)
 {
 	struct event_trigger_data *data;
 
@@ -51,8 +51,11 @@ void event_triggers_call(struct ftrace_event_file *file)
 		return;
 
 	preempt_disable_notrace();
-	list_for_each_entry_rcu(data, &file->triggers, list)
+	list_for_each_entry_rcu(data, &file->triggers, list) {
+		if (data->filter && !filter_match_preds(data->filter, rec))
+			continue;
 		data->ops->func((void **)&data);
+	}
 	preempt_enable_notrace();
 }
 EXPORT_SYMBOL_GPL(event_triggers_call);
@@ -379,6 +382,52 @@ event_trigger_free(struct event_trigger_ops *ops, void **_data)
 		kfree(data);
 }
 
+static int set_trigger_filter(char *filter_str, void *trigger_data,
+			      void *cmd_data)
+{
+	struct trigger_iterator *iter = cmd_data;
+	struct event_trigger_data *data = trigger_data;
+	struct event_filter *filter, *tmp;
+	int ret = -EINVAL;
+	char *s;
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
+	ret = create_event_filter(iter->file->event_call,
+				  filter_str, false, &filter);
+	if (ret)
+		goto out;
+
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
+	data->filter_str = kstrdup(filter_str, GFP_KERNEL);
+	if (!data->filter_str) {
+		free_event_filter(data->filter);
+		data->filter = NULL;
+		ret = -ENOMEM;
+	}
+
+ out:
+	return ret;
+}
+
 static int
 event_trigger_callback(struct event_command *cmd_ops, void *cmd_data,
 		       char *glob, char *cmd, char *param, int enabled)
@@ -600,6 +649,7 @@ static struct event_command trigger_traceon_cmd = {
 	.reg			= register_trigger,
 	.unreg			= unregister_trigger,
 	.get_trigger_ops	= onoff_get_trigger_ops,
+	.set_filter		= set_trigger_filter,
 };
 
 static struct event_command trigger_traceoff_cmd = {
@@ -608,6 +658,7 @@ static struct event_command trigger_traceoff_cmd = {
 	.reg			= register_trigger,
 	.unreg			= unregister_trigger,
 	.get_trigger_ops	= onoff_get_trigger_ops,
+	.set_filter		= set_trigger_filter,
 };
 
 static void
@@ -688,6 +739,7 @@ static struct event_command trigger_snapshot_cmd = {
 	.reg			= register_snapshot_trigger,
 	.unreg			= unregister_trigger,
 	.get_trigger_ops	= snapshot_get_trigger_ops,
+	.set_filter		= set_trigger_filter,
 };
 
 /*
@@ -765,6 +817,7 @@ static struct event_command trigger_stacktrace_cmd = {
 	.reg			= register_trigger,
 	.unreg			= unregister_trigger,
 	.get_trigger_ops	= stacktrace_get_trigger_ops,
+	.set_filter		= set_trigger_filter,
 };
 
 static __init void unregister_trigger_traceon_traceoff_cmds(void)
@@ -1092,6 +1145,7 @@ static struct event_command trigger_enable_cmd = {
 	.reg			= event_enable_register_trigger,
 	.unreg			= event_enable_unregister_trigger,
 	.get_trigger_ops	= event_enable_get_trigger_ops,
+	.set_filter		= set_trigger_filter,
 };
 
 static struct event_command trigger_disable_cmd = {
@@ -1100,6 +1154,7 @@ static struct event_command trigger_disable_cmd = {
 	.reg			= event_enable_register_trigger,
 	.unreg			= event_enable_unregister_trigger,
 	.get_trigger_ops	= event_enable_get_trigger_ops,
+	.set_filter		= set_trigger_filter,
 };
 
 static __init void unregister_trigger_enable_disable_cmds(void)
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index e287011..47fa712 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -319,14 +319,6 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 	if (!sys_data)
 		return;
 
-	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT,
-		     &sys_data->enter_file->flags))
-		event_triggers_call(sys_data->enter_file);
-
-	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,
-		     &sys_data->enter_file->flags))
-		return;
-
 	size = sizeof(*entry) + sizeof(unsigned long) * sys_data->nb_args;
 
 	buffer = tr->trace_buffer.buffer;
@@ -339,9 +331,23 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 	entry->nr = syscall_nr;
 	syscall_get_arguments(current, regs, 0, sys_data->nb_args, entry->args);
 
+	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,
+		     &sys_data->enter_file->flags)) {
+		ring_buffer_discard_commit(buffer, event);
+
+		if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT,
+			     &sys_data->enter_file->flags))
+			event_triggers_call(sys_data->enter_file, entry);
+		return;
+	}
+
 	if (!filter_current_check_discard(buffer, sys_data->enter_event,
 					  entry, event))
 		trace_current_buffer_unlock_commit(buffer, event, 0, 0);
+
+	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT,
+		     &sys_data->enter_file->flags))
+		event_triggers_call(sys_data->enter_file, entry);
 }
 
 static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
@@ -363,14 +369,6 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	if (!sys_data)
 		return;
 
-	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT,
-		     &sys_data->exit_file->flags))
-		event_triggers_call(sys_data->exit_file);
-
-	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,
-		     &sys_data->exit_file->flags))
-		return;
-
 	buffer = tr->trace_buffer.buffer;
 	event = trace_buffer_lock_reserve(buffer,
 			sys_data->exit_event->event.type, sizeof(*entry), 0, 0);
@@ -381,9 +379,23 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	entry->nr = syscall_nr;
 	entry->ret = syscall_get_return_value(current, regs);
 
+	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,
+		     &sys_data->exit_file->flags)) {
+		ring_buffer_discard_commit(buffer, event);
+
+		if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT,
+			     &sys_data->exit_file->flags))
+			event_triggers_call(sys_data->exit_file, entry);
+		return;
+	}
+
 	if (!filter_current_check_discard(buffer, sys_data->exit_event,
 					  entry, event))
 		trace_current_buffer_unlock_commit(buffer, event, 0, 0);
+
+	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT,
+		     &sys_data->exit_file->flags))
+		event_triggers_call(sys_data->exit_file, entry);
 }
 
 static int reg_event_syscall_enter(struct ftrace_event_file *file,
-- 
1.7.11.4

