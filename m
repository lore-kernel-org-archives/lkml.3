Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760617Ab3GaRg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 13:36:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760595Ab3GaRgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 13:36:55 -0400
Date: Wed, 31 Jul 2013 19:31:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] tracing: Kill trace_create_file_ops() and friends
Message-ID: <20130731173132.GA31033@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130731173116.GA31018@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

trace_create_file_ops() allocates the copy of id/filter/format/enable
file_operations to set "f_op->owner = mod" for fops_get().

However after the recent changes there is no reason to prevent rmmod
even if one of these files is opened. A file operation can do nothing
but fail after remove_event_file_dir() clears ->i_private for every
file removed by trace_module_remove_events().

Kill "struct ftrace_module_file_ops" and fix the compilation errors.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_events.c |  153 +++----------------------------------------
 1 files changed, 9 insertions(+), 144 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 3450496..5fcd18b 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1679,8 +1679,7 @@ __trace_early_add_new_event(struct ftrace_event_call *call,
 }
 
 struct ftrace_module_file_ops;
-static void __add_event_to_tracers(struct ftrace_event_call *call,
-				   struct ftrace_module_file_ops *file_ops);
+static void __add_event_to_tracers(struct ftrace_event_call *call);
 
 /* Add an additional event_call dynamically */
 int trace_add_event_call(struct ftrace_event_call *call)
@@ -1691,7 +1690,7 @@ int trace_add_event_call(struct ftrace_event_call *call)
 
 	ret = __register_event(call, NULL);
 	if (ret >= 0)
-		__add_event_to_tracers(call, NULL);
+		__add_event_to_tracers(call);
 
 	mutex_unlock(&event_mutex);
 	mutex_unlock(&trace_types_lock);
@@ -1759,100 +1758,21 @@ int trace_remove_event_call(struct ftrace_event_call *call)
 
 #ifdef CONFIG_MODULES
 
-static LIST_HEAD(ftrace_module_file_list);
-
-/*
- * Modules must own their file_operations to keep up with
- * reference counting.
- */
-struct ftrace_module_file_ops {
-	struct list_head		list;
-	struct module			*mod;
-	struct file_operations		id;
-	struct file_operations		enable;
-	struct file_operations		format;
-	struct file_operations		filter;
-};
-
-static struct ftrace_module_file_ops *
-find_ftrace_file_ops(struct ftrace_module_file_ops *file_ops, struct module *mod)
-{
-	/*
-	 * As event_calls are added in groups by module,
-	 * when we find one file_ops, we don't need to search for
-	 * each call in that module, as the rest should be the
-	 * same. Only search for a new one if the last one did
-	 * not match.
-	 */
-	if (file_ops && mod == file_ops->mod)
-		return file_ops;
-
-	list_for_each_entry(file_ops, &ftrace_module_file_list, list) {
-		if (file_ops->mod == mod)
-			return file_ops;
-	}
-	return NULL;
-}
-
-static struct ftrace_module_file_ops *
-trace_create_file_ops(struct module *mod)
-{
-	struct ftrace_module_file_ops *file_ops;
-
-	/*
-	 * This is a bit of a PITA. To allow for correct reference
-	 * counting, modules must "own" their file_operations.
-	 * To do this, we allocate the file operations that will be
-	 * used in the event directory.
-	 */
-
-	file_ops = kmalloc(sizeof(*file_ops), GFP_KERNEL);
-	if (!file_ops)
-		return NULL;
-
-	file_ops->mod = mod;
-
-	file_ops->id = ftrace_event_id_fops;
-	file_ops->id.owner = mod;
-
-	file_ops->enable = ftrace_enable_fops;
-	file_ops->enable.owner = mod;
-
-	file_ops->filter = ftrace_event_filter_fops;
-	file_ops->filter.owner = mod;
-
-	file_ops->format = ftrace_event_format_fops;
-	file_ops->format.owner = mod;
-
-	list_add(&file_ops->list, &ftrace_module_file_list);
-
-	return file_ops;
-}
-
 static void trace_module_add_events(struct module *mod)
 {
-	struct ftrace_module_file_ops *file_ops = NULL;
 	struct ftrace_event_call **call, **start, **end;
 
 	start = mod->trace_events;
 	end = mod->trace_events + mod->num_trace_events;
 
-	if (start == end)
-		return;
-
-	file_ops = trace_create_file_ops(mod);
-	if (!file_ops)
-		return;
-
 	for_each_event(call, start, end) {
 		__register_event(*call, mod);
-		__add_event_to_tracers(*call, file_ops);
+		__add_event_to_tracers(*call);
 	}
 }
 
 static void trace_module_remove_events(struct module *mod)
 {
-	struct ftrace_module_file_ops *file_ops;
 	struct ftrace_event_call *call, *p;
 	bool clear_trace = false;
 
@@ -1864,16 +1784,6 @@ static void trace_module_remove_events(struct module *mod)
 			__trace_remove_event_call(call);
 		}
 	}
