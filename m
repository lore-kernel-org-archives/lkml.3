Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab3J3TR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 15:17:58 -0400
Received: from fifo99.com ([67.223.236.141]:33621 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533Ab3J3TR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 15:17:57 -0400
From: Daniel Walker <dwalker@fifo99.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] drivers: misc: stcam: Renesas stcam device
Date: Wed, 30 Oct 2013 12:17:48 -0700
Message-Id: <1383160668-8403-1-git-send-email-dwalker@fifo99.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a driver for the ternary content addressable memory unit from Renesas. It
allows filtering on bits, and wildcards thru the chip.

Signed-off-by: Daniel Walker <dwalker@fifo99.com>
---
 drivers/misc/Kconfig  |   7 +
 drivers/misc/Makefile |   1 +
 drivers/misc/stcam.c  | 348 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 356 insertions(+)
 create mode 100644 drivers/misc/stcam.c

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 8dacd4c..1f9bc31 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -528,6 +528,13 @@ config SRAM
 	  the genalloc API. It is supposed to be used for small on-chip SRAM
 	  areas found on many SoCs.
 
+config STCAM
+	bool "Renesas stcam device"
+	help    
+	  This is a ternary content addressable memory unit (TCAM) from Renesas. It
+	  allows filtering on bits, and wildcards.
+ 
+
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index c235d5b..30d413e 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -53,3 +53,4 @@ obj-$(CONFIG_INTEL_MEI)		+= mei/
 obj-$(CONFIG_VMWARE_VMCI)	+= vmw_vmci/
 obj-$(CONFIG_LATTICE_ECP3_CONFIG)	+= lattice-ecp3-config.o
 obj-$(CONFIG_SRAM)		+= sram.o
