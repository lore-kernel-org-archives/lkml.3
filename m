Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab3HVQev (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 12:34:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8416 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab3HVQeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 12:34:22 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=B1UkUieN6IIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=rAPDFgbypYMA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=-rGJlggtklWnS4aP220A:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130822163420.626975502@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 22 Aug 2013 12:32:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [for-next][PATCH 4/5] tracing: Dont pass file_operations array to event_create_dir()
References: <20130822163225.773134216@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Don-t-pass-file_operations-array-to-event_cr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

Now that event_create_dir() and __trace_add_new_event() always
use the same file_operations we can kill these arguments and
simplify the code.

Link: http://lkml.kernel.org/r/20130731173135.GA31040@redhat.com

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |   46 +++++++++++--------------------------------
 1 file changed, 12 insertions(+), 34 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 2ec8273..4e706a0 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1489,12 +1489,7 @@ event_subsystem_dir(struct trace_array *tr, const char *name,
 }
 
 static int
-event_create_dir(struct dentry *parent,
-		 struct ftrace_event_file *file,
-		 const struct file_operations *id,
-		 const struct file_operations *enable,
-		 const struct file_operations *filter,
-		 const struct file_operations *format)
+event_create_dir(struct dentry *parent, struct ftrace_event_file *file)
 {
 	struct ftrace_event_call *call = file->event_call;
 	struct trace_array *tr = file->tr;
@@ -1522,12 +1517,13 @@ event_create_dir(struct dentry *parent,
 
 	if (call->class->reg && !(call->flags & TRACE_EVENT_FL_IGNORE_ENABLE))
 		trace_create_file("enable", 0644, file->dir, file,
-				  enable);
+				  &ftrace_enable_fops);
 
 #ifdef CONFIG_PERF_EVENTS
 	if (call->event.type && call->class->reg)
 		trace_create_file("id", 0444, file->dir,
-				  (void *)(long)call->event.type, id);
+				  (void *)(long)call->event.type,
+				  &ftrace_event_id_fops);
 #endif
 
 	/*
@@ -1544,10 +1540,10 @@ event_create_dir(struct dentry *parent,
 		}
 	}
 	trace_create_file("filter", 0644, file->dir, call,
-			  filter);
+			  &ftrace_event_filter_fops);
 
 	trace_create_file("format", 0444, file->dir, call,
-			  format);
+			  &ftrace_event_format_fops);
 
 	return 0;
 }
@@ -1648,12 +1644,7 @@ trace_create_new_event(struct ftrace_event_call *call,
 
 /* Add an event to a trace directory */
 static int
-__trace_add_new_event(struct ftrace_event_call *call,
-		      struct trace_array *tr,
-		      const struct file_operations *id,
-		      const struct file_operations *enable,
-		      const struct file_operations *filter,
-		      const struct file_operations *format)
+__trace_add_new_event(struct ftrace_event_call *call, struct trace_array *tr)
 {
 	struct ftrace_event_file *file;
 
@@ -1661,7 +1652,7 @@ __trace_add_new_event(struct ftrace_event_call *call,
 	if (!file)
 		return -ENOMEM;
 
-	return event_create_dir(tr->event_dir, file, id, enable, filter, format);
+	return event_create_dir(tr->event_dir, file);
 }
 
 /*
@@ -1845,11 +1836,7 @@ __trace_add_event_dirs(struct trace_array *tr)
 	int ret;
 
 	list_for_each_entry(call, &ftrace_events, list) {
-		ret = __trace_add_new_event(call, tr,
-					    &ftrace_event_id_fops,
-					    &ftrace_enable_fops,
-					    &ftrace_event_filter_fops,
-					    &ftrace_event_format_fops);
+		ret = __trace_add_new_event(call, tr);
 		if (ret < 0)
 			pr_warning("Could not create directory for event %s\n",
 				   call->name);
@@ -2157,11 +2144,7 @@ __trace_early_add_event_dirs(struct trace_array *tr)
 
 
 	list_for_each_entry(file, &tr->events, list) {
-		ret = event_create_dir(tr->event_dir, file,
-				       &ftrace_event_id_fops,
-				       &ftrace_enable_fops,
-				       &ftrace_event_filter_fops,
-				       &ftrace_event_format_fops);
+		ret = event_create_dir(tr->event_dir, file);
 		if (ret < 0)
 			pr_warning("Could not create directory for event %s\n",
 				   file->event_call->name);
@@ -2206,13 +2189,8 @@ static void __add_event_to_tracers(struct ftrace_event_call *call)
 {
 	struct trace_array *tr;
 
-	list_for_each_entry(tr, &ftrace_trace_arrays, list) {
-		__trace_add_new_event(call, tr,
-				      &ftrace_event_id_fops,
-				      &ftrace_enable_fops,
-				      &ftrace_event_filter_fops,
-				      &ftrace_event_format_fops);
-	}
+	list_for_each_entry(tr, &ftrace_trace_arrays, list)
+		__trace_add_new_event(call, tr);
 }
 
 static struct notifier_block trace_module_nb = {
-- 
1.7.10.4


