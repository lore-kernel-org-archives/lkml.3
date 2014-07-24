Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964789AbaGXKW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:22:26 -0400
Received: from regular1.263xmail.com ([211.150.99.140]:52898 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934594AbaGXKVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 06:21:50 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: wxt@rock-chips.com
X-FST-TO: thierry.reding@gmail.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: wxt@rock-chips.com
X-UNIQUE-TAG: <8648407cf2c623a302283926c90e5daf>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Caesar Wang <caesar.wang@rock-chips.com>
To: thierry.reding@gmail.com, heiko@sntech.de, b.galvani@gmail.com,
        robh+dt@kernel.org, ijc+devicetree@hellion.org.uk,
        rdunlap@infradead.org, galak@codeaurora.org
Cc: cf@rock-chips.com, huangtao@rock-chips.com, xjq@rock-chips.com,
        addy.ke@rock-chips.com, cjf@rock-chips.com, hj@rock-chips.com,
        linux-arm-kernel@lists.infradead.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, Caesar Wang <caesar.wang@rock-chips.com>
Subject: [PATCH v4 2/2] pwm: rockchip: Added to support for RK3288 SoC
Date: Thu, 24 Jul 2014 18:21:35 +0800
Message-Id: <1406197295-10604-3-git-send-email-caesar.wang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406197295-10604-1-git-send-email-caesar.wang@rock-chips.com>
References: <1406197295-10604-1-git-send-email-caesar.wang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch added to support the PWM controller found on
RK3288 SoC.

Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
---
 drivers/pwm/pwm-rockchip.c | 124 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 105 insertions(+), 19 deletions(-)

diff --git a/drivers/pwm/pwm-rockchip.c b/drivers/pwm/pwm-rockchip.c
index eec2145..59c2513 100644
--- a/drivers/pwm/pwm-rockchip.c
+++ b/drivers/pwm/pwm-rockchip.c
@@ -2,6 +2,7 @@
  * PWM driver for Rockchip SoCs
  *
  * Copyright (C) 2014 Beniamino Galvani <b.galvani@gmail.com>
+ * Copyright (C) 2014 ROCKCHIP, Inc.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -12,6 +13,7 @@
 #include <linux/io.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/pwm.h>
 #include <linux/time.h>
@@ -25,17 +27,72 @@
 
 #define PRESCALER		2
 
+#define PWM_ENABLE		(1 << 0)
+#define PWM_CONTINUOUS		(1 << 1)
+#define PWM_DUTY_POSITIVE	(1 << 3)
+#define PWM_INACTIVE_NEGATIVE	(0 << 4)
+#define PWM_OUTPUT_LEFT		(0 << 5)
+#define PWM_LP_DISABLE		(0 << 8)
+
 struct rockchip_pwm_chip {
 	struct pwm_chip chip;
 	struct clk *clk;
+	const struct rockchip_pwm_data *data;
 	void __iomem *base;
 };
 
+struct rockchip_pwm_regs {
+	unsigned long duty;
+	unsigned long period;
+	unsigned long cntr;
+	unsigned long ctrl;
+};
+
+struct rockchip_pwm_data {
+	struct rockchip_pwm_regs regs;
+	unsigned int prescaler;
+
+	void (*set_enable)(struct pwm_chip *chip, bool enable);
+};
+
 static inline struct rockchip_pwm_chip *to_rockchip_pwm_chip(struct pwm_chip *c)
 {
 	return container_of(c, struct rockchip_pwm_chip, chip);
 }
 
+static void rockchip_pwm_set_enable_v1(struct pwm_chip *chip, bool enable)
+{
+	struct rockchip_pwm_chip *pc = to_rockchip_pwm_chip(chip);
+	u32 val = 0;
+	u32 enable_conf = PWM_CTRL_OUTPUT_EN | PWM_CTRL_TIMER_EN;
+
+	val = readl_relaxed(pc->base + pc->data->regs.ctrl);
+
+	if (enable)
+		val |= enable_conf;
+	else
+		val &= ~enable_conf;
+
+	writel_relaxed(val, pc->base + pc->data->regs.ctrl);
+}
+
+static void rockchip_pwm_set_enable_v2(struct pwm_chip *chip, bool enable)
+{
+	struct rockchip_pwm_chip *pc = to_rockchip_pwm_chip(chip);
+	u32 val = 0;
+	u32 enable_conf = PWM_OUTPUT_LEFT | PWM_LP_DISABLE | PWM_ENABLE |
+		PWM_CONTINUOUS | PWM_DUTY_POSITIVE | PWM_INACTIVE_NEGATIVE;
+
+	val = readl_relaxed(pc->base + pc->data->regs.ctrl);
+
+	if (enable)
+		val |= enable_conf;
+	else
+		val &= ~enable_conf;
+
+	writel_relaxed(val, pc->base + pc->data->regs.ctrl);
+}
+
 static int rockchip_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 			       int duty_ns, int period_ns)
 {
@@ -52,20 +109,20 @@ static int rockchip_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	 * default prescaler value for all practical clock rate values.
 	 */
 	div = clk_rate * period_ns;
-	do_div(div, PRESCALER * NSEC_PER_SEC);
+	do_div(div, pc->data->prescaler * NSEC_PER_SEC);
 	period = div;
 
 	div = clk_rate * duty_ns;
-	do_div(div, PRESCALER * NSEC_PER_SEC);
+	do_div(div, pc->data->prescaler * NSEC_PER_SEC);
 	duty = div;
 
 	ret = clk_enable(pc->clk);
 	if (ret)
 		return ret;
 
-	writel(period, pc->base + PWM_LRC);
-	writel(duty, pc->base + PWM_HRC);
-	writel(0, pc->base + PWM_CNTR);
+	writel(period, pc->base + pc->data->regs.period);
+	writel(duty, pc->base + pc->data->regs.duty);
+	writel(0, pc->base + pc->data->regs.cntr);
 
 	clk_disable(pc->clk);
 
@@ -76,15 +133,12 @@ static int rockchip_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct rockchip_pwm_chip *pc = to_rockchip_pwm_chip(chip);
 	int ret;
-	u32 val;
 
 	ret = clk_enable(pc->clk);
 	if (ret)
 		return ret;
 
-	val = readl_relaxed(pc->base + PWM_CTRL);
-	val |= PWM_CTRL_OUTPUT_EN | PWM_CTRL_TIMER_EN;
-	writel_relaxed(val, pc->base + PWM_CTRL);
+	pc->data->set_enable(chip, true);
 
 	return 0;
 }
