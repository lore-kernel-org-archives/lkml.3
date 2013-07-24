Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab3GXPct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 11:32:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32477 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635Ab3GXP3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 11:29:18 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=nJc60xxcIqAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=1qB2q6CTtWIA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=0kbfjC1OccZKM1oZNXEA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130724152916.360226534@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 24 Jul 2013 11:27:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [for-next-3.11][PATCH 3/9] tracing: Change tracing_buffers_fops to rely on tracing_get_cpu()
References: <20130724152706.535638468@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Change-tracing_buffers_fops-to-rely-on-traci.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

tracing_buffers_open() is racy, the memory inode->i_private points
to can be already freed.

Change debugfs_create_file("trace_pipe_raw", data) caller to pass
"data = tr", tracing_buffers_open() can use tracing_get_cpu().

Change debugfs_create_file("snapshot_raw_fops", data) caller too,
this file uses tracing_buffers_open/release.

Link: http://lkml.kernel.org/r/20130723152600.GA23720@redhat.com

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 51a99ef..30c058a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4949,8 +4949,7 @@ static const struct file_operations snapshot_raw_fops = {
 
 static int tracing_buffers_open(struct inode *inode, struct file *filp)
 {
-	struct trace_cpu *tc = inode->i_private;
-	struct trace_array *tr = tc->tr;
+	struct trace_array *tr = inode->i_private;
 	struct ftrace_buffer_info *info;
 	int ret;
 
@@ -4969,7 +4968,7 @@ static int tracing_buffers_open(struct inode *inode, struct file *filp)
 	mutex_lock(&trace_types_lock);
 
 	info->iter.tr		= tr;
-	info->iter.cpu_file	= tc->cpu;
+	info->iter.cpu_file	= tracing_get_cpu(inode);
 	info->iter.trace	= tr->current_trace;
 	info->iter.trace_buffer = &tr->trace_buffer;
 	info->spare		= NULL;
@@ -5576,7 +5575,7 @@ tracing_init_debugfs_percpu(struct trace_array *tr, long cpu)
 				&data->trace_cpu, cpu, &tracing_fops);
 
 	trace_create_cpu_file("trace_pipe_raw", 0444, d_cpu,
-				&data->trace_cpu, cpu, &tracing_buffers_fops);
+				tr, cpu, &tracing_buffers_fops);
 
 	trace_create_cpu_file("stats", 0444, d_cpu,
 				&data->trace_cpu, cpu, &tracing_stats_fops);
@@ -5589,7 +5588,7 @@ tracing_init_debugfs_percpu(struct trace_array *tr, long cpu)
 				&data->trace_cpu, cpu, &snapshot_fops);
 
 	trace_create_cpu_file("snapshot_raw", 0444, d_cpu,
-				&data->trace_cpu, cpu, &snapshot_raw_fops);
+				tr, cpu, &snapshot_raw_fops);
 #endif
 }
 
-- 
1.7.10.4


