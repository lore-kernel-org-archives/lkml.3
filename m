Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab3FNPo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 11:44:26 -0400
Received: from gloria.sntech.de ([95.129.55.99]:34488 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083Ab3FNPoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 11:44:25 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5/5] pinctrl: rockchip: correctly handle arguments of pinconf options
Date: Fri, 14 Jun 2013 17:44:20 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org,
        James Hogan <james.hogan@imgtec.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <201306141741.46077.heiko@sntech.de>
In-Reply-To: <201306141741.46077.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201306141744.21117.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the rockchip pinctrl driver to handle the arguments of 0 or 1 to
the pull pinconfig options correctly, so that the pull gets disabled when
either the bias_disable options is set or the pull option has the argument 0.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 drivers/pinctrl/pinctrl-rockchip.c |   37 +++++++++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index c605b63..2568afc 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -563,6 +563,25 @@ static const struct pinmux_ops rockchip_pmx_ops = {
  * Pinconf_ops handling
  */
 
+static bool rockchip_pinconf_pull_valid(struct rockchip_pin_ctrl *ctrl,
+					enum pin_config_param pull)
+{
+	/* rk3066b does support any pulls */
+	if (!ctrl->pull_offset)
+		return pull ? false : true;
+
+	if (ctrl->pull_auto) {
+		if (pull != PIN_CONFIG_BIAS_PULL_PIN_DEFAULT &&
+					pull != PIN_CONFIG_BIAS_DISABLE)
+			return false;
+	} else {
+		if (pull == PIN_CONFIG_BIAS_PULL_PIN_DEFAULT)
+			return false;
+	}
+
+	return true;
+}
+
 /* set the pin config settings for a specified pin */
 static int rockchip_pinconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
 							unsigned long config)
@@ -570,12 +589,21 @@ static int rockchip_pinconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
 	struct rockchip_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
 	struct rockchip_pin_bank *bank = pin_to_bank(info, pin);
 	enum pin_config_param param = pinconf_to_config_param(config);
+	u16 arg = pinconf_to_config_argument(config);
 
 	switch (param) {
 	case PIN_CONFIG_BIAS_DISABLE:
+		return rockchip_set_pull(bank, pin - bank->pin_base, param);
+		break;
 	case PIN_CONFIG_BIAS_PULL_UP:
 	case PIN_CONFIG_BIAS_PULL_DOWN:
 	case PIN_CONFIG_BIAS_PULL_PIN_DEFAULT:
+		if (!rockchip_pinconf_pull_valid(info->ctrl, param))
+			return -ENOTSUPP;
+
+		if (!arg)
+			param = PIN_CONFIG_BIAS_DISABLE;
+
 		return rockchip_set_pull(bank, pin - bank->pin_base, param);
 		break;
 	default:
@@ -600,12 +628,11 @@ static int rockchip_pinconf_get(struct pinctrl_dev *pctldev, unsigned int pin,
 	case PIN_CONFIG_BIAS_PULL_UP:
 	case PIN_CONFIG_BIAS_PULL_DOWN:
 	case PIN_CONFIG_BIAS_PULL_PIN_DEFAULT:
-		pull = rockchip_get_pull(bank, pin - bank->pin_base);
-
-		if (pull != param)
-			return -EINVAL;
+		if (!rockchip_pinconf_pull_valid(info->ctrl, param))
+			return -ENOTSUPP;
 
-		*config = 0;
+		pull = rockchip_get_pull(bank, pin - bank->pin_base);
+		*config = (pull == param) ? 1 : 0;
 		break;
 	default:
 		return -ENOTSUPP;
-- 
1.7.10.4