@@ -92,11 +146,8 @@ static int rockchip_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 static void rockchip_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct rockchip_pwm_chip *pc = to_rockchip_pwm_chip(chip);
-	u32 val;
 
-	val = readl_relaxed(pc->base + PWM_CTRL);
-	val &= ~(PWM_CTRL_OUTPUT_EN | PWM_CTRL_TIMER_EN);
-	writel_relaxed(val, pc->base + PWM_CTRL);
+	pc->data->set_enable(chip, false);
 
 	clk_disable(pc->clk);
 }
@@ -108,12 +159,52 @@ static const struct pwm_ops rockchip_pwm_ops = {
 	.owner = THIS_MODULE,
 };
 
+static const struct rockchip_pwm_data pwm_data_v1 = {
+	.regs.duty = PWM_HRC,
+	.regs.period = PWM_LRC,
+	.regs.cntr = PWM_CNTR,
+	.regs.ctrl = PWM_CTRL,
+	.prescaler = PRESCALER,
+	.set_enable = rockchip_pwm_set_enable_v1,
+};
+
+static const struct rockchip_pwm_data pwm_data_v2 = {
+	.regs.duty = PWM_LRC,
+	.regs.period = PWM_HRC,
+	.regs.cntr = PWM_CNTR,
+	.regs.ctrl = PWM_CTRL,
+	.prescaler = PRESCALER-1,
+	.set_enable = rockchip_pwm_set_enable_v2,
+};
+
+static const struct rockchip_pwm_data pwm_data_vop = {
+	.regs.duty = PWM_LRC,
+	.regs.period = PWM_HRC,
+	.regs.cntr = PWM_CTRL,
+	.regs.ctrl = PWM_CNTR,
+	.prescaler = PRESCALER-1,
+	.set_enable = rockchip_pwm_set_enable_v2,
+};
+
+static const struct of_device_id rockchip_pwm_dt_ids[] = {
+	{ .compatible = "rockchip,rk2928-pwm", .data = &pwm_data_v1},
+	{ .compatible = "rockchip,rk3288-pwm", .data = &pwm_data_v2},
+	{ .compatible = "rockchip,vop-pwm", .data = &pwm_data_vop},
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, rockchip_pwm_dt_ids);
+
 static int rockchip_pwm_probe(struct platform_device *pdev)
 {
+	const struct of_device_id *id;
 	struct rockchip_pwm_chip *pc;
 	struct resource *r;
 	int ret;
 
+	id = of_match_device(rockchip_pwm_dt_ids, &pdev->dev);
+	if (!id)
+		return -EINVAL;
+
 	pc = devm_kzalloc(&pdev->dev, sizeof(*pc), GFP_KERNEL);
 	if (!pc)
 		return -ENOMEM;
@@ -133,6 +224,7 @@ static int rockchip_pwm_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, pc);
 
+	pc->data = id->data;
 	pc->chip.dev = &pdev->dev;
 	pc->chip.ops = &rockchip_pwm_ops;
 	pc->chip.base = -1;
@@ -156,12 +248,6 @@ static int rockchip_pwm_remove(struct platform_device *pdev)
 	return pwmchip_remove(&pc->chip);
 }
 
-static const struct of_device_id rockchip_pwm_dt_ids[] = {
-	{ .compatible = "rockchip,rk2928-pwm" },
-	{ /* sentinel */ }
-};
-MODULE_DEVICE_TABLE(of, rockchip_pwm_dt_ids);
-
 static struct platform_driver rockchip_pwm_driver = {
 	.driver = {
 		.name = "rockchip-pwm",
-- 
1.9.1


