Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932807Ab3GPOpG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 10:45:06 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:63489 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932652Ab3GPOpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 10:45:04 -0400
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org, john.stultz@linaro.org,
        tglx@linutronix.de, u.kleine-koenig@pengutronix.de,
        tomasz.figa@gmail.com, linus.walleij@linaro.org,
        thomas.petazzoni@free-electrons.com, arnd@arndb.de,
        daniel.lezcano@linaro.org, Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH v8] ARM: clocksource: add support for MOXA ART SoCs
Date: Tue, 16 Jul 2013 16:44:40 +0200
Message-Id: <1373985880-23469-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1373024773-24574-1-git-send-email-jonas.jensen@gmail.com>
References: <1373024773-24574-1-git-send-email-jonas.jensen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an clocksource driver for the main timer(s)
found on MOXA ART SoCs.

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---

Notes:
    Changes since v7:
    
    1. use BIT macro
    2. set moxart_clockevent.irq
    
    Applies to next-20130716

 drivers/clocksource/Makefile       |   1 +
 drivers/clocksource/moxart_timer.c | 164 +++++++++++++++++++++++++++++++++++++
 2 files changed, 165 insertions(+)
 create mode 100644 drivers/clocksource/moxart_timer.c

diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 8b00c5c..704d6d3 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_ARMADA_370_XP_TIMER)	+= time-armada-370-xp.o
 obj-$(CONFIG_ORION_TIMER)	+= time-orion.o
 obj-$(CONFIG_ARCH_BCM2835)	+= bcm2835_timer.o
 obj-$(CONFIG_ARCH_MARCO)	+= timer-marco.o
+obj-$(CONFIG_ARCH_MOXART)	+= moxart_timer.o
 obj-$(CONFIG_ARCH_MXS)		+= mxs_timer.o
 obj-$(CONFIG_ARCH_PRIMA2)	+= timer-prima2.o
 obj-$(CONFIG_SUN4I_TIMER)	+= sun4i_timer.o
