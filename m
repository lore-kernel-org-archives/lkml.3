Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbaKQPas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 10:30:48 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:57050 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbaKQPan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 10:30:43 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>,
        Olof Johansson <olof@lixom.net>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 1/3] mfd: cros_ec: Add Chrome OS EC userspace device interface
Date: Mon, 17 Nov 2014 16:30:11 +0100
Message-Id: <1416238213-15263-2-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416238213-15263-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1416238213-15263-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bill Richardson <wfrichar@chromium.org>

This patch adds a device interface to access the
ChromeOS Embedded Controller from user-space.

Signed-off-by: Bill Richardson <wfrichar@chromium.org>
Reviewed-on: https://gerrit-int.chromium.org/38364
Reviewed-by: Simon Glass <sjg@google.com>
Tested-by: Simon Glass <sjg@google.com>
Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/mfd/Kconfig             |  12 ++
 drivers/mfd/Makefile            |   1 +
 drivers/mfd/cros_ec.c           |   4 +
 drivers/mfd/cros_ec_dev.c       | 355 ++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/cros_ec.h     |  12 +-
 include/linux/mfd/cros_ec_dev.h |  47 ++++++
 6 files changed, 430 insertions(+), 1 deletion(-)
 create mode 100644 drivers/mfd/cros_ec_dev.c
 create mode 100644 include/linux/mfd/cros_ec_dev.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 72d3808..31420a7 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -115,6 +115,18 @@ config MFD_CROS_EC_SPI
 	  response time cannot be guaranteed, we support ignoring
 	  'pre-amble' bytes before the response actually starts.
 
+config MFD_CROS_EC_DEV
+	tristate "ChromeOS Embedded Controller userspace device interface"
+	depends on MFD_CROS_EC
+
+	help
+	  If you say Y here, you get support for talking to the ChromeOS
+	  EC from userspace. This is separate from the normal kernel
+	  interfaces.
+
+	  To compile this driver as a module, choose M here: the module will be
+	  called cros_ec_dev.
+
 config MFD_ASIC3
 	bool "Compaq ASIC3"
 	depends on GPIOLIB && ARM
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 53467e2..5104a25 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_MFD_BCM590XX)	+= bcm590xx.o
 obj-$(CONFIG_MFD_CROS_EC)	+= cros_ec.o
 obj-$(CONFIG_MFD_CROS_EC_I2C)	+= cros_ec_i2c.o
 obj-$(CONFIG_MFD_CROS_EC_SPI)	+= cros_ec_spi.o
+obj-$(CONFIG_MFD_CROS_EC_DEV)	+= cros_ec_dev.o
 
 rtsx_pci-objs			:= rtsx_pcr.o rtsx_gops.o rts5209.o rts5229.o rtl8411.o rts5227.o rts5249.o
 obj-$(CONFIG_MFD_RTSX_PCI)	+= rtsx_pci.o
diff --git a/drivers/mfd/cros_ec.c b/drivers/mfd/cros_ec.c
index fc0c81e..197b273 100644
--- a/drivers/mfd/cros_ec.c
+++ b/drivers/mfd/cros_ec.c
@@ -119,6 +119,10 @@ static const struct mfd_cell cros_devs[] = {
 		.id = 2,
 		.of_compatible = "google,cros-ec-i2c-tunnel",
 	},
+	{
+		.name = "cros-ec-dev",
+		.id = 3,
+	},
 };
 
 int cros_ec_register(struct cros_ec_device *ec_dev)
