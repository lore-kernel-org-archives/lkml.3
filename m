Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab3GVNtJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 09:49:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755781Ab3GVNtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 09:49:03 -0400
Date: Mon, 22 Jul 2013 15:43:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Alexander Z Lam <azl@google.com>, David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] tracing: Change tracing_entries_fops to rely on
	tracing_get_cpu()
Message-ID: <20130722134354.GA18375@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130722134313.GA18328@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace.c |   49 ++++++++++++-------------------------------------
 1 files changed, 12 insertions(+), 37 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d6429e5..611113d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2980,23 +2980,6 @@ static int tracing_open_generic_tr(struct inode *inode, struct file *filp)
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
@@ -3050,15 +3033,6 @@ static int tracing_release_generic_tr(struct inode *inode, struct file *file)
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
@@ -4378,15 +4352,16 @@ static ssize_t
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
 
@@ -4413,7 +4388,7 @@ tracing_entries_read(struct file *filp, char __user *ubuf,
 		} else
 			r = sprintf(buf, "X\n");
 	} else
-		r = sprintf(buf, "%lu\n", per_cpu_ptr(tr->trace_buffer.data, tc->cpu)->entries >> 10);
+		r = sprintf(buf, "%lu\n", per_cpu_ptr(tr->trace_buffer.data, cpu)->entries >> 10);
 
 	mutex_unlock(&trace_types_lock);
 
@@ -4425,7 +4400,8 @@ static ssize_t
 tracing_entries_write(struct file *filp, const char __user *ubuf,
 		      size_t cnt, loff_t *ppos)
 {
-	struct trace_cpu *tc = filp->private_data;
+	struct inode *inode = file_inode(filp);
+	struct trace_array *tr = inode->i_private;
 	unsigned long val;
 	int ret;
 
@@ -4439,8 +4415,7 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 
 	/* value is in KB */
 	val <<= 10;
-
-	ret = tracing_resize_ring_buffer(tc->tr, val, tc->cpu);
+	ret = tracing_resize_ring_buffer(tr, val, tracing_get_cpu(inode));
 	if (ret < 0)
 		return ret;
 
@@ -4888,11 +4863,11 @@ static const struct file_operations tracing_pipe_fops = {
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
@@ -5576,7 +5551,7 @@ tracing_init_debugfs_percpu(struct trace_array *tr, long cpu)
 				tr, cpu, &tracing_stats_fops);
 
 	trace_create_cpu_file("buffer_size_kb", 0444, d_cpu,
-				&data->trace_cpu, cpu, &tracing_entries_fops);
+				tr, cpu, &tracing_entries_fops);
 
 #ifdef CONFIG_TRACER_SNAPSHOT
 	trace_create_cpu_file("snapshot", 0644, d_cpu,
@@ -6152,7 +6127,7 @@ init_tracer_debugfs(struct trace_array *tr, struct dentry *d_tracer)
 			  tr, &tracing_pipe_fops);
 
 	trace_create_file("buffer_size_kb", 0644, d_tracer,
-			(void *)&tr->trace_cpu, &tracing_entries_fops);
+			  tr, &tracing_entries_fops);
 
 	trace_create_file("buffer_total_size_kb", 0444, d_tracer,
 			  tr, &tracing_total_entries_fops);
-- 
1.5.5.1

