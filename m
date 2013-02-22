Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307Ab3BVSRs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:17:48 -0500
Received: from [89.21.227.133] ([89.21.227.133]:47019 "EHLO
	mail.kdh.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759005Ab3BVSIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:08:32 -0500
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 35/40] Input: atmel_mxt_ts - Improve messages relating to info block read
Date: Fri, 22 Feb 2013 17:58:22 +0000
Message-Id: <1361555907-19840-36-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The matrix size is only used to print out a debug message, and results in some
rather confusing code to re-read it if the device configuration is updated. So
don't print it out.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 83a0837..267b5d8 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -1390,6 +1390,8 @@ static int mxt_parse_object_table(struct mxt_data *data)
 	u8 reportid;
 	u16 end_address;
 
+	dev_dbg(&client->dev, "Object num: %d\n", data->info->object_num);
+
 	/* Valid Report IDs start counting from 1 */
 	reportid = 1;
 	data->mem_size = 0;
@@ -1567,6 +1569,12 @@ static int mxt_read_info_block(struct mxt_data *data)
 	data->info = (struct mxt_info *)buf;
 	data->object_table = (struct mxt_object *)(buf + MXT_OBJECT_START);
 
+	dev_info(&client->dev,
+			"Family ID: %u Variant ID: %u Firmware: V%u.%u.%02X",
+			data->info->family_id, data->info->variant_id,
+			data->info->version >> 4, data->info->version & 0xf,
+			data->info->build);
+
 	/* Parse object table information */
 	error = mxt_parse_object_table(data);
 	if (error) {
@@ -1575,13 +1583,6 @@ static int mxt_read_info_block(struct mxt_data *data)
 		return error;
 	}
 
-	dev_info(&client->dev,
-			"Family ID: %u Variant ID: %u Firmware V%u.%u.%02X "
-			" Object Num:%d\n",
-			data->info->family_id, data->info->variant_id,
-			data->info->version >> 4, data->info->version & 0xf,
-			data->info->build, data->info->object_num);
-
 	return 0;
 
 err_free_mem:
@@ -1601,11 +1602,6 @@ static int mxt_read_t9_resolution(struct mxt_data *data)
 	if (!object)
 		return -EINVAL;
 
-	/* Update matrix size in info struct (may change after reset) */
-	error = mxt_read_info_block(data);
-	if (error)
-		return error;
-
 	error = __mxt_read_reg(client,
 			       object->start_address + MXT_T9_RANGE,
 			       sizeof(range), &range);
@@ -1636,10 +1632,8 @@ static int mxt_read_t9_resolution(struct mxt_data *data)
 		data->max_y = range.y;
 	}
 
-	dev_info(&client->dev,
-			"Matrix Size X%uY%u Touchscreen size X%uY%u\n",
-			data->info->matrix_xsize, data->info->matrix_ysize,
-			data->max_x, data->max_y);
+	dev_info(&client->dev, "Touchscreen size X%uY%u\n",
+		 data->max_x, data->max_y);
 
 	return 0;
 }
-- 
1.7.10.4

