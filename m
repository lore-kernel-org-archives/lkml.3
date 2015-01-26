Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbbAZQZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 11:25:18 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:47220 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756029AbbAZQZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 11:25:15 -0500
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [PATCH] pinctrl: qcom: enable generic support and input-enable pinctrl conf
Date: Mon, 26 Jan 2015 18:24:54 +0200
Message-Id: <1422289494-31461-1-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enables generic pinconf support and add handling for 'input-enable'
pinconf property.

Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
---
 drivers/pinctrl/qcom/pinctrl-msm.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
index e730935..4a47eb1 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -193,11 +193,11 @@ static int msm_config_reg(struct msm_pinctrl *pctrl,
 		*mask = 7;
 		break;
 	case PIN_CONFIG_OUTPUT:
+	case PIN_CONFIG_INPUT_ENABLE:
 		*bit = g->oe_bit;
 		*mask = 1;
 		break;
 	default:
-		dev_err(pctrl->dev, "Invalid config param %04x\n", param);
 		return -ENOTSUPP;
 	}
 
@@ -208,14 +208,12 @@ static int msm_config_get(struct pinctrl_dev *pctldev,
 			  unsigned int pin,
 			  unsigned long *config)
 {
-	dev_err(pctldev->dev, "pin_config_set op not supported\n");
 	return -ENOTSUPP;
 }
 
 static int msm_config_set(struct pinctrl_dev *pctldev, unsigned int pin,
 				unsigned long *configs, unsigned num_configs)
 {
-	dev_err(pctldev->dev, "pin_config_set op not supported\n");
 	return -ENOTSUPP;
 }
 
@@ -276,9 +274,11 @@ static int msm_config_group_get(struct pinctrl_dev *pctldev,
 		val = readl(pctrl->regs + g->io_reg);
 		arg = !!(val & BIT(g->in_bit));
 		break;
+	case PIN_CONFIG_INPUT_ENABLE:
+		val = readl(pctrl->regs + g->io_reg);
+		arg = !!(val & BIT(g->in_bit));
+		break;
 	default:
-		dev_err(pctrl->dev, "Unsupported config parameter: %x\n",
-			param);
 		return -EINVAL;
 	}
 
@@ -348,6 +348,10 @@ static int msm_config_group_set(struct pinctrl_dev *pctldev,
 			/* enable output */
 			arg = 1;
 			break;
+		case PIN_CONFIG_INPUT_ENABLE:
+			/* disable output */
+			arg = 0;
+			break;
 		default:
 			dev_err(pctrl->dev, "Unsupported config parameter: %x\n",
 				param);
@@ -372,6 +376,9 @@ static int msm_config_group_set(struct pinctrl_dev *pctldev,
 }
 
 static const struct pinconf_ops msm_pinconf_ops = {
+#ifdef CONFIG_GENERIC_PINCONF
+	.is_generic		= true,
+#endif
 	.pin_config_get		= msm_config_get,
 	.pin_config_set		= msm_config_set,
 	.pin_config_group_get	= msm_config_group_get,
-- 
1.7.0.4

