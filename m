Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab3GAOC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 10:02:57 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:48469 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121Ab3GAOCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 10:02:55 -0400
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org, john.stultz@linaro.org,
        tglx@linutronix.de, u.kleine-koenig@pengutronix.de,
        tomasz.figa@gmail.com, linus.walleij@linaro.org,
        thomas.petazzoni@free-electrons.com, arnd@arndb.de,
        Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH v4] ARM: clocksource: add support for MOXA ART SoCs
Date: Mon,  1 Jul 2013 16:02:39 +0200
Message-Id: <1372687359-18235-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1372332203-30228-1-git-send-email-jonas.jensen@gmail.com>
References: <1372332203-30228-1-git-send-email-jonas.jensen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an clocksource driver for the main timer(s)
found on MOXA ART SoCs.

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---

Notes:
    This should hopefully address most of the issues pointed out by Thomas.
    
    Preventing the counter from passing match, TIMER1 is now stopped before
    count is read, I leave it up to you to comment.
    
    I think REG_MATCH1 triggers on ==, or rather, I have no reason to believe
    otherwise. Documentation does not seem to be publicly available, at least
    my searches have come up empty.
    
    The old 2.6.9 sources which this is loosely derived from, rely entirely on
    setting load with periodic timer_tick. REG_MATCH1 was never used there.
    
    Applies to next-20130619
    
    Changes since v3:
    
    1. fix indentation
    2. stop TIMER1 before reading count in moxart_clkevt_next_event
    3. use tabs to align assigned values
    4. handle errors and use more consistent messages
    5. change max_delta from 0xf0000000 to 0xfffffffe (and add comment)

 drivers/clocksource/Makefile       |   1 +
 drivers/clocksource/moxart_timer.c | 165 +++++++++++++++++++++++++++++++++++++
 2 files changed, 166 insertions(+)
 create mode 100644 drivers/clocksource/moxart_timer.c

diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 8d979c7..c93e1a8 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -29,3 +29,4 @@ obj-$(CONFIG_CLKSRC_SAMSUNG_PWM)	+= samsung_pwm_timer.o
 
 obj-$(CONFIG_ARM_ARCH_TIMER)		+= arm_arch_timer.o
 obj-$(CONFIG_CLKSRC_METAG_GENERIC)	+= metag_generic.o
+obj-$(CONFIG_ARCH_MOXART)	+= moxart_timer.o
diff --git a/drivers/clocksource/moxart_timer.c b/drivers/clocksource/moxart_timer.c
new file mode 100644
index 0000000..ae95a11
--- /dev/null
+++ b/drivers/clocksource/moxart_timer.c
@@ -0,0 +1,165 @@
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
+#define TIMEREG_CR_1_ENABLE	(1 << 0)
+#define TIMEREG_CR_1_CLOCK	(1 << 1)
+#define TIMEREG_CR_1_INT	(1 << 2)
+#define TIMEREG_CR_2_ENABLE	(1 << 3)
+#define TIMEREG_CR_2_CLOCK	(1 << 4)
+#define TIMEREG_CR_2_INT	(1 << 5)
+#define TIMEREG_CR_3_ENABLE	(1 << 6)
+#define TIMEREG_CR_3_CLOCK	(1 << 7)
+#define TIMEREG_CR_3_INT	(1 << 8)
+#define TIMEREG_CR_COUNT_UP	(1 << 9)
+#define TIMEREG_CR_COUNT_DOWN	(0 << 9)
+
+static void __iomem *base;
+static unsigned int clock_count_per_tick;
+
+static void moxart_clkevt_mode(enum clock_event_mode mode,
+			       struct clock_event_device *clk)
+{
+	u32 u = readl(base + TIMER_CR);
+
+	switch (mode) {
+	case CLOCK_EVT_MODE_RESUME:
+	case CLOCK_EVT_MODE_ONESHOT:
+		u &= ~TIMEREG_CR_1_ENABLE;
+		writel(u, base + TIMER_CR);
+		writel(~0, base + TIMER1_BASE + REG_LOAD);
+		break;
+	case CLOCK_EVT_MODE_PERIODIC:
+		writel(clock_count_per_tick, base + TIMER1_BASE + REG_LOAD);
+		u |= TIMEREG_CR_1_ENABLE;
+		writel(u, base + TIMER_CR);
+		break;
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+	default:
+		u &= ~TIMEREG_CR_1_ENABLE;
+		writel(u, base + TIMER_CR);
+		break;
+	}
+}
+
+static int moxart_clkevt_next_event(unsigned long cycles,
+				    struct clock_event_device *unused)
+{
+	u32 u;
+
+	u = readl(base + TIMER_CR) & ~TIMEREG_CR_1_ENABLE;
+	writel(u, base + TIMER_CR);
+	u = readl(base + TIMER1_BASE + REG_COUNT) - cycles;
+	writel(u, base + TIMER1_BASE + REG_MATCH1);
+	u = readl(base + TIMER_CR) | TIMEREG_CR_1_ENABLE;
+	writel(u, base + TIMER_CR);
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

