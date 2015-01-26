Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbbAZH5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 02:57:46 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:57356 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213AbbAZH5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 02:57:33 -0500
From: Baruch Siach <baruch@tkos.co.il>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH v4 2/2] clocksource: driver for Conexant Digicolor SoC timer
Date: Mon, 26 Jan 2015 09:56:11 +0200
Message-Id: <d2d06d04f8ee8acb62e7748b42c3177229de478a.1422256855.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <cover.1422256855.git.baruch@tkos.co.il>
References: <cover.1422256855.git.baruch@tkos.co.il>
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
 drivers/clocksource/timer-digicolor.c | 170 ++++++++++++++++++++++++++++++++++
 2 files changed, 171 insertions(+)
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
index 000000000000..c97ea7eac4a5
--- /dev/null
+++ b/drivers/clocksource/timer-digicolor.c
@@ -0,0 +1,170 @@
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
+#define CONTROL_DISABLE		0
+#define CONTROL_ENABLE		BIT(0)
+#define CONTROL_MODE(m)		((m) << 4)
+#define CONTROL_MODE_ONESHOT	CONTROL_MODE(1)
+#define CONTROL_MODE_PERIODIC	CONTROL_MODE(2)
+
+static struct dc_dev_t {
+	void __iomem *timer_base;
+	u32 ticks_per_jiffy;
+} dc_dev;
+
+static void digicolor_clkevt_mode(enum clock_event_mode mode,
+				  struct clock_event_device *clk)
+{
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+		writeb(CONTROL_DISABLE, dc_dev.timer_base + CONTROL(TIMER_C));
+		writel(dc_dev.ticks_per_jiffy,
+		       dc_dev.timer_base + COUNT(TIMER_C));
+		writeb(CONTROL_ENABLE | CONTROL_MODE_PERIODIC,
+		       dc_dev.timer_base + CONTROL(TIMER_C));
+		break;
+	case CLOCK_EVT_MODE_ONESHOT:
+		writeb(CONTROL_DISABLE, dc_dev.timer_base + CONTROL(TIMER_C));
+		writeb(CONTROL_ENABLE | CONTROL_MODE_ONESHOT,
+		       dc_dev.timer_base + CONTROL(TIMER_C));
+		break;
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+	default:
+		writeb(CONTROL_DISABLE, dc_dev.timer_base + CONTROL(TIMER_C));
+		break;
+	}
+}
+
+static int digicolor_clkevt_next_event(unsigned long evt,
+				       struct clock_event_device *unused)
+{
+	writeb(CONTROL_DISABLE, dc_dev.timer_base + CONTROL(TIMER_C));
+	writel(evt, dc_dev.timer_base + COUNT(TIMER_C));
+	writeb(CONTROL_ENABLE | CONTROL_MODE_ONESHOT,
+	       dc_dev.timer_base + CONTROL(TIMER_C));
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
+static irqreturn_t digicolor_timer_interrupt(int irq, void *dev_id)
+{
+	struct clock_event_device *evt = dev_id;
+
+	evt->event_handler(evt);
+
+	return IRQ_HANDLED;
+}
+
+static u64 digicolor_timer_sched_read(void)
+{
+	return ~readl(dc_dev.timer_base + COUNT(TIMER_B));
+}
+
+static void __init digicolor_timer_init(struct device_node *node)
+{
+	unsigned long rate;
+	struct clk *clk;
+	int ret, irq;
+
+	dc_dev.timer_base =
+		of_io_request_and_map(node, 0, of_node_full_name(node));
+	if (!dc_dev.timer_base) {
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
+	dc_dev.ticks_per_jiffy = DIV_ROUND_UP(rate, HZ);
+
+	writeb(CONTROL_DISABLE, dc_dev.timer_base + CONTROL(TIMER_B));
+	writel(UINT_MAX, dc_dev.timer_base + COUNT(TIMER_B));
+	writeb(CONTROL_ENABLE, dc_dev.timer_base + CONTROL(TIMER_B));
+
+	sched_clock_register(digicolor_timer_sched_read, 32, rate);
+	clocksource_mmio_init(dc_dev.timer_base + COUNT(TIMER_B), node->name,
+			      rate, 340, 32, clocksource_mmio_readl_down);
+
+	ret = request_irq(irq, digicolor_timer_interrupt,
+			  IRQF_TIMER | IRQF_IRQPOLL, "digicolor_timerC",
+			  &digicolor_clockevent);
+	if (ret)
+		pr_warn("request of timer irq %d failed (%d)\n", irq, ret);
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

