Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbaKQPbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 10:31:35 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:57052 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbaKQPap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 10:30:45 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>,
        Olof Johansson <olof@lixom.net>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 2/3] mfd: cros_ec: Create sysfs attributes for the ChromeOS EC.
Date: Mon, 17 Nov 2014 16:30:12 +0100
Message-Id: <1416238213-15263-3-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416238213-15263-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1416238213-15263-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bill Richardson <wfrichar@chromium.org>

This adds the first few sysfs attributes for the Chrome OS EC. These
controls are made available under /sys/devices/virtual/chromeos/cros_ec

    flashinfo   - display current flash info
    reboot      - tell the EC to reboot in various ways
    version     - information about the EC software and hardware

Future changes will build on this to add additional controls.

>From a root shell, you should be able to do things like this:

    cd /sys/devices/virtual/chromeos/cros_ec
    cat flashinfo
    cat version
    echo rw > reboot
    cat version
    echo ro > reboot
    cat version
    echo rw > reboot
    cat version
    echo cold > reboot

That last command will reboot the AP too.

Signed-off-by: Bill Richardson <wfrichar@chromium.org>
Reviewed-by: Olof Johansson <olofj@chromium.org>
Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/mfd/Makefile        |   3 +-
 drivers/mfd/cros_ec_dev.c   |  10 +-
 drivers/mfd/cros_ec_dev.h   |  26 +++++
 drivers/mfd/cros_ec_sysfs.c | 271 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 307 insertions(+), 3 deletions(-)
 create mode 100644 drivers/mfd/cros_ec_dev.h
 create mode 100644 drivers/mfd/cros_ec_sysfs.c

diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 5104a25..eb96986 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -12,7 +12,8 @@ obj-$(CONFIG_MFD_BCM590XX)	+= bcm590xx.o
 obj-$(CONFIG_MFD_CROS_EC)	+= cros_ec.o
 obj-$(CONFIG_MFD_CROS_EC_I2C)	+= cros_ec_i2c.o
 obj-$(CONFIG_MFD_CROS_EC_SPI)	+= cros_ec_spi.o
-obj-$(CONFIG_MFD_CROS_EC_DEV)	+= cros_ec_dev.o
+cros_ec_devs-objs		:= cros_ec_dev.o cros_ec_sysfs.o
+obj-$(CONFIG_MFD_CROS_EC_DEV)	+= cros_ec_devs.o
 
 rtsx_pci-objs			:= rtsx_pcr.o rtsx_gops.o rts5209.o rts5229.o rtl8411.o rts5227.o rts5249.o
 obj-$(CONFIG_MFD_RTSX_PCI)	+= rtsx_pci.o
diff --git a/drivers/mfd/cros_ec_dev.c b/drivers/mfd/cros_ec_dev.c
index c18eb40..1db60dd 100644
--- a/drivers/mfd/cros_ec_dev.c
+++ b/drivers/mfd/cros_ec_dev.c
@@ -32,6 +32,8 @@
 #include <linux/types.h>
 #include <linux/uaccess.h>
 
+#include "cros_ec_dev.h"
+
 /* Device variables */
 #define CROS_CLASS_NAME "chromeos"
 static struct cros_ec_device *ec;
@@ -311,15 +313,18 @@ static int ec_device_probe(struct platform_device *pdev)
 		goto failed_chrdevreg;
 	}
 
-	/* Instantiate it */
+	/* Instantiate it (and remember the EC) */
 	ec->vdev = device_create(cros_class, NULL, MKDEV(ec_major, 0),
-				 NULL, CROS_EC_DEV_NAME);
+				 ec, CROS_EC_DEV_NAME);
 	if (IS_ERR(ec->vdev)) {
 		pr_err("failed to create device\n");
 		retval = PTR_ERR(ec->vdev);
 		goto failed_devreg;
 	}
 
