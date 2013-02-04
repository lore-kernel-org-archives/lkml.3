Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab3BDTE5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 14:04:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755389Ab3BDTEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 14:04:12 -0500
Date: Mon, 4 Feb 2013 20:03:01 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Josh Stone <jistone@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] uprobes/perf: Teach trace_uprobe/perf code to use
	UPROBE_HANDLER_REMOVE
Message-ID: <20130204190301.GA10885@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130204190225.GA10840@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change uprobe_trace_func() and uprobe_perf_func() to return "int". Change
Change uprobe_dispatcher() to return "trace_ret | perf_ret" although this
is not really needed, currently TP_FLAG_TRACE/TP_FLAG_PROFILE are mutually
exclusive.

The only functional change is that uprobe_perf_func() checks the filtering
too and returns UPROBE_HANDLER_REMOVE if nobody wants to trace current.

Testing:

	# perf probe -x /lib/libc.so.6 syscall

	# perf record -e probe_libc:syscall -i perl -e 'fork; syscall -1 for 1..10; wait'

	# perf report --show-total-period
		100.00%            10     perl  libc-2.8.so    [.] syscall

Before this patch:

	# cat /sys/kernel/debug/tracing/uprobe_profile
		/lib/libc.so.6 syscall				20

A child process doesn't have a counter, but still it hits this breakoint
"copied" by dup_mmap().

After the patch:

	# cat /sys/kernel/debug/tracing/uprobe_profile
		/lib/libc.so.6 syscall				11

The child process hits this int3 only once and does unapply_uprobe().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_uprobe.c |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 5d5a261..1114619 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -483,7 +483,7 @@ static const struct file_operations uprobe_profile_ops = {
 };
 
 /* uprobe handler */
-static void uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
+static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
 {
 	struct uprobe_trace_entry_head *entry;
 	struct ring_buffer_event *event;
@@ -501,7 +501,7 @@ static void uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
 	event = trace_current_buffer_lock_reserve(&buffer, call->event.type,
 						  size, irq_flags, pc);
 	if (!event)
-		return;
+		return 0;
 
 	entry = ring_buffer_event_data(event);
 	entry->ip = instruction_pointer(task_pt_regs(current));
@@ -511,6 +511,8 @@ static void uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
 
 	if (!filter_current_check_discard(buffer, call, entry, event))
 		trace_buffer_unlock_commit(buffer, event, irq_flags, pc);
+
+	return 0;
 }
 
 /* Event entry printers */
@@ -718,7 +720,7 @@ static bool uprobe_perf_filter(struct uprobe_consumer *uc,
 }
 
 /* uprobe profile handler */
-static void uprobe_perf_func(struct trace_uprobe *tu, struct pt_regs *regs)
+static int uprobe_perf_func(struct trace_uprobe *tu, struct pt_regs *regs)
 {
 	struct ftrace_event_call *call = &tu->call;
 	struct uprobe_trace_entry_head *entry;
@@ -727,11 +729,14 @@ static void uprobe_perf_func(struct trace_uprobe *tu, struct pt_regs *regs)
 	int size, __size, i;
 	int rctx;
 
+	if (!uprobe_perf_filter(&tu->consumer, 0, current->mm))
+		return UPROBE_HANDLER_REMOVE;
+
 	__size = sizeof(*entry) + tu->size;
 	size = ALIGN(__size + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
 	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE, "profile buffer not large enough"))
-		return;
+		return 0;
 
 	preempt_disable();
 
@@ -749,6 +754,7 @@ static void uprobe_perf_func(struct trace_uprobe *tu, struct pt_regs *regs)
 
  out:
 	preempt_enable();
+	return 0;
 }
 #endif	/* CONFIG_PERF_EVENTS */
 
@@ -789,18 +795,19 @@ int trace_uprobe_register(struct ftrace_event_call *event, enum trace_reg type,
 static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs)
 {
 	struct trace_uprobe *tu;
+	int ret = 0;
 
 	tu = container_of(con, struct trace_uprobe, consumer);
 	tu->nhit++;
 
 	if (tu->flags & TP_FLAG_TRACE)
-		uprobe_trace_func(tu, regs);
+		ret |= uprobe_trace_func(tu, regs);
 
 #ifdef CONFIG_PERF_EVENTS
 	if (tu->flags & TP_FLAG_PROFILE)
-		uprobe_perf_func(tu, regs);
+		ret |= uprobe_perf_func(tu, regs);
 #endif
-	return 0;
+	return ret;
 }
 
 static struct trace_event_functions uprobe_funcs = {
-- 
1.5.5.1

