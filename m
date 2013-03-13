Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360Ab3CMICp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 04:02:45 -0400
Received: from mail-ia0-f173.google.com ([209.85.210.173]:58650 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab3CMICl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 04:02:41 -0400
From: Haojian Zhuang <haojian.zhuang@linaro.org>
To: tony@atomide.com, linus.walleij@linaro.org, linux-kernel@vger.kernel.org
Cc: patches@linaro.org, Haojian Zhuang <haojian.zhuang@linaro.org>
Subject: [PATCH] pinctrl: single: correct argument for pinconf
Date: Wed, 13 Mar 2013 16:01:26 +0800
Message-Id: <1363161686-21616-1-git-send-email-haojian.zhuang@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pcs_pinconf_set() is always using "arg << shift" to configure two
parameters case. But pcs_add_conf2() didn't remove shift for config
argument. So correct it.

Signed-off-by: Haojian Zhuang <haojian.zhuang@linaro.org>
---
 drivers/pinctrl/pinctrl-single.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index e35dabd..5f2d2bf 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -623,8 +623,8 @@ static int pcs_pinconf_set(struct pinctrl_dev *pctldev,
 {
 	struct pcs_device *pcs = pinctrl_dev_get_drvdata(pctldev);
 	struct pcs_function *func;
-	unsigned offset = 0, shift = 0, arg = 0, i, data, ret;
-	u16 argument;
+	unsigned offset = 0, shift = 0, i, data, ret;
+	u16 arg;
 
 	ret = pcs_get_function(pctldev, pin, &func);
 	if (ret)
@@ -634,14 +634,13 @@ static int pcs_pinconf_set(struct pinctrl_dev *pctldev,
 		if (pinconf_to_config_param(config) == func->conf[i].param) {
 			offset = pin * (pcs->width / BITS_PER_BYTE);
 			data = pcs->read(pcs->base + offset);
-			argument = pinconf_to_config_argument(config);
+			arg = pinconf_to_config_argument(config);
 			switch (func->conf[i].param) {
 			/* 2 parameters */
 			case PIN_CONFIG_INPUT_SCHMITT:
 			case PIN_CONFIG_DRIVE_STRENGTH:
 			case PIN_CONFIG_SLEW_RATE:
 				shift = ffs(func->conf[i].mask) - 1;
-				arg = pinconf_to_config_argument(config);
 				data &= ~func->conf[i].mask;
 				data |= (arg << shift) & func->conf[i].mask;
 				break;
@@ -651,12 +650,12 @@ static int pcs_pinconf_set(struct pinctrl_dev *pctldev,
 				break;
 			case PIN_CONFIG_BIAS_PULL_DOWN:
 			case PIN_CONFIG_BIAS_PULL_UP:
-				if (argument)
+				if (arg)
 					pcs_pinconf_clear_bias(pctldev, pin);
 				/* fall through */
 			case PIN_CONFIG_INPUT_SCHMITT_ENABLE:
 				data &= ~func->conf[i].mask;
-				if (argument)
+				if (arg)
 					data |= func->conf[i].enable;
 				else
 					data |= func->conf[i].disable;
@@ -965,7 +964,7 @@ static void pcs_add_conf2(struct pcs_device *pcs, struct device_node *np,
 			  const char *name, enum pin_config_param param,
 			  struct pcs_conf_vals **conf, unsigned long **settings)
 {
-	unsigned value[2];
+	unsigned value[2], shift;
 	int ret;
 
 	ret = of_property_read_u32_array(np, name, value, 2);
@@ -973,9 +972,10 @@ static void pcs_add_conf2(struct pcs_device *pcs, struct device_node *np,
 		return;
 	/* set value & mask */
 	value[0] &= value[1];
+	shift = ffs(value[1]) - 1;
 	/* skip enable & disable */
 	add_config(conf, param, value[0], 0, 0, value[1]);
-	add_setting(settings, param, value[0]);
+	add_setting(settings, param, value[0] >> shift);
 }
 
 /* add pinconf setting with 4 parameters */
-- 
1.7.10.4

