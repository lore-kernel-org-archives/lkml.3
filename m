Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab3A2OQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 09:16:54 -0500
Received: from multi.imgtec.com ([194.200.65.239]:43238 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756258Ab3A2OPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 09:15:45 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>,
        "John Stultz" <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v4 21/43] metag: Time keeping
Date: Tue, 29 Jan 2013 14:15:12 +0000
Message-ID: <1359468915-8760-3-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1359468915-8760-1-git-send-email-james.hogan@imgtec.com>
References: <1359468915-8760-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_01_29_14_15_39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add time keeping code for metag. Meta hardware threads have 2 timers.
The background timer (TXTIMER) is used as a free-running time base, and
the interrupt timer (TXTIMERI) is used for the timer interrupt. Both
counters traditionally count at approximately 1MHz.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
v4:
  * move to drivers/clocksource/metag_generic.c (Arnd)
  * use cpu notifier to setup secondary cpu timers

 MAINTAINERS                         |    1 +
 arch/metag/include/asm/clock.h      |   51 +++++++++
 arch/metag/include/asm/delay.h      |   29 +++++
 arch/metag/include/asm/mach/arch.h  |    4 +
 arch/metag/kernel/clock.c           |   53 +++++++++
 arch/metag/kernel/time.c            |   15 +++
 drivers/clocksource/Kconfig         |    5 +
 drivers/clocksource/Makefile        |    1 +
 drivers/clocksource/metag_generic.c |  198 +++++++++++++++++++++++++++++++++++
 include/clocksource/metag_generic.h |   21 ++++
 10 files changed, 378 insertions(+), 0 deletions(-)
 create mode 100644 arch/metag/include/asm/clock.h
 create mode 100644 arch/metag/include/asm/delay.h
 create mode 100644 arch/metag/kernel/clock.c
 create mode 100644 arch/metag/kernel/time.c
 create mode 100644 drivers/clocksource/metag_generic.c
 create mode 100644 include/clocksource/metag_generic.h

diff --git a/MAINTAINERS b/MAINTAINERS
index fc1c3fe..e99e580 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5040,6 +5040,7 @@ S:	Supported
 F:	arch/metag/
 F:	Documentation/metag/
 F:	Documentation/devicetree/bindings/metag/
+F:	drivers/clocksource/metag_generic.c
 
 MICROBLAZE ARCHITECTURE
 M:	Michal Simek <monstr@monstr.eu>
diff --git a/arch/metag/include/asm/clock.h b/arch/metag/include/asm/clock.h
new file mode 100644
index 0000000..3e2915a
--- /dev/null
+++ b/arch/metag/include/asm/clock.h
@@ -0,0 +1,51 @@
+/*
+ * arch/metag/include/asm/clock.h
+ *
+ * Copyright (C) 2012 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _METAG_CLOCK_H_
+#define _METAG_CLOCK_H_
+
+#include <asm/mach/arch.h>
+
+/**
+ * struct meta_clock_desc - Meta Core clock callbacks.
+ * @get_core_freq:	Get the frequency of the Meta core. If this is NULL, the
+ *			core frequency will be determined like this:
+ *			Meta 1: based on loops_per_jiffy.
+ *			Meta 2: (EXPAND_TIMER_DIV + 1) MHz.
+ */
+struct meta_clock_desc {
+	unsigned long		(*get_core_freq)(void);
+};
+
+extern struct meta_clock_desc _meta_clock;
+
+/*
+ * Set up the default clock, ensuring all callbacks are valid - only accessible
+ * during boot.
+ */
+void setup_meta_clocks(struct meta_clock_desc *desc);
+
+/**
+ * get_coreclock() - Get the frequency of the Meta core clock.
+ *
+ * Returns:	The Meta core clock frequency in Hz.
+ */
+static inline unsigned long get_coreclock(void)
+{
+	/*
+	 * Use the current clock callback. If set correctly this will provide
+	 * the most accurate frequency as it can be calculated directly from the
+	 * PLL configuration. otherwise a default callback will have been set
+	 * instead.
+	 */
+	return _meta_clock.get_core_freq();
+}
+
+#endif /* _METAG_CLOCK_H_ */
diff --git a/arch/metag/include/asm/delay.h b/arch/metag/include/asm/delay.h
new file mode 100644
index 0000000..9c92f99
--- /dev/null
+++ b/arch/metag/include/asm/delay.h
@@ -0,0 +1,29 @@
+#ifndef _METAG_DELAY_H
+#define _METAG_DELAY_H
+
+/*
+ * Copyright (C) 1993 Linus Torvalds
+ *
+ * Delay routines calling functions in arch/metag/lib/delay.c
+ */
+
+/* Undefined functions to get compile-time errors */
+extern void __bad_udelay(void);
+extern void __bad_ndelay(void);
+
+extern void __udelay(unsigned long usecs);
+extern void __ndelay(unsigned long nsecs);
+extern void __const_udelay(unsigned long xloops);
+extern void __delay(unsigned long loops);
+
+/* 0x10c7 is 2**32 / 1000000 (rounded up) */
+#define udelay(n) (__builtin_constant_p(n) ? \
+	((n) > 20000 ? __bad_udelay() : __const_udelay((n) * 0x10c7ul)) : \
+	__udelay(n))
+
+/* 0x5 is 2**32 / 1000000000 (rounded up) */
+#define ndelay(n) (__builtin_constant_p(n) ? \
+	((n) > 20000 ? __bad_ndelay() : __const_udelay((n) * 5ul)) : \
+	__ndelay(n))
+
+#endif /* _METAG_DELAY_H */
diff --git a/arch/metag/include/asm/mach/arch.h b/arch/metag/include/asm/mach/arch.h
index 6845d80..12c5664 100644
--- a/arch/metag/include/asm/mach/arch.h
+++ b/arch/metag/include/asm/mach/arch.h
@@ -16,10 +16,13 @@
 
 #include <linux/stddef.h>
 
