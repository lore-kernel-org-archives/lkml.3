Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779AbaE2GPl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 02:15:41 -0400
Received: from acledge3.advantech.com.tw ([219.90.3.242]:58814 "EHLO
	acledge3.advantech.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333AbaE2GPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 02:15:39 -0400
X-Greylist: delayed 988 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 May 2014 02:15:38 EDT
From: Wei-Chun Pan <weichun.pan@advantech.com.tw>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Jean Delvare <jdelvare@suse.de>, Guenter Roeck <linux@roeck-us.net>,
        Wolfram Sang <wsa@the-dreams.de>
CC: "Louis.Lu" <Louis.Lu@advantech.com.tw>, "Neo.Lo" <neo.lo@advantech.com.tw>,
        "Hank.Peng" <Hank.Peng@advantech.com.tw>,
        "Kevin.Ong" <Kevin.Ong@advantech.com.tw>,
        <linux-kernel@vger.kernel.org>,
        Wei-Chun Pan <weichun.pan@advantech.com.tw>
Subject: [PATCH 1/3] mfd: iManager2: Add support for IT8516/18/28
Date: Wed, 28 May 2014 22:57:14 -0700
Message-ID: <1401343036-26159-1-git-send-email-weichun.pan@advantech.com.tw>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-StopIT: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    Advantech's new module comes equipped with "iManager" - an embedded controller (EC), providing embedded features for system integrators to increase reliability and simplify integration.
    This patch add the MFD driver for enabling Advantech iManager V2.0 chipset. Available functions support to recognize ITE-IT85XX and basic control APIs. These functions are tested on Advantech SOM-5892 board. All the embedded functions are configured by a utility. Advantech has done all the hard work for user with the release of a suite of Software APIs.
    These provide not only the underlying drivers required but also a rich set of user-friendly, intelligent and integrated interfaces, which speeds development, enhances security and offers add-on value for Advantech platforms.

Signed-off-by: Wei-Chun Pan Developer <weichun.pan@advantech.com.tw>
---
 drivers/mfd/Kconfig                        |    6 +
 drivers/mfd/Makefile                       |    2 +
 drivers/mfd/imanager2_core.c               |  316 ++++++++
 drivers/mfd/imanager2_ec.c                 | 1093 ++++++++++++++++++++++++++++
 include/linux/mfd/advantech/imanager2.h    |   61 ++
 include/linux/mfd/advantech/imanager2_ec.h |  389 ++++++++++
 6 files changed, 1867 insertions(+)
 mode change 100644 => 100755 drivers/mfd/Kconfig
 mode change 100644 => 100755 drivers/mfd/Makefile
 create mode 100755 drivers/mfd/imanager2_core.c
 create mode 100755 drivers/mfd/imanager2_ec.c
 create mode 100755 include/linux/mfd/advantech/imanager2.h
 create mode 100755 include/linux/mfd/advantech/imanager2_ec.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
old mode 100644
new mode 100755
index 3383412..48b063f
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
old mode 100644
new mode 100755
index 2851275..10c64ae
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -166,3 +166,5 @@ obj-$(CONFIG_MFD_RETU)		+= retu-mfd.o
 obj-$(CONFIG_MFD_AS3711)	+= as3711.o
 obj-$(CONFIG_MFD_AS3722)	+= as3722.o
 obj-$(CONFIG_MFD_STW481X)	+= stw481x.o
+imanager2-objs			:= imanager2_core.o imanager2_ec.o
+obj-$(CONFIG_MFD_IMANAGER2)	+= imanager2.o
diff --git a/drivers/mfd/imanager2_core.c b/drivers/mfd/imanager2_core.c
new file mode 100755
index 0000000..786853d
--- /dev/null
+++ b/drivers/mfd/imanager2_core.c
@@ -0,0 +1,316 @@
+/* imanager2_core.c - MFD core driver of Advantech EC IT8516/18/28
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
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/advantech/imanager2.h>
+
+#define DRV_NAME	CHIP_NAME
+#define DRV_VERSION	"0.2.2"
+
+static struct platform_device *pdev;
+
+static struct mfd_cell it85xx_devs[] = {
+	{ .name = DRV_NAME "_hwm", },
+	{ .name = DRV_NAME "_i2c", },
+};
+
+static int ec_authentication(struct it85xx *ec)
+{
+	u8 tmp;
+	int ret = 0;
+
+	spin_lock(&ec->lock);
+
+	if (inb(EC_IO_PORT_CMD) == 0xFF && inb(EC_IO_PORT_DATA) == 0xFF) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	if ((inb(EC_IO_PORT_CMD) & OBF_MASK) != 0)
+		inb(EC_IO_PORT_DATA);	/* initial OBF */
+
+	if (outb_after_ibc(EC_IO_PORT_CMD, EC_CMD_AUTHENTICATION) != 0) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	if (inb_after_obf(&tmp) != 0)
+		ret = -EFAULT;
+
+out:
+	spin_unlock(&ec->lock);
+
+	if (ret != 0)
+		return ret;
+
+	if (tmp != 0x95)
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
+static int ec_get_chip_type(struct it85xx *ec)
+{
+	spin_lock(&ec->lock);
+
+	outb(0x20, EC_SIO_CMD);
+	ec->type = (inb(EC_SIO_DATA) << 8);
+	outb(0x21, EC_SIO_CMD);
+	ec->type |= inb(EC_SIO_DATA);
+
+	pr_info("chip type = %04X\n", ec->type);
+
+	spin_unlock(&ec->lock);
+
+	switch (ec->type) {
+	case it8516:
+	case it8518:
+		break;
+	case it8519:
+		return -EOPNOTSUPP;
+	case it8528:
+		ec->flag |= EC_F_IO_MAILBOX;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int ec_get_info(struct it85xx *ec)
+{
+	int ret;
+	/* first kernel version that supports ITE mailbox */
+	const u16 supmbox_1st_kver = 0x1105;
+	u8 *tmp = (u8 *)&ec->info.version.kernel_ver;
+
+	spin_lock(&ec->lock);
+
+	ret = ec_io_read(EC_CMD_ACPIRAM_READ,
+			 EC_ACPIRAM_ADDR_KERNEL_MAJOR_VERSION, &tmp[0], 2);
+
+	if (ec->info.version.kernel_ver >= supmbox_1st_kver) {
+		ec->flag |= EC_F_MAILBOX;
+		ret = ec_get_firmware_version_and_project_name(
+						ec, ec->info.prj_name,
+						&ec->info.version.kernel_ver,
+						&ec->info.version.chip_code,
+						&ec->info.version.proj_id,
+						&ec->info.version.proj_ver);
+	} else {
+		ec->flag &= ~EC_F_MAILBOX;
+		ret = ec_io_read(EC_CMD_ACPIRAM_READ,
+				 EC_ACPIRAM_ADDR_KERNEL_MAJOR_VERSION,
+				 &tmp[0], sizeof(struct ec_version));
+	}
+
+	spin_unlock(&ec->lock);
+
+	if (ret != 0)
+		return -EFAULT;
+
+	if ((ec->flag & EC_F_MAILBOX) != 0)
+		pr_info("name = %s\n", ec->info.prj_name);
+
+	pr_info("kernel_ver = %04X\n", ec->info.version.kernel_ver);
+	pr_info("chip_code = %04X\n", ec->info.version.chip_code);
+	pr_info("proj_id = %04X\n", ec->info.version.proj_id);
+	pr_info("proj_ver = %04X\n", ec->info.version.proj_ver);
+
+	return 0;
+}
+
+static int ec_device_initial_by_mailbox(struct it85xx *ec)
+{
+	int i, ret;
+
+	spin_lock(&ec->lock);
+	ret = ec_get_dynamic_table(ec, ec->table.devid,
+				   ec->table.pinnum, NULL);
+	spin_unlock(&ec->lock);
+
+	if (ret != 0)
+		return ret;
+
+	for (i = 0; i < EC_MAX_ITEM_NUM; i++) {
+		if (ec->table.devid[i] == EC_TABLE_DID_NODEV)
+			break;
+
+		ec->table.devid2itemnum[ec->table.devid[i]] = i;
+	}
+
+	return ret;
+}
+
+static int ec_device_initial_by_io(struct it85xx *ec)
+{
+	int i, ret;
+	u8 tmp;
+
+	spin_lock(&ec->lock);
+
+	for (i = 0; i < EC_MAX_ITEM_NUM; i++) {
+		ret = ec_io_read(EC_CMD_HWCTRLTABLE_INDEX, i, &tmp, 1);
+		if (ret != 0)
+			break;
+		if (tmp == EC_TABLE_NOITEM)
+			break;
+
+		ec_io_read_byte_without_offset(EC_CMD_HWCTRLTABLE_GET_PIN_NUM,
+					       &ec->table.pinnum[i]);
+		ec_io_read_byte_without_offset(EC_CMD_HWCTRLTABLE_GET_DEVICE_ID,
+					       &ec->table.devid[i]);
+
+		if (ec->table.devid[i] == EC_TABLE_DID_NODEV)
+			continue;
+
+		ec->table.devid2itemnum[ec->table.devid[i]] = i;
+	}
+
+	spin_unlock(&ec->lock);
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
+static int ec_build_device_table(struct it85xx *ec)
+{
+	memset(&ec->table.devid2itemnum[0], EC_TABLE_ITEM_UNUSED,
+	       ARRAY_SIZE(ec->table.devid2itemnum));
+
+	if (ec->flag & EC_F_MAILBOX)
+		return ec_device_initial_by_mailbox(ec);
+	else
+		return ec_device_initial_by_io(ec);
+}
+
+static int __init it85xx_probe(struct it85xx *ec)
+{
+	int ret;
+
+	ret = ec_authentication(ec);
+	if (ret != 0)
+		return ret;
+
+	ret = ec_get_chip_type(ec);
+	if (ret != 0)
+		return ret;
+
+	ret = ec_get_info(ec);
+	if (ret != 0)
+		return ret;
+
+	ret = ec_build_device_table(ec);
+	if (ret != 0)
+		return ret;
+
+	if (request_region(EC_IO_PORT_DATA, 2, DRV_NAME) == NULL) {
+		release_region(EC_IO_PORT_DATA, 2);
+		return -EIO;
+	}
+
+	if (request_region(EC_ITE_PORT_OFS, 2, DRV_NAME) == NULL) {
+		release_region(EC_ITE_PORT_OFS, 2);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int __init it85xx_device_add(const struct it85xx *ec)
+{
+	int ret;
+
+	pdev = platform_device_alloc(DRV_NAME, 0);
+	if (pdev == NULL) {
+		ret = -ENOMEM;
+		pr_err("Device allocation failed\n");
+		goto exit;
+	}
+
+	ret = platform_device_add_data(pdev, ec,
+				       sizeof(struct it85xx));
+	if (ret != 0) {
+		pr_err("Platform data allocation failed\n");
+		goto exit_device_put;
+	}
+
+	ret = platform_device_add(pdev);
+	if (ret != 0) {
+		pr_err("Device addition failed (%d)\n", ret);
+		goto exit_device_put;
+	}
+
+	ret = mfd_add_devices(&pdev->dev, pdev->id, it85xx_devs,
+			      ARRAY_SIZE(it85xx_devs), NULL, -1, NULL);
+
+	if (ret != 0) {
+		pr_err("Cannot add sub device (error=%d)\n", ret);
+		goto exit_device_unregister;
+	} else {
+		pr_info("MFD core driver v%s loaded\n", DRV_VERSION);
+	}
+
+	return 0;
+
+exit_device_unregister:
+	platform_device_unregister(pdev);
+exit_device_put:
+	platform_device_put(pdev);
+exit:
+	return ret;
+}
+
+
+static int __init it85xx_init(void)
+{
+	struct it85xx ec;
+
+	memset(&ec, 0, sizeof(struct it85xx));
+	spin_lock_init(&ec.lock);
+	if (it85xx_probe(&ec) != 0)
+		return -ENODEV;
+
+	return it85xx_device_add(&ec);
+}
+
+static void __exit it85xx_exit(void)
+{
+	release_region(EC_ITE_PORT_OFS, 2);
+	release_region(EC_IO_PORT_DATA, 2);
+	mfd_remove_devices(&pdev->dev);
+	platform_device_unregister(pdev);
+	pr_info("MFD core driver removed\n");
+}
+
+MODULE_AUTHOR("Richard Vidal-Dorsch <richard.dorsch at advantech.com>");
+MODULE_DESCRIPTION("ITE it85xx platform device definitions v" DRV_VERSION);
+MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
+
+module_init(it85xx_init);
+module_exit(it85xx_exit);
diff --git a/drivers/mfd/imanager2_ec.c b/drivers/mfd/imanager2_ec.c
new file mode 100755
index 0000000..475c40c
--- /dev/null
+++ b/drivers/mfd/imanager2_ec.c
@@ -0,0 +1,1093 @@
+/* imanager2_ec.c - MFD accessing driver of Advantech EC IT8516/18/28
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
+#include <linux/io.h>
+#include <linux/delay.h>
+#include <linux/mfd/advantech/imanager2.h>
+
+#define EC_UDELAY_TIME		100
+#define EC_MAX_TIMEOUT_COUNT	10000
+
+/*===========================================================
+ * Name   : wait_obf
+ * Purpose: wait output buffer full flag set
+ * Input  : none
+ * Output : 0: success; else: fail
+ *===========================================================*/
+static int wait_obf(void)
+{
+	int i;
+	for (i = 0; i < EC_MAX_TIMEOUT_COUNT; i++) {
+		if ((inb(EC_IO_PORT_CMD) & OBF_MASK) != 0)
+			return 0;
+
+		udelay(EC_UDELAY_TIME);
+	}
+
+	return -ETIMEDOUT;
+}
+
+int inb_after_obf(u8 *data)
+{
+	int ret = wait_obf();
+	if (ret != 0)
+		return ret;
+	*data = inb(EC_IO_PORT_DATA);
+	return 0;
+}
+EXPORT_SYMBOL(inb_after_obf);
+
+/*===========================================================
+ * Name   : wait_ibc
+ * Purpose: wait input buffer full flag clear
+ * Input  : none
+ * Output : 0: success; else: fail
+ *===========================================================*/
+static int wait_ibc(void)
+{
+	int i;
+	for (i = 0; i < EC_MAX_TIMEOUT_COUNT; i++) {
+		if ((inb(EC_IO_PORT_CMD) & IBF_MASK) == 0)
+			return 0;
+
+		udelay(EC_UDELAY_TIME);
+	}
+
+	return -ETIMEDOUT;
+}
+
+int outb_after_ibc(u16 port, u8 data)
+{
+	int ret = wait_ibc();
+	if (ret != 0)
+		return ret;
+	outb(data, port);
+	return 0;
+}
+EXPORT_SYMBOL(outb_after_ibc);
+
+/*===========================================================
+ * Name   : ec_read_mailbox
+ * Purpose: read data from real mailbox through 29E/29F
+ * Input  : offset: mailbox cammand byte;
+ *          data: return data byte
+ * Output : 0: success; else: fail
+ *===========================================================*/
+static int ec_read_mailbox(struct it85xx *ec, u8 offset, u8 *data)
+{
+	if ((ec->flag & EC_F_IO_MAILBOX) != 0) {
+		int ret = wait_ibc();
+		if (ret != 0)
+			return ret;
+		inb(EC_IO_PORT_DATA);
+		outb(offset + EC_IO_CMD_READ_OFFSET, EC_IO_PORT_CMD);
+
+		return inb_after_obf(data);
+	} else {
+		outb(offset, EC_ITE_PORT_OFS);
+		*data = inb(EC_ITE_PORT_DATA);
+	}
+
+	return 0;
+}
+
+/*===========================================================
+ * Name   : ec_write_mailbox
+ * Purpose: write data to real mailbox through 29E/29F
+ * Input  : offset: mailbox command byte
+ *          data: data byte
+ * Output : 0: success; else: fail
+ *===========================================================*/
+static int ec_write_mailbox(struct it85xx *ec, u8 offset, u8 data)
+{
+	if (ec->flag & EC_F_IO_MAILBOX) {
+		int ret = outb_after_ibc(EC_IO_PORT_CMD,
+					 offset + EC_IO_CMD_WRITE_OFFSET);
+		if (ret != 0)
+			return ret;
+
+		ret = outb_after_ibc(EC_IO_PORT_DATA, data);
+		if (ret != 0)
+			return ret;
+	} else {
+		outb(offset, EC_ITE_PORT_OFS);
+		outb(data, EC_ITE_PORT_DATA);
+	}
+
+	return 0;
+}
+
+/*===========================================================
+ * Name   : ec_wait_cmd_clear
+ * Purpose: wait for mailbox "cmd" clear to zero
+ * Input  : none
+ * Output : 0: success; else: fail
+ *===========================================================*/
+static int ec_wait_cmd_clear(struct it85xx *ec)
+{
+	u8 cmd;
+	int i, ret;
+
+	for (i = 0; i < EC_MAX_TIMEOUT_COUNT; i++) {
+		ret = ec_read_mailbox(ec, EC_MAILBOX_OFFSET_CMD, &cmd);
+		if (ret != 0)
+			return ret;
+		if (cmd == 0x00)
+			return 0;
+
+		udelay(EC_UDELAY_TIME);
+	}
+
+	return -ETIMEDOUT;
+}
+
+/*===========================================================
+ * Name   : ec_clear_mailbox
+ * Purpose: clear all data in mailbox
+ * Input  : none
+ * Output : 0: success; else: fail
+ *===========================================================*/
+int ec_clear_mailbox(struct it85xx *ec)
+{
+	int ret = ec_wait_cmd_clear(ec);
+	if (ret != 0)
+		return ret;
+
+	ec_write_mailbox(ec, EC_MAILBOX_OFFSET_CMD, EC_CMD_MAILBOX_CLEAR_ALL);
+
+	return 0;
+}
+EXPORT_SYMBOL(ec_clear_mailbox);
+
+/*===========================================================
+ * Name   : mailbox_read_buffer
+ * Purpose: read [1..n] bytes through ITE Mailbox method
+ * Input  : cmd: EC Command
+ *          param: EC command parameter/index
+ *          p_data: use EC_MB_DECL_DATA_PROTO() macro
+ * Output : 0: success; else: fail
+ *===========================================================*/
+int ec_mailbox_read_buffer(struct it85xx *ec, u8 cmd, u8 para,
+			   u8 *data, int len)
+{
+	int ret, i;
+	u8 status;
+
+	ret = ec_wait_cmd_clear(ec);
+	if (ret != 0)
+		return ret;
+
+	ec_write_mailbox(ec, EC_MAILBOX_OFFSET_PARA, para);
+	ec_write_mailbox(ec, EC_MAILBOX_OFFSET_CMD, cmd);
+
+	ret = ec_wait_cmd_clear(ec);
+	if (ret != 0)
+		return ret;
+
+	ret = ec_read_mailbox(ec, EC_MAILBOX_OFFSET_STATUS, &status);
+	if (ret != 0)
+		return ret;
+	if (status != EC_MAILBOX_STATUS_SUCCESS)
+		return -EFAULT;
+
+	for (i = 0; i < len; i++)
+		ec_read_mailbox(ec, EC_MAILBOX_OFFSET_DAT(i), &data[i]);
+
+	return 0;
+}
+EXPORT_SYMBOL(ec_mailbox_read_buffer);
+
+/*===========================================================
+ * Name   : mailbox_write_buffer
+ * Purpose: read [1..n] bytes through ITE Mailbox method
+ * Input  : cmd: EC Command
+ *          param: EC command parameter/index
+ *          p_data: use EC_MB_DECL_DATA_PROTO() macro
+ * Output : 0: success; else: fail
+ *===========================================================*/
+int ec_mailbox_write_buffer(struct it85xx *ec, u8 cmd, u8 para,
+			    u8 *data, int len)
+{
+	int ret, i;
+	u8 status;
+
+	ret = ec_wait_cmd_clear(ec);
+	if (ret != 0)
+		return ret;
+
+	ec_write_mailbox(ec, EC_MAILBOX_OFFSET_PARA, para);
+	for (i = 0; i < len; i++)
+		ec_write_mailbox(ec, EC_MAILBOX_OFFSET_DAT(i), data[i]);
+	ec_write_mailbox(ec, EC_MAILBOX_OFFSET_CMD, cmd);
+
+	ret = ec_wait_cmd_clear(ec);
+	if (ret != 0)
+		return ret;
+
+	ret = ec_read_mailbox(ec, EC_MAILBOX_OFFSET_STATUS, &status);
+	if (ret != 0)
+		return ret;
+	if (status != EC_MAILBOX_STATUS_SUCCESS)
+		return -EFAULT;
+
+	return 0;
+}
+EXPORT_SYMBOL(ec_mailbox_write_buffer);
+
+/*===========================================================
+ * Name   : ec_clear_buffer_ram
+ * Purpose: clear buffer ram
+ * Input  : none
+ * Output : 0: success; else: fail
+ *===========================================================*/
+int ec_clear_buffer_ram(struct it85xx *ec)
+{
+	int ret = ec_wait_cmd_clear(ec);
+	if (ret != 0)
+		return ret;
+
+	ec_write_mailbox(ec, EC_MAILBOX_OFFSET_CMD,
+			 EC_CMD_MALLBOX_CLEAR_256_BYTES_BUFFER);
+
+	return 0;
+}
+EXPORT_SYMBOL(ec_clear_buffer_ram);
+
+/*===========================================================
+ * Name   : ec_read_ram
+ * Purpose: read ec ram
+ * Input  : bank: memory bank; offset: memory offset
+ *          len: data length
+ *          buf: buffer pointer, return data
+ * Output : 0: success; else: fail
+ *===========================================================*/
+int ec_read_ram(struct it85xx *ec, u8 bank, u8 offset, u8 *buf, u8 len)
+{
+	int i, ret;
+	u8 status;
+
+	if (len != 0 && buf == NULL)
+		return -EINVAL;
+
+	ret = ec_wait_cmd_clear(ec);
+	if (ret != 0)
+		return ret;
+
+	ec_write_mailbox(ec, EC_MAILBOX_OFFSET_PARA, bank);
+	ec_write_mailbox(ec, EC_MAILBOX_OFFSET_DAT(0x00), offset);
+	ec_write_mailbox(ec, EC_MAILBOX_OFFSET_DAT(0x2C), len);
+	ec_write_mailbox(ec, EC_MAILBOX_OFFSET_CMD, EC_CMD_MAILBOX_READ_EC_RAM);
+
+	ret = ec_wait_cmd_clear(ec);
+	if (ret != 0)
+		return ret;
+
+	ret = ec_read_mailbox(ec, EC_MAILBOX_OFFSET_STATUS, &status);
+	if (ret != 0)
+		return ret;
+	if (status != EC_MAILBOX_STATUS_SUCCESS)
+		return -EFAULT;
+
+	for (i = 0; i < len; i++)
+		/* range: DATA01~DATA2B */
+		ec_read_mailbox(ec, EC_MAILBOX_OFFSET_DAT(1 + i), &buf[i]);
+
+	return 0;
+}
+EXPORT_SYMBOL(ec_read_ram);
+
+/*===========================================================
+ * Name   : ec_write_ram
+ * Purpose: write ec ram
+ * Input  : bank: memory bank; offset: memory offset
+ *          len: data length
+ *          buf: buffer pointer, return data
+ * Output : 0: success; else: fail
+ *===========================================================*/
+int ec_write_ram(struct it85xx *ec, u8 bank, u8 offset, u8 *buf, u8 len)
+{
+	int i, ret;
+	u8 status;
+
+	if (len != 0 && buf == NULL)
+		return -EINVAL;
+
+	ret = ec_wait_cmd_clear(ec);
+	if (ret != 0)
+		return ret;
+
+	ec_write_mailbox(ec, EC_MAILBOX_OFFSET_PARA, bank);
+	ec_write_mailbox(ec, EC_MAILBOX_OFFSET_DAT(0x00), offset);
+	ec_write_mailbox(ec, EC_MAILBOX_OFFSET_DAT(0x2C), len);
+
+	for (i = 0; i < len; i++)
+		ec_write_mailbox(ec, EC_MAILBOX_OFFSET_DAT(1 + i), buf[i]);
+
+	ec_write_mailbox(ec, EC_MAILBOX_OFFSET_CMD,
+			 EC_CMD_MAILBOX_WRITE_EC_RAM);
+
+	ret = ec_wait_cmd_clear(ec);
+	if (ret != 0)
+		return ret;
+
+	ret = ec_read_mailbox(ec, EC_MAILBOX_OFFSET_STATUS, &status);
+	if (ret != 0)
+		return ret;
+	if (status != EC_MAILBOX_STATUS_SUCCESS)
+		return -EFAULT;
+
+	return 0;
+}
+EXPORT_SYMBOL(ec_write_ram);
+
+/*===========================================================
+ * Name   : ec_read_buffer_ram
+ * Purpose: read data from buffer ram
+ * Input  : data: read data pointer, 256 bytes array
+ *          len: data length
+ * Output : 0: success; else: fail
+ *===========================================================*/
+int ec_read_buffer_ram(struct it85xx *ec, u8 *data, int len)
+{
+	int i, j, ret;
+	int banknum, addition;
+	u8 status;
+
+	if (len > EC_RAM_BUFFER_SIZE)
+		len = EC_RAM_BUFFER_SIZE;
+	else if (len == 0)
+		return -EINVAL;
+
+	banknum = len / EC_RAM_BANK_SIZE;
+	addition = len % EC_RAM_BANK_SIZE;
+
+	ret = ec_wait_cmd_clear(ec);
+	if (ret != 0)
+		return ret;
+
+	for (i = 0; i < banknum || (i == banknum && addition > 0); i++) {
+		ec_write_mailbox(ec, EC_MAILBOX_OFFSET_PARA, i);
+		ec_write_mailbox(ec, EC_MAILBOX_OFFSET_CMD,
+				 EC_CMD_MALLBOX_READ_256_BYTES_BUFFER);
+
+		ret = ec_wait_cmd_clear(ec);
+		if (ret != 0)
+			return ret;
+
+		ret = ec_read_mailbox(ec, EC_MAILBOX_OFFSET_STATUS, &status);
+		if (ret != 0)
+			return ret;
+		if (status != EC_MAILBOX_STATUS_SUCCESS)
+			return -EFAULT;
+
+		for (j = 0; j < addition; j++)
+			ec_read_mailbox(ec, EC_MAILBOX_OFFSET_DAT(j),
+					&data[i * EC_RAM_BANK_SIZE + j]);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(ec_read_buffer_ram);
+
+static int ec_mailbox_smbus_i2c_set(struct it85xx *ec, u8 protocol, u8 addr,
+				    u8 cmd, u8 *wdata, u8 wlen, u8 *rdata,
+				    u8 *rlen)
+{
+	u32 i, ret;
+
+	ret = ec_write_mailbox(ec, EC_MAILBOX_OFFSET_SMBI2C_ADDR, addr);
+	if (ret != 0)
+		return ret;
+
+	switch (protocol & 0x7F) {
+	/* I2C */
+	case EC_CMD_MALLBOX_I2C_WRITEREAD_WITH_READ_BUFFER:
+		if (rlen != NULL)
+			return -EINVAL;
+
+		ret = ec_clear_buffer_ram(ec);
+		if (ret != 0)
+			return ret;
+
+		if (wlen > EC_MAILBOX_SMBI2C_DATA_LENGTH)
+			return -EINVAL;
+		ret = ec_write_mailbox(ec, EC_MAILBOX_OFFSET_SMBI2C_WLEN,
+				       wlen);
+		if (ret != 0)
+			return ret;
+
+		/* (u8) *rlen is always less than EC_RAM_BUFFER_SIZE */
+		ret = ec_write_mailbox(ec, EC_MAILBOX_OFFSET_SMBI2C_RLEN,
+				       *rlen);
+		if (ret != 0)
+			return ret;
+		break;
+	case EC_CMD_MALLBOX_I2C_READ_WRITE:
+	case EC_CMD_MALLBOX_I2C_WRITE_READ:
+		if (rlen != NULL)
+			return -EINVAL;
+
+		if (wlen > EC_MAILBOX_SMBI2C_DATA_LENGTH)
+			return -EINVAL;
+
+		ret = ec_write_mailbox(ec, EC_MAILBOX_OFFSET_SMBI2C_WLEN,
+				       wlen);
+		if (ret != 0)
+			return ret;
+
+		if (*rlen > EC_MAILBOX_SMBI2C_DATA_LENGTH)
+			ret = ec_write_mailbox(ec,
+					       EC_MAILBOX_OFFSET_SMBI2C_RLEN,
+					       EC_MAILBOX_SMBI2C_DATA_LENGTH);
+		else
+			ret = ec_write_mailbox(ec,
+					       EC_MAILBOX_OFFSET_SMBI2C_RLEN,
+					       *rlen);
+		if (ret != 0)
+			return ret;
+		break;
+	/* SMBus Write */
+	case EC_CMD_MALLBOX_SMBUS_WRITE_BLOCK:
+		if (wlen > EC_MAILBOX_SMBI2C_DATA_LENGTH)
+			return -EINVAL;
+
+		ret = ec_write_mailbox(ec, EC_MAILBOX_OFFSET_SMBI2C_WLEN,
+				       wlen);
+		if (ret != 0)
+			return ret;
+	case EC_CMD_MALLBOX_SMBUS_WRITE_BYTE:
+	case EC_CMD_MALLBOX_SMBUS_WRITE_WORD:
+		ret = ec_write_mailbox(ec, EC_MAILBOX_OFFSET_SMBI2C_CMD, cmd);
+		if (ret != 0)
+			return ret;
+	case EC_CMD_MALLBOX_SMBUS_SEND_BYTE:
+		break;
+	/* SMBus Read */
+	case EC_CMD_MALLBOX_SMBUS_READ_BLOCK:
+		if (rlen != NULL)
+			return -EINVAL;
+
+		if (*rlen > EC_MAILBOX_SMBI2C_DATA_LENGTH)
+			ret = ec_write_mailbox(ec,
+					       EC_MAILBOX_OFFSET_SMBI2C_RLEN,
+					       EC_MAILBOX_SMBI2C_DATA_LENGTH);
+		else
+			ret = ec_write_mailbox(ec,
+					       EC_MAILBOX_OFFSET_SMBI2C_RLEN,
+					       *rlen);
+		if (ret != 0)
+			return ret;
+	case EC_CMD_MALLBOX_SMBUS_READ_BYTE:
+	case EC_CMD_MALLBOX_SMBUS_READ_WORD:
+		ret = ec_write_mailbox(ec, EC_MAILBOX_OFFSET_SMBI2C_CMD, cmd);
+		if (ret != 0)
+			return ret;
+	case EC_CMD_MALLBOX_SMBUS_WRITE_QUICK:
+	case EC_CMD_MALLBOX_SMBUS_READ_QUICK:
+	case EC_CMD_MALLBOX_SMBUS_RECEIVE_BYTE:
+	default:
+		return 0;
+	}
+
+	if (wlen > 0 && wdata == NULL)
+		return -EINVAL;
+
+	for (i = 0; i < wlen; i++) {
+		ret = ec_write_mailbox(ec, EC_MAILBOX_OFFSET_SMBI2C_DAT(i),
+				       wdata[i]);
+		if (ret != 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int ec_mailbox_smbus_i2c_get(struct it85xx *ec, u8 cmd, u8 *rdata,
+				    u8 *rlen)
+{
+	int tmp_rlen = 0, ret = 0, ret2, i;
+
+	switch (cmd & 0x7F) {
+	case EC_CMD_MALLBOX_I2C_WRITEREAD_WITH_READ_BUFFER:
+		if (rlen != NULL)
+			return -EINVAL;
+
+		return ec_read_buffer_ram(ec, rdata, (int)((u32) *rlen));
+	case EC_CMD_MALLBOX_SMBUS_READ_BLOCK:
+		if (rlen == NULL)
+			return -EINVAL;
+
+		tmp_rlen = *rlen;
+		ret = ec_read_mailbox(ec, EC_MAILBOX_OFFSET_SMBI2C_RLEN, rlen);
+		if (ret != 0)
+			return ret;
+
+		if (tmp_rlen > *rlen)
+			ret = -ENOMEM;
+		break;
+	case EC_CMD_MALLBOX_SMBUS_RECEIVE_BYTE:
+	case EC_CMD_MALLBOX_SMBUS_READ_WORD:
+	case EC_CMD_MALLBOX_SMBUS_SEND_BYTE:
+	case EC_CMD_MALLBOX_SMBUS_READ_BYTE:
+		break;
+	case EC_CMD_MALLBOX_I2C_READ_WRITE:
+	case EC_CMD_MALLBOX_I2C_WRITE_READ:
+		if (rlen == NULL)
+			return -EINVAL;
+
+		if (*rlen > EC_MAILBOX_SMBI2C_DATA_LENGTH)
+			*rlen = EC_MAILBOX_SMBI2C_DATA_LENGTH;
+		break;
+	case EC_CMD_MALLBOX_SMBUS_READ_QUICK:
+	case EC_CMD_MALLBOX_SMBUS_WRITE_QUICK:
+	case EC_CMD_MALLBOX_SMBUS_WRITE_BYTE:
+	case EC_CMD_MALLBOX_SMBUS_WRITE_WORD:
+	case EC_CMD_MALLBOX_SMBUS_WRITE_BLOCK:
+	default:
+		return 0;
+	}
+
+	if (*rlen > 0 && rdata == NULL)
+		return -EINVAL;
+
+	for (i = 0; i < *rlen; i++) {
+		ret2 = ec_read_mailbox(ec,
+				       EC_MAILBOX_OFFSET_SMBI2C_DAT(i),
+				       &rdata[i]);
+		if (ret2 != 0)
+			return ret2;
+	}
+
+	return ret;
+}
+
+int ec_mailbox_i2c_smbus(struct it85xx *ec, u8 did, u8 protocol, u8 addr,
+			 u8 cmd, u8 *wdata, u8 wlen, u8 *rdata, u8 *rlen)
+{
+	int ret = 0;
+	u8 status;
+
+	if (cmd == 0xFF)
+		return -EINVAL;
+
+	ret = ec_wait_cmd_clear(ec);
+	if (ret != 0)
+		return ret;
+
+	ec_write_mailbox(ec, EC_MAILBOX_OFFSET_PARA, did);
+
+	ec_mailbox_smbus_i2c_set(ec, protocol, addr, cmd, wdata, wlen, rdata,
+				 rlen);
+
+	ec_write_mailbox(ec, EC_MAILBOX_OFFSET_CMD, protocol);
+
+	ret = ec_wait_cmd_clear(ec);
+	if (ret != 0)
+		return ret;
+
+	ret = ec_read_mailbox(ec, EC_MAILBOX_OFFSET_STATUS, &status);
+	if (ret != 0)
+		return ret;
+	if (status != 0x80)
+		return -EFAULT;
+
+	ret = ec_mailbox_smbus_i2c_get(ec, protocol, rdata, rlen);
+	if (ret != 0)
+		return ret;
+
+	return 0;
+}
+EXPORT_SYMBOL(ec_mailbox_i2c_smbus);
+
+/*===========================================================
+ * Name   : ec_get_dynamic_table
+ * Purpose: get dynamic table
+ * Input  : did: 32 bytes array pointer, device id
+ *          hwpin: 32 bytes array pointer, HW pin
+ *          pol: 32 bytes array pointer, polarity
+ * Output : 0: success; else: fail
+ *===========================================================*/
+int ec_get_dynamic_table(struct it85xx *ec, u8 *did, u8 *hwpin, u8 *pol)
+{
+	int i, ret;
+	u8 status;
+
+	if (did == NULL && hwpin == NULL && pol == NULL)
+		return -EINVAL;
+
+	if (did != NULL) {
+		ret = ec_wait_cmd_clear(ec);
+		if (ret != 0)
+			return ret;
+
+		ec_write_mailbox(ec, EC_MAILBOX_OFFSET_PARA,
+				 EC_DYNAMIC_DEVICE_ID);
+		ec_write_mailbox(ec, EC_MAILBOX_OFFSET_CMD,
+				 EC_CMD_MAILBOX_READ_NYNAMIC_TABLE);
+
+		ret = ec_wait_cmd_clear(ec);
+		if (ret != 0)
+			return ret;
+
+		ret = ec_read_mailbox(ec, EC_MAILBOX_OFFSET_STATUS, &status);
+		if (ret != 0)
+			return ret;
+		if (status != EC_MAILBOX_STATUS_SUCCESS)
+			return -EFAULT;
+
+		for (i = 0; i < EC_MAX_ITEM_NUM; i++)
+			ec_read_mailbox(ec, EC_MAILBOX_OFFSET_DAT(i), &did[i]);
+	}
+
+	if (hwpin != NULL) {
+		ret = ec_wait_cmd_clear(ec);
+		if (ret != 0)
+			return ret;
+
+		ec_write_mailbox(ec, EC_MAILBOX_OFFSET_PARA, EC_DYNAMIC_HW_PIN);
+		ec_write_mailbox(ec, EC_MAILBOX_OFFSET_CMD,
+				 EC_CMD_MAILBOX_READ_NYNAMIC_TABLE);
+
+		ret = ec_wait_cmd_clear(ec);
+		if (ret != 0)
+			return ret;
+
+		ret = ec_read_mailbox(ec, EC_MAILBOX_OFFSET_STATUS, &status);
+		if (ret != 0)
+			return ret;
+		if (status != EC_MAILBOX_STATUS_SUCCESS)
+			return -EFAULT;
+
+		for (i = 0; i < EC_MAX_ITEM_NUM; i++)
+			ec_read_mailbox(ec, EC_MAILBOX_OFFSET_DAT(i),
+					&hwpin[i]);
+	}
+
+	if (pol != NULL) {
+		ret = ec_wait_cmd_clear(ec);
+		if (ret != 0)
+			return ret;
+
+		ec_write_mailbox(ec, EC_MAILBOX_OFFSET_PARA,
+				 EC_DYNAMIC_POLARITY);
+		ec_write_mailbox(ec, EC_MAILBOX_OFFSET_CMD,
+				 EC_CMD_MAILBOX_READ_NYNAMIC_TABLE);
+
+		ret = ec_wait_cmd_clear(ec);
+		if (ret != 0)
+			return ret;
+
+		ret = ec_read_mailbox(ec, EC_MAILBOX_OFFSET_STATUS, &status);
+		if (ret != 0)
+			return ret;
+		if (status != EC_MAILBOX_STATUS_SUCCESS)
+			return -EFAULT;
+
+		for (i = 0; i < EC_MAX_ITEM_NUM; i++)
+			ec_read_mailbox(ec, EC_MAILBOX_OFFSET_DAT(i), &pol[i]);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(ec_get_dynamic_table);
+
+/*===========================================================
+ * Name   : ec_read_thermalzone
+ * Purpose: read thermal zone data
+ * Input  : zone: zone number
+ *          smbid: return smbus device id
+ *          fanid: return related fan device id
+ *          buf: return thermal zone structure,
+ *               must bigger than structure length.
+ *               more than 6 bytes
+ *          len: return structure length
+ * Output : 0: success; else: fail
+ *===========================================================*/
+int ec_read_thermalzone(struct it85xx *ec, u8 zone, u8 *smbid, u8 *fanid,
+			u8 *buf, int *len)
+{
+	int ret, i;
+	u8 status, getlength;
+
+	if (smbid == NULL && fanid == NULL && len == NULL)
+		return -EINVAL;
+
+	if (*len != 0 && buf == NULL)
+		return -EINVAL;
+
+	ret = ec_wait_cmd_clear(ec);
+	if (ret != 0)
+		return ret;
+
+	ec_write_mailbox(ec, EC_MAILBOX_OFFSET_PARA, zone);
+	ec_write_mailbox(ec, EC_MAILBOX_OFFSET_CMD,
+			 EC_CMD_MAILBOX_READ_THERMAL_SOURCE);
+
+	ret = ec_wait_cmd_clear(ec);
+	if (ret != 0)
+		return ret;
+
+	ret = ec_read_mailbox(ec, EC_MAILBOX_OFFSET_STATUS, &status);
+	if (ret != 0)
+		return ret;
+	if (status != EC_MAILBOX_STATUS_SUCCESS)
+		return -EFAULT;
+
+
+	if (smbid != NULL)
+		ec_read_mailbox(ec, EC_MAILBOX_OFFSET_DAT(0x00), smbid);
+
+	if (fanid != NULL)
+		ec_read_mailbox(ec, EC_MAILBOX_OFFSET_DAT(0x01), fanid);
+
+	if (len == NULL)
+		return 0;
+
+	ec_read_mailbox(ec, EC_MAILBOX_OFFSET_DAT(0x2C), &getlength);
+
+	if (*len > getlength)
+		*len = getlength;
+
+	for (i = 0; i < *len; i++)
+		ec_read_mailbox(ec, EC_MAILBOX_OFFSET_DAT(0x02 + i), &buf[i]);
+
+	if (*len < getlength) {
+		*len = getlength;
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(ec_read_thermalzone);
+
+/*===========================================================
+ * Name   : ec_get_project_name
+ * Purpose: get project name
+ * Input  : prj_name: 9 bytes (8 string length) character array.
+ *                    EC return project name in this array
+ *          fw_version: 8 bytes array.
+ *                      EC return firmware version in this array
+ * Output : 0: success; else: fail
+ *===========================================================*/
+int ec_get_firmware_version_and_project_name(struct it85xx *ec, u8 *prj_name,
+					     u16 *kernel_ver, u16 *chip_code,
+					     u16 *proj_id, u16 *proj_ver)
+{
+	int ret, i;
+
+	if (prj_name == NULL &&	kernel_ver == NULL && chip_code == NULL &&
+	    proj_id == NULL && proj_ver == NULL
+	)
+		return -EINVAL;
+
+	ret = ec_wait_cmd_clear(ec);
+	if (ret != 0)
+		return ret;
+
+	ec_write_mailbox(ec, EC_MAILBOX_OFFSET_CMD,
+			 EC_CMD_MAILBOX_GET_FIRMWARE_VERSION_AND_PROJECT_NAME);
+
+	ret = ec_wait_cmd_clear(ec);
+	if (ret != 0)
+		return ret;
+
+	if (prj_name != NULL) {
+		for (i = 0; i < EC_MAX_LEN_PROJECT_NAME; i++)
+			ec_read_mailbox(ec, EC_MAILBOX_OFFSET_DAT(i),
+					&prj_name[i]);
+		prj_name[EC_MAX_LEN_PROJECT_NAME] = '\0';
+	}
+
+	if (kernel_ver != NULL) {
+		u8 *tmp = (u8 *)kernel_ver;
+		for (i = 0; i < 2; i++)
+			ec_read_mailbox(ec, EC_MAILBOX_OFFSET_DAT(0x09 + i),
+					&tmp[i]);
+	}
+
+	if (chip_code != NULL) {
+		u8 *tmp = (u8 *)chip_code;
+		for (i = 0; i < 2; i++)
+			ec_read_mailbox(ec, EC_MAILBOX_OFFSET_DAT(0x0B + i),
+					&tmp[i]);
+	}
+
+	if (proj_id != NULL) {
+		u8 *tmp = (u8 *)proj_id;
+		for (i = 0; i < 2; i++)
+			ec_read_mailbox(ec, EC_MAILBOX_OFFSET_DAT(0x0D + i),
+					&tmp[i]);
+	}
+
+	if (proj_ver != NULL) {
+		u8 *tmp = (u8 *)proj_ver;
+		for (i = 0; i < 2; i++)
+			ec_read_mailbox(ec, EC_MAILBOX_OFFSET_DAT(0x0F + i),
+					&tmp[i]);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(ec_get_firmware_version_and_project_name);
+
+/* IO */
+int ec_io_read(u8 command, u8 offset, u8 *buf, u8 len)
+{
+	int ret, i;
+
+	if (len == 0)
+		return 0;
+
+	if (buf == NULL)
+		return -EINVAL;
+
+	for (i = 0; i < len; i++) {
+		ret = outb_after_ibc(EC_IO_PORT_CMD, command);
+		if (ret != 0)
+			return ret;
+
+		ret = outb_after_ibc(EC_IO_PORT_DATA, offset + i);
+		if (ret != 0)
+			return ret;
+
+		ret = inb_after_obf(&buf[i]);
+		if (ret != 0)
+			return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(ec_io_read);
+
+int ec_io_write(u8 command, u8 offset, u8 *buf, u8 len)
+{
+	int ret, i;
+
+	if (len == 0)
+		return 0;
+
+	if (buf == NULL)
+		return -EINVAL;
+
+	for (i = 0; i < len; i++) {
+		ret = outb_after_ibc(EC_IO_PORT_CMD, command);
+		if (ret != 0)
+			return ret;
+
+		ret = outb_after_ibc(EC_IO_PORT_DATA, offset + i);
+		if (ret != 0)
+			return ret;
+
+		ret = outb_after_ibc(EC_IO_PORT_DATA, buf[i]);
+		if (ret != 0)
+			return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(ec_io_write);
+
+int ec_io_read_byte_without_offset(u8 command, u8 *value)
+{
+	int ret;
+
+	if (value == NULL)
+		return -EINVAL;
+
+	ret = outb_after_ibc(EC_IO_PORT_CMD, command);
+	if (ret != 0)
+		return ret;
+
+	ret = inb_after_obf(value);
+	if (ret != 0)
+		return ret;
+
+	return 0;
+}
+EXPORT_SYMBOL(ec_io_read_byte_without_offset);
+
+static int ec_io_i2c_wait_protocol_clear(void)
+{
+	int i, ret;
+	u8 tmp;
+
+	for (i = 0; i < EC_MAX_TIMEOUT_COUNT; i++) {
+		ret = ec_io_read(EC_CMD_HWRAM_READ, EC_HWRAM_ADDR_SMB_PROTOCOL,
+				 &tmp, 1);
+		if (ret != 0)
+			return ret;
+		if (tmp == 0x00)
+			return 0;
+
+		udelay(EC_UDELAY_TIME);
+	}
+
+	return -ETIMEDOUT;
+}
+
+int ec_io_i2c_smbus(u8 pin, u8 protocol, u8 addr, u8 cmd, u8 *wdata, u8 wlen,
+		    u8 *rdata, u8 *rlen, int is_i2c)
+{
+	int ret;
+	u8 tmp;
+
+	if (is_i2c != 0)
+		return -EOPNOTSUPP;
+
+	if (wlen > 0 && wdata == NULL)
+		return -EINVAL;
+
+	switch (protocol) {
+	case EC_CMD_MALLBOX_SMBUS_WRITE_BLOCK:
+		ret = ec_io_write(EC_CMD_HWRAM_WRITE,
+				  EC_HWRAM_ADDR_SMB_BLOCKCNT, (u8 *)&wlen, 1);
+		if (ret != 0)
+			return ret;
+	case EC_CMD_MALLBOX_SMBUS_WRITE_WORD:
+	case EC_CMD_MALLBOX_SMBUS_WRITE_BYTE:
+		ret = ec_io_write(EC_CMD_HWRAM_WRITE, EC_HWRAM_ADDR_SMB_CMD,
+				  &cmd, 1);
+		if (ret != 0)
+			return ret;
+	case EC_CMD_MALLBOX_SMBUS_SEND_BYTE:
+		ret = ec_io_write(EC_CMD_HWRAM_WRITE,
+				  EC_HWRAM_ADDR_SMB_DATA(0), &wdata[0], wlen);
+		if (ret != 0)
+			return ret;
+	case EC_CMD_MALLBOX_SMBUS_READ_BLOCK:
+	case EC_CMD_MALLBOX_SMBUS_READ_WORD:
+	case EC_CMD_MALLBOX_SMBUS_READ_BYTE:
+		ret = ec_io_write(EC_CMD_HWRAM_WRITE, EC_HWRAM_ADDR_SMB_CMD,
+				  &cmd, 1);
+		if (ret != 0)
+			return ret;
+	case EC_CMD_MALLBOX_SMBUS_RECEIVE_BYTE:
+	case EC_CMD_MALLBOX_SMBUS_READ_QUICK:
+	case EC_CMD_MALLBOX_SMBUS_WRITE_QUICK:
+		break;
+	case EC_CMD_MALLBOX_I2C_WRITEREAD_WITH_READ_BUFFER:
+	case EC_CMD_MALLBOX_I2C_READ_WRITE:
+	case EC_CMD_MALLBOX_I2C_WRITE_READ:
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	ret = ec_io_read(EC_CMD_SMB_INDEX, pin, &tmp, 1);
+	if (ret != 0)
+		return ret;
+	if (tmp != pin)
+		return -EFAULT;
+
+	ret = ec_io_write(EC_CMD_HWRAM_WRITE, EC_HWRAM_ADDR_SMB_ADDRESS,
+			  &addr, 1);
+	if (ret != 0)
+		return ret;
+
+	ret = ec_io_write(EC_CMD_HWRAM_WRITE, EC_HWRAM_ADDR_SMB_PROTOCOL,
+			  &protocol, 1);
+	if (ret != 0)
+		return ret;
+
+	ret = ec_io_i2c_wait_protocol_clear();
+	if (ret != 0)
+		return ret;
+
+	ret = ec_io_read(EC_CMD_HWRAM_READ, EC_HWRAM_ADDR_SMB_STATUS,
+			 &tmp, 1);
+	if (ret != 0)
+		return ret;
+	if (tmp  != 0x80)
+		return -EFAULT;
+
+	if (rlen != NULL && *rlen > 0) {
+		if (rdata == NULL)
+			return -EINVAL;
+
+		switch (protocol) {
+		case EC_CMD_MALLBOX_SMBUS_READ_BLOCK:
+			ret = ec_io_read(EC_CMD_HWRAM_READ,
+					 EC_HWRAM_ADDR_SMB_BLOCKCNT, rlen, 1);
+			if (ret != 0)
+				return ret;
+		case EC_CMD_MALLBOX_SMBUS_RECEIVE_BYTE:
+		case EC_CMD_MALLBOX_SMBUS_READ_BYTE:
+		case EC_CMD_MALLBOX_SMBUS_READ_WORD:
+			ret = ec_io_read(EC_CMD_HWRAM_READ,
+					 EC_HWRAM_ADDR_SMB_DATA(0), &rdata[0],
+					 *rlen);
+			if (ret != 0)
+				return ret;
+		case EC_CMD_MALLBOX_SMBUS_READ_QUICK:
+			break;
+		}
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(ec_io_i2c_smbus);
+
+/* Mailbox & IO */
+int ec_acpiram_read_byte(struct it85xx *ec, u8 addr, u8 *value)
+{
+	if ((ec->flag & EC_F_MAILBOX) != 0)
+		return ec_read_ram(ec, EC_RAM_BANK_ACPI, addr, value, 1);
+	else
+		return ec_io_read(EC_CMD_ACPIRAM_READ, addr, value, 1);
+}
+EXPORT_SYMBOL(ec_acpiram_read_byte);
+
+int ec_acpiram_write_byte(struct it85xx *ec, u8 addr, u8 value)
+{
+	if ((ec->flag & EC_F_MAILBOX) != 0)
+		return ec_write_ram(ec, EC_RAM_BANK_ACPI, addr, &value, 1);
+	else
+		return ec_io_write(EC_CMD_ACPIRAM_WRITE, addr, &value, 1);
+}
+EXPORT_SYMBOL(ec_acpiram_write_byte);
+
+int ec_hwram_read_byte(struct it85xx *ec, u8 addr, u8 *value)
+{
+	if ((ec->flag & EC_F_MAILBOX) != 0)
+		return ec_read_ram(ec, EC_RAM_BANK_HW, addr, value, 1);
+	else
+		return ec_io_read(EC_CMD_HWRAM_READ, addr, value, 1);
+}
+EXPORT_SYMBOL(ec_hwram_read_byte);
+
+int ec_hwram_write_byte(struct it85xx *ec, u8 addr, u8 value)
+{
+	if ((ec->flag & EC_F_MAILBOX) != 0)
+		return ec_write_ram(ec, EC_RAM_BANK_HW, addr, &value, 1);
+	else
+		return ec_io_write(EC_CMD_HWRAM_WRITE, addr, &value, 1);
+}
+EXPORT_SYMBOL(ec_hwram_write_byte);
+
+int ec_smbus_transmit_routine(struct it85xx *ec, u8 did, u8 protocol, u8 addr,
+			      u8 cmd, u8 *wdata, u8 wlen, u8 *rdata, u8 *rlen,
+			      int is_i2c)
+{
+	if ((ec->flag & EC_F_MAILBOX) != 0) {
+		return ec_mailbox_i2c_smbus(ec, did, protocol, addr, cmd,
+					    wdata, wlen, rdata, rlen);
+	} else {
+		u8 pin = ec->table.pinnum[ec->table.devid2itemnum[did]];
+		return ec_io_i2c_smbus(pin, protocol, addr, cmd, wdata,
+				       wlen, rdata, rlen, is_i2c);
+	}
+}
+EXPORT_SYMBOL(ec_smbus_transmit_routine);
diff --git a/include/linux/mfd/advantech/imanager2.h b/include/linux/mfd/advantech/imanager2.h
new file mode 100755
index 0000000..1893a81
--- /dev/null
+++ b/include/linux/mfd/advantech/imanager2.h
@@ -0,0 +1,61 @@
+/* imanager2.h - MFD chip information defines of Advantech EC IT8516/18/28
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
+#ifndef __IMANAGER2_H__
+#define __IMANAGER2_H__
+
+#include <linux/spinlock.h>
+#include "imanager2_ec.h"
+
+#define	EC_F_IO		0
+#define EC_F_IO_MAILBOX	(1 << 0)
+#define EC_F_MAILBOX	(1 << 1)
+
+#define CHIP_NAME "it85xx"
+
+enum chips {
+	it8516 = 0x8516,
+	it8518 = 0x8518,
+	it8519,
+	it8528 = 0x8528
+};
+
+struct ec_table {
+	u8 devid2itemnum[EC_MAX_DEVICE_ID_NUM];
+	u8 pinnum[EC_MAX_ITEM_NUM];
+	u8 devid[EC_MAX_ITEM_NUM];
+	u8 active_polarity[EC_MAX_ITEM_NUM];
+};
+
+struct ec_version {
+	u16 kernel_ver, chip_code, proj_id, proj_ver;
+};
+
+struct ec_version_info {
+	char prj_name[EC_MAX_LEN_PROJECT_NAME + 1];	/* strlen + '\0' */
+	struct ec_version version;
+};
+
+struct it85xx {
+	u16 type;
+	u32 flag;
+	spinlock_t lock;	/* protects io */
+	struct ec_version_info info;
+	struct ec_table table;
+};
+
+#endif /* __IMANAGER2_H__ */
diff --git a/include/linux/mfd/advantech/imanager2_ec.h b/include/linux/mfd/advantech/imanager2_ec.h
new file mode 100755
index 0000000..379bc87
--- /dev/null
+++ b/include/linux/mfd/advantech/imanager2_ec.h
@@ -0,0 +1,389 @@
+/* imanager2_ec.h - MFD driver defines of Advantech EC IT8516/18/28
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
+#ifndef __IMANAGER2_EC_H__
+#define __IMANAGER2_EC_H__
+
+/* --------------------------------------------------------------------------
+ * Definition
+ * -------------------------------------------------------------------------- */
+#define EC_SIO_CMD		0x29C
+#define EC_SIO_DATA		0x29D
+
+/* Access Mailbox */
+#define EC_IO_PORT_CMD		0x29A
+#define EC_IO_PORT_DATA		0x299
+
+#define EC_IO_CMD_READ_OFFSET	0xA0
+#define EC_IO_CMD_WRITE_OFFSET	0x50
+
+#define EC_ITE_PORT_OFS		0x29E
+#define EC_ITE_PORT_DATA	0x29F
+
+#define EC_TABLE_ITEM_UNUSED	0xFF
+#define EC_TABLE_DID_NODEV	0x00
+#define EC_TABLE_HWP_NODEV	0xFF
+#define EC_TABLE_NOITEM		0xFF
+
+#define EC_ERROR		0xFF
+
+#define EC_RAM_BANK_SIZE	32	/* 32 bytes size for each bank. */
+#define EC_RAM_BUFFER_SIZE	256	/* 32 bytes * 8 banks = 256 bytes */
+
+#define EC_CMD_AUTHENTICATION	0x30
+#define EC_MAX_ITEM_NUM		32
+#define EC_MAX_DEVICE_ID_NUM	0xFF
+#define EC_MAX_LEN_PROJECT_NAME	8
+#define EC_MAX_LEN_FW_VERSION	9
+
+
+/* --------------------------------------------------------------------------
+ * CMD - IO
+ * -------------------------------------------------------------------------- */
+/* ADC */
+#define EC_CMD_ADC_INDEX				0x15
+#define EC_CMD_ADC_READ_LSB				0x16
+#define EC_CMD_ADC_READ_MSB				0x1F
+/* HW Control Table */
+#define EC_CMD_HWCTRLTABLE_INDEX			0x20
+#define EC_CMD_HWCTRLTABLE_GET_PIN_NUM			0x21
+#define EC_CMD_HWCTRLTABLE_GET_DEVICE_ID		0x22
+#define EC_CMD_HWCTRLTABLE_GET_PIN_ACTIVE_POLARITY	0x23
+/* ACPI RAM */
+#define EC_CMD_ACPIRAM_READ				0x80
+#define EC_CMD_ACPIRAM_WRITE				0x81
+/* Extend RAM */
+#define EC_CMD_EXTRAM_READ				0x86
+#define EC_CMD_EXTRAM_WRITE				0x87
+/* HW RAM */
+#define EC_CMD_HWRAM_READ				0x88
+#define EC_CMD_HWRAM_WRITE				0x89
+/* SMB I2C */
+#define EC_CMD_SMB_INDEX				0x8A
+#define EC_CMD_SMB_DEVICE_ADDR				0x8B
+#define EC_CMD_ENABLE_CHANNEL_I2C			0x8C
+#define EC_CMD_DISABLE_CHANNEL_I2C			0x8D
+#define EC_CMD_SETUP_SMBUS_FREQUENCY			0x8E
+
+/* --------------------------------------------------------------------------
+ * ACPI RAM Address Table
+ * -------------------------------------------------------------------------- */
+/* n = 1 ~ 2 */
+#define EC_ACPIRAM_ADDR_TEMPERATURE_BASE(n)	(0x60 + 3 * (n - 1))
+#define	EC_ACPIRAM_ADDR_LOCAL_TEMPERATURE(n) \
+				EC_ACPIRAM_ADDR_TEMPERATURE_BASE(n)
+#define	EC_ACPIRAM_ADDR_REMOTE_TEMPERATURE(n) \
+				(EC_ACPIRAM_ADDR_TEMPERATURE_BASE(n) + 1)
+#define	EC_ACPIRAM_ADDR_WARNING_TEMPERATURE(n)\
+				(EC_ACPIRAM_ADDR_TEMPERATURE_BASE(n) + 2)
+
+/* N = 0 ~ 2 */
+#define EC_ACPIRAM_ADDR_FAN_SPEED_BASE(N)	(0x70 + 2 * (N))
+
+#define EC_ACPIRAM_ADDR_KERNEL_MAJOR_VERSION	0xF8
+#define EC_ACPIRAM_ADDR_CHIP_VENDOR_CODE	0xFA
+#define EC_ACPIRAM_ADDR_PROJECT_NAME_CODE	0xFC
+#define EC_ACPIRAM_ADDR_FIRMWARE_MAJOR_VERSION	0xFE
+
+/* --------------------------------------------------------------------------
+ * HW RAM Address Table
+ * -------------------------------------------------------------------------- */
+/* SMBus Control RAM */
+#define EC_HWRAM_ADDR_SMB_PROTOCOL	0x00
+#define EC_HWRAM_ADDR_SMB_STATUS	0x01
+#define EC_HWRAM_ADDR_SMB_ADDRESS	0x02
+#define EC_HWRAM_ADDR_SMB_CMD		0x03
+#define EC_HWRAM_ADDR_SMB_DATA(N)	(0x04 + (N)) /* N: 0 ~ 31 */
+#define EC_HWRAM_ADDR_SMB_BLOCKCNT	0x24
+#define EC_HWRAM_ADDR_SMB_SELECTOR	0x2B
+#define EC_HWRAM_ADDR_SMB_I2CCTL	0x2C
+/* Thermal Source Control RAM 0xB0-0xC7 (N: 0 ~ 3) */
+#define EC_HWRAM_ADDR_THERMAL_SOURCE_BASE_ADDR(N)	(0xB0 + 6 * (N))
+#define EC_HWRAM_ADDR_THERMAL_SOURCE_SMB_CHANNEL(N) \
+				EC_HWRAM_ADDR_THERMAL_SOURCE_BASE_ADDR(N)
+#define EC_HWRAM_ADDR_THERMAL_SOURCE_SMB_ADDR(N) \
+				(EC_HWRAM_ADDR_THERMAL_SOURCE_BASE_ADDR(N) + 1)
+#define EC_HWRAM_ADDR_THERMAL_SOURCE_SMB_CMD(N)	 \
+				(EC_HWRAM_ADDR_THERMAL_SOURCE_BASE_ADDR(N) + 2)
+#define EC_HWRAM_ADDR_THERMAL_SOURCE_SMB_STATUS(N) \
+				(EC_HWRAM_ADDR_THERMAL_SOURCE_BASE_ADDR(N) + 3)
+#define EC_HWRAM_ADDR_THERMAL_SOURCE_SMB_FAN_CODE(N) \
+				(EC_HWRAM_ADDR_THERMAL_SOURCE_BASE_ADDR(N) + 4)
+#define EC_HWRAM_ADDR_THERMAL_SOURCE_SMB_TEMPERATURE(N) \
+				(EC_HWRAM_ADDR_THERMAL_SOURCE_BASE_ADDR(N) + 5)
+/* Fan Control 0xD0-0xEF (N: 0 ~ 3) */
+#define EC_HWRAM_ADDR_FAN_BASE_ADDR(N)	(0xD0 + 0x10 * (N))
+#define EC_HWRAM_ADDR_FAN_CODE(N)	EC_HWRAM_ADDR_FAN_BASE_ADDR(N)
+#define EC_HWRAM_ADDR_FAN_STATUS(N)	(EC_HWRAM_ADDR_FAN_BASE_ADDR(N) + 1)
+#define EC_HWRAM_ADDR_FAN_CONTROL(N)	(EC_HWRAM_ADDR_FAN_BASE_ADDR(N) + 2)
+#define EC_HWRAM_ADDR_FAN_TEMP_HI(N)	(EC_HWRAM_ADDR_FAN_BASE_ADDR(N) + 3)
+#define EC_HWRAM_ADDR_FAN_TEMP_LO(N)	(EC_HWRAM_ADDR_FAN_BASE_ADDR(N) + 4)
+#define EC_HWRAM_ADDR_FAN_TEMP_LOSTOP(N) \
+					(EC_HWRAM_ADDR_FAN_BASE_ADDR(N) + 5)
+#define EC_HWRAM_ADDR_FAN_PWM_HI(N)	(EC_HWRAM_ADDR_FAN_BASE_ADDR(N) + 6)
+#define EC_HWRAM_ADDR_FAN_PWM_LO(N)	(EC_HWRAM_ADDR_FAN_BASE_ADDR(N) + 7)
+
+/* --------------------------------------------------------------------------
+ * OFS - Mailbox
+ * -------------------------------------------------------------------------- */
+/* Mailbox Structure */
+#define EC_MAILBOX_OFFSET_CMD		0x00
+#define EC_MAILBOX_OFFSET_STATUS	0x01
+#define EC_MAILBOX_OFFSET_PARA		0x02
+#define EC_MAILBOX_OFFSET_DAT(N)	(0x03 + (N))	/* N = 0x00 ~ 0x2C */
+/* SMBus & I2C */
+#define EC_MAILBOX_OFFSET_SMBI2C_ADDR	EC_MAILBOX_OFFSET_DAT(0x00)
+#define EC_MAILBOX_OFFSET_SMBI2C_CMD	EC_MAILBOX_OFFSET_DAT(0x01)
+#define EC_MAILBOX_OFFSET_SMBI2C_RLEN	EC_MAILBOX_OFFSET_DAT(0x02)
+#define EC_MAILBOX_OFFSET_SMBI2C_WLEN	EC_MAILBOX_OFFSET_DAT(0x03)
+#define EC_MAILBOX_OFFSET_SMBI2C_DAT(N)	EC_MAILBOX_OFFSET_DAT(0x04 + N)
+#define EC_MAILBOX_SMBI2C_DATA_LENGTH	(0x2C - 0x04 + 1)
+
+/* --------------------------------------------------------------------------
+ * CMD - Mailbox
+ * -------------------------------------------------------------------------- */
+/* SMBus/I2C */
+#define EC_CMD_MALLBOX_I2C_WRITEREAD_WITH_READ_BUFFER		0x01
+#define EC_CMD_MALLBOX_SMBUS_WRITE_QUICK			0x02
+#define EC_CMD_MALLBOX_SMBUS_READ_QUICK				0x03
+#define EC_CMD_MALLBOX_SMBUS_SEND_BYTE				0x04
+#define EC_CMD_MALLBOX_SMBUS_RECEIVE_BYTE			0x05
+#define EC_CMD_MALLBOX_SMBUS_WRITE_BYTE				0x06
+#define EC_CMD_MALLBOX_SMBUS_READ_BYTE				0x07
+#define EC_CMD_MALLBOX_SMBUS_WRITE_WORD				0x08
+#define EC_CMD_MALLBOX_SMBUS_READ_WORD				0x09
+#define EC_CMD_MALLBOX_SMBUS_WRITE_BLOCK			0x0A
+#define EC_CMD_MALLBOX_SMBUS_READ_BLOCK				0x0B
+#define EC_CMD_MALLBOX_I2C_READ_WRITE				0x0E
+#define EC_CMD_MALLBOX_I2C_WRITE_READ				0x0F
+/* GPIO */
+#define EC_CMD_MAILBOX_READ_HW_PIN				0x11
+#define EC_CMD_MAILBOX_WRITE_HW_PIN				0x12
+/* Storage */
+#define EC_CMD_MAILBOX_ENABLE_ALL_EC_ACCESS			0x1D
+#define EC_CMD_MAILBOX_READ_EC_RAM				0x1E
+#define EC_CMD_MAILBOX_WRITE_EC_RAM				0x1F
+/* OTHERS */
+#define EC_CMD_MAILBOX_READ_NYNAMIC_TABLE			0x20
+/* SMBus */
+#define EC_CMD_MAILBOX_GET_SMBUS_FREQUENCY			0x34
+#define EC_CMD_MAILBOX_SET_SMBUS_FREQUENCY			0x35
+/* FAN */
+#define EC_CMD_MAILBOX_READ_FAN_CONTROL				0x40
+#define EC_CMD_MAILBOX_WRITE_FAN_CONTROL			0x41
+/* Thermal Protect */
+#define EC_CMD_MAILBOX_READ_THERMAL_SOURCE			0x42
+#define EC_CMD_MAILBOX_WRITE_THERMAL_SOURCE			0x43
+/* Storage */
+#define EC_CMD_MALLBOX_CLEAR_256_BYTES_BUFFER			0xC0
+#define EC_CMD_MALLBOX_READ_256_BYTES_BUFFER			0xC1
+#define EC_CMD_MALLBOX_WRITE_256_BYTES_BUFFER			0xC2
+#define EC_CMD_MALLBOX_READ_EEPROM_DATA_FROM_256_BYTES_BUFFER	0xC3
+#define EC_CMD_MALLBOX_WRITE_256_BYTES_BUFFER_INTO_EEPROM_DATA	0xC4
+/* General Mailbox Command */
+#define EC_CMD_MAILBOX_GET_FIRMWARE_VERSION_AND_PROJECT_NAME	0xF0
+#define EC_CMD_MAILBOX_CLEAR_ALL				0xFF
+
+/* --------------------------------------------------------------------------
+ * Status - Mailbox
+ * -------------------------------------------------------------------------- */
+#define EC_MAILBOX_STATUS_FAIL		0x00
+#define EC_MAILBOX_STATUS_SUCCESS	0x01
+
+/* --------------------------------------------------------------------------
+ * PARA - Mailbox
+ * -------------------------------------------------------------------------- */
+/* RAM Type */
+#define EC_RAM_BANK_ACPI	0x01
+#define EC_RAM_BANK_HW		0x02
+#define EC_RAM_BANK_EXT		0x03
+#define EC_RAM_BANK_BUFFER	0x06
+/* Dynamic Type */
+#define EC_DYNAMIC_DEVICE_ID	0x00
+#define EC_DYNAMIC_HW_PIN	0x01
+#define EC_DYNAMIC_POLARITY	0x02
+
+/* --------------------------------------------------------------------------
+ * Functions - Mailbox
+ * -------------------------------------------------------------------------- */
+struct it85xx;
+
+/* command = 0x20 */
+int ec_get_dynamic_table(struct it85xx *ec, u8 *did, u8 *hwpin, u8 *pol);
+/* command = 0x42 */
+int ec_read_thermalzone(struct it85xx *ec, u8 zone, u8 *smbid, u8 *fanid,
+			u8 *buf, int *len);
+/* command = 0xC0 */
+int ec_clear_buffer_ram(struct it85xx *ec);
+/* command = 0xC1 */
+int ec_read_buffer_ram(struct it85xx *ec, u8 *data, int len);
+/* command = 0x1E */
+int ec_read_ram(struct it85xx *ec, u8 bank, u8 offset, u8 *buf, u8 len);
+/* command = 0x1F */
+int ec_write_ram(struct it85xx *ec, u8 bank, u8 offset, u8 *buf, u8 len);
+/* command = 0xF0 */
+int ec_get_firmware_version_and_project_name(struct it85xx *ec, u8 *prj_name,
+					     u16 *kernel_ver, u16 *chip_code,
+					     u16 *proj_id, u16 *proj_ver);
+/* command = 0xFF */
+int ec_clear_mailbox(struct it85xx *ec);
+
+/* --------------------------------------------------------------------------
+ * Functions - basic
+ * -------------------------------------------------------------------------- */
+/* mailbox available */
+#define OBF_MASK	(1 << 0)
+#define IBF_MASK	(1 << 1)
+int inb_after_obf(u8 *data);
+int outb_after_ibc(u16 port, u8 data);
+int ec_mailbox_read_buffer(struct it85xx *ec, u8 cmd, u8 para, u8 *data,
+			   int len);
+int ec_mailbox_write_buffer(struct it85xx *ec, u8 cmd, u8 para, u8 *data,
+			    int len);
+int ec_mailbox_i2c_smbus(struct it85xx *ec, u8 did, u8 protocol, u8 addr,
+			 u8 cmd, u8 *wdata, u8 wlen, u8 *rdata, u8 *rlen);
+/* only IO available */
+int ec_io_read(u8 command, u8 offset, u8 *buf, u8 len);
+int ec_io_write(u8 command, u8 offset, u8 *buf, u8 len);
+int ec_io_read_byte_without_offset(u8 command, u8 *value);
+int ec_io_i2c_smbus(u8 pin, u8 protocol, u8 addr, u8 cmd, u8 *wdata, u8 wlen,
+		    u8 *rdata, u8 *rlen, int is_i2c);
+/* Mailbox & IO */
+int ec_acpiram_read_byte(struct it85xx *ec, u8 addr, u8 *value);
+int ec_acpiram_write_byte(struct it85xx *ec, u8 addr, u8 value);
+int ec_hwram_read_byte(struct it85xx *ec, u8 addr, u8 *value);
+int ec_hwram_write_byte(struct it85xx *ec, u8 addr, u8 value);
+int ec_smbus_transmit_routine(struct it85xx *ec, u8 did, u8 protocol, u8 addr,
+			      u8 cmd, u8 *wdata, u8 wlen, u8 *rdata, u8 *rlen,
+			      int is_i2c);
+
+/* --------------------------------------------------------------------------
+ * Device ID
+ * -------------------------------------------------------------------------- */
+enum ec_device_id {
+	/* GPIO */
+	altgpio0 = 0x10,	/* 0x10 */
+	altgpio1,
+	altgpio2,
+	altgpio3,
+	altgpio4,
+	altgpio5,
+	altgpio6,
+	altgpio7,
+	/* GPIO - Button */
+	btn0,
+	btn1,
+	btn2,
+	btn3,
+	btn4,
+	btn5,
+	btn6,
+	btn7,
+	/* PWM - Fan */
+	cpufan_2p,		/* 0x20 */
+	cpufan_4p,
+	sysfan1_2p,
+	sysfan1_4p,
+	sysfan2_2p,
+	sysfan2_4p,
+	/* PWM - Brightness Control */
+	pwmbrightness,
+	/* PWM - System Speaker */
+	pwmbeep,
+	/* SMBus */
+	smboem0,
+	smboem1,
+	smboem2,
+	smbeeprom,
+	smbthermal0,
+	smbthermal1,
+	smbsecurityeep,
+	i2coem,
+	/* DAC - Speaker */
+	dacspeaker,		/* 0x30 */
+	/* SMBus */
+	smbeep2k = 0x38,
+	oemeep,
+	oemeep2k,
+	peci,
+	smboem3,
+	smblink,
+	smbslv,
+	/* GPIO - LED */
+	powerled = 0x40,	/* 0x40 */
+	batledg,
+	oemled0,
+	oemled1,
+	oemled2,
+	batledr,
+	/* SMBus - Smart Battery */
+	smartbat1 = 0x48,
+	smartbat2,
+	/* ADC */
+	adcmosbat = 0x50,	/* 0x50 */
+	adcmosbatx2,
+	adcmosbatx10,
+	adcbat,
+	adcbatx2,
+	adcbatx10,
+	adc5vs0,
+	adc5vs0x2,
+	adc5vs0x10,
+	adv5vs5,
+	adv5vs5x2,
+	adv5vs5x10,
+	adc33vs0,
+	adc33vs0x2,
+	adc33vs0x10,
+	adc33vs5,
+	adc33vs5x2,		/* 0x60 */
+	adc33vs5x10,
+	adv12vs0,
+	adv12vs0x2,
+	adv12vs0x10,
+	adcvcorea,
+	adcvcoreax2,
+	adcvcoreax10,
+	adcvcoreb,
+	adcvcorebx2,
+	adcvcorebx10,
+	adcdc,
+	adcdcx2,
+	adcdcx10,
+	adcdcstby,
+	adcdcstbyx2,
+	adcdcstbyx10,		/* 0x70 */
+	adcdcother,
+	adcdcotherx2,
+	adcdcotherx10,
+	adccurrent,
+	/* IRQ - Watchdog */
+	wdirq = 0x78,
+	/* GPIO - Watchdog */
+	wdnmi,
+	/* Tacho - Fan */
+	tacho0 = 0x80,		/* 0x80 */
+	tacho1,
+	tacho2,
+	/* PWM - Brightness Control */
+	pwmbrightness2 = 0x88,
+	/* GPIO - Backlight Control */
+	brionoff1,
+	brionoff2,
+};
+
+#endif /* __IMANAGER2_EC_H__ */
-- 
1.9.1

