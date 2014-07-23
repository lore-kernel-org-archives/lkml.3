Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959AbaGWKye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 06:54:34 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:43243 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409AbaGWKyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 06:54:24 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 13/25] clocksource: Add support for the Mediatek SoCs
Date: Wed, 23 Jul 2014 12:53:55 +0200
Message-Id: <1406112847-26275-13-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406112847-26275-1-git-send-email-daniel.lezcano@linaro.org>
References: <53CF93B2.6040903@linaro.org>
 <1406112847-26275-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthias Brugger <matthias.bgg@gmail.com>

This patch adds a clock source and clock event for the timer found
on the Mediatek SoCs.

The Mediatek General Purpose Timer block provides five 32 bit timers and
one 64 bit timer.

Two 32 bit timers are used by this driver:
TIMER1: clock events supporting periodic and oneshot events
TIMER2: clock source configured as a free running counter

The General Purpose Timer block can be run with two clocks. A 13 MHz system
clock and the RTC clock running at 32 KHz. This implementation uses the system
clock with no clock source divider.

The interrupts are shared between the different timers and have to be read back
from a register. We just enable one interrupt for the clock event. The clock
event timer is used by all cores.

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/Kconfig     |    5 +
 drivers/clocksource/Makefile    |    1 +
 drivers/clocksource/mtk_timer.c |  261 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 267 insertions(+)
 create mode 100644 drivers/clocksource/mtk_timer.c

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index b17c909..497356d 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -151,6 +151,11 @@ config VF_PIT_TIMER
 config SYS_SUPPORTS_SH_CMT
         bool
 
+config MTK_TIMER
+	select CLKSRC_OF
+	select CLKSRC_MMIO
+	bool
+
 config SYS_SUPPORTS_SH_MTU2
         bool
 
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 800b130..da1ac09 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -34,6 +34,7 @@ obj-$(CONFIG_CLKSRC_SAMSUNG_PWM)	+= samsung_pwm_timer.o
 obj-$(CONFIG_FSL_FTM_TIMER)	+= fsl_ftm_timer.o
 obj-$(CONFIG_VF_PIT_TIMER)	+= vf_pit_timer.o
 obj-$(CONFIG_CLKSRC_QCOM)	+= qcom-timer.o
+obj-$(CONFIG_MTK_TIMER)		+= mtk_timer.o
 
 obj-$(CONFIG_ARM_ARCH_TIMER)		+= arm_arch_timer.o
 obj-$(CONFIG_ARM_GLOBAL_TIMER)		+= arm_global_timer.o
