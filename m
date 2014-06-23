Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458AbaFWI6O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:58:14 -0400
Received: from acledge3.advantech.com.tw ([219.90.3.242]:49011 "EHLO
	acledge3.advantech.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbaFWI6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:58:07 -0400
From: Wei-Chun Pan <weichun.pan@advantech.com.tw>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Jean Delvare <jdelvare@suse.de>, Guenter Roeck <linux@roeck-us.net>,
        Wolfram Sang <wsa@the-dreams.de>
CC: "Louis.Lu" <Louis.Lu@advantech.com.tw>, "Neo.Lo" <neo.lo@advantech.com.tw>,
        "Hank.Peng" <Hank.Peng@advantech.com.tw>,
        "Kevin.Ong" <Kevin.Ong@advantech.com.tw>,
        <linux-kernel@vger.kernel.org>,
        Wei-Chun Pan <weichun.pan@advantech.com.tw>
Subject: [PATCH 3/5] mfd: imanager2: Add Core supports for IT8516/18/28
Date: Mon, 23 Jun 2014 01:39:50 -0700
Message-ID: <1403512792-19100-3-git-send-email-weichun.pan@advantech.com.tw>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403512792-19100-1-git-send-email-weichun.pan@advantech.com.tw>
References: <1403512792-19100-1-git-send-email-weichun.pan@advantech.com.tw>
MIME-Version: 1.0
Content-Type: text/plain
X-StopIT: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wei-Chun Pan <weichun.pan@advantech.com.tw>
---
 drivers/mfd/Kconfig          |   6 +
 drivers/mfd/Makefile         |   2 +
 drivers/mfd/imanager2_core.c | 276 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 284 insertions(+)
 create mode 100644 drivers/mfd/imanager2_core.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 3383412..48b063f 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -10,6 +10,12 @@ config MFD_CORE
 	select IRQ_DOMAIN
 	default n
 
+config MFD_IMANAGER2
+	tristate "Support for Advantech iManager2 EC ICs"
+	select MFD_CORE
+	help
+	  Support for Advantech iManager2 EC ICs
+
 config MFD_CS5535
 	tristate "AMD CS5535 and CS5536 southbridge core functions"
 	select MFD_CORE
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 2851275..10c64ae 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -166,3 +166,5 @@ obj-$(CONFIG_MFD_RETU)		+= retu-mfd.o
 obj-$(CONFIG_MFD_AS3711)	+= as3711.o
 obj-$(CONFIG_MFD_AS3722)	+= as3722.o
 obj-$(CONFIG_MFD_STW481X)	+= stw481x.o
+imanager2-objs			:= imanager2_core.o imanager2_ec.o
+obj-$(CONFIG_MFD_IMANAGER2)	+= imanager2.o
diff --git a/drivers/mfd/imanager2_core.c b/drivers/mfd/imanager2_core.c
new file mode 100644
index 0000000..1a45f09
--- /dev/null
+++ b/drivers/mfd/imanager2_core.c
@@ -0,0 +1,276 @@
+/*
+ * imanager2_core.c - MFD core driver of Advantech EC IT8516/18/28
+ * Copyright (C) 2014  Richard Vidal-Dorsch <richard.dorsch@advantech.com>
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 3 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/module.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/advantech/imanager2.h>
+
+#define DRV_NAME	"imanager2"
+#define DRV_VERSION	"4.0.1"
+
+static struct mfd_cell imanager2_cells[] = {
+	{.name = "imanager2_hwm",},
+	{.name = "imanager2_i2c",},
+};
+
+static int imanager2_authentication(struct imanager2 *ec)
+{
+	u8 tmp;
+	int ret;
+
+	mutex_lock(&ec->lock);
+
+	if (inb(EC_IO_PORT_CMD) == 0xFF && inb(EC_IO_PORT_DATA) == 0xFF) {
+		ret = -ENODEV;
+		goto unlock;
+	}
+
+	if (inb(EC_IO_PORT_CMD) & OBF_MASK)
+		inb(EC_IO_PORT_DATA);	/* initial OBF */
+
+	if (outb_after_ibc(EC_IO_PORT_CMD, EC_CMD_AUTHENTICATION)) {
+		ret = -ENODEV;
+		goto unlock;
+	}
+
+	ret = inb_after_obf(&tmp);
+
+unlock:
+	mutex_unlock(&ec->lock);
+
+	if (ret)
+		return ret;
+
+	if (tmp != 0x95)
+		return -ENODEV;
+
+	return 0;
+}
+
+#define EC_ITE_CHIPID_H8	0x20
+#define EC_ITE_CHIPID_L8	0x21
+
+static int imanager2_get_chip_type(struct imanager2 *ec)
+{
+	mutex_lock(&ec->lock);
+
+	outb(EC_ITE_CHIPID_H8, EC_SIO_CMD);
+	ec->id = inb(EC_SIO_DATA) << 8;
+	outb(EC_ITE_CHIPID_L8, EC_SIO_CMD);
+	ec->id |= inb(EC_SIO_DATA);
+
+	mutex_unlock(&ec->lock);
+
+	switch (ec->id) {
+	case it8516:
+	case it8518:
+		ec->flag = EC_FLAG_IO;
+		break;
+	case it8528:
+		ec->flag |= EC_FLAG_IO_MAILBOX;
+		break;
+	default:
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+/*
+ * EC provides IO channel and ITE mailbox ways to access mailbox. IO channel is
+ * a common way to access mailbox, but IET mailbox way is much faster than IO
+ * channel. We prefer ITE mailbox if firmware supports. Source kernel code
+ * X11_05 the first firmware version that supports ITE mailbox.
+ */
+#define EC_CHIPFW_SUPP_ITEMAILBOX	0x1105
+
+static int imanager2_get_info(struct imanager2 *ec)
+{
+	int ret;
+	u8 *tmp = (u8 *)&ec->info.version.kernel_ver;
+
+	mutex_lock(&ec->lock);
+
+	ret = imanager2_io_read(EC_CMD_ACPIRAM_READ,
+				EC_ACPIRAM_ADDR_KERNEL_MAJOR_VERSION, &tmp[0],
+				2);
+
+	if (ret)
+		goto unlock;
+
+	if (ec->info.version.kernel_ver >= EC_CHIPFW_SUPP_ITEMAILBOX) {
+		ec->flag |= EC_FLAG_MAILBOX;
+		ret = imanager2_get_firmware_version_and_project_name(
+						ec, ec->info.prj_name,
+						&ec->info.version.kernel_ver,
+						&ec->info.version.chip_code,
+						&ec->info.version.proj_id,
+						&ec->info.version.proj_ver);
+	} else {
+		ec->flag &= ~EC_FLAG_MAILBOX;
+		ret = imanager2_io_read(EC_CMD_ACPIRAM_READ,
+					EC_ACPIRAM_ADDR_KERNEL_MAJOR_VERSION,
+					&tmp[0], sizeof(struct ec_version));
+	}
+unlock:
+	mutex_unlock(&ec->lock);
+
+	return ret;
+}
+
+static int imanager2_device_initial_by_mailbox(struct imanager2 *ec)
+{
+	int i, ret;
+
+	mutex_lock(&ec->lock);
+	ret = imanager2_get_dynamic_table(ec, ec->table.devid,
+					  ec->table.pinnum, NULL);
+	mutex_unlock(&ec->lock);
+
+	if (ret)
+		return ret;
+
+	for (i = 0; i < EC_MAX_ITEM_NUM; i++) {
+		if (ec->table.devid[i] == EC_TABLE_DID_NODEV)
+			break;
+
+		ec->table.devid2itemnum[ec->table.devid[i]] = i;
+	}
+
+	return 0;
+}
+
+static int imanager2_device_initial_by_io(struct imanager2 *ec)
+{
+	int i, ret;
+	u8 tmp;
+
+	mutex_lock(&ec->lock);
+
+	for (i = 0; i < EC_MAX_ITEM_NUM; i++) {
+		ret = imanager2_io_read(EC_CMD_HWCTRLTABLE_INDEX, i, &tmp, 1);
+		if (ret)
+			break;
+		if (tmp == EC_TABLE_NOITEM)
+			break;
+
+		imanager2_io_read_byte_without_offset
+		    (EC_CMD_HWCTRLTABLE_GET_PIN_NUM, &ec->table.pinnum[i]);
+		imanager2_io_read_byte_without_offset
+		    (EC_CMD_HWCTRLTABLE_GET_DEVICE_ID, &ec->table.devid[i]);
+
+		if (ec->table.devid[i] == EC_TABLE_DID_NODEV)
+			continue;
+
+		ec->table.devid2itemnum[ec->table.devid[i]] = i;
+	}
+
+	mutex_unlock(&ec->lock);
+
+	if (i < EC_MAX_ITEM_NUM) {
+		memset(&ec->table.devid[i], EC_TABLE_DID_NODEV,
+		       EC_MAX_ITEM_NUM - i);
+		memset(&ec->table.pinnum[i], EC_TABLE_HWP_NODEV,
+		       EC_MAX_ITEM_NUM - i);
+	}
+
+	return ret;
+}
+
+static int imanager2_build_device_table(struct imanager2 *ec)
+{
+	memset(&ec->table.devid2itemnum[0], EC_TABLE_ITEM_UNUSED,
+	       ARRAY_SIZE(ec->table.devid2itemnum));
+
+	if (ec->flag & EC_FLAG_MAILBOX)
+		return imanager2_device_initial_by_mailbox(ec);
+	else
+		return imanager2_device_initial_by_io(ec);
+}
+
+static struct platform_device *ec_pdev;
+
+static int __init imanager2_mfd_device_init(void)
+{
+	struct imanager2 ec = { 0 };
+	int ret;
+
+	mutex_init(&ec.lock);
+
+	ret = imanager2_authentication(&ec);
+	if (ret)
+		return ret;
+
+	ret = imanager2_get_chip_type(&ec);
+	if (ret)
+		return ret;
+
+	ret = imanager2_get_info(&ec);
+	if (ret)
+		return ret;
+
+	ret = imanager2_build_device_table(&ec);
+	if (ret)
+		return ret;
+
+	ec_pdev = platform_device_alloc(DRV_NAME, PLATFORM_DEVID_AUTO);
+	if (!ec_pdev)
+		return -ENOMEM;
+
+	if (!devm_request_region(&ec_pdev->dev, EC_IO_PORT_DATA, 2, DRV_NAME))
+		return -EIO;
+
+	if (!devm_request_region(&ec_pdev->dev, EC_ITE_PORT_OFS, 2, DRV_NAME))
+		return -EIO;
+
+	ret = platform_device_add_data(ec_pdev, &ec, sizeof(struct imanager2));
+	if (ret)
+		goto exit_device_put;
+
+	ret = platform_device_add(ec_pdev);
+	if (ret)
+		goto exit_device_put;
+
+	ret = mfd_add_devices(&ec_pdev->dev, -1, imanager2_cells,
+			      ARRAY_SIZE(imanager2_cells), NULL, -1, NULL);
+	if (ret)
+		goto exit_device_unregister;
+
+	return 0;
+
+exit_device_unregister:
+	platform_device_unregister(ec_pdev);
+exit_device_put:
+	platform_device_put(ec_pdev);
+
+	return ret;
+}
+
+static void __exit imanager2_mfd_device_exit(void)
+{
+	mfd_remove_devices(&ec_pdev->dev);
+	platform_device_unregister(ec_pdev);
+}
+
+module_init(imanager2_mfd_device_init);
+module_exit(imanager2_mfd_device_exit);
+
+MODULE_AUTHOR("Richard Vidal-Dorsch <richard.dorsch at advantech.com>");
+MODULE_DESCRIPTION("iManager2 platform device definitions v" DRV_VERSION);
+MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
-- 
1.9.1

