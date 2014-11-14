Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422988AbaKNX1A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 18:27:00 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:41666 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935437AbaKNXZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 18:25:01 -0500
Message-Id: <20141114232453.465935537@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 14 Nov 2014 18:24:09 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>
Subject: [for-next][PATCH 8/9] ftrace-graph: show latency-format on print_graph_irq()
References: <20141114232401.493543108@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0008-ftrace-graph-show-latency-format-on-print_graph_irq.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Bristot de Oliveira <bristot@redhat.com>

On the function_graph tracer, the print_graph_irq() function prints a
trace line with the flag ==========> on an irq handler entry, and the
flag <========== on an irq handler return.

But when the latency-format is enable, it is not printing the
latency-format flags, causing the following error in the trace output:

 0)   ==========> |
 0)  d...              |  smp_apic_timer_interrupt() {

This patch fixes this issue by printing the latency-format flags when
it is enable.

Link: http://lkml.kernel.org/r/7c2e226dac20c940b6242178fab7f0e3c9b5ce58.1415233316.git.bristot@redhat.com

Reviewed-by: Luis Claudio R. Goncalves <lgoncalv@redhat.com>
Signed-off-by: Daniel Bristot de Oliveira <bristot@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_functions_graph.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index a82d1d3bd76d..93ebba09622e 100644
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
2.1.1


