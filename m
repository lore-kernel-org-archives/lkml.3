Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab3GXQDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 12:03:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941Ab3GXQDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 12:03:33 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, John Stultz <john.stultz@linaro.org>,
        Dave Hansen <dave@sr71.net>, x86@kernel.org
Subject: [PATCH] x86, tsc add an initial read offset to __cycles_2_ns() calculations
Date: Wed, 24 Jul 2013 12:03:20 -0400
Message-Id: <1374681800-7237-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note that the E5 Sandybridge processor does not have IA32_TSC_ADJUST MSR
implemented so attempting to resynch the TSCs is not possible on the
problem hardware.

Thanks to John for the suggestion below.

P.

----8<----

The TSC can have non-zero values at boot time on Intel Xeon E5 (family 6,
model 45) aka "SandyBridge" processors.  This is documented in the Errata
for the E5 processors as BT81.

The __cycles_2_ns() calculation is known to overflow if a large value of
cycles is passed into the function.  This is done by design to improve
precision for smaller significant digits in the calculation.  Since the E5
processor can pass in a large value,  we need to snapshot the TSC's
initial value to avoid calculation overflows in the conversions of cycles
to nanoseconds.

Tested successfully on various Sandybridge systems as well as a few older
and newer systems without any issues.

Also, remove the unused cycles_2_ns() function.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Dave Hansen <dave@sr71.net>
Cc: x86@kernel.org
---
 arch/x86/include/asm/timer.h |   15 +++------------
 arch/x86/kernel/tsc.c        |   13 +++++++++++++
 2 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/timer.h b/arch/x86/include/asm/timer.h
index 34baa0e..f9d666b 100644
--- a/arch/x86/include/asm/timer.h
+++ b/arch/x86/include/asm/timer.h
@@ -12,6 +12,8 @@ extern int recalibrate_cpu_khz(void);
 
 extern int no_timer_check;
 
+extern unsigned long long tsc_initial_value;
+
 /* Accelerators for sched_clock()
  * convert from cycles(64bits) => nanoseconds (64bits)
  *  basic equation:
@@ -59,21 +61,10 @@ static inline unsigned long long __cycles_2_ns(unsigned long long cyc)
 {
 	int cpu = smp_processor_id();
 	unsigned long long ns = per_cpu(cyc2ns_offset, cpu);
+	cyc -= tsc_initial_value;
 	ns += mult_frac(cyc, per_cpu(cyc2ns, cpu),
 			(1UL << CYC2NS_SCALE_FACTOR));
 	return ns;
 }
 
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
index 6ff4924..63ed8cc 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -38,6 +38,16 @@ static int __read_mostly tsc_unstable;
 static int __read_mostly tsc_disabled = -1;
 
 int tsc_clocksource_reliable;
+
+/*
+ * TSC can have non-zero values at boot time on Intel Xeon E5 (family 6,
+ * model 45) aka "SandyBridge" processors.  This is documented in the
+ * Errata for the processors as BT81.  As a result, we need to snapshot
+ * the TSC's initial value to avoid calculation overflows in the conversions
+ * of cycles to nanoseconds.
+ */
+unsigned long long tsc_initial_value;
+
 /*
  * Scheduler clock - returns current time in nanosec units.
  */
@@ -979,6 +989,9 @@ void __init tsc_init(void)
 		return;
 	}
 
+	tsc_initial_value = get_cycles();
+	pr_info("TSC: tsc initial value = %lld\n", tsc_initial_value);
+
 	pr_info("Detected %lu.%03lu MHz processor\n",
 		(unsigned long)cpu_khz / 1000,
 		(unsigned long)cpu_khz % 1000);
-- 
1.7.9.3

