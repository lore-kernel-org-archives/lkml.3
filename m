Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab3HVT56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 15:57:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:58708 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753819Ab3HVT5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 15:57:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,935,1367996400"; 
   d="scan'208";a="285515359"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH v5 02/10] tracing: add basic event trigger framework
Date: Thu, 22 Aug 2013 14:57:35 -0500
Message-Id: <ad2a775ed2765b6f0a47302f80cab9d831ca4435.1377183739.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <cover.1377183739.git.tom.zanussi@linux.intel.com>
References: <cover.1377183739.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1377183739.git.tom.zanussi@linux.intel.com>
References: <cover.1377183739.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a 'trigger' file for each trace event, enabling 'trace event
triggers' to be set for trace events.

'trace event triggers' are patterned after the existing 'ftrace
function triggers' implementation except that triggers are written to
per-event 'trigger' files instead of to a single file such as the
'set_ftrace_filter' used for ftrace function triggers.

The implementation is meant to be entirely separate from ftrace
function triggers, in order to keep the respective implementations
relatively simple and to allow them to diverge.

The event trigger functionality is built on top of SOFT_DISABLE
functionality.  It adds a TRIGGER_MODE bit to the ftrace_event_file
flags which is checked when any trace event fires.  Triggers set for a
particular event need to be checked regardless of whether that event
is actually enabled or not - getting an event to fire even if it's not
enabled is what's already implemented by SOFT_DISABLE mode, so trigger
mode directly reuses that.  Event trigger essentially inherit the soft
disable logic in __ftrace_event_enable_disable() while adding a bit of
logic and trigger reference counting via tm_ref on top of that in a
new trace_event_trigger_enable_disable() function.  Because the base
__ftrace_event_enable_disable() code now needs to be invoked from
outside trace_events.c, a wrapper is also added for those usages.

The triggers for an event are actually invoked via a new function,
event_triggers_call(), and code is also added to invoke them for
ftrace_raw_event calls as well as syscall events.

The main part of the patch creates a new trace_events_trigger.c file
to contain the trace event triggers implementation.

The standard open, read, and release file operations are implemented
here.

The open() implementation sets up for the various open modes of the
'trigger' file.  It creates and attaches the trigger iterator and sets
up the command parser.  If opened for reading set up the trigger
seq_ops.

The read() implementation parses the event trigger written to the
'trigger' file, looks up the trigger command, and passes it along to
that event_command's func() implementation for command-specific
processing.

The release() implementation does whatever cleanup is needed to
release the 'trigger' file, like releasing the parser and trigger
iterator, etc.

A couple of functions for event command registration and
unregistration are added, along with a list to add them to and a mutex
to protect them, as well as an (initially empty) registration function
to add the set of commands that will be added by future commits, and
call to it from the trace event initialization code.

also added are a couple trigger-specific data structures needed for
these implementations such as a trigger iterator and a struct for
trigger-specific data.

A couple structs consisting mostly of function meant to be implemented
in command-specific ways, event_command and event_trigger_ops, are
used by the generic event trigger command implementations.  They're
being put into trace.h alongside the other trace_event data structures
and functions, in the expectation that they'll be needed in several
trace_event-related files such as trace_events_trigger.c and
trace_events.c.

The event_command.func() function is meant to be called by the trigger
parsing code in order to add a trigger instance to the corresponding
event.  It essentially coordinates adding a live trigger instance to
the event, and arming the triggering the event.

Every event_command func() implementation essentially does the
same thing for any command:

   - choose ops - use the value of param to choose either a number or
     count version of event_trigger_ops specific to the command
   - do the register or unregister of those ops
   - associate a filter, if specified, with the triggering event

The reg() and unreg() ops allow command-specific implementations for
event_trigger_op registration and unregistration, and the
get_trigger_ops() op allows command-specific event_trigger_ops
selection to be parameterized.  When a trigger instance is added, the
reg() op essentially adds that trigger to the triggering event and
arms it, while unreg() does the opposite.  The set_filter() function
is used to associate a filter with the trigger - if the command
doesn't specify a set_filter() implementation, the command will ignore
filters.

Each command has an associated trigger_mode, which serves double duty,
both as a unique identifier for the command as well as a value that
can be used for setting a trigger mode bit during trigger invocation.

