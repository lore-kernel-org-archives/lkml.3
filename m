Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936150Ab3DITfx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 15:35:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765118Ab3DITfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 15:35:51 -0400
Date: Tue, 9 Apr 2013 21:32:35 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/7] uprobes/tracing: Make uprobe_{trace,perf}_print()
	uretprobe-friendly
Message-ID: <20130409193235.GA27244@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130409193200.GA26731@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change uprobe_trace_print() and uprobe_perf_print() to check
is_ret_probe() and fill ring_buffer_event accordingly.

Also change uprobe_trace_func() and uprobe_perf_func() to not
_print() if is_ret_probe() is true. Note that we keep ->handler()
nontrivial even for uretprobe, we need this for filtering and for
other potential extensions.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Tested-by: Anton Arapov <anton@redhat.com>
---
 kernel/trace/trace_uprobe.c |   34 +++++++++++++++++++++++++---------
 1 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 72aa45e..0ed99a2 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -516,15 +516,22 @@ static void uprobe_trace_print(struct trace_uprobe *tu,
 	int size, i;
 	struct ftrace_event_call *call = &tu->call;
 
-	size = SIZEOF_TRACE_ENTRY(false) + tu->size;
+	size = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
 	event = trace_current_buffer_lock_reserve(&buffer, call->event.type,
-						  size, 0, 0);
+						  size + tu->size, 0, 0);
 	if (!event)
 		return;
 
 	entry = ring_buffer_event_data(event);
-	entry->vaddr[0] = instruction_pointer(regs);
-	data = DATAOF_TRACE_ENTRY(entry, false);
+	if (is_ret_probe(tu)) {
+		entry->vaddr[0] = func;
+		entry->vaddr[1] = instruction_pointer(regs);
+		data = DATAOF_TRACE_ENTRY(entry, true);
+	} else {
+		entry->vaddr[0] = instruction_pointer(regs);
+		data = DATAOF_TRACE_ENTRY(entry, false);
+	}
+
 	for (i = 0; i < tu->nr_args; i++)
 		call_fetch(&tu->args[i].fetch, regs, data + tu->args[i].offset);
 
@@ -535,7 +542,8 @@ static void uprobe_trace_print(struct trace_uprobe *tu,
 /* uprobe handler */
 static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
 {
-	uprobe_trace_print(tu, 0, regs);
+	if (!is_ret_probe(tu))
+		uprobe_trace_print(tu, 0, regs);
 	return 0;
 }
 
@@ -784,7 +792,7 @@ static void uprobe_perf_print(struct trace_uprobe *tu,
 	void *data;
 	int size, rctx, i;
 
-	size = SIZEOF_TRACE_ENTRY(false);
+	size = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
 	size = ALIGN(size + tu->size + sizeof(u32), sizeof(u64)) - sizeof(u32);
 	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE, "profile buffer not large enough"))
 		return;
@@ -795,8 +803,15 @@ static void uprobe_perf_print(struct trace_uprobe *tu,
 		goto out;
 
 	ip = instruction_pointer(regs);
-	entry->vaddr[0] = ip;
-	data = DATAOF_TRACE_ENTRY(entry, false);
+	if (is_ret_probe(tu)) {
+		entry->vaddr[0] = func;
+		entry->vaddr[1] = ip;
+		data = DATAOF_TRACE_ENTRY(entry, true);
+	} else {
+		entry->vaddr[0] = ip;
+		data = DATAOF_TRACE_ENTRY(entry, false);
+	}
+
 	for (i = 0; i < tu->nr_args; i++)
 		call_fetch(&tu->args[i].fetch, regs, data + tu->args[i].offset);
 
@@ -812,7 +827,8 @@ static int uprobe_perf_func(struct trace_uprobe *tu, struct pt_regs *regs)
 	if (!uprobe_perf_filter(&tu->consumer, 0, current->mm))
 		return UPROBE_HANDLER_REMOVE;
 
-	uprobe_perf_print(tu, 0, regs);
+	if (!is_ret_probe(tu))
+		uprobe_perf_print(tu, 0, regs);
 	return 0;
 }
 
-- 
1.5.5.1

