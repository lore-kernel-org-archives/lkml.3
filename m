Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383AbaIWRiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 13:38:23 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:50278 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756428AbaIWRiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 13:38:17 -0400
X-Amavis-Alert: BAD HEADER, Duplicate header field: "In-Reply-To"
From: Stefan Agner <stefan@agner.ch>
To: linus.walleij@linaro.org, gnurou@gmail.com, shawn.guo@freescale.com,
        kernel@pengutronix.de
Cc: linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, bpringlemeir@nbsps.com, stefan@agner.ch
Subject: [PATCH v2 2/5] pinctrl: imx: add gpio pinmux support for vf610
Date: Tue, 23 Sep 2014 19:37:54 +0200
Message-Id: <bb68d2360314158cd8ccb9c6794877c3bb45d72e.1411492954.git.stefan@agner.ch>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1411492954.git.stefan@agner.ch>
References: <cover.1411492954.git.stefan@agner.ch>
In-Reply-To: <cover.1411492954.git.stefan@agner.ch>
References: <cover.1411492954.git.stefan@agner.ch>
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
 drivers/pinctrl/pinctrl-vf610.c |  2 +-
 3 files changed, 56 insertions(+), 1 deletion(-)

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
index b788e15..fdf5661 100644
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
-- 
2.1.0

