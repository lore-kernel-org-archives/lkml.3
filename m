Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758801Ab3GZNFS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 09:05:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14483 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757620Ab3GZNFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 09:05:13 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=mYMHgPtk6LcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=WccrhnkeSn8A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=XvuyIiCH_Q-Y7ANRKWUA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130726130512.628127693@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 26 Jul 2013 09:03:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 4/9] tracing: Change tracing_stats_fops to rely on tracing_get_cpu()
References: <20130726130327.911599518@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-Change-tracing_stats_fops-to-rely-on-tracing.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

tracing_open_generic_tc() is racy, the memory inode->i_private
points to can be already freed.

1. Change one of its users, tracing_stats_fops, to use
   tracing_*_generic_tr() instead.

2. Change trace_create_cpu_file("stats", data) to pass "data = tr".

3. Change tracing_stats_read() to use tracing_get_cpu().

Link: http://lkml.kernel.org/r/20130723152603.GA23727@redhat.com

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 30c058a..e29dc8f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2982,7 +2982,6 @@ static int tracing_open_generic_tr(struct inode *inode, struct file *filp)
 	filp->private_data = inode->i_private;
 
 	return 0;
-	
 }
 
 static int tracing_open_generic_tc(struct inode *inode, struct file *filp)
@@ -5285,14 +5284,14 @@ static ssize_t
 tracing_stats_read(struct file *filp, char __user *ubuf,
 		   size_t count, loff_t *ppos)
 {
-	struct trace_cpu *tc = filp->private_data;
-	struct trace_array *tr = tc->tr;
+	struct inode *inode = file_inode(filp);
+	struct trace_array *tr = inode->i_private;
 	struct trace_buffer *trace_buf = &tr->trace_buffer;
+	int cpu = tracing_get_cpu(inode);
 	struct trace_seq *s;
 	unsigned long cnt;
 	unsigned long long t;
 	unsigned long usec_rem;
-	int cpu = tc->cpu;
 
 	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (!s)
@@ -5345,10 +5344,10 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
 }
 
 static const struct file_operations tracing_stats_fops = {
-	.open		= tracing_open_generic_tc,
+	.open		= tracing_open_generic_tr,
 	.read		= tracing_stats_read,
 	.llseek		= generic_file_llseek,
-	.release	= tracing_release_generic_tc,
+	.release	= tracing_release_generic_tr,
 };
 
 #ifdef CONFIG_DYNAMIC_FTRACE
@@ -5578,7 +5577,7 @@ tracing_init_debugfs_percpu(struct trace_array *tr, long cpu)
 				tr, cpu, &tracing_buffers_fops);
 
 	trace_create_cpu_file("stats", 0444, d_cpu,
-				&data->trace_cpu, cpu, &tracing_stats_fops);
+				tr, cpu, &tracing_stats_fops);
 
 	trace_create_cpu_file("buffer_size_kb", 0444, d_cpu,
 				&data->trace_cpu, cpu, &tracing_entries_fops);
-- 
1.7.10.4