+#include <asm/clock.h>
+
 /**
  * struct machine_desc - Describes a board controlled by a Meta.
  * @name:		Board/SoC name.
  * @dt_compat:		Array of device tree 'compatible' strings.
+ * @clocks:		Clock callbacks.
  *
  * @nr_irqs:		Maximum number of IRQs.
  *			If 0, defaults to NR_IRQS in asm-generic/irq.h.
@@ -37,6 +40,7 @@
 struct machine_desc {
 	const char		*name;
 	const char		**dt_compat;
+	struct meta_clock_desc	*clocks;
 
 	unsigned int		nr_irqs;
 
diff --git a/arch/metag/kernel/clock.c b/arch/metag/kernel/clock.c
new file mode 100644
index 0000000..defc840
--- /dev/null
+++ b/arch/metag/kernel/clock.c
@@ -0,0 +1,53 @@
+/*
+ * arch/metag/kernel/clock.c
+ *
+ * Copyright (C) 2012 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/delay.h>
+#include <linux/io.h>
+
+#include <asm/param.h>
+#include <asm/clock.h>
+
+struct meta_clock_desc _meta_clock;
+
+/* Default machine get_core_freq callback. */
+static unsigned long get_core_freq_default(void)
+{
+#ifdef CONFIG_METAG_META21
+	/*
+	 * Meta 2 cores divide down the core clock for the Meta timers, so we
+	 * can estimate the core clock from the divider.
+	 */
+	return (metag_in32(EXPAND_TIMER_DIV) + 1) * 1000000;
+#else
+	/*
+	 * On Meta 1 we don't know the core clock, but assuming the Meta timer
+	 * is correct it can be estimated based on loops_per_jiffy.
+	 */
+	return (loops_per_jiffy * HZ * 5) >> 1;
+#endif
+}
+
+/**
+ * setup_meta_clocks() - Set up the Meta clock.
+ * @desc:	Clock descriptor usually provided by machine description
+ *
+ * Ensures all callbacks are valid.
+ */
+void __init setup_meta_clocks(struct meta_clock_desc *desc)
+{
+	/* copy callbacks */
+	if (desc)
+		_meta_clock = *desc;
+
+	/* set fallback functions */
+	if (!_meta_clock.get_core_freq)
+		_meta_clock.get_core_freq = get_core_freq_default;
+}
+
diff --git a/arch/metag/kernel/time.c b/arch/metag/kernel/time.c
new file mode 100644
index 0000000..17dc107
--- /dev/null
+++ b/arch/metag/kernel/time.c
@@ -0,0 +1,15 @@
+/*
+ * Copyright (C) 2005-2013 Imagination Technologies Ltd.
+ *
+ * This file contains the Meta-specific time handling details.
+ *
+ */
+
+#include <linux/init.h>
+
+#include <clocksource/metag_generic.h>
+
+void __init time_init(void)
+{
+	metag_generic_timer_init();
+}
diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 7fdcbd3..75bc752 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -58,3 +58,8 @@ config CLKSRC_ARM_GENERIC
 	def_bool y if ARM64
 	help
 	  This option enables support for the ARM generic timer.
