Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbaLROJX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 09:09:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796AbaLROJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 09:09:22 -0500
Date: Thu, 18 Dec 2014 15:08:47 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] perf ftrace: Factor regs retrieval for function tracer
Message-ID: <20141218140847.GA18898@krava.brq.redhat.com>
References: <20141216115041.GW3337@twins.programming.kicks-ass.net>
 <20141217143105.GG18257@krava.brq.redhat.com>
 <20141217153508.GC30905@twins.programming.kicks-ass.net>
 <20141217154507.GA20471@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141217154507.GA20471@krava.brq.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 04:45:07PM +0100, Jiri Olsa wrote:
> On Wed, Dec 17, 2014 at 04:35:08PM +0100, Peter Zijlstra wrote:
> > On Wed, Dec 17, 2014 at 03:31:05PM +0100, Jiri Olsa wrote:
> > > looks like we could also sanitize the perf_ftrace_function_call
> > > in the same way.. like below (untested)
> > > 
> > > hum, I just noticed it actually has pt_regs arg ;-)
> > 
> > Bu if it has pt_regs should we not use that instead of filling one out
> > again?
> 
> yep, I talked to Steven about that and the thing is that
> it's not guaranteed on all archs.. I'll send patch that
> take that in account

and here it is..

jirka


---
Fixing the perf function tracer pt_regs retrieval in a similar
way as started by Peter in following patch:
  http://marc.info/?t=141873073100002&r=1&w=2

The only change for perf function tracer is that we can register
'struct ftrace_ops' with SAVE_REGS_IF_SUPPORTED flag, which forces
ftrace to fill in data for pt_regs callback argument.

In case we don't get pt_regs data (some architectures might not
have support this), we follow the regs retrieval way introduced
by Peter in above patch.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/trace/trace_event_perf.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 6fa484de2ba1..54bffedd28b6 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -304,7 +304,7 @@ perf_ftrace_function_call(unsigned long ip, unsigned long parent_ip,
 {
 	struct ftrace_entry *entry;
 	struct hlist_head *head;
-	struct pt_regs regs;
+	struct pt_regs **regsp, *regs = pt_regs;
 	int rctx;
 
 	head = this_cpu_ptr(event_function.perf_events);
@@ -316,16 +316,24 @@ perf_ftrace_function_call(unsigned long ip, unsigned long parent_ip,
 
 	BUILD_BUG_ON(ENTRY_SIZE > PERF_MAX_TRACE_SIZE);
 
-	perf_fetch_caller_regs(&regs);
+	/*
+	 * The ftrace_ops is registered with SAVE_REGS_IF_SUPPORTED,
+	 * so if we got pt_regs defined, we don't need to retrieve
+	 * regs buffer through perf_trace_buf_prepare.
+	 */
+	regsp = pt_regs ? NULL : &regs;
 
-	entry = perf_trace_buf_prepare(ENTRY_SIZE, TRACE_FN, NULL, &rctx);
+	entry = perf_trace_buf_prepare(ENTRY_SIZE, TRACE_FN, regsp, &rctx);
 	if (!entry)
 		return;
 
+	if (regsp)
+		perf_fetch_caller_regs(regs);
+
 	entry->ip = ip;
 	entry->parent_ip = parent_ip;
 	perf_trace_buf_submit(entry, ENTRY_SIZE, rctx, 0,
-			      1, &regs, head, NULL);
+			      1, regs, head, NULL);
 
 #undef ENTRY_SIZE
 }
@@ -334,7 +342,7 @@ static int perf_ftrace_function_register(struct perf_event *event)
 {
 	struct ftrace_ops *ops = &event->ftrace_ops;
 
-	ops->flags |= FTRACE_OPS_FL_CONTROL;
+	ops->flags |= FTRACE_OPS_FL_CONTROL|FTRACE_OPS_FL_SAVE_REGS_IF_SUPPORTED;
 	ops->func = perf_ftrace_function_call;
 	return register_ftrace_function(ops);
 }
-- 
1.9.3

