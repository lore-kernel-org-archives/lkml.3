Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023Ab3CYNaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 09:30:46 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:46877 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757973Ab3CYNao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 09:30:44 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: kevin@allwinnertech.com, sunny@allwinnertech.com, shuge@allwinnertech.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 04/10] clocksource: sunxi: Rename sunxi to sun4i
Date: Mon, 25 Mar 2013 14:30:27 +0100
Message-Id: <1364218233-29636-5-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364218233-29636-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1364218233-29636-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the introduction of the Allwinner SoC platforms, sunxi was
initially meant as a generic name for all the variants of the Allwinner
SoC.

It was ok at the time of the support of only the A10 and A13 that
looks pretty much the same, but it's beginning to be troublesome with
the future addition of the Allwinner A31 (sun6i) that is quite
different, and would introduce some weird logic, where sunxi would
actually mean in some case sun4i and sun5i but without sun6i...

Moreover, it makes the compatible strings naming scheme not consistent
with other architectures, where usually for this kind of compability, we
just use the oldest SoC name that has this IP, so let's do just this.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-sunxi/Kconfig       |    4 +-
 drivers/clocksource/Kconfig       |    2 +-
 drivers/clocksource/Makefile      |    2 +-
 drivers/clocksource/sun4i_timer.c |  161 +++++++++++++++++++++++++++++++++++++
 drivers/clocksource/sunxi_timer.c |  161 -------------------------------------
 5 files changed, 165 insertions(+), 165 deletions(-)
 create mode 100644 drivers/clocksource/sun4i_timer.c
 delete mode 100644 drivers/clocksource/sunxi_timer.c

diff --git a/arch/arm/mach-sunxi/Kconfig b/arch/arm/mach-sunxi/Kconfig
index 06c2894..d259c78 100644
--- a/arch/arm/mach-sunxi/Kconfig
+++ b/arch/arm/mach-sunxi/Kconfig
@@ -7,5 +7,5 @@ config ARCH_SUNXI
 	select GENERIC_IRQ_CHIP
 	select PINCTRL
 	select SPARSE_IRQ
-	select SUNXI_TIMER
-	select PINCTRL_SUNXI
\ No newline at end of file
+	select SUN4I_TIMER
+	select PINCTRL_SUNXI
diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index e507ab7..9002185 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -25,7 +25,7 @@ config DW_APB_TIMER_OF
 config ARMADA_370_XP_TIMER
 	bool
 
-config SUNXI_TIMER
+config SUN4I_TIMER
 	bool
 
 config VT8500_TIMER
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 4d8283a..7d5d23a 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -16,7 +16,7 @@ obj-$(CONFIG_CLKSRC_NOMADIK_MTU)	+= nomadik-mtu.o
 obj-$(CONFIG_CLKSRC_DBX500_PRCMU)	+= clksrc-dbx500-prcmu.o
 obj-$(CONFIG_ARMADA_370_XP_TIMER)	+= time-armada-370-xp.o
 obj-$(CONFIG_ARCH_BCM2835)	+= bcm2835_timer.o
-obj-$(CONFIG_SUNXI_TIMER)	+= sunxi_timer.o
+obj-$(CONFIG_SUN4I_TIMER)	+= sun4i_timer.o
 obj-$(CONFIG_ARCH_TEGRA)	+= tegra20_timer.o
 obj-$(CONFIG_VT8500_TIMER)	+= vt8500_timer.o
 
