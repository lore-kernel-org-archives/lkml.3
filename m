Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175Ab3FESD3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 14:03:29 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:32186 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756969Ab3FERsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 13:48:07 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 12/53] Input: atmel_mxt_ts - Improve error reporting and debug
Date: Wed,  5 Jun 2013 18:37:05 +0100
Message-Id: <1370453866-16534-13-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add error messages for probe errors
Report type in invalid object type
Tweak some other debug output messages

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   33 +++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 08cd7ff..82b001d 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -431,7 +431,8 @@ recheck:
 	}
 
 	if (val != state) {
-		dev_err(&client->dev, "Unvalid bootloader mode state\n");
+		dev_err(&client->dev, "Invalid bootloader state %02X != %02X\n",
+			val, state);
 		return -EINVAL;
 	}
 
@@ -551,7 +552,7 @@ mxt_get_object(struct mxt_data *data, u8 type)
 			return object;
 	}
 
-	dev_err(&data->client->dev, "Invalid object type\n");
+	dev_err(&data->client->dev, "Invalid object type T%u\n", type);
 	return NULL;
 }
 
@@ -903,7 +904,7 @@ static int mxt_get_object_table(struct mxt_data *data)
 		}
 
 		dev_dbg(&data->client->dev,
-			"Type %2d Start %3d Size %3d Instances %2d ReportIDs %3u : %3u\n",
+			"T%u Start:%u Size:%u Instances:%u Report IDs:%u-%u\n",
 			object->type, object->start_address,
 			mxt_obj_size(object), mxt_obj_instances(object),
 			min_id, max_id);
@@ -964,8 +965,10 @@ static int mxt_initialize(struct mxt_data *data)
 
 	/* Get object table information */
 	error = mxt_get_object_table(data);
-	if (error)
+	if (error) {
+		dev_err(&client->dev, "Error %d reading object table\n", error);
 		goto err_free_object_table;
+	}
 
 	error = mxt_acquire_irq(data);
 	if (error)
@@ -973,8 +976,11 @@ static int mxt_initialize(struct mxt_data *data)
 
 	/* Check register init values */
 	error = mxt_check_reg_init(data);
-	if (error)
+	if (error) {
+		dev_err(&client->dev, "Error %d initialising configuration\n",
+			error);
 		goto err_free_object_table;
+	}
 
 	error = mxt_t6_command(data, MXT_COMMAND_BACKUPNV,
 			       MXT_BACKUP_VALUE, false);
@@ -993,12 +999,12 @@ static int mxt_initialize(struct mxt_data *data)
 	info->matrix_ysize = val;
 
 	dev_info(&client->dev,
-			"Family ID: %u Variant ID: %u Major.Minor.Build: %u.%u.%02X\n",
+			"Family: %u Variant: %u Firmware V%u.%u.%02X\n",
 			info->family_id, info->variant_id, info->version >> 4,
 			info->version & 0xf, info->build);
 
 	dev_info(&client->dev,
-			"Matrix X Size: %u Matrix Y Size: %u Object Num: %u\n",
+			"Matrix X Size: %u Matrix Y Size: %u Objects: %u\n",
 			info->matrix_xsize, info->matrix_ysize,
 			info->object_num);
 
@@ -1207,7 +1213,8 @@ static ssize_t mxt_update_fw_store(struct device *dev,
 		dev_err(dev, "The firmware update failed(%d)\n", error);
 		count = error;
 	} else {
-		dev_dbg(dev, "The firmware update succeeded\n");
+		dev_info(dev, "The firmware update succeeded\n");
+
 		mxt_free_object_table(data);
 
 		error = mxt_initialize(data);
@@ -1452,12 +1459,18 @@ static int mxt_probe(struct i2c_client *client,
 	i2c_set_clientdata(client, data);
 
 	error = input_register_device(input_dev);
-	if (error)
+	if (error) {
+		dev_err(&client->dev, "Error %d registering input device\n",
+			error);
 		goto err_free_object;
+	}
 
 	error = sysfs_create_group(&client->dev.kobj, &mxt_attr_group);
-	if (error)
+	if (error) {
+		dev_err(&client->dev, "Failure %d creating sysfs group\n",
+			error);
 		goto err_unregister_device;
+	}
 
 	sysfs_bin_attr_init(&data->mem_access_attr);
 	data->mem_access_attr.attr.name = "mem_access";
-- 
1.7.10.4

