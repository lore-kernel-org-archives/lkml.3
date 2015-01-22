Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbbAVTRl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 14:17:41 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:36188 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083AbbAVTQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 14:16:46 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>, Jonathan Corbet <corbet@lwn.net>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v3 4/7] platform/chrome: Add Chrome OS EC userspace device interface
Date: Thu, 22 Jan 2015 20:16:23 +0100
Message-Id: <1421954186-29764-5-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421954186-29764-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1421954186-29764-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bill Richardson <wfrichar@chromium.org>

This patch adds a device interface to access the
Chrome OS Embedded Controller from user-space.

Signed-off-by: Bill Richardson <wfrichar@chromium.org>
Reviewed-by: Simon Glass <sjg@google.com>
Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Reviewed-by: Gwendal Grignou <gwendal@chromium.org>
---

Changes since v2:
 - Rename the devname to "cros-ec-ctl". Suggested by Lee Jones.
 - Added Gwendal Grignou Reviewed-by tag.

Changes since v1: None, new patch.
---
 Documentation/ioctl/ioctl-number.txt  |   1 +
 drivers/platform/chrome/Kconfig       |  14 +-
 drivers/platform/chrome/Makefile      |   1 +
 drivers/platform/chrome/cros_ec_dev.c | 268 ++++++++++++++++++++++++++++++++++
 drivers/platform/chrome/cros_ec_dev.h |  47 ++++++
 5 files changed, 328 insertions(+), 3 deletions(-)
 create mode 100644 drivers/platform/chrome/cros_ec_dev.c
 create mode 100644 drivers/platform/chrome/cros_ec_dev.h

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index 8136e1fd30fd..51f4221657bf 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -321,6 +321,7 @@ Code  Seq#(hex)	Include File		Comments
 0xDB	00-0F	drivers/char/mwave/mwavepub.h
 0xDD	00-3F	ZFCP device driver	see drivers/s390/scsi/
 					<mailto:aherrman@de.ibm.com>
+0xEC	00-01	drivers/platform/chrome/cros_ec_dev.h	ChromeOS EC driver
 0xF3	00-3F	drivers/usb/misc/sisusbvga/sisusb.h	sisfb (in development)
 					<mailto:thomas@winischhofer.net>
 0xF4	00-1F	video/mbxfb.h		mbxfb
diff --git a/drivers/platform/chrome/Kconfig b/drivers/platform/chrome/Kconfig
index 440ed776efd4..75dc514915ff 100644
--- a/drivers/platform/chrome/Kconfig
+++ b/drivers/platform/chrome/Kconfig
@@ -4,7 +4,7 @@
 
 menuconfig CHROME_PLATFORMS
 	bool "Platform support for Chrome hardware"
-	depends on X86
+	depends on X86 || ARM
 	---help---
 	  Say Y here to get to see options for platform support for
 	  various Chromebooks and Chromeboxes. This option alone does
@@ -16,8 +16,7 @@ if CHROME_PLATFORMS
 
 config CHROMEOS_LAPTOP
 	tristate "Chrome OS Laptop"
-	depends on I2C
-	depends on DMI
+	depends on I2C && DMI && X86
 	---help---
 	  This driver instantiates i2c and smbus devices such as
 	  light sensors and touchpads.
@@ -27,6 +26,7 @@ config CHROMEOS_LAPTOP
 
 config CHROMEOS_PSTORE
 	tristate "Chrome OS pstore support"
+	depends on X86
 	---help---
 	  This module instantiates the persistent storage on x86 ChromeOS
 	  devices. It can be used to store away console logs and crash
@@ -38,5 +38,13 @@ config CHROMEOS_PSTORE
 	  If you have a supported Chromebook, choose Y or M here.
 	  The module will be called chromeos_pstore.
 
+config CROS_EC_CHARDEV
+        tristate "Chrome OS Embedded Controller userspace device interface"
+        depends on MFD_CROS_EC
+        ---help---
+          This driver adds support to talk with the ChromeOS EC from userspace.
+
+          If you have a supported Chromebook, choose Y or M here.
+          The module will be called cros_ec_dev.
 
 endif # CHROMEOS_PLATFORMS
diff --git a/drivers/platform/chrome/Makefile b/drivers/platform/chrome/Makefile
index 2b860ca7450f..10f1361a97b4 100644
--- a/drivers/platform/chrome/Makefile
+++ b/drivers/platform/chrome/Makefile
@@ -1,3 +1,4 @@
 
 obj-$(CONFIG_CHROMEOS_LAPTOP)	+= chromeos_laptop.o
 obj-$(CONFIG_CHROMEOS_PSTORE)	+= chromeos_pstore.o
