Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759705Ab3HOTtr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 15:49:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59197 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756785Ab3HOTtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 15:49:45 -0400
Date: Thu, 15 Aug 2013 12:48:47 -0700
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-36009d07b79d2a168d6037947357d96e5d8cebe7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, rostedt@goodmis.org, dsahern@gmail.com,
        tglx@linutronix.de, oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, rostedt@goodmis.org, dsahern@gmail.com,
        tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20130806160841.GA2736@redhat.com>
References: <20130806160841.GA2736@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing/perf: Expand TRACE_EVENT(
 sched_stat_runtime)
Git-Commit-ID: 36009d07b79d2a168d6037947357d96e5d8cebe7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 15 Aug 2013 12:48:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  36009d07b79d2a168d6037947357d96e5d8cebe7
Gitweb:     http://git.kernel.org/tip/36009d07b79d2a168d6037947357d96e5d8cebe7
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Tue, 6 Aug 2013 18:08:41 +0200
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 13 Aug 2013 21:05:12 -0400

tracing/perf: Expand TRACE_EVENT(sched_stat_runtime)

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
 include/trace/events/sched.h | 6 +++++-
 include/trace/ftrace.h       | 7 +++----
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
