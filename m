Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab3IRP5H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 11:57:07 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:44414 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab3IRP5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 11:57:01 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Alan Tull <atull@altera.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        David Brown <davidb@codeaurora.org>, Dom Cobley <popcornmix@gmail.com>
Subject: [RFC PATCH] fpga: Introduce new fpga subsystem
Date: Wed, 18 Sep 2013 17:56:39 +0200
Message-Id: <cb9a12ae95bc39626a745c2487ffd0e47e9c7b34.1379519753.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <cover.1379519753.git.michal.simek@xilinx.com>
References: <cover.1379519753.git.michal.simek@xilinx.com>
In-Reply-To: <cover.1379519753.git.michal.simek@xilinx.com>
References: <cover.1379519753.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-22767-1379519817-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-22767-1379519817-0001

This new subsystem should unify all fpga drivers which
do the same things. Load configuration data to fpga
or another programmable logic through common interface.
It doesn't matter if it is MMIO device, gpio bitbanging,
etc. connection. The point is to have the same
inteface for these drivers.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>

---
 MAINTAINERS             |   7 +
 drivers/Kconfig         |   2 +
 drivers/Makefile        |   1 +
 drivers/fpga/Kconfig    |  18 ++
 drivers/fpga/Makefile   |   5 +
 drivers/fpga/fpga-mgr.c | 433 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fpga.h    | 105 ++++++++++++
 7 files changed, 571 insertions(+)
 create mode 100644 drivers/fpga/Kconfig
 create mode 100644 drivers/fpga/Makefile
 create mode 100644 drivers/fpga/fpga-mgr.c
 create mode 100644 include/linux/fpga.h

diff --git a/MAINTAINERS b/MAINTAINERS
index e61c2e8..5c7597b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3427,6 +3427,13 @@ F:	include/linux/fmc*.h
 F:	include/linux/ipmi-fru.h
 K:	fmc_d.*register

+FPGA SUBSYSTEM
+M:	Michal Simek <michal.simek@xilinx.com>
+T:	git git://git.xilinx.com/linux-xlnx.git
+S:	Supported
+F:	drivers/fpga/
+F:	include/linux/fpga.h
+
 FPU EMULATOR
 M:	Bill Metzenthen <billm@melbpc.org.au>
 W:	http://floatingpoint.sourceforge.net/emulator/index.html
diff --git a/drivers/Kconfig b/drivers/Kconfig
index aa43b91..17f3caa 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -166,4 +166,6 @@ source "drivers/reset/Kconfig"

 source "drivers/fmc/Kconfig"

+source "drivers/fpga/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index ab93de8..2b5e73b 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -152,3 +152,4 @@ obj-$(CONFIG_VME_BUS)		+= vme/
 obj-$(CONFIG_IPACK_BUS)		+= ipack/
 obj-$(CONFIG_NTB)		+= ntb/
 obj-$(CONFIG_FMC)		+= fmc/
