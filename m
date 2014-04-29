Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbaD2DDm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 23:03:42 -0400
Received: from mail-bn1blp0189.outbound.protection.outlook.com ([207.46.163.189]:1602
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753128AbaD2DDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 23:03:39 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <daniel.lezcano@linaro.org>, <tglx@linutronix.de>, <shawn.guo@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>,
        Jingchang Lu <b35083@freescale.com>
Subject: [PATCHv3 3/3] clocksource: Add Freescale FlexTimer Module (FTM) timer support
Date: Tue, 29 Apr 2014 10:18:59 +0800
Message-ID: <1398737939-5334-4-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1398737939-5334-1-git-send-email-Li.Xiubo@freescale.com>
References: <1398737939-5334-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.1;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(44976005)(6806004)(19580405001)(19580395003)(80976001)(83322001)(99396002)(36756003)(50466002)(89996001)(81542001)(85852003)(81342001)(83072002)(92726001)(86362001)(93916002)(92566001)(62966002)(575784001)(76176999)(48376002)(50226001)(87286001)(77096999)(88136002)(50986999)(74502001)(77982001)(46102001)(101416001)(31966008)(80022001)(77156001)(87936001)(4396001)(76482001)(79102001)(20776003)(47776003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB509;H:tx30smr01.am.freescale.net;FPR:EC8FE4E5.9032D5ED.52D5AE7F.5CD90A30.20679;MLV:sfv;PTR:gate-tx3.freescale.com;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 0196A226D1
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Freescale FlexTimer Module time reference is a 16-bit counter
that can be used as an unsigned or signed increase counter.

CNTIN defines the starting value of the count and MOD defines the
final value of the count. The value of CNTIN is loaded into the FTM
counter, and the counter increments until the value of MOD is reached,
at which point the counter is reloaded with the value of CNTIN. That's
also when an overflow interrupt will be generated.

Here using the 'evt' prefix or postfix as clock event device and
the 'src' as clock source device.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Jingchang Lu <b35083@freescale.com>
---
 drivers/clocksource/Kconfig         |   5 +
 drivers/clocksource/Makefile        |   1 +
 drivers/clocksource/fsl_ftm_timer.c | 344 ++++++++++++++++++++++++++++++++++++
 3 files changed, 350 insertions(+)
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
index 0000000..7f6246a
--- /dev/null
+++ b/drivers/clocksource/fsl_ftm_timer.c
@@ -0,0 +1,344 @@
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
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/sched_clock.h>
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
+#define FTM_CNTIN	0x4C
+
+static void __iomem *clksrc_base;
+static void __iomem *clkevt_base;
+static unsigned long peroidic_cyc;
+static unsigned long ps;
+bool big_endian;
+
+static inline u32 ftm_readl(void __iomem *addr)
+{
+	if (big_endian)
+		return ioread32be(addr);
+	else
+		return ioread32(addr);
+}
+
+static inline void ftm_writel(u32 val, void __iomem *addr)
+{
+	if (big_endian)
+		iowrite32be(val, addr);
+	else
+		iowrite32(val, addr);
+}
+
+static inline void ftm_counter_enable(void __iomem *base)
+{
+	u32 val;
+
+	/* select and enable counter clock source */
+	val = ftm_readl(base + FTM_SC);
+	val &= ~(FTM_SC_PS_MASK | FTM_SC_CLK_MASK);
+	val |= ps | FTM_SC_CLK(1);
+	ftm_writel(val, base + FTM_SC);
+}
+
+static inline void ftm_counter_disable(void __iomem *base)
+{
+	u32 val;
+
+	/* disable counter clock source */
+	val = ftm_readl(base + FTM_SC);
+	val &= ~(FTM_SC_PS_MASK | FTM_SC_CLK_MASK);
+	ftm_writel(val, base + FTM_SC);
+}
+
+static inline void ftm_irq_acknowledge(void __iomem *base)
+{
+	u32 val;
+
+	val = ftm_readl(base + FTM_SC);
+	val &= ~FTM_SC_TOF;
+	ftm_writel(val, base + FTM_SC);
+}
+
+static inline void ftm_irq_enable(void __iomem *base)
+{
+	u32 val;
+
+	val = ftm_readl(base + FTM_SC);
+	val |= FTM_SC_TOIE;
+	ftm_writel(val, base + FTM_SC);
+}
+
+static inline void ftm_irq_disable(void __iomem *base)
+{
+	u32 val;
+
+	val = ftm_readl(base + FTM_SC);
+	val &= ~FTM_SC_TOIE;
+	ftm_writel(val, base + FTM_SC);
+}
+
+static inline void ftm_reset_counter(void __iomem *base)
+{
+	/*
+	 * The CNT register contains the FTM counter value.
+	 * Reset clears the CNT register. Writing any value to COUNT
+	 * updates the counter with its initial value, CNTIN.
+	 */
+	ftm_writel(0x00, base + FTM_CNT);
+}
+
+static u64 ftm_read_sched_clock(void)
+{
+	return ftm_readl(clksrc_base + FTM_CNT);
+}
+
+static int ftm_set_next_event(unsigned long delta,
+				struct clock_event_device *unused)
+{
+	/*
+	 * The CNNIN and MOD are all double buffer registers, writing
+	 * to the MOD register latches the value into a buffer. The MOD
+	 * register is updated with the value of its write buffer with
+	 * the following scenario:
+	 * a, the counter source clock is diabled.
+	 */
+	ftm_counter_disable(clkevt_base);
+
+	/* Force the value of CNTIN to be loaded into the FTM counter */
+	ftm_reset_counter(clkevt_base);
+
+	/*
+	 * The counter increments until the value of MOD is reached,
+	 * at which point the counter is reloaded with the value of CNTIN.
+	 * The TOF (the overflow flag) bit is set when the FTM counter
+	 * changes from MOD to CNTIN. So we should using the delta - 1.
+	 */
+	ftm_writel(delta - 1, clkevt_base + FTM_MOD);
+
+	ftm_counter_enable(clkevt_base);
+
+	ftm_irq_enable(clkevt_base);
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
+	case CLOCK_EVT_MODE_ONESHOT:
+		ftm_counter_disable(clkevt_base);
+		break;
+	default:
+		return;
+	}
+}
+
+static irqreturn_t ftm_evt_interrupt(int irq, void *dev_id)
+{
+	struct clock_event_device *evt = dev_id;
+
+	ftm_irq_acknowledge(clkevt_base);
+
+	if (likely(evt->mode == CLOCK_EVT_MODE_ONESHOT)) {
+		ftm_irq_disable(clkevt_base);
+		ftm_counter_disable(clkevt_base);
+	}
+
+	evt->event_handler(evt);
+
+	return IRQ_HANDLED;
+}
+
+static struct clock_event_device ftm_clockevent = {
+	.name		= "Freescale ftm timer",
+	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
+	.set_mode	= ftm_set_mode,
+	.set_next_event	= ftm_set_next_event,
+	.rating		= 300,
+};
+
+static struct irqaction ftm_timer_irq = {
+	.name		= "Freescale ftm timer",
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
+	.handler	= ftm_evt_interrupt,
+	.dev_id		= &ftm_clockevent,
+};
+
+static int __init ftm_clockevent_init(unsigned long freq, int irq)
+{
+	int err;
+
+	ftm_writel(0x00, clkevt_base + FTM_CNTIN);
+	ftm_writel(~0UL, clkevt_base + FTM_MOD);
+
+	ftm_reset_counter(clkevt_base);
+
+	err = setup_irq(irq, &ftm_timer_irq);
+	if (err) {
+		pr_err("ftm: setup irq failed: %d\n", err);
+		return err;
+	}
+
+	ftm_clockevent.cpumask = cpumask_of(0);
+	ftm_clockevent.irq = irq;
+
+	clockevents_config_and_register(&ftm_clockevent, freq / (1 << ps),
+					1, 0xffff);
+
+	ftm_counter_enable(clkevt_base);
+
+	return 0;
+}
+
+static int __init ftm_clocksource_init(unsigned long freq)
+{
+	int err;
+
+	ftm_writel(0x00, clksrc_base + FTM_CNTIN);
+	ftm_writel(~0UL, clksrc_base + FTM_MOD);
+
+	ftm_reset_counter(clksrc_base);
+
+	sched_clock_register(ftm_read_sched_clock, 16, freq / (1 << ps));
+	err = clocksource_mmio_init(clksrc_base + FTM_CNT, "fsl-ftm",
+				    freq / (1 << ps), 300, 16,
+				    clocksource_mmio_readl_up);
+	if (err) {
+		pr_err("ftm: init clock source mmio failed: %d\n", err);
+		return err;
+	}
+
+	ftm_counter_enable(clksrc_base);
+
+	return 0;
+}
+
+static int __init __ftm_clk_init(struct device_node *np, char *cnt_name,
+				 char *ftm_name)
+{
+	struct clk *clk;
+	int err;
+
+	clk = of_clk_get_by_name(np, cnt_name);
+	if (IS_ERR(clk)) {
+		pr_err("ftm: Cannot get \"%s\": %ld\n", cnt_name, PTR_ERR(clk));
+		return PTR_ERR(clk);
+	}
+	err = clk_prepare_enable(clk);
+	if (err) {
+		pr_err("ftm: clock failed to prepare+enable \"%s\": %d\n",
+			cnt_name, err);
+		return err;
+	}
+
+	clk = of_clk_get_by_name(np, ftm_name);
+	if (IS_ERR(clk)) {
+		pr_err("ftm: Cannot get \"%s\": %ld\n", ftm_name, PTR_ERR(clk));
+		return PTR_ERR(clk);
+	}
+	err = clk_prepare_enable(clk);
+	if (err)
+		pr_err("ftm: clock failed to prepare+enable \"%s\": %d\n",
+			ftm_name, err);
+
+	return clk_get_rate(clk);
+}
+
+static unsigned long __init ftm_clk_init(struct device_node *np)
+{
+	unsigned long freq;
+
+	freq = __ftm_clk_init(np, "ftm-evt-counter-en", "ftm-evt");
+	if (freq <= 0)
+		return 0;
+
+	freq = __ftm_clk_init(np, "ftm-src-counter-en", "ftm-src");
+	if (freq <= 0)
+		return 0;
+
+	return freq;
+}
+
+static int __init ftm_calc_closest_round_cyc(unsigned long freq)
+{
+	ps = 0;
+
+	do {
+		peroidic_cyc = DIV_ROUND_CLOSEST(freq, HZ * (1 << ps++));
+	} while (peroidic_cyc > 0xFFFF);
+
+	if (ps > 7) {
+		pr_err("ftm: the max prescaler is %lu > 7\n", ps);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void __init ftm_timer_init(struct device_node *np)
+{
+	unsigned long freq;
+	int irq;
+
+	clkevt_base = of_iomap(np, 0);
+	if (!clkevt_base) {
+		pr_err("ftm: unable to map event timer registers\n");
+		return;
+	}
+
+	clksrc_base = of_iomap(np, 1);
+	if (!clksrc_base) {
+		pr_err("ftm: unable to map source timer registers\n");
+		return;
+	}
+
+	irq = irq_of_parse_and_map(np, 0);
+	if (irq <= 0) {
+		pr_err("ftm: unable to get IRQ from DT, %d\n", irq);
+		return;
+	}
+
+	big_endian = of_property_read_bool(np, "big-endian");
+
+	freq = ftm_clk_init(np);
+	if (!freq)
+		return;
+
+	if (ftm_calc_closest_round_cyc(freq))
+		return;
+
+	if (ftm_clocksource_init(freq))
+		return;
+
+	if (ftm_clockevent_init(freq, irq))
+		return;
+}
+CLOCKSOURCE_OF_DECLARE(flextimer, "fsl,ftm-timer", ftm_timer_init);
-- 
1.8.4

