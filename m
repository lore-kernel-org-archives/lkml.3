Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbaAMP7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:59:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32784 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbaAMP6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:58:14 -0500
Date: Mon, 13 Jan 2014 07:57:45 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-36e5kohiasnr106d077mgubp@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/clock: Remove local_irq_disable()
  from the clocks
Git-Commit-ID: ef08f0fff87630d4f67ceb09514d8b444df833f8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 13 Jan 2014 07:57:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ef08f0fff87630d4f67ceb09514d8b444df833f8
Gitweb:     http://git.kernel.org/tip/ef08f0fff87630d4f67ceb09514d8b444df833f8
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 28 Nov 2013 19:31:23 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 13 Jan 2014 15:13:11 +0100

sched/clock: Remove local_irq_disable() from the clocks

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
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-36e5kohiasnr106d077mgubp@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/clock.c | 34 ++++++----------------------------
 1 file changed, 6 insertions(+), 28 deletions(-)

diff --git a/kernel/sched/clock.c b/kernel/sched/clock.c
index c3ae144..5937154 100644
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
@@ -316,14 +308,7 @@ EXPORT_SYMBOL_GPL(sched_clock_idle_wakeup_event);
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
