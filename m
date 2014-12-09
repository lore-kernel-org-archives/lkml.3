Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbaLIL6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 06:58:54 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:58048 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756748AbaLIL6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 06:58:32 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Lee Jones <lee.jones@linaro.org>, Olof Johansson <olof@lixom.net>
Cc: Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v2 5/6] platform/chrome: Create sysfs attributes for the ChromeOS EC.
Date: Tue,  9 Dec 2014 12:57:47 +0100
Message-Id: <1418126268-12532-6-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1418126268-12532-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1418126268-12532-1-git-send-email-javier.martinez@collabora.co.uk>
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

Changes since v1:
 - Moved from drivers/mfd to drivers/platform/chrome. Suggested by Lee Jones.
 - Modify to use the fixed-size arrays for cros_ec_command in and out buffers.

 drivers/platform/chrome/Makefile        |   3 +-
 drivers/platform/chrome/cros_ec_dev.c   |   4 +
 drivers/platform/chrome/cros_ec_dev.h   |   3 +
 drivers/platform/chrome/cros_ec_sysfs.c | 271 ++++++++++++++++++++++++++++++++
 4 files changed, 280 insertions(+), 1 deletion(-)
 create mode 100644 drivers/platform/chrome/cros_ec_sysfs.c

diff --git a/drivers/platform/chrome/Makefile b/drivers/platform/chrome/Makefile
index 10f1361..3e7980b 100644
--- a/drivers/platform/chrome/Makefile
+++ b/drivers/platform/chrome/Makefile
@@ -1,4 +1,5 @@
 
 obj-$(CONFIG_CHROMEOS_LAPTOP)	+= chromeos_laptop.o
 obj-$(CONFIG_CHROMEOS_PSTORE)	+= chromeos_pstore.o
-obj-$(CONFIG_CROS_EC_CHARDEV)	+= cros_ec_dev.o
+cros_ec_devs-objs		:= cros_ec_dev.o cros_ec_sysfs.o
+obj-$(CONFIG_CROS_EC_CHARDEV)	+= cros_ec_devs.o
diff --git a/drivers/platform/chrome/cros_ec_dev.c b/drivers/platform/chrome/cros_ec_dev.c
index 04cc8eb..557f2e8 100644
--- a/drivers/platform/chrome/cros_ec_dev.c
+++ b/drivers/platform/chrome/cros_ec_dev.c
@@ -198,6 +198,9 @@ static int ec_device_probe(struct platform_device *pdev)
 		return retval;
 	}
 
+	/* Initialize extra interfaces */
+	ec_dev_sysfs_init(ec);
+
 	return 0;
 }
 
