Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab3JNIYb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 04:24:31 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:58638 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab3JNIY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 04:24:29 -0400
X-AuditID: 9c93016f-b7c63ae00000696f-16-525baa3b77a8
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 1/4] ftrace: Get rid of ftrace_graph_filter_enabled
Date: Mon, 14 Oct 2013 17:24:23 +0900
Message-Id: <1381739066-7531-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1381739066-7531-1-git-send-email-namhyung@kernel.org>
References: <1381739066-7531-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The ftrace_graph_filter_enabled means that user sets function filter
and it always has same meaning of ftrace_graph_count > 0.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/ftrace.c | 6 +-----
 kernel/trace/trace.h  | 3 +--
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 03cf44ac54d3..a77e4a0142ee 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3776,7 +3776,6 @@ static const struct file_operations ftrace_notrace_fops = {
 static DEFINE_MUTEX(graph_lock);
 
 int ftrace_graph_count;
-int ftrace_graph_filter_enabled;
 unsigned long ftrace_graph_funcs[FTRACE_GRAPH_MAX_FUNCS] __read_mostly;
 
 static void *
@@ -3799,7 +3798,7 @@ static void *g_start(struct seq_file *m, loff_t *pos)
 	mutex_lock(&graph_lock);
 
 	/* Nothing, tell g_show to print all functions are enabled */
-	if (!ftrace_graph_filter_enabled && !*pos)
+	if (!ftrace_graph_count && !*pos)
 		return (void *)1;
 
 	return __g_next(m, pos);
@@ -3845,7 +3844,6 @@ ftrace_graph_open(struct inode *inode, struct file *file)
 	mutex_lock(&graph_lock);
 	if ((file->f_mode & FMODE_WRITE) &&
 	    (file->f_flags & O_TRUNC)) {
-		ftrace_graph_filter_enabled = 0;
 		ftrace_graph_count = 0;
 		memset(ftrace_graph_funcs, 0, sizeof(ftrace_graph_funcs));
 	}
@@ -3925,8 +3923,6 @@ out:
 	if (fail)
 		return -EINVAL;
 
-	ftrace_graph_filter_enabled = !!(*idx);
-
 	return 0;
 }
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 502fed770751..1ea31a7b1890 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -730,7 +730,6 @@ extern void __trace_graph_return(struct trace_array *tr,
 #ifdef CONFIG_DYNAMIC_FTRACE
 /* TODO: make this variable */
 #define FTRACE_GRAPH_MAX_FUNCS		32
-extern int ftrace_graph_filter_enabled;
 extern int ftrace_graph_count;
 extern unsigned long ftrace_graph_funcs[FTRACE_GRAPH_MAX_FUNCS];
 
@@ -738,7 +737,7 @@ static inline int ftrace_graph_addr(unsigned long addr)
 {
 	int i;
 
-	if (!ftrace_graph_filter_enabled)
+	if (!ftrace_graph_count)
 		return 1;
 
 	for (i = 0; i < ftrace_graph_count; i++) {
-- 
1.7.11.7