diff --git a/drivers/clocksource/moxart_timer.c b/drivers/clocksource/moxart_timer.c
new file mode 100644
index 0000000..08a5943
--- /dev/null
+++ b/drivers/clocksource/moxart_timer.c
@@ -0,0 +1,164 @@
+/*
+ * MOXA ART SoCs timer handling.
+ *
+ * Copyright (C) 2013 Jonas Jensen
+ *
+ * Jonas Jensen <jonas.jensen@gmail.com>
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
+#include <linux/io.h>
+#include <linux/clocksource.h>
+
+#define TIMER1_BASE		0x00
+#define TIMER2_BASE		0x10
+#define TIMER3_BASE		0x20
+
+#define REG_COUNT		0x0 /* writable */
+#define REG_LOAD		0x4
+#define REG_MATCH1		0x8
+#define REG_MATCH2		0xC
+
+#define TIMER_CR		0x30
+#define TIMER_INTR_STATE	0x34
+#define TIMER_INTR_MASK		0x38
+
+/*
+ * TIMER_CR flags:
+ *
+ * TIMEREG_CR_*_CLOCK	0: PCLK, 1: EXT1CLK
+ * TIMEREG_CR_*_INT	overflow interrupt enable bit
+ */
+#define TIMEREG_CR_1_ENABLE	BIT(0)
+#define TIMEREG_CR_1_CLOCK	BIT(1)
+#define TIMEREG_CR_1_INT	BIT(2)
+#define TIMEREG_CR_2_ENABLE	BIT(3)
+#define TIMEREG_CR_2_CLOCK	BIT(4)
+#define TIMEREG_CR_2_INT	BIT(5)
+#define TIMEREG_CR_3_ENABLE	BIT(6)
+#define TIMEREG_CR_3_CLOCK	BIT(7)
+#define TIMEREG_CR_3_INT	BIT(8)
+#define TIMEREG_CR_COUNT_UP	BIT(9)
+
+#define TIMER1_ENABLE		(TIMEREG_CR_2_ENABLE | TIMEREG_CR_1_ENABLE)
+#define TIMER1_DISABLE		(TIMEREG_CR_2_ENABLE)
+
+static void __iomem *base;
+static unsigned int clock_count_per_tick;
+
+static void moxart_clkevt_mode(enum clock_event_mode mode,
+			       struct clock_event_device *clk)
+{
+	switch (mode) {
+	case CLOCK_EVT_MODE_RESUME:
+	case CLOCK_EVT_MODE_ONESHOT:
+		writel(TIMER1_DISABLE, base + TIMER_CR);
+		writel(~0, base + TIMER1_BASE + REG_LOAD);
+		break;
+	case CLOCK_EVT_MODE_PERIODIC:
+		writel(clock_count_per_tick, base + TIMER1_BASE + REG_LOAD);
+		writel(TIMER1_ENABLE, base + TIMER_CR);
+		break;
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+	default:
+		writel(TIMER1_DISABLE, base + TIMER_CR);
+		break;
+	}
+}
+
+static int moxart_clkevt_next_event(unsigned long cycles,
+				    struct clock_event_device *unused)
+{
+	u32 u;
+
+	writel(TIMER1_DISABLE, base + TIMER_CR);
+
+	u = readl(base + TIMER1_BASE + REG_COUNT) - cycles;
+	writel(u, base + TIMER1_BASE + REG_MATCH1);
+
+	writel(TIMER1_ENABLE, base + TIMER_CR);
+
+	return 0;
+}
+
+static struct clock_event_device moxart_clockevent = {
+	.name		= "moxart_timer",
+	.rating		= 200,
+	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
+	.set_mode	= moxart_clkevt_mode,
+	.set_next_event	= moxart_clkevt_next_event,
+};
+
+static irqreturn_t moxart_timer_interrupt(int irq, void *dev_id)
+{
+	struct clock_event_device *evt = dev_id;
+	evt->event_handler(evt);
+	return IRQ_HANDLED;
+}
+
+static struct irqaction moxart_timer_irq = {
+	.name		= "moxart-timer",
+	.flags		= IRQF_TIMER,
+	.handler	= moxart_timer_interrupt,
+	.dev_id		= &moxart_clockevent,
+};
+
+static void __init moxart_timer_init(struct device_node *node)
+{
+	int ret, irq;
+	unsigned long pclk;
+	struct clk *clk;
+
+	base = of_iomap(node, 0);
+	if (!base)
+		panic("%s: of_iomap failed\n", node->full_name);
+
+	irq = irq_of_parse_and_map(node, 0);
+	if (irq <= 0)
+		panic("%s: irq_of_parse_and_map failed\n", node->full_name);
+
+	ret = setup_irq(irq, &moxart_timer_irq);
+	if (ret)
+		panic("%s: setup_irq failed\n", node->full_name);
+
+	clk = of_clk_get(node, 0);
+	if (IS_ERR(clk))
+		panic("%s: of_clk_get failed\n", node->full_name);
+
+	pclk = clk_get_rate(clk);
+
+	if (clocksource_mmio_init(base + TIMER2_BASE + REG_COUNT,
+				  "moxart_timer", pclk, 200, 32,
+				  clocksource_mmio_readl_down))
+		panic("%s: clocksource_mmio_init failed\n", node->full_name);
+
+	clock_count_per_tick = DIV_ROUND_CLOSEST(pclk, HZ);
+
+	writel(~0, base + TIMER2_BASE + REG_LOAD);
+	writel(TIMEREG_CR_2_ENABLE, base + TIMER_CR);
+
+	moxart_clockevent.cpumask = cpumask_of(0);
+	moxart_clockevent.irq = irq;
+
+	/*
+	 * documentation is not publicly available:
+	 * min_delta / max_delta obtained by trial-and-error,
+	 * max_delta 0xfffffffe should be ok because count
+	 * register size is u32
+	 */
+	clockevents_config_and_register(&moxart_clockevent, pclk,
+					0x4, 0xfffffffe);
+}
+CLOCKSOURCE_OF_DECLARE(moxart, "moxa,moxart-timer", moxart_timer_init);
-- 
1.8.2.1