@@ -205,6 +208,7 @@ static int ec_device_remove(struct platform_device *pdev)
 {
 	struct cros_ec_device *ec = dev_get_drvdata(pdev->dev.parent);
 
+	ec_dev_sysfs_remove(ec);
 	device_destroy(cros_class, MKDEV(ec_major, 0));
 	cdev_del(&ec->cdev);
 	return 0;
diff --git a/drivers/platform/chrome/cros_ec_dev.h b/drivers/platform/chrome/cros_ec_dev.h
index 15c54c4..f036132 100644
--- a/drivers/platform/chrome/cros_ec_dev.h
+++ b/drivers/platform/chrome/cros_ec_dev.h
@@ -44,4 +44,7 @@ struct cros_ec_readmem {
 #define CROS_EC_DEV_IOCXCMD   _IOWR(CROS_EC_DEV_IOC, 0, struct cros_ec_command)
 #define CROS_EC_DEV_IOCRDMEM  _IOWR(CROS_EC_DEV_IOC, 1, struct cros_ec_readmem)
 
+void ec_dev_sysfs_init(struct cros_ec_device *);
+void ec_dev_sysfs_remove(struct cros_ec_device *);
+
 #endif /* _CROS_EC_DEV_H_ */
diff --git a/drivers/platform/chrome/cros_ec_sysfs.c b/drivers/platform/chrome/cros_ec_sysfs.c
new file mode 100644
index 0000000..fb62ab6
--- /dev/null
+++ b/drivers/platform/chrome/cros_ec_sysfs.c
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
+	struct cros_ec_command msg = { 0 };
+	struct ec_params_reboot_ec *param =
+		(struct ec_params_reboot_ec *)msg.outdata;
+	int got_cmd = 0, offset = 0;
+	int i;
+	int ret;
+	struct cros_ec_device *ec = dev_get_drvdata(dev);
+
+	param->flags = 0;
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
+					param->flags |= words[i].flags;
+				} else {
+					param->cmd = words[i].cmd;
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
+	struct ec_response_get_version *r_ver;
+	struct ec_response_get_chip_info *r_chip;
+	struct ec_response_board_version *r_board;
+	struct cros_ec_command msg = { 0 };
+	int ret;
+	int count = 0;
+	struct cros_ec_device *ec = dev_get_drvdata(dev);
+
+	/* Get versions. RW may change. */
+	msg.command = EC_CMD_GET_VERSION;
+	msg.insize = sizeof(*r_ver);
+	ret = cros_ec_cmd_xfer(ec, &msg);
+	if (ret < 0)
+		return ret;
+	if (msg.result != EC_RES_SUCCESS)
+		return scnprintf(buf, PAGE_SIZE,
+				 "ERROR: EC returned %d\n", msg.result);
+
+	r_ver = (struct ec_response_get_version *)msg.indata;
+	/* Strings should be null-terminated, but let's be sure. */
+	r_ver->version_string_ro[sizeof(r_ver->version_string_ro) - 1] = '\0';
+	r_ver->version_string_rw[sizeof(r_ver->version_string_rw) - 1] = '\0';
+	count += scnprintf(buf + count, PAGE_SIZE - count,
+			   "RO version:    %s\n", r_ver->version_string_ro);
+	count += scnprintf(buf + count, PAGE_SIZE - count,
+			   "RW version:    %s\n", r_ver->version_string_rw);
+	count += scnprintf(buf + count, PAGE_SIZE - count,
+			   "Firmware copy: %s\n",
+			   (r_ver->current_image < ARRAY_SIZE(image_names) ?
+			    image_names[r_ver->current_image] : "?"));
+
+	/* Get build info. */
+	msg.command = EC_CMD_GET_BUILD_INFO;
+	msg.insize = sizeof(msg.indata);
+	ret = cros_ec_cmd_xfer(ec, &msg);
+	if (ret < 0)
+		count += scnprintf(buf + count, PAGE_SIZE - count,
+				   "Build info:    XFER ERROR %d\n", ret);
+	else if (msg.result != EC_RES_SUCCESS)
+		count += scnprintf(buf + count, PAGE_SIZE - count,
+				   "Build info:    EC error %d\n", msg.result);
+	else {
+		msg.indata[sizeof(msg.indata) - 1] = '\0';
+		count += scnprintf(buf + count, PAGE_SIZE - count,
+				   "Build info:    %s\n", msg.indata);
+	}
+
+	/* Get chip info. */
+	msg.command = EC_CMD_GET_CHIP_INFO;
+	msg.insize = sizeof(*r_chip);
+	ret = cros_ec_cmd_xfer(ec, &msg);
+	if (ret < 0)
+		count += scnprintf(buf + count, PAGE_SIZE - count,
+				   "Chip info:     XFER ERROR %d\n", ret);
+	else if (msg.result != EC_RES_SUCCESS)
+		count += scnprintf(buf + count, PAGE_SIZE - count,
+				   "Chip info:     EC error %d\n", msg.result);
+	else {
+		r_chip = (struct ec_response_get_chip_info *)msg.indata;
+
+		r_chip->vendor[sizeof(r_chip->vendor) - 1] = '\0';
+		r_chip->name[sizeof(r_chip->name) - 1] = '\0';
+		r_chip->revision[sizeof(r_chip->revision) - 1] = '\0';
+		count += scnprintf(buf + count, PAGE_SIZE - count,
+				   "Chip vendor:   %s\n", r_chip->vendor);
+		count += scnprintf(buf + count, PAGE_SIZE - count,
+				   "Chip name:     %s\n", r_chip->name);
+		count += scnprintf(buf + count, PAGE_SIZE - count,
+				   "Chip revision: %s\n", r_chip->revision);
+	}
+
+	/* Get board version */
+	msg.command = EC_CMD_GET_BOARD_VERSION;
+	msg.insize = sizeof(*r_board);
+	ret = cros_ec_cmd_xfer(ec, &msg);
+	if (ret < 0)
+		count += scnprintf(buf + count, PAGE_SIZE - count,
+				   "Board version: XFER ERROR %d\n", ret);
+	else if (msg.result != EC_RES_SUCCESS)
+		count += scnprintf(buf + count, PAGE_SIZE - count,
+				   "Board version: EC error %d\n", msg.result);
+	else {
+		r_board = (struct ec_response_board_version *)msg.indata;
+
+		count += scnprintf(buf + count, PAGE_SIZE - count,
+				   "Board version: %d\n",
+				   r_board->board_version);
+	}
+
+	return count;
+}
+
+static ssize_t show_ec_flashinfo(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct ec_response_flash_info *resp;
+	struct cros_ec_command msg = { 0 };
+	int ret;
+	struct cros_ec_device *ec = dev_get_drvdata(dev);
+
+	/* The flash info shouldn't ever change, but ask each time anyway. */
+	msg.command = EC_CMD_FLASH_INFO;
+	msg.insize = sizeof(*resp);
+	ret = cros_ec_cmd_xfer(ec, &msg);
+	if (ret < 0)
+		return ret;
+	if (msg.result != EC_RES_SUCCESS)
+		return scnprintf(buf, PAGE_SIZE,
+				 "ERROR: EC returned %d\n", msg.result);
+
+	resp = (struct ec_response_flash_info *)msg.indata;
+
+	return scnprintf(buf, PAGE_SIZE,
+			 "FlashSize %d\nWriteSize %d\n"
+			 "EraseSize %d\nProtectSize %d\n",
+			 resp->flash_size, resp->write_block_size,
+			 resp->erase_block_size, resp->protect_block_size);
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

