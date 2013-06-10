Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab3FJJgM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 05:36:12 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:35693 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab3FJJgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 05:36:10 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/6] clocksource: add Marvell Orion SoC timer
Date: Mon, 10 Jun 2013 11:35:55 +0200
Message-Id: <1370856955-10514-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1370536034-23956-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1370536034-23956-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add a DT enabled driver for timers found on Marvell Orion SoCs
(Kirkwood, Dove, Orion5x, and Discovery Innovation). It installs a free-
running clocksource on timer0 and a clockevent source on timer1.
Corresponding device tree documentation is also added.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Changelog:
v3->v4:
- export thread-safe access to TIMER_CTRL register to use with watchdog
- remove IRQF_DISABLED and add .irq to clock event (Suggested by Daniel Lezcano)

Notes:
- This is only an update to clocksource driver, the remaining patches are
  not resent as they have not been changed.
- I will not rework orion watchdog driver for this patch set. It is written
  Kirkwood/Orion5x specific although it will also work on Dove and it is messing
  with shared registers. It has done it before, so I consider it broken anyway.
  I (or somebody else) will take care of proper watchdog later.
- An updated branch can be found on
  git://github.com/shesselba/linux-dove.git orion-irqchip-for-v3.11_v4

Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 .../bindings/timer/marvell,orion-timer.txt         |   17 +++
 drivers/clocksource/Kconfig                        |    5 +
 drivers/clocksource/Makefile                       |    1 +
 drivers/clocksource/time-orion.c                   |  150 ++++++++++++++++++++
 4 files changed, 173 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/timer/marvell,orion-timer.txt
 create mode 100644 drivers/clocksource/time-orion.c

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
index f151c6c..2404869 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -25,6 +25,11 @@ config DW_APB_TIMER_OF
 config ARMADA_370_XP_TIMER
 	bool
 
+config ORION_TIMER
+	select CLKSRC_OF
+	select CLKSRC_MMIO
+	bool
+
 config SUN4I_TIMER
 	bool
 
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 8d979c7..d1e8d68 100644
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
diff --git a/drivers/clocksource/time-orion.c b/drivers/clocksource/time-orion.c
new file mode 100644
index 0000000..ad7df17
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
-- 
1.7.2.5

