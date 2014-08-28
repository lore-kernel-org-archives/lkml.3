Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbaH1NPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 09:15:43 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:33242 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbaH1NOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 09:14:45 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 09/11] mfd: pcf50633: Check return value of platform_device_add()
Date: Thu, 28 Aug 2014 14:14:15 +0100
Message-Id: <1409231657-18294-9-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409231657-18294-1-git-send-email-lee.jones@linaro.org>
References: <1409231657-18294-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value of platform_device_add() is checked after every
other use throughout the kernel.

We're also sliding in another cheeky dev_err() => dev_warn() change
as we're not actually erroring out here, rather reporting the fact
that something's gone wrong, but carrying on regardless.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/pcf50633-core.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index c87f7a0..e15c060 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -195,8 +195,9 @@ static int pcf50633_probe(struct i2c_client *client,
 				const struct i2c_device_id *ids)
 {
 	struct pcf50633 *pcf;
+	struct platform_device *pdev;
 	struct pcf50633_platform_data *pdata = dev_get_platdata(&client->dev);
-	int i, ret;
+	int i, j, ret;
 	int version, variant;
 
 	if (!client->irq) {
@@ -243,9 +244,6 @@ static int pcf50633_probe(struct i2c_client *client,
 
 
 	for (i = 0; i < PCF50633_NUM_REGULATORS; i++) {
-		struct platform_device *pdev;
-		int j;
-
 		pdev = platform_device_alloc("pcf50633-regulator", i);
 		if (!pdev)
 			return -ENOMEM;
@@ -253,25 +251,31 @@ static int pcf50633_probe(struct i2c_client *client,
 		pdev->dev.parent = pcf->dev;
 		ret = platform_device_add_data(pdev, &pdata->reg_init_data[i],
 					       sizeof(pdata->reg_init_data[i]));
-		if (ret) {
-			platform_device_put(pdev);
-			for (j = 0; j < i; j++)
-				platform_device_put(pcf->regulator_pdev[j]);
-			return ret;
-		}
-		pcf->regulator_pdev[i] = pdev;
+		if (ret)
+			goto err;
+
+		ret = platform_device_add(pdev);
+		if (ret)
+			goto err;
 
-		platform_device_add(pdev);
+		pcf->regulator_pdev[i] = pdev;
 	}
 
 	ret = sysfs_create_group(&client->dev.kobj, &pcf_attr_group);
 	if (ret)
-		dev_err(pcf->dev, "error creating sysfs entries\n");
+		dev_warn(pcf->dev, "error creating sysfs entries\n");
 
 	if (pdata->probe_done)
 		pdata->probe_done(pcf);
 
 	return 0;
+
+err:
+	platform_device_put(pdev);
+	for (j = 0; j < i; j++)
+		platform_device_put(pcf->regulator_pdev[j]);
+
+	return ret;
 }
 
 static int pcf50633_remove(struct i2c_client *client)
-- 
1.9.1

