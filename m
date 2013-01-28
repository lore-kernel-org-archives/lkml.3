Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab3A1S0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 13:26:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab3A1S0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 13:26:19 -0500
Date: Mon, 28 Jan 2013 19:25:04 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] uprobes: Kill trace_uprobe->enabled, introduce
	is_trace_uprobe_enabled()
Message-ID: <20130128182504.GA18320@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130128182423.GA18273@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Finally kill trace_uprobe->enabled and add is_trace_uprobe_enabled()
which can rely on TP_FLAG_TRACE/TP_FLAG_PROFILE bits we set/clear
anyway.

Note that we could do this from the very beginning, ->enabled was
never strictly needed. But I'd prefer to do this as a last change
so that it can be dropped if the reviewers do not like the (ab)use
of tu->flags.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_uprobe.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 642e003..1e1633c 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -40,7 +40,6 @@ struct trace_uprobe {
 	struct list_head		list;
 	struct ftrace_event_class	class;
 	struct ftrace_event_call	call;
-	bool				enabled;
 	struct uprobe_consumer		consumer;
 	struct trace_uprobe_filter	filter;
 	struct inode			*inode;
@@ -633,31 +632,33 @@ partial:
 	return TRACE_TYPE_PARTIAL_LINE;
 }
 
+static inline bool is_trace_uprobe_enabled(struct trace_uprobe *tu)
+{
+	return tu->flags & (TP_FLAG_TRACE | TP_FLAG_PROFILE);
+}
+
 static int probe_event_enable(struct trace_uprobe *tu, int flag)
 {
 	int ret = 0;
 
-	if (tu->enabled)
+	if (is_trace_uprobe_enabled(tu))
 		return -EINTR;
 
 	tu->flags |= flag;
 	ret = uprobe_register(tu->inode, tu->offset, &tu->consumer);
 	if (ret)
 		tu->flags &= ~flag;
-	else
-		tu->enabled = true;
 
 	return ret;
 }
 
 static void probe_event_disable(struct trace_uprobe *tu, int flag)
 {
-	if (!tu->enabled)
+	if (!is_trace_uprobe_enabled(tu))
 		return;
 
 	uprobe_unregister(tu->inode, tu->offset, &tu->consumer);
 	tu->flags &= ~flag;
-	tu->enabled = false;
 }
 
 static int uprobe_event_define_fields(struct ftrace_event_call *event_call)
-- 
1.5.5.1

