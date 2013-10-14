Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab3JNIZO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 04:25:14 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:65160 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759Ab3JNIY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 04:24:29 -0400
X-AuditID: 9c93016f-b7c63ae00000696f-17-525baa3b456f
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 2/4] ftrace: Introduce struct ftrace_graph_data
Date: Mon, 14 Oct 2013 17:24:24 +0900
Message-Id: <1381739066-7531-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1381739066-7531-1-git-send-email-namhyung@kernel.org>
References: <1381739066-7531-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The struct ftrace_graph_data is for generalizing the access to
set_graph_function file.  This is a preparation for adding support to
set_graph_notrace.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/ftrace.c | 81 +++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 62 insertions(+), 19 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index a77e4a0142ee..0ff3449b4272 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3641,7 +3641,7 @@ __setup("ftrace_filter=", set_ftrace_filter);
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 static char ftrace_graph_buf[FTRACE_FILTER_SIZE] __initdata;
-static int ftrace_set_func(unsigned long *array, int *idx, char *buffer);
+static int ftrace_set_func(unsigned long *array, int *idx, int size, char *buffer);
 
 static int __init set_graph_function(char *str)
 {
@@ -3659,7 +3659,7 @@ static void __init set_ftrace_early_graph(char *buf)
 		func = strsep(&buf, ",");
 		/* we allow only one expression at a time */
 		ret = ftrace_set_func(ftrace_graph_funcs, &ftrace_graph_count,
-				      func);
+				      FTRACE_GRAPH_MAX_FUNCS, func);
 		if (ret)
 			printk(KERN_DEBUG "ftrace: function %s not "
 					  "traceable\n", func);
@@ -3778,12 +3778,21 @@ static DEFINE_MUTEX(graph_lock);
 int ftrace_graph_count;
 unsigned long ftrace_graph_funcs[FTRACE_GRAPH_MAX_FUNCS] __read_mostly;
 
+struct ftrace_graph_data {
+	unsigned long *table;
+	size_t size;
+	int *count;
+	const struct seq_operations *seq_ops;
+};
+
 static void *
 __g_next(struct seq_file *m, loff_t *pos)
 {
-	if (*pos >= ftrace_graph_count)
+	struct ftrace_graph_data *fgd = m->private;
+
+	if (*pos >= *fgd->count)
 		return NULL;
-	return &ftrace_graph_funcs[*pos];
+	return &fgd->table[*pos];
 }
 
 static void *
@@ -3795,10 +3804,12 @@ g_next(struct seq_file *m, void *v, loff_t *pos)
 
 static void *g_start(struct seq_file *m, loff_t *pos)
 {
+	struct ftrace_graph_data *fgd = m->private;
+
 	mutex_lock(&graph_lock);
 
 	/* Nothing, tell g_show to print all functions are enabled */
-	if (!ftrace_graph_count && !*pos)
+	if (!*fgd->count && !*pos)
 		return (void *)1;
 
 	return __g_next(m, pos);
@@ -3834,37 +3845,68 @@ static const struct seq_operations ftrace_graph_seq_ops = {
 };
 
 static int
-ftrace_graph_open(struct inode *inode, struct file *file)
+__ftrace_graph_open(struct inode *inode, struct file *file,
+		    struct ftrace_graph_data *fgd)
 {
 	int ret = 0;
 
-	if (unlikely(ftrace_disabled))
-		return -ENODEV;
-
 	mutex_lock(&graph_lock);
 	if ((file->f_mode & FMODE_WRITE) &&
 	    (file->f_flags & O_TRUNC)) {
-		ftrace_graph_count = 0;
-		memset(ftrace_graph_funcs, 0, sizeof(ftrace_graph_funcs));
+		*fgd->count = 0;
+		memset(fgd->table, 0, fgd->size * sizeof(*fgd->table));
 	}
 	mutex_unlock(&graph_lock);
 
-	if (file->f_mode & FMODE_READ)
-		ret = seq_open(file, &ftrace_graph_seq_ops);
+	if (file->f_mode & FMODE_READ) {
+		ret = seq_open(file, fgd->seq_ops);
+		if (!ret) {
+			struct seq_file *m = file->private_data;
+			m->private = fgd;
+		}
+	} else
+		file->private_data = fgd;
 
 	return ret;
 }
 
 static int
+ftrace_graph_open(struct inode *inode, struct file *file)
+{
+	struct ftrace_graph_data *fgd;
+
+	if (unlikely(ftrace_disabled))
+		return -ENODEV;
+
+	fgd = kmalloc(sizeof(*fgd), GFP_KERNEL);
+	if (fgd == NULL)
+		return -ENOMEM;
+
+	fgd->table = ftrace_graph_funcs;
+	fgd->size = FTRACE_GRAPH_MAX_FUNCS;
+	fgd->count = &ftrace_graph_count;
+	fgd->seq_ops = &ftrace_graph_seq_ops;
+
+	return __ftrace_graph_open(inode, file, fgd);
+}
+
+static int
 ftrace_graph_release(struct inode *inode, struct file *file)
 {
-	if (file->f_mode & FMODE_READ)
+	if (file->f_mode & FMODE_READ) {
+		struct seq_file *m = file->private_data;
+
+		kfree(m->private);
 		seq_release(inode, file);
+	} else {
+		kfree(file->private_data);
+	}
+
 	return 0;
 }
 
 static int
-ftrace_set_func(unsigned long *array, int *idx, char *buffer)
+ftrace_set_func(unsigned long *array, int *idx, int size, char *buffer)
 {
 	struct dyn_ftrace *rec;
 	struct ftrace_page *pg;
@@ -3877,7 +3919,7 @@ ftrace_set_func(unsigned long *array, int *idx, char *buffer)
 
 	/* decode regex */
 	type = filter_parse_regex(buffer, strlen(buffer), &search, &not);
-	if (!not && *idx >= FTRACE_GRAPH_MAX_FUNCS)
+	if (!not && *idx >= size)
 		return -EBUSY;
 
 	search_len = strlen(search);
@@ -3905,7 +3947,7 @@ ftrace_set_func(unsigned long *array, int *idx, char *buffer)
 				fail = 0;
 				if (!exists) {
 					array[(*idx)++] = rec->ip;
-					if (*idx >= FTRACE_GRAPH_MAX_FUNCS)
+					if (*idx >= size)
 						goto out;
 				}
 			} else {
@@ -3932,6 +3974,7 @@ ftrace_graph_write(struct file *file, const char __user *ubuf,
 {
 	struct trace_parser parser;
 	ssize_t read, ret;
+	struct ftrace_graph_data *fgd = file->private_data;
 
 	if (!cnt)
 		return 0;
@@ -3949,8 +3992,8 @@ ftrace_graph_write(struct file *file, const char __user *ubuf,
 		parser.buffer[parser.idx] = 0;
 
 		/* we allow only one expression at a time */
-		ret = ftrace_set_func(ftrace_graph_funcs, &ftrace_graph_count,
-					parser.buffer);
+		ret = ftrace_set_func(fgd->table, fgd->count, fgd->size,
+				      parser.buffer);
 		if (ret)
 			goto out_free;
 	}
-- 
1.7.11.7

