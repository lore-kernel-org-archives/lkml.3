Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab3GVOVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 10:21:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8691 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196Ab3GVOV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 10:21:27 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=5-KeNW68SigA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=OJykrOujhVkA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=UGgH4vjygpHbasOjjw8A:9 a=jEp0ucaQiEUA:10 a=3Rfx1nUSh_UA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130722142125.047273690@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 22 Jul 2013 10:19:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 06/14] tracing/perf: Move the PERF_MAX_TRACE_SIZE check into
 perf_trace_buf_prepare()
References: <20130722141947.972915744@goodmis.org>
Content-Disposition: inline; filename=0006-tracing-perf-Move-the-PERF_MAX_TRACE_SIZE-check-into.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

Every perf_trace_buf_prepare() caller does
WARN_ONCE(size > PERF_MAX_TRACE_SIZE, message) and "message" is
almost the same.

Shift this WARN_ONCE() into perf_trace_buf_prepare(). This changes
the meaning of _ONCE, but I think this is fine.

	- 4947014 2932448 10104832  17984294  1126b26 vmlinux
	+ 4948422 2932448 10104832  17985702  11270a6 vmlinux

on my build.

Link: http://lkml.kernel.org/r/20130617170211.GA19813@redhat.com

Acked-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/ftrace.h          |    4 ----
 kernel/trace/trace_event_perf.c |    4 ++++
 kernel/trace/trace_kprobe.c     |    6 ------
 kernel/trace/trace_syscalls.c   |   12 ------------
 kernel/trace/trace_uprobe.c     |    2 --
 5 files changed, 4 insertions(+), 24 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index d615f78..41a6643 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -670,10 +670,6 @@ perf_trace_##call(void *__data, proto)					\
 			     sizeof(u64));				\
 	__entry_size -= sizeof(u32);					\
 									\
-	if (WARN_ONCE(__entry_size > PERF_MAX_TRACE_SIZE,		\
-		      "profile buffer not large enough"))		\
-		return;							\
-									\
 	entry = (struct ftrace_raw_##call *)perf_trace_buf_prepare(	\
 		__entry_size, event_call->event.type, &__regs, &rctx);	\
 	if (!entry)							\
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 12df557..80c36bc 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -236,6 +236,10 @@ __kprobes void *perf_trace_buf_prepare(int size, unsigned short type,
 
 	BUILD_BUG_ON(PERF_MAX_TRACE_SIZE % sizeof(unsigned long));
 
+	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE,
+			"perf buffer not large enough"))
+		return NULL;
+
 	pc = preempt_count();
 
 	*rctxp = perf_swevent_get_recursion_context();
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 7ed6976..ae6ce83 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1087,9 +1087,6 @@ kprobe_perf_func(struct trace_probe *tp, struct pt_regs *regs)
 	__size = sizeof(*entry) + tp->size + dsize;
 	size = ALIGN(__size + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
-	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE,
-		     "profile buffer not large enough"))
-		return;
 
 	entry = perf_trace_buf_prepare(size, call->event.type, regs, &rctx);
 	if (!entry)
@@ -1120,9 +1117,6 @@ kretprobe_perf_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 	__size = sizeof(*entry) + tp->size + dsize;
 	size = ALIGN(__size + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
-	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE,
-		     "profile buffer not large enough"))
-		return;
 
 	entry = perf_trace_buf_prepare(size, call->event.type, regs, &rctx);
 	if (!entry)
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index ac00857..8fd0365 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -575,10 +575,6 @@ static void perf_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 	size = ALIGN(size + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
 
-	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE,
-		      "perf buffer not large enough"))
-		return;
-
 	rec = (struct syscall_trace_enter *)perf_trace_buf_prepare(size,
 				sys_data->enter_event->event.type, regs, &rctx);
 	if (!rec)
@@ -652,14 +648,6 @@ static void perf_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 	size = ALIGN(sizeof(*rec) + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
 
-	/*
-	 * Impossible, but be paranoid with the future
-	 * How to put this check outside runtime?
-	 */
-	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE,
-		"exit event has grown above perf buffer size"))
-		return;
-
 	rec = (struct syscall_trace_exit *)perf_trace_buf_prepare(size,
 				sys_data->exit_event->event.type, regs, &rctx);
 	if (!rec)
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index d5d0cd3..a23d2d7 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -818,8 +818,6 @@ static void uprobe_perf_print(struct trace_uprobe *tu,
 
 	size = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
 	size = ALIGN(size + tu->size + sizeof(u32), sizeof(u64)) - sizeof(u32);
-	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE, "profile buffer not large enough"))
-		return;
 
 	preempt_disable();
 	head = this_cpu_ptr(call->perf_events);
-- 
1.7.10.4


