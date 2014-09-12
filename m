Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbaILJ3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 05:29:17 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:43764 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930AbaILJ01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 05:26:27 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Julia Lawall <Julia.Lawall@lip6.fr>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 4/6] trace: Replace seq_printf by simpler equivalents
Date: Fri, 12 Sep 2014 11:25:52 +0200
Message-Id: <1410513954-28909-5-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1410513954-28909-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1410513954-28909-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using seq_printf to print a simple string or a single character is a
lot more expensive than it needs to be, since seq_puts and seq_putc
exist.

These patches do

  seq_printf(m, s) -> seq_puts(m, s)
  seq_printf(m, "%s", s) -> seq_puts(m, s)
  seq_printf(m, "%c", c) -> seq_putc(m, c)

Subsequent patches will simplify further.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 kernel/trace/ftrace.c                | 30 ++++++++++++------------
 kernel/trace/trace.c                 | 44 ++++++++++++++++++------------------
 kernel/trace/trace_branch.c          | 24 +++++++++-----------
 kernel/trace/trace_events.c          |  4 ++--
 kernel/trace/trace_events_trigger.c  |  2 +-
 kernel/trace/trace_functions.c       |  2 +-
 kernel/trace/trace_functions_graph.c | 28 +++++++++++------------
 kernel/trace/trace_kprobe.c          |  4 ++--
 kernel/trace/trace_uprobe.c          |  2 +-
 9 files changed, 69 insertions(+), 71 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 5916a8e..7b9ce28 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -556,13 +556,13 @@ static int function_stat_cmp(void *p1, void *p2)
 static int function_stat_headers(struct seq_file *m)
 {
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-	seq_printf(m, "  Function                               "
-		   "Hit    Time            Avg             s^2\n"
-		      "  --------                               "
-		   "---    ----            ---             ---\n");
+	seq_puts(m,
+		 "  Function                               " "Hit    Time            Avg             s^2\n"
+		 "  --------                               " "---    ----            ---             ---\n");
 #else
-	seq_printf(m, "  Function                               Hit\n"
-		      "  --------                               ---\n");
+	seq_puts(m,
+		 "  Function                               Hit\n"
+		 "  --------                               ---\n");
 #endif
 	return 0;
 }
@@ -589,7 +589,7 @@ static int function_stat_show(struct seq_file *m, void *v)
 	seq_printf(m, "  %-30.30s  %10lu", str, rec->counter);
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-	seq_printf(m, "    ");
+	seq_puts(m, "    ");
 	avg = rec->time;
 	do_div(avg, rec->counter);
 
@@ -2941,9 +2941,9 @@ static int t_show(struct seq_file *m, void *v)
 
 	if (iter->flags & FTRACE_ITER_PRINTALL) {
 		if (iter->flags & FTRACE_ITER_NOTRACE)
-			seq_printf(m, "#### no functions disabled ####\n");
+			seq_puts(m, "#### no functions disabled ####\n");
 		else
-			seq_printf(m, "#### all functions enabled ####\n");
+			seq_puts(m, "#### all functions enabled ####\n");
 		return 0;
 	}
 
@@ -2965,11 +2965,11 @@ static int t_show(struct seq_file *m, void *v)
 				seq_printf(m, "\ttramp: %pS",
 					   (void *)ops->trampoline);
 			else
-				seq_printf(m, "\ttramp: ERROR!");
+				seq_puts(m, "\ttramp: ERROR!");
 		}
 	}	
 
-	seq_printf(m, "\n");
+	seq_puts(m, "\n");
 
 	return 0;
 }
@@ -4149,9 +4149,9 @@ static int g_show(struct seq_file *m, void *v)
 		struct ftrace_graph_data *fgd = m->private;
 
 		if (fgd->table == ftrace_graph_funcs)
-			seq_printf(m, "#### all functions enabled ####\n");
+			seq_puts(m, "#### all functions enabled ####\n");
 		else
-			seq_printf(m, "#### no functions disabled ####\n");
+			seq_puts(m, "#### no functions disabled ####\n");
 		return 0;
 	}
 
