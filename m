Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbaBEDzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 22:55:43 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:42033 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbaBEDzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 22:55:31 -0500
From: Bjorn Andersson <bjorn@kryo.se>
To: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH] pinctrl-msm: Support output-{high,low} configuration
Date: Tue,  4 Feb 2014 19:55:31 -0800
Message-Id: <1391572531-6610-1-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for configuring pins as output with value as from the
pinconf-generic interface.

Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---
 drivers/pinctrl/pinctrl-msm.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-msm.c b/drivers/pinctrl/pinctrl-msm.c
index ef2bf31..2cfb1d4 100644
--- a/drivers/pinctrl/pinctrl-msm.c
+++ b/drivers/pinctrl/pinctrl-msm.c
@@ -228,6 +228,11 @@ static int msm_config_reg(struct msm_pinctrl *pctrl,
 		*bit = g->drv_bit;
 		*mask = 7;
 		break;
+	case PIN_CONFIG_OUTPUT:
+		*reg = g->ctl_reg;
+		*bit = g->oe_bit;
+		*mask = 1;
+		break;
 	default:
 		dev_err(pctrl->dev, "Invalid config param %04x\n", param);
 		return -ENOTSUPP;
@@ -301,6 +306,14 @@ static int msm_config_group_get(struct pinctrl_dev *pctldev,
 	case PIN_CONFIG_DRIVE_STRENGTH:
 		arg = msm_regval_to_drive[arg];
 		break;
+	case PIN_CONFIG_OUTPUT:
+		/* Pin is not output */
+		if (!arg)
+			return -EINVAL;
+
+		val = readl(pctrl->regs + g->io_reg);
+		arg = !!(val & BIT(g->in_bit));
+		break;
 	default:
 		dev_err(pctrl->dev, "Unsupported config parameter: %x\n",
 			param);
@@ -357,6 +370,20 @@ static int msm_config_group_set(struct pinctrl_dev *pctldev,
 			else
 				arg = msm_drive_to_regval[arg];
 			break;
+		case PIN_CONFIG_OUTPUT:
+			/* set output value */
+			spin_lock_irqsave(&pctrl->lock, flags);
+			val = readl(pctrl->regs + g->io_reg);
+			if (arg)
+				val |= BIT(g->out_bit);
+			else
+				val &= ~BIT(g->out_bit);
+			writel(val, pctrl->regs + g->io_reg);
+			spin_unlock_irqrestore(&pctrl->lock, flags);
+
+			/* enable output */
+			arg = 1;
+			break;
 		default:
 			dev_err(pctrl->dev, "Unsupported config parameter: %x\n",
 				param);
-- 
1.7.9.5