diff --git a/drivers/clocksource/mtk_timer.c b/drivers/clocksource/mtk_timer.c
new file mode 100644
index 0000000..32a3d25
--- /dev/null
+++ b/drivers/clocksource/mtk_timer.c
@@ -0,0 +1,261 @@
+/*
+ * Mediatek SoCs General-Purpose Timer handling.
+ *
+ * Copyright (C) 2014 Matthias Brugger
+ *
+ * Matthias Brugger <matthias.bgg@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
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
+#include <linux/slab.h>
+
+#define GPT_IRQ_EN_REG		0x00
+#define GPT_IRQ_ENABLE(val)	BIT((val) - 1)
+#define GPT_IRQ_ACK_REG		0x08
+#define GPT_IRQ_ACK(val)	BIT((val) - 1)
+
+#define TIMER_CTRL_REG(val)	(0x10 * (val))
+#define TIMER_CTRL_OP(val)	(((val) & 0x3) << 4)
+#define TIMER_CTRL_OP_ONESHOT	(0)
+#define TIMER_CTRL_OP_REPEAT	(1)
+#define TIMER_CTRL_OP_FREERUN	(3)
+#define TIMER_CTRL_CLEAR	(2)
+#define TIMER_CTRL_ENABLE	(1)
+#define TIMER_CTRL_DISABLE	(0)
+
+#define TIMER_CLK_REG(val)	(0x04 + (0x10 * (val)))
+#define TIMER_CLK_SRC(val)	(((val) & 0x1) << 4)
+#define TIMER_CLK_SRC_SYS13M	(0)
+#define TIMER_CLK_SRC_RTC32K	(1)
+#define TIMER_CLK_DIV1		(0x0)
+#define TIMER_CLK_DIV2		(0x1)
+
+#define TIMER_CNT_REG(val)	(0x08 + (0x10 * (val)))
+#define TIMER_CMP_REG(val)	(0x0C + (0x10 * (val)))
+
+#define GPT_CLK_EVT	1
+#define GPT_CLK_SRC	2
+
+struct mtk_clock_event_device {
+	void __iomem *gpt_base;
+	u32 ticks_per_jiffy;
+	struct clock_event_device dev;
+};
+
+static inline struct mtk_clock_event_device *to_mtk_clk(
+				struct clock_event_device *c)
+{
+	return container_of(c, struct mtk_clock_event_device, dev);
+}
+
+static void mtk_clkevt_time_stop(struct mtk_clock_event_device *evt, u8 timer)
+{
+	u32 val;
+
+	val = readl(evt->gpt_base + TIMER_CTRL_REG(timer));
+	writel(val & ~TIMER_CTRL_ENABLE, evt->gpt_base +
+			TIMER_CTRL_REG(timer));
+}
+
+static void mtk_clkevt_time_setup(struct mtk_clock_event_device *evt,
+				unsigned long delay, u8 timer)
+{
+	writel(delay, evt->gpt_base + TIMER_CMP_REG(timer));
+}
+
+static void mtk_clkevt_time_start(struct mtk_clock_event_device *evt,
+		bool periodic, u8 timer)
+{
+	u32 val;
+
+	/* Acknowledge interrupt */
+	writel(GPT_IRQ_ACK(timer), evt->gpt_base + GPT_IRQ_ACK_REG);
+
+	val = readl(evt->gpt_base + TIMER_CTRL_REG(timer));
+
+	/* Clear 2 bit timer operation mode field */
+	val &= ~TIMER_CTRL_OP(0x3);
+
+	if (periodic)
+		val |= TIMER_CTRL_OP(TIMER_CTRL_OP_REPEAT);
+	else
+		val |= TIMER_CTRL_OP(TIMER_CTRL_OP_ONESHOT);
+
+	writel(val | TIMER_CTRL_ENABLE | TIMER_CTRL_CLEAR,
+	       evt->gpt_base + TIMER_CTRL_REG(timer));
+}
+
+static void mtk_clkevt_mode(enum clock_event_mode mode,
+				struct clock_event_device *clk)
+{
+	struct mtk_clock_event_device *evt = to_mtk_clk(clk);
+
+	mtk_clkevt_time_stop(evt, GPT_CLK_EVT);
+
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+		mtk_clkevt_time_setup(evt, evt->ticks_per_jiffy, GPT_CLK_EVT);
+		mtk_clkevt_time_start(evt, true, GPT_CLK_EVT);
+		break;
+	case CLOCK_EVT_MODE_ONESHOT:
+		/* Timer is enabled in set_next_event */
+		break;
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+	default:
+		/* No more interrupts will occur as source is disabled */
+		break;
+	}
+}
+
+static int mtk_clkevt_next_event(unsigned long event,
+				   struct clock_event_device *clk)
+{
+	struct mtk_clock_event_device *evt = to_mtk_clk(clk);
+
+	mtk_clkevt_time_stop(evt, GPT_CLK_EVT);
+	mtk_clkevt_time_setup(evt, event, GPT_CLK_EVT);
+	mtk_clkevt_time_start(evt, false, GPT_CLK_EVT);
+
+	return 0;
+}
+
+static irqreturn_t mtk_timer_interrupt(int irq, void *dev_id)
+{
+	struct mtk_clock_event_device *evt = dev_id;
+
+	/* Acknowledge timer0 irq */
+	writel(GPT_IRQ_ACK(GPT_CLK_EVT), evt->gpt_base + GPT_IRQ_ACK_REG);
+	evt->dev.event_handler(&evt->dev);
+
+	return IRQ_HANDLED;
+}
+
+static void mtk_timer_global_reset(struct mtk_clock_event_device *evt)
+{
+	/* Disable all interrupts */
+	writel(0x0, evt->gpt_base + GPT_IRQ_EN_REG);
+	/* Acknowledge all interrupts */
+	writel(0x3f, evt->gpt_base + GPT_IRQ_ACK_REG);
+}
+
+static void
+mtk_timer_setup(struct mtk_clock_event_device *evt, u8 timer, u8 option)
+{
+	writel(TIMER_CTRL_CLEAR | TIMER_CTRL_DISABLE,
+		evt->gpt_base + TIMER_CTRL_REG(timer));
+
+	writel(TIMER_CLK_SRC(TIMER_CLK_SRC_SYS13M) | TIMER_CLK_DIV1,
+			evt->gpt_base + TIMER_CLK_REG(timer));
+
+	writel(0x0, evt->gpt_base + TIMER_CMP_REG(timer));
+
+	writel(TIMER_CTRL_OP(option) | TIMER_CTRL_ENABLE,
+			evt->gpt_base + TIMER_CTRL_REG(timer));
+}
+
+static void mtk_timer_enable_irq(struct mtk_clock_event_device *evt, u8 timer)
+{
+	u32 val;
+
+	val = readl(evt->gpt_base + GPT_IRQ_EN_REG);
+	writel(val | GPT_IRQ_ENABLE(timer),
+			evt->gpt_base + GPT_IRQ_EN_REG);
+}
+
+static void __init mtk_timer_init(struct device_node *node)
+{
+	struct mtk_clock_event_device *evt;
+	struct resource res;
+	unsigned long rate = 0;
+	struct clk *clk;
+
+	evt = kzalloc(sizeof(*evt), GFP_KERNEL);
+	if (!evt) {
+		pr_warn("Can't allocate mtk clock event driver struct");
+		return;
+	}
+
+	evt->dev.name = "mtk_tick";
+	evt->dev.rating = 300;
+	evt->dev.features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT;
+	evt->dev.set_mode = mtk_clkevt_mode;
+	evt->dev.set_next_event = mtk_clkevt_next_event;
+	evt->dev.cpumask = cpu_possible_mask;
+
+	evt->gpt_base = of_io_request_and_map(node, 0, "mtk-timer");
+	if (IS_ERR(evt->gpt_base)) {
+		pr_warn("Can't get resource\n");
+		return;
+	}
+
+	evt->dev.irq = irq_of_parse_and_map(node, 0);
+	if (evt->dev.irq <= 0) {
+		pr_warn("Can't parse IRQ");
+		goto err_mem;
+	}
+
+	clk = of_clk_get(node, 0);
+	if (IS_ERR(clk)) {
+		pr_warn("Can't get timer clock");
+		goto err_irq;
+	}
+
+	if (clk_prepare_enable(clk)) {
+		pr_warn("Can't prepare clock");
+		goto err_clk_put;
+	}
+	rate = clk_get_rate(clk);
+
+	if (request_irq(evt->dev.irq, mtk_timer_interrupt,
+			IRQF_TIMER | IRQF_IRQPOLL, "mtk_timer", evt)) {
+		pr_warn("failed to setup irq %d\n", evt->dev.irq);
+		goto err_clk_disable;
+	}
+
+	evt->ticks_per_jiffy = DIV_ROUND_UP(rate, HZ);
+
+	mtk_timer_global_reset(evt);
+
+	/* Configure clock source */
+	mtk_timer_setup(evt, GPT_CLK_SRC, TIMER_CTRL_OP_FREERUN);
+	clocksource_mmio_init(evt->gpt_base + TIMER_CNT_REG(GPT_CLK_SRC),
+			node->name, rate, 300, 32, clocksource_mmio_readl_up);
+
+	/* Configure clock event */
+	mtk_timer_setup(evt, GPT_CLK_EVT, TIMER_CTRL_OP_REPEAT);
+	mtk_timer_enable_irq(evt, GPT_CLK_EVT);
+
+	clockevents_config_and_register(&evt->dev, rate, 0x3,
+					0xffffffff);
+	return;
+
+err_clk_disable:
+	clk_disable_unprepare(clk);
+err_clk_put:
+	clk_put(clk);
+err_irq:
+	irq_dispose_mapping(evt->dev.irq);
+err_mem:
+	iounmap(evt->gpt_base);
+	of_address_to_resource(node, 0, &res);
+	release_mem_region(res.start, resource_size(&res));
+}
+CLOCKSOURCE_OF_DECLARE(mtk_mt6577, "mediatek,mt6577-timer", mtk_timer_init);
-- 
1.7.9.5

