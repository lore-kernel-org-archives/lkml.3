Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab3FAGCy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 02:02:54 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:38487 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab3FAGCp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 02:02:45 -0400
From: Daniel Tang <dt.tangr@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCHv2] Add TI-Nspire timer support
Date: Sat, 1 Jun 2013 16:02:37 +1000
Message-Id: <AE2AF524-C495-4D6B-B622-816B3254D384@gmail.com>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
X-Mailer: Apple Mail (2.1503)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a clocksource/clockevent driver for the timer found on some models in the TI-Nspire calculator series.

The timer has two 16bit subtimers within its memory mapped I/O interface but only the first can generate interrupts. 

The first subtimer is used to generate clockevents but only if an interrupt number and register is given.

The interrupt acknowledgement mechanism is a little strange because the interrupt mask and acknowledge registers are located in another memory mapped I/O peripheral. The address of this register is passed to the driver through device tree bindings.

The second subtimer is used as a clocksource because it isn't capable of generating an interrupt. This subtimer is always added.

Changes between v2 and v1:
* Added a changelog
* Moved `int irqnr` out of struct zevio_timer and into the init function
* Set timer->clkevt.irq to the IRQ number in init function
* Added spaces in the shift macros (i.e. (1<<2) => (1 << 2))
* Realigned function declarations, container_of and at timer->clkevt.
* Remove unnecessary calls to local_irq_save and local_irq_restore
* Remove redundant setting of dev->mode
* Change kzalloc call to use GFP_KERNEL
* Remove redundant line break
* Remove IRQF_DISABLED flag

Cheers,
Daniel Tang

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
---
 .../devicetree/bindings/timer/lsi,zevio-timer.txt  |  33 ++++
 drivers/clocksource/Makefile                       |   1 +
 drivers/clocksource/zevio-timer.c                  | 215 +++++++++++++++++++++
 3 files changed, 249 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/timer/lsi,zevio-timer.txt
 create mode 100644 drivers/clocksource/zevio-timer.c

diff --git a/Documentation/devicetree/bindings/timer/lsi,zevio-timer.txt b/Documentation/devicetree/bindings/timer/lsi,zevio-timer.txt
new file mode 100644
index 0000000..b2d07ad
--- /dev/null
+++ b/Documentation/devicetree/bindings/timer/lsi,zevio-timer.txt
@@ -0,0 +1,33 @@
+TI-NSPIRE timer
+
+Required properties:
+
+- compatible : should be "lsi,zevio-timer".
+- reg : The physical base address and size of the timer (always first).
+- clocks: phandle to the source clock.
+
+Optional properties:
+
+- interrupts : The interrupt number of the first timer.
+- reg : The interrupt acknowledgement registers
+	(always after timer base address)
+
+If any of the optional properties are not given, the timer is added as a
+clock-source only.
+
+Example:
+
+timer {
+	compatible = "lsi,zevio-timer";
+	reg = <0x900D0000 0x1000>, <0x900A0020 0x8>;
+	interrupts = <19>;
+	clocks = <&timer_clk>;
+};
+
+Example (no clock-events):
+
+timer {
+	compatible = "lsi,zevio-timer";
+	reg = <0x900D0000 0x1000>;
+	clocks = <&timer_clk>;
+};
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 8d979c7..293f86e 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_ARCH_PRIMA2)	+= timer-prima2.o
 obj-$(CONFIG_SUN4I_TIMER)	+= sun4i_timer.o
 obj-$(CONFIG_ARCH_TEGRA)	+= tegra20_timer.o
 obj-$(CONFIG_VT8500_TIMER)	+= vt8500_timer.o
+obj-$(CONFIG_ARCH_NSPIRE)	+= zevio-timer.o
 obj-$(CONFIG_ARCH_BCM)		+= bcm_kona_timer.o
 obj-$(CONFIG_CADENCE_TTC_TIMER)	+= cadence_ttc_timer.o
 obj-$(CONFIG_CLKSRC_EXYNOS_MCT)	+= exynos_mct.o
