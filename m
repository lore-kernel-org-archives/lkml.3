Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab3FKJJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 05:09:41 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:51979 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab3FKJJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 05:09:39 -0400
From: Juri Lelli <juri.lelli@gmail.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, juri.lelli@gmail.com
Subject: [PATCH 1/3] ftrace: refactor basis statistics calculation code
Date: Tue, 11 Jun 2013 11:08:46 +0200
Message-Id: <1370941728-15456-2-git-send-email-juri.lelli@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370941728-15456-1-git-send-email-juri.lelli@gmail.com>
References: <1370941728-15456-1-git-send-email-juri.lelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor function_stat_show() code grouping avg and stddev calculations
inside a single function (function_stat_calc()). We are now able to call
it from different places.

Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 kernel/trace/ftrace.c |   46 ++++++++++++++++++++++------------------------
 kernel/trace/trace.h  |   16 ++++++++++++++++
 2 files changed, 38 insertions(+), 24 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 6c508ff..6caaa0e 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -473,16 +473,6 @@ static void ftrace_update_pid_func(void)
 }
 
 #ifdef CONFIG_FUNCTION_PROFILER
-struct ftrace_profile {
-	struct hlist_node		node;
-	unsigned long			ip;
-	unsigned long			counter;
-#ifdef CONFIG_FUNCTION_GRAPH_TRACER
-	unsigned long long		time;
-	unsigned long long		time_squared;
-#endif
-};
-
 struct ftrace_profile_page {
 	struct ftrace_profile_page	*next;
 	unsigned long			index;
@@ -592,6 +582,27 @@ static int function_stat_headers(struct seq_file *m)
 	return 0;
 }
 
+void function_stat_calc(struct ftrace_profile *rec,
+			       unsigned long long *avg,
+			       unsigned long long *stddev)
+{
+	*avg = rec->time;
+	do_div(*avg, rec->counter);
+
+	/* Sample standard deviation (s^2) */
+	if (rec->counter <= 1)
+		*stddev = 0;
+	else {
+		*stddev = rec->time_squared - rec->counter * (*avg) * (*avg);
+
+		/*
+		 * Divide only 1000 for ns^2 -> us^2 conversion.
+		 * trace_print_graph_duration will divide 1000 again.
+		 */
+		do_div(*stddev, (rec->counter - 1) * 1000);
+	}
+}
+
 static int function_stat_show(struct seq_file *m, void *v)
 {
 	struct ftrace_profile *rec = v;
@@ -615,20 +626,7 @@ static int function_stat_show(struct seq_file *m, void *v)
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	seq_printf(m, "    ");
-	avg = rec->time;
-	do_div(avg, rec->counter);
-
-	/* Sample standard deviation (s^2) */
-	if (rec->counter <= 1)
-		stddev = 0;
-	else {
-		stddev = rec->time_squared - rec->counter * avg * avg;
-		/*
-		 * Divide only 1000 for ns^2 -> us^2 conversion.
-		 * trace_print_graph_duration will divide 1000 again.
-		 */
-		do_div(stddev, (rec->counter - 1) * 1000);
-	}
+	function_stat_calc(rec, &avg, &stddev);
 
 	trace_seq_init(&s);
 	trace_print_graph_duration(rec->time, &s);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 711ca7d..89c8a7b 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1062,4 +1062,20 @@ int perf_ftrace_event_register(struct ftrace_event_call *call,
 #define perf_ftrace_event_register NULL
 #endif
 
+#ifdef CONFIG_FUNCTION_PROFILER
+struct ftrace_profile {
+	struct hlist_node		node;
+	unsigned long			ip;
+	unsigned long			counter;
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	unsigned long long		time;
+	unsigned long long		time_squared;
+#endif
+};
+
+void function_stat_calc(struct ftrace_profile *rec,
+			       unsigned long long *avg,
+			       unsigned long long *stddev);
+#endif
+
 #endif /* _LINUX_KERNEL_TRACE_H */
-- 
1.7.9.5

