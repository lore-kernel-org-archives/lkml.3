Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582AbaJPHXn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 03:23:43 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.147]:38838 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751542AbaJPHXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 03:23:40 -0400
X-Env-Sender: Andreas.Werner@men.de
X-Msg-Ref: server-14.tower-180.messagelabs.com!1413444218!36573762!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.12.2; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Thu, 16 Oct 2014 09:23:38 +0200
Date: Thu, 16 Oct 2014 10:15:08 +0200
From: Andreas Werner <andreas.werner@men.de>
To: <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <wsa@the-dreams.de>,
        <linux-i2c@vger.kernel.org>, <johannes.thumshirn@men.de>,
        <andreas.werner@men.de>
Subject: [PATCH 1/2] drivers/misc/eeprom/men_eeprod: Introduce MEN Board
 Information EEPROM driver
Message-ID: <d169930cfe45d4c05c79f7dd00471d732441529d.1413416105.git.andreas.werner@men.de>
References: <cover.1413416105.git.andreas.werner@men.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1413416105.git.andreas.werner@men.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [192.1.1.171]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added driver to support the MEN Board Information EEPROM.
The driver exports the production information as read only sysfs
entries, as well as a user section which is read/write accessible.

Tested on PPC QorIQ and Intel Atom E680.

Tested-by: Johannes Thumshirn <johannes.thumshirn@men.de>
Signed-off-by: Andreas Werner <andreas.werner@men.de>
---
 MAINTAINERS                      |   6 +
 drivers/misc/eeprom/Kconfig      |  10 +
 drivers/misc/eeprom/Makefile     |   1 +
 drivers/misc/eeprom/men_eeprod.c | 560 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 577 insertions(+)
 create mode 100644 drivers/misc/eeprom/men_eeprod.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 503da28..88ede76 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6029,6 +6029,12 @@ F:	drivers/leds/leds-menf21bmc.c
 F:	drivers/hwmon/menf21bmc_hwmon.c
 F:	Documentation/hwmon/menf21bmc
 
+MEN EEPROD (Board information EEPROM)
+M:	Andreas Werner <andreas.werner@men.de>
+S:	Supported
+F:	drivers/misc/eeprom/men_eeprod.c
+F:	Documentation/ABI/testing/sysfs-bus-i2c-devices-men_eeprod
+
 METAG ARCHITECTURE
 M:	James Hogan <james.hogan@imgtec.com>
 L:	linux-metag@vger.kernel.org
diff --git a/drivers/misc/eeprom/Kconfig b/drivers/misc/eeprom/Kconfig
index 9536852f..e087d08 100644
--- a/drivers/misc/eeprom/Kconfig
+++ b/drivers/misc/eeprom/Kconfig
@@ -62,6 +62,16 @@ config EEPROM_MAX6875
 	  This driver can also be built as a module.  If so, the module
 	  will be called max6875.
 
+config EEPROM_MEN_EEPROD
+	tristate "MEN Board Information EEPROM"
+	depends on I2C && SYSFS
+	help
+	  If you say yes here you get support for the MEN Board Information
+	  EEPROM. This driver supports read-only access to the production
+	  data section, and read-write access to the user section.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called men_eeprod.
 
 config EEPROM_93CX6
 	tristate "EEPROM 93CX6 support"
diff --git a/drivers/misc/eeprom/Makefile b/drivers/misc/eeprom/Makefile
index 9507aec..8c70a81 100644
--- a/drivers/misc/eeprom/Makefile
+++ b/drivers/misc/eeprom/Makefile
@@ -2,6 +2,7 @@ obj-$(CONFIG_EEPROM_AT24)	+= at24.o
 obj-$(CONFIG_EEPROM_AT25)	+= at25.o
 obj-$(CONFIG_EEPROM_LEGACY)	+= eeprom.o
 obj-$(CONFIG_EEPROM_MAX6875)	+= max6875.o
+obj-$(CONFIG_EEPROM_MEN_EEPROD) += men_eeprod.o
 obj-$(CONFIG_EEPROM_93CX6)	+= eeprom_93cx6.o
 obj-$(CONFIG_EEPROM_93XX46)	+= eeprom_93xx46.o
 obj-$(CONFIG_EEPROM_SUNXI_SID)	+= sunxi_sid.o
