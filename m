Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556AbaKSX2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:28:45 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:23890 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756940AbaKSX1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:27:14 -0500
Message-Id: <20141119232711.903271065@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 19 Nov 2014 18:26:47 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH 15/18] tracing/uprobes: Do not use return values of trace_seq_printf()
References: <20141119232632.737569526@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0015-tracing-uprobes-Do-not-use-return-values-of-trace_se.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The functions trace_seq_printf() and friends will soon no longer have
return values. Using trace_seq_has_overflowed() and trace_handle_return()
should be used instead.

Link: http://lkml.kernel.org/r/20141114011411.693008134@goodmis.org
Link: http://lkml.kernel.org/r/20141115050602.333705855@goodmis.org

Reviewed-by: Masami Hiramatsu <masami.hiramatu.pt@hitachi.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_uprobe.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index e35327c787f7..fd76f8e108ef 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -852,16 +852,14 @@ print_uprobe_event(struct trace_iterator *iter, int flags, struct trace_event *e
 	tu = container_of(event, struct trace_uprobe, tp.call.event);
 
 	if (is_ret_probe(tu)) {
-		if (!trace_seq_printf(s, "%s: (0x%lx <- 0x%lx)",
-					ftrace_event_name(&tu->tp.call),
-					entry->vaddr[1], entry->vaddr[0]))
-			goto partial;
+		trace_seq_printf(s, "%s: (0x%lx <- 0x%lx)",
+				 ftrace_event_name(&tu->tp.call),
+				 entry->vaddr[1], entry->vaddr[0]);
 		data = DATAOF_TRACE_ENTRY(entry, true);
 	} else {
-		if (!trace_seq_printf(s, "%s: (0x%lx)",
-					ftrace_event_name(&tu->tp.call),
-					entry->vaddr[0]))
-			goto partial;
+		trace_seq_printf(s, "%s: (0x%lx)",
+				 ftrace_event_name(&tu->tp.call),
+				 entry->vaddr[0]);
 		data = DATAOF_TRACE_ENTRY(entry, false);
 	}
 
@@ -869,14 +867,13 @@ print_uprobe_event(struct trace_iterator *iter, int flags, struct trace_event *e
 		struct probe_arg *parg = &tu->tp.args[i];
 
 		if (!parg->type->print(s, parg->name, data + parg->offset, entry))
-			goto partial;
+			goto out;
 	}
 
-	if (trace_seq_putc(s, '\n'))
-		return TRACE_TYPE_HANDLED;
+	trace_seq_putc(s, '\n');
 
-partial:
-	return TRACE_TYPE_PARTIAL_LINE;
+ out:
+	return trace_handle_return(s);
 }
 
 typedef bool (*filter_func_t)(struct uprobe_consumer *self,
-- 
2.1.1


