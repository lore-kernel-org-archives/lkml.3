Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760631Ab3B0RvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 12:51:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4530 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760582Ab3B0RuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 12:50:02 -0500
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=B7jpROUcRFMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=SaeQvhJZZKcA:10 a=20KFwNOVAAAA:8 a=dTWnmunHYR8pGKheq4UA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Sz8tZYn4fcxWAPud:21 a=yDdEojtylCsMx8wQ:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130227174957.874921898@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 27 Feb 2013 12:22:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>, hcochran@lexmark.com
Subject: [for-next][PATCH 1/8] tracing: Separate out trace events from global variables
References: <20130227172232.707306533@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Separate-out-trace-events-from-global-variab.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The trace events for ftrace are all defined via global variables.
The arrays of events and event systems are linked to a global list.
This prevents multiple users of the event system (what to enable and
what not to).

By adding descriptors to represent the event/file relation, as well
as to which trace_array descriptor they are associated with, allows
for more than one set of events to be defined. Once the trace events
files have a link between the trace event and the trace_array they
are associated with, we can create multiple trace_arrays that can
record separate events in separate buffers.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h       |   51 ++-
 include/trace/ftrace.h             |    3 +-
 kernel/trace/trace.c               |    8 +
 kernel/trace/trace.h               |   39 +-
 kernel/trace/trace_events.c        |  776 +++++++++++++++++++++++++-----------
 kernel/trace/trace_events_filter.c |    5 +-
 6 files changed, 622 insertions(+), 260 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 13a54d0..c7191d4 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -182,18 +182,20 @@ extern int ftrace_event_reg(struct ftrace_event_call *event,
 			    enum trace_reg type, void *data);
 
 enum {
-	TRACE_EVENT_FL_ENABLED_BIT,
 	TRACE_EVENT_FL_FILTERED_BIT,
-	TRACE_EVENT_FL_RECORDED_CMD_BIT,
 	TRACE_EVENT_FL_CAP_ANY_BIT,
 	TRACE_EVENT_FL_NO_SET_FILTER_BIT,
 	TRACE_EVENT_FL_IGNORE_ENABLE_BIT,
 };
 
