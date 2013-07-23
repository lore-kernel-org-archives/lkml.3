Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973Ab3GWPbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 11:31:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757467Ab3GWPbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 11:31:09 -0400
Date: Tue, 23 Jul 2013 17:25:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@zeniv.linux.org.uk>, Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Alexander Z Lam <azl@google.com>, David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/7] tracing: Change tracing_pipe_fops() to rely on
	tracing_get_cpu()
Message-ID: <20130723152557.GA23717@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130723152531.GA23688@redhat.com>
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
1.5.5.1

