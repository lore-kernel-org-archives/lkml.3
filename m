Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbaHAWds (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 18:33:48 -0400
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:9321
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755978AbaHAWdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 18:33:44 -0400
From: <atull@opensource.altera.com>
To: <gregkh@linuxfoundation.org>, <jgunthorpe@obsidianresearch.com>,
        <hpa@zytor.com>, <monstr@monstr.eu>, <michal.simek@xilinx.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <pantelis.antoniou@konsulko.com>, <robh+dt@kernel.org>,
        <grant.likely@linaro.org>, <pavel@denx.de>, <broonie@kernel.org>,
        <philip@balister.org>, <rubini@gnudd.com>, <s.trumtrar@pengutronix.de>,
        <jason@lakedaemon.net>, <kyle.teske@ni.com>, <nico@linaro.org>,
        <balbi@ti.com>, <m.chehab@samsung.com>, <davidb@codeaurora.org>,
        <rob@landley.net>, <davem@davemloft.net>, <cesarb@cesarb.net>,
        <sameo@linux.intel.com>, <akpm@linux-foundation.org>,
        <linus.walleij@linaro.org>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH 1/3] fpga manager framework core
Date: Fri, 1 Aug 2014 17:28:36 -0500
Message-ID: <1406932118-13885-2-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406932118-13885-1-git-send-email-atull@opensource.altera.com>
References: <1406932118-13885-1-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BN1PR02CA0025.namprd02.prod.outlook.com (10.141.56.25) To
 DM2PR03MB317.namprd03.prod.outlook.com (10.141.54.15)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 029097202E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(22564002)(189002)(199002)(93916002)(77982001)(66066001)(76176999)(50986999)(62966002)(15975445006)(87976001)(87286001)(92566001)(69596002)(102836001)(48376002)(50466002)(85852003)(575784001)(80022001)(15202345003)(86362001)(20776003)(101416001)(76482001)(81542001)(21056001)(53416004)(81156004)(4396001)(99396002)(50226001)(77096002)(229853001)(74502001)(19580395003)(19580405001)(42186005)(77156001)(88136002)(89996001)(86152002)(107046002)(81342001)(33646002)(106356001)(2201001)(92726001)(64706001)(95666004)(79102001)(104166001)(74662001)(47776003)(31966008)(83322001)(46102001)(105586002)(83072002)(85306004)(2004002)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB317;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@opensource.altera.com>

This core exports methods of doing operations on FPGAs.

EXPORT_SYMBOL_GPL(fpga_mgr_write);
  Write FPGA given a buffer and count.

EXPORT_SYMBOL_GPL(fpga_mgr_firmware_write);
  Request firmware and write that to a fpga

EXPORT_SYMBOL_GPL(fpga_mgr_status_get);
  Get a status string, including failure information

EXPORT_SYMBOL_GPL(fpga_mgr_name);
  Get name of FPGA manager

EXPORT_SYMBOL_GPL(register_fpga_manager);
EXPORT_SYMBOL_GPL(remove_fpga_manager);
  Register/unregister low level fpga driver

TODO: Add interface to set FPGA in specific state such
  as reset.

All userspace interfaces are in separate files so that
they can be compiled out on production builds where
appropriate.

Signed-off-by: Alan Tull <atull@opensource.altera.com>
---
 drivers/Kconfig          |    2 +
 drivers/Makefile         |    1 +
 drivers/fpga/Kconfig     |   13 ++
 drivers/fpga/Makefile    |   10 ++
 drivers/fpga/fpga-mgr.c  |  403 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fpga-mgr.h |  121 ++++++++++++++
 6 files changed, 550 insertions(+)
 create mode 100644 drivers/fpga/Kconfig
 create mode 100644 drivers/fpga/Makefile
 create mode 100644 drivers/fpga/fpga-mgr.c
 create mode 100644 include/linux/fpga-mgr.h

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 0e87a34..b0cbbae 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -34,6 +34,8 @@ source "drivers/message/fusion/Kconfig"
 
 source "drivers/firewire/Kconfig"
 
+source "drivers/fpga/Kconfig"
+
 source "drivers/message/i2o/Kconfig"
 
 source "drivers/macintosh/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index f98b50d..afdd2aa 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -49,6 +49,7 @@ obj-$(CONFIG_RESET_CONTROLLER)	+= reset/
 # default.
 obj-y				+= tty/
 obj-y				+= char/
