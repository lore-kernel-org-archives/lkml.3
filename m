Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab3BDPmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 10:42:10 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:46227 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082Ab3BDPmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 10:42:09 -0500
From: Haojian Zhuang <haojian.zhuang@linaro.org>
To: sameo@linux.intel.com, qingx@marvell.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, cxie4@marvell.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: patches@linaro.org
Subject: [PATCH 2/6] mfd: max8925: fix mfd device register failure
Date: Mon,  4 Feb 2013 23:40:43 +0800
Message-Id: <1359992448-22229-2-git-send-email-haojian.zhuang@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359992448-22229-1-git-send-email-haojian.zhuang@linaro.org>
References: <1359992448-22229-1-git-send-email-haojian.zhuang@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qing Xu <qingx@marvell.com>

we encounter rtc/power/touch driver registry failure, root cause
it is resources confilict in insert_resouce, solved by changing
mfd_add_devices 5th parameter to NULL

Signed-off-by: Qing Xu <qingx@marvell.com>
---
 drivers/mfd/max8925-core.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/mfd/max8925-core.c b/drivers/mfd/max8925-core.c
index 0ad8d9a..d7abbb3 100644
--- a/drivers/mfd/max8925-core.c
+++ b/drivers/mfd/max8925-core.c
@@ -859,7 +859,7 @@ int max8925_device_init(struct max8925_chip *chip,
 
 	ret = mfd_add_devices(chip->dev, 0, &rtc_devs[0],
 			      ARRAY_SIZE(rtc_devs),
-			      &rtc_resources[0], chip->irq_base, NULL);
+			      NULL, chip->irq_base, NULL);
 	if (ret < 0) {
 		dev_err(chip->dev, "Failed to add rtc subdev\n");
 		goto out;
@@ -867,7 +867,7 @@ int max8925_device_init(struct max8925_chip *chip,
 
 	ret = mfd_add_devices(chip->dev, 0, &onkey_devs[0],
 			      ARRAY_SIZE(onkey_devs),
-			      &onkey_resources[0], 0, NULL);
+			      NULL, 0, NULL);
 	if (ret < 0) {
 		dev_err(chip->dev, "Failed to add onkey subdev\n");
 		goto out_dev;
@@ -886,21 +886,19 @@ int max8925_device_init(struct max8925_chip *chip,
 		goto out_dev;
 	}
 
-	if (pdata && pdata->power) {
-		ret = mfd_add_devices(chip->dev, 0, &power_devs[0],
-				      ARRAY_SIZE(power_devs),
-				      &power_supply_resources[0], 0, NULL);
-		if (ret < 0) {
-			dev_err(chip->dev,
-				"Failed to add power supply subdev\n");
-			goto out_dev;
-		}
+	ret = mfd_add_devices(chip->dev, 0, &power_devs[0],
+			      ARRAY_SIZE(power_devs),
+			      NULL, 0, NULL);
+	if (ret < 0) {
+		dev_err(chip->dev,
+			"Failed to add power supply subdev, err = %d\n", ret);
+		goto out_dev;
 	}
 
 	if (pdata && pdata->touch) {
 		ret = mfd_add_devices(chip->dev, 0, &touch_devs[0],
 				      ARRAY_SIZE(touch_devs),
-				      &touch_resources[0], 0, NULL);
+				      NULL, chip->tsc_irq, NULL);
 		if (ret < 0) {
 			dev_err(chip->dev, "Failed to add touch subdev\n");
 			goto out_dev;
-- 
1.7.10.4