+
+config CLKSRC_METAG_GENERIC
+	def_bool y if METAG
+	help
+	  This option enables support for the Meta per-thread timers.
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index f93453d..09dcd49 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -18,3 +18,4 @@ obj-$(CONFIG_ARCH_BCM2835)	+= bcm2835_timer.o
 obj-$(CONFIG_SUNXI_TIMER)	+= sunxi_timer.o
 
 obj-$(CONFIG_CLKSRC_ARM_GENERIC)	+= arm_generic.o
+obj-$(CONFIG_CLKSRC_METAG_GENERIC)	+= metag_generic.o
diff --git a/drivers/clocksource/metag_generic.c b/drivers/clocksource/metag_generic.c
new file mode 100644
index 0000000..ade7513
--- /dev/null
+++ b/drivers/clocksource/metag_generic.c
@@ -0,0 +1,198 @@
+/*
+ * Copyright (C) 2005-2013 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ *
+ * Support for Meta per-thread timers.
+ *
+ * Meta hardware threads have 2 timers. The background timer (TXTIMER) is used
+ * as a free-running time base (hz clocksource), and the interrupt timer
+ * (TXTIMERI) is used for the timer interrupt (clock event). Both counters
+ * traditionally count at approximately 1MHz.
+ */
+
+#include <clocksource/metag_generic.h>
+#include <linux/cpu.h>
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/param.h>
+#include <linux/time.h>
+#include <linux/init.h>
+#include <linux/proc_fs.h>
+#include <linux/clocksource.h>
+#include <linux/clockchips.h>
+#include <linux/interrupt.h>
+
+#include <asm/clock.h>
+#include <asm/hwthread.h>
+#include <asm/core_reg.h>
+#include <asm/metag_mem.h>
+#include <asm/tbx.h>
+
+#define HARDWARE_FREQ		1000000	/* 1MHz */
+#define HARDWARE_DIV		1	/* divide by 1 = 1MHz clock */
+#define HARDWARE_TO_NS_SHIFT	10	/* convert ticks to ns */
+
+static unsigned int hwtimer_freq = HARDWARE_FREQ;
+static DEFINE_PER_CPU(struct clock_event_device, local_clockevent);
+static DEFINE_PER_CPU(char [11], local_clockevent_name);
+
+static int metag_timer_set_next_event(unsigned long delta,
+				      struct clock_event_device *dev)
+{
+	__core_reg_set(TXTIMERI, -delta);
+	return 0;
+}
+
+static void metag_timer_set_mode(enum clock_event_mode mode,
+				 struct clock_event_device *evt)
+{
+	switch (mode) {
+	case CLOCK_EVT_MODE_ONESHOT:
+	case CLOCK_EVT_MODE_RESUME:
+		break;
+
+	case CLOCK_EVT_MODE_SHUTDOWN:
+		/* We should disable the IRQ here */
+		break;
+
+	case CLOCK_EVT_MODE_PERIODIC:
+	case CLOCK_EVT_MODE_UNUSED:
+		WARN_ON(1);
+		break;
+	};
+}
+
+static cycle_t metag_clocksource_read(struct clocksource *cs)
+{
+	return __core_reg_get(TXTIMER);
+}
+
+static struct clocksource clocksource_metag = {
+	.name = "META",
+	.rating = 200,
+	.mask = CLOCKSOURCE_MASK(32),
+	.read = metag_clocksource_read,
+	.flags = CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+static irqreturn_t metag_timer_interrupt(int irq, void *dummy)
+{
+	struct clock_event_device *evt = &__get_cpu_var(local_clockevent);
+
+	evt->event_handler(evt);
+
+	return IRQ_HANDLED;
+}
+
+static struct irqaction metag_timer_irq = {
+	.name = "META core timer",
+	.handler = metag_timer_interrupt,
+	.flags = IRQF_TIMER | IRQF_IRQPOLL | IRQF_PERCPU,
+};
+
+unsigned long long sched_clock(void)
+{
+	unsigned long long ticks = __core_reg_get(TXTIMER);
+	return ticks << HARDWARE_TO_NS_SHIFT;
+}
+
+static void __cpuinit arch_timer_setup(unsigned int cpu)
+{
+	unsigned int txdivtime;
+	struct clock_event_device *clk = &per_cpu(local_clockevent, cpu);
+	char *name = per_cpu(local_clockevent_name, cpu);
+
+	txdivtime = __core_reg_get(TXDIVTIME);
+
+	txdivtime &= ~TXDIVTIME_DIV_BITS;
+	txdivtime |= (HARDWARE_DIV & TXDIVTIME_DIV_BITS);
+
+	__core_reg_set(TXDIVTIME, txdivtime);
+
+	sprintf(name, "META %d", cpu);
+	clk->name = name;
+	clk->features = CLOCK_EVT_FEAT_ONESHOT,
+
+	clk->rating = 200,
+	clk->shift = 12,
+	clk->irq = tbisig_map(TBID_SIGNUM_TRT),
+	clk->set_mode = metag_timer_set_mode,
+	clk->set_next_event = metag_timer_set_next_event,
+
+	clk->mult = div_sc(hwtimer_freq, NSEC_PER_SEC, clk->shift);
+	clk->max_delta_ns = clockevent_delta2ns(0x7fffffff, clk);
+	clk->min_delta_ns = clockevent_delta2ns(0xf, clk);
+	clk->cpumask = cpumask_of(cpu);
+
+	clockevents_register_device(clk);
+
+	/*
+	 * For all non-boot CPUs we need to synchronize our free
+	 * running clock (TXTIMER) with the boot CPU's clock.
+	 *
+	 * While this won't be accurate, it should be close enough.
+	 */
+	if (cpu) {
+		unsigned int thread0 = cpu_2_hwthread_id[0];
+		unsigned long val;
+
+		val = core_reg_read(TXUCT_ID, TXTIMER_REGNUM, thread0);
+		__core_reg_set(TXTIMER, val);
+	}
+}
+
+static int __cpuinit arch_timer_cpu_notify(struct notifier_block *self,
+					   unsigned long action, void *hcpu)
+{
+	int cpu = (long)hcpu;
+
+	switch (action) {
+	case CPU_STARTING:
+	case CPU_STARTING_FROZEN:
+		arch_timer_setup(cpu);
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block __cpuinitdata arch_timer_cpu_nb = {
+	.notifier_call = arch_timer_cpu_notify,
+};
+
+int __init metag_generic_timer_init(void)
+{
+	/*
+	 * On Meta 2 SoCs, the actual frequency of the timer is based on the
+	 * Meta core clock speed divided by an integer, so it is only
+	 * approximately 1MHz. Calculating the real frequency here drastically
+	 * reduces clock skew on these SoCs.
+	 */
+#ifdef CONFIG_METAG_META21
+	hwtimer_freq = get_coreclock() / (metag_in32(EXPAND_TIMER_DIV) + 1);
+#endif
+	clocksource_register_hz(&clocksource_metag, hwtimer_freq);
+
+	setup_irq(tbisig_map(TBID_SIGNUM_TRT), &metag_timer_irq);
+
+	/* Configure timer on boot CPU */
+	arch_timer_setup(smp_processor_id());
+
+	/* Hook cpu boot to configure other CPU's timers */
+	register_cpu_notifier(&arch_timer_cpu_nb);
+
+	return 0;
+}
diff --git a/include/clocksource/metag_generic.h b/include/clocksource/metag_generic.h
new file mode 100644
index 0000000..ac17e7d
--- /dev/null
+++ b/include/clocksource/metag_generic.h
@@ -0,0 +1,21 @@
+/*
+ * Copyright (C) 2013 Imaginaton Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __CLKSOURCE_METAG_GENERIC_H
+#define __CLKSOURCE_METAG_GENERIC_H
+
+extern int metag_generic_timer_init(void);
+
+#endif /* __CLKSOURCE_METAG_GENERIC_H */
-- 
1.7.7.6


