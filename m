Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933692Ab3GPRf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 13:35:58 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:60609 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933562Ab3GPRfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 13:35:11 -0400
From: Richard Henderson <rth@twiddle.net>
To: linux-kernel@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, mattst88@gmail.com, linux-alpha@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH 09/10] alpha: Switch to GENERIC_CLOCKEVENTS
Date: Tue, 16 Jul 2013 10:34:17 -0700
Message-Id: <1373996058-13399-10-git-send-email-rth@twiddle.net>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1373996058-13399-1-git-send-email-rth@twiddle.net>
References: <1373996058-13399-1-git-send-email-rth@twiddle.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows us to get rid of some hacky code for SMP.  Get rid of
some cycle counter hackery that's now handled by generic code via
clocksource + clock_event_device objects.

Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Richard Henderson <rth@twiddle.net>
---
 arch/alpha/Kconfig            |   1 +
 arch/alpha/kernel/irq_alpha.c |  14 ------
 arch/alpha/kernel/proto.h     |   2 +-
 arch/alpha/kernel/smp.c       |  33 ++-----------
 arch/alpha/kernel/time.c      | 111 ++++++++++++++++++------------------------
 5 files changed, 52 insertions(+), 109 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 7e268cf..5b57618 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -16,6 +16,7 @@ config ALPHA
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
+	select GENERIC_CLOCKEVENTS
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
diff --git a/arch/alpha/kernel/irq_alpha.c b/arch/alpha/kernel/irq_alpha.c
index f433fc1..49d50e2 100644
--- a/arch/alpha/kernel/irq_alpha.c
+++ b/arch/alpha/kernel/irq_alpha.c
@@ -66,21 +66,7 @@ do_entInt(unsigned long type, unsigned long vector,
 		break;
 	case 1:
 		old_regs = set_irq_regs(regs);
-#ifdef CONFIG_SMP
-	  {
-		long cpu;
-
-		smp_percpu_timer_interrupt(regs);
-		cpu = smp_processor_id();
-		if (cpu != boot_cpuid) {
-		        kstat_incr_irqs_this_cpu(RTC_IRQ, irq_to_desc(RTC_IRQ));
-		} else {
-			handle_irq(RTC_IRQ);
-		}
-	  }
-#else
 		handle_irq(RTC_IRQ);
-#endif
 		set_irq_regs(old_regs);
 		return;
 	case 2:
diff --git a/arch/alpha/kernel/proto.h b/arch/alpha/kernel/proto.h
index b0c8498..175f7a4 100644
--- a/arch/alpha/kernel/proto.h
+++ b/arch/alpha/kernel/proto.h
@@ -135,13 +135,13 @@ extern void unregister_srm_console(void);
 /* smp.c */
 extern void setup_smp(void);
 extern void handle_ipi(struct pt_regs *);
-extern void smp_percpu_timer_interrupt(struct pt_regs *);
 
 /* bios32.c */
 /* extern void reset_for_srm(void); */
 
 /* time.c */
 extern irqreturn_t timer_interrupt(int irq, void *dev);
+extern void init_clockevent(void);
 extern void common_init_rtc(void);
 extern unsigned long est_cycle_freq;
 
diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 7b60834..1a8a10e 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -138,9 +138,11 @@ smp_callin(void)
 
 	/* Get our local ticker going. */
 	smp_setup_percpu_timer(cpuid);
+	init_clockevent();
 
 	/* Call platform-specific callin, if specified */
-	if (alpha_mv.smp_callin) alpha_mv.smp_callin();
+	if (alpha_mv.smp_callin)
+		alpha_mv.smp_callin();
 
 	/* All kernel threads share the same mm context.  */
 	atomic_inc(&init_mm.mm_count);
@@ -497,35 +499,6 @@ smp_cpus_done(unsigned int max_cpus)
 	       ((bogosum + 2500) / (5000/HZ)) % 100);
 }
 
-
-void
-smp_percpu_timer_interrupt(struct pt_regs *regs)
-{
-	struct pt_regs *old_regs;
-	int cpu = smp_processor_id();
-	unsigned long user = user_mode(regs);
-	struct cpuinfo_alpha *data = &cpu_data[cpu];
-
-	old_regs = set_irq_regs(regs);
-
-	/* Record kernel PC.  */
-	profile_tick(CPU_PROFILING);
-
-	if (!--data->prof_counter) {
-		/* We need to make like a normal interrupt -- otherwise
-		   timer interrupts ignore the global interrupt lock,
-		   which would be a Bad Thing.  */
-		irq_enter();
-
-		update_process_times(user);
-
-		data->prof_counter = data->prof_multiplier;
-
-		irq_exit();
-	}
-	set_irq_regs(old_regs);
-}
-
 int
 setup_profiling_timer(unsigned int multiplier)
 {
diff --git a/arch/alpha/kernel/time.c b/arch/alpha/kernel/time.c
index cadb82b..ec45001 100644
--- a/arch/alpha/kernel/time.c
+++ b/arch/alpha/kernel/time.c
@@ -42,6 +42,7 @@
 #include <linux/time.h>
 #include <linux/timex.h>
 #include <linux/clocksource.h>
+#include <linux/clockchips.h>
 
 #include "proto.h"
 #include "irq_impl.h"
@@ -49,25 +50,6 @@
 DEFINE_SPINLOCK(rtc_lock);
 EXPORT_SYMBOL(rtc_lock);
 
-#define TICK_SIZE (tick_nsec / 1000)
-
-/*
- * Shift amount by which scaled_ticks_per_cycle is scaled.  Shifting
- * by 48 gives us 16 bits for HZ while keeping the accuracy good even
- * for large CPU clock rates.
- */
-#define FIX_SHIFT	48
-
-/* lump static variables together for more efficient access: */
-static struct {
-	/* cycle counter last time it got invoked */
-	__u32 last_time;
-	/* ticks/cycle * 2^48 */
-	unsigned long scaled_ticks_per_cycle;
-	/* partial unused tick */
-	unsigned long partial_tick;
-} state;
-
 unsigned long est_cycle_freq;
 
 #ifdef CONFIG_IRQ_WORK
@@ -98,49 +80,63 @@ static inline __u32 rpcc(void)
     return result;
 }
 
