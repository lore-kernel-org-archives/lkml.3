Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406AbaKFR2b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:28:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbaKFR23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:28:29 -0500
From: Daniel Bristot de Oliveira <bristot@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Subject: [PATCH] ftrace-graph: show latency-format on print_graph_irq()
Date: Thu,  6 Nov 2014 15:25:09 -0200
Message-Id: <7c2e226dac20c940b6242178fab7f0e3c9b5ce58.1415233316.git.bristot@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the function_graph tracer, the print_graph_irq() function prints a
trace line with the flag ==========> on an irq handler entry, and the
flag <========== on an irq handler return.

But when the latency-format is enable, it is not printing the
latency-format flags, causing the following error in the trace output:

 0)   ==========> |
 0)  d...              |  smp_apic_timer_interrupt() {

This patch fixes this issue by printing the latency-format flags when
it is enable.

Signed-off-by: Daniel Bristot de Oliveira <bristot@redhat.com>
Reviewed-by: Luis Claudio R. Goncalves <lgoncalv@redhat.com>

---
 kernel/trace/trace_functions_graph.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index f0a0c98..740f1a0 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -699,6 +699,7 @@ print_graph_irq(struct trace_iterator *iter, unsigned long addr,
 {
 	int ret;
 	struct trace_seq *s = &iter->seq;
+	struct trace_entry *ent = iter->ent;
 
 	if (addr < (unsigned long)__irqentry_text_start ||
 		addr >= (unsigned long)__irqentry_text_end)
@@ -728,6 +729,14 @@ print_graph_irq(struct trace_iterator *iter, unsigned long addr,
 			if (!ret)
 				return TRACE_TYPE_PARTIAL_LINE;
 		}
+
+		/* Latency format */
+		if (trace_flags & TRACE_ITER_LATENCY_FMT) {
+			ret = print_graph_lat_fmt(s, ent);
+			if (ret == TRACE_TYPE_PARTIAL_LINE)
+				return TRACE_TYPE_PARTIAL_LINE;
+		}
+
 	}
 
 	/* No overhead */
-- 
1.9.3

