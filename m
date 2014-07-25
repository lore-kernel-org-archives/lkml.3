Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935287AbaGYUHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 16:07:39 -0400
Received: from relais.videotron.ca ([24.201.245.36]:13726 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080AbaGYUHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 16:07:36 -0400
Content-transfer-encoding: 7BIT
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org
Subject: [PATCH v2 2/5] tracepoint: add generic tracepoint definitions for IPI
 tracing
Date: Fri, 25 Jul 2014 16:05:30 -0400
Message-id: <1406318733-26754-3-git-send-email-nicolas.pitre@linaro.org>
X-Mailer: git-send-email 1.8.4.108.g55ea5f6
In-reply-to: <1406318733-26754-1-git-send-email-nicolas.pitre@linaro.org>
References: <1406318733-26754-1-git-send-email-nicolas.pitre@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Nicolas Pitre <nico@linaro.org>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 include/trace/events/ipi.h | 89 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 89 insertions(+)
 create mode 100644 include/trace/events/ipi.h

diff --git a/include/trace/events/ipi.h b/include/trace/events/ipi.h
new file mode 100644
index 0000000000..834a7362a6
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
1.8.4.108.g55ea5f6

