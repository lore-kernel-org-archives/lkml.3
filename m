Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaLQObk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 09:31:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55366 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbaLQObi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 09:31:38 -0500
Date: Wed, 17 Dec 2014 15:31:05 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] perf: Avoid horrible stack usage
Message-ID: <20141217143105.GG18257@krava.brq.redhat.com>
References: <20141216115041.GW3337@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141216115041.GW3337@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 12:50:41PM +0100, Peter Zijlstra wrote:
> Both Linus (most recent) and Steve (a while ago) reported that perf
> results in massive stack bloat.
> 
> The problem is that software events need a pt_regs in order to
> properly report the event location and unwind stack. And because we
> could not assume one was present we allocated one on stack and filled
> it with minimal bits required for operation.
> 
> Now, pt_regs is quite large, so this is undesirable. Furthermore it
> turns out that most sites actually have a pt_regs pointer available,
> making this even more onerous, as the stack space is pointless waste.
> 
> This patch addresses the problem by observing that software events
> have well defined nesting semantics, therefore we can use static
> per-cpu storage instead of on-stack.
> 
> Linus made the further observation that all but the scheduler callers
> of perf_sw_event() have a pt_regs available, so we change the regular
> perf_sw_event() to require a valid pt_regs (where it used to be
> optional) and add perf_sw_event_sched() for the scheduler.
> 
> We have a scheduler specific call instead of a more generic _noregs()
> like construct because we can assume non-recursion from the scheduler
> and thereby simplify the code further (_noregs would have to put the
> recursion context call inline in order to assertain which __perf_regs
> element to use).
> 
> One last note on the implementation of perf_trace_buf_prepare(); we
> allow .regs = NULL for those cases where we already have a pt_regs
> pointer available and do not need another.

looks like we could also sanitize the perf_ftrace_function_call
in the same way.. like below (untested)

hum, I just noticed it actually has pt_regs arg ;-)

Steven, the commit log of:
  a1e2e31d175a ftrace: Return pt_regs to function trace callback

says the pt_regs value is arch specific, but I could not find the
ARCH_SUPPORTS_FTRACE_SAVE_REGS define..

thanks,
jirka


---
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 6fa484de2ba1..6122c216e857 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -304,7 +304,7 @@ perf_ftrace_function_call(unsigned long ip, unsigned long parent_ip,
 {
 	struct ftrace_entry *entry;
 	struct hlist_head *head;
-	struct pt_regs regs;
+	struct pt_regs *regs;
 	int rctx;
 
 	head = this_cpu_ptr(event_function.perf_events);
@@ -316,12 +316,12 @@ perf_ftrace_function_call(unsigned long ip, unsigned long parent_ip,
 
 	BUILD_BUG_ON(ENTRY_SIZE > PERF_MAX_TRACE_SIZE);
 
-	perf_fetch_caller_regs(&regs);
-
-	entry = perf_trace_buf_prepare(ENTRY_SIZE, TRACE_FN, NULL, &rctx);
+	entry = perf_trace_buf_prepare(ENTRY_SIZE, TRACE_FN, &regs, &rctx);
 	if (!entry)
 		return;
 
+	perf_fetch_caller_regs(&regs);
+
 	entry->ip = ip;
 	entry->parent_ip = parent_ip;
 	perf_trace_buf_submit(entry, ENTRY_SIZE, rctx, 0,
