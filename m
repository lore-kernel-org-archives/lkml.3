Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842Ab3GMLNT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 07:13:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:44351 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757774Ab3GMLNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 07:13:15 -0400
Date: Sat, 13 Jul 2013 13:13:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] timer updates for 3.11
Message-ID: <alpine.DEB.2.02.1307131309161.11918@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest timers-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-urgent-for-linus

 * Watchdog fixes for full dynticks
 * Improved debug output for full dynticks
 * Remove an obsolete full dynticks check
 * Two ARM SoC clocksource drivers for sharing across SoCs
 * Tick broadcast fix for CPU hotplug

Thanks,

	tglx

------------------>
Frederic Weisbecker (4):
      watchdog: Register / unregister watchdog kthreads on sysctl control
      watchdog: Rename confusing state variable
      watchdog: Boot-disable by default on full dynticks
      nohz: Remove obsolete check for full dynticks CPUs to be RCU nocbs

Sebastian Hesselbarth (1):
      clocksource: Add Marvell Orion SoC timer

Stephen Boyd (1):
      tick: broadcast: Check broadcast mode on CPU hotplug

Steven Rostedt (1):
      nohz: Warn if the machine can not perform nohz_full

Stuart Menefy (1):
      clocksource: arm_global_timer: Add ARM global timer support


 .../devicetree/bindings/arm/global_timer.txt       |   24 ++
 .../bindings/timer/marvell,orion-timer.txt         |   17 ++
 drivers/clocksource/Kconfig                        |   18 ++
 drivers/clocksource/Makefile                       |    2 +
 drivers/clocksource/arm_global_timer.c             |  321 ++++++++++++++++++++
 drivers/clocksource/time-orion.c                   |  150 +++++++++
 include/linux/nmi.h                                |    2 +-
 kernel/sysctl.c                                    |    4 +-
 kernel/time/tick-broadcast.c                       |    5 +-
 kernel/time/tick-sched.c                           |   15 +-
 kernel/watchdog.c                                  |  113 ++++---
 11 files changed, 608 insertions(+), 63 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/global_timer.txt
 create mode 100644 Documentation/devicetree/bindings/timer/marvell,orion-timer.txt
 create mode 100644 drivers/clocksource/arm_global_timer.c
 create mode 100644 drivers/clocksource/time-orion.c

diff --git a/Documentation/devicetree/bindings/arm/global_timer.txt b/Documentation/devicetree/bindings/arm/global_timer.txt
new file mode 100644
index 0000000..1e54898
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/global_timer.txt
@@ -0,0 +1,24 @@
+
+* ARM Global Timer
+	Cortex-A9 are often associated with a per-core Global timer.
+
+** Timer node required properties:
+
+- compatible : Should be "arm,cortex-a9-global-timer"
+		Driver supports versions r2p0 and above.
+
+- interrupts : One interrupt to each core
+
+- reg : Specify the base address and the size of the GT timer
+	register window.
+
+- clocks : Should be phandle to a clock.
+
+Example:
+
+	timer@2c000600 {
+		compatible = "arm,cortex-a9-global-timer";
+		reg = <0x2c000600 0x20>;
+		interrupts = <1 13 0xf01>;
+		clocks = <&arm_periph_clk>;
+	};
diff --git a/Documentation/devicetree/bindings/timer/marvell,orion-timer.txt b/Documentation/devicetree/bindings/timer/marvell,orion-timer.txt
new file mode 100644
index 0000000..62bb826
--- /dev/null
+++ b/Documentation/devicetree/bindings/timer/marvell,orion-timer.txt
@@ -0,0 +1,17 @@
+Marvell Orion SoC timer
+
+Required properties:
+- compatible: shall be "marvell,orion-timer"
+- reg: base address of the timer register starting with TIMERS CONTROL register
+- interrupt-parent: phandle of the bridge interrupt controller
+- interrupts: should contain the interrupts for Timer0 and Timer1
+- clocks: phandle of timer reference clock (tclk)
+
+Example:
+	timer: timer {
+		compatible = "marvell,orion-timer";
+		reg = <0x20300 0x20>;
+		interrupt-parent = <&bridge_intc>;
+		interrupts = <1>, <2>;
+		clocks = <&core_clk 0>;
+	};
diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 81465c2..b7b9b04 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -27,6 +27,11 @@ config DW_APB_TIMER_OF
 config ARMADA_370_XP_TIMER
 	bool
 