+obj-$(CONFIG_CROS_EC_CHARDEV)	+= cros_ec_dev.o
diff --git a/drivers/platform/chrome/cros_ec_dev.c b/drivers/platform/chrome/cros_ec_dev.c
new file mode 100644
index 000000000000..94c1442d5104
--- /dev/null
+++ b/drivers/platform/chrome/cros_ec_dev.c
@@ -0,0 +1,268 @@
+/*
+ * cros_ec_dev - expose the Chrome OS Embedded Controller to user-space
+ *
+ * Copyright (C) 2015 Google, Inc.
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
+#include <linux/fs.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/uaccess.h>
+
+#include "cros_ec_dev.h"
+
+/* Device variables */
+#define CROS_MAX_DEV 128
+static struct class *cros_class;
+static int ec_major;
+
+/* Basic communication */
+static int ec_get_version(struct cros_ec_device *ec, char *str, int maxlen)
+{
+	struct ec_response_get_version *resp;
+	static const char * const current_image_name[] = {
+		"unknown", "read-only", "read-write", "invalid",
+	};
+	struct cros_ec_command msg = {
+		.version = 0,
+		.command = EC_CMD_GET_VERSION,
+		.outdata = { 0 },
+		.outsize = 0,
+		.indata = { 0 },
+		.insize = sizeof(*resp),
+	};
+	int ret;
+
+	ret = cros_ec_cmd_xfer(ec, &msg);
+	if (ret < 0)
+		return ret;
+
+	if (msg.result != EC_RES_SUCCESS) {
+		snprintf(str, maxlen,
+			 "%s\nUnknown EC version: EC returned %d\n",
+			 CROS_EC_DEV_VERSION, msg.result);
+		return 0;
+	}
+
+	resp = (struct ec_response_get_version *)msg.indata;
+	if (resp->current_image >= ARRAY_SIZE(current_image_name))
+		resp->current_image = 3; /* invalid */
+
+	snprintf(str, maxlen, "%s\n%s\n%s\n\%s\n", CROS_EC_DEV_VERSION,
+		 resp->version_string_ro, resp->version_string_rw,
+		 current_image_name[resp->current_image]);
+
+	return 0;
+}
+
+/* Device file ops */
+static int ec_device_open(struct inode *inode, struct file *filp)
+{
+	filp->private_data = container_of(inode->i_cdev,
+					  struct cros_ec_device, cdev);
+	return 0;
+}
+
+static int ec_device_release(struct inode *inode, struct file *filp)
+{
+	return 0;
+}
+
+static ssize_t ec_device_read(struct file *filp, char __user *buffer,
+			      size_t length, loff_t *offset)
+{
+	struct cros_ec_device *ec = filp->private_data;
+	char msg[sizeof(struct ec_response_get_version) +
+		 sizeof(CROS_EC_DEV_VERSION)];
+	size_t count;
+	int ret;
+
+	if (*offset != 0)
+		return 0;
+
+	ret = ec_get_version(ec, msg, sizeof(msg));
+	if (ret)
+		return ret;
+
+	count = min(length, strlen(msg));
+
+	if (copy_to_user(buffer, msg, count))
+		return -EFAULT;
+
+	*offset = count;
+	return count;
+}
+
+/* Ioctls */
+static long ec_device_ioctl_xcmd(struct cros_ec_device *ec, void __user *arg)
+{
+	long ret;
+	struct cros_ec_command s_cmd = { };
+
+	if (copy_from_user(&s_cmd, arg, sizeof(s_cmd)))
+		return -EFAULT;
+
+	ret = cros_ec_cmd_xfer(ec, &s_cmd);
+	/* Only copy data to userland if data was received. */
+	if (ret < 0)
+		return ret;
+
+	if (copy_to_user(arg, &s_cmd, sizeof(s_cmd)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static long ec_device_ioctl_readmem(struct cros_ec_device *ec, void __user *arg)
+{
+	struct cros_ec_readmem s_mem = { };
+	long num;
+
+	/* Not every platform supports direct reads */
+	if (!ec->cmd_readmem)
+		return -ENOTTY;
+
+	if (copy_from_user(&s_mem, arg, sizeof(s_mem)))
+		return -EFAULT;
+
+	num = ec->cmd_readmem(ec, s_mem.offset, s_mem.bytes, s_mem.buffer);
+	if (num <= 0)
+		return num;
+
+	if (copy_to_user((void __user *)arg, &s_mem, sizeof(s_mem)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static long ec_device_ioctl(struct file *filp, unsigned int cmd,
+			    unsigned long arg)
+{
+	struct cros_ec_device *ec = filp->private_data;
+
+	if (_IOC_TYPE(cmd) != CROS_EC_DEV_IOC)
+		return -ENOTTY;
+
+	switch (cmd) {
+	case CROS_EC_DEV_IOCXCMD:
+		return ec_device_ioctl_xcmd(ec, (void __user *)arg);
+	case CROS_EC_DEV_IOCRDMEM:
+		return ec_device_ioctl_readmem(ec, (void __user *)arg);
+	}
+
+	return -ENOTTY;
+}
+
+/* Module initialization */
+static const struct file_operations fops = {
+	.open = ec_device_open,
+	.release = ec_device_release,
+	.read = ec_device_read,
+	.unlocked_ioctl = ec_device_ioctl,
+};
+
+static int ec_device_probe(struct platform_device *pdev)
+{
+	struct cros_ec_device *ec = dev_get_drvdata(pdev->dev.parent);
+	int retval = -ENOTTY;
+	dev_t devno = MKDEV(ec_major, 0);
+
+	/* Instantiate it (and remember the EC) */
+	cdev_init(&ec->cdev, &fops);
+
+	retval = cdev_add(&ec->cdev, devno, 1);
+	if (retval) {
+		dev_err(&pdev->dev, ": failed to add character device\n");
+		return retval;
+	}
+
+	ec->vdev = device_create(cros_class, NULL, devno, ec,
+				 CROS_EC_DEV_NAME);
+	if (IS_ERR(ec->vdev)) {
+		retval = PTR_ERR(ec->vdev);
+		dev_err(&pdev->dev, ": failed to create device\n");
+		cdev_del(&ec->cdev);
+		return retval;
+	}
+
+	return 0;
+}
+
+static int ec_device_remove(struct platform_device *pdev)
+{
+	struct cros_ec_device *ec = dev_get_drvdata(pdev->dev.parent);
+
+	device_destroy(cros_class, MKDEV(ec_major, 0));
+	cdev_del(&ec->cdev);
+	return 0;
+}
+
+static struct platform_driver cros_ec_dev_driver = {
+	.driver = {
+		.name = "cros-ec-ctl",
+	},
+	.probe = ec_device_probe,
+	.remove = ec_device_remove,
+};
+
+static int __init cros_ec_dev_init(void)
+{
+	int ret;
+	dev_t dev = 0;
+
+	cros_class = class_create(THIS_MODULE, "chromeos");
+	if (IS_ERR(cros_class)) {
+		pr_err(CROS_EC_DEV_NAME ": failed to register device class\n");
+		return PTR_ERR(cros_class);
+	}
+
+	/* Get a range of minor numbers (starting with 0) to work with */
+	ret = alloc_chrdev_region(&dev, 0, CROS_MAX_DEV, CROS_EC_DEV_NAME);
+	if (ret < 0) {
+		pr_err(CROS_EC_DEV_NAME ": alloc_chrdev_region() failed\n");
+		goto failed_chrdevreg;
+	}
+	ec_major = MAJOR(dev);
+
+	/* Register the driver */
+	ret = platform_driver_register(&cros_ec_dev_driver);
+	if (ret < 0) {
+		pr_warn(CROS_EC_DEV_NAME ": can't register driver: %d\n", ret);
+		goto failed_devreg;
+	}
+	return 0;
+
+failed_devreg:
+	unregister_chrdev_region(MKDEV(ec_major, 0), CROS_MAX_DEV);
+failed_chrdevreg:
+	class_destroy(cros_class);
+	return ret;
+}
+
+static void __exit cros_ec_dev_exit(void)
+{
+	platform_driver_unregister(&cros_ec_dev_driver);
+	unregister_chrdev(ec_major, CROS_EC_DEV_NAME);
+	class_destroy(cros_class);
+}
+
+module_init(cros_ec_dev_init);
+module_exit(cros_ec_dev_exit);
+
+MODULE_AUTHOR("Bill Richardson <wfrichar@chromium.org>");
+MODULE_DESCRIPTION("Userspace interface to the Chrome OS Embedded Controller");
+MODULE_VERSION("1.0");
+MODULE_LICENSE("GPL");
diff --git a/drivers/platform/chrome/cros_ec_dev.h b/drivers/platform/chrome/cros_ec_dev.h
new file mode 100644
index 000000000000..15c54c4c5531
--- /dev/null
+++ b/drivers/platform/chrome/cros_ec_dev.h
@@ -0,0 +1,47 @@
+/*
+ * cros_ec_dev - expose the Chrome OS Embedded Controller to userspace
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
+#ifndef _CROS_EC_DEV_H_
+#define _CROS_EC_DEV_H_
+
+#include <linux/ioctl.h>
+#include <linux/types.h>
+#include <linux/mfd/cros_ec.h>
+
+#define CROS_EC_DEV_NAME "cros_ec"
+#define CROS_EC_DEV_VERSION "1.0.0"
+
+/*
+ * @offset: within EC_LPC_ADDR_MEMMAP region
+ * @bytes: number of bytes to read. zero means "read a string" (including '\0')
+ *         (at most only EC_MEMMAP_SIZE bytes can be read)
+ * @buffer: where to store the result
+ * ioctl returns the number of bytes read, negative on error
+ */
+struct cros_ec_readmem {
+	uint32_t offset;
+	uint32_t bytes;
+	uint8_t buffer[EC_MEMMAP_SIZE];
+};
+
+#define CROS_EC_DEV_IOC       0xEC
+#define CROS_EC_DEV_IOCXCMD   _IOWR(CROS_EC_DEV_IOC, 0, struct cros_ec_command)
+#define CROS_EC_DEV_IOCRDMEM  _IOWR(CROS_EC_DEV_IOC, 1, struct cros_ec_readmem)
+
+#endif /* _CROS_EC_DEV_H_ */
-- 
2.1.3

