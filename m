Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab3HVQfN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 12:35:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24138 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143Ab3HVQeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 12:34:22 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=k_e3pDTibPgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=KOk3MvMldSgA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=RLoQmpYfAAAA:8 a=y2eCTN-h7zFfK6B0x2MA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=fXSdFxVoPP8A:10 a=_xe8Oq-P-xYK-SQU:21 a=zfWUGb8uZcTE3p2B:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130822163420.472968340@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 22 Aug 2013 12:32:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [for-next][PATCH 3/5] tracing: Kill trace_create_file_ops() and friends
References: <20130822163225.773134216@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Kill-trace_create_file_ops-and-friends.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

trace_create_file_ops() allocates the copy of id/filter/format/enable
file_operations to set "f_op->owner = mod" for fops_get().

However after the recent changes there is no reason to prevent rmmod
even if one of these files is opened. A file operation can do nothing
but fail after remove_event_file_dir() clears ->i_private for every
file removed by trace_module_remove_events().

Kill "struct ftrace_module_file_ops" and fix the compilation errors.

Link: http://lkml.kernel.org/r/20130731173132.GA31033@redhat.com

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |  153 +++----------------------------------------
 1 file changed, 9 insertions(+), 144 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 29a7ebc..2ec8273 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1683,8 +1683,7 @@ __trace_early_add_new_event(struct ftrace_event_call *call,
 }
 
 struct ftrace_module_file_ops;
-static void __add_event_to_tracers(struct ftrace_event_call *call,
-				   struct ftrace_module_file_ops *file_ops);
+static void __add_event_to_tracers(struct ftrace_event_call *call);
 
 /* Add an additional event_call dynamically */
 int trace_add_event_call(struct ftrace_event_call *call)
@@ -1695,7 +1694,7 @@ int trace_add_event_call(struct ftrace_event_call *call)
 
 	ret = __register_event(call, NULL);
 	if (ret >= 0)
-		__add_event_to_tracers(call, NULL);
+		__add_event_to_tracers(call);
 
 	mutex_unlock(&event_mutex);
 	mutex_unlock(&trace_types_lock);
@@ -1769,100 +1768,21 @@ int trace_remove_event_call(struct ftrace_event_call *call)
 
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
 
@@ -1874,16 +1794,6 @@ static void trace_module_remove_events(struct module *mod)
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
@@ -1919,62 +1829,22 @@ static int trace_module_notify(struct notifier_block *self,
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
@@ -2332,21 +2202,16 @@ __trace_remove_event_dirs(struct trace_array *tr)
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
1.7.10.4


