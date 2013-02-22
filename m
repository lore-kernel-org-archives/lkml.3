Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321Ab3BVSJb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:09:31 -0500
Received: from [89.21.227.133] ([89.21.227.133]:47367 "EHLO
	mail.kdh.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759090Ab3BVSIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:08:37 -0500
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 33/40] Input: atmel_mxt_ts - Verify Information Block checksum on probe
Date: Fri, 22 Feb 2013 17:58:20 +0000
Message-Id: <1361555907-19840-34-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By reading the information block and the object table into a contiguous region
of memory, we can verify the checksum at probe time. This means we verify that
we are indeed talking to a chip that supports object protocol correctly. We
also detect I2C comms problems much earlier, resulting in easier diagnosis.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |  217 ++++++++++++++++++------------
 1 file changed, 129 insertions(+), 88 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 2f3793a..6dbd3d6 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -30,6 +30,7 @@
 /* Registers */
 #define MXT_OBJECT_START	0x07
 #define MXT_OBJECT_SIZE		6
+#define MXT_INFO_CHECKSUM_SIZE	3
 #define MXT_MAX_BLOCK_WRITE	256
 
 /* Object types */
@@ -199,7 +200,8 @@ struct mxt_data {
 	enum mxt_device_state state;
 	struct mxt_object *object_table;
 	u16 mem_size;
-	struct mxt_info info;
+	struct mxt_info *info;
+	void *raw_info_block;
 	unsigned int irq;
 	unsigned int max_x;
 	unsigned int max_y;
@@ -574,7 +576,7 @@ mxt_get_object(struct mxt_data *data, u8 type)
 	struct mxt_object *object;
 	int i;
 
-	for (i = 0; i < data->info.object_num; i++) {
+	for (i = 0; i < data->info->object_num; i++) {
 		object = data->object_table + i;
 		if (object->type == type)
 			return object;
@@ -1184,7 +1186,7 @@ static int mxt_check_reg_init(struct mxt_data *data)
 
 	/* Malloc memory to store configuration */
 	config_start_offset = MXT_OBJECT_START
-		+ data->info.object_num * sizeof(struct mxt_object);
+		+ data->info->object_num * sizeof(struct mxt_object);
 	config_mem_size = data->mem_size - config_start_offset;
 	config_mem = kzalloc(config_mem_size, GFP_KERNEL);
 	if (!config_mem) {
@@ -1381,53 +1383,17 @@ recheck:
 	}
 }
 
-static int mxt_get_info(struct mxt_data *data)
+static int mxt_parse_object_table(struct mxt_data *data)
 {
 	struct i2c_client *client = data->client;
-	struct mxt_info *info = &data->info;
-	int error;
-
-	/* Read 7-byte info block starting at address 0 */
-	error = __mxt_read_reg(client, 0, sizeof(*info), info);
-	if (error)
-		return error;
-
-	return 0;
-}
-
-static void mxt_free_object_table(struct mxt_data *data)
-{
-	kfree(data->object_table);
-	data->object_table = NULL;
-	kfree(data->msg_buf);
-	data->msg_buf = NULL;
-	data->T5_address = 0;
-	data->T5_msg_size = 0;
-	data->T6_reportid = 0;
-	data->T7_address = 0;
-	data->T9_reportid_min = 0;
-	data->T9_reportid_max = 0;
-}
-
-static int mxt_get_object_table(struct mxt_data *data)
-{
-	struct i2c_client *client = data->client;
-	size_t table_size;
-	int error;
 	int i;
 	u8 reportid;
 	u16 end_address;
 
-	table_size = data->info.object_num * sizeof(struct mxt_object);
-	error = __mxt_read_reg(client, MXT_OBJECT_START, table_size,
-			data->object_table);
-	if (error)
-		return error;
-
 	/* Valid Report IDs start counting from 1 */
 	reportid = 1;
 	data->mem_size = 0;
-	for (i = 0; i < data->info.object_num; i++) {
+	for (i = 0; i < data->info->object_num; i++) {
 		struct mxt_object *object = data->object_table + i;
 		u8 min_id, max_id;
 
@@ -1450,7 +1416,7 @@ static int mxt_get_object_table(struct mxt_data *data)
 
 		switch (object->type) {
 		case MXT_GEN_MESSAGE_T5:
-			if (data->info.family_id == 0x80) {
+			if (data->info->family_id == 0x80) {
 				/* On mXT224 read and discard unused CRC byte
 				 * otherwise DMA reads are misaligned */
 				data->T5_msg_size = OBP_SIZE(object);
@@ -1507,21 +1473,119 @@ static int mxt_get_object_table(struct mxt_data *data)
 	/* If T44 exists, T5 position has to be directly after */
 	if (data->T44_address && (data->T5_address != data->T44_address + 1)) {
 		dev_err(&client->dev, "Invalid T44 position\n");
-		error = -EINVAL;
-		goto free_object_table;
+		return -EINVAL;
 	}
 
 	data->msg_buf = kcalloc(data->max_reportid, data->T5_msg_size, GFP_KERNEL);
 	if (!data->msg_buf) {
 		dev_err(&client->dev, "Failed to allocate message buffer\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void mxt_free_object_table(struct mxt_data *data)
+{
+	kfree(data->raw_info_block);
+	data->raw_info_block = NULL;
+	data->info = NULL;
+	data->object_table = NULL;
+	kfree(data->msg_buf);
+	data->msg_buf = NULL;
+	data->T5_address = 0;
+	data->T5_msg_size = 0;
+	data->T6_address = 0;
+	data->T6_reportid = 0;
+	data->T7_address = 0;
+	data->T9_reportid_min = 0;
+	data->T9_reportid_max = 0;
+}
+
+static int mxt_read_info_block(struct mxt_data *data)
+{
+	struct i2c_client *client = data->client;
+	int error;
+	size_t size;
+	void *buf;
+	struct mxt_info *info;
+	u32 calculated_crc;
+	u8 *crc_ptr;
+
+	/* If info block already allocated, free it */
+	if (data->raw_info_block != NULL)
+		mxt_free_object_table(data);
+
+	/* Read 7-byte ID information block starting at address 0 */
+	size = sizeof(struct mxt_info);
+	buf = kzalloc(size, GFP_KERNEL);
+	if (!buf) {
+		dev_err(&client->dev, "Failed to allocate memory\n");
+		return -ENOMEM;
+	}
+
+	error = __mxt_read_reg(client, 0, size, buf);
+	if (error)
+		goto err_free_mem;
+
+	/* Resize buffer to give space for rest of info block */
+	info = (struct mxt_info *)buf;
+	size += (info->object_num * sizeof(struct mxt_object))
+		+ MXT_INFO_CHECKSUM_SIZE;
+
+	buf = krealloc(buf, size, GFP_KERNEL);
+	if (!buf) {
+		dev_err(&client->dev, "Failed to allocate memory\n");
 		error = -ENOMEM;
-		goto free_object_table;
+		goto err_free_mem;
+	}
+
+	/* Read rest of info block */
+	error = __mxt_read_reg(client, MXT_OBJECT_START,
+			       size - MXT_OBJECT_START,
+			       buf + MXT_OBJECT_START);
+	if (error)
+		goto err_free_mem;
+
+	/* Extract & calculate checksum */
+	crc_ptr = buf + size - MXT_INFO_CHECKSUM_SIZE;
+	data->info_crc = crc_ptr[0] | (crc_ptr[1] << 8) | (crc_ptr[2] << 16);
+
+	calculated_crc = mxt_calculate_crc(buf, 0, size - MXT_INFO_CHECKSUM_SIZE);
+
+	/* CRC mismatch can be caused by data corruption due to I2C comms
+	 * issue or else device is not using Object Based Protocol */
+	if (data->info_crc != calculated_crc) {
+		dev_err(&client->dev,
+			"Info Block CRC error calculated=0x%06X read=0x%06X\n",
+			data->info_crc, calculated_crc);
+		return -EIO;
+	}
+
+	/* Save pointers in device data structure */
+	data->raw_info_block = buf;
+	data->info = (struct mxt_info *)buf;
+	data->object_table = (struct mxt_object *)(buf + MXT_OBJECT_START);
+
+	/* Parse object table information */
+	error = mxt_parse_object_table(data);
+	if (error) {
+		dev_err(&client->dev, "Error %d reading object table\n", error);
+		mxt_free_object_table(data);
+		return error;
 	}
 
+	dev_info(&client->dev,
+			"Family ID: %u Variant ID: %u Firmware V%u.%u.%02X "
+			" Object Num:%d\n",
+			data->info->family_id, data->info->variant_id,
+			data->info->version >> 4, data->info->version & 0xf,
+			data->info->build, data->info->object_num);
+
 	return 0;
 
-free_object_table:
-	mxt_free_object_table(data);
+err_free_mem:
+	kfree(buf);
 	return error;
 }
 
@@ -1538,7 +1602,7 @@ static int mxt_read_t9_resolution(struct mxt_data *data)
 		return -EINVAL;
 
 	/* Update matrix size in info struct (may change after reset) */
-	error = mxt_get_info(data);
+	error = mxt_read_info_block(data);
 	if (error)
 		return error;
 
@@ -1574,7 +1638,7 @@ static int mxt_read_t9_resolution(struct mxt_data *data)
 
 	dev_info(&client->dev,
 			"Matrix Size X%uY%u Touchscreen size X%uY%u\n",
-			data->info.matrix_xsize, data->info.matrix_ysize,
+			data->info->matrix_xsize, data->info->matrix_ysize,
 			data->max_x, data->max_y);
 
 	return 0;
@@ -1583,12 +1647,11 @@ static int mxt_read_t9_resolution(struct mxt_data *data)
 static int mxt_initialize(struct mxt_data *data)
 {
 	struct i2c_client *client = data->client;
-	struct mxt_info *info = &data->info;
 	int error;
 	u8 retry_count = 0;
 
 retry_probe:
-	error = mxt_get_info(data);
+	error = mxt_read_info_block(data);
 	if (error) {
 		error = mxt_probe_bootloader(data);
 		if (error) {
@@ -1614,21 +1677,6 @@ retry_probe:
 
 	data->state = APPMODE;
 
-	data->object_table = kcalloc(info->object_num,
-				     sizeof(struct mxt_object),
-				     GFP_KERNEL);
-	if (!data->object_table) {
-		dev_err(&client->dev, "Failed to allocate memory\n");
-		return -ENOMEM;
-	}
-
-	/* Get object table information */
-	error = mxt_get_object_table(data);
-	if (error) {
-		dev_err(&client->dev, "Error %d reading object table\n", error);
-		return error;
-	}
-
 	/* Check register init values */
 	error = mxt_check_reg_init(data);
 	if (error) {
@@ -1643,16 +1691,6 @@ retry_probe:
 		return error;
 	}
 
-	error = mxt_read_t9_resolution(data);
-	if (error)
-		dev_warn(&client->dev, "Failed to initialize T9 resolution\n");
-
-	dev_info(&client->dev,
-			"Family ID: %u Variant ID: %u Firmware V%u.%u.%02X "
-			" Object Num:%d\n",
-			info->family_id, info->variant_id, info->version >> 4,
-			info->version & 0xf, info->build, info->object_num);
-
 	return 0;
 }
 
@@ -1661,9 +1699,9 @@ static ssize_t mxt_fw_version_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
 	struct mxt_data *data = dev_get_drvdata(dev);
-	struct mxt_info *info = &data->info;
 	return scnprintf(buf, PAGE_SIZE, "%u.%u.%02X\n",
-			 info->version >> 4, info->version & 0xf, info->build);
+			 data->info->version >> 4, data->info->version & 0xf,
+			 data->info->build);
 }
 
 /* Hardware Version is returned as FamilyID.VariantID */
@@ -1671,9 +1709,8 @@ static ssize_t mxt_hw_version_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
 	struct mxt_data *data = dev_get_drvdata(dev);
-	struct mxt_info *info = &data->info;
 	return scnprintf(buf, PAGE_SIZE, "%u.%u\n",
-			 info->family_id, info->variant_id);
+			data->info->family_id, data->info->variant_id);
 }
 
 static ssize_t mxt_show_instance(char *buf, int count,
@@ -1710,7 +1747,7 @@ static ssize_t mxt_object_show(struct device *dev,
 		return -ENOMEM;
 
 	error = 0;
-	for (i = 0; i < data->info.object_num; i++) {
+	for (i = 0; i < data->info->object_num; i++) {
 		object = data->object_table + i;
 
 		if (!mxt_object_readable(object->type))
@@ -2041,6 +2078,10 @@ static int mxt_initialize_t9_input_device(struct mxt_data *data)
 	unsigned int num_mt_slots;
 	int key;
 
+	error = mxt_read_t9_resolution(data);
+	if (error)
+		dev_warn(&client->dev, "Failed to initialize T9 resolution\n");
+
 	input_dev = input_allocate_device();
 	if (!input_dev) {
 		dev_err(&client->dev, "Failed to allocate memory\n");
@@ -2149,6 +2190,13 @@ static int mxt_probe(struct i2c_client *client,
 	if (error)
 		goto err_free_mem;
 
+	error = mxt_initialize_t9_input_device(data);
+	if (error) {
+		dev_err(&client->dev, "Error %d registering input device\n",
+			error);
+		goto err_free_irq;
+	}
+
 	error = request_threaded_irq(client->irq, NULL, mxt_interrupt,
 				     pdata->irqflags | IRQF_ONESHOT,
 				     client->name, data);
@@ -2163,13 +2211,6 @@ static int mxt_probe(struct i2c_client *client,
 			goto err_free_irq;
 	}
 
-	error = mxt_initialize_t9_input_device(data);
-	if (error) {
-		dev_err(&client->dev, "Error %d registering input device\n",
-			error);
-		goto err_free_irq;
-	}
-
 	error = sysfs_create_group(&client->dev.kobj, &mxt_attr_group);
 	if (error) {
 		dev_err(&client->dev, "Failure %d creating sysfs group\n",
-- 
1.7.10.4

