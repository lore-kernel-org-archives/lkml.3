Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935949Ab3DITfQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 15:35:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935893Ab3DITfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 15:35:12 -0400
Date: Tue, 9 Apr 2013 21:32:29 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/7] uprobes/tracing: Introduce
	uprobe_{trace,perf}_print() helpers
Message-ID: <20130409193229.GA27234@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130409193200.GA26731@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extract the output code from uprobe_trace_func() and uprobe_perf_func()
into the new helpers, they will be used by ->ret_handler() too. We also
add the unused "unsigned long func" argument in advance, to simplify the
next changes.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Tested-by: Anton Arapov <anton@redhat.com>
---
 kernel/trace/trace_uprobe.c |   29 ++++++++++++++++++++---------
 1 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 49b4003..0c0f0a7 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -497,8 +497,8 @@ static const struct file_operations uprobe_profile_ops = {
 	.release	= seq_release,
 };
 
-/* uprobe handler */
-static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
+static void uprobe_trace_print(struct trace_uprobe *tu,
+				unsigned long func, struct pt_regs *regs)
 {
 	struct uprobe_trace_entry_head *entry;
 	struct ring_buffer_event *event;
@@ -511,7 +511,7 @@ static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
 	event = trace_current_buffer_lock_reserve(&buffer, call->event.type,
 						  size, 0, 0);
 	if (!event)
-		return 0;
+		return;
 
 	entry = ring_buffer_event_data(event);
 	entry->vaddr[0] = instruction_pointer(regs);
@@ -521,7 +521,12 @@ static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
 
 	if (!filter_current_check_discard(buffer, call, entry, event))
 		trace_buffer_unlock_commit(buffer, event, 0, 0);
+}
 
+/* uprobe handler */
+static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
+{
+	uprobe_trace_print(tu, 0, regs);
 	return 0;
 }
 
@@ -754,8 +759,8 @@ static bool uprobe_perf_filter(struct uprobe_consumer *uc,
 	return ret;
 }
 
-/* uprobe profile handler */
-static int uprobe_perf_func(struct trace_uprobe *tu, struct pt_regs *regs)
+static void uprobe_perf_print(struct trace_uprobe *tu,
+				unsigned long func, struct pt_regs *regs)
 {
 	struct ftrace_event_call *call = &tu->call;
 	struct uprobe_trace_entry_head *entry;
@@ -764,13 +769,10 @@ static int uprobe_perf_func(struct trace_uprobe *tu, struct pt_regs *regs)
 	void *data;
 	int size, rctx, i;
 
-	if (!uprobe_perf_filter(&tu->consumer, 0, current->mm))
-		return UPROBE_HANDLER_REMOVE;
-
 	size = SIZEOF_TRACE_ENTRY(false);
 	size = ALIGN(size + tu->size + sizeof(u32), sizeof(u64)) - sizeof(u32);
 	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE, "profile buffer not large enough"))
-		return 0;
+		return;
 
 	preempt_disable();
 	entry = perf_trace_buf_prepare(size, call->event.type, regs, &rctx);
@@ -787,6 +789,15 @@ static int uprobe_perf_func(struct trace_uprobe *tu, struct pt_regs *regs)
 	perf_trace_buf_submit(entry, size, rctx, ip, 1, regs, head, NULL);
  out:
 	preempt_enable();
+}
+
+/* uprobe profile handler */
+static int uprobe_perf_func(struct trace_uprobe *tu, struct pt_regs *regs)
+{
+	if (!uprobe_perf_filter(&tu->consumer, 0, current->mm))
+		return UPROBE_HANDLER_REMOVE;
+
+	uprobe_perf_print(tu, 0, regs);
 	return 0;
 }
 #endif	/* CONFIG_PERF_EVENTS */
-- 
1.5.5.1

