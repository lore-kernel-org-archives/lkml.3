Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab3K2Rtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 12:49:52 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50504 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab3K2Rsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 12:48:39 -0500
Message-Id: <20131129174430.005767546@infradead.org>
User-Agent: quilt/0.60-1
Date: Fri, 29 Nov 2013 18:37:01 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@gmail.com>, hpa@zytor.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH 4/7] x86: Move some code around
References: <20131129173657.252094369@infradead.org>
Content-Disposition: inline; filename=peterz-tsc-move.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no __cycles_2_ns() users outside of arch/x86/kernel/tsc.c,
so move it there.

There are no cycles_2_ns() users.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/include/asm/timer.h |   59 ----------------------
 arch/x86/kernel/tsc.c        |  112 +++++++++++++++++++++++--------------------
 2 files changed, 61 insertions(+), 110 deletions(-)

--- a/arch/x86/include/asm/timer.h
+++ b/arch/x86/include/asm/timer.h
@@ -13,66 +13,7 @@ extern int recalibrate_cpu_khz(void);
 
 extern int no_timer_check;
 
-/* Accelerators for sched_clock()
- * convert from cycles(64bits) => nanoseconds (64bits)
- *  basic equation:
- *		ns = cycles / (freq / ns_per_sec)
- *		ns = cycles * (ns_per_sec / freq)
- *		ns = cycles * (10^9 / (cpu_khz * 10^3))
- *		ns = cycles * (10^6 / cpu_khz)
- *
- *	Then we use scaling math (suggested by george@mvista.com) to get:
- *		ns = cycles * (10^6 * SC / cpu_khz) / SC
- *		ns = cycles * cyc2ns_scale / SC
- *
- *	And since SC is a constant power of two, we can convert the div
- *  into a shift.
- *
- *  We can use khz divisor instead of mhz to keep a better precision, since
- *  cyc2ns_scale is limited to 10^6 * 2^10, which fits in 32 bits.
- *  (mathieu.desnoyers@polymtl.ca)
- *
- *			-johnstul@us.ibm.com "math is hard, lets go shopping!"
- *
- * In:
- *
- * ns = cycles * cyc2ns_scale / SC
- *
- * Although we may still have enough bits to store the value of ns,
- * in some cases, we may not have enough bits to store cycles * cyc2ns_scale,
- * leading to an incorrect result.
- *
- * To avoid this, we can decompose 'cycles' into quotient and remainder
- * of division by SC.  Then,
- *
- * ns = (quot * SC + rem) * cyc2ns_scale / SC
- *    = quot * cyc2ns_scale + (rem * cyc2ns_scale) / SC
- *
- *			- sqazi@google.com
- */
-
 DECLARE_PER_CPU(unsigned long, cyc2ns);
 DECLARE_PER_CPU(unsigned long long, cyc2ns_offset);
 
-#define CYC2NS_SCALE_FACTOR 10 /* 2^10, carefully chosen */
-
-static inline unsigned long long __cycles_2_ns(unsigned long long cyc)
-{
-	unsigned long long ns = this_cpu_read(cyc2ns_offset);
-	ns += mul_u64_u32_shr(cyc, this_cpu_read(cyc2ns), CYC2NS_SCALE_FACTOR);
-	return ns;
-}
-
-static inline unsigned long long cycles_2_ns(unsigned long long cyc)
-{
-	unsigned long long ns;
-	unsigned long flags;
-
-	local_irq_save(flags);
-	ns = __cycles_2_ns(cyc);
-	local_irq_restore(flags);
-
-	return ns;
-}
-
 #endif /* _ASM_X86_TIMER_H */
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -41,6 +41,66 @@ static int __read_mostly tsc_disabled =
 static struct static_key __use_tsc = STATIC_KEY_INIT;
 
 int tsc_clocksource_reliable;
