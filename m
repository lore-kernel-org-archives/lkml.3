Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933569AbaJ2Ovm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 10:51:42 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46418 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932962AbaJ2Ovj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 10:51:39 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        linux-tegra@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH 2/3] soc/tegra: add support for Tegra Activity Monitor
Date: Wed, 29 Oct 2014 15:50:12 +0100
Message-Id: <1414594232-15684-3-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1414594232-15684-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1414594232-15684-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ACTMON block can monitor several counters, providing averaging and firing
interrupts based on watermarking configuration. This implementation monitors
the MCALL and MCCPU counters to choose an appropriate frequency for the
external memory clock.

This patch is based on work by Alex Frid <afrid@nvidia.com> and Mikko
Perttunen <mikko.perttunen@kapsi.fi>.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 drivers/soc/tegra/Makefile |   1 +
 drivers/soc/tegra/actmon.c | 523 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 524 insertions(+)
 create mode 100644 drivers/soc/tegra/actmon.c

diff --git a/drivers/soc/tegra/Makefile b/drivers/soc/tegra/Makefile
index cdaad9d..00b08a0 100644
--- a/drivers/soc/tegra/Makefile
+++ b/drivers/soc/tegra/Makefile
@@ -2,3 +2,4 @@ obj-$(CONFIG_ARCH_TEGRA) += fuse/
 
 obj-$(CONFIG_ARCH_TEGRA) += common.o
 obj-$(CONFIG_ARCH_TEGRA) += pmc.o
