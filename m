Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933887AbaGQOsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 10:48:50 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:10874 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933370AbaGQOry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 10:47:54 -0400
Message-Id: <20140717144752.691961602@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 17 Jul 2014 10:47:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: [for-next][PATCH 4/7] tracing/uprobes: Kill the dead TRACE_EVENT_FL_USE_CALL_FILTER logic
References: <20140717144707.625978566@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0004-tracing-uprobes-Kill-the-dead-TRACE_EVENT_FL_USE_CAL.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

alloc_trace_uprobe() sets TRACE_EVENT_FL_USE_CALL_FILTER for unknown
reason and this is simply wrong. Fortunately this has no effect because
register_uprobe_event() clears call->flags after that.

Kill both. This trace_uprobe was kzalloc'ed and we rely on this fact
anyway.

Link: http://lkml.kernel.org/p/20140715184824.GA20505@redhat.com

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_uprobe.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 3c9b97e6b1f4..33ff6a24b802 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -265,7 +265,6 @@ alloc_trace_uprobe(const char *group, const char *event, int nargs, bool is_ret)
 	if (is_ret)
 		tu->consumer.ret_handler = uretprobe_dispatcher;
 	init_trace_uprobe_filter(&tu->filter);
-	tu->tp.call.flags |= TRACE_EVENT_FL_USE_CALL_FILTER;
 	return tu;
 
 error:
@@ -1292,7 +1291,7 @@ static int register_uprobe_event(struct trace_uprobe *tu)
 		kfree(call->print_fmt);
 		return -ENODEV;
 	}
-	call->flags = 0;
+
 	call->class->reg = trace_uprobe_register;
 	call->data = tu;
 	ret = trace_add_event_call(call);
-- 
2.0.1


