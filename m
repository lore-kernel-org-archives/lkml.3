Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933202AbaGOSuX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 14:50:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933176AbaGOSuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 14:50:16 -0400
Date: Tue, 15 Jul 2014 20:48:29 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/7] tracing: change apply_subsystem_event_filter()
	paths to check file->system == dir
Message-ID: <20140715184829.GA20516@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140715184753.GA20470@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

filter_free_subsystem_preds(), filter_free_subsystem_filters() and
replace_system_preds() can simply check file->system->subsystem and
avoid strcmp(call->class->system).

Better yet, we can pass "struct ftrace_subsystem_dir *dir" instead of
event_subsystem and just check file->system == dir.

Thanks to Namhyung Kim who pointed out that replace_system_preds() can
be changed too.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_events_filter.c |   39 ++++++++++++++---------------------
 1 files changed, 16 insertions(+), 23 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 54a125c..c2ef5a5 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -842,17 +842,14 @@ static inline void __remove_filter(struct ftrace_event_file *file)
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
@@ -870,15 +867,13 @@ static inline void __free_subsystem_filter(struct ftrace_event_file *file)
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
@@ -1724,13 +1719,12 @@ struct filter_list {
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
@@ -1738,15 +1732,15 @@ static int replace_system_preds(struct event_subsystem *system,
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
+		err = replace_preds(file->event_call, NULL, ps,
+					filter_string, true);
 		if (err)
 			event_set_no_set_filter_flag(file);
 		else
@@ -1756,9 +1750,7 @@ static int replace_system_preds(struct event_subsystem *system,
 	list_for_each_entry(file, &tr->events, list) {
 		struct event_filter *filter;
 
-		call = file->event_call;
-
-		if (strcmp(call->class->system, system->name) != 0)
+		if (file->system != dir)
 			continue;
 
 		if (event_no_set_filter_flag(file))
@@ -1780,7 +1772,8 @@ static int replace_system_preds(struct event_subsystem *system,
 		if (err)
 			goto fail_mem;
 
-		err = replace_preds(call, filter, ps, filter_string, false);
+		err = replace_preds(file->event_call, filter, ps,
+					filter_string, false);
 		if (err) {
 			filter_disable(file);
 			parse_error(ps, FILT_ERR_BAD_SUBSYS_FILTER, 0);
@@ -1928,7 +1921,7 @@ int create_event_filter(struct ftrace_event_call *call,
  * Identical to create_filter() except that it creates a subsystem filter
  * and always remembers @filter_str.
  */
-static int create_system_filter(struct event_subsystem *system,
+static int create_system_filter(struct ftrace_subsystem_dir *dir,
 				struct trace_array *tr,
 				char *filter_str, struct event_filter **filterp)
 {
@@ -1938,7 +1931,7 @@ static int create_system_filter(struct event_subsystem *system,
 
 	err = create_filter_start(filter_str, true, &ps, &filter);
 	if (!err) {
-		err = replace_system_preds(system, tr, ps, filter_str);
+		err = replace_system_preds(dir, tr, ps, filter_str);
 		if (!err) {
 			/* System filters just show a default message */
 			kfree(filter->filter_string);
@@ -2022,18 +2015,18 @@ int apply_subsystem_event_filter(struct ftrace_subsystem_dir *dir,
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
-- 
1.5.5.1

