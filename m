Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab3H0BXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:23:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59429 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab3H0BHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: [ 22/74] tracing: Change tracing_stats_fops to rely on tracing_get_cpu()
Date: Mon, 26 Aug 2013 18:08:20 -0700
Message-Id: <20130827010429.232290157@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 4d3435b8a4c3357695e09c5e7a3bf73a19fca5b0 upstream.

tracing_open_generic_tc() is racy, the memory inode->i_private
points to can be already freed.

1. Change one of its users, tracing_stats_fops, to use
   tracing_*_generic_tr() instead.

2. Change trace_create_cpu_file("stats", data) to pass "data = tr".

3. Change tracing_stats_read() to use tracing_get_cpu().

Link: http://lkml.kernel.org/r/20130723152603.GA23727@redhat.com

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2973,7 +2973,6 @@ int tracing_open_generic_tr(struct inode
 	filp->private_data = inode->i_private;
 
 	return 0;
-
 }
 
 int tracing_open_generic_tc(struct inode *inode, struct file *filp)
@@ -5277,14 +5276,14 @@ static ssize_t
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
@@ -5337,10 +5336,10 @@ tracing_stats_read(struct file *filp, ch
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
@@ -5570,7 +5569,7 @@ tracing_init_debugfs_percpu(struct trace
 				tr, cpu, &tracing_buffers_fops);
 
 	trace_create_cpu_file("stats", 0444, d_cpu,
-				&data->trace_cpu, cpu, &tracing_stats_fops);
+				tr, cpu, &tracing_stats_fops);
 
 	trace_create_cpu_file("buffer_size_kb", 0444, d_cpu,
 				&data->trace_cpu, cpu, &tracing_entries_fops);


