Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab3FQRG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:06:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab3FQRG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:06:57 -0400
Date: Mon, 17 Jun 2013 19:02:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] tracing/perf: Move the PERF_MAX_TRACE_SIZE check into
	perf_trace_buf_prepare()
Message-ID: <20130617170211.GA19813@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130617170142.GA19780@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every perf_trace_buf_prepare() caller does
WARN_ONCE(size > PERF_MAX_TRACE_SIZE, message) and "message" is
almost the same.

Shift this WARN_ONCE() into perf_trace_buf_prepare(). This changes
the meaning of _ONCE, but I think this is fine.

	- 4947014 2932448 10104832  17984294  1126b26 vmlinux
	+ 4948422 2932448 10104832  17985702  11270a6 vmlinux

on my build.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/trace/ftrace.h          |    4 ----
 kernel/trace/trace_event_perf.c |    4 ++++
 kernel/trace/trace_kprobe.c     |    6 ------
 kernel/trace/trace_syscalls.c   |   12 ------------
 kernel/trace/trace_uprobe.c     |    2 --
 5 files changed, 4 insertions(+), 24 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 19edd7f..c162a57 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -666,10 +666,6 @@ perf_trace_##call(void *__data, proto)					\
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
index b95f683..156a4d8 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1088,9 +1088,6 @@ kprobe_perf_func(struct trace_probe *tp, struct pt_regs *regs)
 	__size = sizeof(*entry) + tp->size + dsize;
 	size = ALIGN(__size + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
-	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE,
-		     "profile buffer not large enough"))
-		return;
 
 	entry = perf_trace_buf_prepare(size, call->event.type, regs, &rctx);
 	if (!entry)
@@ -1122,9 +1119,6 @@ kretprobe_perf_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 	__size = sizeof(*entry) + tp->size + dsize;
 	size = ALIGN(__size + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
-	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE,
-		     "profile buffer not large enough"))
-		return;
 
 	entry = perf_trace_buf_prepare(size, call->event.type, regs, &rctx);
 	if (!entry)
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 4d1bd5d..d17246e 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -562,10 +562,6 @@ static void perf_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 	size = ALIGN(size + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
 
-	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE,
-		      "perf buffer not large enough"))
-		return;
-
 	rec = (struct syscall_trace_enter *)perf_trace_buf_prepare(size,
 				sys_data->enter_event->event.type, regs, &rctx);
 	if (!rec)
@@ -639,14 +635,6 @@ static void perf_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
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
index 32494fb..4a32b52 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -816,8 +816,6 @@ static void uprobe_perf_print(struct trace_uprobe *tu,
 
 	size = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
 	size = ALIGN(size + tu->size + sizeof(u32), sizeof(u64)) - sizeof(u32);
-	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE, "profile buffer not large enough"))
-		return;
 
 	preempt_disable();
 	head = this_cpu_ptr(call->perf_events);
-- 
1.5.5.1

