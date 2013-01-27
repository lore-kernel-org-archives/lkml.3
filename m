Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab3A0TuL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 14:50:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755384Ab3A0Tth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 14:49:37 -0500
Date: Sun, 27 Jan 2013 20:48:40 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] uprobes: Teach tracing/uprobe_events to accept
	pid=TGID argument
Message-ID: <20130127194840.GA25405@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130127194814.GA25377@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A separate change to simplify the review.

With this patch create_trace_uprobe() parses the new pid=TGID argument
and stores the found "struct pid *" in "struct trace_uprobe" along with
inode/offset.

However, to simplify the potential extensions, we add the new structure
to hold this pid, and the set of its methods. This way we can, say, change
this code to accept the list of pid's without touching the non-filtering
code again.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_uprobe.c |   66 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 64 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 94d4ea2..f7a2dcb 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -23,6 +23,7 @@
 #include <linux/uprobes.h>
 #include <linux/namei.h>
 #include <linux/string.h>
+#include <linux/pid.h>
 
 #include "trace_probe.h"
 
@@ -37,11 +38,16 @@ struct uprobe_trace_consumer {
 	struct trace_uprobe		*tu;
 };
 
+struct trace_uprobe_filter {
+	struct pid *tgid;
+};
+
 struct trace_uprobe {
 	struct list_head		list;
 	struct ftrace_event_class	class;
 	struct ftrace_event_call	call;
 	struct uprobe_trace_consumer	*consumer;
+	struct trace_uprobe_filter	filter;
 	struct inode			*inode;
 	char				*filename;
 	unsigned long			offset;
@@ -64,6 +70,48 @@ static LIST_HEAD(uprobe_list);
 
 static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs);
 
+static int init_trace_uprobe_filter(struct trace_uprobe_filter *filter,
+					const char *arg)
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
+	filter->tgid = find_get_pid(tgid);
+	if (!filter->tgid)
+		goto err;
+
+	rcu_read_lock();
+	p = pid_task(filter->tgid, PIDTYPE_PID);
+	if (!p || !has_group_leader_pid(p) || (p->flags & PF_KTHREAD))
+		p = NULL;
+	rcu_read_unlock();
+
+	if (p)
+		return 0;
+err:
+	pr_info("Failed to find the process by pid=%s\n", arg);
+	/* free_trace_uprobe() will take care of ->tgid != NULL */
+	return -ESRCH;
+}
+
+static void free_trace_uprobe_filter(struct trace_uprobe_filter *filter)
+{
+	put_pid(filter->tgid);
+}
+
+static void probes_seq_show_filter(struct trace_uprobe_filter *filter,
+				struct seq_file *m)
+{
+	if (filter->tgid)
+		seq_printf(m, " pid=%d", pid_vnr(filter->tgid));
+}
+
 /*
  * Allocate new trace_uprobe and initialize it (including uprobes).
  */
@@ -111,6 +159,7 @@ static void free_trace_uprobe(struct trace_uprobe *tu)
 		traceprobe_free_probe_arg(&tu->args[i]);
 
 	iput(tu->inode);
+	free_trace_uprobe_filter(&tu->filter);
 	kfree(tu->call.class->system);
 	kfree(tu->call.name);
 	kfree(tu->filename);
@@ -167,7 +216,7 @@ end:
 
 /*
  * Argument syntax:
- *  - Add uprobe: p[:[GRP/]EVENT] PATH:SYMBOL[+offs] [FETCHARGS]
+ *  - Add uprobe: p[:[GRP/]EVENT] PATH:OFFSET [pid=TGID] [FETCHARGS]
  *
  *  - Remove uprobe: -:[GRP/]EVENT
  */
@@ -176,6 +225,7 @@ static int create_trace_uprobe(int argc, char **argv)
 	struct trace_uprobe *tu;
 	struct inode *inode;
 	char *arg, *event, *group, *filename;
+	char *filter_arg;
 	char buf[MAX_EVENT_NAME_LEN];
 	struct path path;
 	unsigned long offset;
@@ -265,6 +315,13 @@ static int create_trace_uprobe(int argc, char **argv)
 	argc -= 2;
 	argv += 2;
 
+	filter_arg = NULL;
+	if (argc && strncmp(argv[0], "pid=", 4) == 0) {
+		filter_arg = argv[0] + 4;
+		argc--;
+		argv++;
+	}
+
 	/* setup a probe */
 	if (!event) {
 		char *tail;
@@ -301,8 +358,11 @@ static int create_trace_uprobe(int argc, char **argv)
 		goto error;
 	}
 
+	ret = init_trace_uprobe_filter(&tu->filter, filter_arg);
+	if (ret)
+		goto error;
+
 	/* parse arguments */
-	ret = 0;
 	for (i = 0; i < argc && i < MAX_TRACE_ARGS; i++) {
 		/* Increment count for freeing args in error case */
 		tu->nr_args++;
@@ -402,6 +462,8 @@ static int probes_seq_show(struct seq_file *m, void *v)
 	seq_printf(m, "p:%s/%s", tu->call.class->system, tu->call.name);
 	seq_printf(m, " %s:0x%p", tu->filename, (void *)tu->offset);
 
+	probes_seq_show_filter(&tu->filter, m);
+
 	for (i = 0; i < tu->nr_args; i++)
 		seq_printf(m, " %s=%s", tu->args[i].name, tu->args[i].comm);
 
-- 
1.5.5.1

