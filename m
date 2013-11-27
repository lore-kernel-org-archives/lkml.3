Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab3K0GVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 01:21:23 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:43557 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981Ab3K0GUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 01:20:14 -0500
X-AuditID: 9c930197-b7caaae000001cef-bd-52958f177511
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 14/17] tracing/uprobes: Fetch args before reserving a ring buffer
Date: Wed, 27 Nov 2013 15:20:00 +0900
Message-Id: <1385533203-10014-15-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1385533203-10014-1-git-send-email-namhyung@kernel.org>
References: <1385533203-10014-1-git-send-email-namhyung@kernel.org>
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
code duplication.  And add struct uprobe_cpu_buffer and its helpers as
suggested by Oleg.

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/trace_uprobe.c | 146 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 132 insertions(+), 14 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 5a6eb5686617..c037477d1c1a 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -650,21 +650,117 @@ static const struct file_operations uprobe_profile_ops = {
 	.release	= seq_release,
 };
 
+struct uprobe_cpu_buffer {
+	struct mutex mutex;
+	void *buf;
+};
+static struct uprobe_cpu_buffer __percpu *uprobe_cpu_buffer;
+static int uprobe_buffer_refcnt;
+
+static int uprobe_buffer_init(void)
+{
+	int cpu, err_cpu;
+
+	uprobe_cpu_buffer = alloc_percpu(struct uprobe_cpu_buffer);
+	if (uprobe_cpu_buffer == NULL)
+		return -ENOMEM;
+
+	for_each_possible_cpu(cpu) {
+		struct page *p = alloc_pages_node(cpu_to_node(cpu),
+						  GFP_KERNEL, 0);
+		if (p == NULL) {
+			err_cpu = cpu;
+			goto err;
+		}
+		per_cpu_ptr(uprobe_cpu_buffer, cpu)->buf = page_address(p);
+		mutex_init(&per_cpu_ptr(uprobe_cpu_buffer, cpu)->mutex);
+	}
+
+	return 0;
+
+err:
+	for_each_possible_cpu(cpu) {
+		if (cpu == err_cpu)
+			break;
+		free_page((unsigned long)per_cpu_ptr(uprobe_cpu_buffer, cpu)->buf);
+	}
+
+	free_percpu(uprobe_cpu_buffer);
+	return -ENOMEM;
+}
+
+static int uprobe_buffer_enable(void)
+{
+	int ret = 0;
+
+	BUG_ON(!mutex_is_locked(&event_mutex));
+
+	if (uprobe_buffer_refcnt++ == 0) {
+		ret = uprobe_buffer_init();
+		if (ret < 0)
+			uprobe_buffer_refcnt--;
+	}
+
+	return ret;
+}
+
+static void uprobe_buffer_disable(void)
+{
+	BUG_ON(!mutex_is_locked(&event_mutex));
+
+	if (--uprobe_buffer_refcnt == 0) {
+		free_percpu(uprobe_cpu_buffer);
+		uprobe_cpu_buffer = NULL;
+	}
+}
+
+static struct uprobe_cpu_buffer *uprobe_buffer_get(void)
+{
+	struct uprobe_cpu_buffer *ucb;
+	int cpu;
+
+	cpu = raw_smp_processor_id();
+	ucb = per_cpu_ptr(uprobe_cpu_buffer, cpu);
+
+	/*
+	 * Use per-cpu buffers for fastest access, but we might migrate
+	 * so the mutex makes sure we have sole access to it.
+	 */
+	mutex_lock(&ucb->mutex);
+
+	return ucb;
+}
+
+static void uprobe_buffer_put(struct uprobe_cpu_buffer *ucb)
+{
+	mutex_unlock(&ucb->mutex);
+}
+
 static void uprobe_trace_print(struct trace_uprobe *tu,
 				unsigned long func, struct pt_regs *regs)
 {
 	struct uprobe_trace_entry_head *entry;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
+	struct uprobe_cpu_buffer *ucb;
 	void *data;
-	int size, i;
+	int size, dsize, esize;
 	struct ftrace_event_call *call = &tu->p.call;
 
-	size = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
+	dsize = __get_data_size(&tu->p, regs);
+	esize = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
+
+	if (WARN_ON_ONCE(!uprobe_cpu_buffer || tu->p.size + dsize > PAGE_SIZE))
+		return;
+
+	ucb = uprobe_buffer_get();
+	store_trace_args(esize, &tu->p, regs, ucb->buf, dsize);
+
+	size = esize + tu->p.size + dsize;
 	event = trace_current_buffer_lock_reserve(&buffer, call->event.type,
-						  size + tu->p.size, 0, 0);
+						  size, 0, 0);
 	if (!event)
