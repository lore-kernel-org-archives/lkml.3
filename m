Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbaKHUpT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 15:45:19 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:58836 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaKHUpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 15:45:14 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH v2 2/3] trace: Merge consecutive seq_puts calls
Date: Sat,  8 Nov 2014 21:42:11 +0100
Message-Id: <1415479332-25944-3-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1415479332-25944-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1410513954-28909-5-git-send-email-linux@rasmusvillemoes.dk>
 <1415479332-25944-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consecutive seq_puts calls with literal strings can be merged to a
single call. This reduces the size of the generated code, and can also
lead to slight .rodata reduction (because of fewer nul and padding
bytes). It should also shave a off a few clock cycles.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 kernel/trace/trace.c        | 64 ++++++++++++++++++++++-----------------------
 kernel/trace/trace_branch.c | 14 +++++-----
 2 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 77bb64f..32fb5a4 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2508,14 +2508,14 @@ get_total_entries(struct trace_buffer *buf,
 
 static void print_lat_help_header(struct seq_file *m)
 {
-	seq_puts(m, "#                  _------=> CPU#            \n");
-	seq_puts(m, "#                 / _-----=> irqs-off        \n");
-	seq_puts(m, "#                | / _----=> need-resched    \n");
-	seq_puts(m, "#                || / _---=> hardirq/softirq \n");
-	seq_puts(m, "#                ||| / _--=> preempt-depth   \n");
-	seq_puts(m, "#                |||| /     delay             \n");
-	seq_puts(m, "#  cmd     pid   ||||| time  |   caller      \n");
-	seq_puts(m, "#     \\   /      |||||  \\    |   /           \n");
+	seq_puts(m, "#                  _------=> CPU#            \n"
+		    "#                 / _-----=> irqs-off        \n"
+		    "#                | / _----=> need-resched    \n"
+		    "#                || / _---=> hardirq/softirq \n"
+		    "#                ||| / _--=> preempt-depth   \n"
+		    "#                |||| /     delay            \n"
+		    "#  cmd     pid   ||||| time  |   caller      \n"
+		    "#     \\   /      |||||  \\    |   /         \n");
 }
 
 static void print_event_info(struct trace_buffer *buf, struct seq_file *m)
@@ -2532,20 +2532,20 @@ static void print_event_info(struct trace_buffer *buf, struct seq_file *m)
 static void print_func_help_header(struct trace_buffer *buf, struct seq_file *m)
 {
 	print_event_info(buf, m);
-	seq_puts(m, "#           TASK-PID   CPU#      TIMESTAMP  FUNCTION\n");
-	seq_puts(m, "#              | |       |          |         |\n");
+	seq_puts(m, "#           TASK-PID   CPU#      TIMESTAMP  FUNCTION\n"
+		    "#              | |       |          |         |\n");
 }
 
 static void print_func_help_header_irq(struct trace_buffer *buf, struct seq_file *m)
 {
 	print_event_info(buf, m);
-	seq_puts(m, "#                              _-----=> irqs-off\n");
-	seq_puts(m, "#                             / _----=> need-resched\n");
-	seq_puts(m, "#                            | / _---=> hardirq/softirq\n");
-	seq_puts(m, "#                            || / _--=> preempt-depth\n");
-	seq_puts(m, "#                            ||| /     delay\n");
-	seq_puts(m, "#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION\n");
-	seq_puts(m, "#              | |       |   ||||       |         |\n");
+	seq_puts(m, "#                              _-----=> irqs-off\n"
+		    "#                             / _----=> need-resched\n"
+		    "#                            | / _---=> hardirq/softirq\n"
+		    "#                            || / _--=> preempt-depth\n"
+		    "#                            ||| /     delay\n"
+		    "#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION\n"
+		    "#              | |       |   ||||       |         |\n");
 }
 
 void
@@ -2859,34 +2859,34 @@ static void test_ftrace_alive(struct seq_file *m)
 {
 	if (!ftrace_is_dead())
 		return;
-	seq_puts(m, "# WARNING: FUNCTION TRACING IS CORRUPTED\n");
-	seq_puts(m, "#          MAY BE MISSING FUNCTION EVENTS\n");
+	seq_puts(m, "# WARNING: FUNCTION TRACING IS CORRUPTED\n"
+		    "#          MAY BE MISSING FUNCTION EVENTS\n");
 }
 
 #ifdef CONFIG_TRACER_MAX_TRACE
 static void show_snapshot_main_help(struct seq_file *m)
 {
-	seq_puts(m, "# echo 0 > snapshot : Clears and frees snapshot buffer\n");
-	seq_puts(m, "# echo 1 > snapshot : Allocates snapshot buffer, if not already allocated.\n");
-	seq_puts(m, "#                      Takes a snapshot of the main buffer.\n");
-	seq_puts(m, "# echo 2 > snapshot : Clears snapshot buffer (but does not allocate or free)\n");
-	seq_puts(m, "#                      (Doesn't have to be '2' works with any number that\n");
-	seq_puts(m, "#                       is not a '0' or '1')\n");
+	seq_puts(m, "# echo 0 > snapshot : Clears and frees snapshot buffer\n"
+		    "# echo 1 > snapshot : Allocates snapshot buffer, if not already allocated.\n"
+		    "#                      Takes a snapshot of the main buffer.\n"
+		    "# echo 2 > snapshot : Clears snapshot buffer (but does not allocate or free)\n"
+		    "#                      (Doesn't have to be '2' works with any number that\n"
+		    "#                       is not a '0' or '1')\n");
 }
 
 static void show_snapshot_percpu_help(struct seq_file *m)
 {
 	seq_puts(m, "# echo 0 > snapshot : Invalid for per_cpu snapshot file.\n");
 #ifdef CONFIG_RING_BUFFER_ALLOW_SWAP
-	seq_puts(m, "# echo 1 > snapshot : Allocates snapshot buffer, if not already allocated.\n");
-	seq_puts(m, "#                      Takes a snapshot of the main buffer for this cpu.\n");
+	seq_puts(m, "# echo 1 > snapshot : Allocates snapshot buffer, if not already allocated.\n"
+		    "#                      Takes a snapshot of the main buffer for this cpu.\n");
 #else
-	seq_puts(m, "# echo 1 > snapshot : Not supported with this kernel.\n");
-	seq_puts(m, "#                     Must use main snapshot file to allocate.\n");
+	seq_puts(m, "# echo 1 > snapshot : Not supported with this kernel.\n"
+		    "#                     Must use main snapshot file to allocate.\n");
 #endif
-	seq_puts(m, "# echo 2 > snapshot : Clears this cpu's snapshot buffer (but does not allocate)\n");
-	seq_puts(m, "#                      (Doesn't have to be '2' works with any number that\n");
-	seq_puts(m, "#                       is not a '0' or '1')\n");
+	seq_puts(m, "# echo 2 > snapshot : Clears this cpu's snapshot buffer (but does not allocate)\n"
+		    "#                      (Doesn't have to be '2' works with any number that\n"
+		    "#                       is not a '0' or '1')\n");
 }
 
 static void print_snapshot_help(struct seq_file *m, struct trace_iterator *iter)
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 126c622..a3916f6 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -164,9 +164,9 @@ static enum print_line_t trace_branch_print(struct trace_iterator *iter,
 static void branch_print_header(struct seq_file *s)
 {
 	seq_puts(s, "#           TASK-PID    CPU#    TIMESTAMP  CORRECT"
-		"  FUNC:FILE:LINE\n");
-	seq_puts(s, "#              | |       |          |         |   "
-		"    |\n");
+		    "  FUNC:FILE:LINE\n"
+		    "#              | |       |          |         |   "
+		    "    |\n");
 }
 
 static struct trace_event_functions trace_branch_funcs = {
@@ -233,8 +233,8 @@ extern unsigned long __stop_annotated_branch_profile[];
 
 static int annotated_branch_stat_headers(struct seq_file *m)
 {
-	seq_puts(m, " correct incorrect  % ");
-	seq_puts(m, "       Function                "
+	seq_puts(m, " correct incorrect  % "
+		    "       Function                "
 		    "  File              Line\n"
 		    " ------- ---------  - "
 		    "       --------                "
@@ -362,8 +362,8 @@ extern unsigned long __stop_branch_profile[];
 
 static int all_branch_stat_headers(struct seq_file *m)
 {
-	seq_puts(m, "   miss      hit    % ");
-	seq_puts(m, "       Function                "
+	seq_puts(m, "   miss      hit    % "
+		    "       Function                "
 		    "  File              Line\n"
 		    " ------- ---------  - "
 		    "       --------                "
-- 
2.0.4

