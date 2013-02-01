Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab3BAMID (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 07:08:03 -0500
Received: from nbd.name ([46.4.11.11]:41384 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585Ab3BAMH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 07:07:56 -0500
From: John Crispin <blogic@openwrt.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, John Crispin <blogic@openwrt.org>
Subject: [PATCH 04/11] PINCTRL: lantiq: add output pinconf parameter
Date: Fri,  1 Feb 2013 13:04:58 +0100
Message-Id: <1359720305-31933-4-git-send-email-blogic@openwrt.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359720305-31933-1-git-send-email-blogic@openwrt.org>
References: <1359720305-31933-1-git-send-email-blogic@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While converting the boards inside OpenWrt to OF I noticed that the we are
missing a pinconf parameter to set a pin to output.

Signed-off-by: John Crispin <blogic@openwrt.org>
---
 drivers/pinctrl/pinctrl-lantiq.h |    1 +
 drivers/pinctrl/pinctrl-xway.c   |   14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-lantiq.h b/drivers/pinctrl/pinctrl-lantiq.h
index 4419d32..6d07f02 100644
--- a/drivers/pinctrl/pinctrl-lantiq.h
+++ b/drivers/pinctrl/pinctrl-lantiq.h
@@ -34,6 +34,7 @@ enum ltq_pinconf_param {
 	LTQ_PINCONF_PARAM_OPEN_DRAIN,
 	LTQ_PINCONF_PARAM_DRIVE_CURRENT,
 	LTQ_PINCONF_PARAM_SLEW_RATE,
+	LTQ_PINCONF_PARAM_OUTPUT,
 };
 
 struct ltq_cfg_param {
diff --git a/drivers/pinctrl/pinctrl-xway.c b/drivers/pinctrl/pinctrl-xway.c
index aa4c8b8..b23b895 100644
--- a/drivers/pinctrl/pinctrl-xway.c
+++ b/drivers/pinctrl/pinctrl-xway.c
@@ -466,6 +466,11 @@ static int xway_pinconf_get(struct pinctrl_dev *pctldev,
 			*config = LTQ_PINCONF_PACK(param, 1);
 		break;
 
+	case LTQ_PINCONF_PARAM_OUTPUT:
+		reg = GPIO_DIR(pin);
+		*config = LTQ_PINCONF_PACK(param,
+			gpio_getbit(info->membase[0], reg, PORT_PIN(pin)));
+		break;
 	default:
 		dev_err(pctldev->dev, "Invalid config param %04x\n", param);
 		return -ENOTSUPP;
@@ -515,6 +520,14 @@ static int xway_pinconf_set(struct pinctrl_dev *pctldev,
 			dev_err(pctldev->dev, "Invalid pull value %d\n", arg);
 		break;
 
+	case LTQ_PINCONF_PARAM_OUTPUT:
+		reg = GPIO_DIR(pin);
+		if (arg == 0)
+			gpio_clearbit(info->membase[0], reg, PORT_PIN(pin));
+		else
+			gpio_setbit(info->membase[0], reg, PORT_PIN(pin));
+		break;
+
 	default:
 		dev_err(pctldev->dev, "Invalid config param %04x\n", param);
 		return -ENOTSUPP;
@@ -573,6 +586,7 @@ static inline int xway_mux_apply(struct pinctrl_dev *pctrldev,
 static const struct ltq_cfg_param xway_cfg_params[] = {
 	{"lantiq,pull",		LTQ_PINCONF_PARAM_PULL},
 	{"lantiq,open-drain",	LTQ_PINCONF_PARAM_OPEN_DRAIN},
+	{"lantiq,output",	LTQ_PINCONF_PARAM_OUTPUT},
 };
 
 static struct ltq_pinmux_info xway_info = {
-- 
1.7.10.4

