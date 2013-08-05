Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418Ab3HEQ4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:56:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753825Ab3HEQ4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:56:50 -0400
Date: Mon, 5 Aug 2013 18:51:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] tracing/perf: Avoid perf_trace_buf_*() in
	perf_trace_##call() when possible
Message-ID: <20130805165101.GA6376@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130805165034.GA6344@redhat.com>
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
Tested-by: David Ahern <dsahern@gmail.com>
Reviewed-and-Acked-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/ftrace.h |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 4163d93..5c7ab17 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -667,6 +667,12 @@ perf_trace_##call(void *__data, proto)					\
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
@@ -681,7 +687,6 @@ perf_trace_##call(void *__data, proto)					\
 									\
 	{ assign; }							\
 									\
-	head = this_cpu_ptr(event_call->perf_events);			\
 	perf_trace_buf_submit(entry, __entry_size, rctx, __addr,	\
 		__count, &__regs, head, __task);			\
 }
-- 
1.5.5.1

