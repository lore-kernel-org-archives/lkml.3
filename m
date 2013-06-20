Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030395Ab3FTSbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 14:31:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:28545 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030380Ab3FTSbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 14:31:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,906,1363158000"; 
   d="scan'208";a="356919798"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH 05/11] tracing: add basic event trigger framework
Date: Thu, 20 Jun 2013 13:31:29 -0500
Message-Id: <920295ddd25d36c03d809e49f6d39033b1a76dae.1371751701.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <cover.1371751701.git.tom.zanussi@linux.intel.com>
References: <cover.1371751701.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1371751701.git.tom.zanussi@linux.intel.com>
References: <cover.1371751701.git.tom.zanussi@linux.intel.com>
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
enabled is essentially what's already implemented by SOFT_DISABLE
mode, so trigger mode directly reuses that.  It essentially inherits
the soft disable logic in __ftrace_event_enable_disable() while adding
a bit of logic and trigger reference counting via tm_ref on top of
that.  Because the enable_disable code needs to now be invoked from
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
arm/disarm them as appropriate.

Most event commands will use these, but some will override and
possibly reuse them.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Idea-by: Steve Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h        |   9 +-
 include/trace/ftrace.h              |   4 +
 kernel/trace/Makefile               |   1 +
 kernel/trace/trace.h                |  37 ++++
 kernel/trace/trace_events.c         |  58 ++++--
 kernel/trace/trace_events_trigger.c | 340 ++++++++++++++++++++++++++++++++++++
 kernel/trace/trace_syscalls.c       |   8 +
 7 files changed, 446 insertions(+), 11 deletions(-)
 create mode 100644 kernel/trace/trace_events_trigger.c

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 4372658..10a5fa4 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -253,6 +253,7 @@ enum {
 	FTRACE_EVENT_FL_RECORDED_CMD_BIT,
 	FTRACE_EVENT_FL_SOFT_MODE_BIT,
 	FTRACE_EVENT_FL_SOFT_DISABLED_BIT,
+	FTRACE_EVENT_FL_TRIGGER_MODE_BIT,
 };
 
 /*
@@ -261,13 +262,15 @@ enum {
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
@@ -276,6 +279,7 @@ struct ftrace_event_file {
 	struct dentry			*dir;
 	struct trace_array		*tr;
 	struct ftrace_subsystem_dir	*system;
+	struct list_head		triggers;
 
 	/*
 	 * 32 bit flags:
@@ -283,6 +287,7 @@ struct ftrace_event_file {
 	 *   bit 1:		enabled cmd record
 	 *   bit 2:		enable/disable with the soft disable bit
 	 *   bit 3:		soft disabled
+	 *   bit 4:		trigger enabled
 	 *
 	 * Note: The bits must be set atomically to prevent races
 	 * from other writers. Reads of flags do not need to be in
@@ -294,6 +299,7 @@ struct ftrace_event_file {
 	 */
 	unsigned long		flags;
 	atomic_t		sm_ref;	/* soft-mode reference counter */
+	atomic_t		tm_ref;	/* trigger-mode reference counter */
 };
 
 #define __TRACE_EVENT_FLAGS(name, value)				\
@@ -314,6 +320,7 @@ extern int filter_current_check_discard(struct ring_buffer *buffer,
 					struct ftrace_event_call *call,
 					void *rec,
 					struct ring_buffer_event *event);
