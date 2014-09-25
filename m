Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbaIYQh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 12:37:27 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:60563 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbaIYQhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 12:37:24 -0400
X-Amavis-Alert: BAD HEADER, Duplicate header field: "In-Reply-To"
From: Stefan Agner <stefan@agner.ch>
To: linus.walleij@linaro.org, gnurou@gmail.com, shawn.guo@freescale.com,
        kernel@pengutronix.de
Cc: linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, bpringlemeir@nbsps.com,
        l.stach@pengutronix.de, stefan@agner.ch
Subject: [PATCH v3 1/5] pinctrl: imx: detect uninitialized pins
Date: Thu, 25 Sep 2014 18:37:05 +0200
Message-Id: <94aff496faf26b6fe51c96704dcabcf8a55a1320.1411662961.git.stefan@agner.ch>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1411662961.git.stefan@agner.ch>
References: <cover.1411662961.git.stefan@agner.ch>
In-Reply-To: <cover.1411662961.git.stefan@agner.ch>
References: <cover.1411662961.git.stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pinctrl driver initialized the register offsets for the pins
with 0. On Vybrid an offset of 0 is a valid offset for the pinctrl
mux register. So far, this was solved using the ZERO_OFFSET_VALID
flag which allowed offsets of 0. However, this does not allow to
verify whether a pins struct imx_pmx_func was initialized or not.

Use signed offset values for register offsets and initialize those
with -1 in order to detect uninitialized offset values reliable.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 drivers/pinctrl/pinctrl-imx.c   | 9 +++++----
 drivers/pinctrl/pinctrl-imx.h   | 7 +++----
 drivers/pinctrl/pinctrl-vf610.c | 2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-imx.c b/drivers/pinctrl/pinctrl-imx.c
index 946d594..0d4558b 100644
--- a/drivers/pinctrl/pinctrl-imx.c
+++ b/drivers/pinctrl/pinctrl-imx.c
@@ -204,7 +204,7 @@ static int imx_pmx_enable(struct pinctrl_dev *pctldev, unsigned selector,
 		pin_id = pin->pin;
 		pin_reg = &info->pin_regs[pin_id];
 
-		if (!(info->flags & ZERO_OFFSET_VALID) && !pin_reg->mux_reg) {
+		if (pin_reg->mux_reg == -1) {
 			dev_err(ipctl->dev, "Pin(%s) does not support mux function\n",
 				info->pins[pin_id].name);
 			return -EINVAL;
@@ -308,7 +308,7 @@ static int imx_pinconf_get(struct pinctrl_dev *pctldev,
 	const struct imx_pinctrl_soc_info *info = ipctl->info;
 	const struct imx_pin_reg *pin_reg = &info->pin_regs[pin_id];
 
-	if (!(info->flags & ZERO_OFFSET_VALID) && !pin_reg->conf_reg) {
+	if (pin_reg->conf_reg == -1) {
 		dev_err(info->dev, "Pin(%s) does not support config function\n",
 			info->pins[pin_id].name);
 		return -EINVAL;
@@ -331,7 +331,7 @@ static int imx_pinconf_set(struct pinctrl_dev *pctldev,
 	const struct imx_pin_reg *pin_reg = &info->pin_regs[pin_id];
 	int i;
 
-	if (!(info->flags & ZERO_OFFSET_VALID) && !pin_reg->conf_reg) {
+	if (pin_reg->conf_reg == -1) {
 		dev_err(info->dev, "Pin(%s) does not support config function\n",
 			info->pins[pin_id].name);
 		return -EINVAL;
@@ -586,10 +586,11 @@ int imx_pinctrl_probe(struct platform_device *pdev,
 	if (!ipctl)
 		return -ENOMEM;
 
-	info->pin_regs = devm_kzalloc(&pdev->dev, sizeof(*info->pin_regs) *
+	info->pin_regs = devm_kmalloc(&pdev->dev, sizeof(*info->pin_regs) *
 				      info->npins, GFP_KERNEL);
 	if (!info->pin_regs)
 		return -ENOMEM;
+	memset(info->pin_regs, 0xff, sizeof(*info->pin_regs) * info->npins);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	ipctl->base = devm_ioremap_resource(&pdev->dev, res);
diff --git a/drivers/pinctrl/pinctrl-imx.h b/drivers/pinctrl/pinctrl-imx.h
index db408b0..49e55d3 100644
--- a/drivers/pinctrl/pinctrl-imx.h
+++ b/drivers/pinctrl/pinctrl-imx.h
@@ -67,8 +67,8 @@ struct imx_pmx_func {
  * @conf_reg: config register offset
  */
 struct imx_pin_reg {
-	u16 mux_reg;
-	u16 conf_reg;
+	s16 mux_reg;
+	s16 conf_reg;
 };
 
 struct imx_pinctrl_soc_info {
@@ -83,8 +83,7 @@ struct imx_pinctrl_soc_info {
 	unsigned int flags;
 };
 
-#define ZERO_OFFSET_VALID	0x1
-#define SHARE_MUX_CONF_REG	0x2
+#define SHARE_MUX_CONF_REG	0x1
 
 #define NO_MUX		0x0
 #define NO_PAD		0x0
diff --git a/drivers/pinctrl/pinctrl-vf610.c b/drivers/pinctrl/pinctrl-vf610.c
index bddd913..b788e15 100644
--- a/drivers/pinctrl/pinctrl-vf610.c
+++ b/drivers/pinctrl/pinctrl-vf610.c
@@ -299,7 +299,7 @@ static const struct pinctrl_pin_desc vf610_pinctrl_pads[] = {
 static struct imx_pinctrl_soc_info vf610_pinctrl_info = {
 	.pins = vf610_pinctrl_pads,
 	.npins = ARRAY_SIZE(vf610_pinctrl_pads),
-	.flags = ZERO_OFFSET_VALID | SHARE_MUX_CONF_REG,
+	.flags = SHARE_MUX_CONF_REG,
 };
 
 static struct of_device_id vf610_pinctrl_of_match[] = {
-- 
2.1.0

