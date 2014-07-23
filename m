Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933137AbaGWTgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 15:36:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932387AbaGWTgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 15:36:43 -0400
Date: Wed, 23 Jul 2014 21:35:03 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ftrace: Kill the dead code in probe_sched_switch() and
	probe_sched_wakeup()
Message-ID: <20140723193503.GA30217@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140723193444.GA30194@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the previous patch it is clear that "tracer_enabled" can never be
true, we can remove the "if (tracer_enabled)" code in probe_sched_switch()
and probe_sched_wakeup(). Plus we can obviously remove tracer_enabled,
ctx_trace, and sched_stopped as well.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_sched_switch.c |   40 -------------------------------------
 1 files changed, 0 insertions(+), 40 deletions(-)

diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index 3b60301..f7c7f4f 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -14,12 +14,8 @@
 
 #include "trace.h"
 
-static struct trace_array	*ctx_trace;
-static int __read_mostly	tracer_enabled;
 static int			sched_ref;
 static DEFINE_MUTEX(sched_register_mutex);
-static int			sched_stopped;
-
 
 void
 tracing_sched_switch_trace(struct trace_array *tr,
@@ -52,29 +48,11 @@ tracing_sched_switch_trace(struct trace_array *tr,
 static void
 probe_sched_switch(void *ignore, struct task_struct *prev, struct task_struct *next)
 {
-	struct trace_array_cpu *data;
-	unsigned long flags;
-	int cpu;
-	int pc;
-
 	if (unlikely(!sched_ref))
 		return;
 
 	tracing_record_cmdline(prev);
 	tracing_record_cmdline(next);
-
-	if (!tracer_enabled || sched_stopped)
-		return;
-
-	pc = preempt_count();
-	local_irq_save(flags);
-	cpu = raw_smp_processor_id();
-	data = per_cpu_ptr(ctx_trace->trace_buffer.data, cpu);
-
-	if (likely(!atomic_read(&data->disabled)))
-		tracing_sched_switch_trace(ctx_trace, prev, next, flags, pc);
-
-	local_irq_restore(flags);
 }
 
 void
@@ -108,28 +86,10 @@ tracing_sched_wakeup_trace(struct trace_array *tr,
 static void
 probe_sched_wakeup(void *ignore, struct task_struct *wakee, int success)
 {
-	struct trace_array_cpu *data;
-	unsigned long flags;
-	int cpu, pc;
-
 	if (unlikely(!sched_ref))
 		return;
 
 	tracing_record_cmdline(current);
-
-	if (!tracer_enabled || sched_stopped)
-		return;
-
-	pc = preempt_count();
-	local_irq_save(flags);
-	cpu = raw_smp_processor_id();
-	data = per_cpu_ptr(ctx_trace->trace_buffer.data, cpu);
-
-	if (likely(!atomic_read(&data->disabled)))
-		tracing_sched_wakeup_trace(ctx_trace, wakee, current,
-					   flags, pc);
-
-	local_irq_restore(flags);
 }
 
 static int tracing_sched_register(void)
-- 
1.5.5.1