+obj-$(CONFIG_FPGA)		+= fpga/
diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
new file mode 100644
index 0000000..5357645
--- /dev/null
+++ b/drivers/fpga/Kconfig
@@ -0,0 +1,18 @@
+#
+# FPGA framework configuration
+#
+
+menu "FPGA devices"
+
+config FPGA
+	tristate "FPGA Framework"
+	help
+	  Say Y here if you want support for configuring FPGAs from the
+	  kernel.  The FPGA framework adds a FPGA manager class and FPGA
+	  manager drivers.
+
+if FPGA
+
+endif
+
+endmenu
diff --git a/drivers/fpga/Makefile b/drivers/fpga/Makefile
new file mode 100644
index 0000000..3c7f29b
--- /dev/null
+++ b/drivers/fpga/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for the fpga framework and fpga manager drivers.
+#
+
+obj-$(CONFIG_FPGA)			+= fpga-mgr.o
diff --git a/drivers/fpga/fpga-mgr.c b/drivers/fpga/fpga-mgr.c
new file mode 100644
index 0000000..7312efd
--- /dev/null
+++ b/drivers/fpga/fpga-mgr.c
@@ -0,0 +1,433 @@
+/*
+ * FPGA Framework
+ *
+ * Copyright (C) 2013 Xilinx, Inc.
+ *
+ * based on origin code from
+ * Copyright (C) 2013 Altera Corporation
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
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/firmware.h>
+#include <linux/fpga.h>
+#include <linux/fs.h>
+#include <linux/idr.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+
+static struct idr fpga_mgr_idr;
+static spinlock_t fpga_mgr_idr_lock;
+static struct class *fpga_mgr_class;
+
+/**
+ * fpga_mgr_name_show - Show fpga manager name
+ * @dev: Pointer to the device structure
+ * @attr: Pointer to the device attribute structure
+ * @buf: Pointer to the buffer location
+ *
+ * Returns the number of bytes copied to @buf, a negative error number otherwise
+ */
+static ssize_t fpga_mgr_name_show(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	struct fpga_manager *mgr = dev_get_drvdata(dev);
+
+	if (!mgr)
+		return -ENODEV;
+
+	return snprintf(buf, sizeof(mgr->name), "%s\n", mgr->name);
+}
+
+/**
+ * fpga_mgr_status_show - Show fpga manager status
+ * @dev: Pointer to the device structure
+ * @attr: Pointer to the device attribute structure
+ * @buf: Pointer to the buffer location
+ *
+ * Returns the number of bytes copied to @buf, a negative error number otherwise
+ */
+static ssize_t fpga_mgr_status_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	struct fpga_manager *mgr = dev_get_drvdata(dev);
+
+	if (!mgr || !mgr->mops || !mgr->mops->status)
+		return -ENODEV;
+
+	return mgr->mops->status(mgr, buf);
+}
+
+/**
+ * fpga_mgr_read - Read data from fpga
+ * @mgr: Pointer to the fpga manager structure
+ * @buf: Pointer to the buffer location
+ * @count: Pointer to the number of copied bytes
+ *
+ * Function reads fpga bitstream and copy them to output buffer.
+ *
+ * Returns the number of bytes copied to @buf, a negative error number otherwise
+ */
+static int fpga_mgr_read(struct fpga_manager *mgr, char *buf, ssize_t *count)
+{
+	int ret;
+
+	if (test_and_set_bit_lock(FPGA_MGR_DEV_BUSY, &mgr->flags))
+		return -EBUSY;
+
+	if (!mgr->mops || !mgr->mops->read) {
+		dev_err(mgr->dev,
+			"Controller doesn't support read operations!\n");
+		return -EPERM;
+	}
+
+	if (mgr->mops->read_init) {
+		ret = mgr->mops->read_init(mgr);
+		if (ret) {
+			dev_err(mgr->dev, "Failed in read-init!\n");
+			return ret;
+		}
+	}
+
+	if (mgr->mops->read) {
+		ret = mgr->mops->read(mgr, buf, count);
+		if (ret) {
+			dev_err(mgr->dev, "Failed to read firmware!\n");
+			return ret;
+		}
+	}
+
+	if (mgr->mops->read_complete) {
+		ret = mgr->mops->read_complete(mgr);
+		if (ret) {
+			dev_err(mgr->dev, "Failed in read-complete!\n");
+			return ret;
+		}
+	}
+
+	clear_bit_unlock(FPGA_MGR_DEV_BUSY, &mgr->flags);
+
+	return 0;
+}
+
+/**
+ * fpga_mgr_attr_read - Read data from fpga
+ * @dev: Pointer to the device structure
+ * @attr: Pointer to the device attribute structure
+ * @buf: Pointer to the buffer location
+ *
+ * Function reads fpga bitstream and copy them to output buffer
+ *
+ * Returns the number of bytes copied to @buf, a negative error number otherwise
+ */
+static ssize_t fpga_mgr_attr_read(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct fpga_manager *mgr = dev_get_drvdata(dev);
+	ssize_t count;
+	int ret;
+
+	if (mgr && mgr->fpga_read)
+		ret = mgr->fpga_read(mgr, buf, &count);
+
+	return ret == 0 ? count : -EPERM;
+}
+
+/**
+ * fpga_mgr_write - Write data to fpga
+ * @mgr: Pointer to the fpga manager structure
+ * @fw_name: Pointer to the buffer location with bistream firmware filename
+ *
+ * @buf contains firmware filename which is loading through firmware
+ * interface and passed to the fpga driver.
+ *
+ * Returns string lenght added to @fw_name, a negative error number otherwise
+ */
+static int fpga_mgr_write(struct fpga_manager *mgr, const char *fw_name)
+{
+	int ret = 0;
+	const struct firmware *fw;
+
+	if (!fw_name || !strlen(fw_name)) {
+		dev_err(mgr->dev, "Firmware name is not specified!\n");
+		return -EINVAL;
+	}
+
+	if (!mgr->mops || !mgr->mops->write) {
+		dev_err(mgr->dev,
+			"Controller doesn't support write operations!\n");
+		return -EPERM;
+	}
+
+	ret = request_firmware(&fw, fw_name, mgr->dev);
+	if (ret) {
+		dev_err(mgr->dev, "Failed to load firmware %s!\n", fw_name);
+		return ret;
+	}
+
+	if (test_and_set_bit_lock(FPGA_MGR_DEV_BUSY, &mgr->flags))
+		return -EBUSY;
+
+	/* Init controller */
+	if (mgr->mops->write_init) {
+		ret = mgr->mops->write_init(mgr);
+		if (ret) {
+			dev_err(mgr->dev, "Failed to write_init!\n");
+			return ret;
+		}
+	}
+
+	/* Do write */
+	ret = mgr->mops->write(mgr, (void *)fw->data, fw->size);
+	if (ret) {
+		dev_err(mgr->dev, "Failed to write data!\n");
+		return ret;
+	}
+
+	if (mgr->mops->write_complete) {
+		ret = mgr->mops->write_complete(mgr);
+		if (ret) {
+			dev_err(mgr->dev, "Failed to write_init!\n");
+			return ret;
+		}
+	}
+
+	release_firmware(fw);
+
+	clear_bit_unlock(FPGA_MGR_DEV_BUSY, &mgr->flags);
+
+	return 0;
+}
+
+/**
+ * fpga_mgr_attr_write - Write data to fpga
+ * @dev: Pointer to the device structure
+ * @attr: Pointer to the device attribute structure
+ * @buf: Pointer to the buffer location with bistream firmware filename
+ * @count: Number of characters in @buf
+ *
+ * @buf contains firmware filename which is loading through firmware
+ * interface and passed to the fpga driver.
+ *
+ * Returns string lenght added to @buf, a negative error number otherwise
+ */
+static ssize_t fpga_mgr_attr_write(struct device *dev,
+				   struct device_attribute *attr,
+				   const char *buf, size_t count)
+{
+	struct fpga_manager *mgr = dev_get_drvdata(dev);
+	int ret;
+
+	if (mgr && mgr->fpga_write)
+		ret = mgr->fpga_write(mgr, buf);
+
+	return ret == 0 ? strlen(buf) : -EPERM;
+}
+
+static struct device_attribute fpga_mgr_attrs[] = {
+	__ATTR(name, S_IRUGO, fpga_mgr_name_show, NULL),
+	__ATTR(status, S_IRUGO, fpga_mgr_status_show, NULL),
+	__ATTR(fpga, S_IRUGO | S_IWUGO, fpga_mgr_attr_read,
+	       fpga_mgr_attr_write),
+	__ATTR_NULL
+};
+
+/**
+ * fpga_mgr_register: Register new fpga manager
+ * @pdev: Pointer to the platform device of fpga manager
+ * @mops: Pointer to the fpga manager operations
+ * @name: Name of fpga manager
+ * @priv: Pointer to the fpga manager private data
+ *
+ * Function register fpga manager with uniq ID and create device
+ * for accessing the device.
+ *
+ * Returns 0 on success, a negative error number otherwise
+ */
+int fpga_mgr_register(struct platform_device *pdev,
+		      struct fpga_manager_ops *mops, char *name, void *priv)
+{
+	struct fpga_manager *mgr;
+	int ret;
+
+	if (!mops) {
+		dev_err(&pdev->dev, "Register failed: NO fpga_manager_ops!\n");
+		return -EINVAL;
+	}
+
+	if (!name || !strlen(name)) {
+		dev_err(&pdev->dev, "Register failed: NO name specific!\n");
+		return -EINVAL;
+	}
+
+	mgr = devm_kzalloc(&pdev->dev, sizeof(*mgr), GFP_KERNEL);
+	if (!mgr) {
+		dev_err(&pdev->dev, "Failed to alloc mgr struct!\n");
+		return -ENOMEM;
+	}
+
+	/* Get unique number */
+	idr_preload(GFP_KERNEL);
+	spin_lock(&fpga_mgr_idr_lock);
+	ret = idr_alloc(&fpga_mgr_idr, mgr, 0, 0, GFP_NOWAIT);
+	if (ret >= 0)
+		mgr->nr = ret;
+	spin_unlock(&fpga_mgr_idr_lock);
+	idr_preload_end();
+	if (ret < 0)
+		return ret;
+
+	/* Setup all necessary information */
+	mgr->dev = &pdev->dev;
+	mgr->mops = mops;
+	mgr->priv = priv;
+	mgr->fpga_read = fpga_mgr_read;
+	mgr->fpga_write = fpga_mgr_write;
+	strlcpy(mgr->name, name, sizeof(mgr->name));
+
+	mgr->dev = device_create(fpga_mgr_class, get_device(&pdev->dev),
+				 MKDEV(0, 0), mgr, "fpga%d", mgr->nr);
+	if (IS_ERR(mgr->dev)) {
+		spin_lock(&fpga_mgr_idr_lock);
+		idr_remove(&fpga_mgr_idr, mgr->nr);
+		spin_unlock(&fpga_mgr_idr_lock);
+
+		dev_err(&pdev->dev, "Failed to create device!\n");
+		return PTR_ERR(mgr->dev);
+	}
+
+	platform_set_drvdata(pdev, mgr);
+
+	dev_info(&pdev->dev, "Fpga manager [%s] registered as minor %d\n",
+		 mgr->name, mgr->nr);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(fpga_mgr_register);
+
+/**
+ * fpga_mgr_unregister: Remove fpga manager
+ * @pdev: Pointer to the platform device of fpga manager
+ *
+ * Function unregister fpga manager and release all temporary structures
+ *
+ * Returns 0 for all cases
+ */
+int fpga_mgr_unregister(struct platform_device *pdev)
+{
+	struct fpga_manager *mgr = platform_get_drvdata(pdev);
+
+	if (mgr && mgr->mops && mgr->mops->fpga_remove)
+		mgr->mops->fpga_remove(mgr);
+
+	device_unregister(mgr->dev);
+
+	spin_lock(&fpga_mgr_idr_lock);
+	idr_remove(&fpga_mgr_idr, mgr->nr);
+	spin_unlock(&fpga_mgr_idr_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(fpga_mgr_unregister);
+
+/**
+ * of_dev_node_match: Compare associated device tree node with
+ * @dev: Pointer to the device
+ * @data: Pointer to the device tree node
+ *
+ * Returns 1 on success
+ */
+static int of_dev_node_match(struct device *dev, void *data)
+{
+	return dev->of_node == data;
+}
+
+/**
+ * of_find_fpga_mgr_by_node - Find the fpga_manager associated with a node
+ * @node: Pointer to the device tree node
+ *
+ * Returns fpga_manager pointer, or NULL if not found
+ */
+struct fpga_manager *of_find_fpga_mgr_by_node(struct device_node *node)
+{
+	struct device *dev;
+	struct fpga_manager *mgr;
+
+	dev = bus_find_device(&platform_bus_type, NULL, node,
+			      of_dev_node_match);
+	if (!dev)
+		return NULL;
+
+	mgr = dev_get_drvdata(dev);
+
+	return mgr ? mgr : NULL;
+}
+EXPORT_SYMBOL(of_find_fpga_mgr_by_node);
+
+/**
+ * of_find_fpga_mgr_by_phandle - Find the fpga_manager associated with a node
+ * @node: Pointer to the device tree node
+ * @phandle_name: Pointer to the phandle_name
+ *
+ * Returns fpga_manager pointer, or NULL if not found
+ */
+struct fpga_manager *of_find_fpga_mgr_by_phandle(struct device_node *node,
+						 const char *phandle_name)
+{
+	struct device_node *fpga_node;
+
+	fpga_node = of_parse_phandle(node, phandle_name, 0);
+	if (!fpga_node) {
+		pr_err("Phandle not found\n");
+		return ERR_PTR(-ENODEV);
+	}
+
+	return of_find_fpga_mgr_by_node(fpga_node);
+}
+EXPORT_SYMBOL(of_find_fpga_mgr_by_phandle);
+
+/**
+ * fpga_mgr_init: Create fpga class
+ */
+static int __init fpga_mgr_init(void)
+{
+	pr_info("FPGA Manager framework driver\n");
+
+	fpga_mgr_class = class_create(THIS_MODULE, "fpga");
+	if (IS_ERR(fpga_mgr_class))
+		return PTR_ERR(fpga_mgr_class);
+
+	idr_init(&fpga_mgr_idr);
+	spin_lock_init(&fpga_mgr_idr_lock);
+
+	fpga_mgr_class->dev_attrs = fpga_mgr_attrs;
+
+	return 0;
+}
+subsys_initcall(fpga_mgr_init);
+
+/**
+ * fpga_mgr_exit: Destroy fpga class
+ */
+static void __exit fpga_mgr_exit(void)
+{
+	class_destroy(fpga_mgr_class);
+	idr_destroy(&fpga_mgr_idr);
+}
+module_exit(fpga_mgr_exit);
+
+MODULE_AUTHOR("Xilinx, Inc.");
+MODULE_DESCRIPTION("FPGA Manager framework driver");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/fpga.h b/include/linux/fpga.h
new file mode 100644
index 0000000..970c42e
--- /dev/null
+++ b/include/linux/fpga.h
@@ -0,0 +1,105 @@
+/*
+ * FPGA Framework
+ *
+ * Copyright (C) 2013 Xilinx, Inc.
+ *
+ * based on origin code from
+ * Copyright (C) 2013 Altera Corporation
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
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/of.h>
+
+#ifndef _LINUX_FPGA_H
+#define _LINUX_FPGA_H
+
+struct fpga_manager;
+
+/**
+ * struct fpga_manager_ops - FPGA manager driver operations
+ *
+ * @status: The function to call for getting fpga manager status.
+ *	    Returns number of characters written to the @buf and
+ *	    a string of the FPGA's status in @bug.
+ * @read_init: The function to call for preparing the FPGA for reading
+ *	       its confuration data. Returns 0 on success, a negative error
+ *	       number otherwise.
+ * @read: Read configuration data from the FPGA. Return 0 on success,
+ *	  a negative error number otherwise.
+ * @read_complete: Return FPGA to a default state after reading is done.
+ *		   Return 0 on success, a negative error number otherwise.
+ * @write_init: Prepare the FPGA to receive configuration data.
+ *		Return 0 on success, a negative error number otherwise.
+ * @write: Write count bytes of configuration data to the FPGA placed in @buf.
+ *	   Return 0 on success, a negative error number otherwise.
+ * @write_complete: Return FPGA to default state after writing is done.
+ *		    Return 0 on success, a negative error number otherwise.
+ * @fpga_remove: Set FPGA into a specific state during driver remove.
+ *
+ * fpga_manager_ops are the low level functions implemented by a specific
+ * fpga manager driver. Leaving any of these out that aren't needed is fine
+ * as they are all tested for NULL before being called.
+ */
+struct fpga_manager_ops {
+	int (*status)(struct fpga_manager *mgr, char *buf);
+	int (*read_init)(struct fpga_manager *mgr);
+	int (*read)(struct fpga_manager *mgr, char *buf, ssize_t *count);
+	int (*read_complete)(struct fpga_manager *mgr);
+	int (*write_init)(struct fpga_manager *mgr);
+	int (*write)(struct fpga_manager *mgr, char *buf, ssize_t count);
+	int (*write_complete)(struct fpga_manager *mgr);
+	void (*fpga_remove)(struct fpga_manager *mgr);
+};
+
+/* flag bits */
+#define FPGA_MGR_DEV_BUSY 0
+
+/**
+ * struct fpga_manager - FPGA manager driver structure
+ *
+ * @name: Name of fpga manager
+ * @dev: Pointer to the device structure
+ * @mops: Pointer to the fpga manager operations
+ * @priv: Pointer to fpga manager private data
+ * @nr: Unique manager number in the system
+ * @flags: For saving temporary
+ * @fpga_read: The function to call for reading configuration data from
+ *	       the FPGA.
+ * @fpga_write: The function to call for writing configuration data to the FPGA.
+ */
+struct fpga_manager {
+	char name[48];
+	struct device *dev;
+	struct fpga_manager_ops *mops;
+	void *priv;
+	unsigned int nr;
+	unsigned long flags;
+	int (*fpga_read)(struct fpga_manager *mgr, char *buf,
+			 ssize_t *count);
+	int (*fpga_write)(struct fpga_manager *mgr, const char *fw_name);
+};
+
+int fpga_mgr_register(struct platform_device *pdev,
+		      struct fpga_manager_ops *mops, char *name, void *priv);
+
+int fpga_mgr_unregister(struct platform_device *pdev);
+
+struct fpga_manager *of_find_fpga_mgr_by_node(struct device_node *node);
+struct fpga_manager *of_find_fpga_mgr_by_phandle(struct device_node *node,
+						 const char *phandle_name);
+
+#endif /*_LINUX_FPGA_H */
--
1.8.2.3


--=_mimegpg-monstr-desktop-22767-1379519817-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlI5zUkACgkQykllyylKDCFXbwCeIRijh3CVrXMx64Zhx5WkiWHJ
TDkAoJV5FCDEou8UfZ9AE9LpW0hW+aH5
=9ETw
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-22767-1379519817-0001--
