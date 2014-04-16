Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaDPDDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 23:03:46 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:5314 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751342AbaDPDCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 23:02:51 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zze0eahc8kzz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzdchz1de098h8275bh8275dh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh26d3h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <daniel.lezcano@linaro.org>, <tglx@linutronix.de>, <shawn.guo@linaro.org>,
        <b35083@freescale.com>, <r64188@freescale.com>, <b40534@freescale.com>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [RFC][PATCH 3/3] clocksource: Add Freescale FlexTimer Module (FTM) timer support
Date: Wed, 16 Apr 2014 10:19:47 +0800
Message-ID: <1397614787-8300-4-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1397614787-8300-1-git-send-email-Li.Xiubo@freescale.com>
References: <1397614787-8300-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Freescale FlexTimer Module time reference is a 16-bit counter
that can be used as an unsigned or signed counter.one 16-bits
increase counter.

Here using the FTM0 as clock event device and the FTM1 as clock
source device.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Jingchang Lu <b35083@freescale.com>
---
 drivers/clocksource/Kconfig         |   5 +
 drivers/clocksource/Makefile        |   1 +
 drivers/clocksource/fsl_ftm_timer.c | 238 ++++++++++++++++++++++++++++++++++++
 3 files changed, 244 insertions(+)
 create mode 100644 drivers/clocksource/fsl_ftm_timer.c

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index cd6950f..28321c5 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -136,6 +136,11 @@ config CLKSRC_SAMSUNG_PWM
 	  for all devicetree enabled platforms. This driver will be
 	  needed only on systems that do not have the Exynos MCT available.
 
+config FSL_FTM_TIMER
+	bool
+	help
+	  Support for Freescale FlexTimer Module (FTM) timer.
+
 config VF_PIT_TIMER
 	bool
 	help
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index c7ca50a..ce0a967 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -31,6 +31,7 @@ obj-$(CONFIG_CADENCE_TTC_TIMER)	+= cadence_ttc_timer.o
 obj-$(CONFIG_CLKSRC_EFM32)	+= time-efm32.o
 obj-$(CONFIG_CLKSRC_EXYNOS_MCT)	+= exynos_mct.o
 obj-$(CONFIG_CLKSRC_SAMSUNG_PWM)	+= samsung_pwm_timer.o
+obj-$(CONFIG_FSL_FTM_TIMER)	+= fsl_ftm_timer.o
 obj-$(CONFIG_VF_PIT_TIMER)	+= vf_pit_timer.o
 
 obj-$(CONFIG_ARM_ARCH_TIMER)		+= arm_arch_timer.o
