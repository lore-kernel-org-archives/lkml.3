Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338Ab3HBC4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 22:56:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23427 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750Ab3HBCz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 22:55:56 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=CtY08EEph50A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=nPVObUGDjiQA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=4lMels9tAAAA:8 a=OlMeekkxadkd7eQCLvgA:9 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130802025553.787778530@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 01 Aug 2013 22:49:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next-3.11][PATCH 5/5] tracing/uprobes: Fail to unregister if probe event files are in use
References: <20130802024924.999067099@goodmis.org>
Content-Disposition: inline; filename=0005-tracing-uprobes-Fail-to-unregister-if-probe-event-fi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Uprobes suffer the same problem that kprobes have. There's a race between
writing to the "enable" file and removing the probe. The probe checks for
it being in use and if it is not, goes about deleting the probe and the
event that represents it. But the problem with that is, after it checks
if it is in use it can be enabled, and the deletion of the event (access
to the probe) will fail, as it is in use. But the uprobe will still be
deleted. This is a problem as the event can reference the uprobe that
was deleted.

The fix is to remove the event first, and check to make sure the event
removal succeeds. Then it is safe to remove the probe.

When the event exists, either ftrace or perf can enable the probe and
prevent the event from being removed.

Link: http://lkml.kernel.org/r/20130704034038.991525256@goodmis.org

Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_uprobe.c |   51 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 38 insertions(+), 13 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index a23d2d7..272261b 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -70,7 +70,7 @@ struct trace_uprobe {
 	(sizeof(struct probe_arg) * (n)))
 
 static int register_uprobe_event(struct trace_uprobe *tu);
-static void unregister_uprobe_event(struct trace_uprobe *tu);
+static int unregister_uprobe_event(struct trace_uprobe *tu);
 
 static DEFINE_MUTEX(uprobe_lock);
 static LIST_HEAD(uprobe_list);
@@ -164,11 +164,17 @@ static struct trace_uprobe *find_probe_event(const char *event, const char *grou
 }
 
 /* Unregister a trace_uprobe and probe_event: call with locking uprobe_lock */
-static void unregister_trace_uprobe(struct trace_uprobe *tu)
+static int unregister_trace_uprobe(struct trace_uprobe *tu)
 {
+	int ret;
+
+	ret = unregister_uprobe_event(tu);
+	if (ret)
+		return ret;
+
 	list_del(&tu->list);
-	unregister_uprobe_event(tu);
 	free_trace_uprobe(tu);
+	return 0;
 }
 
 /* Register a trace_uprobe and probe_event */
@@ -181,9 +187,12 @@ static int register_trace_uprobe(struct trace_uprobe *tu)
 
 	/* register as an event */
 	old_tp = find_probe_event(tu->call.name, tu->call.class->system);
-	if (old_tp)
+	if (old_tp) {
 		/* delete old event */
-		unregister_trace_uprobe(old_tp);
+		ret = unregister_trace_uprobe(old_tp);
+		if (ret)
+			goto end;
+	}
 
 	ret = register_uprobe_event(tu);
 	if (ret) {
@@ -256,6 +265,8 @@ static int create_trace_uprobe(int argc, char **argv)
 		group = UPROBE_EVENT_SYSTEM;
 
 	if (is_delete) {
+		int ret;
+
 		if (!event) {
 			pr_info("Delete command needs an event name.\n");
 			return -EINVAL;
@@ -269,9 +280,9 @@ static int create_trace_uprobe(int argc, char **argv)
 			return -ENOENT;
 		}
 		/* delete an event */
-		unregister_trace_uprobe(tu);
+		ret = unregister_trace_uprobe(tu);
 		mutex_unlock(&uprobe_lock);
-		return 0;
+		return ret;
 	}
 
 	if (argc < 2) {
@@ -408,16 +419,20 @@ fail_address_parse:
 	return ret;
 }
 
-static void cleanup_all_probes(void)
+static int cleanup_all_probes(void)
 {
 	struct trace_uprobe *tu;
+	int ret = 0;
 
 	mutex_lock(&uprobe_lock);
 	while (!list_empty(&uprobe_list)) {
 		tu = list_entry(uprobe_list.next, struct trace_uprobe, list);
-		unregister_trace_uprobe(tu);
+		ret = unregister_trace_uprobe(tu);
+		if (ret)
+			break;
 	}
 	mutex_unlock(&uprobe_lock);
+	return ret;
 }
 
 /* Probes listing interfaces */
@@ -462,8 +477,13 @@ static const struct seq_operations probes_seq_op = {
 
 static int probes_open(struct inode *inode, struct file *file)
 {
-	if ((file->f_mode & FMODE_WRITE) && (file->f_flags & O_TRUNC))
-		cleanup_all_probes();
+	int ret;
+
+	if ((file->f_mode & FMODE_WRITE) && (file->f_flags & O_TRUNC)) {
+		ret = cleanup_all_probes();
+		if (ret)
+			return ret;
+	}
 
 	return seq_open(file, &probes_seq_op);
 }
@@ -968,12 +988,17 @@ static int register_uprobe_event(struct trace_uprobe *tu)
 	return ret;
 }
 
-static void unregister_uprobe_event(struct trace_uprobe *tu)
+static int unregister_uprobe_event(struct trace_uprobe *tu)
 {
+	int ret;
+
 	/* tu->event is unregistered in trace_remove_event_call() */
-	trace_remove_event_call(&tu->call);
+	ret = trace_remove_event_call(&tu->call);
+	if (ret)
+		return ret;
 	kfree(tu->call.print_fmt);
 	tu->call.print_fmt = NULL;
+	return 0;
 }
 
 /* Make a trace interface for controling probe points */
-- 
1.7.10.4


