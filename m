Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab3EVMKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 08:10:24 -0400
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:53382 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756093Ab3EVMKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 08:10:22 -0400
From: <yizhang.mrvl@gmail.com>
To: <sameo@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <yizhang.mrvl@gmail.com>
CC: <cxie4@marvell.com>, <arnd@arndb.de>, <yizhang@marvell.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] mfd: 88pm800: fix probe bug
Date: Wed, 22 May 2013 20:07:08 +0800
Message-ID: <1369224429-27077-4-git-send-email-yizhang.mrvl@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1369224429-27077-1-git-send-email-yizhang.mrvl@gmail.com>
References: <1369224429-27077-1-git-send-email-yizhang.mrvl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yi Zhang <yizhang@marvell.com>

1) return 0 when probe function is successful
2) fine-tune pm800_pages_init()

Signed-off-by: Yi Zhang <yizhang@marvell.com>
---
 drivers/mfd/88pm800.c |   29 +++++++++++++++++++++--------
 1 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/88pm800.c b/drivers/mfd/88pm800.c
index 618a6b9..475b5fa 100644
--- a/drivers/mfd/88pm800.c
+++ b/drivers/mfd/88pm800.c
@@ -369,32 +369,43 @@ static int pm800_pages_init(struct pm80x_chip *chip)
 	struct pm80x_subchip *subchip;
 	struct i2c_client *client = chip->client;
 
+	int ret = -ENODEV;
+
 	subchip = chip->subchip;
 	/* PM800 block power: i2c addr 0x31 */
-	if (subchip->power_page_addr) {
+	if (subchip & (subchip->power_page_addr)) {
 		subchip->power_page =
 		    i2c_new_dummy(client->adapter, subchip->power_page_addr);
 		subchip->regmap_power =
 		    devm_regmap_init_i2c(subchip->power_page,
 					 &pm80x_regmap_config);
 		i2c_set_clientdata(subchip->power_page, chip);
-	} else
+	} else {
 		dev_info(chip->dev,
 			 "PM800 block power 0x31: No power_page_addr\n");
+		return ret;
+	}
 
 	/* PM800 block GPADC: i2c addr 0x32 */
-	if (subchip->gpadc_page_addr) {
+	if (subchip & (subchip->gpadc_page_addr)) {
 		subchip->gpadc_page = i2c_new_dummy(client->adapter,
 						    subchip->gpadc_page_addr);
 		subchip->regmap_gpadc =
 		    devm_regmap_init_i2c(subchip->gpadc_page,
 					 &pm80x_regmap_config);
 		i2c_set_clientdata(subchip->gpadc_page, chip);
-	} else
+	} else {
 		dev_info(chip->dev,
 			 "PM800 block GPADC 0x32: No gpadc_page_addr\n");
+		goto out_gpadc_page;
+	}
 
 	return 0;
+
+out_gpadc_page:
+	regmap_exit(subchip->regmap_power);
+	i2c_unregister_device(subchip->power_page);
+	return ret;
 }
 
 static void pm800_pages_exit(struct pm80x_chip *chip)
@@ -537,16 +548,18 @@ static int pm800_probe(struct i2c_client *client,
 	ret = device_800_init(chip, pdata);
 	if (ret) {
 		dev_err(chip->dev, "%s id 0x%x failed!\n", __func__, chip->id);
-		goto err_subchip_alloc;
+		goto err_800_init;
 	}
 
 	if (pdata->plat_config)
 		pdata->plat_config(chip, pdata);
 
-err_subchip_alloc:
-	mfd_remove_devices(chip->dev);
-	device_irq_exit_800(chip);
+	return 0;
+
+err_800_init:
+	pm800_pages_exit(chip);
 err_page_init:
+err_subchip_alloc:
 	pm80x_deinit();
 out_init:
 	return ret;
-- 
1.7.0.4