The signature of func() adds a pointer to the event_command struct,
used to invoke those functions, along with a command_data param that
can be passed to the reg/unreg functions.  This allows func()
implementations to use command-specific blobs and supports code
re-use.

The event_trigger_ops.func() command corrsponds to the trigger 'probe'
function that gets called when the triggering event is actually
invoked.  The other functions are used to list the trigger when
needed, along with a couple mundane book-keeping functions.

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

This also moves event_file_data() into trace.h so it can be used
outside of trace_events.c.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Idea-by: Steve Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h        |  13 +-
 include/trace/ftrace.h              |   4 +
 kernel/trace/Makefile               |   1 +
 kernel/trace/trace.h                | 175 +++++++++++
 kernel/trace/trace_events.c         |  36 ++-
 kernel/trace/trace_events_trigger.c | 570 ++++++++++++++++++++++++++++++++++++
 kernel/trace/trace_syscalls.c       |   4 +
 7 files changed, 795 insertions(+), 8 deletions(-)
 create mode 100644 kernel/trace/trace_events_trigger.c

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 120d57a..06be0fe 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -255,6 +255,7 @@ enum {
 	FTRACE_EVENT_FL_RECORDED_CMD_BIT,
 	FTRACE_EVENT_FL_SOFT_MODE_BIT,
 	FTRACE_EVENT_FL_SOFT_DISABLED_BIT,
+	FTRACE_EVENT_FL_TRIGGER_MODE_BIT,
 };
 
 /*
@@ -263,13 +264,15 @@ enum {
  *  RECORDED_CMD  - The comms should be recorded at sched_switch
  *  SOFT_MODE     - The event is enabled/disabled by SOFT_DISABLED
  *  SOFT_DISABLED - When set, do not trace the event (even though its
- *                   tracepoint may be enabled)
+ *                  tracepoint may be enabled)
+ *  TRIGGER_MODE  - The event is enabled/disabled by SOFT_DISABLED
  */
 enum {
 	FTRACE_EVENT_FL_ENABLED		= (1 << FTRACE_EVENT_FL_ENABLED_BIT),
 	FTRACE_EVENT_FL_RECORDED_CMD	= (1 << FTRACE_EVENT_FL_RECORDED_CMD_BIT),
 	FTRACE_EVENT_FL_SOFT_MODE	= (1 << FTRACE_EVENT_FL_SOFT_MODE_BIT),
 	FTRACE_EVENT_FL_SOFT_DISABLED	= (1 << FTRACE_EVENT_FL_SOFT_DISABLED_BIT),
+	FTRACE_EVENT_FL_TRIGGER_MODE	= (1 << FTRACE_EVENT_FL_TRIGGER_MODE_BIT),
 };
 
 struct ftrace_event_file {
@@ -278,6 +281,7 @@ struct ftrace_event_file {
 	struct dentry			*dir;
 	struct trace_array		*tr;
 	struct ftrace_subsystem_dir	*system;
+	struct list_head		triggers;
 
 	/*
 	 * 32 bit flags:
@@ -285,6 +289,7 @@ struct ftrace_event_file {
 	 *   bit 1:		enabled cmd record
 	 *   bit 2:		enable/disable with the soft disable bit
 	 *   bit 3:		soft disabled
+	 *   bit 4:		trigger enabled
 	 *
 	 * Note: The bits must be set atomically to prevent races
 	 * from other writers. Reads of flags do not need to be in
@@ -296,6 +301,7 @@ struct ftrace_event_file {
 	 */
 	unsigned long		flags;
 	atomic_t		sm_ref;	/* soft-mode reference counter */
+	atomic_t		tm_ref;	/* trigger-mode reference counter */
 };
 
 #define __TRACE_EVENT_FLAGS(name, value)				\
@@ -310,12 +316,17 @@ struct ftrace_event_file {
 
 #define MAX_FILTER_STR_VAL	256	/* Should handle KSYM_SYMBOL_LEN */
 
+enum trigger_mode {
+	TM_NONE			= (0),
+};
+
 extern void destroy_preds(struct ftrace_event_call *call);
 extern int filter_match_preds(struct event_filter *filter, void *rec);
 extern int filter_current_check_discard(struct ring_buffer *buffer,
 					struct ftrace_event_call *call,
 					void *rec,
 					struct ring_buffer_event *event);
+extern void event_triggers_call(struct ftrace_event_file *file);
 
 enum {
 	FILTER_OTHER = 0,
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 41a6643..326ba32 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -526,6 +526,10 @@ ftrace_raw_event_##call(void *__data, proto)				\
 	int __data_size;						\
 	int pc;								\
 									\
+	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT,			\
+		     &ftrace_file->flags))				\
+		event_triggers_call(ftrace_file);			\
+									\
 	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,			\
 		     &ftrace_file->flags))				\
 		return;							\
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index d7e2068..1378e84 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -50,6 +50,7 @@ ifeq ($(CONFIG_PERF_EVENTS),y)
 obj-$(CONFIG_EVENT_TRACING) += trace_event_perf.o
 endif
 obj-$(CONFIG_EVENT_TRACING) += trace_events_filter.o
