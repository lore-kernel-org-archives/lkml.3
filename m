Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab3A1S1q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 13:27:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab3A1S1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 13:27:42 -0500
Date: Mon, 28 Jan 2013 19:25:01 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] uprobes: Kill set_trace_uprobe_filter_func()
Message-ID: <20130128182501.GA18317@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130128182423.GA18273@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that uprobe_consumer is embedded into "struct trace_uprobe" we
can remove the ugly set_trace_uprobe_filter_func() and initialize
consumer->handler/filter at create_ time.

The patch looks complicated, but this is only because it moves
trace_uprobe_filter_func() up before init_trace_uprobe_filter().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_uprobe.c |   97 ++++++++++++++++++++-----------------------
 1 files changed, 45 insertions(+), 52 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 6551b77..642e003 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -63,50 +63,6 @@ static void unregister_uprobe_event(struct trace_uprobe *tu);
 static DEFINE_MUTEX(uprobe_lock);
 static LIST_HEAD(uprobe_list);
 
-static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs);
-
-static int init_trace_uprobe_filter(struct trace_uprobe_filter *filter,
-					const char *arg)
-{
-	struct task_struct *p;
-	pid_t tgid;
-
-	if (!arg)
-		return 0;
-
-	if (kstrtouint(arg, 0, &tgid))
-		goto err;
-
-	filter->tgid = find_get_pid(tgid);
-	if (!filter->tgid)
-		goto err;
-
-	rcu_read_lock();
-	p = pid_task(filter->tgid, PIDTYPE_PID);
-	if (!p || !has_group_leader_pid(p) || (p->flags & PF_KTHREAD))
-		p = NULL;
-	rcu_read_unlock();
-
-	if (p)
-		return 0;
-err:
-	pr_info("Failed to find the process by pid=%s\n", arg);
-	/* free_trace_uprobe() will take care of ->tgid != NULL */
-	return -ESRCH;
-}
-
-static void free_trace_uprobe_filter(struct trace_uprobe_filter *filter)
-{
-	put_pid(filter->tgid);
-}
-
-static void probes_seq_show_filter(struct trace_uprobe_filter *filter,
-				struct seq_file *m)
-{
-	if (filter->tgid)
-		seq_printf(m, " pid=%d", pid_vnr(filter->tgid));
-}
-
 static bool trace_uprobe_filter_current(struct trace_uprobe_filter *filter)
 {
 	return !filter->tgid || filter->tgid == task_tgid(current);
@@ -144,13 +100,52 @@ static bool trace_uprobe_filter_func(struct uprobe_consumer *uc,
 	return ret;
 }
 
-static inline void set_trace_uprobe_filter_func(struct uprobe_consumer *uc,
-					struct trace_uprobe_filter *filter)
+static int init_trace_uprobe_filter(struct trace_uprobe *tu, const char *arg)
+{
+	struct task_struct *p;
+	pid_t tgid;
+
+	if (!arg)
+		return 0;
+
+	if (kstrtouint(arg, 0, &tgid))
+		goto err;
+
+	tu->filter.tgid = find_get_pid(tgid);
+	if (!tu->filter.tgid)
+		goto err;
+
+	rcu_read_lock();
+	p = pid_task(tu->filter.tgid, PIDTYPE_PID);
+	if (!p || !has_group_leader_pid(p) || (p->flags & PF_KTHREAD))
+		p = NULL;
+	rcu_read_unlock();
+
+	if (!p)
+		goto err;
+
+	tu->consumer.filter = trace_uprobe_filter_func;
+	return 0;
+err:
+	pr_info("Failed to find the process by pid=%s\n", arg);
+	/* free_trace_uprobe() will take care of ->tgid != NULL */
+	return -ESRCH;
+}
+
+static void free_trace_uprobe_filter(struct trace_uprobe *tu)
+{
+	put_pid(tu->filter.tgid);
+}
+
+static void probes_seq_show_filter(struct trace_uprobe_filter *filter,
+				struct seq_file *m)
 {
 	if (filter->tgid)
-		uc->filter = trace_uprobe_filter_func;
+		seq_printf(m, " pid=%d", pid_vnr(filter->tgid));
 }
 
+static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs);
+
 /*
  * Allocate new trace_uprobe and initialize it (including uprobes).
  */
@@ -179,6 +174,7 @@ alloc_trace_uprobe(const char *group, const char *event, int nargs)
 		goto error;
 
 	INIT_LIST_HEAD(&tu->list);
+	tu->consumer.handler = uprobe_dispatcher;
 	return tu;
 
 error:
@@ -196,7 +192,7 @@ static void free_trace_uprobe(struct trace_uprobe *tu)
 		traceprobe_free_probe_arg(&tu->args[i]);
 
 	iput(tu->inode);
-	free_trace_uprobe_filter(&tu->filter);
+	free_trace_uprobe_filter(tu);
 	kfree(tu->call.class->system);
 	kfree(tu->call.name);
 	kfree(tu->filename);
@@ -397,7 +393,7 @@ static int create_trace_uprobe(int argc, char **argv)
 		goto error;
 	}
 
-	ret = init_trace_uprobe_filter(&tu->filter, filter_arg);
+	ret = init_trace_uprobe_filter(tu, filter_arg);
 	if (ret)
 		goto error;
 
@@ -644,10 +640,7 @@ static int probe_event_enable(struct trace_uprobe *tu, int flag)
 	if (tu->enabled)
 		return -EINTR;
 
-	set_trace_uprobe_filter_func(&tu->consumer, &tu->filter);
-	tu->consumer.handler = uprobe_dispatcher;
 	tu->flags |= flag;
-
 	ret = uprobe_register(tu->inode, tu->offset, &tu->consumer);
 	if (ret)
 		tu->flags &= ~flag;
-- 
1.5.5.1

