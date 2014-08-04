Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbaHDO7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:59:33 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:56374 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753004AbaHDO7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:59:31 -0400
Date: Mon, 4 Aug 2014 10:59:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Subject: [GIT PULL] tracing: Clean ups for tracing filter for 3.17
Message-ID: <20140804105926.3f28992f@gandalf.local.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Oleg Nesterov did several clean ups with the tracing filter code.
As he found some small bugs that went into 3.16, and these changes were
based on that, I had to apply his changes to a separate branch than
my main development branch.

This was based on work that was already pulled into 3.16, and is a
separate pull request to keep from having local merges in my pull
request.

Please pull the latest trace-3.17-2 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-3.17-2

Tag SHA1: 53cf4ddf4de60141e6c01501eb736c1aca1a44ec
Head SHA1: 6355d54438bfc3b636cb6453cd091f782fb9b4d7


Oleg Nesterov (7):
      tracing: Kill destroy_preds() and destroy_file_preds()
      tracing: Kill destroy_call_preds()
      tracing: Kill call_filter_disable()
      tracing/uprobes: Kill the dead TRACE_EVENT_FL_USE_CALL_FILTER logic
      tracing: Kill ftrace_event_call->files
      tracing: Change apply_subsystem_event_filter() paths to check file->system == dir
      tracing: Kill "filter_string" arg of replace_preds()

----
 include/linux/ftrace_event.h       |  3 --
 kernel/trace/trace_events.c        |  4 +--
 kernel/trace/trace_events_filter.c | 73 +++++++++-----------------------------
 kernel/trace/trace_uprobe.c        |  3 +-
 4 files changed, 19 insertions(+), 64 deletions(-)
---------------------------
diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index cff3106ffe2c..06c6faa9e5cc 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -272,7 +272,6 @@ struct ftrace_event_call {
 	struct trace_event	event;
 	const char		*print_fmt;
 	struct event_filter	*filter;
-	struct list_head	*files;
 	void			*mod;
 	void			*data;
 	/*
@@ -404,8 +403,6 @@ enum event_trigger_type {
 	ETT_EVENT_ENABLE	= (1 << 3),
 };
 
-extern void destroy_preds(struct ftrace_event_file *file);
-extern void destroy_call_preds(struct ftrace_event_call *call);
 extern int filter_match_preds(struct event_filter *filter, void *rec);
 
 extern int filter_check_discard(struct ftrace_event_file *file, void *rec,
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 2de53628689f..0d8ee29f6b9a 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1621,7 +1621,6 @@ static void event_remove(struct ftrace_event_call *call)
 		if (file->event_call != call)
 			continue;
 		ftrace_event_enable_disable(file, 0);
-		destroy_preds(file);
 		/*
 		 * The do_for_each_event_file() is
 		 * a double loop. After finding the call for this
@@ -1749,7 +1748,8 @@ static void __trace_remove_event_call(struct ftrace_event_call *call)
 {
 	event_remove(call);
 	trace_destroy_fields(call);
-	destroy_call_preds(call);
+	free_event_filter(call->filter);
+	call->filter = NULL;
 }
 
 static int probe_remove_event_call(struct ftrace_event_call *call)
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 8a8631926a07..7a8c1528e141 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -774,17 +774,12 @@ static void __free_preds(struct event_filter *filter)
 	filter->n_preds = 0;
 }
 
-static void call_filter_disable(struct ftrace_event_call *call)
-{
-	call->flags &= ~TRACE_EVENT_FL_FILTERED;
-}
-
 static void filter_disable(struct ftrace_event_file *file)
 {
 	struct ftrace_event_call *call = file->event_call;
 
 	if (call->flags & TRACE_EVENT_FL_USE_CALL_FILTER)
-		call_filter_disable(call);
+		call->flags &= ~TRACE_EVENT_FL_FILTERED;
 	else
 		file->flags &= ~FTRACE_EVENT_FL_FILTERED;
 }
@@ -804,32 +799,6 @@ void free_event_filter(struct event_filter *filter)
 	__free_filter(filter);
 }
 
-void destroy_call_preds(struct ftrace_event_call *call)
-{
-	__free_filter(call->filter);
-	call->filter = NULL;
-}
-
-static void destroy_file_preds(struct ftrace_event_file *file)
-{
-	__free_filter(file->filter);
-	file->filter = NULL;
-}
-
-/*
- * Called when destroying the ftrace_event_file.
- * The file is being freed, so we do not need to worry about
- * the file being currently used. This is for module code removing
- * the tracepoints from within it.
- */
-void destroy_preds(struct ftrace_event_file *file)
-{
-	if (file->event_call->flags & TRACE_EVENT_FL_USE_CALL_FILTER)
-		destroy_call_preds(file->event_call);
-	else
-		destroy_file_preds(file);
-}
-
 static struct event_filter *__alloc_filter(void)
 {
 	struct event_filter *filter;
@@ -873,17 +842,14 @@ static inline void __remove_filter(struct ftrace_event_file *file)
 		remove_filter_string(file->filter);
 }
 
-static void filter_free_subsystem_preds(struct event_subsystem *system,
+static void filter_free_subsystem_preds(struct ftrace_subsystem_dir *dir,
 					struct trace_array *tr)
 {
 	struct ftrace_event_file *file;
-	struct ftrace_event_call *call;
 
 	list_for_each_entry(file, &tr->events, list) {
-		call = file->event_call;
-		if (strcmp(call->class->system, system->name) != 0)
+		if (file->system != dir)
 			continue;
-
 		__remove_filter(file);
 	}
 }
@@ -901,15 +867,13 @@ static inline void __free_subsystem_filter(struct ftrace_event_file *file)
 	}
 }
 