+obj-$(CONFIG_ARCH_TEGRA) += actmon.o
diff --git a/drivers/soc/tegra/actmon.c b/drivers/soc/tegra/actmon.c
new file mode 100644
index 0000000..031c601
--- /dev/null
+++ b/drivers/soc/tegra/actmon.c
@@ -0,0 +1,523 @@
+/*
+ * A driver for the ACTMON block
+ *
+ * Copyright (c) 2014, NVIDIA CORPORATION. All rights reserved.
+ * Copyright (C) 2014 Google, Inc
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+
+#include <linux/clk.h>
+#include <linux/cpufreq.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/reset.h>
+
+#define ACTMON_GLB_STATUS					0x0
+#define ACTMON_GLB_PERIOD_CTRL					0x4
+
+#define ACTMON_DEV_CTRL						0x0
+#define ACTMON_DEV_CTRL_K_VAL_SHIFT				10
+#define ACTMON_DEV_CTRL_ENB_PERIODIC				BIT(18)
+#define ACTMON_DEV_CTRL_AVG_BELOW_WMARK_EN			BIT(20)
+#define ACTMON_DEV_CTRL_AVG_ABOVE_WMARK_EN			BIT(21)
+#define ACTMON_DEV_CTRL_CONSECUTIVE_BELOW_WMARK_NUM_SHIFT	23
+#define ACTMON_DEV_CTRL_CONSECUTIVE_ABOVE_WMARK_NUM_SHIFT	26
+#define ACTMON_DEV_CTRL_CONSECUTIVE_BELOW_WMARK_EN		BIT(29)
+#define ACTMON_DEV_CTRL_CONSECUTIVE_ABOVE_WMARK_EN		BIT(30)
+#define ACTMON_DEV_CTRL_ENB					BIT(31)
+
+#define ACTMON_DEV_UPPER_WMARK					0x4
+#define ACTMON_DEV_LOWER_WMARK					0x8
+#define ACTMON_DEV_INIT_AVG					0xc
+#define ACTMON_DEV_AVG_UPPER_WMARK				0x10
+#define ACTMON_DEV_AVG_LOWER_WMARK				0x14
+#define ACTMON_DEV_COUNT_WEIGHT					0x18
+#define ACTMON_DEV_AVG_COUNT					0x20
+#define ACTMON_DEV_INTR_STATUS					0x24
+
+#define ACTMON_DEV_INTR_CONSECUTIVE_UPPER			BIT(31)
+#define ACTMON_DEV_INTR_CONSECUTIVE_LOWER			BIT(30)
+
+#define ACTMON_ABOVE_WMARK_WINDOW				1
+#define ACTMON_BELOW_WMARK_WINDOW				3
+#define ACTMON_BOOST_FREQ_STEP					16000
+
+/* activity counter is incremented every 256 memory transactions, and each
+ * transaction takes 4 EMC clocks for Tegra124; So the COUNT_WEIGHT is
+ * 4 * 256 = 1024.
+ */
+#define ACTMON_COUNT_WEIGHT					0x400
+
+/*
+ * ACTMON_AVERAGE_WINDOW_LOG2: default value for @DEV_CTRL_K_VAL, which translates to
+ * 2 ^ (K_VAL + 1). ex: 2 ^ (6 + 1) = 128
+ */
+#define ACTMON_AVERAGE_WINDOW_LOG2				6
+#define ACTMON_SAMPLING_PERIOD					12	/* ms */
+#define ACTMON_DEFAULT_AVG_BAND					6	/* 1/10 of % */
+
+#define KHZ							1000
+
+/**
+ * struct tegra_actmon_device_config - configuration specific to an ACTMON device
+ *
+ * Coefficients and thresholds are in %
+ */
+struct tegra_actmon_device_config {
+	u32		offset;
+	u32		irq_mask;
+
+	unsigned int	boost_up_coeff;
+	unsigned int	boost_down_coeff;
+	unsigned int	boost_up_threshold;
+	unsigned int	boost_down_threshold;
+	u32		avg_dependency_threshold;
+};
+
+static struct tegra_actmon_device_config actmon_device_configs[] = {
+	{
+		/* MCALL */
+		.offset = 0x1c0,
+		.irq_mask = 1 << 26,
+		.boost_up_coeff = 200,
+		.boost_down_coeff = 50,
+		.boost_up_threshold = 60,
+		.boost_down_threshold = 40,
+	},
+	{
+		/* MCCPU */
+		.offset = 0x200,
+		.irq_mask = 1 << 25,
+		.boost_up_coeff = 800,
+		.boost_down_coeff = 90,
+		.boost_up_threshold = 27,
+		.boost_down_threshold = 10,
+		.avg_dependency_threshold = 50000,
+	},
+};
+
+/**
+ * struct tegra_actmon_device - state specific to an ACTMON device
+ *
+ * Frequencies are in kHz.
+ */
+struct tegra_actmon_device {
+	const struct tegra_actmon_device_config *config;
+
+	void __iomem	*regs;
+	u32		avg_band_freq;
+	u32		avg_count;
+
+	unsigned long	target_freq;
+	unsigned long	boost_freq;
+};
+
+struct tegra_actmon {
+	struct platform_device	*pdev;
+	struct reset_control	*reset;
+	struct clk		*clock;
+	void __iomem		*regs;
+	spinlock_t		lock;
+
+	struct clk		*emc_clock;
+	unsigned long		max_freq;
+	unsigned long		cur_freq;
+	struct notifier_block	rate_change_nb;
+
+	struct tegra_actmon_device devices[ARRAY_SIZE(actmon_device_configs)];
+};
+
+struct tegra_actmon_emc_ratio {
+	unsigned long cpu_freq;
+	unsigned long emc_freq;
+};
+
+static struct tegra_actmon_emc_ratio actmon_emc_ratios[] = {
+	{ 1400000, ULONG_MAX },
+	{ 1200000,    750000 },
+	{ 1100000,    600000 },
+	{ 1000000,    500000 },
+	{  800000,    375000 },
+	{  500000,    200000 },
+	{  250000,    100000 },
+};
+
+static unsigned long do_percent(unsigned long val, unsigned int pct)
+{
+	return val * pct / 100;
+}
+
+static void tegra_actmon_update_avg_wmark(struct tegra_actmon_device *dev)
+{
+	u32 avg = dev->avg_count;
+	u32 band = dev->avg_band_freq * ACTMON_SAMPLING_PERIOD;
+
+	writel(avg + band, dev->regs + ACTMON_DEV_AVG_UPPER_WMARK);
+	avg = max(avg, band);
+	writel(avg - band, dev->regs + ACTMON_DEV_AVG_LOWER_WMARK);
+}
+
+static void tegra_actmon_update_wmark(struct tegra_actmon *tegra, struct tegra_actmon_device *dev)
+{
+	u32 val = tegra->cur_freq * ACTMON_SAMPLING_PERIOD;
+
+	writel(do_percent(val, dev->config->boost_up_threshold),
+	       dev->regs + ACTMON_DEV_UPPER_WMARK);
+
+	writel(do_percent(val, dev->config->boost_down_threshold),
+	       dev->regs + ACTMON_DEV_LOWER_WMARK);
+}
+
+static void actmon_write_barrier(struct tegra_actmon *tegra)
+{
+	/* ensure the update has reached the ACTMON */
+	wmb();
+	readl(tegra->regs + ACTMON_GLB_STATUS);
+}
+
+irqreturn_t actmon_isr(int irq, void *data)
+{
+	struct tegra_actmon *tegra = data;
+	struct tegra_actmon_device *dev = NULL;
+	unsigned long flags;
+	u32 val;
+	int i;
+
+	val = readl(tegra->regs + ACTMON_GLB_STATUS);
+
+	for (i = 0; i < ARRAY_SIZE(tegra->devices); ++i) {
+		if (val & tegra->devices[i].config->irq_mask) {
+			dev = tegra->devices + i;
+			break;
+		}
+	}
+
+	if (!dev)
+		return IRQ_NONE;
+
+	spin_lock_irqsave(&tegra->lock, flags);
+
+	dev->avg_count = readl(dev->regs + ACTMON_DEV_AVG_COUNT);
+	tegra_actmon_update_avg_wmark(dev);
+
+	val = readl(dev->regs + ACTMON_DEV_INTR_STATUS);
+	if (val & ACTMON_DEV_INTR_CONSECUTIVE_UPPER) {
+		val = readl(dev->regs + ACTMON_DEV_CTRL) |
+			ACTMON_DEV_CTRL_CONSECUTIVE_ABOVE_WMARK_EN |
+			ACTMON_DEV_CTRL_CONSECUTIVE_BELOW_WMARK_EN;
+
+		/*
+		 * new_boost = min(old_boost * up_coef + step, max_freq)
+		 */
+		dev->boost_freq = ACTMON_BOOST_FREQ_STEP +
+			do_percent(dev->boost_freq, dev->config->boost_up_coeff);
+		if (dev->boost_freq >= tegra->max_freq) {
+			dev->boost_freq = tegra->max_freq;
+			val &= ~ACTMON_DEV_CTRL_CONSECUTIVE_ABOVE_WMARK_EN;
+		}
+		writel(val, dev->regs + ACTMON_DEV_CTRL);
+	} else if (val & ACTMON_DEV_INTR_CONSECUTIVE_LOWER) {
+		val = readl(dev->regs + ACTMON_DEV_CTRL) |
+			ACTMON_DEV_CTRL_CONSECUTIVE_ABOVE_WMARK_EN |
+			ACTMON_DEV_CTRL_CONSECUTIVE_BELOW_WMARK_EN;
+
+		/*
+		 * new_boost = old_boost * down_coef
+		 * or 0 if (old_boost * down_coef < step / 2)
+		 */
+		dev->boost_freq =
+			do_percent(dev->boost_freq, dev->config->boost_down_coeff);
+		if (dev->boost_freq < (ACTMON_BOOST_FREQ_STEP >> 1)) {
+			dev->boost_freq = 0;
+			val &= ~ACTMON_DEV_CTRL_CONSECUTIVE_BELOW_WMARK_EN;
+		}
+		writel(val, dev->regs + ACTMON_DEV_CTRL);
+	}
+
+	if (dev->config->avg_dependency_threshold) {
+		val = readl(dev->regs + ACTMON_DEV_CTRL);
+		if (dev->avg_count >= dev->config->avg_dependency_threshold)
+			val |= ACTMON_DEV_CTRL_CONSECUTIVE_BELOW_WMARK_EN;
+		else if (dev->boost_freq == 0)
+			val &= ~ACTMON_DEV_CTRL_CONSECUTIVE_BELOW_WMARK_EN;
+		writel(val, dev->regs + ACTMON_DEV_CTRL);
+	}
+
+	writel(0xffffffff, dev->regs + ACTMON_DEV_INTR_STATUS);
+
+	actmon_write_barrier(tegra);
+
+	spin_unlock_irqrestore(&tegra->lock, flags);
+
+	return IRQ_WAKE_THREAD;
+}
+
+static unsigned long actmon_cpu_to_emc_rate(struct tegra_actmon *tegra, unsigned long cpu_freq)
+{
+	int i;
+	struct tegra_actmon_emc_ratio *ratio = actmon_emc_ratios;
+
+	for (i = 0; i < ARRAY_SIZE(actmon_emc_ratios); i++, ratio++) {
+		if (cpu_freq >= ratio->cpu_freq) {
+			if (ratio->emc_freq >= tegra->max_freq)
+				return tegra->max_freq;
+			else
+				return ratio->emc_freq;
+		}
+	}
+
+	return 0;
+}
+
+static void actmon_update_target(struct tegra_actmon *tegra, struct tegra_actmon_device *dev)
+{
+	unsigned long cpu_freq = 0;
+	unsigned long static_cpu_emc_freq = 0;
+	unsigned int avg_sustain_coef;
+	unsigned long flags;
+
+	if (dev->config->avg_dependency_threshold) {
+		cpu_freq = cpufreq_get(0);
+		static_cpu_emc_freq = actmon_cpu_to_emc_rate(tegra, cpu_freq);
+	}
+
+	spin_lock_irqsave(&tegra->lock, flags);
+
+	dev->target_freq = dev->avg_count / ACTMON_SAMPLING_PERIOD;
+	avg_sustain_coef = 100 * 100 / dev->config->boost_up_threshold;
+	dev->target_freq = do_percent(dev->target_freq, avg_sustain_coef);
+	dev->target_freq += dev->boost_freq;
+
+	if (dev->avg_count >= dev->config->avg_dependency_threshold)
+		dev->target_freq = max(dev->target_freq, static_cpu_emc_freq);
+
+	dev->target_freq = dev->target_freq < 102000 ? 102000 : dev->target_freq;
+
+	spin_unlock_irqrestore(&tegra->lock, flags);
+}
+
+irqreturn_t actmon_thread_isr(int irq, void *data)
+{
+	struct tegra_actmon *tegra = data;
+	struct tegra_actmon_device *dev = NULL;
+	unsigned long target_freq = 0;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(tegra->devices); ++i) {
+		dev = tegra->devices + i;
+
+		actmon_update_target(tegra, dev);
+
+		/* TODO: Once we have per-user clks, set one floor freq for each device */
+		target_freq = max(target_freq, dev->target_freq);
+	}
+
+	clk_set_rate(tegra->emc_clock, target_freq * KHZ);
+
+	return IRQ_HANDLED;
+}
+
+static int tegra_actmon_rate_notify_cb(struct notifier_block *nb,
+				       unsigned long action, void *ptr)
+{
+	struct clk_notifier_data *data = ptr;
+	struct tegra_actmon *tegra = container_of(nb, struct tegra_actmon,
+						  rate_change_nb);
+	int i;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tegra->lock, flags);
+
+	switch (action) {
+	case POST_RATE_CHANGE:
+		tegra->cur_freq = data->new_rate / KHZ;
+
+		for (i = 0; i < ARRAY_SIZE(tegra->devices); ++i)
+			tegra_actmon_update_wmark(tegra, tegra->devices + i);
+
+		actmon_write_barrier(tegra);
+		break;
+	case PRE_RATE_CHANGE:
+		/* fall through */
+	case ABORT_RATE_CHANGE:
+		break;
+	};
+
+	spin_unlock_irqrestore(&tegra->lock, flags);
+	return NOTIFY_OK;
+}
+
+static void tegra_actmon_configure_device(struct tegra_actmon *tegra,
+					  struct tegra_actmon_device *dev)
+{
+	u32 val;
+
+	dev->avg_band_freq = tegra->max_freq * ACTMON_DEFAULT_AVG_BAND / KHZ;
+	dev->target_freq = tegra->cur_freq;
+
+	dev->avg_count = tegra->cur_freq * ACTMON_SAMPLING_PERIOD;
+	writel(dev->avg_count, dev->regs + ACTMON_DEV_INIT_AVG);
+
+	tegra_actmon_update_avg_wmark(dev);
+	tegra_actmon_update_wmark(tegra, dev);
+
+	writel(ACTMON_COUNT_WEIGHT, dev->regs + ACTMON_DEV_COUNT_WEIGHT);
+
+	writel(0xffffffff, dev->regs + ACTMON_DEV_INTR_STATUS);
+
+	val = 0;
+	val |= ACTMON_DEV_CTRL_ENB_PERIODIC |
+	       ACTMON_DEV_CTRL_AVG_ABOVE_WMARK_EN |
+	       ACTMON_DEV_CTRL_AVG_BELOW_WMARK_EN;
+	val |= (ACTMON_AVERAGE_WINDOW_LOG2 - 1)
+		<< ACTMON_DEV_CTRL_K_VAL_SHIFT;
+	val |= (ACTMON_BELOW_WMARK_WINDOW - 1)
+		<< ACTMON_DEV_CTRL_CONSECUTIVE_BELOW_WMARK_NUM_SHIFT;
+	val |= (ACTMON_ABOVE_WMARK_WINDOW - 1)
+		<< ACTMON_DEV_CTRL_CONSECUTIVE_ABOVE_WMARK_NUM_SHIFT;
+	val |= ACTMON_DEV_CTRL_CONSECUTIVE_BELOW_WMARK_EN |
+	       ACTMON_DEV_CTRL_CONSECUTIVE_ABOVE_WMARK_EN;
+
+	writel(val, dev->regs + ACTMON_DEV_CTRL);
+
+	actmon_write_barrier(tegra);
+
+	val = readl(dev->regs + ACTMON_DEV_CTRL);
+	val |= ACTMON_DEV_CTRL_ENB;
+	writel(val, dev->regs + ACTMON_DEV_CTRL);
+
+	actmon_write_barrier(tegra);
+}
+
+static int tegra_actmon_probe(struct platform_device *pdev)
+{
+	struct tegra_actmon *tegra;
+	struct tegra_actmon_device *dev;
+	unsigned long max_freq;
+	int i;
+	int irq;
+	int err;
+
+	tegra = devm_kzalloc(&pdev->dev, sizeof(*tegra), GFP_KERNEL);
+	if (!tegra)
+		return -ENOMEM;
+
+	spin_lock_init(&tegra->lock);
+
+	tegra->regs = devm_ioremap_resource(&pdev->dev, platform_get_resource(pdev, IORESOURCE_MEM, 0));
+	if (IS_ERR(tegra->regs)) {
+		dev_err(&pdev->dev, "Failed to get IO memory\n");
+		return PTR_ERR(tegra->regs);
+	}
+
+	tegra->reset = devm_reset_control_get(&pdev->dev, "actmon");
+	if (IS_ERR(tegra->reset)) {
+		dev_err(&pdev->dev, "Failed to get reset\n");
+		return PTR_ERR(tegra->reset);
+	}
+
+	tegra->clock = devm_clk_get(&pdev->dev, "actmon");
+	if (IS_ERR(tegra->clock)) {
+		dev_err(&pdev->dev, "Failed to get actmon clock\n");
+		return PTR_ERR(tegra->clock);
+	}
+
+	tegra->emc_clock = devm_clk_get(&pdev->dev, "emc");
+	if (IS_ERR(tegra->emc_clock)) {
+		dev_err(&pdev->dev, "Failed to get emc clock\n");
+		return PTR_ERR(tegra->emc_clock);
+	}
+
+	tegra->rate_change_nb.notifier_call = tegra_actmon_rate_notify_cb;
+	err = clk_notifier_register(tegra->emc_clock, &tegra->rate_change_nb);
+	if (err) {
+		dev_err(&pdev->dev,
+			"Failed to register rate change notifier\n");
+		return err;
+	}
+
+	reset_control_assert(tegra->reset);
+
+	err = clk_prepare_enable(tegra->clock);
+	if (err) {
+		reset_control_deassert(tegra->reset);
+		return err;
+	}
+
+	reset_control_deassert(tegra->reset);
+
+	max_freq = clk_round_rate(tegra->emc_clock, ULONG_MAX);
+	tegra->max_freq = max_freq / KHZ;
+
+	clk_set_rate(tegra->emc_clock, max_freq);
+
+	tegra->cur_freq = clk_get_rate(tegra->emc_clock) / KHZ;
+
+	writel(ACTMON_SAMPLING_PERIOD - 1, tegra->regs + ACTMON_GLB_PERIOD_CTRL);
+
+	for (i = 0; i < ARRAY_SIZE(actmon_device_configs); ++i) {
+		dev = tegra->devices + i;
+		dev->config = actmon_device_configs + i;
+		dev->regs = tegra->regs + dev->config->offset;
+
+		tegra_actmon_configure_device(tegra, tegra->devices + i);
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	err = devm_request_threaded_irq(&pdev->dev, irq, actmon_isr,
+					actmon_thread_isr, IRQF_SHARED,
+					"tegra-actmon", tegra);
+	if (err) {
+		dev_err(&pdev->dev, "Interrupt request failed\n");
+		return err;
+	}
+
+	platform_set_drvdata(pdev, tegra);
+
+	dev_info(&pdev->dev, "probed\n");
+
+	return 0;
+}
+
+static int tegra_actmon_remove(struct platform_device *pdev)
+{
+	struct tegra_actmon *tegra = platform_get_drvdata(pdev);
+
+	clk_disable_unprepare(tegra->clock);
+
+	return 0;
+}
+
+static struct of_device_id tegra_actmon_of_match[] = {
+	{ .compatible = "nvidia,tegra124-actmon" },
+	{ },
+};
+
+static struct platform_driver tegra_actmon_driver = {
+	.probe	= tegra_actmon_probe,
+	.remove	= tegra_actmon_remove,
+	.driver = {
+		.name	= "tegra-actmon",
+		.owner = THIS_MODULE,
+		.of_match_table = tegra_actmon_of_match,
+	},
+};
+module_platform_driver(tegra_actmon_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Tegra ACTMON driver");
+MODULE_DEVICE_TABLE(of, tegra_actmon_of_match);
-- 
1.9.3

