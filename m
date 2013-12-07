Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759045Ab3LGAqJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 19:46:09 -0500
Received: from mga02.intel.com ([134.134.136.20]:7949 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754238Ab3LGAqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 19:46:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,843,1378882800"; 
   d="scan'208";a="420748690"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Andi Kleen <ak@linux.intel.com>, lenb@kernel.org,
        tglx@linutronix.de, peterz@infradead.org
Subject: [PATCH] Trace idle entry and exit times
Date: Fri,  6 Dec 2013 16:46:04 -0800
Message-Id: <1386377164-2223-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

This patch creates 4 new trace points: one at the beginning of idle,
one before entering mwait, one after exiting mwait, and one after
finishing the idle code. This is useful to trace down any
additional latencies caused by the ever-growing idle code.

Idle latencies are a common source of performance problems, so it's
important to be able to measure them.

I moved mwait out of line to avoid a nasty include loop.

To use:

trace-cmd record -e power:cpu_idle_end -e power:cpu_idle_start -e power:cpu_idle_mwait_end -e power:cpu_idle_mwait_start
run workload
Ctrl-C
trace-cmd report

Compute per CPU intervals between
power:cpu_idle_start and power:cpu_idle_mwait_start
to get the entry latency

and

power:cpu_idle_mwait_end and power:cpu_idle_end
to get the exit latency (likely more important)

Cc: lenb@kernel.org
Cc: tglx@linutronix.de
Cc: peterz@infradead.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/processor.h |  7 +------
 arch/x86/kernel/process.c        |  9 +++++++++
 include/trace/events/power.h     | 30 ++++++++++++++++++++++++++++++
 kernel/cpu/idle.c                |  3 +++
 4 files changed, 43 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 7b034a4..22deb08 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -708,12 +708,7 @@ static inline void __monitor(const void *eax, unsigned long ecx,
 		     :: "a" (eax), "c" (ecx), "d"(edx));
 }
 
-static inline void __mwait(unsigned long eax, unsigned long ecx)
-{
-	/* "mwait %eax, %ecx;" */
-	asm volatile(".byte 0x0f, 0x01, 0xc9;"
-		     :: "a" (eax), "c" (ecx));
-}
+extern void __mwait(unsigned long eax, unsigned long ecx);
 
 static inline void __sti_mwait(unsigned long eax, unsigned long ecx)
 {
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 3fb8d95..9083e34 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -469,3 +469,12 @@ unsigned long arch_randomize_brk(struct mm_struct *mm)
 	return randomize_range(mm->brk, range_end, 0) ? : mm->brk;
 }
 
+void __mwait(unsigned long eax, unsigned long ecx)
+{
+	trace_cpu_idle_mwait_start(0);
+	/* "mwait %eax, %ecx;" */
+	asm volatile(".byte 0x0f, 0x01, 0xc9;"
+		     :: "a" (eax), "c" (ecx));
+	trace_cpu_idle_mwait_end(0);
+}
+EXPORT_SYMBOL(__mwait);
diff --git a/include/trace/events/power.h b/include/trace/events/power.h
index cda100d..71261a7 100644
--- a/include/trace/events/power.h
+++ b/include/trace/events/power.h
@@ -35,6 +35,36 @@ DEFINE_EVENT(cpu, cpu_idle,
 	TP_ARGS(state, cpu_id)
 );
 
+/* Dummy argument to work around ftrace's lack of no argument support */
+
+TRACE_EVENT(cpu_idle_start,
+	TP_PROTO(int x),
+	TP_ARGS(x),
+	TP_STRUCT__entry(__array(int, x, 0)),
+	TP_fast_assign((void)(x)),
+	TP_printk("%s", ""))
+
+TRACE_EVENT(cpu_idle_mwait_start,
+	TP_PROTO(int x),
+	TP_ARGS(x),
+	TP_STRUCT__entry(__array(int, x, 0)),
+	TP_fast_assign((void)(x)),
+	TP_printk("%s", ""));
+
+TRACE_EVENT(cpu_idle_mwait_end,
+	TP_PROTO(int x),
+	TP_ARGS(x),
+	TP_STRUCT__entry(__array(int, x, 0)),
+	TP_fast_assign((void)(x)),
+	TP_printk("%s", ""));
+
+TRACE_EVENT(cpu_idle_end,
+	TP_PROTO(int x),
+	TP_ARGS(x),
+	TP_STRUCT__entry(__array(int, x, 0)),
+	TP_fast_assign((void)(x)),
+	TP_printk("%s", ""));
+
 /* This file can get included multiple times, TRACE_HEADER_MULTI_READ at top */
 #ifndef _PWR_EVENT_AVOID_DOUBLE_DEFINING
 #define _PWR_EVENT_AVOID_DOUBLE_DEFINING
diff --git a/kernel/cpu/idle.c b/kernel/cpu/idle.c
index 988573a..1cf1676 100644
--- a/kernel/cpu/idle.c
+++ b/kernel/cpu/idle.c
@@ -6,6 +6,7 @@
 #include <linux/tick.h>
 #include <linux/mm.h>
 #include <linux/stackprotector.h>
+#include <trace/events/power.h>
 
 #include <asm/tlb.h>
 
@@ -68,6 +69,7 @@ void __weak arch_cpu_idle(void)
 static void cpu_idle_loop(void)
 {
 	while (1) {
+		trace_cpu_idle_start(0);
 		tick_nohz_idle_enter();
 
 		while (!need_resched()) {
@@ -114,6 +116,7 @@ static void cpu_idle_loop(void)
 				set_preempt_need_resched();
 		}
 		tick_nohz_idle_exit();
+		trace_cpu_idle_end(0);
 		schedule_preempt_disabled();
 	}
 }
-- 
1.8.3.1

