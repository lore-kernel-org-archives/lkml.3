Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbaGQGIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 02:08:49 -0400
Received: from regular2.263xmail.com ([211.157.152.3]:34714 "EHLO
	regular2.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603AbaGQGIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 02:08:46 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: wxt@rock-chips.com
X-FST-TO: thierry.reding@gmail.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: wxt@rock-chips.com
X-UNIQUE-TAG: <e8c4334f94945b004bd43f3588e603fb>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: caesar <caesar.wang@rock-chips.com>
To: thierry.reding@gmail.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org
Cc: linux-pwm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        cf@rock-chips.com, addy.ke@rock-chips.com, xjq@rock-chips.com,
        huangtao@rock-chips.com, hj@rock-chips.com,
        caesar <caesar.wang@rock-chips.com>
Subject: [PATCH 2/2] pwm: add this series patch to support for rk-pwm and vop-pwm.
Date: Thu, 17 Jul 2014 14:08:14 +0800
Message-Id: <1405577294-19336-3-git-send-email-caesar.wang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405577294-19336-1-git-send-email-caesar.wang@rock-chips.com>
References: <1405577294-19336-1-git-send-email-caesar.wang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: caesar <caesar.wang@rock-chips.com>
---
 drivers/pwm/pwm-rockchip.c | 108 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 88 insertions(+), 20 deletions(-)

diff --git a/drivers/pwm/pwm-rockchip.c b/drivers/pwm/pwm-rockchip.c
index eec2145..59b0380 100644
--- a/drivers/pwm/pwm-rockchip.c
+++ b/drivers/pwm/pwm-rockchip.c
@@ -2,6 +2,7 @@
  * PWM driver for Rockchip SoCs
  *
  * Copyright (C) 2014 Beniamino Galvani <b.galvani@gmail.com>
+ * Copyright (C) 2014 Caesar Wang <caesar.wang@rock-chips.com>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -12,6 +13,8 @@
 #include <linux/io.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/of_address.h>
 #include <linux/platform_device.h>
 #include <linux/pwm.h>
 #include <linux/time.h>
@@ -23,14 +26,37 @@
 #define PWM_CTRL_TIMER_EN	(1 << 0)
 #define PWM_CTRL_OUTPUT_EN	(1 << 3)
 
+#define RK_PRESCALER		1
 #define PRESCALER		2
 
+#define PWM_CONTINUOUS		(1 << 1)
+#define PWM_DUTY_POSITIVE		(1 << 3)
+#define PWM_INACTIVE_NEGATIVE		(0 << 4)
+#define PWM_OUTPUT_LEFT		(0 << 5)
+#define PWM_LP_DISABLE		(0 << 8)
+
+#define RK_PWM_ENABLE		(1 << 0)
+
+#define VOP_PWM_CTRL		0x00		/* VOP-PWM Control Register */
+#define VOP_PWM_CNTR		0x0c
+
+
 struct rockchip_pwm_chip {
 	struct pwm_chip chip;
 	struct clk *clk;
+	const struct rockchip_pwm_data *data;
 	void __iomem *base;
 };
 
+struct rockchip_pwm_data {
+	u32 duty;
+	u32 period;
+	u32 reg_cntr;
+	u32 reg_ctrl;
+	int prescaler;
+	u32 enable_conf;
+};
+
 static inline struct rockchip_pwm_chip *to_rockchip_pwm_chip(struct pwm_chip *c)
 {
 	return container_of(c, struct rockchip_pwm_chip, chip);
@@ -52,20 +78,20 @@ static int rockchip_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
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
+	writel(period, pc->base + pc->data->period);
+	writel(duty, pc->base + pc->data->duty);
+	writel(0, pc->base + pc->data->reg_cntr);
 
 	clk_disable(pc->clk);
 
@@ -82,9 +108,9 @@ static int rockchip_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 	if (ret)
 		return ret;
 
-	val = readl_relaxed(pc->base + PWM_CTRL);
-	val |= PWM_CTRL_OUTPUT_EN | PWM_CTRL_TIMER_EN;
-	writel_relaxed(val, pc->base + PWM_CTRL);
+	val = readl_relaxed(pc->base + pc->data->reg_ctrl);
+	val |= pc->data->enable_conf;
+	writel_relaxed(val, pc->base + pc->data->reg_ctrl);
 
 	return 0;
 }
@@ -94,9 +120,9 @@ static void rockchip_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 	struct rockchip_pwm_chip *pc = to_rockchip_pwm_chip(chip);
 	u32 val;
 
-	val = readl_relaxed(pc->base + PWM_CTRL);
-	val &= ~(PWM_CTRL_OUTPUT_EN | PWM_CTRL_TIMER_EN);
-	writel_relaxed(val, pc->base + PWM_CTRL);
+	val = readl_relaxed(pc->base + pc->data->reg_ctrl);
+	val &= ~pc->data->enable_conf;
+	writel_relaxed(val, pc->base + pc->data->reg_ctrl);
 
 	clk_disable(pc->clk);
 }
