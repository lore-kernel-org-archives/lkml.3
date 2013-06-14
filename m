Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870Ab3FNFXx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 01:23:53 -0400
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:48093 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751409Ab3FNFXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 01:23:51 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>,
        <yizhang@marvell.com>
CC: Chao Xie <chao.xie@marvell.com>
Subject: [PATCH V2 6/9] mfd: 88pm800: fixes error handling for sub pages probe/remove
Date: Fri, 14 Jun 2013 01:21:50 -0400
Message-ID: <1371187313-5776-7-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1371187313-5776-1-git-send-email-chao.xie@marvell.com>
References: <1371187313-5776-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pm800_pages_init and pm800_pages_exit are called by pm800_probe.
Change the code to enhance error handling and remove unused code at
pm800_pages_init/exit and pm800_probe.

Signed-off-by: Yi Zhang <yizhang@marvell.com>
Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 drivers/mfd/88pm800.c |   80 ++++++++++++++++++++++++++++--------------------
 1 files changed, 47 insertions(+), 33 deletions(-)

diff --git a/drivers/mfd/88pm800.c b/drivers/mfd/88pm800.c
index 6b607ad..932ebe8 100644
--- a/drivers/mfd/88pm800.c
+++ b/drivers/mfd/88pm800.c
@@ -370,50 +370,64 @@ static int pm800_pages_init(struct pm80x_chip *chip)
 	struct pm80x_subchip *subchip;
 	struct i2c_client *client = chip->client;
 
+	int ret = 0;
+
 	subchip = chip->subchip;
-	/* PM800 block power: i2c addr 0x31 */
-	if (subchip->power_page_addr) {
-		subchip->power_page =
-		    i2c_new_dummy(client->adapter, subchip->power_page_addr);
-		subchip->regmap_power =
-		    devm_regmap_init_i2c(subchip->power_page,
-					 &pm80x_regmap_config);
-		i2c_set_clientdata(subchip->power_page, chip);
-	} else
-		dev_info(chip->dev,
-			 "PM800 block power 0x31: No power_page_addr\n");
-
-	/* PM800 block GPADC: i2c addr 0x32 */
-	if (subchip->gpadc_page_addr) {
-		subchip->gpadc_page = i2c_new_dummy(client->adapter,
-						    subchip->gpadc_page_addr);
-		subchip->regmap_gpadc =
-		    devm_regmap_init_i2c(subchip->gpadc_page,
-					 &pm80x_regmap_config);
-		i2c_set_clientdata(subchip->gpadc_page, chip);
-	} else
-		dev_info(chip->dev,
-			 "PM800 block GPADC 0x32: No gpadc_page_addr\n");
+	if (!subchip || !subchip->power_page_addr || !subchip->gpadc_page_addr)
+		return -ENODEV;
+
+	/* PM800 block power page */
+	subchip->power_page = i2c_new_dummy(client->adapter,
+					    subchip->power_page_addr);
+	if (subchip->power_page == NULL) {
+		ret = -ENODEV;
+		goto out;
+	}
 
-	return 0;
+	subchip->regmap_power = devm_regmap_init_i2c(subchip->power_page,
+						     &pm80x_regmap_config);
+	if (IS_ERR(subchip->regmap_power)) {
+		ret = PTR_ERR(subchip->regmap_power);
+		dev_err(chip->dev,
+			"Failed to allocate regmap_power: %d\n", ret);
+		goto out;
+	}
+
+	i2c_set_clientdata(subchip->power_page, chip);
+
+	/* PM800 block GPADC */
+	subchip->gpadc_page = i2c_new_dummy(client->adapter,
+					    subchip->gpadc_page_addr);
+	if (subchip->gpadc_page == NULL) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	subchip->regmap_gpadc = devm_regmap_init_i2c(subchip->gpadc_page,
+						     &pm80x_regmap_config);
+	if (IS_ERR(subchip->regmap_gpadc)) {
+		ret = PTR_ERR(subchip->regmap_gpadc);
+		dev_err(chip->dev,
+			"Failed to allocate regmap_gpadc: %d\n", ret);
+		goto out;
+	}
+	i2c_set_clientdata(subchip->gpadc_page, chip);
+
+out:
+	return ret;
 }
 
 static void pm800_pages_exit(struct pm80x_chip *chip)
 {
 	struct pm80x_subchip *subchip;
 
-	regmap_exit(chip->regmap);
-	i2c_unregister_device(chip->client);
-
 	subchip = chip->subchip;
-	if (subchip->power_page) {
-		regmap_exit(subchip->regmap_power);
+
+	if (subchip && subchip->power_page)
 		i2c_unregister_device(subchip->power_page);
-	}
-	if (subchip->gpadc_page) {
-		regmap_exit(subchip->regmap_gpadc);
+
+	if (subchip && subchip->gpadc_page)
 		i2c_unregister_device(subchip->gpadc_page);
-	}
 }
 
 static int device_800_init(struct pm80x_chip *chip,
-- 
1.7.4.1

