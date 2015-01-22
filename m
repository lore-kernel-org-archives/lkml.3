Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbbAVTR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 14:17:57 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:36181 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbbAVTQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 14:16:44 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>, Jonathan Corbet <corbet@lwn.net>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v3 3/7] misc: Add cros_ec_lpc driver for x86 devices
Date: Thu, 22 Jan 2015 20:16:22 +0100
Message-Id: <1421954186-29764-4-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421954186-29764-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1421954186-29764-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bill Richardson <wfrichar@chromium.org>

Chromebooks have an Embedded Controller (EC) that is used to
implement various functions such as keyboard, power and battery.

The AP can communicate with the EC through different bus types
such as I2C, SPI or LPC.

The cros_ec mfd driver is then composed of a core driver that
register the sub-devices as mfd cells and provide a high level
communication interface that is used by the rest of the kernel
and bus specific interfaces modules.

Each connection method then has its own driver, which register
with the EC driver interface-agnostic interface.

Currently, there are drivers to communicate with the EC over
I2C and SPI and this driver adds support for LPC.

Signed-off-by: Bill Richardson <wfrichar@chromium.org>
Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---

Changes since v2:
 - Move out from drivers/mfd to drivers/misc. Suggested by Lee Jones.

Changes since v1: None, new patch.
---
 drivers/misc/Kconfig       |  10 ++
 drivers/misc/Makefile      |   1 +
 drivers/misc/cros_ec_lpc.c | 306 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 317 insertions(+)
 create mode 100644 drivers/misc/cros_ec_lpc.c

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 006242c8bca0..142393e84a43 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -515,6 +515,16 @@ config VEXPRESS_SYSCFG
 	  bus. System Configuration interface is one of the possible means
 	  of generating transactions on this bus.
 
+config CROS_EC_LPC
+	tristate "ChromeOS Embedded Controller (LPC)"
+	depends on MFD_CROS_EC
+
+	help
+	  If you say Y here, you get support for talking to the ChromeOS EC
+	  over an LPC bus. This uses a simple byte-level protocol with a
+	  checksum. This is used for userspace access only. The kernel
+	  typically has its own communication methods.
+
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 7d5c4cd118c4..37a9647e7900 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -55,4 +55,5 @@ obj-y				+= mic/
 obj-$(CONFIG_GENWQE)		+= genwqe/
 obj-$(CONFIG_ECHO)		+= echo/
 obj-$(CONFIG_VEXPRESS_SYSCFG)	+= vexpress-syscfg.o
+obj-$(CONFIG_CROS_EC_LPC)	+= cros_ec_lpc.o
 obj-$(CONFIG_CXL_BASE)		+= cxl/
