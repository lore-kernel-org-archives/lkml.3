Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbaBUCxG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 21:53:06 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:3567 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753225AbaBUCuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 21:50:06 -0500
Message-Id: <20140221025002.967711127@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 20 Feb 2014 21:49:19 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [for-next][PATCH 13/18] tracing/uprobes: Move argument fetching to uprobe_dispatcher()
References: <20140221024906.901631810@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0013-tracing-uprobes-Move-argument-fetching-to-uprobe_dis.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

A single uprobe event might serve different users like ftrace and
perf.  And this is especially important for upcoming multi buffer
support.  But in this case it'll fetch (same) data from userspace
multiple times.  So move it to the beginning of the dispatcher
function and reuse it for each users.

Link: http://lkml.kernel.org/r/1389946120-19610-3-git-send-email-namhyung@kernel.org

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_uprobe.c | 93 +++++++++++++++++++++++++++------------------
 1 file changed, 56 insertions(+), 37 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index c5d2612..d83155e 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -759,30 +759,25 @@ static void uprobe_buffer_put(struct uprobe_cpu_buffer *ucb)
 }
 
 static void __uprobe_trace_func(struct trace_uprobe *tu,
-				unsigned long func, struct pt_regs *regs)
+				unsigned long func, struct pt_regs *regs,
+				struct uprobe_cpu_buffer *ucb, int dsize)
 {
 	struct uprobe_trace_entry_head *entry;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
-	struct uprobe_cpu_buffer *ucb;
 	void *data;
-	int size, dsize, esize;
+	int size, esize;
 	struct ftrace_event_call *call = &tu->tp.call;
 
-	dsize = __get_data_size(&tu->tp, regs);
-	esize = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
-
-	if (WARN_ON_ONCE(!uprobe_cpu_buffer || tu->tp.size + dsize > PAGE_SIZE))
+	if (WARN_ON_ONCE(tu->tp.size + dsize > PAGE_SIZE))
 		return;
 
-	ucb = uprobe_buffer_get();
-	store_trace_args(esize, &tu->tp, regs, ucb->buf, dsize);
-
+	esize = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
 	size = esize + tu->tp.size + dsize;
 	event = trace_current_buffer_lock_reserve(&buffer, call->event.type,
 						  size, 0, 0);
 	if (!event)
-		goto out;
+		return;
 
 	entry = ring_buffer_event_data(event);
 	if (is_ret_probe(tu)) {
@@ -798,23 +793,22 @@ static void __uprobe_trace_func(struct trace_uprobe *tu,
 
 	if (!call_filter_check_discard(call, entry, buffer, event))
 		trace_buffer_unlock_commit(buffer, event, 0, 0);
-
-out:
-	uprobe_buffer_put(ucb);
 }
 
 /* uprobe handler */
-static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
+static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs,
+			     struct uprobe_cpu_buffer *ucb, int dsize)
 {
 	if (!is_ret_probe(tu))
-		__uprobe_trace_func(tu, 0, regs);
+		__uprobe_trace_func(tu, 0, regs, ucb, dsize);
 	return 0;
 }
 
 static void uretprobe_trace_func(struct trace_uprobe *tu, unsigned long func,
-				struct pt_regs *regs)
+				 struct pt_regs *regs,
+				 struct uprobe_cpu_buffer *ucb, int dsize)
 {
-	__uprobe_trace_func(tu, func, regs);
+	__uprobe_trace_func(tu, func, regs, ucb, dsize);
 }
 
 /* Event entry printers */
@@ -1015,30 +1009,23 @@ static bool uprobe_perf_filter(struct uprobe_consumer *uc,
 }
 
 static void __uprobe_perf_func(struct trace_uprobe *tu,
-				unsigned long func, struct pt_regs *regs)
+			       unsigned long func, struct pt_regs *regs,
+			       struct uprobe_cpu_buffer *ucb, int dsize)
 {
 	struct ftrace_event_call *call = &tu->tp.call;
 	struct uprobe_trace_entry_head *entry;
 	struct hlist_head *head;
-	struct uprobe_cpu_buffer *ucb;
 	void *data;
-	int size, dsize, esize;
+	int size, esize;
 	int rctx;
 
-	dsize = __get_data_size(&tu->tp, regs);
 	esize = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
 
-	if (WARN_ON_ONCE(!uprobe_cpu_buffer))
-		return;
-
 	size = esize + tu->tp.size + dsize;
 	size = ALIGN(size + sizeof(u32), sizeof(u64)) - sizeof(u32);
 	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE, "profile buffer not large enough"))
 		return;
 
