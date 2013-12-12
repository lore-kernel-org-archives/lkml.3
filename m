Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab3LLOVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 09:21:19 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36017 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab3LLOVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 09:21:13 -0500
Message-Id: <20131212141655.299946299@infradead.org>
User-Agent: quilt/0.60-1
Date: Thu, 12 Dec 2013 15:08:47 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        rui.zhang@intel.com, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 12/15] sched: Remove local_irq_disable() from the clocks
References: <20131212140835.729222186@infradead.org>
Content-Disposition: inline; filename=peterz-sched_clock_irq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that x86 no longer requires IRQs disabled for sched_clock() and
ia64 never had this requirement (it doesn't seem to do cpufreq at
all), we can remove the requirement of disabling IRQs.

                        MAINLINE   PRE        POST

    sched_clock_stable: 1          1          1
    (cold) sched_clock: 329841     257223     221876
    (cold) local_clock: 301773     309889     234692
    (warm) sched_clock: 38375      25280      25602
    (warm) local_clock: 100371     85268      33265
    (warm) rdtsc:       27340      24247      24214
    sched_clock_stable: 0          0          0
    (cold) sched_clock: 382634     301224     235941
    (cold) local_clock: 396890     399870     297017
    (warm) sched_clock: 38194      25630      25233
    (warm) local_clock: 143452     129629     71234
    (warm) rdtsc:       27345      24307      24245

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/clock.c |   34 ++++++----------------------------
 1 file changed, 6 insertions(+), 28 deletions(-)

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
@@ -242,20 +234,20 @@ u64 sched_clock_cpu(int cpu)
 	struct sched_clock_data *scd;
 	u64 clock;
 
-	WARN_ON_ONCE(!irqs_disabled());
-
 	if (sched_clock_stable)
 		return sched_clock();
 
 	if (unlikely(!sched_clock_running))
 		return 0ull;
 
+	preempt_disable();
 	scd = cpu_sdc(cpu);
 
 	if (cpu != smp_processor_id())
 		clock = sched_clock_remote(scd);
 	else
 		clock = sched_clock_local(scd);
+	preempt_enable();
 
 	return clock;
 }
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
+	return sched_clock_cpu(raw_smp_processor_id());
 }
 
 #else /* CONFIG_HAVE_UNSTABLE_SCHED_CLOCK */


