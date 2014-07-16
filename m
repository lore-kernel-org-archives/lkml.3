Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbaGPVIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:08:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:59887 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbaGPVFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:05:13 -0400
Message-Id: <20140716205056.964226252@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:05:12 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch V2 56/64] clocksource: Move cycle_last validation to core code
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=clocksource-move-cycle_last-validation-to-core.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only user of the cycle_last validation is the x86 TSC. In order to
provide NMI safe accessor functions for clock monotonic and
monotonic_raw we need to do that in the core.

We can't do the TSC specific

    if (now < cycle_last)
       	    now = cycle_last;

for the other wrapping around clocksources, but TSC has
CLOCKSOURCE_MASK(64) which actually does not mask out anything so if
now is less than cycle_last the subtraction will give a negative
result. So we can check for that in clocksource_delta() and return 0
for that case.

Implement and enable it for x86

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/Kconfig                   |    1 +
 arch/x86/kernel/tsc.c              |   21 +++++++++------------
 kernel/time/Kconfig                |    5 +++++
 kernel/time/timekeeping_internal.h |    9 +++++++++
 4 files changed, 24 insertions(+), 12 deletions(-)

Index: tip/arch/x86/Kconfig
===================================================================
--- tip.orig/arch/x86/Kconfig
+++ tip/arch/x86/Kconfig
@@ -109,6 +109,7 @@ config X86
 	select CLOCKSOURCE_WATCHDOG
 	select GENERIC_CLOCKEVENTS
 	select ARCH_CLOCKSOURCE_DATA
+	select CLOCKSOURCE_VALIDATE_LAST_CYCLE
 	select GENERIC_CLOCKEVENTS_BROADCAST if X86_64 || (X86_32 && X86_LOCAL_APIC)
 	select GENERIC_TIME_VSYSCALL
 	select GENERIC_STRNCPY_FROM_USER
Index: tip/arch/x86/kernel/tsc.c
===================================================================
--- tip.orig/arch/x86/kernel/tsc.c
+++ tip/arch/x86/kernel/tsc.c
@@ -951,7 +951,7 @@ core_initcall(cpufreq_tsc);
 static struct clocksource clocksource_tsc;
 
 /*
- * We compare the TSC to the cycle_last value in the clocksource
+ * We used to compare the TSC to the cycle_last value in the clocksource
  * structure to avoid a nasty time-warp. This can be observed in a
  * very small window right after one CPU updated cycle_last under
  * xtime/vsyscall_gtod lock and the other CPU reads a TSC value which
@@ -961,26 +961,23 @@ static struct clocksource clocksource_ts
  * due to the unsigned delta calculation of the time keeping core
  * code, which is necessary to support wrapping clocksources like pm
  * timer.
+ *
+ * This sanity check is now done in the core timekeeping code.
+ * checking the result of read_tsc() - cycle_last for being negative.
+ * That works because CLOCKSOURCE_MASK(64) does not mask out any bit.
  */
 static cycle_t read_tsc(struct clocksource *cs)
 {
-	cycle_t ret = (cycle_t)get_cycles();
-
-	return ret >= clocksource_tsc.cycle_last ?
-		ret : clocksource_tsc.cycle_last;
-}
-
-static void resume_tsc(struct clocksource *cs)
-{
-	if (!boot_cpu_has(X86_FEATURE_NONSTOP_TSC_S3))
-		clocksource_tsc.cycle_last = 0;
+	return (cycle_t)get_cycles();
 }
 
+/*
+ * .mask MUST be CLOCKSOURCE_MASK(64). See comment above read_tsc()
+ */
 static struct clocksource clocksource_tsc = {
 	.name                   = "tsc",
 	.rating                 = 300,
 	.read                   = read_tsc,
-	.resume			= resume_tsc,
 	.mask                   = CLOCKSOURCE_MASK(64),
 	.flags                  = CLOCK_SOURCE_IS_CONTINUOUS |
 				  CLOCK_SOURCE_MUST_VERIFY,
Index: tip/kernel/time/Kconfig
===================================================================
--- tip.orig/kernel/time/Kconfig
+++ tip/kernel/time/Kconfig
@@ -12,6 +12,11 @@ config CLOCKSOURCE_WATCHDOG
 config ARCH_CLOCKSOURCE_DATA
 	bool
 
+# Clocksources require validation of the clocksource against the last
+# cycle update - x86/TSC misfeature
+config CLOCKSOURCE_VALIDATE_LAST_CYCLE
+	bool
+
 # Timekeeping vsyscall support
 config GENERIC_TIME_VSYSCALL
 	bool
Index: tip/kernel/time/timekeeping_internal.h
===================================================================
--- tip.orig/kernel/time/timekeeping_internal.h
+++ tip/kernel/time/timekeeping_internal.h
@@ -12,9 +12,18 @@ extern void tk_debug_account_sleep_time(
 #define tk_debug_account_sleep_time(x)
 #endif
 
+#ifdef CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE
+static inline cycle_t clocksource_delta(cycle_t now, cycle_t last, cycle_t mask)
+{
+	cycle_t ret = (now - last) & mask;
+
+	return (s64) ret > 0 ? ret : 0;
+}
+#else
 static inline cycle_t clocksource_delta(cycle_t now, cycle_t last, cycle_t mask)
 {
 	return (now - last) & mask;
 }
+#endif
 
 #endif /* _TIMEKEEPING_INTERNAL_H */


