Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbaAMP5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:57:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60982 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888AbaAMP5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:57:48 -0500
Date: Mon, 13 Jan 2014 07:57:15 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-01lslnavfgo3kmbo4532zlcj@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/clock, x86: Move some cyc2ns() code around
Git-Commit-ID: 57c67da274f3fab38e08d2c9edf08b89e1d9c71d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 13 Jan 2014 07:57:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  57c67da274f3fab38e08d2c9edf08b89e1d9c71d
Gitweb:     http://git.kernel.org/tip/57c67da274f3fab38e08d2c9edf08b89e1d9c71d
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 29 Nov 2013 15:39:25 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 13 Jan 2014 13:47:39 +0100

sched/clock, x86: Move some cyc2ns() code around

There are no __cycles_2_ns() users outside of arch/x86/kernel/tsc.c,
so move it there.

There are no cycles_2_ns() users.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-01lslnavfgo3kmbo4532zlcj@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/timer.h |  59 -----------------------
 arch/x86/kernel/tsc.c        | 112 +++++++++++++++++++++++--------------------
 2 files changed, 61 insertions(+), 110 deletions(-)

diff --git a/arch/x86/include/asm/timer.h b/arch/x86/include/asm/timer.h
index 10a78c0..b4c6676 100644
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
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 930e5d4..b4a04ac 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -38,6 +38,66 @@ static int __read_mostly tsc_unstable;
 static int __read_mostly tsc_disabled = -1;
 
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
@@ -62,7 +122,7 @@ u64 native_sched_clock(void)
 	rdtscll(this_offset);
 
 	/* return the value in ns */
-	return __cycles_2_ns(this_offset);
+	return cycles_2_ns(this_offset);
 }
 
 /* We need to define a real function for sched_clock, to override the
@@ -589,56 +649,6 @@ int recalibrate_cpu_khz(void)
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
