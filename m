Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab3AXKxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:53:18 -0500
Received: from alvesta.synopsys.com ([198.182.60.77]:42443 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab3AXKwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:52:33 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v3 19/71] ARC: Timers/counters/delay management
Date: Thu, 24 Jan 2013 16:20:21 +0530
Message-ID: <1359024639-21915-8-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359024639-21915-1-git-send-email-vgupta@synopsys.com>
References: <1359024639-21915-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARC700 includes 2 in-core 32bit timers TIMER0 and TIMER1.
Both have exactly same capabilies.

* programmable to count from TIMER<n>_CNT to TIMER<n>_LIMIT
* for count 0 and LIMIT ~1, provides a free-running counter by
    auto-wrapping when limit is reached.
* optionally interrupt when LIMIT is reached (oneshot event semantics)
* rearming the interrupt provides periodic semantics
* run at CPU clk

ARC Linux uses TIMER0 for clockevent (periodic/oneshot) and TIMER1 for
clocksource (free-running clock).

Newer cores provide RTSC insn which gives a 64bit cpu clk snapshot hence
is more apt for clocksource when available.

SMP poses a bit of challenge for global timekeeping clocksource /
sched_clock() backend:
 -TIMER1 based local clocks are out-of-sync hence can't be used
  (thus we default to jiffies based cs as well as sched_clock() one/both
  of which platform can override with it's specific hardware assist)
 -RTSC is only allowed in SMP if it's cross-core-sync (Kconfig glue
  ensures that) and thus usable for both requirements.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arc/include/asm/arcregs.h |   11 ++
 arch/arc/include/asm/clk.h     |   20 +++
 arch/arc/include/asm/delay.h   |   68 +++++++++
 arch/arc/include/asm/irq.h     |    2 +
 arch/arc/include/asm/timex.h   |   18 +++
 arch/arc/kernel/clk.c          |   11 ++
 arch/arc/kernel/time.c         |  295 ++++++++++++++++++++++++++++++++++++++++
 7 files changed, 425 insertions(+), 0 deletions(-)
 create mode 100644 arch/arc/include/asm/clk.h
 create mode 100644 arch/arc/include/asm/delay.h
 create mode 100644 arch/arc/include/asm/timex.h
 create mode 100644 arch/arc/kernel/clk.c
 create mode 100644 arch/arc/kernel/time.c

diff --git a/arch/arc/include/asm/arcregs.h b/arch/arc/include/asm/arcregs.h
index d764118..5131bb3 100644
--- a/arch/arc/include/asm/arcregs.h
+++ b/arch/arc/include/asm/arcregs.h
@@ -47,6 +47,17 @@
 #define AUX_ITRIGGER		0x40d
 #define AUX_IPULSE		0x415
 
