Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbbAUGgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 01:36:44 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:43164 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbbAUGgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 01:36:41 -0500
From: Baruch Siach <baruch@tkos.co.il>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH v3 2/2] clocksource: driver for Conexant Digicolor SoC timer
Date: Wed, 21 Jan 2015 08:36:29 +0200
Message-Id: <762d81b2cf12922ba28fb58b3ea4d5b7072abefb.1421821466.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <cover.1421821466.git.baruch@tkos.co.il>
References: <cover.1421821466.git.baruch@tkos.co.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add clocksource driver to the Conexant CX92755 SoC, part of the Digicolor SoCs
series. Hardware provides 8 timers, A to H. Timer A is dedicated to a future
watchdog driver so we don't use it here. Use timer B for sched_clock, and timer
C for clock_event.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 drivers/clocksource/Makefile          |   1 +
 drivers/clocksource/timer-digicolor.c | 164 ++++++++++++++++++++++++++++++++++
 2 files changed, 165 insertions(+)
 create mode 100644 drivers/clocksource/timer-digicolor.c

diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 94d90b24b56b..a993c108be67 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_SH_TIMER_TMU)	+= sh_tmu.o
 obj-$(CONFIG_EM_TIMER_STI)	+= em_sti.o
 obj-$(CONFIG_CLKBLD_I8253)	+= i8253.o
 obj-$(CONFIG_CLKSRC_MMIO)	+= mmio.o
+obj-$(CONFIG_ARCH_DIGICOLOR)	+= timer-digicolor.o
 obj-$(CONFIG_DW_APB_TIMER)	+= dw_apb_timer.o
 obj-$(CONFIG_DW_APB_TIMER_OF)	+= dw_apb_timer_of.o
 obj-$(CONFIG_CLKSRC_NOMADIK_MTU)	+= nomadik-mtu.o
diff --git a/drivers/clocksource/timer-digicolor.c b/drivers/clocksource/timer-digicolor.c
new file mode 100644
index 000000000000..014c50675980
--- /dev/null
+++ b/drivers/clocksource/timer-digicolor.c
@@ -0,0 +1,164 @@
+/*
+ * Conexant Digicolor timer driver
+ *
+ * Author: Baruch Siach <baruch@tkos.co.il>
+ *
+ * Copyright (C) 2014 Paradox Innovation Ltd.
+ *
+ * Based on:
+ *	Allwinner SoCs hstimer driver
+ *
+ * Copyright (C) 2013 Maxime Ripard
+ *
+ * Maxime Ripard <maxime.ripard@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+/*
+ * Conexant Digicolor SoCs have 8 configurable timers, named from "Timer A" to
+ * "Timer H". Timer A is the only one with watchdog support, so it is dedicated
+ * to the watchdog driver. This driver uses Timer B for sched_clock(), and
+ * Timer C for clockevents.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/clk.h>
+#include <linux/clockchips.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/irqreturn.h>
+#include <linux/sched_clock.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+
+enum {
+	TIMER_A,
+	TIMER_B,
+	TIMER_C,
+	TIMER_D,
+	TIMER_E,
+	TIMER_F,
+	TIMER_G,
+	TIMER_H,
+};
+
+#define CONTROL(t)	((t)*8)
+#define COUNT(t)	((t)*8 + 4)
+
+static void __iomem *timer_base;
+static u32 ticks_per_jiffy;
+
+static void digicolor_clkevt_mode(enum clock_event_mode mode,
+				  struct clock_event_device *clk)
+{
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+		writeb(0, timer_base + CONTROL(TIMER_C));
+		writel(ticks_per_jiffy, timer_base + COUNT(TIMER_C));
+		writeb(0x21, timer_base + CONTROL(TIMER_C));
+		break;
+	case CLOCK_EVT_MODE_ONESHOT:
+		writeb(0, timer_base + CONTROL(TIMER_C));
+		writeb(0x11, timer_base + CONTROL(TIMER_C));
+		break;
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+	default:
+		writeb(0, timer_base + CONTROL(TIMER_C));
+		break;
+	}
+}
+
+static int digicolor_clkevt_next_event(unsigned long evt,
+				       struct clock_event_device *unused)
+{
+	writeb(0, timer_base + CONTROL(TIMER_C));
+	writel(evt, timer_base + COUNT(TIMER_C));
+	writeb(0x11, timer_base + CONTROL(TIMER_C));
+
+	return 0;
+}
+
+static struct clock_event_device digicolor_clockevent = {
+	.name = "digicolor_tick",
+	.rating = 340,
+	.features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
+	.set_mode = digicolor_clkevt_mode,
+	.set_next_event = digicolor_clkevt_next_event,
+};
+
+
+static irqreturn_t digicolor_timer_interrupt(int irq, void *dev_id)
+{
+	struct clock_event_device *evt = (struct clock_event_device *)dev_id;
+
+	evt->event_handler(evt);
+
+	return IRQ_HANDLED;
+}
+
+static struct irqaction digicolor_timer_irq = {
+	.name = "digicolor_timerC",
+	.flags = IRQF_TIMER | IRQF_IRQPOLL,
+	.handler = digicolor_timer_interrupt,
+	.dev_id = &digicolor_clockevent,
+};
+
+static u64 digicolor_timer_sched_read(void)
+{
+	return ~readl(timer_base + COUNT(TIMER_B));
+}
+
+static void __init digicolor_timer_init(struct device_node *node)
+{
+	unsigned long rate;
+	struct clk *clk;
+	int ret, irq;
+
+	timer_base = of_iomap(node, 0);
+	if (!timer_base) {
+		pr_err("Can't map registers");
+		return;
+	}
+
+	irq = irq_of_parse_and_map(node, TIMER_C);
+	if (irq <= 0) {
+		pr_err("Can't parse IRQ");
+		return;
+	}
+
+	clk = of_clk_get(node, 0);
+	if (IS_ERR(clk)) {
+		pr_err("Can't get timer clock");
+		return;
+	}
+	clk_prepare_enable(clk);
+	rate = clk_get_rate(clk);
+
+	writeb(0, timer_base + CONTROL(TIMER_B));
+	writel(~0, timer_base + COUNT(TIMER_B));
+	writeb(1, timer_base + CONTROL(TIMER_B));
+
+	sched_clock_register(digicolor_timer_sched_read, 32, rate);
+	clocksource_mmio_init(timer_base + COUNT(TIMER_B), node->name,
+			      rate, 340, 32, clocksource_mmio_readl_down);
+
+	ticks_per_jiffy = DIV_ROUND_UP(rate, HZ);
+
+	ret = setup_irq(irq, &digicolor_timer_irq);
+	if (ret)
+		pr_warn("failed to setup timer irq %d (%d)\n", irq, ret);
+
+	digicolor_clockevent.cpumask = cpu_possible_mask;
+	digicolor_clockevent.irq = irq;
+
+	clockevents_config_and_register(&digicolor_clockevent, rate, 0,
+					0xffffffff);
+}
+CLOCKSOURCE_OF_DECLARE(conexant_digicolor, "cnxt,cx92755-timer",
+		       digicolor_timer_init);
-- 
2.1.4

