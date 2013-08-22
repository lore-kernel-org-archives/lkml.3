Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab3HVT6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 15:58:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:10850 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754296Ab3HVT6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 15:58:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,935,1367996400"; 
   d="scan'208";a="390541267"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH v5 08/10] tracing: update event filters for multibuffer
Date: Thu, 22 Aug 2013 14:57:41 -0500
Message-Id: <e09e01350c860f4f216f463f8d34e2db814f8be9.1377183739.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <cover.1377183739.git.tom.zanussi@linux.intel.com>
References: <cover.1377183739.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1377183739.git.tom.zanussi@linux.intel.com>
References: <cover.1377183739.git.tom.zanussi@linux.intel.com>
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
 kernel/trace/trace_events.c          |  26 +++---
 kernel/trace/trace_events_filter.c   | 168 +++++++++++++++++++++++++++--------
 kernel/trace/trace_export.c          |   2 +-
 kernel/trace/trace_functions_graph.c |   4 +-
 kernel/trace/trace_kprobe.c          |   4 +-
 kernel/trace/trace_mmiotrace.c       |   4 +-
 kernel/trace/trace_sched_switch.c    |   4 +-
 kernel/trace/trace_syscalls.c        |   8 +-
 kernel/trace/trace_uprobe.c          |   3 +-
 14 files changed, 200 insertions(+), 96 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index cd5326a8..061a12a 100644
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
 	FTRACE_EVENT_FL_TRIGGER_MODE_BIT,
