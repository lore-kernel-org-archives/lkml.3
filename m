Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760654Ab3GaRhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 13:37:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760622Ab3GaRhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 13:37:00 -0400
Date: Wed, 31 Jul 2013 19:31:35 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] tracing: Don't pass file_operations array to
	event_create_dir()
Message-ID: <20130731173135.GA31040@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130731173116.GA31018@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that event_create_dir() and __trace_add_new_event() always
use the same file_operations we can kill these arguments and
simplify the code.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_events.c |   46 +++++++++++-------------------------------
 1 files changed, 12 insertions(+), 34 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 5fcd18b..77ef314 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1485,12 +1485,7 @@ event_subsystem_dir(struct trace_array *tr, const char *name,
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
@@ -1518,12 +1513,13 @@ event_create_dir(struct dentry *parent,
 
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
@@ -1540,10 +1536,10 @@ event_create_dir(struct dentry *parent,
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
@@ -1644,12 +1640,7 @@ trace_create_new_event(struct ftrace_event_call *call,
 
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
 
@@ -1657,7 +1648,7 @@ __trace_add_new_event(struct ftrace_event_call *call,
 	if (!file)
 		return -ENOMEM;
 
-	return event_create_dir(tr->event_dir, file, id, enable, filter, format);
+	return event_create_dir(tr->event_dir, file);
 }
 
 /*
@@ -1835,11 +1826,7 @@ __trace_add_event_dirs(struct trace_array *tr)
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
@@ -2147,11 +2134,7 @@ __trace_early_add_event_dirs(struct trace_array *tr)
 
 
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
@@ -2196,13 +2179,8 @@ static void __add_event_to_tracers(struct ftrace_event_call *call)
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
1.5.5.1