+obj-$(CONFIG_EVENT_TRACING) += trace_events_trigger.o
 obj-$(CONFIG_KPROBE_EVENT) += trace_kprobe.o
 obj-$(CONFIG_TRACEPOINTS) += power-traces.o
 ifeq ($(CONFIG_PM_RUNTIME),y)
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 3dd994e8..c2afd79 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1016,9 +1016,184 @@ extern void trace_event_enable_cmd_record(bool enable);
 extern int event_trace_add_tracer(struct dentry *parent, struct trace_array *tr);
 extern int event_trace_del_tracer(struct trace_array *tr);
 
+extern struct ftrace_event_file *find_event_file(struct trace_array *tr,
+						 const char *system,
+						 const char *event);
+
+static inline void *event_file_data(struct file *filp)
+{
+	return ACCESS_ONCE(file_inode(filp)->i_private);
+}
+
 extern struct mutex event_mutex;
 extern struct list_head ftrace_events;
 
+extern const struct file_operations event_trigger_fops;
+
+extern int register_trigger_cmds(void);
+extern void clear_event_triggers(struct trace_array *tr);
+
+/**
+ * struct event_trigger_ops - callbacks for trace event triggers
+ *
+ * The methods in this structure provide per-event trigger hooks for
+ * various trigger operations.
+ *
+ * All the methods below, except for @init() and @free(), must be
+ * implemented.
+ *
+ * @func: The trigger 'probe' function called when the triggering
+ *	event occurs.  The data passed into this callback is the data
+ *	that was supplied to the event_command @reg() function that
+ *	registered the trigger (see struct event_command).
+ *
+ * @init: An optional initialization function called for the trigger
+ *	when the trigger is registered (via the event_command reg()
+ *	function).  This can be used to perform per-trigger
+ *	initialization such as incrementing a per-trigger reference
+ *	count, for instance.  This is usually implemented by the
+ *	generic utility function @event_trigger_init() (see
+ *	trace_event_triggers.c).
+ *
+ * @free: An optional de-initialization function called for the
+ *	trigger when the trigger is unregistered (via the
+ *	event_command @reg() function).  This can be used to perform
+ *	per-trigger de-initialization such as decrementing a
+ *	per-trigger reference count and freeing corresponding trigger
+ *	data, for instance.  This is usually implemented by the
+ *	generic utility function @event_trigger_free() (see
+ *	trace_event_triggers.c).
+ *
+ * @print: The callback function invoked to have the trigger print
+ *	itself.  This is usually implemented by a wrapper function
+ *	that calls the generic utility function @event_trigger_print()
+ *	(see trace_event_triggers.c).
+ */
+struct event_trigger_ops {
+	void			(*func)(void **data);
+	int			(*init)(struct event_trigger_ops *ops,
+					void **data);
+	void			(*free)(struct event_trigger_ops *ops,
+					void **data);
+	int			(*print)(struct seq_file *m,
+					 struct event_trigger_ops *ops,
+					 void *data);
+};
+
+/**
+ * struct event_command - callbacks and data members for event commands
+ *
+ * Event commands are invoked by users by writing the command name
+ * into the 'trigger' file associated with a trace event.  The
+ * parameters associated with a specific invocation of an event
+ * command are used to create an event trigger instance, which is
+ * added to the list of trigger instances associated with that trace
+ * event.  When the event is hit, the set of triggers associated with
+ * that event is invoked.
+ *
+ * The data members in this structure provide per-event command data
+ * for various event commands.
+ *
+ * All the data members below, except for @post_trigger, must be set
+ * for each event command.
+ *
+ * @name: The unique name that identifies the event command.  This is
+ *	the name used when setting triggers via trigger files.
+ *
+ * @trigger_mode: A unique id that identifies the event command
+ *	'category'.  This value has two purposes, the first to ensure
+ *	that only one trigger of the same category can be set at a
+ *	given time for a particular event e.g. it doesn't make sense
+ *	to have both a traceon and traceoff trigger attached to a
+ *	single event at the same time, so traceon and traceoff have
+ *	the same category though they have different names.  The
+ *	@trigger_mode value is also used as a bit value for deferring
+ *	the actual trigger action until after the current event is
+ *	finished.  Some commands need to do this if they themselves
+ *	log to the trace buffer (see the @post_trigger() member
+ *	below).  @trigger_mode values are defined by adding new values
+ *	to the trigger_mode enum in include/linux/ftrace_event.h.
+ *
+ * @post_trigger: A flag that says whether or not this command needs
+ *	to have its action delayed until after the current event has
+ *	been closed.  Some triggers need to avoid being invoked while
+ *	an event is currently in the process of being logged, since
+ *	the trigger may itself log data into the trace buffer.  Thus
+ *	we make sure the current event is committed before invoking
+ *	those triggers.  To do that, the trigger invocation is split
+ *	in two - the first part checks the filter using the current
+ *	trace record; if a command has the @post_trigger flag set, it
+ *	sets a bit for itself in the return value, otherwise it
+ *	directly invokes the trigger.  Once all commands have been
+ *	either invoked or set their return flag, the current record is
+ *	either committed or discarded.  At that point, if any commands
+ *	have deferred their triggers, those commands are finally
+ *	invoked following the close of the current event.  In other
+ *	words, if the event_trigger_ops @func() probe implementation
+ *	itself logs to the trace buffer, this flag should be set,
+ *	otherwise it can be left unspecified.
+ *
+ * All the methods below, except for @set_filter(), must be
+ * implemented.
+ *
+ * @func: The callback function responsible for parsing and
+ *	registering the trigger written to the 'trigger' file by the
+ *	user.  It allocates the trigger instance and registers it with
+ *	the appropriate trace event.  It makes use of the other
+ *	event_command callback functions to orchestrate this, and is
+ *	usually implemented by the generic utility function
+ *	@event_trigger_callback() (see trace_event_triggers.c).
+ *
+ * @reg: Adds the trigger to the list of triggers associated with the
+ *	event, and enables the event trigger itself, after
+ *	initializing it (via the event_trigger_ops @init() function).
+ *	This is also where commands can use the @trigger_mode value to
+ *	make the decision as to whether or not multiple instances of
+ *	the trigger should be allowed.  This is usually implemented by
+ *	the generic utility function @register_trigger() (see
+ *	trace_event_triggers.c).
+ *
+ * @unreg: Removes the trigger from the list of triggers associated
+ *	with the event, and disables the event trigger itself, after
+ *	initializing it (via the event_trigger_ops @free() function).
+ *	This is usually implemented by the generic utility function
+ *	@unregister_trigger() (see trace_event_triggers.c).
+ *
+ * @set_filter: An optional function called to parse and set a filter
+ *	for the trigger.  If no @set_filter() method is set for the
+ *	event command, filters set by the user for the command will be
+ *	ignored.  This is usually implemented by the generic utility
+ *	function @set_trigger_filter() (see trace_event_triggers.c).
+ *
+ * @get_trigger_ops: The callback function invoked to retrieve the
+ *	event_trigger_ops implementation associated with the command.
+ */
+struct event_command {
+	struct list_head	list;
+	char			*name;
+	enum trigger_mode	trigger_mode;
+	bool			post_trigger;
+	int			(*func)(struct event_command *cmd_ops,
+					struct ftrace_event_file *file,
+					char *glob, char *cmd,
+					char *params, int enable);
+	int			(*reg)(char *glob,
+				       struct event_trigger_ops *trigger_ops,
+				       void *trigger_data,
+				       struct ftrace_event_file *file);
+	void			(*unreg)(char *glob,
+					 struct event_trigger_ops *trigger_ops,
+					 void *trigger_data,
+					 struct ftrace_event_file *file);
+	int			(*set_filter)(char *filter_str,
+					      void *trigger_data,
+					      struct ftrace_event_file *file);
+	struct event_trigger_ops *(*get_trigger_ops)(char *cmd, char *param);
+};
+
+extern int trace_event_enable_disable(struct ftrace_event_file *file,
+				      int enable, int soft_disable);
+
 extern const char *__start___trace_bprintk_fmt[];
 extern const char *__stop___trace_bprintk_fmt[];
 
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 29a7ebc..e31b8cc 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -342,6 +342,12 @@ static int __ftrace_event_enable_disable(struct ftrace_event_file *file,
 	return ret;
 }
 