@@ -262,6 +268,8 @@ enum {
  * Ftrace event file flags:
  *  ENABLED	  - The event is enabled
  *  RECORDED_CMD  - The comms should be recorded at sched_switch
+ *  FILTERED	  - The event has a filter attached
+ *  NO_SET_FILTER - Set when filter has error and is to be ignored
  *  SOFT_MODE     - The event is enabled/disabled by SOFT_DISABLED
  *  SOFT_DISABLED - When set, do not trace the event (even though its
  *                  tracepoint may be enabled)
@@ -270,6 +278,8 @@ enum {
 enum {
 	FTRACE_EVENT_FL_ENABLED		= (1 << FTRACE_EVENT_FL_ENABLED_BIT),
 	FTRACE_EVENT_FL_RECORDED_CMD	= (1 << FTRACE_EVENT_FL_RECORDED_CMD_BIT),
+	FTRACE_EVENT_FL_FILTERED	= (1 << FTRACE_EVENT_FL_FILTERED_BIT),
+	FTRACE_EVENT_FL_NO_SET_FILTER	= (1 << FTRACE_EVENT_FL_NO_SET_FILTER_BIT),
 	FTRACE_EVENT_FL_SOFT_MODE	= (1 << FTRACE_EVENT_FL_SOFT_MODE_BIT),
 	FTRACE_EVENT_FL_SOFT_DISABLED	= (1 << FTRACE_EVENT_FL_SOFT_DISABLED_BIT),
 	FTRACE_EVENT_FL_TRIGGER_MODE	= (1 << FTRACE_EVENT_FL_TRIGGER_MODE_BIT),
@@ -278,6 +288,7 @@ enum {
 struct ftrace_event_file {
 	struct list_head		list;
 	struct ftrace_event_call	*event_call;
+	struct event_filter		*filter;
 	struct dentry			*dir;
 	struct trace_array		*tr;
 	struct ftrace_subsystem_dir	*system;
@@ -288,8 +299,10 @@ struct ftrace_event_file {
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
@@ -324,17 +337,27 @@ enum trigger_mode {
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
index be913f1..12d89fc 100644
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
index 5a61dbe..2aabd34 100644
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
 cycle_t buffer_ftrace_now(struct trace_buffer *buf, int cpu)
 {
 	u64 ts;
@@ -1630,7 +1622,7 @@ trace_function(struct trace_array *tr,
 	entry->ip			= ip;
 	entry->parent_ip		= parent_ip;
 
-	if (!filter_check_discard(call, entry, buffer, event))
+	if (!call_filter_check_discard(call, entry, buffer, event))
 		__buffer_unlock_commit(buffer, event);
 }
 
@@ -1714,7 +1706,7 @@ static void __ftrace_trace_stack(struct ring_buffer *buffer,
 
 	entry->size = trace.nr_entries;
 
-	if (!filter_check_discard(call, entry, buffer, event))
+	if (!call_filter_check_discard(call, entry, buffer, event))
 		__buffer_unlock_commit(buffer, event);
 
  out:
@@ -1816,7 +1808,7 @@ ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags, int pc)
 	trace.entries		= entry->caller;
 
 	save_stack_trace_user(&trace);
-	if (!filter_check_discard(call, entry, buffer, event))
+	if (!call_filter_check_discard(call, entry, buffer, event))
 		__buffer_unlock_commit(buffer, event);
 
  out_drop_count:
@@ -2008,7 +2000,7 @@ int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
 	entry->fmt			= fmt;
 
 	memcpy(entry->buf, tbuffer, sizeof(u32) * len);
-	if (!filter_check_discard(call, entry, buffer, event)) {
+	if (!call_filter_check_discard(call, entry, buffer, event)) {
 		__buffer_unlock_commit(buffer, event);
 		ftrace_trace_stack(buffer, flags, 6, pc);
 	}
@@ -2063,7 +2055,7 @@ __trace_array_vprintk(struct ring_buffer *buffer,
 
 	memcpy(&entry->buf, tbuffer, len);
 	entry->buf[len] = '\0';
-	if (!filter_check_discard(call, entry, buffer, event)) {
+	if (!call_filter_check_discard(call, entry, buffer, event)) {
 		__buffer_unlock_commit(buffer, event);
 		ftrace_trace_stack(buffer, flags, 6, pc);
 	}
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 5cf3eb2..415538c 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -985,9 +985,9 @@ struct filter_pred {
 
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
@@ -1003,9 +1003,9 @@ struct ftrace_event_field *
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
index 0a1e29f..abd208d 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -990,7 +990,7 @@ static ssize_t
 event_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
 		  loff_t *ppos)
 {
-	struct ftrace_event_call *call;
+	struct ftrace_event_file *file;
 	struct trace_seq *s;
 	int r = -ENODEV;
 
@@ -1005,12 +1005,12 @@ event_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
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
@@ -1022,7 +1022,7 @@ static ssize_t
 event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 		   loff_t *ppos)
 {
-	struct ftrace_event_call *call;
+	struct ftrace_event_file *file;
 	char *buf;
 	int err = -ENODEV;
 
@@ -1040,9 +1040,9 @@ event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
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
@@ -1545,7 +1545,7 @@ event_create_dir(struct dentry *parent,
 			return -1;
 		}
 	}
-	trace_create_file("filter", 0644, file->dir, call,
+	trace_create_file("filter", 0644, file->dir, file,
 			  filter);
 
 	trace_create_file("trigger", 0644, file->dir, file,
@@ -1586,6 +1586,10 @@ static void event_remove(struct ftrace_event_call *call)
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
@@ -1719,7 +1723,7 @@ static void __trace_remove_event_call(struct ftrace_event_call *call)
 {
 	event_remove(call);
 	trace_destroy_fields(call);
-	destroy_preds(call);
+	destroy_call_preds(call);
 }
 
 static int probe_remove_event_call(struct ftrace_event_call *call)
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 0c45aa1..af55a84 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -638,9 +638,14 @@ static void append_filter_err(struct filter_parse_state *ps,
 }
 
 /* caller must hold event_mutex */
-void print_event_filter(struct ftrace_event_call *call, struct trace_seq *s)
+void print_event_filter(struct ftrace_event_file *file, struct trace_seq *s)
 {
-	struct event_filter *filter = call->filter;
+	struct event_filter *filter;
+
+	if (file->event_call->flags & TRACE_EVENT_FL_USE_CALL_FILTER)
+		filter = file->event_call->filter;
+	else
+		filter = file->filter;
 
 	if (filter && filter->filter_string)
 		trace_seq_printf(s, "%s\n", filter->filter_string);
@@ -766,7 +771,12 @@ static void __free_preds(struct event_filter *filter)
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
@@ -787,12 +797,24 @@ void free_event_filter(struct event_filter *filter)
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
@@ -830,28 +852,44 @@ static int __alloc_preds(struct event_filter *filter, int n_preds)
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
 
@@ -1628,9 +1666,11 @@ struct filter_list {
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
@@ -1638,8 +1678,8 @@ static int replace_system_preds(struct event_subsystem *system,
 	bool fail = true;
 	int err;
 
-	list_for_each_entry(call, &ftrace_events, list) {
-
+	list_for_each_entry(file, &tr->events, list) {
+		call = file->event_call;
 		if (strcmp(call->class->system, system->name) != 0)
 			continue;
 
@@ -1648,21 +1688,34 @@ static int replace_system_preds(struct event_subsystem *system,
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
@@ -1681,17 +1734,29 @@ static int replace_system_preds(struct event_subsystem *system,
 
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
@@ -1829,6 +1894,7 @@ int create_event_filter(struct ftrace_event_call *call,
  * and always remembers @filter_str.
  */
 static int create_system_filter(struct event_subsystem *system,
+				struct trace_array *tr,
 				char *filter_str, struct event_filter **filterp)
 {
 	struct event_filter *filter = NULL;
@@ -1837,7 +1903,7 @@ static int create_system_filter(struct event_subsystem *system,
 
 	err = create_filter_start(filter_str, true, &ps, &filter);
 	if (!err) {
-		err = replace_system_preds(system, ps, filter_str);
+		err = replace_system_preds(system, tr, ps, filter_str);
 		if (!err) {
 			/* System filters just show a default message */
 			kfree(filter->filter_string);
@@ -1853,17 +1919,29 @@ static int create_system_filter(struct event_subsystem *system,
 }
 
 /* caller must hold event_mutex */
-int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
+int apply_event_filter(struct ftrace_event_file *file, char *filter_string)
 {
+	struct ftrace_event_call *call = file->event_call;
 	struct event_filter *filter;
+	bool use_call_filter;
 	int err;
 
+	use_call_filter = call->flags & TRACE_EVENT_FL_USE_CALL_FILTER;
+
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
 			return 0;
-		RCU_INIT_POINTER(call->filter, NULL);
+		if (use_call_filter)
+			RCU_INIT_POINTER(call->filter, NULL);
+		else
+			RCU_INIT_POINTER(file->filter, NULL);
 		/* Make sure the filter is not being used */
 		synchronize_sched();
 		__free_filter(filter);
@@ -1879,14 +1957,25 @@ int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
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
@@ -1902,6 +1991,7 @@ int apply_subsystem_event_filter(struct ftrace_subsystem_dir *dir,
 				 char *filter_string)
 {
 	struct event_subsystem *system = dir->subsystem;
+	struct trace_array *tr = dir->tr;
 	struct event_filter *filter;
 	int err = 0;
 
@@ -1914,18 +2004,18 @@ int apply_subsystem_event_filter(struct ftrace_subsystem_dir *dir,
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
index b5c0924..7d2fcd7 100644
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
index 879285f..1d0f761 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -326,11 +326,9 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
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
@@ -351,8 +349,7 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 
 	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
 		ring_buffer_discard_commit(buffer, event);
-	else if (!filter_current_check_discard(buffer, sys_data->enter_event,
-					       entry, event))
+	else if (!filter_check_discard(ftrace_file, entry, buffer, event))
 		trace_current_buffer_unlock_commit(buffer, event,
 						   irq_flags, pc);
 	if (__tm)
@@ -409,8 +406,7 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 
 	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
 		ring_buffer_discard_commit(buffer, event);
-	else if (!filter_current_check_discard(buffer, sys_data->exit_event,
-					       entry, event))
+	else if (!filter_check_discard(ftrace_file, entry, buffer, event))
 		trace_current_buffer_unlock_commit(buffer, event,
 						   irq_flags, pc);
 	if (__tm)
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
1.7.11.4

