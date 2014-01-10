Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869AbaAJPVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 10:21:55 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:43189 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752235AbaAJPVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 10:21:04 -0500
Message-Id: <20140110152100.170587122@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 10 Jan 2014 10:20:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [for-next][PATCH 1/5] tracing/kprobes: Add trace event trigger invocations
References: <20140110152004.200225053@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-kprobes-Add-trace-event-trigger-invocations.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tom.zanussi@linux.intel.com>

Add code to the kprobe/kretprobe event functions that will invoke any
event triggers associated with a probe's ftrace_event_file.

The code to do this is very similar to the invocation code already
used to invoke the triggers associated with static events and
essentially replaces the existing soft-disable checks with a superset
that preserves the original behavior but adds the bits needed to
support event triggers.

Link: http://lkml.kernel.org/r/f2d49f157b608070045fdb26c9564d5a05a5a7d0.1389036657.git.tom.zanussi@linux.intel.com

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_kprobe.c | 42 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 36 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index ce0ed8a..3afa716 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -929,12 +929,20 @@ __kprobe_trace_func(struct trace_kprobe *tk, struct pt_regs *regs,
 	struct ring_buffer *buffer;
 	int size, dsize, pc;
 	unsigned long irq_flags;
+	unsigned long eflags;
+	enum event_trigger_type tt = ETT_NONE;
 	struct ftrace_event_call *call = &tk->tp.call;
 
 	WARN_ON(call != ftrace_file->event_call);
 
-	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
-		return;
+	eflags = ftrace_file->flags;
+
+	if (!(eflags & FTRACE_EVENT_FL_TRIGGER_COND)) {
+		if (eflags & FTRACE_EVENT_FL_TRIGGER_MODE)
+			event_triggers_call(ftrace_file, NULL);
+		if (eflags & FTRACE_EVENT_FL_SOFT_DISABLED)
+			return;
+	}
 
 	local_save_flags(irq_flags);
 	pc = preempt_count();
@@ -952,9 +960,16 @@ __kprobe_trace_func(struct trace_kprobe *tk, struct pt_regs *regs,
 	entry->ip = (unsigned long)tk->rp.kp.addr;
 	store_trace_args(sizeof(*entry), &tk->tp, regs, (u8 *)&entry[1], dsize);
 
-	if (!filter_check_discard(ftrace_file, entry, buffer, event))
+	if (eflags & FTRACE_EVENT_FL_TRIGGER_COND)
+		tt = event_triggers_call(ftrace_file, entry);
+
+	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
+		ring_buffer_discard_commit(buffer, event);
+	else if (!filter_check_discard(ftrace_file, entry, buffer, event))
 		trace_buffer_unlock_commit_regs(buffer, event,
 						irq_flags, pc, regs);
+	if (tt)
+		event_triggers_post_call(ftrace_file, tt);
 }
 
 static __kprobes void
@@ -977,12 +992,20 @@ __kretprobe_trace_func(struct trace_kprobe *tk, struct kretprobe_instance *ri,
 	struct ring_buffer *buffer;
 	int size, pc, dsize;
 	unsigned long irq_flags;
+	unsigned long eflags;
+	enum event_trigger_type tt = ETT_NONE;
 	struct ftrace_event_call *call = &tk->tp.call;
 
 	WARN_ON(call != ftrace_file->event_call);
 
-	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
-		return;
+	eflags = ftrace_file->flags;
+
+	if (!(eflags & FTRACE_EVENT_FL_TRIGGER_COND)) {
+		if (eflags & FTRACE_EVENT_FL_TRIGGER_MODE)
+			event_triggers_call(ftrace_file, NULL);
+		if (eflags & FTRACE_EVENT_FL_SOFT_DISABLED)
+			return;
+	}
 
 	local_save_flags(irq_flags);
 	pc = preempt_count();
@@ -1001,9 +1024,16 @@ __kretprobe_trace_func(struct trace_kprobe *tk, struct kretprobe_instance *ri,
 	entry->ret_ip = (unsigned long)ri->ret_addr;
 	store_trace_args(sizeof(*entry), &tk->tp, regs, (u8 *)&entry[1], dsize);
 
-	if (!filter_check_discard(ftrace_file, entry, buffer, event))
+	if (eflags & FTRACE_EVENT_FL_TRIGGER_COND)
+		tt = event_triggers_call(ftrace_file, entry);
+
+	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
+		ring_buffer_discard_commit(buffer, event);
+	else if (!filter_check_discard(ftrace_file, entry, buffer, event))
 		trace_buffer_unlock_commit_regs(buffer, event,
 						irq_flags, pc, regs);
+	if (tt)
+		event_triggers_post_call(ftrace_file, tt);
 }
 
 static __kprobes void
-- 
1.8.4.3


