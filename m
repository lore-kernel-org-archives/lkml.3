Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996Ab3GWPbQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 11:31:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757632Ab3GWPbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 11:31:14 -0400
Date: Tue, 23 Jul 2013 17:26:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@zeniv.linux.org.uk>, Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Alexander Z Lam <azl@google.com>, David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/7] tracing: Change tracing_buffers_fops to rely on
	tracing_get_cpu()
Message-ID: <20130723152600.GA23720@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130723152531.GA23688@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tracing_buffers_open() is racy, the memory inode->i_private points
to can be already freed.

Change debugfs_create_file("trace_pipe_raw", data) caller to pass
"data = tr", tracing_buffers_open() can use tracing_get_cpu().

Change debugfs_create_file("snapshot_raw_fops", data) caller too,
this file uses tracing_buffers_open/release.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

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
1.5.5.1