+/* Timer related Aux registers */
+#define ARC_REG_TIMER0_LIMIT	0x23	/* timer 0 limit */
+#define ARC_REG_TIMER0_CTRL	0x22	/* timer 0 control */
+#define ARC_REG_TIMER0_CNT	0x21	/* timer 0 count */
+#define ARC_REG_TIMER1_LIMIT	0x102	/* timer 1 limit */
+#define ARC_REG_TIMER1_CTRL	0x101	/* timer 1 control */
+#define ARC_REG_TIMER1_CNT	0x100	/* timer 1 count */
+
+#define TIMER_CTRL_IE		(1 << 0) /* Interupt when Count reachs limit */
+#define TIMER_CTRL_NH		(1 << 1) /* Count only when CPU NOT halted */
+
 /*
  * Floating Pt Registers
  * Status regs are read-only (build-time) so need not be saved/restored
diff --git a/arch/arc/include/asm/clk.h b/arch/arc/include/asm/clk.h
new file mode 100644
index 0000000..6195643
--- /dev/null
+++ b/arch/arc/include/asm/clk.h
@@ -0,0 +1,20 @@
+/*
+ * Copyright (C) 2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_ARC_CLK_H
+#define _ASM_ARC_CLK_H
+
+/* Although we can't really hide core_freq, the accessor is still better way */
+extern unsigned long core_freq;
+
+static inline unsigned long arc_get_core_freq(void)
+{
+	return core_freq;
+}
+
+#endif
diff --git a/arch/arc/include/asm/delay.h b/arch/arc/include/asm/delay.h
new file mode 100644
index 0000000..442ce5d
--- /dev/null
+++ b/arch/arc/include/asm/delay.h
@@ -0,0 +1,68 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Delay routines using pre computed loops_per_jiffy value.
+ *
+ * vineetg: Feb 2012
+ *  -Rewrote in "C" to avoid dealing with availability of H/w MPY
+ *  -Also reduced the num of MPY operations from 3 to 2
+ *
+ * Amit Bhor: Codito Technologies 2004
+ */
+
+#ifndef __ASM_ARC_UDELAY_H
+#define __ASM_ARC_UDELAY_H
+
+#include <asm/param.h>		/* HZ */
+
+static inline void __delay(unsigned long loops)
+{
+	__asm__ __volatile__(
+	"1:	sub.f %0, %0, 1	\n"
+	"	jpnz 1b		\n"
+	: "+r"(loops)
+	:
+	: "cc");
+}
+
+extern void __bad_udelay(void);
+
+/*
+ * Normal Math for computing loops in "N" usecs
+ *  -we have precomputed @loops_per_jiffy
+ *  -1 sec has HZ jiffies
+ * loops per "N" usecs = ((loops_per_jiffy * HZ / 1000000) * N)
+ *
+ * Approximate Division by multiplication:
+ *  -Mathematically if we multiply and divide a number by same value the
+ *   result remains unchanged:  In this case, we use 2^32
+ *  -> (loops_per_N_usec * 2^32 ) / 2^32
+ *  -> (((loops_per_jiffy * HZ / 1000000) * N) * 2^32) / 2^32
+ *  -> (loops_per_jiffy * HZ * N * 4295) / 2^32
+ *
+ *  -Divide by 2^32 is very simply right shift by 32
+ *  -We simply need to ensure that the multiply per above eqn happens in
+ *   64-bit precision (if CPU doesn't support it - gcc can emaulate it)
+ */
+
+static inline void __udelay(unsigned long usecs)
+{
+	unsigned long loops;
+
+	/* (long long) cast ensures 64 bit MPY - real or emulated
+	 * HZ * 4295 is pre-evaluated by gcc - hence only 2 mpy ops
+	 */
+	loops = ((long long)(usecs * 4295 * HZ) *
+		 (long long)(loops_per_jiffy)) >> 32;
+
+	__delay(loops);
+}
+
+#define udelay(n) (__builtin_constant_p(n) ? ((n) > 20000 ? __bad_udelay() \
+				: __udelay(n)) : __udelay(n))
+
+#endif /* __ASM_ARC_UDELAY_H */
diff --git a/arch/arc/include/asm/irq.h b/arch/arc/include/asm/irq.h
index ca4aeba..514b302 100644
--- a/arch/arc/include/asm/irq.h
+++ b/arch/arc/include/asm/irq.h
@@ -19,4 +19,6 @@ extern void __init arc_init_IRQ(void);
 extern void __init plat_init_IRQ(void);
 extern int __init get_hw_config_num_irq(void);
 
+void __cpuinit arc_local_timer_setup(unsigned int cpu);
+
 #endif
