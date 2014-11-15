Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbaKOFKx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 00:10:53 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:27267 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750982AbaKOFGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 00:06:05 -0500
Message-Id: <20141115050602.481889146@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 14 Nov 2014 23:58:58 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 11/26 v5] tracing: Do not use return values of trace_seq_printf() in syscall
 tracing
References: <20141115045847.712848224@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0011-tracing-Do-not-use-return-values-of-trace_seq_printf.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The functions trace_seq_printf() and friends will not be returning values
soon and will be void functions. To know if they succeeded or not, the
functions trace_seq_has_overflowed() and trace_handle_return() should be
used instead.

Reviewed-by: Petr Mladek <pmladek@suse.cz>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_syscalls.c | 43 +++++++++++++++----------------------------
 1 file changed, 15 insertions(+), 28 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 4dc8b79c5f75..2193e8038681 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -114,7 +114,7 @@ print_syscall_enter(struct trace_iterator *iter, int flags,
 	struct trace_entry *ent = iter->ent;
 	struct syscall_trace_enter *trace;
 	struct syscall_metadata *entry;
-	int i, ret, syscall;
+	int i, syscall;
 
 	trace = (typeof(trace))ent;
 	syscall = trace->nr;
@@ -128,35 +128,24 @@ print_syscall_enter(struct trace_iterator *iter, int flags,
 		goto end;
 	}
 
-	ret = trace_seq_printf(s, "%s(", entry->name);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	trace_seq_printf(s, "%s(", entry->name);
 
 	for (i = 0; i < entry->nb_args; i++) {
 		/* parameter types */
-		if (trace_flags & TRACE_ITER_VERBOSE) {
-			ret = trace_seq_printf(s, "%s ", entry->types[i]);
-			if (!ret)
-				return TRACE_TYPE_PARTIAL_LINE;
-		}
+		if (trace_flags & TRACE_ITER_VERBOSE)
+			trace_seq_printf(s, "%s ", entry->types[i]);
+
 		/* parameter values */
-		ret = trace_seq_printf(s, "%s: %lx%s", entry->args[i],
-				       trace->args[i],
-				       i == entry->nb_args - 1 ? "" : ", ");
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
+		trace_seq_printf(s, "%s: %lx%s", entry->args[i],
+				 trace->args[i],
+				 i == entry->nb_args - 1 ? "" : ", ");
 	}
 
-	ret = trace_seq_putc(s, ')');
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
+	trace_seq_putc(s, ')');
 end:
-	ret =  trace_seq_putc(s, '\n');
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	trace_seq_putc(s, '\n');
 
-	return TRACE_TYPE_HANDLED;
+	return trace_handle_return(s);
 }
 
 static enum print_line_t
@@ -168,7 +157,6 @@ print_syscall_exit(struct trace_iterator *iter, int flags,
 	struct syscall_trace_exit *trace;
 	int syscall;
 	struct syscall_metadata *entry;
-	int ret;
 
 	trace = (typeof(trace))ent;
 	syscall = trace->nr;
@@ -176,7 +164,7 @@ print_syscall_exit(struct trace_iterator *iter, int flags,
 
 	if (!entry) {
 		trace_seq_putc(s, '\n');
-		return TRACE_TYPE_HANDLED;
+		goto out;
 	}
 
 	if (entry->exit_event->event.type != ent->type) {
@@ -184,12 +172,11 @@ print_syscall_exit(struct trace_iterator *iter, int flags,
 		return TRACE_TYPE_UNHANDLED;
 	}
 
-	ret = trace_seq_printf(s, "%s -> 0x%lx\n", entry->name,
+	trace_seq_printf(s, "%s -> 0x%lx\n", entry->name,
 				trace->ret);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
 
-	return TRACE_TYPE_HANDLED;
+ out:
+	return trace_handle_return(s);
 }
 
 extern char *__bad_type_size(void);
-- 
2.1.1


