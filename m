Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760592Ab3GSPK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 11:10:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:15830 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933027Ab3GSPJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 11:09:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,702,1367996400"; 
   d="scan'208";a="333901400"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: masami.hiramatsu.pt@hitachi.com, jovi.zhangwei@huawei.com,
        linux-kernel@vger.kernel.org,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH v3 8/9] tracing: update event filters for multibuffer
Date: Fri, 19 Jul 2013 10:09:35 -0500
Message-Id: <ab4181c051942670e51a133a66c92274b85b99e8.1374245042.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <cover.1374245042.git.tom.zanussi@linux.intel.com>
References: <cover.1374245042.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1374245042.git.tom.zanussi@linux.intel.com>
References: <cover.1374245042.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The trace event filters are still tied to event calls rather than
event files, which means you don't get what you'd expect when using
filters in the multibuffer case:

Before:

  # echo 'count > 65536' > /sys/kernel/debug/tracing/events/syscalls/sys_enter_read/filter
  # cat /sys/kernel/debug/tracing/events/syscalls/sys_enter_read/filter
  count > 65536
  # mkdir /sys/kernel/debug/tracing/instances/test1
  # echo 'count > 4096' > /sys/kernel/debug/tracing/instances/test1/events/syscalls/sys_enter_read/filter
  # cat /sys/kernel/debug/tracing/events/syscalls/sys_enter_read/filter
  count > 4096

Setting the filter in tracing/instances/test1/events shouldn't affect
the same event in tracing/events as it does above.

After:

  # echo 'count > 65536' > /sys/kernel/debug/tracing/events/syscalls/sys_enter_read/filter
  # cat /sys/kernel/debug/tracing/events/syscalls/sys_enter_read/filter
  count > 65536
  # mkdir /sys/kernel/debug/tracing/instances/test1
  # echo 'count > 4096' > /sys/kernel/debug/tracing/instances/test1/events/syscalls/sys_enter_read/filter
  # cat /sys/kernel/debug/tracing/events/syscalls/sys_enter_read/filter
count > 65536

We'd like to just move the filter directly from ftrace_event_call to
ftrace_event_file, but there are a couple cases that don't yet have
multibuffer support and therefore have to continue using the current
event_call-based filters.  For those cases, a new USE_CALL_FILTER bit
is added to the event_call flags, whose main purpose is to keep the
old behavioir for those cases until they can be updated with
multibuffer support; at that point, the USE_CALL_FILTER flag (and the
new associated call_filter_check_discard() function) can go away.