diff --git a/arch/arc/include/asm/timex.h b/arch/arc/include/asm/timex.h
new file mode 100644
index 0000000..0a82960
--- /dev/null
+++ b/arch/arc/include/asm/timex.h
@@ -0,0 +1,18 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_ARC_TIMEX_H
+#define _ASM_ARC_TIMEX_H
+
+#define CLOCK_TICK_RATE	80000000 /* slated to be removed */
+
+#include <asm-generic/timex.h>
+
+/* XXX: get_cycles() to be implemented with RTSC insn */
+
+#endif /* _ASM_ARC_TIMEX_H */
diff --git a/arch/arc/kernel/clk.c b/arch/arc/kernel/clk.c
new file mode 100644
index 0000000..64925db
--- /dev/null
+++ b/arch/arc/kernel/clk.c
@@ -0,0 +1,11 @@
+/*
+ * Copyright (C) 2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <asm/clk.h>
+
+unsigned long core_freq = CONFIG_ARC_PLAT_CLK;
diff --git a/arch/arc/kernel/time.c b/arch/arc/kernel/time.c
new file mode 100644
index 0000000..05dba11
--- /dev/null
+++ b/arch/arc/kernel/time.c
@@ -0,0 +1,295 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * vineetg: Jan 1011
+ *  -sched_clock( ) no longer jiffies based. Uses the same clocksource
+ *   as gtod
+ *
+ * Rajeshwarr/Vineetg: Mar 2008
+ *  -Implemented CONFIG_GENERIC_TIME (rather deleted arch specific code)
+ *   for arch independent gettimeofday()
+ *  -Implemented CONFIG_GENERIC_CLOCKEVENTS as base for hrtimers
+ *
+ * Vineetg: Mar 2008: Forked off from time.c which now is time-jiff.c
+ */
+
+/* ARC700 has two 32bit independent prog Timers: TIMER0 and TIMER1
+ * Each can programmed to go from @count to @limit and optionally
+ * interrupt when that happens.
+ * A write to Control Register clears the Interrupt
+ *
+ * We've designated TIMER0 for events (clockevents)
+ * while TIMER1 for free running (clocksource)
+ *
+ * Newer ARC700 cores have 64bit clk fetching RTSC insn, preferred over TIMER1
+ */
+
+#include <linux/spinlock.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/time.h>
+#include <linux/init.h>
+#include <linux/timex.h>
+#include <linux/profile.h>
+#include <linux/clocksource.h>
+#include <linux/clockchips.h>
+#include <asm/irq.h>
+#include <asm/arcregs.h>
+#include <asm/clk.h>
+
+#define ARC_TIMER_MAX	0xFFFFFFFF
+
+/********** Clock Source Device *********/
+
+#ifdef CONFIG_ARC_HAS_RTSC
+
+int __cpuinit arc_counter_setup(void)
+{
+	/* RTSC insn taps into cpu clk, needs no setup */
+
+	/* For SMP, only allowed if cross-core-sync, hence usable as cs */
+	return 1;
+}
+
+static cycle_t arc_counter_read(struct clocksource *cs)
+{
+	unsigned long flags;
+	union {
+#ifdef CONFIG_CPU_BIG_ENDIAN
+		struct { u32 high, low; };
+#else
+		struct { u32 low, high; };
+#endif
+		cycle_t  full;
+	} stamp;
+
+	flags = arch_local_irq_save();
+
+	__asm__ __volatile(
+	"	.extCoreRegister tsch, 58,  r, cannot_shortcut	\n"
+	"	rtsc %0, 0	\n"
+	"	mov  %1, tsch	\n"	/* TSCH is extn core reg 58 */
+	: "=r" (stamp.low), "=r" (stamp.high));
+
+	arch_local_irq_restore(flags);
+
+	return stamp.full;
+}
+
+static struct clocksource arc_counter = {
+	.name   = "ARC RTSC",
+	.rating = 300,
+	.read   = arc_counter_read,
+	.mask   = CLOCKSOURCE_MASK(64),
+	.flags  = CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+#else /* !CONFIG_ARC_HAS_RTSC */
+
+static bool is_usable_as_clocksource(void)
+{
+#ifdef CONFIG_SMP
+	return 0;
+#else
+	return 1;
+#endif
+}
+
+/*
+ * set 32bit TIMER1 to keep counting monotonically and wraparound
+ */
+int __cpuinit arc_counter_setup(void)
+{
+	write_aux_reg(ARC_REG_TIMER1_LIMIT, ARC_TIMER_MAX);
+	write_aux_reg(ARC_REG_TIMER1_CNT, 0);
+	write_aux_reg(ARC_REG_TIMER1_CTRL, TIMER_CTRL_NH);
+
+	return is_usable_as_clocksource();
+}
+
+static cycle_t arc_counter_read(struct clocksource *cs)
+{
+	return (cycle_t) read_aux_reg(ARC_REG_TIMER1_CNT);
+}
+
+static struct clocksource arc_counter = {
+	.name   = "ARC Timer1",
+	.rating = 300,
+	.read   = arc_counter_read,
+	.mask   = CLOCKSOURCE_MASK(32),
+	.flags  = CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+#endif
+
+/********** Clock Event Device *********/
+
+/*
+ * Arm the timer to interrupt after @limit cycles
+ * The distinction for oneshot/periodic is done in arc_event_timer_ack() below
+ */
+static void arc_timer_event_setup(unsigned int limit)
+{
+	write_aux_reg(ARC_REG_TIMER0_LIMIT, limit);
+	write_aux_reg(ARC_REG_TIMER0_CNT, 0);	/* start from 0 */
+
+	write_aux_reg(ARC_REG_TIMER0_CTRL, TIMER_CTRL_IE | TIMER_CTRL_NH);
+}
+
+/*
+ * Acknowledge the interrupt (oneshot) and optionally re-arm it (periodic)
+ * -Any write to CTRL Reg will ack the intr (NH bit: Count when not halted)
+ * -Rearming is done by setting the IE bit
+ *
+ * Small optimisation: Normal code would have been
+ *   if (irq_reenable)
+ *     CTRL_REG = (IE | NH);
+ *   else
+ *     CTRL_REG = NH;
+ * However since IE is BIT0 we can fold the branch
+ */
+static void arc_timer_event_ack(unsigned int irq_reenable)
+{
+	write_aux_reg(ARC_REG_TIMER0_CTRL, irq_reenable | TIMER_CTRL_NH);
+}
+
+static int arc_clkevent_set_next_event(unsigned long delta,
+				       struct clock_event_device *dev)
+{
+	arc_timer_event_setup(delta);
+	return 0;
+}
+
+static void arc_clkevent_set_mode(enum clock_event_mode mode,
+				  struct clock_event_device *dev)
+{
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+		arc_timer_event_setup(arc_get_core_freq() / HZ);
+		break;
+	case CLOCK_EVT_MODE_ONESHOT:
+		break;
+	default:
+		break;
+	}
+
+	return;
+}
+
+static DEFINE_PER_CPU(struct clock_event_device, arc_clockevent_device) = {
+	.name		= "ARC Timer0",
+	.features	= CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_PERIODIC,
+	.mode		= CLOCK_EVT_MODE_UNUSED,
+	.rating		= 300,
+	.irq		= TIMER0_IRQ,	/* hardwired, no need for resources */
+	.set_next_event = arc_clkevent_set_next_event,
+	.set_mode	= arc_clkevent_set_mode,
+};
+
+static irqreturn_t timer_irq_handler(int irq, void *dev_id)
+{
+	struct clock_event_device *clk = &__get_cpu_var(arc_clockevent_device);
+
+	arc_timer_event_ack(clk->mode == CLOCK_EVT_MODE_PERIODIC);
+	clk->event_handler(clk);
+	return IRQ_HANDLED;
+}
+
+static struct irqaction arc_timer_irq = {
+	.name    = "Timer0 (clock-evt-dev)",
+	.flags   = IRQF_TIMER | IRQF_PERCPU,
+	.handler = timer_irq_handler,
+};
+
+/*
+ * Setup the local event timer for @cpu
+ * N.B. weak so that some exotic ARC SoCs can completely override it
+ */
+void __attribute__((weak)) __cpuinit arc_local_timer_setup(unsigned int cpu)
+{
+	struct clock_event_device *clk = &per_cpu(arc_clockevent_device, cpu);
+
+	clockevents_calc_mult_shift(clk, arc_get_core_freq(), 5);
+
+	clk->max_delta_ns = clockevent_delta2ns(ARC_TIMER_MAX, clk);
+	clk->cpumask = cpumask_of(cpu);
+
+	clockevents_register_device(clk);
+
+	/*
+	 * setup the per-cpu timer IRQ handler - for all cpus
+	 * For non boot CPU explicitly unmask at intc
+	 * setup_irq() -> .. -> irq_startup() already does this on boot-cpu
+	 */
+	if (!cpu)
+		setup_irq(TIMER0_IRQ, &arc_timer_irq);
+	else
+		arch_unmask_irq(TIMER0_IRQ);
+}
+
+/*
+ * Called from start_kernel() - boot CPU only
+ *
+ * -Sets up h/w timers as applicable on boot cpu
+ * -Also sets up any global state needed for timer subsystem:
+ *    - for "counting" timer, registers a clocksource, usable across CPUs
+ *      (provided that underlying counter h/w is synchronized across cores)
+ *    - for "event" timer, sets up TIMER0 IRQ (as that is platform agnostic)
+ */
+void __init time_init(void)
+{
+	/*
+	 * sets up the timekeeping free-flowing counter which also returns
+	 * whether the counter is usable as clocksource
+	 */
+	if (arc_counter_setup())
+		/*
+		 * CLK upto 4.29 GHz can be safely represented in 32 bits
+		 * because Max 32 bit number is 4,294,967,295
+		 */
+		clocksource_register_hz(&arc_counter, arc_get_core_freq());
+
+	/* sets up the periodic event timer */
+	arc_local_timer_setup(smp_processor_id());
+}
+
+#ifdef CONFIG_ARC_HAS_RTSC
+/*
+ * sched_clock math assist
+ * ns = cycles * (ns_per_sec / cpu_freq_hz)
+ * ns = cycles * (10^6 / cpu_freq_khz)
+ * ns = cycles * (10^6 * 2^SF / cpu_freq_khz) / 2^SF
+ * ns = cycles * cyc2ns_scale >> SF
+ */
+#define CYC2NS_SF	10  /* 2^10, carefully chosen */
+#define CYC2NS_SCALE	((1000000 << CYC2NS_SF) / (arc_get_core_freq() / 1000))
+
+static unsigned long long cycles2ns(unsigned long long cyc)
+{
+	return (cyc * CYC2NS_SCALE ) >> CYC2NS_SF;
+}
+
+/*
+ * Scheduler clock - a monotonically increasing clock in nanosec units.
+ * It's return value must NOT wrap around.
+ *
+ * - Since 32bit TIMER1 will overflow almost immediately (53sec @ 80MHz), it
+ *   can't be used directly.
+ * - Using getrawmonotonic (TIMER1 based, but with state for last + current
+ *   snapshots), is no-good either because of seqlock deadlock possibilities
+ * - So only with native 64bit timer we do this, otherwise fallback to generic
+ *   jiffies based version - which despite not being fine grained gaurantees
+ *   the monotonically increasing semantics.
+ */
+unsigned long long sched_clock(void)
+{
+	return cycles2ns(arc_counter_read(NULL));
+}
+#endif
-- 
1.7.4.1