@@ -108,8 +134,48 @@ static const struct pwm_ops rockchip_pwm_ops = {
 	.owner = THIS_MODULE,
 };
 
+static struct rockchip_pwm_data pwm_data_v1 = {
+	.duty = PWM_HRC,
+	.period = PWM_LRC,
+	.reg_cntr = PWM_CNTR,
+	.reg_ctrl = PWM_CTRL,
+	.prescaler = PRESCALER,
+	.enable_conf = PWM_CTRL_OUTPUT_EN | PWM_CTRL_TIMER_EN,
+};
+
+static struct rockchip_pwm_data pwm_data_v2 = {
+	.duty = PWM_LRC,
+	.period = PWM_HRC,
+	.reg_cntr = PWM_CNTR,
+	.reg_ctrl = PWM_CTRL,
+	.prescaler = RK_PRESCALER,
+	.enable_conf = PWM_OUTPUT_LEFT | PWM_LP_DISABLE | RK_PWM_ENABLE |
+		PWM_CONTINUOUS | PWM_DUTY_POSITIVE | PWM_INACTIVE_NEGATIVE,
+};
+
+static struct rockchip_pwm_data pwm_data_vop = {
+	.duty = PWM_LRC,
+	.period = PWM_HRC,
+	.reg_cntr = VOP_PWM_CNTR,
+	.reg_ctrl = VOP_PWM_CTRL,
+	.prescaler = RK_PRESCALER,
+	.enable_conf = PWM_OUTPUT_LEFT | PWM_LP_DISABLE | RK_PWM_ENABLE |
+		PWM_CONTINUOUS | PWM_DUTY_POSITIVE | PWM_INACTIVE_NEGATIVE,
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
+	const struct of_device_id *of_id =
+	    of_match_device(rockchip_pwm_dt_ids, &pdev->dev);
+	struct device_node *np = pdev->dev.of_node;
 	struct rockchip_pwm_chip *pc;
 	struct resource *r;
 	int ret;
@@ -119,9 +185,12 @@ static int rockchip_pwm_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	pc->base = devm_ioremap_resource(&pdev->dev, r);
-	if (IS_ERR(pc->base))
-		return PTR_ERR(pc->base);
+	pc->base = of_iomap(np, 0);
+	if (!pc->base) {
+		dev_err(&pdev->dev, "failed to map controller\n");
+		ret = -ENOMEM;
+		goto fail_map;
+	}
 
 	pc->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(pc->clk))
@@ -133,6 +202,7 @@ static int rockchip_pwm_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, pc);
 
+	pc->data = of_id->data;
 	pc->chip.dev = &pdev->dev;
 	pc->chip.ops = &rockchip_pwm_ops;
 	pc->chip.base = -1;
@@ -145,6 +215,10 @@ static int rockchip_pwm_probe(struct platform_device *pdev)
 	}
 
 	return ret;
+
+fail_map:
+	iounmap(pc->base);
+	return ret;
 }
 
 static int rockchip_pwm_remove(struct platform_device *pdev)
@@ -156,12 +230,6 @@ static int rockchip_pwm_remove(struct platform_device *pdev)
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


