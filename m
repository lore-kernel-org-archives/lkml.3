Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab3FPPlX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 11:41:23 -0400
Received: from gloria.sntech.de ([95.129.55.99]:33334 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755206Ab3FPPlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 11:41:22 -0400
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v2] pinctrl: rockchip: correctly handle arguments of pinconf options
Date: Sun, 16 Jun 2013 17:41:16 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        James Hogan <james.hogan@imgtec.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <201306141741.46077.heiko@sntech.de> <201306161302.32156.heiko@sntech.de> <CACRpkdZxO-8rQPBRPsxAx8OBfwvh_BQuts7NAi379gMZG+1ocg@mail.gmail.com>
In-Reply-To: <CACRpkdZxO-8rQPBRPsxAx8OBfwvh_BQuts7NAi379gMZG+1ocg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306161741.17048.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the rockchip pinctrl driver to handle the arguments to the pull
pinconfig options correctly. So only accept non-0 values for the
pull options as the rockchip pin-controller can only turn pulls on and
off (this via BIAS_DISABLE).

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
changes since v1:
 really respect the values for arguments of the pull options (aka 0 is not
 meant to turn off a pull).
 Replacing the patch also makes sure that no wrong knowledge stays in the
 kernel via the old commit message, least somebody else reads it and takes
 it as true.

 drivers/pinctrl/pinctrl-rockchip.c      |   41 ++++++++++++++++++++++++++++---
 1 file changed, 37 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index c605b63..427564f 100644
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
+			return -EINVAL;
+
 		return rockchip_set_pull(bank, pin - bank->pin_base, param);
 		break;
 	default:
@@ -593,19 +621,24 @@ static int rockchip_pinconf_get(struct pinctrl_dev *pctldev, unsigned int pin,
 	struct rockchip_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
 	struct rockchip_pin_bank *bank = pin_to_bank(info, pin);
 	enum pin_config_param param = pinconf_to_config_param(*config);
-	unsigned int pull;
 
 	switch (param) {
 	case PIN_CONFIG_BIAS_DISABLE:
+		if (rockchip_get_pull(bank, pin - bank->pin_base) != param)
+			return -EINVAL;
+
+		*config = 0;
+		break;
 	case PIN_CONFIG_BIAS_PULL_UP:
 	case PIN_CONFIG_BIAS_PULL_DOWN:
 	case PIN_CONFIG_BIAS_PULL_PIN_DEFAULT:
-		pull = rockchip_get_pull(bank, pin - bank->pin_base);
+		if (!rockchip_pinconf_pull_valid(info->ctrl, param))
+			return -ENOTSUPP;
 
-		if (pull != param)
+		if (rockchip_get_pull(bank, pin - bank->pin_base) != param)
 			return -EINVAL;
 
-		*config = 0;
+		*config = 1;
 		break;
 	default:
 		return -ENOTSUPP;
-- 
1.7.10.4

