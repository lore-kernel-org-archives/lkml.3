Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab3GVNuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 09:50:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755715Ab3GVNs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 09:48:59 -0400
Date: Mon, 22 Jul 2013 15:43:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Alexander Z Lam <azl@google.com>, David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] tracing: Change tracing_pipe_fops() to rely on
	tracing_get_cpu()
Message-ID: <20130722134345.GA18358@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130722134313.GA18328@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tracing_open_pipe() is racy, the memory inode->i_private points to
can be already freed.

Change debugfs_create_file("trace_pipe", data) callers to to pass
"data = tr", tracing_open_pipe() can use tracing_get_cpu().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 1e0fae9..311581a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3955,8 +3955,7 @@ tracing_max_lat_write(struct file *filp, const char __user *ubuf,
 
 static int tracing_open_pipe(struct inode *inode, struct file *filp)
 {
-	struct trace_cpu *tc = inode->i_private;
-	struct trace_array *tr = tc->tr;
+	struct trace_array *tr = inode->i_private;
 	struct trace_iterator *iter;
 	int ret = 0;
 
@@ -4002,9 +4001,9 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
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
 
@@ -4027,8 +4026,7 @@ fail:
 static int tracing_release_pipe(struct inode *inode, struct file *file)
 {
 	struct trace_iterator *iter = file->private_data;
-	struct trace_cpu *tc = inode->i_private;
-	struct trace_array *tr = tc->tr;
+	struct trace_array *tr = inode->i_private;
 
 	mutex_lock(&trace_types_lock);
 
@@ -5567,7 +5565,7 @@ tracing_init_debugfs_percpu(struct trace_array *tr, long cpu)
 
 	/* per cpu trace_pipe */
 	trace_create_cpu_file("trace_pipe", 0444, d_cpu,
-				&data->trace_cpu, cpu, &tracing_pipe_fops);
+				tr, cpu, &tracing_pipe_fops);
 
 	/* per cpu trace */
 	trace_create_cpu_file("trace", 0644, d_cpu,
@@ -6153,7 +6151,7 @@ init_tracer_debugfs(struct trace_array *tr, struct dentry *d_tracer)
 			(void *)&tr->trace_cpu, &tracing_fops);
 
 	trace_create_file("trace_pipe", 0444, d_tracer,
-			(void *)&tr->trace_cpu, &tracing_pipe_fops);
+			  tr, &tracing_pipe_fops);
 
 	trace_create_file("buffer_size_kb", 0644, d_tracer,
 			(void *)&tr->trace_cpu, &tracing_entries_fops);
-- 
1.5.5.1