@@ -4989,12 +4989,12 @@ static int fpid_show(struct seq_file *m, void *v)
 	const struct ftrace_pid *fpid = list_entry(v, struct ftrace_pid, list);
 
 	if (v == (void *)1) {
-		seq_printf(m, "no pid\n");
+		seq_puts(m, "no pid\n");
 		return 0;
 	}
 
 	if (fpid->pid == ftrace_swapper_pid)
-		seq_printf(m, "swapper tasks\n");
+		seq_puts(m, "swapper tasks\n");
 	else
 		seq_printf(m, "%u\n", pid_vnr(fpid->pid));
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8a52839..77bb64f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2859,44 +2859,44 @@ static void test_ftrace_alive(struct seq_file *m)
 {
 	if (!ftrace_is_dead())
 		return;
-	seq_printf(m, "# WARNING: FUNCTION TRACING IS CORRUPTED\n");
-	seq_printf(m, "#          MAY BE MISSING FUNCTION EVENTS\n");
+	seq_puts(m, "# WARNING: FUNCTION TRACING IS CORRUPTED\n");
+	seq_puts(m, "#          MAY BE MISSING FUNCTION EVENTS\n");
 }
 
 #ifdef CONFIG_TRACER_MAX_TRACE
 static void show_snapshot_main_help(struct seq_file *m)
 {
-	seq_printf(m, "# echo 0 > snapshot : Clears and frees snapshot buffer\n");
-	seq_printf(m, "# echo 1 > snapshot : Allocates snapshot buffer, if not already allocated.\n");
-	seq_printf(m, "#                      Takes a snapshot of the main buffer.\n");
-	seq_printf(m, "# echo 2 > snapshot : Clears snapshot buffer (but does not allocate or free)\n");
-	seq_printf(m, "#                      (Doesn't have to be '2' works with any number that\n");
-	seq_printf(m, "#                       is not a '0' or '1')\n");
+	seq_puts(m, "# echo 0 > snapshot : Clears and frees snapshot buffer\n");
+	seq_puts(m, "# echo 1 > snapshot : Allocates snapshot buffer, if not already allocated.\n");
+	seq_puts(m, "#                      Takes a snapshot of the main buffer.\n");
+	seq_puts(m, "# echo 2 > snapshot : Clears snapshot buffer (but does not allocate or free)\n");
+	seq_puts(m, "#                      (Doesn't have to be '2' works with any number that\n");
+	seq_puts(m, "#                       is not a '0' or '1')\n");
 }
 
 static void show_snapshot_percpu_help(struct seq_file *m)
 {
-	seq_printf(m, "# echo 0 > snapshot : Invalid for per_cpu snapshot file.\n");
+	seq_puts(m, "# echo 0 > snapshot : Invalid for per_cpu snapshot file.\n");
 #ifdef CONFIG_RING_BUFFER_ALLOW_SWAP
-	seq_printf(m, "# echo 1 > snapshot : Allocates snapshot buffer, if not already allocated.\n");
-	seq_printf(m, "#                      Takes a snapshot of the main buffer for this cpu.\n");
+	seq_puts(m, "# echo 1 > snapshot : Allocates snapshot buffer, if not already allocated.\n");
+	seq_puts(m, "#                      Takes a snapshot of the main buffer for this cpu.\n");
 #else
-	seq_printf(m, "# echo 1 > snapshot : Not supported with this kernel.\n");
-	seq_printf(m, "#                     Must use main snapshot file to allocate.\n");
+	seq_puts(m, "# echo 1 > snapshot : Not supported with this kernel.\n");
+	seq_puts(m, "#                     Must use main snapshot file to allocate.\n");
 #endif
-	seq_printf(m, "# echo 2 > snapshot : Clears this cpu's snapshot buffer (but does not allocate)\n");
-	seq_printf(m, "#                      (Doesn't have to be '2' works with any number that\n");
-	seq_printf(m, "#                       is not a '0' or '1')\n");
+	seq_puts(m, "# echo 2 > snapshot : Clears this cpu's snapshot buffer (but does not allocate)\n");
+	seq_puts(m, "#                      (Doesn't have to be '2' works with any number that\n");
+	seq_puts(m, "#                       is not a '0' or '1')\n");
 }
 
 static void print_snapshot_help(struct seq_file *m, struct trace_iterator *iter)
 {
 	if (iter->tr->allocated_snapshot)
-		seq_printf(m, "#\n# * Snapshot is allocated *\n#\n");
+		seq_puts(m, "#\n# * Snapshot is allocated *\n#\n");
 	else
-		seq_printf(m, "#\n# * Snapshot is freed *\n#\n");
+		seq_puts(m, "#\n# * Snapshot is freed *\n#\n");
 
-	seq_printf(m, "# Snapshot commands:\n");
+	seq_puts(m, "# Snapshot commands:\n");
 	if (iter->cpu_file == RING_BUFFER_ALL_CPUS)
 		show_snapshot_main_help(m);
 	else
@@ -3250,7 +3250,7 @@ static int t_show(struct seq_file *m, void *v)
 	if (!t)
 		return 0;
 
-	seq_printf(m, "%s", t->name);
+	seq_puts(m, t->name);
 	if (t->next)
 		seq_putc(m, ' ');
 	else
@@ -5752,10 +5752,10 @@ ftrace_snapshot_print(struct seq_file *m, unsigned long ip,
 
 	seq_printf(m, "%ps:", (void *)ip);
 
-	seq_printf(m, "snapshot");
+	seq_puts(m, "snapshot");
 
 	if (count == -1)
-		seq_printf(m, ":unlimited\n");
+		seq_puts(m, ":unlimited\n");
 	else
 		seq_printf(m, ":count=%ld\n", count);
 
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 697fb9b..c38f8fa 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -233,12 +233,13 @@ extern unsigned long __stop_annotated_branch_profile[];
 
 static int annotated_branch_stat_headers(struct seq_file *m)
 {
-	seq_printf(m, " correct incorrect  %% ");
-	seq_printf(m, "       Function                "
-			      "  File              Line\n"
-			      " ------- ---------  - "
-			      "       --------                "
-			      "  ----              ----\n");
+	seq_puts(m, " correct incorrect  % ");
+	seq_puts(m,
+		 "       Function                "
+		 "  File              Line\n"
+		 " ------- ---------  - "
+		 "       --------                "
+		 "  ----              ----\n");
 	return 0;
 }
 
@@ -274,7 +275,7 @@ static int branch_stat_show(struct seq_file *m, void *v)
 
 	seq_printf(m, "%8lu %8lu ",  p->correct, p->incorrect);
 	if (percent < 0)
-		seq_printf(m, "  X ");
+		seq_puts(m, "  X ");
 	else
 		seq_printf(m, "%3ld ", percent);
 	seq_printf(m, "%-30.30s %-20.20s %d\n", p->func, f, p->line);
@@ -362,12 +363,9 @@ extern unsigned long __stop_branch_profile[];
 
 static int all_branch_stat_headers(struct seq_file *m)
 {
-	seq_printf(m, "   miss      hit    %% ");
-	seq_printf(m, "       Function                "
-			      "  File              Line\n"
-			      " ------- ---------  - "
-			      "       --------                "
-			      "  ----              ----\n");
+	seq_puts(m, "   miss      hit    % ");
+	seq_puts(m,
+		 "       Function                " "  File              Line\n" " ------- ---------  - " "       --------                " "  ----              ----\n");
 	return 0;
 }
 
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index ef06ce7..32f0199 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -918,7 +918,7 @@ static int f_show(struct seq_file *m, void *v)
 	case FORMAT_HEADER:
 		seq_printf(m, "name: %s\n", ftrace_event_name(call));
 		seq_printf(m, "ID: %d\n", call->event.type);
-		seq_printf(m, "format:\n");
+		seq_puts(m, "format:\n");
 		return 0;
 
 	case FORMAT_FIELD_SEPERATOR:
@@ -1988,7 +1988,7 @@ event_enable_print(struct seq_file *m, unsigned long ip,
 		   ftrace_event_name(data->file->event_call));
 
 	if (data->count == -1)
-		seq_printf(m, ":unlimited\n");
+		seq_puts(m, ":unlimited\n");
 	else
 		seq_printf(m, ":count=%ld\n", data->count);
 
diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index 4747b47..3d89ffc 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -373,7 +373,7 @@ event_trigger_print(const char *name, struct seq_file *m,
 {
 	long count = (long)data;
 
-	seq_printf(m, "%s", name);
+	seq_puts(m, name);
 
 	if (count == -1)
 		seq_puts(m, ":unlimited");
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 57f0ec9..a8e0c76 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -361,7 +361,7 @@ ftrace_probe_print(const char *name, struct seq_file *m,
 	seq_printf(m, "%ps:%s", (void *)ip, name);
 
 	if (count == -1)
-		seq_printf(m, ":unlimited\n");
+		seq_puts(m, ":unlimited\n");
 	else
 		seq_printf(m, ":count=%ld\n", count);
 
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index f0a0c98..29ba611 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -1407,32 +1407,32 @@ static void __print_graph_headers_flags(struct seq_file *s, u32 flags)
 		print_lat_header(s, flags);
 
 	/* 1st line */
-	seq_printf(s, "#");
+	seq_puts(s, "#");
 	if (flags & TRACE_GRAPH_PRINT_ABS_TIME)
-		seq_printf(s, "     TIME       ");
+		seq_puts(s, "     TIME       ");
 	if (flags & TRACE_GRAPH_PRINT_CPU)
-		seq_printf(s, " CPU");
+		seq_puts(s, " CPU");
 	if (flags & TRACE_GRAPH_PRINT_PROC)
-		seq_printf(s, "  TASK/PID       ");
+		seq_puts(s, "  TASK/PID       ");
 	if (lat)
-		seq_printf(s, "||||");
+		seq_puts(s, "||||");
 	if (flags & TRACE_GRAPH_PRINT_DURATION)
-		seq_printf(s, "  DURATION   ");
-	seq_printf(s, "               FUNCTION CALLS\n");
+		seq_puts(s, "  DURATION   ");
+	seq_puts(s, "               FUNCTION CALLS\n");
 
 	/* 2nd line */
-	seq_printf(s, "#");
+	seq_puts(s, "#");
 	if (flags & TRACE_GRAPH_PRINT_ABS_TIME)
-		seq_printf(s, "      |         ");
+		seq_puts(s, "      |         ");
 	if (flags & TRACE_GRAPH_PRINT_CPU)
-		seq_printf(s, " |  ");
+		seq_puts(s, " |  ");
 	if (flags & TRACE_GRAPH_PRINT_PROC)
-		seq_printf(s, "   |    |        ");
+		seq_puts(s, "   |    |        ");
 	if (lat)
-		seq_printf(s, "||||");
+		seq_puts(s, "||||");
 	if (flags & TRACE_GRAPH_PRINT_DURATION)
-		seq_printf(s, "   |   |      ");
-	seq_printf(s, "               |   |   |   |\n");
+		seq_puts(s, "   |   |      ");
+	seq_puts(s, "               |   |   |   |\n");
 }
 
 static void print_graph_headers(struct seq_file *s)
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 282f6e4..ce2ea71 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -826,7 +826,7 @@ static int probes_seq_show(struct seq_file *m, void *v)
 	struct trace_kprobe *tk = v;
 	int i;
 
-	seq_printf(m, "%c", trace_kprobe_is_return(tk) ? 'r' : 'p');
+	seq_putc(m, trace_kprobe_is_return(tk) ? 'r' : 'p');
 	seq_printf(m, ":%s/%s", tk->tp.call.class->system,
 			ftrace_event_name(&tk->tp.call));
 
@@ -840,7 +840,7 @@ static int probes_seq_show(struct seq_file *m, void *v)
 
 	for (i = 0; i < tk->tp.nr_args; i++)
 		seq_printf(m, " %s=%s", tk->tp.args[i].name, tk->tp.args[i].comm);
-	seq_printf(m, "\n");
+	seq_puts(m, "\n");
 
 	return 0;
 }
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 33ff6a2..184aec1 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -606,7 +606,7 @@ static int probes_seq_show(struct seq_file *m, void *v)
 	for (i = 0; i < tu->tp.nr_args; i++)
 		seq_printf(m, " %s=%s", tu->tp.args[i].name, tu->tp.args[i].comm);
 
-	seq_printf(m, "\n");
+	seq_puts(m, "\n");
 	return 0;
 }
 
-- 
2.0.4