-	ucb = uprobe_buffer_get();
-	store_trace_args(esize, &tu->tp, regs, ucb->buf, dsize);
-
 	preempt_disable();
 	head = this_cpu_ptr(call->perf_events);
 	if (hlist_empty(head))
@@ -1068,24 +1055,25 @@ static void __uprobe_perf_func(struct trace_uprobe *tu,
 	perf_trace_buf_submit(entry, size, rctx, 0, 1, regs, head, NULL);
  out:
 	preempt_enable();
-	uprobe_buffer_put(ucb);
 }
 
 /* uprobe profile handler */
-static int uprobe_perf_func(struct trace_uprobe *tu, struct pt_regs *regs)
+static int uprobe_perf_func(struct trace_uprobe *tu, struct pt_regs *regs,
+			    struct uprobe_cpu_buffer *ucb, int dsize)
 {
 	if (!uprobe_perf_filter(&tu->consumer, 0, current->mm))
 		return UPROBE_HANDLER_REMOVE;
 
 	if (!is_ret_probe(tu))
-		__uprobe_perf_func(tu, 0, regs);
+		__uprobe_perf_func(tu, 0, regs, ucb, dsize);
 	return 0;
 }
 
 static void uretprobe_perf_func(struct trace_uprobe *tu, unsigned long func,
-				struct pt_regs *regs)
+				struct pt_regs *regs,
+				struct uprobe_cpu_buffer *ucb, int dsize)
 {
-	__uprobe_perf_func(tu, func, regs);
+	__uprobe_perf_func(tu, func, regs, ucb, dsize);
 }
 #endif	/* CONFIG_PERF_EVENTS */
 
@@ -1127,8 +1115,11 @@ static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs)
 {
 	struct trace_uprobe *tu;
 	struct uprobe_dispatch_data udd;
+	struct uprobe_cpu_buffer *ucb;
+	int dsize, esize;
 	int ret = 0;
 
+
 	tu = container_of(con, struct trace_uprobe, consumer);
 	tu->nhit++;
 
@@ -1137,13 +1128,29 @@ static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs)
 
 	current->utask->vaddr = (unsigned long) &udd;
 
+#ifdef CONFIG_PERF_EVENTS
+	if ((tu->tp.flags & TP_FLAG_TRACE) == 0 &&
+	    !uprobe_perf_filter(&tu->consumer, 0, current->mm))
+		return UPROBE_HANDLER_REMOVE;
+#endif
+
+	if (WARN_ON_ONCE(!uprobe_cpu_buffer))
+		return 0;
+
+	dsize = __get_data_size(&tu->tp, regs);
+	esize = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
+
+	ucb = uprobe_buffer_get();
+	store_trace_args(esize, &tu->tp, regs, ucb->buf, dsize);
+
 	if (tu->tp.flags & TP_FLAG_TRACE)
-		ret |= uprobe_trace_func(tu, regs);
+		ret |= uprobe_trace_func(tu, regs, ucb, dsize);
 
 #ifdef CONFIG_PERF_EVENTS
 	if (tu->tp.flags & TP_FLAG_PROFILE)
-		ret |= uprobe_perf_func(tu, regs);
+		ret |= uprobe_perf_func(tu, regs, ucb, dsize);
 #endif
+	uprobe_buffer_put(ucb);
 	return ret;
 }
 
@@ -1152,6 +1159,8 @@ static int uretprobe_dispatcher(struct uprobe_consumer *con,
 {
 	struct trace_uprobe *tu;
 	struct uprobe_dispatch_data udd;
+	struct uprobe_cpu_buffer *ucb;
+	int dsize, esize;
 
 	tu = container_of(con, struct trace_uprobe, consumer);
 
@@ -1160,13 +1169,23 @@ static int uretprobe_dispatcher(struct uprobe_consumer *con,
 
 	current->utask->vaddr = (unsigned long) &udd;
 
+	if (WARN_ON_ONCE(!uprobe_cpu_buffer))
+		return 0;
+
+	dsize = __get_data_size(&tu->tp, regs);
+	esize = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
+
+	ucb = uprobe_buffer_get();
+	store_trace_args(esize, &tu->tp, regs, ucb->buf, dsize);
+
 	if (tu->tp.flags & TP_FLAG_TRACE)
-		uretprobe_trace_func(tu, func, regs);
+		uretprobe_trace_func(tu, func, regs, ucb, dsize);
 
 #ifdef CONFIG_PERF_EVENTS
 	if (tu->tp.flags & TP_FLAG_PROFILE)
-		uretprobe_perf_func(tu, func, regs);
+		uretprobe_perf_func(tu, func, regs, ucb, dsize);
 #endif
+	uprobe_buffer_put(ucb);
 	return 0;
 }
 
-- 
1.8.5.3


