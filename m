Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157Ab3LWVjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 16:39:22 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:60910 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758119Ab3LWVjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:39:20 -0500
Message-Id: <20131223213915.389237477@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 23 Dec 2013 16:38:20 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        kbuild test robot <fengguang.wu@intel.com>
Subject: [for-next][PATCH 10/10] tracing: Fix rcu handling of event_trigger_data filter field
References: <20131223213810.967436536@goodmis.org>
Content-Disposition: inline; filename=0010-tracing-Fix-rcu-handling-of-event_trigger_data-filte.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The filter field of the event_trigger_data structure is protected under
RCU sched locks. It was not annotated as such, and after doing so,
sparse pointed out several locations that required fix ups.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h                | 2 +-
 kernel/trace/trace_events_trigger.c | 8 +++++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 0380cab..02b592f 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1057,7 +1057,7 @@ struct event_trigger_data {
 	int				ref;
 	struct event_trigger_ops	*ops;
 	struct event_command		*cmd_ops;
-	struct event_filter		*filter;
+	struct event_filter __rcu	*filter;
 	char				*filter_str;
 	void				*private_data;
 	struct list_head		list;
diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index 12ac8a5..f6dd115 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -67,6 +67,7 @@ event_triggers_call(struct ftrace_event_file *file, void *rec)
 {
 	struct event_trigger_data *data;
 	enum event_trigger_type tt = ETT_NONE;
+	struct event_filter *filter;
 
 	if (list_empty(&file->triggers))
 		return tt;
@@ -76,7 +77,8 @@ event_triggers_call(struct ftrace_event_file *file, void *rec)
 			data->ops->func(data);
 			continue;
 		}
-		if (data->filter && !filter_match_preds(data->filter, rec))
+		filter = rcu_dereference(data->filter);
+		if (filter && !filter_match_preds(filter, rec))
 			continue;
 		if (data->cmd_ops->post_trigger) {
 			tt |= data->cmd_ops->trigger_type;
@@ -703,7 +705,7 @@ static int set_trigger_filter(char *filter_str,
 	if (ret)
 		goto out;
  assign:
-	tmp = data->filter;
+	tmp = rcu_access_pointer(data->filter);
 
 	rcu_assign_pointer(data->filter, filter);
 
@@ -719,7 +721,7 @@ static int set_trigger_filter(char *filter_str,
 	if (filter_str) {
 		data->filter_str = kstrdup(filter_str, GFP_KERNEL);
 		if (!data->filter_str) {
-			free_event_filter(data->filter);
+			free_event_filter(rcu_access_pointer(data->filter));
 			data->filter = NULL;
 			ret = -ENOMEM;
 		}
-- 
1.8.4.3


