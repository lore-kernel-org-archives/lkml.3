Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760147Ab3HOCDj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 22:03:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2950 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758582Ab3HOCDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 22:03:36 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=dzgTTVZbPnkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=l2TaRiXcqNYA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=JfrnYn6hAAAA:8 a=Hv4b9A_i4XO6o4Ooc9EA:9 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=3Rfx1nUSh_UA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130815020335.292748624@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 14 Aug 2013 22:01:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH tip/perf/core 3/3] tracing/perf: Avoid perf_trace_buf_*() in perf_trace_##call() when
 possible
References: <20130815020104.813498803@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-perf-Avoid-perf_trace_buf_-in-perf_trace_-ca.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

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

Link: http://lkml.kernel.org/r/20130806160847.GA2746@redhat.com

Tested-by: David Ahern <dsahern@gmail.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/ftrace.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

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
1.7.10.4


