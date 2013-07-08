Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324Ab3GHI1O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 04:27:14 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:38184 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab3GHI1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 04:27:09 -0400
From: Balint Czobor <czoborbalint@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Balint Czobor <czoborbalint@gmail.com>
Subject: [PATCH 1/1] drivers: input: touchscreen: Initial support for SYNAPTICS_I2C_RMI touchscreen
Date: Mon,  8 Jul 2013 10:25:47 +0200
Message-Id: <1373271947-8393-1-git-send-email-czoborbalint@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add initial support for Synaptics RMI over I2C based touchscreens.

Signed-off-by: Balint Czobor <czoborbalint@gmail.com>
---
 drivers/input/touchscreen/Kconfig             |   13 +
 drivers/input/touchscreen/Makefile            |    1 +
 drivers/input/touchscreen/rmi_dev.c           |  735 ++++
 drivers/input/touchscreen/rmi_f54.c           | 4513 +++++++++++++++++++++++++
 drivers/input/touchscreen/rmi_fw_update.c     | 1732 ++++++++++
 drivers/input/touchscreen/synaptics_i2c_rmi.c | 4328 ++++++++++++++++++++++++
 drivers/input/touchscreen/synaptics_i2c_rmi.h |  399 +++
 7 files changed, 11721 insertions(+)
 create mode 100644 drivers/input/touchscreen/rmi_dev.c
 create mode 100644 drivers/input/touchscreen/rmi_f54.c
 create mode 100644 drivers/input/touchscreen/rmi_fw_update.c
 create mode 100644 drivers/input/touchscreen/synaptics_i2c_rmi.c
 create mode 100644 drivers/input/touchscreen/synaptics_i2c_rmi.h

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 3b9758b..6d2e009 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -514,6 +514,19 @@ config TOUCHSCREEN_MIGOR
 	  To compile this driver as a module, choose M here: the
 	  module will be called migor_ts.
 
+config TOUCHSCREEN_SYNAPTICS_I2C_RMI
+	tristate "Synaptics i2c touchscreen"
+	depends on I2C
+	help
+	  This enables support for Synaptics RMI over I2C based touchscreens.
+
+config TOUCHSCREEN_SYNAPTICS_PREVENT_HSYNC_LEAKAGE
+	bool "Synaptics prevent leakage i2c due to hsync"
+	default n
+	help
+	  There is leakage current on TSP I2C by HW defect. TSP I2C Failed.
+	  So To prevent leakage, hsync off, tsp on, hsync on.
+
 config TOUCHSCREEN_TNETV107X
 	tristate "TI TNETV107X touchscreen support"
 	depends on ARCH_DAVINCI_TNETV107X
diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index f5216c1..7826e31 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -54,6 +54,7 @@ obj-$(CONFIG_TOUCHSCREEN_PIXCIR)	+= pixcir_i2c_ts.o
 obj-$(CONFIG_TOUCHSCREEN_S3C2410)	+= s3c2410_ts.o
 obj-$(CONFIG_TOUCHSCREEN_ST1232)	+= st1232.o
 obj-$(CONFIG_TOUCHSCREEN_STMPE)		+= stmpe-ts.o
+obj-$(CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI)	+= synaptics_i2c_rmi.o rmi_dev.o rmi_f54.o rmi_fw_update.o
 obj-$(CONFIG_TOUCHSCREEN_TI_AM335X_TSC)	+= ti_am335x_tsc.o
 obj-$(CONFIG_TOUCHSCREEN_TNETV107X)	+= tnetv107x-ts.o
 obj-$(CONFIG_TOUCHSCREEN_TOUCHIT213)	+= touchit213.o
diff --git a/drivers/input/touchscreen/rmi_dev.c b/drivers/input/touchscreen/rmi_dev.c
new file mode 100644
index 0000000..6eea06d
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_dev.c
@@ -0,0 +1,735 @@
+/* Synaptics Register Mapped Interface (RMI4) I2C Physical Layer Driver.
+ * Copyright (c) 2007-2012, Synaptics Incorporated
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <asm/unaligned.h>
+#include <mach/cpufreq.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/input.h>
+#include <linux/gpio.h>
+#include <linux/uaccess.h>
+#include <linux/cdev.h>
+#include "synaptics_i2c_rmi.h"
+
+#define CHAR_DEVICE_NAME "rmi"
+#define DEVICE_CLASS_NAME "rmidev"
+#define DEV_NUMBER 1
+#define REG_ADDR_LIMIT 0xFFFF
+
+static ssize_t rmidev_sysfs_data_show(struct file *data_file,
+		struct kobject *kobj, struct bin_attribute *attributes,
+		char *buf, loff_t pos, size_t count);
+
+static ssize_t rmidev_sysfs_data_store(struct file *data_file,
+		struct kobject *kobj, struct bin_attribute *attributes,
+		char *buf, loff_t pos, size_t count);
+
+static ssize_t rmidev_sysfs_open_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count);
+
+static ssize_t rmidev_sysfs_release_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count);
+
+static ssize_t rmidev_sysfs_address_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count);
+
+static ssize_t rmidev_sysfs_length_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count);
+
+static ssize_t rmidev_sysfs_attn_state_show(struct device *dev,
+		struct device_attribute *attr, char *buf);
+
+struct rmidev_handle {
+	dev_t dev_no;
+	unsigned short address;
+	unsigned int length;
+	struct device dev;
+	struct synaptics_rmi4_data *rmi4_data;
+	struct synaptics_rmi4_exp_fn_ptr *fn_ptr;
+	struct kobject *sysfs_dir;
+	void *data;
+};
+
+struct rmidev_data {
+	int ref_count;
+	struct cdev main_dev;
+	struct class *device_class;
+	struct mutex file_mutex;
+	struct rmidev_handle *rmi_dev;
+};
+
+static struct bin_attribute attr_data = {
+	.attr = {
+		.name = "data",
+		.mode = (S_IRUGO | S_IWUSR | S_IWGRP),
+	},
+	.size = 0,
+	.read = rmidev_sysfs_data_show,
+	.write = rmidev_sysfs_data_store,
+};
+
+static struct device_attribute attrs[] = {
+	__ATTR(open, S_IWUSR | S_IWGRP,
+			synaptics_rmi4_show_error,
+			rmidev_sysfs_open_store),
+	__ATTR(release, S_IWUSR | S_IWGRP,
+			synaptics_rmi4_show_error,
+			rmidev_sysfs_release_store),
+	__ATTR(address, S_IWUSR | S_IWGRP,
+			synaptics_rmi4_show_error,
+			rmidev_sysfs_address_store),
+	__ATTR(length, S_IWUSR | S_IWGRP,
+			synaptics_rmi4_show_error,
+			rmidev_sysfs_length_store),
+	__ATTR(attn_state, S_IRUGO,
+			rmidev_sysfs_attn_state_show,
+			synaptics_rmi4_store_error),
+};
+
+static int rmidev_major_num;
+
+static struct class *rmidev_device_class;
+
+static struct rmidev_handle *rmidev;
+
+static ssize_t rmidev_sysfs_data_show(struct file *data_file,
+		struct kobject *kobj, struct bin_attribute *attributes,
+		char *buf, loff_t pos, size_t count)
+{
+	int retval;
+	unsigned int data_length = rmidev->length;
+
+	if (data_length > (REG_ADDR_LIMIT - rmidev->address))
+		data_length = REG_ADDR_LIMIT - rmidev->address;
+
+	if (count < data_length) {
+		dev_err(&rmidev->rmi4_data->i2c_client->dev,
+				"%s: Not enough space (%d bytes) in buffer\n",
+				__func__, count);
+		return -EINVAL;
+	}
+
+	if (data_length) {
+		retval = rmidev->fn_ptr->read(rmidev->rmi4_data,
+				rmidev->address,
+				(unsigned char *)buf,
+				data_length);
+		if (retval < 0) {
+			dev_err(&rmidev->rmi4_data->i2c_client->dev,
+					"%s: Failed to read data\n",
+					__func__);
+			return retval;
+		}
+	} else {
+		return -EINVAL;
+	}
+
+	return data_length;
+}
+
+static ssize_t rmidev_sysfs_data_store(struct file *data_file,
+		struct kobject *kobj, struct bin_attribute *attributes,
+		char *buf, loff_t pos, size_t count)
+{
+	int retval;
+	unsigned int data_length = rmidev->length;
+
+	if (data_length > (REG_ADDR_LIMIT - rmidev->address))
+		data_length = REG_ADDR_LIMIT - rmidev->address;
+
+	if (data_length) {
+		retval = rmidev->fn_ptr->write(rmidev->rmi4_data,
+				rmidev->address,
+				(unsigned char *)buf,
+				data_length);
+		if (retval < 0) {
+			dev_err(&rmidev->rmi4_data->i2c_client->dev,
+					"%s: Failed to write data\n",
+					__func__);
+			return retval;
+		}
+	} else {
+		return -EINVAL;
+	}
+
+	return count;
+}
+
+static ssize_t rmidev_sysfs_open_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	unsigned int input;
+
+	if (sscanf(buf, "%u", &input) != 1)
+			return -EINVAL;
+
+	if (input != 1)
+		return -EINVAL;
+
+	rmidev->fn_ptr->enable(rmidev->rmi4_data, false);
+	dev_dbg(&rmidev->rmi4_data->i2c_client->dev,
+			"%s: Attention interrupt disabled\n",
+			__func__);
+
+	return count;
+}
+
+static ssize_t rmidev_sysfs_release_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	unsigned int input;
+
+	if (sscanf(buf, "%u", &input) != 1)
+			return -EINVAL;
+
+	if (input != 1)
+		return -EINVAL;
+
+	rmidev->fn_ptr->enable(rmidev->rmi4_data, true);
+	dev_dbg(&rmidev->rmi4_data->i2c_client->dev,
+			"%s: Attention interrupt enabled\n",
+			__func__);
+
+	return count;
+}
+
+static ssize_t rmidev_sysfs_address_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	unsigned int input;
+
+	if (sscanf(buf, "%u", &input) != 1)
+			return -EINVAL;
+
+	if (input > REG_ADDR_LIMIT)
+		return -EINVAL;
+
+	rmidev->address = (unsigned short)input;
+
+	return count;
+}
+
+static ssize_t rmidev_sysfs_length_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	unsigned int input;
+
+	if (sscanf(buf, "%u", &input) != 1)
+			return -EINVAL;
+
+	if (input > REG_ADDR_LIMIT)
+		return -EINVAL;
+
+	rmidev->length = input;
+
+	return count;
+}
+
+static ssize_t rmidev_sysfs_attn_state_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	int attn_state;
+	const struct synaptics_rmi4_platform_data *platform_data =
+			rmidev->rmi4_data->board;
+
+	attn_state = gpio_get_value(platform_data->gpio);
+
+	return snprintf(buf, PAGE_SIZE, "%u\n", attn_state);
+}
+
+/*
+ * rmidev_llseek - used to set up register address
+ *
+ * @filp: file structure for seek
+ * @off: offset
+ *   if whence == SEEK_SET,
+ *     high 16 bits: page address
+ *     low 16 bits: register address
+ *   if whence == SEEK_CUR,
+ *     offset from current position
+ *   if whence == SEEK_END,
+ *     offset from end position (0xFFFF)
+ * @whence: SEEK_SET, SEEK_CUR, or SEEK_END
+ */
+static loff_t rmidev_llseek(struct file *filp, loff_t off, int whence)
+{
+	loff_t newpos;
+	struct rmidev_data *dev_data = filp->private_data;
+
+	if (IS_ERR(dev_data)) {
+		pr_err("%s: Pointer of char device data is invalid", __func__);
+		return -EBADF;
+	}
+
+	mutex_lock(&(dev_data->file_mutex));
+
+	switch (whence) {
+	case SEEK_SET:
+		newpos = off;
+		break;
+	case SEEK_CUR:
+		newpos = filp->f_pos + off;
+		break;
+	case SEEK_END:
+		newpos = REG_ADDR_LIMIT + off;
+		break;
+	default:
+		newpos = -EINVAL;
+		goto clean_up;
+	}
+
+	if (newpos < 0 || newpos > REG_ADDR_LIMIT) {
+		dev_err(&rmidev->rmi4_data->i2c_client->dev,
+				"%s: New position 0x%04x is invalid\n",
+				__func__, (unsigned int)newpos);
+		newpos = -EINVAL;
+		goto clean_up;
+	}
+
+	filp->f_pos = newpos;
+
+clean_up:
+	mutex_unlock(&(dev_data->file_mutex));
+
+	return newpos;
+}
+
+/*
+ * rmidev_read: - use to read data from rmi device
+ *
+ * @filp: file structure for read
+ * @buf: user space buffer pointer
+ * @count: number of bytes to read
+ * @f_pos: offset (starting register address)
+ */
+static ssize_t rmidev_read(struct file *filp, char __user *buf,
+		size_t count, loff_t *f_pos)
+{
+	ssize_t retval;
+	unsigned char tmpbuf[count + 1];
+	struct rmidev_data *dev_data = filp->private_data;
+
+	if (IS_ERR(dev_data)) {
+		pr_err("%s: Pointer of char device data is invalid", __func__);
+		return -EBADF;
+	}
+
+	if (count == 0)
+		return 0;
+
+	if (count > (REG_ADDR_LIMIT - *f_pos))
+		count = REG_ADDR_LIMIT - *f_pos;
+
+	mutex_lock(&(dev_data->file_mutex));
+
+	retval = rmidev->fn_ptr->read(rmidev->rmi4_data,
+			*f_pos,
+			tmpbuf,
+			count);
+	if (retval < 0)
+		goto clean_up;
+
+	if (copy_to_user(buf, tmpbuf, count))
+		retval = -EFAULT;
+	else
+		*f_pos += retval;
+
+clean_up:
+	mutex_unlock(&(dev_data->file_mutex));
+
+	return retval;
+}
+
+/*
+ * rmidev_write: - used to write data to rmi device
+ *
+ * @filep: file structure for write
+ * @buf: user space buffer pointer
+ * @count: number of bytes to write
+ * @f_pos: offset (starting register address)
+ */
+static ssize_t rmidev_write(struct file *filp, const char __user *buf,
+		size_t count, loff_t *f_pos)
+{
+	ssize_t retval;
+	unsigned char tmpbuf[count + 1];
+	struct rmidev_data *dev_data = filp->private_data;
+
+	if (IS_ERR(dev_data)) {
+		pr_err("%s: Pointer of char device data is invalid", __func__);
+		return -EBADF;
+	}
+
+	if (count == 0)
+		return 0;
+
+	if (count > (REG_ADDR_LIMIT - *f_pos))
+		count = REG_ADDR_LIMIT - *f_pos;
+
+	if (copy_from_user(tmpbuf, buf, count))
+		return -EFAULT;
+
+	mutex_lock(&(dev_data->file_mutex));
+
+	retval = rmidev->fn_ptr->write(rmidev->rmi4_data,
+			*f_pos,
+			tmpbuf,
+			count);
+	if (retval >= 0)
+		*f_pos += retval;
+
+	mutex_unlock(&(dev_data->file_mutex));
+
+	return retval;
+}
+
+/*
+ * rmidev_open: enable access to rmi device
+ * @inp: inode struture
+ * @filp: file structure
+ */
+static int rmidev_open(struct inode *inp, struct file *filp)
+{
+	int retval = 0;
+	struct rmidev_data *dev_data =
+			container_of(inp->i_cdev, struct rmidev_data, main_dev);
+
+	if (!dev_data)
+		return -EACCES;
+
+	filp->private_data = dev_data;
+
+	mutex_lock(&(dev_data->file_mutex));
+
+	rmidev->fn_ptr->enable(rmidev->rmi4_data, false);
+	dev_dbg(&rmidev->rmi4_data->i2c_client->dev,
+			"%s: Attention interrupt disabled\n",
+			__func__);
+
+	if (dev_data->ref_count < 1)
+		dev_data->ref_count++;
+	else
+		retval = -EACCES;
+
+	mutex_unlock(&(dev_data->file_mutex));
+
+	return retval;
+}
+
+/*
+ * rmidev_release: - release access to rmi device
+ * @inp: inode structure
+ * @filp: file structure
+ */
+static int rmidev_release(struct inode *inp, struct file *filp)
+{
+	struct rmidev_data *dev_data =
+			container_of(inp->i_cdev, struct rmidev_data, main_dev);
+
+	if (!dev_data)
+		return -EACCES;
+
+	mutex_lock(&(dev_data->file_mutex));
+
+	dev_data->ref_count--;
+	if (dev_data->ref_count < 0)
+		dev_data->ref_count = 0;
+
+	rmidev->fn_ptr->enable(rmidev->rmi4_data, true);
+	dev_dbg(&rmidev->rmi4_data->i2c_client->dev,
+			"%s: Attention interrupt enabled\n",
+			__func__);
+
+	mutex_unlock(&(dev_data->file_mutex));
+
+	return 0;
+}
+
+static const struct file_operations rmidev_fops = {
+	.owner = THIS_MODULE,
+	.llseek = rmidev_llseek,
+	.read = rmidev_read,
+	.write = rmidev_write,
+	.open = rmidev_open,
+	.release = rmidev_release,
+};
+
+static void rmidev_device_cleanup(struct rmidev_data *dev_data)
+{
+	dev_t devno;
+
+	if (dev_data) {
+		devno = dev_data->main_dev.dev;
+
+		if (dev_data->device_class)
+			device_destroy(dev_data->device_class, devno);
+
+		cdev_del(&dev_data->main_dev);
+
+		unregister_chrdev_region(devno, 1);
+
+		dev_dbg(&rmidev->rmi4_data->i2c_client->dev,
+				"%s: rmidev device removed\n",
+				__func__);
+	}
+
+	return;
+}
+
+static char *rmi_char_devnode(struct device *dev, mode_t *mode)
+{
+	if (!mode)
+		return NULL;
+
+	*mode = (S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH | S_IWOTH);
+
+	return kasprintf(GFP_KERNEL, "rmi/%s", dev_name(dev));
+}
+
+static int rmidev_create_device_class(void)
+{
+	rmidev_device_class = class_create(THIS_MODULE, DEVICE_CLASS_NAME);
+
+	if (IS_ERR(rmidev_device_class)) {
+		pr_err("%s: Failed to create /dev/%s\n",
+				__func__, CHAR_DEVICE_NAME);
+		return -ENODEV;
+	}
+
+	rmidev_device_class->devnode = rmi_char_devnode;
+
+	return 0;
+}
+
+static int rmidev_init_device(struct synaptics_rmi4_data *rmi4_data)
+{
+	int retval;
+	dev_t dev_no;
+	unsigned char attr_count;
+	int attr_count_num;
+	struct rmidev_data *dev_data;
+	struct device *device_ptr;
+
+	rmidev = kzalloc(sizeof(*rmidev), GFP_KERNEL);
+	if (!rmidev) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to alloc mem for rmidev\n",
+				__func__);
+		retval = -ENOMEM;
+		goto err_rmidev;
+	}
+
+	rmidev->fn_ptr =  kzalloc(sizeof(*(rmidev->fn_ptr)), GFP_KERNEL);
+	if (!rmidev) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to alloc mem for fn_ptr\n",
+				__func__);
+		retval = -ENOMEM;
+		goto err_fn_ptr;
+	}
+
+	rmidev->fn_ptr->read = rmi4_data->i2c_read;
+	rmidev->fn_ptr->write = rmi4_data->i2c_write;
+	rmidev->fn_ptr->enable = rmi4_data->irq_enable;
+	rmidev->rmi4_data = rmi4_data;
+
+	retval = rmidev_create_device_class();
+	if (retval < 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to create device class\n",
+				__func__);
+		goto err_device_class;
+	}
+
+	if (rmidev_major_num) {
+		dev_no = MKDEV(rmidev_major_num, DEV_NUMBER);
+		retval = register_chrdev_region(dev_no, 1, CHAR_DEVICE_NAME);
+	} else {
+		retval = alloc_chrdev_region(&dev_no, 0, 1, CHAR_DEVICE_NAME);
+		if (retval < 0) {
+			dev_err(&rmi4_data->i2c_client->dev,
+					"%s: Failed to allocate char device region\n",
+					__func__);
+			goto err_device_region;
+		}
+
+		rmidev_major_num = MAJOR(dev_no);
+		dev_dbg(&rmi4_data->i2c_client->dev,
+				"%s: Major number of rmidev = %d\n",
+				__func__, rmidev_major_num);
+	}
+
+	dev_data = kzalloc(sizeof(*dev_data), GFP_KERNEL);
+	if (!dev_data) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to alloc mem for dev_data\n",
+				__func__);
+		retval = -ENOMEM;
+		goto err_dev_data;
+	}
+
+	mutex_init(&dev_data->file_mutex);
+	dev_data->rmi_dev = rmidev;
+	rmidev->data = dev_data;
+
+	cdev_init(&dev_data->main_dev, &rmidev_fops);
+
+	retval = cdev_add(&dev_data->main_dev, dev_no, 1);
+	if (retval < 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to add rmi char device\n",
+				__func__);
+		goto err_char_device;
+	}
+
+	dev_set_name(&rmidev->dev, "rmidev%d", MINOR(dev_no));
+	dev_data->device_class = rmidev_device_class;
+
+	device_ptr = device_create(dev_data->device_class, NULL, dev_no,
+			NULL, CHAR_DEVICE_NAME"%d", MINOR(dev_no));
+	if (IS_ERR(device_ptr)) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to create rmi char device\n",
+				__func__);
+		retval = -ENODEV;
+		goto err_char_device;
+	}
+
+	retval = gpio_export(rmi4_data->board->gpio, false);
+	if (retval < 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to export attention gpio\n",
+				__func__);
+	} else {
+		retval = gpio_export_link(&(rmi4_data->input_dev->dev),
+				"attn", rmi4_data->board->gpio);
+		if (retval < 0) {
+			dev_err(&rmi4_data->input_dev->dev,
+					"%s Failed to create gpio symlink\n",
+					__func__);
+		} else {
+			dev_dbg(&rmi4_data->input_dev->dev,
+					"%s: Exported attention gpio %d\n",
+					__func__, rmi4_data->board->gpio);
+		}
+	}
+
+	rmidev->sysfs_dir = kobject_create_and_add("rmidev",
+			&rmi4_data->input_dev->dev.kobj);
+	if (!rmidev->sysfs_dir) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to create sysfs directory\n",
+				__func__);
+		goto err_sysfs_dir;
+	}
+
+	retval = sysfs_create_bin_file(rmidev->sysfs_dir,
+			&attr_data);
+	if (retval < 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to create sysfs bin file\n",
+				__func__);
+		goto err_sysfs_bin;
+	}
+
+	for (attr_count = 0; attr_count < ARRAY_SIZE(attrs); attr_count++) {
+		retval = sysfs_create_file(rmidev->sysfs_dir,
+				&attrs[attr_count].attr);
+		if (retval < 0) {
+			dev_err(&rmi4_data->input_dev->dev,
+					"%s: Failed to create sysfs attributes\n",
+					__func__);
+			retval = -ENODEV;
+			goto err_sysfs_attrs;
+		}
+	}
+
+	return 0;
+
+err_sysfs_attrs:
+	attr_count_num = (int)attr_count;
+	for (attr_count_num--; attr_count_num >= 0; attr_count_num--)
+		sysfs_remove_file(rmidev->sysfs_dir, &attrs[attr_count].attr);
+
+	sysfs_remove_bin_file(rmidev->sysfs_dir, &attr_data);
+
+err_sysfs_bin:
+	kobject_put(rmidev->sysfs_dir);
+
+err_sysfs_dir:
+err_char_device:
+	rmidev_device_cleanup(dev_data);
+	kfree(dev_data);
+
+err_dev_data:
+	unregister_chrdev_region(dev_no, 1);
+
+err_device_region:
+	class_destroy(rmidev_device_class);
+
+err_device_class:
+	kfree(rmidev->fn_ptr);
+
+err_fn_ptr:
+	kfree(rmidev);
+
+err_rmidev:
+	return retval;
+}
+
+static void rmidev_remove_device(struct synaptics_rmi4_data *rmi4_data)
+{
+	unsigned char attr_count;
+	struct rmidev_data *dev_data;
+
+	if (!rmidev)
+		return;
+
+	for (attr_count = 0; attr_count < ARRAY_SIZE(attrs); attr_count++)
+		sysfs_remove_file(rmidev->sysfs_dir, &attrs[attr_count].attr);
+
+	sysfs_remove_bin_file(rmidev->sysfs_dir, &attr_data);
+
+	kobject_put(rmidev->sysfs_dir);
+
+	dev_data = rmidev->data;
+	if (dev_data) {
+		rmidev_device_cleanup(dev_data);
+		kfree(dev_data);
+	}
+
+	unregister_chrdev_region(rmidev->dev_no, 1);
+
+	class_destroy(rmidev_device_class);
+
+	kfree(rmidev->fn_ptr);
+	kfree(rmidev);
+
+	return;
+}
+
+int rmidev_module_register(void)
+{
+	int retval;
+
+	retval = synaptics_rmi4_new_function(RMI_DEV,
+			rmidev_init_device,
+			rmidev_remove_device,
+			NULL);
+
+	return retval;
+}
diff --git a/drivers/input/touchscreen/rmi_f54.c b/drivers/input/touchscreen/rmi_f54.c
new file mode 100644
index 0000000..264fbb9
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_f54.c
@@ -0,0 +1,4513 @@
+/* Synaptics Register Mapped Interface (RMI4) I2C Physical Layer Driver.
+ * Copyright (c) 2007-2012, Synaptics Incorporated
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <asm/unaligned.h>
+#include <mach/cpufreq.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/input.h>
+#include <linux/ctype.h>
+#include <linux/hrtimer.h>
+#include <linux/firmware.h>
+
+#include "synaptics_i2c_rmi.h"
+
+#define FACTORY_MODE
+
+#define CMD_REPORT_TYPE_DELTA	2
+#define CMD_REPORT_TYPE_RAWCAP	20
+#define CMD_GET_REPORT	1
+
+#define TSP_RAWCAP_MAX	6000
+#define TSP_RAWCAP_MIN	300
+#define TSP_DELTA_MAX	10
+#define TSP_DELTA_MIN	-10
+
+#define WATCHDOG_HRTIMER
+#define WATCHDOG_TIMEOUT_S	2 /* sec */
+#define FORCE_TIMEOUT_100MS 10
+#define STATUS_WORK_INTERVAL	20 /* ms */
+
+/*
+#define RAW_HEX
+#define HUMAN_READABLE
+*/
+
+#define STATUS_IDLE 0
+#define STATUS_BUSY 1
+
+#define DATA_REPORT_INDEX_OFFSET 1
+#define DATA_REPORT_DATA_OFFSET 3
+
+#define COMMAND_GET_REPORT 1
+#define COMMAND_FORCE_CAL 2
+#define COMMAND_FORCE_UPDATE 4
+
+#define HIGH_RESISTANCE_DATA_SIZE 6
+#define FULL_RAW_CAP_MIN_MAX_DATA_SIZE 4
+#define TREX_DATA_SIZE 7
+
+#define NO_AUTO_CAL_MASK 0x01
+
+#define concat(a, b) a##b
+#define tostring(x) (#x)
+
+#define GROUP(_attrs) {\
+	.attrs = _attrs,\
+}
+
+#define attrify(propname) (&dev_attr_##propname.attr)
+
+#define show_prototype(propname)\
+static ssize_t concat(synaptics_rmi4_f54, _##propname##_show)(\
+		struct device *dev,\
+		struct device_attribute *attr,\
+		char *buf);\
+\
+struct device_attribute dev_attr_##propname =\
+		__ATTR(propname, S_IRUGO,\
+		concat(synaptics_rmi4_f54, _##propname##_show),\
+		synaptics_rmi4_store_error);
+
+#define store_prototype(propname)\
+static ssize_t concat(synaptics_rmi4_f54, _##propname##_store)(\
+		struct device *dev,\
+		struct device_attribute *attr,\
+		const char *buf, size_t count);\
+\
+struct device_attribute dev_attr_##propname =\
+		__ATTR(propname, S_IWUSR | S_IWGRP,\
+		synaptics_rmi4_show_error,\
+		concat(synaptics_rmi4_f54, _##propname##_store));
+
+#define show_store_prototype(propname)\
+static ssize_t concat(synaptics_rmi4_f54, _##propname##_show)(\
+		struct device *dev,\
+		struct device_attribute *attr,\
+		char *buf);\
+\
+static ssize_t concat(synaptics_rmi4_f54, _##propname##_store)(\
+		struct device *dev,\
+		struct device_attribute *attr,\
+		const char *buf, size_t count);\
+\
+struct device_attribute dev_attr_##propname =\
+		__ATTR(propname, (S_IRUGO | S_IWUSR | S_IWGRP),\
+		concat(synaptics_rmi4_f54, _##propname##_show),\
+		concat(synaptics_rmi4_f54, _##propname##_store));
+
+#define simple_show_func(rtype, propname, fmt)\
+static ssize_t concat(synaptics_rmi4_f54, _##propname##_show)(\
+		struct device *dev,\
+		struct device_attribute *attr,\
+		char *buf)\
+{\
+	return snprintf(buf, PAGE_SIZE, fmt, f54->rtype.propname);\
+} \
+
+#define simple_show_func_unsigned(rtype, propname)\
+simple_show_func(rtype, propname, "%u\n")
+
+#define show_func(rtype, rgrp, propname, fmt)\
+static ssize_t concat(synaptics_rmi4_f54, _##propname##_show)(\
+		struct device *dev,\
+		struct device_attribute *attr,\
+		char *buf)\
+{\
+	int retval;\
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;\
+\
+	mutex_lock(&f54->rtype##_mutex);\
+\
+	retval = f54->fn_ptr->read(rmi4_data,\
+			f54->rtype.rgrp->address,\
+			f54->rtype.rgrp->data,\
+			sizeof(f54->rtype.rgrp->data));\
+	mutex_unlock(&f54->rtype##_mutex);\
+	if (retval < 0) {\
+		dev_err(&rmi4_data->i2c_client->dev,\
+				"%s: Failed to read " #rtype\
+				" " #rgrp "\n",\
+				__func__);\
+		return retval;\
+	} \
+\
+	return snprintf(buf, PAGE_SIZE, fmt,\
+			f54->rtype.rgrp->propname);\
+} \
+
+#define show_store_func(rtype, rgrp, propname, fmt)\
+show_func(rtype, rgrp, propname, fmt)\
+\
+static ssize_t concat(synaptics_rmi4_f54, _##propname##_store)(\
+		struct device *dev,\
+		struct device_attribute *attr,\
+		const char *buf, size_t count)\
+{\
+	int retval;\
+	unsigned long setting;\
+	unsigned long o_setting;\
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;\
+\
+	retval = kstrtoul(buf, 10, &setting);\
+	if (retval)\
+		return retval;\
+\
+	mutex_lock(&f54->rtype##_mutex);\
+	retval = f54->fn_ptr->read(rmi4_data,\
+			f54->rtype.rgrp->address,\
+			f54->rtype.rgrp->data,\
+			sizeof(f54->rtype.rgrp->data));\
+	if (retval < 0) {\
+		mutex_unlock(&f54->rtype##_mutex);\
+		dev_err(&rmi4_data->i2c_client->dev,\
+				"%s: Failed to read " #rtype\
+				" " #rgrp "\n",\
+				__func__);\
+		return retval;\
+	} \
+\
+	if (f54->rtype.rgrp->propname == setting) {\
+		mutex_unlock(&f54->rtype##_mutex);\
+		return count;\
+	} \
+\
+	o_setting = f54->rtype.rgrp->propname;\
+	f54->rtype.rgrp->propname = setting;\
+\
+	retval = f54->fn_ptr->write(rmi4_data,\
+			f54->rtype.rgrp->address,\
+			f54->rtype.rgrp->data,\
+			sizeof(f54->rtype.rgrp->data));\
+	if (retval < 0) {\
+		dev_err(&rmi4_data->i2c_client->dev,\
+				"%s: Failed to write " #rtype\
+				" " #rgrp "\n",\
+				__func__);\
+		f54->rtype.rgrp->propname = o_setting;\
+		mutex_unlock(&f54->rtype##_mutex);\
+		return retval;\
+	} \
+\
+	mutex_unlock(&f54->rtype##_mutex);\
+	return count;\
+} \
+
+#define show_store_func_unsigned(rtype, rgrp, propname)\
+show_store_func(rtype, rgrp, propname, "%u\n")
+
+#define show_replicated_func(rtype, rgrp, propname, fmt)\
+static ssize_t concat(synaptics_rmi4_f54, _##propname##_show)(\
+		struct device *dev,\
+		struct device_attribute *attr,\
+		char *buf)\
+{\
+	int retval;\
+	int size = 0;\
+	unsigned char ii;\
+	unsigned char length;\
+	unsigned char *temp;\
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;\
+\
+	mutex_lock(&f54->rtype##_mutex);\
+\
+	length = f54->rtype.rgrp->length;\
+\
+	retval = f54->fn_ptr->read(rmi4_data,\
+			f54->rtype.rgrp->address,\
+			(unsigned char *)f54->rtype.rgrp->data,\
+			length);\
+	mutex_unlock(&f54->rtype##_mutex);\
+	if (retval < 0) {\
+		dev_dbg(&rmi4_data->i2c_client->dev,\
+				"%s: Failed to read " #rtype\
+				" " #rgrp "\n",\
+				__func__);\
+	} \
+\
+	temp = buf;\
+\
+	for (ii = 0; ii < length; ii++) {\
+		retval = snprintf(temp, PAGE_SIZE - size, fmt " ",\
+				f54->rtype.rgrp->data[ii].propname);\
+		if (retval < 0) {\
+			dev_err(&rmi4_data->i2c_client->dev,\
+					"%s: Faild to write output\n",\
+					__func__);\
+			return retval;\
+		} \
+		size += retval;\
+		temp += retval;\
+	} \
+\
+	retval = snprintf(temp, PAGE_SIZE - size, "\n");\
+	if (retval < 0) {\
+		dev_err(&rmi4_data->i2c_client->dev,\
+				"%s: Faild to write null terminator\n",\
+				__func__);\
+		return retval;\
+	} \
+\
+	return size + retval;\
+} \
+
+#define show_replicated_func_unsigned(rtype, rgrp, propname)\
+show_replicated_func(rtype, rgrp, propname, "%u")
+
+#define show_store_replicated_func(rtype, rgrp, propname, fmt)\
+show_replicated_func(rtype, rgrp, propname, fmt)\
+\
+static ssize_t concat(synaptics_rmi4_f54, _##propname##_store)(\
+		struct device *dev,\
+		struct device_attribute *attr,\
+		const char *buf, size_t count)\
+{\
+	int retval;\
+	unsigned int setting;\
+	unsigned char ii;\
+	unsigned char length;\
+	const unsigned char *temp;\
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;\
+\
+	mutex_lock(&f54->rtype##_mutex);\
+\
+	length = f54->rtype.rgrp->length;\
+\
+	retval = f54->fn_ptr->read(rmi4_data,\
+			f54->rtype.rgrp->address,\
+			(unsigned char *)f54->rtype.rgrp->data,\
+			length);\
+	if (retval < 0) {\
+		dev_dbg(&rmi4_data->i2c_client->dev,\
+				"%s: Failed to read " #rtype\
+				" " #rgrp "\n",\
+				__func__);\
+	} \
+\
+	temp = buf;\
+\
+	for (ii = 0; ii < length; ii++) {\
+		if (sscanf(temp, fmt, &setting) == 1) {\
+			f54->rtype.rgrp->data[ii].propname = setting;\
+		} else {\
+			retval = f54->fn_ptr->read(rmi4_data,\
+					f54->rtype.rgrp->address,\
+					(unsigned char *)f54->rtype.rgrp->data,\
+					length);\
+			mutex_unlock(&f54->rtype##_mutex);\
+			return -EINVAL;\
+		} \
+\
+		while (*temp != 0) {\
+			temp++;\
+			if (isspace(*(temp - 1)) && !isspace(*temp))\
+				break;\
+		} \
+	} \
+\
+	retval = f54->fn_ptr->write(rmi4_data,\
+			f54->rtype.rgrp->address,\
+			(unsigned char *)f54->rtype.rgrp->data,\
+			length);\
+	mutex_unlock(&f54->rtype##_mutex);\
+	if (retval < 0) {\
+		dev_err(&rmi4_data->i2c_client->dev,\
+				"%s: Failed to write " #rtype\
+				" " #rgrp "\n",\
+				__func__);\
+		return retval;\
+	} \
+\
+	return count;\
+} \
+
+#define show_store_replicated_func_unsigned(rtype, rgrp, propname)\
+show_store_replicated_func(rtype, rgrp, propname, "%u")
+
+enum f54_report_types {
+	F54_8BIT_IMAGE = 1,
+	F54_16BIT_IMAGE = 2,
+	F54_RAW_16BIT_IMAGE = 3,
+	F54_HIGH_RESISTANCE = 4,
+	F54_TX_TO_TX_SHORT = 5,
+	F54_RX_TO_RX1 = 7,
+	F54_TRUE_BASELINE = 9,
+	F54_FULL_RAW_CAP_MIN_MAX = 13,
+	F54_RX_OPENS1 = 14,
+	F54_TX_OPEN = 15,
+	F54_TX_TO_GROUND = 16,
+	F54_RX_TO_RX2 = 17,
+	F54_RX_OPENS2 = 18,
+	F54_FULL_RAW_CAP = 19,
+	F54_FULL_RAW_CAP_RX_COUPLING_COMP = 20,
+	F54_SENSOR_SPEED = 22,
+	F54_ADC_RANGE = 23,
+	F54_TREX_OPENS = 24,
+	F54_TREX_TO_GND = 25,
+	F54_TREX_SHORTS = 26,
+	F54_ABS_RAW_CAP = 38,
+	F54_ABS_DELTA_CAP = 40,
+	INVALID_REPORT_TYPE = -1,
+};
+
+struct f54_query {
+	union {
+		struct {
+			/* query 0 */
+			unsigned char num_of_rx_electrodes;
+
+			/* query 1 */
+			unsigned char num_of_tx_electrodes;
+
+			/* query 2 */
+			unsigned char f54_query2_b0__1:2;
+			unsigned char has_baseline:1;
+			unsigned char has_image8:1;
+			unsigned char f54_query2_b4__5:2;
+			unsigned char has_image16:1;
+			unsigned char f54_query2_b7:1;
+
+			/* queries 3.0 and 3.1 */
+			unsigned short clock_rate;
+
+			/* query 4 */
+			unsigned char touch_controller_family;
+
+			/* query 5 */
+			unsigned char has_pixel_touch_threshold_adjustment:1;
+			unsigned char f54_query5_b1__7:7;
+
+			/* query 6 */
+			unsigned char has_sensor_assignment:1;
+			unsigned char has_interference_metric:1;
+			unsigned char has_sense_frequency_control:1;
+			unsigned char has_firmware_noise_mitigation:1;
+			unsigned char has_ctrl11:1;
+			unsigned char has_two_byte_report_rate:1;
+			unsigned char has_one_byte_report_rate:1;
+			unsigned char has_relaxation_control:1;
+
+			/* query 7 */
+			unsigned char curve_compensation_mode:2;
+			unsigned char f54_query7_b2__7:6;
+
+			/* query 8 */
+			unsigned char f54_query8_b0:1;
+			unsigned char has_iir_filter:1;
+			unsigned char has_cmn_removal:1;
+			unsigned char has_cmn_maximum:1;
+			unsigned char has_touch_hysteresis:1;
+			unsigned char has_edge_compensation:1;
+			unsigned char has_per_frequency_noise_control:1;
+			unsigned char has_enhanced_stretch:1;
+
+			/* query 9 */
+			unsigned char has_force_fast_relaxation:1;
+			unsigned char has_multi_metric_state_machine:1;
+			unsigned char has_signal_clarity:1;
+			unsigned char has_variance_metric:1;
+			unsigned char has_0d_relaxation_control:1;
+			unsigned char has_0d_acquisition_control:1;
+			unsigned char has_status:1;
+			unsigned char has_slew_metric:1;
+
+			/* queries 10 11 */
+			unsigned char f54_query10;
+			unsigned char f54_query11;
+
+			/* query 12 */
+			unsigned char number_of_sensing_frequencies:4;
+			unsigned char f54_query12_b4__7:4;
+		} __packed;
+		unsigned char data[14];
+	};
+};
+
+struct f54_control_0 {
+	union {
+		struct {
+			unsigned char no_relax:1;
+			unsigned char no_scan:1;
+			unsigned char force_fast_relaxation:1;
+			unsigned char startup_fast_relaxation:1;
+			unsigned char gesture_cancels_sfr:1;
+			unsigned char enable_energy_ratio_relaxation:1;
+			unsigned char excessive_noise_attn_enable:1;
+			unsigned char f54_control0_b7:1;
+		} __packed;
+		struct {
+			unsigned char data[1];
+			unsigned short address;
+		} __packed;
+	};
+};
+
+struct f54_control_1 {
+	union {
+		struct {
+			unsigned char bursts_per_cluster:4;
+			unsigned char f54_ctrl1_b4__7:4;
+		} __packed;
+		struct {
+			unsigned char data[1];
+			unsigned short address;
+		} __packed;
+	};
+};
+
+struct f54_control_2 {
+	union {
+		struct {
+			unsigned short saturation_cap;
+		} __packed;
+		struct {
+			unsigned char data[2];
+			unsigned short address;
+		} __packed;
+	};
+};
+
+struct f54_control_3 {
+	union {
+		struct {
+			unsigned char pixel_touch_threshold;
+		} __packed;
+		struct {
+			unsigned char data[1];
+			unsigned short address;
+		} __packed;
+	};
+};
+
+struct f54_control_4__6 {
+	union {
+		struct {
+			/* control 4 */
+			unsigned char rx_feedback_cap:2;
+			unsigned char bias_current:2;
+			unsigned char f54_ctrl4_b4__7:4;
+
+			/* control 5 */
+			unsigned char low_ref_cap:2;
+			unsigned char low_ref_feedback_cap:2;
+			unsigned char low_ref_polarity:1;
+			unsigned char f54_ctrl5_b5__7:3;
+
+			/* control 6 */
+			unsigned char high_ref_cap:2;
+			unsigned char high_ref_feedback_cap:2;
+			unsigned char high_ref_polarity:1;
+			unsigned char f54_ctrl6_b5__7:3;
+		} __packed;
+		struct {
+			unsigned char data[3];
+			unsigned short address;
+		} __packed;
+	};
+};
+
+struct f54_control_7 {
+	union {
+		struct {
+			unsigned char cbc_cap:2;
+			unsigned char cbc_polarity:2;
+			unsigned char cbc_tx_carrier_selection:1;
+			unsigned char f54_ctrl7_b5__7:3;
+		} __packed;
+		struct {
+			unsigned char data[1];
+			unsigned short address;
+		} __packed;
+	};
+};
+
+struct f54_control_8__9 {
+	union {
+		struct {
+			/* control 8 */
+			unsigned short integration_duration:10;
+			unsigned short f54_ctrl8_b10__15:6;
+
+			/* control 9 */
+			unsigned char reset_duration;
+		} __packed;
+		struct {
+			unsigned char data[3];
+			unsigned short address;
+		} __packed;
+	};
+};
+
+struct f54_control_10 {
+	union {
+		struct {
+			unsigned char noise_sensing_bursts_per_image:4;
+			unsigned char f54_ctrl10_b4__7:4;
+		} __packed;
+		struct {
+			unsigned char data[1];
+			unsigned short address;
+		} __packed;
+	};
+};
+
+struct f54_control_11 {
+	union {
+		struct {
+			unsigned short f54_ctrl11;
+		} __packed;
+		struct {
+			unsigned char data[2];
+			unsigned short address;
+		} __packed;
+	};
+};
+
+struct f54_control_12__13 {
+	union {
+		struct {
+			/* control 12 */
+			unsigned char slow_relaxation_rate;
+
+			/* control 13 */
+			unsigned char fast_relaxation_rate;
+		} __packed;
+		struct {
+			unsigned char data[2];
+			unsigned short address;
+		} __packed;
+	};
+};
+
+struct f54_control_14 {
+	union {
+		struct {
+				unsigned char rxs_on_xaxis:1;
+				unsigned char curve_comp_on_txs:1;
+				unsigned char f54_ctrl14_b2__7:6;
+		} __packed;
+		struct {
+			unsigned char data[1];
+			unsigned short address;
+		} __packed;
+	};
+};
+
+struct f54_control_15n {
+	unsigned char sensor_rx_assignment;
+};
+
+struct f54_control_15 {
+	struct f54_control_15n *data;
+	unsigned short address;
+	unsigned char length;
+};
+
+struct f54_control_16n {
+	unsigned char sensor_tx_assignment;
+};
+
+struct f54_control_16 {
+	struct f54_control_16n *data;
+	unsigned short address;
+	unsigned char length;
+};
+
+struct f54_control_17n {
+	unsigned char burst_count_b8__10:3;
+	unsigned char disable:1;
+	unsigned char f54_ctrl17_b4:1;
+	unsigned char filter_bandwidth:3;
+};
+
+struct f54_control_17 {
+	struct f54_control_17n *data;
+	unsigned short address;
+	unsigned char length;
+};
+
+struct f54_control_18n {
+	unsigned char burst_count_b0__7;
+};
+
+struct f54_control_18 {
+	struct f54_control_18n *data;
+	unsigned short address;
+	unsigned char length;
+};
+
+struct f54_control_19n {
+	unsigned char stretch_duration;
+};
+
+struct f54_control_19 {
+	struct f54_control_19n *data;
+	unsigned short address;
+	unsigned char length;
+};
+
+struct f54_control_20 {
+	union {
+		struct {
+			unsigned char disable_noise_mitigation:1;
+			unsigned char f54_ctrl20_b1__7:7;
+		} __packed;
+		struct {
+			unsigned char data[1];
+			unsigned short address;
+		} __packed;
+	};
+};
+
+struct f54_control_21 {
+	union {
+		struct {
+			unsigned short freq_shift_noise_threshold;
+		} __packed;
+		struct {
+			unsigned char data[2];
+			unsigned short address;
+		} __packed;
+	};
+};
+
+struct f54_control_22__26 {
+	union {
+		struct {
+			/* control 22 */
+			unsigned char f54_ctrl22;
+
+			/* control 23 */
+			unsigned short medium_noise_threshold;
+
+			/* control 24 */
+			unsigned short high_noise_threshold;
+
+			/* control 25 */
+			unsigned char noise_density;
+
+			/* control 26 */
+			unsigned char frame_count;
+		} __packed;
+		struct {
+			unsigned char data[7];
+			unsigned short address;
+		} __packed;
+	};
+};
+
+struct f54_control_27 {
+	union {
+		struct {
+			unsigned char iir_filter_coef;
+		} __packed;
+		struct {
+			unsigned char data[1];
+			unsigned short address;
+		} __packed;
+	};
+};
+
+struct f54_control_28 {
+	union {
+		struct {
+			unsigned short quiet_threshold;
+		} __packed;
+		struct {
+			unsigned char data[2];
+			unsigned short address;
+		} __packed;
+	};
+};
+
+struct f54_control_29 {
+	union {
+		struct {
+			/* control 29 */
+			unsigned char f54_ctrl29_b0__6:7;
+			unsigned char cmn_filter_disable:1;
+		} __packed;
+		struct {
+			unsigned char data[1];
+			unsigned short address;
+		} __packed;
+	};
+};
+
+struct f54_control_30 {
+	union {
+		struct {
+			unsigned char cmn_filter_max;
+		} __packed;
+		struct {
+			unsigned char data[1];
+			unsigned short address;
+		} __packed;
+	};
+};
+
+struct f54_control_31 {
+	union {
+		struct {
+			unsigned char touch_hysteresis;
+		} __packed;
+		struct {
+			unsigned char data[1];
+			unsigned short address;
+		} __packed;
+	};
+};
+
+struct f54_control_32__35 {
+	union {
+		struct {
+			/* control 32 */
+			unsigned short rx_low_edge_comp;
+
+			/* control 33 */
+			unsigned short rx_high_edge_comp;
+
+			/* control 34 */
+			unsigned short tx_low_edge_comp;
+
+			/* control 35 */
+			unsigned short tx_high_edge_comp;
+		} __packed;
+		struct {
+			unsigned char data[8];
+			unsigned short address;
+		} __packed;
+	};
+};
+
+struct f54_control_36n {
+	unsigned char axis1_comp;
+};
+
+struct f54_control_36 {
+	struct f54_control_36n *data;
+	unsigned short address;
+	unsigned char length;
+};
+
+struct f54_control_37n {
+	unsigned char axis2_comp;
+};
+
+struct f54_control_37 {
+	struct f54_control_37n *data;
+	unsigned short address;
+	unsigned char length;
+};
+
+struct f54_control_38n {
+	unsigned char noise_control_1;
+};
+
+struct f54_control_38 {
+	struct f54_control_38n *data;
+	unsigned short address;
+	unsigned char length;
+};
+
+struct f54_control_39n {
+	unsigned char noise_control_2;
+};
+
+struct f54_control_39 {
+	struct f54_control_39n *data;
+	unsigned short address;
+	unsigned char length;
+};
+
+struct f54_control_40n {
+	unsigned char noise_control_3;
+};
+
+struct f54_control_40 {
+	struct f54_control_40n *data;
+	unsigned short address;
+	unsigned char length;
+};
+
+struct f54_control_41 {
+	union {
+		struct {
+			/* control 41 */
+			unsigned char no_signal_clarity:1;
+			unsigned char f54_ctrl41_b1__7:7;
+		} __packed;
+		struct {
+			unsigned char data[1];
+			unsigned short address;
+		} __packed;
+	};
+};
+
+struct f54_control_57 {
+	union {
+		struct {
+			unsigned char cbc_cap_0d:3;
+			unsigned char cbc_polarity_0d:1;
+			unsigned char cbc_tx_carrier_selection_0d:1;
+			unsigned char f54_ctrl57_b5__7:3;
+		} __packed;
+		struct {
+			unsigned char data[1];
+			unsigned short address;
+		} __packed;
+	};
+};
+
+struct f54_control {
+	struct f54_control_0 *reg_0;
+	struct f54_control_1 *reg_1;
+	struct f54_control_2 *reg_2;
+	struct f54_control_3 *reg_3;
+	struct f54_control_4__6 *reg_4__6;
+	struct f54_control_7 *reg_7;
+	struct f54_control_8__9 *reg_8__9;
+	struct f54_control_10 *reg_10;
+	struct f54_control_11 *reg_11;
+	struct f54_control_12__13 *reg_12__13;
+	struct f54_control_14 *reg_14;
+	struct f54_control_15 *reg_15;
+	struct f54_control_16 *reg_16;
+	struct f54_control_17 *reg_17;
+	struct f54_control_18 *reg_18;
+	struct f54_control_19 *reg_19;
+	struct f54_control_20 *reg_20;
+	struct f54_control_21 *reg_21;
+	struct f54_control_22__26 *reg_22__26;
+	struct f54_control_27 *reg_27;
+	struct f54_control_28 *reg_28;
+	struct f54_control_29 *reg_29;
+	struct f54_control_30 *reg_30;
+	struct f54_control_31 *reg_31;
+	struct f54_control_32__35 *reg_32__35;
+	struct f54_control_36 *reg_36;
+	struct f54_control_37 *reg_37;
+	struct f54_control_38 *reg_38;
+	struct f54_control_39 *reg_39;
+	struct f54_control_40 *reg_40;
+	struct f54_control_41 *reg_41;
+	struct f54_control_57 *reg_57;
+};
+
+#ifdef FACTORY_MODE
+#include <linux/uaccess.h>
+
+#define CMD_STR_LEN 32
+#define CMD_PARAM_NUM 8
+#define CMD_RESULT_STR_LEN 512
+#define FT_CMD(name, func) .cmd_name = name, .cmd_func = func
+#define F12_CTRL9_ADDR 0X0011
+#define F34_CTRL0_0_ADDR 0x0007
+#define F34_CTRL0_3_ADDR 0x000a
+
+enum CMD_STATUS {
+	CMD_STATUS_WAITING = 0,
+	CMD_STATUS_RUNNING,
+	CMD_STATUS_OK,
+	CMD_STATUS_FAIL,
+	CMD_STATUS_NOT_APPLICABLE,
+};
+
+struct ft_cmd {
+	const char *cmd_name;
+	void (*cmd_func)(void);
+	struct list_head list;
+};
+
+struct factory_data {
+	struct device *fac_dev_ts;
+	short *rawcap_data;
+	short *delta_data;
+	short *abscap_data;
+	short *absdelta_data;
+	short *trx_short;
+	bool cmd_is_running;
+	unsigned char cmd_state;
+	char cmd[CMD_STR_LEN];
+	int cmd_param[CMD_PARAM_NUM];
+	char cmd_buff[CMD_RESULT_STR_LEN];
+	char cmd_result[CMD_RESULT_STR_LEN];
+	struct mutex cmd_lock;
+	struct list_head cmd_list_head;
+};
+
+static int synaptics_rmi4_f54_get_report_type(int type);
+
+static ssize_t cmd_store(struct device *dev, struct device_attribute *attr,
+		const char *buf, size_t count);
+
+static ssize_t cmd_status_show(struct device *dev,
+		struct device_attribute *attr, char *buf);
+
+static ssize_t cmd_result_show(struct device *dev,
+		struct device_attribute *attr, char *buf);
+
+static ssize_t cmd_list_show(struct device *dev,
+		struct device_attribute *attr, char *buf);
+
+static DEVICE_ATTR(cmd, S_IWUSR | S_IWGRP, NULL, cmd_store);
+static DEVICE_ATTR(cmd_status, S_IRUGO, cmd_status_show, NULL);
+static DEVICE_ATTR(cmd_result, S_IRUGO, cmd_result_show, NULL);
+static DEVICE_ATTR(cmd_list, S_IRUGO, cmd_list_show, NULL);
+
+static struct attribute *cmd_attributes[] = {
+	&dev_attr_cmd.attr,
+	&dev_attr_cmd_status.attr,
+	&dev_attr_cmd_result.attr,
+	&dev_attr_cmd_list.attr,
+	NULL,
+};
+
+static struct attribute_group cmd_attr_group = {
+	.attrs = cmd_attributes,
+};
+
+static void fw_update(void);
+static void get_fw_ver_bin(void);
+static void get_fw_ver_ic(void);
+static void get_fac_fw_ver_bin(void);
+static void get_config_ver(void);
+static void get_threshold(void);
+static void module_off_master(void);
+static void module_on_master(void);
+static void get_chip_vendor(void);
+static void get_chip_name(void);
+static void get_x_num(void);
+static void get_y_num(void);
+static void get_rawcap(void);
+static void run_rawcap_read(void);
+static void get_delta(void);
+static void run_delta_read(void);
+static void run_abscap_read(void);
+static void run_absdelta_read(void);
+static void run_trx_short_test(void);
+static void hover_enable(void);
+static void hover_no_sleep_enable(void);
+static void boost_level(void);
+static void clear_cover_mode(void);
+static void glove_mode(void);
+static void get_glove_sensitivity(void);
+static void fast_glove_mode(void);
+static void hover_rezero(void);
+static void not_support_cmd(void);
+
+struct ft_cmd ft_cmds[] = {
+	{FT_CMD("fw_update", fw_update),},
+	{FT_CMD("get_fw_ver_bin", get_fw_ver_bin),},
+	{FT_CMD("get_fw_ver_ic", get_fw_ver_ic),},
+	{FT_CMD("get_fac_fw_ver_bin", get_fac_fw_ver_bin),},
+	{FT_CMD("get_config_ver", get_config_ver),},
+	{FT_CMD("get_threshold", get_threshold),},
+	{FT_CMD("module_off_master", module_off_master),},
+	{FT_CMD("module_on_master", module_on_master),},
+	{FT_CMD("module_off_slave", not_support_cmd),},
+	{FT_CMD("module_on_slave", not_support_cmd),},
+	{FT_CMD("get_chip_vendor", get_chip_vendor),},
+	{FT_CMD("get_chip_name", get_chip_name),},
+	{FT_CMD("get_x_num", get_x_num),},
+	{FT_CMD("get_y_num", get_y_num),},
+	{FT_CMD("get_rawcap", get_rawcap),},
+	{FT_CMD("run_rawcap_read", run_rawcap_read),},
+	{FT_CMD("get_delta", get_delta),},
+	{FT_CMD("run_delta_read", run_delta_read),},
+	{FT_CMD("run_abscap_read", run_abscap_read),},
+	{FT_CMD("run_absdelta_read", run_absdelta_read),},
+	{FT_CMD("run_trx_short_test", run_trx_short_test),},
+	{FT_CMD("hover_enable", hover_enable),},
+	{FT_CMD("hover_no_sleep_enable", hover_no_sleep_enable),},
+	{FT_CMD("boost_level", boost_level),},
+	{FT_CMD("clear_cover_mode", clear_cover_mode),},
+	{FT_CMD("glove_mode", glove_mode),},
+	{FT_CMD("get_glove_sensitivity", get_glove_sensitivity),},
+	{FT_CMD("fast_glove_mode", fast_glove_mode),},
+	{FT_CMD("hover_rezero", hover_rezero),},
+	{FT_CMD("not_support_cmd", not_support_cmd),},
+};
+#endif
+
+struct synaptics_rmi4_f54_handle {
+	bool no_auto_cal;
+	unsigned char status;
+	unsigned char intr_mask;
+	unsigned char intr_reg_num;
+	unsigned char *report_data;
+	unsigned short query_base_addr;
+	unsigned short control_base_addr;
+	unsigned short data_base_addr;
+	unsigned short command_base_addr;
+	unsigned short fifoindex;
+	unsigned int report_size;
+	unsigned int data_buffer_size;
+	enum f54_report_types report_type;
+	struct mutex status_mutex;
+	struct mutex data_mutex;
+	struct mutex control_mutex;
+	struct f54_query query;
+	struct f54_control control;
+#ifdef FACTORY_MODE
+	struct factory_data *factory_data;
+#endif
+	struct kobject *attr_dir;
+	struct hrtimer watchdog;
+	struct work_struct timeout_work;
+	struct delayed_work status_work;
+	struct workqueue_struct *status_workqueue;
+	struct synaptics_rmi4_exp_fn_ptr *fn_ptr;
+	struct synaptics_rmi4_data *rmi4_data;
+};
+
+show_prototype(status)
+show_prototype(report_size)
+show_store_prototype(no_auto_cal)
+show_store_prototype(report_type)
+show_store_prototype(fifoindex)
+store_prototype(do_preparation)
+store_prototype(get_report)
+store_prototype(force_cal)
+show_prototype(num_of_rx_electrodes)
+show_prototype(num_of_tx_electrodes)
+show_prototype(has_image16)
+show_prototype(has_image8)
+show_prototype(has_baseline)
+show_prototype(clock_rate)
+show_prototype(touch_controller_family)
+show_prototype(has_pixel_touch_threshold_adjustment)
+show_prototype(has_sensor_assignment)
+show_prototype(has_interference_metric)
+show_prototype(has_sense_frequency_control)
+show_prototype(has_firmware_noise_mitigation)
+show_prototype(has_two_byte_report_rate)
+show_prototype(has_one_byte_report_rate)
+show_prototype(has_relaxation_control)
+show_prototype(curve_compensation_mode)
+show_prototype(has_iir_filter)
+show_prototype(has_cmn_removal)
+show_prototype(has_cmn_maximum)
+show_prototype(has_touch_hysteresis)
+show_prototype(has_edge_compensation)
+show_prototype(has_per_frequency_noise_control)
+show_prototype(has_signal_clarity)
+show_prototype(number_of_sensing_frequencies)
+
+show_store_prototype(no_relax)
+show_store_prototype(no_scan)
+show_store_prototype(bursts_per_cluster)
+show_store_prototype(saturation_cap)
+show_store_prototype(pixel_touch_threshold)
+show_store_prototype(rx_feedback_cap)
+show_store_prototype(low_ref_cap)
+show_store_prototype(low_ref_feedback_cap)
+show_store_prototype(low_ref_polarity)
+show_store_prototype(high_ref_cap)
+show_store_prototype(high_ref_feedback_cap)
+show_store_prototype(high_ref_polarity)
+show_store_prototype(cbc_cap)
+show_store_prototype(cbc_polarity)
+show_store_prototype(cbc_tx_carrier_selection)
+show_store_prototype(integration_duration)
+show_store_prototype(reset_duration)
+show_store_prototype(noise_sensing_bursts_per_image)
+show_store_prototype(slow_relaxation_rate)
+show_store_prototype(fast_relaxation_rate)
+show_store_prototype(rxs_on_xaxis)
+show_store_prototype(curve_comp_on_txs)
+show_prototype(sensor_rx_assignment)
+show_prototype(sensor_tx_assignment)
+show_prototype(burst_count)
+show_prototype(disable)
+show_prototype(filter_bandwidth)
+show_prototype(stretch_duration)
+show_store_prototype(disable_noise_mitigation)
+show_store_prototype(freq_shift_noise_threshold)
+show_store_prototype(medium_noise_threshold)
+show_store_prototype(high_noise_threshold)
+show_store_prototype(noise_density)
+show_store_prototype(frame_count)
+show_store_prototype(iir_filter_coef)
+show_store_prototype(quiet_threshold)
+show_store_prototype(cmn_filter_disable)
+show_store_prototype(cmn_filter_max)
+show_store_prototype(touch_hysteresis)
+show_store_prototype(rx_low_edge_comp)
+show_store_prototype(rx_high_edge_comp)
+show_store_prototype(tx_low_edge_comp)
+show_store_prototype(tx_high_edge_comp)
+show_store_prototype(axis1_comp)
+show_store_prototype(axis2_comp)
+show_prototype(noise_control_1)
+show_prototype(noise_control_2)
+show_prototype(noise_control_3)
+show_store_prototype(no_signal_clarity)
+
+static ssize_t synaptics_rmi4_f54_data_read(struct file *data_file,
+		struct kobject *kobj, struct bin_attribute *attributes,
+		char *buf, loff_t pos, size_t count);
+
+static struct attribute *attrs[] = {
+	attrify(status),
+	attrify(report_size),
+	attrify(no_auto_cal),
+	attrify(report_type),
+	attrify(fifoindex),
+	attrify(do_preparation),
+	attrify(get_report),
+	attrify(force_cal),
+	attrify(num_of_rx_electrodes),
+	attrify(num_of_tx_electrodes),
+	attrify(has_image16),
+	attrify(has_image8),
+	attrify(has_baseline),
+	attrify(clock_rate),
+	attrify(touch_controller_family),
+	attrify(has_pixel_touch_threshold_adjustment),
+	attrify(has_sensor_assignment),
+	attrify(has_interference_metric),
+	attrify(has_sense_frequency_control),
+	attrify(has_firmware_noise_mitigation),
+	attrify(has_two_byte_report_rate),
+	attrify(has_one_byte_report_rate),
+	attrify(has_relaxation_control),
+	attrify(curve_compensation_mode),
+	attrify(has_iir_filter),
+	attrify(has_cmn_removal),
+	attrify(has_cmn_maximum),
+	attrify(has_touch_hysteresis),
+	attrify(has_edge_compensation),
+	attrify(has_per_frequency_noise_control),
+	attrify(has_signal_clarity),
+	attrify(number_of_sensing_frequencies),
+	NULL,
+};
+
+static struct attribute_group attr_group = GROUP(attrs);
+
+static struct attribute *attrs_reg_0[] = {
+	attrify(no_relax),
+	attrify(no_scan),
+	NULL,
+};
+
+static struct attribute *attrs_reg_1[] = {
+	attrify(bursts_per_cluster),
+	NULL,
+};
+
+static struct attribute *attrs_reg_2[] = {
+	attrify(saturation_cap),
+	NULL,
+};
+
+static struct attribute *attrs_reg_3[] = {
+	attrify(pixel_touch_threshold),
+	NULL,
+};
+
+static struct attribute *attrs_reg_4__6[] = {
+	attrify(rx_feedback_cap),
+	attrify(low_ref_cap),
+	attrify(low_ref_feedback_cap),
+	attrify(low_ref_polarity),
+	attrify(high_ref_cap),
+	attrify(high_ref_feedback_cap),
+	attrify(high_ref_polarity),
+	NULL,
+};
+
+static struct attribute *attrs_reg_7[] = {
+	attrify(cbc_cap),
+	attrify(cbc_polarity),
+	attrify(cbc_tx_carrier_selection),
+	NULL,
+};
+
+static struct attribute *attrs_reg_8__9[] = {
+	attrify(integration_duration),
+	attrify(reset_duration),
+	NULL,
+};
+
+static struct attribute *attrs_reg_10[] = {
+	attrify(noise_sensing_bursts_per_image),
+	NULL,
+};
+
+static struct attribute *attrs_reg_11[] = {
+	NULL,
+};
+
+static struct attribute *attrs_reg_12__13[] = {
+	attrify(slow_relaxation_rate),
+	attrify(fast_relaxation_rate),
+	NULL,
+};
+
+static struct attribute *attrs_reg_14__16[] = {
+	attrify(rxs_on_xaxis),
+	attrify(curve_comp_on_txs),
+	attrify(sensor_rx_assignment),
+	attrify(sensor_tx_assignment),
+	NULL,
+};
+
+static struct attribute *attrs_reg_17__19[] = {
+	attrify(burst_count),
+	attrify(disable),
+	attrify(filter_bandwidth),
+	attrify(stretch_duration),
+	NULL,
+};
+
+static struct attribute *attrs_reg_20[] = {
+	attrify(disable_noise_mitigation),
+	NULL,
+};
+
+static struct attribute *attrs_reg_21[] = {
+	attrify(freq_shift_noise_threshold),
+	NULL,
+};
+
+static struct attribute *attrs_reg_22__26[] = {
+	attrify(medium_noise_threshold),
+	attrify(high_noise_threshold),
+	attrify(noise_density),
+	attrify(frame_count),
+	NULL,
+};
+
+static struct attribute *attrs_reg_27[] = {
+	attrify(iir_filter_coef),
+	NULL,
+};
+
+static struct attribute *attrs_reg_28[] = {
+	attrify(quiet_threshold),
+	NULL,
+};
+
+static struct attribute *attrs_reg_29[] = {
+	attrify(cmn_filter_disable),
+	NULL,
+};
+
+static struct attribute *attrs_reg_30[] = {
+	attrify(cmn_filter_max),
+	NULL,
+};
+
+static struct attribute *attrs_reg_31[] = {
+	attrify(touch_hysteresis),
+	NULL,
+};
+
+static struct attribute *attrs_reg_32__35[] = {
+	attrify(rx_low_edge_comp),
+	attrify(rx_high_edge_comp),
+	attrify(tx_low_edge_comp),
+	attrify(tx_high_edge_comp),
+	NULL,
+};
+
+static struct attribute *attrs_reg_36[] = {
+	attrify(axis1_comp),
+	NULL,
+};
+
+static struct attribute *attrs_reg_37[] = {
+	attrify(axis2_comp),
+	NULL,
+};
+
+static struct attribute *attrs_reg_38__40[] = {
+	attrify(noise_control_1),
+	attrify(noise_control_2),
+	attrify(noise_control_3),
+	NULL,
+};
+
+static struct attribute *attrs_reg_41[] = {
+	attrify(no_signal_clarity),
+	NULL,
+};
+
+static struct attribute_group attrs_ctrl_regs[] = {
+	GROUP(attrs_reg_0),
+	GROUP(attrs_reg_1),
+	GROUP(attrs_reg_2),
+	GROUP(attrs_reg_3),
+	GROUP(attrs_reg_4__6),
+	GROUP(attrs_reg_7),
+	GROUP(attrs_reg_8__9),
+	GROUP(attrs_reg_10),
+	GROUP(attrs_reg_11),
+	GROUP(attrs_reg_12__13),
+	GROUP(attrs_reg_14__16),
+	GROUP(attrs_reg_17__19),
+	GROUP(attrs_reg_20),
+	GROUP(attrs_reg_21),
+	GROUP(attrs_reg_22__26),
+	GROUP(attrs_reg_27),
+	GROUP(attrs_reg_28),
+	GROUP(attrs_reg_29),
+	GROUP(attrs_reg_30),
+	GROUP(attrs_reg_31),
+	GROUP(attrs_reg_32__35),
+	GROUP(attrs_reg_36),
+	GROUP(attrs_reg_37),
+	GROUP(attrs_reg_38__40),
+	GROUP(attrs_reg_41),
+};
+
+static bool attrs_ctrl_regs_exist[ARRAY_SIZE(attrs_ctrl_regs)];
+
+static struct bin_attribute dev_report_data = {
+	.attr = {
+		.name = "report_data",
+		.mode = S_IRUGO,
+	},
+	.size = 0,
+	.read = synaptics_rmi4_f54_data_read,
+};
+
+static struct synaptics_rmi4_f54_handle *f54;
+
+static bool is_report_type_valid(enum f54_report_types report_type)
+{
+	switch (report_type) {
+	case F54_8BIT_IMAGE:
+	case F54_16BIT_IMAGE:
+	case F54_RAW_16BIT_IMAGE:
+	case F54_HIGH_RESISTANCE:
+	case F54_TX_TO_TX_SHORT:
+	case F54_RX_TO_RX1:
+	case F54_TRUE_BASELINE:
+	case F54_FULL_RAW_CAP_MIN_MAX:
+	case F54_RX_OPENS1:
+	case F54_TX_OPEN:
+	case F54_TX_TO_GROUND:
+	case F54_RX_TO_RX2:
+	case F54_RX_OPENS2:
+	case F54_FULL_RAW_CAP:
+	case F54_FULL_RAW_CAP_RX_COUPLING_COMP:
+	case F54_SENSOR_SPEED:
+	case F54_ADC_RANGE:
+	case F54_TREX_OPENS:
+	case F54_TREX_TO_GND:
+	case F54_TREX_SHORTS:
+	case F54_ABS_RAW_CAP:
+	case F54_ABS_DELTA_CAP:
+		return true;
+		break;
+	default:
+		f54->report_type = INVALID_REPORT_TYPE;
+		f54->report_size = 0;
+		return false;
+	}
+}
+
+static void set_report_size(void)
+{
+	int retval;
+	unsigned char rx = f54->rmi4_data->num_of_rx;
+	unsigned char tx = f54->rmi4_data->num_of_tx;
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+
+	switch (f54->report_type) {
+	case F54_8BIT_IMAGE:
+		f54->report_size = rx * tx;
+		break;
+	case F54_16BIT_IMAGE:
+	case F54_RAW_16BIT_IMAGE:
+	case F54_TRUE_BASELINE:
+	case F54_FULL_RAW_CAP:
+	case F54_FULL_RAW_CAP_RX_COUPLING_COMP:
+	case F54_SENSOR_SPEED:
+		f54->report_size = 2 * rx * tx;
+		break;
+	case F54_HIGH_RESISTANCE:
+		f54->report_size = HIGH_RESISTANCE_DATA_SIZE;
+		break;
+	case F54_TX_TO_TX_SHORT:
+	case F54_TX_OPEN:
+	case F54_TX_TO_GROUND:
+		f54->report_size = (tx + 7) / 8;
+		break;
+	case F54_RX_TO_RX1:
+	case F54_RX_OPENS1:
+		if (rx < tx)
+			f54->report_size = 2 * rx * rx;
+		else
+			f54->report_size = 2 * rx * tx;
+		break;
+	case F54_FULL_RAW_CAP_MIN_MAX:
+		f54->report_size = FULL_RAW_CAP_MIN_MAX_DATA_SIZE;
+		break;
+	case F54_RX_TO_RX2:
+	case F54_RX_OPENS2:
+		if (rx <= tx)
+			f54->report_size = 0;
+		else
+			f54->report_size = 2 * rx * (rx - tx);
+		break;
+	case F54_ADC_RANGE:
+		if (f54->query.has_signal_clarity) {
+			mutex_lock(&f54->control_mutex);
+			retval = f54->fn_ptr->read(rmi4_data,
+					f54->control.reg_41->address,
+					f54->control.reg_41->data,
+					sizeof(f54->control.reg_41->data));
+			mutex_unlock(&f54->control_mutex);
+			if (retval < 0) {
+				dev_dbg(&rmi4_data->i2c_client->dev,
+						"%s: Failed to read control reg_41\n",
+						__func__);
+				f54->report_size = 0;
+				break;
+			}
+			if (!f54->control.reg_41->no_signal_clarity) {
+				if (tx % 4)
+					tx += 4 - (tx % 4);
+			}
+		}
+		f54->report_size = 2 * rx * tx;
+		break;
+	case F54_TREX_OPENS:
+	case F54_TREX_TO_GND:
+	case F54_TREX_SHORTS:
+		f54->report_size = TREX_DATA_SIZE;
+		break;
+	case F54_ABS_RAW_CAP:
+	case F54_ABS_DELTA_CAP:
+		f54->report_size = 4 * (rx + tx);
+		break;
+	default:
+		f54->report_size = 0;
+	}
+
+	return;
+}
+
+static int set_interrupt(bool set)
+{
+	int retval;
+	unsigned char ii;
+	unsigned char zero = 0x00;
+	unsigned char *intr_mask;
+	unsigned short f01_ctrl_reg;
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+
+	intr_mask = rmi4_data->intr_mask;
+	f01_ctrl_reg = rmi4_data->f01_ctrl_base_addr + 1 + f54->intr_reg_num;
+
+	if (!set) {
+		retval = f54->fn_ptr->write(rmi4_data,
+				f01_ctrl_reg,
+				&zero,
+				sizeof(zero));
+		if (retval < 0)
+			return retval;
+	}
+
+	for (ii = 0; ii < rmi4_data->num_of_intr_regs; ii++) {
+		if (intr_mask[ii] != 0x00) {
+			f01_ctrl_reg = rmi4_data->f01_ctrl_base_addr + 1 + ii;
+			if (set) {
+				retval = f54->fn_ptr->write(rmi4_data,
+						f01_ctrl_reg,
+						&zero,
+						sizeof(zero));
+				if (retval < 0)
+					return retval;
+			} else {
+				retval = f54->fn_ptr->write(rmi4_data,
+						f01_ctrl_reg,
+						&(intr_mask[ii]),
+						sizeof(intr_mask[ii]));
+				if (retval < 0)
+					return retval;
+			}
+		}
+	}
+
+	f01_ctrl_reg = rmi4_data->f01_ctrl_base_addr + 1 + f54->intr_reg_num;
+
+	if (set) {
+		retval = f54->fn_ptr->write(rmi4_data,
+				f01_ctrl_reg,
+				&f54->intr_mask,
+				1);
+		if (retval < 0)
+			return retval;
+	}
+
+	return 0;
+}
+
+static int do_preparation(void)
+{
+	int retval;
+	unsigned char value;
+	unsigned char command;
+	unsigned char timeout_count;
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+
+	if (f54->query.touch_controller_family == 1) {
+		value = 0;
+		retval = f54->fn_ptr->write(rmi4_data,
+				f54->control.reg_7->address,
+				&value,
+				sizeof(f54->control.reg_7->data));
+		if (retval < 0) {
+			dev_err(&rmi4_data->i2c_client->dev,
+					"%s: Failed to disable CBC\n",
+					__func__);
+			return retval;
+		}
+	}
+	/* Below codes are just needed for 0D */
+/*
+	if (f54->query.has_0d_acquisition_control) {
+		value = 0;
+		retval = f54->fn_ptr->write(rmi4_data,
+				f54->control.reg_57->address,
+				&value,
+				sizeof(f54->control.reg_57->data));
+		if (retval < 0) {
+			dev_err(&rmi4_data->i2c_client->dev,
+					"%s: Failed to disable 0D CBC\n",
+					__func__);
+			return retval;
+		}
+	}
+*/
+
+	if (f54->query.has_signal_clarity) {
+		value = 1;
+		retval = f54->fn_ptr->write(rmi4_data,
+				f54->control.reg_41->address,
+				&value,
+				sizeof(f54->control.reg_41->data));
+		if (retval < 0) {
+			dev_err(&rmi4_data->i2c_client->dev,
+					"%s: Failed to disable signal clarity\n",
+					__func__);
+			return retval;
+		}
+	}
+
+	command = (unsigned char)COMMAND_FORCE_UPDATE;
+
+	retval = f54->fn_ptr->write(rmi4_data,
+			f54->command_base_addr,
+			&command,
+			sizeof(command));
+	if (retval < 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to write force update command\n",
+				__func__);
+		return retval;
+	}
+
+	timeout_count = 0;
+	do {
+		retval = f54->fn_ptr->read(rmi4_data,
+				f54->command_base_addr,
+				&value,
+				sizeof(value));
+		if (retval < 0) {
+			dev_err(&rmi4_data->i2c_client->dev,
+					"%s: Failed to read command register\n",
+					__func__);
+			return retval;
+		}
+
+		if (value == 0x00)
+			break;
+
+		msleep(100);
+		timeout_count++;
+	} while (timeout_count < FORCE_TIMEOUT_100MS);
+
+	if (timeout_count == FORCE_TIMEOUT_100MS) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Timed out waiting for force update\n",
+				__func__);
+		return -ETIMEDOUT;
+	}
+
+	command = (unsigned char)COMMAND_FORCE_CAL;
+
+	retval = f54->fn_ptr->write(rmi4_data,
+			f54->command_base_addr,
+			&command,
+			sizeof(command));
+	if (retval < 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to write force cal command\n",
+				__func__);
+		return retval;
+	}
+
+	timeout_count = 0;
+	do {
+		retval = f54->fn_ptr->read(rmi4_data,
+				f54->command_base_addr,
+				&value,
+				sizeof(value));
+		if (retval < 0) {
+			dev_err(&rmi4_data->i2c_client->dev,
+					"%s: Failed to read command register\n",
+					__func__);
+			return retval;
+		}
+
+		if (value == 0x00)
+			break;
+
+		msleep(100);
+		timeout_count++;
+	} while (timeout_count < FORCE_TIMEOUT_100MS);
+
+	if (timeout_count == FORCE_TIMEOUT_100MS) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Timed out waiting for force cal\n",
+				__func__);
+		return -ETIMEDOUT;
+	}
+
+	return 0;
+}
+
+#ifdef WATCHDOG_HRTIMER
+static void timeout_set_status(struct work_struct *work)
+{
+	int retval;
+	unsigned char command;
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+
+	mutex_lock(&f54->status_mutex);
+	if (f54->status == STATUS_BUSY) {
+		retval = f54->fn_ptr->read(rmi4_data,
+				f54->command_base_addr,
+				&command,
+				sizeof(command));
+		if (retval < 0) {
+			dev_err(&rmi4_data->i2c_client->dev,
+					"%s: Failed to read command register\n",
+					__func__);
+			f54->status = -ETIMEDOUT;
+		} else if (command & COMMAND_GET_REPORT) {
+			dev_err(&rmi4_data->i2c_client->dev,
+					"%s: Report type not supported by FW\n",
+					__func__);
+			f54->status = -ETIMEDOUT;
+		} else {
+			queue_delayed_work(f54->status_workqueue,
+					&f54->status_work,
+					0);
+			mutex_unlock(&f54->status_mutex);
+			return;
+		}
+		f54->report_type = INVALID_REPORT_TYPE;
+		f54->report_size = 0;
+	}
+	mutex_unlock(&f54->status_mutex);
+
+	/* read fail : need ic reset */
+	if (f54->status == -ETIMEDOUT) {
+		mutex_lock(&f54->status_mutex);
+		retval = synaptics_rmi4_reset_device(rmi4_data);
+		if (retval < 0)
+			dev_info(&rmi4_data->i2c_client->dev,
+					"%s: reset fail.\n", __func__);
+		f54->status = STATUS_IDLE;
+		mutex_unlock(&f54->status_mutex);
+	}
+	return;
+}
+
+static enum hrtimer_restart get_report_timeout(struct hrtimer *timer)
+{
+	schedule_work(&(f54->timeout_work));
+
+	return HRTIMER_NORESTART;
+}
+#endif
+
+#ifdef RAW_HEX
+static void print_raw_hex_report(void)
+{
+	unsigned int ii;
+
+	pr_info("%s: Report data (raw hex)\n", __func__);
+
+	switch (f54->report_type) {
+	case F54_16BIT_IMAGE:
+	case F54_RAW_16BIT_IMAGE:
+	case F54_HIGH_RESISTANCE:
+	case F54_TRUE_BASELINE:
+	case F54_FULL_RAW_CAP_MIN_MAX:
+	case F54_FULL_RAW_CAP:
+	case F54_FULL_RAW_CAP_RX_COUPLING_COMP:
+	case F54_SENSOR_SPEED:
+	case F54_ADC_RANGE:
+		for (ii = 0; ii < f54->report_size; ii += 2) {
+			pr_info("%03d: 0x%02x%02x\n",
+					ii / 2,
+					f54->report_data[ii + 1],
+					f54->report_data[ii]);
+		}
+		break;
+	case F54_ABS_RAW_CAP:
+	case F54_ABS_DELTA_CAP:
+		for (ii = 0; ii < f54->report_size; ii += 4) {
+			pr_info("%03d: 0x%02x%02x%02x%02x\n",
+					ii / 4,
+					f54->report_data[ii + 3],
+					f54->report_data[ii + 2],
+					f54->report_data[ii + 1],
+					f54->report_data[ii]);
+		}
+		break;
+	default:
+		for (ii = 0; ii < f54->report_size; ii++)
+			pr_info("%03d: 0x%02x\n", ii, f54->report_data[ii]);
+		break;
+	}
+
+	return;
+}
+#endif
+
+#ifdef HUMAN_READABLE
+static void print_image_report(void)
+{
+	unsigned int ii;
+	unsigned int jj;
+	short *report_data;
+
+	switch (f54->report_type) {
+	case F54_16BIT_IMAGE:
+	case F54_RAW_16BIT_IMAGE:
+	case F54_TRUE_BASELINE:
+	case F54_FULL_RAW_CAP:
+	case F54_FULL_RAW_CAP_RX_COUPLING_COMP:
+		pr_info("%s: Report data (image)\n", __func__);
+
+		report_data = (short *)f54->report_data;
+
+		for (ii = 0; ii < f54->rmi4_data->num_of_tx; ii++) {
+			for (jj = 0; jj < f54->rmi4_data->num_of_rx; jj++) {
+				if (*report_data < -64)
+					pr_cont(".");
+				else if (*report_data < 0)
+					pr_cont("-");
+				else if (*report_data > 64)
+					pr_cont("*");
+				else if (*report_data > 0)
+					pr_cont("+");
+				else
+					pr_cont("0");
+
+				report_data++;
+			}
+			pr_info("");
+		}
+		pr_info("%s: End of report\n", __func__);
+		break;
+	default:
+		pr_info("%s: Image not supported for report type %d\n",
+				__func__, f54->report_type);
+	}
+
+	return;
+}
+#endif
+
+static void free_control_mem(void)
+{
+	struct f54_control control = f54->control;
+
+	kfree(control.reg_0);
+	kfree(control.reg_1);
+	kfree(control.reg_2);
+	kfree(control.reg_3);
+	kfree(control.reg_4__6);
+	kfree(control.reg_7);
+	kfree(control.reg_8__9);
+	kfree(control.reg_10);
+	kfree(control.reg_11);
+	kfree(control.reg_12__13);
+	kfree(control.reg_14);
+	kfree(control.reg_15);
+	kfree(control.reg_16);
+	kfree(control.reg_17);
+	kfree(control.reg_18);
+	kfree(control.reg_19);
+	kfree(control.reg_20);
+	kfree(control.reg_21);
+	kfree(control.reg_22__26);
+	kfree(control.reg_27);
+	kfree(control.reg_28);
+	kfree(control.reg_29);
+	kfree(control.reg_30);
+	kfree(control.reg_31);
+	kfree(control.reg_32__35);
+	kfree(control.reg_36);
+	kfree(control.reg_37);
+	kfree(control.reg_38);
+	kfree(control.reg_39);
+	kfree(control.reg_40);
+	kfree(control.reg_41);
+
+	return;
+}
+
+static void remove_sysfs(void)
+{
+	int reg_num;
+
+	sysfs_remove_bin_file(f54->attr_dir, &dev_report_data);
+
+	sysfs_remove_group(f54->attr_dir, &attr_group);
+
+	for (reg_num = 0; reg_num < ARRAY_SIZE(attrs_ctrl_regs); reg_num++)
+		sysfs_remove_group(f54->attr_dir, &attrs_ctrl_regs[reg_num]);
+
+	kobject_put(f54->attr_dir);
+
+	return;
+}
+
+#ifdef FACTORY_MODE
+static void set_default_result(struct factory_data *data)
+{
+	char delim = ':';
+
+	memset(data->cmd_buff, 0x00, sizeof(data->cmd_buff));
+	memset(data->cmd_result, 0x00, sizeof(data->cmd_result));
+	memcpy(data->cmd_result, data->cmd, strlen(data->cmd));
+	strncat(data->cmd_result, &delim, 1);
+
+	return;
+}
+
+static void set_cmd_result(struct factory_data *data, char *buf, int length)
+{
+	strncat(data->cmd_result, buf, length);
+
+	return;
+}
+
+static ssize_t cmd_store(struct device *dev, struct device_attribute *attr,
+		const char *buf, size_t count)
+{
+	unsigned char param_cnt = 0;
+	char *start;
+	char *end;
+	char *pos;
+	char delim = ',';
+	char buffer[CMD_STR_LEN];
+	bool cmd_found = false;
+	int *param;
+	int length;
+	struct ft_cmd *ft_cmd_ptr;
+	struct factory_data *data = f54->factory_data;
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+
+	if (data->cmd_is_running == true) {
+		dev_err(&rmi4_data->i2c_client->dev, "%s: Still servicing previous command. Skip cmd :%s\n",
+			 __func__, buf);
+		return count;
+	}
+
+	mutex_lock(&data->cmd_lock);
+	data->cmd_is_running = true;
+	mutex_unlock(&data->cmd_lock);
+
+	data->cmd_state = CMD_STATUS_RUNNING;
+
+	length = (int)count;
+	if (*(buf + length - 1) == '\n')
+		length--;
+
+	memset(data->cmd, 0x00, sizeof(data->cmd));
+	memcpy(data->cmd, buf, length);
+	memset(data->cmd_param, 0, sizeof(data->cmd_param));
+
+	memset(buffer, 0x00, sizeof(buffer));
+	pos = strchr(buf, (int)delim);
+	if (pos)
+		memcpy(buffer, buf, pos - buf);
+	else
+		memcpy(buffer, buf, length);
+
+	/* find command */
+	list_for_each_entry(ft_cmd_ptr, &data->cmd_list_head, list) {
+		if (!strcmp(buffer, ft_cmd_ptr->cmd_name)) {
+			cmd_found = true;
+			break;
+		}
+	}
+
+	/* set not_support_cmd */
+	if (!cmd_found) {
+		list_for_each_entry(ft_cmd_ptr,
+			&data->cmd_list_head, list) {
+			if (!strcmp("not_support_cmd", ft_cmd_ptr->cmd_name))
+				break;
+		}
+	}
+
+	/* parsing parameters */
+	if (cmd_found && pos) {
+		pos++;
+		start = pos;
+		do {
+			if ((*pos == delim) || (pos - buf == length)) {
+				end = pos;
+				memset(buffer, 0x00, sizeof(buffer));
+				memcpy(buffer, start, end - start);
+				*(buffer + strlen(buffer)) = '\0';
+				param = data->cmd_param + param_cnt;
+				if (kstrtoint(buffer, 10, param) < 0)
+					break;
+				param_cnt++;
+				start = pos + 1;
+			}
+			pos++;
+		} while (pos - buf <= length);
+	}
+
+	dev_info(&rmi4_data->i2c_client->dev, "%s: Command = %s\n",
+			__func__, buf);
+
+	ft_cmd_ptr->cmd_func();
+
+	return count;
+}
+
+static ssize_t cmd_status_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	char buffer[16];
+	struct factory_data *data = f54->factory_data;
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+
+	dev_info(&rmi4_data->i2c_client->dev, "%s: Command status = %d\n",
+	    __func__, data->cmd_state);
+
+	switch (data->cmd_state) {
+	case CMD_STATUS_WAITING:
+		sprintf(buffer, "%s", tostring(WAITING));
+		break;
+	case CMD_STATUS_RUNNING:
+		sprintf(buffer, "%s", tostring(RUNNING));
+		break;
+	case CMD_STATUS_OK:
+		sprintf(buffer, "%s", tostring(OK));
+		break;
+	case CMD_STATUS_FAIL:
+		sprintf(buffer, "%s", tostring(FAIL));
+		break;
+	case CMD_STATUS_NOT_APPLICABLE:
+		sprintf(buffer, "%s", tostring(NOT_APPLICABLE));
+		break;
+	default:
+		sprintf(buffer, "%s", tostring(NOT_APPLICABLE));
+		break;
+	}
+
+	return snprintf(buf, PAGE_SIZE, "%s\n", buffer);
+}
+
+static ssize_t cmd_result_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct factory_data *data = f54->factory_data;
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+
+	dev_info(&rmi4_data->i2c_client->dev, "%s: Command result = %s\n",
+		__func__, data->cmd_result);
+
+	mutex_lock(&data->cmd_lock);
+	data->cmd_is_running = false;
+	mutex_unlock(&data->cmd_lock);
+
+	data->cmd_state = CMD_STATUS_WAITING;
+
+	return snprintf(buf, PAGE_SIZE, "%s\n", data->cmd_result);
+}
+
+static ssize_t cmd_list_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	int ii = 0;
+	char buffer[CMD_RESULT_STR_LEN];
+	char buffer_name[CMD_STR_LEN];
+
+	snprintf(buffer, 30, "++factory command list++\n");
+	while (strncmp(ft_cmds[ii].cmd_name, "not_support_cmd", 16) != 0) {
+		snprintf(buffer_name, CMD_STR_LEN, "%s\n", ft_cmds[ii].cmd_name);
+		strcat(buffer, buffer_name);
+		ii++;
+	}
+
+	return snprintf(buf, PAGE_SIZE, "%s\n", buffer);
+
+}
+
+static int synaptics_load_fw_from_ums(struct synaptics_rmi4_data *data)
+{
+	struct file *fp;
+	mm_segment_t old_fs;
+	unsigned short fw_size, nread;
+	int error = 0;
+
+	old_fs = get_fs();
+	set_fs(KERNEL_DS);
+
+	fp = filp_open(SYNAPTICS_FW_UMS, O_RDONLY, S_IRUSR);
+	if (IS_ERR(fp)) {
+		dev_err(&data->i2c_client->dev,
+			"%s: failed to open %s.\n", __func__, SYNAPTICS_FW_UMS);
+		error = -ENOENT;
+		goto open_err;
+	}
+
+	fw_size = fp->f_path.dentry->d_inode->i_size;
+	if (0 < fw_size) {
+		unsigned char *fw_data;
+		fw_data = kzalloc(fw_size, GFP_KERNEL);
+		nread = vfs_read(fp, (char __user *)fw_data,
+			fw_size, &fp->f_pos);
+		dev_info(&data->i2c_client->dev,
+			"%s: start, file path %s, size %u Bytes\n", __func__,
+		       SYNAPTICS_FW_UMS, fw_size);
+		if (nread != fw_size) {
+			dev_err(&data->i2c_client->dev,
+			       "%s: failed to read firmware file, nread %u Bytes\n",
+			       __func__,
+			       nread);
+			error = -EIO;
+		} else
+			error = synaptics_fw_updater(fw_data, true, false);
+			if (error < 0)
+				dev_err(&data->i2c_client->dev,
+					"%s: failed update firmware\n",
+					__func__);
+		kfree(fw_data);
+	}
+
+	filp_close(fp, current->files);
+
+ open_err:
+	set_fs(old_fs);
+	return error;
+}
+
+static void fw_update(void)
+{
+	struct factory_data *data = f54->factory_data;
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+
+	int retval = 0;
+
+	set_default_result(data);
+
+	switch (data->cmd_param[0]) {
+
+	case 1:
+		retval = synaptics_load_fw_from_ums(rmi4_data);
+		break;
+	case 2:
+		retval = synaptics_fw_updater(NULL, true, true);
+		break;
+	case 0:
+		retval = synaptics_fw_updater(NULL, true, false);
+		break;
+	}
+	msleep(1000);
+
+	if (retval < 0) {
+		sprintf(data->cmd_buff, "%s", tostring(NA));
+		set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+		data->cmd_state = CMD_STATUS_FAIL;
+		dev_err(&rmi4_data->i2c_client->dev, "%s: failed [%d]\n",
+			__func__, retval);
+	} else {
+		sprintf(data->cmd_buff, "%s", tostring(OK));
+		set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+		data->cmd_state = CMD_STATUS_OK;
+		dev_info(&rmi4_data->i2c_client->dev, "%s: success [%d]\n",
+			__func__, retval);
+	}
+
+	return;
+}
+
+static void get_fw_ver_bin(void)
+{
+	struct factory_data *data = f54->factory_data;
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+
+	set_default_result(data);
+	sprintf(data->cmd_buff, "SY%02X%02X%02X",
+			rmi4_data->ic_revision_of_bin,
+			rmi4_data->board->panel_touch_type,
+			rmi4_data->fw_version_of_bin);
+	set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+
+	data->cmd_state = CMD_STATUS_OK;
+
+	return;
+}
+
+static void get_fw_ver_ic(void)
+{
+	struct factory_data *data = f54->factory_data;
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+
+	set_default_result(data);
+	sprintf(data->cmd_buff, "SY%02X%02X%02X",
+			rmi4_data->ic_revision_of_ic,
+			rmi4_data->board->panel_touch_type,
+			rmi4_data->fw_version_of_ic);
+
+	set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+
+	data->cmd_state = CMD_STATUS_OK;
+
+	return;
+}
+
+static void get_fac_fw_ver_bin(void)
+{
+	struct factory_data *data = f54->factory_data;
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+	int retval;
+	const struct firmware *fw_entry = NULL;
+
+	set_default_result(data);
+#if defined(CONFIG_MACH_JACTIVE_EUR) || defined(CONFIG_MACH_JACTIVE_ATT)
+	retval = request_firmware(&fw_entry, FW_IMAGE_NAME_B0_HSYNC_FAC,
+			&rmi4_data->i2c_client->dev);
+#else
+	retval = request_firmware(&fw_entry, FW_IMAGE_NAME_B0_FAC,
+			&rmi4_data->i2c_client->dev);
+#endif
+
+	if (retval < 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: factory firmware request failed\n",
+				__func__);
+		snprintf(data->cmd_buff, sizeof(data->cmd_buff), "NG");
+		set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+
+		data->cmd_state = CMD_STATUS_FAIL;
+
+	} else {
+		sprintf(data->cmd_buff, "SY%02X%02X%02X",
+				(int)fw_entry->data[DATE_OF_FIRMWARE_BIN_OFFSET],
+				(int)fw_entry->data[IC_REVISION_BIN_OFFSET],
+				(int)fw_entry->data[FW_VERSION_BIN_OFFSET]);
+		set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+
+		data->cmd_state = CMD_STATUS_OK;
+	}
+
+	release_firmware(fw_entry);
+
+	return;
+}
+
+static void get_config_ver(void)
+{
+	struct factory_data *data = f54->factory_data;
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+
+	set_default_result(data);
+	sprintf(data->cmd_buff, "%s_SY_%02d%02d",
+	    SYNAPTICS_DEVICE_NAME, rmi4_data->fw_release_date_of_ic >> 8,
+	    rmi4_data->fw_release_date_of_ic & 0x00FF);
+	set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+
+	data->cmd_state = CMD_STATUS_OK;
+
+	return;
+}
+
+static void get_threshold(void)
+{
+	unsigned char threshold;
+	struct factory_data *data = f54->factory_data;
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+
+	f54->fn_ptr->read(rmi4_data,
+			F12_CTRL9_ADDR,
+			&threshold,
+			sizeof(threshold));
+
+	set_default_result(data);
+	sprintf(data->cmd_buff, "%03d", threshold);
+	set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+
+	data->cmd_state = CMD_STATUS_OK;
+
+	return;
+}
+
+static void module_off_master(void)
+{
+	struct factory_data *data = f54->factory_data;
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+
+	set_default_result(data);
+
+	mutex_lock(&data->cmd_lock);
+
+	disable_irq(rmi4_data->i2c_client->irq);
+	rmi4_data->touch_stopped = true;
+
+	rmi4_data->board->power(false);
+
+	sprintf(data->cmd_buff, "%s", tostring(OK));
+	data->cmd_state = CMD_STATUS_OK;
+
+	mutex_unlock(&data->cmd_lock);
+
+	set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+}
+
+static void module_on_master(void)
+{
+	struct factory_data *data = f54->factory_data;
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+
+	set_default_result(data);
+
+	mutex_lock(&data->cmd_lock);
+
+	rmi4_data->board->power(true);
+	msleep(400);
+	rmi4_data->touch_stopped = false;
+	rmi4_data->reset_device(rmi4_data);
+	enable_irq(rmi4_data->i2c_client->irq);
+
+	sprintf(data->cmd_buff, "%s", tostring(OK));
+	data->cmd_state = CMD_STATUS_OK;
+
+	mutex_unlock(&data->cmd_lock);
+
+	set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+}
+
+static void get_chip_vendor(void)
+{
+	struct factory_data *data = f54->factory_data;
+
+	set_default_result(data);
+
+	sprintf(data->cmd_buff, "%s", tostring(SYNAPTICS));
+	data->cmd_state = CMD_STATUS_OK;
+	set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+}
+
+static void get_chip_name(void)
+{
+	struct factory_data *data = f54->factory_data;
+
+	set_default_result(data);
+
+	sprintf(data->cmd_buff, "%s", tostring(S5000));
+	data->cmd_state = CMD_STATUS_OK;
+	set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+}
+
+static void get_x_num(void)
+{
+	struct factory_data *data = f54->factory_data;
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+
+	set_default_result(data);
+	sprintf(data->cmd_buff, "%d", rmi4_data->num_of_tx);
+	set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+
+	data->cmd_state = CMD_STATUS_OK;
+
+	return;
+}
+
+static void get_y_num(void)
+{
+	struct factory_data *data = f54->factory_data;
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+
+	set_default_result(data);
+	sprintf(data->cmd_buff, "%d", rmi4_data->num_of_rx);
+	set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+
+	data->cmd_state = CMD_STATUS_OK;
+
+	return;
+}
+
+static int check_rx_tx_num(void)
+{
+	struct factory_data *data = f54->factory_data;
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+
+	int node;
+
+	dev_info(&rmi4_data->i2c_client->dev, "%s: param[0] = %d, param[1] = %d\n",
+			__func__, data->cmd_param[0], data->cmd_param[1]);
+
+	if (data->cmd_param[0] < 0 ||
+			data->cmd_param[0] >= rmi4_data->num_of_tx ||
+			data->cmd_param[1] < 0 ||
+			data->cmd_param[1] >= rmi4_data->num_of_rx) {
+
+		sprintf(data->cmd_buff, "%s", tostring(NA));
+		set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+		data->cmd_state = CMD_STATUS_FAIL;
+
+		dev_info(&rmi4_data->i2c_client->dev, "%s: parameter error: %u,%u\n",
+			__func__, data->cmd_param[0], data->cmd_param[1]);
+		node = -1;
+	} else {
+#if defined(CONFIG_MACH_JACTIVE_EUR) || defined(CONFIG_MACH_JACTIVE_ATT)
+		node = data->cmd_param[0] * rmi4_data->num_of_rx +
+						data->cmd_param[1];
+#else
+		node = data->cmd_param[0] * rmi4_data->num_of_tx +
+						data->cmd_param[1];
+#endif
+		dev_info(&rmi4_data->i2c_client->dev, "%s: node = %d\n",
+				__func__, node);
+	}
+	return node;
+}
+
+static void get_rawcap(void)
+{
+	int node;
+	short report_data;
+	struct factory_data *data = f54->factory_data;
+
+	set_default_result(data);
+
+	node = check_rx_tx_num();
+
+	if (node < 0) {
+		data->cmd_state = CMD_STATUS_FAIL;
+		return;
+	} else {
+		report_data = f54->factory_data->rawcap_data[node];
+
+		sprintf(data->cmd_buff, "%d", report_data);
+		set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+		data->cmd_state = CMD_STATUS_OK;
+	}
+	return;
+}
+
+static void run_rawcap_read(void)
+{
+	int retval;
+	int kk = 0;
+	unsigned char ii;
+	unsigned char jj;
+	unsigned char num_of_tx;
+	unsigned char num_of_rx;
+	short *report_data;
+	short max_value;
+	short min_value;
+	short cur_value;
+	struct factory_data *data = f54->factory_data;
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+	unsigned char command = 0x01;
+
+	set_default_result(data);
+
+	if (f54->rmi4_data->ic_revision_of_ic != 0xBF) {
+		dev_info(&f54->rmi4_data->i2c_client->dev,
+				"%s: this is not Factory FW.\n", __func__);
+		sprintf(data->cmd_buff, "%s", "Not Factory Firmware");
+		set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+		data->cmd_state = CMD_STATUS_NOT_APPLICABLE;
+		return;
+	}
+
+	if (rmi4_data->touch_stopped) {
+		dev_err(&rmi4_data->i2c_client->dev, "%s: [ERROR] Touch is stopped\n",
+			__func__);
+		sprintf(data->cmd_buff, "%s", "TSP turned off");
+		set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+		data->cmd_state = CMD_STATUS_NOT_APPLICABLE;
+		return;
+	}
+
+	retval = do_preparation();
+	if (retval < 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to do preparation\n",
+				__func__);
+		sprintf(data->cmd_buff, "%s", "Error preparation");
+		set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+		data->cmd_state = CMD_STATUS_NOT_APPLICABLE;
+		return;
+	}
+
+	if (!synaptics_rmi4_f54_get_report_type(CMD_REPORT_TYPE_RAWCAP)) {
+		data->cmd_state = CMD_STATUS_FAIL;
+		goto exit;
+	}
+
+	report_data = f54->factory_data->rawcap_data;
+	memcpy(report_data, f54->report_data, f54->report_size);
+
+	num_of_tx = rmi4_data->num_of_tx;
+	num_of_rx = rmi4_data->num_of_rx;
+	max_value = min_value = report_data[0];
+
+	for (ii = 0; ii < num_of_tx; ii++) {
+		for (jj = 0; jj < num_of_rx; jj++) {
+			cur_value = *report_data;
+			max_value = max(max_value, cur_value);
+			min_value = min(min_value, cur_value);
+			report_data++;
+
+			if (cur_value > TSP_RAWCAP_MAX || cur_value < TSP_RAWCAP_MIN)
+				dev_info(&rmi4_data->i2c_client->dev,
+					"tx = %02d, rx = %02d, data[%d] = %d\n",
+					ii, jj, kk, cur_value);
+			kk++;
+		}
+	}
+
+	sprintf(data->cmd_buff, "%d,%d", min_value, max_value);
+	set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+
+	data->cmd_state = CMD_STATUS_OK;
+
+exit:
+	/* soft reset */
+	retval = f54->fn_ptr->write(rmi4_data,
+		rmi4_data->f01_cmd_base_addr,
+		&command,
+		sizeof(command));
+	if (retval < 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to issue reset command, error = %d\n",
+				__func__, retval);
+	}
+
+	return;
+}
+
+static void get_delta(void)
+{
+	int node;
+	short report_data;
+	struct factory_data *data = f54->factory_data;
+
+	set_default_result(data);
+
+	node = check_rx_tx_num();
+
+	if (node < 0) {
+		data->cmd_state = CMD_STATUS_FAIL;
+		return;
+	} else {
+		report_data = f54->factory_data->delta_data[node];
+
+		sprintf(data->cmd_buff, "%d", report_data);
+		set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+		data->cmd_state = CMD_STATUS_OK;
+	}
+}
+
+static void run_delta_read(void)
+{
+	struct factory_data *data = f54->factory_data;
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+	short *report_data;
+	short cur_value;
+	unsigned char ii;
+	unsigned char jj;
+	unsigned char num_of_tx;
+	unsigned char num_of_rx;
+	int kk = 0;
+
+	set_default_result(data);
+
+	if (f54->rmi4_data->ic_revision_of_ic != 0xBF) {
+		dev_info(&f54->rmi4_data->i2c_client->dev,
+				"%s: this is not Factory FW.\n", __func__);
+		sprintf(data->cmd_buff, "%s", "Not Factory Firmware");
+		set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+		data->cmd_state = CMD_STATUS_NOT_APPLICABLE;
+		return;
+	}
+
+	if (rmi4_data->touch_stopped) {
+		dev_err(&rmi4_data->i2c_client->dev, "%s: [ERROR] Touch is stopped\n",
+			__func__);
+		sprintf(data->cmd_buff, "%s", "TSP turned off");
+		set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+		data->cmd_state = CMD_STATUS_NOT_APPLICABLE;
+		return;
+	}
+
+	if (!synaptics_rmi4_f54_get_report_type(CMD_REPORT_TYPE_DELTA)) {
+		data->cmd_state = CMD_STATUS_FAIL;
+		return;
+	}
+
+	report_data = f54->factory_data->delta_data;
+	memcpy(report_data, f54->report_data, f54->report_size);
+
+	num_of_tx = rmi4_data->num_of_tx;
+	num_of_rx = rmi4_data->num_of_rx;
+
+	for (ii = 0; ii < num_of_tx; ii++) {
+		for (jj = 0; jj < num_of_rx; jj++) {
+			cur_value = *report_data;
+			report_data++;
+			if (cur_value > TSP_DELTA_MAX || cur_value < TSP_DELTA_MIN)
+				dev_info(&rmi4_data->i2c_client->dev,
+					"tx = %02d, rx = %02d, data[%d] = %d\n",
+					ii, jj, kk, cur_value);
+			kk++;
+		}
+	}
+
+	snprintf(data->cmd_buff, sizeof(data->cmd_buff), "OK");
+	set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+
+	data->cmd_state = CMD_STATUS_OK;
+
+	return;
+
+}
+
+static void run_abscap_read(void)
+{
+	struct factory_data *data = f54->factory_data;
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+
+	unsigned short *report_data;
+	char temp[CMD_STR_LEN];
+	char temp2[CMD_RESULT_STR_LEN];
+	unsigned char ii;
+	unsigned short num_of_tx;
+	unsigned short num_of_rx;
+
+	set_default_result(data);
+
+	if (f54->rmi4_data->ic_revision_of_ic != 0xBF) {
+		dev_info(&f54->rmi4_data->i2c_client->dev,
+				"%s: this is not Factory FW.\n", __func__);
+		sprintf(data->cmd_buff, "%s", "Not Factory Firmware");
+		set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+		data->cmd_state = CMD_STATUS_NOT_APPLICABLE;
+		return;
+	}
+
+	if (rmi4_data->touch_stopped) {
+		dev_err(&rmi4_data->i2c_client->dev, "%s: [ERROR] Touch is stopped\n",
+			__func__);
+		sprintf(data->cmd_buff, "%s", "TSP turned off");
+		set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+		data->cmd_state = CMD_STATUS_NOT_APPLICABLE;
+		return;
+	}
+
+	if (!synaptics_rmi4_f54_get_report_type(F54_ABS_RAW_CAP)) {
+		data->cmd_state = CMD_STATUS_FAIL;
+		return;
+	}
+
+	report_data = f54->factory_data->abscap_data;
+	memcpy(report_data, f54->report_data, f54->report_size);
+	memset(temp, 0, CMD_STR_LEN);
+	memset(temp2, 0, CMD_RESULT_STR_LEN);
+
+	num_of_tx = rmi4_data->num_of_tx;
+	num_of_rx = rmi4_data->num_of_rx;
+
+	for (ii = 0; ii < num_of_rx + num_of_tx; ii++) {
+		*report_data &= 0x0FFFF;
+		dev_info(&rmi4_data->i2c_client->dev,
+				"%s: %s [%d] = %d\n", __func__,
+				ii >= num_of_rx ? "Tx" : "Rx",
+				ii < num_of_rx ? ii : ii - num_of_rx,
+				*report_data);
+		sprintf(temp, "%d,", *report_data);
+		strncat(temp2, temp, 9);
+		report_data += 2;
+	}
+	sprintf(data->cmd_buff, "%s", temp2);
+	set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+
+	data->cmd_state = CMD_STATUS_OK;
+
+	return;
+}
+
+static void run_absdelta_read(void)
+{
+	struct factory_data *data = f54->factory_data;
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+
+	short *report_data;
+	char temp[CMD_STR_LEN];
+	char temp2[CMD_RESULT_STR_LEN];
+	unsigned char ii;
+	unsigned short num_of_tx;
+	unsigned short num_of_rx;
+
+	set_default_result(data);
+
+	if (f54->rmi4_data->ic_revision_of_ic != 0xBF) {
+		dev_info(&f54->rmi4_data->i2c_client->dev,
+				"%s: this is not Factory FW.\n", __func__);
+		sprintf(data->cmd_buff, "%s", "Not Factory Firmware");
+		set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+		data->cmd_state = CMD_STATUS_NOT_APPLICABLE;
+		return;
+	}
+
+	if (rmi4_data->touch_stopped) {
+		dev_err(&rmi4_data->i2c_client->dev, "%s: [ERROR] Touch is stopped\n",
+			__func__);
+		sprintf(data->cmd_buff, "%s", "TSP turned off");
+		set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+		data->cmd_state = CMD_STATUS_NOT_APPLICABLE;
+		return;
+	}
+
+	if (!synaptics_rmi4_f54_get_report_type(F54_ABS_DELTA_CAP)) {
+		data->cmd_state = CMD_STATUS_FAIL;
+		return;
+	}
+
+	report_data = f54->factory_data->absdelta_data;
+	memcpy(report_data, f54->report_data, f54->report_size);
+	memset(temp, 0, CMD_STR_LEN);
+	memset(temp2, 0, CMD_RESULT_STR_LEN);
+
+	num_of_tx = rmi4_data->num_of_tx;
+	num_of_rx = rmi4_data->num_of_rx;
+
+	for (ii = 0; ii < num_of_rx + num_of_tx; ii++) {
+		dev_info(&rmi4_data->i2c_client->dev,
+				"%s: %s [%d] = %d\n", __func__,
+				ii >= num_of_rx ? "Tx" : "Rx",
+				ii < num_of_rx ? ii : ii - num_of_rx,
+				*report_data);
+		sprintf(temp, "%d,", *report_data);
+		strncat(temp2, temp, 5);
+		report_data += 2;
+	}
+	sprintf(data->cmd_buff, "%s", temp2);
+	set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+
+	data->cmd_state = CMD_STATUS_OK;
+
+	return;
+}
+
+static void run_trx_short_test(void)
+{
+	struct factory_data *data = f54->factory_data;
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+
+	short *report_data;
+	unsigned char ii;
+	int retval = 0;
+
+	set_default_result(data);
+
+	if (f54->rmi4_data->ic_revision_of_ic != 0xBF) {
+		dev_info(&f54->rmi4_data->i2c_client->dev,
+				"%s: this is not Factory FW.\n", __func__);
+		sprintf(data->cmd_buff, "%s", "Not Factory Firmware");
+		set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+		data->cmd_state = CMD_STATUS_NOT_APPLICABLE;
+		return;
+	}
+
+	if (rmi4_data->touch_stopped) {
+		dev_err(&rmi4_data->i2c_client->dev, "%s: [ERROR] Touch is stopped\n",
+			__func__);
+		sprintf(data->cmd_buff, "%s", "TSP turned off");
+		set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+		data->cmd_state = CMD_STATUS_NOT_APPLICABLE;
+		return;
+	}
+
+	disable_irq(rmi4_data->i2c_client->irq);
+	if (!synaptics_rmi4_f54_get_report_type(F54_TREX_SHORTS)) {
+		data->cmd_state = CMD_STATUS_FAIL;
+		return;
+	}
+
+	report_data = f54->factory_data->trx_short;
+	memcpy(report_data, f54->report_data, f54->report_size);
+
+	for (ii = 0; ii < f54->report_size; ii++) {
+		dev_info(&rmi4_data->i2c_client->dev,
+			"%s: [%d]: [%x][%x][%x][%x][%x][%x][%x][%x]\n",
+			__func__, ii, *report_data & 0x1, (*report_data & 0x2) >> 1,
+			(*report_data & 0x4) >> 2, (*report_data & 0x8) >> 3,
+			(*report_data & 0x10) >> 4, (*report_data & 0x20) >> 5,
+			(*report_data & 0x40) >> 6, (*report_data & 0x80) >> 7);
+		if (*report_data > 0)
+			retval++;
+		report_data++;
+	}
+	if (retval > 0)
+		sprintf(data->cmd_buff, "FAIL");
+	else
+		sprintf(data->cmd_buff, "OK");
+
+	enable_irq(rmi4_data->i2c_client->irq);
+
+	f54->rmi4_data->reset_device(rmi4_data);
+	set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+
+	data->cmd_state = CMD_STATUS_OK;
+
+	return;
+}
+
+static void hover_enable(void)
+{
+	struct factory_data *data = f54->factory_data;
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+
+	set_default_result(data);
+
+	if (data->cmd_param[0] < 0 || data->cmd_param[0] > 1) {
+		snprintf(data->cmd_buff, sizeof(data->cmd_buff), "NG");
+		data->cmd_state = CMD_STATUS_FAIL;
+	} else {
+		int retval, enables;
+
+		enables = data->cmd_param[0];
+		retval = synaptics_rmi4_proximity_enables(enables);
+		if (retval < 0) {
+			dev_err(&rmi4_data->i2c_client->dev,
+				"%s failed, retval = %d\n",
+				__func__, retval);
+			snprintf(data->cmd_buff, sizeof(data->cmd_buff), "NG");
+			data->cmd_state = CMD_STATUS_FAIL;
+		} else {
+			snprintf(data->cmd_buff, sizeof(data->cmd_buff), "OK");
+			data->cmd_state = CMD_STATUS_OK;
+		}
+	}
+
+	set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+
+	mutex_lock(&data->cmd_lock);
+	data->cmd_is_running = false;
+	mutex_unlock(&data->cmd_lock);
+
+	data->cmd_state = CMD_STATUS_WAITING;
+
+	return;
+}
+
+static void hover_no_sleep_enable(void)
+{
+	struct factory_data *data = f54->factory_data;
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+
+	set_default_result(data);
+
+	if (data->cmd_param[0] < 0 || data->cmd_param[0] > 1) {
+		snprintf(data->cmd_buff, sizeof(data->cmd_buff), "NG");
+		data->cmd_state = CMD_STATUS_FAIL;
+	} else {
+		int retval;
+
+		if (data->cmd_param[0])
+			retval = synaptics_proximity_no_sleep_set(true);
+		else
+			retval = synaptics_proximity_no_sleep_set(false);
+
+		if (retval < 0) {
+			dev_err(&rmi4_data->i2c_client->dev, "%s failed, retval = %d\n",
+				__func__, retval);
+			snprintf(data->cmd_buff, sizeof(data->cmd_buff), "NG");
+			data->cmd_state = CMD_STATUS_FAIL;
+		} else {
+			snprintf(data->cmd_buff, sizeof(data->cmd_buff), "OK");
+			data->cmd_state = CMD_STATUS_OK;
+		}
+
+	}
+
+	set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+
+	return;
+}
+
+#define GLOVE_MODE_EN (1 << 0)
+#define CLEAR_COVER_EN (1 << 1)
+#define FAST_GLOVE_MODE_EN (1 << 2)
+
+static void glove_mode(void)
+{
+	struct factory_data *data = f54->factory_data;
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+
+	set_default_result(data);
+
+	if (rmi4_data->glove_mode_enables & CLEAR_COVER_EN) {
+		snprintf(data->cmd_buff, sizeof(data->cmd_buff), "OK");
+		data->cmd_state = CMD_STATUS_OK;
+		dev_info(&rmi4_data->i2c_client->dev,
+				"%s Skip glove mode set (cover bit enabled)\n",
+				__func__);
+		goto skip_glove_mode_set;
+	}
+
+	if (data->cmd_param[0] < 0 || data->cmd_param[0] > 1) {
+		snprintf(data->cmd_buff, sizeof(data->cmd_buff), "NG");
+		data->cmd_state = CMD_STATUS_FAIL;
+	} else {
+		int retval;
+
+		if (data->cmd_param[0])
+			rmi4_data->glove_mode_enables |= GLOVE_MODE_EN;
+		else
+			rmi4_data->glove_mode_enables &= ~(GLOVE_MODE_EN);
+
+		retval = synaptics_rmi4_glove_mode_enables(rmi4_data);
+		if (retval < 0) {
+			dev_err(&rmi4_data->i2c_client->dev,
+				"%s failed, retval = %d\n",
+				__func__, retval);
+			snprintf(data->cmd_buff, sizeof(data->cmd_buff), "NG");
+			data->cmd_state = CMD_STATUS_FAIL;
+		} else {
+			snprintf(data->cmd_buff, sizeof(data->cmd_buff), "OK");
+			data->cmd_state = CMD_STATUS_OK;
+		}
+	}
+
+skip_glove_mode_set:
+	set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+
+	mutex_lock(&data->cmd_lock);
+	data->cmd_is_running = false;
+	mutex_unlock(&data->cmd_lock);
+
+	data->cmd_state = CMD_STATUS_WAITING;
+
+	return;
+}
+
+static void fast_glove_mode(void)
+{
+	struct factory_data *data = f54->factory_data;
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+
+	set_default_result(data);
+
+	if (data->cmd_param[0] < 0 || data->cmd_param[0] > 1) {
+		snprintf(data->cmd_buff, sizeof(data->cmd_buff), "NG");
+		data->cmd_state = CMD_STATUS_FAIL;
+	} else {
+		int retval;
+
+		if (data->cmd_param[0]) {
+			rmi4_data->glove_mode_enables |= (FAST_GLOVE_MODE_EN | GLOVE_MODE_EN);
+			rmi4_data->fast_glove_state = true;
+		} else {
+			rmi4_data->glove_mode_enables &= ~(FAST_GLOVE_MODE_EN);
+			rmi4_data->fast_glove_state = false;
+		}
+
+		retval = synaptics_rmi4_glove_mode_enables(rmi4_data);
+		if (retval < 0) {
+			dev_err(&rmi4_data->i2c_client->dev,
+				"%s failed, retval = %d\n",
+				__func__, retval);
+			snprintf(data->cmd_buff, sizeof(data->cmd_buff), "NG");
+			data->cmd_state = CMD_STATUS_FAIL;
+		} else {
+			snprintf(data->cmd_buff, sizeof(data->cmd_buff), "OK");
+			data->cmd_state = CMD_STATUS_OK;
+		}
+	}
+
+	set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+
+	mutex_lock(&data->cmd_lock);
+	data->cmd_is_running = false;
+	mutex_unlock(&data->cmd_lock);
+
+	data->cmd_state = CMD_STATUS_WAITING;
+
+	return;
+}
+
+static void clear_cover_mode(void)
+{
+	struct factory_data *data = f54->factory_data;
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+
+	set_default_result(data);
+
+	if (data->cmd_param[0] < 0 || data->cmd_param[0] > 3) {
+		snprintf(data->cmd_buff, sizeof(data->cmd_buff), "NG");
+		data->cmd_state = CMD_STATUS_FAIL;
+	} else {
+		int retval;
+
+		rmi4_data->glove_mode_enables = data->cmd_param[0];
+
+		if (data->cmd_param[0] && rmi4_data->fast_glove_state)
+			rmi4_data->glove_mode_enables |= FAST_GLOVE_MODE_EN;
+
+		retval = synaptics_rmi4_glove_mode_enables(rmi4_data);
+		if (retval < 0) {
+			dev_err(&rmi4_data->i2c_client->dev,
+				"%s failed, retval = %d\n",
+				__func__, retval);
+			snprintf(data->cmd_buff, sizeof(data->cmd_buff), "NG");
+			data->cmd_state = CMD_STATUS_FAIL;
+		} else {
+			snprintf(data->cmd_buff, sizeof(data->cmd_buff), "OK");
+			data->cmd_state = CMD_STATUS_OK;
+		}
+
+		/* Sync user setting value when wakeup with flip cover opened */
+		if ((0x02 == rmi4_data->glove_mode_enables) ||
+			(0x06 == rmi4_data->glove_mode_enables)) {
+			rmi4_data->glove_mode_enables &= ~(CLEAR_COVER_EN);
+
+			if (rmi4_data->fast_glove_state)
+				rmi4_data->glove_mode_enables |= GLOVE_MODE_EN;
+		}
+	}
+
+	set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+
+	mutex_lock(&data->cmd_lock);
+	data->cmd_is_running = false;
+	mutex_unlock(&data->cmd_lock);
+
+	data->cmd_state = CMD_STATUS_WAITING;
+
+	return;
+}
+
+static void get_glove_sensitivity(void)
+{
+	struct factory_data *data = f54->factory_data;
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+
+	set_default_result(data);
+
+	dev_info(&rmi4_data->i2c_client->dev,
+			"%s : %x\n", __func__, rmi4_data->gloved_sensitivity & 0x0F);
+
+	sprintf(data->cmd_buff, "%x", rmi4_data->gloved_sensitivity & 0x0F);
+	set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+
+	data->cmd_state = CMD_STATUS_OK;
+	return;
+}
+
+static void hover_rezero(void)
+{
+	struct factory_data *data = f54->factory_data;
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+
+	dev_info(&rmi4_data->i2c_client->dev, "%s\n", __func__);
+
+	set_default_result(data);
+
+	synaptics_rmi4_f51_set_custom_rezero(rmi4_data);
+
+	snprintf(data->cmd_buff, sizeof(data->cmd_buff), "OK");
+	data->cmd_state = CMD_STATUS_OK;
+
+	set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+}
+
+static void boost_level(void)
+{
+	struct factory_data *data = f54->factory_data;
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+#ifdef TSP_BOOSTER
+	int retval;
+#endif
+	dev_info(&rmi4_data->i2c_client->dev, "%s\n", __func__);
+
+	set_default_result(data);
+
+#ifdef TSP_BOOSTER
+	rmi4_data->dvfs_boost_mode = data->cmd_param[0];
+
+	dev_info(&rmi4_data->i2c_client->dev,
+			"%s: dvfs_boost_mode = %d\n",
+			__func__, rmi4_data->dvfs_boost_mode);
+#endif
+	snprintf(data->cmd_buff, sizeof(data->cmd_buff), "OK");
+	data->cmd_state = CMD_STATUS_OK;
+#ifdef TSP_BOOSTER
+	if (rmi4_data->dvfs_boost_mode == DVFS_STAGE_NONE) {
+			retval = set_freq_limit(DVFS_TOUCH_ID, -1);
+			if (retval < 0) {
+				dev_err(&rmi4_data->i2c_client->dev,
+					"%s: booster stop failed(%d).\n",
+					__func__, retval);
+				snprintf(data->cmd_buff, sizeof(data->cmd_buff), "NG");
+				data->cmd_state = CMD_STATUS_FAIL;
+
+				rmi4_data->dvfs_lock_status = false;
+			}
+	}
+#endif
+
+	set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+
+	mutex_lock(&data->cmd_lock);
+	data->cmd_is_running = false;
+	mutex_unlock(&data->cmd_lock);
+
+	data->cmd_state = CMD_STATUS_WAITING;
+
+	return;
+}
+
+static void not_support_cmd(void)
+{
+	struct factory_data *data = f54->factory_data;
+
+	set_default_result(data);
+	sprintf(data->cmd_buff, "%s", tostring(NA));
+	set_cmd_result(data, data->cmd_buff, strlen(data->cmd_buff));
+	data->cmd_state = CMD_STATUS_NOT_APPLICABLE;
+}
+#endif
+
+static ssize_t synaptics_rmi4_f54_status_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%u\n", f54->status);
+}
+
+static ssize_t synaptics_rmi4_f54_report_size_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%u\n", f54->report_size);
+}
+
+static ssize_t synaptics_rmi4_f54_no_auto_cal_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%u\n", f54->no_auto_cal);
+}
+
+static ssize_t synaptics_rmi4_f54_no_auto_cal_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	int retval;
+	unsigned char data;
+	unsigned long setting;
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+
+	retval = kstrtoul(buf, 10, &setting);
+	if (retval)
+		return retval;
+
+	if (setting > 1)
+		return -EINVAL;
+
+	retval = f54->fn_ptr->read(rmi4_data,
+			f54->control_base_addr,
+			&data,
+			sizeof(data));
+	if (retval < 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to read control register\n",
+				__func__);
+		return retval;
+	}
+
+	if ((data & NO_AUTO_CAL_MASK) == setting)
+		return count;
+
+	data = (data & ~NO_AUTO_CAL_MASK) | (data & NO_AUTO_CAL_MASK);
+
+	retval = f54->fn_ptr->write(rmi4_data,
+			f54->control_base_addr,
+			&data,
+			sizeof(data));
+	if (retval < 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to write control register\n",
+				__func__);
+		return retval;
+	}
+
+	f54->no_auto_cal = (setting == 1);
+
+	return count;
+}
+
+static ssize_t synaptics_rmi4_f54_report_type_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%u\n", f54->report_type);
+}
+
+static ssize_t synaptics_rmi4_f54_report_type_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	int retval;
+	unsigned char data;
+	unsigned long setting;
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+
+	retval = kstrtoul(buf, 10, &setting);
+	if (retval)
+		return retval;
+
+	if (!is_report_type_valid((enum f54_report_types)setting)) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Report type not supported by driver\n",
+				__func__);
+		return -EINVAL;
+	}
+
+	mutex_lock(&f54->status_mutex);
+
+	if (f54->status != STATUS_BUSY) {
+		f54->report_type = (enum f54_report_types)setting;
+		data = (unsigned char)setting;
+		retval = f54->fn_ptr->write(rmi4_data,
+				f54->data_base_addr,
+				&data,
+				sizeof(data));
+		mutex_unlock(&f54->status_mutex);
+		if (retval < 0) {
+			dev_err(&rmi4_data->i2c_client->dev,
+					"%s: Failed to write data register\n",
+					__func__);
+			return retval;
+		}
+		return count;
+	} else {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Previous get report still ongoing\n",
+				__func__);
+		mutex_unlock(&f54->status_mutex);
+		return -EINVAL;
+	}
+}
+
+static ssize_t synaptics_rmi4_f54_fifoindex_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	int retval;
+	unsigned char data[2];
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+
+	retval = f54->fn_ptr->read(rmi4_data,
+			f54->data_base_addr + DATA_REPORT_INDEX_OFFSET,
+			data,
+			sizeof(data));
+	if (retval < 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to read data registers\n",
+				__func__);
+		return retval;
+	}
+
+	batohs(&f54->fifoindex, data);
+
+	return snprintf(buf, PAGE_SIZE, "%u\n", f54->fifoindex);
+}
+static ssize_t synaptics_rmi4_f54_fifoindex_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	int retval;
+	unsigned char data[2];
+	unsigned long setting;
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+
+	retval = kstrtoul(buf, 10, &setting);
+	if (retval)
+		return retval;
+
+	f54->fifoindex = setting;
+
+	hstoba(data, (unsigned short)setting);
+
+	retval = f54->fn_ptr->write(rmi4_data,
+			f54->data_base_addr + DATA_REPORT_INDEX_OFFSET,
+			data,
+			sizeof(data));
+	if (retval < 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to write data registers\n",
+				__func__);
+		return retval;
+	}
+
+	return count;
+}
+
+static ssize_t synaptics_rmi4_f54_do_preparation_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	int retval;
+	unsigned long setting;
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+
+	retval = kstrtoul(buf, 10, &setting);
+	if (retval)
+		return retval;
+
+	if (setting != 1)
+		return -EINVAL;
+
+	mutex_lock(&f54->status_mutex);
+
+	if (f54->status != STATUS_IDLE) {
+		if (f54->status != STATUS_BUSY) {
+			dev_err(&rmi4_data->i2c_client->dev,
+					"%s: Invalid status (%d)\n",
+					__func__, f54->status);
+		} else {
+			dev_err(&rmi4_data->i2c_client->dev,
+					"%s: Previous get report still ongoing\n",
+					__func__);
+		}
+		mutex_unlock(&f54->status_mutex);
+		return -EBUSY;
+	}
+
+	mutex_unlock(&f54->status_mutex);
+
+	retval = do_preparation();
+	if (retval < 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to do preparation\n",
+				__func__);
+		return retval;
+	}
+
+	return count;
+}
+
+static ssize_t synaptics_rmi4_f54_get_report_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	int retval;
+	unsigned char command;
+	unsigned long setting;
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+
+	retval = kstrtoul(buf, 10, &setting);
+	if (retval)
+		return retval;
+
+	if (setting != 1)
+		return -EINVAL;
+
+	command = (unsigned char)COMMAND_GET_REPORT;
+
+	if (!is_report_type_valid(f54->report_type)) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Invalid report type\n",
+				__func__);
+		return -EINVAL;
+	}
+
+	mutex_lock(&f54->status_mutex);
+
+	if (f54->status != STATUS_IDLE) {
+		if (f54->status != STATUS_BUSY) {
+			dev_err(&rmi4_data->i2c_client->dev,
+					"%s: Invalid status (%d)\n",
+					__func__, f54->status);
+		} else {
+			dev_err(&rmi4_data->i2c_client->dev,
+					"%s: Previous get report still ongoing\n",
+					__func__);
+		}
+		mutex_unlock(&f54->status_mutex);
+		return -EBUSY;
+	}
+
+	set_interrupt(true);
+
+	f54->status = STATUS_BUSY;
+
+	retval = f54->fn_ptr->write(rmi4_data,
+			f54->command_base_addr,
+			&command,
+			sizeof(command));
+	mutex_unlock(&f54->status_mutex);
+	if (retval < 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to write get report command\n",
+				__func__);
+		return retval;
+	}
+
+#ifdef WATCHDOG_HRTIMER
+	hrtimer_start(&f54->watchdog,
+			ktime_set(WATCHDOG_TIMEOUT_S, 0),
+			HRTIMER_MODE_REL);
+#endif
+
+	return count;
+}
+
+static ssize_t synaptics_rmi4_f54_force_cal_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	int retval;
+	unsigned char command;
+	unsigned long setting;
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+
+	retval = kstrtoul(buf, 10, &setting);
+	if (retval)
+		return retval;
+
+	if (setting != 1)
+		return count;
+
+	command = (unsigned char)COMMAND_FORCE_CAL;
+
+	if (f54->status == STATUS_BUSY)
+		return -EBUSY;
+
+	retval = f54->fn_ptr->write(rmi4_data,
+			f54->command_base_addr,
+			&command,
+			sizeof(command));
+	if (retval < 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to write force cal command\n",
+				__func__);
+		return retval;
+	}
+
+	return count;
+}
+
+simple_show_func_unsigned(query, num_of_rx_electrodes)
+simple_show_func_unsigned(query, num_of_tx_electrodes)
+simple_show_func_unsigned(query, has_image16)
+simple_show_func_unsigned(query, has_image8)
+simple_show_func_unsigned(query, has_baseline)
+simple_show_func_unsigned(query, clock_rate)
+simple_show_func_unsigned(query, touch_controller_family)
+simple_show_func_unsigned(query, has_pixel_touch_threshold_adjustment)
+simple_show_func_unsigned(query, has_sensor_assignment)
+simple_show_func_unsigned(query, has_interference_metric)
+simple_show_func_unsigned(query, has_sense_frequency_control)
+simple_show_func_unsigned(query, has_firmware_noise_mitigation)
+simple_show_func_unsigned(query, has_two_byte_report_rate)
+simple_show_func_unsigned(query, has_one_byte_report_rate)
+simple_show_func_unsigned(query, has_relaxation_control)
+simple_show_func_unsigned(query, curve_compensation_mode)
+simple_show_func_unsigned(query, has_iir_filter)
+simple_show_func_unsigned(query, has_cmn_removal)
+simple_show_func_unsigned(query, has_cmn_maximum)
+simple_show_func_unsigned(query, has_touch_hysteresis)
+simple_show_func_unsigned(query, has_edge_compensation)
+simple_show_func_unsigned(query, has_per_frequency_noise_control)
+simple_show_func_unsigned(query, has_signal_clarity)
+simple_show_func_unsigned(query, number_of_sensing_frequencies)
+
+show_store_func_unsigned(control, reg_0, no_relax)
+show_store_func_unsigned(control, reg_0, no_scan)
+show_store_func_unsigned(control, reg_1, bursts_per_cluster)
+show_store_func_unsigned(control, reg_2, saturation_cap)
+show_store_func_unsigned(control, reg_3, pixel_touch_threshold)
+show_store_func_unsigned(control, reg_4__6, rx_feedback_cap)
+show_store_func_unsigned(control, reg_4__6, low_ref_cap)
+show_store_func_unsigned(control, reg_4__6, low_ref_feedback_cap)
+show_store_func_unsigned(control, reg_4__6, low_ref_polarity)
+show_store_func_unsigned(control, reg_4__6, high_ref_cap)
+show_store_func_unsigned(control, reg_4__6, high_ref_feedback_cap)
+show_store_func_unsigned(control, reg_4__6, high_ref_polarity)
+show_store_func_unsigned(control, reg_7, cbc_cap)
+show_store_func_unsigned(control, reg_7, cbc_polarity)
+show_store_func_unsigned(control, reg_7, cbc_tx_carrier_selection)
+show_store_func_unsigned(control, reg_8__9, integration_duration)
+show_store_func_unsigned(control, reg_8__9, reset_duration)
+show_store_func_unsigned(control, reg_10, noise_sensing_bursts_per_image)
+show_store_func_unsigned(control, reg_12__13, slow_relaxation_rate)
+show_store_func_unsigned(control, reg_12__13, fast_relaxation_rate)
+show_store_func_unsigned(control, reg_14, rxs_on_xaxis)
+show_store_func_unsigned(control, reg_14, curve_comp_on_txs)
+show_store_func_unsigned(control, reg_20, disable_noise_mitigation)
+show_store_func_unsigned(control, reg_21, freq_shift_noise_threshold)
+show_store_func_unsigned(control, reg_22__26, medium_noise_threshold)
+show_store_func_unsigned(control, reg_22__26, high_noise_threshold)
+show_store_func_unsigned(control, reg_22__26, noise_density)
+show_store_func_unsigned(control, reg_22__26, frame_count)
+show_store_func_unsigned(control, reg_27, iir_filter_coef)
+show_store_func_unsigned(control, reg_28, quiet_threshold)
+show_store_func_unsigned(control, reg_29, cmn_filter_disable)
+show_store_func_unsigned(control, reg_30, cmn_filter_max)
+show_store_func_unsigned(control, reg_31, touch_hysteresis)
+show_store_func_unsigned(control, reg_32__35, rx_low_edge_comp)
+show_store_func_unsigned(control, reg_32__35, rx_high_edge_comp)
+show_store_func_unsigned(control, reg_32__35, tx_low_edge_comp)
+show_store_func_unsigned(control, reg_32__35, tx_high_edge_comp)
+show_store_func_unsigned(control, reg_41, no_signal_clarity)
+
+show_replicated_func_unsigned(control, reg_15, sensor_rx_assignment)
+show_replicated_func_unsigned(control, reg_16, sensor_tx_assignment)
+show_replicated_func_unsigned(control, reg_17, disable)
+show_replicated_func_unsigned(control, reg_17, filter_bandwidth)
+show_replicated_func_unsigned(control, reg_19, stretch_duration)
+show_replicated_func_unsigned(control, reg_38, noise_control_1)
+show_replicated_func_unsigned(control, reg_39, noise_control_2)
+show_replicated_func_unsigned(control, reg_40, noise_control_3)
+
+show_store_replicated_func_unsigned(control, reg_36, axis1_comp)
+show_store_replicated_func_unsigned(control, reg_37, axis2_comp)
+
+static ssize_t synaptics_rmi4_f54_burst_count_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	int retval;
+	int size = 0;
+	unsigned char ii;
+	unsigned char *temp;
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+
+	mutex_lock(&f54->control_mutex);
+
+	retval = f54->fn_ptr->read(rmi4_data,
+			f54->control.reg_17->address,
+			(unsigned char *)f54->control.reg_17->data,
+			f54->control.reg_17->length);
+	if (retval < 0) {
+		dev_dbg(&rmi4_data->i2c_client->dev,
+				"%s: Failed to read control reg_17\n",
+				__func__);
+	}
+
+	retval = f54->fn_ptr->read(rmi4_data,
+			f54->control.reg_18->address,
+			(unsigned char *)f54->control.reg_18->data,
+			f54->control.reg_18->length);
+	if (retval < 0) {
+		dev_dbg(&rmi4_data->i2c_client->dev,
+				"%s: Failed to read control reg_18\n",
+				__func__);
+	}
+
+	mutex_unlock(&f54->control_mutex);
+
+	temp = buf;
+
+	for (ii = 0; ii < f54->control.reg_17->length; ii++) {
+		retval = snprintf(temp, PAGE_SIZE - size, "%u ", (1 << 8) *
+			f54->control.reg_17->data[ii].burst_count_b8__10 +
+			f54->control.reg_18->data[ii].burst_count_b0__7);
+		if (retval < 0) {
+			dev_err(&rmi4_data->i2c_client->dev,
+					"%s: Faild to write output\n",
+					__func__);
+			return retval;
+		}
+		size += retval;
+		temp += retval;
+	}
+
+	retval = snprintf(temp, PAGE_SIZE - size, "\n");
+	if (retval < 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Faild to write null terminator\n",
+				__func__);
+		return retval;
+	}
+
+	return size + retval;
+}
+
+static ssize_t synaptics_rmi4_f54_data_read(struct file *data_file,
+		struct kobject *kobj, struct bin_attribute *attributes,
+		char *buf, loff_t pos, size_t count)
+{
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+
+	mutex_lock(&f54->data_mutex);
+
+	if (count < f54->report_size) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Report type %d data size (%d) too large\n",
+				__func__, f54->report_type, f54->report_size);
+		mutex_unlock(&f54->data_mutex);
+		return -EINVAL;
+	}
+
+	if (f54->report_data) {
+		memcpy(buf, f54->report_data, f54->report_size);
+		mutex_unlock(&f54->data_mutex);
+		return f54->report_size;
+	} else {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Report type %d data not available\n",
+				__func__, f54->report_type);
+		mutex_unlock(&f54->data_mutex);
+		return -EINVAL;
+	}
+}
+
+static int synaptics_rmi4_f54_set_sysfs(void)
+{
+	int retval;
+	int reg_num;
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+
+	f54->attr_dir = kobject_create_and_add("f54",
+			&rmi4_data->input_dev->dev.kobj);
+	if (!f54->attr_dir) {
+		dev_err(&rmi4_data->i2c_client->dev,
+			"%s: Failed to create sysfs directory\n",
+			__func__);
+		goto exit_1;
+	}
+
+	retval = sysfs_create_bin_file(f54->attr_dir, &dev_report_data);
+	if (retval < 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to create sysfs bin file\n",
+				__func__);
+		goto exit_2;
+	}
+
+	retval = sysfs_create_group(f54->attr_dir, &attr_group);
+	if (retval < 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to create sysfs attributes\n",
+				__func__);
+		goto exit_3;
+	}
+
+	for (reg_num = 0; reg_num < ARRAY_SIZE(attrs_ctrl_regs); reg_num++) {
+		if (attrs_ctrl_regs_exist[reg_num]) {
+			retval = sysfs_create_group(f54->attr_dir,
+					&attrs_ctrl_regs[reg_num]);
+			if (retval < 0) {
+				dev_err(&rmi4_data->i2c_client->dev,
+						"%s: Failed to create sysfs attributes\n",
+						__func__);
+				goto exit_4;
+			}
+		}
+	}
+
+	return 0;
+
+exit_4:
+	sysfs_remove_group(f54->attr_dir, &attr_group);
+
+	for (reg_num--; reg_num >= 0; reg_num--)
+		sysfs_remove_group(f54->attr_dir, &attrs_ctrl_regs[reg_num]);
+
+exit_3:
+	sysfs_remove_bin_file(f54->attr_dir, &dev_report_data);
+
+exit_2:
+	kobject_put(f54->attr_dir);
+
+exit_1:
+	return -ENODEV;
+}
+
+static int synaptics_rmi4_f54_set_ctrl(void)
+{
+	unsigned char length;
+	unsigned char reg_num = 0;
+	unsigned char num_of_sensing_freqs;
+	unsigned short reg_addr = f54->control_base_addr;
+	struct f54_control *control = &f54->control;
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+
+	num_of_sensing_freqs = f54->query.number_of_sensing_frequencies;
+
+	/* control 0 */
+	attrs_ctrl_regs_exist[reg_num] = true;
+	control->reg_0 = kzalloc(sizeof(*(control->reg_0)),
+			GFP_KERNEL);
+	if (!control->reg_0)
+		goto exit_no_mem;
+	control->reg_0->address = reg_addr;
+	reg_addr += sizeof(control->reg_0->data);
+	reg_num++;
+
+	/* control 1 */
+	if ((f54->query.touch_controller_family == 0) ||
+			(f54->query.touch_controller_family == 1)) {
+		attrs_ctrl_regs_exist[reg_num] = true;
+		control->reg_1 = kzalloc(sizeof(*(control->reg_1)),
+				GFP_KERNEL);
+		if (!control->reg_1)
+			goto exit_no_mem;
+		control->reg_1->address = reg_addr;
+		reg_addr += sizeof(control->reg_1->data);
+	}
+	reg_num++;
+
+	/* control 2 */
+	attrs_ctrl_regs_exist[reg_num] = true;
+	control->reg_2 = kzalloc(sizeof(*(control->reg_2)),
+			GFP_KERNEL);
+	if (!control->reg_2)
+		goto exit_no_mem;
+	control->reg_2->address = reg_addr;
+	reg_addr += sizeof(control->reg_2->data);
+	reg_num++;
+
+	/* control 3 */
+	if (f54->query.has_pixel_touch_threshold_adjustment == 1) {
+		attrs_ctrl_regs_exist[reg_num] = true;
+		control->reg_3 = kzalloc(sizeof(*(control->reg_3)),
+				GFP_KERNEL);
+		if (!control->reg_3)
+			goto exit_no_mem;
+		control->reg_3->address = reg_addr;
+		reg_addr += sizeof(control->reg_3->data);
+	}
+	reg_num++;
+
+	/* controls 4 5 6 */
+	if ((f54->query.touch_controller_family == 0) ||
+			(f54->query.touch_controller_family == 1)) {
+		attrs_ctrl_regs_exist[reg_num] = true;
+		control->reg_4__6 = kzalloc(sizeof(*(control->reg_4__6)),
+				GFP_KERNEL);
+		if (!control->reg_4__6)
+			goto exit_no_mem;
+		control->reg_4__6->address = reg_addr;
+		reg_addr += sizeof(control->reg_4__6->data);
+	}
+	reg_num++;
+
+	/* control 7 */
+	if (f54->query.touch_controller_family == 1) {
+		attrs_ctrl_regs_exist[reg_num] = true;
+		control->reg_7 = kzalloc(sizeof(*(control->reg_7)),
+				GFP_KERNEL);
+		if (!control->reg_7)
+			goto exit_no_mem;
+		control->reg_7->address = reg_addr;
+		reg_addr += sizeof(control->reg_7->data);
+	}
+	reg_num++;
+
+	/* controls 8 9 */
+	if ((f54->query.touch_controller_family == 0) ||
+			(f54->query.touch_controller_family == 1)) {
+		attrs_ctrl_regs_exist[reg_num] = true;
+		control->reg_8__9 = kzalloc(sizeof(*(control->reg_8__9)),
+				GFP_KERNEL);
+		if (!control->reg_8__9)
+			goto exit_no_mem;
+		control->reg_8__9->address = reg_addr;
+		reg_addr += sizeof(control->reg_8__9->data);
+	}
+	reg_num++;
+
+	/* control 10 */
+	if (f54->query.has_interference_metric == 1) {
+		attrs_ctrl_regs_exist[reg_num] = true;
+		control->reg_10 = kzalloc(sizeof(*(control->reg_10)),
+				GFP_KERNEL);
+		if (!control->reg_10)
+			goto exit_no_mem;
+		control->reg_10->address = reg_addr;
+		reg_addr += sizeof(control->reg_10->data);
+	}
+	reg_num++;
+
+	/* control 11 */
+	if (f54->query.has_ctrl11 == 1) {
+		attrs_ctrl_regs_exist[reg_num] = true;
+		control->reg_11 = kzalloc(sizeof(*(control->reg_11)),
+				GFP_KERNEL);
+		if (!control->reg_11)
+			goto exit_no_mem;
+		control->reg_11->address = reg_addr;
+		reg_addr += sizeof(control->reg_11->data);
+	}
+	reg_num++;
+
+	/* controls 12 13 */
+	if (f54->query.has_relaxation_control == 1) {
+		attrs_ctrl_regs_exist[reg_num] = true;
+		control->reg_12__13 = kzalloc(sizeof(*(control->reg_12__13)),
+				GFP_KERNEL);
+		if (!control->reg_12__13)
+			goto exit_no_mem;
+		control->reg_12__13->address = reg_addr;
+		reg_addr += sizeof(control->reg_12__13->data);
+	}
+	reg_num++;
+
+	/* controls 14 15 16 */
+	if (f54->query.has_sensor_assignment == 1) {
+		attrs_ctrl_regs_exist[reg_num] = true;
+
+		control->reg_14 = kzalloc(sizeof(*(control->reg_14)),
+				GFP_KERNEL);
+		if (!control->reg_14)
+			goto exit_no_mem;
+		control->reg_14->address = reg_addr;
+		reg_addr += sizeof(control->reg_14->data);
+
+		control->reg_15 = kzalloc(sizeof(*(control->reg_15)),
+				GFP_KERNEL);
+		if (!control->reg_15)
+			goto exit_no_mem;
+		control->reg_15->length = f54->query.num_of_rx_electrodes;
+		control->reg_15->data = kzalloc(control->reg_15->length *
+				sizeof(*(control->reg_15->data)), GFP_KERNEL);
+		if (!control->reg_15->data)
+			goto exit_no_mem;
+		control->reg_15->address = reg_addr;
+		reg_addr += control->reg_15->length;
+
+		control->reg_16 = kzalloc(sizeof(*(control->reg_16)),
+				GFP_KERNEL);
+		if (!control->reg_16)
+			goto exit_no_mem;
+		control->reg_16->length = f54->query.num_of_tx_electrodes;
+		control->reg_16->data = kzalloc(control->reg_16->length *
+				sizeof(*(control->reg_16->data)), GFP_KERNEL);
+		if (!control->reg_16->data)
+			goto exit_no_mem;
+		control->reg_16->address = reg_addr;
+		reg_addr += control->reg_16->length;
+	}
+	reg_num++;
+
+	/* controls 17 18 19 */
+	if (f54->query.has_sense_frequency_control == 1) {
+		attrs_ctrl_regs_exist[reg_num] = true;
+
+		length = num_of_sensing_freqs;
+
+		control->reg_17 = kzalloc(sizeof(*(control->reg_17)),
+				GFP_KERNEL);
+		if (!control->reg_17)
+			goto exit_no_mem;
+		control->reg_17->length = length;
+		control->reg_17->data = kzalloc(length *
+				sizeof(*(control->reg_17->data)), GFP_KERNEL);
+		if (!control->reg_17->data)
+			goto exit_no_mem;
+		control->reg_17->address = reg_addr;
+		reg_addr += length;
+
+		control->reg_18 = kzalloc(sizeof(*(control->reg_18)),
+				GFP_KERNEL);
+		if (!control->reg_18)
+			goto exit_no_mem;
+		control->reg_18->length = length;
+		control->reg_18->data = kzalloc(length *
+				sizeof(*(control->reg_18->data)), GFP_KERNEL);
+		if (!control->reg_18->data)
+			goto exit_no_mem;
+		control->reg_18->address = reg_addr;
+		reg_addr += length;
+
+		control->reg_19 = kzalloc(sizeof(*(control->reg_19)),
+				GFP_KERNEL);
+		if (!control->reg_19)
+			goto exit_no_mem;
+		control->reg_19->length = length;
+		control->reg_19->data = kzalloc(length *
+				sizeof(*(control->reg_19->data)), GFP_KERNEL);
+		if (!control->reg_19->data)
+			goto exit_no_mem;
+		control->reg_19->address = reg_addr;
+		reg_addr += length;
+	}
+	reg_num++;
+
+	/* control 20 */
+	attrs_ctrl_regs_exist[reg_num] = true;
+	control->reg_20 = kzalloc(sizeof(*(control->reg_20)),
+			GFP_KERNEL);
+	if (!control->reg_20)
+		goto exit_no_mem;
+	control->reg_20->address = reg_addr;
+	reg_addr += sizeof(control->reg_20->data);
+	reg_num++;
+
+	/* control 21 */
+	if (f54->query.has_sense_frequency_control == 1) {
+		attrs_ctrl_regs_exist[reg_num] = true;
+		control->reg_21 = kzalloc(sizeof(*(control->reg_21)),
+				GFP_KERNEL);
+		if (!control->reg_21)
+			goto exit_no_mem;
+		control->reg_21->address = reg_addr;
+		reg_addr += sizeof(control->reg_21->data);
+	}
+	reg_num++;
+
+	/* controls 22 23 24 25 26 */
+	if (f54->query.has_firmware_noise_mitigation == 1) {
+		attrs_ctrl_regs_exist[reg_num] = true;
+		control->reg_22__26 = kzalloc(sizeof(*(control->reg_22__26)),
+				GFP_KERNEL);
+		if (!control->reg_22__26)
+			goto exit_no_mem;
+		control->reg_22__26->address = reg_addr;
+		reg_addr += sizeof(control->reg_22__26->data);
+	}
+	reg_num++;
+
+	/* control 27 */
+	if (f54->query.has_iir_filter == 1) {
+		attrs_ctrl_regs_exist[reg_num] = true;
+		control->reg_27 = kzalloc(sizeof(*(control->reg_27)),
+				GFP_KERNEL);
+		if (!control->reg_27)
+			goto exit_no_mem;
+		control->reg_27->address = reg_addr;
+		reg_addr += sizeof(control->reg_27->data);
+	}
+	reg_num++;
+
+	/* control 28 */
+	if (f54->query.has_firmware_noise_mitigation == 1) {
+		attrs_ctrl_regs_exist[reg_num] = true;
+		control->reg_28 = kzalloc(sizeof(*(control->reg_28)),
+				GFP_KERNEL);
+		if (!control->reg_28)
+			goto exit_no_mem;
+		control->reg_28->address = reg_addr;
+		reg_addr += sizeof(control->reg_28->data);
+	}
+	reg_num++;
+
+	/* control 29 */
+	if (f54->query.has_cmn_removal == 1) {
+		attrs_ctrl_regs_exist[reg_num] = true;
+		control->reg_29 = kzalloc(sizeof(*(control->reg_29)),
+				GFP_KERNEL);
+		if (!control->reg_29)
+			goto exit_no_mem;
+		control->reg_29->address = reg_addr;
+		reg_addr += sizeof(control->reg_29->data);
+	}
+	reg_num++;
+
+	/* control 30 */
+	if (f54->query.has_cmn_maximum == 1) {
+		attrs_ctrl_regs_exist[reg_num] = true;
+		control->reg_30 = kzalloc(sizeof(*(control->reg_30)),
+				GFP_KERNEL);
+		if (!control->reg_30)
+			goto exit_no_mem;
+		control->reg_30->address = reg_addr;
+		reg_addr += sizeof(control->reg_30->data);
+	}
+	reg_num++;
+
+	/* control 31 */
+	if (f54->query.has_touch_hysteresis == 1) {
+		attrs_ctrl_regs_exist[reg_num] = true;
+		control->reg_31 = kzalloc(sizeof(*(control->reg_31)),
+				GFP_KERNEL);
+		if (!control->reg_31)
+			goto exit_no_mem;
+		control->reg_31->address = reg_addr;
+		reg_addr += sizeof(control->reg_31->data);
+	}
+	reg_num++;
+
+	/* controls 32 33 34 35 */
+	if (f54->query.has_edge_compensation == 1) {
+		attrs_ctrl_regs_exist[reg_num] = true;
+		control->reg_32__35 = kzalloc(sizeof(*(control->reg_32__35)),
+				GFP_KERNEL);
+		if (!control->reg_32__35)
+			goto exit_no_mem;
+		control->reg_32__35->address = reg_addr;
+		reg_addr += sizeof(control->reg_32__35->data);
+	}
+	reg_num++;
+
+	/* control 36 */
+	if ((f54->query.curve_compensation_mode == 1) ||
+			(f54->query.curve_compensation_mode == 2)) {
+		attrs_ctrl_regs_exist[reg_num] = true;
+
+		if (f54->query.curve_compensation_mode == 1) {
+			length = max(f54->query.num_of_rx_electrodes,
+					f54->query.num_of_tx_electrodes);
+		} else if (f54->query.curve_compensation_mode == 2) {
+			length = f54->query.num_of_rx_electrodes;
+		}
+
+		control->reg_36 = kzalloc(sizeof(*(control->reg_36)),
+				GFP_KERNEL);
+		if (!control->reg_36)
+			goto exit_no_mem;
+		control->reg_36->length = length;
+		control->reg_36->data = kzalloc(length *
+				sizeof(*(control->reg_36->data)), GFP_KERNEL);
+		if (!control->reg_36->data)
+			goto exit_no_mem;
+		control->reg_36->address = reg_addr;
+		reg_addr += length;
+	}
+	reg_num++;
+
+	/* control 37 */
+	if (f54->query.curve_compensation_mode == 2) {
+		attrs_ctrl_regs_exist[reg_num] = true;
+
+		control->reg_37 = kzalloc(sizeof(*(control->reg_37)),
+				GFP_KERNEL);
+		if (!control->reg_37)
+			goto exit_no_mem;
+		control->reg_37->length = f54->query.num_of_tx_electrodes;
+		control->reg_37->data = kzalloc(control->reg_37->length *
+				sizeof(*(control->reg_37->data)), GFP_KERNEL);
+		if (!control->reg_37->data)
+			goto exit_no_mem;
+
+		control->reg_37->address = reg_addr;
+		reg_addr += control->reg_37->length;
+	}
+	reg_num++;
+
+	/* controls 38 39 40 */
+	if (f54->query.has_per_frequency_noise_control == 1) {
+		attrs_ctrl_regs_exist[reg_num] = true;
+
+		control->reg_38 = kzalloc(sizeof(*(control->reg_38)),
+				GFP_KERNEL);
+		if (!control->reg_38)
+			goto exit_no_mem;
+		control->reg_38->length = num_of_sensing_freqs;
+		control->reg_38->data = kzalloc(control->reg_38->length *
+				sizeof(*(control->reg_38->data)), GFP_KERNEL);
+		if (!control->reg_38->data)
+			goto exit_no_mem;
+		control->reg_38->address = reg_addr;
+		reg_addr += control->reg_38->length;
+
+		control->reg_39 = kzalloc(sizeof(*(control->reg_39)),
+				GFP_KERNEL);
+		if (!control->reg_39)
+			goto exit_no_mem;
+		control->reg_39->length = num_of_sensing_freqs;
+		control->reg_39->data = kzalloc(control->reg_39->length *
+				sizeof(*(control->reg_39->data)), GFP_KERNEL);
+		if (!control->reg_39->data)
+			goto exit_no_mem;
+		control->reg_39->address = reg_addr;
+		reg_addr += control->reg_39->length;
+
+		control->reg_40 = kzalloc(sizeof(*(control->reg_40)),
+				GFP_KERNEL);
+		if (!control->reg_40)
+			goto exit_no_mem;
+		control->reg_40->length = num_of_sensing_freqs;
+		control->reg_40->data = kzalloc(control->reg_40->length *
+				sizeof(*(control->reg_40->data)), GFP_KERNEL);
+		if (!control->reg_40->data)
+			goto exit_no_mem;
+		control->reg_40->address = reg_addr;
+		reg_addr += control->reg_40->length;
+	}
+	reg_num++;
+
+	/* control 41 */
+	if (f54->query.has_signal_clarity == 1) {
+		attrs_ctrl_regs_exist[reg_num] = true;
+		control->reg_41 = kzalloc(sizeof(*(control->reg_41)),
+				GFP_KERNEL);
+		if (!control->reg_41)
+			goto exit_no_mem;
+		control->reg_41->address = reg_addr;
+		reg_addr += sizeof(control->reg_41->data);
+	}
+	reg_num++;
+
+	return 0;
+
+exit_no_mem:
+	dev_err(&rmi4_data->i2c_client->dev,
+			"%s: Failed to alloc mem for control registers\n",
+			__func__);
+	return -ENOMEM;
+}
+
+#ifdef FACTORY_MODE
+static int synaptics_rmi4_f54_get_report_type(int type)
+{
+	int retval;
+	char buf[3];
+	unsigned char patience = 5;
+
+	memset(buf, 0x00, sizeof(buf));
+	snprintf(buf, 3, "%u\n", type);
+	retval = synaptics_rmi4_f54_report_type_store(NULL, NULL, buf, 2);
+	if (retval != 2)
+		return 0;
+
+	memset(buf, 0x00, sizeof(buf));
+	snprintf(buf, 3, "%u\n", CMD_GET_REPORT);
+	retval = synaptics_rmi4_f54_get_report_store(NULL, NULL, buf, 2);
+	if (retval != 2)
+		return 0;
+
+	do {
+		msleep(1000);
+		if (f54->status == STATUS_IDLE)
+			break;
+	} while (--patience > 0);
+
+	if ((f54->report_size == 0) || (f54->status != STATUS_IDLE))
+		return 0;
+	else
+		return 1;
+}
+#endif
+
+static void synaptics_rmi4_f54_status_work(struct work_struct *work)
+{
+	int retval;
+	unsigned char report_index[2];
+	struct synaptics_rmi4_data *rmi4_data = f54->rmi4_data;
+
+	if (f54->status != STATUS_BUSY)
+		return;
+
+	set_report_size();
+	if (f54->report_size == 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Report data size = 0\n",
+				__func__);
+		retval = -EINVAL;
+		goto error_exit;
+	}
+
+	if (f54->data_buffer_size < f54->report_size) {
+		mutex_lock(&f54->data_mutex);
+		if (f54->data_buffer_size)
+			kfree(f54->report_data);
+		f54->report_data = kzalloc(f54->report_size, GFP_KERNEL);
+		if (!f54->report_data) {
+			dev_err(&rmi4_data->i2c_client->dev,
+					"%s: Failed to alloc mem for data buffer\n",
+					__func__);
+			f54->data_buffer_size = 0;
+			mutex_unlock(&f54->data_mutex);
+			retval = -ENOMEM;
+			goto error_exit;
+		}
+		f54->data_buffer_size = f54->report_size;
+		mutex_unlock(&f54->data_mutex);
+	}
+
+	report_index[0] = 0;
+	report_index[1] = 0;
+
+	retval = f54->fn_ptr->write(rmi4_data,
+			f54->data_base_addr + DATA_REPORT_INDEX_OFFSET,
+			report_index,
+			sizeof(report_index));
+	if (retval < 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to write report data index\n",
+				__func__);
+		retval = -EINVAL;
+		goto error_exit;
+	}
+
+	retval = f54->fn_ptr->read(rmi4_data,
+			f54->data_base_addr + DATA_REPORT_DATA_OFFSET,
+			f54->report_data,
+			f54->report_size);
+	if (retval < 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to read report data\n",
+				__func__);
+		retval = -EINVAL;
+		goto error_exit;
+	}
+
+	retval = STATUS_IDLE;
+
+#ifdef RAW_HEX
+	print_raw_hex_report();
+#endif
+
+#ifdef HUMAN_READABLE
+	print_image_report();
+#endif
+
+error_exit:
+	mutex_lock(&f54->status_mutex);
+	set_interrupt(false);
+	f54->status = retval;
+	mutex_unlock(&f54->status_mutex);
+
+	return;
+}
+
+static void synaptics_rmi4_f54_attn(struct synaptics_rmi4_data *rmi4_data,
+		unsigned char intr_mask)
+{
+	if (f54->intr_mask & intr_mask) {
+		queue_delayed_work(f54->status_workqueue,
+				&f54->status_work,
+				msecs_to_jiffies(STATUS_WORK_INTERVAL));
+	}
+
+	return;
+}
+
+int synaptics_rmi4_f54_set_control(struct synaptics_rmi4_data *rmi4_data)
+{
+	int retval;
+	unsigned short ii;
+	unsigned char page;
+	unsigned char intr_count = 0;
+	unsigned char intr_offset;
+	struct synaptics_rmi4_fn_desc rmi_fd;
+
+	f54->rmi4_data = rmi4_data;
+	f54->fn_ptr->read = rmi4_data->i2c_read;
+	f54->fn_ptr->write = rmi4_data->i2c_write;
+	f54->fn_ptr->enable = rmi4_data->irq_enable;
+
+	for (page = 0; page < PAGES_TO_SERVICE; page++) {
+		for (ii = PDT_START; ii > PDT_END; ii -= PDT_ENTRY_SIZE) {
+			ii |= (page << 8);
+
+			retval = f54->fn_ptr->read(rmi4_data,
+					ii,
+					(unsigned char *)&rmi_fd,
+					sizeof(rmi_fd));
+			if (retval < 0)
+				goto err_out;
+
+			if (!rmi_fd.fn_number)
+				break;
+
+			if (rmi_fd.fn_number == SYNAPTICS_RMI4_F54)
+				goto f54_found;
+
+			intr_count += (rmi_fd.intr_src_count & MASK_3BIT);
+		}
+	}
+
+f54_found:
+	f54->query_base_addr = rmi_fd.query_base_addr | (page << 8);
+	f54->control_base_addr = rmi_fd.ctrl_base_addr | (page << 8);
+	f54->data_base_addr = rmi_fd.data_base_addr | (page << 8);
+	f54->command_base_addr = rmi_fd.cmd_base_addr | (page << 8);
+
+	dev_info(&rmi4_data->i2c_client->dev,
+		"%s: query_base_addr: %x, control_base_addr: %x, data_base_addr: %x, command_base_addr: %x\n",
+		__func__, f54->query_base_addr, f54->control_base_addr,
+		f54->data_base_addr, f54->command_base_addr);
+
+	f54->intr_reg_num = (intr_count + 7) / 8;
+	if (f54->intr_reg_num != 0)
+		f54->intr_reg_num -= 1;
+
+	f54->intr_mask = 0;
+	intr_offset = intr_count % 8;
+	for (ii = intr_offset;
+			ii < ((rmi_fd.intr_src_count & MASK_3BIT) +
+			intr_offset);
+			ii++) {
+		f54->intr_mask |= 1 << ii;
+	}
+
+	retval = f54->fn_ptr->read(rmi4_data,
+			f54->query_base_addr,
+			f54->query.data,
+			sizeof(f54->query.data));
+	if (retval < 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to read query registers\n",
+				__func__);
+		goto err_out;
+	}
+
+	retval = synaptics_rmi4_f54_set_ctrl();
+	if (retval < 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to set up control registers\n",
+				__func__);
+		goto err_out;
+	}
+
+	return 0;
+
+err_out:
+	return retval;
+}
+
+static int synaptics_rmi4_f54_init(struct synaptics_rmi4_data *rmi4_data)
+{
+	int retval;
+	unsigned short ii;
+#ifdef FACTORY_MODE
+	unsigned char rx = rmi4_data->num_of_rx;
+	unsigned char tx = rmi4_data->num_of_tx;
+	struct factory_data *factory_data;
+#endif
+
+	f54 = kzalloc(sizeof(*f54), GFP_KERNEL);
+	if (!f54) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to alloc mem for f54\n",
+				__func__);
+		retval = -ENOMEM;
+		goto exit;
+	}
+
+	f54->fn_ptr = kzalloc(sizeof(*(f54->fn_ptr)), GFP_KERNEL);
+	if (!f54->fn_ptr) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to alloc mem for fn_ptr\n",
+				__func__);
+		retval = -ENOMEM;
+		goto exit_free_f54;
+	}
+
+	retval = synaptics_rmi4_f54_set_control(rmi4_data);
+	if (retval < 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to control f54.\n",
+				__func__);
+		goto exit_free_control;
+	}
+
+	mutex_init(&f54->status_mutex);
+	mutex_init(&f54->data_mutex);
+	mutex_init(&f54->control_mutex);
+
+	retval = synaptics_rmi4_f54_set_sysfs();
+	if (retval < 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to create sysfs entries\n",
+				__func__);
+		goto exit_sysfs;
+	}
+
+#ifdef FACTORY_MODE
+	factory_data = kzalloc(sizeof(*factory_data), GFP_KERNEL);
+	if (!factory_data) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to alloc mem for factory_data\n",
+				__func__);
+		retval = -ENOMEM;
+		goto exit_factory_data;
+	}
+
+	factory_data->rawcap_data = kzalloc(2 * rx * tx, GFP_KERNEL);
+	if (!factory_data->rawcap_data) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to alloc mem for rawcap_data\n",
+				__func__);
+		retval = -ENOMEM;
+		goto exit_rawcap_data;
+	}
+
+	factory_data->delta_data = kzalloc(2 * rx * tx, GFP_KERNEL);
+	if (!factory_data->delta_data) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to alloc mem for delta_data\n",
+				__func__);
+		retval = -ENOMEM;
+		goto exit_delta_data;
+	}
+
+	factory_data->abscap_data = kzalloc(4 * rx * tx, GFP_KERNEL);
+	if (!factory_data->abscap_data) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to alloc mem for abscap_data\n",
+				__func__);
+		retval = -ENOMEM;
+		goto exit_abscap_data;
+	}
+
+	factory_data->absdelta_data = kzalloc(4 * rx * tx, GFP_KERNEL);
+	if (!factory_data->abscap_data) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to alloc mem for abscap_data\n",
+				__func__);
+		retval = -ENOMEM;
+		goto exit_absdelta_data;
+	}
+
+	factory_data->trx_short = kzalloc(TREX_DATA_SIZE, GFP_KERNEL);
+	if (!factory_data->trx_short) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to alloc mem for trx_short\n",
+				__func__);
+		retval = -ENOMEM;
+		goto exit_trx_short;
+	}
+
+	INIT_LIST_HEAD(&factory_data->cmd_list_head);
+	for (ii = 0; ii < ARRAY_SIZE(ft_cmds); ii++)
+		list_add_tail(&ft_cmds[ii].list, &factory_data->cmd_list_head);
+
+	mutex_init(&factory_data->cmd_lock);
+	factory_data->cmd_is_running = false;
+
+	factory_data->fac_dev_ts = device_create(sec_class,
+			NULL, 0, f54, "tsp");
+
+	retval = IS_ERR(factory_data->fac_dev_ts);
+	if (retval) {
+		dev_err(&rmi4_data->i2c_client->dev, "%s: Failed to create device for the sysfs\n",
+				__func__);
+		retval = IS_ERR(factory_data->fac_dev_ts);
+		goto exit_cmd_attr_group;
+	}
+
+	retval = sysfs_create_group(&factory_data->fac_dev_ts->kobj,
+	    &cmd_attr_group);
+	if (retval < 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to create sysfs attributes\n",
+				__func__);
+		goto exit_cmd_attr_group;
+	}
+
+	f54->factory_data = factory_data;
+#endif
+
+	f54->status_workqueue =
+			create_singlethread_workqueue("f54_status_workqueue");
+	INIT_DELAYED_WORK(&f54->status_work,
+			synaptics_rmi4_f54_status_work);
+
+#ifdef WATCHDOG_HRTIMER
+	/* Watchdog timer to catch unanswered get report commands */
+	hrtimer_init(&f54->watchdog, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	f54->watchdog.function = get_report_timeout;
+
+	/* Work function to do actual cleaning up */
+	INIT_WORK(&f54->timeout_work, timeout_set_status);
+#endif
+
+	return 0;
+
+#ifdef FACTORY_MODE
+exit_cmd_attr_group:
+	kfree(factory_data->trx_short);
+	kfree(factory_data->abscap_data);
+	kfree(factory_data->absdelta_data);
+	kfree(factory_data->rawcap_data);
+	kfree(factory_data->delta_data);
+exit_trx_short:
+exit_absdelta_data:
+exit_abscap_data:
+exit_delta_data:
+exit_rawcap_data:
+	kfree(factory_data);
+
+exit_factory_data:
+	remove_sysfs();
+#endif
+
+exit_sysfs:
+exit_free_control:
+	free_control_mem();
+	kfree(f54->fn_ptr);
+
+exit_free_f54:
+	kfree(f54);
+
+exit:
+	return retval;
+}
+
+static void synaptics_rmi4_f54_remove(struct synaptics_rmi4_data *rmi4_data)
+{
+#ifdef WATCHDOG_HRTIMER
+	hrtimer_cancel(&f54->watchdog);
+#endif
+
+	cancel_delayed_work_sync(&f54->status_work);
+	flush_workqueue(f54->status_workqueue);
+	destroy_workqueue(f54->status_workqueue);
+
+#ifdef FACTORY_MODE
+	sysfs_remove_group(f54->attr_dir, &cmd_attr_group);
+	kfree(f54->factory_data->abscap_data);
+	kfree(f54->factory_data->absdelta_data);
+	kfree(f54->factory_data->rawcap_data);
+	kfree(f54->factory_data->delta_data);
+	kfree(f54->factory_data);
+#endif
+
+	remove_sysfs();
+
+	free_control_mem();
+
+	if (f54->data_buffer_size)
+		kfree(f54->report_data);
+
+	kfree(f54->fn_ptr);
+	kfree(f54);
+
+	return;
+}
+
+int rmi4_f54_module_register(void)
+{
+	int retval;
+
+	retval = synaptics_rmi4_new_function(RMI_F54,
+			synaptics_rmi4_f54_init,
+			synaptics_rmi4_f54_remove,
+			synaptics_rmi4_f54_attn);
+
+	return retval;
+}
diff --git a/drivers/input/touchscreen/rmi_fw_update.c b/drivers/input/touchscreen/rmi_fw_update.c
new file mode 100644
index 0000000..3543b45
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_fw_update.c
@@ -0,0 +1,1732 @@
+/* Synaptics Register Mapped Interface (RMI4) I2C Physical Layer Driver.
+ * Copyright (c) 2007-2012, Synaptics Incorporated
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <asm/unaligned.h>
+#include <mach/cpufreq.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/input.h>
+#include <linux/firmware.h>
+#include "synaptics_i2c_rmi.h"
+#include <linux/regulator/consumer.h>
+
+#define F01_DEVICE_STATUS	0X0004
+
+#define CHECKSUM_OFFSET 0x00
+#define BOOTLOADER_VERSION_OFFSET 0x07
+#define IMAGE_SIZE_OFFSET 0x08
+#define CONFIG_SIZE_OFFSET 0x0C
+#define PRODUCT_ID_OFFSET 0x10
+#define PRODUCT_INFO_OFFSET 0x1E
+#define FW_IMAGE_OFFSET 0x100
+#define PRODUCT_ID_SIZE 10
+
+#define BOOTLOADER_ID_OFFSET 0
+#define FLASH_PROPERTIES_OFFSET 1
+#define BLOCK_SIZE_OFFSET 2
+#define BLOCK_COUNT_OFFSET 3
+
+#define REG_MAP (1 << 0)
+#define UNLOCKED (1 << 1)
+#define HAS_CONFIG_ID (1 << 2)
+#define HAS_PERM_CONFIG (1 << 3)
+#define HAS_BL_CONFIG (1 << 4)
+#define HAS_DISP_CONFIG (1 << 5)
+#define HAS_CTRL1 (1 << 6)
+
+#define BLOCK_NUMBER_OFFSET 0
+#define BLOCK_DATA_OFFSET 1
+#define FLASH_COMMAND_OFFSET 2
+#define FLASH_STATUS_OFFSET 3
+
+#define UI_CONFIG_AREA 0x00
+#define PERM_CONFIG_AREA 0x01
+#define BL_CONFIG_AREA 0x02
+#define DISP_CONFIG_AREA 0x03
+
+#define CMD_WRITE_FW_BLOCK 0x2
+#define CMD_ERASE_ALL 0x3
+#define CMD_READ_CONFIG_BLOCK 0x5
+#define CMD_WRITE_CONFIG_BLOCK 0x6
+#define CMD_ERASE_CONFIG 0x7
+#define CMD_ERASE_BL_CONFIG 0x9
+#define CMD_ERASE_DISP_CONFIG 0xa
+#define CMD_ENABLE_FLASH_PROG 0xf
+
+#define SLEEP_MODE_NORMAL (0x00)
+#define SLEEP_MODE_SENSOR_SLEEP (0x01)
+#define SLEEP_MODE_RESERVED0 (0x02)
+#define SLEEP_MODE_RESERVED1 (0x03)
+
+#define ENABLE_WAIT_MS (1 * 1000)
+#define WRITE_WAIT_MS (3 * 1000)
+#define ERASE_WAIT_MS (5 * 1000)
+
+#define MIN_SLEEP_TIME_US 50
+#define MAX_SLEEP_TIME_US 100
+
+#if defined(CONFIG_MACH_JACTIVE_EUR) || defined(CONFIG_MACH_JACTIVE_ATT)
+#define FW_SUPPORT_HSYNC03(x)	 (strncmp(x->product_id, "SY 03", 5) == 0)
+#define FW_SUPPORT_HSYNC04(x)	 (strncmp(x->product_id, "SY 04", 5) == 0)
+#define FW_NOT_SUPPORT_HSYNC(x)	 ((strncmp(x->product_id, "SY 01", 5) == 0) || (strncmp(x->product_id, "S5000B", 6) == 0) || (strncmp(x->product_id, "SY 02", 5) == 0))
+#endif
+
+static ssize_t fwu_sysfs_show_image(struct file *data_file,
+		struct kobject *kobj, struct bin_attribute *attributes,
+		char *buf, loff_t pos, size_t count);
+
+static ssize_t fwu_sysfs_store_image(struct file *data_file,
+		struct kobject *kobj, struct bin_attribute *attributes,
+		char *buf, loff_t pos, size_t count);
+
+static ssize_t fwu_sysfs_do_reflash_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count);
+
+static ssize_t fwu_sysfs_write_config_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count);
+
+static ssize_t fwu_sysfs_read_config_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count);
+
+static ssize_t fwu_sysfs_config_area_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count);
+
+static ssize_t fwu_sysfs_image_size_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count);
+
+static ssize_t fwu_sysfs_block_size_show(struct device *dev,
+		struct device_attribute *attr, char *buf);
+
+static ssize_t fwu_sysfs_firmware_block_count_show(struct device *dev,
+		struct device_attribute *attr, char *buf);
+
+static ssize_t fwu_sysfs_configuration_block_count_show(struct device *dev,
+		struct device_attribute *attr, char *buf);
+
+static ssize_t fwu_sysfs_perm_config_block_count_show(struct device *dev,
+		struct device_attribute *attr, char *buf);
+
+static ssize_t fwu_sysfs_bl_config_block_count_show(struct device *dev,
+		struct device_attribute *attr, char *buf);
+
+static ssize_t fwu_sysfs_disp_config_block_count_show(struct device *dev,
+		struct device_attribute *attr, char *buf);
+
+struct image_header {
+	unsigned int checksum;
+	unsigned int image_size;
+	unsigned int config_size;
+	unsigned char options;
+	unsigned char bootloader_version;
+	unsigned char product_id[SYNAPTICS_RMI4_PRODUCT_ID_SIZE + 1];
+	unsigned char product_info[SYNAPTICS_RMI4_PRODUCT_INFO_SIZE];
+};
+
+struct pdt_properties {
+	union {
+		struct {
+			unsigned char reserved_1:6;
+			unsigned char has_bsr:1;
+			unsigned char reserved_2:1;
+		} __packed;
+		unsigned char data[1];
+	};
+};
+
+struct f01_device_status {
+	union {
+		struct {
+			unsigned char status_code:4;
+			unsigned char reserved:2;
+			unsigned char flash_prog:1;
+			unsigned char unconfigured:1;
+		} __packed;
+		unsigned char data[1];
+	};
+};
+
+struct f01_device_control {
+	union {
+		struct {
+			unsigned char sleep_mode:2;
+			unsigned char nosleep:1;
+			unsigned char reserved:2;
+			unsigned char charger_connected:1;
+			unsigned char report_rate:1;
+			unsigned char configured:1;
+		} __packed;
+		unsigned char data[1];
+	};
+};
+
+struct f34_flash_status {
+	union {
+		struct {
+			unsigned char status:6;
+			unsigned char reserved:1;
+			unsigned char program_enabled:1;
+		} __packed;
+		unsigned char data[1];
+	};
+};
+
+struct synaptics_rmi4_fwu_handle {
+	bool initialized;
+	bool has_perm_config;
+	bool has_bl_config;
+	bool has_disp_config;
+	unsigned int image_size;
+	unsigned int data_pos;
+	unsigned char *ext_data_source;
+	unsigned char *read_config_buf;
+	unsigned char intr_mask;
+	unsigned char command;
+	unsigned char bootloader_id[2];
+	unsigned char flash_properties;
+	unsigned char productinfo1;
+	unsigned char productinfo2;
+	unsigned short block_size;
+	unsigned short fw_block_count;
+	unsigned short config_block_count;
+	unsigned short perm_config_block_count;
+	unsigned short bl_config_block_count;
+	unsigned short disp_config_block_count;
+	unsigned short config_size;
+	unsigned short config_area;
+	char product_id[SYNAPTICS_RMI4_PRODUCT_ID_SIZE + 1];
+	const unsigned char *firmware_data;
+	const unsigned char *config_data;
+	struct f34_flash_status flash_status;
+	struct synaptics_rmi4_fn_desc f01_fd;
+	struct synaptics_rmi4_fn_desc f34_fd;
+	struct synaptics_rmi4_exp_fn_ptr *fn_ptr;
+	struct synaptics_rmi4_data *rmi4_data;
+};
+
+static struct bin_attribute dev_attr_data = {
+	.attr = {
+		.name = "data",
+		.mode = (S_IRUGO | S_IWUSR | S_IWGRP),
+	},
+	.size = 0,
+	.read = fwu_sysfs_show_image,
+	.write = fwu_sysfs_store_image,
+};
+
+static struct device_attribute attrs[] = {
+	__ATTR(doreflash, S_IWUSR | S_IWGRP,
+			synaptics_rmi4_show_error,
+			fwu_sysfs_do_reflash_store),
+	__ATTR(writeconfig, S_IWUSR | S_IWGRP,
+			synaptics_rmi4_show_error,
+			fwu_sysfs_write_config_store),
+	__ATTR(readconfig, S_IWUSR | S_IWGRP,
+			synaptics_rmi4_show_error,
+			fwu_sysfs_read_config_store),
+	__ATTR(configarea, S_IWUSR | S_IWGRP,
+			synaptics_rmi4_show_error,
+			fwu_sysfs_config_area_store),
+	__ATTR(imagesize, S_IWUSR | S_IWGRP,
+			synaptics_rmi4_show_error,
+			fwu_sysfs_image_size_store),
+	__ATTR(blocksize, S_IRUGO,
+			fwu_sysfs_block_size_show,
+			synaptics_rmi4_store_error),
+	__ATTR(fwblockcount, S_IRUGO,
+			fwu_sysfs_firmware_block_count_show,
+			synaptics_rmi4_store_error),
+	__ATTR(configblockcount, S_IRUGO,
+			fwu_sysfs_configuration_block_count_show,
+			synaptics_rmi4_store_error),
+	__ATTR(permconfigblockcount, S_IRUGO,
+			fwu_sysfs_perm_config_block_count_show,
+			synaptics_rmi4_store_error),
+	__ATTR(blconfigblockcount, S_IRUGO,
+			fwu_sysfs_bl_config_block_count_show,
+			synaptics_rmi4_store_error),
+	__ATTR(dispconfigblockcount, S_IRUGO,
+			fwu_sysfs_disp_config_block_count_show,
+			synaptics_rmi4_store_error),
+};
+
+static struct synaptics_rmi4_fwu_handle *fwu;
+
+static unsigned int extract_uint(const unsigned char *ptr)
+{
+	return (unsigned int)ptr[0] +
+			(unsigned int)ptr[1] * 0x100 +
+			(unsigned int)ptr[2] * 0x10000 +
+			(unsigned int)ptr[3] * 0x1000000;
+}
+
+static void parse_header(struct image_header *header,
+		const unsigned char *fw_image)
+{
+	header->checksum = extract_uint(&fw_image[CHECKSUM_OFFSET]);
+	header->bootloader_version = fw_image[BOOTLOADER_VERSION_OFFSET];
+	header->image_size = extract_uint(&fw_image[IMAGE_SIZE_OFFSET]);
+	header->config_size = extract_uint(&fw_image[CONFIG_SIZE_OFFSET]);
+	memcpy(header->product_id, &fw_image[PRODUCT_ID_OFFSET],
+			SYNAPTICS_RMI4_PRODUCT_ID_SIZE);
+	header->product_id[SYNAPTICS_RMI4_PRODUCT_ID_SIZE] = 0;
+	memcpy(header->product_info, &fw_image[PRODUCT_INFO_OFFSET],
+			SYNAPTICS_RMI4_PRODUCT_INFO_SIZE);
+
+	return;
+}
+
+static int fwu_read_f01_device_status(struct f01_device_status *status)
+{
+	int retval;
+
+	retval = fwu->fn_ptr->read(fwu->rmi4_data,
+			fwu->f01_fd.data_base_addr,
+			status->data,
+			sizeof(status->data));
+	if (retval < 0) {
+		dev_err(&fwu->rmi4_data->i2c_client->dev,
+				"%s: Failed to read F01 device status\n",
+				__func__);
+		return retval;
+	}
+
+	return 0;
+}
+
+static int fwu_read_f34_queries(void)
+{
+	int retval;
+	unsigned char count;
+	unsigned char buf[10];
+
+	retval = fwu->fn_ptr->read(fwu->rmi4_data,
+			fwu->f34_fd.query_base_addr + BOOTLOADER_ID_OFFSET,
+			fwu->bootloader_id,
+			sizeof(fwu->bootloader_id));
+	if (retval < 0) {
+		dev_err(&fwu->rmi4_data->i2c_client->dev,
+				"%s: Failed to read bootloader ID\n",
+				__func__);
+		return retval;
+	}
+
+	retval = fwu->fn_ptr->read(fwu->rmi4_data,
+			fwu->f34_fd.query_base_addr + FLASH_PROPERTIES_OFFSET,
+			&fwu->flash_properties,
+			sizeof(fwu->flash_properties));
+	if (retval < 0) {
+		dev_err(&fwu->rmi4_data->i2c_client->dev,
+				"%s: Failed to read flash properties\n",
+				__func__);
+		return retval;
+	}
+
+	count = 4;
+
+	if (fwu->flash_properties & HAS_PERM_CONFIG) {
+		fwu->has_perm_config = 1;
+		count += 2;
+	}
+
+	if (fwu->flash_properties & HAS_BL_CONFIG) {
+		fwu->has_bl_config = 1;
+		count += 2;
+	}
+
+	if (fwu->flash_properties & HAS_DISP_CONFIG) {
+		fwu->has_disp_config = 1;
+		count += 2;
+	}
+
+	retval = fwu->fn_ptr->read(fwu->rmi4_data,
+			fwu->f34_fd.query_base_addr + BLOCK_SIZE_OFFSET,
+			buf,
+			2);
+	if (retval < 0) {
+		dev_err(&fwu->rmi4_data->i2c_client->dev,
+				"%s: Failed to read block size info\n",
+				__func__);
+		return retval;
+	}
+
+	batohs(&fwu->block_size, &(buf[0]));
+
+	retval = fwu->fn_ptr->read(fwu->rmi4_data,
+			fwu->f34_fd.query_base_addr + BLOCK_COUNT_OFFSET,
+			buf,
+			count);
+	if (retval < 0) {
+		dev_err(&fwu->rmi4_data->i2c_client->dev,
+				"%s: Failed to read block count info\n",
+				__func__);
+		return retval;
+	}
+
+	batohs(&fwu->fw_block_count, &(buf[0]));
+	batohs(&fwu->config_block_count, &(buf[2]));
+
+	count = 4;
+
+	if (fwu->has_perm_config) {
+		batohs(&fwu->perm_config_block_count, &(buf[count]));
+		count += 2;
+	}
+
+	if (fwu->has_bl_config) {
+		batohs(&fwu->bl_config_block_count, &(buf[count]));
+		count += 2;
+	}
+
+	if (fwu->has_disp_config)
+		batohs(&fwu->disp_config_block_count, &(buf[count]));
+
+	return 0;
+}
+
+static int fwu_read_f34_flash_status(void)
+{
+	int retval;
+	unsigned char status;
+	unsigned char command;
+
+	retval = fwu->fn_ptr->read(fwu->rmi4_data,
+			fwu->f34_fd.data_base_addr + FLASH_STATUS_OFFSET,
+			&status,
+			sizeof(status));
+	if (retval < 0) {
+		dev_err(&fwu->rmi4_data->i2c_client->dev,
+				"%s: Failed to read flash status\n",
+				__func__);
+		return retval;
+	}
+
+	/* Program enabled bit not available - force bit to be set */
+	fwu->flash_status.program_enabled = 1;
+	fwu->flash_status.status = status & MASK_3BIT;
+
+	retval = fwu->fn_ptr->read(fwu->rmi4_data,
+			fwu->f34_fd.data_base_addr + FLASH_COMMAND_OFFSET,
+			&command,
+			sizeof(command));
+	if (retval < 0) {
+		dev_err(&fwu->rmi4_data->i2c_client->dev,
+				"%s: Failed to read flash command\n",
+				__func__);
+		return retval;
+	}
+
+	fwu->command = command & MASK_4BIT;
+
+	return 0;
+}
+
+static int fwu_write_f34_command(unsigned char cmd)
+{
+	int retval;
+	unsigned char command = cmd;
+
+	retval = fwu->fn_ptr->write(fwu->rmi4_data,
+			fwu->f34_fd.data_base_addr + FLASH_COMMAND_OFFSET,
+			&command,
+			sizeof(command));
+	if (retval < 0) {
+		dev_err(&fwu->rmi4_data->i2c_client->dev,
+				"%s: Failed to write command 0x%02x\n",
+				__func__, command);
+		return retval;
+	}
+
+	fwu->command = cmd;
+
+	return 0;
+}
+
+static int fwu_wait_for_idle(int timeout_ms)
+{
+	int count = 0;
+	int timeout_count = ((timeout_ms * 1000) / MAX_SLEEP_TIME_US) + 1;
+
+	do {
+		usleep_range(MIN_SLEEP_TIME_US, MAX_SLEEP_TIME_US);
+
+		count++;
+		if (count == timeout_count)
+			fwu_read_f34_flash_status();
+
+		if ((fwu->command == 0x00) &&
+				(fwu->flash_status.status == 0x00))
+			return 0;
+	} while (count < timeout_count);
+
+	dev_err(&fwu->rmi4_data->i2c_client->dev,
+			"%s: Timed out waiting for idle status\n",
+			__func__);
+
+	return -ETIMEDOUT;
+}
+
+static int fwu_scan_pdt(void)
+{
+	int retval;
+	unsigned char ii;
+	unsigned char intr_count = 0;
+	unsigned char intr_off;
+	unsigned char intr_src;
+	unsigned short addr;
+	bool f01found = false;
+	bool f34found = false;
+	struct synaptics_rmi4_fn_desc rmi_fd;
+
+	for (addr = PDT_START; addr > PDT_END; addr -= PDT_ENTRY_SIZE) {
+		retval = fwu->fn_ptr->read(fwu->rmi4_data,
+				addr,
+				(unsigned char *)&rmi_fd,
+				sizeof(rmi_fd));
+		if (retval < 0)
+			return retval;
+
+		if (rmi_fd.fn_number) {
+			dev_dbg(&fwu->rmi4_data->i2c_client->dev,
+					"%s: Found F%02x\n",
+					__func__, rmi_fd.fn_number);
+			switch (rmi_fd.fn_number) {
+			case SYNAPTICS_RMI4_F01:
+				f01found = true;
+				fwu->f01_fd.query_base_addr =
+						rmi_fd.query_base_addr;
+				fwu->f01_fd.ctrl_base_addr =
+						rmi_fd.ctrl_base_addr;
+				fwu->f01_fd.data_base_addr =
+						rmi_fd.data_base_addr;
+				fwu->f01_fd.cmd_base_addr =
+						rmi_fd.cmd_base_addr;
+				break;
+			case SYNAPTICS_RMI4_F34:
+				f34found = true;
+				fwu->f34_fd.query_base_addr =
+						rmi_fd.query_base_addr;
+				fwu->f34_fd.ctrl_base_addr =
+						rmi_fd.ctrl_base_addr;
+				fwu->f34_fd.data_base_addr =
+						rmi_fd.data_base_addr;
+
+				fwu->intr_mask = 0;
+				intr_src = rmi_fd.intr_src_count;
+				intr_off = intr_count % 8;
+				for (ii = intr_off;
+						ii < ((intr_src & MASK_3BIT) +
+						intr_off);
+						ii++) {
+					fwu->intr_mask |= 1 << ii;
+				}
+				break;
+			}
+		} else {
+			break;
+		}
+
+		intr_count += (rmi_fd.intr_src_count & MASK_3BIT);
+	}
+
+	if (!f01found || !f34found) {
+		dev_err(&fwu->rmi4_data->i2c_client->dev,
+				"%s: Failed to find both F01 and F34\n",
+				__func__);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int fwu_write_blocks(unsigned char *block_ptr, unsigned short block_cnt,
+		unsigned char command)
+{
+	int retval;
+	unsigned char block_offset[] = {0, 0};
+	unsigned short block_num;
+
+	block_offset[1] |= (fwu->config_area << 5);
+
+	retval = fwu->fn_ptr->write(fwu->rmi4_data,
+			fwu->f34_fd.data_base_addr + BLOCK_NUMBER_OFFSET,
+			block_offset,
+			sizeof(block_offset));
+	if (retval < 0) {
+		dev_err(&fwu->rmi4_data->i2c_client->dev,
+				"%s: Failed to write to block number registers\n",
+				__func__);
+		return retval;
+	}
+
+	for (block_num = 0; block_num < block_cnt; block_num++) {
+		retval = fwu->fn_ptr->write(fwu->rmi4_data,
+				fwu->f34_fd.data_base_addr + BLOCK_DATA_OFFSET,
+				block_ptr,
+				fwu->block_size);
+		if (retval < 0) {
+			dev_err(&fwu->rmi4_data->i2c_client->dev,
+					"%s: Failed to write block data (block %d)\n",
+					__func__, block_num);
+			return retval;
+		}
+
+		retval = fwu_write_f34_command(command);
+		if (retval < 0) {
+			dev_err(&fwu->rmi4_data->i2c_client->dev,
+					"%s: Failed to write command for block %d\n",
+					__func__, block_num);
+			return retval;
+		}
+
+		retval = fwu_wait_for_idle(WRITE_WAIT_MS);
+		if (retval < 0) {
+			dev_err(&fwu->rmi4_data->i2c_client->dev,
+					"%s: Failed to wait for idle status (block %d)\n",
+					__func__, block_num);
+			return retval;
+		}
+
+		block_ptr += fwu->block_size;
+	}
+
+	return 0;
+}
+
+static int fwu_write_firmware(void)
+{
+	return fwu_write_blocks((unsigned char *)fwu->firmware_data,
+		fwu->fw_block_count, CMD_WRITE_FW_BLOCK);
+}
+
+static int fwu_write_configuration(void)
+{
+	return fwu_write_blocks((unsigned char *)fwu->config_data,
+		fwu->config_block_count, CMD_WRITE_CONFIG_BLOCK);
+}
+
+static int fwu_write_bootloader_id(void)
+{
+	int retval;
+
+	retval = fwu->fn_ptr->write(fwu->rmi4_data,
+			fwu->f34_fd.data_base_addr + BLOCK_DATA_OFFSET,
+			fwu->bootloader_id,
+			sizeof(fwu->bootloader_id));
+	if (retval < 0) {
+		dev_err(&fwu->rmi4_data->i2c_client->dev,
+				"%s: Failed to write bootloader ID\n",
+				__func__);
+		return retval;
+	}
+
+	return 0;
+}
+
+static int fwu_enter_flash_prog(void)
+{
+	int retval;
+	struct f01_device_status f01_device_status;
+	struct f01_device_control f01_device_control;
+
+	retval = fwu_write_bootloader_id();
+	if (retval < 0)
+		return retval;
+
+	retval = fwu_write_f34_command(CMD_ENABLE_FLASH_PROG);
+	if (retval < 0)
+		return retval;
+
+	retval = fwu_wait_for_idle(ENABLE_WAIT_MS);
+	if (retval < 0)
+		return retval;
+
+	if (!fwu->flash_status.program_enabled) {
+		dev_err(&fwu->rmi4_data->i2c_client->dev,
+				"%s: Program enabled bit not set\n",
+				__func__);
+		return -EINVAL;
+	}
+
+	retval = fwu_scan_pdt();
+	if (retval < 0)
+		return retval;
+
+	retval = fwu_read_f01_device_status(&f01_device_status);
+	if (retval < 0)
+		return retval;
+
+	if (!f01_device_status.flash_prog) {
+		dev_err(&fwu->rmi4_data->i2c_client->dev,
+				"%s: Not in flash prog mode\n",
+				__func__);
+		return -EINVAL;
+	}
+
+	retval = fwu_read_f34_queries();
+	if (retval < 0)
+		return retval;
+
+	retval = fwu->fn_ptr->read(fwu->rmi4_data,
+			fwu->f01_fd.ctrl_base_addr,
+			f01_device_control.data,
+			sizeof(f01_device_control.data));
+	if (retval < 0) {
+		dev_err(&fwu->rmi4_data->i2c_client->dev,
+				"%s: Failed to read F01 device control\n",
+				__func__);
+		return retval;
+	}
+
+	f01_device_control.nosleep = true;
+	f01_device_control.sleep_mode = SLEEP_MODE_NORMAL;
+
+	retval = fwu->fn_ptr->write(fwu->rmi4_data,
+			fwu->f01_fd.ctrl_base_addr,
+			f01_device_control.data,
+			sizeof(f01_device_control.data));
+	if (retval < 0) {
+		dev_err(&fwu->rmi4_data->i2c_client->dev,
+				"%s: Failed to write F01 device control\n",
+				__func__);
+		return retval;
+	}
+
+	return retval;
+}
+
+static int fwu_do_reflash(void)
+{
+	int retval;
+
+#ifdef TSP_BOOSTER
+	retval = set_freq_limit(DVFS_TOUCH_ID,
+				MIN_TOUCH_LIMIT);
+	if (retval < 0)
+		dev_err(&fwu->rmi4_data->i2c_client->dev,
+			"%s: dvfs failed at fw update.\n",
+			__func__);
+#endif
+	retval = fwu_enter_flash_prog();
+	if (retval < 0)
+		return retval;
+
+	dev_info(&fwu->rmi4_data->i2c_client->dev,
+			"%s: Entered flash prog mode\n",
+			__func__);
+
+	retval = fwu_write_bootloader_id();
+	if (retval < 0)
+		return retval;
+
+	dev_info(&fwu->rmi4_data->i2c_client->dev,
+			"%s: Bootloader ID written\n",
+			__func__);
+
+	retval = fwu_write_f34_command(CMD_ERASE_ALL);
+	if (retval < 0)
+		return retval;
+
+	dev_info(&fwu->rmi4_data->i2c_client->dev,
+			"%s: Erase all command written\n",
+			__func__);
+
+	retval = fwu_wait_for_idle(ERASE_WAIT_MS);
+	if (retval < 0)
+		return retval;
+
+	dev_info(&fwu->rmi4_data->i2c_client->dev,
+			"%s: Idle status detected\n",
+			__func__);
+
+	if (fwu->firmware_data) {
+		retval = fwu_write_firmware();
+		if (retval < 0)
+			return retval;
+		dev_info(&fwu->rmi4_data->i2c_client->dev, "%s: Firmware programmed\n",
+			__func__);
+	}
+
+	if (fwu->config_data) {
+		retval = fwu_write_configuration();
+		if (retval < 0)
+			return retval;
+		dev_info(&fwu->rmi4_data->i2c_client->dev, "%s: Configuration programmed\n",
+			__func__);
+	}
+
+	return retval;
+}
+
+/* TODO: Below function is added to check that firmware update is needed or not.
+ * During development period, we need to support test firmware and various H/W
+ * type such as A1/B0.... So Below conditions are very compex, maybe we need to
+ * simplify this function not so far.
+ * Synaptics's test firmware binary doesn't have Ic and firmware version.
+ * in that case we skip update on booting time.
+ * otherwise we forced run the update during UMS update..
+ */
+static bool fwu_check_skip_reflash(bool mode, bool factory_fw,
+	const struct firmware *fw_entry)
+{
+	if (fwu->ext_data_source) {
+		/* UMS case */
+		int ic_revision_of_bin =
+			(int)fwu->ext_data_source[IC_REVISION_BIN_OFFSET];
+		int fw_version_of_bin =
+			(int)fwu->ext_data_source[FW_VERSION_BIN_OFFSET];
+		int fw_release_date_of_bin =
+			(int)(fwu->ext_data_source[DATE_OF_FIRMWARE_BIN_OFFSET] << 8
+				| fwu->ext_data_source[DATE_OF_FIRMWARE_BIN_OFFSET + 1]);
+
+		/* A1 revision does not have revision info in firmware */
+		if ((ic_revision_of_bin >> 4) != 0xB) {
+#if !defined(CONFIG_SAMSUNG_PRODUCT_SHIP)
+			/* Test firmware file does not have version infomation */
+			if (!ic_revision_of_bin && !fw_version_of_bin
+				&& !fw_release_date_of_bin) {
+				dev_info(&fwu->rmi4_data->i2c_client->dev,
+					"%s [UMS] : Firmware is Test firmware\n",
+					__func__);
+				ic_revision_of_bin = 0xB0;
+			} else {
+				ic_revision_of_bin = 0xA1;
+			}
+#else
+			ic_revision_of_bin = 0xA1;
+#endif
+		}
+
+		if (ic_revision_of_bin == 0xBF)
+			dev_info(&fwu->rmi4_data->i2c_client->dev,
+				"%s [UMS] : Firmware is Factory Test firmware\n",
+				__func__);
+
+		/* To prevent writing B0 firmware into A1 board */
+		if ((fwu->rmi4_data->ic_revision_of_ic >> 4) != (ic_revision_of_bin >> 4)) {
+
+			if ((!fwu->rmi4_data->fw_release_date_of_ic) && (!fwu->rmi4_data->fw_version_of_ic)) {
+					dev_err(&fwu->rmi4_data->i2c_client->dev,
+						"%s:[UMS] update: Revision is not macthed 0x%X(BIN) != 0x%X(IC), but IC FW is TEST FW, run force update\n",
+						__func__, ic_revision_of_bin,
+						fwu->rmi4_data->ic_revision_of_ic);
+				return false;
+			} else {
+				dev_err(&fwu->rmi4_data->i2c_client->dev,
+						"%s:[UMS] update: Revision is not macthed 0x%X(BIN) != 0x%X(IC)\n",
+						__func__, ic_revision_of_bin,
+						fwu->rmi4_data->ic_revision_of_ic);
+				return true;
+			}
+		}
+	} else {
+		/* In kernel case */
+		/* Read revision and firmware info from binary */
+		fwu->rmi4_data->ic_revision_of_bin =
+			(int)fw_entry->data[IC_REVISION_BIN_OFFSET];
+		/* A1 revision does not have revision info in firmware */
+		if ((fwu->rmi4_data->ic_revision_of_bin  >> 4) != 0xB)
+			fwu->rmi4_data->ic_revision_of_bin = 0xA1;
+
+		fwu->rmi4_data->fw_version_of_bin =
+			(int)fw_entry->data[FW_VERSION_BIN_OFFSET];
+
+		dev_info(&fwu->rmi4_data->i2c_client->dev,
+			"%s: [FW size. revision, version] [%d, 0x%02X/0x%02X(BIN/IC), 0x%02X/0x%02X(BIN/IC)]\n",
+			__func__, fw_entry->size,
+			fwu->rmi4_data->ic_revision_of_bin,
+			fwu->rmi4_data->ic_revision_of_ic,
+			(int)fw_entry->data[FW_VERSION_BIN_OFFSET],
+			fwu->rmi4_data->fw_version_of_ic);
+		dev_info(&fwu->rmi4_data->i2c_client->dev,
+			"%s: [Panel, mode, prog] [0x%02X, 0x%02X, 0x%02X]\n",
+			__func__, fwu->rmi4_data->panel_revision,
+			mode, fwu->rmi4_data->flash_prog_mode);
+
+#if !defined(CONFIG_SAMSUNG_PRODUCT_SHIP)
+		/* Test firmware file does not have version infomation */
+		if ((!mode) && (!fwu->rmi4_data->flash_prog_mode)
+			&& !fwu->rmi4_data->fw_version_of_ic
+			&& !fwu->rmi4_data->fw_release_date_of_ic){
+			dev_info(&fwu->rmi4_data->i2c_client->dev,
+					"%s:[TEST] Firmware is Test firmware so do not need to update fw\n",
+					__func__);
+			return true;
+		}
+#endif
+/*
+		if (((fwu->rmi4_data->ic_revision_of_ic >> 4) != (fwu->rmi4_data->ic_revision_of_bin >> 4))) {
+			dev_info(&fwu->rmi4_data->i2c_client->dev,
+				"%s: IC revision is not equal. IC: 0x%x / BIN 0x%x\n",
+				__func__,
+				fwu->rmi4_data->ic_revision_of_ic,
+				fwu->rmi4_data->ic_revision_of_bin);
+			return true;
+		}
+*/
+		if ((!mode) && (factory_fw) && (fwu->rmi4_data->ic_revision_of_ic == 0xB0) &&
+			(fwu->rmi4_data->fw_version_of_bin <= fwu->rmi4_data->fw_version_of_ic)) {
+			if (fwu->rmi4_data->board->recovery_mode) {
+				dev_info(&fwu->rmi4_data->i2c_client->dev,
+					"%s: recovery mode && factory bianry, run fw update to Factory FW\n",
+					__func__);
+			} else {
+				dev_info(&fwu->rmi4_data->i2c_client->dev,
+					"%s:[%s] %s BIN: 0x%02X /  %s FW: 0x%02X, do not update factory fw\n",
+					__func__, mode ? "Force" : "Booting",
+					factory_fw ? "FACTORY" : "USER", fwu->rmi4_data->fw_version_of_bin,
+					fwu->rmi4_data->ic_revision_of_ic == 0xB0 ? "USER FW" : "FACTORY FW",
+					fwu->rmi4_data->fw_version_of_ic);
+				return true;
+			}
+		}
+
+		if ((fwu->rmi4_data->fw_version_of_bin <= fwu->rmi4_data->fw_version_of_ic) &&
+			(fwu->rmi4_data->ic_revision_of_ic == fwu->rmi4_data->ic_revision_of_bin) &&
+			(!mode) && (!fwu->rmi4_data->flash_prog_mode)) {
+			dev_info(&fwu->rmi4_data->i2c_client->dev,
+				"%s: do not need to update fw\n", __func__);
+			return true;
+		} else {
+			dev_info(&fwu->rmi4_data->i2c_client->dev,
+				"%s: fw_ver (BIN:0x%x/IC:0x%x) ic_ver(BIN:0x%x/IC:0x%x) mode(%s) frog(%x)\n",
+				__func__, fwu->rmi4_data->fw_version_of_bin,
+				fwu->rmi4_data->fw_version_of_ic,
+				fwu->rmi4_data->ic_revision_of_ic,
+				fwu->rmi4_data->ic_revision_of_bin,
+				mode ? "forced" : "booting",
+				fwu->rmi4_data->flash_prog_mode);
+		}
+	}
+
+	return false;
+}
+
+static int fwu_start_reflash(bool mode, bool factory_fw)
+{
+	int retval = 0, retry = 3;
+	unsigned char device_status;
+	struct image_header header;
+	const unsigned char *fw_image;
+	const struct firmware *fw_entry = NULL;
+
+	if (fwu->rmi4_data->sensor_sleep || fwu->rmi4_data->touch_stopped) {
+		dev_err(&fwu->rmi4_data->i2c_client->dev,
+				"%s: Sensor sleeping or stopped\n",
+				__func__);
+		return -ENODEV;
+	}
+
+	fwu->rmi4_data->stay_awake = true;
+
+	if (fwu->ext_data_source) {
+		if (fwu_check_skip_reflash(mode, factory_fw, NULL)) {
+			retval = -EINVAL;
+			goto done;
+		}
+		fw_image = fwu->ext_data_source;
+	} else {
+		char fw_path[SYNAPTICS_MAX_FW_PATH];
+
+		memset(&fw_path, 0, SYNAPTICS_MAX_FW_PATH);
+
+		/* use factory test FW */
+#if defined(CONFIG_MACH_JACTIVE_EUR) || defined(CONFIG_MACH_JACTIVE_ATT)
+		if (factory_fw) {
+			dev_info(&fwu->rmi4_data->i2c_client->dev,
+				"%s: run fw update for FACTORY FIRMWARE\n",
+				__func__);
+			if (FW_NOT_SUPPORT_HSYNC(fwu))
+				snprintf(fw_path, SYNAPTICS_MAX_FW_PATH,
+					"%s", FW_IMAGE_NAME_B0_NON_HSYNC_FAC);
+			else if (FW_SUPPORT_HSYNC03(fwu))
+				snprintf(fw_path, SYNAPTICS_MAX_FW_PATH,
+					"%s", FW_IMAGE_NAME_B0_HSYNC_FAC);
+			else // FW_SUPPORT_HSYNC04(fwu)
+				snprintf(fw_path, SYNAPTICS_MAX_FW_PATH,
+					"%s", FW_IMAGE_NAME_B0_HSYNC04_FAC);
+		} else {
+		/* Read firmware according to ic revision */
+			if ((fwu->rmi4_data->ic_revision_of_ic >> 4) == 0xB) {
+				/* Read firmware according to panel ID */
+				switch (fwu->rmi4_data->panel_revision) {
+				case OCTA_PANEL_REVISION_34:
+					if (FW_NOT_SUPPORT_HSYNC(fwu))
+						snprintf(fw_path, SYNAPTICS_MAX_FW_PATH,
+							"%s", FW_IMAGE_NAME_B0_NON_HSYNC);
+					else if (FW_SUPPORT_HSYNC03(fwu)){
+						snprintf(fw_path, SYNAPTICS_MAX_FW_PATH,
+							"%s", FW_IMAGE_NAME_B0_HSYNC);
+						}
+					else // FW_SUPPORT_HSYNC04(fwu)
+						snprintf(fw_path, SYNAPTICS_MAX_FW_PATH,
+							"%s", FW_IMAGE_NAME_B0_HSYNC04);
+					break;
+				default:
+					dev_info(&fwu->rmi4_data->i2c_client->dev,
+						"%s: Do not request, not matched revision and FW.\n",
+						__func__);
+					goto out;
+				}
+			} else if ((fwu->rmi4_data->ic_revision_of_ic >> 4) == 0xA) {
+				dev_info(&fwu->rmi4_data->i2c_client->dev,
+					"%s: Do not request, not matched revision and FW.\n",
+					__func__);
+				goto out;
+			} else { // force update when ic_revision_of_ic is NULL
+				snprintf(fw_path, SYNAPTICS_MAX_FW_PATH, "%s", FW_IMAGE_NAME_B0_HSYNC);
+				printk(KERN_ERR "%s, force update when ic_revision_of_ic is NULL\n", __func__);
+				mode = true;
+			}
+		}
+#else
+		if (factory_fw) {
+			dev_info(&fwu->rmi4_data->i2c_client->dev,
+				"%s: run fw update for FACTORY FIRMWARE\n",
+				__func__);
+			if (fwu->rmi4_data->panel_revision < OCTA_PANEL_REVISION_51)
+				snprintf(fw_path, SYNAPTICS_MAX_FW_PATH,
+						"%s", FW_IMAGE_NAME_B0_FAC);
+			else
+				snprintf(fw_path, SYNAPTICS_MAX_FW_PATH,
+						"%s", FW_IMAGE_NAME_B0_5_1_FAC);
+
+		} else {
+		/* Read firmware according to ic revision */
+			if ((fwu->rmi4_data->ic_revision_of_ic >> 4) == 0xB) {
+					/* Read firmware according to panel ID */
+					switch (fwu->rmi4_data->panel_revision) {
+					case OCTA_PANEL_REVISION_43:
+						snprintf(fw_path, SYNAPTICS_MAX_FW_PATH,
+							"%s", FW_IMAGE_NAME_B0_43);
+						break;
+					case OCTA_PANEL_REVISION_40:
+						snprintf(fw_path, SYNAPTICS_MAX_FW_PATH,
+							"%s", FW_IMAGE_NAME_B0_40);
+						break;
+					case OCTA_PANEL_REVISION_34:
+						snprintf(fw_path, SYNAPTICS_MAX_FW_PATH,
+							"%s", FW_IMAGE_NAME_B0_34);
+						break;
+					case OCTA_PANEL_REVISION_51:
+						snprintf(fw_path, SYNAPTICS_MAX_FW_PATH,
+							"%s", FW_IMAGE_NAME_B0_51);
+						break;
+					default:
+						dev_info(&fwu->rmi4_data->i2c_client->dev,
+							"%s: Do not request, not matched revision and FW.\n",
+							__func__);
+						goto out;
+				}
+			} else if ((fwu->rmi4_data->ic_revision_of_ic >> 4) == 0xA) {
+				snprintf(fw_path, SYNAPTICS_MAX_FW_PATH,
+					"%s", FW_IMAGE_NAME_A1);
+			} else if (fwu->rmi4_data->ic_revision_of_ic == 0x00) {
+				if ((strncmp(fwu->product_id, SYNAPTICS_PRODUCT_ID_B0, 5) == 0)
+					 ||	(strncmp(fwu->product_id, SYNAPTICS_PRODUCT_ID_B0_SPAIR, 6) == 0))
+					snprintf(fw_path, SYNAPTICS_MAX_FW_PATH,
+						"%s", FW_IMAGE_NAME_B0_43);
+			}
+		}
+#endif
+		dev_info(&fwu->rmi4_data->i2c_client->dev,
+				"%s: Requesting firmware image %s\n",
+				__func__, fw_path);
+
+		retval = request_firmware(&fw_entry, fw_path,
+				&fwu->rmi4_data->i2c_client->dev);
+		if (retval != 0) {
+			dev_err(&fwu->rmi4_data->i2c_client->dev,
+					"%s: Firmware image %s not available\n",
+					__func__, fw_path);
+			goto done;
+		}
+
+		if (fwu_check_skip_reflash(mode, factory_fw, fw_entry))
+			goto done;
+		fw_image = fw_entry->data;
+	}
+
+	parse_header(&header, fw_image);
+
+	if (header.image_size)
+		fwu->firmware_data = fw_image + FW_IMAGE_OFFSET;
+	if (header.config_size) {
+		fwu->config_data = fw_image + FW_IMAGE_OFFSET +
+				header.image_size;
+	}
+
+	while (retry--) {
+
+		mutex_lock(&(fwu->rmi4_data->rmi4_reflash_mutex));
+		fwu->rmi4_data->doing_reflash = true;
+		retval = fwu_do_reflash();
+		if (retval < 0) {
+			dev_err(&fwu->rmi4_data->i2c_client->dev,
+					"%s: Failed to do reflash\n",
+					__func__);
+		}
+
+		fwu->rmi4_data->reset_device(fwu->rmi4_data);
+		fwu->rmi4_data->doing_reflash = false;
+		mutex_unlock(&(fwu->rmi4_data->rmi4_reflash_mutex));
+
+		fwu->fn_ptr->read(fwu->rmi4_data,
+				F01_DEVICE_STATUS,
+				&device_status,
+				sizeof(device_status));
+		if (!(device_status & (1 << 6)))
+			break;
+		else
+			dev_info(&fwu->rmi4_data->i2c_client->dev,
+				"%s: flash prog bit = %x, retry = %d\n",
+				__func__, device_status & (1 << 6), retry);
+
+	}
+done:
+	if (fw_entry)
+		release_firmware(fw_entry);
+out:
+#ifdef TSP_BOOSTER
+	retval = set_freq_limit(DVFS_TOUCH_ID, -1);
+#endif
+	if (retval < 0)
+		dev_err(&fwu->rmi4_data->i2c_client->dev,
+			"%s: in fw update, failed booster stop.\n",
+			__func__);
+
+	dev_info(&fwu->rmi4_data->i2c_client->dev, "%s: End of reflash process\n",
+		 __func__);
+
+	fwu->rmi4_data->stay_awake = false;
+
+	return retval;
+}
+
+static int fwu_do_write_config(void)
+{
+	int retval;
+
+	retval = fwu_enter_flash_prog();
+	if (retval < 0)
+		return retval;
+
+	dev_dbg(&fwu->rmi4_data->i2c_client->dev,
+			"%s: Entered flash prog mode\n",
+			__func__);
+
+	if (fwu->config_area == PERM_CONFIG_AREA) {
+		fwu->config_block_count = fwu->perm_config_block_count;
+		goto write_config;
+	}
+
+	retval = fwu_write_bootloader_id();
+	if (retval < 0)
+		return retval;
+
+	dev_dbg(&fwu->rmi4_data->i2c_client->dev,
+			"%s: Bootloader ID written\n",
+			__func__);
+
+	switch (fwu->config_area) {
+	case UI_CONFIG_AREA:
+		retval = fwu_write_f34_command(CMD_ERASE_CONFIG);
+		break;
+	case BL_CONFIG_AREA:
+		retval = fwu_write_f34_command(CMD_ERASE_BL_CONFIG);
+		fwu->config_block_count = fwu->bl_config_block_count;
+		break;
+	case DISP_CONFIG_AREA:
+		retval = fwu_write_f34_command(CMD_ERASE_DISP_CONFIG);
+		fwu->config_block_count = fwu->disp_config_block_count;
+		break;
+	}
+	if (retval < 0)
+		return retval;
+
+	dev_dbg(&fwu->rmi4_data->i2c_client->dev,
+			"%s: Erase command written\n",
+			__func__);
+
+	retval = fwu_wait_for_idle(ERASE_WAIT_MS);
+	if (retval < 0)
+		return retval;
+
+	dev_dbg(&fwu->rmi4_data->i2c_client->dev,
+			"%s: Idle status detected\n",
+			__func__);
+
+write_config:
+	retval = fwu_write_configuration();
+	if (retval < 0)
+		return retval;
+
+	dev_info(&fwu->rmi4_data->i2c_client->dev, "%s: Config written\n",
+		__func__);
+
+	return retval;
+}
+
+static int fwu_start_write_config(void)
+{
+	int retval;
+	struct image_header header;
+
+	switch (fwu->config_area) {
+	case UI_CONFIG_AREA:
+		break;
+	case PERM_CONFIG_AREA:
+		if (!fwu->has_perm_config)
+			return -EINVAL;
+		break;
+	case BL_CONFIG_AREA:
+		if (!fwu->has_bl_config)
+			return -EINVAL;
+		break;
+	case DISP_CONFIG_AREA:
+		if (!fwu->has_disp_config)
+			return -EINVAL;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (fwu->ext_data_source)
+		fwu->config_data = fwu->ext_data_source;
+	else
+		return -EINVAL;
+
+	if (fwu->config_area == UI_CONFIG_AREA) {
+		parse_header(&header, fwu->ext_data_source);
+
+		if (header.config_size) {
+			fwu->config_data = fwu->ext_data_source +
+					FW_IMAGE_OFFSET +
+					header.image_size;
+		} else {
+			return -EINVAL;
+		}
+	}
+
+	dev_info(&fwu->rmi4_data->i2c_client->dev, "%s: Start of write config process\n",
+		__func__);
+
+	fwu->rmi4_data->doing_reflash = true;
+	retval = fwu_do_write_config();
+	if (retval < 0) {
+		dev_err(&fwu->rmi4_data->i2c_client->dev,
+				"%s: Failed to write config\n",
+				__func__);
+	}
+
+	fwu->rmi4_data->reset_device(fwu->rmi4_data);
+	fwu->rmi4_data->doing_reflash = false;
+
+	dev_info(&fwu->rmi4_data->i2c_client->dev, "%s: End of write config process\n",
+		__func__);
+
+	return retval;
+}
+
+static int fwu_do_read_config(void)
+{
+	int retval;
+	unsigned char block_offset[] = {0, 0};
+	unsigned short block_num;
+	unsigned short block_count;
+	unsigned short index = 0;
+
+	retval = fwu_enter_flash_prog();
+	if (retval < 0)
+		goto exit;
+
+	dev_dbg(&fwu->rmi4_data->i2c_client->dev,
+			"%s: Entered flash prog mode\n",
+			__func__);
+
+	switch (fwu->config_area) {
+	case UI_CONFIG_AREA:
+		block_count = fwu->config_block_count;
+		break;
+	case PERM_CONFIG_AREA:
+		if (!fwu->has_perm_config) {
+			retval = -EINVAL;
+			goto exit;
+		}
+		block_count = fwu->perm_config_block_count;
+		break;
+	case BL_CONFIG_AREA:
+		if (!fwu->has_bl_config) {
+			retval = -EINVAL;
+			goto exit;
+		}
+		block_count = fwu->bl_config_block_count;
+		break;
+	case DISP_CONFIG_AREA:
+		if (!fwu->has_disp_config) {
+			retval = -EINVAL;
+			goto exit;
+		}
+		block_count = fwu->disp_config_block_count;
+		break;
+	default:
+		retval = -EINVAL;
+		goto exit;
+	}
+
+	fwu->config_size = fwu->block_size * block_count;
+
+	kfree(fwu->read_config_buf);
+	fwu->read_config_buf = kzalloc(fwu->config_size, GFP_KERNEL);
+
+	block_offset[1] |= (fwu->config_area << 5);
+
+	retval = fwu->fn_ptr->write(fwu->rmi4_data,
+			fwu->f34_fd.data_base_addr + BLOCK_NUMBER_OFFSET,
+			block_offset,
+			sizeof(block_offset));
+	if (retval < 0) {
+		dev_err(&fwu->rmi4_data->i2c_client->dev,
+				"%s: Failed to write to block number registers\n",
+				__func__);
+		goto exit;
+	}
+
+	for (block_num = 0; block_num < block_count; block_num++) {
+		retval = fwu_write_f34_command(CMD_READ_CONFIG_BLOCK);
+		if (retval < 0) {
+			dev_err(&fwu->rmi4_data->i2c_client->dev,
+					"%s: Failed to write read config command\n",
+					__func__);
+			goto exit;
+		}
+
+		retval = fwu_wait_for_idle(WRITE_WAIT_MS);
+		if (retval < 0) {
+			dev_err(&fwu->rmi4_data->i2c_client->dev,
+					"%s: Failed to wait for idle status\n",
+					__func__);
+			goto exit;
+		}
+
+		retval = fwu->fn_ptr->read(fwu->rmi4_data,
+				fwu->f34_fd.data_base_addr + BLOCK_DATA_OFFSET,
+				&fwu->read_config_buf[index],
+				fwu->block_size);
+		if (retval < 0) {
+			dev_err(&fwu->rmi4_data->i2c_client->dev,
+					"%s: Failed to read block data (block %d)\n",
+					__func__, block_num);
+			goto exit;
+		}
+
+		index += fwu->block_size;
+	}
+
+exit:
+	fwu->rmi4_data->reset_device(fwu->rmi4_data);
+
+	return retval;
+}
+
+/*
+ * fw_data : if exist external FW data.
+ * mode : TRUE : force update, FALSE : auto update
+ * factory_mode : TRUE : FACTORY FW update, FALSE : normal FW update
+ */
+int synaptics_fw_updater(unsigned char *fw_data, bool mode, bool factory_fw)
+{
+	int retval;
+
+	if (!fwu)
+		return -ENODEV;
+
+	if (!fwu->initialized)
+		return -ENODEV;
+
+	fwu->ext_data_source = fw_data;
+	fwu->config_area = UI_CONFIG_AREA;
+
+	dev_info(&fwu->rmi4_data->i2c_client->dev,
+			"%s: %s, %s_FW\n", __func__, mode ? "forced" : "booting",
+			factory_fw ? "factory" : "user");
+	retval = fwu_start_reflash(mode, factory_fw);
+
+	return retval;
+}
+EXPORT_SYMBOL(synaptics_fw_updater);
+
+static ssize_t fwu_sysfs_show_image(struct file *data_file,
+		struct kobject *kobj, struct bin_attribute *attributes,
+		char *buf, loff_t pos, size_t count)
+{
+	struct synaptics_rmi4_data *rmi4_data = fwu->rmi4_data;
+
+	if (count < fwu->config_size) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Not enough space (%d bytes) in buffer\n",
+				__func__, count);
+		return -EINVAL;
+	}
+
+	memcpy(buf, fwu->read_config_buf, fwu->config_size);
+
+	return fwu->config_size;
+}
+
+static ssize_t fwu_sysfs_store_image(struct file *data_file,
+		struct kobject *kobj, struct bin_attribute *attributes,
+		char *buf, loff_t pos, size_t count)
+{
+	memcpy((void *)(&fwu->ext_data_source[fwu->data_pos]),
+			(const void *)buf,
+			count);
+
+	fwu->data_pos += count;
+
+	return count;
+}
+
+static ssize_t fwu_sysfs_do_reflash_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	int retval;
+	unsigned int input;
+	struct synaptics_rmi4_data *rmi4_data = fwu->rmi4_data;
+
+	if (sscanf(buf, "%u", &input) != 1) {
+		retval = -EINVAL;
+		goto exit;
+	}
+
+	if (input != 1) {
+		retval = -EINVAL;
+		goto exit;
+	}
+
+	retval = synaptics_fw_updater(fwu->ext_data_source, true, false);
+	if (retval < 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to do reflash\n",
+				__func__);
+		goto exit;
+	}
+
+	retval = count;
+
+exit:
+	kfree(fwu->ext_data_source);
+	fwu->ext_data_source = NULL;
+	return retval;
+}
+
+static ssize_t fwu_sysfs_write_config_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	int retval;
+	unsigned int input;
+	struct synaptics_rmi4_data *rmi4_data = fwu->rmi4_data;
+
+	if (sscanf(buf, "%u", &input) != 1) {
+		retval = -EINVAL;
+		goto exit;
+	}
+
+	if (input != 1) {
+		retval = -EINVAL;
+		goto exit;
+	}
+
+	retval = fwu_start_write_config();
+	if (retval < 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to write config\n",
+				__func__);
+		goto exit;
+	}
+
+	retval = count;
+
+exit:
+	kfree(fwu->ext_data_source);
+	fwu->ext_data_source = NULL;
+	return retval;
+}
+
+static ssize_t fwu_sysfs_read_config_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	int retval;
+	unsigned int input;
+	struct synaptics_rmi4_data *rmi4_data = fwu->rmi4_data;
+
+	if (sscanf(buf, "%u", &input) != 1)
+		return -EINVAL;
+
+	if (input != 1)
+		return -EINVAL;
+
+	retval = fwu_do_read_config();
+	if (retval < 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to read config\n",
+				__func__);
+		return retval;
+	}
+
+	return count;
+}
+
+static ssize_t fwu_sysfs_config_area_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	int retval;
+	unsigned long config_area;
+
+	retval = kstrtoul(buf, 10, &config_area);
+	if (retval)
+		return retval;
+
+	fwu->config_area = config_area;
+
+	return count;
+}
+
+static ssize_t fwu_sysfs_image_size_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	int retval;
+	unsigned long size;
+	struct synaptics_rmi4_data *rmi4_data = fwu->rmi4_data;
+
+	retval = kstrtoul(buf, 10, &size);
+	if (retval)
+		return retval;
+
+	fwu->image_size = size;
+	fwu->data_pos = 0;
+
+	kfree(fwu->ext_data_source);
+	fwu->ext_data_source = kzalloc(fwu->image_size, GFP_KERNEL);
+	if (!fwu->ext_data_source) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to alloc mem for image data\n",
+				__func__);
+		return -ENOMEM;
+	}
+
+	return count;
+}
+
+static ssize_t fwu_sysfs_block_size_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%u\n", fwu->block_size);
+}
+
+static ssize_t fwu_sysfs_firmware_block_count_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%u\n", fwu->fw_block_count);
+}
+
+static ssize_t fwu_sysfs_configuration_block_count_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%u\n", fwu->config_block_count);
+}
+
+static ssize_t fwu_sysfs_perm_config_block_count_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%u\n", fwu->perm_config_block_count);
+}
+
+static ssize_t fwu_sysfs_bl_config_block_count_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%u\n", fwu->bl_config_block_count);
+}
+
+static ssize_t fwu_sysfs_disp_config_block_count_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%u\n", fwu->disp_config_block_count);
+}
+
+static void synaptics_rmi4_fwu_attn(struct synaptics_rmi4_data *rmi4_data,
+		unsigned char intr_mask)
+{
+	if (fwu->intr_mask & intr_mask)
+		fwu_read_f34_flash_status();
+
+	return;
+}
+
+static int synaptics_rmi4_fwu_init(struct synaptics_rmi4_data *rmi4_data)
+{
+	int retval;
+	unsigned char attr_count;
+	int attr_count_num;
+	struct pdt_properties pdt_props;
+
+	fwu = kzalloc(sizeof(*fwu), GFP_KERNEL);
+	if (!fwu) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to alloc mem for fwu\n",
+				__func__);
+		goto exit;
+	}
+
+	fwu->fn_ptr = kzalloc(sizeof(*(fwu->fn_ptr)), GFP_KERNEL);
+	if (!fwu->fn_ptr) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to alloc mem for fn_ptr\n",
+				__func__);
+		retval = -ENOMEM;
+		goto exit_free_fwu;
+	}
+
+	fwu->rmi4_data = rmi4_data;
+	fwu->fn_ptr->read = rmi4_data->i2c_read;
+	fwu->fn_ptr->write = rmi4_data->i2c_write;
+	fwu->fn_ptr->enable = rmi4_data->irq_enable;
+
+	retval = fwu->fn_ptr->read(rmi4_data,
+			PDT_PROPS,
+			pdt_props.data,
+			sizeof(pdt_props.data));
+	if (retval < 0) {
+		dev_info(&rmi4_data->i2c_client->dev,
+				"%s: Failed to read PDT properties, assuming 0x00\n",
+				__func__);
+	} else if (pdt_props.has_bsr) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Reflash for LTS not currently supported\n",
+				__func__);
+		goto exit_free_mem;
+	}
+
+	retval = fwu_scan_pdt();
+	if (retval < 0)
+		goto exit_free_mem;
+
+	fwu->productinfo1 = rmi4_data->rmi4_mod_info.product_info[0];
+	fwu->productinfo2 = rmi4_data->rmi4_mod_info.product_info[1];
+	memcpy(fwu->product_id, rmi4_data->rmi4_mod_info.product_id_string,
+			SYNAPTICS_RMI4_PRODUCT_ID_SIZE);
+	fwu->product_id[SYNAPTICS_RMI4_PRODUCT_ID_SIZE] = 0;
+
+#if defined(CONFIG_MACH_JACTIVE_EUR) || defined(CONFIG_MACH_JACTIVE_ATT)
+	/* Fortius Use only B Type. So read and use ic_revision_of_ic from IC */
+#else
+	/* Check the IC revision from product ID value
+	 * we can check the ic revision with f34_ctrl_3 but to read production
+	 * ID is more safity. because it is non-user writerble area.
+	 */
+
+	if ((strncmp(fwu->product_id, SYNAPTICS_PRODUCT_ID_B0, 5) == 0)
+		 || (strncmp(fwu->product_id, SYNAPTICS_PRODUCT_ID_B0_SPAIR, 6) == 0))
+			 dev_info(&rmi4_data->i2c_client->dev,
+					"%s: ic revision is B0 type.\n",
+					__func__);
+	else
+		rmi4_data->ic_revision_of_ic = 0xA1;
+#endif
+
+	dev_info(&rmi4_data->i2c_client->dev,
+			"%s: [IC] [F01 product info, ID(revision)] [0x%04X 0x%04X, %s(0X%X)], PANEL : 0x%02X\n",
+			__func__, fwu->productinfo1,
+			fwu->productinfo2, fwu->product_id,
+			rmi4_data->ic_revision_of_ic,
+			rmi4_data->panel_revision);
+
+	retval = fwu_read_f34_queries();
+	if (retval < 0)
+		goto exit_free_mem;
+
+	fwu->initialized = true;
+
+	retval = sysfs_create_bin_file(&rmi4_data->input_dev->dev.kobj,
+			&dev_attr_data);
+	if (retval < 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to create sysfs bin file\n",
+				__func__);
+		goto exit_free_mem;
+	}
+
+	for (attr_count = 0; attr_count < ARRAY_SIZE(attrs); attr_count++) {
+		retval = sysfs_create_file(&rmi4_data->input_dev->dev.kobj,
+				&attrs[attr_count].attr);
+		if (retval < 0) {
+			dev_err(&rmi4_data->i2c_client->dev,
+					"%s: Failed to create sysfs attributes\n",
+					__func__);
+			retval = -ENODEV;
+			goto exit_remove_attrs;
+		}
+	}
+
+	return 0;
+
+exit_remove_attrs:
+	attr_count_num = (int)attr_count;
+	for (attr_count_num--; attr_count_num >= 0; attr_count_num--) {
+		sysfs_remove_file(&rmi4_data->input_dev->dev.kobj,
+			&attrs[attr_count].attr);
+}
+
+sysfs_remove_bin_file(&rmi4_data->input_dev->dev.kobj, &dev_attr_data);
+
+exit_free_mem:
+	kfree(fwu->fn_ptr);
+
+exit_free_fwu:
+	kfree(fwu);
+
+exit:
+	return 0;
+}
+
+static void synaptics_rmi4_fwu_remove(struct synaptics_rmi4_data *rmi4_data)
+{
+	unsigned char attr_count;
+
+	sysfs_remove_bin_file(&rmi4_data->input_dev->dev.kobj, &dev_attr_data);
+
+	for (attr_count = 0; attr_count < ARRAY_SIZE(attrs); attr_count++) {
+		sysfs_remove_file(&rmi4_data->input_dev->dev.kobj,
+				&attrs[attr_count].attr);
+	}
+
+	kfree(fwu->fn_ptr);
+	kfree(fwu);
+
+	return;
+}
+
+int rmi4_fw_update_module_register(void)
+{
+	int retval;
+
+	retval = synaptics_rmi4_new_function(RMI_FW_UPDATER,
+			synaptics_rmi4_fwu_init,
+			synaptics_rmi4_fwu_remove,
+			synaptics_rmi4_fwu_attn);
+
+	return retval;
+}
diff --git a/drivers/input/touchscreen/synaptics_i2c_rmi.c b/drivers/input/touchscreen/synaptics_i2c_rmi.c
new file mode 100644
index 0000000..985c0c6
--- /dev/null
+++ b/drivers/input/touchscreen/synaptics_i2c_rmi.c
@@ -0,0 +1,4328 @@
+/* Synaptics Register Mapped Interface (RMI4) I2C Physical Layer Driver.
+ * Copyright (c) 2007-2012, Synaptics Incorporated
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <asm/unaligned.h>
+#include <mach/cpufreq.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/input.h>
+#include <linux/input/mt.h>
+#include <linux/gpio.h>
+#include <linux/regulator/consumer.h>
+#ifdef CONFIG_HAS_EARLYSUSPEND
+#include <linux/earlysuspend.h>
+#endif
+#include "synaptics_i2c_rmi.h"
+
+#define DRIVER_NAME "synaptics_rmi4_i2c"
+
+#define PROXIMITY
+#define TYPE_B_PROTOCOL
+#define SURFACE_TOUCH
+
+#ifdef SURFACE_TOUCH
+#define EDGE_SWIPE
+#endif
+#undef USE_OPEN_CLOSE
+#undef USE_SENSOR_SLEEP
+
+/*
+#define REPORT_2D_Z
+*/
+#define REPORT_2D_W
+
+#define F12_FINGERS_TO_SUPPORT 10
+
+#define RPT_TYPE (1 << 0)
+#define RPT_X_LSB (1 << 1)
+#define RPT_X_MSB (1 << 2)
+#define RPT_Y_LSB (1 << 3)
+#define RPT_Y_MSB (1 << 4)
+#define RPT_Z (1 << 5)
+#define RPT_WX (1 << 6)
+#define RPT_WY (1 << 7)
+#define RPT_DEFAULT (RPT_TYPE | RPT_X_LSB | RPT_X_MSB | RPT_Y_LSB | RPT_Y_MSB)
+
+#ifdef CONFIG_GLOVE_TOUCH
+#define GLOVE_FEATURE_EN	0x20
+#define GLOVE_CLEAR_DEFAULT	0x01
+#define F12_CTRL26_OFFSET (8)
+#endif
+
+#ifdef PROXIMITY
+#define USE_CUSTOM_REZERO
+
+#define HOVER_Z_MAX (255)
+#define FINGER_HOVER_EN (1 << 0)
+#define FINGER_HOVER_DIS (0 << 0)
+#define AIR_SWIPE_EN (1 << 1)
+#define LARGE_OBJ_EN (1 << 2)
+#define HOVER_PINCH_EN (1 << 3)
+#define NO_PROXIMITY_ON_TOUCH_EN (1 << 5)
+#define CONTINUOUS_LOAD_REPORT_EN (1 << 6)
+#define SLEEP_PROXIMITY (1 << 7)
+
+#define PROXIMITY_DEFAULT (NO_PROXIMITY_ON_TOUCH_EN)
+#define PROXIMITY_ENABLE (PROXIMITY_DEFAULT | FINGER_HOVER_EN)
+
+#define HAS_FINGER_HOVER (1 << 0)
+#define HAS_AIR_SWIPE (1 << 1)
+#define HAS_LARGE_OBJ (1 << 2)
+#define HAS_HOVER_PINCH (1 << 3)
+#define HAS_EDGE_SWIPE (1 << 4)
+#define HAS_SINGLE_FINGER (1 << 5)
+#define F51_VERSION	0x41
+#define F51_PROXIMITY_ENABLES_OFFSET (0)
+#define F51_CTRL54_OFFSET 99
+#ifdef USE_CUSTOM_REZERO
+#define F51_GENERAL_CONTROL_OFFSET (1)
+#define F51_CTRL78_OFFSET	115
+#endif
+
+#ifdef EDGE_SWIPE
+#define EDGE_SWIPE_DATA_OFFSET	8
+
+#define EDGE_SWIPE_WIDTH_MAX	255
+#define EDGE_SWIPE_ANGLE_MIN	(-90)
+#define EDGE_SWIPE_ANGLE_MAX	90
+#define EDGE_SWIPE_PALM_MAX		1
+#endif
+
+#define F51_FINGER_TIMEOUT 50 /* ms */
+#endif
+
+#define POLLING_PERIOD 1 /* ms */
+#define SYN_I2C_RETRY_TIMES 5
+#define MAX_F11_TOUCH_WIDTH 15
+
+#define CHECK_STATUS_TIMEOUT_MS 200
+#define STATUS_NO_ERROR 0x00
+#define STATUS_RESET_OCCURRED 0x01
+#define STATUS_INVALID_CONFIG 0x02
+#define STATUS_DEVICE_FAILURE 0x03
+#define STATUS_CONFIG_CRC_FAILURE 0x04
+#define STATUS_FIRMWARE_CRC_FAILURE 0x05
+#define STATUS_CRC_IN_PROGRESS 0x06
+
+#define F01_STD_QUERY_LEN 21
+#define F01_BUID_ID_OFFSET 18
+#define F11_STD_QUERY_LEN 9
+#define F11_STD_CTRL_LEN 10
+#define F11_STD_DATA_LEN 12
+
+#define NORMAL_OPERATION (0 << 0)
+#define SENSOR_SLEEP (1 << 0)
+#define NO_SLEEP_OFF (0 << 2)
+#define NO_SLEEP_ON (1 << 2)
+#define CHARGER_CONNECTED (1 << 5)
+#define CHARGER_DISCONNECTED	0xDF
+#define CONFIGURED (1 << 7)
+
+static int synaptics_rmi4_i2c_read(struct synaptics_rmi4_data *rmi4_data,
+		unsigned short addr, unsigned char *data,
+		unsigned short length);
+
+static int synaptics_rmi4_i2c_write(struct synaptics_rmi4_data *rmi4_data,
+		unsigned short addr, unsigned char *data,
+		unsigned short length);
+
+static int synaptics_rmi4_reinit_device(struct synaptics_rmi4_data *rmi4_data);
+
+#ifdef CONFIG_HAS_EARLYSUSPEND
+static ssize_t synaptics_rmi4_full_pm_cycle_show(struct device *dev,
+		struct device_attribute *attr, char *buf);
+
+static ssize_t synaptics_rmi4_full_pm_cycle_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count);
+
+static void synaptics_rmi4_early_suspend(struct early_suspend *h);
+
+static void synaptics_rmi4_late_resume(struct early_suspend *h);
+
+#else
+
+static int synaptics_rmi4_suspend(struct device *dev);
+
+static int synaptics_rmi4_resume(struct device *dev);
+#endif
+
+#ifdef PROXIMITY
+static void synaptics_rmi4_f51_finger_timer(unsigned long data);
+
+static ssize_t synaptics_rmi4_f51_enables_show(struct device *dev,
+		struct device_attribute *attr, char *buf);
+
+static ssize_t synaptics_rmi4_f51_enables_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count);
+#endif
+
+#ifdef USE_OPEN_CLOSE
+static int synaptics_rmi4_input_open(struct input_dev *dev);
+static void synaptics_rmi4_input_close(struct input_dev *dev);
+#endif
+static ssize_t synaptics_rmi4_glove_enable_show(struct device *dev,
+		struct device_attribute *attr, char *buf);
+
+static ssize_t synaptics_rmi4_glove_enable_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count);
+
+static ssize_t synaptics_rmi4_show_device_status(struct device *dev,
+		struct device_attribute *attr, char *buf);
+
+static ssize_t synaptics_rmi4_f01_reset_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count);
+
+static ssize_t synaptics_rmi4_f01_productinfo_show(struct device *dev,
+		struct device_attribute *attr, char *buf);
+
+static ssize_t synaptics_rmi4_f01_buildid_show(struct device *dev,
+		struct device_attribute *attr, char *buf);
+
+static ssize_t synaptics_rmi4_f01_flashprog_show(struct device *dev,
+		struct device_attribute *attr, char *buf);
+
+static ssize_t synaptics_rmi4_0dbutton_show(struct device *dev,
+		struct device_attribute *attr, char *buf);
+
+static ssize_t synaptics_rmi4_0dbutton_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count);
+
+struct synaptics_rmi4_f01_device_status {
+	union {
+		struct {
+			unsigned char status_code:4;
+			unsigned char reserved:2;
+			unsigned char flash_prog:1;
+			unsigned char unconfigured:1;
+		} __packed;
+		unsigned char data[1];
+	};
+};
+
+struct synaptics_rmi4_f12_query_5 {
+	union {
+		struct {
+			unsigned char size_of_query6;
+			struct {
+				unsigned char ctrl0_is_present:1;
+				unsigned char ctrl1_is_present:1;
+				unsigned char ctrl2_is_present:1;
+				unsigned char ctrl3_is_present:1;
+				unsigned char ctrl4_is_present:1;
+				unsigned char ctrl5_is_present:1;
+				unsigned char ctrl6_is_present:1;
+				unsigned char ctrl7_is_present:1;
+			} __packed;
+			struct {
+				unsigned char ctrl8_is_present:1;
+				unsigned char ctrl9_is_present:1;
+				unsigned char ctrl10_is_present:1;
+				unsigned char ctrl11_is_present:1;
+				unsigned char ctrl12_is_present:1;
+				unsigned char ctrl13_is_present:1;
+				unsigned char ctrl14_is_present:1;
+				unsigned char ctrl15_is_present:1;
+			} __packed;
+			struct {
+				unsigned char ctrl16_is_present:1;
+				unsigned char ctrl17_is_present:1;
+				unsigned char ctrl18_is_present:1;
+				unsigned char ctrl19_is_present:1;
+				unsigned char ctrl20_is_present:1;
+				unsigned char ctrl21_is_present:1;
+				unsigned char ctrl22_is_present:1;
+				unsigned char ctrl23_is_present:1;
+			} __packed;
+			struct {
+				unsigned char ctrl24_is_present:1;
+				unsigned char ctrl25_is_present:1;
+				unsigned char ctrl26_is_present:1;
+				unsigned char ctrl27_is_present:1;
+				unsigned char ctrl28_is_present:1;
+				unsigned char ctrl29_is_present:1;
+				unsigned char ctrl30_is_present:1;
+				unsigned char ctrl31_is_present:1;
+			} __packed;
+		};
+		unsigned char data[5];
+	};
+};
+
+struct synaptics_rmi4_f12_query_8 {
+	union {
+		struct {
+			unsigned char size_of_query9;
+			struct {
+				unsigned char data0_is_present:1;
+				unsigned char data1_is_present:1;
+				unsigned char data2_is_present:1;
+				unsigned char data3_is_present:1;
+				unsigned char data4_is_present:1;
+				unsigned char data5_is_present:1;
+				unsigned char data6_is_present:1;
+				unsigned char data7_is_present:1;
+			} __packed;
+		};
+		unsigned char data[2];
+	};
+};
+
+struct synaptics_rmi4_f12_ctrl_8 {
+	union {
+		struct {
+			unsigned char max_x_coord_lsb;
+			unsigned char max_x_coord_msb;
+			unsigned char max_y_coord_lsb;
+			unsigned char max_y_coord_msb;
+			unsigned char rx_pitch_lsb;
+			unsigned char rx_pitch_msb;
+			unsigned char tx_pitch_lsb;
+			unsigned char tx_pitch_msb;
+			unsigned char low_rx_clip;
+			unsigned char high_rx_clip;
+			unsigned char low_tx_clip;
+			unsigned char high_tx_clip;
+			unsigned char num_of_rx;
+			unsigned char num_of_tx;
+		};
+		unsigned char data[14];
+	};
+};
+
+struct synaptics_rmi4_f12_ctrl_9 {
+	union {
+		struct {
+			unsigned char touch_threshold;
+			unsigned char lift_hysteresis;
+			unsigned char small_z_scale_factor_lsb;
+			unsigned char small_z_scale_factor_msb;
+			unsigned char large_z_scale_factor_lsb;
+			unsigned char large_z_scale_factor_msb;
+			unsigned char small_large_boundary;
+			unsigned char wx_scale;
+			unsigned char wx_offset;
+			unsigned char wy_scale;
+			unsigned char wy_offset;
+			unsigned char x_size_lsb;
+			unsigned char x_size_msb;
+			unsigned char y_size_lsb;
+			unsigned char y_size_msb;
+			unsigned char gloved_finger;
+		};
+		unsigned char data[16];
+	};
+};
+
+struct synaptics_rmi4_f12_ctrl_23 {
+	union {
+		struct {
+			unsigned char obj_type_enable;
+			unsigned char max_reported_objects;
+		};
+		unsigned char data[2];
+	};
+};
+
+#ifdef CONFIG_GLOVE_TOUCH
+struct synaptics_rmi4_f12_ctrl_26 {
+	union {
+		struct {
+			unsigned char glove_feature_enable;
+		};
+		unsigned char data[1];
+	};
+};
+#endif
+
+struct synaptics_rmi4_f12_finger_data {
+	unsigned char object_type_and_status;
+	unsigned char x_lsb;
+	unsigned char x_msb;
+	unsigned char y_lsb;
+	unsigned char y_msb;
+#ifdef REPORT_2D_Z
+	unsigned char z;
+#endif
+#ifdef REPORT_2D_W
+	unsigned char wx;
+	unsigned char wy;
+#endif
+};
+
+struct synaptics_rmi4_f1a_query {
+	union {
+		struct {
+			unsigned char max_button_count:3;
+			unsigned char reserved:5;
+			unsigned char has_general_control:1;
+			unsigned char has_interrupt_enable:1;
+			unsigned char has_multibutton_select:1;
+			unsigned char has_tx_rx_map:1;
+			unsigned char has_perbutton_threshold:1;
+			unsigned char has_release_threshold:1;
+			unsigned char has_strongestbtn_hysteresis:1;
+			unsigned char has_filter_strength:1;
+		} __packed;
+		unsigned char data[2];
+	};
+};
+
+struct synaptics_rmi4_f1a_control_0 {
+	union {
+		struct {
+			unsigned char multibutton_report:2;
+			unsigned char filter_mode:2;
+			unsigned char reserved:4;
+		} __packed;
+		unsigned char data[1];
+	};
+};
+
+struct synaptics_rmi4_f1a_control_3_4 {
+	unsigned char transmitterbutton;
+	unsigned char receiverbutton;
+};
+
+struct synaptics_rmi4_f1a_control {
+	struct synaptics_rmi4_f1a_control_0 general_control;
+	unsigned char *button_int_enable;
+	unsigned char *multi_button;
+	struct synaptics_rmi4_f1a_control_3_4 *electrode_map;
+	unsigned char *button_threshold;
+	unsigned char button_release_threshold;
+	unsigned char strongest_button_hysteresis;
+	unsigned char filter_strength;
+};
+
+struct synaptics_rmi4_f1a_handle {
+	int button_bitmask_size;
+	unsigned char button_count;
+	unsigned char valid_button_count;
+	unsigned char *button_data_buffer;
+	unsigned char *button_map;
+	struct synaptics_rmi4_f1a_query button_query;
+	struct synaptics_rmi4_f1a_control button_control;
+};
+
+struct synaptics_rmi4_f34_ctrl_3 {
+	union {
+		struct {
+			unsigned char fw_release_month;
+			unsigned char fw_release_date;
+			unsigned char fw_release_revision;
+			unsigned char fw_release_version;
+		};
+		unsigned char data[4];
+	};
+};
+
+struct synaptics_rmi4_f34_fn_ptr {
+	int (*read)(struct synaptics_rmi4_data *rmi4_data, unsigned short addr,
+			unsigned char *data, unsigned short length);
+	int (*write)(struct synaptics_rmi4_data *rmi4_data, unsigned short addr,
+			unsigned char *data, unsigned short length);
+	int (*enable)(struct synaptics_rmi4_data *rmi4_data, bool enable);
+};
+
+struct synaptics_rmi4_f34_handle {
+	unsigned char status;
+	unsigned char cmd;
+	unsigned short bootloaderid;
+	unsigned short blocksize;
+	unsigned short imageblockcount;
+	unsigned short configblockcount;
+	unsigned short blocknum;
+	unsigned short query_base_addr;
+	unsigned short control_base_addr;
+	unsigned short data_base_addr;
+	bool inflashprogmode;
+	unsigned char intr_mask;
+	struct mutex attn_mutex;
+	struct synaptics_rmi4_f34_fn_ptr *fn_ptr;
+};
+
+#ifdef PROXIMITY
+struct synaptics_rmi4_f51_query {
+	union {
+		struct {
+			unsigned char query_register_count;
+			unsigned char data_register_count;
+			unsigned char control_register_count;
+			unsigned char command_register_count;
+			unsigned char proximity_controls;
+		};
+		unsigned char data[5];
+	};
+};
+
+struct synaptics_rmi4_f51_data {
+	union {
+		struct {
+			unsigned char finger_hover_det:1;
+			unsigned char air_swipe_det:1;
+			unsigned char large_obj_det:1;
+			unsigned char f1a_data0_b3:1;
+			unsigned char hover_pinch_det:1;
+			unsigned char f1a_data0_b5__7:3;
+			unsigned char hover_finger_x_4__11;
+			unsigned char hover_finger_y_4__11;
+			unsigned char hover_finger_xy_0__3;
+			unsigned char hover_finger_z;
+			unsigned char air_swipe_dir_0:1;
+			unsigned char air_swipe_dir_1:1;
+			unsigned char f1a_data3_b2__4:3;
+			unsigned char object_present:1;
+			unsigned char large_obj_act:2;
+		} __packed;
+		unsigned char proximity_data[6];
+	};
+#ifdef EDGE_SWIPE
+	union {
+		struct {
+			unsigned char edge_swipe_x_lsb;
+			unsigned char edge_swipe_x_msb;
+			unsigned char edge_swipe_y_lsb;
+			unsigned char edge_swipe_y_msb;
+			unsigned char edge_swipe_z;
+			unsigned char edge_swipe_wx;
+			unsigned char edge_swipe_wy;
+			unsigned char edge_swipe_mm;
+			unsigned char edge_swipe_dg;
+		} __packed;
+		unsigned char edge_swipe_data[9];
+	};
+#endif
+};
+
+#ifdef EDGE_SWIPE
+struct synaptics_rmi4_surface {
+	int width_major;
+	int palm;
+	int angle;
+	int wx;
+	int wy;
+};
+#endif
+
+struct synaptics_rmi4_f51_handle {
+	unsigned char proximity_enables;
+	unsigned short proximity_enables_addr;
+#ifdef USE_CUSTOM_REZERO
+	unsigned char num_of_data_sources;
+	unsigned short proximity_custom_rezero_addr;
+#endif
+	unsigned char proximity_controls;
+#ifdef EDGE_SWIPE
+	struct synaptics_rmi4_surface surface_data;
+#endif
+	struct synaptics_rmi4_data *rmi4_data;
+};
+#endif
+
+struct synaptics_rmi4_exp_fn {
+	enum exp_fn fn_type;
+	bool initialized;
+	int (*func_init)(struct synaptics_rmi4_data *rmi4_data);
+	void (*func_remove)(struct synaptics_rmi4_data *rmi4_data);
+	void (*func_attn)(struct synaptics_rmi4_data *rmi4_data,
+			unsigned char intr_mask);
+	struct list_head link;
+};
+
+static struct device_attribute attrs[] = {
+#ifdef CONFIG_HAS_EARLYSUSPEND
+	__ATTR(full_pm_cycle, (S_IRUGO | S_IWUSR | S_IWGRP),
+			synaptics_rmi4_full_pm_cycle_show,
+			synaptics_rmi4_full_pm_cycle_store),
+#endif
+#ifdef PROXIMITY
+	__ATTR(proximity_enables, (S_IRUGO | S_IWUSR | S_IWGRP),
+			synaptics_rmi4_f51_enables_show,
+			synaptics_rmi4_f51_enables_store),
+#endif
+	__ATTR(glove_enable, (S_IRUGO | S_IWUSR | S_IWGRP),
+			synaptics_rmi4_glove_enable_show,
+			synaptics_rmi4_glove_enable_store),
+	__ATTR(device_status, S_IRUGO,
+			synaptics_rmi4_show_device_status,
+			synaptics_rmi4_store_error),
+	__ATTR(reset, S_IWUSR | S_IWGRP,
+			synaptics_rmi4_show_error,
+			synaptics_rmi4_f01_reset_store),
+	__ATTR(productinfo, S_IRUGO,
+			synaptics_rmi4_f01_productinfo_show,
+			synaptics_rmi4_store_error),
+	__ATTR(buildid, S_IRUGO,
+			synaptics_rmi4_f01_buildid_show,
+			synaptics_rmi4_store_error),
+	__ATTR(flashprog, S_IRUGO,
+			synaptics_rmi4_f01_flashprog_show,
+			synaptics_rmi4_store_error),
+	__ATTR(0dbutton, (S_IRUGO | S_IWUSR | S_IWGRP),
+			synaptics_rmi4_0dbutton_show,
+			synaptics_rmi4_0dbutton_store),
+};
+
+static struct list_head exp_fn_list;
+
+#ifdef PROXIMITY
+static struct synaptics_rmi4_f51_handle *f51;
+#endif
+
+#ifdef CONFIG_HAS_EARLYSUSPEND
+static ssize_t synaptics_rmi4_full_pm_cycle_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct synaptics_rmi4_data *rmi4_data = dev_get_drvdata(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%u\n",
+			rmi4_data->full_pm_cycle);
+}
+
+static ssize_t synaptics_rmi4_full_pm_cycle_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	unsigned int input;
+	struct synaptics_rmi4_data *rmi4_data = dev_get_drvdata(dev);
+
+	if (sscanf(buf, "%u", &input) != 1)
+		return -EINVAL;
+
+	rmi4_data->full_pm_cycle = input > 0 ? 1 : 0;
+
+	return count;
+}
+#endif
+
+#ifdef TSP_BOOSTER
+static void synaptics_change_dvfs_lock(struct work_struct *work)
+{
+	struct synaptics_rmi4_data *rmi4_data =
+		container_of(work,
+			struct synaptics_rmi4_data, work_dvfs_chg.work);
+	int retval = 0;
+
+	mutex_lock(&rmi4_data->dvfs_lock);
+
+	if (rmi4_data->dvfs_boost_mode == DVFS_STAGE_DUAL) {
+		if (rmi4_data->stay_awake) {
+			dev_info(&rmi4_data->i2c_client->dev,
+				"%s: do fw update, do not change cpu frequency.\n",
+				__func__);
+		} else {
+		retval = set_freq_limit(DVFS_TOUCH_ID,
+				MIN_TOUCH_LIMIT_SECOND);
+		rmi4_data->dvfs_freq = MIN_TOUCH_LIMIT_SECOND;
+		}
+	} else if (rmi4_data->dvfs_boost_mode == DVFS_STAGE_SINGLE) {
+		retval = set_freq_limit(DVFS_TOUCH_ID, -1);
+		rmi4_data->dvfs_freq = -1;
+	}
+
+	if (retval < 0)
+		dev_err(&rmi4_data->i2c_client->dev,
+			"%s: booster change failed(%d).\n",
+			__func__, retval);
+	mutex_unlock(&rmi4_data->dvfs_lock);
+
+}
+
+static void synaptics_set_dvfs_off(struct work_struct *work)
+{
+	struct synaptics_rmi4_data *rmi4_data =
+		container_of(work,
+			struct synaptics_rmi4_data, work_dvfs_off.work);
+	int retval;
+
+	if (rmi4_data->stay_awake) {
+		dev_info(&rmi4_data->i2c_client->dev,
+			"%s: do fw update, do not change cpu frequency.\n",
+			__func__);
+	} else {
+	mutex_lock(&rmi4_data->dvfs_lock);
+
+	retval = set_freq_limit(DVFS_TOUCH_ID, -1);
+	rmi4_data->dvfs_freq = -1;
+
+	if (retval < 0)
+		dev_err(&rmi4_data->i2c_client->dev,
+			"%s: booster stop failed(%d).\n",
+			__func__, retval);
+	rmi4_data->dvfs_lock_status = false;
+
+	mutex_unlock(&rmi4_data->dvfs_lock);
+}
+}
+
+static void synaptics_set_dvfs_lock(struct synaptics_rmi4_data *rmi4_data,
+					int on)
+{
+	int ret = 0;
+
+	if (rmi4_data->dvfs_boost_mode == DVFS_STAGE_NONE) {
+		dev_info(&rmi4_data->i2c_client->dev,
+				"%s: DVFS stage is none(%d)\n",
+				__func__, rmi4_data->dvfs_boost_mode);
+		return;
+	}
+
+	mutex_lock(&rmi4_data->dvfs_lock);
+	if (on == 0) {
+		if (rmi4_data->dvfs_lock_status) {
+			schedule_delayed_work(&rmi4_data->work_dvfs_off,
+				msecs_to_jiffies(TOUCH_BOOSTER_OFF_TIME));
+		}
+	} else if (on > 0) {
+		cancel_delayed_work(&rmi4_data->work_dvfs_off);
+
+		if (rmi4_data->dvfs_old_stauts != on) {
+			cancel_delayed_work(&rmi4_data->work_dvfs_chg);
+			if (1/*!rmi4_data->dvfs_lock_status*/) {
+				if (rmi4_data->dvfs_freq != MIN_TOUCH_LIMIT) {
+					ret = set_freq_limit(DVFS_TOUCH_ID,
+							MIN_TOUCH_LIMIT);
+					rmi4_data->dvfs_freq = MIN_TOUCH_LIMIT;
+
+					if (ret < 0)
+						dev_err(&rmi4_data->i2c_client->dev,
+							"%s: cpu first lock failed(%d)\n",
+							__func__, ret);
+				}
+
+				schedule_delayed_work(&rmi4_data->work_dvfs_chg,
+					msecs_to_jiffies(TOUCH_BOOSTER_CHG_TIME));
+
+				rmi4_data->dvfs_lock_status = true;
+			}
+		}
+	} else if (on < 0) {
+		if (rmi4_data->dvfs_lock_status) {
+			cancel_delayed_work(&rmi4_data->work_dvfs_off);
+			cancel_delayed_work(&rmi4_data->work_dvfs_chg);
+			schedule_work(&rmi4_data->work_dvfs_off.work);
+		}
+	}
+	rmi4_data->dvfs_old_stauts = on;
+	mutex_unlock(&rmi4_data->dvfs_lock);
+}
+
+static void synaptics_init_dvfs(struct synaptics_rmi4_data *rmi4_data)
+{
+	mutex_init(&rmi4_data->dvfs_lock);
+
+	rmi4_data->dvfs_boost_mode = DVFS_STAGE_DUAL;
+
+	INIT_DELAYED_WORK(&rmi4_data->work_dvfs_off, synaptics_set_dvfs_off);
+	INIT_DELAYED_WORK(&rmi4_data->work_dvfs_chg, synaptics_change_dvfs_lock);
+
+	rmi4_data->dvfs_lock_status = false;
+}
+#endif
+
+#ifdef PROXIMITY
+static ssize_t synaptics_rmi4_f51_enables_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	unsigned char hover_enables;
+	int retval;
+
+	if (!f51)
+		return -ENODEV;
+	retval = synaptics_rmi4_i2c_read(f51->rmi4_data,
+			f51->proximity_enables_addr,
+			&hover_enables,
+			sizeof(hover_enables));
+
+	dev_info(&f51->rmi4_data->i2c_client->dev, "%s: hover enables : %02x\n",
+				__func__, hover_enables);
+
+	return snprintf(buf, PAGE_SIZE, "0x%02x\n",
+			f51->proximity_enables);
+}
+
+static ssize_t synaptics_rmi4_f51_enables_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	int retval;
+	unsigned int input;
+	struct synaptics_rmi4_data *rmi4_data = dev_get_drvdata(dev);
+
+	if (!f51)
+		return -ENODEV;
+
+	if (sscanf(buf, "%x", &input) != 1)
+		return -EINVAL;
+
+	f51->proximity_enables = (unsigned char)input;
+
+	retval = synaptics_rmi4_i2c_write(rmi4_data,
+			f51->proximity_enables_addr,
+			&f51->proximity_enables,
+			sizeof(f51->proximity_enables));
+	if (retval < 0) {
+		dev_err(dev, "%s: Failed to write proximity enables, error = %d\n",
+				__func__, retval);
+		return retval;
+	}
+
+	return count;
+}
+#endif
+
+#ifdef CONFIG_GLOVE_TOUCH
+static ssize_t synaptics_rmi4_glove_enable_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct synaptics_rmi4_data *rmi4_data = dev_get_drvdata(dev);
+	unsigned char glove_enable = 0;
+	int retval;
+
+	retval = synaptics_rmi4_i2c_read(rmi4_data,
+			rmi4_data->glove_touch_addr,
+			&glove_enable,
+			sizeof(glove_enable));
+
+	dev_info(&rmi4_data->i2c_client->dev,
+			"%s: glove touch enable : 0x%x, %d\n",
+			__func__, glove_enable, retval);
+
+	return snprintf(buf, PAGE_SIZE, "glove touch enable =0x %x\n",
+			glove_enable);
+}
+
+int synaptics_rmi4_glove_mode_enables(struct synaptics_rmi4_data *rmi4_data)
+{
+	int retval;
+
+	if (GLOVE_FEATURE_EN != rmi4_data->glove_mode_feature) {
+		dev_err(&rmi4_data->i2c_client->dev,
+			"%s: Ver[%02X%02X%02X] FW does not support glove mode %02X\n",
+			__func__, rmi4_data->panel_revision, rmi4_data->ic_revision_of_ic,
+			rmi4_data->fw_version_of_ic, rmi4_data->glove_mode_feature);
+		return 0;
+	}
+
+	dev_info(&rmi4_data->i2c_client->dev, "%s: [%02X]: %s\n",
+		 __func__, rmi4_data->glove_mode_enables,
+		(rmi4_data->glove_mode_enables == 0x07) ? "fast glove & clear cover enable" :
+		(rmi4_data->glove_mode_enables == 0x06) ? "fast glove & flip cover enable" :
+		(rmi4_data->glove_mode_enables == 0x05) ? "only fast glove enable" :
+		(rmi4_data->glove_mode_enables == 0x03) ? "only clear cover enable" :
+		(rmi4_data->glove_mode_enables == 0x02) ? "only flip cover enable" :
+		(rmi4_data->glove_mode_enables == 0x01) ? "only glove enable" : "glove disable");
+
+	retval = synaptics_rmi4_i2c_write(rmi4_data,
+			rmi4_data->glove_mode_enables_addr,
+			&rmi4_data->glove_mode_enables,
+			sizeof(rmi4_data->glove_mode_enables));
+	if (retval < 0)
+		return retval;
+
+	return 0;
+}
+
+static int synaptics_rmi4_glove_mode_set(struct synaptics_rmi4_data *rmi4_data,
+		int mode, int enable)
+{
+	int retval = 0;
+	unsigned char glove_enable = 0;
+
+#if !defined(CONFIG_MACH_JACTIVE_EUR) && !defined(CONFIG_MACH_JACTIVE_ATT)
+	if (rmi4_data->panel_revision < OCTA_PANEL_REVISION_43) {
+		dev_info(&rmi4_data->i2c_client->dev,
+					"%s: do not support this FPCB version.\n", __func__);
+		return 0;
+	}
+#endif
+
+	retval = synaptics_rmi4_i2c_read(rmi4_data,
+			rmi4_data->glove_touch_addr,
+			&glove_enable,
+			sizeof(glove_enable));
+
+	if (retval <= 0)
+		glove_enable = rmi4_data->glove_mode_enables;
+
+	if (mode == 0x01) {
+		if (enable)
+			glove_enable |= 0x01;
+		else
+			glove_enable &= 0xFE;
+	} else if (mode == 0x02) {
+		if (enable)
+			glove_enable |= 0x02;
+		else
+			glove_enable &= 0xFD;
+	}
+
+	retval = synaptics_rmi4_i2c_write(rmi4_data,
+			rmi4_data->glove_touch_addr,
+			&glove_enable,
+			sizeof(glove_enable));
+
+	dev_info(&rmi4_data->i2c_client->dev,
+			"%s: %s, %s, retval = %d\n", __func__,
+			mode == 0x01 ? "glove mode" : mode == 0x02 ? "clear case mode" : "mode == 0x0",
+			enable ? "enable" : "disable", retval);
+
+	rmi4_data->glove_mode_enables = glove_enable;
+
+	return retval;
+
+}
+
+static ssize_t synaptics_rmi4_glove_enable_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct synaptics_rmi4_data *rmi4_data = dev_get_drvdata(dev);
+	unsigned int input;
+	int retval;
+
+	if (sscanf(buf, "%x", &input) != 1)
+		return -EINVAL;
+
+	retval = synaptics_rmi4_glove_mode_set(rmi4_data, 1, input);
+	if (retval < 0)
+		dev_info(&rmi4_data->i2c_client->dev,
+				"%s: glove touch enable failed (%d)\n",
+				__func__, retval);
+
+	return count;
+}
+
+static ssize_t synaptics_rmi4_show_device_status(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct synaptics_rmi4_data *rmi4_data = dev_get_drvdata(dev);
+	int retval;
+	unsigned char device_status = 0;
+
+	retval = synaptics_rmi4_i2c_read(rmi4_data,
+			rmi4_data->f01_ctrl_base_addr,
+			&device_status,
+			sizeof(device_status));
+
+	dev_info(&rmi4_data->i2c_client->dev,
+			"%s: retval = %d, device_status = %x\n",
+			__func__, retval, device_status);
+
+	return snprintf(buf, PAGE_SIZE, "device_status = %x\n",
+			device_status);
+}
+#endif
+
+static ssize_t synaptics_rmi4_f01_reset_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	int retval;
+	unsigned int reset;
+	struct synaptics_rmi4_data *rmi4_data = dev_get_drvdata(dev);
+
+	if (sscanf(buf, "%u", &reset) != 1)
+		return -EINVAL;
+
+	if (reset != 1)
+		return -EINVAL;
+
+	retval = synaptics_rmi4_reset_device(rmi4_data);
+	if (retval < 0) {
+		dev_err(dev,
+				"%s: Failed to issue reset command, error = %d\n",
+				__func__, retval);
+		return retval;
+	}
+
+	return count;
+}
+
+static ssize_t synaptics_rmi4_f01_productinfo_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct synaptics_rmi4_data *rmi4_data = dev_get_drvdata(dev);
+
+	return snprintf(buf, PAGE_SIZE, "0x%02x 0x%02x\n",
+			(rmi4_data->rmi4_mod_info.product_info[0]),
+			(rmi4_data->rmi4_mod_info.product_info[1]));
+}
+
+static ssize_t synaptics_rmi4_f01_buildid_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	unsigned int build_id;
+	struct synaptics_rmi4_data *rmi4_data = dev_get_drvdata(dev);
+	struct synaptics_rmi4_device_info *rmi;
+
+	rmi = &(rmi4_data->rmi4_mod_info);
+
+	build_id = (unsigned int)rmi->build_id[0] +
+			(unsigned int)rmi->build_id[1] * 0x100 +
+			(unsigned int)rmi->build_id[2] * 0x10000;
+
+	return snprintf(buf, PAGE_SIZE, "%u\n",
+			build_id);
+}
+
+static ssize_t synaptics_rmi4_f01_flashprog_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	int retval;
+	struct synaptics_rmi4_f01_device_status device_status;
+	struct synaptics_rmi4_data *rmi4_data = dev_get_drvdata(dev);
+
+	retval = synaptics_rmi4_i2c_read(rmi4_data,
+			rmi4_data->f01_data_base_addr,
+			device_status.data,
+			sizeof(device_status.data));
+	if (retval < 0) {
+		dev_err(dev,
+				"%s: Failed to read device status, error = %d\n",
+				__func__, retval);
+		return retval;
+	}
+
+	return snprintf(buf, PAGE_SIZE, "%u\n",
+			device_status.flash_prog);
+}
+
+static ssize_t synaptics_rmi4_0dbutton_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct synaptics_rmi4_data *rmi4_data = dev_get_drvdata(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%u\n",
+			rmi4_data->button_0d_enabled);
+}
+
+static ssize_t synaptics_rmi4_0dbutton_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	int retval;
+	unsigned int input;
+	unsigned char ii;
+	unsigned char intr_enable;
+	struct synaptics_rmi4_fn *fhandler;
+	struct synaptics_rmi4_data *rmi4_data = dev_get_drvdata(dev);
+	struct synaptics_rmi4_device_info *rmi;
+
+	rmi = &(rmi4_data->rmi4_mod_info);
+
+	if (sscanf(buf, "%u", &input) != 1)
+		return -EINVAL;
+
+	input = input > 0 ? 1 : 0;
+
+	if (rmi4_data->button_0d_enabled == input)
+		return count;
+
+	if (list_empty(&rmi->support_fn_list))
+		return -ENODEV;
+
+	list_for_each_entry(fhandler, &rmi->support_fn_list, link) {
+		if (fhandler->fn_number == SYNAPTICS_RMI4_F1A) {
+			ii = fhandler->intr_reg_num;
+
+			retval = synaptics_rmi4_i2c_read(rmi4_data,
+					rmi4_data->f01_ctrl_base_addr + 1 + ii,
+					&intr_enable,
+					sizeof(intr_enable));
+			if (retval < 0)
+				return retval;
+
+			if (input == 1)
+				intr_enable |= fhandler->intr_mask;
+			else
+				intr_enable &= ~fhandler->intr_mask;
+
+			retval = synaptics_rmi4_i2c_write(rmi4_data,
+					rmi4_data->f01_ctrl_base_addr + 1 + ii,
+					&intr_enable,
+					sizeof(intr_enable));
+			if (retval < 0)
+				return retval;
+		}
+	}
+
+	rmi4_data->button_0d_enabled = input;
+
+	return count;
+}
+
+ /**
+ * synaptics_rmi4_set_page()
+ *
+ * Called by synaptics_rmi4_i2c_read() and synaptics_rmi4_i2c_write().
+ *
+ * This function writes to the page select register to switch to the
+ * assigned page.
+ */
+static int synaptics_rmi4_set_page(struct synaptics_rmi4_data *rmi4_data,
+		unsigned int address)
+{
+	int retval = 0;
+	unsigned char retry;
+	unsigned char buf[PAGE_SELECT_LEN];
+	unsigned char page;
+	struct i2c_client *i2c = rmi4_data->i2c_client;
+
+	page = ((address >> 8) & MASK_8BIT);
+	if (page != rmi4_data->current_page) {
+		buf[0] = MASK_8BIT;
+		buf[1] = page;
+		for (retry = 0; retry < SYN_I2C_RETRY_TIMES; retry++) {
+			retval = i2c_master_send(i2c, buf, PAGE_SELECT_LEN);
+			if (retval != PAGE_SELECT_LEN) {
+				dev_err(&i2c->dev,
+						"%s: I2C retry %d\n",
+						__func__, retry + 1);
+				msleep(20);
+			} else {
+				rmi4_data->current_page = page;
+				break;
+			}
+		}
+	} else {
+		retval = PAGE_SELECT_LEN;
+	}
+
+	return retval;
+}
+
+ /**
+ * synaptics_rmi4_i2c_read()
+ *
+ * Called by various functions in this driver, and also exported to
+ * other expansion Function modules such as rmi_dev.
+ *
+ * This function reads data of an arbitrary length from the sensor,
+ * starting from an assigned register address of the sensor, via I2C
+ * with a retry mechanism.
+ */
+static int synaptics_rmi4_i2c_read(struct synaptics_rmi4_data *rmi4_data,
+		unsigned short addr, unsigned char *data, unsigned short length)
+{
+	int retval;
+	unsigned char retry;
+	unsigned char buf;
+	struct i2c_msg msg[] = {
+		{
+			.addr = rmi4_data->i2c_client->addr,
+			.flags = 0,
+			.len = 1,
+			.buf = &buf,
+		},
+		{
+			.addr = rmi4_data->i2c_client->addr,
+			.flags = I2C_M_RD,
+			.len = length,
+			.buf = data,
+		},
+	};
+
+	buf = addr & MASK_8BIT;
+
+	mutex_lock(&(rmi4_data->rmi4_io_ctrl_mutex));
+
+	if (rmi4_data->touch_stopped) {
+		dev_err(&rmi4_data->i2c_client->dev, "%s: Sensor stopped\n",
+				__func__);
+		retval = 0;
+		goto exit;
+	}
+
+	retval = synaptics_rmi4_set_page(rmi4_data, addr);
+	if (retval != PAGE_SELECT_LEN)
+		goto exit;
+
+	for (retry = 0; retry < SYN_I2C_RETRY_TIMES; retry++) {
+		if (i2c_transfer(rmi4_data->i2c_client->adapter, msg, 2) == 2) {
+			retval = length;
+			break;
+		}
+		dev_err(&rmi4_data->i2c_client->dev, "%s: I2C retry %d\n",
+				__func__, retry + 1);
+		msleep(20);
+	}
+
+	if (retry == SYN_I2C_RETRY_TIMES) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: I2C read over retry limit\n",
+				__func__);
+		retval = -EIO;
+	}
+
+exit:
+	mutex_unlock(&(rmi4_data->rmi4_io_ctrl_mutex));
+
+	return retval;
+}
+
+ /**
+ * synaptics_rmi4_i2c_write()
+ *
+ * Called by various functions in this driver, and also exported to
+ * other expansion Function modules such as rmi_dev.
+ *
+ * This function writes data of an arbitrary length to the sensor,
+ * starting from an assigned register address of the sensor, via I2C with
+ * a retry mechanism.
+ */
+static int synaptics_rmi4_i2c_write(struct synaptics_rmi4_data *rmi4_data,
+		unsigned short addr, unsigned char *data, unsigned short length)
+{
+	int retval;
+	unsigned char retry;
+	unsigned char buf[length + 1];
+	struct i2c_msg msg[] = {
+		{
+			.addr = rmi4_data->i2c_client->addr,
+			.flags = 0,
+			.len = length + 1,
+			.buf = buf,
+		}
+	};
+
+	mutex_lock(&(rmi4_data->rmi4_io_ctrl_mutex));
+
+	if (rmi4_data->touch_stopped) {
+		dev_err(&rmi4_data->i2c_client->dev, "%s: Sensor stopped\n",
+				__func__);
+		retval = 0;
+		goto exit;
+	}
+
+	retval = synaptics_rmi4_set_page(rmi4_data, addr);
+	if (retval != PAGE_SELECT_LEN)
+		goto exit;
+
+	buf[0] = addr & MASK_8BIT;
+	memcpy(&buf[1], &data[0], length);
+
+	for (retry = 0; retry < SYN_I2C_RETRY_TIMES; retry++) {
+		if (i2c_transfer(rmi4_data->i2c_client->adapter, msg, 1) == 1) {
+			retval = length;
+			break;
+		}
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: I2C retry %d\n",
+				__func__, retry + 1);
+		msleep(20);
+	}
+
+	if (retry == SYN_I2C_RETRY_TIMES) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: I2C write over retry limit\n",
+				__func__);
+		retval = -EIO;
+	}
+
+exit:
+	mutex_unlock(&(rmi4_data->rmi4_io_ctrl_mutex));
+
+	return retval;
+}
+
+ /**
+ * synaptics_rmi4_f11_abs_report()
+ *
+ * Called by synaptics_rmi4_report_touch() when valid Function $11
+ * finger data has been detected.
+ *
+ * This function reads the Function $11 data registers, determines the
+ * status of each finger supported by the Function, processes any
+ * necessary coordinate manipulation, reports the finger data to
+ * the input subsystem, and returns the number of fingers detected.
+ */
+static int synaptics_rmi4_f11_abs_report(struct synaptics_rmi4_data *rmi4_data,
+		struct synaptics_rmi4_fn *fhandler)
+{
+	int retval;
+	unsigned char touch_count = 0; /* number of touch points */
+	unsigned char reg_index;
+	unsigned char finger;
+	unsigned char fingers_supported;
+	unsigned char num_of_finger_status_regs;
+	unsigned char finger_shift;
+	unsigned char finger_status;
+	unsigned char data_reg_blk_size;
+	unsigned char finger_status_reg[3];
+	unsigned char data[F11_STD_DATA_LEN];
+	unsigned short data_addr;
+	unsigned short data_offset;
+	int x;
+	int y;
+	int wx;
+	int wy;
+
+	/*
+	 * The number of finger status registers is determined by the
+	 * maximum number of fingers supported - 2 bits per finger. So
+	 * the number of finger status registers to read is:
+	 * register_count = ceil(max_num_of_fingers / 4)
+	 */
+	fingers_supported = fhandler->num_of_data_points;
+	num_of_finger_status_regs = (fingers_supported + 3) / 4;
+	data_addr = fhandler->full_addr.data_base;
+	data_reg_blk_size = fhandler->size_of_data_register_block;
+
+	retval = synaptics_rmi4_i2c_read(rmi4_data,
+			data_addr,
+			finger_status_reg,
+			num_of_finger_status_regs);
+	if (retval < 0)
+		return 0;
+
+	for (finger = 0; finger < fingers_supported; finger++) {
+		reg_index = finger / 4;
+		finger_shift = (finger % 4) * 2;
+		finger_status = (finger_status_reg[reg_index] >> finger_shift)
+				& MASK_2BIT;
+
+		/*
+		 * Each 2-bit finger status field represents the following:
+		 * 00 = finger not present
+		 * 01 = finger present and data accurate
+		 * 10 = finger present but data may be inaccurate
+		 * 11 = reserved
+		 */
+#ifdef TYPE_B_PROTOCOL
+		input_mt_slot(rmi4_data->input_dev, finger);
+		input_mt_report_slot_state(rmi4_data->input_dev,
+				MT_TOOL_FINGER, finger_status);
+#endif
+
+		if (finger_status) {
+			data_offset = data_addr +
+					num_of_finger_status_regs +
+					(finger * data_reg_blk_size);
+			retval = synaptics_rmi4_i2c_read(rmi4_data,
+					data_offset,
+					data,
+					data_reg_blk_size);
+			if (retval < 0)
+				return 0;
+
+			x = (data[0] << 4) | (data[2] & MASK_4BIT);
+			y = (data[1] << 4) | ((data[2] >> 4) & MASK_4BIT);
+			wx = (data[3] & MASK_4BIT);
+			wy = (data[3] >> 4) & MASK_4BIT;
+
+			if (rmi4_data->board->x_flip)
+				x = rmi4_data->sensor_max_x - x;
+			if (rmi4_data->board->y_flip)
+				y = rmi4_data->sensor_max_y - y;
+
+			input_report_key(rmi4_data->input_dev,
+					BTN_TOUCH, 1);
+			input_report_key(rmi4_data->input_dev,
+					BTN_TOOL_FINGER, 1);
+			input_report_abs(rmi4_data->input_dev,
+					ABS_MT_POSITION_X, x);
+			input_report_abs(rmi4_data->input_dev,
+					ABS_MT_POSITION_Y, y);
+#ifdef REPORT_2D_W
+			input_report_abs(rmi4_data->input_dev,
+					ABS_MT_TOUCH_MAJOR, max(wx, wy));
+			input_report_abs(rmi4_data->input_dev,
+					ABS_MT_TOUCH_MINOR, min(wx, wy));
+#endif
+#ifndef TYPE_B_PROTOCOL
+			input_mt_sync(rmi4_data->input_dev);
+#endif
+
+			dev_dbg(&rmi4_data->i2c_client->dev,
+					"%s: Finger %d:\n"
+					"status = 0x%02x\n"
+					"x = %d\n"
+					"y = %d\n"
+					"wx = %d\n"
+					"wy = %d\n",
+					__func__, finger,
+					finger_status,
+					x, y, wx, wy);
+
+			touch_count++;
+		}
+	}
+
+#ifndef TYPE_B_PROTOCOL
+	if (touch_count == 0)
+		input_mt_sync(rmi4_data->input_dev);
+#endif
+
+	input_sync(rmi4_data->input_dev);
+
+	return touch_count;
+}
+
+ /**
+ * synaptics_rmi4_f12_abs_report()
+ *
+ * Called by synaptics_rmi4_report_touch() when valid Function $12
+ * finger data has been detected.
+ *
+ * This function reads the Function $12 data registers, determines the
+ * status of each finger supported by the Function, processes any
+ * necessary coordinate manipulation, reports the finger data to
+ * the input subsystem, and returns the number of fingers detected.
+ */
+static int synaptics_rmi4_f12_abs_report(struct synaptics_rmi4_data *rmi4_data,
+		struct synaptics_rmi4_fn *fhandler)
+{
+	int retval;
+	unsigned char touch_count = 0; /* number of touch points */
+	unsigned char finger;
+	unsigned char fingers_supported;
+	unsigned char finger_status;
+	unsigned short data_addr;
+	int x;
+	int y;
+	int wx;
+	int wy;
+	struct synaptics_rmi4_f12_finger_data *data;
+	struct synaptics_rmi4_f12_finger_data *finger_data;
+
+	fingers_supported = fhandler->num_of_data_points;
+	data_addr = fhandler->full_addr.data_base;
+
+	retval = synaptics_rmi4_i2c_read(rmi4_data,
+			data_addr + fhandler->data1_offset,
+			(unsigned char *)fhandler->data,
+			fhandler->data_size);
+	if (retval < 0)
+		return 0;
+
+	data = (struct synaptics_rmi4_f12_finger_data *)fhandler->data;
+
+	for (finger = 0; finger < fingers_supported; finger++) {
+		finger_data = data + finger;
+		finger_status = finger_data->object_type_and_status;
+
+		/*
+		 * Each 3-bit finger status field represents the following:
+		 * 000 = finger not present
+		 * 001 = finger present and data accurate
+		 * 010 = finger present but data may be inaccurate
+		 * 011 = palm
+		 * 100 = glove touch
+		 */
+/* if reject finger status 0x03, do not work screen capture. */
+/*
+		if (0x03 == finger_status)
+			continue;
+*/
+#ifdef TYPE_B_PROTOCOL
+		input_mt_slot(rmi4_data->input_dev, finger);
+		input_mt_report_slot_state(rmi4_data->input_dev,
+				MT_TOOL_FINGER, finger_status);
+#endif
+
+		if (finger_status) {
+#ifdef CONFIG_GLOVE_TOUCH
+			if ((finger_status == 0x06) &&
+				!rmi4_data->touchkey_glove_mode_status) {
+				rmi4_data->touchkey_glove_mode_status = true;
+				input_report_switch(rmi4_data->input_dev,
+					SW_GLOVE, true);
+			} else if ((finger_status != 0x06) &&
+				rmi4_data->touchkey_glove_mode_status) {
+				rmi4_data->touchkey_glove_mode_status = false;
+				input_report_switch(rmi4_data->input_dev,
+					SW_GLOVE, false);
+			}
+#endif
+			x = (finger_data->x_msb << 8) | (finger_data->x_lsb);
+			y = (finger_data->y_msb << 8) | (finger_data->y_lsb);
+#ifdef REPORT_2D_W
+			wx = finger_data->wx;
+			wy = finger_data->wy;
+#ifdef EDGE_SWIPE
+			if (f51) {
+#if defined(CONFIG_MACH_JACTIVE_ATT)
+				if (f51->proximity_controls & HAS_EDGE_SWIPE) {
+#else
+				if ((f51->proximity_controls & HAS_EDGE_SWIPE)
+					&& f51->surface_data.palm) {
+#endif
+					wx = f51->surface_data.wx;
+					wy = f51->surface_data.wy;
+				}
+			}
+#endif
+#endif
+			if (rmi4_data->board->x_flip)
+				x = rmi4_data->sensor_max_x - x;
+			if (rmi4_data->board->y_flip)
+				y = rmi4_data->sensor_max_y - y;
+
+			input_report_key(rmi4_data->input_dev,
+					BTN_TOUCH, 1);
+			input_report_key(rmi4_data->input_dev,
+					BTN_TOOL_FINGER, 1);
+			input_report_abs(rmi4_data->input_dev,
+					ABS_MT_POSITION_X, x);
+			input_report_abs(rmi4_data->input_dev,
+					ABS_MT_POSITION_Y, y);
+#ifdef REPORT_2D_W
+			input_report_abs(rmi4_data->input_dev,
+					ABS_MT_TOUCH_MAJOR, max(wx, wy));
+			input_report_abs(rmi4_data->input_dev,
+					ABS_MT_TOUCH_MINOR, min(wx, wy));
+#endif
+#ifdef EDGE_SWIPE
+			if (f51) {
+				if (f51->proximity_controls & HAS_EDGE_SWIPE) {
+					input_report_abs(rmi4_data->input_dev,
+							ABS_MT_WIDTH_MAJOR, f51->surface_data.width_major);
+					input_report_abs(rmi4_data->input_dev,
+							ABS_MT_ANGLE, f51->surface_data.angle);
+					input_report_abs(rmi4_data->input_dev,
+							ABS_MT_PALM, f51->surface_data.palm);
+				}
+			}
+#endif
+#ifndef TYPE_B_PROTOCOL
+			input_mt_sync(rmi4_data->input_dev);
+#endif
+
+			if (!rmi4_data->finger[finger].state)
+				dev_info(&rmi4_data->i2c_client->dev, "[%d][P] 0x%02x\n",
+					finger, finger_status);
+			else
+				rmi4_data->finger[finger].mcount++;
+
+			touch_count++;
+		}
+
+		if (rmi4_data->finger[finger].state && !finger_status) {
+			dev_info(&rmi4_data->i2c_client->dev, "[%d][R] 0x%02x M[%d] V[%x]\n",
+				finger, finger_status, rmi4_data->finger[finger].mcount,
+				rmi4_data->fw_version_of_ic);
+
+			rmi4_data->finger[finger].mcount = 0;
+		}
+
+		rmi4_data->finger[finger].state = finger_status;
+	}
+
+
+	if (touch_count == 0) {
+		/* Clear BTN_TOUCH when All touch are released  */
+		input_report_key(rmi4_data->input_dev,
+				BTN_TOUCH, 0);
+#ifndef TYPE_B_PROTOCOL
+		input_mt_sync(rmi4_data->input_dev);
+#endif
+	}
+
+	input_sync(rmi4_data->input_dev);
+
+#ifdef TSP_BOOSTER
+	if (touch_count)
+		synaptics_set_dvfs_lock(rmi4_data, touch_count);
+	else
+		synaptics_set_dvfs_lock(rmi4_data, 0);
+#endif
+	return touch_count;
+}
+
+static void synaptics_rmi4_f1a_report(struct synaptics_rmi4_data *rmi4_data,
+		struct synaptics_rmi4_fn *fhandler)
+{
+	int retval;
+	unsigned char touch_count = 0;
+	unsigned char button;
+	unsigned char index;
+	unsigned char shift;
+	unsigned char status;
+	unsigned char *data;
+	unsigned short data_addr = fhandler->full_addr.data_base;
+	struct synaptics_rmi4_f1a_handle *f1a = fhandler->data;
+	static unsigned char do_once = 1;
+	static bool current_status[MAX_NUMBER_OF_BUTTONS];
+#ifdef NO_0D_WHILE_2D
+	static bool before_2d_status[MAX_NUMBER_OF_BUTTONS];
+	static bool while_2d_status[MAX_NUMBER_OF_BUTTONS];
+#endif
+
+	if (do_once) {
+		memset(current_status, 0, sizeof(current_status));
+#ifdef NO_0D_WHILE_2D
+		memset(before_2d_status, 0, sizeof(before_2d_status));
+		memset(while_2d_status, 0, sizeof(while_2d_status));
+#endif
+		do_once = 0;
+	}
+
+	retval = synaptics_rmi4_i2c_read(rmi4_data,
+			data_addr,
+			f1a->button_data_buffer,
+			f1a->button_bitmask_size);
+	if (retval < 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to read button data registers\n",
+				__func__);
+		return;
+	}
+
+	data = f1a->button_data_buffer;
+
+	for (button = 0; button < f1a->valid_button_count; button++) {
+		index = button / 8;
+		shift = button % 8;
+		status = ((data[index] >> shift) & MASK_1BIT);
+
+		if (current_status[button] == status)
+			continue;
+		else
+			current_status[button] = status;
+
+		dev_dbg(&rmi4_data->i2c_client->dev,
+				"%s: Button %d (code %d) ->%d\n",
+				__func__, button,
+				f1a->button_map[button],
+				status);
+#ifdef NO_0D_WHILE_2D
+		if (rmi4_data->fingers_on_2d == false) {
+			if (status == 1) {
+				before_2d_status[button] = 1;
+			} else {
+				if (while_2d_status[button] == 1) {
+					while_2d_status[button] = 0;
+					continue;
+				} else {
+					before_2d_status[button] = 0;
+				}
+			}
+			touch_count++;
+			input_report_key(rmi4_data->input_dev,
+					f1a->button_map[button],
+					status);
+		} else {
+			if (before_2d_status[button] == 1) {
+				before_2d_status[button] = 0;
+				touch_count++;
+				input_report_key(rmi4_data->input_dev,
+						f1a->button_map[button],
+						status);
+			} else {
+				if (status == 1)
+					while_2d_status[button] = 1;
+				else
+					while_2d_status[button] = 0;
+			}
+		}
+#else
+		touch_count++;
+		input_report_key(rmi4_data->input_dev,
+				f1a->button_map[button],
+				status);
+#endif
+	}
+
+	if (touch_count)
+		input_sync(rmi4_data->input_dev);
+
+	return;
+}
+
+#ifdef PROXIMITY
+#ifdef EDGE_SWIPE
+static int synaptics_rmi4_f51_edge_swipe(struct synaptics_rmi4_data *rmi4_data,
+		struct synaptics_rmi4_fn *fhandler)
+{
+	int retval;
+	unsigned short data_base_addr;
+	struct synaptics_rmi4_f51_data *data;
+
+	data_base_addr = fhandler->full_addr.data_base;
+	data = (struct synaptics_rmi4_f51_data *)fhandler->data;
+
+	retval = synaptics_rmi4_i2c_read(rmi4_data,
+			data_base_addr + EDGE_SWIPE_DATA_OFFSET,
+			data->edge_swipe_data,
+			sizeof(data->edge_swipe_data));
+
+	if (retval < 0)
+		return retval;
+
+	if (!f51)
+		return -ENODEV;
+
+	if (data->edge_swipe_dg >= 90 && data->edge_swipe_dg <= 180)
+#if defined(CONFIG_MACH_JACTIVE_EUR) || defined(CONFIG_MACH_JACTIVE_ATT)
+		f51->surface_data.angle = data->edge_swipe_dg - 90;
+#else
+		f51->surface_data.angle = data->edge_swipe_dg - 180;
+#endif
+	else if (data->edge_swipe_dg < 90)
+#if defined(CONFIG_MACH_JACTIVE_EUR) || defined(CONFIG_MACH_JACTIVE_ATT)
+		f51->surface_data.angle = 90 - data->edge_swipe_dg;
+#else
+		f51->surface_data.angle = data->edge_swipe_dg;
+#endif
+	else
+		dev_err(&rmi4_data->i2c_client->dev,
+				"Skip wrong edge swipe angle [%d]\n",
+				data->edge_swipe_dg);
+
+	f51->surface_data.width_major = data->edge_swipe_mm;
+	f51->surface_data.wx = data->edge_swipe_wx;
+	f51->surface_data.wy = data->edge_swipe_wy;
+	f51->surface_data.palm = data->edge_swipe_z;
+
+	dev_dbg(&rmi4_data->i2c_client->dev,
+		"%s: edge_data : x[%d], y[%d], z[%d] ,wx[%d], wy[%d], area[%d], angle[%d][%d]\n", __func__,
+		data->edge_swipe_x_msb << 8 | data->edge_swipe_x_lsb,
+		data->edge_swipe_y_msb << 8 | data->edge_swipe_y_lsb,
+		data->edge_swipe_z, data->edge_swipe_wx, data->edge_swipe_wy,
+		data->edge_swipe_mm, data->edge_swipe_dg, f51->surface_data.angle);
+
+	return retval;
+}
+#endif
+
+static void synaptics_rmi4_f51_report(struct synaptics_rmi4_data *rmi4_data,
+		struct synaptics_rmi4_fn *fhandler)
+{
+	int retval;
+	unsigned short data_base_addr;
+	int x;
+	int y;
+	int z;
+	struct synaptics_rmi4_f51_data *data;
+
+#ifdef EDGE_SWIPE
+	/* Read edge swipe data */
+	if (f51->proximity_controls & HAS_EDGE_SWIPE) {
+		retval = synaptics_rmi4_f51_edge_swipe(rmi4_data, fhandler);
+		if (retval < 0) {
+			dev_err(&rmi4_data->i2c_client->dev,
+					"%s: Failed to read edge swipe data\n",
+					__func__);
+			return;
+		}
+	}
+#endif
+
+	data_base_addr = fhandler->full_addr.data_base;
+	data = (struct synaptics_rmi4_f51_data *)fhandler->data;
+
+	retval = synaptics_rmi4_i2c_read(rmi4_data,
+			data_base_addr,
+			data->proximity_data,
+			sizeof(data->proximity_data));
+	if (retval < 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to read proximity data registers\n",
+				__func__);
+		return;
+	}
+
+	if (data->proximity_data[0] == 0x00)
+		return;
+
+	if (data->finger_hover_det && (data->hover_finger_z > 0)) {
+		x = (data->hover_finger_x_4__11 << 4) |
+				(data->hover_finger_xy_0__3 & 0x0f);
+		y = (data->hover_finger_y_4__11 << 4) |
+				(data->hover_finger_xy_0__3 >> 4);
+		z = HOVER_Z_MAX - data->hover_finger_z;
+
+#ifdef TYPE_B_PROTOCOL
+		input_mt_slot(rmi4_data->input_dev, 0);
+		input_mt_report_slot_state(rmi4_data->input_dev,
+				MT_TOOL_FINGER, 1);
+#endif
+		input_report_key(rmi4_data->input_dev,
+				BTN_TOUCH, 0);
+		input_report_key(rmi4_data->input_dev,
+				BTN_TOOL_FINGER, 1);
+		input_report_abs(rmi4_data->input_dev,
+				ABS_MT_POSITION_X, x);
+		input_report_abs(rmi4_data->input_dev,
+				ABS_MT_POSITION_Y, y);
+		input_report_abs(rmi4_data->input_dev,
+				ABS_MT_DISTANCE, z);
+
+#ifndef TYPE_B_PROTOCOL
+		input_mt_sync(rmi4_data->input_dev);
+#endif
+		input_sync(rmi4_data->input_dev);
+/*
+		dev_info(&rmi4_data->i2c_client->dev,
+				"%s: Hover finger: x = %d, y = %d, z = %d\n" ,__func__, x, y, z);
+*/
+		rmi4_data->f51_finger = true;
+		rmi4_data->fingers_on_2d = false;
+		synaptics_rmi4_f51_finger_timer((unsigned long)rmi4_data);
+	}
+
+	if (data->air_swipe_det) {
+		dev_dbg(&rmi4_data->i2c_client->dev,
+				"%s: Swipe direction 0 = %d\n",
+				__func__, data->air_swipe_dir_0);
+		dev_dbg(&rmi4_data->i2c_client->dev,
+				"%s: Swipe direction 1 = %d\n",
+				__func__, data->air_swipe_dir_1);
+	}
+
+	if (data->large_obj_det) {
+		dev_dbg(&rmi4_data->i2c_client->dev,
+				"%s: Large object activity = %d\n",
+				__func__, data->large_obj_act);
+	}
+/*
+	if (data->hover_pinch_det) {
+		dev_dbg(&rmi4_data->i2c_client->dev,
+				"%s: Hover pinch direction = %d\n",
+				__func__, data->hover_pinch_dir);
+	}
+*/
+	if (data->object_present) {
+		dev_dbg(&rmi4_data->i2c_client->dev,
+				"%s: Object presence detected\n",
+				__func__);
+	}
+
+	return;
+}
+#endif
+
+ /**
+ * synaptics_rmi4_report_touch()
+ *
+ * Called by synaptics_rmi4_sensor_report().
+ *
+ * This function calls the appropriate finger data reporting function
+ * based on the function handler it receives and returns the number of
+ * fingers detected.
+ */
+static void synaptics_rmi4_report_touch(struct synaptics_rmi4_data *rmi4_data,
+		struct synaptics_rmi4_fn *fhandler)
+{
+	unsigned char touch_count_2d;
+
+	dev_dbg(&rmi4_data->i2c_client->dev,
+			"%s: Function %02x reporting\n",
+			__func__, fhandler->fn_number);
+
+	switch (fhandler->fn_number) {
+	case SYNAPTICS_RMI4_F11:
+		touch_count_2d = synaptics_rmi4_f11_abs_report(rmi4_data,
+				fhandler);
+
+		if (touch_count_2d)
+			rmi4_data->fingers_on_2d = true;
+		else
+			rmi4_data->fingers_on_2d = false;
+		break;
+	case SYNAPTICS_RMI4_F12:
+		touch_count_2d = synaptics_rmi4_f12_abs_report(rmi4_data,
+				fhandler);
+
+		if (touch_count_2d)
+			rmi4_data->fingers_on_2d = true;
+		else
+			rmi4_data->fingers_on_2d = false;
+		break;
+	case SYNAPTICS_RMI4_F1A:
+		synaptics_rmi4_f1a_report(rmi4_data, fhandler);
+		break;
+#ifdef PROXIMITY
+	case SYNAPTICS_RMI4_F51:
+		synaptics_rmi4_f51_report(rmi4_data, fhandler);
+		break;
+#endif
+	default:
+		break;
+	}
+
+	return;
+}
+
+ /**
+ * synaptics_rmi4_sensor_report()
+ *
+ * Called by synaptics_rmi4_irq().
+ *
+ * This function determines the interrupt source(s) from the sensor
+ * and calls synaptics_rmi4_report_touch() with the appropriate
+ * function handler for each function with valid data inputs.
+ */
+static int synaptics_rmi4_sensor_report(struct synaptics_rmi4_data *rmi4_data)
+{
+	int retval;
+	unsigned char data[MAX_INTR_REGISTERS + 1];
+	unsigned char *intr = &data[1];
+	struct synaptics_rmi4_f01_device_status status;
+	struct synaptics_rmi4_fn *fhandler;
+	struct synaptics_rmi4_exp_fn *exp_fhandler;
+	struct synaptics_rmi4_device_info *rmi;
+
+	rmi = &(rmi4_data->rmi4_mod_info);
+
+	/*
+	 * Get interrupt status information from F01 Data1 register to
+	 * determine the source(s) that are flagging the interrupt.
+	 */
+	retval = synaptics_rmi4_i2c_read(rmi4_data,
+			rmi4_data->f01_data_base_addr,
+			data,
+			rmi4_data->num_of_intr_regs + 1);
+	if (retval < 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to read interrupt status\n",
+				__func__);
+		return retval;
+	}
+
+	status.data[0] = data[0];
+	if (status.unconfigured) {
+		if (rmi4_data->doing_reflash) {
+			dev_err(&rmi4_data->i2c_client->dev,
+				"Spontaneous reset detected during reflash.\n");
+			return 0;
+		}
+
+		dev_info(&rmi4_data->i2c_client->dev,
+			"Spontaneous reset detected\n");
+		retval = synaptics_rmi4_reinit_device(rmi4_data);
+		if (retval < 0) {
+			dev_err(&rmi4_data->i2c_client->dev,
+					"%s: Failed to reinit device\n",
+					__func__);
+		}
+		return 0;
+	}
+
+	/*
+	 * Traverse the function handler list and service the source(s)
+	 * of the interrupt accordingly.
+	 */
+	if (!list_empty(&rmi->support_fn_list)) {
+		list_for_each_entry(fhandler, &rmi->support_fn_list, link) {
+			if (fhandler->num_of_data_sources) {
+				if (fhandler->intr_mask &
+						intr[fhandler->intr_reg_num]) {
+					synaptics_rmi4_report_touch(rmi4_data,
+							fhandler);
+				}
+			}
+		}
+	}
+
+	if (!list_empty(&exp_fn_list)) {
+		list_for_each_entry(exp_fhandler, &exp_fn_list, link) {
+			if (exp_fhandler->func_attn != NULL)
+				exp_fhandler->func_attn(rmi4_data, intr[0]);
+		}
+	}
+
+	return 0;
+}
+
+ /**
+ * synaptics_rmi4_irq()
+ *
+ * Called by the kernel when an interrupt occurs (when the sensor
+ * asserts the attention irq).
+ *
+ * This function is the ISR thread and handles the acquisition
+ * and the reporting of finger data when the presence of fingers
+ * is detected.
+ */
+static irqreturn_t synaptics_rmi4_irq(int irq, void *data)
+{
+	int retval;
+	struct synaptics_rmi4_data *rmi4_data = data;
+
+	do {
+		retval = synaptics_rmi4_sensor_report(rmi4_data);
+		if (retval < 0) {
+			dev_err(&rmi4_data->i2c_client->dev, "%s: Failed to read",
+				__func__);
+			goto out;
+		}
+
+		if (!rmi4_data->touch_stopped)
+			goto out;
+
+	} while (!gpio_get_value(rmi4_data->board->gpio));
+
+out:
+	return IRQ_HANDLED;
+}
+
+ /**
+ * synaptics_rmi4_irq_enable()
+ *
+ * Called by synaptics_rmi4_probe() and the power management functions
+ * in this driver and also exported to other expansion Function modules
+ * such as rmi_dev.
+ *
+ * This function handles the enabling and disabling of the attention
+ * irq including the setting up of the ISR thread.
+ */
+static int synaptics_rmi4_irq_enable(struct synaptics_rmi4_data *rmi4_data,
+		bool enable)
+{
+	int retval = 0;
+	unsigned char intr_status;
+	const struct synaptics_rmi4_platform_data *platform_data =
+			rmi4_data->i2c_client->dev.platform_data;
+
+	if (enable) {
+		if (rmi4_data->irq_enabled)
+			return retval;
+
+		/* Clear interrupts first */
+		retval = synaptics_rmi4_i2c_read(rmi4_data,
+				rmi4_data->f01_data_base_addr + 1,
+				&intr_status,
+				rmi4_data->num_of_intr_regs);
+		if (retval < 0)
+			return retval;
+
+		retval = request_threaded_irq(rmi4_data->irq, NULL,
+				synaptics_rmi4_irq, platform_data->irq_type,
+				DRIVER_NAME, rmi4_data);
+		if (retval < 0) {
+			dev_err(&rmi4_data->i2c_client->dev,
+					"%s: Failed to create irq thread\n",
+					__func__);
+			return retval;
+		}
+
+		rmi4_data->irq_enabled = true;
+	} else {
+		if (rmi4_data->irq_enabled) {
+			disable_irq(rmi4_data->irq);
+			free_irq(rmi4_data->irq, rmi4_data);
+			rmi4_data->irq_enabled = false;
+		}
+	}
+
+	return retval;
+}
+
+ /**
+ * synaptics_rmi4_f11_init()
+ *
+ * Called by synaptics_rmi4_query_device().
+ *
+ * This funtion parses information from the Function 11 registers
+ * and determines the number of fingers supported, x and y data ranges,
+ * offset to the associated interrupt status register, interrupt bit
+ * mask, and gathers finger data acquisition capabilities from the query
+ * registers.
+ */
+static int synaptics_rmi4_f11_init(struct synaptics_rmi4_data *rmi4_data,
+		struct synaptics_rmi4_fn *fhandler,
+		struct synaptics_rmi4_fn_desc *fd,
+		unsigned int intr_count)
+{
+	int retval;
+	unsigned char ii;
+	unsigned char intr_offset;
+	unsigned char abs_data_size;
+	unsigned char abs_data_blk_size;
+	unsigned char query[F11_STD_QUERY_LEN];
+	unsigned char control[F11_STD_CTRL_LEN];
+
+	fhandler->fn_number = fd->fn_number;
+	fhandler->num_of_data_sources = fd->intr_src_count;
+
+	retval = synaptics_rmi4_i2c_read(rmi4_data,
+			fhandler->full_addr.query_base,
+			query,
+			sizeof(query));
+	if (retval < 0)
+		return retval;
+
+	/* Maximum number of fingers supported */
+	if ((query[1] & MASK_3BIT) <= 4)
+		fhandler->num_of_data_points = (query[1] & MASK_3BIT) + 1;
+	else if ((query[1] & MASK_3BIT) == 5)
+		fhandler->num_of_data_points = 10;
+
+	rmi4_data->num_of_fingers = fhandler->num_of_data_points;
+
+	retval = synaptics_rmi4_i2c_read(rmi4_data,
+			fhandler->full_addr.ctrl_base,
+			control,
+			sizeof(control));
+	if (retval < 0)
+		return retval;
+
+	/* Maximum x and y */
+	rmi4_data->sensor_max_x = ((control[6] & MASK_8BIT) << 0) |
+			((control[7] & MASK_4BIT) << 8);
+	rmi4_data->sensor_max_y = ((control[8] & MASK_8BIT) << 0) |
+			((control[9] & MASK_4BIT) << 8);
+	dev_dbg(&rmi4_data->i2c_client->dev,
+			"%s: Function %02x max x = %d max y = %d\n",
+			__func__, fhandler->fn_number,
+			rmi4_data->sensor_max_x,
+			rmi4_data->sensor_max_y);
+
+	rmi4_data->max_touch_width = MAX_F11_TOUCH_WIDTH;
+
+	fhandler->intr_reg_num = (intr_count + 7) / 8;
+	if (fhandler->intr_reg_num != 0)
+		fhandler->intr_reg_num -= 1;
+
+	/* Set an enable bit for each data source */
+	intr_offset = intr_count % 8;
+	fhandler->intr_mask = 0;
+	for (ii = intr_offset;
+			ii < ((fd->intr_src_count & MASK_3BIT) +
+			intr_offset);
+			ii++)
+		fhandler->intr_mask |= 1 << ii;
+
+	abs_data_size = query[5] & MASK_2BIT;
+	abs_data_blk_size = 3 + (2 * (abs_data_size == 0 ? 1 : 0));
+	fhandler->size_of_data_register_block = abs_data_blk_size;
+	fhandler->data = NULL;
+
+	return retval;
+}
+
+static int synaptics_rmi4_f12_set_enables(struct synaptics_rmi4_data *rmi4_data,
+		unsigned short address)
+{
+	int retval;
+	unsigned char enable_mask;
+	static unsigned short ctrl_28_address;
+
+	if (address)
+		ctrl_28_address = address;
+
+	enable_mask = RPT_DEFAULT;
+#ifdef REPORT_2D_Z
+	enable_mask |= RPT_Z;
+#endif
+#ifdef REPORT_2D_W
+	enable_mask |= (RPT_WX | RPT_WY);
+#endif
+
+	retval = synaptics_rmi4_i2c_write(rmi4_data,
+			ctrl_28_address,
+			&enable_mask,
+			sizeof(enable_mask));
+	if (retval < 0)
+		return retval;
+
+	return retval;
+}
+
+ /**
+ * synaptics_rmi4_f12_init()
+ *
+ * Called by synaptics_rmi4_query_device().
+ *
+ * This funtion parses information from the Function 12 registers and
+ * determines the number of fingers supported, offset to the data1
+ * register, x and y data ranges, offset to the associated interrupt
+ * status register, interrupt bit mask, and allocates memory resources
+ * for finger data acquisition.
+ */
+static int synaptics_rmi4_f12_init(struct synaptics_rmi4_data *rmi4_data,
+		struct synaptics_rmi4_fn *fhandler,
+		struct synaptics_rmi4_fn_desc *fd,
+		unsigned int intr_count)
+{
+	int retval;
+	unsigned char ii;
+	unsigned char intr_offset;
+	unsigned char size_of_2d_data;
+	unsigned char ctrl_8_offset;
+	unsigned char ctrl_9_offset;
+	unsigned char ctrl_23_offset;
+	unsigned char ctrl_26_offset;
+	unsigned char ctrl_28_offset;
+	unsigned char fingers_to_support = F12_FINGERS_TO_SUPPORT;
+	struct synaptics_rmi4_f12_query_5 query_5;
+	struct synaptics_rmi4_f12_query_8 query_8;
+	struct synaptics_rmi4_f12_ctrl_8 ctrl_8;
+	struct synaptics_rmi4_f12_ctrl_9 ctrl_9;
+	struct synaptics_rmi4_f12_ctrl_23 ctrl_23;
+	struct synaptics_rmi4_f12_ctrl_26 ctrl_26;
+
+	fhandler->fn_number = fd->fn_number;
+	fhandler->num_of_data_sources = fd->intr_src_count;
+
+	retval = synaptics_rmi4_i2c_read(rmi4_data,
+			fhandler->full_addr.query_base + 5,
+			query_5.data,
+			sizeof(query_5.data));
+	if (retval < 0)
+		return retval;
+
+	ctrl_8_offset = query_5.ctrl0_is_present +
+			query_5.ctrl1_is_present +
+			query_5.ctrl2_is_present +
+			query_5.ctrl3_is_present +
+			query_5.ctrl4_is_present +
+			query_5.ctrl5_is_present +
+			query_5.ctrl6_is_present +
+			query_5.ctrl7_is_present;
+
+	ctrl_9_offset = ctrl_8_offset +
+			query_5.ctrl8_is_present;
+
+	ctrl_23_offset = ctrl_9_offset +
+			query_5.ctrl9_is_present +
+			query_5.ctrl10_is_present +
+			query_5.ctrl11_is_present +
+			query_5.ctrl12_is_present +
+			query_5.ctrl13_is_present +
+			query_5.ctrl14_is_present +
+			query_5.ctrl15_is_present +
+			query_5.ctrl16_is_present +
+			query_5.ctrl17_is_present +
+			query_5.ctrl18_is_present +
+			query_5.ctrl19_is_present +
+			query_5.ctrl20_is_present +
+			query_5.ctrl21_is_present +
+			query_5.ctrl22_is_present;
+
+	ctrl_26_offset = ctrl_23_offset +
+			query_5.ctrl23_is_present +
+			query_5.ctrl24_is_present +
+			query_5.ctrl25_is_present;
+
+	ctrl_28_offset = ctrl_26_offset +
+			query_5.ctrl26_is_present +
+			query_5.ctrl27_is_present;
+
+	retval = synaptics_rmi4_i2c_read(rmi4_data,
+			fhandler->full_addr.ctrl_base + ctrl_26_offset,
+			ctrl_26.data,
+			sizeof(ctrl_26.data));
+	rmi4_data->glove_touch_addr = fhandler->full_addr.ctrl_base + ctrl_26_offset;
+	dev_info(&rmi4_data->i2c_client->dev,
+			"%s: globe touch %s(0x%x)\n", __func__,
+			(ctrl_26.glove_feature_enable & 0x1) ? "enabled" : "disabled",
+			rmi4_data->glove_touch_addr);
+
+	retval = synaptics_rmi4_i2c_read(rmi4_data,
+			fhandler->full_addr.ctrl_base + ctrl_23_offset,
+			ctrl_23.data,
+			sizeof(ctrl_23.data));
+	if (retval < 0)
+		return retval;
+
+	/* Maximum number of fingers supported */
+	fhandler->num_of_data_points = min(ctrl_23.max_reported_objects,
+			fingers_to_support);
+
+	rmi4_data->num_of_fingers = fhandler->num_of_data_points;
+
+	retval = synaptics_rmi4_f12_set_enables(rmi4_data,
+			fhandler->full_addr.ctrl_base + ctrl_28_offset);
+	if (retval < 0)
+		return retval;
+
+	retval = synaptics_rmi4_i2c_read(rmi4_data,
+			fhandler->full_addr.query_base + 8,
+			query_8.data,
+			sizeof(query_8.data));
+	if (retval < 0)
+		return retval;
+
+	/* Determine the presence of the Data0 register */
+	fhandler->data1_offset = query_8.data0_is_present;
+
+	retval = synaptics_rmi4_i2c_read(rmi4_data,
+			fhandler->full_addr.ctrl_base + ctrl_8_offset,
+			ctrl_8.data,
+			sizeof(ctrl_8.data));
+	if (retval < 0)
+		return retval;
+
+	/* Maximum x and y */
+	rmi4_data->sensor_max_x =
+			((unsigned short)ctrl_8.max_x_coord_lsb << 0) |
+			((unsigned short)ctrl_8.max_x_coord_msb << 8);
+	rmi4_data->sensor_max_y =
+			((unsigned short)ctrl_8.max_y_coord_lsb << 0) |
+			((unsigned short)ctrl_8.max_y_coord_msb << 8);
+	dev_info(&rmi4_data->i2c_client->dev,
+			"%s: Function %02x max x = %d max y = %d\n",
+			__func__, fhandler->fn_number,
+			rmi4_data->sensor_max_x,
+			rmi4_data->sensor_max_y);
+
+	if (!rmi4_data->board->num_of_rx && !rmi4_data->board->num_of_tx) {
+		rmi4_data->num_of_rx = ctrl_8.num_of_rx;
+		rmi4_data->num_of_tx = ctrl_8.num_of_tx;
+		rmi4_data->max_touch_width = max(rmi4_data->num_of_rx,
+				rmi4_data->num_of_tx);
+		rmi4_data->num_of_node = ctrl_8.num_of_rx * ctrl_8.num_of_tx;
+	} else {
+		rmi4_data->num_of_rx = rmi4_data->board->num_of_rx;
+		rmi4_data->num_of_tx = rmi4_data->board->num_of_tx;
+		rmi4_data->max_touch_width = max(rmi4_data->num_of_rx,
+				rmi4_data->num_of_tx);
+		rmi4_data->num_of_node = rmi4_data->num_of_rx * rmi4_data->num_of_tx;
+	}
+	retval = synaptics_rmi4_i2c_read(rmi4_data,
+			fhandler->full_addr.ctrl_base + ctrl_9_offset,
+			ctrl_9.data,
+			sizeof(ctrl_9.data));
+
+	if (retval < 0)
+		return retval;
+
+	rmi4_data->touch_threshold = (int)ctrl_9.touch_threshold;
+	rmi4_data->gloved_sensitivity = (int)ctrl_9.gloved_finger;
+	dev_info(&rmi4_data->i2c_client->dev,
+			"%s: %02x num_Rx:%d num_Tx:%d, node:%d, threshold:%d, gloved sensitivity:%x\n",
+			__func__, fhandler->fn_number,
+			rmi4_data->num_of_rx, rmi4_data->num_of_tx,
+			rmi4_data->num_of_node, rmi4_data->touch_threshold,
+			rmi4_data->gloved_sensitivity);
+
+	fhandler->intr_reg_num = (intr_count + 7) / 8;
+	if (fhandler->intr_reg_num != 0)
+		fhandler->intr_reg_num -= 1;
+
+	/* Set an enable bit for each data source */
+	intr_offset = intr_count % 8;
+	fhandler->intr_mask = 0;
+	for (ii = intr_offset;
+			ii < ((fd->intr_src_count & MASK_3BIT) +
+			intr_offset);
+			ii++)
+		fhandler->intr_mask |= 1 << ii;
+
+	size_of_2d_data = sizeof(struct synaptics_rmi4_f12_finger_data);
+
+	/* Allocate memory for finger data storage space */
+	fhandler->data_size = fhandler->num_of_data_points * size_of_2d_data;
+	fhandler->data = kzalloc(fhandler->data_size, GFP_KERNEL);
+
+#ifdef CONFIG_GLOVE_TOUCH
+	rmi4_data->glove_mode_enables_addr = fhandler->full_addr.ctrl_base +
+				ctrl_26_offset;
+
+	retval = synaptics_rmi4_i2c_read(rmi4_data,
+			fhandler->full_addr.query_base + 10,
+			ctrl_26.data,
+			sizeof(ctrl_26.data));
+	if (retval < 0)
+		return retval;
+
+	rmi4_data->glove_mode_feature = ctrl_26.glove_feature_enable;
+	synaptics_rmi4_glove_mode_enables(rmi4_data);
+#endif
+
+	return retval;
+}
+
+static int synaptics_rmi4_f1a_alloc_mem(struct synaptics_rmi4_data *rmi4_data,
+		struct synaptics_rmi4_fn *fhandler)
+{
+	int retval;
+	struct synaptics_rmi4_f1a_handle *f1a;
+
+	f1a = kzalloc(sizeof(*f1a), GFP_KERNEL);
+	if (!f1a) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to alloc mem for function handle\n",
+				__func__);
+		return -ENOMEM;
+	}
+
+	fhandler->data = (void *)f1a;
+
+	retval = synaptics_rmi4_i2c_read(rmi4_data,
+			fhandler->full_addr.query_base,
+			f1a->button_query.data,
+			sizeof(f1a->button_query.data));
+	if (retval < 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to read query registers\n",
+				__func__);
+		return retval;
+	}
+
+	f1a->button_count = f1a->button_query.max_button_count + 1;
+	f1a->button_bitmask_size = (f1a->button_count + 7) / 8;
+
+	f1a->button_data_buffer = kcalloc(f1a->button_bitmask_size,
+			sizeof(*(f1a->button_data_buffer)), GFP_KERNEL);
+	if (!f1a->button_data_buffer) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to alloc mem for data buffer\n",
+				__func__);
+		return -ENOMEM;
+	}
+
+	f1a->button_map = kcalloc(f1a->button_count,
+			sizeof(*(f1a->button_map)), GFP_KERNEL);
+	if (!f1a->button_map) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to alloc mem for button map\n",
+				__func__);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int synaptics_rmi4_f1a_button_map(struct synaptics_rmi4_data *rmi4_data,
+		struct synaptics_rmi4_fn *fhandler)
+{
+	unsigned char ii;
+	struct synaptics_rmi4_f1a_handle *f1a = fhandler->data;
+	const struct synaptics_rmi4_platform_data *pdata = rmi4_data->board;
+
+	if (!pdata->f1a_button_map) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: f1a_button_map is NULL in board file\n",
+				__func__);
+		return -ENODEV;
+	} else if (!pdata->f1a_button_map->map) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Button map is missing in board file\n",
+				__func__);
+		return -ENODEV;
+	} else {
+		if (pdata->f1a_button_map->nbuttons != f1a->button_count) {
+			f1a->valid_button_count = min(f1a->button_count,
+					pdata->f1a_button_map->nbuttons);
+		} else {
+			f1a->valid_button_count = f1a->button_count;
+		}
+
+		for (ii = 0; ii < f1a->valid_button_count; ii++)
+			f1a->button_map[ii] = pdata->f1a_button_map->map[ii];
+	}
+
+	return 0;
+}
+
+static void synaptics_rmi4_f1a_kfree(struct synaptics_rmi4_fn *fhandler)
+{
+	struct synaptics_rmi4_f1a_handle *f1a = fhandler->data;
+
+	if (f1a) {
+		kfree(f1a->button_data_buffer);
+		kfree(f1a->button_map);
+		kfree(f1a);
+		fhandler->data = NULL;
+	}
+
+	return;
+}
+
+static int synaptics_rmi4_f1a_init(struct synaptics_rmi4_data *rmi4_data,
+		struct synaptics_rmi4_fn *fhandler,
+		struct synaptics_rmi4_fn_desc *fd,
+		unsigned int intr_count)
+{
+	int retval;
+	unsigned char ii;
+	unsigned short intr_offset;
+
+	fhandler->fn_number = fd->fn_number;
+	fhandler->num_of_data_sources = fd->intr_src_count;
+
+	fhandler->intr_reg_num = (intr_count + 7) / 8;
+	if (fhandler->intr_reg_num != 0)
+		fhandler->intr_reg_num -= 1;
+
+	/* Set an enable bit for each data source */
+	intr_offset = intr_count % 8;
+	fhandler->intr_mask = 0;
+	for (ii = intr_offset;
+			ii < ((fd->intr_src_count & MASK_3BIT) +
+			intr_offset);
+			ii++)
+		fhandler->intr_mask |= 1 << ii;
+
+	retval = synaptics_rmi4_f1a_alloc_mem(rmi4_data, fhandler);
+	if (retval < 0)
+		goto error_exit;
+
+	retval = synaptics_rmi4_f1a_button_map(rmi4_data, fhandler);
+	if (retval < 0)
+		goto error_exit;
+
+	rmi4_data->button_0d_enabled = 1;
+
+	return 0;
+
+error_exit:
+	synaptics_rmi4_f1a_kfree(fhandler);
+
+	return retval;
+}
+
+static int synaptics_rmi4_f34_init(struct synaptics_rmi4_data *rmi4_data,
+		struct synaptics_rmi4_fn *fhandler,
+		struct synaptics_rmi4_fn_desc *fd,
+		unsigned int intr_count)
+{
+	int retval;
+	struct synaptics_rmi4_f34_ctrl_3 ctrl_3;
+
+	fhandler->fn_number = fd->fn_number;
+	fhandler->num_of_data_sources = fd->intr_src_count;
+
+	retval = synaptics_rmi4_i2c_read(rmi4_data,
+			fhandler->full_addr.ctrl_base,
+			ctrl_3.data,
+			sizeof(ctrl_3.data));
+	if (retval < 0)
+		return retval;
+
+	dev_info(&rmi4_data->i2c_client->dev,
+		"%s: [IC] [date, revision, version, panel] [%02d/%02d, 0x%02X, 0x%02X, 0x%02X]\n",
+		__func__, ctrl_3.fw_release_month, ctrl_3.fw_release_date,
+		ctrl_3.fw_release_revision, ctrl_3.fw_release_version,
+		rmi4_data->panel_revision);
+
+	rmi4_data->fw_release_date_of_ic =
+		(ctrl_3.fw_release_month << 8) | ctrl_3.fw_release_date;
+	rmi4_data->ic_revision_of_ic = ctrl_3.fw_release_revision;
+	rmi4_data->fw_version_of_ic = ctrl_3.fw_release_version;
+	fhandler->data = NULL;
+
+	return retval;
+}
+
+#ifdef PROXIMITY
+#ifdef USE_CUSTOM_REZERO
+static void synaptics_work_rezero(struct work_struct *work)
+{
+	struct synaptics_rmi4_data *rmi4_data =
+		container_of(work,
+			struct synaptics_rmi4_data, work_rezero.work);
+	int retval;
+	unsigned char custom_rezero;
+
+	retval = synaptics_rmi4_i2c_read(rmi4_data,
+			f51->proximity_custom_rezero_addr,
+			&custom_rezero, sizeof(custom_rezero));
+
+	if (F51_VERSION == f51->num_of_data_sources)
+		custom_rezero |= 0x34;
+	else
+		custom_rezero |= 0x01;
+
+	retval = synaptics_rmi4_i2c_write(rmi4_data,
+			f51->proximity_custom_rezero_addr,
+			&custom_rezero, sizeof(custom_rezero));
+
+	if (retval < 0)
+		dev_err(&rmi4_data->i2c_client->dev, "%s: fail to write custom rezero\n",
+			__func__);
+}
+
+void synaptics_rmi4_f51_set_custom_rezero(struct synaptics_rmi4_data *rmi4_data)
+{
+	schedule_delayed_work(&rmi4_data->work_rezero,
+				msecs_to_jiffies(300));
+}
+#endif
+
+int synaptics_proximity_no_sleep_set(bool enables)
+{
+	int retval;
+	unsigned char no_sleep = 0;
+
+	if (!f51)
+		return -ENODEV;
+
+	retval = synaptics_rmi4_i2c_read(f51->rmi4_data,
+			f51->rmi4_data->f01_ctrl_base_addr,
+			&no_sleep,
+			sizeof(no_sleep));
+	if (retval <= 0)
+		dev_err(&f51->rmi4_data->i2c_client->dev,
+				"%s: fail to read no_sleep[ret:%d]\n",
+				__func__, retval);
+
+	if (enables)
+		no_sleep |= 0x04;
+	else
+		no_sleep &= 0xFB;
+
+	retval = synaptics_rmi4_i2c_write(f51->rmi4_data,
+			f51->rmi4_data->f01_ctrl_base_addr,
+			&no_sleep,
+			sizeof(no_sleep));
+	if (retval <= 0)
+		dev_err(&f51->rmi4_data->i2c_client->dev,
+				"%s: fail to set no_sleep[%X][ret:%d]\n",
+				__func__, no_sleep, retval);
+
+	return retval;
+}
+
+static int synaptics_rmi4_f51_set_enables(struct synaptics_rmi4_data *rmi4_data)
+{
+	int retval;
+	unsigned char hover_enable;
+
+	dev_info(&rmi4_data->i2c_client->dev, "%s: %s\n", __func__,
+		(f51->proximity_enables & 0x01) ? "enable" : "disable");
+
+	/* if fw version is larger than 0x39,
+	 * when IC go into DOZE mode,
+	 * disable proximity sensing mode(hover).
+	 */
+	if (rmi4_data->panel_revision >= OCTA_PANEL_REVISION_43) {
+		if (f51->proximity_enables & 0x01)
+			hover_enable = 0x03;
+		else
+			hover_enable = 0x82;
+	} else {
+		hover_enable = f51->proximity_enables;
+	}
+
+	retval = synaptics_rmi4_i2c_write(rmi4_data,
+			f51->proximity_enables_addr,
+			&hover_enable,
+			sizeof(hover_enable));
+	if (retval < 0)
+		return retval;
+
+#ifdef USE_CUSTOM_REZERO
+	if (f51->proximity_enables & 0x01)
+		synaptics_rmi4_f51_set_custom_rezero(rmi4_data);
+#endif
+
+	return 0;
+}
+
+static int synaptics_rmi4_f51_init(struct synaptics_rmi4_data *rmi4_data,
+		struct synaptics_rmi4_fn *fhandler,
+		struct synaptics_rmi4_fn_desc *fd,
+		unsigned int intr_count)
+{
+	int retval;
+	unsigned char ii;
+	unsigned short intr_offset;
+	struct synaptics_rmi4_f51_data *data_register;
+	struct synaptics_rmi4_f51_query query_register;
+
+	fhandler->fn_number = fd->fn_number;
+	fhandler->num_of_data_sources = fd->intr_src_count;
+
+	fhandler->intr_reg_num = (intr_count + 7) / 8;
+	if (fhandler->intr_reg_num != 0)
+		fhandler->intr_reg_num -= 1;
+
+	/* Set an enable bit for each data source */
+	intr_offset = intr_count % 8;
+	fhandler->intr_mask = 0;
+	for (ii = intr_offset;
+			ii < ((fd->intr_src_count & MASK_3BIT) + intr_offset);
+			ii++)
+		fhandler->intr_mask |= 1 << ii;
+
+	fhandler->data_size = sizeof(*data_register);
+	data_register = kzalloc(fhandler->data_size, GFP_KERNEL);
+	fhandler->data = (void *)data_register;
+
+	f51 = kzalloc(sizeof(*f51), GFP_KERNEL);
+	f51->rmi4_data = rmi4_data;
+
+	if (F51_VERSION == fhandler->num_of_data_sources) {
+		f51->num_of_data_sources = fhandler->num_of_data_sources;
+		f51->proximity_enables = AIR_SWIPE_EN | SLEEP_PROXIMITY;
+		f51->proximity_enables_addr = fhandler->full_addr.ctrl_base +
+			F51_PROXIMITY_ENABLES_OFFSET;
+#ifdef USE_CUSTOM_REZERO
+		f51->proximity_custom_rezero_addr = fhandler->full_addr.ctrl_base +
+			F51_GENERAL_CONTROL_OFFSET;
+#endif
+	} else {
+		f51->proximity_enables = PROXIMITY_DEFAULT;
+		f51->proximity_enables_addr = fhandler->full_addr.ctrl_base +
+				F51_CTRL54_OFFSET;
+#ifdef USE_CUSTOM_REZERO
+		f51->proximity_custom_rezero_addr = fhandler->full_addr.ctrl_base +
+			F51_CTRL78_OFFSET;
+#endif
+	}
+	retval = synaptics_rmi4_i2c_read(rmi4_data,
+			fhandler->full_addr.query_base,
+			query_register.data,
+			sizeof(query_register));
+	if (retval < 0)
+		return retval;
+
+	/* Save proximity controls(query 4 register) to get which functions
+	 * are supported by firmware.
+	 */
+	f51->proximity_controls = query_register.proximity_controls;
+	dev_info(&rmi4_data->i2c_client->dev, "%s: proximity controls:[0X%02X]\n",
+			__func__, f51->proximity_controls);
+
+	retval = synaptics_rmi4_f51_set_enables(rmi4_data);
+	if (retval < 0)
+		return retval;
+
+	return 0;
+}
+
+int synaptics_rmi4_proximity_enables(unsigned char enables)
+{
+	int retval;
+
+	if (!f51)
+		return -ENODEV;
+
+	if (F51_VERSION == f51->num_of_data_sources) {
+		if (enables)
+			f51->proximity_enables = AIR_SWIPE_EN | FINGER_HOVER_EN;
+		else
+			f51->proximity_enables = AIR_SWIPE_EN | SLEEP_PROXIMITY;
+	} else {
+		if (enables)
+			f51->proximity_enables = PROXIMITY_ENABLE;
+		else
+			f51->proximity_enables = PROXIMITY_DEFAULT;
+	}
+
+	if (f51->rmi4_data->touch_stopped)
+		return 0;
+
+	retval = synaptics_rmi4_f51_set_enables(f51->rmi4_data);
+	if (retval < 0)
+		return retval;
+
+	return 0;
+}
+EXPORT_SYMBOL(synaptics_rmi4_proximity_enables);
+#endif
+
+static int synaptics_rmi4_check_status(struct synaptics_rmi4_data *rmi4_data)
+{
+	int retval;
+	int timeout = CHECK_STATUS_TIMEOUT_MS;
+	unsigned char data;
+	struct synaptics_rmi4_f01_device_status status;
+
+	retval = synaptics_rmi4_i2c_read(rmi4_data,
+			rmi4_data->f01_data_base_addr,
+			status.data,
+			sizeof(status.data));
+	if (retval < 0)
+		return retval;
+
+	dev_info(&rmi4_data->i2c_client->dev,
+			"%s: status_code: %x\n",
+			__func__, status.status_code);
+
+	while (status.status_code == STATUS_CRC_IN_PROGRESS) {
+		if (timeout > 0)
+			msleep(20);
+		else
+			return -1;
+
+		retval = synaptics_rmi4_i2c_read(rmi4_data,
+				rmi4_data->f01_data_base_addr,
+				status.data,
+				sizeof(status.data));
+		if (retval < 0)
+			return retval;
+
+		dev_info(&rmi4_data->i2c_client->dev,
+				"%s: status_code: %x, status.data: %x, timeout: %d\n",
+				__func__, status.status_code, status.data[0], timeout);
+
+		timeout -= 20;
+	}
+
+	if (status.flash_prog == 1) {
+		rmi4_data->flash_prog_mode = true;
+		dev_info(&rmi4_data->i2c_client->dev,
+				"%s: In flash prog mode, status = 0x%02x\n",
+				__func__, status.status_code);
+	} else {
+		rmi4_data->flash_prog_mode = false;
+	}
+
+	retval = synaptics_rmi4_i2c_read(rmi4_data,
+			rmi4_data->f01_data_base_addr,
+			&data,
+			sizeof(data));
+	if (retval < 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to read interrupt status\n",
+				__func__);
+		return retval;
+	}
+
+	return 0;
+}
+
+static void synaptics_rmi4_set_configured(struct synaptics_rmi4_data *rmi4_data)
+{
+	int retval;
+	unsigned char device_ctrl;
+
+	retval = synaptics_rmi4_i2c_read(rmi4_data,
+			rmi4_data->f01_ctrl_base_addr,
+			&device_ctrl,
+			sizeof(device_ctrl));
+	if (retval < 0) {
+		dev_err(&(rmi4_data->i2c_client->dev),
+				"%s: Failed to set configured\n",
+				__func__);
+		return;
+	}
+
+	device_ctrl |= CONFIGURED;
+
+	retval = synaptics_rmi4_i2c_write(rmi4_data,
+			rmi4_data->f01_ctrl_base_addr,
+			&device_ctrl,
+			sizeof(device_ctrl));
+	if (retval < 0) {
+		dev_err(&(rmi4_data->i2c_client->dev),
+				"%s: Failed to set configured\n",
+				__func__);
+	}
+
+	return;
+}
+
+static int synaptics_rmi4_alloc_fh(struct synaptics_rmi4_fn **fhandler,
+		struct synaptics_rmi4_fn_desc *rmi_fd, int page_number)
+{
+	*fhandler = kzalloc(sizeof(**fhandler), GFP_KERNEL);
+	if (!(*fhandler))
+		return -ENOMEM;
+
+	(*fhandler)->full_addr.data_base =
+			(rmi_fd->data_base_addr |
+			(page_number << 8));
+	(*fhandler)->full_addr.ctrl_base =
+			(rmi_fd->ctrl_base_addr |
+			(page_number << 8));
+	(*fhandler)->full_addr.cmd_base =
+			(rmi_fd->cmd_base_addr |
+			(page_number << 8));
+	(*fhandler)->full_addr.query_base =
+			(rmi_fd->query_base_addr |
+			(page_number << 8));
+
+	return 0;
+}
+
+ /**
+ * synaptics_rmi4_query_device()
+ *
+ * Called by synaptics_rmi4_probe().
+ *
+ * This funtion scans the page description table, records the offsets
+ * to the register types of Function $01, sets up the function handlers
+ * for Function $11 and Function $12, determines the number of interrupt
+ * sources from the sensor, adds valid Functions with data inputs to the
+ * Function linked list, parses information from the query registers of
+ * Function $01, and enables the interrupt sources from the valid Functions
+ * with data inputs.
+ */
+static int synaptics_rmi4_query_device(struct synaptics_rmi4_data *rmi4_data)
+{
+	int retval;
+	unsigned char ii = 0;
+	unsigned char page_number;
+	unsigned char intr_count = 0;
+	unsigned char f01_query[F01_STD_QUERY_LEN];
+	unsigned short pdt_entry_addr;
+	unsigned short intr_addr;
+	struct synaptics_rmi4_fn_desc rmi_fd;
+	struct synaptics_rmi4_fn *fhandler;
+	struct synaptics_rmi4_device_info *rmi;
+
+	rmi = &(rmi4_data->rmi4_mod_info);
+
+	INIT_LIST_HEAD(&rmi->support_fn_list);
+
+	/* Scan the page description tables of the pages to service */
+	for (page_number = 0; page_number < PAGES_TO_SERVICE; page_number++) {
+		for (pdt_entry_addr = PDT_START; pdt_entry_addr > PDT_END;
+				pdt_entry_addr -= PDT_ENTRY_SIZE) {
+			pdt_entry_addr |= (page_number << 8);
+
+			retval = synaptics_rmi4_i2c_read(rmi4_data,
+					pdt_entry_addr,
+					(unsigned char *)&rmi_fd,
+					sizeof(rmi_fd));
+			if (retval < 0)
+				return retval;
+
+			fhandler = NULL;
+
+			if (rmi_fd.fn_number == 0) {
+				dev_dbg(&rmi4_data->i2c_client->dev,
+						"%s: Reached end of PDT\n",
+						__func__);
+				break;
+			}
+
+			/* Display function description infomation */
+			dev_dbg(&rmi4_data->i2c_client->dev, "%s: F%02x found (page %d): INT_SRC[%02X] BASE_ADDRS[%02X,%02X,%02X,%02x]\n",
+				__func__, rmi_fd.fn_number, page_number,
+				rmi_fd.intr_src_count, rmi_fd.data_base_addr,
+				rmi_fd.ctrl_base_addr, rmi_fd.cmd_base_addr,
+				rmi_fd.query_base_addr);
+
+			switch (rmi_fd.fn_number) {
+			case SYNAPTICS_RMI4_F01:
+				rmi4_data->f01_query_base_addr =
+						rmi_fd.query_base_addr;
+				rmi4_data->f01_ctrl_base_addr =
+						rmi_fd.ctrl_base_addr;
+				rmi4_data->f01_data_base_addr =
+						rmi_fd.data_base_addr;
+				rmi4_data->f01_cmd_base_addr =
+						rmi_fd.cmd_base_addr;
+
+				retval = synaptics_rmi4_check_status(rmi4_data);
+				if (retval < 0) {
+					dev_err(&rmi4_data->i2c_client->dev,
+							"%s: Failed to check status\n",
+							__func__);
+					return retval;
+				}
+
+				if (rmi4_data->flash_prog_mode)
+					goto flash_prog_mode;
+
+				break;
+			case SYNAPTICS_RMI4_F11:
+				if (rmi_fd.intr_src_count == 0)
+					break;
+
+				retval = synaptics_rmi4_alloc_fh(&fhandler,
+						&rmi_fd, page_number);
+				if (retval < 0) {
+					dev_err(&rmi4_data->i2c_client->dev,
+							"%s: Failed to alloc for F%d\n",
+							__func__,
+							rmi_fd.fn_number);
+					return retval;
+				}
+
+				retval = synaptics_rmi4_f11_init(rmi4_data,
+						fhandler, &rmi_fd, intr_count);
+				if (retval < 0)
+					return retval;
+				break;
+			case SYNAPTICS_RMI4_F12:
+				if (rmi_fd.intr_src_count == 0)
+					break;
+
+				retval = synaptics_rmi4_alloc_fh(&fhandler,
+						&rmi_fd, page_number);
+				if (retval < 0) {
+					dev_err(&rmi4_data->i2c_client->dev,
+							"%s: Failed to alloc for F%d\n",
+							__func__,
+							rmi_fd.fn_number);
+					return retval;
+				}
+
+				retval = synaptics_rmi4_f12_init(rmi4_data,
+						fhandler, &rmi_fd, intr_count);
+				if (retval < 0)
+					return retval;
+				break;
+			case SYNAPTICS_RMI4_F1A:
+				if (rmi_fd.intr_src_count == 0)
+					break;
+
+				retval = synaptics_rmi4_alloc_fh(&fhandler,
+						&rmi_fd, page_number);
+				if (retval < 0) {
+					dev_err(&rmi4_data->i2c_client->dev,
+							"%s: Failed to alloc for F%d\n",
+							__func__,
+							rmi_fd.fn_number);
+					return retval;
+				}
+
+				retval = synaptics_rmi4_f1a_init(rmi4_data,
+						fhandler, &rmi_fd, intr_count);
+				if (retval < 0)
+					return retval;
+				break;
+			case SYNAPTICS_RMI4_F34:
+				if (rmi_fd.intr_src_count == 0)
+					break;
+
+				retval = synaptics_rmi4_alloc_fh(&fhandler,
+						&rmi_fd, page_number);
+				if (retval < 0) {
+					dev_err(&rmi4_data->i2c_client->dev,
+							"%s: Failed to alloc for F%d\n",
+							__func__,
+							rmi_fd.fn_number);
+					return retval;
+				}
+
+				retval = synaptics_rmi4_f34_init(rmi4_data,
+						fhandler, &rmi_fd, intr_count);
+				if (retval < 0)
+					return retval;
+				break;
+
+#ifdef PROXIMITY
+			case SYNAPTICS_RMI4_F51:
+				if (rmi_fd.intr_src_count == 0)
+					break;
+
+				retval = synaptics_rmi4_alloc_fh(&fhandler,
+						&rmi_fd, page_number);
+				if (retval < 0) {
+					dev_err(&rmi4_data->i2c_client->dev,
+							"%s: Failed to alloc for F%d\n",
+							__func__,
+							rmi_fd.fn_number);
+					return retval;
+				}
+
+				retval = synaptics_rmi4_f51_init(rmi4_data,
+						fhandler, &rmi_fd, intr_count);
+				if (retval < 0)
+					return retval;
+				break;
+#endif
+			}
+
+			/* Accumulate the interrupt count */
+			intr_count += (rmi_fd.intr_src_count & MASK_3BIT);
+
+			if (fhandler && rmi_fd.intr_src_count) {
+				list_add_tail(&fhandler->link,
+						&rmi->support_fn_list);
+			}
+		}
+	}
+
+flash_prog_mode:
+	rmi4_data->num_of_intr_regs = (intr_count + 7) / 8;
+	dev_info(&rmi4_data->i2c_client->dev,
+			"%s: Number of interrupt registers = %d sum of intr_count = %d\n",
+			__func__, rmi4_data->num_of_intr_regs, intr_count);
+
+	retval = synaptics_rmi4_i2c_read(rmi4_data,
+			rmi4_data->f01_query_base_addr,
+			f01_query,
+			sizeof(f01_query));
+	if (retval < 0)
+		return retval;
+
+	/* RMI Version 4.0 currently supported */
+	rmi->version_major = 4;
+	rmi->version_minor = 0;
+
+	rmi->manufacturer_id = f01_query[0];
+	rmi->product_props = f01_query[1];
+	rmi->product_info[0] = f01_query[2] & MASK_7BIT;
+	rmi->product_info[1] = f01_query[3] & MASK_7BIT;
+	rmi->date_code[0] = f01_query[4] & MASK_5BIT;
+	rmi->date_code[1] = f01_query[5] & MASK_4BIT;
+	rmi->date_code[2] = f01_query[6] & MASK_5BIT;
+	rmi->tester_id = ((f01_query[7] & MASK_7BIT) << 8) |
+			(f01_query[8] & MASK_7BIT);
+	rmi->serial_number = ((f01_query[9] & MASK_7BIT) << 8) |
+			(f01_query[10] & MASK_7BIT);
+	memcpy(rmi->product_id_string, &f01_query[11], 10);
+
+	if (rmi->manufacturer_id != 1) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Non-Synaptics device found, manufacturer ID = %d\n",
+				__func__, rmi->manufacturer_id);
+	}
+
+	retval = synaptics_rmi4_i2c_read(rmi4_data,
+			rmi4_data->f01_query_base_addr + F01_BUID_ID_OFFSET,
+			rmi->build_id,
+			sizeof(rmi->build_id));
+	if (retval < 0)
+		return retval;
+
+	memset(rmi4_data->intr_mask, 0x00, sizeof(rmi4_data->intr_mask));
+
+	/*
+	 * Map out the interrupt bit masks for the interrupt sources
+	 * from the registered function handlers.
+	 */
+	if (!list_empty(&rmi->support_fn_list)) {
+		list_for_each_entry(fhandler, &rmi->support_fn_list, link) {
+			if (fhandler->num_of_data_sources) {
+				rmi4_data->intr_mask[fhandler->intr_reg_num] |=
+						fhandler->intr_mask;
+			}
+
+			/* To display each fhandler data */
+			dev_info(&rmi4_data->i2c_client->dev, "%s: F%02x : NUM_SOURCE[%02X] NUM_INT_REG[%02X] INT_MASK[%02X]\n",
+				__func__, fhandler->fn_number,
+				fhandler->num_of_data_sources, fhandler->intr_reg_num,
+				fhandler->intr_mask);
+		}
+	}
+
+	/* Enable the interrupt sources */
+	for (ii = 0; ii < rmi4_data->num_of_intr_regs; ii++) {
+		if (rmi4_data->intr_mask[ii] != 0x00) {
+			dev_info(&rmi4_data->i2c_client->dev,
+					"%s: Interrupt enable mask %d = 0x%02x\n",
+					__func__, ii, rmi4_data->intr_mask[ii]);
+			intr_addr = rmi4_data->f01_ctrl_base_addr + 1 + ii;
+			retval = synaptics_rmi4_i2c_write(rmi4_data,
+					intr_addr,
+					&(rmi4_data->intr_mask[ii]),
+					sizeof(rmi4_data->intr_mask[ii]));
+			if (retval < 0)
+				return retval;
+		}
+	}
+
+	synaptics_rmi4_set_configured(rmi4_data);
+
+	return 0;
+}
+
+static void synaptics_rmi4_release_support_fn(struct synaptics_rmi4_data *rmi4_data)
+{
+	struct synaptics_rmi4_fn *fhandler, *n;
+	struct synaptics_rmi4_device_info *rmi;
+
+	rmi = &(rmi4_data->rmi4_mod_info);
+
+	if (list_empty(&rmi->support_fn_list)) {
+		dev_err(&rmi4_data->i2c_client->dev, "%s: support_fn_list is empty\n",
+				__func__);
+		goto out;
+	}
+
+	list_for_each_entry_safe(fhandler, n, &rmi->support_fn_list, link) {
+		dev_dbg(&rmi4_data->i2c_client->dev, "%s: fn_number = %x\n",
+				__func__, fhandler->fn_number);
+		if (fhandler->fn_number == SYNAPTICS_RMI4_F1A)
+			synaptics_rmi4_f1a_kfree(fhandler);
+		else
+			kfree(fhandler->data);
+
+		kfree(fhandler);
+	}
+
+out:
+#ifdef PROXIMITY
+	kfree(f51);
+	f51 = NULL;
+#endif
+}
+
+static int synaptics_rmi4_set_input_device
+		(struct synaptics_rmi4_data *rmi4_data)
+{
+	int retval;
+	unsigned char ii;
+	struct synaptics_rmi4_f1a_handle *f1a;
+	struct synaptics_rmi4_fn *fhandler;
+	struct synaptics_rmi4_device_info *rmi;
+
+	rmi = &(rmi4_data->rmi4_mod_info);
+
+	rmi4_data->input_dev = input_allocate_device();
+	if (rmi4_data->input_dev == NULL) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to allocate input device\n",
+				__func__);
+		retval = -ENOMEM;
+		goto err_input_device;
+	}
+
+	retval = synaptics_rmi4_query_device(rmi4_data);
+	if (retval < 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to query device\n",
+				__func__);
+		goto err_query_device;
+	}
+
+	rmi4_data->input_dev->name = "sec_touchscreen";
+	rmi4_data->input_dev->id.bustype = BUS_I2C;
+	rmi4_data->input_dev->dev.parent = &rmi4_data->i2c_client->dev;
+#ifdef USE_OPEN_CLOSE
+	rmi4_data->input_dev->open = synaptics_rmi4_input_open;
+	rmi4_data->input_dev->close = synaptics_rmi4_input_close;
+#endif
+	input_set_drvdata(rmi4_data->input_dev, rmi4_data);
+
+#ifdef CONFIG_GLOVE_TOUCH
+	input_set_capability(rmi4_data->input_dev, EV_SW, SW_GLOVE);
+#endif
+	set_bit(EV_SYN, rmi4_data->input_dev->evbit);
+	set_bit(EV_KEY, rmi4_data->input_dev->evbit);
+	set_bit(EV_ABS, rmi4_data->input_dev->evbit);
+	set_bit(BTN_TOUCH, rmi4_data->input_dev->keybit);
+	set_bit(BTN_TOOL_FINGER, rmi4_data->input_dev->keybit);
+#ifdef INPUT_PROP_DIRECT
+	set_bit(INPUT_PROP_DIRECT, rmi4_data->input_dev->propbit);
+#endif
+
+	input_set_abs_params(rmi4_data->input_dev,
+			ABS_MT_POSITION_X, 0,
+			rmi4_data->board->max_x, 0, 0);
+	input_set_abs_params(rmi4_data->input_dev,
+			ABS_MT_POSITION_Y, 0,
+			rmi4_data->board->max_y, 0, 0);
+#ifdef REPORT_2D_W
+#ifdef EDGE_SWIPE
+	input_set_abs_params(rmi4_data->input_dev,
+			ABS_MT_TOUCH_MAJOR, 0,
+			EDGE_SWIPE_WIDTH_MAX, 0, 0);
+	input_set_abs_params(rmi4_data->input_dev,
+			ABS_MT_TOUCH_MINOR, 0,
+			EDGE_SWIPE_WIDTH_MAX, 0, 0);
+#else
+	input_set_abs_params(rmi4_data->input_dev,
+			ABS_MT_TOUCH_MAJOR, 0,
+			rmi4_data->board->max_width, 0, 0);
+	input_set_abs_params(rmi4_data->input_dev,
+			ABS_MT_TOUCH_MINOR, 0,
+			rmi4_data->board->max_width, 0, 0);
+#endif
+#endif
+#ifdef PROXIMITY
+	input_set_abs_params(rmi4_data->input_dev,
+			ABS_MT_DISTANCE, 0,
+			HOVER_Z_MAX, 0, 0);
+#ifdef EDGE_SWIPE
+	input_set_abs_params(rmi4_data->input_dev,
+			ABS_MT_WIDTH_MAJOR, 0,
+			EDGE_SWIPE_WIDTH_MAX, 0, 0);
+	input_set_abs_params(rmi4_data->input_dev,
+			ABS_MT_ANGLE, 0,
+			EDGE_SWIPE_ANGLE_MAX, 0, 0);
+	input_set_abs_params(rmi4_data->input_dev,
+			ABS_MT_PALM, 0,
+			EDGE_SWIPE_PALM_MAX, 0, 0);
+#endif
+	setup_timer(&rmi4_data->f51_finger_timer,
+			synaptics_rmi4_f51_finger_timer,
+			(unsigned long)rmi4_data);
+#endif
+
+#ifdef TYPE_B_PROTOCOL
+	input_mt_init_slots(rmi4_data->input_dev,
+			rmi4_data->num_of_fingers);
+#endif
+
+	f1a = NULL;
+	if (!list_empty(&rmi->support_fn_list)) {
+		list_for_each_entry(fhandler, &rmi->support_fn_list, link) {
+			if (fhandler->fn_number == SYNAPTICS_RMI4_F1A)
+				f1a = fhandler->data;
+		}
+	}
+
+	if (f1a) {
+		for (ii = 0; ii < f1a->valid_button_count; ii++) {
+			set_bit(f1a->button_map[ii],
+					rmi4_data->input_dev->keybit);
+			input_set_capability(rmi4_data->input_dev,
+					EV_KEY, f1a->button_map[ii]);
+		}
+	}
+
+	retval = input_register_device(rmi4_data->input_dev);
+	if (retval) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to register input device\n",
+				__func__);
+		goto err_register_input;
+	}
+
+	return 0;
+
+err_register_input:
+	input_free_device(rmi4_data->input_dev);
+
+err_query_device:
+	synaptics_rmi4_release_support_fn(rmi4_data);
+
+err_input_device:
+	return retval;
+}
+
+static int synaptics_rmi4_reinit_device(struct synaptics_rmi4_data *rmi4_data)
+{
+	int retval;
+	unsigned char ii = 0;
+	unsigned short intr_addr;
+	struct synaptics_rmi4_fn *fhandler;
+	struct synaptics_rmi4_device_info *rmi;
+
+	rmi = &(rmi4_data->rmi4_mod_info);
+
+	if (!list_empty(&rmi->support_fn_list)) {
+		list_for_each_entry(fhandler, &rmi->support_fn_list, link) {
+			if (fhandler->fn_number == SYNAPTICS_RMI4_F12) {
+				retval = synaptics_rmi4_f12_set_enables(rmi4_data, 0);
+				if (retval < 0)
+					return retval;
+				break;
+			}
+		}
+	}
+#ifdef CONFIG_GLOVE_TOUCH
+	synaptics_rmi4_glove_mode_enables(rmi4_data);
+#endif
+#ifdef PROXIMITY
+	if (!f51) {
+		dev_info(&rmi4_data->i2c_client->dev,
+			"%s: f51 is no available.\n", __func__);
+		return -ENODEV;
+	}
+	dev_info(&rmi4_data->i2c_client->dev, "%s: proximity controls:[0X%02X]\n",
+			__func__, f51->proximity_controls);
+
+#ifdef USE_CUSTOM_REZERO
+	synaptics_rmi4_f51_set_custom_rezero(rmi4_data);
+
+	msleep(100);
+#endif
+
+	retval = synaptics_rmi4_f51_set_enables(rmi4_data);
+	if (retval < 0)
+		return retval;
+
+#endif
+	for (ii = 0; ii < rmi4_data->num_of_intr_regs; ii++) {
+		if (rmi4_data->intr_mask[ii] != 0x00) {
+			dev_info(&rmi4_data->i2c_client->dev,
+					"%s: Interrupt enable mask register[%d] = 0x%02x\n",
+					__func__, ii, rmi4_data->intr_mask[ii]);
+			intr_addr = rmi4_data->f01_ctrl_base_addr + 1 + ii;
+			retval = synaptics_rmi4_i2c_write(rmi4_data,
+					intr_addr,
+					&(rmi4_data->intr_mask[ii]),
+					sizeof(rmi4_data->intr_mask[ii]));
+			if (retval < 0)
+				return retval;
+		}
+	}
+
+	synaptics_rmi4_set_configured(rmi4_data);
+
+	return 0;
+}
+
+static void synaptics_rmi4_release_all_finger(
+	struct synaptics_rmi4_data *rmi4_data)
+{
+	int ii;
+
+#ifdef TYPE_B_PROTOCOL
+	for (ii = 0; ii < rmi4_data->num_of_fingers; ii++) {
+		input_mt_slot(rmi4_data->input_dev, ii);
+		input_mt_report_slot_state(rmi4_data->input_dev,
+				MT_TOOL_FINGER, 0);
+	}
+#else
+	input_mt_sync(rmi4_data->input_dev);
+#endif
+	input_report_key(rmi4_data->input_dev,
+			BTN_TOUCH, 0);
+#ifdef CONFIG_GLOVE_TOUCH
+	input_report_switch(rmi4_data->input_dev,
+		SW_GLOVE, false);
+	rmi4_data->touchkey_glove_mode_status = false;
+#endif
+	input_sync(rmi4_data->input_dev);
+
+	rmi4_data->fingers_on_2d = false;
+#ifdef PROXIMITY
+	rmi4_data->f51_finger = false;
+#endif
+
+#ifdef TSP_BOOSTER
+	synaptics_set_dvfs_lock(rmi4_data, -1);
+	dev_info(&rmi4_data->i2c_client->dev,
+			"%s: dvfs_lock free.\n", __func__);
+#endif
+}
+
+int synaptics_rmi4_reset_device(struct synaptics_rmi4_data *rmi4_data)
+{
+	int retval;
+	unsigned char command = 0x01;
+
+	mutex_lock(&(rmi4_data->rmi4_reset_mutex));
+
+	disable_irq(rmi4_data->i2c_client->irq);
+
+	synaptics_rmi4_release_all_finger(rmi4_data);
+
+	if (!rmi4_data->stay_awake) {
+		retval = synaptics_rmi4_i2c_write(rmi4_data,
+				rmi4_data->f01_cmd_base_addr,
+				&command,
+				sizeof(command));
+		if (retval < 0) {
+			dev_err(&rmi4_data->i2c_client->dev,
+					"%s: Failed to issue reset command, error = %d\n",
+					__func__, retval);
+			goto out;
+		}
+
+		/* A1(400msec) need more sleep time than B0(min 60msec) */
+		if (rmi4_data->ic_revision_of_ic == 0xB0)
+			msleep(SYNAPTICS_HW_RESET_TIME_B0);
+		else
+			msleep(SYNAPTICS_HW_RESET_TIME);
+
+	} else {
+#if defined(CONFIG_TOUCHSCREEN_SYNAPTICS_PREVENT_HSYNC_LEAKAGE)
+		rmi4_data->board->hsync_onoff(false);
+#endif
+		rmi4_data->board->power(false);
+		msleep(30);
+		rmi4_data->board->power(true);
+
+		/* A1(400msec) need more sleep time than B0(min 60msec) */
+		if (rmi4_data->ic_revision_of_ic == 0xB0)
+			msleep(SYNAPTICS_HW_RESET_TIME_B0);
+		else
+			msleep(SYNAPTICS_HW_RESET_TIME);
+
+#if defined(CONFIG_TOUCHSCREEN_SYNAPTICS_PREVENT_HSYNC_LEAKAGE)
+		rmi4_data->board->hsync_onoff(true);
+#endif
+		retval = synaptics_rmi4_f54_set_control(rmi4_data);
+		if (retval < 0)
+			dev_err(&rmi4_data->i2c_client->dev,
+					"%s: Failed to set f54 control\n",
+					__func__);
+	}
+
+	synaptics_rmi4_release_support_fn(rmi4_data);
+
+	retval = synaptics_rmi4_query_device(rmi4_data);
+	if (retval < 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to query device\n",
+				__func__);
+	}
+
+out:
+	enable_irq(rmi4_data->i2c_client->irq);
+	mutex_unlock(&(rmi4_data->rmi4_reset_mutex));
+
+	return 0;
+}
+
+static void synaptics_charger_conn(struct synaptics_rmi4_data *rmi4_data,
+				int ta_status)
+{
+	int retval;
+	unsigned char charger_connected;
+
+	retval = synaptics_rmi4_i2c_read(rmi4_data,
+			rmi4_data->f01_ctrl_base_addr,
+			&charger_connected,
+			sizeof(charger_connected));
+	if (retval < 0) {
+		dev_err(&(rmi4_data->input_dev->dev),
+				"%s: Failed to set configured\n",
+				__func__);
+		return;
+	}
+
+	if (ta_status == 0x01 || ta_status == 0x03)
+		charger_connected |= CHARGER_CONNECTED;
+	else
+		charger_connected &= CHARGER_DISCONNECTED;
+
+	retval = synaptics_rmi4_i2c_write(rmi4_data,
+		rmi4_data->f01_ctrl_base_addr,
+		&charger_connected,
+		sizeof(charger_connected));
+
+	if (retval < 0) {
+		dev_err(&(rmi4_data->input_dev->dev),
+				"%s: Failed to set configured\n",
+				__func__);
+	}
+
+	dev_info(&rmi4_data->i2c_client->dev,
+		"%s: device_control : %x, ta_status : %x\n",
+		__func__, charger_connected, ta_status);
+
+}
+
+static void synaptics_ta_cb(struct synaptics_rmi_callbacks *cb, int ta_status)
+{
+	struct synaptics_rmi4_data *rmi4_data =
+			container_of(cb, struct synaptics_rmi4_data, callbacks);
+
+	dev_info(&rmi4_data->i2c_client->dev,
+		"%s: ta_status : %x\n", __func__, ta_status);
+
+	rmi4_data->ta_status = ta_status;
+
+	/* if do not completed driver loading, ta_cb will not run. */
+	if (!rmi4_data->init_done.done) {
+		dev_err(&rmi4_data->i2c_client->dev,
+			"%s: until driver loading done.\n",
+			__func__);
+		return;
+	}
+	if (rmi4_data->touch_stopped || rmi4_data->doing_reflash) {
+		dev_err(&rmi4_data->i2c_client->dev,
+			"%s: device is in suspend state or reflash.\n",
+			__func__);
+		return;
+	}
+
+	synaptics_charger_conn(rmi4_data, ta_status);
+
+}
+
+#ifdef PROXIMITY
+static void synaptics_rmi4_f51_finger_timer(unsigned long data)
+{
+	struct synaptics_rmi4_data *rmi4_data =
+			(struct synaptics_rmi4_data *)data;
+
+	if (rmi4_data->f51_finger) {
+		rmi4_data->f51_finger = false;
+		mod_timer(&rmi4_data->f51_finger_timer,
+				jiffies + msecs_to_jiffies(F51_FINGER_TIMEOUT));
+	} else if (!rmi4_data->fingers_on_2d) {
+#ifdef TYPE_B_PROTOCOL
+		input_mt_slot(rmi4_data->input_dev, 0);
+		input_mt_report_slot_state(rmi4_data->input_dev,
+				MT_TOOL_FINGER, 0);
+#else
+		input_mt_sync(rmi4_data->input_dev);
+#endif
+		input_sync(rmi4_data->input_dev);
+	}
+
+	return;
+}
+#endif
+
+static void synaptics_rmi4_remove_exp_fn(struct synaptics_rmi4_data *rmi4_data)
+{
+	struct synaptics_rmi4_exp_fn *exp_fhandler, *n;
+
+	if (list_empty(&exp_fn_list)) {
+		dev_err(&rmi4_data->i2c_client->dev, "%s: exp_fn_list empty\n",
+				__func__);
+		return;
+	}
+
+	list_for_each_entry_safe(exp_fhandler, n, &exp_fn_list, link) {
+		if (exp_fhandler->initialized &&
+				(exp_fhandler->func_remove != NULL)) {
+			dev_dbg(&rmi4_data->i2c_client->dev, "%s: [%d]\n",
+				__func__, exp_fhandler->fn_type);
+			exp_fhandler->func_remove(rmi4_data);
+		}
+		list_del(&exp_fhandler->link);
+		kfree(exp_fhandler);
+	}
+}
+
+static int synaptics_rmi4_init_exp_fn(struct synaptics_rmi4_data *rmi4_data)
+{
+	int retval;
+	struct synaptics_rmi4_exp_fn *exp_fhandler;
+
+	INIT_LIST_HEAD(&exp_fn_list);
+
+	retval = rmidev_module_register();
+	if (retval < 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to register rmidev module\n",
+				__func__);
+		goto error_exit;
+	}
+
+	retval = rmi4_f54_module_register();
+	if (retval < 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to register f54 module\n",
+				__func__);
+		goto error_exit;
+	}
+
+	retval = rmi4_fw_update_module_register();
+	if (retval < 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: Failed to register fw update module\n",
+				__func__);
+		goto error_exit;
+	}
+
+	if (list_empty(&exp_fn_list))
+		return -ENODEV;
+
+	list_for_each_entry(exp_fhandler, &exp_fn_list, link) {
+		if (exp_fhandler->func_init != NULL) {
+			dev_dbg(&rmi4_data->i2c_client->dev, "%s: run [%d]'s init function\n",
+						__func__, exp_fhandler->fn_type);
+			retval = exp_fhandler->func_init(rmi4_data);
+			if (retval < 0) {
+				dev_err(&rmi4_data->i2c_client->dev,
+						"%s: Failed to init exp fn\n",
+						__func__);
+				goto error_exit;
+			} else {
+				exp_fhandler->initialized = true;
+			}
+		}
+	}
+
+	return 0;
+
+error_exit:
+	synaptics_rmi4_remove_exp_fn(rmi4_data);
+
+	return retval;
+}
+
+/**
+* synaptics_rmi4_new_function()
+*
+* Called by other expansion Function modules in their module init and
+* module exit functions.
+*
+* This function is used by other expansion Function modules such as
+* rmi_dev to register themselves with the driver by providing their
+* initialization and removal callback function pointers so that they
+* can be inserted or removed dynamically at module init and exit times,
+* respectively.
+*/
+int synaptics_rmi4_new_function(enum exp_fn fn_type,
+		int (*func_init)(struct synaptics_rmi4_data *rmi4_data),
+		void (*func_remove)(struct synaptics_rmi4_data *rmi4_data),
+		void (*func_attn)(struct synaptics_rmi4_data *rmi4_data,
+		unsigned char intr_mask))
+{
+	struct synaptics_rmi4_exp_fn *exp_fhandler;
+
+	exp_fhandler = kzalloc(sizeof(*exp_fhandler), GFP_KERNEL);
+	if (!exp_fhandler) {
+		pr_err("%s: Failed to alloc mem for expansion function\n",
+				__func__);
+		return -ENOMEM;
+	}
+	exp_fhandler->fn_type = fn_type;
+	exp_fhandler->func_init = func_init;
+	exp_fhandler->func_attn = func_attn;
+	exp_fhandler->func_remove = func_remove;
+	list_add_tail(&exp_fhandler->link, &exp_fn_list);
+
+	return 0;
+}
+
+static void synaptics_init_power_on(struct work_struct *work)
+{
+	struct synaptics_rmi4_data *rmi4_data =
+		container_of(work,
+			struct synaptics_rmi4_data, work_init_power_on.work);
+
+#ifdef CONFIG_FB_MSM_MIPI_SAMSUNG_OCTA_VIDEO_FULL_HD_PT_PANEL
+	if (!touch_display_status) {
+			dev_info(&rmi4_data->i2c_client->dev,
+					"%s: until lcd does not turn on.\n", __func__);
+			schedule_delayed_work(&rmi4_data->work_init_power_on,
+					msecs_to_jiffies(1000));
+	} else {
+		synaptics_rmi4_late_resume(&rmi4_data->early_suspend);
+	}
+#else
+	synaptics_rmi4_late_resume(&rmi4_data->early_suspend);
+#endif
+}
+
+ /**
+ * synaptics_rmi4_probe()
+ *
+ * Called by the kernel when an association with an I2C device of the
+ * same name is made (after doing i2c_add_driver).
+ *
+ * This funtion allocates and initializes the resources for the driver
+ * as an input driver, turns on the power to the sensor, queries the
+ * sensor for its supported Functions and characteristics, registers
+ * the driver to the input subsystem, sets up the interrupt, handles
+ * the registration of the early_suspend and late_resume functions,
+ * and creates a work queue for detection of other expansion Function
+ * modules.
+ */
+static int __devinit synaptics_rmi4_probe(struct i2c_client *client,
+		const struct i2c_device_id *dev_id)
+{
+	int retval;
+	unsigned char attr_count;
+	int attr_count_num;
+	struct synaptics_rmi4_data *rmi4_data;
+	struct synaptics_rmi4_device_info *rmi;
+	const struct synaptics_rmi4_platform_data *platform_data =
+			client->dev.platform_data;
+
+	if (!i2c_check_functionality(client->adapter,
+			I2C_FUNC_SMBUS_BYTE_DATA)) {
+		dev_err(&client->dev,
+				"%s: SMBus byte data not supported\n",
+				__func__);
+		return -EIO;
+	}
+
+	if (!platform_data) {
+		dev_err(&client->dev,
+				"%s: No platform data found\n",
+				__func__);
+		return -EINVAL;
+	}
+
+	rmi4_data = kzalloc(sizeof(*rmi4_data), GFP_KERNEL);
+	if (!rmi4_data) {
+		dev_err(&client->dev,
+				"%s: Failed to alloc mem for rmi4_data\n",
+				__func__);
+		return -ENOMEM;
+	}
+
+	rmi = &(rmi4_data->rmi4_mod_info);
+
+	rmi4_data->i2c_client = client;
+	rmi4_data->current_page = MASK_8BIT;
+	rmi4_data->board = platform_data;
+	rmi4_data->touch_stopped = false;
+	rmi4_data->sensor_sleep = false;
+	rmi4_data->irq_enabled = false;
+
+	/* define panel version : M4 / M4+ */
+	rmi4_data->panel_revision = rmi4_data->board->panel_revision;
+
+#if defined(CONFIG_TOUCHSCREEN_SYNAPTICS_PREVENT_HSYNC_LEAKAGE)
+	rmi4_data->board->hsync_onoff(false);
+#endif
+	rmi4_data->board->power(true);
+
+#if defined(CONFIG_TOUCHSCREEN_SYNAPTICS_PREVENT_HSYNC_LEAKAGE)
+	rmi4_data->board->hsync_onoff(true);
+#endif
+	rmi4_data->i2c_read = synaptics_rmi4_i2c_read;
+	rmi4_data->i2c_write = synaptics_rmi4_i2c_write;
+	rmi4_data->irq_enable = synaptics_rmi4_irq_enable;
+	rmi4_data->reset_device = synaptics_rmi4_reset_device;
+	rmi4_data->irq = rmi4_data->i2c_client->irq;
+
+	mutex_init(&(rmi4_data->rmi4_io_ctrl_mutex));
+	mutex_init(&(rmi4_data->rmi4_reset_mutex));
+	mutex_init(&(rmi4_data->rmi4_reflash_mutex));
+	init_completion(&rmi4_data->init_done);
+
+	i2c_set_clientdata(client, rmi4_data);
+
+	/*Direct IRQ for secure input*/
+	retval = msm_gpio_install_direct_irq(rmi4_data->board->gpio, 0, 0);
+	if (retval)
+		dev_err(&client->dev,
+			"error : could not configure  GPIO as a direct connect\n");
+
+#ifdef USE_CUSTOM_REZERO
+	INIT_DELAYED_WORK(&rmi4_data->work_rezero, synaptics_work_rezero);
+#endif
+
+#ifdef TSP_BOOSTER
+	synaptics_init_dvfs(rmi4_data);
+#endif
+
+	retval = synaptics_rmi4_set_input_device(rmi4_data);
+	if (retval < 0) {
+		dev_err(&client->dev,
+				"%s: Failed to register input device\n",
+				__func__);
+		goto err_set_input_device;
+	}
+
+
+	retval = synaptics_rmi4_init_exp_fn(rmi4_data);
+	if (retval < 0) {
+		dev_err(&client->dev,
+				"%s: Failed to register rmidev module\n",
+				__func__);
+		goto err_init_exp_fn;
+	}
+
+	retval = synaptics_rmi4_irq_enable(rmi4_data, true);
+	if (retval < 0) {
+		dev_err(&client->dev,
+				"%s: Failed to enable attention interrupt\n",
+				__func__);
+		goto err_enable_irq;
+	}
+
+	for (attr_count = 0; attr_count < ARRAY_SIZE(attrs); attr_count++) {
+		retval = sysfs_create_file(&rmi4_data->input_dev->dev.kobj,
+				&attrs[attr_count].attr);
+		if (retval < 0) {
+			dev_err(&client->dev,
+					"%s: Failed to create sysfs attributes\n",
+					__func__);
+			goto err_sysfs;
+		}
+	}
+
+	if (rmi4_data->board->factory_flatform) {
+		retval = synaptics_fw_updater(NULL, false, true);
+	} else {
+		if (rmi4_data->board->panel_revision >= OCTA_PANEL_REVISION_43)
+			retval = synaptics_fw_updater(NULL, false, false);
+#if defined(CONFIG_MACH_JACTIVE_EUR) || defined(CONFIG_MACH_JACTIVE_ATT)
+		else if (rmi4_data->board->panel_revision == OCTA_PANEL_REVISION_34) {
+			retval = synaptics_fw_updater(NULL, false, false);
+		}
+#endif
+		else
+			dev_info(&client->dev,
+					"%s: panel version is lower than FPCB4.3. do not FW update\n",
+					__func__);
+	}
+	if (retval < 0) {
+		dev_err(&client->dev, "%s: Failed to firmware update\n",
+					__func__);
+	}
+
+#ifdef CONFIG_HAS_EARLYSUSPEND
+	rmi4_data->early_suspend.level = EARLY_SUSPEND_LEVEL_BLANK_SCREEN - 1;
+	rmi4_data->early_suspend.suspend = synaptics_rmi4_early_suspend;
+	rmi4_data->early_suspend.resume = synaptics_rmi4_late_resume;
+	register_early_suspend(&rmi4_data->early_suspend);
+#endif
+
+	rmi4_data->register_cb = rmi4_data->board->register_cb;
+
+	rmi4_data->callbacks.inform_charger = synaptics_ta_cb;
+	if (rmi4_data->register_cb)
+		rmi4_data->register_cb(&rmi4_data->callbacks);
+
+#ifdef CONFIG_HAS_EARLYSUSPEND
+	/* turn off TSP power. after LCD module on, TSP power will turn on */
+	synaptics_rmi4_early_suspend(&rmi4_data->early_suspend);
+
+	INIT_DELAYED_WORK(&rmi4_data->work_init_power_on,
+					synaptics_init_power_on);
+	schedule_delayed_work(&rmi4_data->work_init_power_on,
+					msecs_to_jiffies(6000));
+#endif
+
+	/* for blocking to be excuted open function until probing */
+	complete_all(&rmi4_data->init_done);
+
+	return retval;
+
+err_sysfs:
+	attr_count_num = (int)attr_count;
+	for (attr_count_num--; attr_count_num >= 0; attr_count_num--) {
+		sysfs_remove_file(&rmi4_data->input_dev->dev.kobj,
+				&attrs[attr_count].attr);
+	}
+	synaptics_rmi4_irq_enable(rmi4_data, false);
+
+err_enable_irq:
+	synaptics_rmi4_remove_exp_fn(rmi4_data);
+
+err_init_exp_fn:
+	synaptics_rmi4_release_support_fn(rmi4_data);
+
+	input_unregister_device(rmi4_data->input_dev);
+	rmi4_data->input_dev = NULL;
+
+err_set_input_device:
+	rmi4_data->board->power(false);
+	complete_all(&rmi4_data->init_done);
+	kfree(rmi4_data);
+
+	return retval;
+}
+
+ /**
+ * synaptics_rmi4_remove()
+ *
+ * Called by the kernel when the association with an I2C device of the
+ * same name is broken (when the driver is unloaded).
+ *
+ * This funtion terminates the work queue, stops sensor data acquisition,
+ * frees the interrupt, unregisters the driver from the input subsystem,
+ * turns off the power to the sensor, and frees other allocated resources.
+ */
+static int __devexit synaptics_rmi4_remove(struct i2c_client *client)
+{
+	unsigned char attr_count;
+	struct synaptics_rmi4_data *rmi4_data = i2c_get_clientdata(client);
+	struct synaptics_rmi4_device_info *rmi;
+	/*const struct synaptics_rmi4_platform_data *platform_data =
+			rmi4_data->board;*/
+
+	rmi = &(rmi4_data->rmi4_mod_info);
+#ifdef CONFIG_HAS_EARLYSUSPEND
+	unregister_early_suspend(&rmi4_data->early_suspend);
+#endif
+
+	synaptics_rmi4_irq_enable(rmi4_data, false);
+
+	for (attr_count = 0; attr_count < ARRAY_SIZE(attrs); attr_count++) {
+		sysfs_remove_file(&rmi4_data->input_dev->dev.kobj,
+				&attrs[attr_count].attr);
+	}
+
+	input_unregister_device(rmi4_data->input_dev);
+
+	synaptics_rmi4_remove_exp_fn(rmi4_data);
+
+	rmi4_data->board->power(false);
+	rmi4_data->touch_stopped = true;
+
+	synaptics_rmi4_release_support_fn(rmi4_data);
+
+	input_free_device(rmi4_data->input_dev);
+
+	kfree(rmi4_data);
+
+	return 0;
+}
+
+#ifdef USE_SENSOR_SLEEP
+ /**
+ * synaptics_rmi4_sensor_sleep()
+ *
+ * Called by synaptics_rmi4_early_suspend() and synaptics_rmi4_suspend().
+ *
+ * This function stops finger data acquisition and puts the sensor to sleep.
+ */
+static void synaptics_rmi4_sensor_sleep(struct synaptics_rmi4_data *rmi4_data)
+{
+	int retval;
+	unsigned char device_ctrl;
+
+	dev_info(&rmi4_data->i2c_client->dev, "%s\n", __func__);
+
+	retval = synaptics_rmi4_i2c_read(rmi4_data,
+			rmi4_data->f01_ctrl_base_addr,
+			&device_ctrl,
+			sizeof(device_ctrl));
+	if (retval < 0) {
+		dev_err(&(rmi4_data->i2c_client->dev),
+				"%s: Failed to enter sleep mode\n",
+				__func__);
+		rmi4_data->sensor_sleep = false;
+		return;
+	}
+
+	device_ctrl = (device_ctrl & ~MASK_3BIT);
+	device_ctrl = (device_ctrl | NO_SLEEP_OFF | SENSOR_SLEEP);
+
+	retval = synaptics_rmi4_i2c_write(rmi4_data,
+			rmi4_data->f01_ctrl_base_addr,
+			&device_ctrl,
+			sizeof(device_ctrl));
+	if (retval < 0) {
+		dev_err(&(rmi4_data->i2c_client->dev),
+				"%s: Failed to enter sleep mode\n",
+				__func__);
+		rmi4_data->sensor_sleep = false;
+		return;
+	} else {
+		rmi4_data->sensor_sleep = true;
+	}
+
+	return;
+}
+
+ /**
+ * synaptics_rmi4_sensor_wake()
+ *
+ * Called by synaptics_rmi4_resume() and synaptics_rmi4_late_resume().
+ *
+ * This function wakes the sensor from sleep.
+ */
+static void synaptics_rmi4_sensor_wake(struct synaptics_rmi4_data *rmi4_data)
+{
+	int retval;
+	unsigned char device_ctrl;
+
+	dev_info(&rmi4_data->i2c_client->dev, "%s\n", __func__);
+
+	retval = synaptics_rmi4_i2c_read(rmi4_data,
+			rmi4_data->f01_ctrl_base_addr,
+			&device_ctrl,
+			sizeof(device_ctrl));
+	if (retval < 0) {
+		dev_err(&(rmi4_data->i2c_client->dev),
+				"%s: Failed to wake from sleep mode\n",
+				__func__);
+		rmi4_data->sensor_sleep = true;
+		return;
+	}
+
+	device_ctrl = (device_ctrl & ~MASK_3BIT);
+	device_ctrl = (device_ctrl | NO_SLEEP_OFF | NORMAL_OPERATION);
+
+	retval = synaptics_rmi4_i2c_write(rmi4_data,
+			rmi4_data->f01_ctrl_base_addr,
+			&device_ctrl,
+			sizeof(device_ctrl));
+	if (retval < 0) {
+		dev_err(&(rmi4_data->i2c_client->dev),
+				"%s: Failed to wake from sleep mode\n",
+				__func__);
+		rmi4_data->sensor_sleep = true;
+		return;
+	} else {
+		rmi4_data->sensor_sleep = false;
+	}
+
+	return;
+}
+#endif
+
+#ifdef USE_OPEN_CLOSE
+static int synaptics_rmi4_input_open(struct input_dev *dev)
+{
+	struct synaptics_rmi4_data *rmi4_data = input_get_drvdata(dev);
+	int ret;
+
+	ret = wait_for_completion_interruptible_timeout(&rmi4_data->init_done,
+			msecs_to_jiffies(90 * MSEC_PER_SEC));
+
+	if (ret < 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+			"error while waiting for device to init (%d)\n", ret);
+		ret = -ENXIO;
+		goto err_open;
+	}
+	if (ret == 0) {
+		dev_err(&rmi4_data->i2c_client->dev,
+			"timedout while waiting for device to init\n");
+		ret = -ENXIO;
+		goto err_open;
+	}
+
+	dev_dbg(&rmi4_data->i2c_client->dev, "%s +\n", __func__);
+
+	if (rmi4_data->touch_stopped) {
+
+#if defined(CONFIG_TOUCHSCREEN_SYNAPTICS_PREVENT_HSYNC_LEAKAGE)
+		rmi4_data->board->hsync_onoff(false);
+#endif
+		rmi4_data->board->power(true);
+		rmi4_data->touch_stopped = false;
+
+#if defined(CONFIG_TOUCHSCREEN_SYNAPTICS_PREVENT_HSYNC_LEAKAGE)
+		rmi4_data->board->hsync_onoff(true);
+#endif
+		ret = synaptics_rmi4_reinit_device(rmi4_data);
+		if (ret < 0) {
+			dev_err(&rmi4_data->i2c_client->dev,
+					"%s: Failed to reinit device\n",
+					__func__);
+		}
+
+		enable_irq(rmi4_data->i2c_client->irq);
+
+		dev_dbg(&rmi4_data->i2c_client->dev, "%s -\n", __func__);
+	} else {
+		dev_err(&rmi4_data->i2c_client->dev, "%s already power on\n",
+			__func__);
+	}
+
+	return 0;
+
+err_open:
+	return ret;
+}
+
+static void synaptics_rmi4_input_close(struct input_dev *dev)
+{
+	struct synaptics_rmi4_data *rmi4_data = input_get_drvdata(dev);
+
+	dev_dbg(&rmi4_data->i2c_client->dev, "%s +\n", __func__);
+
+	if (!rmi4_data->touch_stopped) {
+		disable_irq(rmi4_data->i2c_client->irq);
+		rmi4_data->board->power(false);
+		rmi4_data->touch_stopped = true;
+		synaptics_rmi4_release_all_finger(rmi4_data);
+		dev_dbg(&rmi4_data->i2c_client->dev, "%s -\n", __func__);
+	} else {
+		dev_err(&rmi4_data->i2c_client->dev, "%s already power off\n",
+			__func__);
+	}
+}
+#endif
+
+#ifdef CONFIG_HAS_EARLYSUSPEND
+#define synaptics_rmi4_suspend NULL
+#define synaptics_rmi4_resume NULL
+
+ /**
+ * synaptics_rmi4_early_suspend()
+ *
+ * Called by the kernel during the early suspend phase when the system
+ * enters suspend.
+ *
+ * This function calls synaptics_rmi4_sensor_sleep() to stop finger
+ * data acquisition and put the sensor to sleep.
+ */
+static void synaptics_rmi4_early_suspend(struct early_suspend *h)
+{
+	struct synaptics_rmi4_data *rmi4_data =
+			container_of(h, struct synaptics_rmi4_data,
+			early_suspend);
+
+	if (rmi4_data->stay_awake) {
+		rmi4_data->staying_awake = true;
+		return;
+	} else {
+		rmi4_data->staying_awake = false;
+	}
+
+	if (!rmi4_data->touch_stopped) {
+		dev_info(&rmi4_data->i2c_client->dev, "%s\n", __func__);
+
+		disable_irq(rmi4_data->i2c_client->irq);
+		rmi4_data->board->power(false);
+		rmi4_data->touch_stopped = true;
+
+		gpio_free(rmi4_data->board->gpio);
+		/* release all finger when entered suspend */
+		synaptics_rmi4_release_all_finger(rmi4_data);
+	}
+}
+
+ /**
+ * synaptics_rmi4_late_resume()
+ *
+ * Called by the kernel during the late resume phase when the system
+ * wakes up from suspend.
+ *
+ * This function goes through the sensor wake process if the system wakes
+ * up from early suspend (without going into suspend).
+ */
+static void synaptics_rmi4_late_resume(struct early_suspend *h)
+{
+	struct synaptics_rmi4_data *rmi4_data =
+			container_of(h, struct synaptics_rmi4_data,
+			early_suspend);
+	int retval;
+
+	if (rmi4_data->staying_awake)
+		return;
+
+	if (rmi4_data->touch_stopped) {
+		dev_info(&rmi4_data->i2c_client->dev, "%s\n", __func__);
+
+#if defined(CONFIG_TOUCHSCREEN_SYNAPTICS_PREVENT_HSYNC_LEAKAGE)
+		rmi4_data->board->hsync_onoff(false);
+#endif
+		rmi4_data->board->power(true);
+		rmi4_data->touch_stopped = false;
+
+#if defined(CONFIG_TOUCHSCREEN_SYNAPTICS_PREVENT_HSYNC_LEAKAGE)
+		rmi4_data->board->hsync_onoff(true);
+#endif
+		retval = gpio_request(rmi4_data->board->gpio, "tsp_int");
+		if (retval != 0) {
+			dev_info(&rmi4_data->i2c_client->dev, "%s: tsp int request failed, ret=%d", __func__, retval);
+			return ;
+		}
+
+		retval = synaptics_rmi4_reinit_device(rmi4_data);
+		if (retval < 0) {
+			dev_err(&rmi4_data->i2c_client->dev,
+					"%s: Failed to reinit device\n",
+					__func__);
+		}
+
+		if (rmi4_data->ta_status)
+			synaptics_charger_conn(rmi4_data, rmi4_data->ta_status);
+
+		enable_irq(rmi4_data->i2c_client->irq);
+	}
+#ifdef CONFIG_FB_MSM_MIPI_SAMSUNG_OCTA_VIDEO_FULL_HD_PT_PANEL
+	retval = rmi4_data->board->tout1_on();
+	if (retval)
+		dev_err(&rmi4_data->i2c_client->dev,
+				"%s: touch_tout1_on failed\n", __func__);
+#endif
+	return;
+}
+#else
+
+ /**
+ * synaptics_rmi4_suspend()
+ *
+ * Called by the kernel during the suspend phase when the system
+ * enters suspend.
+ *
+ * This function stops finger data acquisition and puts the sensor to
+ * sleep (if not already done so during the early suspend phase),
+ * disables the interrupt, and turns off the power to the sensor.
+ */
+static int synaptics_rmi4_suspend(struct device *dev)
+{
+	struct synaptics_rmi4_data *rmi4_data = dev_get_drvdata(dev);
+
+	dev_info(&rmi4_data->i2c_client->dev, "%s\n", __func__);
+
+	if (rmi4_data->staying_awake)
+		return 0;
+
+	mutex_lock(&rmi4_data->input_dev->mutex);
+
+	if (rmi4_data->input_dev->users) {
+		if (!rmi4_data->touch_stopped) {
+			disable_irq(rmi4_data->i2c_client->irq);
+			synaptics_rmi4_release_all_finger(rmi4_data);
+			rmi4_data->board->power(false);
+			rmi4_data->touch_stopped = true;
+		} else {
+			dev_err(&rmi4_data->i2c_client->dev, "%s already power off\n",
+				__func__);
+		}
+	}
+	mutex_unlock(&rmi4_data->input_dev->mutex);
+
+	return 0;
+}
+
+ /**
+ * synaptics_rmi4_resume()
+ *
+ * Called by the kernel during the resume phase when the system
+ * wakes up from suspend.
+ *
+ * This function turns on the power to the sensor, wakes the sensor
+ * from sleep, enables the interrupt, and starts finger data
+ * acquisition.
+ */
+static int synaptics_rmi4_resume(struct device *dev)
+{
+	struct synaptics_rmi4_data *rmi4_data = dev_get_drvdata(dev);
+	int retval;
+
+	dev_info(&rmi4_data->i2c_client->dev, "%s\n", __func__);
+
+	mutex_lock(&rmi4_data->input_dev->mutex);
+
+	if (rmi4_data->input_dev->users) {
+		if (rmi4_data->touch_stopped) {
+			rmi4_data->board->power(true);
+			rmi4_data->touch_stopped = false;
+
+			retval = synaptics_rmi4_reinit_device(rmi4_data);
+			if (retval < 0) {
+				dev_err(&rmi4_data->i2c_client->dev,
+						"%s: Failed to reinit device\n",
+						__func__);
+			}
+			enable_irq(rmi4_data->i2c_client->irq);
+
+			dev_dbg(&rmi4_data->i2c_client->dev, "%s -\n", __func__);
+		} else {
+			dev_err(&rmi4_data->i2c_client->dev, "%s already power on\n",
+				__func__);
+		}
+	}
+
+	mutex_unlock(&rmi4_data->input_dev->mutex);
+
+	return 0;
+}
+#endif
+
+#ifdef CONFIG_PM
+static const struct dev_pm_ops synaptics_rmi4_dev_pm_ops = {
+	.suspend = synaptics_rmi4_suspend,
+	.resume  = synaptics_rmi4_resume,
+};
+#endif
+
+static const struct i2c_device_id synaptics_rmi4_id_table[] = {
+	{DRIVER_NAME, 0},
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, synaptics_rmi4_id_table);
+
+static struct i2c_driver synaptics_rmi4_driver = {
+	.driver = {
+		.name = DRIVER_NAME,
+		.owner = THIS_MODULE,
+#ifdef CONFIG_PM
+		.pm = &synaptics_rmi4_dev_pm_ops,
+#endif
+	},
+	.probe = synaptics_rmi4_probe,
+	.remove = __devexit_p(synaptics_rmi4_remove),
+	.id_table = synaptics_rmi4_id_table,
+};
+
+ /**
+ * synaptics_rmi4_init()
+ *
+ * Called by the kernel during do_initcalls (if built-in)
+ * or when the driver is loaded (if a module).
+ *
+ * This function registers the driver to the I2C subsystem.
+ *
+ */
+static int __init synaptics_rmi4_init(void)
+{
+	return i2c_add_driver(&synaptics_rmi4_driver);
+}
+
+ /**
+ * synaptics_rmi4_exit()
+ *
+ * Called by the kernel when the driver is unloaded.
+ *
+ * This funtion unregisters the driver from the I2C subsystem.
+ *
+ */
+static void __exit synaptics_rmi4_exit(void)
+{
+	i2c_del_driver(&synaptics_rmi4_driver);
+}
+
+module_init(synaptics_rmi4_init);
+module_exit(synaptics_rmi4_exit);
+
+MODULE_AUTHOR("Synaptics, Inc.");
+MODULE_DESCRIPTION("Synaptics RMI4 I2C Touch Driver");
+MODULE_LICENSE("GPL v2");
+MODULE_VERSION(SYNAPTICS_RMI4_DRIVER_VERSION);
diff --git a/drivers/input/touchscreen/synaptics_i2c_rmi.h b/drivers/input/touchscreen/synaptics_i2c_rmi.h
new file mode 100644
index 0000000..b95522d
--- /dev/null
+++ b/drivers/input/touchscreen/synaptics_i2c_rmi.h
@@ -0,0 +1,399 @@
+/* Synaptics Register Mapped Interface (RMI4) I2C Physical Layer Driver.
+ * Copyright (c) 2007-2012, Synaptics Incorporated
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+#ifndef _SYNAPTICS_RMI4_H_
+#define _SYNAPTICS_RMI4_H_
+
+#define SYNAPTICS_RMI4_DRIVER_VERSION "DS5 1.0"
+#include <linux/device.h>
+#include <linux/i2c/synaptics_rmi.h>
+
+#ifdef CONFIG_HAS_EARLYSUSPEND
+#include <linux/earlysuspend.h>
+#endif
+
+/*#define dev_dbg(dev, fmt, arg...) dev_info(dev, fmt, ##arg)*/
+
+/* DVFS feature : TOUCH BOOSTER */
+#ifdef CONFIG_SEC_DVFS_BOOSTER
+#define TSP_BOOSTER
+#endif
+#ifdef TSP_BOOSTER
+#define DVFS_STAGE_DUAL		2
+#define DVFS_STAGE_SINGLE	1
+#define DVFS_STAGE_NONE		0
+#include <linux/cpufreq.h>
+
+#define TOUCH_BOOSTER_OFF_TIME	300
+#define TOUCH_BOOSTER_CHG_TIME	200
+#endif
+
+/* To support suface touch, firmware should support data
+ * which is required related app ex) MT_ANGLE, MT_PALM ...
+ * Synpatics IC report those data through F51's edge swipe
+ * fucntionality.
+ */
+#define SYNAPTICS_PRODUCT_ID_B0	"SY 01"
+#define SYNAPTICS_PRODUCT_ID_B0_SPAIR	"S5000B"
+
+#if defined(CONFIG_MACH_JACTIVE_EUR) || defined(CONFIG_MACH_JACTIVE_ATT)
+#define FW_IMAGE_NAME_B0_HSYNC		"tsp_synaptics/jactive/synaptics_b0_hsync.fw"
+#define FW_IMAGE_NAME_B0_HSYNC_FAC	"tsp_synaptics/jactive/synaptics_b0_hsync_fac.fw"
+#define FW_IMAGE_NAME_B0_HSYNC04	"tsp_synaptics/jactive/synaptics_b0_hsync04.fw"
+#define FW_IMAGE_NAME_B0_HSYNC04_FAC	"tsp_synaptics/jactive/synaptics_b0_hsync04_fac.fw"
+
+/* NON HYNC F/W will be removed */
+/* PRODUCT ID : SY 01, SY 02, S5000B */
+#define FW_IMAGE_NAME_B0_NON_HSYNC	"tsp_synaptics/jactive/synaptics_b0_non_hsync.fw"
+#define FW_IMAGE_NAME_B0_NON_HSYNC_FAC	"tsp_synaptics/jactive/synaptics_b0_non_hsync_fac.fw"
+
+#else
+#define FW_IMAGE_NAME_A1			"tsp_synaptics/synaptics_a1.fw"
+#define FW_IMAGE_NAME_B0_34			"tsp_synaptics/synaptics_b0_3_4.fw"
+#endif
+#define FW_IMAGE_NAME_B0_40			"tsp_synaptics/synaptics_b0_4_0.fw"
+#define FW_IMAGE_NAME_B0_43			"tsp_synaptics/synaptics_b0_4_3.fw"
+#define FW_IMAGE_NAME_B0_51			"tsp_synaptics/synaptics_b0_5_1.fw"
+#define FW_IMAGE_NAME_B0_FAC		"tsp_synaptics/synaptics_b0_fac.fw"
+#define FW_IMAGE_NAME_B0_5_1_FAC	"tsp_synaptics/synaptics_b0_5_1_fac.fw"
+#define SYNAPTICS_FW_UMS			"/sdcard/synaptics.fw"
+
+#if defined(CONFIG_MACH_JACTIVE_EUR) || defined(CONFIG_MACH_JACTIVE_ATT)
+#define FW_IMAGE_TEST	"tsp_synaptics/synaptics_d0.fw"
+#define SYNAPTICS_DEVICE_NAME		"GT-I9295"
+#else
+#define SYNAPTICS_DEVICE_NAME		"SGH-I337"
+#endif
+#define SYNAPTICS_MAX_FW_PATH	64
+
+#define DATE_OF_FIRMWARE_BIN_OFFSET	0xEF00
+#define IC_REVISION_BIN_OFFSET	0xEF02
+#define FW_VERSION_BIN_OFFSET	0xEF03
+
+#define PDT_PROPS (0X00EF)
+#define PDT_START (0x00E9)
+#define PDT_END (0x000A)
+#define PDT_ENTRY_SIZE (0x0006)
+#define PAGES_TO_SERVICE (10)
+#define PAGE_SELECT_LEN (2)
+
+#define SYNAPTICS_RMI4_F01 (0x01)
+#define SYNAPTICS_RMI4_F11 (0x11)
+#define SYNAPTICS_RMI4_F12 (0x12)
+#define SYNAPTICS_RMI4_F1A (0x1a)
+#define SYNAPTICS_RMI4_F34 (0x34)
+#define SYNAPTICS_RMI4_F51 (0x51)
+#define SYNAPTICS_RMI4_F54 (0x54)
+
+#define SYNAPTICS_RMI4_PRODUCT_INFO_SIZE 2
+#define SYNAPTICS_RMI4_DATE_CODE_SIZE 3
+#define SYNAPTICS_RMI4_PRODUCT_ID_SIZE 10
+#define SYNAPTICS_RMI4_BUILD_ID_SIZE 3
+#define SYNAPTICS_RMI4_PRODUCT_ID_LENGTH 10
+
+#define MAX_NUMBER_OF_BUTTONS 4
+#define MAX_INTR_REGISTERS 4
+#define MAX_NUMBER_OF_FINGERS 10
+
+#define MASK_16BIT 0xFFFF
+#define MASK_8BIT 0xFF
+#define MASK_7BIT 0x7F
+#define MASK_6BIT 0x3F
+#define MASK_5BIT 0x1F
+#define MASK_4BIT 0x0F
+#define MASK_3BIT 0x07
+#define MASK_2BIT 0x03
+#define MASK_1BIT 0x01
+
+/*
+ * struct synaptics_rmi4_fn_desc - function descriptor fields in PDT
+ * @query_base_addr: base address for query registers
+ * @cmd_base_addr: base address for command registers
+ * @ctrl_base_addr: base address for control registers
+ * @data_base_addr: base address for data registers
+ * @intr_src_count: number of interrupt sources
+ * @fn_number: function number
+ */
+struct synaptics_rmi4_fn_desc {
+	unsigned char query_base_addr;
+	unsigned char cmd_base_addr;
+	unsigned char ctrl_base_addr;
+	unsigned char data_base_addr;
+	unsigned char intr_src_count;
+	unsigned char fn_number;
+};
+
+/*
+ * synaptics_rmi4_fn_full_addr - full 16-bit base addresses
+ * @query_base: 16-bit base address for query registers
+ * @cmd_base: 16-bit base address for data registers
+ * @ctrl_base: 16-bit base address for command registers
+ * @data_base: 16-bit base address for control registers
+ */
+struct synaptics_rmi4_fn_full_addr {
+	unsigned short query_base;
+	unsigned short cmd_base;
+	unsigned short ctrl_base;
+	unsigned short data_base;
+};
+
+/*
+ * struct synaptics_rmi4_fn - function handler data structure
+ * @fn_number: function number
+ * @num_of_data_sources: number of data sources
+ * @num_of_data_points: maximum number of fingers supported
+ * @size_of_data_register_block: data register block size
+ * @data1_offset: offset to data1 register from data base address
+ * @intr_reg_num: index to associated interrupt register
+ * @intr_mask: interrupt mask
+ * @full_addr: full 16-bit base addresses of function registers
+ * @link: linked list for function handlers
+ * @data_size: size of private data
+ * @data: pointer to private data
+ */
+struct synaptics_rmi4_fn {
+	unsigned char fn_number;
+	unsigned char num_of_data_sources;
+	unsigned char num_of_data_points;
+	unsigned char size_of_data_register_block;
+	unsigned char data1_offset;
+	unsigned char intr_reg_num;
+	unsigned char intr_mask;
+	struct synaptics_rmi4_fn_full_addr full_addr;
+	struct list_head link;
+	int data_size;
+	void *data;
+};
+
+/*
+ * struct synaptics_rmi4_device_info - device information
+ * @version_major: rmi protocol major version number
+ * @version_minor: rmi protocol minor version number
+ * @manufacturer_id: manufacturer id
+ * @product_props: product properties information
+ * @product_info: product info array
+ * @date_code: device manufacture date
+ * @tester_id: tester id array
+ * @serial_number: device serial number
+ * @product_id_string: device product id
+ * @support_fn_list: linked list for function handlers
+ */
+struct synaptics_rmi4_device_info {
+	unsigned int version_major;
+	unsigned int version_minor;
+	unsigned char manufacturer_id;
+	unsigned char product_props;
+	unsigned char product_info[SYNAPTICS_RMI4_PRODUCT_INFO_SIZE];
+	unsigned char date_code[SYNAPTICS_RMI4_DATE_CODE_SIZE];
+	unsigned short tester_id;
+	unsigned short serial_number;
+	unsigned char product_id_string[SYNAPTICS_RMI4_PRODUCT_ID_SIZE + 1];
+	unsigned char build_id[SYNAPTICS_RMI4_BUILD_ID_SIZE];
+	struct list_head support_fn_list;
+};
+
+/**
+ * struct synaptics_finger - Represents fingers.
+ * @ state: finger status.
+ * @ mcount: moving counter for debug.
+ */
+struct synaptics_finger {
+	unsigned char state;
+	unsigned short mcount;
+};
+
+/*
+ * struct synaptics_rmi4_data - rmi4 device instance data
+ * @i2c_client: pointer to associated i2c client
+ * @input_dev: pointer to associated input device
+ * @board: constant pointer to platform data
+ * @rmi4_mod_info: device information
+ * @regulator: pointer to associated regulator
+ * @rmi4_io_ctrl_mutex: mutex for i2c i/o control
+ * @early_suspend: instance to support early suspend power management
+ * @current_page: current page in sensor to acess
+ * @button_0d_enabled: flag for 0d button support
+ * @full_pm_cycle: flag for full power management cycle in early suspend stage
+ * @num_of_intr_regs: number of interrupt registers
+ * @f01_query_base_addr: query base address for f01
+ * @f01_cmd_base_addr: command base address for f01
+ * @f01_ctrl_base_addr: control base address for f01
+ * @f01_data_base_addr: data base address for f01
+ * @irq: attention interrupt
+ * @sensor_max_x: sensor maximum x value
+ * @sensor_max_y: sensor maximum y value
+ * @irq_enabled: flag for indicating interrupt enable status
+ * @touch_stopped: flag to stop interrupt thread processing
+ * @fingers_on_2d: flag to indicate presence of fingers in 2d area
+ * @sensor_sleep: flag to indicate sleep state of sensor
+ * @wait: wait queue for touch data polling in interrupt thread
+ * @i2c_read: pointer to i2c read function
+ * @i2c_write: pointer to i2c write function
+ * @irq_enable: pointer to irq enable function
+ */
+
+struct synaptics_rmi4_data {
+	struct i2c_client *i2c_client;
+	struct input_dev *input_dev;
+	const struct synaptics_rmi4_platform_data *board;
+	struct synaptics_rmi4_device_info rmi4_mod_info;
+	struct regulator *regulator;
+	struct mutex rmi4_reset_mutex;
+	struct mutex rmi4_io_ctrl_mutex;
+	struct mutex rmi4_reflash_mutex;
+	struct timer_list f51_finger_timer;
+#ifdef CONFIG_HAS_EARLYSUSPEND
+	struct early_suspend early_suspend;
+#endif
+	unsigned char *firmware_image;
+
+	struct completion init_done;
+	struct synaptics_finger finger[MAX_NUMBER_OF_FINGERS];
+
+	unsigned char current_page;
+	unsigned char button_0d_enabled;
+	unsigned char full_pm_cycle;
+	unsigned char num_of_rx;
+	unsigned char num_of_tx;
+	unsigned char num_of_node;
+	unsigned char num_of_fingers;
+	unsigned char max_touch_width;
+	unsigned char intr_mask[MAX_INTR_REGISTERS];
+	unsigned short num_of_intr_regs;
+	unsigned short f01_query_base_addr;
+	unsigned short f01_cmd_base_addr;
+	unsigned short f01_ctrl_base_addr;
+	unsigned short f01_data_base_addr;
+	int irq;
+	int sensor_max_x;
+	int sensor_max_y;
+	int touch_threshold;
+	int gloved_sensitivity;
+	int ta_status;
+	bool flash_prog_mode; /* prog_mod == TRUE ?  boot mode : normal mode */
+	bool irq_enabled;
+	bool touch_stopped;
+	bool fingers_on_2d;
+	bool f51_finger;
+	bool sensor_sleep;
+	bool stay_awake;
+	bool staying_awake;
+	bool fast_glove_state;
+
+	int ic_revision_of_ic;		/* revision of reading from IC */
+	int fw_version_of_ic;		/* firmware version of IC */
+	int ic_revision_of_bin;		/* revision of reading from binary */
+	int fw_version_of_bin;		/* firmware version of binary */
+	int fw_release_date_of_ic;	/* Config release data from IC */
+	int panel_revision;		/* Octa panel revision */
+	bool doing_reflash;
+
+#ifdef CONFIG_GLOVE_TOUCH
+	int glove_touch_addr;
+	bool touchkey_glove_mode_status;
+	unsigned char glove_mode_feature;
+	unsigned char glove_mode_enables;
+	unsigned short glove_mode_enables_addr;
+#endif
+
+#ifdef TSP_BOOSTER
+	struct delayed_work	work_dvfs_off;
+	struct delayed_work	work_dvfs_chg;
+	struct mutex		dvfs_lock;
+	bool dvfs_lock_status;
+	int dvfs_old_stauts;
+	int dvfs_boost_mode;
+	int dvfs_freq;
+#endif
+
+	struct delayed_work work_init_power_on;
+	struct delayed_work	work_rezero;
+
+	void (*register_cb)(struct synaptics_rmi_callbacks *);
+	struct synaptics_rmi_callbacks callbacks;
+
+	int (*i2c_read)(struct synaptics_rmi4_data *pdata, unsigned short addr,
+			unsigned char *data, unsigned short length);
+	int (*i2c_write)(struct synaptics_rmi4_data *pdata, unsigned short addr,
+			unsigned char *data, unsigned short length);
+	int (*irq_enable)(struct synaptics_rmi4_data *rmi4_data, bool enable);
+	int (*reset_device)(struct synaptics_rmi4_data *rmi4_data);
+};
+
+enum exp_fn {
+	RMI_DEV = 0,
+	RMI_F54,
+	RMI_FW_UPDATER,
+	RMI_LAST,
+};
+
+struct synaptics_rmi4_exp_fn_ptr {
+	int (*read)(struct synaptics_rmi4_data *rmi4_data, unsigned short addr,
+			unsigned char *data, unsigned short length);
+	int (*write)(struct synaptics_rmi4_data *rmi4_data, unsigned short addr,
+			unsigned char *data, unsigned short length);
+	int (*enable)(struct synaptics_rmi4_data *rmi4_data, bool enable);
+};
+
+int synaptics_rmi4_new_function(enum exp_fn fn_type,
+		int (*func_init)(struct synaptics_rmi4_data *rmi4_data),
+		void (*func_remove)(struct synaptics_rmi4_data *rmi4_data),
+		void (*func_attn)(struct synaptics_rmi4_data *rmi4_data,
+				unsigned char intr_mask));
+
+int rmidev_module_register(void);
+int rmi4_f54_module_register(void);
+int synaptics_rmi4_f54_set_control(struct synaptics_rmi4_data *rmi4_data);
+
+int rmi4_fw_update_module_register(void);
+
+int synaptics_fw_updater(unsigned char *fw_data, bool mode, bool factory_fw);
+int synaptics_rmi4_glove_mode_enables(struct synaptics_rmi4_data *rmi4_data);
+
+int synaptics_rmi4_reset_device(struct synaptics_rmi4_data *rmi4_data);
+int synaptics_proximity_no_sleep_set(bool enables);
+void synaptics_rmi4_f51_set_custom_rezero(struct synaptics_rmi4_data *rmi4_data);
+
+extern int synaptics_rmi4_proximity_enables(unsigned char enables);
+
+extern struct class *sec_class;
+static inline ssize_t synaptics_rmi4_show_error(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	dev_warn(dev, "%s Attempted to read from write-only attribute %s\n",
+			__func__, attr->attr.name);
+	return -EPERM;
+}
+
+static inline ssize_t synaptics_rmi4_store_error(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	dev_warn(dev, "%s Attempted to write to read-only attribute %s\n",
+			__func__, attr->attr.name);
+	return -EPERM;
+}
+
+static inline void batohs(unsigned short *dest, unsigned char *src)
+{
+	*dest = src[1] * 0x100 + src[0];
+}
+
+static inline void hstoba(unsigned char *dest, unsigned short src)
+{
+	dest[0] = src % 0x100;
+	dest[1] = src / 0x100;
+}
+#ifdef CONFIG_FB_MSM_MIPI_SAMSUNG_OCTA_VIDEO_FULL_HD_PT_PANEL
+extern int touch_display_status;
+#endif
+#endif
-- 
1.8.3.2

