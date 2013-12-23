Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563Ab3LWQNc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 11:13:32 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:48786 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab3LWQM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 11:12:58 -0500
From: Laszlo Papp <lpapp@kde.org>
To: Guenter Roeck <linux@roeck-us.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Laszlo Papp <lpapp@kde.org>
Subject: [PATCH 1/3] mfd: MAX6650/6651 support
Date: Mon, 23 Dec 2013 16:08:07 +0000
Message-Id: <1387814889-16670-2-git-send-email-lpapp@kde.org>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1387814889-16670-1-git-send-email-lpapp@kde.org>
References: <1387814889-16670-1-git-send-email-lpapp@kde.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX6650/MAX6651 chip is a multi-function device with I2C busses. The
chip includes fan-speed regulators and monitors, GPIO, and alarm.

This patch is an initial release of a MAX6650/6651 MFD driver that
supports to enable the chip with its primary I2C bus that will connect
the hwmon, and then the gpio devices for now.

Signed-off-by: Laszlo Papp <lpapp@kde.org>
---
 drivers/mfd/Kconfig                 |  11 +++
 drivers/mfd/Makefile                |   1 +
 drivers/mfd/max6651.c               | 132 ++++++++++++++++++++++++++++++++++++
 include/linux/mfd/max6651-private.h |  53 +++++++++++++++
 4 files changed, 197 insertions(+)
 create mode 100644 drivers/mfd/max6651.c
 create mode 100644 include/linux/mfd/max6651-private.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index dd67158..706c4e5 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -321,6 +321,17 @@ config MFD_88PM860X
 	  select individual components like voltage regulators, RTC and
 	  battery-charger under the corresponding menus.
 
+config MFD_MAX6651
+	bool "Maxim Semiconductor MAX6651 Support"
+	depends on I2C=y
+	select MFD_CORE
+	select IRQ_DOMAIN
+	help
+	  Say yes here to support for Maxim Semiconductor MAX6651. This is
+	  a fan speed regulator and monitor IC. This driver provies common support
+	  for accessing the device, additional drivers must be enabled in order to
+	  use the functionality of the device.
+
 config MFD_MAX77686
 	bool "Maxim Semiconductor MAX77686 PMIC Support"
 	depends on I2C=y
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 8a28dc9..254a8a7 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -110,6 +110,7 @@ obj-$(CONFIG_MFD_DA9055)	+= da9055.o
 da9063-objs			:= da9063-core.o da9063-irq.o da9063-i2c.o
 obj-$(CONFIG_MFD_DA9063)	+= da9063.o
 
+obj-$(CONFIG_MFD_MAX6651)	+= max6651.o
 obj-$(CONFIG_MFD_MAX77686)	+= max77686.o max77686-irq.o
 obj-$(CONFIG_MFD_MAX77693)	+= max77693.o max77693-irq.o
 obj-$(CONFIG_MFD_MAX8907)	+= max8907.o
