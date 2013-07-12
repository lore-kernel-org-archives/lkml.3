Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911Ab3GLL3p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 07:29:45 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:53339 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932757Ab3GLL3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 07:29:44 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] input: twl6040-vibra: Remove support for legacy (pdata) mode
Date: Fri, 12 Jul 2013 13:29:41 +0200
Message-ID: <1373628581-11305-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.2.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TWL6040 is used only with OMAP4/5 SoCs and they can only boot in in DT mode.
The support for pdata/legacy boot can be removed.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/input/misc/twl6040-vibra.c | 41 ++++++++++++++------------------------
 1 file changed, 15 insertions(+), 26 deletions(-)

diff --git a/drivers/input/misc/twl6040-vibra.c b/drivers/input/misc/twl6040-vibra.c
index 0c2dfc8..7864b0c 100644
--- a/drivers/input/misc/twl6040-vibra.c
+++ b/drivers/input/misc/twl6040-vibra.c
@@ -257,7 +257,6 @@ static SIMPLE_DEV_PM_OPS(twl6040_vibra_pm_ops, twl6040_vibra_suspend, NULL);
 
 static int twl6040_vibra_probe(struct platform_device *pdev)
 {
-	struct twl6040_vibra_data *pdata = pdev->dev.platform_data;
 	struct device *twl6040_core_dev = pdev->dev.parent;
 	struct device_node *twl6040_core_node = NULL;
 	struct vibra_info *info;
@@ -270,8 +269,8 @@ static int twl6040_vibra_probe(struct platform_device *pdev)
 						 "vibra");
 #endif
 
-	if (!pdata && !twl6040_core_node) {
-		dev_err(&pdev->dev, "platform_data not available\n");
+	if (!twl6040_core_node) {
+		dev_err(&pdev->dev, "parent of node is missing?\n");
 		return -EINVAL;
 	}
 
@@ -284,27 +283,17 @@ static int twl6040_vibra_probe(struct platform_device *pdev)
 	info->dev = &pdev->dev;
 
 	info->twl6040 = dev_get_drvdata(pdev->dev.parent);
-	if (pdata) {
-		info->vibldrv_res = pdata->vibldrv_res;
-		info->vibrdrv_res = pdata->vibrdrv_res;
-		info->viblmotor_res = pdata->viblmotor_res;
-		info->vibrmotor_res = pdata->vibrmotor_res;
-		vddvibl_uV = pdata->vddvibl_uV;
-		vddvibr_uV = pdata->vddvibr_uV;
-	} else {
-		of_property_read_u32(twl6040_core_node, "ti,vibldrv-res",
-				     &info->vibldrv_res);
-		of_property_read_u32(twl6040_core_node, "ti,vibrdrv-res",
-				     &info->vibrdrv_res);
-		of_property_read_u32(twl6040_core_node, "ti,viblmotor-res",
-				     &info->viblmotor_res);
-		of_property_read_u32(twl6040_core_node, "ti,vibrmotor-res",
-				     &info->vibrmotor_res);
-		of_property_read_u32(twl6040_core_node, "ti,vddvibl-uV",
-				     &vddvibl_uV);
-		of_property_read_u32(twl6040_core_node, "ti,vddvibr-uV",
-				     &vddvibr_uV);
-	}
+
+	of_property_read_u32(twl6040_core_node, "ti,vibldrv-res",
+			     &info->vibldrv_res);
+	of_property_read_u32(twl6040_core_node, "ti,vibrdrv-res",
+			     &info->vibrdrv_res);
+	of_property_read_u32(twl6040_core_node, "ti,viblmotor-res",
+			     &info->viblmotor_res);
+	of_property_read_u32(twl6040_core_node, "ti,vibrmotor-res",
+			     &info->vibrmotor_res);
+	of_property_read_u32(twl6040_core_node, "ti,vddvibl-uV", &vddvibl_uV);
+	of_property_read_u32(twl6040_core_node, "ti,vddvibr-uV", &vddvibr_uV);
 
 	if ((!info->vibldrv_res && !info->viblmotor_res) ||
 	    (!info->vibrdrv_res && !info->vibrmotor_res)) {
@@ -334,8 +323,8 @@ static int twl6040_vibra_probe(struct platform_device *pdev)
 	 * When booted with Device tree the regulators are attached to the
 	 * parent device (twl6040 MFD core)
 	 */
-	ret = regulator_bulk_get(pdata ? info->dev : twl6040_core_dev,
-				 ARRAY_SIZE(info->supplies), info->supplies);
+	ret = regulator_bulk_get(twl6040_core_dev, ARRAY_SIZE(info->supplies),
+				 info->supplies);
 	if (ret) {
 		dev_err(info->dev, "couldn't get regulators %d\n", ret);
 		return ret;
-- 
1.8.2.1