diff --git a/drivers/clocksource/sun4i_timer.c b/drivers/clocksource/sun4i_timer.c
new file mode 100644
index 0000000..16fcb7c
--- /dev/null
+++ b/drivers/clocksource/sun4i_timer.c
@@ -0,0 +1,161 @@
+/*
+ * Allwinner A1X SoCs timer handling.
+ *
+ * Copyright (C) 2012 Maxime Ripard
+ *
+ * Maxime Ripard <maxime.ripard@free-electrons.com>
+ *
+ * Based on code from
+ * Allwinner Technology Co., Ltd. <www.allwinnertech.com>
+ * Benn Huang <benn@allwinnertech.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/clk.h>
+#include <linux/clockchips.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/irqreturn.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/clk/sunxi.h>
+
+#define TIMER_IRQ_EN_REG	0x00
+#define TIMER_IRQ_EN(val)		(1 << val)
+#define TIMER_IRQ_ST_REG	0x04
+#define TIMER_CTL_REG(val)	(0x10 * val + 0x10)
+#define TIMER_CTL_ENABLE		(1 << 0)
+#define TIMER_CTL_AUTORELOAD		(1 << 1)
+#define TIMER_CTL_ONESHOT		(1 << 7)
+#define TIMER_INTVAL_REG(val)	(0x10 * val + 0x14)
+#define TIMER_CNTVAL_REG(val)	(0x10 * val + 0x18)
+
+#define TIMER_SCAL		16
+
+static void __iomem *timer_base;
+
+static void sun4i_clkevt_mode(enum clock_event_mode mode,
+			      struct clock_event_device *clk)
+{
+	u32 u = readl(timer_base + TIMER_CTL_REG(0));
+
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+		u &= ~(TIMER_CTL_ONESHOT);
+		writel(u | TIMER_CTL_ENABLE, timer_base + TIMER_CTL_REG(0));
+		break;
+
+	case CLOCK_EVT_MODE_ONESHOT:
+		writel(u | TIMER_CTL_ONESHOT, timer_base + TIMER_CTL_REG(0));
+		break;
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+	default:
+		writel(u & ~(TIMER_CTL_ENABLE), timer_base + TIMER_CTL_REG(0));
+		break;
+	}
+}
+
+static int sun4i_clkevt_next_event(unsigned long evt,
+				   struct clock_event_device *unused)
+{
+	u32 u = readl(timer_base + TIMER_CTL_REG(0));
+	writel(evt, timer_base + TIMER_CNTVAL_REG(0));
+	writel(u | TIMER_CTL_ENABLE | TIMER_CTL_AUTORELOAD,
+	       timer_base + TIMER_CTL_REG(0));
+
+	return 0;
+}
+
+static struct clock_event_device sun4i_clockevent = {
+	.name = "sun4i_tick",
+	.rating = 300,
+	.features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
+	.set_mode = sun4i_clkevt_mode,
+	.set_next_event = sun4i_clkevt_next_event,
+};
+
+
+static irqreturn_t sun4i_timer_interrupt(int irq, void *dev_id)
+{
+	struct clock_event_device *evt = (struct clock_event_device *)dev_id;
+
+	writel(0x1, timer_base + TIMER_IRQ_ST_REG);
+	evt->event_handler(evt);
+
+	return IRQ_HANDLED;
+}
+
+static struct irqaction sun4i_timer_irq = {
+	.name = "sun4i_timer0",
+	.flags = IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.handler = sun4i_timer_interrupt,
+	.dev_id = &sun4i_clockevent,
+};
+
+static struct of_device_id sun4i_timer_dt_ids[] = {
+	{ .compatible = "allwinner,sun4i-timer" },
+	{ }
+};
+
+void __init sun4i_timer_init(void)
+{
+	struct device_node *node;
+	unsigned long rate = 0;
+	struct clk *clk;
+	int ret, irq;
+	u32 val;
+
+	node = of_find_matching_node(NULL, sun4i_timer_dt_ids);
+	if (!node)
+		panic("No sun4i timer node");
+
+	timer_base = of_iomap(node, 0);
+	if (!timer_base)
+		panic("Can't map registers");
+
+	irq = irq_of_parse_and_map(node, 0);
+	if (irq <= 0)
+		panic("Can't parse IRQ");
+
+	sunxi_init_clocks();
+
+	clk = of_clk_get(node, 0);
+	if (IS_ERR(clk))
+		panic("Can't get timer clock");
+
+	rate = clk_get_rate(clk);
+
+	writel(rate / (TIMER_SCAL * HZ),
+	       timer_base + TIMER_INTVAL_REG(0));
+
+	/* set clock source to HOSC, 16 pre-division */
+	val = readl(timer_base + TIMER_CTL_REG(0));
+	val &= ~(0x07 << 4);
+	val &= ~(0x03 << 2);
+	val |= (4 << 4) | (1 << 2);
+	writel(val, timer_base + TIMER_CTL_REG(0));
+
+	/* set mode to auto reload */
+	val = readl(timer_base + TIMER_CTL_REG(0));
+	writel(val | TIMER_CTL_AUTORELOAD, timer_base + TIMER_CTL_REG(0));
+
+	ret = setup_irq(irq, &sun4i_timer_irq);
+	if (ret)
+		pr_warn("failed to setup irq %d\n", irq);
+
+	/* Enable timer0 interrupt */
+	val = readl(timer_base + TIMER_IRQ_EN_REG);
+	writel(val | TIMER_IRQ_EN(0), timer_base + TIMER_IRQ_EN_REG);
+
+	sun4i_clockevent.cpumask = cpumask_of(0);
+
+	clockevents_config_and_register(&sun4i_clockevent, rate / TIMER_SCAL,
+					0x1, 0xff);
+}
+CLOCKSOURCE_OF_DECLARE(sun4i, "allwinner,sun4i-timer",
+		       sun4i_timer_init);
diff --git a/drivers/clocksource/sunxi_timer.c b/drivers/clocksource/sunxi_timer.c
deleted file mode 100644
index 0b46b7f..0000000
--- a/drivers/clocksource/sunxi_timer.c
+++ /dev/null
@@ -1,161 +0,0 @@
-/*
- * Allwinner A1X SoCs timer handling.
- *
- * Copyright (C) 2012 Maxime Ripard
- *
- * Maxime Ripard <maxime.ripard@free-electrons.com>
- *
- * Based on code from
- * Allwinner Technology Co., Ltd. <www.allwinnertech.com>
- * Benn Huang <benn@allwinnertech.com>
- *
- * This file is licensed under the terms of the GNU General Public
- * License version 2.  This program is licensed "as is" without any
- * warranty of any kind, whether express or implied.
- */
-
-#include <linux/clk.h>
-#include <linux/clockchips.h>
-#include <linux/interrupt.h>
-#include <linux/irq.h>
-#include <linux/irqreturn.h>
-#include <linux/of.h>
-#include <linux/of_address.h>
-#include <linux/of_irq.h>
-#include <linux/clk/sunxi.h>
-
-#define TIMER_IRQ_EN_REG	0x00
-#define TIMER_IRQ_EN(val)		(1 << val)
-#define TIMER_IRQ_ST_REG	0x04
-#define TIMER_CTL_REG(val)	(0x10 * val + 0x10)
-#define TIMER_CTL_ENABLE		(1 << 0)
-#define TIMER_CTL_AUTORELOAD		(1 << 1)
-#define TIMER_CTL_ONESHOT		(1 << 7)
-#define TIMER_INTVAL_REG(val)	(0x10 * val + 0x14)
-#define TIMER_CNTVAL_REG(val)	(0x10 * val + 0x18)
-
-#define TIMER_SCAL		16
-
-static void __iomem *timer_base;
-
-static void sunxi_clkevt_mode(enum clock_event_mode mode,
-			      struct clock_event_device *clk)
-{
-	u32 u = readl(timer_base + TIMER_CTL_REG(0));
-
-	switch (mode) {
-	case CLOCK_EVT_MODE_PERIODIC:
-		u &= ~(TIMER_CTL_ONESHOT);
-		writel(u | TIMER_CTL_ENABLE, timer_base + TIMER_CTL_REG(0));
-		break;
-
-	case CLOCK_EVT_MODE_ONESHOT:
-		writel(u | TIMER_CTL_ONESHOT, timer_base + TIMER_CTL_REG(0));
-		break;
-	case CLOCK_EVT_MODE_UNUSED:
-	case CLOCK_EVT_MODE_SHUTDOWN:
-	default:
-		writel(u & ~(TIMER_CTL_ENABLE), timer_base + TIMER_CTL_REG(0));
-		break;
-	}
-}
-
-static int sunxi_clkevt_next_event(unsigned long evt,
-				   struct clock_event_device *unused)
-{
-	u32 u = readl(timer_base + TIMER_CTL_REG(0));
-	writel(evt, timer_base + TIMER_CNTVAL_REG(0));
-	writel(u | TIMER_CTL_ENABLE | TIMER_CTL_AUTORELOAD,
-	       timer_base + TIMER_CTL_REG(0));
-
-	return 0;
-}
-
-static struct clock_event_device sunxi_clockevent = {
-	.name = "sunxi_tick",
-	.rating = 300,
-	.features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
-	.set_mode = sunxi_clkevt_mode,
-	.set_next_event = sunxi_clkevt_next_event,
-};
-
-
-static irqreturn_t sunxi_timer_interrupt(int irq, void *dev_id)
-{
-	struct clock_event_device *evt = (struct clock_event_device *)dev_id;
-
-	writel(0x1, timer_base + TIMER_IRQ_ST_REG);
-	evt->event_handler(evt);
-
-	return IRQ_HANDLED;
-}
-
-static struct irqaction sunxi_timer_irq = {
-	.name = "sunxi_timer0",
-	.flags = IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
-	.handler = sunxi_timer_interrupt,
-	.dev_id = &sunxi_clockevent,
-};
-
-static struct of_device_id sunxi_timer_dt_ids[] = {
-	{ .compatible = "allwinner,sunxi-timer" },
-	{ }
-};
-
-void __init sunxi_timer_init(void)
-{
-	struct device_node *node;
-	unsigned long rate = 0;
-	struct clk *clk;
-	int ret, irq;
-	u32 val;
-
-	node = of_find_matching_node(NULL, sunxi_timer_dt_ids);
-	if (!node)
-		panic("No sunxi timer node");
-
-	timer_base = of_iomap(node, 0);
-	if (!timer_base)
-		panic("Can't map registers");
-
-	irq = irq_of_parse_and_map(node, 0);
-	if (irq <= 0)
-		panic("Can't parse IRQ");
-
-	sunxi_init_clocks();
-
-	clk = of_clk_get(node, 0);
-	if (IS_ERR(clk))
-		panic("Can't get timer clock");
-
-	rate = clk_get_rate(clk);
-
-	writel(rate / (TIMER_SCAL * HZ),
-	       timer_base + TIMER_INTVAL_REG(0));
-
-	/* set clock source to HOSC, 16 pre-division */
-	val = readl(timer_base + TIMER_CTL_REG(0));
-	val &= ~(0x07 << 4);
-	val &= ~(0x03 << 2);
-	val |= (4 << 4) | (1 << 2);
-	writel(val, timer_base + TIMER_CTL_REG(0));
-
-	/* set mode to auto reload */
-	val = readl(timer_base + TIMER_CTL_REG(0));
-	writel(val | TIMER_CTL_AUTORELOAD, timer_base + TIMER_CTL_REG(0));
-
-	ret = setup_irq(irq, &sunxi_timer_irq);
-	if (ret)
-		pr_warn("failed to setup irq %d\n", irq);
-
-	/* Enable timer0 interrupt */
-	val = readl(timer_base + TIMER_IRQ_EN_REG);
-	writel(val | TIMER_IRQ_EN(0), timer_base + TIMER_IRQ_EN_REG);
-
-	sunxi_clockevent.cpumask = cpumask_of(0);
-
-	clockevents_config_and_register(&sunxi_clockevent, rate / TIMER_SCAL,
-					0x1, 0xff);
-}
-CLOCKSOURCE_OF_DECLARE(sunxi, "allwinner,sun4i-timer",
-		       sunxi_timer_init);
-- 
1.7.10.4