diff --git a/drivers/misc/eeprom/men_eeprod.c b/drivers/misc/eeprom/men_eeprod.c
new file mode 100644
index 0000000..28264df
--- /dev/null
+++ b/drivers/misc/eeprom/men_eeprod.c
@@ -0,0 +1,560 @@
+/*
+ *  men_eeprod - MEN board information EEPROM driver.
+ *
+ *  This is the driver for the Board Information EEPROM on almost
+ *  all of the MEN boards.
+ *  The driver exports each of the predefined eeprom sections as sysfs entries
+ *  including an entry for user data.
+ *
+ *  The EEPROM can be normally found at I2C address 0x57.
+ *
+ *  Copyright (C) 2014 MEN Mikro Elektronik Nuernberg GmbH
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ */
+
+/*
+ * Supports the following EEPROM layouts:
+ *
+ * Name		eeprod_id	user_section size
+ * ----------------------------------------------
+ * EEPROD2	0x0E		232 byte
+ *
+ * See Documentation/ABI/testing/sysfs-bus-i2c-devices-men_eeprod
+ * for more details.
+ */
+
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/jiffies.h>
+#include <linux/delay.h>
+#include <linux/sysfs.h>
+
+#define EEPROM_ID_ADDR	0x00
+#define EEPROM_SIZE	256
+#define EEPROD2_ID	0x0E
+
+#define DATE_YEAR_BIAS	1990
+
+/*
+ * Internal structure of the Board Information EEPROM
+ * production data section
+ */
+struct eeprom_data {
+	uint8_t eeprod_id;
+
+	uint8_t revision[3];
+	uint32_t serialnr;
+	uint8_t board_model;
+	char hw_name[6];
+
+	uint8_t reserved;
+
+	__be16 prod_date;
+	__be16 rep_date;
+
+	uint8_t reserved2[4];
+};
+
+struct men_eeprod_data {
+	struct bin_attribute user_section;
+	struct i2c_client *client;
+	struct eeprom_data eeprom;
+	struct mutex lock;
+	int smb_access;
+};
+
+static unsigned int i2c_timeout = 25;
+module_param(i2c_timeout, uint, 0);
+MODULE_PARM_DESC(i2c_timeout, "Time (in ms) to try reads and writes (default 25)");
+
+#define OFFSET_TO_USR_SECTION(off) (off + sizeof(struct eeprom_data))
+
+static inline int eeprod_get_day(__be16 eeprod_date)
+{
+	return be16_to_cpu(eeprod_date) & 0x001f;
+}
+
+static inline int eeprod_get_month(__be16 eeprod_date)
+{
+	return (be16_to_cpu(eeprod_date) >> 5) & 0x000f;
+}
+
+static inline int eeprod_get_year(__be16 eeprod_date)
+{
+	return ((be16_to_cpu(eeprod_date) >> 9) & 0x007f) + DATE_YEAR_BIAS;
+}
+
+static ssize_t men_eeprom_read(struct men_eeprod_data *drv_data,
+			       char *buf, loff_t offset, size_t count)
+{
+	struct i2c_client *i2c_client = drv_data->client;
+	unsigned long timeout, read_time;
+	int ret_val;
+
+	/*
+	 * Read fail if the previous write did not copmlete yet.
+	 * Therefore we try to read a few times until this succeed.
+	 */
+	timeout = jiffies + msecs_to_jiffies(i2c_timeout);
+	do {
+		read_time = jiffies;
+
+		/*
+		 * if there is just one byte requested, we use read byte data.
+		 * This will also protect us against a rollover if there is
+		 * just one byte left to read.
+		 */
+		if (count == 1) {
+			ret_val = i2c_smbus_read_byte_data(i2c_client, offset);
+			if (ret_val >= 0) {
+				buf[0] = ret_val;
+				ret_val = 1;
+			}
+			goto err_byte;
+		}
+
+		switch (drv_data->smb_access) {
+		case I2C_SMBUS_I2C_BLOCK_DATA:
+			if (count > I2C_SMBUS_BLOCK_MAX)
+				count = I2C_SMBUS_BLOCK_MAX;
+
+			ret_val = i2c_smbus_read_i2c_block_data(i2c_client,
+								offset, count,
+								buf);
+			if (ret_val >= 0)
+				return count;
+			break;
+		case I2C_SMBUS_WORD_DATA:
+			ret_val = i2c_smbus_read_word_data(i2c_client, offset);
+			if (ret_val >= 0) {
+				buf[0] = ret_val & 0xff;
+				buf[1] = ret_val >> 8;
+				return 2;
+			}
+			break;
+		default:
+			ret_val = i2c_smbus_read_byte_data(i2c_client, offset);
+			if (ret_val >= 0) {
+				buf[0] = ret_val;
+				return 1;
+			}
+			break;
+		}
+
+err_byte:
+		usleep_range(600, 1000);
+	} while (time_before(read_time, timeout));
+
+	return -ETIMEDOUT;
+
+}
+
+static ssize_t men_user_section_read(struct file *filp, struct kobject *kobj,
+				     struct bin_attribute *attr,
+				     char *buf, loff_t off, size_t count)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct men_eeprod_data *drv_data = dev_get_drvdata(dev);
+	int user_section_size = attr->size;
+	ssize_t retval = 0;
+	int bytes_read;
+
+	if (off > user_section_size)
+		return 0;
+
+	if (off + count > user_section_size)
+		count = user_section_size - off;
+
+	off = OFFSET_TO_USR_SECTION(off);
+
+	mutex_lock(&drv_data->lock);
+	while (count) {
+		bytes_read = men_eeprom_read(drv_data, buf, off, count);
+
+		if (bytes_read <= 0) {
+			if (retval == 0)
+				retval = bytes_read;
+			break;
+		}
+
+		buf += bytes_read;
+		off += bytes_read;
+		count -= bytes_read;
+		retval += bytes_read;
+	}
+	mutex_unlock(&drv_data->lock);
+
+	return retval;
+}
+
+static ssize_t men_eeprom_write(struct men_eeprod_data *drv_data,
+				char *buf, loff_t offset, size_t count)
+{
+	struct i2c_client *i2c_client = drv_data->client;
+	unsigned long timeout, write_time;
+	uint16_t word_data;
+	int ret_val;
+
+	/*
+	 * Write fail if the previous write did not copmlete yet.
+	 * Therefore we try to write a few times until this succeed.
+	 */
+	timeout = jiffies + msecs_to_jiffies(i2c_timeout);
+	do {
+		write_time = jiffies;
+
+		/*
+		 * if there is just one byte to write, we use write byte data.
+		 * This will also protect us against a rollover if there is
+		 * just one byte left to write.
+		 */
+		if (count == 1) {
+			ret_val =  i2c_smbus_write_byte_data(i2c_client, offset,
+							     buf[0]);
+			if (!ret_val)
+				return 1;
+			goto err_byte;
+		}
+
+		switch (drv_data->smb_access) {
+		case I2C_SMBUS_I2C_BLOCK_DATA:
+			if (count > I2C_SMBUS_BLOCK_MAX)
+				count = I2C_SMBUS_BLOCK_MAX;
+
+			ret_val = i2c_smbus_write_i2c_block_data(i2c_client,
+								 offset, count,
+								 buf);
+			if (!ret_val)
+				return count;
+			break;
+		case I2C_SMBUS_WORD_DATA:
+			word_data = buf[0] | (buf[1] << 8);
+
+			ret_val = i2c_smbus_write_word_data(i2c_client, offset,
+							    word_data);
+			if (!ret_val)
+				return 2;
+			break;
+		default:
+			ret_val = i2c_smbus_write_byte_data(i2c_client, offset,
+							    buf[0]);
+			if (!ret_val)
+				return 1;
+			break;
+		}
+err_byte:
+		usleep_range(600, 1000);
+	} while (time_before(write_time, timeout));
+
+	return -ETIMEDOUT;
+}
+
+static ssize_t men_user_section_write(struct file *filp, struct kobject *kobj,
+				      struct bin_attribute *attr, char *buf,
+				      loff_t off, size_t count)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct men_eeprod_data *drv_data = dev_get_drvdata(dev);
+	int user_section_size = attr->size;
+	int bytes_written;
+	ssize_t retval = 0;
+
+	if (off > user_section_size)
+		return 0;
+
+	if (off + count > user_section_size)
+		count = user_section_size - off;
+
+	off = OFFSET_TO_USR_SECTION(off);
+
+	mutex_lock(&drv_data->lock);
+	while (count) {
+		bytes_written = men_eeprom_write(drv_data, buf, off, count);
+
+		if (bytes_written <= 0) {
+			if (retval == 0)
+				retval = bytes_written;
+			break;
+		}
+
+		buf += bytes_written;
+		off += bytes_written;
+		count -= bytes_written;
+		retval += bytes_written;
+	}
+	mutex_unlock(&drv_data->lock);
+
+	return retval;
+}
+
+static ssize_t
+show_eeprod_id(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct men_eeprod_data *drv_data = dev_get_drvdata(dev);
+	struct eeprom_data *eeprom = &drv_data->eeprom;
+
+	return sprintf(buf, "0x%02x\n", eeprom->eeprod_id);
+}
+
+static ssize_t
+show_revision(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct men_eeprod_data *drv_data = dev_get_drvdata(dev);
+	struct eeprom_data *eeprom = &drv_data->eeprom;
+
+	return sprintf(buf, "%02d.%02d.%02d\n", eeprom->revision[0],
+		       eeprom->revision[1], eeprom->revision[2]);
+}
+
+static ssize_t
+show_serialnr(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct men_eeprod_data *drv_data = dev_get_drvdata(dev);
+	struct eeprom_data *eeprom = &drv_data->eeprom;
+
+	return sprintf(buf, "%d\n", cpu_to_be32(eeprom->serialnr));
+}
+
+static ssize_t
+show_hw_name(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct men_eeprod_data *drv_data = dev_get_drvdata(dev);
+	struct eeprom_data *eeprom = &drv_data->eeprom;
+
+	return sprintf(buf, "%s%02d\n", eeprom->hw_name, eeprom->board_model);
+}
+
+static ssize_t
+show_prod_date(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct men_eeprod_data *drv_data = dev_get_drvdata(dev);
+	__be16 eeprod_date = drv_data->eeprom.prod_date;
+
+	return sprintf(buf, "%04d-%02d-%02d\n",
+		       eeprod_get_year(eeprod_date),
+		       eeprod_get_month(eeprod_date),
+		       eeprod_get_day(eeprod_date));
+}
+
+static ssize_t
+show_rep_date(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct men_eeprod_data *drv_data = dev_get_drvdata(dev);
+	__be16 eeprod_date = drv_data->eeprom.rep_date;
+
+	/*
+	 * could be empty if the board was never send back
+	 * to the repair department.
+	 */
+	if (eeprod_date == cpu_to_be16(0xffff))
+		return -EINVAL;
+
+	return sprintf(buf, "%04d-%02d-%02d\n",
+		       eeprod_get_year(eeprod_date),
+		       eeprod_get_month(eeprod_date),
+		       eeprod_get_day(eeprod_date));
+}
+
+static DEVICE_ATTR(eeprod_id, S_IRUGO, show_eeprod_id, NULL);
+static DEVICE_ATTR(revision, S_IRUGO, show_revision, NULL);
+static DEVICE_ATTR(serial, S_IRUGO, show_serialnr, NULL);
+static DEVICE_ATTR(hw_name, S_IRUGO, show_hw_name, NULL);
+static DEVICE_ATTR(prod_date, S_IRUGO, show_prod_date, NULL);
+static DEVICE_ATTR(rep_date, S_IRUGO, show_rep_date, NULL);
+
+static struct attribute *eeprod_attrs[] = {
+	&dev_attr_eeprod_id.attr,
+	&dev_attr_revision.attr,
+	&dev_attr_serial.attr,
+	&dev_attr_hw_name.attr,
+	&dev_attr_prod_date.attr,
+	&dev_attr_rep_date.attr,
+	NULL,
+};
+
+static struct attribute_group eeprod_attr_group = {
+	.attrs = eeprod_attrs,
+};
+
+static struct bin_attribute eeprom_user_attr = {
+	.attr = {
+		.name = "user_section",
+		.mode = S_IRUGO | S_IWUSR,
+	},
+	.size = EEPROM_SIZE - sizeof(struct eeprom_data),
+	.read = men_user_section_read,
+	.write = men_user_section_write,
+};
+
+static int men_eeprod_read_prod_data(struct men_eeprod_data *drv_data)
+{
+	struct eeprom_data *eeprom = &drv_data->eeprom;
+	uint8_t *eeprom_byte;
+	int i, ret;
+
+	eeprom_byte = (uint8_t *)eeprom + 1;
+
+	for (i = 1; i < sizeof(*eeprom); i++) {
+		ret = i2c_smbus_read_byte_data(drv_data->client, i);
+		if (ret < 0)
+			return ret;
+
+		*(eeprom_byte++) = ret;
+	}
+	return 0;
+}
+
+static int men_eeprod_calc_parity(struct eeprom_data *eeprom)
+{
+	uint8_t *eeprom_byte;
+	int parity, len;
+
+	eeprom_byte = (uint8_t *)eeprom + 1;
+	len = sizeof(*eeprom) - 1;
+	parity = 0x0f;
+
+	while (len--) {
+		parity ^= (*eeprom_byte >> 4);
+		parity ^= (*eeprom_byte) & 0x0f;
+		eeprom_byte++;
+	}
+
+	return parity;
+}
+
+static int men_eeprod_i2c_functionality(struct men_eeprod_data *drv_data)
+{
+	struct i2c_adapter *i2c_adapter = drv_data->client->adapter;
+	int ret;
+
+	/*
+	 * As the minimum we need read/write byte data
+	 * which every adapter should support
+	 */
+	ret = i2c_check_functionality(i2c_adapter,
+				      I2C_FUNC_SMBUS_BYTE_DATA);
+	if (!ret)
+		return -ENODEV;
+
+	if (i2c_check_functionality(i2c_adapter,
+				    I2C_FUNC_SMBUS_I2C_BLOCK)) {
+		drv_data->smb_access = I2C_SMBUS_I2C_BLOCK_DATA;
+	} else if (i2c_check_functionality(i2c_adapter,
+					   I2C_FUNC_SMBUS_WORD_DATA)) {
+		drv_data->smb_access = I2C_SMBUS_WORD_DATA;
+	} else {
+		drv_data->smb_access = I2C_SMBUS_BYTE_DATA;
+	}
+
+	return 0;
+}
+
+static int
+men_eeprod_probe(struct i2c_client *client, const struct i2c_device_id *id)
+{
+	struct men_eeprod_data *drv_data;
+	int eeprod_id, eeprod_chksum;
+	int parity, ret;
+
+	drv_data = devm_kzalloc(&client->dev, sizeof(*drv_data), GFP_KERNEL);
+	if (!drv_data)
+		return -ENOMEM;
+
+	drv_data->client = client;
+	mutex_init(&drv_data->lock);
+
+	i2c_set_clientdata(client, drv_data);
+
+	ret = men_eeprod_i2c_functionality(drv_data);
+	if (ret)
+		return ret;
+
+	eeprod_id = i2c_smbus_read_byte_data(client, EEPROM_ID_ADDR);
+	if (eeprod_id < 0)
+		return eeprod_id;
+
+	eeprod_chksum = eeprod_id & 0x0f;
+	eeprod_id >>= 4;
+	drv_data->eeprom.eeprod_id = eeprod_id;
+
+	if (eeprod_id == EEPROD2_ID) {
+		dev_info(&client->dev,
+			 "found MEN Board EEPROM. ID: 0x%02x\n", eeprod_id);
+	} else {
+		dev_err(&client->dev,
+			"board eeprom not supported. ID: 0x%02x\n", eeprod_id);
+		return -ENXIO;
+	}
+
+	ret = men_eeprod_read_prod_data(drv_data);
+	if (ret < 0) {
+		dev_err(&client->dev, "failed to read EEPROM board data\n");
+		return ret;
+	}
+
+	parity = men_eeprod_calc_parity(&drv_data->eeprom);
+	if (parity != eeprod_chksum) {
+		dev_err(&client->dev, "checksum error. eeprom in invalid state\n");
+		return -EINVAL;
+	}
+
+	drv_data->user_section = eeprom_user_attr;
+	ret = sysfs_create_bin_file(&client->dev.kobj,
+				    &drv_data->user_section);
+	if (ret) {
+		dev_err(&client->dev,
+			"failed to create user_section sysfs entry\n");
+		return ret;
+	}
+
+	ret = sysfs_create_group(&client->dev.kobj, &eeprod_attr_group);
+	if (ret < 0) {
+		dev_err(&client->dev, "failed to create sysfs entries\n");
+		goto err_sysfs;
+	}
+
+	dev_info(&client->dev, "MEN Board Information EEPROM registered\n");
+
+	return 0;
+
+err_sysfs:
+	sysfs_remove_bin_file(&client->dev.kobj, &drv_data->user_section);
+	return ret;
+}
+
+static int men_eeprod_remove(struct i2c_client *client)
+{
+	struct men_eeprod_data *drv_data = i2c_get_clientdata(client);
+
+	sysfs_remove_group(&client->dev.kobj, &eeprod_attr_group);
+	sysfs_remove_bin_file(&client->dev.kobj, &drv_data->user_section);
+	return 0;
+}
+
+static const struct i2c_device_id men_eeprod_ids[] = {
+	{ "men_eeprod" },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, men_eeprod_ids);
+
+static struct i2c_driver men_eeprod_driver = {
+	.driver = {
+		.name = "men_eeprod",
+		.owner = THIS_MODULE,
+	},
+	.probe = men_eeprod_probe,
+	.remove = men_eeprod_remove,
+	.id_table = men_eeprod_ids,
+};
+
+module_i2c_driver(men_eeprod_driver);
+
+MODULE_DESCRIPTION("MEN Board Information EEPROM driver");
+MODULE_AUTHOR("Andreas Werner <andreas.werner@men.de>");
+MODULE_LICENSE("GPL v2");
-- 
2.1.0

