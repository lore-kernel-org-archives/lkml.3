Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284Ab3HaFUO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 01:20:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17351 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801Ab3HaFRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 01:17:04 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=lg7xcWd3iwsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=2SfXdHNypsIA:10 a=Hg4I13Rm0uD_RGvEMn4A:9 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130831051702.253028770@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 31 Aug 2013 01:11:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [RFC][PATCH 11/18 v2] ftrace: Adde infrastructure to stop RCU unsafe checker from checking
References: <20130831051117.884125230@goodmis.org>
Content-Disposition: inline; filename=0011-ftrace-Adde-infrastructure-to-stop-RCU-unsafe-checke.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

This is a light weight way to keep the rcu checker from checking
RCU safety. It adds a ftrace_unsafe_rcu_checker_disable/enable()
that increments or decrements a counter respectively. When the
counter is set, the RCU unsafe checker callback does not run the
tests to see if RCU is safe or not.

This is required by the graph tracer because the checks can cause
the graph tracer to live lock the system by its own calls.

It's also needed by the irqsoff tracer, because it may be called
in RCU unsafe regions and if its internal functions get traced
then the RCU unsafe checker may have some false positives.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h           |   12 +++++++++---
 kernel/trace/trace_functions.c |   15 +++++++++++++++
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index e551316..58e4c37 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -760,9 +760,6 @@ static inline int ftrace_graph_addr(unsigned long addr)
 
 	return 0;
 }
-#ifdef CONFIG_FTRACE_UNSAFE_RCU_CHECKER
-extern bool ftrace_rcu_unsafe(unsigned long addr);
-#endif
 #else
 static inline int ftrace_graph_addr(unsigned long addr)
 {
@@ -1061,4 +1058,13 @@ int perf_ftrace_event_register(struct ftrace_event_call *call,
 #define perf_ftrace_event_register NULL
 #endif
 
+#ifdef CONFIG_FTRACE_UNSAFE_RCU_CHECKER
+extern bool ftrace_rcu_unsafe(unsigned long addr);
+extern void ftrace_unsafe_rcu_checker_disable(void);
+extern void ftrace_unsafe_rcu_checker_enable(void);
+#else
+static inline void ftrace_unsafe_rcu_checker_disable(void) { }
+static inline void ftrace_unsafe_rcu_checker_enable(void) { }
+#endif
+
 #endif /* _LINUX_KERNEL_TRACE_H */
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 9dd4627..1d5f951 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -560,12 +560,27 @@ static inline int init_func_cmd_traceon(void)
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
 #ifdef CONFIG_FTRACE_UNSAFE_RCU_CHECKER
+static atomic_t ftrace_unsafe_rcu_disabled;
+
+void ftrace_unsafe_rcu_checker_disable(void)
+{
+	atomic_inc(&ftrace_unsafe_rcu_disabled);
+}
+
+void ftrace_unsafe_rcu_checker_enable(void)
+{
+	atomic_dec(&ftrace_unsafe_rcu_disabled);
+}
+
 static void
 ftrace_unsafe_callback(unsigned long ip, unsigned long parent_ip,
 		       struct ftrace_ops *op, struct pt_regs *pt_regs)
 {
 	int bit;
 
+	if (atomic_read(&ftrace_unsafe_rcu_disabled))
+		return;
+
 	preempt_disable_notrace();
 
 	bit = trace_test_and_set_recursion(TRACE_FTRACE_START, TRACE_FTRACE_MAX);
-- 
1.7.10.4


