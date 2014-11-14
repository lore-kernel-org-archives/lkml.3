Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422862AbaKNXZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 18:25:06 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:59789 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935395AbaKNXZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 18:25:00 -0500
Message-Id: <20141114232452.692357576@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 14 Nov 2014 18:24:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [for-next][PATCH 5/9] tracing: Replace seq_printf by simpler equivalents
References: <20141114232401.493543108@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0005-tracing-Replace-seq_printf-by-simpler-equivalents.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Using seq_printf to print a simple string or a single character is a
lot more expensive than it needs to be, since seq_puts and seq_putc
exist.

These patches do

  seq_printf(m, s) -> seq_puts(m, s)
  seq_printf(m, "%s", s) -> seq_puts(m, s)
  seq_printf(m, "%c", c) -> seq_putc(m, c)

Subsequent patches will simplify further.

Link: http://lkml.kernel.org/r/1415479332-25944-2-git-send-email-linux@rasmusvillemoes.dk

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c                | 30 ++++++++++++------------
 kernel/trace/trace.c                 | 44 ++++++++++++++++++------------------
 kernel/trace/trace_branch.c          | 26 ++++++++++-----------
 kernel/trace/trace_events.c          |  4 ++--
 kernel/trace/trace_events_trigger.c  |  2 +-
 kernel/trace/trace_functions.c       |  2 +-
 kernel/trace/trace_functions_graph.c | 28 +++++++++++------------
 kernel/trace/trace_kprobe.c          |  4 ++--
 kernel/trace/trace_uprobe.c          |  2 +-
 9 files changed, 71 insertions(+), 71 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 1a13e615a068..6233f9102179 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -571,13 +571,13 @@ static int function_stat_cmp(void *p1, void *p2)
 static int function_stat_headers(struct seq_file *m)
 {
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-	seq_printf(m, "  Function                               "
-		   "Hit    Time            Avg             s^2\n"
-		      "  --------                               "
-		   "---    ----            ---             ---\n");
+	seq_puts(m, "  Function                               "
+		 "Hit    Time            Avg             s^2\n"
+		    "  --------                               "
+		 "---    ----            ---             ---\n");
 #else
-	seq_printf(m, "  Function                               Hit\n"
-		      "  --------                               ---\n");
+	seq_puts(m, "  Function                               Hit\n"
+		    "  --------                               ---\n");
 #endif
 	return 0;
 }
@@ -604,7 +604,7 @@ static int function_stat_show(struct seq_file *m, void *v)
 	seq_printf(m, "  %-30.30s  %10lu", str, rec->counter);
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-	seq_printf(m, "    ");
+	seq_puts(m, "    ");
 	avg = rec->time;
 	do_div(avg, rec->counter);
 
@@ -3006,9 +3006,9 @@ static int t_show(struct seq_file *m, void *v)
 
 	if (iter->flags & FTRACE_ITER_PRINTALL) {
 		if (iter->flags & FTRACE_ITER_NOTRACE)
-			seq_printf(m, "#### no functions disabled ####\n");
+			seq_puts(m, "#### no functions disabled ####\n");
 		else
-			seq_printf(m, "#### all functions enabled ####\n");
+			seq_puts(m, "#### all functions enabled ####\n");
 		return 0;
 	}
 
@@ -3030,13 +3030,13 @@ static int t_show(struct seq_file *m, void *v)
 				seq_printf(m, "\ttramp: %pS",
 					   (void *)ops->trampoline);
 			else
-				seq_printf(m, "\ttramp: ERROR!");
+				seq_puts(m, "\ttramp: ERROR!");
 
 		}
 		add_trampoline_func(m, ops, rec);
 	}	
 
-	seq_printf(m, "\n");
+	seq_putc(m, '\n');
 
 	return 0;
 }
@@ -4233,9 +4233,9 @@ static int g_show(struct seq_file *m, void *v)
 		struct ftrace_graph_data *fgd = m->private;
 
 		if (fgd->table == ftrace_graph_funcs)