diff --git a/drivers/mfd/cros_ec_dev.c b/drivers/mfd/cros_ec_dev.c
new file mode 100644
index 0000000..c18eb40
--- /dev/null
+++ b/drivers/mfd/cros_ec_dev.c
@@ -0,0 +1,355 @@
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
+#define pr_fmt(fmt) "cros_ec_dev: " fmt
+
+#include <linux/compat.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/fs.h>
+#include <linux/mfd/cros_ec.h>
+#include <linux/mfd/cros_ec_commands.h>
+#include <linux/mfd/cros_ec_dev.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/printk.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+
+/* Device variables */
+#define CROS_CLASS_NAME "chromeos"
+static struct cros_ec_device *ec;
+static struct class *cros_class;
+static int ec_major;
+
+
+/* Basic communication */
+static int ec_get_version(struct cros_ec_device *ec, char *str, int maxlen)
+{
+	struct ec_response_get_version resp;
+	static const char * const current_image_name[] = {
+		"unknown", "read-only", "read-write", "invalid",
+	};
+	struct cros_ec_command msg = {
+		.version = 0,
+		.command = EC_CMD_GET_VERSION,
+		.outdata = NULL,
+		.outsize = 0,
+		.indata = (uint8_t *)&resp,
+		.insize = sizeof(resp),
+	};
+	int ret;
+
+	ret = cros_ec_cmd_xfer(ec, &msg);
+	if (ret < 0)
+		return ret;
+	if (msg.result != EC_RES_SUCCESS) {
+		snprintf(str, maxlen,
+			 "%s\nUnknown EC version: EC returned %d\n",
+			 CROS_EC_DEV_VERSION, msg.result);
+		return 0;
+	}
+	if (resp.current_image >= ARRAY_SIZE(current_image_name))
+		resp.current_image = 3; /* invalid */
+	snprintf(str, maxlen, "%s\n%s\n%s\n\%s\n", CROS_EC_DEV_VERSION,
+		 resp.version_string_ro, resp.version_string_rw,
+		 current_image_name[resp.current_image]);
+
+	return 0;
+}
+
+/* Device file ops */
+static int ec_device_open(struct inode *inode, struct file *filp)
+{
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
+	count = min(length, strlen(msg));
+
+	if (copy_to_user(buffer, msg, count))
+		return -EFAULT;
+
+	*offset += count;
+	return count;
+}
+
+
+/* Ioctls */
+static long ec_device_ioctl_xcmd(void __user *argp)
+{
+	long ret;
+	struct cros_ec_command s_cmd;
+	uint8_t *user_indata;
+	uint8_t buf[EC_PROTO2_MAX_PARAM_SIZE];
+
+	if (copy_from_user(&s_cmd, argp, sizeof(s_cmd)))
+		return -EFAULT;
+	if (s_cmd.outsize &&
+	    copy_from_user(&buf, (void __user *)s_cmd.outdata, sizeof(buf)))
+		return -EFAULT;
+
+	user_indata = s_cmd.indata;
+	s_cmd.indata = buf;
+	s_cmd.outdata = buf;
+	ret = cros_ec_cmd_xfer(ec, &s_cmd);
+	s_cmd.indata = user_indata;
+
+	/* Only copy data to userland if data was received. */
+	if (ret > 0 && s_cmd.insize) {
+		unsigned size = ret;
+
+		size = min(size, s_cmd.insize);
+		if (copy_to_user((void __user *)s_cmd.indata, buf, size))
+			return -EFAULT;
+	}
+	if (copy_to_user(argp, &s_cmd, sizeof(s_cmd)))
+		return -EFAULT;
+
+	return ret;
+}
+
+static long ec_device_ioctl_readmem(void __user *argp)
+{
+	struct cros_ec_readmem s_mem;
+	char buf[EC_MEMMAP_SIZE];
+	long num;
+
+	/* Not every platform supports direct reads */
+	if (!ec->cmd_readmem)
+		return -ENOTTY;
+
+	if (copy_from_user(&s_mem, argp, sizeof(s_mem)))
+		return -EFAULT;
+	num = ec->cmd_readmem(ec, s_mem.offset, s_mem.bytes, buf);
+	if (num <= 0)
+		return num;
+	if (copy_to_user((void __user *)s_mem.buffer, buf, num))
+		return -EFAULT;
+	return num;
+}
+
+static long ec_device_ioctl(struct file *filp, unsigned int cmd,
+			    unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+
+	if (_IOC_TYPE(cmd) != CROS_EC_DEV_IOC)
+		return -ENOTTY;
+
+	switch (cmd) {
+	case CROS_EC_DEV_IOCXCMD:
+		return ec_device_ioctl_xcmd(argp);
+	case CROS_EC_DEV_IOCRDMEM:
+		return ec_device_ioctl_readmem(argp);
+	}
+
+	return -ENOTTY;
+}
+
+#ifdef CONFIG_COMPAT
+struct compat_cros_ec_command {
+	uint32_t version;
+	uint32_t command;
+	compat_uptr_t outdata;
+	uint32_t outsize;
+	compat_uptr_t indata;
+	uint32_t insize;
+	uint32_t result;
+};
+
+struct compat_cros_ec_readmem {
+	uint32_t offset;
+	uint32_t bytes;
+	compat_uptr_t buffer;
+};
+
+#define CROS_EC_DEV_COMPAT_IOCXCMD  _IOWR(':', 0, struct compat_cros_ec_command)
+#define CROS_EC_DEV_COMPAT_IOCRDMEM _IOWR(':', 1, struct compat_cros_ec_readmem)
+
+static long ec_device_compat_ioctl_readmem(void __user *argp)
+{
+	struct compat_cros_ec_readmem compat_s_mem;
+	char buf[EC_MEMMAP_SIZE];
+	long num;
+
+	/* Not every platform supports direct reads */
+	if (!ec->cmd_readmem)
+		return -ENOTTY;
+
+	if (copy_from_user(&compat_s_mem, argp, sizeof(compat_s_mem)))
+		return -EFAULT;
+
+	num = ec->cmd_readmem(ec, compat_s_mem.offset, compat_s_mem.bytes, buf);
+	if (num <= 0)
+		return num;
+
+	if (copy_to_user(compat_ptr(compat_s_mem.buffer), buf, num))
+		return -EFAULT;
+	return num;
+}
+
+static long ec_device_compat_ioctl_xcmd(void __user *argp)
+{
+	long ret;
+	struct cros_ec_command s_cmd;
+	struct compat_cros_ec_command compat_s_cmd;
+	uint8_t buf[EC_PROTO2_MAX_PARAM_SIZE];
+
+	if (copy_from_user(&compat_s_cmd, argp, sizeof(compat_s_cmd)))
+		return -EFAULT;
+
+	s_cmd.version = compat_s_cmd.version;
+	s_cmd.command = compat_s_cmd.command;
+	s_cmd.insize = compat_s_cmd.insize;
+	s_cmd.outsize = compat_s_cmd.outsize;
+
+	if (s_cmd.outsize &&
+	    copy_from_user(&buf, compat_ptr(compat_s_cmd.outdata), sizeof(buf)))
+		return -EFAULT;
+
+	s_cmd.indata = buf;
+	s_cmd.outdata = buf;
+	ret = cros_ec_cmd_xfer(ec, &s_cmd);
+
+	compat_s_cmd.result = s_cmd.result;
+
+	/* Only copy data to userland if data was received. */
+	if (ret > 0 && s_cmd.insize) {
+		unsigned size = ret;
+
+		size = min(size, s_cmd.insize);
+		if (copy_to_user(compat_ptr(compat_s_cmd.indata), buf, size))
+			return -EFAULT;
+	}
+
+	if (copy_to_user(argp, &compat_s_cmd, sizeof(compat_s_cmd)))
+		return -EFAULT;
+
+	return ret;
+}
+
+static long ec_device_compat_ioctl(struct file *filp, unsigned int cmd,
+				   unsigned long arg)
+{
+	void __user
+	*argp = (void __user *)arg;
+	switch (cmd) {
+	case CROS_EC_DEV_COMPAT_IOCXCMD:
+		return ec_device_compat_ioctl_xcmd(argp);
+	case CROS_EC_DEV_COMPAT_IOCRDMEM:
+		return ec_device_compat_ioctl_readmem(argp);
+	}
+	return -ENOTTY;
+}
+#endif /* CONFIG_COMPAT */
+
+
+/* Module initialization */
+static const struct file_operations fops = {
+	.open = ec_device_open,
+	.release = ec_device_release,
+	.read = ec_device_read,
+	.unlocked_ioctl = ec_device_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = ec_device_compat_ioctl,
+#endif
+};
+
+static int ec_device_probe(struct platform_device *pdev)
+{
+	int retval = -ENOTTY;
+
+	ec = dev_get_drvdata(pdev->dev.parent);
+
+	cros_class = class_create(THIS_MODULE, CROS_CLASS_NAME);
+	if (IS_ERR(cros_class)) {
+		pr_err("failed to register device class\n");
+		retval = PTR_ERR(cros_class);
+		goto failed_class;
+	}
+
+	/* Let the kernel pick the major num for us */
+	ec_major = register_chrdev(0, CROS_EC_DEV_NAME, &fops);
+	if (ec_major < 0) {
+		pr_err("failed to register device\n");
+		retval = ec_major;
+		goto failed_chrdevreg;
+	}
+
+	/* Instantiate it */
+	ec->vdev = device_create(cros_class, NULL, MKDEV(ec_major, 0),
+				 NULL, CROS_EC_DEV_NAME);
+	if (IS_ERR(ec->vdev)) {
+		pr_err("failed to create device\n");
+		retval = PTR_ERR(ec->vdev);
+		goto failed_devreg;
+	}
+
+	return 0;
+
+failed_devreg:
+	unregister_chrdev(ec_major, CROS_EC_DEV_NAME);
+failed_chrdevreg:
+	class_destroy(cros_class);
+failed_class:
+	return retval;
+}
+
+static int ec_device_remove(struct platform_device *pdev)
+{
+	device_destroy(cros_class, MKDEV(ec_major, 0));
+	unregister_chrdev(ec_major, CROS_EC_DEV_NAME);
+	class_destroy(cros_class);
+	return 0;
+}
+
+static struct platform_driver cros_ec_dev_driver = {
+	.driver = {
+		.name = "cros-ec-dev",
+		.owner = THIS_MODULE,
+	},
+	.probe = ec_device_probe,
+	.remove = ec_device_remove,
+};
+
+module_platform_driver(cros_ec_dev_driver);
+
+MODULE_AUTHOR("Bill Richardson <wfrichar@chromium.org>");
+MODULE_DESCRIPTION("Userspace interface to the Chrome OS Embedded Controller");
+MODULE_VERSION("1.0");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/cros_ec.h b/include/linux/mfd/cros_ec.h
index 0e166b9..b1cb934 100644
--- a/include/linux/mfd/cros_ec.h
+++ b/include/linux/mfd/cros_ec.h
@@ -59,9 +59,16 @@ struct cros_ec_command {
  *
  * @ec_name: name of EC device (e.g. 'chromeos-ec')
  * @phys_name: name of physical comms layer (e.g. 'i2c-4')
- * @dev: Device pointer
+ * @dev: Device pointer for physical comms device
+ * @vdev: Device pointer for virtual comms device
  * @was_wake_device: true if this device was set to wake the system from
  * sleep at the last suspend
+ * @cmd_read_mem: direct read of the EC memory-mapped region, if supported
+ *     @offset is within EC_LPC_ADDR_MEMMAP region.
+ *     @bytes: number of bytes to read. zero means "read a string" (including
+ *     the trailing '\0'). At most only EC_MEMMAP_SIZE bytes can be read.
+ *     Caller must ensure that the buffer is large enough for the result when
+ *     reading a string.
  *
  * @priv: Private data
  * @irq: Interrupt to use
@@ -90,8 +97,11 @@ struct cros_ec_device {
 	const char *ec_name;
 	const char *phys_name;
 	struct device *dev;
+	struct device *vdev;
 	bool was_wake_device;
 	struct class *cros_class;
+	int (*cmd_readmem)(struct cros_ec_device *ec, unsigned int offset,
+			   unsigned int bytes, void *dest);
 
 	/* These are used to implement the platform-specific interface */
 	void *priv;
diff --git a/include/linux/mfd/cros_ec_dev.h b/include/linux/mfd/cros_ec_dev.h
new file mode 100644
index 0000000..465e926
--- /dev/null
+++ b/include/linux/mfd/cros_ec_dev.h
@@ -0,0 +1,47 @@
+/*
+ * cros_ec_dev - expose the Chrome OS Embedded Controller to userspace
+ *
+ * Copyright (C) 2013 The Chromium OS Authors
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
+	char *buffer;
+};
+
+#define CROS_EC_DEV_IOC              ':'
+#define CROS_EC_DEV_IOCXCMD    _IOWR(':', 0, struct cros_ec_command)
+#define CROS_EC_DEV_IOCRDMEM   _IOWR(':', 1, struct cros_ec_readmem)
+
+#endif /* _CROS_EC_DEV_H_ */
-- 
2.1.0

