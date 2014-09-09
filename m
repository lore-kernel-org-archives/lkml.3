Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981AbaIIOvH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 10:51:07 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:13607 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751766AbaIIOvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:51:01 -0400
From: nick.dyer@itdev.co.uk
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Yufeng Shen <miletus@google.com>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Sekhar Nori <nsekhar@ti.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 2/2] Input: atmel_mxt_ts - fix double free of input device
Date: Tue,  9 Sep 2014 15:50:49 +0100
Message-Id: <1410274249-3469-3-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410274249-3469-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1410274249-3469-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@wwwdotorg.org>

[reworked after comments by Dmitry Torokhov. Move free of input device into
separate function. Only call in paths that require it. Move mxt_initialize
after sysfs init, because otherwise an error in the sysfs init may interfere
with the async return from the firmware loader. Add guards for sysfs
functions. ]
Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 40 ++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 12 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index d954b81..65153c4 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -1379,11 +1379,16 @@ static int mxt_get_info(struct mxt_data *data)
 	return 0;
 }
 
-static void mxt_free_object_table(struct mxt_data *data)
+static void mxt_free_input_device(struct mxt_data *data)
 {
-	input_unregister_device(data->input_dev);
-	data->input_dev = NULL;
+	if (data->input_dev) {
+		input_unregister_device(data->input_dev);
+		data->input_dev = NULL;
+	}
+}
 
+static void mxt_free_object_table(struct mxt_data *data)
+{
 	kfree(data->object_table);
 	data->object_table = NULL;
 	kfree(data->msg_buf);
@@ -1828,6 +1833,10 @@ static ssize_t mxt_fw_version_show(struct device *dev,
 {
 	struct mxt_data *data = dev_get_drvdata(dev);
 	struct mxt_info *info = &data->info;
+
+	if (!data->object_table)
+		return -EINVAL;
+
 	return scnprintf(buf, PAGE_SIZE, "%u.%u.%02X\n",
 			 info->version >> 4, info->version & 0xf, info->build);
 }
@@ -1838,6 +1847,10 @@ static ssize_t mxt_hw_version_show(struct device *dev,
 {
 	struct mxt_data *data = dev_get_drvdata(dev);
 	struct mxt_info *info = &data->info;
+
+	if (!data->object_table)
+		return -EINVAL;
+
 	return scnprintf(buf, PAGE_SIZE, "%u.%u\n",
 			 info->family_id, info->variant_id);
 }
@@ -1870,6 +1883,9 @@ static ssize_t mxt_object_show(struct device *dev,
 	int error;
 	u8 *obuf;
 
+	if (!data->object_table)
+		return -EINVAL;
+
 	/* Pre-allocate buffer large enough to hold max sized object. */
 	obuf = kmalloc(256, GFP_KERNEL);
 	if (!obuf)
@@ -1962,11 +1978,13 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 		ret = mxt_lookup_bootloader_address(data, 0);
 		if (ret)
 			goto release_firmware;
+
+		mxt_free_input_device(data);
+		mxt_free_object_table(data);
 	} else {
 		enable_irq(data->irq);
 	}
 
-	mxt_free_object_table(data);
 	reinit_completion(&data->bl_completion);
 
 	ret = mxt_check_bootloader(data, MXT_WAITING_BOOTLOAD_CMD, false);
@@ -2201,21 +2219,19 @@ static int mxt_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 	disable_irq(client->irq);
 
-	error = mxt_initialize(data);
-	if (error)
-		goto err_free_irq;
-
 	error = sysfs_create_group(&client->dev.kobj, &mxt_attr_group);
 	if (error) {
 		dev_err(&client->dev, "Failure %d creating sysfs group\n",
 			error);
-		goto err_free_object;
+		goto err_free_irq;
 	}
 
+	error = mxt_initialize(data);
+	if (error)
+		goto err_free_irq;
+
 	return 0;
 
-err_free_object:
-	mxt_free_object_table(data);
 err_free_irq:
 	free_irq(client->irq, data);
 err_free_mem:
@@ -2229,7 +2245,7 @@ static int mxt_remove(struct i2c_client *client)
 
 	sysfs_remove_group(&client->dev.kobj, &mxt_attr_group);
 	free_irq(data->irq, data);
-	input_unregister_device(data->input_dev);
+	mxt_free_input_device(data);
 	mxt_free_object_table(data);
 	kfree(data);
 
-- 
1.9.1