+obj-$(CONFIG_STCAM)		+= stcam.o
diff --git a/drivers/misc/stcam.c b/drivers/misc/stcam.c
new file mode 100644
index 0000000..b395a09
--- /dev/null
+++ b/drivers/misc/stcam.c
@@ -0,0 +1,348 @@
+/*------------------------------------------------------------------
+ * stcam.c - I2C driver for the Renesas stcam device
+ *
+ * January 2013, Craig MacFarlane
+ *
+ * Copyright (c) 2013 by Cisco Systems, Inc.
+ * All rights reserved.
+ *------------------------------------------------------------------
+ */
+
+#include <linux/i2c.h>
+#include <linux/sysctl.h>
+#include <linux/version.h>
+#include <linux/semaphore.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+
+/*
+ * client instance data
+ */
+struct stcam_data {
+	struct mutex mutex;
+	struct i2c_client *client;
+	long reg;
+};
+
+/*
+ * stcam_i2c_read_block_data
+ *
+ * Read an arbitrary amount of data
+ */
+int
+stcam_i2c_read_block_data(struct i2c_client *client, uint32_t reg,
+			   char *buf, int count)
+{
+	struct i2c_msg msg[2];
+	uint8_t register_buf[3];
+
+	register_buf[2] = reg & 0xFF;
+	register_buf[1] = (reg >> 8) & 0xFF;
+	register_buf[0] = (reg >> 16) & 0xFF;
+
+	msg[0].addr =  client->addr;
+	msg[0].flags = 0;
+	msg[0].len = 3;
+	msg[0].buf = register_buf;
+
+	msg[1].addr = client->addr;
+	msg[1].flags = I2C_M_RD;
+	msg[1].len = count;
+	msg[1].buf = buf;
+
+	return i2c_transfer(client->adapter, msg, 2);
+}
+
+/*
+ * stcam_i2c_write_block_data
+ *
+ * Write 4 bytes of data to offset reg.
+ */
+int
+stcam_i2c_write_block_data(struct i2c_client *client, uint32_t reg,
+			    uint32_t data)
+{
+	struct i2c_msg msg;
+	uint8_t write_buf[7];
+
+	write_buf[2] = reg & 0xFF;
+	write_buf[1] = (reg >> 8) & 0xFF;
+	write_buf[0] = (reg >> 16) & 0xFF;
+
+	write_buf[6] = data & 0xFF;
+	write_buf[5] = (data >> 8) & 0xFF;
+	write_buf[4] = (data >> 16) & 0xFF;
+	write_buf[3] = (data >> 24) & 0xFF;
+
+	msg.addr = client->addr;
+	msg.flags = 0;
+	msg.len = 7;
+	msg.buf = write_buf;
+
+	return i2c_transfer(client->adapter, &msg, 1);
+}
+
+#ifdef CONFIG_X86_64
+/* swap function for Intel arch */
+#define STCAM_SWAP(x) \
+	(((x & 0x000000FFUL) << 24) |  \
+	 ((x & 0x0000FF00UL) <<  8) |  \
+	 ((x & 0x00FF0000UL) >>  8) |  \
+	 ((x & 0xFF000000UL) >> 24))
+#else
+#define STCAM_SWAP(x) (x)
+#endif
+
+/*
+ * show_id
+ *
+ * Convenience function to dump the ID register
+ */
+static ssize_t
+show_id(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	s32 rtn;
+	unsigned char val_upper[4];
+	unsigned char val_lower[4];
+	uint32_t u_upper;
+	uint32_t u_lower;
+
+	struct i2c_client *client = to_i2c_client(dev);
+	struct stcam_data *data = i2c_get_clientdata(client);
+
+	mutex_lock(&data->mutex);
+	rtn = stcam_i2c_read_block_data(client, 0x02, val_upper, 4);
+	rtn = stcam_i2c_read_block_data(client, 0x03, val_lower, 4);
+	mutex_unlock(&data->mutex);
+	if (rtn == -1) {
+		dev_err(dev, "read stcam register read failed \n");
+		rtn = 0;
+	} else {
+		u_upper = *(uint32_t *)val_upper;
+		u_upper = STCAM_SWAP(u_upper);
+		u_lower = *(uint32_t *)val_lower;
+		u_lower = STCAM_SWAP(u_lower);
+		return snprintf(buf, PAGE_SIZE, "%08X %08X", u_upper, u_lower);
+	}
+
+	return rtn;
+}
+
+/*
+ * show_reg
+ *
+ * Read an arbitrary register.
+ *
+ * To use write the register to read to
+ *    /sys/bus/i2c/drivers/stcam/<slave-addr>/reg
+ *
+ * e.g.
+ *    echo <val> > /sys/bus/i2c/drivers/stcam/<slave-addr>/reg
+ *
+ * Then cat reg.  The driver caches the register to read from and
+ * performs the read when when you do a read from the file.
+ */
+static ssize_t
+show_reg(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	s32 rtn;
+	struct i2c_client *client = to_i2c_client(dev);
+	struct stcam_data *data = i2c_get_clientdata(client);
+	unsigned char val[4];
+	uint32_t u_val;
+
+	mutex_lock(&data->mutex);
+	rtn = stcam_i2c_read_block_data(client, data->reg, val, 4);
+	mutex_unlock(&data->mutex);
+	if (rtn == -1) {
+		dev_err(dev, "read stcam register read failed \n");
+		rtn = 0;
+	} else {
+		u_val = *(uint32_t *)val;
+		u_val = STCAM_SWAP(u_val);
+		rtn = snprintf(buf, PAGE_SIZE, "%08X\n", u_val);
+	}
+	return rtn;
+}
+
+/*
+ * set_reg
+ *
+ * Cache a register to read from.  See show_reg
+ */
+static ssize_t
+set_reg(struct device *dev, struct device_attribute *attr,
+	  const char *buf, size_t count)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct stcam_data *data = i2c_get_clientdata(client);
+	int ret = kstrtoul(buf, 10, &data->reg);
+
+	return (ret == 0) ? count : ret;
+}
+
+/*
+ * set_write_reg
+ *
+ * Write to the cached register.
+ */
+static ssize_t
+set_write_reg(struct device *dev, struct device_attribute *attr,
+		const char *buf, size_t count)
+{
+	s32 rtn;
+	struct i2c_client *client = to_i2c_client(dev);
+	struct stcam_data *data = i2c_get_clientdata(client);
+	long val;
+
+	rtn = kstrtoul(buf, 10, &val);
+
+	if (rtn == 0) {
+		mutex_lock(&data->mutex);
+		rtn = stcam_i2c_write_block_data(client, data->reg,
+						 (uint32_t)val);
+		mutex_unlock(&data->mutex);
+
+		return count;
+	} else
+		return rtn;
+}
+
+static DEVICE_ATTR(id, S_IRUGO, show_id, NULL);
+static DEVICE_ATTR(reg, S_IWUSR | S_IRUGO, show_reg, set_reg);
+static DEVICE_ATTR(write_reg, S_IWUSR, NULL, set_write_reg);
+
+/*
+ * stcam_detect
+ *
+ * called by i2c_detect
+ */
+static int
+stcam_detect(struct i2c_client *client,
+	     struct i2c_board_info *info)
+{
+	int rtn = 0;
+
+	strlcpy(info->type, "stcam", I2C_NAME_SIZE);
+
+	pr_debug("rtn = %d\n", (unsigned int)rtn);
+	return rtn;
+}
+
+/*
+ * stcam_probe
+ */
+static int
+stcam_probe(struct i2c_client *client, const struct i2c_device_id *id)
+{
+	struct stcam_data   *data;
+	struct device       *dev = &client->dev;
+	struct i2c_adapter  *adapter = client->adapter;
+	int rtn = 0;
+	int rc;
+
+	rtn = 0;
+	data = NULL;
+
+	if (!i2c_check_functionality(adapter, I2C_FUNC_I2C)) {
+		pr_err("stcam unsupported function\n");
+		rtn = -ENOSYS;
+		goto _exit;
+	}
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (data == NULL) {
+		pr_err("failed to allocate client data memory\n");
+		rtn = -ENOMEM;
+		goto _exit;
+	}
+
+	mutex_init(&data->mutex);
+	data->client = client;
+
+	i2c_set_clientdata(client, data);
+
+	rc = device_create_file(dev, &dev_attr_id);
+	rc = device_create_file(dev, &dev_attr_reg);
+	rc = device_create_file(dev, &dev_attr_write_reg);
+
+_exit:
+	if (rtn != 0)
+		kfree(data);
+
+
+	pr_debug("rtn = %d\n", rtn);
+	return rtn;
+}
+
+/*
+ * stcam_remove
+ */
+static int stcam_remove(struct i2c_client *client)
+{
+	int rtn = 0;
+	struct stcam_data *data;
+
+	data = i2c_get_clientdata(client);
+	kfree(data);
+
+	pr_debug("stcam rtn = %d\n", rtn);
+	return rtn;
+}
+
+static struct i2c_device_id stcam_idtable[] = {
+	{ "stcam",        0},
+	{ },
+};
+
+MODULE_DEVICE_TABLE(i2c, stcam_idtable);
+
+
+/*
+ * this is the driver that will be inserted
+ */
+static struct i2c_driver stcam_chip_driver = {
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = "stcam",
+	},
+	.id_table	= stcam_idtable,
+	.probe		= stcam_probe,
+	.remove		= stcam_remove,
+	.detect		= stcam_detect,
+	.class		= I2C_CLASS_HWMON,
+};
+
+/*
+ * stcam_init
+ */
+int
+stcam_init(void)
+{
+	int rtn;
+
+	rtn = i2c_add_driver(&stcam_chip_driver);
+	if (rtn) {
+		pr_err("Could not initialize stcam driver, rtn = %d\n", rtn);
+		return rtn;
+	}
+	pr_debug("stcam rtn = %d\n", rtn);
+	return rtn;
+}
+
+/*
+ * stcam_exit
+ */
+void
+stcam_exit(void)
+{
+	i2c_del_driver(&stcam_chip_driver);
+	pr_debug("exit\n");
+}
+
+MODULE_AUTHOR("Cisco Systems Inc.");
+MODULE_DESCRIPTION("sTCAM I2C Driver");
+MODULE_LICENSE("GPL");
+
+module_init(stcam_init);
+module_exit(stcam_exit);
-- 
1.8.3.2

