Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077AbaHHOh1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 10:37:27 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:33154 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756980AbaHHOhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 10:37:14 -0400
Message-Id: <20140808143710.037645264@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 08 Aug 2014 10:32:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 2/4] tracepoint: add generic tracepoint definitions for IPI tracing
References: <20140808143254.145903999@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0002-tracepoint-add-generic-tracepoint-definitions-for-IP.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Pitre <nicolas.pitre@linaro.org>

The Inter Processor Interrupt is used to make another processor do a
specific action such as rescheduling tasks, signal a timer event or
execute something in another CPU's context. IRQs are already traceable
but IPIs were not. Tracing them is useful for monitoring IPI latency,
or to verify when they are the source of CPU wake-ups with power
management implications.

Three trace hooks are defined: ipi_raise, ipi_entry and ipi_exit. To make
them portable, a string is used to identify them and correlate related
events. Additionally, ipi_raise records a bitmask representing targeted
CPUs.

Link: http://lkml.kernel.org/p/1406318733-26754-3-git-send-email-nicolas.pitre@linaro.org

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/ipi.h | 89 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 89 insertions(+)
 create mode 100644 include/trace/events/ipi.h

diff --git a/include/trace/events/ipi.h b/include/trace/events/ipi.h
new file mode 100644
index 000000000000..834a7362a610
--- /dev/null
+++ b/include/trace/events/ipi.h
@@ -0,0 +1,89 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM ipi
+
+#if !defined(_TRACE_IPI_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_IPI_H
+
+#include <linux/tracepoint.h>
+
+/**
+ * ipi_raise - called when a smp cross call is made
+ *
+ * @mask: mask of recipient CPUs for the IPI
+ * @reason: string identifying the IPI purpose
+ *
+ * It is necessary for @reason to be a static string declared with
+ * __tracepoint_string.
+ */
+TRACE_EVENT(ipi_raise,
+
+	TP_PROTO(const struct cpumask *mask, const char *reason),
+
+	TP_ARGS(mask, reason),
+
+	TP_STRUCT__entry(
+		__bitmask(target_cpus, nr_cpumask_bits)
+		__field(const char *, reason)
+	),
+
+	TP_fast_assign(
+		__assign_bitmask(target_cpus, cpumask_bits(mask), nr_cpumask_bits);
+		__entry->reason = reason;
+	),
+
+	TP_printk("target_mask=%s (%s)", __get_bitmask(target_cpus), __entry->reason)
+);
+
+DECLARE_EVENT_CLASS(ipi_handler,
+
+	TP_PROTO(const char *reason),
+
+	TP_ARGS(reason),
+
+	TP_STRUCT__entry(
+		__field(const char *, reason)
+	),
+
+	TP_fast_assign(
+		__entry->reason = reason;
+	),
+
+	TP_printk("(%s)", __entry->reason)
+);
+
+/**
+ * ipi_entry - called immediately before the IPI handler
+ *
+ * @reason: string identifying the IPI purpose
+ *
+ * It is necessary for @reason to be a static string declared with
+ * __tracepoint_string, ideally the same as used with trace_ipi_raise
+ * for that IPI.
+ */
+DEFINE_EVENT(ipi_handler, ipi_entry,
+
+	TP_PROTO(const char *reason),
+
+	TP_ARGS(reason)
+);
+
+/**
+ * ipi_exit - called immediately after the IPI handler returns
+ *
+ * @reason: string identifying the IPI purpose
+ *
+ * It is necessary for @reason to be a static string declared with
+ * __tracepoint_string, ideally the same as used with trace_ipi_raise for
+ * that IPI.
+ */
+DEFINE_EVENT(ipi_handler, ipi_exit,
+
+	TP_PROTO(const char *reason),
+
+	TP_ARGS(reason)
+);
+
+#endif /* _TRACE_IPI_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
2.0.1