+
+
 /*
- * timer_interrupt() needs to keep up the real-time clock,
- * as well as call the "xtime_update()" routine every clocktick
+ * The RTC as a clock_event_device primitive.
  */
-irqreturn_t timer_interrupt(int irq, void *dev)
-{
-	unsigned long delta;
-	__u32 now;
-	long nticks;
 
-#ifndef CONFIG_SMP
-	/* Not SMP, do kernel PC profiling here.  */
-	profile_tick(CPU_PROFILING);
-#endif
+static DEFINE_PER_CPU(struct clock_event_device, cpu_ce);
 
-	/*
-	 * Calculate how many ticks have passed since the last update,
-	 * including any previous partial leftover.  Save any resulting
-	 * fraction for the next pass.
-	 */
-	now = rpcc();
-	delta = now - state.last_time;
-	state.last_time = now;
-	delta = delta * state.scaled_ticks_per_cycle + state.partial_tick;
-	state.partial_tick = delta & ((1UL << FIX_SHIFT) - 1); 
-	nticks = delta >> FIX_SHIFT;
+irqreturn_t
+timer_interrupt(int irq, void *dev)
+{
+	int cpu = smp_processor_id();
+	struct clock_event_device *ce = &per_cpu(cpu_ce, cpu);
 
-	if (nticks)
-		xtime_update(nticks);
+	/* Don't run the hook for UNUSED or SHUTDOWN.  */
+	if (likely(ce->mode == CLOCK_EVT_MODE_PERIODIC))
+		ce->event_handler(ce);
 
 	if (test_irq_work_pending()) {
 		clear_irq_work_pending();
 		irq_work_run();
 	}
 
-#ifndef CONFIG_SMP
-	while (nticks--)
-		update_process_times(user_mode(get_irq_regs()));
-#endif
-
 	return IRQ_HANDLED;
 }
 
+static void
+rtc_ce_set_mode(enum clock_event_mode mode, struct clock_event_device *ce)
+{
+	/* The mode member of CE is updated in generic code.
+	   Since we only support periodic events, nothing to do.  */
+}
+static int
+rtc_ce_set_next_event(unsigned long evt, struct clock_event_device *ce)
+{
+	/* This hook is for oneshot mode, which we don't support.  */
+	return -EINVAL;
+}
+
+void __init
+init_clockevent(void)
+{
+	int cpu = smp_processor_id();
+	struct clock_event_device *ce = &per_cpu(cpu_ce, cpu);
+
+	*ce = (struct clock_event_device){
+		.name = "rtc",
+		.features = CLOCK_EVT_FEAT_PERIODIC,
+		.rating = 100,
+		.cpumask = cpumask_of(cpu),
+		.set_mode = rtc_ce_set_mode,
+		.set_next_event = rtc_ce_set_next_event,
+	};
+
+	clockevents_config_and_register(ce, CONFIG_HZ, 0, 0);
+}
+
 void __init
 common_init_rtc(void)
 {
@@ -365,22 +361,9 @@ time_init(void)
 	if (hwrpb->nr_processors == 1)
 		clocksource_register_hz(&clocksource_rpcc, cycle_freq);
 
-	/* From John Bowman <bowman@math.ualberta.ca>: allow the values
-	   to settle, as the Update-In-Progress bit going low isn't good
-	   enough on some hardware.  2ms is our guess; we haven't found 
-	   bogomips yet, but this is close on a 500Mhz box.  */
-	__delay(1000000);
-
-	if (HZ > (1<<16)) {
-		extern void __you_loose (void);
-		__you_loose();
-	}
-
-	state.last_time = cc1;
-	state.scaled_ticks_per_cycle
-		= ((unsigned long) HZ << FIX_SHIFT) / cycle_freq;
-	state.partial_tick = 0L;
-
 	/* Startup the timer source. */
 	alpha_mv.init_rtc();
+
+	/* Start up the clock event device.  */
+	init_clockevent();
 }
-- 
1.8.1.4