+int trace_event_enable_disable(struct ftrace_event_file *file,
+			       int enable, int soft_disable)
+{
+	return __ftrace_event_enable_disable(file, enable, soft_disable);
+}
+
 static int ftrace_event_enable_disable(struct ftrace_event_file *file,
 				       int enable)
 {
@@ -421,11 +427,6 @@ static void remove_subsystem(struct ftrace_subsystem_dir *dir)
 	}
 }
 
-static void *event_file_data(struct file *filp)
-{
-	return ACCESS_ONCE(file_inode(filp)->i_private);
-}
-
 static void remove_event_file_dir(struct ftrace_event_file *file)
 {
 	struct dentry *dir = file->dir;
@@ -1494,6 +1495,7 @@ event_create_dir(struct dentry *parent,
 		 const struct file_operations *id,
 		 const struct file_operations *enable,
 		 const struct file_operations *filter,
+		 const struct file_operations *trigger,
 		 const struct file_operations *format)
 {
 	struct ftrace_event_call *call = file->event_call;
@@ -1546,6 +1548,9 @@ event_create_dir(struct dentry *parent,
 	trace_create_file("filter", 0644, file->dir, call,
 			  filter);
 
+	trace_create_file("trigger", 0644, file->dir, file,
+			  trigger);
+
 	trace_create_file("format", 0444, file->dir, call,
 			  format);
 
@@ -1641,6 +1646,8 @@ trace_create_new_event(struct ftrace_event_call *call,
 	file->event_call = call;
 	file->tr = tr;
 	atomic_set(&file->sm_ref, 0);
+	atomic_set(&file->tm_ref, 0);
+	INIT_LIST_HEAD(&file->triggers);
 	list_add(&file->list, &tr->events);
 
 	return file;
@@ -1653,6 +1660,7 @@ __trace_add_new_event(struct ftrace_event_call *call,
 		      const struct file_operations *id,
 		      const struct file_operations *enable,
 		      const struct file_operations *filter,
+		      const struct file_operations *trigger,
 		      const struct file_operations *format)
 {
 	struct ftrace_event_file *file;
@@ -1661,7 +1669,8 @@ __trace_add_new_event(struct ftrace_event_call *call,
 	if (!file)
 		return -ENOMEM;
 
-	return event_create_dir(tr->event_dir, file, id, enable, filter, format);
+	return event_create_dir(tr->event_dir, file, id, enable, filter,
+				trigger, format);
 }
 
 /*
@@ -1782,6 +1791,7 @@ struct ftrace_module_file_ops {
 	struct file_operations		enable;
 	struct file_operations		format;
 	struct file_operations		filter;
+	struct file_operations		trigger;
 };
 
 static struct ftrace_module_file_ops *
@@ -1831,6 +1841,9 @@ trace_create_file_ops(struct module *mod)
 	file_ops->filter = ftrace_event_filter_fops;
 	file_ops->filter.owner = mod;
 
+	file_ops->trigger = event_trigger_fops;
+	file_ops->trigger.owner = mod;
+
 	file_ops->format = ftrace_event_format_fops;
 	file_ops->format.owner = mod;
 
@@ -1926,7 +1939,8 @@ __trace_add_new_mod_event(struct ftrace_event_call *call,
 {
 	return __trace_add_new_event(call, tr,
 				     &file_ops->id, &file_ops->enable,
-				     &file_ops->filter, &file_ops->format);
+				     &file_ops->filter, &file_ops->filter,
+				     &file_ops->format);
 }
 
 #else
@@ -1979,6 +1993,7 @@ __trace_add_event_dirs(struct trace_array *tr)
 					    &ftrace_event_id_fops,
 					    &ftrace_enable_fops,
 					    &ftrace_event_filter_fops,
+					    &event_trigger_fops,
 					    &ftrace_event_format_fops);
 		if (ret < 0)
 			pr_warning("Could not create directory for event %s\n",
@@ -2291,6 +2306,7 @@ __trace_early_add_event_dirs(struct trace_array *tr)
 				       &ftrace_event_id_fops,
 				       &ftrace_enable_fops,
 				       &ftrace_event_filter_fops,
+				       &event_trigger_fops,
 				       &ftrace_event_format_fops);
 		if (ret < 0)
 			pr_warning("Could not create directory for event %s\n",
@@ -2346,6 +2362,7 @@ __add_event_to_tracers(struct ftrace_event_call *call,
 					      &ftrace_event_id_fops,
 					      &ftrace_enable_fops,
 					      &ftrace_event_filter_fops,
+					      &event_trigger_fops,
 					      &ftrace_event_format_fops);
 	}
 }
@@ -2467,6 +2484,9 @@ int event_trace_del_tracer(struct trace_array *tr)
 {
 	mutex_lock(&event_mutex);
 
+	/* Disable any event triggers and associated soft-disabled events */
+	clear_event_triggers(tr);
+
 	/* Disable any running events */
 	__ftrace_set_clr_event_nolock(tr, NULL, NULL, NULL, 0);
 
@@ -2530,6 +2550,8 @@ static __init int event_trace_enable(void)
 
 	register_event_cmds();
 
+	register_trigger_cmds();
+
 	return 0;
 }
 
diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
new file mode 100644
index 0000000..7a52109
--- /dev/null
+++ b/kernel/trace/trace_events_trigger.c
@@ -0,0 +1,570 @@
+/*
+ * trace_events_trigger - trace event triggers
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) 2013 Tom Zanussi <tom.zanussi@linux.intel.com>
+ */
+
+#include <linux/module.h>
+#include <linux/ctype.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+
+#include "trace.h"
+
+static LIST_HEAD(trigger_commands);
+static DEFINE_MUTEX(trigger_cmd_mutex);
+
+struct event_trigger_data {
+	struct ftrace_event_file	*file;
+	unsigned long			count;
+	int				ref;
+	bool				enable;
+	struct event_trigger_ops	*ops;
+	struct event_command *		cmd_ops;
+	enum trigger_mode		mode;
+	struct event_filter		*filter;
+	char				*filter_str;
+	struct list_head		list;
+};
+
+static void
+trigger_data_free(struct event_trigger_data *data)
+{
+	synchronize_sched(); /* make sure current triggers exit before free */
+	kfree(data);
+}
+
+void event_triggers_call(struct ftrace_event_file *file)
+{
+	struct event_trigger_data *data;
+
+	if (list_empty(&file->triggers))
+		return;
+
+	preempt_disable_notrace();
+	list_for_each_entry_rcu(data, &file->triggers, list)
+		data->ops->func((void **)&data);
+	preempt_enable_notrace();
+}
+EXPORT_SYMBOL_GPL(event_triggers_call);
+
+static void *trigger_next(struct seq_file *m, void *t, loff_t *pos)
+{
+	struct ftrace_event_file *event_file = event_file_data(m->private);
+
+	return seq_list_next(t, &event_file->triggers, pos);
+}
+
+static void *trigger_start(struct seq_file *m, loff_t *pos)
+{
+	struct ftrace_event_file *event_file;
+
+	/* ->stop() is called even if ->start() fails */
+	mutex_lock(&event_mutex);
+	event_file = event_file_data(m->private);
+	if (unlikely(!event_file))
+		return ERR_PTR(-ENODEV);
+
+	return seq_list_start(&event_file->triggers, *pos);
+}
+
+static void trigger_stop(struct seq_file *m, void *t)
+{
+	mutex_unlock(&event_mutex);
+}
+
+static int trigger_show(struct seq_file *m, void *v)
+{
+	struct event_trigger_data *data;
+
+	data = list_entry(v, struct event_trigger_data, list);
+	data->ops->print(m, data->ops, data);
+
+	return 0;
+}
+
+static const struct seq_operations event_triggers_seq_ops = {
+	.start = trigger_start,
+	.next = trigger_next,
+	.stop = trigger_stop,
+	.show = trigger_show,
+};
+
+static int event_trigger_regex_open(struct inode *inode, struct file *file)
+{
+	int ret = 0;
+
+	mutex_lock(&event_mutex);
+
+	if (unlikely(!event_file_data(file))) {
+		mutex_unlock(&event_mutex);
+		return -ENODEV;
+	}
+
+	if (file->f_mode & FMODE_READ) {
+		ret = seq_open(file, &event_triggers_seq_ops);
+		if (!ret) {
+			struct seq_file *m = file->private_data;
+			m->private = file;
+		}
+	}
+
+	mutex_unlock(&event_mutex);
+
+	return ret;
+}
+
+static int trigger_process_regex(struct ftrace_event_file *file,
+				 char *buff, int enable)
+{
+	char *command, *next = buff;
+	struct event_command *p;
+	int ret = -EINVAL;
+
+	command = strsep(&next, ": \t");
+	command = (command[0] != '!') ? command : command + 1;
+
+	mutex_lock(&trigger_cmd_mutex);
+	list_for_each_entry(p, &trigger_commands, list) {
+		if (strcmp(p->name, command) == 0) {
+			ret = p->func(p, file, buff, command, next, enable);
+			goto out_unlock;
+		}
+	}
+ out_unlock:
+	mutex_unlock(&trigger_cmd_mutex);
+
+	return ret;
+}
+
+static ssize_t event_trigger_regex_write(struct file *file,
+					 const char __user *ubuf,
+					 size_t cnt, loff_t *ppos, int enable)
+{
+	struct ftrace_event_file *event_file;
+	ssize_t ret;
+	char *buf;
+
+	if (!cnt)
+		return 0;
+
+	if (cnt >= PAGE_SIZE)
+		return -EINVAL;
+
+	buf = (char *)__get_free_page(GFP_TEMPORARY);
+	if (!buf)
+		return -ENOMEM;
+
+	if (copy_from_user(buf, ubuf, cnt)) {
+		free_page((unsigned long) buf);
+		return -EFAULT;
+	}
+	buf[cnt] = '\0';
+	strim(buf);
+
+	mutex_lock(&event_mutex);
+	event_file = event_file_data(file);
+	if (unlikely(!event_file)) {
+		mutex_unlock(&event_mutex);
+		free_page((unsigned long) buf);
+		return -ENODEV;
+	}
+	ret = trigger_process_regex(event_file, buf, enable);
+	mutex_unlock(&event_mutex);
+
+	free_page((unsigned long) buf);
+	if (ret < 0)
+		goto out;
+
+	*ppos += cnt;
+	ret = cnt;
+ out:
+	return ret;
+}
+
+static int event_trigger_regex_release(struct inode *inode, struct file *file)
+{
+	mutex_lock(&event_mutex);
+
+	if (file->f_mode & FMODE_READ)
+		seq_release(inode, file);
+
+	mutex_unlock(&event_mutex);
+
+	return 0;
+}
+
+static ssize_t
+event_trigger_write(struct file *filp, const char __user *ubuf,
+		    size_t cnt, loff_t *ppos)
+{
+	return event_trigger_regex_write(filp, ubuf, cnt, ppos, 1);
+}
+
+static int
+event_trigger_open(struct inode *inode, struct file *filp)
+{
+	return event_trigger_regex_open(inode, filp);
+}
+
+static int
+event_trigger_release(struct inode *inode, struct file *file)
+{
+	return event_trigger_regex_release(inode, file);
+}
+
+const struct file_operations event_trigger_fops = {
+	.open = event_trigger_open,
+	.read = seq_read,
+	.write = event_trigger_write,
+	.llseek = ftrace_filter_lseek,
+	.release = event_trigger_release,
+};
+
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
+event_trigger_init(struct event_trigger_ops *ops, void **_data)
+{
+	struct event_trigger_data **p = (struct event_trigger_data **)_data;
+	struct event_trigger_data *data = *p;
+
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
+event_trigger_free(struct event_trigger_ops *ops, void **_data)
+{
+	struct event_trigger_data **p = (struct event_trigger_data **)_data;
+	struct event_trigger_data *data = *p;
+
+	if (WARN_ON_ONCE(data->ref <= 0))
+		return;
+
+	data->ref--;
+	if (!data->ref)
+		trigger_data_free(data);
+}
+
+static int trace_event_trigger_enable_disable(struct ftrace_event_file *file,
+					      int trigger_enable)
+{
+	int ret = 0;
+
+	if (trigger_enable) {
+		if (atomic_inc_return(&file->tm_ref) > 1)
+			return ret;
+		set_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT, &file->flags);
+		ret = trace_event_enable_disable(file, 1, 1);
+	} else {
+		if (atomic_dec_return(&file->tm_ref) > 0)
+			return ret;
+		clear_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT, &file->flags);
+		ret = trace_event_enable_disable(file, 0, 1);
+	}
+
+	return ret;
+}
+
+/**
+ * clear_event_triggers - clear all triggers associated with a trace array.
+ *
+ * For each trigger, the triggering event has its tm_ref decremented
+ * via trace_event_trigger_enable_disable(), and any associated event
+ * (in the case of enable/disable_event triggers) will have its sm_ref
+ * decremented via free()->trace_event_enable_disable().  That
+ * combination effectively reverses the soft-mode/trigger state added
+ * by trigger registration.
+ *
+ * Must be called with event_mutex held.
+ */
+void
+clear_event_triggers(struct trace_array *tr)
+{
+	struct ftrace_event_file *file;
+
+	list_for_each_entry(file, &tr->events, list) {
+		struct event_trigger_data *data;
+		list_for_each_entry_rcu(data, &file->triggers, list) {
+			trace_event_trigger_enable_disable(file, 0);
+			if (data->ops->free)
+				data->ops->free(data->ops, (void **)&data);
+		}
+	}
+}
+
+/**
+ * register_trigger - generic event_command @reg implementation
+ *
+ * Common implementation for event trigger registration.
+ *
+ * Usually used directly as the @reg method in event command
+ * implementations.
+ */
+static int register_trigger(char *glob, struct event_trigger_ops *ops,
+			    void *trigger_data, struct ftrace_event_file *file)
+{
+	struct event_trigger_data *data = trigger_data;
+	struct event_trigger_data *test;
+	int ret = 0;
+
+	list_for_each_entry_rcu(test, &file->triggers, list) {
+		if (test->mode == data->mode) {
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
+			       void *trigger_data,
+			       struct ftrace_event_file *file)
+{
+	struct event_trigger_data *test = trigger_data;
+	struct event_trigger_data *data;
+	bool unregistered = false;
+
+	list_for_each_entry_rcu(data, &file->triggers, list) {
+		if (data->mode == test->mode) {
+			unregistered = true;
+			list_del_rcu(&data->list);
+			trace_event_trigger_enable_disable(file, 0);
+			break;
+		}
+	}
+
+	if (unregistered && data->ops->free)
+		data->ops->free(data->ops, (void **)&data);
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
+	trigger_data->mode = cmd_ops->trigger_mode;
+	trigger_data->post_trigger = cmd_ops->post_trigger;
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
+__init int register_trigger_cmds(void)
+{
+	return 0;
+}
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 4a47b6d..bb40a8d 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -321,6 +321,8 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 	if (!ftrace_file)
 		return;
 
+	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT, &ftrace_file->flags))
+		event_triggers_call(ftrace_file);
 	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
 		return;
 
@@ -370,6 +372,8 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	if (!ftrace_file)
 		return;
 
+	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT, &ftrace_file->flags))
+		event_triggers_call(ftrace_file);
 	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
 		return;
 
-- 
1.7.11.4

