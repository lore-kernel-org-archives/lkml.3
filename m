Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934955AbaKNBTP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 20:19:15 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:53835 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934878AbaKNBOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 20:14:14 -0500
Message-Id: <20141114011411.693008134@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 13 Nov 2014 20:12:54 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: [RFC][PATCH 10/23 v4] tracing/uprobes: Do not use return values of trace_seq_printf()
References: <20141114011244.256115061@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0010-tracing-uprobes-Do-not-use-return-values-of-trace_se.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The functions trace_seq_printf() and friends will soon no longer have
return values. Using trace_seq_has_overflowed() and trace_handle_return()
should be used instead.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_uprobe.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 33ff6a24b802..bd6007b13b52 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -852,31 +852,26 @@ print_uprobe_event(struct trace_iterator *iter, int flags, struct trace_event *e
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
 
 	for (i = 0; i < tu->tp.nr_args; i++) {
 		struct probe_arg *parg = &tu->tp.args[i];
 
-		if (!parg->type->print(s, parg->name, data + parg->offset, entry))
-			goto partial;
+		parg->type->print(s, parg->name, data + parg->offset, entry);
 	}
 
-	if (trace_seq_puts(s, "\n"))
-		return TRACE_TYPE_HANDLED;
+	trace_seq_puts(s, "\n");
 
-partial:
-	return TRACE_TYPE_PARTIAL_LINE;
+	return trace_handle_return(s);
 }
 
 typedef bool (*filter_func_t)(struct uprobe_consumer *self,
-- 
2.1.1


