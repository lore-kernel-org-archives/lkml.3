Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab3A0Ttw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 14:49:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755742Ab3A0Tti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 14:49:38 -0500
Date: Sun, 27 Jan 2013 20:48:43 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] uprobes: Teach uprobe_trace_consumer to support the
	pre-filtering
Message-ID: <20130127194843.GA25412@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130127194814.GA25377@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement trace_uprobe_filter_func() and change probe_event_enable()
to setup uprobe_consumer->filter() if necessary.

Also change uprobe_dispatcher() to skip the tasks we do not want to
probe and return UPROBE_HANDLER_REMOVE to indicate that this "int3"
should be removed unless there is another consumer which wants to
trace this task.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_uprobe.c |   48 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index f7a2dcb..78e918f 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -112,6 +112,50 @@ static void probes_seq_show_filter(struct trace_uprobe_filter *filter,
 		seq_printf(m, " pid=%d", pid_vnr(filter->tgid));
 }
 
+static bool trace_uprobe_filter_current(struct trace_uprobe_filter *filter)
+{
+	return !filter->tgid || filter->tgid == task_tgid(current);
+}
+
+static bool trace_uprobe_filter_func(struct uprobe_consumer *uc,
+					enum uprobe_filter_ctx ctx,
+					struct mm_struct *mm)
+{
+	struct uprobe_trace_consumer *utc;
+	struct trace_uprobe_filter *filter;
+	struct task_struct *p, *t;
+	bool ret;
+
+	utc = container_of(uc, struct uprobe_trace_consumer, cons);
+	filter = &utc->tu->filter;
+
+	if (ctx == UPROBE_FILTER_MMAP)
+		return trace_uprobe_filter_current(filter);
+
+	ret = false;
+	rcu_read_lock();
+	p = pid_task(filter->tgid, PIDTYPE_PID);
+	if (p) {
+		t = p;
+		do {
+			if (t->mm) {
+				ret = (t->mm == mm);
+				break;
+			}
+		} while_each_thread(p, t);
+	}
+	rcu_read_unlock();
+
+	return ret;
+}
+
+static inline void set_trace_uprobe_filter_func(struct uprobe_consumer *uc,
+					struct trace_uprobe_filter *filter)
+{
+	if (filter->tgid)
+		uc->filter = trace_uprobe_filter_func;
+}
+
 /*
  * Allocate new trace_uprobe and initialize it (including uprobes).
  */
@@ -613,6 +657,7 @@ static int probe_event_enable(struct trace_uprobe *tu, int flag)
 	if (!utc)
 		return -EINTR;
 
+	set_trace_uprobe_filter_func(&utc->cons, &tu->filter);
 	utc->cons.handler = uprobe_dispatcher;
 	utc->tu = tu;
 	tu->consumer = utc;
@@ -784,6 +829,9 @@ static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs)
 	if (!tu || tu->consumer != utc)
 		return 0;
 
+	if (!trace_uprobe_filter_current(&tu->filter))
+		return UPROBE_HANDLER_REMOVE;
+
 	if (tu->flags & TP_FLAG_TRACE)
 		uprobe_trace_func(tu, regs);
 
-- 
1.5.5.1

