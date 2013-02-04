Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab3BDPmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 10:42:22 -0500
Received: from mail-da0-f41.google.com ([209.85.210.41]:48399 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082Ab3BDPmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 10:42:20 -0500
From: Haojian Zhuang <haojian.zhuang@linaro.org>
To: sameo@linux.intel.com, qingx@marvell.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, cxie4@marvell.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: patches@linaro.org, Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: [PATCH 4/6] mfd: max8925: support dt for backlight
Date: Mon,  4 Feb 2013 23:40:45 +0800
Message-Id: <1359992448-22229-4-git-send-email-haojian.zhuang@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359992448-22229-1-git-send-email-haojian.zhuang@linaro.org>
References: <1359992448-22229-1-git-send-email-haojian.zhuang@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qing Xu <qingx@marvell.com>

Add device tree support in max8925 backlight.

Signed-off-by: Qing Xu <qingx@marvell.com>
Signed-off-by: Haojian Zhuang <haojian.zhuang@gmail.com>
---
 drivers/video/backlight/max8925_bl.c |   31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/video/backlight/max8925_bl.c b/drivers/video/backlight/max8925_bl.c
index 2c9bce0..5ca11b0 100644
--- a/drivers/video/backlight/max8925_bl.c
+++ b/drivers/video/backlight/max8925_bl.c
@@ -101,6 +101,29 @@ static const struct backlight_ops max8925_backlight_ops = {
 	.get_brightness	= max8925_backlight_get_brightness,
 };
 
+#ifdef CONFIG_OF
+static int max8925_backlight_dt_init(struct platform_device *pdev,
+			      struct max8925_backlight_pdata *pdata)
+{
+	struct device_node *nproot = pdev->dev.parent->of_node, *np;
+	int dual_string;
+
+	if (!nproot)
+		return -ENODEV;
+	np = of_find_node_by_name(nproot, "backlight");
+	if (!np) {
+		dev_err(&pdev->dev, "failed to find backlight node\n");
+		return -ENODEV;
+	}
+
+	of_property_read_u32(np, "maxim,max8925-dual-string", &dual_string);
+	pdata->dual_string = dual_string;
+	return 0;
+}
+#else
+#define max8925_backlight_dt_init(x, y)	(-1)
+#endif
+
 static int max8925_backlight_probe(struct platform_device *pdev)
 {
 	struct max8925_chip *chip = dev_get_drvdata(pdev->dev.parent);
@@ -147,6 +170,13 @@ static int max8925_backlight_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, bl);
 
 	value = 0;
+	if (pdev->dev.parent->of_node && !pdata) {
+		pdata = devm_kzalloc(&pdev->dev,
+				     sizeof(struct max8925_backlight_pdata),
+				     GFP_KERNEL);
+		max8925_backlight_dt_init(pdev, pdata);
+	}
+
 	if (pdata) {
 		if (pdata->lxw_scl)
 			value |= (1 << 7);
@@ -158,7 +188,6 @@ static int max8925_backlight_probe(struct platform_device *pdev)
 	ret = max8925_set_bits(chip->i2c, data->reg_mode_cntl, 0xfe, value);
 	if (ret < 0)
 		goto out_brt;
-
 	backlight_update_status(bl);
 	return 0;
 out_brt:
-- 
1.7.10.4

