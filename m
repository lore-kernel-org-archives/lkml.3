Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934998Ab3GWW3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:29:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41926 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934924Ab3GWW2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:28:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [ 102/103] tracing: Fix race between deleting buffer and setting events
Date: Tue, 23 Jul 2013 15:26:53 -0700
Message-Id: <20130723220433.740987566@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

commit 2a6c24afab70dbcfee49f4c76e1511eec1a3298b upstream.

While analyzing the code, I discovered that there's a potential race between
deleting a trace instance and setting events. There are a few races that can
occur if events are being traced as the buffer is being deleted. Mostly the
problem comes with freeing the descriptor used by the trace event callback.
To prevent problems like this, the events are disabled before the buffer is
deleted. The problem with the current solution is that the event_mutex is let
go between disabling the events and freeing the files, which means that the events
could be enabled again while the freeing takes place.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace_events.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -415,14 +415,14 @@ static void put_system(struct ftrace_sub
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
@@ -448,6 +448,17 @@ static int __ftrace_set_clr_event(struct
 
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
@@ -2367,11 +2378,11 @@ early_event_add_tracer(struct dentry *pa
 
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