+obj-$(CONFIG_FPGA)		+= fpga/
 
 # gpu/ comes after char for AGP vs DRM startup
 obj-y				+= gpu/
diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
new file mode 100644
index 0000000..49293a3
--- /dev/null
+++ b/drivers/fpga/Kconfig
@@ -0,0 +1,13 @@
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
+endmenu
diff --git a/drivers/fpga/Makefile b/drivers/fpga/Makefile
new file mode 100644
index 0000000..c8a676f
--- /dev/null
+++ b/drivers/fpga/Makefile
@@ -0,0 +1,10 @@
+#
+# Makefile for the fpga framework and fpga manager drivers.
+#
+
+fpga-mgr-core-y += fpga-mgr.o
+
+# Core FPGA Manager Framework
+obj-$(CONFIG_FPGA)			+= fpga-mgr-core.o
+
+# FPGA Manager Drivers
diff --git a/drivers/fpga/fpga-mgr.c b/drivers/fpga/fpga-mgr.c
new file mode 100644
index 0000000..0e2eba4
--- /dev/null
+++ b/drivers/fpga/fpga-mgr.c
@@ -0,0 +1,403 @@
+/*
+ * FPGA Manager Core
+ *
+ *  Copyright (C) 2013-2014 Altera Corporation
+ *
+ * With code from the mailing list:
+ * Copyright (C) 2013 Xilinx, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#include <linux/delay.h>
+#include <linux/firmware.h>
+#include <linux/fpga-mgr.h>
+#include <linux/fs.h>
+#include <linux/idr.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pm.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/vmalloc.h>
+
+static DEFINE_IDA(fpga_mgr_ida);
+static int fpga_mgr_major;
+static struct class *fpga_mgr_class;
+
+#define FPGA_MAX_MINORS	256
+
+static DEFINE_MUTEX(fpga_manager_mutex);
+static LIST_HEAD(fpga_manager_list);
+
+/*
+ * Unlocked version of fpga_mgr_write function.
+ *  Does not touch flags.  So caller must grab the FPGA_MGR_BUSY bit
+ *  and update the FPGA_MGR_FAIL bit.
+ */
+static int __fpga_mgr_write(struct fpga_manager *mgr, const char *buf,
+			    size_t count)
+{
+	int ret;
+
+	if (mgr->mops->write_init) {
+		mgr->state = FPGA_MGR_WRITE_INIT;
+		ret = mgr->mops->write_init(mgr);
+		if (ret)
+			return ret;
+	}
+
+	mgr->state = FPGA_MGR_WRITE;
+	ret = mgr->mops->write(mgr, buf, count);
+	if (ret)
+		return ret;
+
+	if (mgr->mops->write_complete) {
+		mgr->state = FPGA_MGR_WRITE_COMPLETE;
+		ret = mgr->mops->write_complete(mgr);
+		if (ret)
+			return ret;
+	}
+
+	mgr->state = FPGA_MGR_WRITE_SUCCESS;
+
+	return 0;
+}
+
+int fpga_mgr_write(struct fpga_manager *mgr, const char *buf, size_t count)
+{
+	int ret;
+
+	if (test_and_set_bit_lock(FPGA_MGR_BUSY, &mgr->flags))
+		return -EBUSY;
+
+	dev_info(mgr->dev, "writing buffer to %s\n", mgr->name);
+
+	ret = __fpga_mgr_write(mgr, buf, count);
+	if (ret)
+		set_bit(FPGA_MGR_FAIL, &mgr->flags);
+	else
+		clear_bit(FPGA_MGR_FAIL, &mgr->flags);
+
+	clear_bit_unlock(FPGA_MGR_BUSY, &mgr->flags);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(fpga_mgr_write);
+
+/*
+ * Grab lock, request firmware, and write out to the FPGA.
+ * Update the state before each step to provide info on what step
+ * failed if there is a failure.
+ */
+int fpga_mgr_firmware_write(struct fpga_manager *mgr, const char *path)
+{
+	const struct firmware *fw;
+	int ret;
+
+	if (test_and_set_bit_lock(FPGA_MGR_BUSY, &mgr->flags))
+		return -EBUSY;
+
+	dev_info(mgr->dev, "writing %s to %s\n", path, mgr->name);
+
+	mgr->state = FPGA_MGR_FIRMWARE_REQ;
+	ret = request_firmware(&fw, path, mgr->dev);
+	if (ret)
+		goto fw_write_fail;
+
+	ret = __fpga_mgr_write(mgr, fw->data, fw->size);
+	if (ret)
+		goto fw_write_fail;
+
+	clear_bit(FPGA_MGR_FAIL, &mgr->flags);
+	clear_bit_unlock(FPGA_MGR_BUSY, &mgr->flags);
+
+	return 0;
+
+fw_write_fail:
+	set_bit(FPGA_MGR_FAIL, &mgr->flags);
+	clear_bit_unlock(FPGA_MGR_BUSY, &mgr->flags);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(fpga_mgr_firmware_write);
+
+int fpga_mgr_status_get(struct fpga_manager *mgr, char *buf)
+{
+	if (!mgr || !mgr->mops || !mgr->mops->status)
+		return -ENODEV;
+
+	return mgr->mops->status(mgr, buf);
+}
+EXPORT_SYMBOL_GPL(fpga_mgr_status_get);
+
+int fpga_mgr_name(struct fpga_manager *mgr, char *buf)
+{
+	if (!mgr)
+		return -ENODEV;
+
+	return sprintf(buf, "%s\n", mgr->name);
+}
+EXPORT_SYMBOL_GPL(fpga_mgr_name);
+
+static int fpga_mgr_get_new_minor(struct fpga_manager *mgr, int request_nr)
+{
+	int nr, start;
+
+	/* check specified minor number */
+	if (request_nr >= FPGA_MAX_MINORS) {
+		dev_err(mgr->parent, "Out of device minors (%d)\n", request_nr);
+		return -ENODEV;
+	}
+
+	/*
+	 * If request_nr == -1, dynamically allocate number.
+	 * If request_nr >= 0, attempt to get specific number.
+	 */
+	if (request_nr == -1)
+		start = 0;
+	else
+		start = request_nr;
+
+	nr = ida_simple_get(&fpga_mgr_ida, start, FPGA_MAX_MINORS, GFP_KERNEL);
+
+	/* return error code */
+	if (nr < 0)
+		return nr;
+
+	if ((request_nr != -1) && (request_nr != nr)) {
+		dev_err(mgr->parent,
+			"Could not get requested device minor (%d)\n", nr);
+		ida_simple_remove(&fpga_mgr_ida, nr);
+		return -ENODEV;
+	}
+
+	mgr->nr = nr;
+
+	return 0;
+}
+
+static void fpga_mgr_free_minor(int nr)
+{
+	ida_simple_remove(&fpga_mgr_ida, nr);
+}
+
+const char *state_str[] = {
+	"default",
+	"firmware_request",
+	"write_init",
+	"write",
+	"write_complete",
+	"write_success",
+	"read_init",
+	"read",
+	"read_complete",
+	"read_done",
+};
+
+/*
+ * Provide status as: [state] [fail] [busy] such as
+ *  'firmware_request fail' = failed to load firmware image from filesystem
+ *  'write fail'            = failed while writing to FPGA
+ *  'write_success'         = after writing, low level driver returns success
+ */
+static int fpga_mgr_ops_framework_status(struct fpga_manager *mgr, char *buf)
+{
+	int ret = 0, flags = mgr->flags;
+
+	ret += sprintf(buf + ret, state_str[mgr->state]);
+
+	if (flags & BIT(FPGA_MGR_FAIL))
+		ret += sprintf(buf + ret, " fail");
+
+	if (flags & BIT(FPGA_MGR_BUSY))
+		ret += sprintf(buf + ret, " busy");
+
+	ret += sprintf(buf + ret, "\n");
+
+	return ret;
+}
+
+static int fpga_mgr_suspend(struct device *dev)
+{
+	struct fpga_manager *mgr = dev_get_drvdata(dev);
+
+	if (!mgr)
+		return -ENODEV;
+
+	if (mgr->mops->suspend)
+		return mgr->mops->suspend(mgr);
+
+	return 0;
+}
+
+static int fpga_mgr_resume(struct device *dev)
+{
+	struct fpga_manager *mgr = dev_get_drvdata(dev);
+	int ret = 0;
+
+	if (!mgr)
+		return -ENODEV;
+
+	if (mgr->mops->resume) {
+		ret = mgr->mops->resume(mgr);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+const struct dev_pm_ops fpga_mgr_dev_pm_ops = {
+	.suspend	= fpga_mgr_suspend,
+	.resume		= fpga_mgr_resume,
+};
+
+int register_fpga_manager(struct platform_device *pdev,
+			  struct fpga_manager_ops *mops,
+			  const char *name,
+			  unsigned int num_areas,
+			  void *priv)
+{
+	struct fpga_manager *mgr;
+	int ret;
+
+	BUG_ON(!mops || !name || !strlen(name));
+
+	mgr = devm_kzalloc(&pdev->dev, sizeof(struct fpga_manager), GFP_KERNEL);
+	if (!mgr)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, mgr);
+	mgr->mops = mops;
+
+	/* implementing status() for each fpga manager is optional */
+	if (!mgr->mops->status)
+		mgr->mops->status = fpga_mgr_ops_framework_status;
+
+	mgr->np = pdev->dev.of_node;
+	mgr->parent = get_device(&pdev->dev);
+	mgr->priv = priv;
+	mgr->name = name;
+	mgr->num_areas = num_areas;
+	init_completion(&mgr->status_complete);
+
+	ret = fpga_mgr_get_new_minor(mgr, pdev->id);
+	if (ret)
+		goto error_kfree;
+
+	if (mops->isr) {
+		mgr->irq = irq_of_parse_and_map(mgr->np, 0);
+		if (mgr->irq == NO_IRQ) {
+			dev_err(mgr->parent, "failed to map interrupt\n");
+			goto error_irq_map;
+		}
+
+		ret = request_irq(mgr->irq, mops->isr, 0, "fpga-mgr", mgr);
+		if (ret < 0) {
+			dev_err(mgr->parent, "error requesting interrupt\n");
+			goto error_irq_req;
+		}
+	}
+
+	mgr->dev = device_create(fpga_mgr_class, mgr->parent, MKDEV(0, 0), mgr,
+				 "fpga%d", mgr->nr);
+	if (IS_ERR(mgr->dev)) {
+		ret = PTR_ERR(mgr->dev);
+		goto error_device;
+	}
+
+	fpga_mgr_class->pm = &fpga_mgr_dev_pm_ops;
+
+	dev_info(mgr->parent, "fpga manager [%s] registered as minor %d\n",
+		 mgr->name, mgr->nr);
+
+	INIT_LIST_HEAD(&mgr->list);
+	mutex_lock(&fpga_manager_mutex);
+	list_add(&mgr->list, &fpga_manager_list);
+	mutex_unlock(&fpga_manager_mutex);
+
+	return 0;
+
+error_device:
+	cdev_del(&mgr->cdev);
+	free_irq(mgr->irq, mgr);
+error_irq_req:
+	irq_dispose_mapping(mgr->irq);
+error_irq_map:
+	fpga_mgr_free_minor(mgr->nr);
+error_kfree:
+	put_device(mgr->parent);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(register_fpga_manager);
+
+void remove_fpga_manager(struct platform_device *pdev)
+{
+	struct fpga_manager *mgr = platform_get_drvdata(pdev);
+
+	if (!mgr)
+		return;
+
+	if (mgr->mops->fpga_remove)
+		mgr->mops->fpga_remove(mgr);
+
+	mutex_lock(&fpga_manager_mutex);
+	list_del(&mgr->list);
+	mutex_unlock(&fpga_manager_mutex);
+
+	device_destroy(fpga_mgr_class, MKDEV(fpga_mgr_major, mgr->nr));
+	cdev_del(&mgr->cdev);
+	free_irq(mgr->irq, mgr);
+	irq_dispose_mapping(mgr->irq);
+	fpga_mgr_free_minor(mgr->nr);
+	put_device(mgr->parent);
+}
+EXPORT_SYMBOL_GPL(remove_fpga_manager);
+
+static int __init fpga_mgr_dev_init(void)
+{
+	dev_t fpga_mgr_dev;
+	int ret;
+
+	pr_info("FPGA Manager framework driver\n");
+
+	fpga_mgr_class = class_create(THIS_MODULE, "fpga_manager");
+	if (IS_ERR(fpga_mgr_class))
+		return PTR_ERR(fpga_mgr_class);
+
+	ret = alloc_chrdev_region(&fpga_mgr_dev, 0, FPGA_MAX_MINORS,
+				  "fpga_manager");
+	if (ret) {
+		class_destroy(fpga_mgr_class);
+		return ret;
+	}
+
+	fpga_mgr_major = MAJOR(fpga_mgr_dev);
+
+	return 0;
+}
+
+static void __exit fpga_mgr_dev_exit(void)
+{
+	unregister_chrdev_region(MKDEV(fpga_mgr_major, 0), FPGA_MAX_MINORS);
+	class_destroy(fpga_mgr_class);
+	ida_destroy(&fpga_mgr_ida);
+}
+
+MODULE_AUTHOR("Alan Tull <atull@opensource.altera.com>");
+MODULE_DESCRIPTION("FPGA Manager framework driver");
+MODULE_LICENSE("GPL v2");
+
+subsys_initcall(fpga_mgr_dev_init);
+module_exit(fpga_mgr_dev_exit);
diff --git a/include/linux/fpga-mgr.h b/include/linux/fpga-mgr.h
new file mode 100644
index 0000000..6af0873
--- /dev/null
+++ b/include/linux/fpga-mgr.h
@@ -0,0 +1,121 @@
+/*
+ * FPGA Framework
+ *
+ *  Copyright (C) 2013-2014 Altera Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#include <linux/configfs.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/cdev.h>
+#include <linux/of.h>
+#include <linux/interrupt.h>
+#include <linux/completion.h>
+
+#ifndef _LINUX_FPGA_MGR_H
+#define _LINUX_FPGA_MGR_H
+
+struct fpga_manager;
+
+/*
+ * fpga_manager_ops are the low level functions implemented by a specific
+ * fpga manager driver.  Leaving any of these out that aren't needed is fine
+ * as they are all tested for NULL before being called.
+ */
+struct fpga_manager_ops {
+	/* Returns a string of the FPGA's status */
+	int (*status)(struct fpga_manager *mgr, char *buf);
+
+	/* Prepare the FPGA for reading its confuration data */
+	int (*read_init)(struct fpga_manager *mgr);
+
+	/* Read count bytes configuration data from the FPGA */
+	ssize_t (*read)(struct fpga_manager *mgr, char *buf, size_t count);
+
+	/* Return FPGA to a default state after reading is done */
+	int (*read_complete)(struct fpga_manager *mgr);
+
+	/* Prepare the FPGA to receive confuration data */
+	int (*write_init)(struct fpga_manager *mgr);
+
+	/* Write count bytes of configuration data to the FPGA */
+	int (*write)(struct fpga_manager *mgr, const char *buf, size_t count);
+
+	/* Return FPGA to default state after writing is done */
+	int (*write_complete)(struct fpga_manager *mgr);
+
+	/* Optional: Set FPGA into a specific state during driver remove */
+	void (*fpga_remove)(struct fpga_manager *mgr);
+
+	int (*suspend)(struct fpga_manager *mgr);
+
+	int (*resume)(struct fpga_manager *mgr);
+
+	/* FPGA mangager isr */
+	irqreturn_t (*isr)(int irq, void *dev_id);
+};
+
+/* flag bits */
+#define FPGA_MGR_BUSY		0
+#define FPGA_MGR_FAIL           1
+
+/* States */
+enum fpga_mgr_states {
+	FPGA_MGR_DEFAULT,
+	FPGA_MGR_FIRMWARE_REQ,
+	FPGA_MGR_WRITE_INIT,
+	FPGA_MGR_WRITE,
+	FPGA_MGR_WRITE_COMPLETE,
+	FPGA_MGR_WRITE_SUCCESS,
+	FPGA_MGR_READ_INIT,
+	FPGA_MGR_READ,
+	FPGA_MGR_READ_COMPLETE,
+	FPGA_MGR_READ_DONE,
+};
+
+struct fpga_manager {
+	const char *name;
+	int nr;
+	struct device_node *np;
+	struct device *parent;
+	struct device *dev;
+	struct cdev cdev;
+	struct configfs_subsystem configfs;
+
+	struct list_head list;
+
+	int irq;
+	struct completion status_complete;
+	unsigned long flags;
+	enum fpga_mgr_states state;
+	struct fpga_manager_ops *mops;
+	void *priv;
+};
+
+#if IS_ENABLED(CONFIG_FPGA)
+
+int fpga_mgr_firmware_write(struct fpga_manager *mgr, const char *path);
+int fpga_mgr_write(struct fpga_manager *mgr, const char *buf, size_t count);
+int fpga_mgr_status_get(struct fpga_manager *mgr, char *buf);
+int fpga_mgr_name(struct fpga_manager *mgr, char *buf);
+
+int register_fpga_manager(struct platform_device *pdev,
+			  struct fpga_manager_ops *mops,
+			  const char *name,
+			  void *priv);
+
+void remove_fpga_manager(struct platform_device *pdev);
+
+#endif /* CONFIG_FPGA */
+#endif /*_LINUX_FPGA_MGR_H */
-- 
1.7.9.5

