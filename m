Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759226Ab3BVSJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:09:47 -0500
Received: from [89.21.227.133] ([89.21.227.133]:47019 "EHLO
	mail.kdh.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759077Ab3BVSIh (ORCPT
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
Subject: [PATCH 03/40] Input: atmel_mxt_ts - Add memory access interface via sysfs
Date: Fri, 22 Feb 2013 17:57:50 +0000
Message-Id: <1361555907-19840-4-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atmel maXTouch chips can be addressed via an "Object Based Protocol" which
defines how i2c registers are mapped to different functions within the
chips. This interface exposes the register map and allows user-space
utilities to inspect and alter object configuration, and to view diagnostic
data, while the device is running.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   78 ++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 1de1d24..9cfb124 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -49,6 +49,8 @@
 
 #define MXT_OBJECT_SIZE		6
 
+#define MXT_MAX_BLOCK_WRITE	256
+
 /* Object types */
 #define MXT_DEBUG_DIAGNOSTIC_T37	37
 #define MXT_GEN_MESSAGE_T5		5
@@ -249,10 +251,12 @@ struct mxt_data {
 	char phys[64];		/* device physical location */
 	const struct mxt_platform_data *pdata;
 	struct mxt_object *object_table;
+	u16 mem_size;
 	struct mxt_info info;
 	unsigned int irq;
 	unsigned int max_x;
 	unsigned int max_y;
+	struct bin_attribute mem_access_attr;
 
 	/* Cached parameters from object table */
 	u8 T6_reportid;
@@ -794,6 +798,7 @@ static int mxt_get_object_table(struct mxt_data *data)
 	int error;
 	int i;
 	u8 reportid;
+	u16 end_address;
 
 	table_size = data->info.object_num * sizeof(struct mxt_object);
 	error = __mxt_read_reg(client, MXT_OBJECT_START, table_size,
@@ -803,6 +808,7 @@ static int mxt_get_object_table(struct mxt_data *data)
 
 	/* Valid Report IDs start counting from 1 */
 	reportid = 1;
+	data->mem_size = 0;
 	for (i = 0; i < data->info.object_num; i++) {
 		struct mxt_object *object = data->object_table + i;
 		u8 min_id, max_id;
@@ -834,6 +840,12 @@ static int mxt_get_object_table(struct mxt_data *data)
 			data->T9_reportid_max = max_id;
 			break;
 		}
+
+		end_address = object->start_address
+			+ OBP_SIZE(object) * OBP_INSTANCES(object) - 1;
+
+		if (end_address >= data->mem_size)
+			data->mem_size = end_address + 1;
 	}
 
 	return 0;
@@ -1110,6 +1122,56 @@ static ssize_t mxt_update_fw_store(struct device *dev,
 	return count;
 }
 
+static int mxt_check_mem_access_params(struct mxt_data *data, loff_t off,
+				       size_t *count)
+{
+	if (off >= data->mem_size)
+		return -EIO;
+
+	if (off + *count > data->mem_size)
+		*count = data->mem_size - off;
+
+	if (*count > MXT_MAX_BLOCK_WRITE)
+		*count = MXT_MAX_BLOCK_WRITE;
+
+	return 0;
+}
+
+static ssize_t mxt_mem_access_read(struct file *filp, struct kobject *kobj,
+	struct bin_attribute *bin_attr, char *buf, loff_t off, size_t count)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct mxt_data *data = dev_get_drvdata(dev);
+	int ret = 0;
+
+	ret = mxt_check_mem_access_params(data, off, &count);
+	if (ret < 0)
+		return ret;
+
+	if (count > 0)
+		ret = __mxt_read_reg(data->client, off, count, buf);
+
+	return ret == 0 ? count : ret;
+}
+
+static ssize_t mxt_mem_access_write(struct file *filp, struct kobject *kobj,
+	struct bin_attribute *bin_attr, char *buf, loff_t off,
+	size_t count)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct mxt_data *data = dev_get_drvdata(dev);
+	int ret = 0;
+
+	ret = mxt_check_mem_access_params(data, off, &count);
+	if (ret < 0)
+		return ret;
+
+	if (count > 0)
+		ret = __mxt_write_reg(data->client, off, count, buf);
+
+	return ret == 0 ? count : 0;
+}
+
 static DEVICE_ATTR(fw_version, S_IRUGO, mxt_fw_version_show, NULL);
 static DEVICE_ATTR(hw_version, S_IRUGO, mxt_hw_version_show, NULL);
 static DEVICE_ATTR(object, S_IRUGO, mxt_object_show, NULL);
@@ -1247,8 +1309,23 @@ static int mxt_probe(struct i2c_client *client,
 	if (error)
 		goto err_unregister_device;
 
+	sysfs_bin_attr_init(&data->mem_access_attr);
+	data->mem_access_attr.attr.name = "mem_access";
+	data->mem_access_attr.attr.mode = S_IRUGO | S_IWUSR;
+	data->mem_access_attr.read = mxt_mem_access_read;
+	data->mem_access_attr.write = mxt_mem_access_write;
+	data->mem_access_attr.size = data->mem_size;
+
+	if (sysfs_create_bin_file(&client->dev.kobj,
+				  &data->mem_access_attr) < 0) {
+		dev_err(&client->dev, "Failed to create %s\n",
+			data->mem_access_attr.attr.name);
+		goto err_remove_sysfs_group;
+	}
 	return 0;
 
+err_remove_sysfs_group:
+	sysfs_remove_group(&client->dev.kobj, &mxt_attr_group);
 err_unregister_device:
 	input_unregister_device(input_dev);
 	input_dev = NULL;
@@ -1266,6 +1343,7 @@ static int mxt_remove(struct i2c_client *client)
 {
 	struct mxt_data *data = i2c_get_clientdata(client);
 
+	sysfs_remove_bin_file(&client->dev.kobj, &data->mem_access_attr);
 	sysfs_remove_group(&client->dev.kobj, &mxt_attr_group);
 	free_irq(data->irq, data);
 	input_unregister_device(data->input_dev);
-- 
1.7.10.4

