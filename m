Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab3GXPcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 11:32:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32477 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001Ab3GXP3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 11:29:19 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=iHb6DO19o9wA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=w4kK2zIDt8kA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=ayC55rCoAAAA:8 a=RvlEQHu-AAAA:8 a=0kbfjC1OccZKM1oZNXEA:9 a=E6k37eg1NvgA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130724152916.203705232@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 24 Jul 2013 11:27:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [for-next-3.11][PATCH 2/9] tracing: Change tracing_pipe_fops() to rely on tracing_get_cpu()
References: <20130724152706.535638468@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Change-tracing_pipe_fops-to-rely-on-tracing_.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

tracing_open_pipe() is racy, the memory inode->i_private points to
can be already freed.

Change debugfs_create_file("trace_pipe", data) callers to to pass
"data = tr", tracing_open_pipe() can use tracing_get_cpu().

Link: http://lkml.kernel.org/r/20130723152557.GA23717@redhat.com

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index cfff63c..51a99ef 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3959,8 +3959,7 @@ tracing_max_lat_write(struct file *filp, const char __user *ubuf,
 
 static int tracing_open_pipe(struct inode *inode, struct file *filp)
 {
-	struct trace_cpu *tc = inode->i_private;
-	struct trace_array *tr = tc->tr;
+	struct trace_array *tr = inode->i_private;
 	struct trace_iterator *iter;
 	int ret = 0;
 
@@ -4006,9 +4005,9 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
 	if (trace_clocks[tr->clock_id].in_ns)
 		iter->iter_flags |= TRACE_FILE_TIME_IN_NS;
 
-	iter->cpu_file = tc->cpu;
-	iter->tr = tc->tr;
-	iter->trace_buffer = &tc->tr->trace_buffer;
+	iter->tr = tr;
+	iter->trace_buffer = &tr->trace_buffer;
+	iter->cpu_file = tracing_get_cpu(inode);
 	mutex_init(&iter->mutex);
 	filp->private_data = iter;
 
@@ -4031,8 +4030,7 @@ fail:
 static int tracing_release_pipe(struct inode *inode, struct file *file)
 {
 	struct trace_iterator *iter = file->private_data;
-	struct trace_cpu *tc = inode->i_private;
-	struct trace_array *tr = tc->tr;
+	struct trace_array *tr = inode->i_private;
 
 	mutex_lock(&trace_types_lock);
 
@@ -5571,7 +5569,7 @@ tracing_init_debugfs_percpu(struct trace_array *tr, long cpu)
 
 	/* per cpu trace_pipe */
 	trace_create_cpu_file("trace_pipe", 0444, d_cpu,
-				&data->trace_cpu, cpu, &tracing_pipe_fops);
+				tr, cpu, &tracing_pipe_fops);
 
 	/* per cpu trace */
 	trace_create_cpu_file("trace", 0644, d_cpu,
@@ -6157,7 +6155,7 @@ init_tracer_debugfs(struct trace_array *tr, struct dentry *d_tracer)
 			(void *)&tr->trace_cpu, &tracing_fops);
 
 	trace_create_file("trace_pipe", 0444, d_tracer,
-			(void *)&tr->trace_cpu, &tracing_pipe_fops);
+			  tr, &tracing_pipe_fops);
 
 	trace_create_file("buffer_size_kb", 0644, d_tracer,
 			(void *)&tr->trace_cpu, &tracing_entries_fops);
-- 
1.7.10.4


