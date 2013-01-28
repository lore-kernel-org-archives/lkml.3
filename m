Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab3A1S1P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 13:27:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228Ab3A1S1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 13:27:11 -0500
Date: Mon, 28 Jan 2013 19:24:58 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] uprobes: Kill uprobe_trace_consumer, embed
	uprobe_consumer into trace_uprobe
Message-ID: <20130128182458.GA18310@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130128182423.GA18273@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

trace_uprobe->consumer and "struct uprobe_trace_consumer" add the
unnecessary indirection and complicate the code for no reason.

This patch simply embeds uprobe_consumer into "struct trace_uprobe",
all other changes only fix the compilation errors.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_uprobe.c |   44 ++++++++++--------------------------------
 1 files changed, 11 insertions(+), 33 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index c430d01..6551b77 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -32,12 +32,6 @@
 /*
  * uprobe event core functions
  */
-struct trace_uprobe;
-struct uprobe_trace_consumer {
-	struct uprobe_consumer		cons;
-	struct trace_uprobe		*tu;
-};
-
 struct trace_uprobe_filter {
 	struct pid *tgid;
 };
@@ -47,7 +41,7 @@ struct trace_uprobe {
 	struct ftrace_event_class	class;
 	struct ftrace_event_call	call;
 	bool				enabled;
-	struct uprobe_trace_consumer	*consumer;
+	struct uprobe_consumer		consumer;
 	struct trace_uprobe_filter	filter;
 	struct inode			*inode;
 	char				*filename;
@@ -122,13 +116,13 @@ static bool trace_uprobe_filter_func(struct uprobe_consumer *uc,
 					enum uprobe_filter_ctx ctx,
 					struct mm_struct *mm)
 {
-	struct uprobe_trace_consumer *utc;
+	struct trace_uprobe *tu;
 	struct trace_uprobe_filter *filter;
 	struct task_struct *p, *t;
 	bool ret;
 
-	utc = container_of(uc, struct uprobe_trace_consumer, cons);
-	filter = &utc->tu->filter;
+	tu = container_of(uc, struct trace_uprobe, consumer);
+	filter = &tu->filter;
 
 	if (ctx == UPROBE_FILTER_MMAP)
 		return trace_uprobe_filter_current(filter);
@@ -645,30 +639,20 @@ partial:
 
 static int probe_event_enable(struct trace_uprobe *tu, int flag)
 {
-	struct uprobe_trace_consumer *utc;
 	int ret = 0;
 
 	if (tu->enabled)
 		return -EINTR;
 
-	utc = kzalloc(sizeof(struct uprobe_trace_consumer), GFP_KERNEL);
-	if (!utc)
-		return -EINTR;
-
-	set_trace_uprobe_filter_func(&utc->cons, &tu->filter);
-	utc->cons.handler = uprobe_dispatcher;
-	utc->tu = tu;
-	tu->consumer = utc;
+	set_trace_uprobe_filter_func(&tu->consumer, &tu->filter);
+	tu->consumer.handler = uprobe_dispatcher;
 	tu->flags |= flag;
 
-	ret = uprobe_register(tu->inode, tu->offset, &utc->cons);
-	if (ret) {
-		tu->consumer = NULL;
+	ret = uprobe_register(tu->inode, tu->offset, &tu->consumer);
+	if (ret)
 		tu->flags &= ~flag;
-		kfree(utc);
-	} else {
+	else
 		tu->enabled = true;
-	}
 
 	return ret;
 }
@@ -678,11 +662,9 @@ static void probe_event_disable(struct trace_uprobe *tu, int flag)
 	if (!tu->enabled)
 		return;
 
-	uprobe_unregister(tu->inode, tu->offset, &tu->consumer->cons);
+	uprobe_unregister(tu->inode, tu->offset, &tu->consumer);
 	tu->flags &= ~flag;
 	tu->enabled = false;
-	kfree(tu->consumer);
-	tu->consumer = NULL;
 }
 
 static int uprobe_event_define_fields(struct ftrace_event_call *event_call)
@@ -820,13 +802,9 @@ int trace_uprobe_register(struct ftrace_event_call *event, enum trace_reg type,
 
 static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs)
 {
-	struct uprobe_trace_consumer *utc;
 	struct trace_uprobe *tu;
 
-	utc = container_of(con, struct uprobe_trace_consumer, cons);
-	tu = utc->tu;
-	if (!tu || tu->consumer != utc)
-		return 0;
+	tu = container_of(con, struct trace_uprobe, consumer);
 
 	if (!trace_uprobe_filter_current(&tu->filter))
 		return UPROBE_HANDLER_REMOVE;
-- 
1.5.5.1

