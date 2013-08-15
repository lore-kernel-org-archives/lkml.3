Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760129Ab3HOTuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 15:50:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59200 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759780Ab3HOTts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 15:49:48 -0400
Date: Thu, 15 Aug 2013 12:49:07 -0700
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-d027e6a9c83440bf1ca9e5503539d58d8e0914f1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, rostedt@goodmis.org, dsahern@gmail.com,
        tglx@linutronix.de, oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, rostedt@goodmis.org, dsahern@gmail.com,
        tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20130806160847.GA2746@redhat.com>
References: <20130806160847.GA2746@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing/perf: Avoid perf_trace_buf_*()
  in perf_trace_##call() when possible
Git-Commit-ID: d027e6a9c83440bf1ca9e5503539d58d8e0914f1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 15 Aug 2013 12:49:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d027e6a9c83440bf1ca9e5503539d58d8e0914f1
Gitweb:     http://git.kernel.org/tip/d027e6a9c83440bf1ca9e5503539d58d8e0914f1
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Tue, 6 Aug 2013 18:08:47 +0200
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 13 Aug 2013 21:06:30 -0400

tracing/perf: Avoid perf_trace_buf_*() in perf_trace_##call() when possible

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
 include/trace/ftrace.h | 7 ++++++-
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
