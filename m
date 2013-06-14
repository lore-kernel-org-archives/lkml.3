Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab3FNFZA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 01:25:00 -0400
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:42462 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751765Ab3FNFY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 01:24:59 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>,
        <yizhang@marvell.com>
CC: Chao Xie <chao.xie@marvell.com>
Subject: [PATCH V2 8/9] mfd: 88pm800: enhance sub devices initialization
Date: Fri, 14 Jun 2013 01:21:52 -0400
Message-ID: <1371187313-5776-9-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1371187313-5776-1-git-send-email-chao.xie@marvell.com>
References: <1371187313-5776-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate the devices initialization into different functions.
It makes the probe function clearly.

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 drivers/mfd/88pm800.c |   61 +++++++++++++++++++++++++++++++++---------------
 1 files changed, 42 insertions(+), 19 deletions(-)

diff --git a/drivers/mfd/88pm800.c b/drivers/mfd/88pm800.c
index 16faad6..35c7fe8 100644
--- a/drivers/mfd/88pm800.c
+++ b/drivers/mfd/88pm800.c
@@ -304,6 +304,40 @@ out:
 	return ret;
 }
 
+static int device_onkey_init(struct pm80x_chip *chip,
+				struct pm80x_platform_data *pdata)
+{
+	int ret;
+
+	ret = mfd_add_devices(chip->dev, 0, &onkey_devs[0],
+			      ARRAY_SIZE(onkey_devs), &onkey_resources[0], 0,
+			      NULL);
+	if (ret) {
+		dev_err(chip->dev, "Failed to add onkey subdev\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int device_rtc_init(struct pm80x_chip *chip,
+				struct pm80x_platform_data *pdata)
+{
+	int ret;
+
+	rtc_devs[0].platform_data = pdata->rtc;
+	rtc_devs[0].pdata_size =
+			pdata->rtc ? sizeof(struct pm80x_rtc_pdata) : 0;
+	ret = mfd_add_devices(chip->dev, 0, &rtc_devs[0],
+			      ARRAY_SIZE(rtc_devs), NULL, 0, NULL);
+	if (ret) {
+		dev_err(chip->dev, "Failed to add rtc subdev\n");
+		return ret;
+	}
+
+	return 0;
+}
+
 static int device_irq_init_800(struct pm80x_chip *chip)
 {
 	struct regmap *map = chip->regmap;
@@ -453,27 +487,16 @@ static int device_800_init(struct pm80x_chip *chip,
 		goto out;
 	}
 
-	ret =
-	    mfd_add_devices(chip->dev, 0, &onkey_devs[0],
-			    ARRAY_SIZE(onkey_devs), &onkey_resources[0], 0,
-			    NULL);
-	if (ret < 0) {
+	ret = device_onkey_init(chip, pdata);
+	if (ret) {
 		dev_err(chip->dev, "Failed to add onkey subdev\n");
 		goto out_dev;
-	} else
-		dev_info(chip->dev, "[%s]:Added mfd onkey_devs\n", __func__);
-
-	if (pdata && pdata->rtc) {
-		rtc_devs[0].platform_data = pdata->rtc;
-		rtc_devs[0].pdata_size = sizeof(struct pm80x_rtc_pdata);
-		ret = mfd_add_devices(chip->dev, 0, &rtc_devs[0],
-				      ARRAY_SIZE(rtc_devs), NULL, 0, NULL);
-		if (ret < 0) {
-			dev_err(chip->dev, "Failed to add rtc subdev\n");
-			goto out_dev;
-		} else
-			dev_info(chip->dev,
-				 "[%s]:Added mfd rtc_devs\n", __func__);
+	}
+
+	ret = device_rtc_init(chip, pdata);
+	if (ret) {
+		dev_err(chip->dev, "Failed to add rtc subdev\n");
+		goto out;
 	}
 
 	return 0;
-- 
1.7.4.1

