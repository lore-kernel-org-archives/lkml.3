Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbaIYQim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 12:38:42 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:60586 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbaIYQh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 12:37:26 -0400
X-Amavis-Alert: BAD HEADER, Duplicate header field: "In-Reply-To"
From: Stefan Agner <stefan@agner.ch>
To: linus.walleij@linaro.org, gnurou@gmail.com, shawn.guo@freescale.com,
        kernel@pengutronix.de
Cc: linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, bpringlemeir@nbsps.com,
        l.stach@pengutronix.de, stefan@agner.ch
Subject: [PATCH v3 2/5] pinctrl: imx: add gpio pinmux support for vf610
Date: Thu, 25 Sep 2014 18:37:06 +0200
Message-Id: <6fef79bfe3597dfe4fbd09785b45b8762755af8a.1411662961.git.stefan@agner.ch>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1411662961.git.stefan@agner.ch>
References: <cover.1411662961.git.stefan@agner.ch>
In-Reply-To: <cover.1411662961.git.stefan@agner.ch>
References: <cover.1411662961.git.stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pinmux support for GPIO for Vybrid (vf610) IOMUX controller.
This is needed since direction configuration is not part of the
GPIO module in Vybrid.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 drivers/pinctrl/pinctrl-imx.c | 72 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-imx.c b/drivers/pinctrl/pinctrl-imx.c
index 0d4558b..f22c41e 100644
--- a/drivers/pinctrl/pinctrl-imx.c
+++ b/drivers/pinctrl/pinctrl-imx.c
@@ -294,10 +294,82 @@ static int imx_pmx_get_groups(struct pinctrl_dev *pctldev, unsigned selector,
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
+	.gpio_request_enable = imx_pmx_gpio_request_enable,
+	.gpio_set_direction = imx_pmx_gpio_set_direction,
 	.enable = imx_pmx_enable,
 };
 
-- 
2.1.0

