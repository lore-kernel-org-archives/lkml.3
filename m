Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991AbbA2NIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 08:08:37 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:40051 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbbA2NId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 08:08:33 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Barry.Song@csr.com, baruch@tkos.co.il, linux@rempel-privat.de,
        rob.herring@linaro.org, thierry.reding@gmail.com
Subject: [PATCH 2/9] clocksource: marco: Rename marco to atlas7
Date: Thu, 29 Jan 2015 14:08:12 +0100
Message-Id: <1422536899-16609-2-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422536899-16609-1-git-send-email-daniel.lezcano@linaro.org>
References: <54CA3044.6070501@linaro.org>
 <1422536899-16609-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Barry Song <Baohua.Song@csr.com>

marco project is replaced by atlas7 and we should obliterate
its all traces.

Signed-off-by: Barry Song <Baohua.Song@csr.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 MAINTAINERS                        |   2 +-
 drivers/clocksource/Makefile       |   2 +-
 drivers/clocksource/timer-atlas7.c | 306 +++++++++++++++++++++++++++++++++++++
 drivers/clocksource/timer-marco.c  | 306 -------------------------------------
 4 files changed, 308 insertions(+), 308 deletions(-)
 create mode 100644 drivers/clocksource/timer-atlas7.c
 delete mode 100644 drivers/clocksource/timer-marco.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 2fa3853..f6923cf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -958,7 +958,7 @@ S:	Maintained
 F:	arch/arm/mach-prima2/
 F:	drivers/clk/sirf/
 F:	drivers/clocksource/timer-prima2.c
-F:	drivers/clocksource/timer-marco.c
+F:	drivers/clocksource/timer-atlas7.c
 N:	[^a-z]sirf
 
 ARM/EBSA110 MACHINE SUPPORT
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 94d90b2..306bc47 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -18,7 +18,7 @@ obj-$(CONFIG_ARMADA_370_XP_TIMER)	+= time-armada-370-xp.o
 obj-$(CONFIG_ORION_TIMER)	+= time-orion.o
 obj-$(CONFIG_ARCH_BCM2835)	+= bcm2835_timer.o
 obj-$(CONFIG_ARCH_CLPS711X)	+= clps711x-timer.o
-obj-$(CONFIG_ARCH_MARCO)	+= timer-marco.o
+obj-$(CONFIG_ARCH_ATLAS7)	+= timer-atlas7.o
 obj-$(CONFIG_ARCH_MOXART)	+= moxart_timer.o
 obj-$(CONFIG_ARCH_MXS)		+= mxs_timer.o
 obj-$(CONFIG_ARCH_PXA)		+= pxa_timer.o
