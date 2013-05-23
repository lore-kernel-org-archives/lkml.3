Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759716Ab3EWP0o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 11:26:44 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:43451 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759600Ab3EWPZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 11:25:55 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, sameo@linux.intel.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 15/16] mfd: max77686: Convert to managed resources for allocating memory
Date: Thu, 23 May 2013 16:25:16 +0100
Message-Id: <1369322717-30429-15-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369322717-30429-1-git-send-email-lee.jones@linaro.org>
References: <1369322717-30429-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/max77686.c |   25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
index 1cbb176..b094ac5 100644
--- a/drivers/mfd/max77686.c
+++ b/drivers/mfd/max77686.c
@@ -84,12 +84,12 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
 		pdata = max77686_i2c_parse_dt_pdata(&i2c->dev);
 
 	if (!pdata) {
-		ret = -EIO;
 		dev_err(&i2c->dev, "No platform data found.\n");
-		goto err;
+		return -EIO;
 	}
 
-	max77686 = kzalloc(sizeof(struct max77686_dev), GFP_KERNEL);
+	max77686 = devm_kzalloc(&i2c->dev,
+				sizeof(struct max77686_dev), GFP_KERNEL);
 	if (max77686 == NULL)
 		return -ENOMEM;
 
@@ -107,7 +107,6 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
 		ret = PTR_ERR(max77686->regmap);
 		dev_err(max77686->dev, "Failed to allocate register map: %d\n",
 				ret);
-		kfree(max77686);
 		return ret;
 	}
 
@@ -115,8 +114,7 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
 			 MAX77686_REG_DEVICE_ID, &data) < 0) {
 		dev_err(max77686->dev,
 			"device not found on this channel (this is not an error)\n");
-		ret = -ENODEV;
-		goto err;
+		return -ENODEV;
 	} else
 		dev_info(max77686->dev, "device found\n");
 
@@ -127,17 +125,11 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
 
 	ret = mfd_add_devices(max77686->dev, -1, max77686_devs,
 			      ARRAY_SIZE(max77686_devs), NULL, 0, NULL);
+	if (ret < 0) {
+		mfd_remove_devices(max77686->dev);
+		i2c_unregister_device(max77686->rtc);
+	}
 
-	if (ret < 0)
-		goto err_mfd;
-
-	return ret;
-
-err_mfd:
-	mfd_remove_devices(max77686->dev);
-	i2c_unregister_device(max77686->rtc);
-err:
-	kfree(max77686);
 	return ret;
 }
 
@@ -147,7 +139,6 @@ static int max77686_i2c_remove(struct i2c_client *i2c)
 
 	mfd_remove_devices(max77686->dev);
 	i2c_unregister_device(max77686->rtc);
-	kfree(max77686);
 
 	return 0;
 }
-- 
1.7.10.4

