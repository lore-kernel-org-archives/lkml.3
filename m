Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760190Ab3HOCEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 22:04:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2950 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759975Ab3HOCDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 22:03:37 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=VBg2XEWNCwUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=DexiEvqo-AYA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=pGLkceISAAAA:8 a=tw0jqR0cGbOLAKoT6x4A:9 a=jEp0ucaQiEUA:10 a=3Rfx1nUSh_UA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130815020334.994809031@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 14 Aug 2013 22:01:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH tip/perf/core 1/3] tracing/perf: Expand TRACE_EVENT(sched_stat_runtime)
References: <20130815020104.813498803@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-perf-Expand-TRACE_EVENT-sched_stat_runtime.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

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

Link: http://lkml.kernel.org/r/20130806160841.GA2736@redhat.com

Acked-by: Peter Zijlstra <peterz@infradead.org>
Tested-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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
index 41a6643..618af05 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -663,15 +663,14 @@ perf_trace_##call(void *__data, proto)					\
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
1.7.10.4


