Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab3H0Itl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:49:41 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:47370 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab3H0ItH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:49:07 -0400
X-AuditID: 9c930197-b7b44ae00000347f-52-521c67fb991b
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>, Hyeoncheol Lee <cheol.lee@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 10/13] tracing/uprobes: Fetch args before reserving a ring buffer
Date: Tue, 27 Aug 2013 17:48:53 +0900
Message-Id: <1377593336-16828-11-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1377593336-16828-1-git-send-email-namhyung@kernel.org>
References: <1377593336-16828-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Fetching from user space should be done in a non-atomic context.  So
use a per-cpu buffer and copy its content to the ring buffer
atomically.  Note that we can migrate during accessing user memory
thus use a per-cpu mutex to protect concurrent accesses.

This is needed since we'll be able to fetch args from an user memory
which can be swapped out.  Before that uprobes could fetch args from
registers only which saved in a kernel space.

While at it, use __get_data_size() and store_trace_args() to reduce
code duplication.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/trace_uprobe.c | 97 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 81 insertions(+), 16 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 9f2d12d2311d..9ede401759ab 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -530,21 +530,46 @@ static const struct file_operations uprobe_profile_ops = {
 	.release	= seq_release,
 };
 
+static atomic_t uprobe_buffer_ref = ATOMIC_INIT(0);
+static void __percpu *uprobe_cpu_buffer;
+static DEFINE_PER_CPU(struct mutex, uprobe_cpu_mutex);
+
 static void uprobe_trace_print(struct trace_uprobe *tu,
 				unsigned long func, struct pt_regs *regs)
 {
 	struct uprobe_trace_entry_head *entry;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
-	void *data;
-	int size, i;
+	struct mutex *mutex;
+	void *data, *arg_buf;
+	int size, dsize, esize;
+	int cpu;
 	struct ftrace_event_call *call = &tu->p.call;
 
-	size = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
+	dsize = __get_data_size(&tu->p, regs);
+	esize = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
+
+	if (WARN_ON_ONCE(!uprobe_cpu_buffer || tu->p.size + dsize > PAGE_SIZE))
+		return;
+
+	cpu = raw_smp_processor_id();
+	mutex = &per_cpu(uprobe_cpu_mutex, cpu);
+	arg_buf = per_cpu_ptr(uprobe_cpu_buffer, cpu);
+
+	/*
+	 * Use per-cpu buffers for fastest access, but we might migrate
+	 * so the mutex makes sure we have sole access to it.
+	 */
+	mutex_lock(mutex);
+	store_trace_args(esize, &tu->p, regs, arg_buf, dsize);
+
+	size = esize + tu->p.size + dsize;
 	event = trace_current_buffer_lock_reserve(&buffer, call->event.type,
-						  size + tu->p.size, 0, 0);
-	if (!event)
+						  size, 0, 0);
+	if (!event) {
+		mutex_unlock(mutex);
 		return;
+	}
 
 	entry = ring_buffer_event_data(event);
 	if (is_ret_probe(tu)) {
@@ -556,13 +581,12 @@ static void uprobe_trace_print(struct trace_uprobe *tu,
 		data = DATAOF_TRACE_ENTRY(entry, false);
 	}
 
-	for (i = 0; i < tu->p.nr_args; i++) {
-		call_fetch(&tu->p.args[i].fetch, regs,
-			   data + tu->p.args[i].offset);
-	}
+	memcpy(data, arg_buf, tu->p.size + dsize);
 
 	if (!filter_current_check_discard(buffer, call, entry, event))
 		trace_buffer_unlock_commit(buffer, event, 0, 0);
+
+	mutex_unlock(mutex);
 }
 
 /* uprobe handler */
@@ -630,6 +654,17 @@ probe_event_enable(struct trace_uprobe *tu, int flag, filter_func_t filter)
 	if (trace_probe_is_enabled(&tu->p))
 		return -EINTR;
 
+	if (atomic_inc_return(&uprobe_buffer_ref) == 1) {
+		int cpu;
+
+		uprobe_cpu_buffer = __alloc_percpu(PAGE_SIZE, PAGE_SIZE);
+		if (uprobe_cpu_buffer == NULL)
+			return -ENOMEM;
+
+		for_each_possible_cpu(cpu)
+			mutex_init(&per_cpu(uprobe_cpu_mutex, cpu));
+	}
+
 	WARN_ON(!uprobe_filter_is_empty(&tu->filter));
 
 	tu->p.flags |= flag;
@@ -646,6 +681,11 @@ static void probe_event_disable(struct trace_uprobe *tu, int flag)
 	if (!trace_probe_is_enabled(&tu->p))
 		return;
 
+	if (atomic_dec_and_test(&uprobe_buffer_ref)) {
+		free_percpu(uprobe_cpu_buffer);
+		uprobe_cpu_buffer = NULL;
+	}
+
 	WARN_ON(!uprobe_filter_is_empty(&tu->filter));
 
 	uprobe_unregister(tu->inode, tu->offset, &tu->consumer);
@@ -776,11 +816,33 @@ static void uprobe_perf_print(struct trace_uprobe *tu,
 	struct ftrace_event_call *call = &tu->p.call;
 	struct uprobe_trace_entry_head *entry;
 	struct hlist_head *head;
-	void *data;
-	int size, rctx, i;
+	struct mutex *mutex;
+	void *data, *arg_buf;
+	int size, dsize, esize;
+	int cpu;
+	int rctx;
 
-	size = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
-	size = ALIGN(size + tu->p.size + sizeof(u32), sizeof(u64)) - sizeof(u32);
+	dsize = __get_data_size(&tu->p, regs);
+	esize = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
+
+	if (WARN_ON_ONCE(!uprobe_cpu_buffer))
+		return;
+
+	size = esize + tu->p.size + dsize;
+	size = ALIGN(size + sizeof(u32), sizeof(u64)) - sizeof(u32);
+	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE, "profile buffer not large enough"))
+		return;
+
+	cpu = raw_smp_processor_id();
+	mutex = &per_cpu(uprobe_cpu_mutex, cpu);
+	arg_buf = per_cpu_ptr(uprobe_cpu_buffer, cpu);
+
+	/*
+	 * Use per-cpu buffers for fastest access, but we might migrate
+	 * so the mutex makes sure we have sole access to it.
+	 */
+	mutex_lock(mutex);
+	store_trace_args(esize, &tu->p, regs, arg_buf, dsize);
 
 	preempt_disable();
 	head = this_cpu_ptr(call->perf_events);
@@ -800,15 +862,18 @@ static void uprobe_perf_print(struct trace_uprobe *tu,
 		data = DATAOF_TRACE_ENTRY(entry, false);
 	}
 
-	for (i = 0; i < tu->p.nr_args; i++) {
-		struct probe_arg *parg = &tu->p.args[i];
+	memcpy(data, arg_buf, tu->p.size + dsize);
+
+	if (size - esize > tu->p.size + dsize) {
+		int len = tu->p.size + dsize;
 
-		call_fetch(&parg->fetch, regs, data + parg->offset);
+		memset(data + len, 0, size - esize - len);
 	}
 
 	perf_trace_buf_submit(entry, size, rctx, 0, 1, regs, head, NULL);
  out:
 	preempt_enable();
+	mutex_unlock(mutex);
 }
 
 /* uprobe profile handler */
-- 
1.7.11.7

