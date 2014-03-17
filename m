Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875AbaCQRde (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 13:33:34 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:27657 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755233AbaCQRd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 13:33:29 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Yufeng Shen <miletus@google.com>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 09/22] Input: atmel_mxt_ts - improve error reporting and debug
Date: Mon, 17 Mar 2014 17:26:42 +0000
Message-Id: <1395077215-10922-10-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395077215-10922-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1395077215-10922-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Add error messages for probe errors
- Report type in invalid object type
- Tweak some other debug output messages

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
Acked-by: Yufeng Shen <miletus@chromium.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 33 ++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index d3aef87..278f364 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -420,7 +420,8 @@ recheck:
 	}
 
 	if (val != state) {
-		dev_err(&client->dev, "Unvalid bootloader mode state\n");
+		dev_err(&client->dev, "Invalid bootloader state %02X != %02X\n",
+			val, state);
 		return -EINVAL;
 	}
 
@@ -540,7 +541,7 @@ mxt_get_object(struct mxt_data *data, u8 type)
 			return object;
 	}
 
-	dev_err(&data->client->dev, "Invalid object type\n");
+	dev_err(&data->client->dev, "Invalid object type T%u\n", type);
 	return NULL;
 }
 
@@ -861,7 +862,7 @@ static int mxt_get_object_table(struct mxt_data *data)
 		}
 
 		dev_dbg(&data->client->dev,
-			"Type %2d Start %3d Size %3zd Instances %2zd ReportIDs %3u : %3u\n",
+			"T%u Start:%u Size:%zu Instances:%zu Report IDs:%u-%u\n",
 			object->type, object->start_address,
 			mxt_obj_size(object), mxt_obj_instances(object),
 			min_id, max_id);
@@ -915,13 +916,18 @@ static int mxt_initialize(struct mxt_data *data)
 
 	/* Get object table information */
 	error = mxt_get_object_table(data);
-	if (error)
+	if (error) {
+		dev_err(&client->dev, "Error %d reading object table\n", error);
 		goto err_free_object_table;
+	}
 
 	/* Check register init values */
 	error = mxt_check_reg_init(data);
-	if (error)
+	if (error) {
+		dev_err(&client->dev, "Error %d initializing configuration\n",
+			error);
 		goto err_free_object_table;
+	}
 
 	error = mxt_t6_command(data, MXT_COMMAND_BACKUPNV,
 			       MXT_BACKUP_VALUE, false);
@@ -940,12 +946,12 @@ static int mxt_initialize(struct mxt_data *data)
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
 
@@ -1154,7 +1160,8 @@ static ssize_t mxt_update_fw_store(struct device *dev,
 		dev_err(dev, "The firmware update failed(%d)\n", error);
 		count = error;
 	} else {
-		dev_dbg(dev, "The firmware update succeeded\n");
+		dev_info(dev, "The firmware update succeeded\n");
+
 		mxt_free_object_table(data);
 
 		mxt_initialize(data);
@@ -1325,12 +1332,18 @@ static int mxt_probe(struct i2c_client *client,
 		goto err_free_irq;
 
 	error = input_register_device(input_dev);
-	if (error)
+	if (error) {
+		dev_err(&client->dev, "Error %d registering input device\n",
+			error);
 		goto err_free_irq;
+	}
 
 	error = sysfs_create_group(&client->dev.kobj, &mxt_attr_group);
-	if (error)
+	if (error) {
+		dev_err(&client->dev, "Failure %d creating sysfs group\n",
+			error);
 		goto err_unregister_device;
+	}
 
 	return 0;
 
-- 
1.8.3.2