diff --git a/drivers/clocksource/zevio-timer.c b/drivers/clocksource/zevio-timer.c
new file mode 100644
index 0000000..ca81809
--- /dev/null
+++ b/drivers/clocksource/zevio-timer.c
@@ -0,0 +1,215 @@
+/*
+ *  linux/drivers/clocksource/zevio-timer.c
+ *
+ *  Copyright (C) 2013 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/clk.h>
+#include <linux/clockchips.h>
+#include <linux/cpumask.h>
+#include <linux/interrupt.h>
+#include <linux/slab.h>
+
+#define IO_CURRENT_VAL	0x00
+#define IO_DIVIDER	0x04
+#define IO_CONTROL	0x08
+
+#define IO_TIMER1	0x00
+#define IO_TIMER2	0x0C
+
+#define IO_MATCH_BEGIN	0x18
+#define IO_MATCH(x)	(IO_MATCH_BEGIN + ((x) << 2))
+
+#define IO_INTR_STS	0x00
+#define IO_INTR_ACK	0x00
+#define IO_INTR_MSK	0x04
+
+#define CNTL_STOP_TIMER	(1 << 4)
+#define CNTL_RUN_TIMER	(0 << 4)
+
+#define CNTL_INC	(1 << 3)
+#define CNTL_DEC	(0 << 3)
+
+#define CNTL_TOZERO	0
+#define CNTL_MATCH(x)	((x) + 1)
+#define CNTL_FOREVER	7
+
+/* There are 6 match registers but we only use one. */
+#define TIMER_MATCH	0
+
+#define TIMER_INTR_MSK	(1 << (TIMER_MATCH))
+#define TIMER_INTR_ALL	0x3F
+
+struct zevio_timer {
+	void __iomem *base;
+	void __iomem *timer1, *timer2;
+	void __iomem *interrupt_regs;
+
+	struct clk *clk;
+	struct clock_event_device clkevt;
+	struct irqaction clkevt_irq;
+
+	char clocksource_name[64];
+	char clockevent_name[64];
+};
+
+static int zevio_timer_set_event(unsigned long delta,
+				 struct clock_event_device *dev)
+{
+	struct zevio_timer *timer = container_of(dev, struct zevio_timer,
+						 clkevt);
+
+	writel(delta, timer->timer1 + IO_CURRENT_VAL);
+	writel(CNTL_RUN_TIMER | CNTL_DEC | CNTL_MATCH(TIMER_MATCH),
+			timer->timer1 + IO_CONTROL);
+
+	return 0;
+}
+
+static void zevio_timer_set_mode(enum clock_event_mode mode,
+				 struct clock_event_device *dev)
+{
+	struct zevio_timer *timer = container_of(dev, struct zevio_timer,
+						 clkevt);
+
+	switch (mode) {
+	case CLOCK_EVT_MODE_RESUME:
+	case CLOCK_EVT_MODE_ONESHOT:
+		/* Enable timer interrupts */
+		writel(TIMER_INTR_MSK, timer->interrupt_regs + IO_INTR_MSK);
+		writel(TIMER_INTR_ALL, timer->interrupt_regs + IO_INTR_ACK);
+		break;
+	case CLOCK_EVT_MODE_SHUTDOWN:
+	case CLOCK_EVT_MODE_UNUSED:
+		/* Disable timer interrupts */
+		writel(0, timer->interrupt_regs + IO_INTR_MSK);
+		writel(TIMER_INTR_ALL, timer->interrupt_regs + IO_INTR_ACK);
+		/* Stop timer */
+		writel(CNTL_STOP_TIMER, timer->timer1 + IO_CONTROL);
+		break;
+	case CLOCK_EVT_MODE_PERIODIC:
+	default:
+		/* Unsupported */
+		break;
+	}
+}
+
+static irqreturn_t zevio_timer_interrupt(int irq, void *dev_id)
+{
+	struct zevio_timer *timer = dev_id;
+	u32 intr;
+
+	intr = readl(timer->interrupt_regs + IO_INTR_ACK);
+	if (!(intr & TIMER_INTR_MSK))
+		return IRQ_NONE;
+
+	writel(TIMER_INTR_MSK, timer->interrupt_regs + IO_INTR_ACK);
+	writel(CNTL_STOP_TIMER, timer->timer1 + IO_CONTROL);
+
+	if (timer->clkevt.event_handler)
+		timer->clkevt.event_handler(&timer->clkevt);
+
+	return IRQ_HANDLED;
+}
+
+static int __init zevio_timer_add(struct device_node *node)
+{
+	struct zevio_timer *timer;
+	struct resource res;
+	int irqnr, ret;
+
+	timer = kzalloc(sizeof(*timer), GFP_KERNEL);
+	if (!timer)
+		return -ENOMEM;
+
+	timer->base = of_iomap(node, 0);
+	if (!timer->base) {
+		ret = -EINVAL;
+		goto error_free;
+	}
+	timer->timer1 = timer->base + IO_TIMER1;
+	timer->timer2 = timer->base + IO_TIMER2;
+
+	timer->clk = of_clk_get(node, 0);
+	if (IS_ERR(timer->clk)) {
+		ret = PTR_ERR(timer->clk);
+		pr_err("Timer clock not found! (error %d)\n", ret);
+		goto error_unmap;
+	}
+
+	timer->interrupt_regs = of_iomap(node, 1);
+	irqnr = irq_of_parse_and_map(node, 0);
+
+	of_address_to_resource(node, 0, &res);
+	scnprintf(timer->clocksource_name, sizeof(timer->clocksource_name),
+			"%llx.%s_clocksource",
+			(unsigned long long)res.start, node->name);
+
+	scnprintf(timer->clockevent_name, sizeof(timer->clockevent_name),
+			"%llx.%s_clockevent",
+			(unsigned long long)res.start, node->name);
+
+	if (timer->interrupt_regs && irqnr) {
+		timer->clkevt.name		= timer->clockevent_name;
+		timer->clkevt.set_next_event	= zevio_timer_set_event;
+		timer->clkevt.set_mode		= zevio_timer_set_mode;
+		timer->clkevt.rating		= 200;
+		timer->clkevt.cpumask		= cpu_all_mask;
+		timer->clkevt.features		= CLOCK_EVT_FEAT_ONESHOT;
+		timer->clkevt.irq		= irqnr;
+
+		writel(CNTL_STOP_TIMER, timer->timer1 + IO_CONTROL);
+		writel(0, timer->timer1 + IO_DIVIDER);
+
+		/* Start with timer interrupts disabled */
+		writel(0, timer->interrupt_regs + IO_INTR_MSK);
+		writel(TIMER_INTR_ALL, timer->interrupt_regs + IO_INTR_ACK);
+
+		/* Interrupt to occur when timer value matches 0 */
+		writel(0, timer->base + IO_MATCH(TIMER_MATCH));
+
+		timer->clkevt_irq.name		= timer->clockevent_name;
+		timer->clkevt_irq.handler	= zevio_timer_interrupt;
+		timer->clkevt_irq.dev_id	= timer;
+		timer->clkevt_irq.flags		= IRQF_TIMER | IRQF_IRQPOLL;
+
+		setup_irq(irqnr, &timer->clkevt_irq);
+
+		clockevents_config_and_register(&timer->clkevt,
+				clk_get_rate(timer->clk), 0x0001, 0xffff);
+		pr_info("Added %s as clockevent\n", timer->clockevent_name);
+	}
+
+	writel(CNTL_STOP_TIMER, timer->timer2 + IO_CONTROL);
+	writel(0, timer->timer2 + IO_CURRENT_VAL);
+	writel(0, timer->timer2 + IO_DIVIDER);
+	writel(CNTL_RUN_TIMER | CNTL_FOREVER | CNTL_INC,
+			timer->timer2 + IO_CONTROL);
+
+	clocksource_mmio_init(timer->timer2 + IO_CURRENT_VAL,
+			timer->clocksource_name,
+			clk_get_rate(timer->clk),
+			200, 16,
+			clocksource_mmio_readw_up);
+
+	pr_info("Added %s as clocksource\n", timer->clocksource_name);
+
+	return 0;
+error_unmap:
+	iounmap(timer->base);
+error_free:
+	kfree(timer);
+	return ret;
+}
+
+CLOCKSOURCE_OF_DECLARE(zevio_timer, "lsi,zevio-timer", zevio_timer_add);
-- 
1.8.1.3


