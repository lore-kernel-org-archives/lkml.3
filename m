Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722Ab3GBUZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 16:25:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9935 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092Ab3GBUYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 16:24:30 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=69niqd27fYMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=vyhsZpOMUI0A:10 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=XznJoCFwAAAA:8 a=SkL8VvJ2eyLkXCsXQcsA:9 a=jeBq3FmKZ4MA:10 a=UTB_XpHje0EA:10 a=OQ-hY_huEOgA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130702202427.455930200@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 02 Jul 2013 16:22:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, <stable@vger.kernel.org>,
        Alexander Lam <azl@google.com>
Subject: [for-next][PATCH 14/14] tracing: Get trace_array ref counts when accessing trace files
References: <20130702202216.623562799@goodmis.org>
Content-Disposition: inline; filename=0014-tracing-Get-trace_array-ref-counts-when-accessing-tr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

When a trace file is opened that may access a trace array, it must
increment its ref count to prevent it from being deleted.

Cc: stable@vger.kernel.org # 3.10
Reported-by: Alexander Lam <azl@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |  121 ++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 112 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 6be9df1..6d9bd9b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2965,6 +2965,43 @@ int tracing_open_generic(struct inode *inode, struct file *filp)
 	return 0;
 }
 
+/*
+ * Open and update trace_array ref count.
+ * Must have the current trace_array passed to it.
+ */
+int tracing_open_generic_tr(struct inode *inode, struct file *filp)
+{
+	struct trace_array *tr = inode->i_private;
+
+	if (tracing_disabled)
+		return -ENODEV;
+
+	if (trace_array_get(tr) < 0)
+		return -ENODEV;
+
+	filp->private_data = inode->i_private;
+
+	return 0;
+	
+}
+
+int tracing_open_generic_tc(struct inode *inode, struct file *filp)
+{
+	struct trace_cpu *tc = inode->i_private;
+	struct trace_array *tr = tc->tr;
+
+	if (tracing_disabled)
+		return -ENODEV;
+
+	if (trace_array_get(tr) < 0)
+		return -ENODEV;
+
+	filp->private_data = inode->i_private;
+
+	return 0;
+	
+}
+
 static int tracing_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *m = file->private_data;
@@ -3008,6 +3045,32 @@ static int tracing_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static int tracing_release_generic_tr(struct inode *inode, struct file *file)
+{
+	struct trace_array *tr = inode->i_private;
+
+	trace_array_put(tr);
+	return 0;
+}
+
+static int tracing_release_generic_tc(struct inode *inode, struct file *file)
+{
+	struct trace_cpu *tc = inode->i_private;
+	struct trace_array *tr = tc->tr;
+
+	trace_array_put(tr);
+	return 0;
+}
+
+static int tracing_single_release_tr(struct inode *inode, struct file *file)
+{
+	struct trace_array *tr = inode->i_private;
+
+	trace_array_put(tr);
+
+	return single_release(inode, file);
+}
+
 static int tracing_open(struct inode *inode, struct file *file)
 {
 	struct trace_cpu *tc = inode->i_private;
@@ -3394,9 +3457,14 @@ tracing_trace_options_write(struct file *filp, const char __user *ubuf,
 
 static int tracing_trace_options_open(struct inode *inode, struct file *file)
 {
+	struct trace_array *tr = inode->i_private;
+
 	if (tracing_disabled)
 		return -ENODEV;
 
+	if (trace_array_get(tr) < 0)
+		return -ENODEV;
+
 	return single_open(file, tracing_trace_options_show, inode->i_private);
 }
 
@@ -3404,7 +3472,7 @@ static const struct file_operations tracing_iter_fops = {
 	.open		= tracing_trace_options_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= single_release,
+	.release	= tracing_single_release_tr,
 	.write		= tracing_trace_options_write,
 };
 
@@ -3892,6 +3960,9 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
 	if (tracing_disabled)
 		return -ENODEV;
 
+	if (trace_array_get(tr) < 0)
+		return -ENODEV;
+
 	mutex_lock(&trace_types_lock);
 
 	/* create a buffer to store the information to pass to userspace */
@@ -3944,6 +4015,7 @@ out:
 fail:
 	kfree(iter->trace);
 	kfree(iter);
+	__trace_array_put(tr);
 	mutex_unlock(&trace_types_lock);
 	return ret;
 }
@@ -3951,6 +4023,8 @@ fail:
 static int tracing_release_pipe(struct inode *inode, struct file *file)
 {
 	struct trace_iterator *iter = file->private_data;
+	struct trace_cpu *tc = inode->i_private;
+	struct trace_array *tr = tc->tr;
 
 	mutex_lock(&trace_types_lock);
 
@@ -3964,6 +4038,8 @@ static int tracing_release_pipe(struct inode *inode, struct file *file)
 	kfree(iter->trace);
 	kfree(iter);
 
+	trace_array_put(tr);
+
 	return 0;
 }
 
@@ -4421,6 +4497,8 @@ tracing_free_buffer_release(struct inode *inode, struct file *filp)
 	/* resize the ring buffer to 0 */
 	tracing_resize_ring_buffer(tr, 0, RING_BUFFER_ALL_CPUS);
 
+	trace_array_put(tr);
+
 	return 0;
 }
 
