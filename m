Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbaKRQD4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 11:03:56 -0500
Received: from sauhun.de ([89.238.76.85]:46110 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755244AbaKRQDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 11:03:52 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jean Delvare <jdelvare@suse.de>
Subject: [PATCH 2/3] i2c: slave-eeprom: add eeprom simulator driver
Date: Tue, 18 Nov 2014 17:04:54 +0100
Message-Id: <1416326695-13083-3-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1416326695-13083-1-git-send-email-wsa@the-dreams.de>
References: <1416326695-13083-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

The first user of the i2c-slave interface is an eeprom simulator. It is
a shared memory which can be accessed by the remote master via I2C and
locally via sysfs.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---

Changes since RFC:
* fix build error for modules
* don't hardcode size
* add boundary checks for sysfs access
* use a spinlock
* s/at24s/eeprom/g
* add some docs
* clean up exit paths
* use size-variable instead of driver_data

 drivers/i2c/Kconfig            |  10 +++
 drivers/i2c/Makefile           |   1 +
 drivers/i2c/i2c-slave-eeprom.c | 170 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 181 insertions(+)
 create mode 100644 drivers/i2c/i2c-slave-eeprom.c

diff --git a/drivers/i2c/Kconfig b/drivers/i2c/Kconfig
index b51a402752c4..8c9e619f3026 100644
--- a/drivers/i2c/Kconfig
+++ b/drivers/i2c/Kconfig
@@ -110,6 +110,16 @@ config I2C_STUB
 
 	  If you don't know what to do here, definitely say N.
 
+config I2C_SLAVE
+	bool "I2C slave support"
+
+if I2C_SLAVE
+
+config I2C_SLAVE_EEPROM
+	tristate "I2C eeprom slave driver"
+
+endif
+
 config I2C_DEBUG_CORE
 	bool "I2C Core debugging messages"
 	help
diff --git a/drivers/i2c/Makefile b/drivers/i2c/Makefile
index 1722f50f2473..45095b3d16a9 100644
--- a/drivers/i2c/Makefile
+++ b/drivers/i2c/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_I2C_CHARDEV)	+= i2c-dev.o
 obj-$(CONFIG_I2C_MUX)		+= i2c-mux.o
 obj-y				+= algos/ busses/ muxes/
 obj-$(CONFIG_I2C_STUB)		+= i2c-stub.o
+obj-$(CONFIG_I2C_SLAVE_EEPROM)	+= i2c-slave-eeprom.o
 
 ccflags-$(CONFIG_I2C_DEBUG_CORE) := -DDEBUG
 CFLAGS_i2c-core.o := -Wno-deprecated-declarations
