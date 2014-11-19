Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125AbaKSX1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:27:18 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:44218 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755343AbaKSX1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:27:15 -0500
Message-Id: <20141119232711.447260782@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 19 Nov 2014 18:26:44 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Petr Mladek <pmladek@suse.cz>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [for-next][PATCH 12/18] kprobes/tracing: Use trace_seq_has_overflowed() for overflow checks
References: <20141119232632.737569526@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0012-kprobes-tracing-Use-trace_seq_has_overflowed-for-ove.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Instead of checking the return value of trace_seq_printf() and friends
for overflowing of the buffer, use the trace_seq_has_overflowed() helper
function.

This cleans up the code quite a bit and also takes us a step closer to
changing the return values of trace_seq_printf() and friends to void.

Link: http://lkml.kernel.org/r/20141114011411.181812785@goodmis.org

Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Reviewed-by: Petr Mladek <pmladek@suse.cz>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_kprobe.c | 42 ++++++++++++++++--------------------------
 1 file changed, 16 insertions(+), 26 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index ef7e7f16ed1a..5edb518be345 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1024,27 +1024,22 @@ print_kprobe_event(struct trace_iterator *iter, int flags,
 	field = (struct kprobe_trace_entry_head *)iter->ent;
 	tp = container_of(event, struct trace_probe, call.event);
 
-	if (!trace_seq_printf(s, "%s: (", ftrace_event_name(&tp->call)))
-		goto partial;
+	trace_seq_printf(s, "%s: (", ftrace_event_name(&tp->call));
 
 	if (!seq_print_ip_sym(s, field->ip, flags | TRACE_ITER_SYM_OFFSET))
-		goto partial;
+		goto out;
 
-	if (!trace_seq_putc(s, ')'))
-		goto partial;
+	trace_seq_putc(s, ')');
 
 	data = (u8 *)&field[1];
 	for (i = 0; i < tp->nr_args; i++)
 		if (!tp->args[i].type->print(s, tp->args[i].name,
 					     data + tp->args[i].offset, field))
-			goto partial;
-
-	if (!trace_seq_putc(s, '\n'))
-		goto partial;
+			goto out;
 
-	return TRACE_TYPE_HANDLED;
-partial:
-	return TRACE_TYPE_PARTIAL_LINE;
+	trace_seq_putc(s, '\n');
+ out:
+	return trace_handle_return(s);
 }
 
 static enum print_line_t
@@ -1060,33 +1055,28 @@ print_kretprobe_event(struct trace_iterator *iter, int flags,
 	field = (struct kretprobe_trace_entry_head *)iter->ent;
 	tp = container_of(event, struct trace_probe, call.event);
 
-	if (!trace_seq_printf(s, "%s: (", ftrace_event_name(&tp->call)))
-		goto partial;
+	trace_seq_printf(s, "%s: (", ftrace_event_name(&tp->call));
 
 	if (!seq_print_ip_sym(s, field->ret_ip, flags | TRACE_ITER_SYM_OFFSET))
-		goto partial;
+		goto out;
 
-	if (!trace_seq_puts(s, " <- "))
-		goto partial;
+	trace_seq_puts(s, " <- ");
 
 	if (!seq_print_ip_sym(s, field->func, flags & ~TRACE_ITER_SYM_OFFSET))
-		goto partial;
+		goto out;
 
-	if (!trace_seq_putc(s, ')'))
-		goto partial;
+	trace_seq_putc(s, ')');
 
 	data = (u8 *)&field[1];
 	for (i = 0; i < tp->nr_args; i++)
 		if (!tp->args[i].type->print(s, tp->args[i].name,
 					     data + tp->args[i].offset, field))
-			goto partial;
+			goto out;
 
-	if (!trace_seq_putc(s, '\n'))
-		goto partial;
+	trace_seq_putc(s, '\n');
 
-	return TRACE_TYPE_HANDLED;
-partial:
-	return TRACE_TYPE_PARTIAL_LINE;
+ out:
+	return trace_handle_return(s);
 }
 
 
-- 
2.1.1


