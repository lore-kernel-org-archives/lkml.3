Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab3JUCrR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 22:47:17 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:22710 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752277Ab3JUCqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 22:46:33 -0400
Message-Id: <20131021024630.653228933@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sun, 20 Oct 2013 22:44:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH 3/6] ftrace: Get rid of ftrace_graph_filter_enabled
References: <20131021024429.189874455@goodmis.org>
Content-Disposition: inline; filename=0003-ftrace-Get-rid-of-ftrace_graph_filter_enabled.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The ftrace_graph_filter_enabled means that user sets function filter
and it always has same meaning of ftrace_graph_count > 0.

Link: http://lkml.kernel.org/r/1381739066-7531-2-git-send-email-namhyung@kernel.org

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 6 +-----
 kernel/trace/trace.h  | 3 +--
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 03cf44a..a77e4a0 100644
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
index 10c86fb..40211ce 100644
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
1.8.4.rc3


