Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab3KFOyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 09:54:16 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:32083 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932506Ab3KFOxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 09:53:00 -0500
Message-Id: <20131106145257.926843450@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 06 Nov 2013 09:50:47 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [for-next][PATCH 6/8] tracing: Update event filters for multibuffer
References: <20131106145041.904349372@goodmis.org>
Content-Disposition: inline; filename=0012-tracing-Update-event-filters-for-multibuffer.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tom.zanussi@linux.intel.com>

The trace event filters are still tied to event calls rather than
event files, which means you don't get what you'd expect when using
filters in the multibuffer case:

Before:

  # echo 'bytes_alloc > 8192' > /sys/kernel/debug/tracing/events/kmem/kmalloc/filter
  # cat /sys/kernel/debug/tracing/events/kmem/kmalloc/filter
  bytes_alloc > 8192
  # mkdir /sys/kernel/debug/tracing/instances/test1
  # echo 'bytes_alloc > 2048' > /sys/kernel/debug/tracing/instances/test1/events/kmem/kmalloc/filter
  # cat /sys/kernel/debug/tracing/events/kmem/kmalloc/filter
  bytes_alloc > 2048
  # cat /sys/kernel/debug/tracing/instances/test1/events/kmem/kmalloc/filter
  bytes_alloc > 2048

Setting the filter in tracing/instances/test1/events shouldn't affect
the same event in tracing/events as it does above.

After:

  # echo 'bytes_alloc > 8192' > /sys/kernel/debug/tracing/events/kmem/kmalloc/filter
  # cat /sys/kernel/debug/tracing/events/kmem/kmalloc/filter
  bytes_alloc > 8192
  # mkdir /sys/kernel/debug/tracing/instances/test1
  # echo 'bytes_alloc > 2048' > /sys/kernel/debug/tracing/instances/test1/events/kmem/kmalloc/filter
  # cat /sys/kernel/debug/tracing/events/kmem/kmalloc/filter
  bytes_alloc > 8192
  # cat /sys/kernel/debug/tracing/instances/test1/events/kmem/kmalloc/filter
  bytes_alloc > 2048

We'd like to just move the filter directly from ftrace_event_call to
ftrace_event_file, but there are a couple cases that don't yet have
multibuffer support and therefore have to continue using the current
event_call-based filters.  For those cases, a new USE_CALL_FILTER bit
is added to the event_call flags, whose main purpose is to keep the
old behavior for those cases until they can be updated with
multibuffer support; at that point, the USE_CALL_FILTER flag (and the
new associated call_filter_check_discard() function) can go away.

The multibuffer support also made filter_current_check_discard()
redundant, so this change removes that function as well and replaces
it with filter_check_discard() (or call_filter_check_discard() as
appropriate).