+config ORION_TIMER
+	select CLKSRC_OF
+	select CLKSRC_MMIO
+	bool
+
 config SUN4I_TIMER
 	bool
 
@@ -69,6 +74,19 @@ config ARM_ARCH_TIMER
 	bool
 	select CLKSRC_OF if OF
 
+config ARM_GLOBAL_TIMER
+	bool
+	select CLKSRC_OF if OF
+	help
+	  This options enables support for the ARM global timer unit
+
+config CLKSRC_ARM_GLOBAL_TIMER_SCHED_CLOCK
+	bool
+	depends on ARM_GLOBAL_TIMER
+	default y
+	help
+	 Use ARM global timer clock source as sched_clock
+
 config CLKSRC_METAG_GENERIC
 	def_bool y if METAG
 	help
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 9ba8b4d..8b00c5c 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -15,6 +15,7 @@ obj-$(CONFIG_DW_APB_TIMER_OF)	+= dw_apb_timer_of.o
 obj-$(CONFIG_CLKSRC_NOMADIK_MTU)	+= nomadik-mtu.o
 obj-$(CONFIG_CLKSRC_DBX500_PRCMU)	+= clksrc-dbx500-prcmu.o
 obj-$(CONFIG_ARMADA_370_XP_TIMER)	+= time-armada-370-xp.o
+obj-$(CONFIG_ORION_TIMER)	+= time-orion.o
 obj-$(CONFIG_ARCH_BCM2835)	+= bcm2835_timer.o
 obj-$(CONFIG_ARCH_MARCO)	+= timer-marco.o
 obj-$(CONFIG_ARCH_MXS)		+= mxs_timer.o
@@ -30,5 +31,6 @@ obj-$(CONFIG_CLKSRC_SAMSUNG_PWM)	+= samsung_pwm_timer.o
 obj-$(CONFIG_VF_PIT_TIMER)	+= vf_pit_timer.o
 
 obj-$(CONFIG_ARM_ARCH_TIMER)		+= arm_arch_timer.o
+obj-$(CONFIG_ARM_GLOBAL_TIMER)		+= arm_global_timer.o
 obj-$(CONFIG_CLKSRC_METAG_GENERIC)	+= metag_generic.o
 obj-$(CONFIG_ARCH_HAS_TICK_BROADCAST)	+= dummy_timer.o
