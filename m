Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbaC0EyU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 00:54:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:62662 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbaC0EyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 00:54:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,739,1389772800"; 
   d="scan'208";a="508628415"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH 2/5] tracing: Add event record param to trigger_ops.func()
Date: Wed, 26 Mar 2014 23:54:04 -0500
Message-Id: <157f83b74e7384bfdf7b3e58117cfab2aff0245d.1395894625.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1395894625.git.tom.zanussi@linux.intel.com>
References: <cover.1395894625.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1395894625.git.tom.zanussi@linux.intel.com>
References: <cover.1395894625.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some triggers may need access to the trace event, so pass it in.  Also
fix up the existing trigger funcs and their callers.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 include/linux/ftrace_event.h        |  7 ++++---
 kernel/trace/trace.h                |  6 ++++--
 kernel/trace/trace_events_trigger.c | 35 ++++++++++++++++++-----------------
 3 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 4cdb3a1..5961964 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -368,7 +368,8 @@ extern int call_filter_check_discard(struct ftrace_event_call *call, void *rec,
 extern enum event_trigger_type event_triggers_call(struct ftrace_event_file *file,
 						   void *rec);
 extern void event_triggers_post_call(struct ftrace_event_file *file,
-				     enum event_trigger_type tt);
+				     enum event_trigger_type tt,
+				     void *rec);
 
 /**
  * ftrace_trigger_soft_disabled - do triggers and test if soft disabled
@@ -451,7 +452,7 @@ event_trigger_unlock_commit(struct ftrace_event_file *file,
 		trace_buffer_unlock_commit(buffer, event, irq_flags, pc);
 
 	if (tt)
-		event_triggers_post_call(file, tt);
+		event_triggers_post_call(file, tt, entry);
 }
 
 /**
@@ -484,7 +485,7 @@ event_trigger_unlock_commit_regs(struct ftrace_event_file *file,
 						irq_flags, pc, regs);
 
 	if (tt)
-		event_triggers_post_call(file, tt);
+		event_triggers_post_call(file, tt, entry);
 }
 
 enum {
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 26c55ff..9032cf3 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1087,7 +1087,8 @@ struct event_trigger_data {
  * @func: The trigger 'probe' function called when the triggering
  *	event occurs.  The data passed into this callback is the data
  *	that was supplied to the event_command @reg() function that
- *	registered the trigger (see struct event_command).
+ *	registered the trigger (see struct event_command) along with
+ *	the trace record, rec.
  *
  * @init: An optional initialization function called for the trigger
  *	when the trigger is registered (via the event_command reg()
@@ -1112,7 +1113,8 @@ struct event_trigger_data {
  *	(see trace_event_triggers.c).
  */
 struct event_trigger_ops {
-	void			(*func)(struct event_trigger_data *data);
+	void			(*func)(struct event_trigger_data *data,
+					void *rec);
 	int			(*init)(struct event_trigger_ops *ops,
 					struct event_trigger_data *data);
 	void			(*free)(struct event_trigger_ops *ops,
diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index 8efbb69..323846e 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -74,7 +74,7 @@ event_triggers_call(struct ftrace_event_file *file, void *rec)
 
 	list_for_each_entry_rcu(data, &file->triggers, list) {
 		if (!rec) {
-			data->ops->func(data);
+			data->ops->func(data, rec);
 			continue;
 		}
 		filter = rcu_dereference(data->filter);
@@ -84,7 +84,7 @@ event_triggers_call(struct ftrace_event_file *file, void *rec)
 			tt |= data->cmd_ops->trigger_type;
 			continue;
 		}
-		data->ops->func(data);
+		data->ops->func(data, rec);
 	}
 	return tt;
 }
@@ -104,13 +104,14 @@ EXPORT_SYMBOL_GPL(event_triggers_call);
  */
 void
 event_triggers_post_call(struct ftrace_event_file *file,
-			 enum event_trigger_type tt)
+			 enum event_trigger_type tt,
+			 void *rec)
 {
 	struct event_trigger_data *data;
 
 	list_for_each_entry_rcu(data, &file->triggers, list) {
 		if (data->cmd_ops->trigger_type & tt)
-			data->ops->func(data);
+			data->ops->func(data, rec);
 	}
 }
 EXPORT_SYMBOL_GPL(event_triggers_post_call);