Link: http://lkml.kernel.org/r/f16e9ce4270c62f46b2e966119225e1c3cca7e60.1382620672.git.tom.zanussi@linux.intel.com

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h         |  25 +++-
 include/linux/syscalls.h             |   4 +-
 include/trace/ftrace.h               |   7 +-
 kernel/trace/trace.c                 |  40 +++++--
 kernel/trace/trace.h                 |  18 +--
 kernel/trace/trace_branch.c          |   2 +-
 kernel/trace/trace_events.c          |  23 ++--
 kernel/trace/trace_events_filter.c   | 218 ++++++++++++++++++++++++++++-------
 kernel/trace/trace_export.c          |   2 +-
 kernel/trace/trace_functions_graph.c |   4 +-
 kernel/trace/trace_kprobe.c          |   4 +-
 kernel/trace/trace_mmiotrace.c       |   4 +-
 kernel/trace/trace_sched_switch.c    |   4 +-
 kernel/trace/trace_syscalls.c        |   8 +-
 kernel/trace/trace_uprobe.c          |   3 +-
 15 files changed, 264 insertions(+), 102 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 5eaa746..9abbe63 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -202,6 +202,7 @@ enum {
 	TRACE_EVENT_FL_NO_SET_FILTER_BIT,
 	TRACE_EVENT_FL_IGNORE_ENABLE_BIT,
 	TRACE_EVENT_FL_WAS_ENABLED_BIT,
+	TRACE_EVENT_FL_USE_CALL_FILTER_BIT,
 };
 
 /*
@@ -213,6 +214,7 @@ enum {
  *  WAS_ENABLED   - Set and stays set when an event was ever enabled
  *                    (used for module unloading, if a module event is enabled,
  *                     it is best to clear the buffers that used it).
+ *  USE_CALL_FILTER - For ftrace internal events, don't use file filter
  */
 enum {
 	TRACE_EVENT_FL_FILTERED		= (1 << TRACE_EVENT_FL_FILTERED_BIT),
@@ -220,6 +222,7 @@ enum {
 	TRACE_EVENT_FL_NO_SET_FILTER	= (1 << TRACE_EVENT_FL_NO_SET_FILTER_BIT),
 	TRACE_EVENT_FL_IGNORE_ENABLE	= (1 << TRACE_EVENT_FL_IGNORE_ENABLE_BIT),
 	TRACE_EVENT_FL_WAS_ENABLED	= (1 << TRACE_EVENT_FL_WAS_ENABLED_BIT),
+	TRACE_EVENT_FL_USE_CALL_FILTER	= (1 << TRACE_EVENT_FL_USE_CALL_FILTER_BIT),
 };
 
 struct ftrace_event_call {
@@ -238,6 +241,7 @@ struct ftrace_event_call {
 	 *   bit 2:		failed to apply filter
 	 *   bit 3:		ftrace internal event (do not enable)
 	 *   bit 4:		Event was enabled by module
+	 *   bit 5:		use call filter rather than file filter
 	 */
 	int			flags; /* static flags of different events */
 
@@ -253,6 +257,8 @@ struct ftrace_subsystem_dir;
 enum {
 	FTRACE_EVENT_FL_ENABLED_BIT,
 	FTRACE_EVENT_FL_RECORDED_CMD_BIT,
+	FTRACE_EVENT_FL_FILTERED_BIT,
+	FTRACE_EVENT_FL_NO_SET_FILTER_BIT,
 	FTRACE_EVENT_FL_SOFT_MODE_BIT,
 	FTRACE_EVENT_FL_SOFT_DISABLED_BIT,
 };
@@ -261,6 +267,8 @@ enum {
  * Ftrace event file flags:
  *  ENABLED	  - The event is enabled
  *  RECORDED_CMD  - The comms should be recorded at sched_switch
+ *  FILTERED	  - The event has a filter attached
+ *  NO_SET_FILTER - Set when filter has error and is to be ignored
  *  SOFT_MODE     - The event is enabled/disabled by SOFT_DISABLED
  *  SOFT_DISABLED - When set, do not trace the event (even though its
  *                   tracepoint may be enabled)
@@ -268,6 +276,8 @@ enum {
 enum {
 	FTRACE_EVENT_FL_ENABLED		= (1 << FTRACE_EVENT_FL_ENABLED_BIT),
 	FTRACE_EVENT_FL_RECORDED_CMD	= (1 << FTRACE_EVENT_FL_RECORDED_CMD_BIT),
+	FTRACE_EVENT_FL_FILTERED	= (1 << FTRACE_EVENT_FL_FILTERED_BIT),
+	FTRACE_EVENT_FL_NO_SET_FILTER	= (1 << FTRACE_EVENT_FL_NO_SET_FILTER_BIT),
 	FTRACE_EVENT_FL_SOFT_MODE	= (1 << FTRACE_EVENT_FL_SOFT_MODE_BIT),
 	FTRACE_EVENT_FL_SOFT_DISABLED	= (1 << FTRACE_EVENT_FL_SOFT_DISABLED_BIT),
 };
@@ -275,6 +285,7 @@ enum {
 struct ftrace_event_file {
 	struct list_head		list;
 	struct ftrace_event_call	*event_call;
+	struct event_filter		*filter;
 	struct dentry			*dir;
 	struct trace_array		*tr;
 	struct ftrace_subsystem_dir	*system;
@@ -310,12 +321,16 @@ struct ftrace_event_file {
 
 #define MAX_FILTER_STR_VAL	256	/* Should handle KSYM_SYMBOL_LEN */
 
-extern void destroy_preds(struct ftrace_event_call *call);
+extern void destroy_preds(struct ftrace_event_file *file);
+extern void destroy_call_preds(struct ftrace_event_call *call);
 extern int filter_match_preds(struct event_filter *filter, void *rec);
-extern int filter_current_check_discard(struct ring_buffer *buffer,
-					struct ftrace_event_call *call,
-					void *rec,
-					struct ring_buffer_event *event);
+
+extern int filter_check_discard(struct ftrace_event_file *file, void *rec,
+				struct ring_buffer *buffer,
+				struct ring_buffer_event *event);
+extern int call_filter_check_discard(struct ftrace_event_call *call, void *rec,
+				     struct ring_buffer *buffer,
+				     struct ring_buffer_event *event);
 
 enum {
 	FILTER_OTHER = 0,
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 7fac04e..10bafa9 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -120,7 +120,7 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 		.class			= &event_class_syscall_enter,	\
 		.event.funcs            = &enter_syscall_print_funcs,	\
 		.data			= (void *)&__syscall_meta_##sname,\
-		.flags			= TRACE_EVENT_FL_CAP_ANY,	\
+		.flags			= TRACE_EVENT_FL_CAP_ANY | TRACE_EVENT_FL_USE_CALL_FILTER,\
 	};								\
 	static struct ftrace_event_call __used				\
 	  __attribute__((section("_ftrace_events")))			\
@@ -134,7 +134,7 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 		.class			= &event_class_syscall_exit,	\
 		.event.funcs		= &exit_syscall_print_funcs,	\
 		.data			= (void *)&__syscall_meta_##sname,\
-		.flags			= TRACE_EVENT_FL_CAP_ANY,	\
+		.flags			= TRACE_EVENT_FL_CAP_ANY | TRACE_EVENT_FL_USE_CALL_FILTER,\
 	};								\
 	static struct ftrace_event_call __used				\
 	  __attribute__((section("_ftrace_events")))			\
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 5c7ab17..52594b2 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -437,9 +437,8 @@ static inline notrace int ftrace_get_offsets_##call(			\
  *	{ <assign>; }  <-- Here we assign the entries by the __field and
  *			   __array macros.
  *
- *	if (!filter_current_check_discard(buffer, event_call, entry, event))
- *		trace_nowake_buffer_unlock_commit(buffer,
- *						   event, irq_flags, pc);
+ *	if (!filter_check_discard(ftrace_file, entry, buffer, event))
+ *		trace_buffer_unlock_commit(buffer, event, irq_flags, pc);
  * }
  *
  * static struct trace_event ftrace_event_type_<call> = {
@@ -553,7 +552,7 @@ ftrace_raw_event_##call(void *__data, proto)				\
 									\
 	{ assign; }							\
 									\
-	if (!filter_current_check_discard(buffer, event_call, entry, event)) \
+	if (!filter_check_discard(ftrace_file, entry, buffer, event))	\
 		trace_buffer_unlock_commit(buffer, event, irq_flags, pc); \
 }
 /*
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 063a92b..489da8b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -235,13 +235,33 @@ void trace_array_put(struct trace_array *this_tr)
 	mutex_unlock(&trace_types_lock);
 }
 
-int filter_current_check_discard(struct ring_buffer *buffer,
-				 struct ftrace_event_call *call, void *rec,
-				 struct ring_buffer_event *event)
+int filter_check_discard(struct ftrace_event_file *file, void *rec,
+			 struct ring_buffer *buffer,
+			 struct ring_buffer_event *event)
 {
-	return filter_check_discard(call, rec, buffer, event);
+	if (unlikely(file->flags & FTRACE_EVENT_FL_FILTERED) &&
+	    !filter_match_preds(file->filter, rec)) {
+		ring_buffer_discard_commit(buffer, event);
+		return 1;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(filter_check_discard);
+
+int call_filter_check_discard(struct ftrace_event_call *call, void *rec,
+			      struct ring_buffer *buffer,
+			      struct ring_buffer_event *event)
+{
+	if (unlikely(call->flags & TRACE_EVENT_FL_FILTERED) &&
+	    !filter_match_preds(call->filter, rec)) {
+		ring_buffer_discard_commit(buffer, event);
+		return 1;
+	}
+
+	return 0;
 }
-EXPORT_SYMBOL_GPL(filter_current_check_discard);
+EXPORT_SYMBOL_GPL(call_filter_check_discard);
 
 cycle_t buffer_ftrace_now(struct trace_buffer *buf, int cpu)
 {
@@ -1633,7 +1653,7 @@ trace_function(struct trace_array *tr,
 	entry->ip			= ip;
 	entry->parent_ip		= parent_ip;
 
-	if (!filter_check_discard(call, entry, buffer, event))
+	if (!call_filter_check_discard(call, entry, buffer, event))
 		__buffer_unlock_commit(buffer, event);
 }
 
@@ -1717,7 +1737,7 @@ static void __ftrace_trace_stack(struct ring_buffer *buffer,
 
 	entry->size = trace.nr_entries;
 
-	if (!filter_check_discard(call, entry, buffer, event))
+	if (!call_filter_check_discard(call, entry, buffer, event))
 		__buffer_unlock_commit(buffer, event);
 
  out:
@@ -1819,7 +1839,7 @@ ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags, int pc)
 	trace.entries		= entry->caller;
 
 	save_stack_trace_user(&trace);
-	if (!filter_check_discard(call, entry, buffer, event))
+	if (!call_filter_check_discard(call, entry, buffer, event))
 		__buffer_unlock_commit(buffer, event);
 
  out_drop_count:
@@ -2011,7 +2031,7 @@ int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
 	entry->fmt			= fmt;
 
 	memcpy(entry->buf, tbuffer, sizeof(u32) * len);
-	if (!filter_check_discard(call, entry, buffer, event)) {
+	if (!call_filter_check_discard(call, entry, buffer, event)) {
 		__buffer_unlock_commit(buffer, event);
 		ftrace_trace_stack(buffer, flags, 6, pc);
 	}
@@ -2066,7 +2086,7 @@ __trace_array_vprintk(struct ring_buffer *buffer,
 
 	memcpy(&entry->buf, tbuffer, len);
 	entry->buf[len] = '\0';
-	if (!filter_check_discard(call, entry, buffer, event)) {
+	if (!call_filter_check_discard(call, entry, buffer, event)) {
 		__buffer_unlock_commit(buffer, event);
 		ftrace_trace_stack(buffer, flags, 6, pc);
 	}
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index d1cf515..12d1a61 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1007,9 +1007,9 @@ struct filter_pred {
 
 extern enum regex_type
 filter_parse_regex(char *buff, int len, char **search, int *not);
-extern void print_event_filter(struct ftrace_event_call *call,
+extern void print_event_filter(struct ftrace_event_file *file,
 			       struct trace_seq *s);
-extern int apply_event_filter(struct ftrace_event_call *call,
+extern int apply_event_filter(struct ftrace_event_file *file,
 			      char *filter_string);
 extern int apply_subsystem_event_filter(struct ftrace_subsystem_dir *dir,
 					char *filter_string);
@@ -1020,20 +1020,6 @@ extern int filter_assign_type(const char *type);
 struct ftrace_event_field *
 trace_find_event_field(struct ftrace_event_call *call, char *name);
 
-static inline int
-filter_check_discard(struct ftrace_event_call *call, void *rec,
-		     struct ring_buffer *buffer,
-		     struct ring_buffer_event *event)
-{
-	if (unlikely(call->flags & TRACE_EVENT_FL_FILTERED) &&
-	    !filter_match_preds(call->filter, rec)) {
-		ring_buffer_discard_commit(buffer, event);
-		return 1;
-	}
-
-	return 0;
-}
-
 extern void trace_event_enable_cmd_record(bool enable);
 extern int event_trace_add_tracer(struct dentry *parent, struct trace_array *tr);
 extern int event_trace_del_tracer(struct trace_array *tr);
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index d594da0..697fb9b 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -78,7 +78,7 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
 	entry->line = f->line;
 	entry->correct = val == expect;
 
-	if (!filter_check_discard(call, entry, buffer, event))
+	if (!call_filter_check_discard(call, entry, buffer, event))
 		__buffer_unlock_commit(buffer, event);
 
  out:
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 368a4d5..043f833 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -989,7 +989,7 @@ static ssize_t
 event_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
 		  loff_t *ppos)
 {
-	struct ftrace_event_call *call;
+	struct ftrace_event_file *file;
 	struct trace_seq *s;
 	int r = -ENODEV;
 
@@ -1004,12 +1004,12 @@ event_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
 	trace_seq_init(s);
 
 	mutex_lock(&event_mutex);
-	call = event_file_data(filp);
-	if (call)
-		print_event_filter(call, s);
+	file = event_file_data(filp);
+	if (file)
+		print_event_filter(file, s);
 	mutex_unlock(&event_mutex);
 
-	if (call)
+	if (file)
 		r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
 
 	kfree(s);
@@ -1021,7 +1021,7 @@ static ssize_t
 event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 		   loff_t *ppos)
 {
-	struct ftrace_event_call *call;
+	struct ftrace_event_file *file;
 	char *buf;
 	int err = -ENODEV;
 
@@ -1039,9 +1039,9 @@ event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	buf[cnt] = '\0';
 
 	mutex_lock(&event_mutex);
-	call = event_file_data(filp);
-	if (call)
-		err = apply_event_filter(call, buf);
+	file = event_file_data(filp);
+	if (file)
+		err = apply_event_filter(file, buf);
 	mutex_unlock(&event_mutex);
 
 	free_page((unsigned long) buf);
@@ -1539,7 +1539,7 @@ event_create_dir(struct dentry *parent, struct ftrace_event_file *file)
 			return -1;
 		}
 	}
-	trace_create_file("filter", 0644, file->dir, call,
+	trace_create_file("filter", 0644, file->dir, file,
 			  &ftrace_event_filter_fops);
 
 	trace_create_file("format", 0444, file->dir, call,
@@ -1577,6 +1577,7 @@ static void event_remove(struct ftrace_event_call *call)
 		if (file->event_call != call)
 			continue;
 		ftrace_event_enable_disable(file, 0);
+		destroy_preds(file);
 		/*
 		 * The do_for_each_event_file() is
 		 * a double loop. After finding the call for this
@@ -1700,7 +1701,7 @@ static void __trace_remove_event_call(struct ftrace_event_call *call)
 {
 	event_remove(call);
 	trace_destroy_fields(call);
-	destroy_preds(call);
+	destroy_call_preds(call);
 }
 
 static int probe_remove_event_call(struct ftrace_event_call *call)
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 97daa8c..2468f56 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -637,10 +637,18 @@ static void append_filter_err(struct filter_parse_state *ps,
 	free_page((unsigned long) buf);
 }
 
+static inline struct event_filter *event_filter(struct ftrace_event_file *file)
+{
+	if (file->event_call->flags & TRACE_EVENT_FL_USE_CALL_FILTER)
+		return file->event_call->filter;
+	else
+		return file->filter;
+}
+
 /* caller must hold event_mutex */
-void print_event_filter(struct ftrace_event_call *call, struct trace_seq *s)
+void print_event_filter(struct ftrace_event_file *file, struct trace_seq *s)
 {
-	struct event_filter *filter = call->filter;
+	struct event_filter *filter = event_filter(file);
 
 	if (filter && filter->filter_string)
 		trace_seq_printf(s, "%s\n", filter->filter_string);
@@ -766,11 +774,21 @@ static void __free_preds(struct event_filter *filter)
 	filter->n_preds = 0;
 }
 
-static void filter_disable(struct ftrace_event_call *call)
+static void call_filter_disable(struct ftrace_event_call *call)
 {
 	call->flags &= ~TRACE_EVENT_FL_FILTERED;
 }
 
+static void filter_disable(struct ftrace_event_file *file)
+{
+	struct ftrace_event_call *call = file->event_call;
+
+	if (call->flags & TRACE_EVENT_FL_USE_CALL_FILTER)
+		call_filter_disable(call);
+	else
+		file->flags &= ~FTRACE_EVENT_FL_FILTERED;
+}
+
 static void __free_filter(struct event_filter *filter)
 {
 	if (!filter)
@@ -781,16 +799,30 @@ static void __free_filter(struct event_filter *filter)
 	kfree(filter);
 }
 
+void destroy_call_preds(struct ftrace_event_call *call)
+{
+	__free_filter(call->filter);
+	call->filter = NULL;
+}
+
+static void destroy_file_preds(struct ftrace_event_file *file)
+{
+	__free_filter(file->filter);
+	file->filter = NULL;
+}
+
 /*
- * Called when destroying the ftrace_event_call.
- * The call is being freed, so we do not need to worry about
- * the call being currently used. This is for module code removing
+ * Called when destroying the ftrace_event_file.
+ * The file is being freed, so we do not need to worry about
+ * the file being currently used. This is for module code removing
  * the tracepoints from within it.
  */
-void destroy_preds(struct ftrace_event_call *call)
+void destroy_preds(struct ftrace_event_file *file)
 {
-	__free_filter(call->filter);
-	call->filter = NULL;
+	if (file->event_call->flags & TRACE_EVENT_FL_USE_CALL_FILTER)
+		destroy_call_preds(file->event_call);
+	else
+		destroy_file_preds(file);
 }
 
 static struct event_filter *__alloc_filter(void)
@@ -825,28 +857,56 @@ static int __alloc_preds(struct event_filter *filter, int n_preds)
 	return 0;
 }
 
-static void filter_free_subsystem_preds(struct event_subsystem *system)
+static inline void __remove_filter(struct ftrace_event_file *file)
 {
+	struct ftrace_event_call *call = file->event_call;
+
+	filter_disable(file);
+	if (call->flags & TRACE_EVENT_FL_USE_CALL_FILTER)
+		remove_filter_string(call->filter);
+	else
+		remove_filter_string(file->filter);
+}
+
+static void filter_free_subsystem_preds(struct event_subsystem *system,
+					struct trace_array *tr)
+{
+	struct ftrace_event_file *file;
 	struct ftrace_event_call *call;
 
-	list_for_each_entry(call, &ftrace_events, list) {
+	list_for_each_entry(file, &tr->events, list) {
+		call = file->event_call;
 		if (strcmp(call->class->system, system->name) != 0)
 			continue;
 
-		filter_disable(call);
-		remove_filter_string(call->filter);
+		__remove_filter(file);
 	}
 }
 
-static void filter_free_subsystem_filters(struct event_subsystem *system)
+static inline void __free_subsystem_filter(struct ftrace_event_file *file)
 {
+	struct ftrace_event_call *call = file->event_call;
+
+	if (call->flags & TRACE_EVENT_FL_USE_CALL_FILTER) {
+		__free_filter(call->filter);
+		call->filter = NULL;
+	} else {
+		__free_filter(file->filter);
+		file->filter = NULL;
+	}
+}
+
+static void filter_free_subsystem_filters(struct event_subsystem *system,
+					  struct trace_array *tr)
+{
+	struct ftrace_event_file *file;
 	struct ftrace_event_call *call;
 
-	list_for_each_entry(call, &ftrace_events, list) {
+	list_for_each_entry(file, &tr->events, list) {
+		call = file->event_call;
 		if (strcmp(call->class->system, system->name) != 0)
 			continue;
-		__free_filter(call->filter);
-		call->filter = NULL;
+		__free_subsystem_filter(file);
 	}
 }
 
@@ -1617,15 +1677,85 @@ fail:
 	return err;
 }
 
+static inline void event_set_filtered_flag(struct ftrace_event_file *file)
+{
+	struct ftrace_event_call *call = file->event_call;
+
+	if (call->flags & TRACE_EVENT_FL_USE_CALL_FILTER)
+		call->flags |= TRACE_EVENT_FL_FILTERED;
+	else
+		file->flags |= FTRACE_EVENT_FL_FILTERED;
+}
+
+static inline void event_set_filter(struct ftrace_event_file *file,
+				    struct event_filter *filter)
+{
+	struct ftrace_event_call *call = file->event_call;
+
+	if (call->flags & TRACE_EVENT_FL_USE_CALL_FILTER)
+		rcu_assign_pointer(call->filter, filter);
+	else
+		rcu_assign_pointer(file->filter, filter);
+}
+
+static inline void event_clear_filter(struct ftrace_event_file *file)
+{
+	struct ftrace_event_call *call = file->event_call;
+
+	if (call->flags & TRACE_EVENT_FL_USE_CALL_FILTER)
+		RCU_INIT_POINTER(call->filter, NULL);
+	else
+		RCU_INIT_POINTER(file->filter, NULL);
+}
+
+static inline void
+event_set_no_set_filter_flag(struct ftrace_event_file *file)
+{
+	struct ftrace_event_call *call = file->event_call;
+
+	if (call->flags & TRACE_EVENT_FL_USE_CALL_FILTER)
+		call->flags |= TRACE_EVENT_FL_NO_SET_FILTER;
+	else
+		file->flags |= FTRACE_EVENT_FL_NO_SET_FILTER;
+}
+
+static inline void
+event_clear_no_set_filter_flag(struct ftrace_event_file *file)
+{
+	struct ftrace_event_call *call = file->event_call;
+
+	if (call->flags & TRACE_EVENT_FL_USE_CALL_FILTER)
+		call->flags &= ~TRACE_EVENT_FL_NO_SET_FILTER;
+	else
+		file->flags &= ~FTRACE_EVENT_FL_NO_SET_FILTER;
+}
+
+static inline bool
+event_no_set_filter_flag(struct ftrace_event_file *file)
+{
+	struct ftrace_event_call *call = file->event_call;
+
+	if (file->flags & FTRACE_EVENT_FL_NO_SET_FILTER)
+		return true;
+
+	if ((call->flags & TRACE_EVENT_FL_USE_CALL_FILTER) &&
+	    (call->flags & TRACE_EVENT_FL_NO_SET_FILTER))
+		return true;
+
+	return false;
+}
+
 struct filter_list {
 	struct list_head	list;
 	struct event_filter	*filter;
 };
 
 static int replace_system_preds(struct event_subsystem *system,
+				struct trace_array *tr,
 				struct filter_parse_state *ps,
 				char *filter_string)
 {
+	struct ftrace_event_file *file;
 	struct ftrace_event_call *call;
 	struct filter_list *filter_item;
 	struct filter_list *tmp;
@@ -1633,8 +1763,8 @@ static int replace_system_preds(struct event_subsystem *system,
 	bool fail = true;
 	int err;
 
-	list_for_each_entry(call, &ftrace_events, list) {
-
+	list_for_each_entry(file, &tr->events, list) {
+		call = file->event_call;
 		if (strcmp(call->class->system, system->name) != 0)
 			continue;
 
@@ -1644,18 +1774,20 @@ static int replace_system_preds(struct event_subsystem *system,
 		 */
 		err = replace_preds(call, NULL, ps, filter_string, true);
 		if (err)
-			call->flags |= TRACE_EVENT_FL_NO_SET_FILTER;
+			event_set_no_set_filter_flag(file);
 		else
-			call->flags &= ~TRACE_EVENT_FL_NO_SET_FILTER;
+			event_clear_no_set_filter_flag(file);
 	}
 
-	list_for_each_entry(call, &ftrace_events, list) {
+	list_for_each_entry(file, &tr->events, list) {
 		struct event_filter *filter;
 
+		call = file->event_call;
+
 		if (strcmp(call->class->system, system->name) != 0)
 			continue;
 
-		if (call->flags & TRACE_EVENT_FL_NO_SET_FILTER)
+		if (event_no_set_filter_flag(file))
 			continue;
 
 		filter_item = kzalloc(sizeof(*filter_item), GFP_KERNEL);
@@ -1676,17 +1808,17 @@ static int replace_system_preds(struct event_subsystem *system,
 
 		err = replace_preds(call, filter, ps, filter_string, false);
 		if (err) {
-			filter_disable(call);
+			filter_disable(file);
 			parse_error(ps, FILT_ERR_BAD_SUBSYS_FILTER, 0);
 			append_filter_err(ps, filter);
 		} else
-			call->flags |= TRACE_EVENT_FL_FILTERED;
+			event_set_filtered_flag(file);
 		/*
 		 * Regardless of if this returned an error, we still
 		 * replace the filter for the call.
 		 */
-		filter = call->filter;
-		rcu_assign_pointer(call->filter, filter_item->filter);
+		filter = event_filter(file);
+		event_set_filter(file, filter_item->filter);
 		filter_item->filter = filter;
 
 		fail = false;
@@ -1816,6 +1948,7 @@ static int create_filter(struct ftrace_event_call *call,
  * and always remembers @filter_str.
  */
 static int create_system_filter(struct event_subsystem *system,
+				struct trace_array *tr,
 				char *filter_str, struct event_filter **filterp)
 {
 	struct event_filter *filter = NULL;
@@ -1824,7 +1957,7 @@ static int create_system_filter(struct event_subsystem *system,
 
 	err = create_filter_start(filter_str, true, &ps, &filter);
 	if (!err) {
-		err = replace_system_preds(system, ps, filter_str);
+		err = replace_system_preds(system, tr, ps, filter_str);
 		if (!err) {
 			/* System filters just show a default message */
 			kfree(filter->filter_string);
@@ -1840,20 +1973,25 @@ static int create_system_filter(struct event_subsystem *system,
 }
 
 /* caller must hold event_mutex */
-int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
+int apply_event_filter(struct ftrace_event_file *file, char *filter_string)
 {
+	struct ftrace_event_call *call = file->event_call;
 	struct event_filter *filter;
 	int err;
 
 	if (!strcmp(strstrip(filter_string), "0")) {
-		filter_disable(call);
-		filter = call->filter;
+		filter_disable(file);
+		filter = event_filter(file);
+
 		if (!filter)
 			return 0;
-		RCU_INIT_POINTER(call->filter, NULL);
+
+		event_clear_filter(file);
+
 		/* Make sure the filter is not being used */
 		synchronize_sched();
 		__free_filter(filter);
+
 		return 0;
 	}
 
@@ -1866,14 +2004,15 @@ int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
 	 * string
 	 */
 	if (filter) {
-		struct event_filter *tmp = call->filter;
+		struct event_filter *tmp;
 
+		tmp = event_filter(file);
 		if (!err)
-			call->flags |= TRACE_EVENT_FL_FILTERED;
+			event_set_filtered_flag(file);
 		else
-			filter_disable(call);
+			filter_disable(file);
 
-		rcu_assign_pointer(call->filter, filter);
+		event_set_filter(file, filter);
 
 		if (tmp) {
 			/* Make sure the call is done with the filter */
@@ -1889,6 +2028,7 @@ int apply_subsystem_event_filter(struct ftrace_subsystem_dir *dir,
 				 char *filter_string)
 {
 	struct event_subsystem *system = dir->subsystem;
+	struct trace_array *tr = dir->tr;
 	struct event_filter *filter;
 	int err = 0;
 
@@ -1901,18 +2041,18 @@ int apply_subsystem_event_filter(struct ftrace_subsystem_dir *dir,
 	}
 
 	if (!strcmp(strstrip(filter_string), "0")) {
-		filter_free_subsystem_preds(system);
+		filter_free_subsystem_preds(system, tr);
 		remove_filter_string(system->filter);
 		filter = system->filter;
 		system->filter = NULL;
 		/* Ensure all filters are no longer used */
 		synchronize_sched();
-		filter_free_subsystem_filters(system);
+		filter_free_subsystem_filters(system, tr);
 		__free_filter(filter);
 		goto out_unlock;
 	}
 
-	err = create_system_filter(system, filter_string, &filter);
+	err = create_system_filter(system, tr, filter_string, &filter);
 	if (filter) {
 		/*
 		 * No event actually uses the system filter
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index d21a746..7c3e3e7 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -180,7 +180,7 @@ struct ftrace_event_call __used event_##call = {			\
 	.event.type		= etype,				\
 	.class			= &event_class_ftrace_##call,		\
 	.print_fmt		= print,				\
-	.flags			= TRACE_EVENT_FL_IGNORE_ENABLE,		\
+	.flags			= TRACE_EVENT_FL_IGNORE_ENABLE | TRACE_EVENT_FL_USE_CALL_FILTER, \
 };									\
 struct ftrace_event_call __used						\
 __attribute__((section("_ftrace_events"))) *__event_##call = &event_##call;
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index e08c030..80387d1 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -270,7 +270,7 @@ int __trace_graph_entry(struct trace_array *tr,
 		return 0;
 	entry	= ring_buffer_event_data(event);
 	entry->graph_ent			= *trace;
-	if (!filter_current_check_discard(buffer, call, entry, event))
+	if (!call_filter_check_discard(call, entry, buffer, event))
 		__buffer_unlock_commit(buffer, event);
 
 	return 1;
@@ -385,7 +385,7 @@ void __trace_graph_return(struct trace_array *tr,
 		return;
 	entry	= ring_buffer_event_data(event);
 	entry->ret				= *trace;
-	if (!filter_current_check_discard(buffer, call, entry, event))
+	if (!call_filter_check_discard(call, entry, buffer, event))
 		__buffer_unlock_commit(buffer, event);
 }
 
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 243f683..dae9541 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -835,7 +835,7 @@ __kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs,
 	entry->ip = (unsigned long)tp->rp.kp.addr;
 	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
 
-	if (!filter_current_check_discard(buffer, call, entry, event))
+	if (!filter_check_discard(ftrace_file, entry, buffer, event))
 		trace_buffer_unlock_commit_regs(buffer, event,
 						irq_flags, pc, regs);
 }
@@ -884,7 +884,7 @@ __kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 	entry->ret_ip = (unsigned long)ri->ret_addr;
 	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
 
-	if (!filter_current_check_discard(buffer, call, entry, event))
+	if (!filter_check_discard(ftrace_file, entry, buffer, event))
 		trace_buffer_unlock_commit_regs(buffer, event,
 						irq_flags, pc, regs);
 }
diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index b3dcfb2..0abd9b8 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -323,7 +323,7 @@ static void __trace_mmiotrace_rw(struct trace_array *tr,
 	entry	= ring_buffer_event_data(event);
 	entry->rw			= *rw;
 
-	if (!filter_check_discard(call, entry, buffer, event))
+	if (!call_filter_check_discard(call, entry, buffer, event))
 		trace_buffer_unlock_commit(buffer, event, 0, pc);
 }
 
@@ -353,7 +353,7 @@ static void __trace_mmiotrace_map(struct trace_array *tr,
 	entry	= ring_buffer_event_data(event);
 	entry->map			= *map;
 
-	if (!filter_check_discard(call, entry, buffer, event))
+	if (!call_filter_check_discard(call, entry, buffer, event))
 		trace_buffer_unlock_commit(buffer, event, 0, pc);
 }
 
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index 4e98e3b..3f34dc9 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -45,7 +45,7 @@ tracing_sched_switch_trace(struct trace_array *tr,
 	entry->next_state		= next->state;
 	entry->next_cpu	= task_cpu(next);
 
-	if (!filter_check_discard(call, entry, buffer, event))
+	if (!call_filter_check_discard(call, entry, buffer, event))
 		trace_buffer_unlock_commit(buffer, event, flags, pc);
 }
 
@@ -101,7 +101,7 @@ tracing_sched_wakeup_trace(struct trace_array *tr,
 	entry->next_state		= wakee->state;
 	entry->next_cpu			= task_cpu(wakee);
 
-	if (!filter_check_discard(call, entry, buffer, event))
+	if (!call_filter_check_discard(call, entry, buffer, event))
 		trace_buffer_unlock_commit(buffer, event, flags, pc);
 }
 
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 559329d..32644ee 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -336,8 +336,8 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 	entry->nr = syscall_nr;
 	syscall_get_arguments(current, regs, 0, sys_data->nb_args, entry->args);
 
-	if (!filter_current_check_discard(buffer, sys_data->enter_event,
-					  entry, event))
+	if (!call_filter_check_discard(sys_data->enter_event, entry,
+				       buffer, event))
 		trace_current_buffer_unlock_commit(buffer, event,
 						   irq_flags, pc);
 }
@@ -377,8 +377,8 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	entry->nr = syscall_nr;
 	entry->ret = syscall_get_return_value(current, regs);
 
-	if (!filter_current_check_discard(buffer, sys_data->exit_event,
-					  entry, event))
+	if (!call_filter_check_discard(sys_data->exit_event, entry,
+				       buffer, event))
 		trace_current_buffer_unlock_commit(buffer, event,
 						   irq_flags, pc);
 }
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 272261b..b6dcc42 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -128,6 +128,7 @@ alloc_trace_uprobe(const char *group, const char *event, int nargs, bool is_ret)
 	if (is_ret)
 		tu->consumer.ret_handler = uretprobe_dispatcher;
 	init_trace_uprobe_filter(&tu->filter);
+	tu->call.flags |= TRACE_EVENT_FL_USE_CALL_FILTER;
 	return tu;
 
 error:
@@ -561,7 +562,7 @@ static void uprobe_trace_print(struct trace_uprobe *tu,
 	for (i = 0; i < tu->nr_args; i++)
 		call_fetch(&tu->args[i].fetch, regs, data + tu->args[i].offset);
 
-	if (!filter_current_check_discard(buffer, call, entry, event))
+	if (!call_filter_check_discard(call, entry, buffer, event))
 		trace_buffer_unlock_commit(buffer, event, 0, 0);
 }
 
-- 
1.8.4.rc3


