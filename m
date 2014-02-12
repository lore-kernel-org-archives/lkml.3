Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799AbaBLNaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 08:30:08 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37783 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbaBLNaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 08:30:06 -0500
Date: Wed, 12 Feb 2014 14:29:52 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Dave Jones <davej@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Sandeen <sandeen@sandeen.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140212132952.GX27965@twins.programming.kicks-ass.net>
References: <20140212010941.GM18016@ZenIV.linux.org.uk>
 <CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>
 <20140212040358.GA25327@redhat.com>
 <20140212042215.GN18016@ZenIV.linux.org.uk>
 <20140212054043.GB13997@dastard>
 <20140212055027.GA28502@redhat.com>
 <20140212061038.GC13997@dastard>
 <20140212063150.GD13997@dastard>
 <CA+55aFyp91=1seVT0ZV8T+GjOuafWvvjHNHn+MKGydsG+8eUEQ@mail.gmail.com>
 <20140212074036.4c6105b5@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212074036.4c6105b5@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 07:40:36AM -0500, Steven Rostedt wrote:
> The pt_regs structure.
> 
> That's what? 21 unsigned longs? 21 * 8 = 168. I think that's the
> culprit here.
> 
> Peter and Frederic, is there a way not to store that on the stack?

Something like so?

---
 include/trace/ftrace.h          | 7 ++++---
 kernel/trace/trace_event_perf.c | 5 ++++-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 1a8b28db3775..87ae3ef1d278 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -678,7 +678,7 @@ perf_trace_##call(void *__data, proto)					\
 	struct ftrace_event_call *event_call = __data;			\
 	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
 	struct ftrace_raw_##call *entry;				\
-	struct pt_regs __regs;						\
+	struct pt_regs *__regs;						\
 	u64 __addr = 0, __count = 1;					\
 	struct task_struct *__task = NULL;				\
 	struct hlist_head *head;					\
@@ -697,18 +697,19 @@ perf_trace_##call(void *__data, proto)					\
 			     sizeof(u64));				\
 	__entry_size -= sizeof(u32);					\
 									\
-	perf_fetch_caller_regs(&__regs);				\
 	entry = perf_trace_buf_prepare(__entry_size,			\
 			event_call->event.type, &__regs, &rctx);	\
 	if (!entry)							\
 		return;							\
 									\
+	perf_fetch_caller_regs(__regs);					\
+									\
 	tstruct								\
 									\
 	{ assign; }							\
 									\
 	perf_trace_buf_submit(entry, __entry_size, rctx, __addr,	\
-		__count, &__regs, head, __task);			\
+		__count, __regs, head, __task);				\
 }
 
 /*
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index e854f420e033..1885f4aac109 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -232,8 +232,10 @@ void perf_trace_del(struct perf_event *p_event, int flags)
 	tp_event->class->reg(tp_event, TRACE_REG_PERF_DEL, p_event);
 }
 
+static DEFINE_PER_CPU(struct pt_regs, tp_regs[4]);
+
 __kprobes void *perf_trace_buf_prepare(int size, unsigned short type,
-				       struct pt_regs *regs, int *rctxp)
+				       struct pt_regs **regs, int *rctxp)
 {
 	struct trace_entry *entry;
 	unsigned long flags;
@@ -252,6 +254,7 @@ __kprobes void *perf_trace_buf_prepare(int size, unsigned short type,
 	if (*rctxp < 0)
 		return NULL;
 
+	*regs = this_cpu_ptr(&tp_regs[*rctxp]);
 	raw_data = this_cpu_ptr(perf_trace_buf[*rctxp]);
 
 	/* zero the dead bytes from align to not leak stack to user */

