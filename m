Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818AbaIFQZZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 12:25:25 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:49541 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaIFQZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 12:25:16 -0400
X-Amavis-Alert: BAD HEADER, Duplicate header field: "In-Reply-To"
From: Stefan Agner <stefan@agner.ch>
To: linus.walleij@linaro.org, gnurou@gmail.com, shawn.guo@freescale.com,
        kernel@pengutronix.de
Cc: linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stefan@agner.ch
Subject: [PATCH 2/4] pinctrl: imx: add gpio pinmux support for vf610
Date: Sat,  6 Sep 2014 18:25:05 +0200
Message-Id: <4cf96e22ce2c7646513b64260c7bb1a2279e232d.1410020459.git.stefan@agner.ch>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1410020458.git.stefan@agner.ch>
References: <cover.1410020458.git.stefan@agner.ch>
In-Reply-To: <cover.1410020458.git.stefan@agner.ch>
References: <cover.1410020458.git.stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pinmux support for GPIO for Vybrid (vf610) IOMUX controller.
This is needed since direction configuration is not part of the
GPIO module in Vybrid.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 drivers/pinctrl/pinctrl-imx.c   | 54 +++++++++++++++++++++++++++++++++++++++++
 drivers/pinctrl/pinctrl-imx.h   |  1 +
 drivers/pinctrl/pinctrl-vf610.c |  4 +--
 3 files changed, 57 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-imx.c b/drivers/pinctrl/pinctrl-imx.c
index 0d4558b..64d1b59 100644
--- a/drivers/pinctrl/pinctrl-imx.c
+++ b/drivers/pinctrl/pinctrl-imx.c
@@ -294,10 +294,59 @@ static int imx_pmx_get_groups(struct pinctrl_dev *pctldev, unsigned selector,
 	return 0;
 }
 
+static int imx_pmx_gpio_request_enable(struct pinctrl_dev *pctldev,
+			struct pinctrl_gpio_range *range, unsigned offset)
+{
+	struct imx_pinctrl *ipctl = pinctrl_dev_get_drvdata(pctldev);
+	const struct imx_pinctrl_soc_info *info = ipctl->info;
+	const struct imx_pin_reg *pin_reg;
+	u32 reg;
+
+	if (!(info->flags & GPIO_CONTROL))
+		return -EINVAL;
+
+	pin_reg = &info->pin_regs[offset];
+	if (pin_reg->mux_reg == -1)
+		return -EINVAL;
+
+	reg = readl(ipctl->base + pin_reg->mux_reg);
+	reg &= ~(0x7 << 20);
+	writel(reg, ipctl->base + pin_reg->mux_reg);
+
+	return 0;
+}
+
+static int imx_pmx_gpio_set_direction(struct pinctrl_dev *pctldev,
+	   struct pinctrl_gpio_range *range, unsigned offset, bool input)
+{
+	struct imx_pinctrl *ipctl = pinctrl_dev_get_drvdata(pctldev);
+	const struct imx_pinctrl_soc_info *info = ipctl->info;
+	const struct imx_pin_reg *pin_reg;
+	u32 reg;
+
+	if (!(info->flags & GPIO_CONTROL))
+		return -EINVAL;
+
+	pin_reg = &info->pin_regs[offset];
+	if (pin_reg->mux_reg == -1)
+		return -EINVAL;
+
+	reg = readl(ipctl->base + pin_reg->mux_reg);
+	if (input)
+		reg &= ~0x2;
+	else
+		reg |= 0x2;
+	writel(reg, ipctl->base + pin_reg->mux_reg);
+
+	return 0;
+}
+
 static const struct pinmux_ops imx_pmx_ops = {
 	.get_functions_count = imx_pmx_get_funcs_count,
 	.get_function_name = imx_pmx_get_func_name,
 	.get_function_groups = imx_pmx_get_groups,
+	.gpio_request_enable = imx_pmx_gpio_request_enable,
+	.gpio_set_direction = imx_pmx_gpio_set_direction,
 	.enable = imx_pmx_enable,
 };
 
@@ -579,6 +628,11 @@ int imx_pinctrl_probe(struct platform_device *pdev,
 		dev_err(&pdev->dev, "wrong pinctrl info\n");
 		return -EINVAL;
 	}
+
+	/* GPIO control functions only intended for shared mux/conf register */
+	if (info->flags & GPIO_CONTROL)
+		BUG_ON(!(info->flags & SHARE_MUX_CONF_REG));
+
 	info->dev = &pdev->dev;
 
 	/* Create state holders etc for this driver */
diff --git a/drivers/pinctrl/pinctrl-imx.h b/drivers/pinctrl/pinctrl-imx.h
index 49e55d3..8f37ca4 100644
--- a/drivers/pinctrl/pinctrl-imx.h
+++ b/drivers/pinctrl/pinctrl-imx.h
@@ -84,6 +84,7 @@ struct imx_pinctrl_soc_info {
 };
 
 #define SHARE_MUX_CONF_REG	0x1
+#define GPIO_CONTROL		0x2
 
 #define NO_MUX		0x0
 #define NO_PAD		0x0
diff --git a/drivers/pinctrl/pinctrl-vf610.c b/drivers/pinctrl/pinctrl-vf610.c
index b788e15..d34a3ac 100644
--- a/drivers/pinctrl/pinctrl-vf610.c
+++ b/drivers/pinctrl/pinctrl-vf610.c
@@ -299,7 +299,7 @@ static const struct pinctrl_pin_desc vf610_pinctrl_pads[] = {
 static struct imx_pinctrl_soc_info vf610_pinctrl_info = {
 	.pins = vf610_pinctrl_pads,
 	.npins = ARRAY_SIZE(vf610_pinctrl_pads),
-	.flags = SHARE_MUX_CONF_REG,
+	.flags = SHARE_MUX_CONF_REG | GPIO_CONTROL,
 };
 
 static struct of_device_id vf610_pinctrl_of_match[] = {
@@ -326,7 +326,7 @@ static int __init vf610_pinctrl_init(void)
 {
 	return platform_driver_register(&vf610_pinctrl_driver);
 }
-arch_initcall(vf610_pinctrl_init);
+postcore_initcall(vf610_pinctrl_init);
 
 static void __exit vf610_pinctrl_exit(void)
 {
-- 
2.1.0

