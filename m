Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933615Ab3GRSgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 14:36:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494Ab3GRSgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 14:36:09 -0400
Date: Thu, 18 Jul 2013 20:30:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] tracing/perf: Avoid perf_trace_buf_*() in
	perf_trace_##call() when possible
Message-ID: <20130718183044.GA4071@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130718183018.GA4043@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf_trace_buf_prepare() + perf_trace_buf_submit(task => NULL)
make no sense if hlist_empty(head). Change perf_trace_##call()
to check ->perf_events beforehand and do nothing if it is empty.

This removes the overhead for tasks without events associated
with them. For example, "perf record -e sched:sched_switch -p1"
attaches the counter(s) to the single task, but every task in
system will do perf_trace_buf_prepare/submit() just to realize
that it was not attached to this event.

However, we can only do this if __task == NULL, so we also add
the __builtin_constant_p(__task) check.

With this patch "perf bench sched pipe" shows approximately 4%
improvement when "perf record -p1" runs in parallel, many thanks
to Steven for the testing.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/trace/ftrace.h |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 8886877..04455b8 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -663,6 +663,12 @@ perf_trace_##call(void *__data, proto)					\
 	int rctx;							\
 									\
 	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
+									\
+	head = this_cpu_ptr(event_call->perf_events);			\
+	if (__builtin_constant_p(!__task) && !__task &&			\
+				hlist_empty(head))			\
+		return;							\
+									\
 	__entry_size = ALIGN(__data_size + sizeof(*entry) + sizeof(u32),\
 			     sizeof(u64));				\
 	__entry_size -= sizeof(u32);					\
@@ -677,7 +683,6 @@ perf_trace_##call(void *__data, proto)					\
 									\
 	{ assign; }							\
 									\
-	head = this_cpu_ptr(event_call->perf_events);			\
 	perf_trace_buf_submit(entry, __entry_size, rctx, __addr,	\
 		__count, &__regs, head, __task);			\
 }
-- 
1.5.5.1