-			seq_printf(m, "#### all functions enabled ####\n");
+			seq_puts(m, "#### all functions enabled ####\n");
 		else
-			seq_printf(m, "#### no functions disabled ####\n");
+			seq_puts(m, "#### no functions disabled ####\n");
 		return 0;
 	}
 
@@ -5155,12 +5155,12 @@ static int fpid_show(struct seq_file *m, void *v)
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
index 75798ab8eb88..a419db75152c 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2860,44 +2860,44 @@ static void test_ftrace_alive(struct seq_file *m)
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
@@ -3251,7 +3251,7 @@ static int t_show(struct seq_file *m, void *v)
 	if (!t)
 		return 0;
 
-	seq_printf(m, "%s", t->name);
+	seq_puts(m, t->name);
 	if (t->next)
 		seq_putc(m, ' ');
 	else
@@ -5753,10 +5753,10 @@ ftrace_snapshot_print(struct seq_file *m, unsigned long ip,
 
 	seq_printf(m, "%ps:", (void *)ip);
 
-	seq_printf(m, "snapshot");
+	seq_puts(m, "snapshot");
 
 	if (count == -1)
-		seq_printf(m, ":unlimited\n");
+		seq_puts(m, ":unlimited\n");
 	else
 		seq_printf(m, ":count=%ld\n", count);
 
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 697fb9bac8f0..126c622e4f42 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -233,12 +233,12 @@ extern unsigned long __stop_annotated_branch_profile[];
 
 static int annotated_branch_stat_headers(struct seq_file *m)
 {
-	seq_printf(m, " correct incorrect  %% ");
-	seq_printf(m, "       Function                "
-			      "  File              Line\n"
-			      " ------- ---------  - "
-			      "       --------                "
-			      "  ----              ----\n");
+	seq_puts(m, " correct incorrect  % ");
+	seq_puts(m, "       Function                "
+		    "  File              Line\n"
+		    " ------- ---------  - "
+		    "       --------                "
+		    "  ----              ----\n");
 	return 0;
 }
 
@@ -274,7 +274,7 @@ static int branch_stat_show(struct seq_file *m, void *v)
 
 	seq_printf(m, "%8lu %8lu ",  p->correct, p->incorrect);
 	if (percent < 0)
-		seq_printf(m, "  X ");
+		seq_puts(m, "  X ");
 	else
 		seq_printf(m, "%3ld ", percent);
 	seq_printf(m, "%-30.30s %-20.20s %d\n", p->func, f, p->line);
@@ -362,12 +362,12 @@ extern unsigned long __stop_branch_profile[];
 
 static int all_branch_stat_headers(struct seq_file *m)
 {
-	seq_printf(m, "   miss      hit    %% ");
-	seq_printf(m, "       Function                "
-			      "  File              Line\n"
-			      " ------- ---------  - "
-			      "       --------                "
-			      "  ----              ----\n");
+	seq_puts(m, "   miss      hit    % ");
+	seq_puts(m, "       Function                "
+		    "  File              Line\n"
+		    " ------- ---------  - "
+		    "       --------                "
+		    "  ----              ----\n");
 	return 0;
 }
 
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 0cc51edde3a8..f9d0cbe014b7 100644
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
index 4747b476a030..3d89ffc66740 100644
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
index 57f0ec962d2c..a8e0c7666164 100644
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
index f0a0c982cde3..29ba611e6f57 100644
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
index 282f6e4e5539..240d27ddf82e 100644
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
+	seq_putc(m, '\n');
 
 	return 0;
 }
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 33ff6a24b802..d22117beedd0 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -606,7 +606,7 @@ static int probes_seq_show(struct seq_file *m, void *v)
 	for (i = 0; i < tu->tp.nr_args; i++)
 		seq_printf(m, " %s=%s", tu->tp.args[i].name, tu->tp.args[i].comm);
 
-	seq_printf(m, "\n");
+	seq_putc(m, '\n');
 	return 0;
 }
 
-- 
2.1.1


