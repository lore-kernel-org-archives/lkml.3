Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbaILJ10 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 05:27:26 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:59561 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748AbaILJ03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 05:26:29 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Julia Lawall <Julia.Lawall@lip6.fr>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 6/6] trace: Replace single-character seq_puts with seq_putc
Date: Fri, 12 Sep 2014 11:25:54 +0200
Message-Id: <1410513954-28909-7-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1410513954-28909-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1410513954-28909-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Printing a single character to a seqfile might as well be done with
seq_putc instead of seq_puts; this avoids a strlen() call and a memory
access. It also shaves another few bytes off the generated code.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 kernel/trace/ftrace.c                |  2 +-
 kernel/trace/trace_events_trigger.c  |  4 ++--
 kernel/trace/trace_functions_graph.c |  4 ++--
 kernel/trace/trace_kprobe.c          | 10 +++++-----
 kernel/trace/trace_printk.c          |  2 +-
 kernel/trace/trace_uprobe.c          |  4 ++--
 6 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 7b9ce28..e931730 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2969,7 +2969,7 @@ static int t_show(struct seq_file *m, void *v)
 		}
 	}	
 
-	seq_puts(m, "\n");
+	seq_putc(m, '\n');
 
 	return 0;
 }
diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index 3d89ffc..8712df9 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -383,7 +383,7 @@ event_trigger_print(const char *name, struct seq_file *m,
 	if (filter_str)
 		seq_printf(m, " if %s\n", filter_str);
 	else
-		seq_puts(m, "\n");
+		seq_putc(m, '\n');
 
 	return 0;
 }
@@ -1105,7 +1105,7 @@ event_enable_trigger_print(struct seq_file *m, struct event_trigger_ops *ops,
 	if (data->filter_str)
 		seq_printf(m, " if %s\n", data->filter_str);
 	else
-		seq_puts(m, "\n");
+		seq_putc(m, '\n');
 
 	return 0;
 }
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 29ba611..a82d1d3 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -1407,7 +1407,7 @@ static void __print_graph_headers_flags(struct seq_file *s, u32 flags)
 		print_lat_header(s, flags);
 
 	/* 1st line */
-	seq_puts(s, "#");
+	seq_putc(s, '#');
 	if (flags & TRACE_GRAPH_PRINT_ABS_TIME)
 		seq_puts(s, "     TIME       ");
 	if (flags & TRACE_GRAPH_PRINT_CPU)
@@ -1421,7 +1421,7 @@ static void __print_graph_headers_flags(struct seq_file *s, u32 flags)
 	seq_puts(s, "               FUNCTION CALLS\n");
 
 	/* 2nd line */
-	seq_puts(s, "#");
+	seq_putc(s, '#');
 	if (flags & TRACE_GRAPH_PRINT_ABS_TIME)
 		seq_puts(s, "      |         ");
 	if (flags & TRACE_GRAPH_PRINT_CPU)
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index ce2ea71..ef7e7f1 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -840,7 +840,7 @@ static int probes_seq_show(struct seq_file *m, void *v)
 
 	for (i = 0; i < tk->tp.nr_args; i++)
 		seq_printf(m, " %s=%s", tk->tp.args[i].name, tk->tp.args[i].comm);
-	seq_puts(m, "\n");
+	seq_putc(m, '\n');
 
 	return 0;
 }
@@ -1030,7 +1030,7 @@ print_kprobe_event(struct trace_iterator *iter, int flags,
 	if (!seq_print_ip_sym(s, field->ip, flags | TRACE_ITER_SYM_OFFSET))
 		goto partial;
 
-	if (!trace_seq_puts(s, ")"))
+	if (!trace_seq_putc(s, ')'))
 		goto partial;
 
 	data = (u8 *)&field[1];
@@ -1039,7 +1039,7 @@ print_kprobe_event(struct trace_iterator *iter, int flags,
 					     data + tp->args[i].offset, field))
 			goto partial;
 
-	if (!trace_seq_puts(s, "\n"))
+	if (!trace_seq_putc(s, '\n'))
 		goto partial;
 
 	return TRACE_TYPE_HANDLED;
@@ -1072,7 +1072,7 @@ print_kretprobe_event(struct trace_iterator *iter, int flags,
 	if (!seq_print_ip_sym(s, field->func, flags & ~TRACE_ITER_SYM_OFFSET))
 		goto partial;
 
-	if (!trace_seq_puts(s, ")"))
+	if (!trace_seq_putc(s, ')'))
 		goto partial;
 
 	data = (u8 *)&field[1];
@@ -1081,7 +1081,7 @@ print_kretprobe_event(struct trace_iterator *iter, int flags,
 					     data + tp->args[i].offset, field))
 			goto partial;
 
-	if (!trace_seq_puts(s, "\n"))
+	if (!trace_seq_putc(s, '\n'))
 		goto partial;
 
 	return TRACE_TYPE_HANDLED;
diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
index 2900817..c4e70b6 100644
--- a/kernel/trace/trace_printk.c
+++ b/kernel/trace/trace_printk.c
@@ -305,7 +305,7 @@ static int t_show(struct seq_file *m, void *v)
 			seq_puts(m, "\\t");
 			break;
 		case '\\':
-			seq_puts(m, "\\");
+			seq_putc(m, '\\');
 			break;
 		case '"':
 			seq_puts(m, "\\\"");
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 184aec1..e35327c 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -606,7 +606,7 @@ static int probes_seq_show(struct seq_file *m, void *v)
 	for (i = 0; i < tu->tp.nr_args; i++)
 		seq_printf(m, " %s=%s", tu->tp.args[i].name, tu->tp.args[i].comm);
 
-	seq_puts(m, "\n");
+	seq_putc(m, '\n');
 	return 0;
 }
 
@@ -872,7 +872,7 @@ print_uprobe_event(struct trace_iterator *iter, int flags, struct trace_event *e
 			goto partial;
 	}
 
-	if (trace_seq_puts(s, "\n"))
+	if (trace_seq_putc(s, '\n'))
 		return TRACE_TYPE_HANDLED;
 
 partial:
-- 
2.0.4