diff --git a/drivers/clocksource/fsl_ftm_timer.c b/drivers/clocksource/fsl_ftm_timer.c
new file mode 100644
index 0000000..988449e
--- /dev/null
+++ b/drivers/clocksource/fsl_ftm_timer.c
@@ -0,0 +1,238 @@
+/*
+ * Freescale FlexTimer Module (FTM) timer driver.
+ *
+ * Copyright 2014 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ */
+
+#include <linux/clk.h>
+#include <linux/clockchips.h>
+#include <linux/clocksource.h>
+#include <linux/err.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/sched_clock.h>
+
+#define FTM_OFFSET(n)	(0x1000 * n)
+
+#define FTM_SC		0x00
+#define FTM_SC_CLK_SHIFT	3
+#define FTM_SC_CLK_MASK	(0x3 << FTM_SC_CLK_SHIFT)
+#define FTM_SC_CLK(c)	((c) << FTM_SC_CLK_SHIFT)
+#define FTM_SC_PS_MASK	0x7
+#define FTM_SC_TOIE	BIT(6)
+#define FTM_SC_TOF	BIT(7)
+
+#define FTM_CNT		0x04
+#define FTM_MOD		0x08
+
+#define FTM_CSC_BASE	0x0C
+#define FTM_CSC_MSB	BIT(5)
+#define FTM_CSC_MSA	BIT(4)
+#define FTM_CSC_ELSB	BIT(3)
+#define FTM_CSC_ELSA	BIT(2)
+
+#define FTM_CV_BASE	0x10
+#define FTM_CNTIN	0x4C
+#define FTM_STATUS	0x50
+
+#define FTM_MODE	0x54
+#define FTM_MODE_FTMEN	BIT(0)
+#define FTM_MODE_WPDIS	BIT(2)
+#define FTM_MODE_PWMSYNC	BIT(3)
+
+#define FTM_SYNC	0x58
+#define FTM_OUTINIT	0x5C
+#define FTM_OUTMASK	0x60
+#define FTM_COMBINE	0x64
+#define FTM_DEADTIME	0x68
+#define FTM_EXTTRIG	0x6C
+#define FTM_POL		0x70
+#define FTM_FMS		0x74
+#define FTM_FILTER	0x78
+#define FTM_FLTCTRL	0x7C
+#define FTM_QDCTRL	0x80
+#define FTM_CONF	0x84
+#define FTM_FLTPOL	0x88
+#define FTM_SYNCONF	0x8C
+#define FTM_INVCTRL	0x90
+#define FTM_SWOCTRL	0x94
+#define FTM_PWMLOAD	0x98
+
+static void __iomem *clksrc_base;
+static void __iomem *clkevt_base;
+static unsigned long peroidic_cyc;
+
+static inline void __init ftm_timer_enable(void __iomem *base)
+{
+	u32 val;
+
+	/* select and enable counter clock source */
+	val = __raw_readl(base + FTM_SC);
+	val &= ~FTM_SC_CLK_MASK;
+	val |= FTM_SC_CLK(1);
+	__raw_writel(val, base + FTM_SC);
+}
+
+static u64 ftm_read_sched_clock(void)
+{
+	return __raw_readl(clksrc_base + FTM_CNT);
+}
+
+static int __init ftm_clocksource_init(unsigned long freq)
+{
+	int ret;
+
+	__raw_writel(0x00, clksrc_base + FTM_CNTIN);
+	__raw_writel(~0UL, clksrc_base + FTM_MOD);
+	__raw_writel(0x1, clksrc_base + FTM_CNT);
+
+	sched_clock_register(ftm_read_sched_clock, 16, freq);
+	ret = clocksource_mmio_init(clksrc_base + FTM_CNT, "fsl-ftm",
+				freq, 300, 16, clocksource_mmio_readl_up);
+	if (ret)
+		return ret;
+
+	ftm_timer_enable(clksrc_base);
+
+	return 0;
+}
+
+static inline void ftm_irq_acknowledge(void)
+{
+	u32 val;
+
+	val = __raw_readl(clkevt_base + FTM_SC);
+	val &= ~FTM_SC_TOF;
+	__raw_writel(val, clkevt_base + FTM_SC);
+}
+
+static int ftm_set_next_event(unsigned long delta,
+				struct clock_event_device *unused)
+{
+	__raw_writel(delta, clkevt_base + FTM_MOD);
+
+	return 0;
+}
+
+static void ftm_set_mode(enum clock_event_mode mode,
+				struct clock_event_device *evt)
+{
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+		ftm_set_next_event(peroidic_cyc, evt);
+		break;
+	default:
+		break;
+	}
+}
+
+static irqreturn_t ftm_timer_interrupt(int irq, void *dev_id)
+{
+	struct clock_event_device *evt = dev_id;
+
+	ftm_irq_acknowledge();
+
+	evt->event_handler(evt);
+
+	return IRQ_HANDLED;
+}
+
+static struct clock_event_device clockevent_ftm = {
+	.name		= "Freescale ftm timer",
+	.features	= CLOCK_EVT_FEAT_PERIODIC,
+	.set_mode	= ftm_set_mode,
+	.set_next_event	= ftm_set_next_event,
+	.rating		= 300,
+};
+
+static struct irqaction ftm_timer_irq = {
+	.name		= "Freescale ftm timer",
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
+	.handler	= ftm_timer_interrupt,
+	.dev_id		= &clockevent_ftm,
+};
+
+static int __init ftm_clockevent_init(unsigned long freq, int irq)
+{
+	u32 val;
+
+	__raw_writel(0x00, clkevt_base + FTM_CNTIN);
+	__raw_writel(~0UL, clkevt_base + FTM_MOD);
+	__raw_writel(0x1, clksrc_base + FTM_CNT);
+
+	val = __raw_readl(clkevt_base + FTM_SC);
+	val |= FTM_SC_TOIE;
+	__raw_writel(val, clkevt_base + FTM_SC);
+
+	BUG_ON(setup_irq(irq, &ftm_timer_irq));
+
+	clockevent_ftm.cpumask = cpumask_of(0);
+	clockevent_ftm.irq = irq;
+
+	clockevents_config_and_register(&clockevent_ftm, freq, 1, 0xffff);
+
+	ftm_timer_enable(clkevt_base);
+
+	return 0;
+}
+
+static void __init calc_closest_cound_cyc(unsigned long freq)
+{
+	unsigned long ps = 0;
+
+	do {
+		peroidic_cyc = DIV_ROUND_CLOSEST(freq, HZ * (1 << ps++));
+	} while (peroidic_cyc > 0xFFFF);
+
+}
+
+static void __init ftm_timer_init(struct device_node *np)
+{
+	struct clk *ftm_clk;
+	void __iomem *timer_base;
+	unsigned long freq;
+	int irq;
+
+	timer_base = of_iomap(np, 0);
+	BUG_ON(!timer_base);
+
+	clksrc_base = timer_base + FTM_OFFSET(1);
+	clkevt_base = timer_base + FTM_OFFSET(0);
+
+	irq = irq_of_parse_and_map(np, 0);
+	BUG_ON(irq <= 0);
+
+	ftm_clk = of_clk_get_by_name(np, "ftm0_counter_en");
+	BUG_ON(IS_ERR(ftm_clk));
+	BUG_ON(clk_prepare_enable(ftm_clk));
+
+	ftm_clk = of_clk_get_by_name(np, "ftm1_counter_en");
+	BUG_ON(IS_ERR(ftm_clk));
+	BUG_ON(clk_prepare_enable(ftm_clk));
+
+	ftm_clk = of_clk_get_by_name(np, "ftm0");
+	BUG_ON(IS_ERR(ftm_clk));
+	BUG_ON(clk_prepare_enable(ftm_clk));
+
+	ftm_clk = of_clk_get_by_name(np, "ftm1");
+	BUG_ON(IS_ERR(ftm_clk));
+	BUG_ON(clk_prepare_enable(ftm_clk));
+
+	freq = clk_get_rate(ftm_clk);
+
+	calc_closest_cound_cyc(freq);
+
+	BUG_ON(ftm_clocksource_init(freq));
+
+	BUG_ON(ftm_clockevent_init(freq, irq));
+}
+CLOCKSOURCE_OF_DECLARE(vf610, "fsl,vf610-ftm-timer", ftm_timer_init);
-- 
1.8.4


