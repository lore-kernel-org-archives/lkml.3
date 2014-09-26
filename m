Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbaIZL5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 07:57:23 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:47687 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbaIZL5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 07:57:19 -0400
X-Amavis-Alert: BAD HEADER, Duplicate header field: "In-Reply-To"
From: Stefan Agner <stefan@agner.ch>
To: linus.walleij@linaro.org, shawn.guo@freescale.com
Cc: gnurou@gmail.com, kernel@pengutronix.de, linux-gpio@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpringlemeir@nbsps.com, l.stach@pengutronix.de, stefan@agner.ch
Subject: [PATCH v4 1/4] pinctrl: imx: add gpio pinmux support for vf610
Date: Fri, 26 Sep 2014 13:57:08 +0200
Message-Id: <a5c20cf7fd08c5cf41a2d43210c74708dda9519c.1411731755.git.stefan@agner.ch>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1411731755.git.stefan@agner.ch>
References: <cover.1411731755.git.stefan@agner.ch>
In-Reply-To: <cover.1411731755.git.stefan@agner.ch>
References: <cover.1411731755.git.stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pinmux support for GPIO for Vybrid (vf610) IOMUX controller.
This is needed since direction configuration is not part of the
GPIO module in Vybrid.

Signed-off-by: Stefan Agner <stefan@agner.ch>
Acked-by: Shawn Guo <shawn.guo@freescale.com>
---
 drivers/pinctrl/freescale/pinctrl-imx.c | 72 +++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/drivers/pinctrl/freescale/pinctrl-imx.c b/drivers/pinctrl/freescale/pinctrl-imx.c
index f244676..52f2b94 100644
--- a/drivers/pinctrl/freescale/pinctrl-imx.c
+++ b/drivers/pinctrl/freescale/pinctrl-imx.c
@@ -294,11 +294,83 @@ static int imx_pmx_get_groups(struct pinctrl_dev *pctldev, unsigned selector,
 	return 0;
 }
 
+static int imx_pmx_gpio_request_enable(struct pinctrl_dev *pctldev,
+			struct pinctrl_gpio_range *range, unsigned offset)
+{
+	struct imx_pinctrl *ipctl = pinctrl_dev_get_drvdata(pctldev);
+	const struct imx_pinctrl_soc_info *info = ipctl->info;
+	const struct imx_pin_reg *pin_reg;
+	struct imx_pin_group *grp;
+	struct imx_pin *imx_pin;
+	unsigned int pin, group;
+	u32 reg;
+
+	/* Currently implementation only for shared mux/conf register */
+	if (!(info->flags & SHARE_MUX_CONF_REG))
+		return -EINVAL;
+
+	pin_reg = &info->pin_regs[offset];
+	if (pin_reg->mux_reg == -1)
+		return -EINVAL;
+
+	/* Find the pinctrl config with GPIO mux mode for the requested pin */
+	for (group = 0; group < info->ngroups; group++) {
+		grp = &info->groups[group];
+		for (pin = 0; pin < grp->npins; pin++) {
+			imx_pin = &grp->pins[pin];
+			if (imx_pin->pin == offset && !imx_pin->mux_mode)
+				goto mux_pin;
+		}
+	}
+
+	return -EINVAL;
+
+mux_pin:
+	reg = readl(ipctl->base + pin_reg->mux_reg);
+	reg &= ~(0x7 << 20);
+	reg |= imx_pin->config;
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
+	/*
+	 * Only Vybrid has the input/output buffer enable flags (IBE/OBE)
+	 * They are part of the shared mux/conf register.
+	 */
+	if (!(info->flags & SHARE_MUX_CONF_REG))
+		return -EINVAL;
+
+	pin_reg = &info->pin_regs[offset];
+	if (pin_reg->mux_reg == -1)
+		return -EINVAL;
+
+	/* IBE always enabled allows us to read the value "on the wire" */
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
 	.set_mux = imx_pmx_set,
+	.gpio_request_enable = imx_pmx_gpio_request_enable,
+	.gpio_set_direction = imx_pmx_gpio_set_direction,
 };
 
 static int imx_pinconf_get(struct pinctrl_dev *pctldev,
-- 
2.1.0