diff --git a/drivers/i2c/i2c-slave-eeprom.c b/drivers/i2c/i2c-slave-eeprom.c
new file mode 100644
index 000000000000..6631400b5f02
--- /dev/null
+++ b/drivers/i2c/i2c-slave-eeprom.c
@@ -0,0 +1,170 @@
+/*
+ * I2C slave mode EEPROM simulator
+ *
+ * Copyright (C) 2014 by Wolfram Sang, Sang Engineering <wsa@sang-engineering.com>
+ * Copyright (C) 2014 by Renesas Electronics Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; version 2 of the License.
+ *
+ * Because most IP blocks can only detect one I2C slave address anyhow, this
+ * driver does not support simulating EEPROM types which take more than one
+ * address. It is prepared to simulate bigger EEPROMs with an internal 16 bit
+ * pointer, yet implementation is deferred until the need actually arises.
+ */
+
+#include <linux/i2c.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/sysfs.h>
+
+struct eeprom_data {
+	struct bin_attribute bin;
+	bool first_write;
+	spinlock_t buffer_lock;
+	u8 buffer_idx;
+	u8 buffer[];
+};
+
+static int i2c_slave_eeprom_slave_cb(struct i2c_client *client,
+				     enum i2c_slave_event event, u8 *val)
+{
+	struct eeprom_data *eeprom = i2c_get_clientdata(client);
+
+	switch (event) {
+	case I2C_SLAVE_REQ_WRITE_END:
+		if (eeprom->first_write) {
+			eeprom->buffer_idx = *val;
+			eeprom->first_write = false;
+		} else {
+			spin_lock(&eeprom->buffer_lock);
+			eeprom->buffer[eeprom->buffer_idx++] = *val;
+			spin_unlock(&eeprom->buffer_lock);
+		}
+		break;
+
+	case I2C_SLAVE_REQ_READ_START:
+		spin_lock(&eeprom->buffer_lock);
+		*val = eeprom->buffer[eeprom->buffer_idx];
+		spin_unlock(&eeprom->buffer_lock);
+		break;
+
+	case I2C_SLAVE_REQ_READ_END:
+		eeprom->buffer_idx++;
+		break;
+
+	case I2C_SLAVE_STOP:
+		eeprom->first_write = true;
+		break;
+
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static ssize_t i2c_slave_eeprom_bin_read(struct file *filp, struct kobject *kobj,
+		struct bin_attribute *attr, char *buf, loff_t off, size_t count)
+{
+	struct eeprom_data *eeprom;
+	unsigned long flags;
+
+	if (off + count >= attr->size)
+		return -EFBIG;
+
+	eeprom = dev_get_drvdata(container_of(kobj, struct device, kobj));
+
+	spin_lock_irqsave(&eeprom->buffer_lock, flags);
+	memcpy(buf, &eeprom->buffer[off], count);
+	spin_unlock_irqrestore(&eeprom->buffer_lock, flags);
+
+	return count;
+}
+
+static ssize_t i2c_slave_eeprom_bin_write(struct file *filp, struct kobject *kobj,
+		struct bin_attribute *attr, char *buf, loff_t off, size_t count)
+{
+	struct eeprom_data *eeprom;
+	unsigned long flags;
+
+	if (off + count >= attr->size)
+		return -EFBIG;
+
+	eeprom = dev_get_drvdata(container_of(kobj, struct device, kobj));
+
+	spin_lock_irqsave(&eeprom->buffer_lock, flags);
+	memcpy(&eeprom->buffer[off], buf, count);
+	spin_unlock_irqrestore(&eeprom->buffer_lock, flags);
+
+	return count;
+}
+
+static int i2c_slave_eeprom_probe(struct i2c_client *client, const struct i2c_device_id *id)
+{
+	struct eeprom_data *eeprom;
+	int ret;
+	unsigned size = id->driver_data;
+
+	eeprom = devm_kzalloc(&client->dev, sizeof(struct eeprom_data) + size, GFP_KERNEL);
+	if (!eeprom)
+		return -ENOMEM;
+
+	eeprom->first_write = true;
+	spin_lock_init(&eeprom->buffer_lock);
+	i2c_set_clientdata(client, eeprom);
+
+	sysfs_bin_attr_init(&eeprom->bin);
+	eeprom->bin.attr.name = "slave-eeprom";
+	eeprom->bin.attr.mode = S_IRUSR | S_IWUSR;
+	eeprom->bin.read = i2c_slave_eeprom_bin_read;
+	eeprom->bin.write = i2c_slave_eeprom_bin_write;
+	eeprom->bin.size = size;
+
+	ret = sysfs_create_bin_file(&client->dev.kobj, &eeprom->bin);
+	if (ret)
+		return ret;
+
+	ret = i2c_slave_register(client, i2c_slave_eeprom_slave_cb);
+	if (ret) {
+		sysfs_remove_bin_file(&client->dev.kobj, &eeprom->bin);
+		return ret;
+	}
+
+	return 0;
+};
+
+static int i2c_slave_eeprom_remove(struct i2c_client *client)
+{
+	struct eeprom_data *eeprom = i2c_get_clientdata(client);
+
+	i2c_slave_unregister(client);
+	sysfs_remove_bin_file(&client->dev.kobj, &eeprom->bin);
+
+	return 0;
+}
+
+static const struct i2c_device_id i2c_slave_eeprom_id[] = {
+	{ "slave-24c02", 2048 / 8 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, i2c_slave_eeprom_id);
+
+static struct i2c_driver i2c_slave_eeprom_driver = {
+	.driver = {
+		.name = "i2c-slave-eeprom",
+		.owner = THIS_MODULE,
+	},
+	.probe = i2c_slave_eeprom_probe,
+	.remove = i2c_slave_eeprom_remove,
+	.id_table = i2c_slave_eeprom_id,
+};
+module_i2c_driver(i2c_slave_eeprom_driver);
+
+MODULE_AUTHOR("Wolfram Sang <wsa@sang-engineering.com>");
+MODULE_DESCRIPTION("I2C slave mode EEPROM simulator");
+MODULE_LICENSE("GPL v2");
-- 
2.1.1