diff --git a/drivers/misc/cros_ec_lpc.c b/drivers/misc/cros_ec_lpc.c
new file mode 100644
index 000000000000..ef644d26ea4f
--- /dev/null
+++ b/drivers/misc/cros_ec_lpc.c
@@ -0,0 +1,306 @@
+/*
+ * cros_ec_lpc - LPC access to the Chrome OS Embedded Controller
+ *
+ * Copyright (C) 2012-2015 Google, Inc
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * This driver uses the Chrome OS EC byte-level message-based protocol for
+ * communicating the keyboard state (which keys are pressed) from a keyboard EC
+ * to the AP over some bus (such as i2c, lpc, spi).  The EC does debouncing,
+ * but everything else (including deghosting) is done here.  The main
+ * motivation for this is to keep the EC firmware as simple as possible, since
+ * it cannot be easily upgraded and EC flash/IRAM space is relatively
+ * expensive.
+ */
+
+#include <linux/delay.h>
+#include <linux/mfd/cros_ec.h>
+#include <linux/mfd/cros_ec_commands.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/printk.h>
+
+#define MYNAME "cros_ec_lpc"
+
+static int ec_response_timed_out(void)
+{
+	unsigned long one_second = jiffies + HZ;
+
+	usleep_range(200, 300);
+	do {
+		if (!(inb(EC_LPC_ADDR_HOST_CMD) & EC_LPC_STATUS_BUSY_MASK))
+			return 0;
+		usleep_range(100, 200);
+	} while (time_before(jiffies, one_second));
+
+	return 1;
+}
+
+static int cros_ec_cmd_xfer_lpc(struct cros_ec_device *ec,
+				struct cros_ec_command *msg)
+{
+	struct ec_lpc_host_args args;
+	int csum;
+	int i;
+	int ret = 0;
+
+	if (msg->outsize > EC_PROTO2_MAX_PARAM_SIZE ||
+	    msg->insize > EC_PROTO2_MAX_PARAM_SIZE) {
+		dev_err(ec->dev,
+			"invalid buffer sizes (out %d, in %d)\n",
+			msg->outsize, msg->insize);
+		return -EINVAL;
+	}
+
+	/* Now actually send the command to the EC and get the result */
+	args.flags = EC_HOST_ARGS_FLAG_FROM_HOST;
+	args.command_version = msg->version;
+	args.data_size = msg->outsize;
+
+	/* Initialize checksum */
+	csum = msg->command + args.flags +
+		args.command_version + args.data_size;
+
+	/* Copy data and update checksum */
+	for (i = 0; i < msg->outsize; i++) {
+		outb(msg->outdata[i], EC_LPC_ADDR_HOST_PARAM + i);
+		csum += msg->outdata[i];
+	}
+
+	/* Finalize checksum and write args */
+	args.checksum = csum & 0xFF;
+	outb(args.flags, EC_LPC_ADDR_HOST_ARGS);
+	outb(args.command_version, EC_LPC_ADDR_HOST_ARGS + 1);
+	outb(args.data_size, EC_LPC_ADDR_HOST_ARGS + 2);
+	outb(args.checksum, EC_LPC_ADDR_HOST_ARGS + 3);
+
+	/* Here we go */
+	outb(msg->command, EC_LPC_ADDR_HOST_CMD);
+
+	if (ec_response_timed_out()) {
+		dev_warn(ec->dev, "EC responsed timed out\n");
+		ret = -EIO;
+		goto done;
+	}
+
+	/* Check result */
+	msg->result = inb(EC_LPC_ADDR_HOST_DATA);
+
+	switch (msg->result) {
+	case EC_RES_SUCCESS:
+		break;
+	case EC_RES_IN_PROGRESS:
+		ret = -EAGAIN;
+		dev_dbg(ec->dev, "command 0x%02x in progress\n",
+			msg->command);
+		goto done;
+	default:
+		dev_dbg(ec->dev, "command 0x%02x returned %d\n",
+			msg->command, msg->result);
+	}
+
+	/* Read back args */
+	args.flags = inb(EC_LPC_ADDR_HOST_ARGS);
+	args.command_version = inb(EC_LPC_ADDR_HOST_ARGS + 1);
+	args.data_size = inb(EC_LPC_ADDR_HOST_ARGS + 2);
+	args.checksum = inb(EC_LPC_ADDR_HOST_ARGS + 3);
+
+	if (args.data_size > msg->insize) {
+		dev_err(ec->dev,
+			"packet too long (%d bytes, expected %d)",
+			args.data_size, msg->insize);
+		ret = -ENOSPC;
+		goto done;
+	}
+
+	/* Start calculating response checksum */
+	csum = msg->command + args.flags +
+		args.command_version + args.data_size;
+
+	/* Read response and update checksum */
+	for (i = 0; i < args.data_size; i++) {
+		msg->indata[i] = inb(EC_LPC_ADDR_HOST_PARAM + i);
+		csum += msg->indata[i];
+	}
+
+	/* Verify checksum */
+	if (args.checksum != (csum & 0xFF)) {
+		dev_err(ec->dev,
+			"bad packet checksum, expected %02x, got %02x\n",
+			args.checksum, csum & 0xFF);
+		ret = -EBADMSG;
+		goto done;
+	}
+
+	/* Return actual amount of data received */
+	ret = args.data_size;
+done:
+	return ret;
+}
+
+/* Returns num bytes read, or negative on error. Doesn't need locking. */
+static int cros_ec_lpc_readmem(struct cros_ec_device *ec, unsigned int offset,
+			       unsigned int bytes, void *dest)
+{
+	int i = offset;
+	char *s = dest;
+	int cnt = 0;
+
+	if (offset >= EC_MEMMAP_SIZE - bytes)
+		return -EINVAL;
+
+	/* fixed length */
+	if (bytes) {
+		for (; cnt < bytes; i++, s++, cnt++)
+			*s = inb(EC_LPC_ADDR_MEMMAP + i);
+		return cnt;
+	}
+
+	/* string */
+	for (; i < EC_MEMMAP_SIZE; i++, s++) {
+		*s = inb(EC_LPC_ADDR_MEMMAP + i);
+		cnt++;
+		if (!*s)
+			break;
+	}
+
+	return cnt;
+}
+
+static int cros_ec_lpc_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct cros_ec_device *ec_dev;
+	int err = -ENOTTY;
+
+	if (!request_region(EC_LPC_ADDR_MEMMAP, EC_MEMMAP_SIZE, MYNAME)) {
+		dev_warn(dev, "couldn't reserve memmap region\n");
+		goto failed_memmap;
+	}
+
+	if ((inb(EC_LPC_ADDR_MEMMAP + EC_MEMMAP_ID) != 'E') ||
+	    (inb(EC_LPC_ADDR_MEMMAP + EC_MEMMAP_ID + 1) != 'C')) {
+		dev_warn(dev, "EC ID not detected\n");
+		goto failed_ec_probe;
+	}
+
+	if (!request_region(EC_HOST_CMD_REGION0, EC_HOST_CMD_REGION_SIZE,
+			    MYNAME)) {
+		dev_warn(dev, "couldn't reserve region0\n");
+		goto failed_region0;
+	}
+	if (!request_region(EC_HOST_CMD_REGION1, EC_HOST_CMD_REGION_SIZE,
+			    MYNAME)) {
+		dev_warn(dev, "couldn't reserve region1\n");
+		goto failed_region1;
+	}
+
+	ec_dev = devm_kzalloc(dev, sizeof(*ec_dev), GFP_KERNEL);
+	if (!ec_dev) {
+		err = -ENOMEM;
+		goto failed_ec_dev;
+	}
+
+	platform_set_drvdata(pdev, ec_dev);
+	ec_dev->dev = dev;
+	ec_dev->ec_name = pdev->name;
+	ec_dev->phys_name = dev_name(dev);
+	ec_dev->parent = dev;
+	ec_dev->cmd_xfer = cros_ec_cmd_xfer_lpc;
+	ec_dev->cmd_readmem = cros_ec_lpc_readmem;
+
+	err = cros_ec_register(ec_dev);
+	if (err) {
+		dev_warn(dev, "couldn't register ec_dev\n");
+		goto failed_ec_dev;
+	}
+
+	return 0;
+
+failed_ec_dev:
+	release_region(EC_HOST_CMD_REGION1, EC_HOST_CMD_REGION_SIZE);
+failed_region1:
+	release_region(EC_HOST_CMD_REGION0, EC_HOST_CMD_REGION_SIZE);
+failed_region0:
+failed_ec_probe:
+	release_region(EC_LPC_ADDR_MEMMAP, EC_MEMMAP_SIZE);
+failed_memmap:
+	return err;
+}
+
+static int cros_ec_lpc_remove(struct platform_device *pdev)
+{
+	struct cros_ec_device *ec_dev;
+
+	ec_dev = platform_get_drvdata(pdev);
+	cros_ec_remove(ec_dev);
+
+	release_region(EC_HOST_CMD_REGION1, EC_HOST_CMD_REGION_SIZE);
+	release_region(EC_HOST_CMD_REGION0, EC_HOST_CMD_REGION_SIZE);
+	release_region(EC_LPC_ADDR_MEMMAP, EC_MEMMAP_SIZE);
+
+	return 0;
+}
+
+static struct platform_driver cros_ec_lpc_driver = {
+	.driver = {
+		.name = MYNAME,
+		.owner = THIS_MODULE,
+	},
+	.probe = cros_ec_lpc_probe,
+	.remove = cros_ec_lpc_remove,
+};
+
+static void do_nothing(struct device *dev)
+{
+	/* not a physical device */
+}
+
+static struct platform_device cros_ec_lpc_device = {
+	.name = MYNAME,
+	.dev = {
+		.release = do_nothing,
+	},
+};
+
+static int __init cros_ec_lpc_init(void)
+{
+	int ret;
+
+	/* Register the driver */
+	ret = platform_driver_register(&cros_ec_lpc_driver);
+	if (ret < 0) {
+		pr_warn(MYNAME ": can't register driver: %d\n", ret);
+		return ret;
+	}
+
+	/* Register the device, and it'll get hooked up automatically */
+	ret = platform_device_register(&cros_ec_lpc_device);
+	if (ret < 0) {
+		pr_warn(MYNAME ": can't register device: %d\n", ret);
+		platform_driver_unregister(&cros_ec_lpc_driver);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void __exit cros_ec_lpc_exit(void)
+{
+	platform_device_unregister(&cros_ec_lpc_device);
+	platform_driver_unregister(&cros_ec_lpc_driver);
+}
+
+module_init(cros_ec_lpc_init);
+module_exit(cros_ec_lpc_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("ChromeOS EC LPC driver");
-- 
2.1.3