@@ -4597,10 +4675,20 @@ static ssize_t tracing_clock_write(struct file *filp, const char __user *ubuf,
 
 static int tracing_clock_open(struct inode *inode, struct file *file)
 {
+	struct trace_array *tr = inode->i_private;
+	int ret;
+
 	if (tracing_disabled)
 		return -ENODEV;
 
-	return single_open(file, tracing_clock_show, inode->i_private);
+	if (trace_array_get(tr))
+		return -ENODEV;
+
+	ret = single_open(file, tracing_clock_show, inode->i_private);
+	if (ret < 0)
+		trace_array_put(tr);
+
+	return ret;
 }
 
 struct ftrace_buffer_info {
@@ -4796,34 +4884,38 @@ static const struct file_operations tracing_pipe_fops = {
 };
 
 static const struct file_operations tracing_entries_fops = {
-	.open		= tracing_open_generic,
+	.open		= tracing_open_generic_tc,
 	.read		= tracing_entries_read,
 	.write		= tracing_entries_write,
 	.llseek		= generic_file_llseek,
+	.release	= tracing_release_generic_tc,
 };
 
 static const struct file_operations tracing_total_entries_fops = {
-	.open		= tracing_open_generic,
+	.open		= tracing_open_generic_tr,
 	.read		= tracing_total_entries_read,
 	.llseek		= generic_file_llseek,
+	.release	= tracing_release_generic_tr,
 };
 
 static const struct file_operations tracing_free_buffer_fops = {
+	.open		= tracing_open_generic_tr,
 	.write		= tracing_free_buffer_write,
 	.release	= tracing_free_buffer_release,
 };
 
 static const struct file_operations tracing_mark_fops = {
-	.open		= tracing_open_generic,
+	.open		= tracing_open_generic_tr,
 	.write		= tracing_mark_write,
 	.llseek		= generic_file_llseek,
+	.release	= tracing_release_generic_tr,
 };
 
 static const struct file_operations trace_clock_fops = {
 	.open		= tracing_clock_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= single_release,
+	.release	= tracing_single_release_tr,
 	.write		= tracing_clock_write,
 };
 
@@ -4851,13 +4943,19 @@ static int tracing_buffers_open(struct inode *inode, struct file *filp)
 	struct trace_cpu *tc = inode->i_private;
 	struct trace_array *tr = tc->tr;
 	struct ftrace_buffer_info *info;
+	int ret;
 
 	if (tracing_disabled)
 		return -ENODEV;
 
+	if (trace_array_get(tr) < 0)
+		return -ENODEV;
+
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
-	if (!info)
+	if (!info) {
+		trace_array_put(tr);
 		return -ENOMEM;
+	}
 
 	mutex_lock(&trace_types_lock);
 
@@ -4875,7 +4973,11 @@ static int tracing_buffers_open(struct inode *inode, struct file *filp)
 
 	mutex_unlock(&trace_types_lock);
 
-	return nonseekable_open(inode, filp);
+	ret = nonseekable_open(inode, filp);
+	if (ret < 0)
+		trace_array_put(tr);
+
+	return ret;
 }
 
 static unsigned int
@@ -5765,9 +5867,10 @@ rb_simple_write(struct file *filp, const char __user *ubuf,
 }
 
 static const struct file_operations rb_simple_fops = {
-	.open		= tracing_open_generic,
+	.open		= tracing_open_generic_tr,
 	.read		= rb_simple_read,
 	.write		= rb_simple_write,
+	.release	= tracing_release_generic_tr,
 	.llseek		= default_llseek,
 };
 
-- 
1.7.10.4


