Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933492Ab3GRSgH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 14:36:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494Ab3GRSgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 14:36:05 -0400
Date: Thu, 18 Jul 2013 20:30:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] tracing/perf: expand TRACE_EVENT(sched_stat_runtime)
Message-ID: <20130718183038.GA4061@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130718183018.GA4043@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To simplify the review of the next patches:

1. We are going to reimplent __perf_task/counter and embedd them
   into TP_ARGS(). expand TRACE_EVENT(sched_stat_runtime) into
   DECLARE_EVENT_CLASS() + DEFINE_EVENT(), this way they can use
   different TP_ARGS's.

2. Change perf_trace_##call() macro to do perf_fetch_caller_regs()
   right before perf_trace_buf_prepare().

   This way it evaluates TP_ARGS() asap, the next patch explores
   this fact.

   Note: after 87f44bbc perf_trace_buf_prepare() doesn't need
   "struct pt_regs *regs", perhaps it makes sense to remove this
   argument. And perhaps we can teach perf_trace_buf_submit()
   to accept regs == NULL and do fetch_caller_regs(CALLER_ADDR1)
   in this case.

3. Cosmetic, but the typecast from "void*" buys nothing. It just
   adds the noise, remove it.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/trace/events/sched.h |    6 +++++-
 include/trace/ftrace.h       |    7 +++----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index e5586ca..249c024 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -372,7 +372,7 @@ DEFINE_EVENT(sched_stat_template, sched_stat_blocked,
  * Tracepoint for accounting runtime (time the task is executing
  * on a CPU).
  */
-TRACE_EVENT(sched_stat_runtime,
+DECLARE_EVENT_CLASS(sched_stat_runtime,
 
 	TP_PROTO(struct task_struct *tsk, u64 runtime, u64 vruntime),
 
@@ -401,6 +401,10 @@ TRACE_EVENT(sched_stat_runtime,
 			(unsigned long long)__entry->vruntime)
 );
 
+DEFINE_EVENT(sched_stat_runtime, sched_stat_runtime,
+	     TP_PROTO(struct task_struct *tsk, u64 runtime, u64 vruntime),
+	     TP_ARGS(tsk, runtime, vruntime));
+
 /*
  * Tracepoint for showing priority inheritance modifying a tasks
  * priority.
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index c162a57..aed594a 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -659,15 +659,14 @@ perf_trace_##call(void *__data, proto)					\
 	int __data_size;						\
 	int rctx;							\
 									\
-	perf_fetch_caller_regs(&__regs);				\
-									\
 	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
 	__entry_size = ALIGN(__data_size + sizeof(*entry) + sizeof(u32),\
 			     sizeof(u64));				\
 	__entry_size -= sizeof(u32);					\
 									\
-	entry = (struct ftrace_raw_##call *)perf_trace_buf_prepare(	\
-		__entry_size, event_call->event.type, &__regs, &rctx);	\
+	perf_fetch_caller_regs(&__regs);				\
+	entry = perf_trace_buf_prepare(__entry_size,			\
+			event_call->event.type, &__regs, &rctx);	\
 	if (!entry)							\
 		return;							\
 									\
-- 
1.5.5.1