+/*
+ * Event flags:
+ *  FILTERED	  - The event has a filter attached
+ *  CAP_ANY	  - Any user can enable for perf
+ *  NO_SET_FILTER - Set when filter has error and is to be ignored
+ */
 enum {
-	TRACE_EVENT_FL_ENABLED		= (1 << TRACE_EVENT_FL_ENABLED_BIT),
 	TRACE_EVENT_FL_FILTERED		= (1 << TRACE_EVENT_FL_FILTERED_BIT),
-	TRACE_EVENT_FL_RECORDED_CMD	= (1 << TRACE_EVENT_FL_RECORDED_CMD_BIT),
 	TRACE_EVENT_FL_CAP_ANY		= (1 << TRACE_EVENT_FL_CAP_ANY_BIT),
 	TRACE_EVENT_FL_NO_SET_FILTER	= (1 << TRACE_EVENT_FL_NO_SET_FILTER_BIT),
 	TRACE_EVENT_FL_IGNORE_ENABLE	= (1 << TRACE_EVENT_FL_IGNORE_ENABLE_BIT),
@@ -203,12 +205,44 @@ struct ftrace_event_call {
 	struct list_head	list;
 	struct ftrace_event_class *class;
 	char			*name;
-	struct dentry		*dir;
 	struct trace_event	event;
 	const char		*print_fmt;
 	struct event_filter	*filter;
+	struct list_head	*files;
 	void			*mod;
 	void			*data;
+	int			flags; /* static flags of different events */
+
+#ifdef CONFIG_PERF_EVENTS
+	int				perf_refcount;
+	struct hlist_head __percpu	*perf_events;
+#endif
+};
+
+struct trace_array;
+struct ftrace_subsystem_dir;
+
+enum {
+	FTRACE_EVENT_FL_ENABLED_BIT,
+	FTRACE_EVENT_FL_RECORDED_CMD_BIT,
+};
+
+/*
+ * Ftrace event file flags:
+ *  ENABELD	  - The event is enabled
+ *  RECORDED_CMD  - The comms should be recorded at sched_switch
+ */
+enum {
+	FTRACE_EVENT_FL_ENABLED		= (1 << FTRACE_EVENT_FL_ENABLED_BIT),
+	FTRACE_EVENT_FL_RECORDED_CMD	= (1 << FTRACE_EVENT_FL_RECORDED_CMD_BIT),
+};
+
+struct ftrace_event_file {
+	struct list_head		list;
+	struct ftrace_event_call	*event_call;
+	struct dentry			*dir;
+	struct trace_array		*tr;
+	struct ftrace_subsystem_dir	*system;
 
 	/*
 	 * 32 bit flags:
@@ -223,17 +257,12 @@ struct ftrace_event_call {
 	 *
 	 * Note: Reads of flags do not hold the event_mutex since
 	 * they occur in critical sections. But the way flags
-	 * is currently used, these changes do no affect the code
+	 * is currently used, these changes do not affect the code
 	 * except that when a change is made, it may have a slight
 	 * delay in propagating the changes to other CPUs due to
 	 * caching and such.
 	 */
 	unsigned int		flags;
-
-#ifdef CONFIG_PERF_EVENTS
-	int				perf_refcount;
-	struct hlist_head __percpu	*perf_events;
-#endif
 };
 
 #define __TRACE_EVENT_FLAGS(name, value)				\
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 40dc5e8..191d966 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -518,7 +518,8 @@ static inline notrace int ftrace_get_offsets_##call(			\
 static notrace void							\
 ftrace_raw_event_##call(void *__data, proto)				\
 {									\
-	struct ftrace_event_call *event_call = __data;			\
+	struct ftrace_event_file *ftrace_file = __data;			\
+	struct ftrace_event_call *event_call = ftrace_file->event_call;	\
 	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
 	struct ring_buffer_event *event;				\
 	struct ftrace_raw_##call *entry;				\
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c2e2c23..a2756a0 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -189,6 +189,8 @@ unsigned long long ns2usecs(cycle_t nsec)
  */
 static struct trace_array	global_trace;
 
+LIST_HEAD(ftrace_trace_arrays);
+
 static DEFINE_PER_CPU(struct trace_array_cpu, global_trace_cpu);
 
 int filter_current_check_discard(struct ring_buffer *buffer,
@@ -5303,6 +5305,12 @@ __init static int tracer_alloc_buffers(void)
 
 	register_die_notifier(&trace_die_notifier);
 
+	global_trace.flags = TRACE_ARRAY_FL_GLOBAL;
+
+	INIT_LIST_HEAD(&global_trace.systems);
+	INIT_LIST_HEAD(&global_trace.events);
+	list_add(&global_trace.list, &ftrace_trace_arrays);
+
 	while (trace_boot_options) {
 		char *option;
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 57d7e53..ef11984 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -158,13 +158,39 @@ struct trace_array_cpu {
  */
 struct trace_array {
 	struct ring_buffer	*buffer;
+	struct list_head	list;
 	int			cpu;
 	int			buffer_disabled;
+	unsigned int		flags;
 	cycle_t			time_start;
+	struct dentry		*dir;
+	struct dentry		*event_dir;
+	struct list_head	systems;
+	struct list_head	events;
 	struct task_struct	*waiter;
 	struct trace_array_cpu	*data[NR_CPUS];
 };
 
+enum {
+	TRACE_ARRAY_FL_GLOBAL	= (1 << 0)
+};
+
+extern struct list_head ftrace_trace_arrays;
+
+/*
+ * The global tracer (top) should be the first trace array added,
+ * but we check the flag anyway.
+ */
+static inline struct trace_array *top_trace_array(void)
+{
+	struct trace_array *tr;
+
+	tr = list_entry(ftrace_trace_arrays.prev,
+			typeof(*tr), list);
+	WARN_ON(!(tr->flags & TRACE_ARRAY_FL_GLOBAL));
+	return tr;
+}
+
 #define FTRACE_CMP_TYPE(var, type) \
 	__builtin_types_compatible_p(typeof(var), type *)
 
@@ -847,12 +873,19 @@ struct event_filter {
 struct event_subsystem {
 	struct list_head	list;
 	const char		*name;
-	struct dentry		*entry;
 	struct event_filter	*filter;
-	int			nr_events;
 	int			ref_count;
 };
 
+struct ftrace_subsystem_dir {
+	struct list_head		list;
+	struct event_subsystem		*subsystem;
+	struct trace_array		*tr;
+	struct dentry			*entry;
+	int				ref_count;
+	int				nr_events;
+};
+
 #define FILTER_PRED_INVALID	((unsigned short)-1)
 #define FILTER_PRED_IS_RIGHT	(1 << 15)
 #define FILTER_PRED_FOLD	(1 << 15)
@@ -910,7 +943,7 @@ extern void print_event_filter(struct ftrace_event_call *call,
 			       struct trace_seq *s);
 extern int apply_event_filter(struct ftrace_event_call *call,
 			      char *filter_string);
-extern int apply_subsystem_event_filter(struct event_subsystem *system,
+extern int apply_subsystem_event_filter(struct ftrace_subsystem_dir *dir,
 					char *filter_string);
 extern void print_subsystem_event_filter(struct event_subsystem *system,
 					 struct trace_seq *s);
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 57e9b28..4399552 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -36,6 +36,19 @@ EXPORT_SYMBOL_GPL(event_storage);
 LIST_HEAD(ftrace_events);
 LIST_HEAD(ftrace_common_fields);
 
+/* Double loops, do not use break, only goto's work */
+#define do_for_each_event_file(tr, file)			\
+	list_for_each_entry(tr, &ftrace_trace_arrays, list) {	\
+		list_for_each_entry(file, &tr->events, list)
+
+#define do_for_each_event_file_safe(tr, file)			\
+	list_for_each_entry(tr, &ftrace_trace_arrays, list) {	\
+		struct ftrace_event_file *___n;				\
+		list_for_each_entry_safe(file, ___n, &tr->events, list)
+
+#define while_for_each_event_file()		\
+	}
+
 struct list_head *
 trace_get_fields(struct ftrace_event_call *event_call)
 {
@@ -149,15 +162,17 @@ EXPORT_SYMBOL_GPL(trace_event_raw_init);
 int ftrace_event_reg(struct ftrace_event_call *call,
 		     enum trace_reg type, void *data)
 {
+	struct ftrace_event_file *file = data;
+
 	switch (type) {
 	case TRACE_REG_REGISTER:
 		return tracepoint_probe_register(call->name,
 						 call->class->probe,
-						 call);
+						 file);
 	case TRACE_REG_UNREGISTER:
 		tracepoint_probe_unregister(call->name,
 					    call->class->probe,
-					    call);
+					    file);
 		return 0;
 
 #ifdef CONFIG_PERF_EVENTS
@@ -183,54 +198,57 @@ EXPORT_SYMBOL_GPL(ftrace_event_reg);
 
 void trace_event_enable_cmd_record(bool enable)
 {
-	struct ftrace_event_call *call;
+	struct ftrace_event_file *file;
+	struct trace_array *tr;
 
 	mutex_lock(&event_mutex);
-	list_for_each_entry(call, &ftrace_events, list) {
-		if (!(call->flags & TRACE_EVENT_FL_ENABLED))
+	do_for_each_event_file(tr, file) {
+
+		if (!(file->flags & FTRACE_EVENT_FL_ENABLED))
 			continue;
 
 		if (enable) {
 			tracing_start_cmdline_record();
-			call->flags |= TRACE_EVENT_FL_RECORDED_CMD;
+			file->flags |= FTRACE_EVENT_FL_RECORDED_CMD;
 		} else {
 			tracing_stop_cmdline_record();
-			call->flags &= ~TRACE_EVENT_FL_RECORDED_CMD;
+			file->flags &= ~FTRACE_EVENT_FL_RECORDED_CMD;
 		}
-	}
+	} while_for_each_event_file();
 	mutex_unlock(&event_mutex);
 }
 
-static int ftrace_event_enable_disable(struct ftrace_event_call *call,
-					int enable)
+static int ftrace_event_enable_disable(struct ftrace_event_file *file,
+				       int enable)
 {
+	struct ftrace_event_call *call = file->event_call;
 	int ret = 0;
 
 	switch (enable) {
 	case 0:
-		if (call->flags & TRACE_EVENT_FL_ENABLED) {
-			call->flags &= ~TRACE_EVENT_FL_ENABLED;
-			if (call->flags & TRACE_EVENT_FL_RECORDED_CMD) {
+		if (file->flags & FTRACE_EVENT_FL_ENABLED) {
+			file->flags &= ~FTRACE_EVENT_FL_ENABLED;
+			if (file->flags & FTRACE_EVENT_FL_RECORDED_CMD) {
 				tracing_stop_cmdline_record();
-				call->flags &= ~TRACE_EVENT_FL_RECORDED_CMD;
+				file->flags &= ~FTRACE_EVENT_FL_RECORDED_CMD;
 			}
-			call->class->reg(call, TRACE_REG_UNREGISTER, NULL);
+			call->class->reg(call, TRACE_REG_UNREGISTER, file);
 		}
 		break;
 	case 1:
-		if (!(call->flags & TRACE_EVENT_FL_ENABLED)) {
+		if (!(file->flags & FTRACE_EVENT_FL_ENABLED)) {
 			if (trace_flags & TRACE_ITER_RECORD_CMD) {
 				tracing_start_cmdline_record();
-				call->flags |= TRACE_EVENT_FL_RECORDED_CMD;
+				file->flags |= FTRACE_EVENT_FL_RECORDED_CMD;
 			}
-			ret = call->class->reg(call, TRACE_REG_REGISTER, NULL);
+			ret = call->class->reg(call, TRACE_REG_REGISTER, file);
 			if (ret) {
 				tracing_stop_cmdline_record();
 				pr_info("event trace: Could not enable event "
 					"%s\n", call->name);
 				break;
 			}
-			call->flags |= TRACE_EVENT_FL_ENABLED;
+			file->flags |= FTRACE_EVENT_FL_ENABLED;
 		}
 		break;
 	}
@@ -238,13 +256,13 @@ static int ftrace_event_enable_disable(struct ftrace_event_call *call,
 	return ret;
 }
 
-static void ftrace_clear_events(void)
+static void ftrace_clear_events(struct trace_array *tr)
 {
-	struct ftrace_event_call *call;
+	struct ftrace_event_file *file;
 
 	mutex_lock(&event_mutex);
-	list_for_each_entry(call, &ftrace_events, list) {
-		ftrace_event_enable_disable(call, 0);
+	list_for_each_entry(file, &tr->events, list) {
+		ftrace_event_enable_disable(file, 0);
 	}
 	mutex_unlock(&event_mutex);
 }
@@ -257,6 +275,8 @@ static void __put_system(struct event_subsystem *system)
 	if (--system->ref_count)
 		return;
 
+	list_del(&system->list);
+
 	if (filter) {
 		kfree(filter->filter_string);
 		kfree(filter);
@@ -271,24 +291,45 @@ static void __get_system(struct event_subsystem *system)
 	system->ref_count++;
 }
 
-static void put_system(struct event_subsystem *system)
+static void __get_system_dir(struct ftrace_subsystem_dir *dir)
+{
+	WARN_ON_ONCE(dir->ref_count == 0);
+	dir->ref_count++;
+	__get_system(dir->subsystem);
+}
+
+static void __put_system_dir(struct ftrace_subsystem_dir *dir)
+{
+	WARN_ON_ONCE(dir->ref_count == 0);
+	/* If the subsystem is about to be freed, the dir must be too */
+	WARN_ON_ONCE(dir->subsystem->ref_count == 1 && dir->ref_count != 1);
+
+	__put_system(dir->subsystem);
+	if (!--dir->ref_count)
+		kfree(dir);
+}
+
+static void put_system(struct ftrace_subsystem_dir *dir)
 {
 	mutex_lock(&event_mutex);
-	__put_system(system);
+	__put_system_dir(dir);
 	mutex_unlock(&event_mutex);
 }
 
 /*
  * __ftrace_set_clr_event(NULL, NULL, NULL, set) will set/unset all events.
  */
-static int __ftrace_set_clr_event(const char *match, const char *sub,
-				  const char *event, int set)
+static int __ftrace_set_clr_event(struct trace_array *tr, const char *match,
+				  const char *sub, const char *event, int set)
 {
+	struct ftrace_event_file *file;
 	struct ftrace_event_call *call;
 	int ret = -EINVAL;
 
 	mutex_lock(&event_mutex);
-	list_for_each_entry(call, &ftrace_events, list) {
+	list_for_each_entry(file, &tr->events, list) {
+
+		call = file->event_call;
 
 		if (!call->name || !call->class || !call->class->reg)
 			continue;
@@ -307,7 +348,7 @@ static int __ftrace_set_clr_event(const char *match, const char *sub,
 		if (event && strcmp(event, call->name) != 0)
 			continue;
 
-		ftrace_event_enable_disable(call, set);
+		ftrace_event_enable_disable(file, set);
 
 		ret = 0;
 	}
@@ -316,7 +357,7 @@ static int __ftrace_set_clr_event(const char *match, const char *sub,
 	return ret;
 }
 
-static int ftrace_set_clr_event(char *buf, int set)
+static int ftrace_set_clr_event(struct trace_array *tr, char *buf, int set)
 {
 	char *event = NULL, *sub = NULL, *match;
 
@@ -344,7 +385,7 @@ static int ftrace_set_clr_event(char *buf, int set)
 			event = NULL;
 	}
 
-	return __ftrace_set_clr_event(match, sub, event, set);
+	return __ftrace_set_clr_event(tr, match, sub, event, set);
 }
 
 /**
@@ -361,7 +402,9 @@ static int ftrace_set_clr_event(char *buf, int set)
  */
 int trace_set_clr_event(const char *system, const char *event, int set)
 {
-	return __ftrace_set_clr_event(NULL, system, event, set);
+	struct trace_array *tr = top_trace_array();
+
+	return __ftrace_set_clr_event(tr, NULL, system, event, set);
 }
 EXPORT_SYMBOL_GPL(trace_set_clr_event);
 
@@ -373,6 +416,8 @@ ftrace_event_write(struct file *file, const char __user *ubuf,
 		   size_t cnt, loff_t *ppos)
 {
 	struct trace_parser parser;
+	struct seq_file *m = file->private_data;
+	struct trace_array *tr = m->private;
 	ssize_t read, ret;
 
 	if (!cnt)
@@ -395,7 +440,7 @@ ftrace_event_write(struct file *file, const char __user *ubuf,
 
 		parser.buffer[parser.idx] = 0;
 
-		ret = ftrace_set_clr_event(parser.buffer + !set, set);
+		ret = ftrace_set_clr_event(tr, parser.buffer + !set, set);
 		if (ret)
 			goto out_put;
 	}
@@ -411,17 +456,20 @@ ftrace_event_write(struct file *file, const char __user *ubuf,
 static void *
 t_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	struct ftrace_event_call *call = v;
+	struct ftrace_event_file *file = v;
+	struct ftrace_event_call *call;
+	struct trace_array *tr = m->private;
 
 	(*pos)++;
 
-	list_for_each_entry_continue(call, &ftrace_events, list) {
+	list_for_each_entry_continue(file, &tr->events, list) {
+		call = file->event_call;
 		/*
 		 * The ftrace subsystem is for showing formats only.
 		 * They can not be enabled or disabled via the event files.
 		 */
 		if (call->class && call->class->reg)
-			return call;
+			return file;
 	}
 
 	return NULL;
@@ -429,30 +477,32 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 
 static void *t_start(struct seq_file *m, loff_t *pos)
 {
-	struct ftrace_event_call *call;
+	struct ftrace_event_file *file;
+	struct trace_array *tr = m->private;
 	loff_t l;
 
 	mutex_lock(&event_mutex);
 
-	call = list_entry(&ftrace_events, struct ftrace_event_call, list);
+	file = list_entry(&tr->events, struct ftrace_event_file, list);
 	for (l = 0; l <= *pos; ) {
-		call = t_next(m, call, &l);
-		if (!call)
+		file = t_next(m, file, &l);
+		if (!file)
 			break;
 	}
-	return call;
+	return file;
 }
 
 static void *
 s_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	struct ftrace_event_call *call = v;
+	struct ftrace_event_file *file = v;
+	struct trace_array *tr = m->private;
 
 	(*pos)++;
 
-	list_for_each_entry_continue(call, &ftrace_events, list) {
-		if (call->flags & TRACE_EVENT_FL_ENABLED)
-			return call;
+	list_for_each_entry_continue(file, &tr->events, list) {
+		if (file->flags & FTRACE_EVENT_FL_ENABLED)
+			return file;
 	}
 
 	return NULL;
@@ -460,23 +510,25 @@ s_next(struct seq_file *m, void *v, loff_t *pos)
 
 static void *s_start(struct seq_file *m, loff_t *pos)
 {
-	struct ftrace_event_call *call;
+	struct ftrace_event_file *file;
+	struct trace_array *tr = m->private;
 	loff_t l;
 
 	mutex_lock(&event_mutex);
 
-	call = list_entry(&ftrace_events, struct ftrace_event_call, list);
+	file = list_entry(&tr->events, struct ftrace_event_file, list);
 	for (l = 0; l <= *pos; ) {
-		call = s_next(m, call, &l);
-		if (!call)
+		file = s_next(m, file, &l);
+		if (!file)
 			break;
 	}
-	return call;
+	return file;
 }
 
 static int t_show(struct seq_file *m, void *v)
 {
-	struct ftrace_event_call *call = v;
+	struct ftrace_event_file *file = v;
+	struct ftrace_event_call *call = file->event_call;
 
 	if (strcmp(call->class->system, TRACE_SYSTEM) != 0)
 		seq_printf(m, "%s:", call->class->system);
@@ -494,10 +546,10 @@ static ssize_t
 event_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
 		  loff_t *ppos)
 {
-	struct ftrace_event_call *call = filp->private_data;
+	struct ftrace_event_file *file = filp->private_data;
 	char *buf;
 
-	if (call->flags & TRACE_EVENT_FL_ENABLED)
+	if (file->flags & FTRACE_EVENT_FL_ENABLED)
 		buf = "1\n";
 	else
 		buf = "0\n";
@@ -509,10 +561,13 @@ static ssize_t
 event_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 		   loff_t *ppos)
 {
-	struct ftrace_event_call *call = filp->private_data;
+	struct ftrace_event_file *file = filp->private_data;
 	unsigned long val;
 	int ret;
 
+	if (!file)
+		return -EINVAL;
+
 	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
 	if (ret)
 		return ret;
@@ -525,7 +580,7 @@ event_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	case 0:
 	case 1:
 		mutex_lock(&event_mutex);
-		ret = ftrace_event_enable_disable(call, val);
+		ret = ftrace_event_enable_disable(file, val);
 		mutex_unlock(&event_mutex);
 		break;
 
@@ -543,14 +598,18 @@ system_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
 		   loff_t *ppos)
 {
 	const char set_to_char[4] = { '?', '0', '1', 'X' };
-	struct event_subsystem *system = filp->private_data;
+	struct ftrace_subsystem_dir *dir = filp->private_data;
+	struct event_subsystem *system = dir->subsystem;
 	struct ftrace_event_call *call;
+	struct ftrace_event_file *file;
+	struct trace_array *tr = dir->tr;
 	char buf[2];
 	int set = 0;
 	int ret;
 
 	mutex_lock(&event_mutex);
-	list_for_each_entry(call, &ftrace_events, list) {
+	list_for_each_entry(file, &tr->events, list) {
+		call = file->event_call;
 		if (!call->name || !call->class || !call->class->reg)
 			continue;
 
@@ -562,7 +621,7 @@ system_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
 		 * or if all events or cleared, or if we have
 		 * a mixture.
 		 */
-		set |= (1 << !!(call->flags & TRACE_EVENT_FL_ENABLED));
+		set |= (1 << !!(file->flags & FTRACE_EVENT_FL_ENABLED));
 
 		/*
 		 * If we have a mixture, no need to look further.
@@ -584,7 +643,8 @@ static ssize_t
 system_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 		    loff_t *ppos)
 {
-	struct event_subsystem *system = filp->private_data;
+	struct ftrace_subsystem_dir *dir = filp->private_data;
+	struct event_subsystem *system = dir->subsystem;
 	const char *name = NULL;
 	unsigned long val;
 	ssize_t ret;
@@ -607,7 +667,7 @@ system_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	if (system)
 		name = system->name;
 
-	ret = __ftrace_set_clr_event(NULL, name, NULL, val);
+	ret = __ftrace_set_clr_event(dir->tr, NULL, name, NULL, val);
 	if (ret)
 		goto out;
 
@@ -845,43 +905,75 @@ static LIST_HEAD(event_subsystems);
 static int subsystem_open(struct inode *inode, struct file *filp)
 {
 	struct event_subsystem *system = NULL;
+	struct ftrace_subsystem_dir *dir = NULL; /* Initialize for gcc */
+	struct trace_array *tr;
 	int ret;
 
-	if (!inode->i_private)
-		goto skip_search;
-
 	/* Make sure the system still exists */
 	mutex_lock(&event_mutex);
-	list_for_each_entry(system, &event_subsystems, list) {
-		if (system == inode->i_private) {
-			/* Don't open systems with no events */
-			if (!system->nr_events) {
-				system = NULL;
-				break;
+	list_for_each_entry(tr, &ftrace_trace_arrays, list) {
+		list_for_each_entry(dir, &tr->systems, list) {
+			if (dir == inode->i_private) {
+				/* Don't open systems with no events */
+				if (dir->nr_events) {
+					__get_system_dir(dir);
+					system = dir->subsystem;
+				}
+				goto exit_loop;
 			}
-			__get_system(system);
-			break;
 		}
 	}
+ exit_loop:
 	mutex_unlock(&event_mutex);
 
-	if (system != inode->i_private)
+	if (!system)
 		return -ENODEV;
 
- skip_search:
+	/* Some versions of gcc think dir can be uninitialized here */
+	WARN_ON(!dir);
+
 	ret = tracing_open_generic(inode, filp);
-	if (ret < 0 && system)
-		put_system(system);
+	if (ret < 0)
+		put_system(dir);
+
+	return ret;
+}
+
+static int system_tr_open(struct inode *inode, struct file *filp)
+{
+	struct ftrace_subsystem_dir *dir;
+	struct trace_array *tr = inode->i_private;
+	int ret;
+
+	/* Make a temporary dir that has no system but points to tr */
+	dir = kzalloc(sizeof(*dir), GFP_KERNEL);
+	if (!dir)
+		return -ENOMEM;
+
+	dir->tr = tr;
+
+	ret = tracing_open_generic(inode, filp);
+	if (ret < 0)
+		kfree(dir);
+
+	filp->private_data = dir;
 
 	return ret;
 }
 
 static int subsystem_release(struct inode *inode, struct file *file)
 {
-	struct event_subsystem *system = inode->i_private;
+	struct ftrace_subsystem_dir *dir = file->private_data;
 
-	if (system)
-		put_system(system);
+	/*
+	 * If dir->subsystem is NULL, then this is a temporary
+	 * descriptor that was made for a trace_array to enable
+	 * all subsystems.
+	 */
+	if (dir->subsystem)
+		put_system(dir);
+	else
+		kfree(dir);
 
 	return 0;
 }
@@ -890,7 +982,8 @@ static ssize_t
 subsystem_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
 		      loff_t *ppos)
 {
-	struct event_subsystem *system = filp->private_data;
+	struct ftrace_subsystem_dir *dir = filp->private_data;
+	struct event_subsystem *system = dir->subsystem;
 	struct trace_seq *s;
 	int r;
 
@@ -915,7 +1008,7 @@ static ssize_t
 subsystem_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 		       loff_t *ppos)
 {
-	struct event_subsystem *system = filp->private_data;
+	struct ftrace_subsystem_dir *dir = filp->private_data;
 	char *buf;
 	int err;
 
@@ -932,7 +1025,7 @@ subsystem_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	}
 	buf[cnt] = '\0';
 
-	err = apply_subsystem_event_filter(system, buf);
+	err = apply_subsystem_event_filter(dir, buf);
 	free_page((unsigned long) buf);
 	if (err < 0)
 		return err;
@@ -1041,30 +1134,35 @@ static const struct file_operations ftrace_system_enable_fops = {
 	.release = subsystem_release,
 };
 
+static const struct file_operations ftrace_tr_enable_fops = {
+	.open = system_tr_open,
+	.read = system_enable_read,
+	.write = system_enable_write,
+	.llseek = default_llseek,
+	.release = subsystem_release,
+};
+
 static const struct file_operations ftrace_show_header_fops = {
 	.open = tracing_open_generic,
 	.read = show_header,
 	.llseek = default_llseek,
 };
 
-static struct dentry *event_trace_events_dir(void)
+static int
+ftrace_event_open(struct inode *inode, struct file *file,
+		  const struct seq_operations *seq_ops)
 {
-	static struct dentry *d_tracer;
-	static struct dentry *d_events;
-
-	if (d_events)
-		return d_events;
-
-	d_tracer = tracing_init_dentry();
-	if (!d_tracer)
-		return NULL;
+	struct seq_file *m;
+	int ret;
 
-	d_events = debugfs_create_dir("events", d_tracer);
-	if (!d_events)
-		pr_warning("Could not create debugfs "
-			   "'events' directory\n");
+	ret = seq_open(file, seq_ops);
+	if (ret < 0)
+		return ret;
+	m = file->private_data;
+	/* copy tr over to seq ops */
+	m->private = inode->i_private;
 
-	return d_events;
+	return ret;
 }
 
 static int
@@ -1072,117 +1170,169 @@ ftrace_event_avail_open(struct inode *inode, struct file *file)
 {
 	const struct seq_operations *seq_ops = &show_event_seq_ops;
 
-	return seq_open(file, seq_ops);
+	return ftrace_event_open(inode, file, seq_ops);
 }
 
 static int
 ftrace_event_set_open(struct inode *inode, struct file *file)
 {
 	const struct seq_operations *seq_ops = &show_set_event_seq_ops;
+	struct trace_array *tr = inode->i_private;
 
 	if ((file->f_mode & FMODE_WRITE) &&
 	    (file->f_flags & O_TRUNC))
-		ftrace_clear_events();
+		ftrace_clear_events(tr);
 
-	return seq_open(file, seq_ops);
+	return ftrace_event_open(inode, file, seq_ops);
+}
+
+static struct event_subsystem *
+create_new_subsystem(const char *name)
+{
+	struct event_subsystem *system;
+
+	/* need to create new entry */
+	system = kmalloc(sizeof(*system), GFP_KERNEL);
+	if (!system)
+		return NULL;
+
+	system->ref_count = 1;
+	system->name = kstrdup(name, GFP_KERNEL);
+
+	if (!system->name)
+		goto out_free;
+
+	system->filter = NULL;
+
+	system->filter = kzalloc(sizeof(struct event_filter), GFP_KERNEL);
+	if (!system->filter)
+		goto out_free;
+
+	list_add(&system->list, &event_subsystems);
+
+	return system;
+
+ out_free:
+	kfree(system->name);
+	kfree(system);
+	return NULL;
 }
 
 static struct dentry *
-event_subsystem_dir(const char *name, struct dentry *d_events)
+event_subsystem_dir(struct trace_array *tr, const char *name,
+		    struct ftrace_event_file *file, struct dentry *parent)
 {
+	struct ftrace_subsystem_dir *dir;
 	struct event_subsystem *system;
 	struct dentry *entry;
 
 	/* First see if we did not already create this dir */
-	list_for_each_entry(system, &event_subsystems, list) {
+	list_for_each_entry(dir, &tr->systems, list) {
+		system = dir->subsystem;
 		if (strcmp(system->name, name) == 0) {
-			system->nr_events++;
-			return system->entry;
+			dir->nr_events++;
+			file->system = dir;
+			return dir->entry;
 		}
 	}
 
-	/* need to create new entry */
-	system = kmalloc(sizeof(*system), GFP_KERNEL);
-	if (!system) {
-		pr_warning("No memory to create event subsystem %s\n",
-			   name);
-		return d_events;
+	/* Now see if the system itself exists. */
+	list_for_each_entry(system, &event_subsystems, list) {
+		if (strcmp(system->name, name) == 0)
+			break;
 	}
+	/* Reset system variable when not found */
+	if (&system->list == &event_subsystems)
+		system = NULL;
 
-	system->entry = debugfs_create_dir(name, d_events);
-	if (!system->entry) {
-		pr_warning("Could not create event subsystem %s\n",
-			   name);
-		kfree(system);
-		return d_events;
-	}
+	dir = kmalloc(sizeof(*dir), GFP_KERNEL);
+	if (!dir)
+		goto out_fail;
 
-	system->nr_events = 1;
-	system->ref_count = 1;
-	system->name = kstrdup(name, GFP_KERNEL);
-	if (!system->name) {
-		debugfs_remove(system->entry);
-		kfree(system);
-		return d_events;
+	if (!system) {
+		system = create_new_subsystem(name);
+		if (!system)
+			goto out_free;
+	} else
+		__get_system(system);
+
+	dir->entry = debugfs_create_dir(name, parent);
+	if (!dir->entry) {
+		pr_warning("Failed to create system directory %s\n", name);
+		__put_system(system);
+		goto out_free;
 	}
 
-	list_add(&system->list, &event_subsystems);
-
-	system->filter = NULL;
-
-	system->filter = kzalloc(sizeof(struct event_filter), GFP_KERNEL);
-	if (!system->filter) {
-		pr_warning("Could not allocate filter for subsystem "
-			   "'%s'\n", name);
-		return system->entry;
-	}
+	dir->tr = tr;
+	dir->ref_count = 1;
+	dir->nr_events = 1;
+	dir->subsystem = system;
+	file->system = dir;
 
-	entry = debugfs_create_file("filter", 0644, system->entry, system,
+	entry = debugfs_create_file("filter", 0644, dir->entry, dir,
 				    &ftrace_subsystem_filter_fops);
 	if (!entry) {
 		kfree(system->filter);
 		system->filter = NULL;
-		pr_warning("Could not create debugfs "
-			   "'%s/filter' entry\n", name);
+		pr_warning("Could not create debugfs '%s/filter' entry\n", name);
 	}
 
-	trace_create_file("enable", 0644, system->entry, system,
+	trace_create_file("enable", 0644, dir->entry, dir,
 			  &ftrace_system_enable_fops);
 
-	return system->entry;
+	list_add(&dir->list, &tr->systems);
+
+	return dir->entry;
+
+ out_free:
+	kfree(dir);
+ out_fail:
+	/* Only print this message if failed on memory allocation */
+	if (!dir || !system)
+		pr_warning("No memory to create event subsystem %s\n",
+			   name);
+	return NULL;
 }
 
 static int
-event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
+event_create_dir(struct dentry *parent,
+		 struct ftrace_event_file *file,
 		 const struct file_operations *id,
 		 const struct file_operations *enable,
 		 const struct file_operations *filter,
 		 const struct file_operations *format)
 {
+	struct ftrace_event_call *call = file->event_call;
+	struct trace_array *tr = file->tr;
 	struct list_head *head;
+	struct dentry *d_events;
 	int ret;
 
 	/*
 	 * If the trace point header did not define TRACE_SYSTEM
 	 * then the system would be called "TRACE_SYSTEM".
 	 */
-	if (strcmp(call->class->system, TRACE_SYSTEM) != 0)
-		d_events = event_subsystem_dir(call->class->system, d_events);
-
-	call->dir = debugfs_create_dir(call->name, d_events);
-	if (!call->dir) {
-		pr_warning("Could not create debugfs "
-			   "'%s' directory\n", call->name);
+	if (strcmp(call->class->system, TRACE_SYSTEM) != 0) {
+		d_events = event_subsystem_dir(tr, call->class->system, file, parent);
+		if (!d_events)
+			return -ENOMEM;
+	} else
+		d_events = parent;
+
+	file->dir = debugfs_create_dir(call->name, d_events);
+	if (!file->dir) {
+		pr_warning("Could not create debugfs '%s' directory\n",
+			   call->name);
 		return -1;
 	}
 
 	if (call->class->reg && !(call->flags & TRACE_EVENT_FL_IGNORE_ENABLE))
-		trace_create_file("enable", 0644, call->dir, call,
+		trace_create_file("enable", 0644, file->dir, file,
 				  enable);
 
 #ifdef CONFIG_PERF_EVENTS
 	if (call->event.type && call->class->reg)
-		trace_create_file("id", 0444, call->dir, call,
+		trace_create_file("id", 0444, file->dir, call,
 		 		  id);
 #endif
 
@@ -1196,23 +1346,76 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 		if (ret < 0) {
 			pr_warning("Could not initialize trace point"
 				   " events/%s\n", call->name);
-			return ret;
+			return -1;
 		}
 	}
-	trace_create_file("filter", 0644, call->dir, call,
+	trace_create_file("filter", 0644, file->dir, call,
 			  filter);
 
-	trace_create_file("format", 0444, call->dir, call,
+	trace_create_file("format", 0444, file->dir, call,
 			  format);
 
 	return 0;
 }
 
+static void remove_subsystem(struct ftrace_subsystem_dir *dir)
+{
+	if (!dir)
+		return;
+
+	if (!--dir->nr_events) {
+		debugfs_remove_recursive(dir->entry);
+		list_del(&dir->list);
+		__put_system_dir(dir);
+	}
+}
+
+static void remove_event_from_tracers(struct ftrace_event_call *call)
+{
+	struct ftrace_event_file *file;
+	struct trace_array *tr;
+
+	do_for_each_event_file_safe(tr, file) {
+
+		if (file->event_call != call)
+			continue;
+
+		list_del(&file->list);
+		debugfs_remove_recursive(file->dir);
+		remove_subsystem(file->system);
+		kfree(file);
+
+		/*
+		 * The do_for_each_event_file_safe() is
+		 * a double loop. After finding the call for this
+		 * trace_array, we use break to jump to the next
+		 * trace_array.
+		 */
+		break;
+	} while_for_each_event_file();
+}
+
 static void event_remove(struct ftrace_event_call *call)
 {
-	ftrace_event_enable_disable(call, 0);
+	struct trace_array *tr;
+	struct ftrace_event_file *file;
+
+	do_for_each_event_file(tr, file) {
+		if (file->event_call != call)
+			continue;
+		ftrace_event_enable_disable(file, 0);
+		/*
+		 * The do_for_each_event_file() is
+		 * a double loop. After finding the call for this
+		 * trace_array, we use break to jump to the next
+		 * trace_array.
+		 */
+		break;
+	} while_for_each_event_file();
+
 	if (call->event.funcs)
 		__unregister_ftrace_event(&call->event);
+	remove_event_from_tracers(call);
 	list_del(&call->list);
 }
 
@@ -1234,61 +1437,58 @@ static int event_init(struct ftrace_event_call *call)
 }
 
 static int
-__trace_add_event_call(struct ftrace_event_call *call, struct module *mod,
-		       const struct file_operations *id,
-		       const struct file_operations *enable,
-		       const struct file_operations *filter,
-		       const struct file_operations *format)
+__register_event(struct ftrace_event_call *call, struct module *mod)
 {
-	struct dentry *d_events;
 	int ret;
 
 	ret = event_init(call);
 	if (ret < 0)
 		return ret;
 
-	d_events = event_trace_events_dir();
-	if (!d_events)
-		return -ENOENT;
-
-	ret = event_create_dir(call, d_events, id, enable, filter, format);
-	if (!ret)
-		list_add(&call->list, &ftrace_events);
+	list_add(&call->list, &ftrace_events);
 	call->mod = mod;
 
-	return ret;
+	return 0;
 }
 
+/* Add an event to a trace directory */
+static int
+__trace_add_new_event(struct ftrace_event_call *call,
+		      struct trace_array *tr,
+		      const struct file_operations *id,
+		      const struct file_operations *enable,
+		      const struct file_operations *filter,
+		      const struct file_operations *format)
+{
+	struct ftrace_event_file *file;
+
+	file = kzalloc(sizeof(*file), GFP_KERNEL);
+	if (!file)
+		return -ENOMEM;
+
+	file->event_call = call;
+	file->tr = tr;
+	list_add(&file->list, &tr->events);
+
+	return event_create_dir(tr->event_dir, file, id, enable, filter, format);
+}
+
+struct ftrace_module_file_ops;
+static void __add_event_to_tracers(struct ftrace_event_call *call,
+				   struct ftrace_module_file_ops *file_ops);
+
 /* Add an additional event_call dynamically */
 int trace_add_event_call(struct ftrace_event_call *call)
 {
 	int ret;
 	mutex_lock(&event_mutex);
-	ret = __trace_add_event_call(call, NULL, &ftrace_event_id_fops,
-				     &ftrace_enable_fops,
-				     &ftrace_event_filter_fops,
-				     &ftrace_event_format_fops);
-	mutex_unlock(&event_mutex);
-	return ret;
-}
 
-static void remove_subsystem_dir(const char *name)
-{
-	struct event_subsystem *system;
+	ret = __register_event(call, NULL);
+	if (ret >= 0)
+		__add_event_to_tracers(call, NULL);
 
-	if (strcmp(name, TRACE_SYSTEM) == 0)
-		return;
-
-	list_for_each_entry(system, &event_subsystems, list) {
-		if (strcmp(system->name, name) == 0) {
-			if (!--system->nr_events) {
-				debugfs_remove_recursive(system->entry);
-				list_del(&system->list);
-				__put_system(system);
-			}
-			break;
-		}
-	}
+	mutex_unlock(&event_mutex);
+	return ret;
 }
 
 /*
@@ -1299,8 +1499,6 @@ static void __trace_remove_event_call(struct ftrace_event_call *call)
 	event_remove(call);
 	trace_destroy_fields(call);
 	destroy_preds(call);
-	debugfs_remove_recursive(call->dir);
-	remove_subsystem_dir(call->class->system);
 }
 
 /* Remove an event_call */
@@ -1335,6 +1533,17 @@ struct ftrace_module_file_ops {
 	struct file_operations		filter;
 };
 
+static struct ftrace_module_file_ops *find_ftrace_file_ops(struct module *mod)
+{
+	struct ftrace_module_file_ops *file_ops;
+
+	list_for_each_entry(file_ops, &ftrace_module_file_list, list) {
+		if (file_ops->mod == mod)
+			return file_ops;
+	}
+	return NULL;
+}
+
 static struct ftrace_module_file_ops *
 trace_create_file_ops(struct module *mod)
 {
@@ -1386,9 +1595,8 @@ static void trace_module_add_events(struct module *mod)
 		return;
 
 	for_each_event(call, start, end) {
-		__trace_add_event_call(*call, mod,
-				       &file_ops->id, &file_ops->enable,
-				       &file_ops->filter, &file_ops->format);
+		__register_event(*call, mod);
+		__add_event_to_tracers(*call, file_ops);
 	}
 }
 
@@ -1444,6 +1652,10 @@ static int trace_module_notify(struct notifier_block *self,
 	return 0;
 }
 #else
+static struct ftrace_module_file_ops *find_ftrace_file_ops(struct module *mod)
+{
+	return NULL;
+}
 static int trace_module_notify(struct notifier_block *self,
 			       unsigned long val, void *data)
 {
@@ -1451,6 +1663,72 @@ static int trace_module_notify(struct notifier_block *self,
 }
 #endif /* CONFIG_MODULES */
 
+/* Create a new event directory structure for a trace directory. */
+static void
+__trace_add_event_dirs(struct trace_array *tr)
+{
+	struct ftrace_module_file_ops *file_ops = NULL;
+	struct ftrace_event_call *call;
+	int ret;
+
+	list_for_each_entry(call, &ftrace_events, list) {
+		if (call->mod) {
+			/*
+			 * Directories for events by modules need to
+			 * keep module ref counts when opened (as we don't
+			 * want the module to disappear when reading one
+			 * of these files). The file_ops keep account of
+			 * the module ref count.
+			 *
+			 * As event_calls are added in groups by module,
+			 * when we find one file_ops, we don't need to search for
+			 * each call in that module, as the rest should be the
+			 * same. Only search for a new one if the last one did
+			 * not match.
+			 */
+			if (!file_ops || call->mod != file_ops->mod)
+				file_ops = find_ftrace_file_ops(call->mod);
+			if (!file_ops)
+				continue; /* Warn? */
+			ret = __trace_add_new_event(call, tr,
+					&file_ops->id, &file_ops->enable,
+					&file_ops->filter, &file_ops->format);
+			if (ret < 0)
+				pr_warning("Could not create directory for event %s\n",
+					   call->name);
+			continue;
+		}
+		ret = __trace_add_new_event(call, tr,
+					    &ftrace_event_id_fops,
+					    &ftrace_enable_fops,
+					    &ftrace_event_filter_fops,
+					    &ftrace_event_format_fops);
+		if (ret < 0)
+			pr_warning("Could not create directory for event %s\n",
+				   call->name);
+	}
+}
+
+static void
+__add_event_to_tracers(struct ftrace_event_call *call,
+		       struct ftrace_module_file_ops *file_ops)
+{
+	struct trace_array *tr;
+
+	list_for_each_entry(tr, &ftrace_trace_arrays, list) {
+		if (file_ops)
+			__trace_add_new_event(call, tr,
+					      &file_ops->id, &file_ops->enable,
+					      &file_ops->filter, &file_ops->format);
+		else
+			__trace_add_new_event(call, tr,
+					      &ftrace_event_id_fops,
+					      &ftrace_enable_fops,
+					      &ftrace_event_filter_fops,
+					      &ftrace_event_format_fops);
+	}
+}
+
 static struct notifier_block trace_module_nb = {
 	.notifier_call = trace_module_notify,
 	.priority = 0,
@@ -1471,8 +1749,43 @@ static __init int setup_trace_event(char *str)
 }
 __setup("trace_event=", setup_trace_event);
 
+int event_trace_add_tracer(struct dentry *parent, struct trace_array *tr)
+{
+	struct dentry *d_events;
+	struct dentry *entry;
+
+	entry = debugfs_create_file("set_event", 0644, parent,
+				    tr, &ftrace_set_event_fops);
+	if (!entry) {
+		pr_warning("Could not create debugfs 'set_event' entry\n");
+		return -ENOMEM;
+	}
+
+	d_events = debugfs_create_dir("events", parent);
+	if (!d_events)
+		pr_warning("Could not create debugfs 'events' directory\n");
+
+	/* ring buffer internal formats */
+	trace_create_file("header_page", 0444, d_events,
+			  ring_buffer_print_page_header,
+			  &ftrace_show_header_fops);
+
+	trace_create_file("header_event", 0444, d_events,
+			  ring_buffer_print_entry_header,
+			  &ftrace_show_header_fops);
+
+	trace_create_file("enable", 0644, d_events,
+			  tr, &ftrace_tr_enable_fops);
+
+	tr->event_dir = d_events;
+	__trace_add_event_dirs(tr);
+
+	return 0;
+}
+
 static __init int event_trace_enable(void)
 {
+	struct trace_array *tr = top_trace_array();
 	struct ftrace_event_call **iter, *call;
 	char *buf = bootup_event_buf;
 	char *token;
@@ -1494,7 +1807,7 @@ static __init int event_trace_enable(void)
 		if (!*token)
 			continue;
 
-		ret = ftrace_set_clr_event(token, 1);
+		ret = ftrace_set_clr_event(tr, token, 1);
 		if (ret)
 			pr_warn("Failed to enable trace event: %s\n", token);
 	}
@@ -1506,61 +1819,29 @@ static __init int event_trace_enable(void)
 
 static __init int event_trace_init(void)
 {
-	struct ftrace_event_call *call;
+	struct trace_array *tr;
 	struct dentry *d_tracer;
 	struct dentry *entry;
-	struct dentry *d_events;
 	int ret;
 
+	tr = top_trace_array();
+
 	d_tracer = tracing_init_dentry();
 	if (!d_tracer)
 		return 0;
 
 	entry = debugfs_create_file("available_events", 0444, d_tracer,
-				    NULL, &ftrace_avail_fops);
+				    tr, &ftrace_avail_fops);
 	if (!entry)
 		pr_warning("Could not create debugfs "
 			   "'available_events' entry\n");
 
-	entry = debugfs_create_file("set_event", 0644, d_tracer,
-				    NULL, &ftrace_set_event_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'set_event' entry\n");
-
-	d_events = event_trace_events_dir();
-	if (!d_events)
-		return 0;
-
-	/* ring buffer internal formats */
-	trace_create_file("header_page", 0444, d_events,
-			  ring_buffer_print_page_header,
-			  &ftrace_show_header_fops);
-
-	trace_create_file("header_event", 0444, d_events,
-			  ring_buffer_print_entry_header,
-			  &ftrace_show_header_fops);
-
-	trace_create_file("enable", 0644, d_events,
-			  NULL, &ftrace_system_enable_fops);
-
 	if (trace_define_common_fields())
 		pr_warning("tracing: Failed to allocate common fields");
 
-	/*
-	 * Early initialization already enabled ftrace event.
-	 * Now it's only necessary to create the event directory.
-	 */
-	list_for_each_entry(call, &ftrace_events, list) {
-
-		ret = event_create_dir(call, d_events,
-				       &ftrace_event_id_fops,
-				       &ftrace_enable_fops,
-				       &ftrace_event_filter_fops,
-				       &ftrace_event_format_fops);
-		if (ret < 0)
-			event_remove(call);
-	}
+	ret = event_trace_add_tracer(d_tracer, tr);
+	if (ret)
+		return ret;
 
 	ret = register_module_notifier(&trace_module_nb);
 	if (ret)
@@ -1627,13 +1908,20 @@ static __init void event_test_stuff(void)
  */
 static __init void event_trace_self_tests(void)
 {
+	struct ftrace_subsystem_dir *dir;
+	struct ftrace_event_file *file;
 	struct ftrace_event_call *call;
 	struct event_subsystem *system;
+	struct trace_array *tr;
 	int ret;
 
+	tr = top_trace_array();
+
 	pr_info("Running tests on trace events:\n");
 
-	list_for_each_entry(call, &ftrace_events, list) {
+	list_for_each_entry(file, &tr->events, list) {
+
+		call = file->event_call;
 
 		/* Only test those that have a probe */
 		if (!call->class || !call->class->probe)
@@ -1657,15 +1945,15 @@ static __init void event_trace_self_tests(void)
 		 * If an event is already enabled, someone is using
 		 * it and the self test should not be on.
 		 */
-		if (call->flags & TRACE_EVENT_FL_ENABLED) {
+		if (file->flags & FTRACE_EVENT_FL_ENABLED) {
 			pr_warning("Enabled event during self test!\n");
 			WARN_ON_ONCE(1);
 			continue;
 		}
 
-		ftrace_event_enable_disable(call, 1);
+		ftrace_event_enable_disable(file, 1);
 		event_test_stuff();
-		ftrace_event_enable_disable(call, 0);
+		ftrace_event_enable_disable(file, 0);
 
 		pr_cont("OK\n");
 	}
@@ -1674,7 +1962,9 @@ static __init void event_trace_self_tests(void)
 
 	pr_info("Running tests on trace event systems:\n");
 
-	list_for_each_entry(system, &event_subsystems, list) {
+	list_for_each_entry(dir, &tr->systems, list) {
+
+		system = dir->subsystem;
 
 		/* the ftrace system is special, skip it */
 		if (strcmp(system->name, "ftrace") == 0)
@@ -1682,7 +1972,7 @@ static __init void event_trace_self_tests(void)
 
 		pr_info("Testing event system %s: ", system->name);
 
-		ret = __ftrace_set_clr_event(NULL, system->name, NULL, 1);
+		ret = __ftrace_set_clr_event(tr, NULL, system->name, NULL, 1);
 		if (WARN_ON_ONCE(ret)) {
 			pr_warning("error enabling system %s\n",
 				   system->name);
@@ -1691,7 +1981,7 @@ static __init void event_trace_self_tests(void)
 
 		event_test_stuff();
 
-		ret = __ftrace_set_clr_event(NULL, system->name, NULL, 0);
+		ret = __ftrace_set_clr_event(tr, NULL, system->name, NULL, 0);
 		if (WARN_ON_ONCE(ret)) {
 			pr_warning("error disabling system %s\n",
 				   system->name);
@@ -1706,7 +1996,7 @@ static __init void event_trace_self_tests(void)
 	pr_info("Running tests on all trace events:\n");
 	pr_info("Testing all events: ");
 
-	ret = __ftrace_set_clr_event(NULL, NULL, NULL, 1);
+	ret = __ftrace_set_clr_event(tr, NULL, NULL, NULL, 1);
 	if (WARN_ON_ONCE(ret)) {
 		pr_warning("error enabling all events\n");
 		return;
@@ -1715,7 +2005,7 @@ static __init void event_trace_self_tests(void)
 	event_test_stuff();
 
 	/* reset sysname */
-	ret = __ftrace_set_clr_event(NULL, NULL, NULL, 0);
+	ret = __ftrace_set_clr_event(tr, NULL, NULL, NULL, 0);
 	if (WARN_ON_ONCE(ret)) {
 		pr_warning("error disabling all events\n");
 		return;
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index e5b0ca8..2a22a17 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1907,16 +1907,17 @@ out_unlock:
 	return err;
 }
 
-int apply_subsystem_event_filter(struct event_subsystem *system,
+int apply_subsystem_event_filter(struct ftrace_subsystem_dir *dir,
 				 char *filter_string)
 {
+	struct event_subsystem *system = dir->subsystem;
 	struct event_filter *filter;
 	int err = 0;
 
 	mutex_lock(&event_mutex);
 
 	/* Make sure the system still has events */
-	if (!system->nr_events) {
+	if (!dir->nr_events) {
 		err = -ENODEV;
 		goto out_unlock;
 	}
-- 
1.7.10.4