The multibuffer support also made filter_current_check_discard()
redundant, so this change removes that function as well and replaces
it with filter_check_discard() (or call_filter_check_discard() as
appropriate).

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 include/linux/ftrace_event.h         |  37 ++++++--
 include/trace/ftrace.h               |   6 +-
 kernel/trace/trace.c                 |  18 ++--
 kernel/trace/trace.h                 |  10 +--
 kernel/trace/trace_branch.c          |   2 +-
 kernel/trace/trace_events.c          |  16 ++--
 kernel/trace/trace_events_filter.c   | 166 +++++++++++++++++++++++++++--------
 kernel/trace/trace_export.c          |   2 +-
 kernel/trace/trace_functions_graph.c |   4 +-
 kernel/trace/trace_kprobe.c          |   4 +-
 kernel/trace/trace_mmiotrace.c       |   4 +-
 kernel/trace/trace_sched_switch.c    |   4 +-
 kernel/trace/trace_syscalls.c        |   8 +-
 kernel/trace/trace_uprobe.c          |   3 +-
 14 files changed, 193 insertions(+), 91 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index f0c6e80..00c8a5e 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -200,6 +200,7 @@ enum {
 	TRACE_EVENT_FL_NO_SET_FILTER_BIT,
 	TRACE_EVENT_FL_IGNORE_ENABLE_BIT,
 	TRACE_EVENT_FL_WAS_ENABLED_BIT,
+	TRACE_EVENT_FL_USE_CALL_FILTER_BIT,
 };
 
 /*
@@ -211,6 +212,7 @@ enum {
  *  WAS_ENABLED   - Set and stays set when an event was ever enabled
  *                    (used for module unloading, if a module event is enabled,
  *                     it is best to clear the buffers that used it).
+ *  USE_CALL_FILTER - For ftrace internal events, don't use file filter
  */
 enum {
 	TRACE_EVENT_FL_FILTERED		= (1 << TRACE_EVENT_FL_FILTERED_BIT),
@@ -218,6 +220,7 @@ enum {
 	TRACE_EVENT_FL_NO_SET_FILTER	= (1 << TRACE_EVENT_FL_NO_SET_FILTER_BIT),
 	TRACE_EVENT_FL_IGNORE_ENABLE	= (1 << TRACE_EVENT_FL_IGNORE_ENABLE_BIT),
 	TRACE_EVENT_FL_WAS_ENABLED	= (1 << TRACE_EVENT_FL_WAS_ENABLED_BIT),
+	TRACE_EVENT_FL_USE_CALL_FILTER	= (1 << TRACE_EVENT_FL_USE_CALL_FILTER_BIT),
 };
 
 struct ftrace_event_call {
@@ -236,6 +239,7 @@ struct ftrace_event_call {
 	 *   bit 2:		failed to apply filter
 	 *   bit 3:		ftrace internal event (do not enable)
 	 *   bit 4:		Event was enabled by module
+	 *   bit 5:		use call filter rather than file filter
 	 */
 	int			flags; /* static flags of different events */
 
@@ -251,6 +255,8 @@ struct ftrace_subsystem_dir;
 enum {
 	FTRACE_EVENT_FL_ENABLED_BIT,
 	FTRACE_EVENT_FL_RECORDED_CMD_BIT,
+	FTRACE_EVENT_FL_FILTERED_BIT,
+	FTRACE_EVENT_FL_NO_SET_FILTER_BIT,
 	FTRACE_EVENT_FL_SOFT_MODE_BIT,
 	FTRACE_EVENT_FL_SOFT_DISABLED_BIT,
 	FTRACE_EVENT_FL_TRIGGER_MODE_BIT,
@@ -260,6 +266,8 @@ enum {
  * Ftrace event file flags:
  *  ENABLED	  - The event is enabled
  *  RECORDED_CMD  - The comms should be recorded at sched_switch
+ *  FILTERED	  - The event has a filter attached
+ *  NO_SET_FILTER - Set when filter has error and is to be ignored
  *  SOFT_MODE     - The event is enabled/disabled by SOFT_DISABLED
  *  SOFT_DISABLED - When set, do not trace the event (even though its
  *                  tracepoint may be enabled)
@@ -268,6 +276,8 @@ enum {
 enum {
 	FTRACE_EVENT_FL_ENABLED		= (1 << FTRACE_EVENT_FL_ENABLED_BIT),
 	FTRACE_EVENT_FL_RECORDED_CMD	= (1 << FTRACE_EVENT_FL_RECORDED_CMD_BIT),
+	FTRACE_EVENT_FL_FILTERED	= (1 << FTRACE_EVENT_FL_FILTERED_BIT),
+	FTRACE_EVENT_FL_NO_SET_FILTER	= (1 << FTRACE_EVENT_FL_NO_SET_FILTER_BIT),
 	FTRACE_EVENT_FL_SOFT_MODE	= (1 << FTRACE_EVENT_FL_SOFT_MODE_BIT),
 	FTRACE_EVENT_FL_SOFT_DISABLED	= (1 << FTRACE_EVENT_FL_SOFT_DISABLED_BIT),
 	FTRACE_EVENT_FL_TRIGGER_MODE	= (1 << FTRACE_EVENT_FL_TRIGGER_MODE_BIT),
@@ -276,6 +286,7 @@ enum {
 struct ftrace_event_file {
 	struct list_head		list;
 	struct ftrace_event_call	*event_call;
+	struct event_filter		*filter;
 	struct dentry			*dir;
 	struct trace_array		*tr;
 	struct ftrace_subsystem_dir	*system;
@@ -286,8 +297,10 @@ struct ftrace_event_file {
 	 *   bit 0:		enabled
 	 *   bit 1:		enabled cmd record
 	 *   bit 2:		enable/disable with the soft disable bit
-	 *   bit 3:		soft disabled
-	 *   bit 4:		trigger enabled
+	 *   bit 3:		filter_active
+	 *   bit 4:		failed to apply filter
+	 *   bit 5:		soft disabled
+	 *   bit 6:		trigger enabled
 	 *
 	 * Note: The bits must be set atomically to prevent races
 	 * from other writers. Reads of flags do not need to be in
@@ -322,17 +335,27 @@ enum trigger_mode {
 	TM_EVENT_ENABLE		= (1 << 3),
 };
 
-extern void destroy_preds(struct ftrace_event_call *call);
+extern void destroy_preds(struct ftrace_event_file *file);
+extern void destroy_call_preds(struct ftrace_event_call *call);
 extern int filter_match_preds(struct event_filter *filter, void *rec);
-extern int filter_current_check_discard(struct ring_buffer *buffer,
-					struct ftrace_event_call *call,
-					void *rec,
-					struct ring_buffer_event *event);
 extern enum trigger_mode event_triggers_call(struct ftrace_event_file *file,
 					     void *rec);
 extern void event_triggers_post_call(struct ftrace_event_file *file,
 				     enum trigger_mode tm);
 
+static inline int
+filter_check_discard(struct ftrace_event_file *file, void *rec,
+		     struct ring_buffer *buffer,
+		     struct ring_buffer_event *event)
+{
+	if (unlikely(file->flags & FTRACE_EVENT_FL_FILTERED) &&
+	    !filter_match_preds(file->filter, rec)) {
+		ring_buffer_discard_commit(buffer, event);
+		return 1;
+	}
+
+	return 0;
+}
 
 enum {
 	FILTER_OTHER = 0,
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 311f38e..7eff632 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -446,8 +446,7 @@ static inline notrace int ftrace_get_offsets_##call(			\
  *	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,
  *		     &ftrace_file->flags))
  *		ring_buffer_discard_commit(buffer, event);
- *	else if (!filter_current_check_discard(buffer, event_call,
- *					       entry, event))
+ *	else if (!filter_check_discard(ftrace_file, entry, buffer, event))
  *		trace_buffer_unlock_commit(buffer, event, irq_flags, pc);
  *
  *	if (__tm)
@@ -568,8 +567,7 @@ ftrace_raw_event_##call(void *__data, proto)				\
 	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,                 \
 		     &ftrace_file->flags))                              \
 		ring_buffer_discard_commit(buffer, event);              \
-	else if (!filter_current_check_discard(buffer, event_call,      \
-					       entry, event))		\
+	else if (!filter_check_discard(ftrace_file, entry, buffer, event)) \
 		trace_buffer_unlock_commit(buffer, event, irq_flags, pc); \
 									\
 	if (__tm)							\
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 2997d61..4e2a70f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -235,14 +235,6 @@ void trace_array_put(struct trace_array *this_tr)
 	mutex_unlock(&trace_types_lock);
 }
 
-int filter_current_check_discard(struct ring_buffer *buffer,
-				 struct ftrace_event_call *call, void *rec,
-				 struct ring_buffer_event *event)
-{
-	return filter_check_discard(call, rec, buffer, event);
-}
-EXPORT_SYMBOL_GPL(filter_current_check_discard);
-
 cycle_t ftrace_now(int cpu)
 {
 	u64 ts;
@@ -1631,7 +1623,7 @@ trace_function(struct trace_array *tr,
 	entry->ip			= ip;
 	entry->parent_ip		= parent_ip;
 
-	if (!filter_check_discard(call, entry, buffer, event))
+	if (!call_filter_check_discard(call, entry, buffer, event))
 		__buffer_unlock_commit(buffer, event);
 }
 
@@ -1715,7 +1707,7 @@ static void __ftrace_trace_stack(struct ring_buffer *buffer,
 
 	entry->size = trace.nr_entries;
 
-	if (!filter_check_discard(call, entry, buffer, event))
+	if (!call_filter_check_discard(call, entry, buffer, event))
 		__buffer_unlock_commit(buffer, event);
 
  out:
@@ -1817,7 +1809,7 @@ ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags, int pc)
 	trace.entries		= entry->caller;
 
 	save_stack_trace_user(&trace);
-	if (!filter_check_discard(call, entry, buffer, event))
+	if (!call_filter_check_discard(call, entry, buffer, event))
 		__buffer_unlock_commit(buffer, event);
 
  out_drop_count:
@@ -2009,7 +2001,7 @@ int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
 	entry->fmt			= fmt;
 
 	memcpy(entry->buf, tbuffer, sizeof(u32) * len);
-	if (!filter_check_discard(call, entry, buffer, event)) {
+	if (!call_filter_check_discard(call, entry, buffer, event)) {
 		__buffer_unlock_commit(buffer, event);
 		ftrace_trace_stack(buffer, flags, 6, pc);
 	}
@@ -2064,7 +2056,7 @@ __trace_array_vprintk(struct ring_buffer *buffer,
 
 	memcpy(&entry->buf, tbuffer, len);
 	entry->buf[len] = '\0';
-	if (!filter_check_discard(call, entry, buffer, event)) {
+	if (!call_filter_check_discard(call, entry, buffer, event)) {
 		__buffer_unlock_commit(buffer, event);
 		ftrace_trace_stack(buffer, flags, 6, pc);
 	}
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 8597592..2bcf37a 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -987,9 +987,9 @@ struct filter_pred {
 
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
@@ -1005,9 +1005,9 @@ struct ftrace_event_field *
 trace_find_event_field(struct ftrace_event_call *call, char *name);
 
 static inline int
-filter_check_discard(struct ftrace_event_call *call, void *rec,
-		     struct ring_buffer *buffer,
-		     struct ring_buffer_event *event)
+call_filter_check_discard(struct ftrace_event_call *call, void *rec,
+			  struct ring_buffer *buffer,
+			  struct ring_buffer_event *event)
 {
 	if (unlikely(call->flags & TRACE_EVENT_FL_FILTERED) &&
 	    !filter_match_preds(call->filter, rec)) {
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
index 8ac5ce0..9493e67 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -992,7 +992,7 @@ static ssize_t
 event_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
 		  loff_t *ppos)
 {
-	struct ftrace_event_call *call = filp->private_data;
+	struct ftrace_event_file *file = filp->private_data;
 	struct trace_seq *s;
 	int r;
 
@@ -1005,7 +1005,7 @@ event_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
 
 	trace_seq_init(s);
 
-	print_event_filter(call, s);
+	print_event_filter(file, s);
 	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
 
 	kfree(s);
@@ -1017,7 +1017,7 @@ static ssize_t
 event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 		   loff_t *ppos)
 {
-	struct ftrace_event_call *call = filp->private_data;
+	struct ftrace_event_file *file = filp->private_data;
 	char *buf;
 	int err;
 
@@ -1034,7 +1034,7 @@ event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	}
 	buf[cnt] = '\0';
 
-	err = apply_event_filter(call, buf);
+	err = apply_event_filter(file, buf);
 	free_page((unsigned long) buf);
 	if (err < 0)
 		return err;
@@ -1520,7 +1520,7 @@ event_create_dir(struct dentry *parent,
 			return -1;
 		}
 	}
-	trace_create_file("filter", 0644, file->dir, call,
+	trace_create_file("filter", 0644, file->dir, file,
 			  filter);
 
 	trace_create_file("trigger", 0644, file->dir, file,
@@ -1578,6 +1578,10 @@ static void event_remove(struct ftrace_event_call *call)
 		if (file->event_call != call)
 			continue;
 		ftrace_event_enable_disable(file, 0);
+		if (call->flags & TRACE_EVENT_FL_USE_CALL_FILTER)
+			destroy_call_preds(call);
+		else
+			destroy_preds(file);
 		/*
 		 * The do_for_each_event_file() is
 		 * a double loop. After finding the call for this
@@ -1711,7 +1715,7 @@ static void __trace_remove_event_call(struct ftrace_event_call *call)
 {
 	event_remove(call);
 	trace_destroy_fields(call);
-	destroy_preds(call);
+	destroy_call_preds(call);
 }
 
 /* Remove an event_call */
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 6cf2cef..edd5e97 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -637,12 +637,15 @@ static void append_filter_err(struct filter_parse_state *ps,
 	free_page((unsigned long) buf);
 }
 
-void print_event_filter(struct ftrace_event_call *call, struct trace_seq *s)
+void print_event_filter(struct ftrace_event_file *file, struct trace_seq *s)
 {
 	struct event_filter *filter;
 
 	mutex_lock(&event_mutex);
-	filter = call->filter;
+	if (file->event_call->flags & TRACE_EVENT_FL_USE_CALL_FILTER)
+		filter = file->event_call->filter;
+	else
+		filter = file->filter;
 	if (filter && filter->filter_string)
 		trace_seq_printf(s, "%s\n", filter->filter_string);
 	else
@@ -768,7 +771,12 @@ static void __free_preds(struct event_filter *filter)
 	filter->n_preds = 0;
 }
 
-static void filter_disable(struct ftrace_event_call *call)
+static void filter_disable(struct ftrace_event_file *file)
+{
+	file->flags &= ~FTRACE_EVENT_FL_FILTERED;
+}
+
+static void call_filter_disable(struct ftrace_event_call *call)
 {
 	call->flags &= ~TRACE_EVENT_FL_FILTERED;
 }
@@ -789,12 +797,24 @@ void free_event_filter(struct event_filter *filter)
 }
 
 /*
+ * Called when destroying the ftrace_event_file.
+ * The file is being freed, so we do not need to worry about
+ * the file being currently used. This is for module code removing
+ * the tracepoints from within it.
+ */
+void destroy_preds(struct ftrace_event_file *file)
+{
+	__free_filter(file->filter);
+	file->filter = NULL;
+}
+
+/*
  * Called when destroying the ftrace_event_call.
  * The call is being freed, so we do not need to worry about
  * the call being currently used. This is for module code removing
  * the tracepoints from within it.
  */
-void destroy_preds(struct ftrace_event_call *call)
+void destroy_call_preds(struct ftrace_event_call *call)
 {
 	__free_filter(call->filter);
 	call->filter = NULL;
@@ -832,28 +852,44 @@ static int __alloc_preds(struct event_filter *filter, int n_preds)
 	return 0;
 }
 
-static void filter_free_subsystem_preds(struct event_subsystem *system)
+static void filter_free_subsystem_preds(struct event_subsystem *system,
+					struct trace_array *tr)
 {
+	struct ftrace_event_file *file;
 	struct ftrace_event_call *call;
 
-	list_for_each_entry(call, &ftrace_events, list) {
+	list_for_each_entry(file, &tr->events, list) {
+		call = file->event_call;
 		if (strcmp(call->class->system, system->name) != 0)
 			continue;
 
-		filter_disable(call);
-		remove_filter_string(call->filter);
+		if (call->flags & TRACE_EVENT_FL_USE_CALL_FILTER) {
+			call_filter_disable(call);
+			remove_filter_string(call->filter);
+		} else {
+			filter_disable(file);
+			remove_filter_string(file->filter);
+		}
 	}
 }
 
-static void filter_free_subsystem_filters(struct event_subsystem *system)
+static void filter_free_subsystem_filters(struct event_subsystem *system,
+					  struct trace_array *tr)
 {
+	struct ftrace_event_file *file;
 	struct ftrace_event_call *call;
 
-	list_for_each_entry(call, &ftrace_events, list) {
+	list_for_each_entry(file, &tr->events, list) {
+		call = file->event_call;
 		if (strcmp(call->class->system, system->name) != 0)
 			continue;
-		__free_filter(call->filter);
-		call->filter = NULL;
+		if (call->flags & TRACE_EVENT_FL_USE_CALL_FILTER) {
+			__free_filter(call->filter);
+			call->filter = NULL;
+		} else {
+			__free_filter(file->filter);
+			file->filter = NULL;
+		}
 	}
 }
 
@@ -1630,9 +1666,11 @@ struct filter_list {
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
@@ -1640,8 +1678,8 @@ static int replace_system_preds(struct event_subsystem *system,
 	bool fail = true;
 	int err;
 
-	list_for_each_entry(call, &ftrace_events, list) {
-
+	list_for_each_entry(file, &tr->events, list) {
+		call = file->event_call;
 		if (strcmp(call->class->system, system->name) != 0)
 			continue;
 
@@ -1650,21 +1688,34 @@ static int replace_system_preds(struct event_subsystem *system,
 		 *  (filter arg is ignored on dry_run)
 		 */
 		err = replace_preds(call, NULL, ps, filter_string, true);
-		if (err)
-			call->flags |= TRACE_EVENT_FL_NO_SET_FILTER;
-		else
-			call->flags &= ~TRACE_EVENT_FL_NO_SET_FILTER;
+		if (call->flags & TRACE_EVENT_FL_USE_CALL_FILTER) {
+			if (err)
+				call->flags |= TRACE_EVENT_FL_NO_SET_FILTER;
+			else
+				call->flags &= ~TRACE_EVENT_FL_NO_SET_FILTER;
+		} else {
+			if (err)
+				file->flags |= FTRACE_EVENT_FL_NO_SET_FILTER;
+			else
+				file->flags &= ~FTRACE_EVENT_FL_NO_SET_FILTER;
+		}
 	}
 
-	list_for_each_entry(call, &ftrace_events, list) {
+	list_for_each_entry(file, &tr->events, list) {
 		struct event_filter *filter;
 
+		call = file->event_call;
+
 		if (strcmp(call->class->system, system->name) != 0)
 			continue;
 
-		if (call->flags & TRACE_EVENT_FL_NO_SET_FILTER)
+		if (file->flags & FTRACE_EVENT_FL_NO_SET_FILTER)
 			continue;
 
+		if ((call->flags & TRACE_EVENT_FL_USE_CALL_FILTER) &&
+		    (call->flags & TRACE_EVENT_FL_NO_SET_FILTER))
+				continue;
+
 		filter_item = kzalloc(sizeof(*filter_item), GFP_KERNEL);
 		if (!filter_item)
 			goto fail_mem;
@@ -1683,17 +1734,29 @@ static int replace_system_preds(struct event_subsystem *system,
 
 		err = replace_preds(call, filter, ps, filter_string, false);
 		if (err) {
-			filter_disable(call);
+			if (call->flags & TRACE_EVENT_FL_USE_CALL_FILTER)
+				call_filter_disable(call);
+			else
+				filter_disable(file);
 			parse_error(ps, FILT_ERR_BAD_SUBSYS_FILTER, 0);
 			append_filter_err(ps, filter);
-		} else
-			call->flags |= TRACE_EVENT_FL_FILTERED;
+		} else {
+			if (call->flags & TRACE_EVENT_FL_USE_CALL_FILTER)
+				call->flags |= TRACE_EVENT_FL_FILTERED;
+			else
+				file->flags |= FTRACE_EVENT_FL_FILTERED;
+		}
 		/*
 		 * Regardless of if this returned an error, we still
 		 * replace the filter for the call.
 		 */
-		filter = call->filter;
-		rcu_assign_pointer(call->filter, filter_item->filter);
+		if (call->flags & TRACE_EVENT_FL_USE_CALL_FILTER) {
+			filter = call->filter;
+			rcu_assign_pointer(call->filter, filter_item->filter);
+		} else {
+			filter = file->filter;
+			rcu_assign_pointer(file->filter, filter_item->filter);
+		}
 		filter_item->filter = filter;
 
 		fail = false;
@@ -1831,6 +1894,7 @@ int create_event_filter(struct ftrace_event_call *call,
  * and always remembers @filter_str.
  */
 static int create_system_filter(struct event_subsystem *system,
+				struct trace_array *tr,
 				char *filter_str, struct event_filter **filterp)
 {
 	struct event_filter *filter = NULL;
@@ -1839,7 +1903,7 @@ static int create_system_filter(struct event_subsystem *system,
 
 	err = create_filter_start(filter_str, true, &ps, &filter);
 	if (!err) {
-		err = replace_system_preds(system, ps, filter_str);
+		err = replace_system_preds(system, tr, ps, filter_str);
 		if (!err) {
 			/* System filters just show a default message */
 			kfree(filter->filter_string);
@@ -1854,19 +1918,31 @@ static int create_system_filter(struct event_subsystem *system,
 	return err;
 }
 
-int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
+int apply_event_filter(struct ftrace_event_file *file, char *filter_string)
 {
+	struct ftrace_event_call *call = file->event_call;
 	struct event_filter *filter;
+	bool use_call_filter;
 	int err = 0;
 
+	use_call_filter = call->flags & TRACE_EVENT_FL_USE_CALL_FILTER;
+
 	mutex_lock(&event_mutex);
 
 	if (!strcmp(strstrip(filter_string), "0")) {
-		filter_disable(call);
-		filter = call->filter;
+		if (use_call_filter) {
+			call_filter_disable(call);
+			filter = call->filter;
+		} else {
+			filter_disable(file);
+			filter = file->filter;
+		}
 		if (!filter)
 			goto out_unlock;
-		RCU_INIT_POINTER(call->filter, NULL);
+		if (use_call_filter)
+			RCU_INIT_POINTER(call->filter, NULL);
+		else
+			RCU_INIT_POINTER(file->filter, NULL);
 		/* Make sure the filter is not being used */
 		synchronize_sched();
 		__free_filter(filter);
@@ -1882,14 +1958,25 @@ int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
 	 * string
 	 */
 	if (filter) {
-		struct event_filter *tmp = call->filter;
+		struct event_filter *tmp;
 
-		if (!err)
-			call->flags |= TRACE_EVENT_FL_FILTERED;
-		else
-			filter_disable(call);
+		if (use_call_filter) {
+			tmp = call->filter;
+			if (!err)
+				call->flags |= TRACE_EVENT_FL_FILTERED;
+			else
+				call_filter_disable(call);
+
+			rcu_assign_pointer(call->filter, filter);
+		} else {
+			tmp = file->filter;
+			if (!err)
+				file->flags |= FTRACE_EVENT_FL_FILTERED;
+			else
+				filter_disable(file);
 
-		rcu_assign_pointer(call->filter, filter);
+			rcu_assign_pointer(file->filter, filter);
+		}
 
 		if (tmp) {
 			/* Make sure the call is done with the filter */
@@ -1907,6 +1994,7 @@ int apply_subsystem_event_filter(struct ftrace_subsystem_dir *dir,
 				 char *filter_string)
 {
 	struct event_subsystem *system = dir->subsystem;
+	struct trace_array *tr = dir->tr;
 	struct event_filter *filter;
 	int err = 0;
 
@@ -1919,18 +2007,18 @@ int apply_subsystem_event_filter(struct ftrace_subsystem_dir *dir,
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
index 8388bc9..1500aeb 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -230,7 +230,7 @@ int __trace_graph_entry(struct trace_array *tr,
 		return 0;
 	entry	= ring_buffer_event_data(event);
 	entry->graph_ent			= *trace;
-	if (!filter_current_check_discard(buffer, call, entry, event))
+	if (!call_filter_check_discard(call, entry, buffer, event))
 		__buffer_unlock_commit(buffer, event);
 
 	return 1;
@@ -335,7 +335,7 @@ void __trace_graph_return(struct trace_array *tr,
 		return;
 	entry	= ring_buffer_event_data(event);
 	entry->ret				= *trace;
-	if (!filter_current_check_discard(buffer, call, entry, event))
+	if (!call_filter_check_discard(call, entry, buffer, event))
 		__buffer_unlock_commit(buffer, event);
 }
 
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 7ed6976..60180ad 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -819,7 +819,7 @@ __kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs,
 	entry->ip = (unsigned long)tp->rp.kp.addr;
 	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
 
-	if (!filter_current_check_discard(buffer, call, entry, event))
+	if (!filter_check_discard(ftrace_file, entry, buffer, event))
 		trace_buffer_unlock_commit_regs(buffer, event,
 						irq_flags, pc, regs);
 }
@@ -868,7 +868,7 @@ __kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 	entry->ret_ip = (unsigned long)ri->ret_addr;
 	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
 
-	if (!filter_current_check_discard(buffer, call, entry, event))
+	if (!filter_check_discard(ftrace_file, entry, buffer, event))
 		trace_buffer_unlock_commit_regs(buffer, event,
 						irq_flags, pc, regs);
 }
diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index a5e8f48..4f06ac0 100644
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
index 609190b..516df72 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -324,11 +324,9 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 	     (FTRACE_EVENT_FL_SOFT_DISABLED | FTRACE_EVENT_FL_TRIGGER_MODE)) ==
 	    FTRACE_EVENT_FL_SOFT_DISABLED)
 		return;
-
 	sys_data = syscall_nr_to_meta(syscall_nr);
 	if (!sys_data)
 		return;
-
 	size = sizeof(*entry) + sizeof(unsigned long) * sys_data->nb_args;
 
 	local_save_flags(irq_flags);
@@ -349,8 +347,7 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 
 	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
 		ring_buffer_discard_commit(buffer, event);
-	else if (!filter_current_check_discard(buffer, sys_data->enter_event,
-					       entry, event))
+	else if (!filter_check_discard(ftrace_file, entry, buffer, event))
 		trace_current_buffer_unlock_commit(buffer, event,
 						   irq_flags, pc);
 	if (__tm)
@@ -405,8 +402,7 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 
 	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
 		ring_buffer_discard_commit(buffer, event);
-	else if (!filter_current_check_discard(buffer, sys_data->exit_event,
-					       entry, event))
+	else if (!filter_check_discard(ftrace_file, entry, buffer, event))
 		trace_current_buffer_unlock_commit(buffer, event,
 						   irq_flags, pc);
 	if (__tm)
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index d5d0cd3..df1eb12 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -128,6 +128,7 @@ alloc_trace_uprobe(const char *group, const char *event, int nargs, bool is_ret)
 	if (is_ret)
 		tu->consumer.ret_handler = uretprobe_dispatcher;
 	init_trace_uprobe_filter(&tu->filter);
+	tu->call.flags |= TRACE_EVENT_FL_USE_CALL_FILTER;
 	return tu;
 
 error:
@@ -541,7 +542,7 @@ static void uprobe_trace_print(struct trace_uprobe *tu,
 	for (i = 0; i < tu->nr_args; i++)
 		call_fetch(&tu->args[i].fetch, regs, data + tu->args[i].offset);
 
-	if (!filter_current_check_discard(buffer, call, entry, event))
+	if (!call_filter_check_discard(call, entry, buffer, event))
 		trace_buffer_unlock_commit(buffer, event, 0, 0);
 }
 
-- 
1.7.11.4

