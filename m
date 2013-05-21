Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab3EUI1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 04:27:01 -0400
Received: from mail-db9lp0249.outbound.messaging.microsoft.com ([213.199.154.249]:35978
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751655Ab3EUI05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 04:26:57 -0400
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 May 2013 04:26:57 EDT
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 14
X-BigFish: VS14(zzc8kzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh11f642sz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
From: Jingchang Lu <b35083@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <john.stultz@linaro.org>,
        <tglx@linutronix.de>, <shawn.guo@linaro.org>, <s.hauer@pengutronix.de>,
        Jingchang Lu <b35083@freescale.com>
Subject: [PATCH v4] clocksource: add Vybrid Family pit timer support
Date: Tue, 21 May 2013 15:27:54 +0800
Message-ID: <1369121274-9371-1-git-send-email-b35083@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Freescale Vybrid Family period interrupt timer support.

Signed-off-by: Jingchang Lu <b35083@freescale.com>
---
v4:
  use family name names driver and symbol instead of SoC name.
  remove redundant code.
  use BUG_ON instead of WARN_ON.
  add necessory comment information.

 drivers/clocksource/Kconfig         |   5 +
 drivers/clocksource/Makefile        |   1 +
 drivers/clocksource/mvf_pit_timer.c | 187 ++++++++++++++++++++++++++++++++++++
 3 files changed, 193 insertions(+)
 create mode 100644 drivers/clocksource/mvf_pit_timer.c

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index f151c6c..4f3ca11 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -85,3 +85,8 @@ config CLKSRC_SAMSUNG_PWM
 	  Samsung S3C, S5P and Exynos SoCs, replacing an earlier driver
 	  for all devicetree enabled platforms. This driver will be
 	  needed only on systems that do not have the Exynos MCT available.
+
+config MVF_PIT_TIMER
+	bool
+	help
+	  Support for Period Interrupt Timer on Freescale Vybrid Family SoCs.
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 8d979c7..e28783c 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -26,6 +26,7 @@ obj-$(CONFIG_ARCH_BCM)		+= bcm_kona_timer.o
 obj-$(CONFIG_CADENCE_TTC_TIMER)	+= cadence_ttc_timer.o
 obj-$(CONFIG_CLKSRC_EXYNOS_MCT)	+= exynos_mct.o
 obj-$(CONFIG_CLKSRC_SAMSUNG_PWM)	+= samsung_pwm_timer.o
+obj-$(CONFIG_MVF_PIT_TIMER)	+= mvf_pit_timer.o
 
 obj-$(CONFIG_ARM_ARCH_TIMER)		+= arm_arch_timer.o
 obj-$(CONFIG_CLKSRC_METAG_GENERIC)	+= metag_generic.o
diff --git a/drivers/clocksource/mvf_pit_timer.c b/drivers/clocksource/mvf_pit_timer.c
new file mode 100644
index 0000000..34f4871
--- /dev/null
+++ b/drivers/clocksource/mvf_pit_timer.c
@@ -0,0 +1,187 @@
+/*
+ * Copyright 2012-2013 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ */
+
+#include <linux/interrupt.h>
+#include <linux/clockchips.h>
+#include <linux/clk.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <asm/sched_clock.h>
+
+/*
+ * Each pit takes 0x10 Bytes register space
+ */
+#define PITMCR		0x00
+#define PIT0_OFFSET	0x100
+#define PITn_OFFSET(n)	(PIT0_OFFSET + 0x10 * (n))
+#define PITLDVAL	0x00
+#define PITCVAL		0x04
+#define PITTCTRL	0x08
+#define PITTFLG		0x0c
+
+#define PITMCR_MDIS	(0x1 << 1)
+
+#define PITTCTRL_TEN	(0x1 << 0)
+#define PITTCTRL_TIE	(0x1 << 1)
+#define PITCTRL_CHN	(0x1 << 2)
+
+#define PITTFLG_TIF	0x1
+
+static void __iomem *clksrc_base;
+static void __iomem *clkevt_base;
+static unsigned long cycle_per_jiffy;
+
+static inline void pit_timer_enable(void)
+{
+	__raw_writel(PITTCTRL_TEN | PITTCTRL_TIE, clkevt_base + PITTCTRL);
+}
+
+static inline void pit_timer_disable(void)
+{
+	__raw_writel(0, clkevt_base + PITTCTRL);
+}
+
+static inline void pit_irq_acknowledge(void)
+{
+	__raw_writel(PITTFLG_TIF, clkevt_base + PITTFLG);
+}
+
+static unsigned int pit_read_sched_clock(void)
+{
+	return __raw_readl(clksrc_base + PITCVAL);
+}
+
+static int __init pit_clocksource_init(struct clk *pit_clk)
+{
+	unsigned int c = clk_get_rate(pit_clk);
+
+	/* set the max load value and start the clock source counter */
+	__raw_writel(0, clksrc_base + PITTCTRL);
+	__raw_writel(~0UL, clksrc_base + PITLDVAL);
+	__raw_writel(PITTCTRL_TEN, clksrc_base + PITTCTRL);
+
+	setup_sched_clock(pit_read_sched_clock, 32, c);
+	return clocksource_mmio_init(clksrc_base + PITCVAL, "mvf-pit", c,
+			300, 32, clocksource_mmio_readl_down);
+}
+
+static int pit_set_next_event(unsigned long delta,
+				struct clock_event_device *unused)
+{
+	/*
+	 * set a new value to PITLDVAL register will not restart the timer,
+	 * to abort the current cycle and start a timer period with the new
+	 * value, the timer must be disabled and enabled again.
+	 * and the PITLAVAL should be set to delta minus one.
+	 */
+	pit_timer_disable();
+	__raw_writel(delta - 1, clkevt_base + PITLDVAL);
+	pit_timer_enable();
+
+	return 0;
+}
+
+static void pit_set_mode(enum clock_event_mode mode,
+				struct clock_event_device *evt)
+{
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+		pit_timer_disable();
+		__raw_writel(cycle_per_jiffy - 1, clkevt_base + PITLDVAL);
+		pit_timer_enable();
+		break;
+	default:
+		break;
+	}
+}
+
+static irqreturn_t pit_timer_interrupt(int irq, void *dev_id)
+{
+	struct clock_event_device *evt = dev_id;
+
+	pit_irq_acknowledge();
+
+	/*
+	 * pit hardware doesn't support oneshot, it will generate an interrupt
+	 * and reload the counter value from PITLDVAL when PITCVAL reach zero,
+	 * and start the counter again. So software need to disable the timer
+	 * to stop the counter loop in ONESHOT mode.
+	 */
+	if (likely(evt->mode == CLOCK_EVT_MODE_ONESHOT))
+		pit_timer_disable();
+
+	evt->event_handler(evt);
+
+	return IRQ_HANDLED;
+}
+
+static struct clock_event_device clockevent_pit = {
+	.name		= "MVF pit timer",
+	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
+	.set_mode	= pit_set_mode,
+	.set_next_event	= pit_set_next_event,
+	.rating		= 300,
+};
+
+static struct irqaction pit_timer_irq = {
+	.name		= "MVF pit timer",
+	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.handler	= pit_timer_interrupt,
+	.dev_id		= &clockevent_pit,
+};
+
+static int __init pit_clockevent_init(struct clk *pit_clk, int irq)
+{
+	unsigned int c = clk_get_rate(pit_clk);
+
+	__raw_writel(0, clkevt_base + PITTCTRL);
+	__raw_writel(PITTFLG_TIF, clkevt_base + PITTFLG);
+
+	clockevent_pit.cpumask = cpumask_of(0);
+	clockevents_config_and_register(&clockevent_pit, c, 2, 0xffffffff);
+
+	BUG_ON(setup_irq(irq, &pit_timer_irq));
+
+	return 0;
+}
+
+static void __init pit_timer_init(struct device_node *np)
+{
+	struct clk *pit_clk;
+	void __iomem *timer_base;
+	int irq;
+
+	timer_base = of_iomap(np, 0);
+	BUG_ON(!timer_base);
+
+	/*
+	 * PIT0 and PIT1 can be chained to build a 64-bit timer,
+	 * so choose PIT2 as clocksource, PIT3 as clockevent device,
+	 * and leave PIT0 and PIT1 unused for anyone else who needs them.
+	 */
+	clksrc_base = timer_base + PITn_OFFSET(2);
+	clkevt_base = timer_base + PITn_OFFSET(3);
+
+	irq = irq_of_parse_and_map(np, 0);
+
+	pit_clk = of_clk_get(np, 0);
+	BUG_ON(IS_ERR(pit_clk));
+
+	BUG_ON(clk_prepare_enable(pit_clk));
+
+	cycle_per_jiffy = clk_get_rate(pit_clk)/(HZ);
+
+	/* enable the pit module */
+	__raw_writel(~PITMCR_MDIS, timer_base + PITMCR);
+
+	BUG_ON(pit_clocksource_init(pit_clk));
+
+	pit_clockevent_init(pit_clk, irq);
+}
+CLOCKSOURCE_OF_DECLARE(mvf600, "fsl,mvf600-pit", pit_timer_init);
-- 
1.8.0