diff --git a/drivers/mfd/max6651.c b/drivers/mfd/max6651.c
new file mode 100644
index 0000000..c6b1716
--- /dev/null
+++ b/drivers/mfd/max6651.c
@@ -0,0 +1,132 @@
+/*
+ * Device access for MAX6651
+ *
+ * Copyright(c) 2013 Polatis Ltd.
+ *
+ * Author: Laszlo Papp <laszlo.papp@polatis.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ */
+
+#include <linux/device.h>
+#include <linux/delay.h>
+#include <linux/input.h>
+#include <linux/interrupt.h>
+#include <linux/mfd/core.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/i2c.h>
+
+#include <linux/mfd/max6651-private.h>
+
+static struct mfd_cell max6651_devs[] = {
+    { .name = "max6651-gpio", },
+    { .name = "max6650", },
+};
+
+int max6651_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest)
+{
+    struct max6651_dev *max6651 = i2c_get_clientdata(i2c);
+    int ret;
+
+    mutex_lock(&max6651->iolock);
+    ret = i2c_smbus_read_byte_data(i2c, reg);
+    mutex_unlock(&max6651->iolock);
+    if (ret < 0)
+        return ret;
+
+    ret &= 0xff;
+    *dest = ret;
+    return 0;
+}
+EXPORT_SYMBOL_GPL(max6651_read_reg);
+
+int max6651_write_reg(struct i2c_client *i2c, u8 reg, u8 value)
+{
+    struct max6651_dev *max6651 = i2c_get_clientdata(i2c);
+    int ret;
+
+    mutex_lock(&max6651->iolock);
+    ret = i2c_smbus_write_byte_data(i2c, reg, value);
+    mutex_unlock(&max6651->iolock);
+    return ret;
+}
+EXPORT_SYMBOL_GPL(max6651_write_reg);
+
+static int max6651_i2c_probe(struct i2c_client *i2c,
+			    const struct i2c_device_id *id)
+{
+	struct max6651_dev *max6651;
+	int ret = 0;
+
+	max6651 = kzalloc(sizeof(struct max6651_dev), GFP_KERNEL);
+	if (max6651 == NULL)
+		return -ENOMEM;
+
+	i2c_set_clientdata(i2c, max6651);
+	max6651->dev = &i2c->dev;
+
+	mutex_init(&max6651->iolock);
+
+	ret = mfd_add_devices(max6651->dev, -1, max6651_devs,
+			ARRAY_SIZE(max6651_devs),
+			NULL, 0, NULL);
+
+	if (ret < 0) {
+        dev_err(max6651->dev, "cannot add mfd cells\n");
+		goto err_mfd;
+    }
+
+	return ret;
+
+err_mfd:
+	mfd_remove_devices(max6651->dev);
+	kfree(max6651);
+	return ret;
+}
+
+static int max6651_i2c_remove(struct i2c_client *i2c)
+{
+    struct max6651_dev *max6651 = i2c_get_clientdata(i2c);
+
+    mfd_remove_devices(max6651->dev);
+
+    return 0;
+}
+
+static const struct i2c_device_id max6651_i2c_id[] = {
+    { "max6650", TYPE_MAX6650 },
+    { "max6651", TYPE_MAX6651 },
+    { }
+};
+MODULE_DEVICE_TABLE(i2c, max6651_i2c_id);
+
+static struct i2c_driver max6651_i2c_driver = {
+    .driver = {
+           .name = "max6651",
+           .owner = THIS_MODULE,
+    },
+    .probe = max6651_i2c_probe,
+    .remove = max6651_i2c_remove,
+    .id_table = max6651_i2c_id,
+};
+
+static int __init max6651_i2c_init(void)
+{
+    return i2c_add_driver(&max6651_i2c_driver);
+}
+/* init early so consumer devices can complete system boot */
+subsys_initcall(max6651_i2c_init);
+
+static void __exit max6651_i2c_exit(void)
+{
+    i2c_del_driver(&max6651_i2c_driver);
+}
+module_exit(max6651_i2c_exit);
+
+MODULE_AUTHOR("Laszlo Papp <laszlo.papp@polatis.com>");
+MODULE_DESCRIPTION("MAX6651 MFD");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/max6651-private.h b/include/linux/mfd/max6651-private.h
new file mode 100644
index 0000000..ae90261
--- /dev/null
+++ b/include/linux/mfd/max6651-private.h
@@ -0,0 +1,53 @@
+/*
+ * max6650.h - Driver for the Maxim 6650/6651
+ *
+ *  Copyright (C) 2013 Laszlo Papp <laszlo.papp@polatis.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ * This driver is based on max8998.h
+ *
+ * MAX8997 has PMIC, MUIC, HAPTIC, RTC, FLASH, and Fuel Gauge devices.
+ * Except Fuel Gauge, every device shares the same I2C bus and included in
+ * this mfd driver. Although the fuel gauge is included in the chip, it is
+ * excluded from the driver because a) it has a different I2C bus from
+ * others and b) it can be enabled simply by using MAX17042 driver.
+ */
+
+#ifndef __LINUX_MFD_MAX6651_PRIVATE_H
+#define __LINUX_MFD_MAX6651_PRIVATE_H
+
+#include <linux/i2c.h>
+#include <linux/export.h>
+#include <linux/irqdomain.h>
+
+struct max6651_dev {
+    struct device *dev;
+    struct mutex iolock;
+
+    struct i2c_client *i2c;
+
+	int type;
+};
+
+enum max6651_types {
+	TYPE_MAX6650,
+	TYPE_MAX6651,
+};
+
+extern int max6651_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest);
+extern int max6651_write_reg(struct i2c_client *i2c, u8 reg, u8 value);
+
+#endif
-- 
1.8.5.1

