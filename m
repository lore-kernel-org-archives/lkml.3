Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758897Ab3GZNHQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 09:07:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4259 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758250Ab3GZNFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 09:05:14 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=Q0SPfy9JPQ0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=93WekRmMqL0A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=J8l4cvyrY8pGt16UqIUA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130726130512.785579526@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 26 Jul 2013 09:03:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 5/9] tracing: Change tracing_entries_fops to rely on tracing_get_cpu()
References: <20130726130327.911599518@goodmis.org>
Content-Disposition: inline; filename=0005-tracing-Change-tracing_entries_fops-to-rely-on-traci.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

tracing_open_generic_tc() is racy, the memory inode->i_private
points to can be already freed.

1. Change its last user, tracing_entries_fops, to use
   tracing_*_generic_tr() instead.

2. Change debugfs_create_file("buffer_size_kb", data) callers
   to pass "data = tr".

3. Change tracing_entries_read() and tracing_entries_write() to
   use tracing_get_cpu().

4. Kill the no longer used tracing_open_generic_tc() and
   tracing_release_generic_tc().

Link: http://lkml.kernel.org/r/20130723152606.GA23730@redhat.com

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   49 ++++++++++++-------------------------------------
 1 file changed, 12 insertions(+), 37 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e29dc8f..68b4685 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2984,23 +2984,6 @@ static int tracing_open_generic_tr(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-static int tracing_open_generic_tc(struct inode *inode, struct file *filp)
-{
-	struct trace_cpu *tc = inode->i_private;
-	struct trace_array *tr = tc->tr;
-
-	if (tracing_disabled)
-		return -ENODEV;
-
-	if (trace_array_get(tr) < 0)
-		return -ENODEV;
-
-	filp->private_data = inode->i_private;
-
-	return 0;
-	
-}
-
 static int tracing_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *m = file->private_data;
@@ -3054,15 +3037,6 @@ static int tracing_release_generic_tr(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static int tracing_release_generic_tc(struct inode *inode, struct file *file)
-{
-	struct trace_cpu *tc = inode->i_private;
-	struct trace_array *tr = tc->tr;
-
-	trace_array_put(tr);
-	return 0;
-}
-
 static int tracing_single_release_tr(struct inode *inode, struct file *file)
 {
 	struct trace_array *tr = inode->i_private;
@@ -4382,15 +4356,16 @@ static ssize_t
 tracing_entries_read(struct file *filp, char __user *ubuf,
 		     size_t cnt, loff_t *ppos)
 {
-	struct trace_cpu *tc = filp->private_data;
-	struct trace_array *tr = tc->tr;
+	struct inode *inode = file_inode(filp);
+	struct trace_array *tr = inode->i_private;
+	int cpu = tracing_get_cpu(inode);
 	char buf[64];
 	int r = 0;
 	ssize_t ret;
 
 	mutex_lock(&trace_types_lock);
 
-	if (tc->cpu == RING_BUFFER_ALL_CPUS) {
+	if (cpu == RING_BUFFER_ALL_CPUS) {
 		int cpu, buf_size_same;
 		unsigned long size;
 
@@ -4417,7 +4392,7 @@ tracing_entries_read(struct file *filp, char __user *ubuf,
 		} else
 			r = sprintf(buf, "X\n");
 	} else
-		r = sprintf(buf, "%lu\n", per_cpu_ptr(tr->trace_buffer.data, tc->cpu)->entries >> 10);
+		r = sprintf(buf, "%lu\n", per_cpu_ptr(tr->trace_buffer.data, cpu)->entries >> 10);
 
 	mutex_unlock(&trace_types_lock);
 
@@ -4429,7 +4404,8 @@ static ssize_t
 tracing_entries_write(struct file *filp, const char __user *ubuf,
 		      size_t cnt, loff_t *ppos)
 {
-	struct trace_cpu *tc = filp->private_data;
+	struct inode *inode = file_inode(filp);
+	struct trace_array *tr = inode->i_private;
 	unsigned long val;
 	int ret;
 
@@ -4443,8 +4419,7 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 
 	/* value is in KB */
 	val <<= 10;
-
-	ret = tracing_resize_ring_buffer(tc->tr, val, tc->cpu);
+	ret = tracing_resize_ring_buffer(tr, val, tracing_get_cpu(inode));
 	if (ret < 0)
 		return ret;
 
@@ -4892,11 +4867,11 @@ static const struct file_operations tracing_pipe_fops = {
 };
 
 static const struct file_operations tracing_entries_fops = {
-	.open		= tracing_open_generic_tc,
+	.open		= tracing_open_generic_tr,
 	.read		= tracing_entries_read,
 	.write		= tracing_entries_write,
 	.llseek		= generic_file_llseek,
-	.release	= tracing_release_generic_tc,
+	.release	= tracing_release_generic_tr,
 };
 
 static const struct file_operations tracing_total_entries_fops = {
@@ -5580,7 +5555,7 @@ tracing_init_debugfs_percpu(struct trace_array *tr, long cpu)
 				tr, cpu, &tracing_stats_fops);
 
 	trace_create_cpu_file("buffer_size_kb", 0444, d_cpu,
-				&data->trace_cpu, cpu, &tracing_entries_fops);
+				tr, cpu, &tracing_entries_fops);
 
 #ifdef CONFIG_TRACER_SNAPSHOT
 	trace_create_cpu_file("snapshot", 0644, d_cpu,
@@ -6156,7 +6131,7 @@ init_tracer_debugfs(struct trace_array *tr, struct dentry *d_tracer)
 			  tr, &tracing_pipe_fops);
 
 	trace_create_file("buffer_size_kb", 0644, d_tracer,
-			(void *)&tr->trace_cpu, &tracing_entries_fops);
+			  tr, &tracing_entries_fops);
 
 	trace_create_file("buffer_total_size_kb", 0444, d_tracer,
 			  tr, &tracing_total_entries_fops);
-- 
1.7.10.4


