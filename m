Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab3GXPbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 11:31:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10128 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109Ab3GXP3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 11:29:20 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=Bgxh6EHDL9oA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Ei2Z-uYdWMEA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=zjrQCKcW1wbbZFTcZgEA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130724152917.108054127@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 24 Jul 2013 11:27:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [for-next-3.11][PATCH 7/9] tracing: Kill trace_cpu struct/members
References: <20130724152706.535638468@goodmis.org>
Content-Disposition: inline; filename=0007-tracing-Kill-trace_cpu-struct-members.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

After the previous changes trace_array_cpu->trace_cpu and
trace_array->trace_cpu becomes write-only. Remove these members
and kill "struct trace_cpu" as well.

As a side effect this also removes memset(per_cpu_memory, 0).
It was not needed, alloc_percpu() returns zero-filled memory.

Link: http://lkml.kernel.org/r/20130723152613.GA23741@redhat.com

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   21 ---------------------
 kernel/trace/trace.h |    8 --------
 2 files changed, 29 deletions(-)

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
1.7.10.4