+
+/* Accelerators for sched_clock()
+ * convert from cycles(64bits) => nanoseconds (64bits)
+ *  basic equation:
+ *              ns = cycles / (freq / ns_per_sec)
+ *              ns = cycles * (ns_per_sec / freq)
+ *              ns = cycles * (10^9 / (cpu_khz * 10^3))
+ *              ns = cycles * (10^6 / cpu_khz)
+ *
+ *      Then we use scaling math (suggested by george@mvista.com) to get:
+ *              ns = cycles * (10^6 * SC / cpu_khz) / SC
+ *              ns = cycles * cyc2ns_scale / SC
+ *
+ *      And since SC is a constant power of two, we can convert the div
+ *  into a shift.
+ *
+ *  We can use khz divisor instead of mhz to keep a better precision, since
+ *  cyc2ns_scale is limited to 10^6 * 2^10, which fits in 32 bits.
+ *  (mathieu.desnoyers@polymtl.ca)
+ *
+ *                      -johnstul@us.ibm.com "math is hard, lets go shopping!"
+ */
+
+DEFINE_PER_CPU(unsigned long, cyc2ns);
+DEFINE_PER_CPU(unsigned long long, cyc2ns_offset);
+
+#define CYC2NS_SCALE_FACTOR 10 /* 2^10, carefully chosen */
+
+static inline unsigned long long cycles_2_ns(unsigned long long cyc)
+{
+	unsigned long long ns = this_cpu_read(cyc2ns_offset);
+	ns += mul_u64_u32_shr(cyc, this_cpu_read(cyc2ns), CYC2NS_SCALE_FACTOR);
+	return ns;
+}
+
+static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
+{
+	unsigned long long tsc_now, ns_now, *offset;
+	unsigned long flags, *scale;
+
+	local_irq_save(flags);
+	sched_clock_idle_sleep_event();
+
+	scale = &per_cpu(cyc2ns, cpu);
+	offset = &per_cpu(cyc2ns_offset, cpu);
+
+	rdtscll(tsc_now);
+	ns_now = cycles_2_ns(tsc_now);
+
+	if (cpu_khz) {
+		*scale = ((NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR) +
+				cpu_khz / 2) / cpu_khz;
+		*offset = ns_now - mult_frac(tsc_now, *scale,
+					     (1UL << CYC2NS_SCALE_FACTOR));
+	}
+
+	sched_clock_idle_wakeup_event(0);
+	local_irq_restore(flags);
+}
+
 /*
  * Scheduler clock - returns current time in nanosec units.
  */
@@ -65,7 +125,7 @@ u64 native_sched_clock(void)
 	rdtscll(this_offset);
 
 	/* return the value in ns */
-	return __cycles_2_ns(this_offset);
+	return cycles_2_ns(this_offset);
 }
 
 /* We need to define a real function for sched_clock, to override the
@@ -592,56 +652,6 @@ int recalibrate_cpu_khz(void)
 EXPORT_SYMBOL(recalibrate_cpu_khz);
 
 
-/* Accelerators for sched_clock()
- * convert from cycles(64bits) => nanoseconds (64bits)
- *  basic equation:
- *              ns = cycles / (freq / ns_per_sec)
- *              ns = cycles * (ns_per_sec / freq)
- *              ns = cycles * (10^9 / (cpu_khz * 10^3))
- *              ns = cycles * (10^6 / cpu_khz)
- *
- *      Then we use scaling math (suggested by george@mvista.com) to get:
- *              ns = cycles * (10^6 * SC / cpu_khz) / SC
- *              ns = cycles * cyc2ns_scale / SC
- *
- *      And since SC is a constant power of two, we can convert the div
- *  into a shift.
- *
- *  We can use khz divisor instead of mhz to keep a better precision, since
- *  cyc2ns_scale is limited to 10^6 * 2^10, which fits in 32 bits.
- *  (mathieu.desnoyers@polymtl.ca)
- *
- *                      -johnstul@us.ibm.com "math is hard, lets go shopping!"
- */
-
-DEFINE_PER_CPU(unsigned long, cyc2ns);
-DEFINE_PER_CPU(unsigned long long, cyc2ns_offset);
-
-static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
-{
-	unsigned long long tsc_now, ns_now, *offset;
-	unsigned long flags, *scale;
-
-	local_irq_save(flags);
-	sched_clock_idle_sleep_event();
-
-	scale = &per_cpu(cyc2ns, cpu);
-	offset = &per_cpu(cyc2ns_offset, cpu);
-
-	rdtscll(tsc_now);
-	ns_now = __cycles_2_ns(tsc_now);
-
-	if (cpu_khz) {
-		*scale = ((NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR) +
-				cpu_khz / 2) / cpu_khz;
-		*offset = ns_now - mult_frac(tsc_now, *scale,
-					     (1UL << CYC2NS_SCALE_FACTOR));
-	}
-
-	sched_clock_idle_wakeup_event(0);
-	local_irq_restore(flags);
-}
-
 static unsigned long long cyc2ns_suspend;
 
 void tsc_save_sched_clock_state(void)


