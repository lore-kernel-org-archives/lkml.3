Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126Ab3FER7Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 13:59:24 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:3842 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757088Ab3FERsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 13:48:12 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 44/53] Input: atmel_mxt_ts - Verify Information Block checksum on probe
Date: Wed,  5 Jun 2013 18:37:37 +0100
Message-Id: <1370453866-16534-45-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By reading the information block and the object table into a contiguous region
of memory, we can verify the checksum at probe time. This means we verify that
we are indeed talking to a chip that supports object protocol correctly. We
also detect I2C comms problems much earlier, resulting in easier diagnosis.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |  181 ++++++++++++++++++------------
 1 file changed, 111 insertions(+), 70 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index bbfea7a..e0ff017 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -194,7 +194,8 @@ struct mxt_data {
 	char phys[64];		/* device physical location */
 	struct mxt_platform_data *pdata;
 	struct mxt_object *object_table;
-	struct mxt_info info;
+	struct mxt_info *info;
+	void *raw_info_block;
 	unsigned int irq;
 	unsigned int max_x;
 	unsigned int max_y;
@@ -365,12 +366,16 @@ static int mxt_lookup_bootloader_address(struct mxt_data *data, bool retry)
 {
 	u8 appmode = data->client->addr;
 	u8 bootloader;
+	u8 family_id = 0;
+
+	if (data->info)
+		family_id = data->info->family_id;
 
 	switch (appmode) {
 	case 0x4a:
 	case 0x4b:
 		/* Chips after 1664S use different scheme */
-		if (retry || data->info.family_id >= 0xa2) {
+		if (retry || family_id >= 0xa2) {
 			bootloader = appmode - 0x24;
 			break;
 		}
@@ -610,7 +615,7 @@ mxt_get_object(struct mxt_data *data, u8 type)
 	struct mxt_object *object;
 	int i;
 
-	for (i = 0; i < data->info.object_num; i++) {
+	for (i = 0; i < data->info->object_num; i++) {
 		object = data->object_table + i;
 		if (object->type == type)
 			return object;
@@ -1249,13 +1254,13 @@ static int mxt_check_reg_init(struct mxt_data *data)
 		data_pos += offset;
 	}
 
-	if (cfg_info.family_id != data->info.family_id) {
+	if (cfg_info.family_id != data->info->family_id) {
 		dev_err(dev, "Family ID mismatch!\n");
 		ret = -EINVAL;
 		goto release;
 	}
 
-	if (cfg_info.variant_id != data->info.variant_id) {
+	if (cfg_info.variant_id != data->info->variant_id) {
 		dev_err(dev, "Variant ID mismatch!\n");
 		ret = -EINVAL;
 		goto release;
@@ -1302,7 +1307,7 @@ static int mxt_check_reg_init(struct mxt_data *data)
 
 	/* Malloc memory to store configuration */
 	cfg_start_ofs = MXT_OBJECT_START
-		+ data->info.object_num * sizeof(struct mxt_object)
+		+ data->info->object_num * sizeof(struct mxt_object)
 		+ MXT_INFO_CHECKSUM_SIZE;
 	config_mem_size = data->mem_size - cfg_start_ofs;
 	config_mem = kzalloc(config_mem_size, GFP_KERNEL);
@@ -1510,24 +1515,12 @@ static int mxt_acquire_irq(struct mxt_data *data)
 	return 0;
 }
 
-static int mxt_get_info(struct mxt_data *data)
-{
-	struct i2c_client *client = data->client;
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
 static void mxt_free_object_table(struct mxt_data *data)
 {
-	kfree(data->object_table);
+	kfree(data->raw_info_block);
 	data->object_table = NULL;
+	data->info = NULL;
+	data->raw_info_block = NULL;
 	kfree(data->msg_buf);
 	data->msg_buf = NULL;
 	data->enable_reporting = false;
@@ -1549,25 +1542,17 @@ static void mxt_free_object_table(struct mxt_data *data)
 	data->max_reportid = 0;
 }
 
-static int mxt_get_object_table(struct mxt_data *data)
+static int mxt_parse_object_table(struct mxt_data *data)
 {
 	struct i2c_client *client = data->client;
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
 
@@ -1591,7 +1576,7 @@ static int mxt_get_object_table(struct mxt_data *data)
 
 		switch (object->type) {
 		case MXT_GEN_MESSAGE_T5:
-			if (data->info.family_id == 0x80) {
+			if (data->info->family_id == 0x80) {
 				/* On mXT224 read and discard unused CRC byte
 				 * otherwise DMA reads are misaligned */
 				data->T5_msg_size = mxt_obj_size(object);
@@ -1651,22 +1636,102 @@ static int mxt_get_object_table(struct mxt_data *data)
 	/* If T44 exists, T5 position has to be directly after */
 	if (data->T44_address && (data->T5_address != data->T44_address + 1)) {
 		dev_err(&client->dev, "Invalid T44 position\n");
-		error = -EINVAL;
-		goto free_object_table;
+		return -EINVAL;
 	}
 
 	data->msg_buf = kcalloc(data->max_reportid,
 				data->T5_msg_size, GFP_KERNEL);
 	if (!data->msg_buf) {
 		dev_err(&client->dev, "Failed to allocate message buffer\n");
+		return -ENOMEM;
+	}
+
+	return 0;
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
+	calculated_crc = mxt_calculate_crc(buf, 0,
+					   size - MXT_INFO_CHECKSUM_SIZE);
+
+	/* CRC mismatch can be caused by data corruption due to I2C comms
+	 * issue or else device is not using Object Based Protocol */
+	if ((data->info_crc == 0) || (data->info_crc != calculated_crc)) {
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
+	dev_info(&client->dev,
+		 "Family: %u Variant: %u Firmware V%u.%u.%02X Objects: %u\n",
+		 info->family_id, info->variant_id, info->version >> 4,
+		 info->version & 0xf, info->build, info->object_num);
+
+	/* Parse object table information */
+	error = mxt_parse_object_table(data);
+	if (error) {
+		dev_err(&client->dev, "Error %d reading object table\n", error);
+		mxt_free_object_table(data);
+		return error;
 	}
 
 	return 0;
 
-free_object_table:
-	mxt_free_object_table(data);
+err_free_mem:
+	kfree(buf);
 	return error;
 }
 
@@ -1721,13 +1786,12 @@ static int mxt_read_t9_resolution(struct mxt_data *data)
 static int mxt_initialize(struct mxt_data *data)
 {
 	struct i2c_client *client = data->client;
-	struct mxt_info *info = &data->info;
 	int error;
 	bool alt_bootloader_addr = false;
 	bool retry = false;
 
 retry_info:
-	error = mxt_get_info(data);
+	error = mxt_read_info_block(data);
 	if (error) {
 retry_bootloader:
 		error = mxt_probe_bootloader(data, alt_bootloader_addr);
@@ -1759,21 +1823,6 @@ retry_bootloader:
 		}
 	}
 
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
-		goto err_free_object_table;
-	}
-
 	error = mxt_acquire_irq(data);
 	if (error)
 		goto err_free_object_table;
@@ -1792,17 +1841,6 @@ retry_bootloader:
 		goto err_free_object_table;
 	}
 
-	error = mxt_read_t9_resolution(data);
-	if (error) {
-		dev_err(&client->dev, "Failed to initialize T9 resolution\n");
-		goto err_free_object_table;
-	}
-
-	dev_info(&client->dev,
-		 "Family: %u Variant: %u Firmware V%u.%u.%02X Objects: %u\n",
-		 info->family_id, info->variant_id, info->version >> 4,
-		 info->version & 0xf, info->build, info->object_num);
-
 	data->enable_reporting = true;
 
 	return 0;
@@ -1817,9 +1855,9 @@ static ssize_t mxt_fw_version_show(struct device *dev,
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
@@ -1827,9 +1865,8 @@ static ssize_t mxt_hw_version_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
 	struct mxt_data *data = dev_get_drvdata(dev);
-	struct mxt_info *info = &data->info;
 	return scnprintf(buf, PAGE_SIZE, "%u.%u\n",
-			 info->family_id, info->variant_id);
+			data->info->family_id, data->info->variant_id);
 }
 
 static ssize_t mxt_show_instance(char *buf, int count,
@@ -1866,7 +1903,7 @@ static ssize_t mxt_object_show(struct device *dev,
 		return -ENOMEM;
 
 	error = 0;
-	for (i = 0; i < data->info.object_num; i++) {
+	for (i = 0; i < data->info->object_num; i++) {
 		object = data->object_table + i;
 
 		if (!mxt_object_readable(object->type))
@@ -2211,6 +2248,10 @@ static int mxt_initialize_t9_input_device(struct mxt_data *data)
 	unsigned int mt_flags = 0;
 	int i;
 
+	error = mxt_read_t9_resolution(data);
+	if (error)
+		dev_warn(dev, "Failed to initialize T9 resolution\n");
+
 	input_dev = input_allocate_device();
 	if (!input_dev) {
 		dev_err(dev, "Failed to allocate memory\n");
-- 
1.7.10.4