-
-	/* Now free the file_operations */
-	list_for_each_entry(file_ops, &ftrace_module_file_list, list) {
-		if (file_ops->mod == mod)
-			break;
-	}
-	if (&file_ops->list != &ftrace_module_file_list) {
-		list_del(&file_ops->list);
-		kfree(file_ops);
-	}
 	up_write(&trace_event_sem);
 
 	/*
@@ -1909,62 +1819,22 @@ static int trace_module_notify(struct notifier_block *self,
 	return 0;
 }
 
-static int
-__trace_add_new_mod_event(struct ftrace_event_call *call,
-			  struct trace_array *tr,
-			  struct ftrace_module_file_ops *file_ops)
-{
-	return __trace_add_new_event(call, tr,
-				     &file_ops->id, &file_ops->enable,
-				     &file_ops->filter, &file_ops->format);
-}
-
 #else
-static inline struct ftrace_module_file_ops *
-find_ftrace_file_ops(struct ftrace_module_file_ops *file_ops, struct module *mod)
-{
-	return NULL;
-}
 static inline int trace_module_notify(struct notifier_block *self,
 				      unsigned long val, void *data)
 {
 	return 0;
 }
-static inline int
-__trace_add_new_mod_event(struct ftrace_event_call *call,
-			  struct trace_array *tr,
-			  struct ftrace_module_file_ops *file_ops)
-{
-	return -ENODEV;
-}
 #endif /* CONFIG_MODULES */
 
 /* Create a new event directory structure for a trace directory. */
 static void
 __trace_add_event_dirs(struct trace_array *tr)
 {
-	struct ftrace_module_file_ops *file_ops = NULL;
 	struct ftrace_event_call *call;
 	int ret;
 
 	list_for_each_entry(call, &ftrace_events, list) {
-		if (call->mod) {
-			/*
-			 * Directories for events by modules need to
-			 * keep module ref counts when opened (as we don't
-			 * want the module to disappear when reading one
-			 * of these files). The file_ops keep account of
-			 * the module ref count.
-			 */
-			file_ops = find_ftrace_file_ops(file_ops, call->mod);
-			if (!file_ops)
-				continue; /* Warn? */
-			ret = __trace_add_new_mod_event(call, tr, file_ops);
-			if (ret < 0)
-				pr_warning("Could not create directory for event %s\n",
-					   call->name);
-			continue;
-		}
 		ret = __trace_add_new_event(call, tr,
 					    &ftrace_event_id_fops,
 					    &ftrace_enable_fops,
@@ -2322,21 +2192,16 @@ __trace_remove_event_dirs(struct trace_array *tr)
 		remove_event_file_dir(file);
 }
 
-static void
-__add_event_to_tracers(struct ftrace_event_call *call,
-		       struct ftrace_module_file_ops *file_ops)
+static void __add_event_to_tracers(struct ftrace_event_call *call)
 {
 	struct trace_array *tr;
 
 	list_for_each_entry(tr, &ftrace_trace_arrays, list) {
-		if (file_ops)
-			__trace_add_new_mod_event(call, tr, file_ops);
-		else
-			__trace_add_new_event(call, tr,
-					      &ftrace_event_id_fops,
-					      &ftrace_enable_fops,
-					      &ftrace_event_filter_fops,
-					      &ftrace_event_format_fops);
+		__trace_add_new_event(call, tr,
+				      &ftrace_event_id_fops,
+				      &ftrace_enable_fops,
+				      &ftrace_event_filter_fops,
+				      &ftrace_event_format_fops);
 	}
 }
 
-- 
1.5.5.1

