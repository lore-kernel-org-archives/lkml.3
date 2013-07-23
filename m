Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045Ab3GWPbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 11:31:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757798Ab3GWPbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 11:31:24 -0400
Date: Tue, 23 Jul 2013 17:26:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@zeniv.linux.org.uk>, Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Alexander Z Lam <azl@google.com>, David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 7/7] tracing: Kill trace_cpu struct/members
Message-ID: <20130723152613.GA23741@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130723152531.GA23688@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the previous changes trace_array_cpu->trace_cpu and
trace_array->trace_cpu becomes write-only. Remove these members
and kill "struct trace_cpu" as well.

As a side effect this also removes memset(per_cpu_memory, 0).
It was not needed, alloc_percpu() returns zero-filled memory.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace.c |   21 ---------------------
 kernel/trace/trace.h |    8 --------
 2 files changed, 0 insertions(+), 29 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index dd7780d..69cba47 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5865,17 +5865,6 @@ struct dentry *trace_instance_dir;
 static void
 init_tracer_debugfs(struct trace_array *tr, struct dentry *d_tracer);
 
-static void init_trace_buffers(struct trace_array *tr, struct trace_buffer *buf)
-{
-	int cpu;
-
-	for_each_tracing_cpu(cpu) {
-		memset(per_cpu_ptr(buf->data, cpu), 0, sizeof(struct trace_array_cpu));
-		per_cpu_ptr(buf->data, cpu)->trace_cpu.cpu = cpu;
-		per_cpu_ptr(buf->data, cpu)->trace_cpu.tr = tr;
-	}
-}
-
 static int
 allocate_trace_buffer(struct trace_array *tr, struct trace_buffer *buf, int size)
 {
@@ -5893,8 +5882,6 @@ allocate_trace_buffer(struct trace_array *tr, struct trace_buffer *buf, int size
 		return -ENOMEM;
 	}
 
-	init_trace_buffers(tr, buf);
-
 	/* Allocate the first page for all buffers */
 	set_buffer_entries(&tr->trace_buffer,
 			   ring_buffer_size(tr->trace_buffer.buffer, 0));
@@ -5961,10 +5948,6 @@ static int new_instance_create(const char *name)
 	if (allocate_trace_buffers(tr, trace_buf_size) < 0)
 		goto out_free_tr;
 
-	/* Holder for file callbacks */
-	tr->trace_cpu.cpu = RING_BUFFER_ALL_CPUS;
-	tr->trace_cpu.tr = tr;
-
 	tr->dir = debugfs_create_dir(name, trace_instance_dir);
 	if (!tr->dir)
 		goto out_free_tr;
@@ -6438,10 +6421,6 @@ __init static int tracer_alloc_buffers(void)
 
 	global_trace.flags = TRACE_ARRAY_FL_GLOBAL;
 
-	/* Holder for file callbacks */
-	global_trace.trace_cpu.cpu = RING_BUFFER_ALL_CPUS;
-	global_trace.trace_cpu.tr = &global_trace;
-
 	INIT_LIST_HEAD(&global_trace.systems);
 	INIT_LIST_HEAD(&global_trace.events);
 	list_add(&global_trace.list, &ftrace_trace_arrays);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index e7d643b..afaae41 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -130,19 +130,12 @@ enum trace_flag_type {
 
 struct trace_array;
 
-struct trace_cpu {
-	struct trace_array	*tr;
-	struct dentry		*dir;
-	int			cpu;
-};
-
 /*
  * The CPU trace array - it consists of thousands of trace entries
  * plus some other descriptor data: (for example which task started
  * the trace, etc.)
  */
 struct trace_array_cpu {
-	struct trace_cpu	trace_cpu;
 	atomic_t		disabled;
 	void			*buffer_page;	/* ring buffer spare */
 
@@ -196,7 +189,6 @@ struct trace_array {
 	bool			allocated_snapshot;
 #endif
 	int			buffer_disabled;
-	struct trace_cpu	trace_cpu;	/* place holder */
 #ifdef CONFIG_FTRACE_SYSCALLS
 	int			sys_refcount_enter;
 	int			sys_refcount_exit;
-- 
1.5.5.1

