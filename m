Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbaAFTo3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 14:44:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:23596 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756131AbaAFTo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 14:44:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,614,1384329600"; 
   d="scan'208";a="462466504"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH 1/2 v2] tracing/kprobes: Add trace event trigger invocations
Date: Mon,  6 Jan 2014 13:44:19 -0600
Message-Id: <f2d49f157b608070045fdb26c9564d5a05a5a7d0.1389036657.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1389036657.git.tom.zanussi@linux.intel.com>
References: <cover.1389036657.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1389036657.git.tom.zanussi@linux.intel.com>
References: <cover.1389036657.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add code to the kprobe/kretprobe event functions that will invoke any
event triggers associated with a probe's ftrace_event_file.

The code to do this is very similar to the invocation code already
used to invoke the triggers associated with static events and
essentially replaces the existing soft-disable checks with a superset
that preserves the original behavior but adds the bits needed to
support event triggers.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
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
1.8.3.1