+extern void event_triggers_call(struct ftrace_event_file *file);
 
 enum {
 	FILTER_OTHER = 0,
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 19edd7f..88ac7da 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -522,6 +522,10 @@ ftrace_raw_event_##call(void *__data, proto)				\
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
index 20572ed..3738d65 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1024,6 +1024,43 @@ extern int event_trace_del_tracer(struct trace_array *tr);
 extern struct mutex event_mutex;
 extern struct list_head ftrace_events;
 
+extern const struct file_operations event_trigger_fops;
+
+extern int register_trigger_cmds(void);
+
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
+struct event_command {
+	struct list_head	list;
+	char			*name;
+	int			(*func)(struct event_command *cmd_ops,
+					void *cmd_data,	char *glob, char *cmd,
+					char *params, int enable);
+	int			(*reg)(char *glob,
+				       struct event_trigger_ops *trigger_ops,
+				       void *trigger_data, void *cmd_data);
+	void			(*unreg)(char *glob,
+					 struct event_trigger_ops *trigger_ops,
+					 void *trigger_data, void *cmd_data);
+	int			(*set_filter)(char *filter_str,
+					      void *trigger_data,
+					      void *cmd_data);
+	struct event_trigger_ops *(*get_trigger_ops)(char *cmd, char *param);
+};
+
+extern int trace_event_enable_disable(struct ftrace_event_file *file,
+				      int enable, int soft_disable,
+				      int trigger_enable);
+
 extern const char *__start___trace_bprintk_fmt[];
 extern const char *__stop___trace_bprintk_fmt[];
 
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index f9738dc..1fc1602 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -242,7 +242,8 @@ void trace_event_enable_cmd_record(bool enable)
 }
 
 static int __ftrace_event_enable_disable(struct ftrace_event_file *file,
-					 int enable, int soft_disable)
+					 int enable, int soft_disable,
+					 int trigger_enable)
 {
 	struct ftrace_event_call *call = file->event_call;
 	int ret = 0;
@@ -263,7 +264,13 @@ static int __ftrace_event_enable_disable(struct ftrace_event_file *file,
 		 * we do nothing. Do not disable the tracepoint, otherwise
 		 * "soft enable"s (clearing the SOFT_DISABLED bit) wont work.
 		 */
-		if (soft_disable) {
+		if (trigger_enable) {
+			if (atomic_dec_return(&file->tm_ref) > 0)
+				break;
+			clear_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT, &file->flags);
+			ret = __ftrace_event_enable_disable(file, enable, 1, 0);
+			break;
+		} else if (soft_disable) {
 			if (atomic_dec_return(&file->sm_ref) > 0)
 				break;
 			disable = file->flags & FTRACE_EVENT_FL_SOFT_DISABLED;
@@ -279,7 +286,7 @@ static int __ftrace_event_enable_disable(struct ftrace_event_file *file,
 			}
 			call->class->reg(call, TRACE_REG_UNREGISTER, file);
 		}
-		/* If in SOFT_MODE, just set the SOFT_DISABLE_BIT */
+		/* If in SOFT_MODE, just set the SOFT_DISABLE_BIT, else clear it */
 		if (file->flags & FTRACE_EVENT_FL_SOFT_MODE)
 			set_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &file->flags);
 		else
@@ -294,7 +301,13 @@ static int __ftrace_event_enable_disable(struct ftrace_event_file *file,
 		 * set SOFT_DISABLED before enabling the event tracepoint, so
 		 * it still seems to be disabled.
 		 */
-		if (!soft_disable)
+		if (trigger_enable) {
+			if (atomic_inc_return(&file->tm_ref) > 1)
+				break;
+			set_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT, &file->flags);
+			ret = __ftrace_event_enable_disable(file, enable, 1, 0);
+			break;
+		} else if (!soft_disable)
 			clear_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &file->flags);
 		else {
 			if (atomic_inc_return(&file->sm_ref) > 1)
@@ -330,10 +343,18 @@ static int __ftrace_event_enable_disable(struct ftrace_event_file *file,
 	return ret;
 }
 
+int trace_event_enable_disable(struct ftrace_event_file *file,
+			       int enable, int soft_disable,
+			       int trigger_enable)
+{
+	return __ftrace_event_enable_disable(file, enable, soft_disable,
+					     trigger_enable);
+}
+
 static int ftrace_event_enable_disable(struct ftrace_event_file *file,
 				       int enable)
 {
-	return __ftrace_event_enable_disable(file, enable, 0);
+	return __ftrace_event_enable_disable(file, enable, 0, 0);
 }
 
 static void ftrace_clear_events(struct trace_array *tr)
@@ -1380,6 +1401,7 @@ event_create_dir(struct dentry *parent,
 		 const struct file_operations *id,
 		 const struct file_operations *enable,
 		 const struct file_operations *filter,
+		 const struct file_operations *trigger,
 		 const struct file_operations *format)
 {
 	struct ftrace_event_call *call = file->event_call;
@@ -1432,6 +1454,9 @@ event_create_dir(struct dentry *parent,
 	trace_create_file("filter", 0644, file->dir, call,
 			  filter);
 
+	trace_create_file("trigger", 0644, file->dir, file,
+			  trigger);
+
 	trace_create_file("format", 0444, file->dir, call,
 			  format);
 
@@ -1544,6 +1569,8 @@ trace_create_new_event(struct ftrace_event_call *call,
 	file->event_call = call;
 	file->tr = tr;
 	atomic_set(&file->sm_ref, 0);
+	atomic_set(&file->tm_ref, 0);
+	INIT_LIST_HEAD(&file->triggers);
 	list_add(&file->list, &tr->events);
 
 	return file;
@@ -1556,6 +1583,7 @@ __trace_add_new_event(struct ftrace_event_call *call,
 		      const struct file_operations *id,
 		      const struct file_operations *enable,
 		      const struct file_operations *filter,
+		      const struct file_operations *trigger,
 		      const struct file_operations *format)
 {
 	struct ftrace_event_file *file;
@@ -1564,7 +1592,7 @@ __trace_add_new_event(struct ftrace_event_call *call,
 	if (!file)
 		return -ENOMEM;
 
-	return event_create_dir(tr->event_dir, file, id, enable, filter, format);
+	return event_create_dir(tr->event_dir, file, id, enable, filter, trigger, format);
 }
 
 /*
@@ -1643,6 +1671,7 @@ struct ftrace_module_file_ops {
 	struct file_operations		enable;
 	struct file_operations		format;
 	struct file_operations		filter;
+	struct file_operations		trigger;
 };
 
 static struct ftrace_module_file_ops *
@@ -1692,6 +1721,9 @@ trace_create_file_ops(struct module *mod)
 	file_ops->filter = ftrace_event_filter_fops;
 	file_ops->filter.owner = mod;
 
+	file_ops->trigger = event_trigger_fops;
+	file_ops->trigger.owner = mod;
+
 	file_ops->format = ftrace_event_format_fops;
 	file_ops->format.owner = mod;
 
@@ -1785,7 +1817,8 @@ __trace_add_new_mod_event(struct ftrace_event_call *call,
 {
 	return __trace_add_new_event(call, tr,
 				     &file_ops->id, &file_ops->enable,
-				     &file_ops->filter, &file_ops->format);
+				     &file_ops->filter, &file_ops->filter,
+				     &file_ops->format);
 }
 
 #else
@@ -1838,6 +1871,7 @@ __trace_add_event_dirs(struct trace_array *tr)
 					    &ftrace_event_id_fops,
 					    &ftrace_enable_fops,
 					    &ftrace_event_filter_fops,
+					    &event_trigger_fops,
 					    &ftrace_event_format_fops);
 		if (ret < 0)
 			pr_warning("Could not create directory for event %s\n",
@@ -1963,7 +1997,7 @@ event_enable_free(struct ftrace_probe_ops *ops, unsigned long ip,
 	data->ref--;
 	if (!data->ref) {
 		/* Remove the SOFT_MODE flag */
-		__ftrace_event_enable_disable(data->file, 0, 1);
+		__ftrace_event_enable_disable(data->file, 0, 1, 0);
 		module_put(data->file->event_call->mod);
 		kfree(data);
 	}
@@ -2079,7 +2113,7 @@ event_enable_func(struct ftrace_hash *hash,
 		goto out_free;
 	}
 
-	ret = __ftrace_event_enable_disable(file, 1, 1);
+	ret = __ftrace_event_enable_disable(file, 1, 1, 0);
 	if (ret < 0)
 		goto out_put;
 	ret = register_ftrace_function_probe(glob, ops, data);
@@ -2100,7 +2134,7 @@ event_enable_func(struct ftrace_hash *hash,
 	return ret;
 
  out_disable:
-	__ftrace_event_enable_disable(file, 0, 1);
+	__ftrace_event_enable_disable(file, 0, 1, 0);
  out_put:
 	module_put(file->event_call->mod);
  out_free:
@@ -2153,6 +2187,7 @@ __trace_early_add_event_dirs(struct trace_array *tr)
 				       &ftrace_event_id_fops,
 				       &ftrace_enable_fops,
 				       &ftrace_event_filter_fops,
+				       &event_trigger_fops,
 				       &ftrace_event_format_fops);
 		if (ret < 0)
 			pr_warning("Could not create directory for event %s\n",
@@ -2212,6 +2247,7 @@ __add_event_to_tracers(struct ftrace_event_call *call,
 					      &ftrace_event_id_fops,
 					      &ftrace_enable_fops,
 					      &ftrace_event_filter_fops,
+					      &event_trigger_fops,
 					      &ftrace_event_format_fops);
 	}
 }
@@ -2396,6 +2432,8 @@ static __init int event_trace_enable(void)
 
 	register_event_cmds();
 
+	register_trigger_cmds();
+
 	return 0;
 }
 
diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
new file mode 100644
index 0000000..3a1b46b
--- /dev/null
+++ b/kernel/trace/trace_events_trigger.c
@@ -0,0 +1,340 @@
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
+	struct event_filter		*filter;
+	char				*filter_str;
+	struct list_head		list;
+};
+
+struct trigger_iterator {
+	struct ftrace_event_file	*file;
+};
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
+	struct trigger_iterator *iter = m->private;
+
+	return seq_list_next(t, &iter->file->triggers, pos);
+}
+
+static void *trigger_start(struct seq_file *m, loff_t *pos)
+{
+	struct trigger_iterator *iter = m->private;
+
+	mutex_lock(&event_mutex);
+
+	return seq_list_start(&iter->file->triggers, *pos);
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
+	struct trigger_iterator *iter;
+	int ret = 0;
+
+	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
+	if (!iter)
+		return -ENOMEM;
+
+	iter->file = inode->i_private;
+
+	mutex_lock(&event_mutex);
+
+	if (file->f_mode & FMODE_READ) {
+		ret = seq_open(file, &event_triggers_seq_ops);
+		if (!ret) {
+			struct seq_file *m = file->private_data;
+			m->private = iter;
+		} else {
+			/* Failed */
+			kfree(iter);
+		}
+	} else
+		file->private_data = iter;
+
+	mutex_unlock(&event_mutex);
+
+	return ret;
+}
+
+static int trigger_process_regex(struct trigger_iterator *iter,
+				 char *buff, int enable)
+{
+	struct event_command *p;
+	char *command, *next = buff;
+	int ret = -EINVAL;
+
+	command = strsep(&next, ": \t");
+	command = (command[0] != '!') ? command : command + 1;
+
+	mutex_lock(&trigger_cmd_mutex);
+	list_for_each_entry(p, &trigger_commands, list) {
+		if (strcmp(p->name, command) == 0) {
+			ret = p->func(p, iter, buff, command, next, enable);
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
+	struct trigger_iterator *iter = file->private_data;
+	ssize_t ret;
+	char *buf;
+
+	if (!cnt)
+		return 0;
+
+	if (cnt >= PAGE_SIZE)
+		return -EINVAL;
+
+	if (file->f_mode & FMODE_READ) {
+		struct seq_file *m = file->private_data;
+		iter = m->private;
+	} else
+		iter = file->private_data;
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
+	ret = trigger_process_regex(iter, buf, enable);
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
+	struct seq_file *m = (struct seq_file *)file->private_data;
+	struct trigger_iterator *iter;
+
+	mutex_lock(&event_mutex);
+
+	if (file->f_mode & FMODE_READ) {
+		iter = m->private;
+
+		seq_release(inode, file);
+	} else
+		iter = file->private_data;
+
+	kfree(iter);
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
+static int register_event_command(struct event_command *cmd,
+				  struct list_head *cmd_list,
+				  struct mutex *cmd_list_mutex)
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
+static int unregister_event_command(struct event_command *cmd,
+				    struct list_head *cmd_list,
+				    struct mutex *cmd_list_mutex)
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
+static int register_trigger(char *glob, struct event_trigger_ops *ops,
+			    void *trigger_data, void *cmd_data)
+{
+	struct trigger_iterator *iter = cmd_data;
+	struct event_trigger_data *data = trigger_data;
+	struct event_trigger_data *test;
+	int ret = 0;
+
+	list_for_each_entry_rcu(test, &iter->file->triggers, list) {
+		if (test->ops == data->ops) {
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
+	if (trace_event_enable_disable(iter->file, 1, 0, 1) < 0) {
+		list_del_rcu(&data->list);
+		ret--;
+	}
+out:
+	return ret;
+}
+
+static void unregister_trigger(char *glob, struct event_trigger_ops *ops,
+			       void *trigger_data, void *cmd_data)
+{
+	struct trigger_iterator *iter = cmd_data;
+	struct event_trigger_data *test = trigger_data;
+	struct event_trigger_data *data;
+	bool unregistered = false;
+
+	list_for_each_entry_rcu(data, &iter->file->triggers, list) {
+		if (data->ops == test->ops) {
+			unregistered = true;
+			list_del_rcu(&data->list);
+			trace_event_enable_disable(iter->file, 0, 0, 1);
+			break;
+		}
+	}
+
+	if (unregistered && data->ops->free)
+		data->ops->free(data->ops, (void **)&data);
+}
+
+__init int register_trigger_cmds(void)
+{
+	return 0;
+}
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 1d81881..e287011 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -319,6 +319,10 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 	if (!sys_data)
 		return;
 
+	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT,
+		     &sys_data->enter_file->flags))
+		event_triggers_call(sys_data->enter_file);
+
 	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,
 		     &sys_data->enter_file->flags))
 		return;
@@ -359,6 +363,10 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	if (!sys_data)
 		return;
 
+	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT,
+		     &sys_data->exit_file->flags))
+		event_triggers_call(sys_data->exit_file);
+
 	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,
 		     &sys_data->exit_file->flags))
 		return;
-- 
1.7.11.4

