Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135AbaKDNuB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 08:50:01 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:13127 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753421AbaKDNtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:49:17 -0500
Message-Id: <20141104134916.016542150@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 04 Nov 2014 08:48:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [for-next][PATCH 2/4] tracing: Kill the dead code in probe_sched_switch() and
 probe_sched_wakeup()
References: <20141104134847.978505265@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0002-tracing-Kill-the-dead-code-in-probe_sched_switch-and.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

After the previous patch it is clear that "tracer_enabled" can never be
true, we can remove the "if (tracer_enabled)" code in probe_sched_switch()
and probe_sched_wakeup(). Plus we can obviously remove tracer_enabled,
ctx_trace, and sched_stopped as well.

Link: http://lkml.kernel.org/p/20140723193503.GA30217@redhat.com

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_sched_switch.c | 40 ---------------------------------------
 1 file changed, 40 deletions(-)

diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index 3b60301c59d2..f7c7f4f1544c 100644
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
2.1.1