-		return;
+		goto out;
 
 	entry = ring_buffer_event_data(event);
 	if (is_ret_probe(tu)) {
@@ -676,13 +772,13 @@ static void uprobe_trace_print(struct trace_uprobe *tu,
 		data = DATAOF_TRACE_ENTRY(entry, false);
 	}
 
-	for (i = 0; i < tu->p.nr_args; i++) {
-		call_fetch(&tu->p.args[i].fetch, regs,
-			   data + tu->p.args[i].offset);
-	}
+	memcpy(data, ucb->buf, tu->p.size + dsize);
 
 	if (!call_filter_check_discard(call, entry, buffer, event))
 		trace_buffer_unlock_commit(buffer, event, 0, 0);
+
+out:
+	uprobe_buffer_put(ucb);
 }
 
 /* uprobe handler */
@@ -750,6 +846,10 @@ probe_event_enable(struct trace_uprobe *tu, int flag, filter_func_t filter)
 	if (trace_probe_is_enabled(&tu->p))
 		return -EINTR;
 
+	ret = uprobe_buffer_enable();
+	if (ret < 0)
+		return ret;
+
 	WARN_ON(!uprobe_filter_is_empty(&tu->filter));
 
 	tu->p.flags |= flag;
@@ -770,6 +870,8 @@ static void probe_event_disable(struct trace_uprobe *tu, int flag)
 
 	uprobe_unregister(tu->inode, tu->offset, &tu->consumer);
 	tu->p.flags &= ~flag;
+
+	uprobe_buffer_disable();
 }
 
 static int uprobe_event_define_fields(struct ftrace_event_call *event_call)
@@ -896,11 +998,24 @@ static void uprobe_perf_print(struct trace_uprobe *tu,
 	struct ftrace_event_call *call = &tu->p.call;
 	struct uprobe_trace_entry_head *entry;
 	struct hlist_head *head;
+	struct uprobe_cpu_buffer *ucb;
 	void *data;
-	int size, rctx, i;
+	int size, dsize, esize;
+	int rctx;
+
+	dsize = __get_data_size(&tu->p, regs);
+	esize = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
 
-	size = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
-	size = ALIGN(size + tu->p.size + sizeof(u32), sizeof(u64)) - sizeof(u32);
+	if (WARN_ON_ONCE(!uprobe_cpu_buffer))
+		return;
+
+	size = esize + tu->p.size + dsize;
+	size = ALIGN(size + sizeof(u32), sizeof(u64)) - sizeof(u32);
+	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE, "profile buffer not large enough"))
+		return;
+
+	ucb = uprobe_buffer_get();
+	store_trace_args(esize, &tu->p, regs, ucb->buf, dsize);
 
 	preempt_disable();
 	head = this_cpu_ptr(call->perf_events);
@@ -920,15 +1035,18 @@ static void uprobe_perf_print(struct trace_uprobe *tu,
 		data = DATAOF_TRACE_ENTRY(entry, false);
 	}
 
-	for (i = 0; i < tu->p.nr_args; i++) {
-		struct probe_arg *parg = &tu->p.args[i];
+	memcpy(data, ucb->buf, tu->p.size + dsize);
+
+	if (size - esize > tu->p.size + dsize) {
+		int len = tu->p.size + dsize;
 
-		call_fetch(&parg->fetch, regs, data + parg->offset);
+		memset(data + len, 0, size - esize - len);
 	}
 
 	perf_trace_buf_submit(entry, size, rctx, 0, 1, regs, head, NULL);
  out:
 	preempt_enable();
+	uprobe_buffer_put(ucb);
 }
 
 /* uprobe profile handler */
-- 
1.7.11.7