diff --git a/drivers/clocksource/timer-atlas7.c b/drivers/clocksource/timer-atlas7.c
new file mode 100644
index 0000000..60f9de3
--- /dev/null
+++ b/drivers/clocksource/timer-atlas7.c
@@ -0,0 +1,306 @@
+/*
+ * System timer for CSR SiRFprimaII
+ *
+ * Copyright (c) 2011 Cambridge Silicon Radio Limited, a CSR plc group company.
+ *
+ * Licensed under GPLv2 or later.
+ */
+
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/clockchips.h>
+#include <linux/clocksource.h>
+#include <linux/cpu.h>
+#include <linux/bitops.h>
+#include <linux/irq.h>
+#include <linux/clk.h>
+#include <linux/slab.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
+#include <linux/of_address.h>
+#include <linux/sched_clock.h>
+
+#define SIRFSOC_TIMER_32COUNTER_0_CTRL			0x0000
+#define SIRFSOC_TIMER_32COUNTER_1_CTRL			0x0004
+#define SIRFSOC_TIMER_MATCH_0				0x0018
+#define SIRFSOC_TIMER_MATCH_1				0x001c
+#define SIRFSOC_TIMER_COUNTER_0				0x0048
+#define SIRFSOC_TIMER_COUNTER_1				0x004c
+#define SIRFSOC_TIMER_INTR_STATUS			0x0060
+#define SIRFSOC_TIMER_WATCHDOG_EN			0x0064
+#define SIRFSOC_TIMER_64COUNTER_CTRL			0x0068
+#define SIRFSOC_TIMER_64COUNTER_LO			0x006c
+#define SIRFSOC_TIMER_64COUNTER_HI			0x0070
+#define SIRFSOC_TIMER_64COUNTER_LOAD_LO			0x0074
+#define SIRFSOC_TIMER_64COUNTER_LOAD_HI			0x0078
+#define SIRFSOC_TIMER_64COUNTER_RLATCHED_LO		0x007c
+#define SIRFSOC_TIMER_64COUNTER_RLATCHED_HI		0x0080
+
+#define SIRFSOC_TIMER_REG_CNT 6
+
+static unsigned long atlas7_timer_rate;
+
+static const u32 sirfsoc_timer_reg_list[SIRFSOC_TIMER_REG_CNT] = {
+	SIRFSOC_TIMER_WATCHDOG_EN,
+	SIRFSOC_TIMER_32COUNTER_0_CTRL,
+	SIRFSOC_TIMER_32COUNTER_1_CTRL,
+	SIRFSOC_TIMER_64COUNTER_CTRL,
+	SIRFSOC_TIMER_64COUNTER_RLATCHED_LO,
+	SIRFSOC_TIMER_64COUNTER_RLATCHED_HI,
+};
+
+static u32 sirfsoc_timer_reg_val[SIRFSOC_TIMER_REG_CNT];
+
+static void __iomem *sirfsoc_timer_base;
+
+/* disable count and interrupt */
+static inline void sirfsoc_timer_count_disable(int idx)
+{
+	writel_relaxed(readl_relaxed(sirfsoc_timer_base + SIRFSOC_TIMER_32COUNTER_0_CTRL + 4 * idx) & ~0x7,
+		sirfsoc_timer_base + SIRFSOC_TIMER_32COUNTER_0_CTRL + 4 * idx);
+}
+
+/* enable count and interrupt */
+static inline void sirfsoc_timer_count_enable(int idx)
+{
+	writel_relaxed(readl_relaxed(sirfsoc_timer_base + SIRFSOC_TIMER_32COUNTER_0_CTRL + 4 * idx) | 0x3,
+		sirfsoc_timer_base + SIRFSOC_TIMER_32COUNTER_0_CTRL + 4 * idx);
+}
+
+/* timer interrupt handler */
+static irqreturn_t sirfsoc_timer_interrupt(int irq, void *dev_id)
+{
+	struct clock_event_device *ce = dev_id;
+	int cpu = smp_processor_id();
+
+	/* clear timer interrupt */
+	writel_relaxed(BIT(cpu), sirfsoc_timer_base + SIRFSOC_TIMER_INTR_STATUS);
+
+	if (ce->mode == CLOCK_EVT_MODE_ONESHOT)
+		sirfsoc_timer_count_disable(cpu);
+
+	ce->event_handler(ce);
+
+	return IRQ_HANDLED;
+}
+
+/* read 64-bit timer counter */
+static cycle_t sirfsoc_timer_read(struct clocksource *cs)
+{
+	u64 cycles;
+
+	writel_relaxed((readl_relaxed(sirfsoc_timer_base + SIRFSOC_TIMER_64COUNTER_CTRL) |
+			BIT(0)) & ~BIT(1), sirfsoc_timer_base + SIRFSOC_TIMER_64COUNTER_CTRL);
+
+	cycles = readl_relaxed(sirfsoc_timer_base + SIRFSOC_TIMER_64COUNTER_RLATCHED_HI);
+	cycles = (cycles << 32) | readl_relaxed(sirfsoc_timer_base + SIRFSOC_TIMER_64COUNTER_RLATCHED_LO);
+
+	return cycles;
+}
+
+static int sirfsoc_timer_set_next_event(unsigned long delta,
+	struct clock_event_device *ce)
+{
+	int cpu = smp_processor_id();
+
+	/* disable timer first, then modify the related registers */
+	sirfsoc_timer_count_disable(cpu);
+
+	writel_relaxed(0, sirfsoc_timer_base + SIRFSOC_TIMER_COUNTER_0 +
+		4 * cpu);
+	writel_relaxed(delta, sirfsoc_timer_base + SIRFSOC_TIMER_MATCH_0 +
+		4 * cpu);
+
+	/* enable the tick */
+	sirfsoc_timer_count_enable(cpu);
+
+	return 0;
+}
+
+static void sirfsoc_timer_set_mode(enum clock_event_mode mode,
+	struct clock_event_device *ce)
+{
+	switch (mode) {
+	case CLOCK_EVT_MODE_ONESHOT:
+		/* enable in set_next_event */
+		break;
+	default:
+		break;
+	}
+
+	sirfsoc_timer_count_disable(smp_processor_id());
+}
+
+static void sirfsoc_clocksource_suspend(struct clocksource *cs)
+{
+	int i;
+
+	for (i = 0; i < SIRFSOC_TIMER_REG_CNT; i++)
+		sirfsoc_timer_reg_val[i] = readl_relaxed(sirfsoc_timer_base + sirfsoc_timer_reg_list[i]);
+}
+
+static void sirfsoc_clocksource_resume(struct clocksource *cs)
+{
+	int i;
+
+	for (i = 0; i < SIRFSOC_TIMER_REG_CNT - 2; i++)
+		writel_relaxed(sirfsoc_timer_reg_val[i], sirfsoc_timer_base + sirfsoc_timer_reg_list[i]);
+
+	writel_relaxed(sirfsoc_timer_reg_val[SIRFSOC_TIMER_REG_CNT - 2],
+		sirfsoc_timer_base + SIRFSOC_TIMER_64COUNTER_LOAD_LO);
+	writel_relaxed(sirfsoc_timer_reg_val[SIRFSOC_TIMER_REG_CNT - 1],
+		sirfsoc_timer_base + SIRFSOC_TIMER_64COUNTER_LOAD_HI);
+
+	writel_relaxed(readl_relaxed(sirfsoc_timer_base + SIRFSOC_TIMER_64COUNTER_CTRL) |
+		BIT(1) | BIT(0), sirfsoc_timer_base + SIRFSOC_TIMER_64COUNTER_CTRL);
+}
+
+static struct clock_event_device __percpu *sirfsoc_clockevent;
+
+static struct clocksource sirfsoc_clocksource = {
+	.name = "sirfsoc_clocksource",
+	.rating = 200,
+	.mask = CLOCKSOURCE_MASK(64),
+	.flags = CLOCK_SOURCE_IS_CONTINUOUS,
+	.read = sirfsoc_timer_read,
+	.suspend = sirfsoc_clocksource_suspend,
+	.resume = sirfsoc_clocksource_resume,
+};
+
+static struct irqaction sirfsoc_timer_irq = {
+	.name = "sirfsoc_timer0",
+	.flags = IRQF_TIMER | IRQF_NOBALANCING,
+	.handler = sirfsoc_timer_interrupt,
+};
+
+static struct irqaction sirfsoc_timer1_irq = {
+	.name = "sirfsoc_timer1",
+	.flags = IRQF_TIMER | IRQF_NOBALANCING,
+	.handler = sirfsoc_timer_interrupt,
+};
+
+static int sirfsoc_local_timer_setup(struct clock_event_device *ce)
+{
+	int cpu = smp_processor_id();
+	struct irqaction *action;
+
+	if (cpu == 0)
+		action = &sirfsoc_timer_irq;
+	else
+		action = &sirfsoc_timer1_irq;
+
+	ce->irq = action->irq;
+	ce->name = "local_timer";
+	ce->features = CLOCK_EVT_FEAT_ONESHOT;
+	ce->rating = 200;
+	ce->set_mode = sirfsoc_timer_set_mode;
+	ce->set_next_event = sirfsoc_timer_set_next_event;
+	clockevents_calc_mult_shift(ce, atlas7_timer_rate, 60);
+	ce->max_delta_ns = clockevent_delta2ns(-2, ce);
+	ce->min_delta_ns = clockevent_delta2ns(2, ce);
+	ce->cpumask = cpumask_of(cpu);
+
+	action->dev_id = ce;
+	BUG_ON(setup_irq(ce->irq, action));
+	irq_force_affinity(action->irq, cpumask_of(cpu));
+
+	clockevents_register_device(ce);
+	return 0;
+}
+
+static void sirfsoc_local_timer_stop(struct clock_event_device *ce)
+{
+	int cpu = smp_processor_id();
+
+	sirfsoc_timer_count_disable(1);
+
+	if (cpu == 0)
+		remove_irq(sirfsoc_timer_irq.irq, &sirfsoc_timer_irq);
+	else
+		remove_irq(sirfsoc_timer1_irq.irq, &sirfsoc_timer1_irq);
+}
+
+static int sirfsoc_cpu_notify(struct notifier_block *self,
+			      unsigned long action, void *hcpu)
+{
+	/*
+	 * Grab cpu pointer in each case to avoid spurious
+	 * preemptible warnings
+	 */
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_STARTING:
+		sirfsoc_local_timer_setup(this_cpu_ptr(sirfsoc_clockevent));
+		break;
+	case CPU_DYING:
+		sirfsoc_local_timer_stop(this_cpu_ptr(sirfsoc_clockevent));
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block sirfsoc_cpu_nb = {
+	.notifier_call = sirfsoc_cpu_notify,
+};
+
+static void __init sirfsoc_clockevent_init(void)
+{
+	sirfsoc_clockevent = alloc_percpu(struct clock_event_device);
+	BUG_ON(!sirfsoc_clockevent);
+
+	BUG_ON(register_cpu_notifier(&sirfsoc_cpu_nb));
+
+	/* Immediately configure the timer on the boot CPU */
+	sirfsoc_local_timer_setup(this_cpu_ptr(sirfsoc_clockevent));
+}
+
+/* initialize the kernel jiffy timer source */
+static void __init sirfsoc_atlas7_timer_init(struct device_node *np)
+{
+	struct clk *clk;
+
+	clk = of_clk_get(np, 0);
+	BUG_ON(IS_ERR(clk));
+
+	BUG_ON(clk_prepare_enable(clk));
+
+	atlas7_timer_rate = clk_get_rate(clk);
+
+	/* timer dividers: 0, not divided */
+	writel_relaxed(0, sirfsoc_timer_base + SIRFSOC_TIMER_64COUNTER_CTRL);
+	writel_relaxed(0, sirfsoc_timer_base + SIRFSOC_TIMER_32COUNTER_0_CTRL);
+	writel_relaxed(0, sirfsoc_timer_base + SIRFSOC_TIMER_32COUNTER_1_CTRL);
+
+	/* Initialize timer counters to 0 */
+	writel_relaxed(0, sirfsoc_timer_base + SIRFSOC_TIMER_64COUNTER_LOAD_LO);
+	writel_relaxed(0, sirfsoc_timer_base + SIRFSOC_TIMER_64COUNTER_LOAD_HI);
+	writel_relaxed(readl_relaxed(sirfsoc_timer_base + SIRFSOC_TIMER_64COUNTER_CTRL) |
+		BIT(1) | BIT(0), sirfsoc_timer_base + SIRFSOC_TIMER_64COUNTER_CTRL);
+	writel_relaxed(0, sirfsoc_timer_base + SIRFSOC_TIMER_COUNTER_0);
+	writel_relaxed(0, sirfsoc_timer_base + SIRFSOC_TIMER_COUNTER_1);
+
+	/* Clear all interrupts */
+	writel_relaxed(0xFFFF, sirfsoc_timer_base + SIRFSOC_TIMER_INTR_STATUS);
+
+	BUG_ON(clocksource_register_hz(&sirfsoc_clocksource, atlas7_timer_rate));
+
+	sirfsoc_clockevent_init();
+}
+
+static void __init sirfsoc_of_timer_init(struct device_node *np)
+{
+	sirfsoc_timer_base = of_iomap(np, 0);
+	if (!sirfsoc_timer_base)
+		panic("unable to map timer cpu registers\n");
+
+	sirfsoc_timer_irq.irq = irq_of_parse_and_map(np, 0);
+	if (!sirfsoc_timer_irq.irq)
+		panic("No irq passed for timer0 via DT\n");
+
+	sirfsoc_timer1_irq.irq = irq_of_parse_and_map(np, 1);
+	if (!sirfsoc_timer1_irq.irq)
+		panic("No irq passed for timer1 via DT\n");
+
+	sirfsoc_atlas7_timer_init(np);
+}
+CLOCKSOURCE_OF_DECLARE(sirfsoc_atlas7_timer, "sirf,atlas7-tick", sirfsoc_of_timer_init);
diff --git a/drivers/clocksource/timer-marco.c b/drivers/clocksource/timer-marco.c
deleted file mode 100644
index 3ddb81f..0000000
--- a/drivers/clocksource/timer-marco.c
+++ /dev/null
@@ -1,306 +0,0 @@
-/*
- * System timer for CSR SiRFprimaII
- *
- * Copyright (c) 2011 Cambridge Silicon Radio Limited, a CSR plc group company.
- *
- * Licensed under GPLv2 or later.
- */
-
-#include <linux/kernel.h>
-#include <linux/interrupt.h>
-#include <linux/clockchips.h>
-#include <linux/clocksource.h>
-#include <linux/cpu.h>
-#include <linux/bitops.h>
-#include <linux/irq.h>
-#include <linux/clk.h>
-#include <linux/slab.h>
-#include <linux/of.h>
-#include <linux/of_irq.h>
-#include <linux/of_address.h>
-#include <linux/sched_clock.h>
-
-#define SIRFSOC_TIMER_32COUNTER_0_CTRL			0x0000
-#define SIRFSOC_TIMER_32COUNTER_1_CTRL			0x0004
-#define SIRFSOC_TIMER_MATCH_0				0x0018
-#define SIRFSOC_TIMER_MATCH_1				0x001c
-#define SIRFSOC_TIMER_COUNTER_0				0x0048
-#define SIRFSOC_TIMER_COUNTER_1				0x004c
-#define SIRFSOC_TIMER_INTR_STATUS			0x0060
-#define SIRFSOC_TIMER_WATCHDOG_EN			0x0064
-#define SIRFSOC_TIMER_64COUNTER_CTRL			0x0068
-#define SIRFSOC_TIMER_64COUNTER_LO			0x006c
-#define SIRFSOC_TIMER_64COUNTER_HI			0x0070
-#define SIRFSOC_TIMER_64COUNTER_LOAD_LO			0x0074
-#define SIRFSOC_TIMER_64COUNTER_LOAD_HI			0x0078
-#define SIRFSOC_TIMER_64COUNTER_RLATCHED_LO		0x007c
-#define SIRFSOC_TIMER_64COUNTER_RLATCHED_HI		0x0080
-
-#define SIRFSOC_TIMER_REG_CNT 6
-
-static unsigned long marco_timer_rate;
-
-static const u32 sirfsoc_timer_reg_list[SIRFSOC_TIMER_REG_CNT] = {
-	SIRFSOC_TIMER_WATCHDOG_EN,
-	SIRFSOC_TIMER_32COUNTER_0_CTRL,
-	SIRFSOC_TIMER_32COUNTER_1_CTRL,
-	SIRFSOC_TIMER_64COUNTER_CTRL,
-	SIRFSOC_TIMER_64COUNTER_RLATCHED_LO,
-	SIRFSOC_TIMER_64COUNTER_RLATCHED_HI,
-};
-
-static u32 sirfsoc_timer_reg_val[SIRFSOC_TIMER_REG_CNT];
-
-static void __iomem *sirfsoc_timer_base;
-
-/* disable count and interrupt */
-static inline void sirfsoc_timer_count_disable(int idx)
-{
-	writel_relaxed(readl_relaxed(sirfsoc_timer_base + SIRFSOC_TIMER_32COUNTER_0_CTRL + 4 * idx) & ~0x7,
-		sirfsoc_timer_base + SIRFSOC_TIMER_32COUNTER_0_CTRL + 4 * idx);
-}
-
-/* enable count and interrupt */
-static inline void sirfsoc_timer_count_enable(int idx)
-{
-	writel_relaxed(readl_relaxed(sirfsoc_timer_base + SIRFSOC_TIMER_32COUNTER_0_CTRL + 4 * idx) | 0x3,
-		sirfsoc_timer_base + SIRFSOC_TIMER_32COUNTER_0_CTRL + 4 * idx);
-}
-
-/* timer interrupt handler */
-static irqreturn_t sirfsoc_timer_interrupt(int irq, void *dev_id)
-{
-	struct clock_event_device *ce = dev_id;
-	int cpu = smp_processor_id();
-
-	/* clear timer interrupt */
-	writel_relaxed(BIT(cpu), sirfsoc_timer_base + SIRFSOC_TIMER_INTR_STATUS);
-
-	if (ce->mode == CLOCK_EVT_MODE_ONESHOT)
-		sirfsoc_timer_count_disable(cpu);
-
-	ce->event_handler(ce);
-
-	return IRQ_HANDLED;
-}
-
-/* read 64-bit timer counter */
-static cycle_t sirfsoc_timer_read(struct clocksource *cs)
-{
-	u64 cycles;
-
-	writel_relaxed((readl_relaxed(sirfsoc_timer_base + SIRFSOC_TIMER_64COUNTER_CTRL) |
-			BIT(0)) & ~BIT(1), sirfsoc_timer_base + SIRFSOC_TIMER_64COUNTER_CTRL);
-
-	cycles = readl_relaxed(sirfsoc_timer_base + SIRFSOC_TIMER_64COUNTER_RLATCHED_HI);
-	cycles = (cycles << 32) | readl_relaxed(sirfsoc_timer_base + SIRFSOC_TIMER_64COUNTER_RLATCHED_LO);
-
-	return cycles;
-}
-
-static int sirfsoc_timer_set_next_event(unsigned long delta,
-	struct clock_event_device *ce)
-{
-	int cpu = smp_processor_id();
-
-	/* disable timer first, then modify the related registers */
-	sirfsoc_timer_count_disable(cpu);
-
-	writel_relaxed(0, sirfsoc_timer_base + SIRFSOC_TIMER_COUNTER_0 +
-		4 * cpu);
-	writel_relaxed(delta, sirfsoc_timer_base + SIRFSOC_TIMER_MATCH_0 +
-		4 * cpu);
-
-	/* enable the tick */
-	sirfsoc_timer_count_enable(cpu);
-
-	return 0;
-}
-
-static void sirfsoc_timer_set_mode(enum clock_event_mode mode,
-	struct clock_event_device *ce)
-{
-	switch (mode) {
-	case CLOCK_EVT_MODE_ONESHOT:
-		/* enable in set_next_event */
-		break;
-	default:
-		break;
-	}
-
-	sirfsoc_timer_count_disable(smp_processor_id());
-}
-
-static void sirfsoc_clocksource_suspend(struct clocksource *cs)
-{
-	int i;
-
-	for (i = 0; i < SIRFSOC_TIMER_REG_CNT; i++)
-		sirfsoc_timer_reg_val[i] = readl_relaxed(sirfsoc_timer_base + sirfsoc_timer_reg_list[i]);
-}
-
-static void sirfsoc_clocksource_resume(struct clocksource *cs)
-{
-	int i;
-
-	for (i = 0; i < SIRFSOC_TIMER_REG_CNT - 2; i++)
-		writel_relaxed(sirfsoc_timer_reg_val[i], sirfsoc_timer_base + sirfsoc_timer_reg_list[i]);
-
-	writel_relaxed(sirfsoc_timer_reg_val[SIRFSOC_TIMER_REG_CNT - 2],
-		sirfsoc_timer_base + SIRFSOC_TIMER_64COUNTER_LOAD_LO);
-	writel_relaxed(sirfsoc_timer_reg_val[SIRFSOC_TIMER_REG_CNT - 1],
-		sirfsoc_timer_base + SIRFSOC_TIMER_64COUNTER_LOAD_HI);
-
-	writel_relaxed(readl_relaxed(sirfsoc_timer_base + SIRFSOC_TIMER_64COUNTER_CTRL) |
-		BIT(1) | BIT(0), sirfsoc_timer_base + SIRFSOC_TIMER_64COUNTER_CTRL);
-}
-
-static struct clock_event_device __percpu *sirfsoc_clockevent;
-
-static struct clocksource sirfsoc_clocksource = {
-	.name = "sirfsoc_clocksource",
-	.rating = 200,
-	.mask = CLOCKSOURCE_MASK(64),
-	.flags = CLOCK_SOURCE_IS_CONTINUOUS,
-	.read = sirfsoc_timer_read,
-	.suspend = sirfsoc_clocksource_suspend,
-	.resume = sirfsoc_clocksource_resume,
-};
-
-static struct irqaction sirfsoc_timer_irq = {
-	.name = "sirfsoc_timer0",
-	.flags = IRQF_TIMER | IRQF_NOBALANCING,
-	.handler = sirfsoc_timer_interrupt,
-};
-
-static struct irqaction sirfsoc_timer1_irq = {
-	.name = "sirfsoc_timer1",
-	.flags = IRQF_TIMER | IRQF_NOBALANCING,
-	.handler = sirfsoc_timer_interrupt,
-};
-
-static int sirfsoc_local_timer_setup(struct clock_event_device *ce)
-{
-	int cpu = smp_processor_id();
-	struct irqaction *action;
-
-	if (cpu == 0)
-		action = &sirfsoc_timer_irq;
-	else
-		action = &sirfsoc_timer1_irq;
-
-	ce->irq = action->irq;
-	ce->name = "local_timer";
-	ce->features = CLOCK_EVT_FEAT_ONESHOT;
-	ce->rating = 200;
-	ce->set_mode = sirfsoc_timer_set_mode;
-	ce->set_next_event = sirfsoc_timer_set_next_event;
-	clockevents_calc_mult_shift(ce, marco_timer_rate, 60);
-	ce->max_delta_ns = clockevent_delta2ns(-2, ce);
-	ce->min_delta_ns = clockevent_delta2ns(2, ce);
-	ce->cpumask = cpumask_of(cpu);
-
-	action->dev_id = ce;
-	BUG_ON(setup_irq(ce->irq, action));
-	irq_force_affinity(action->irq, cpumask_of(cpu));
-
-	clockevents_register_device(ce);
-	return 0;
-}
-
-static void sirfsoc_local_timer_stop(struct clock_event_device *ce)
-{
-	int cpu = smp_processor_id();
-
-	sirfsoc_timer_count_disable(1);
-
-	if (cpu == 0)
-		remove_irq(sirfsoc_timer_irq.irq, &sirfsoc_timer_irq);
-	else
-		remove_irq(sirfsoc_timer1_irq.irq, &sirfsoc_timer1_irq);
-}
-
-static int sirfsoc_cpu_notify(struct notifier_block *self,
-			      unsigned long action, void *hcpu)
-{
-	/*
-	 * Grab cpu pointer in each case to avoid spurious
-	 * preemptible warnings
-	 */
-	switch (action & ~CPU_TASKS_FROZEN) {
-	case CPU_STARTING:
-		sirfsoc_local_timer_setup(this_cpu_ptr(sirfsoc_clockevent));
-		break;
-	case CPU_DYING:
-		sirfsoc_local_timer_stop(this_cpu_ptr(sirfsoc_clockevent));
-		break;
-	}
-
-	return NOTIFY_OK;
-}
-
-static struct notifier_block sirfsoc_cpu_nb = {
-	.notifier_call = sirfsoc_cpu_notify,
-};
-
-static void __init sirfsoc_clockevent_init(void)
-{
-	sirfsoc_clockevent = alloc_percpu(struct clock_event_device);
-	BUG_ON(!sirfsoc_clockevent);
-
-	BUG_ON(register_cpu_notifier(&sirfsoc_cpu_nb));
-
-	/* Immediately configure the timer on the boot CPU */
-	sirfsoc_local_timer_setup(this_cpu_ptr(sirfsoc_clockevent));
-}
-
-/* initialize the kernel jiffy timer source */
-static void __init sirfsoc_marco_timer_init(struct device_node *np)
-{
-	struct clk *clk;
-
-	clk = of_clk_get(np, 0);
-	BUG_ON(IS_ERR(clk));
-
-	BUG_ON(clk_prepare_enable(clk));
-
-	marco_timer_rate = clk_get_rate(clk);
-
-	/* timer dividers: 0, not divided */
-	writel_relaxed(0, sirfsoc_timer_base + SIRFSOC_TIMER_64COUNTER_CTRL);
-	writel_relaxed(0, sirfsoc_timer_base + SIRFSOC_TIMER_32COUNTER_0_CTRL);
-	writel_relaxed(0, sirfsoc_timer_base + SIRFSOC_TIMER_32COUNTER_1_CTRL);
-
-	/* Initialize timer counters to 0 */
-	writel_relaxed(0, sirfsoc_timer_base + SIRFSOC_TIMER_64COUNTER_LOAD_LO);
-	writel_relaxed(0, sirfsoc_timer_base + SIRFSOC_TIMER_64COUNTER_LOAD_HI);
-	writel_relaxed(readl_relaxed(sirfsoc_timer_base + SIRFSOC_TIMER_64COUNTER_CTRL) |
-		BIT(1) | BIT(0), sirfsoc_timer_base + SIRFSOC_TIMER_64COUNTER_CTRL);
-	writel_relaxed(0, sirfsoc_timer_base + SIRFSOC_TIMER_COUNTER_0);
-	writel_relaxed(0, sirfsoc_timer_base + SIRFSOC_TIMER_COUNTER_1);
-
-	/* Clear all interrupts */
-	writel_relaxed(0xFFFF, sirfsoc_timer_base + SIRFSOC_TIMER_INTR_STATUS);
-
-	BUG_ON(clocksource_register_hz(&sirfsoc_clocksource, marco_timer_rate));
-
-	sirfsoc_clockevent_init();
-}
-
-static void __init sirfsoc_of_timer_init(struct device_node *np)
-{
-	sirfsoc_timer_base = of_iomap(np, 0);
-	if (!sirfsoc_timer_base)
-		panic("unable to map timer cpu registers\n");
-
-	sirfsoc_timer_irq.irq = irq_of_parse_and_map(np, 0);
-	if (!sirfsoc_timer_irq.irq)
-		panic("No irq passed for timer0 via DT\n");
-
-	sirfsoc_timer1_irq.irq = irq_of_parse_and_map(np, 1);
-	if (!sirfsoc_timer1_irq.irq)
-		panic("No irq passed for timer1 via DT\n");
-
-	sirfsoc_marco_timer_init(np);
-}
-CLOCKSOURCE_OF_DECLARE(sirfsoc_marco_timer, "sirf,marco-tick", sirfsoc_of_timer_init );
-- 
1.9.1