-static void filter_free_subsystem_filters(struct event_subsystem *system,
+static void filter_free_subsystem_filters(struct ftrace_subsystem_dir *dir,
 					  struct trace_array *tr)
 {
 	struct ftrace_event_file *file;
-	struct ftrace_event_call *call;
 
 	list_for_each_entry(file, &tr->events, list) {
-		call = file->event_call;
-		if (strcmp(call->class->system, system->name) != 0)
+		if (file->system != dir)
 			continue;
 		__free_subsystem_filter(file);
 	}
@@ -1582,7 +1546,6 @@ static int fold_pred_tree(struct event_filter *filter,
 static int replace_preds(struct ftrace_event_call *call,
 			 struct event_filter *filter,
 			 struct filter_parse_state *ps,
-			 char *filter_string,
 			 bool dry_run)
 {
 	char *operand1 = NULL, *operand2 = NULL;
@@ -1755,13 +1718,12 @@ struct filter_list {
 	struct event_filter	*filter;
 };
 
-static int replace_system_preds(struct event_subsystem *system,
+static int replace_system_preds(struct ftrace_subsystem_dir *dir,
 				struct trace_array *tr,
 				struct filter_parse_state *ps,
 				char *filter_string)
 {
 	struct ftrace_event_file *file;
-	struct ftrace_event_call *call;
 	struct filter_list *filter_item;
 	struct filter_list *tmp;
 	LIST_HEAD(filter_list);
@@ -1769,15 +1731,14 @@ static int replace_system_preds(struct event_subsystem *system,
 	int err;
 
 	list_for_each_entry(file, &tr->events, list) {
-		call = file->event_call;
-		if (strcmp(call->class->system, system->name) != 0)
+		if (file->system != dir)
 			continue;
 
 		/*
 		 * Try to see if the filter can be applied
 		 *  (filter arg is ignored on dry_run)
 		 */
-		err = replace_preds(call, NULL, ps, filter_string, true);
+		err = replace_preds(file->event_call, NULL, ps, true);
 		if (err)
 			event_set_no_set_filter_flag(file);
 		else
@@ -1787,9 +1748,7 @@ static int replace_system_preds(struct event_subsystem *system,
 	list_for_each_entry(file, &tr->events, list) {
 		struct event_filter *filter;
 
-		call = file->event_call;
-
-		if (strcmp(call->class->system, system->name) != 0)
+		if (file->system != dir)
 			continue;
 
 		if (event_no_set_filter_flag(file))
@@ -1811,7 +1770,7 @@ static int replace_system_preds(struct event_subsystem *system,
 		if (err)
 			goto fail_mem;
 
-		err = replace_preds(call, filter, ps, filter_string, false);
+		err = replace_preds(file->event_call, filter, ps, false);
 		if (err) {
 			filter_disable(file);
 			parse_error(ps, FILT_ERR_BAD_SUBSYS_FILTER, 0);
@@ -1933,7 +1892,7 @@ static int create_filter(struct ftrace_event_call *call,
 
 	err = create_filter_start(filter_str, set_str, &ps, &filter);
 	if (!err) {
-		err = replace_preds(call, filter, ps, filter_str, false);
+		err = replace_preds(call, filter, ps, false);
 		if (err && set_str)
 			append_filter_err(ps, filter);
 	}
@@ -1959,7 +1918,7 @@ int create_event_filter(struct ftrace_event_call *call,
  * Identical to create_filter() except that it creates a subsystem filter
  * and always remembers @filter_str.
  */
-static int create_system_filter(struct event_subsystem *system,
+static int create_system_filter(struct ftrace_subsystem_dir *dir,
 				struct trace_array *tr,
 				char *filter_str, struct event_filter **filterp)
 {
@@ -1969,7 +1928,7 @@ static int create_system_filter(struct event_subsystem *system,
 
 	err = create_filter_start(filter_str, true, &ps, &filter);
 	if (!err) {
-		err = replace_system_preds(system, tr, ps, filter_str);
+		err = replace_system_preds(dir, tr, ps, filter_str);
 		if (!err) {
 			/* System filters just show a default message */
 			kfree(filter->filter_string);
@@ -2053,18 +2012,18 @@ int apply_subsystem_event_filter(struct ftrace_subsystem_dir *dir,
 	}
 
 	if (!strcmp(strstrip(filter_string), "0")) {
-		filter_free_subsystem_preds(system, tr);
+		filter_free_subsystem_preds(dir, tr);
 		remove_filter_string(system->filter);
 		filter = system->filter;
 		system->filter = NULL;
 		/* Ensure all filters are no longer used */
 		synchronize_sched();
-		filter_free_subsystem_filters(system, tr);
+		filter_free_subsystem_filters(dir, tr);
 		__free_filter(filter);
 		goto out_unlock;
 	}
 
-	err = create_system_filter(system, tr, filter_string, &filter);
+	err = create_system_filter(dir, tr, filter_string, &filter);
 	if (filter) {
 		/*
 		 * No event actually uses the system filter
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 3c9b97e6b1f4..33ff6a24b802 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -265,7 +265,6 @@ alloc_trace_uprobe(const char *group, const char *event, int nargs, bool is_ret)
 	if (is_ret)
 		tu->consumer.ret_handler = uretprobe_dispatcher;
 	init_trace_uprobe_filter(&tu->filter);
-	tu->tp.call.flags |= TRACE_EVENT_FL_USE_CALL_FILTER;
 	return tu;
 
 error:
@@ -1292,7 +1291,7 @@ static int register_uprobe_event(struct trace_uprobe *tu)
 		kfree(call->print_fmt);
 		return -ENODEV;
 	}
-	call->flags = 0;
+
 	call->class->reg = trace_uprobe_register;
 	call->data = tu;
 	ret = trace_add_event_call(call);
