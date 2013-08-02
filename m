Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab3HBK43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:56:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37070 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758896Ab3HBKIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:08:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexander Z Lam <azl@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        David Sharp <dhsharp@google.com>,
        Alexander Z Lam <lambchop468@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [ 19/99] tracing: Miscellaneous fixes for trace_array ref counting
Date: Fri,  2 Aug 2013 18:07:32 +0800
Message-Id: <20130802100228.729946852@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Z Lam <azl@google.com>

commit f77d09a384676bde6445413949d9d2c508ff3e62 upstream.

Some error paths did not handle ref counting properly, and some trace files need
ref counting.

Link: http://lkml.kernel.org/r/1374171524-11948-1-git-send-email-azl@google.com

Signed-off-by: Alexander Z Lam <azl@google.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: David Sharp <dhsharp@google.com>
Cc: Alexander Z Lam <lambchop468@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace.c        |   24 ++++++++++++++++++------
 kernel/trace/trace_events.c |   21 +++++++++++++++++++--
 2 files changed, 37 insertions(+), 8 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2956,7 +2956,6 @@ static int tracing_release(struct inode
 
 	iter = m->private;
 	tr = iter->tr;
-	trace_array_put(tr);
 
 	mutex_lock(&trace_types_lock);
 
@@ -2971,6 +2970,9 @@ static int tracing_release(struct inode
 	if (!iter->snapshot)
 		/* reenable tracing if it was previously enabled */
 		tracing_start_tr(tr);
+
+	__trace_array_put(tr);
+
 	mutex_unlock(&trace_types_lock);
 
 	mutex_destroy(&iter->mutex);
@@ -3395,6 +3397,7 @@ tracing_trace_options_write(struct file
 static int tracing_trace_options_open(struct inode *inode, struct file *file)
 {
 	struct trace_array *tr = inode->i_private;
+	int ret;
 
 	if (tracing_disabled)
 		return -ENODEV;
@@ -3402,7 +3405,11 @@ static int tracing_trace_options_open(st
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
@@ -3906,6 +3913,7 @@ static int tracing_open_pipe(struct inod
 	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
 	if (!iter) {
 		ret = -ENOMEM;
+		__trace_array_put(tr);
 		goto out;
 	}
 
@@ -4652,21 +4660,24 @@ static int tracing_snapshot_open(struct
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
 
@@ -5276,9 +5287,10 @@ tracing_stats_read(struct file *filp, ch
 }
 
 static const struct file_operations tracing_stats_fops = {
-	.open		= tracing_open_generic,
+	.open		= tracing_open_generic_tc,
 	.read		= tracing_stats_read,
 	.llseek		= generic_file_llseek,
+	.release	= tracing_release_generic_tc,
 };
 
 #ifdef CONFIG_DYNAMIC_FTRACE
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1221,6 +1221,7 @@ show_header(struct file *filp, char __us
 
 static int ftrace_event_avail_open(struct inode *inode, struct file *file);
 static int ftrace_event_set_open(struct inode *inode, struct file *file);
+static int ftrace_event_release(struct inode *inode, struct file *file);
 
 static const struct seq_operations show_event_seq_ops = {
 	.start = t_start,
@@ -1248,7 +1249,7 @@ static const struct file_operations ftra
 	.read = seq_read,
 	.write = ftrace_event_write,
 	.llseek = seq_lseek,
-	.release = seq_release,
+	.release = ftrace_event_release,
 };
 
 static const struct file_operations ftrace_enable_fops = {
@@ -1326,6 +1327,15 @@ ftrace_event_open(struct inode *inode, s
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
@@ -1339,12 +1349,19 @@ ftrace_event_set_open(struct inode *inod
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


