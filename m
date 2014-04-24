Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649AbaDXQEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:04:00 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:34376 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758624AbaDXQD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:03:28 -0400
Message-Id: <20140424160320.462975510@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 24 Apr 2014 12:02:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 5/8] tracing: Allow irq/preempt tracers to be used by instances
References: <20140424160232.271454710@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0005-tracing-Allow-irq-preempt-tracers-to-be-used-by-inst.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The irqsoff, preemptoff and preemptirqsoff tracers can now be used by
instances. But they may only be used by one instance at a time (including
the top level directory). This allows multiple tracers to run while the
irqsoff (and friends) tracer is running simultaneously.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_irqsoff.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 40aa300..9bb104f 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -597,8 +597,13 @@ static void stop_irqsoff_tracer(struct trace_array *tr, int graph)
 	unregister_irqsoff_function(tr, graph);
 }
 
-static void __irqsoff_tracer_init(struct trace_array *tr)
+static bool irqsoff_busy;
+
+static int __irqsoff_tracer_init(struct trace_array *tr)
 {
+	if (irqsoff_busy)
+		return -EBUSY;
+
 	save_flags = trace_flags;
 
 	/* non overwrite screws up the latency tracers */
@@ -617,6 +622,9 @@ static void __irqsoff_tracer_init(struct trace_array *tr)
 	if (start_irqsoff_tracer(tr, (tr->flags & TRACE_ARRAY_FL_GLOBAL &&
 				      is_graph())))
 		printk(KERN_ERR "failed to start irqsoff tracer\n");
+
+	irqsoff_busy = true;
+	return 0;
 }
 
 static void irqsoff_tracer_reset(struct trace_array *tr)
@@ -629,6 +637,8 @@ static void irqsoff_tracer_reset(struct trace_array *tr)
 	set_tracer_flag(tr, TRACE_ITER_LATENCY_FMT, lat_flag);
 	set_tracer_flag(tr, TRACE_ITER_OVERWRITE, overwrite_flag);
 	ftrace_reset_array_ops(tr);
+
+	irqsoff_busy = false;
 }
 
 static void irqsoff_tracer_start(struct trace_array *tr)
@@ -646,8 +656,7 @@ static int irqsoff_tracer_init(struct trace_array *tr)
 {
 	trace_type = TRACER_IRQS_OFF;
 
-	__irqsoff_tracer_init(tr);
-	return 0;
+	return __irqsoff_tracer_init(tr);
 }
 static struct tracer irqsoff_tracer __read_mostly =
 {
@@ -667,6 +676,7 @@ static struct tracer irqsoff_tracer __read_mostly =
 #endif
 	.open           = irqsoff_trace_open,
 	.close          = irqsoff_trace_close,
+	.allow_instances = true,
 	.use_max_tr	= true,
 };
 # define register_irqsoff(trace) register_tracer(&trace)
@@ -679,8 +689,7 @@ static int preemptoff_tracer_init(struct trace_array *tr)
 {
 	trace_type = TRACER_PREEMPT_OFF;
 
-	__irqsoff_tracer_init(tr);
-	return 0;
+	return __irqsoff_tracer_init(tr);
 }
 
 static struct tracer preemptoff_tracer __read_mostly =
@@ -701,6 +710,7 @@ static struct tracer preemptoff_tracer __read_mostly =
 #endif
 	.open		= irqsoff_trace_open,
 	.close		= irqsoff_trace_close,
+	.allow_instances = true,
 	.use_max_tr	= true,
 };
 # define register_preemptoff(trace) register_tracer(&trace)
@@ -715,8 +725,7 @@ static int preemptirqsoff_tracer_init(struct trace_array *tr)
 {
 	trace_type = TRACER_IRQS_OFF | TRACER_PREEMPT_OFF;
 
-	__irqsoff_tracer_init(tr);
-	return 0;
+	return __irqsoff_tracer_init(tr);
 }
 
 static struct tracer preemptirqsoff_tracer __read_mostly =
@@ -737,6 +746,7 @@ static struct tracer preemptirqsoff_tracer __read_mostly =
 #endif
 	.open		= irqsoff_trace_open,
 	.close		= irqsoff_trace_close,
+	.allow_instances = true,
 	.use_max_tr	= true,
 };
 
-- 
1.8.5.3