+	/* Initialize extra interfaces */
+	ec_dev_sysfs_init(ec);
+
 	return 0;
 
 failed_devreg:
@@ -332,6 +337,7 @@ failed_class:
 
 static int ec_device_remove(struct platform_device *pdev)
 {
+	ec_dev_sysfs_remove(ec);
 	device_destroy(cros_class, MKDEV(ec_major, 0));
 	unregister_chrdev(ec_major, CROS_EC_DEV_NAME);
 	class_destroy(cros_class);
diff --git a/drivers/mfd/cros_ec_dev.h b/drivers/mfd/cros_ec_dev.h
new file mode 100644
index 0000000..0bb833e
--- /dev/null
+++ b/drivers/mfd/cros_ec_dev.h
@@ -0,0 +1,26 @@
+/*
+ * Copyright (C) 2014 Google, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef _DRV_CROS_EC_DEV_H_
+#define _DRV_CROS_EC_DEV_H_
+
+struct cros_ec_device;
+
+void ec_dev_sysfs_init(struct cros_ec_device *);
+void ec_dev_sysfs_remove(struct cros_ec_device *);
+
+#endif	/* _DRV_CROS_EC_DEV_H_ */
diff --git a/drivers/mfd/cros_ec_sysfs.c b/drivers/mfd/cros_ec_sysfs.c
new file mode 100644
index 0000000..7359c9f
--- /dev/null
+++ b/drivers/mfd/cros_ec_sysfs.c
@@ -0,0 +1,271 @@
+/*
+ * cros_ec_sysfs - expose the Chrome OS EC through sysfs
+ *
+ * Copyright (C) 2014 Google, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#define pr_fmt(fmt) "cros_ec_sysfs: " fmt
+
+#include <linux/ctype.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/fs.h>
+#include <linux/kobject.h>
+#include <linux/mfd/cros_ec.h>
+#include <linux/mfd/cros_ec_commands.h>
+#include <linux/mfd/cros_ec_dev.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/printk.h>
+#include <linux/stat.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+
+#include "cros_ec_dev.h"
+
+/* Accessor functions */
+
+static ssize_t show_ec_reboot(struct device *dev,
+			      struct device_attribute *attr, char *buf)
+{
+	int count = 0;
+
+	count += scnprintf(buf + count, PAGE_SIZE - count,
+			   "ro|rw|cancel|cold|disable-jump|hibernate");
+	count += scnprintf(buf + count, PAGE_SIZE - count,
+			   " [at-shutdown]\n");
+	return count;
+}
+
+static ssize_t store_ec_reboot(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t count)
+{
+	static const struct {
+		const char * const str;
+		uint8_t cmd;
+		uint8_t flags;
+	} words[] = {
+		{"cancel",       EC_REBOOT_CANCEL, 0},
+		{"ro",           EC_REBOOT_JUMP_RO, 0},
+		{"rw",           EC_REBOOT_JUMP_RW, 0},
+		{"cold",         EC_REBOOT_COLD, 0},
+		{"disable-jump", EC_REBOOT_DISABLE_JUMP, 0},
+		{"hibernate",    EC_REBOOT_HIBERNATE, 0},
+		{"at-shutdown",  -1, EC_REBOOT_FLAG_ON_AP_SHUTDOWN},
+	};
+	struct ec_params_reboot_ec param;
+	struct cros_ec_command msg = { 0 };
+	int got_cmd = 0, offset = 0;
+	int i;
+	int ret;
+	struct cros_ec_device *ec = dev_get_drvdata(dev);
+
+	param.flags = 0;
+	while (1) {
+		/* Find word to start scanning */
+		while (buf[offset] && isspace(buf[offset]))
+			offset++;
+		if (!buf[offset])
+			break;
+
+		for (i = 0; i < ARRAY_SIZE(words); i++) {
+			if (!strncasecmp(words[i].str, buf+offset,
+					 strlen(words[i].str))) {
+				if (words[i].flags) {
+					param.flags |= words[i].flags;
+				} else {
+					param.cmd = words[i].cmd;
+					got_cmd = 1;
+				}
+				break;
+			}
+		}
+
+		/* On to the next word, if any */
+		while (buf[offset] && !isspace(buf[offset]))
+			offset++;
+	}
+
+	if (!got_cmd)
+		return -EINVAL;
+
+	msg.command = EC_CMD_REBOOT_EC;
+	msg.outdata = (uint8_t *)&param;
+	msg.outsize = sizeof(param);
+	ret = cros_ec_cmd_xfer(ec, &msg);
+	if (ret < 0)
+		return ret;
+	if (msg.result != EC_RES_SUCCESS) {
+		dev_dbg(ec->dev, "EC result %d\n", msg.result);
+		return -EINVAL;
+	}
+
+	return count;
+}
+
+static ssize_t show_ec_version(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	static const char * const image_names[] = {"unknown", "RO", "RW"};
+	struct ec_response_get_version r_ver;
+	struct ec_response_get_chip_info r_chip;
+	struct ec_response_board_version r_board;
+	struct cros_ec_command msg = { 0 };
+	char r_build_string[EC_HOST_PARAM_SIZE];
+	int ret;
+	int count = 0;
+	struct cros_ec_device *ec = dev_get_drvdata(dev);
+
+	/* Get versions. RW may change. */
+	msg.command = EC_CMD_GET_VERSION;
+	msg.indata = (uint8_t *)&r_ver;
+	msg.insize = sizeof(r_ver);
+	ret = cros_ec_cmd_xfer(ec, &msg);
+	if (ret < 0)
+		return ret;
+	if (msg.result != EC_RES_SUCCESS)
+		return scnprintf(buf, PAGE_SIZE,
+				 "ERROR: EC returned %d\n", msg.result);
+
+	/* Strings should be null-terminated, but let's be sure. */
+	r_ver.version_string_ro[sizeof(r_ver.version_string_ro) - 1] = '\0';
+	r_ver.version_string_rw[sizeof(r_ver.version_string_rw) - 1] = '\0';
+	count += scnprintf(buf + count, PAGE_SIZE - count,
+			   "RO version:    %s\n", r_ver.version_string_ro);
+	count += scnprintf(buf + count, PAGE_SIZE - count,
+			   "RW version:    %s\n", r_ver.version_string_rw);
+	count += scnprintf(buf + count, PAGE_SIZE - count,
+			   "Firmware copy: %s\n",
+			   (r_ver.current_image < ARRAY_SIZE(image_names) ?
+			    image_names[r_ver.current_image] : "?"));
+
+	/* Get build info. */
+	msg.command = EC_CMD_GET_BUILD_INFO;
+	msg.indata = (uint8_t *)r_build_string;
+	msg.insize = sizeof(r_build_string);
+	ret = cros_ec_cmd_xfer(ec, &msg);
+	if (ret < 0)
+		count += scnprintf(buf + count, PAGE_SIZE - count,
+				   "Build info:    XFER ERROR %d\n", ret);
+	else if (msg.result != EC_RES_SUCCESS)
+		count += scnprintf(buf + count, PAGE_SIZE - count,
+				   "Build info:    EC error %d\n", msg.result);
+	else {
+		r_build_string[sizeof(r_build_string) - 1] = '\0';
+		count += scnprintf(buf + count, PAGE_SIZE - count,
+				   "Build info:    %s\n", r_build_string);
+	}
+
+	/* Get chip info. */
+	msg.command = EC_CMD_GET_CHIP_INFO;
+	msg.indata = (uint8_t *)&r_chip;
+	msg.insize = sizeof(r_chip);
+	ret = cros_ec_cmd_xfer(ec, &msg);
+	if (ret < 0)
+		count += scnprintf(buf + count, PAGE_SIZE - count,
+				   "Chip info:     XFER ERROR %d\n", ret);
+	else if (msg.result != EC_RES_SUCCESS)
+		count += scnprintf(buf + count, PAGE_SIZE - count,
+				   "Chip info:     EC error %d\n", msg.result);
+	else {
+		r_chip.vendor[sizeof(r_chip.vendor) - 1] = '\0';
+		r_chip.name[sizeof(r_chip.name) - 1] = '\0';
+		r_chip.revision[sizeof(r_chip.revision) - 1] = '\0';
+		count += scnprintf(buf + count, PAGE_SIZE - count,
+				   "Chip vendor:   %s\n", r_chip.vendor);
+		count += scnprintf(buf + count, PAGE_SIZE - count,
+				   "Chip name:     %s\n", r_chip.name);
+		count += scnprintf(buf + count, PAGE_SIZE - count,
+				   "Chip revision: %s\n", r_chip.revision);
+	}
+
+	/* Get board version */
+	msg.command = EC_CMD_GET_BOARD_VERSION;
+	msg.indata = (uint8_t *)&r_board;
+	msg.insize = sizeof(r_board);
+	ret = cros_ec_cmd_xfer(ec, &msg);
+	if (ret < 0)
+		count += scnprintf(buf + count, PAGE_SIZE - count,
+				   "Board version: XFER ERROR %d\n", ret);
+	else if (msg.result != EC_RES_SUCCESS)
+		count += scnprintf(buf + count, PAGE_SIZE - count,
+				   "Board version: EC error %d\n", msg.result);
+	else {
+		count += scnprintf(buf + count, PAGE_SIZE - count,
+				   "Board version: %d\n",
+				   r_board.board_version);
+	}
+
+	return count;
+}
+
+static ssize_t show_ec_flashinfo(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct ec_response_flash_info resp;
+	struct cros_ec_command msg = { 0 };
+	int ret;
+	struct cros_ec_device *ec = dev_get_drvdata(dev);
+
+	/* The flash info shouldn't ever change, but ask each time anyway. */
+	msg.command = EC_CMD_FLASH_INFO;
+	msg.indata = (uint8_t *)&resp;
+	msg.insize = sizeof(resp);
+	ret = cros_ec_cmd_xfer(ec, &msg);
+	if (ret < 0)
+		return ret;
+	if (msg.result != EC_RES_SUCCESS)
+		return scnprintf(buf, PAGE_SIZE,
+				 "ERROR: EC returned %d\n", msg.result);
+
+	return scnprintf(buf, PAGE_SIZE,
+			 "FlashSize %d\nWriteSize %d\n"
+			 "EraseSize %d\nProtectSize %d\n",
+			 resp.flash_size, resp.write_block_size,
+			 resp.erase_block_size, resp.protect_block_size);
+}
+
+/* Module initialization */
+
+static DEVICE_ATTR(reboot, S_IWUSR | S_IRUGO, show_ec_reboot, store_ec_reboot);
+static DEVICE_ATTR(version, S_IRUGO, show_ec_version, NULL);
+static DEVICE_ATTR(flashinfo, S_IRUGO, show_ec_flashinfo, NULL);
+
+static struct attribute *__ec_attrs[] = {
+	&dev_attr_reboot.attr,
+	&dev_attr_version.attr,
+	&dev_attr_flashinfo.attr,
+	NULL,
+};
+
+static struct attribute_group ec_attr_group = {
+	.attrs = __ec_attrs,
+};
+
+void ec_dev_sysfs_init(struct cros_ec_device *ec)
+{
+	int error;
+
+	error = sysfs_create_group(&ec->vdev->kobj, &ec_attr_group);
+	if (error)
+		pr_warn("failed to create group: %d\n", error);
+}
+
+void ec_dev_sysfs_remove(struct cros_ec_device *ec)
+{
+	sysfs_remove_group(&ec->vdev->kobj, &ec_attr_group);
+}
-- 
2.1.0

