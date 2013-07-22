Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab3GVNtH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 09:49:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755787Ab3GVNtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 09:49:03 -0400
Date: Mon, 22 Jul 2013 15:43:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Alexander Z Lam <azl@google.com>, David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] tracing: Change tracing_stats_fops to rely on
	tracing_get_cpu()
Message-ID: <20130722134351.GA18368@redhat.com>
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

1. Change one of its users, tracing_stats_fops, to use
   tracing_*_generic_tr() instead.

2. Change trace_create_cpu_file("stats", data) to pass "data = tr".

3. Change tracing_stats_read() to use tracing_get_cpu().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5a7fbc3..d6429e5 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2978,7 +2978,6 @@ static int tracing_open_generic_tr(struct inode *inode, struct file *filp)
 	filp->private_data = inode->i_private;
 
 	return 0;
-	
 }
 
 static int tracing_open_generic_tc(struct inode *inode, struct file *filp)
@@ -5281,14 +5280,14 @@ static ssize_t
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
@@ -5341,10 +5340,10 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
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
@@ -5574,7 +5573,7 @@ tracing_init_debugfs_percpu(struct trace_array *tr, long cpu)
 				tr, cpu, &tracing_buffers_fops);
 
 	trace_create_cpu_file("stats", 0444, d_cpu,
-				&data->trace_cpu, cpu, &tracing_stats_fops);
+				tr, cpu, &tracing_stats_fops);
 
 	trace_create_cpu_file("buffer_size_kb", 0444, d_cpu,
 				&data->trace_cpu, cpu, &tracing_entries_fops);
-- 
1.5.5.1