diff --git a/drivers/clocksource/arm_global_timer.c b/drivers/clocksource/arm_global_timer.c
new file mode 100644
index 0000000..db8afc7
--- /dev/null
+++ b/drivers/clocksource/arm_global_timer.c
@@ -0,0 +1,321 @@
+/*
+ * drivers/clocksource/arm_global_timer.c
+ *
+ * Copyright (C) 2013 STMicroelectronics (R&D) Limited.
+ * Author: Stuart Menefy <stuart.menefy@st.com>
+ * Author: Srinivas Kandagatla <srinivas.kandagatla@st.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/clocksource.h>
+#include <linux/clockchips.h>
+#include <linux/cpu.h>
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
+#include <linux/of_address.h>
+#include <linux/sched_clock.h>
+
+#include <asm/cputype.h>
+
+#define GT_COUNTER0	0x00
+#define GT_COUNTER1	0x04
+
+#define GT_CONTROL	0x08
+#define GT_CONTROL_TIMER_ENABLE		BIT(0)  /* this bit is NOT banked */
+#define GT_CONTROL_COMP_ENABLE		BIT(1)	/* banked */
+#define GT_CONTROL_IRQ_ENABLE		BIT(2)	/* banked */
+#define GT_CONTROL_AUTO_INC		BIT(3)	/* banked */
+
+#define GT_INT_STATUS	0x0c
+#define GT_INT_STATUS_EVENT_FLAG	BIT(0)
+
+#define GT_COMP0	0x10
+#define GT_COMP1	0x14
+#define GT_AUTO_INC	0x18
+
+/*
+ * We are expecting to be clocked by the ARM peripheral clock.
+ *
+ * Note: it is assumed we are using a prescaler value of zero, so this is
+ * the units for all operations.
+ */
+static void __iomem *gt_base;
+static unsigned long gt_clk_rate;
+static int gt_ppi;
+static struct clock_event_device __percpu *gt_evt;
+
+/*
+ * To get the value from the Global Timer Counter register proceed as follows:
+ * 1. Read the upper 32-bit timer counter register
+ * 2. Read the lower 32-bit timer counter register
+ * 3. Read the upper 32-bit timer counter register again. If the value is
+ *  different to the 32-bit upper value read previously, go back to step 2.
+ *  Otherwise the 64-bit timer counter value is correct.
+ */
+static u64 gt_counter_read(void)
+{
+	u64 counter;
+	u32 lower;
+	u32 upper, old_upper;
+
+	upper = readl_relaxed(gt_base + GT_COUNTER1);
+	do {
+		old_upper = upper;
+		lower = readl_relaxed(gt_base + GT_COUNTER0);
+		upper = readl_relaxed(gt_base + GT_COUNTER1);
+	} while (upper != old_upper);
+
+	counter = upper;
+	counter <<= 32;
+	counter |= lower;
+	return counter;
+}
+
+/**
+ * To ensure that updates to comparator value register do not set the
+ * Interrupt Status Register proceed as follows:
+ * 1. Clear the Comp Enable bit in the Timer Control Register.
+ * 2. Write the lower 32-bit Comparator Value Register.
+ * 3. Write the upper 32-bit Comparator Value Register.
+ * 4. Set the Comp Enable bit and, if necessary, the IRQ enable bit.
+ */
+static void gt_compare_set(unsigned long delta, int periodic)
+{
+	u64 counter = gt_counter_read();
+	unsigned long ctrl;
+
+	counter += delta;
+	ctrl = GT_CONTROL_TIMER_ENABLE;
+	writel(ctrl, gt_base + GT_CONTROL);
+	writel(lower_32_bits(counter), gt_base + GT_COMP0);
+	writel(upper_32_bits(counter), gt_base + GT_COMP1);
+
+	if (periodic) {
+		writel(delta, gt_base + GT_AUTO_INC);
+		ctrl |= GT_CONTROL_AUTO_INC;
+	}
+
+	ctrl |= GT_CONTROL_COMP_ENABLE | GT_CONTROL_IRQ_ENABLE;
+	writel(ctrl, gt_base + GT_CONTROL);
+}
+
+static void gt_clockevent_set_mode(enum clock_event_mode mode,
+				   struct clock_event_device *clk)
+{
+	unsigned long ctrl;
+
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+		gt_compare_set(DIV_ROUND_CLOSEST(gt_clk_rate, HZ), 1);
+		break;
+	case CLOCK_EVT_MODE_ONESHOT:
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+		ctrl = readl(gt_base + GT_CONTROL);
+		ctrl &= ~(GT_CONTROL_COMP_ENABLE |
+				GT_CONTROL_IRQ_ENABLE | GT_CONTROL_AUTO_INC);
+		writel(ctrl, gt_base + GT_CONTROL);
+		break;
+	default:
+		break;
+	}
+}
+
+static int gt_clockevent_set_next_event(unsigned long evt,
+					struct clock_event_device *unused)
+{
+	gt_compare_set(evt, 0);
+	return 0;
+}
+
+static irqreturn_t gt_clockevent_interrupt(int irq, void *dev_id)
+{
+	struct clock_event_device *evt = dev_id;
+
+	if (!(readl_relaxed(gt_base + GT_INT_STATUS) &
+				GT_INT_STATUS_EVENT_FLAG))
+		return IRQ_NONE;
+
+	/**
+	 * ERRATA 740657( Global Timer can send 2 interrupts for
+	 * the same event in single-shot mode)
+	 * Workaround:
+	 *	Either disable single-shot mode.
+	 *	Or
+	 *	Modify the Interrupt Handler to avoid the
+	 *	offending sequence. This is achieved by clearing
+	 *	the Global Timer flag _after_ having incremented
+	 *	the Comparator register	value to a higher value.
+	 */
+	if (evt->mode == CLOCK_EVT_MODE_ONESHOT)
+		gt_compare_set(ULONG_MAX, 0);
+
+	writel_relaxed(GT_INT_STATUS_EVENT_FLAG, gt_base + GT_INT_STATUS);
+	evt->event_handler(evt);
+
+	return IRQ_HANDLED;
+}
+
+static int __cpuinit gt_clockevents_init(struct clock_event_device *clk)
+{
+	int cpu = smp_processor_id();
+
+	clk->name = "arm_global_timer";
+	clk->features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT;
+	clk->set_mode = gt_clockevent_set_mode;
+	clk->set_next_event = gt_clockevent_set_next_event;
+	clk->cpumask = cpumask_of(cpu);
+	clk->rating = 300;
+	clk->irq = gt_ppi;
+	clockevents_config_and_register(clk, gt_clk_rate,
+					1, 0xffffffff);
+	enable_percpu_irq(clk->irq, IRQ_TYPE_NONE);
+	return 0;
+}
+
+static void gt_clockevents_stop(struct clock_event_device *clk)
+{
+	gt_clockevent_set_mode(CLOCK_EVT_MODE_UNUSED, clk);
+	disable_percpu_irq(clk->irq);
+}
+
+static cycle_t gt_clocksource_read(struct clocksource *cs)
+{
+	return gt_counter_read();
+}
+
+static struct clocksource gt_clocksource = {
+	.name	= "arm_global_timer",
+	.rating	= 300,
+	.read	= gt_clocksource_read,
+	.mask	= CLOCKSOURCE_MASK(64),
+	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+#ifdef CONFIG_CLKSRC_ARM_GLOBAL_TIMER_SCHED_CLOCK
+static u32 notrace gt_sched_clock_read(void)
+{
+	return gt_counter_read();
+}
+#endif
+
+static void __init gt_clocksource_init(void)
+{
+	writel(0, gt_base + GT_CONTROL);
+	writel(0, gt_base + GT_COUNTER0);
+	writel(0, gt_base + GT_COUNTER1);
+	/* enables timer on all the cores */
+	writel(GT_CONTROL_TIMER_ENABLE, gt_base + GT_CONTROL);
+
+#ifdef CONFIG_CLKSRC_ARM_GLOBAL_TIMER_SCHED_CLOCK
+	setup_sched_clock(gt_sched_clock_read, 32, gt_clk_rate);
+#endif
+	clocksource_register_hz(&gt_clocksource, gt_clk_rate);
+}
+
+static int __cpuinit gt_cpu_notify(struct notifier_block *self,
+					   unsigned long action, void *hcpu)
+{
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_STARTING:
+		gt_clockevents_init(this_cpu_ptr(gt_evt));
+		break;
+	case CPU_DYING:
+		gt_clockevents_stop(this_cpu_ptr(gt_evt));
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+static struct notifier_block gt_cpu_nb __cpuinitdata = {
+	.notifier_call = gt_cpu_notify,
+};
+
+static void __init global_timer_of_register(struct device_node *np)
+{
+	struct clk *gt_clk;
+	int err = 0;
+
+	/*
+	 * In r2p0 the comparators for each processor with the global timer
+	 * fire when the timer value is greater than or equal to. In previous
+	 * revisions the comparators fired when the timer value was equal to.
+	 */
+	if ((read_cpuid_id() & 0xf0000f) < 0x200000) {
+		pr_warn("global-timer: non support for this cpu version.\n");
+		return;
+	}
+
+	gt_ppi = irq_of_parse_and_map(np, 0);
+	if (!gt_ppi) {
+		pr_warn("global-timer: unable to parse irq\n");
+		return;
+	}
+
+	gt_base = of_iomap(np, 0);
+	if (!gt_base) {
+		pr_warn("global-timer: invalid base address\n");
+		return;
+	}
+
+	gt_clk = of_clk_get(np, 0);
+	if (!IS_ERR(gt_clk)) {
+		err = clk_prepare_enable(gt_clk);
+		if (err)
+			goto out_unmap;
+	} else {
+		pr_warn("global-timer: clk not found\n");
+		err = -EINVAL;
+		goto out_unmap;
+	}
+
+	gt_clk_rate = clk_get_rate(gt_clk);
+	gt_evt = alloc_percpu(struct clock_event_device);
+	if (!gt_evt) {
+		pr_warn("global-timer: can't allocate memory\n");
+		err = -ENOMEM;
+		goto out_clk;
+	}
+
+	err = request_percpu_irq(gt_ppi, gt_clockevent_interrupt,
+				 "gt", gt_evt);
+	if (err) {
+		pr_warn("global-timer: can't register interrupt %d (%d)\n",
+			gt_ppi, err);
+		goto out_free;
+	}
+
+	err = register_cpu_notifier(&gt_cpu_nb);
+	if (err) {
+		pr_warn("global-timer: unable to register cpu notifier.\n");
+		goto out_irq;
+	}
+
+	/* Immediately configure the timer on the boot CPU */
+	gt_clocksource_init();
+	gt_clockevents_init(this_cpu_ptr(gt_evt));
+
+	return;
+
+out_irq:
+	free_percpu_irq(gt_ppi, gt_evt);
+out_free:
+	free_percpu(gt_evt);
+out_clk:
+	clk_disable_unprepare(gt_clk);
+out_unmap:
+	iounmap(gt_base);
+	WARN(err, "ARM Global timer register failed (%d)\n", err);
+}
+
+/* Only tested on r2p2 and r3p0  */
+CLOCKSOURCE_OF_DECLARE(arm_gt, "arm,cortex-a9-global-timer",
+			global_timer_of_register);
diff --git a/drivers/clocksource/time-orion.c b/drivers/clocksource/time-orion.c
new file mode 100644
index 0000000..ecbeb68
--- /dev/null
+++ b/drivers/clocksource/time-orion.c
@@ -0,0 +1,150 @@
+/*
+ * Marvell Orion SoC timer handling.
+ *
+ * Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ *
+ * Timer 0 is used as free-running clocksource, while timer 1 is
+ * used as clock_event_device.
+ */
+
+#include <linux/kernel.h>
+#include <linux/bitops.h>
+#include <linux/clk.h>
+#include <linux/clockchips.h>
+#include <linux/interrupt.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/spinlock.h>
+#include <asm/sched_clock.h>
+
+#define TIMER_CTRL		0x00
+#define  TIMER0_EN		BIT(0)
+#define  TIMER0_RELOAD_EN	BIT(1)
+#define  TIMER1_EN		BIT(2)
+#define  TIMER1_RELOAD_EN	BIT(3)
+#define TIMER0_RELOAD		0x10
+#define TIMER0_VAL		0x14
+#define TIMER1_RELOAD		0x18
+#define TIMER1_VAL		0x1c
+
+#define ORION_ONESHOT_MIN	1
+#define ORION_ONESHOT_MAX	0xfffffffe
+
+static void __iomem *timer_base;
+static DEFINE_SPINLOCK(timer_ctrl_lock);
+
+/*
+ * Thread-safe access to TIMER_CTRL register
+ * (shared with watchdog timer)
+ */
+void orion_timer_ctrl_clrset(u32 clr, u32 set)
+{
+	spin_lock(&timer_ctrl_lock);
+	writel((readl(timer_base + TIMER_CTRL) & ~clr) | set,
+		timer_base + TIMER_CTRL);
+	spin_unlock(&timer_ctrl_lock);
+}
+EXPORT_SYMBOL(orion_timer_ctrl_clrset);
+
+/*
+ * Free-running clocksource handling.
+ */
+static u32 notrace orion_read_sched_clock(void)
+{
+	return ~readl(timer_base + TIMER0_VAL);
+}
+
+/*
+ * Clockevent handling.
+ */
+static u32 ticks_per_jiffy;
+
+static int orion_clkevt_next_event(unsigned long delta,
+				   struct clock_event_device *dev)
+{
+	/* setup and enable one-shot timer */
+	writel(delta, timer_base + TIMER1_VAL);
+	orion_timer_ctrl_clrset(TIMER1_RELOAD_EN, TIMER1_EN);
+
+	return 0;
+}
+
+static void orion_clkevt_mode(enum clock_event_mode mode,
+			      struct clock_event_device *dev)
+{
+	if (mode == CLOCK_EVT_MODE_PERIODIC) {
+		/* setup and enable periodic timer at 1/HZ intervals */
+		writel(ticks_per_jiffy - 1, timer_base + TIMER1_RELOAD);
+		writel(ticks_per_jiffy - 1, timer_base + TIMER1_VAL);
+		orion_timer_ctrl_clrset(0, TIMER1_RELOAD_EN | TIMER1_EN);
+	} else {
+		/* disable timer */
+		orion_timer_ctrl_clrset(TIMER1_RELOAD_EN | TIMER1_EN, 0);
+	}
+}
+
+static struct clock_event_device orion_clkevt = {
+	.name		= "orion_event",
+	.features	= CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_PERIODIC,
+	.shift		= 32,
+	.rating		= 300,
+	.set_next_event	= orion_clkevt_next_event,
+	.set_mode	= orion_clkevt_mode,
+};
+
+static irqreturn_t orion_clkevt_irq_handler(int irq, void *dev_id)
+{
+	orion_clkevt.event_handler(&orion_clkevt);
+	return IRQ_HANDLED;
+}
+
+static struct irqaction orion_clkevt_irq = {
+	.name		= "orion_event",
+	.flags		= IRQF_TIMER,
+	.handler	= orion_clkevt_irq_handler,
+};
+
+static void __init orion_timer_init(struct device_node *np)
+{
+	struct clk *clk;
+	int irq;
+
+	/* timer registers are shared with watchdog timer */
+	timer_base = of_iomap(np, 0);
+	if (!timer_base)
+		panic("%s: unable to map resource\n", np->name);
+
+	clk = of_clk_get(np, 0);
+	if (IS_ERR(clk))
+		panic("%s: unable to get clk\n", np->name);
+	clk_prepare_enable(clk);
+
+	/* we are only interested in timer1 irq */
+	irq = irq_of_parse_and_map(np, 1);
+	if (irq <= 0)
+		panic("%s: unable to parse timer1 irq\n", np->name);
+
+	/* setup timer0 as free-running clocksource */
+	writel(~0, timer_base + TIMER0_VAL);
+	writel(~0, timer_base + TIMER0_RELOAD);
+	orion_timer_ctrl_clrset(0, TIMER0_RELOAD_EN | TIMER0_EN);
+	clocksource_mmio_init(timer_base + TIMER0_VAL, "orion_clocksource",
+			      clk_get_rate(clk), 300, 32,
+			      clocksource_mmio_readl_down);
+	setup_sched_clock(orion_read_sched_clock, 32, clk_get_rate(clk));
+
+	/* setup timer1 as clockevent timer */
+	if (setup_irq(irq, &orion_clkevt_irq))
+		panic("%s: unable to setup irq\n", np->name);
+
+	ticks_per_jiffy = (clk_get_rate(clk) + HZ/2) / HZ;
+	orion_clkevt.cpumask = cpumask_of(0);
+	orion_clkevt.irq = irq;
+	clockevents_config_and_register(&orion_clkevt, clk_get_rate(clk),
+					ORION_ONESHOT_MIN, ORION_ONESHOT_MAX);
+}
+CLOCKSOURCE_OF_DECLARE(orion_timer, "marvell,orion-timer", orion_timer_init);
diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index db50840..6a45fb5 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -46,7 +46,7 @@ static inline bool trigger_all_cpu_backtrace(void)
 #ifdef CONFIG_LOCKUP_DETECTOR
 int hw_nmi_is_cpu_stuck(struct pt_regs *);
 u64 hw_nmi_get_sample_period(int watchdog_thresh);
-extern int watchdog_enabled;
+extern int watchdog_user_enabled;
 extern int watchdog_thresh;
 struct ctl_table;
 extern int proc_dowatchdog(struct ctl_table *, int ,
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index e5b31af..ac09d98 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -807,7 +807,7 @@ static struct ctl_table kern_table[] = {
 #if defined(CONFIG_LOCKUP_DETECTOR)
 	{
 		.procname       = "watchdog",
-		.data           = &watchdog_enabled,
+		.data           = &watchdog_user_enabled,
 		.maxlen         = sizeof (int),
 		.mode           = 0644,
 		.proc_handler   = proc_dowatchdog,
@@ -834,7 +834,7 @@ static struct ctl_table kern_table[] = {
 	},
 	{
 		.procname       = "nmi_watchdog",
-		.data           = &watchdog_enabled,
+		.data           = &watchdog_user_enabled,
 		.maxlen         = sizeof (int),
 		.mode           = 0644,
 		.proc_handler   = proc_dowatchdog,
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 6d3f916..218bcb5 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -157,7 +157,10 @@ int tick_device_uses_broadcast(struct clock_event_device *dev, int cpu)
 		dev->event_handler = tick_handle_periodic;
 		tick_device_setup_broadcast_func(dev);
 		cpumask_set_cpu(cpu, tick_broadcast_mask);
-		tick_broadcast_start_periodic(bc);
+		if (tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC)
+			tick_broadcast_start_periodic(bc);
+		else
+			tick_broadcast_setup_oneshot(bc);
 		ret = 1;
 	} else {
 		/*
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 0cf1c14..6960172 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -178,6 +178,11 @@ static bool can_stop_full_tick(void)
 	 */
 	if (!sched_clock_stable) {
 		trace_tick_stop(0, "unstable sched clock\n");
+		/*
+		 * Don't allow the user to think they can get
+		 * full NO_HZ with this machine.
+		 */
+		WARN_ONCE(1, "NO_HZ FULL will not work with unstable sched clock");
 		return false;
 	}
 #endif
@@ -346,16 +351,6 @@ void __init tick_nohz_init(void)
 	}
 
 	cpu_notifier(tick_nohz_cpu_down_callback, 0);
-
-	/* Make sure full dynticks CPU are also RCU nocbs */
-	for_each_cpu(cpu, nohz_full_mask) {
-		if (!rcu_is_nocb_cpu(cpu)) {
-			pr_warning("NO_HZ: CPU %d is not RCU nocb: "
-				   "cleared from nohz_full range", cpu);
-			cpumask_clear_cpu(cpu, nohz_full_mask);
-		}
-	}
-
 	cpulist_scnprintf(nohz_full_buf, sizeof(nohz_full_buf), nohz_full_mask);
 	pr_info("NO_HZ: Full dynticks CPUs: %s.\n", nohz_full_buf);
 }
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 05039e3..1241d8c 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -29,9 +29,9 @@
 #include <linux/kvm_para.h>
 #include <linux/perf_event.h>
 
-int watchdog_enabled = 1;
+int watchdog_user_enabled = 1;
 int __read_mostly watchdog_thresh = 10;
-static int __read_mostly watchdog_disabled;
+static int __read_mostly watchdog_running;
 static u64 __read_mostly sample_period;
 
 static DEFINE_PER_CPU(unsigned long, watchdog_touch_ts);
@@ -63,7 +63,7 @@ static int __init hardlockup_panic_setup(char *str)
 	else if (!strncmp(str, "nopanic", 7))
 		hardlockup_panic = 0;
 	else if (!strncmp(str, "0", 1))
-		watchdog_enabled = 0;
+		watchdog_user_enabled = 0;
 	return 1;
 }
 __setup("nmi_watchdog=", hardlockup_panic_setup);
@@ -82,7 +82,7 @@ __setup("softlockup_panic=", softlockup_panic_setup);
 
 static int __init nowatchdog_setup(char *str)
 {
-	watchdog_enabled = 0;
+	watchdog_user_enabled = 0;
 	return 1;
 }
 __setup("nowatchdog", nowatchdog_setup);
@@ -90,7 +90,7 @@ __setup("nowatchdog", nowatchdog_setup);
 /* deprecated */
 static int __init nosoftlockup_setup(char *str)
 {
-	watchdog_enabled = 0;
+	watchdog_user_enabled = 0;
 	return 1;
 }
 __setup("nosoftlockup", nosoftlockup_setup);
@@ -158,7 +158,7 @@ void touch_all_softlockup_watchdogs(void)
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 void touch_nmi_watchdog(void)
 {
-	if (watchdog_enabled) {
+	if (watchdog_user_enabled) {
 		unsigned cpu;
 
 		for_each_present_cpu(cpu) {
@@ -347,11 +347,6 @@ static void watchdog_enable(unsigned int cpu)
 	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	hrtimer->function = watchdog_timer_fn;
 
-	if (!watchdog_enabled) {
-		kthread_park(current);
-		return;
-	}
-
 	/* Enable the perf event */
 	watchdog_nmi_enable(cpu);
 
@@ -374,6 +369,11 @@ static void watchdog_disable(unsigned int cpu)
 	watchdog_nmi_disable(cpu);
 }
 
+static void watchdog_cleanup(unsigned int cpu, bool online)
+{
+	watchdog_disable(cpu);
+}
+
 static int watchdog_should_run(unsigned int cpu)
 {
 	return __this_cpu_read(hrtimer_interrupts) !=
@@ -475,28 +475,40 @@ static int watchdog_nmi_enable(unsigned int cpu) { return 0; }
 static void watchdog_nmi_disable(unsigned int cpu) { return; }
 #endif /* CONFIG_HARDLOCKUP_DETECTOR */
 
-/* prepare/enable/disable routines */
-/* sysctl functions */
-#ifdef CONFIG_SYSCTL
-static void watchdog_enable_all_cpus(void)
+static struct smp_hotplug_thread watchdog_threads = {
+	.store			= &softlockup_watchdog,
+	.thread_should_run	= watchdog_should_run,
+	.thread_fn		= watchdog,
+	.thread_comm		= "watchdog/%u",
+	.setup			= watchdog_enable,
+	.cleanup		= watchdog_cleanup,
+	.park			= watchdog_disable,
+	.unpark			= watchdog_enable,
+};
+
+static int watchdog_enable_all_cpus(void)
 {
-	unsigned int cpu;
+	int err = 0;
 
-	if (watchdog_disabled) {
-		watchdog_disabled = 0;
-		for_each_online_cpu(cpu)
-			kthread_unpark(per_cpu(softlockup_watchdog, cpu));
+	if (!watchdog_running) {
+		err = smpboot_register_percpu_thread(&watchdog_threads);
+		if (err)
+			pr_err("Failed to create watchdog threads, disabled\n");
+		else
+			watchdog_running = 1;
 	}
+
+	return err;
 }
 
+/* prepare/enable/disable routines */
+/* sysctl functions */
+#ifdef CONFIG_SYSCTL
 static void watchdog_disable_all_cpus(void)
 {
-	unsigned int cpu;
-
-	if (!watchdog_disabled) {
-		watchdog_disabled = 1;
-		for_each_online_cpu(cpu)
-			kthread_park(per_cpu(softlockup_watchdog, cpu));
+	if (watchdog_running) {
+		watchdog_running = 0;
+		smpboot_unregister_percpu_thread(&watchdog_threads);
 	}
 }
 
@@ -507,45 +519,48 @@ static void watchdog_disable_all_cpus(void)
 int proc_dowatchdog(struct ctl_table *table, int write,
 		    void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-	int ret;
+	int err, old_thresh, old_enabled;
 
-	if (watchdog_disabled < 0)
-		return -ENODEV;
+	old_thresh = ACCESS_ONCE(watchdog_thresh);
+	old_enabled = ACCESS_ONCE(watchdog_user_enabled);
 
-	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
-	if (ret || !write)
-		return ret;
+	err = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+	if (err || !write)
+		return err;
 
 	set_sample_period();
 	/*
 	 * Watchdog threads shouldn't be enabled if they are
-	 * disabled. The 'watchdog_disabled' variable check in
+	 * disabled. The 'watchdog_running' variable check in
 	 * watchdog_*_all_cpus() function takes care of this.
 	 */
-	if (watchdog_enabled && watchdog_thresh)
-		watchdog_enable_all_cpus();
+	if (watchdog_user_enabled && watchdog_thresh)
+		err = watchdog_enable_all_cpus();
 	else
 		watchdog_disable_all_cpus();
 
-	return ret;
+	/* Restore old values on failure */
+	if (err) {
+		watchdog_thresh = old_thresh;
+		watchdog_user_enabled = old_enabled;
+	}
+
+	return err;
 }
 #endif /* CONFIG_SYSCTL */
 
-static struct smp_hotplug_thread watchdog_threads = {
-	.store			= &softlockup_watchdog,
-	.thread_should_run	= watchdog_should_run,
-	.thread_fn		= watchdog,
-	.thread_comm		= "watchdog/%u",
-	.setup			= watchdog_enable,
-	.park			= watchdog_disable,
-	.unpark			= watchdog_enable,
-};
-
 void __init lockup_detector_init(void)
 {
 	set_sample_period();
-	if (smpboot_register_percpu_thread(&watchdog_threads)) {
-		pr_err("Failed to create watchdog threads, disabled\n");
-		watchdog_disabled = -ENODEV;
+
+#ifdef CONFIG_NO_HZ_FULL
+	if (watchdog_user_enabled) {
+		watchdog_user_enabled = 0;
+		pr_warning("Disabled lockup detectors by default for full dynticks\n");
+		pr_warning("You can reactivate it with 'sysctl -w kernel.watchdog=1'\n");
 	}
+#endif
+
+	if (watchdog_user_enabled)
+		watchdog_enable_all_cpus();
 }