@@ -751,7 +752,7 @@ static int set_trigger_filter(char *filter_str,
 }
 
 static void
-traceon_trigger(struct event_trigger_data *data)
+traceon_trigger(struct event_trigger_data *data, void *rec)
 {
 	if (tracing_is_on())
 		return;
@@ -760,7 +761,7 @@ traceon_trigger(struct event_trigger_data *data)
 }
 
 static void
-traceon_count_trigger(struct event_trigger_data *data)
+traceon_count_trigger(struct event_trigger_data *data, void *rec)
 {
 	if (tracing_is_on())
 		return;
@@ -775,7 +776,7 @@ traceon_count_trigger(struct event_trigger_data *data)
 }
 
 static void
-traceoff_trigger(struct event_trigger_data *data)
+traceoff_trigger(struct event_trigger_data *data, void *rec)
 {
 	if (!tracing_is_on())
 		return;
@@ -784,7 +785,7 @@ traceoff_trigger(struct event_trigger_data *data)
 }
 
 static void
-traceoff_count_trigger(struct event_trigger_data *data)
+traceoff_count_trigger(struct event_trigger_data *data, void *rec)
 {
 	if (!tracing_is_on())
 		return;
@@ -880,13 +881,13 @@ static struct event_command trigger_traceoff_cmd = {
 
 #ifdef CONFIG_TRACER_SNAPSHOT
 static void
-snapshot_trigger(struct event_trigger_data *data)
+snapshot_trigger(struct event_trigger_data *data, void *rec)
 {
 	tracing_snapshot();
 }
 
 static void
-snapshot_count_trigger(struct event_trigger_data *data)
+snapshot_count_trigger(struct event_trigger_data *data, void *rec)
 {
 	if (!data->count)
 		return;
@@ -894,7 +895,7 @@ snapshot_count_trigger(struct event_trigger_data *data)
 	if (data->count != -1)
 		(data->count)--;
 
-	snapshot_trigger(data);
+	snapshot_trigger(data, rec);
 }
 
 static int
@@ -973,13 +974,13 @@ static __init int register_trigger_snapshot_cmd(void) { return 0; }
 #define STACK_SKIP 3
 
 static void
-stacktrace_trigger(struct event_trigger_data *data)
+stacktrace_trigger(struct event_trigger_data *data, void *rec)
 {
 	trace_dump_stack(STACK_SKIP);
 }
 
 static void
-stacktrace_count_trigger(struct event_trigger_data *data)
+stacktrace_count_trigger(struct event_trigger_data *data, void *rec)
 {
 	if (!data->count)
 		return;
@@ -987,7 +988,7 @@ stacktrace_count_trigger(struct event_trigger_data *data)
 	if (data->count != -1)
 		(data->count)--;
 
-	stacktrace_trigger(data);
+	stacktrace_trigger(data, rec);
 }
 
 static int
@@ -1058,7 +1059,7 @@ struct enable_trigger_data {
 };
 
 static void
-event_enable_trigger(struct event_trigger_data *data)
+event_enable_trigger(struct event_trigger_data *data, void *rec)
 {
 	struct enable_trigger_data *enable_data = data->private_data;
 
@@ -1069,7 +1070,7 @@ event_enable_trigger(struct event_trigger_data *data)
 }
 
 static void
-event_enable_count_trigger(struct event_trigger_data *data)
+event_enable_count_trigger(struct event_trigger_data *data, void *rec)
 {
 	struct enable_trigger_data *enable_data = data->private_data;
 
@@ -1083,7 +1084,7 @@ event_enable_count_trigger(struct event_trigger_data *data)
 	if (data->count != -1)
 		(data->count)--;
 
-	event_enable_trigger(data);
+	event_enable_trigger(data, rec);
 }
 
 static int
-- 
1.8.3.1

