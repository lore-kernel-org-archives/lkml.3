Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553Ab3A1S0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 13:26:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270Ab3A1S0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 13:26:16 -0500
Date: Mon, 28 Jan 2013 19:24:53 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] uprobes: Introduce trace_uprobe->enabled
Message-ID: <20130128182453.GA18303@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130128182423.GA18273@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

probe_event_enable/disable() check tu->consumer != NULL to avoid
the wrong uprobe_register/unregister().

We are going to kill uprobe_trace_consumer, so we add the explicit
trace_uprobe->enabled member which can be used instead.

This is the temporary change to simplify the next patch, the new
member will go away after cleanups.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_uprobe.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index f49ccf9..c430d01 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -46,6 +46,7 @@ struct trace_uprobe {
 	struct list_head		list;
 	struct ftrace_event_class	class;
 	struct ftrace_event_call	call;
+	bool				enabled;
 	struct uprobe_trace_consumer	*consumer;
 	struct trace_uprobe_filter	filter;
 	struct inode			*inode;
@@ -647,7 +648,7 @@ static int probe_event_enable(struct trace_uprobe *tu, int flag)
 	struct uprobe_trace_consumer *utc;
 	int ret = 0;
 
-	if (tu->consumer)
+	if (tu->enabled)
 		return -EINTR;
 
 	utc = kzalloc(sizeof(struct uprobe_trace_consumer), GFP_KERNEL);
@@ -665,6 +666,8 @@ static int probe_event_enable(struct trace_uprobe *tu, int flag)
 		tu->consumer = NULL;
 		tu->flags &= ~flag;
 		kfree(utc);
+	} else {
+		tu->enabled = true;
 	}
 
 	return ret;
@@ -672,11 +675,12 @@ static int probe_event_enable(struct trace_uprobe *tu, int flag)
 
 static void probe_event_disable(struct trace_uprobe *tu, int flag)
 {
-	if (!tu->consumer)
+	if (!tu->enabled)
 		return;
 
 	uprobe_unregister(tu->inode, tu->offset, &tu->consumer->cons);
 	tu->flags &= ~flag;
+	tu->enabled = false;
 	kfree(tu->consumer);
 	tu->consumer = NULL;
 }
-- 
1.5.5.1

