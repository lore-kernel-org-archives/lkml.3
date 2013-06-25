Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab3FYIQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 04:16:42 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:7392 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab3FYIQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 04:16:38 -0400
Message-ID: <51C951CD.50701@huawei.com>
Date: Tue, 25 Jun 2013 16:16:13 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] tracing/uprobes: disallow unregister trace_uprobe when
 trace_uprobe is in use
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We cannot unregister trace_uprobe when trace_uprobe is in use,
otherwise resource will leak.

Just return -EBUSY if user want to unregister a trace_uprobe
which in use.

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 kernel/trace/trace_uprobe.c |   51 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 38 insertions(+), 13 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index d2da3ea..248757b 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -102,6 +102,11 @@ static inline bool is_ret_probe(struct trace_uprobe *tu)
 	return tu->consumer.ret_handler != NULL;
 }

+static inline bool is_trace_uprobe_enabled(struct trace_uprobe *tu)
+{
+	return tu->flags & (TP_FLAG_TRACE | TP_FLAG_PROFILE);
+}
+
 /*
  * Allocate new trace_uprobe and initialize it (including uprobes).
  */
@@ -171,11 +176,17 @@ static struct trace_uprobe *find_probe_event(const char *event, const char *grou
 }

 /* Unregister a trace_uprobe and probe_event: call with locking uprobe_lock */
-static void unregister_trace_uprobe(struct trace_uprobe *tu)
+static int unregister_trace_uprobe(struct trace_uprobe *tu)
 {
+	/* Enabled event can not be unregistered */
+	if (is_trace_uprobe_enabled(tu))
+		return -EBUSY;
+
 	list_del(&tu->list);
 	unregister_uprobe_event(tu);
 	free_trace_uprobe(tu);
+
+	return 0;
 }

 /* Register a trace_uprobe and probe_event */
@@ -188,9 +199,12 @@ static int register_trace_uprobe(struct trace_uprobe *tu)

 	/* register as an event */
 	old_tp = find_probe_event(tu->call.name, tu->call.class->system);
-	if (old_tp)
+	if (old_tp) {
 		/* delete old event */
-		unregister_trace_uprobe(old_tp);
+		ret = unregister_trace_uprobe(old_tp);
+		if (ret < 0)
+			goto end;
+	}

 	ret = register_uprobe_event(tu);
 	if (ret) {
@@ -276,9 +290,9 @@ static int create_trace_uprobe(int argc, char **argv)
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
@@ -413,16 +427,27 @@ fail_address_parse:
 	return ret;
 }

-static void cleanup_all_probes(void)
+static int cleanup_all_probes(void)
 {
 	struct trace_uprobe *tu;
+	int ret = 0;

 	mutex_lock(&uprobe_lock);
+
+	/* Ensure no probe is in use. */
+	list_for_each_entry(tu, &uprobe_list, list)
+		if (is_trace_uprobe_enabled(tu)) {
+			ret = -EBUSY;
+			goto end;
+		}
+
 	while (!list_empty(&uprobe_list)) {
 		tu = list_entry(uprobe_list.next, struct trace_uprobe, list);
 		unregister_trace_uprobe(tu);
 	}
+ end:
 	mutex_unlock(&uprobe_lock);
+	return ret;
 }

 /* Probes listing interfaces */
@@ -467,8 +492,13 @@ static const struct seq_operations probes_seq_op = {

 static int probes_open(struct inode *inode, struct file *file)
 {
-	if ((file->f_mode & FMODE_WRITE) && (file->f_flags & O_TRUNC))
-		cleanup_all_probes();
+	int ret;
+
+	if ((file->f_mode & FMODE_WRITE) && (file->f_flags & O_TRUNC)) {
+		ret = cleanup_all_probes();
+		if (ret < 0)
+			return ret;
+	}

 	return seq_open(file, &probes_seq_op);
 }
@@ -622,11 +652,6 @@ partial:
 	return TRACE_TYPE_PARTIAL_LINE;
 }

-static inline bool is_trace_uprobe_enabled(struct trace_uprobe *tu)
-{
-	return tu->flags & (TP_FLAG_TRACE | TP_FLAG_PROFILE);
-}
-
 typedef bool (*filter_func_t)(struct uprobe_consumer *self,
 				enum uprobe_filter_ctx ctx,
 				struct mm_struct *mm);
-- 
1.7.9.7


