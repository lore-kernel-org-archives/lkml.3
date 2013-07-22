Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab3GVOVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 10:21:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7711 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227Ab3GVOV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 10:21:27 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=4-RujkMt7QsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=sVsboJVBK0AA:10 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=-ZwrPxqXzBW1ZZGbd6MA:9 a=UTB_XpHje0EA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130722142125.753163340@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 22 Jul 2013 10:19:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, <stable@vger.kernel.org>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        David Sharp <dhsharp@google.com>,
        Alexander Z Lam <lambchop468@gmail.com>,
        Alexander Z Lam <azl@google.com>
Subject: [PATCH 09/14] tracing: Miscellaneous fixes for trace_array ref counting
References: <20130722141947.972915744@goodmis.org>
Content-Disposition: inline; filename=0009-tracing-Miscellaneous-fixes-for-trace_array-ref-coun.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Z Lam <azl@google.com>

Some error paths did not handle ref counting properly, and some trace files need
ref counting.

Link: http://lkml.kernel.org/r/1374171524-11948-1-git-send-email-azl@google.com

Cc: stable@vger.kernel.org # 3.10
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: David Sharp <dhsharp@google.com>
Cc: Alexander Z Lam <lambchop468@gmail.com>
Signed-off-by: Alexander Z Lam <azl@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c        |   24 ++++++++++++++++++------
 kernel/trace/trace_events.c |   21 +++++++++++++++++++--
 2 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 7c3da7b..7d9ceab 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3008,7 +3008,6 @@ static int tracing_release(struct inode *inode, struct file *file)
 
 	iter = m->private;
 	tr = iter->tr;
-	trace_array_put(tr);
 
 	mutex_lock(&trace_types_lock);
 
@@ -3023,6 +3022,9 @@ static int tracing_release(struct inode *inode, struct file *file)
 	if (!iter->snapshot)
 		/* reenable tracing if it was previously enabled */
 		tracing_start_tr(tr);
+
+	__trace_array_put(tr);
+
 	mutex_unlock(&trace_types_lock);
 
 	mutex_destroy(&iter->mutex);
@@ -3447,6 +3449,7 @@ tracing_trace_options_write(struct file *filp, const char __user *ubuf,
 static int tracing_trace_options_open(struct inode *inode, struct file *file)
 {
 	struct trace_array *tr = inode->i_private;
+	int ret;
 
 	if (tracing_disabled)
 		return -ENODEV;
@@ -3454,7 +3457,11 @@ static int tracing_trace_options_open(struct inode *inode, struct file *file)
 	if (trace_array_get(tr) < 0)
 		return -ENODEV;
 
-	return single_open(file, tracing_trace_options_show, inode->i_private);
+	ret = single_open(file, tracing_trace_options_show, inode->i_private);
+	if (ret < 0)
+		trace_array_put(tr);
+
+	return ret;
 }
 
 static const struct file_operations tracing_iter_fops = {
@@ -3958,6 +3965,7 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
 	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
 	if (!iter) {
 		ret = -ENOMEM;
+		__trace_array_put(tr);
 		goto out;
 	}
 
@@ -4704,21 +4712,24 @@ static int tracing_snapshot_open(struct inode *inode, struct file *file)
 			ret = PTR_ERR(iter);
 	} else {
 		/* Writes still need the seq_file to hold the private data */
+		ret = -ENOMEM;
 		m = kzalloc(sizeof(*m), GFP_KERNEL);
 		if (!m)
-			return -ENOMEM;
+			goto out;
 		iter = kzalloc(sizeof(*iter), GFP_KERNEL);
 		if (!iter) {
 			kfree(m);
-			return -ENOMEM;
+			goto out;
 		}
+		ret = 0;
+
 		iter->tr = tr;
 		iter->trace_buffer = &tc->tr->max_buffer;
 		iter->cpu_file = tc->cpu;
 		m->private = iter;
 		file->private_data = m;
 	}
-
+out:
 	if (ret < 0)
 		trace_array_put(tr);
 
@@ -5328,9 +5339,10 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
 }
 
 static const struct file_operations tracing_stats_fops = {
-	.open		= tracing_open_generic,
+	.open		= tracing_open_generic_tc,
 	.read		= tracing_stats_read,
 	.llseek		= generic_file_llseek,
+	.release	= tracing_release_generic_tc,
 };
 
 #ifdef CONFIG_DYNAMIC_FTRACE
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 7d85429..7a75cb2 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1218,6 +1218,7 @@ show_header(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
 
 static int ftrace_event_avail_open(struct inode *inode, struct file *file);
 static int ftrace_event_set_open(struct inode *inode, struct file *file);
+static int ftrace_event_release(struct inode *inode, struct file *file);
 
 static const struct seq_operations show_event_seq_ops = {
 	.start = t_start,
@@ -1245,7 +1246,7 @@ static const struct file_operations ftrace_set_event_fops = {
 	.read = seq_read,
 	.write = ftrace_event_write,
 	.llseek = seq_lseek,
-	.release = seq_release,
+	.release = ftrace_event_release,
 };
 
 static const struct file_operations ftrace_enable_fops = {
@@ -1323,6 +1324,15 @@ ftrace_event_open(struct inode *inode, struct file *file,
 	return ret;
 }
 
+static int ftrace_event_release(struct inode *inode, struct file *file)
+{
+	struct trace_array *tr = inode->i_private;
+
+	trace_array_put(tr);
+
+	return seq_release(inode, file);
+}
+
 static int
 ftrace_event_avail_open(struct inode *inode, struct file *file)
 {
@@ -1336,12 +1346,19 @@ ftrace_event_set_open(struct inode *inode, struct file *file)
 {
 	const struct seq_operations *seq_ops = &show_set_event_seq_ops;
 	struct trace_array *tr = inode->i_private;
+	int ret;
+
+	if (trace_array_get(tr) < 0)
+		return -ENODEV;
 
 	if ((file->f_mode & FMODE_WRITE) &&
 	    (file->f_flags & O_TRUNC))
 		ftrace_clear_events(tr);
 
-	return ftrace_event_open(inode, file, seq_ops);
+	ret = ftrace_event_open(inode, file, seq_ops);
+	if (ret < 0)
+		trace_array_put(tr);
+	return ret;
 }
 
 static struct event_subsystem *
-- 
1.7.10.4


