Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab3JDP2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 11:28:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49320 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476Ab3JDP2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 11:28:40 -0400
Date: Fri, 4 Oct 2013 17:28:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Huang Ying <ying.huang@intel.com>, lkp@linux.intel.com
Subject: Re: [PATCH] ftrace, sched: Add TRACE_FLAG_PREEMPT_RESCHED
Message-ID: <20131004152826.GP3081@twins.programming.kicks-ass.net>
References: <tip-7a7m5qqbn5pmwnd4wko9u6da@git.kernel.org>
 <20130927091427.GE24743@yliu-dev.sh.intel.com>
 <20130927152908.GE15690@laptop.programming.kicks-ass.net>
 <20131004080909.GP26785@twins.programming.kicks-ass.net>
 <20131004105342.20c00a41@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004105342.20c00a41@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 10:53:42AM -0400, Steven Rostedt wrote:
> In other words, what does these flags in the trace actually mean?
> Probably need to add comments in the code and/or update the
> Documentation section

If "task need resched" is supposed to explain things; the below too will
suffice... muwhahaha!

---
Subject: ftrace, sched: Add TRACE_FLAG_PREEMPT_RESCHED
From: Peter Zijlstra <peterz@infradead.org>
Date: Fri Sep 27 17:11:00 CEST 2013

Since the introduction of PREEMPT_NEED_RESCHED; see commit:
f27dde8deef3 ("sched: Add NEED_RESCHED to the preempt_count") we need
to be able to look at both TIF_NEED_RESCHED and PREEMPT_NEED_RESCHED
to understand the full preemption behaviour. Add it to the trace
output.

Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-1tys5rfpbpi7ky20b7msh4qy@git.kernel.org
---
 Documentation/trace/ftrace.txt |    6 +++++-
 kernel/trace/trace.c           |    3 ++-
 kernel/trace/trace.h           |    1 +
 kernel/trace/trace_output.c    |   13 +++++++++++--
 4 files changed, 19 insertions(+), 4 deletions(-)

--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -655,7 +655,11 @@ explains which is which.
 		  read the irq flags variable, an 'X' will always
 		  be printed here.
 
-  need-resched: 'N' task need_resched is set, '.' otherwise.
+  need-resched:
+	'N' both TIF_NEED_RESCHED and PREEMPT_NEED_RESCHED is set,
+	'n' only TIF_NEED_RESCHED is set,
+	'p' only PREEMPT_NEED_RESCHED is set,
+	'.' otherwise.
 
   hardirq/softirq:
 	'H' - hard irq occurred inside a softirq.
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1509,7 +1509,8 @@ tracing_generic_entry_update(struct trac
 #endif
 		((pc & HARDIRQ_MASK) ? TRACE_FLAG_HARDIRQ : 0) |
 		((pc & SOFTIRQ_MASK) ? TRACE_FLAG_SOFTIRQ : 0) |
-		(need_resched() ? TRACE_FLAG_NEED_RESCHED : 0);
+		(tif_need_resched() ? TRACE_FLAG_NEED_RESCHED : 0) |
+		(test_preempt_need_resched() ? TRACE_FLAG_PREEMPT_RESCHED : 0);
 }
 EXPORT_SYMBOL_GPL(tracing_generic_entry_update);
 
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -124,6 +124,7 @@ enum trace_flag_type {
 	TRACE_FLAG_NEED_RESCHED		= 0x04,
 	TRACE_FLAG_HARDIRQ		= 0x08,
 	TRACE_FLAG_SOFTIRQ		= 0x10,
+	TRACE_FLAG_PREEMPT_RESCHED	= 0x20,
 };
 
 #define TRACE_BUF_SIZE		1024
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -618,8 +618,17 @@ int trace_print_lat_fmt(struct trace_seq
 		(entry->flags & TRACE_FLAG_IRQS_OFF) ? 'd' :
 		(entry->flags & TRACE_FLAG_IRQS_NOSUPPORT) ? 'X' :
 		'.';
-	need_resched =
-		(entry->flags & TRACE_FLAG_NEED_RESCHED) ? 'N' : '.';
+
+	if ((entry->flags & TRACE_FLAG_NEED_RESCHED) &&
+	    (entry->flags & TRACE_FLAG_PREEMPT_RESCHED))
+		need_resched = 'N';
+	else if (entry->flags & TRACE_FLAG_NEED_RESCHED)
+		need_resched = 'n';
+	else if (entry->flags & TRACE_FLAG_PREEMPT_RESCHED)
+		need_resched = 'p';
+	else
+		need_resched = '.';
+
 	hardsoft_irq =
 		(hardirq && softirq) ? 'H' :
 		hardirq ? 'h' :
