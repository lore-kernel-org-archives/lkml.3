Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab3K2Rsl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 12:48:41 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50497 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab3K2Rsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 12:48:38 -0500
Message-Id: <20131129174430.150107090@infradead.org>
User-Agent: quilt/0.60-1
Date: Fri, 29 Nov 2013 18:37:03 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@gmail.com>, hpa@zytor.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH 6/7] sched: Remove local_irq_disable() from the clocks
References: <20131129173657.252094369@infradead.org>
Content-Disposition: inline; filename=peterz-sched_clock_irq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that x86 uses the 'latch' stuff to avoid having to disable IRQs
while using sched_clock() and ia64 never had this requirement (it
doesn't seem to do cpufreq at all), we can remove the requirement of
disabling IRQs.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/clock.c |   30 ++++--------------------------
 1 file changed, 4 insertions(+), 26 deletions(-)

--- a/kernel/sched/clock.c
+++ b/kernel/sched/clock.c
@@ -26,9 +26,10 @@
  * at 0 on boot (but people really shouldn't rely on that).
  *
  * cpu_clock(i)       -- can be used from any context, including NMI.
- * sched_clock_cpu(i) -- must be used with local IRQs disabled (implied by NMI)
  * local_clock()      -- is cpu_clock() on the current cpu.
  *
+ * sched_clock_cpu(i)
+ *
  * How:
  *
  * The implementation either uses sched_clock() when
@@ -50,15 +51,6 @@
  * Furthermore, explicit sleep and wakeup hooks allow us to account for time
  * that is otherwise invisible (TSC gets stopped).
  *
- *
- * Notes:
- *
- * The !IRQ-safetly of sched_clock() and sched_clock_cpu() comes from things
- * like cpufreq interrupts that can change the base clock (TSC) multiplier
- * and cause funny jumps in time -- although the filtering provided by
- * sched_clock_cpu() should mitigate serious artifacts we cannot rely on it
- * in general since for !CONFIG_HAVE_UNSTABLE_SCHED_CLOCK we fully rely on
- * sched_clock().
  */
 #include <linux/spinlock.h>
 #include <linux/hardirq.h>
@@ -316,14 +308,7 @@ EXPORT_SYMBOL_GPL(sched_clock_idle_wakeu
  */
 u64 cpu_clock(int cpu)
 {
-	u64 clock;
-	unsigned long flags;
-
-	local_irq_save(flags);
-	clock = sched_clock_cpu(cpu);
-	local_irq_restore(flags);
-
-	return clock;
+	return sched_clock_cpu(cpu);
 }
 
 /*
@@ -335,14 +320,7 @@ u64 cpu_clock(int cpu)
  */
 u64 local_clock(void)
 {
-	u64 clock;
-	unsigned long flags;
-
-	local_irq_save(flags);
-	clock = sched_clock_cpu(smp_processor_id());
-	local_irq_restore(flags);
-
-	return clock;
+	return sched_clock_cpu(smp_processor_id());
 }
 
 #else /* CONFIG_HAVE_UNSTABLE_SCHED_CLOCK */


