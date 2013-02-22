Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362Ab3BVSOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:14:30 -0500
Received: from [89.21.227.133] ([89.21.227.133]:55429 "EHLO
	mail.kdh.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759053Ab3BVSIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:08:34 -0500
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 05/40] Input: atmel_mxt_ts - Improve error reporting and debug
Date: Fri, 22 Feb 2013 17:57:52 +0000
Message-Id: <1361555907-19840-6-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add error messages for probe errors
Report type in invalid object type
Tweak some other debug output messages

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   35 ++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index dad0be9..9e734dc 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -364,7 +364,7 @@ recheck:
 	}
 
 	if (val != state) {
-		dev_err(&client->dev, "Unvalid bootloader mode state\n");
+		dev_err(&client->dev, "Invalid bootloader mode state\n");
 		return -EINVAL;
 	}
 
@@ -484,7 +484,7 @@ mxt_get_object(struct mxt_data *data, u8 type)
 			return object;
 	}
 
-	dev_err(&data->client->dev, "Invalid object type\n");
+	dev_err(&data->client->dev, "Invalid object type T%u\n", type);
 	return NULL;
 }
 
@@ -834,7 +834,7 @@ static int mxt_get_object_table(struct mxt_data *data)
 		}
 
 		dev_dbg(&data->client->dev,
-			"Type %2d Start %3d Size %3d Instances %2d ReportIDs %3u : %3u\n",
+			"T%u Start:%u Size:%u Instances:%u Report IDs:%u-%u\n",
 			object->type, object->start_address, OBP_SIZE(object),
 			OBP_INSTANCES(object), min_id, max_id);
 
@@ -890,13 +890,18 @@ static int mxt_initialize(struct mxt_data *data)
 
 	/* Get object table information */
 	error = mxt_get_object_table(data);
-	if (error)
-		goto err_free_object_table;
+	if (error) {
+		dev_err(&client->dev, "Error %d reading object table\n", error);
+		return error;
+	}
 
 	/* Check register init values */
 	error = mxt_check_reg_init(data);
-	if (error)
-		goto err_free_object_table;
+	if (error) {
+		dev_err(&client->dev, "Error %d initialising configuration\n",
+			error);
+		return error;
+	}
 
 	mxt_handle_pdata(data);
 
@@ -916,7 +921,7 @@ static int mxt_initialize(struct mxt_data *data)
 	info->matrix_ysize = val;
 
 	dev_info(&client->dev,
-			"Family ID: %u Variant ID: %u Major.Minor.Build: %u.%u.%02X\n",
+			"Family ID: %u Variant ID: %u Firmware V%u.%u.%02X\n",
 			info->family_id, info->variant_id, info->version >> 4,
 			info->version & 0xf, info->build);
 
@@ -1339,16 +1344,24 @@ static int mxt_probe(struct i2c_client *client,
 	}
 
 	error = mxt_make_highchg(data);
-	if (error)
+	if (error) {
+		dev_err(&client->dev, "Error %d clearing messages\n", error);
 		goto err_free_irq;
+	}
 
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
 
 	sysfs_bin_attr_init(&data->mem_access_attr);
 	data->mem_access_attr.attr.name = "mem_access";
-- 
1.7.10.4

