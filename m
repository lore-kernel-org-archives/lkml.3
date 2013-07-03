Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab3GCLip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 07:38:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30056 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab3GCLhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 07:37:21 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=NC-cUe8cKpoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=VwQJya78TucA:10 a=VwQbUJbxAAAA:8 a=0JIfQGlApRYaNP9MQlYA:9 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703113718.674632381@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 07:36:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, <stable@vger.kernel.org>
Subject: [for-next][PATCH 2/8] tracing: Fix race between deleting buffer and setting events
References: <20130703113635.696310819@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Fix-race-between-deleting-buffer-and-setting.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

While analyzing the code, I discovered that there's a potential race between
deleting a trace instance and setting events. There are a few races that can
occur if events are being traced as the buffer is being deleted. Mostly the
problem comes with freeing the descriptor used by the trace event callback.
To prevent problems like this, the events are disabled before the buffer is
deleted. The problem with the current solution is that the event_mutex is let
go between disabling the events and freeing the files, which means that the events
could be enabled again while the freeing takes place.

Cc: stable@vger.kernel.org # 3.10
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 920e08f..7d85429 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -441,14 +441,14 @@ static int tracing_release_generic_file(struct inode *inode, struct file *filp)
 /*
  * __ftrace_set_clr_event(NULL, NULL, NULL, set) will set/unset all events.
  */
-static int __ftrace_set_clr_event(struct trace_array *tr, const char *match,
-				  const char *sub, const char *event, int set)
+static int
+__ftrace_set_clr_event_nolock(struct trace_array *tr, const char *match,
+			      const char *sub, const char *event, int set)
 {
 	struct ftrace_event_file *file;
 	struct ftrace_event_call *call;
 	int ret = -EINVAL;
 
-	mutex_lock(&event_mutex);
 	list_for_each_entry(file, &tr->events, list) {
 
 		call = file->event_call;
@@ -474,6 +474,17 @@ static int __ftrace_set_clr_event(struct trace_array *tr, const char *match,
 
 		ret = 0;
 	}
+
+	return ret;
+}
+
+static int __ftrace_set_clr_event(struct trace_array *tr, const char *match,
+				  const char *sub, const char *event, int set)
+{
+	int ret;
+
+	mutex_lock(&event_mutex);
+	ret = __ftrace_set_clr_event_nolock(tr, match, sub, event, set);
 	mutex_unlock(&event_mutex);
 
 	return ret;
@@ -2408,11 +2419,11 @@ early_event_add_tracer(struct dentry *parent, struct trace_array *tr)
 
 int event_trace_del_tracer(struct trace_array *tr)
 {
-	/* Disable any running events */
-	__ftrace_set_clr_event(tr, NULL, NULL, NULL, 0);
-
 	mutex_lock(&event_mutex);
 
+	/* Disable any running events */
+	__ftrace_set_clr_event_nolock(tr, NULL, NULL, NULL, 0);
+
 	down_write(&trace_event_sem);
 	__trace_remove_event_dirs(tr);
 	debugfs_remove_recursive(tr->event_dir);
-- 
1.7.10.4


