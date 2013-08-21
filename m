Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab3HURwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 13:52:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:6020 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760Ab3HURwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 13:52:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,929,1367996400"; 
   d="scan'208";a="349731691"
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux-doc@vger.kernel.org,
        Asias He <asias@redhat.com>
Cc: Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Caz Yokoyama <Caz.Yokoyama@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
Subject: [PATCH v3 4/7] Intel MIC Card Driver for X100 family.
Date: Wed, 21 Aug 2013 10:51:40 -0700
Message-Id: <4a1008f86a8a976994e5113c1aa983900f47e5c4.1377104309.git.sudeep.dutt@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1377104309.git.sudeep.dutt@intel.com>
References: <cover.1377104309.git.sudeep.dutt@intel.com>
In-Reply-To: <cover.1377104309.git.sudeep.dutt@intel.com>
References: <cover.1377104309.git.sudeep.dutt@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does the following:
a) Initializes the Intel MIC X100 platform device and driver.
b) Sets up support to handle shutdown requests from the host.
c) Maps the device page after obtaining the device page address
from the scratchpad registers updated by the host.
d) Informs the host upon a card crash by registering a panic notifier.
e) Informs the host upon a poweroff/halt event.

Co-author: Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Caz Yokoyama <Caz.Yokoyama@intel.com>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>
Signed-off-by: Nikhil Rao <nikhil.rao@intel.com>
Signed-off-by: Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>
Signed-off-by: Sudeep Dutt <sudeep.dutt@intel.com>
Acked-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
Reviewed-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
---
 drivers/misc/mic/Kconfig            |  18 +++
 drivers/misc/mic/Makefile           |   1 +
 drivers/misc/mic/card/Makefile      |  10 ++
 drivers/misc/mic/card/mic_debugfs.c | 130 ++++++++++++++++
 drivers/misc/mic/card/mic_device.c  | 299 ++++++++++++++++++++++++++++++++++++
 drivers/misc/mic/card/mic_device.h  | 133 ++++++++++++++++
 drivers/misc/mic/card/mic_x100.c    | 256 ++++++++++++++++++++++++++++++
 drivers/misc/mic/card/mic_x100.h    |  48 ++++++
 8 files changed, 895 insertions(+)
 create mode 100644 drivers/misc/mic/card/Makefile
 create mode 100644 drivers/misc/mic/card/mic_debugfs.c
 create mode 100644 drivers/misc/mic/card/mic_device.c
 create mode 100644 drivers/misc/mic/card/mic_device.h
 create mode 100644 drivers/misc/mic/card/mic_x100.c
 create mode 100644 drivers/misc/mic/card/mic_x100.h

diff --git a/drivers/misc/mic/Kconfig b/drivers/misc/mic/Kconfig
index aaefd0c..279a2e6 100644
--- a/drivers/misc/mic/Kconfig
+++ b/drivers/misc/mic/Kconfig
@@ -17,3 +17,21 @@ config INTEL_MIC_HOST
 	  More information about the Intel MIC family as well as the Linux
 	  OS and tools for MIC to use with this driver are available from
 	  <http://software.intel.com/en-us/mic-developer>.
+
+comment "Intel MIC Card Driver"
+
+config INTEL_MIC_CARD
+	tristate "Intel MIC Card Driver"
+	depends on 64BIT
+	default N
+	help
+	  This enables card driver support for the Intel Many Integrated
+	  Core (MIC) device family. The card driver communicates shutdown/
+	  crash events to the host and allows registration/configuration of
+	  virtio devices. Intel MIC X100 devices are currently supported.
+
+	  If you are building a card kernel for an Intel MIC device then
+	  say M (recommended) or Y, else say N. If unsure say N.
+
+	  For more information see
+	  <http://software.intel.com/en-us/mic-developer>.
diff --git a/drivers/misc/mic/Makefile b/drivers/misc/mic/Makefile
index 8e72421..05b34d6 100644
--- a/drivers/misc/mic/Makefile
+++ b/drivers/misc/mic/Makefile
@@ -3,3 +3,4 @@
 # Copyright(c) 2013, Intel Corporation.
 #
 obj-$(CONFIG_INTEL_MIC_HOST) += host/
+obj-$(CONFIG_INTEL_MIC_CARD) += card/
diff --git a/drivers/misc/mic/card/Makefile b/drivers/misc/mic/card/Makefile
new file mode 100644
index 0000000..6e9675e
--- /dev/null
+++ b/drivers/misc/mic/card/Makefile
@@ -0,0 +1,10 @@
+#
+# Makefile - Intel MIC Linux driver.
+# Copyright(c) 2013, Intel Corporation.
+#
+ccflags-y += -DINTEL_MIC_CARD
+
+obj-$(CONFIG_INTEL_MIC_CARD) += mic_card.o
+mic_card-y += mic_x100.o
+mic_card-y += mic_device.o
+mic_card-y += mic_debugfs.o
diff --git a/drivers/misc/mic/card/mic_debugfs.c b/drivers/misc/mic/card/mic_debugfs.c
new file mode 100644
index 0000000..95cf186
--- /dev/null
+++ b/drivers/misc/mic/card/mic_debugfs.c
@@ -0,0 +1,130 @@
+/*
+ * Intel MIC Platform Software Stack (MPSS)
+ *
+ * Copyright(c) 2013 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * The full GNU General Public License is included in this distribution in
+ * the file called "COPYING".
+ *
+ * Disclaimer: The codes contained in these modules may be specific to
+ * the Intel Software Development Platform codenamed: Knights Ferry, and
+ * the Intel product codenamed: Knights Corner, and are not backward
+ * compatible with other Intel products. Additionally, Intel will NOT
+ * support the codes or instruction set in future products.
+ *
+ * Intel MIC Card driver.
+ *
+ */
+#include <linux/debugfs.h>
+#include <linux/delay.h>
+#include <linux/seq_file.h>
+#include <linux/interrupt.h>
+#include <linux/device.h>
+
+#include "../common/mic_device.h"
+#include "mic_device.h"
+
+/* Debugfs parent dir */
+static struct dentry *mic_dbg;
+
+/**
+ * mic_intr_test - Send interrupts to host.
+ */
+static int mic_intr_test(struct seq_file *s, void *unused)
+{
+	struct mic_driver *mdrv = s->private;
+	struct mic_device *mdev = &mdrv->mdev;
+
+	mic_send_intr(mdev, 0);
+	msleep(1000);
+	mic_send_intr(mdev, 1);
+	msleep(1000);
+	mic_send_intr(mdev, 2);
+	msleep(1000);
+	mic_send_intr(mdev, 3);
+	msleep(1000);
+
+	return 0;
+}
+
+static int mic_intr_test_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, mic_intr_test, inode->i_private);
+}
+
+static int mic_intr_test_release(struct inode *inode, struct file *file)
+{
+	return single_release(inode, file);
+}
+
+static const struct file_operations intr_test_ops = {
+	.owner   = THIS_MODULE,
+	.open    = mic_intr_test_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = mic_intr_test_release
+};
+
+/**
+ * mic_create_card_debug_dir - Initialize MIC debugfs entries.
+ */
+void __init mic_create_card_debug_dir(struct mic_driver *mdrv)
+{
+	struct dentry *d;
+
+	if (!mic_dbg)
+		return;
+
+	mdrv->dbg_dir = debugfs_create_dir(mdrv->name, mic_dbg);
+	if (!mdrv->dbg_dir) {
+		dev_err(mdrv->dev, "Cant create dbg_dir %s\n", mdrv->name);
+		return;
+	}
+
+	d = debugfs_create_file("intr_test", 0444, mdrv->dbg_dir,
+		mdrv, &intr_test_ops);
+
+	if (!d) {
+		dev_err(mdrv->dev,
+			"Cant create dbg intr_test %s\n", mdrv->name);
+		return;
+	}
+}
+
+/**
+ * mic_delete_card_debug_dir - Uninitialize MIC debugfs entries.
+ */
+void mic_delete_card_debug_dir(struct mic_driver *mdrv)
+{
+	if (!mdrv->dbg_dir)
+		return;
+
+	debugfs_remove_recursive(mdrv->dbg_dir);
+}
+
+/**
+ * mic_init_card_debugfs - Initialize global debugfs entry.
+ */
+void __init mic_init_card_debugfs(void)
+{
+	mic_dbg = debugfs_create_dir(KBUILD_MODNAME, NULL);
+	if (!mic_dbg)
+		pr_err("can't create debugfs dir\n");
+}
+
+/**
+ * mic_exit_card_debugfs - Uninitialize global debugfs entry
+ */
+void mic_exit_card_debugfs(void)
+{
+	debugfs_remove(mic_dbg);
+}
diff --git a/drivers/misc/mic/card/mic_device.c b/drivers/misc/mic/card/mic_device.c
new file mode 100644
index 0000000..3c5c302
--- /dev/null
+++ b/drivers/misc/mic/card/mic_device.c
@@ -0,0 +1,299 @@
+/*
+ * Intel MIC Platform Software Stack (MPSS)
+ *
+ * Copyright(c) 2013 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * The full GNU General Public License is included in this distribution in
+ * the file called "COPYING".
+ *
+ * Disclaimer: The codes contained in these modules may be specific to
+ * the Intel Software Development Platform codenamed: Knights Ferry, and
+ * the Intel product codenamed: Knights Corner, and are not backward
+ * compatible with other Intel products. Additionally, Intel will NOT
+ * support the codes or instruction set in future products.
+ *
+ * Intel MIC Card driver.
+ *
+ */
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/interrupt.h>
+#include <linux/reboot.h>
+
+#include <linux/mic_common.h>
+#include "../common/mic_device.h"
+#include "mic_device.h"
+
+static struct mic_driver *g_drv;
+static struct mic_irq *shutdown_cookie;
+
+static void mic_notify_host(u8 state)
+{
+	struct mic_driver *mdrv = g_drv;
+	struct mic_bootparam __iomem *bootparam = mdrv->dp;
+
+	iowrite8(state, &bootparam->shutdown_status);
+	dev_dbg(mdrv->dev, "%s %d system_state %d\n",
+		__func__, __LINE__, state);
+	mic_send_intr(&mdrv->mdev, ioread8(&bootparam->c2h_shutdown_db));
+}
+
+static int mic_panic_event(struct notifier_block *this, unsigned long event,
+		void *ptr)
+{
+	struct mic_driver *mdrv = g_drv;
+	struct mic_bootparam __iomem *bootparam = mdrv->dp;
+
+	iowrite8(-1, &bootparam->h2c_config_db);
+	iowrite8(-1, &bootparam->h2c_shutdown_db);
+	mic_notify_host(MIC_CRASHED);
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block mic_panic = {
+	.notifier_call  = mic_panic_event,
+};
+
+static irqreturn_t mic_shutdown_isr(int irq, void *data)
+{
+	struct mic_driver *mdrv = g_drv;
+	struct mic_bootparam __iomem *bootparam = mdrv->dp;
+
+	mic_ack_interrupt(&g_drv->mdev);
+	if (ioread8(&bootparam->shutdown_card))
+		orderly_poweroff(true);
+	return IRQ_HANDLED;
+}
+
+static int mic_shutdown_init(void)
+{
+	int rc = 0;
+	struct mic_driver *mdrv = g_drv;
+	struct mic_bootparam __iomem *bootparam = mdrv->dp;
+	int shutdown_db;
+
+	shutdown_db = mic_next_card_db();
+	shutdown_cookie = mic_request_card_irq(mic_shutdown_isr,
+			"Shutdown", mdrv, shutdown_db);
+	if (IS_ERR(shutdown_cookie))
+		rc = PTR_ERR(shutdown_cookie);
+	else
+		iowrite8(shutdown_db, &bootparam->h2c_shutdown_db);
+	return rc;
+}
+
+static void mic_shutdown_uninit(void)
+{
+	struct mic_driver *mdrv = g_drv;
+	struct mic_bootparam __iomem *bootparam = mdrv->dp;
+
+	iowrite8(-1, &bootparam->h2c_shutdown_db);
+	mic_free_card_irq(shutdown_cookie, mdrv);
+}
+
+static int __init mic_dp_init(void)
+{
+	struct mic_driver *mdrv = g_drv;
+	struct mic_device *mdev = &mdrv->mdev;
+	struct mic_bootparam __iomem *bootparam;
+	u64 lo, hi, dp_dma_addr;
+	u32 magic;
+
+	lo = mic_read_spad(&mdrv->mdev, MIC_DPLO_SPAD);
+	hi = mic_read_spad(&mdrv->mdev, MIC_DPHI_SPAD);
+
+	dp_dma_addr = lo | (hi << 32);
+	mdrv->dp = mic_card_map(mdev, dp_dma_addr, MIC_DP_SIZE);
+	if (!mdrv->dp) {
+		dev_err(mdrv->dev, "Cannot remap Aperture BAR\n");
+		return -ENOMEM;
+	}
+	bootparam = mdrv->dp;
+	magic = ioread32(&bootparam->magic);
+	if (MIC_MAGIC != magic) {
+		dev_err(mdrv->dev, "bootparam magic mismatch 0x%x\n", magic);
+		return -EIO;
+	}
+	return 0;
+}
+
+/* Uninitialize the device page */
+static void mic_dp_uninit(void)
+{
+	mic_card_unmap(&g_drv->mdev, g_drv->dp);
+}
+
+/**
+ * mic_request_card_irq - request an irq.
+ *
+ * @func: The callback function that handles the interrupt.
+ * @name: The ASCII name of the callee requesting the irq.
+ * @data: private data that is returned back when calling the
+ * function handler.
+ * @index: The doorbell index of the requester.
+ *
+ * returns: The cookie that is transparent to the caller. Passed
+ * back when calling mic_free_irq. An appropriate error code
+ * is returned on failure. Caller needs to use IS_ERR(return_val)
+ * to check for failure and PTR_ERR(return_val) to obtained the
+ * error code.
+ *
+ */
+struct mic_irq *mic_request_card_irq(irqreturn_t (*func)(int irq, void *data),
+	const char *name, void *data, int index)
+{
+	int rc = 0;
+	unsigned long cookie;
+	struct mic_driver *mdrv = g_drv;
+
+	rc  = request_irq(mic_db_to_irq(mdrv, index), func,
+		0, name, data);
+	if (rc) {
+		dev_err(mdrv->dev, "request_irq failed rc = %d\n", rc);
+		goto err;
+	}
+	mdrv->irq_info.irq_usage_count[index]++;
+	cookie = index;
+	return (struct mic_irq *)cookie;
+err:
+	return ERR_PTR(rc);
+
+}
+
+/**
+ * mic_free_card_irq - free irq.
+ *
+ * @cookie: cookie obtained during a successful call to mic_request_irq
+ * @data: private data specified by the calling function during the
+ * mic_request_irq
+ *
+ * returns: none.
+ */
+void mic_free_card_irq(struct mic_irq *cookie, void *data)
+{
+	int index;
+	struct mic_driver *mdrv = g_drv;
+
+	index = (unsigned long)cookie & 0xFFFFU;
+	free_irq(mic_db_to_irq(mdrv, index), data);
+	mdrv->irq_info.irq_usage_count[index]--;
+}
+
+/**
+ * mic_next_card_db - Get the doorbell with minimum usage count.
+ *
+ * Returns the irq index.
+ */
+int mic_next_card_db(void)
+{
+	int i;
+	int index = 0;
+	struct mic_driver *mdrv = g_drv;
+
+	for (i = 0; i < mdrv->intr_info.num_intr; i++) {
+		if (mdrv->irq_info.irq_usage_count[i] <
+			mdrv->irq_info.irq_usage_count[index])
+			index = i;
+	}
+
+	return index;
+}
+
+/**
+ * mic_init_irq - Initialize irq information.
+ *
+ * Returns 0 in success. Appropriate error code on failure.
+ */
+static int mic_init_irq(void)
+{
+	struct mic_driver *mdrv = g_drv;
+
+	mdrv->irq_info.irq_usage_count = kzalloc((sizeof(u32) *
+			mdrv->intr_info.num_intr),
+			GFP_KERNEL);
+	if (!mdrv->irq_info.irq_usage_count)
+		return -ENOMEM;
+	return 0;
+}
+
+/**
+ * mic_uninit_irq - Uninitialize irq information.
+ *
+ * None.
+ */
+static void mic_uninit_irq(void)
+{
+	struct mic_driver *mdrv = g_drv;
+
+	kfree(mdrv->irq_info.irq_usage_count);
+}
+
+/*
+ * mic_driver_init - MIC driver initialization tasks.
+ *
+ * Returns 0 in success. Appropriate error code on failure.
+ */
+int __init mic_driver_init(struct mic_driver *mdrv)
+{
+	int rc;
+
+	g_drv = mdrv;
+	/*
+	 * Unloading the card module is not supported. The MIC card module
+	 * handles fundamental operations like host/card initiated shutdowns
+	 * and informing the host about card crashes and cannot be unloaded.
+	 */
+	if (!try_module_get(mdrv->dev->driver->owner)) {
+		rc = -ENODEV;
+		goto done;
+	}
+	rc = mic_dp_init();
+	if (rc)
+		goto put;
+	rc = mic_init_irq();
+	if (rc)
+		goto dp_uninit;
+	rc = mic_shutdown_init();
+	if (rc)
+		goto irq_uninit;
+	mic_create_card_debug_dir(mdrv);
+	atomic_notifier_chain_register(&panic_notifier_list, &mic_panic);
+done:
+	return rc;
+irq_uninit:
+	mic_uninit_irq();
+dp_uninit:
+	mic_dp_uninit();
+put:
+	module_put(mdrv->dev->driver->owner);
+	return rc;
+}
+
+/*
+ * mic_driver_uninit - MIC driver uninitialization tasks.
+ *
+ * Returns None
+ */
+void mic_driver_uninit(struct mic_driver *mdrv)
+{
+	mic_delete_card_debug_dir(mdrv);
+	/*
+	 * Inform the host about the shutdown status i.e. poweroff/restart etc.
+	 * The module cannot be unloaded so the only code path to call
+	 * mic_devices_uninit(..) is the shutdown callback.
+	 */
+	mic_notify_host(system_state);
+	mic_shutdown_uninit();
+	mic_uninit_irq();
+	mic_dp_uninit();
+	module_put(mdrv->dev->driver->owner);
+}
diff --git a/drivers/misc/mic/card/mic_device.h b/drivers/misc/mic/card/mic_device.h
new file mode 100644
index 0000000..347b9b3
--- /dev/null
+++ b/drivers/misc/mic/card/mic_device.h
@@ -0,0 +1,133 @@
+/*
+ * Intel MIC Platform Software Stack (MPSS)
+ *
+ * Copyright(c) 2013 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * The full GNU General Public License is included in this distribution in
+ * the file called "COPYING".
+ *
+ * Disclaimer: The codes contained in these modules may be specific to
+ * the Intel Software Development Platform codenamed: Knights Ferry, and
+ * the Intel product codenamed: Knights Corner, and are not backward
+ * compatible with other Intel products. Additionally, Intel will NOT
+ * support the codes or instruction set in future products.
+ *
+ * Intel MIC Card driver.
+ *
+ */
+#ifndef _MIC_CARD_DEVICE_H_
+#define _MIC_CARD_DEVICE_H_
+
+#include <linux/workqueue.h>
+#include <linux/io.h>
+
+/**
+ * struct mic_intr_info - Contains h/w specific interrupt sources info
+ *
+ * @num_intr: The number of irqs available
+ */
+struct mic_intr_info {
+	u32 num_intr;
+};
+
+/**
+ * struct mic_irq_info - OS specific irq information
+ *
+ * @irq_usage_count: usage count array tracking the number of sources
+ * assigned for each irq.
+ */
+struct mic_irq_info {
+	int *irq_usage_count;
+};
+
+/**
+ * struct mic_device -  MIC device information.
+ *
+ * @mmio: MMIO bar information.
+ */
+struct mic_device {
+	struct mic_mw mmio;
+};
+
+/**
+ * struct mic_driver - MIC card driver information.
+ *
+ * @name: Name for MIC driver.
+ * @dbg_dir: debugfs directory of this MIC device.
+ * @dev: The device backing this MIC.
+ * @dp: The pointer to the virtio device page.
+ * @mdev: MIC device information for the host.
+ * @hotplug_work: Hot plug work for adding/removing virtio devices.
+ * @irq_info: The OS specific irq information
+ * @intr_info: H/W specific interrupt information.
+ */
+struct mic_driver {
+	char name[20];
+	struct dentry *dbg_dir;
+	struct device *dev;
+	void __iomem *dp;
+	struct mic_device mdev;
+	struct work_struct hotplug_work;
+	struct mic_irq_info irq_info;
+	struct mic_intr_info intr_info;
+};
+
+/**
+ * struct mic_irq - opaque pointer used as cookie
+ */
+struct mic_irq;
+
+/**
+ * mic_mmio_read - read from an MMIO register.
+ * @mw: MMIO register base virtual address.
+ * @offset: register offset.
+ *
+ * RETURNS: register value.
+ */
+static inline u32 mic_mmio_read(struct mic_mw *mw, u32 offset)
+{
+	return ioread32(mw->va + offset);
+}
+
+/**
+ * mic_mmio_write - write to an MMIO register.
+ * @mw: MMIO register base virtual address.
+ * @val: the data value to put into the register
+ * @offset: register offset.
+ *
+ * RETURNS: none.
+ */
+static inline void
+mic_mmio_write(struct mic_mw *mw, u32 val, u32 offset)
+{
+	iowrite32(val, mw->va + offset);
+}
+
+int mic_driver_init(struct mic_driver *mdrv);
+void mic_driver_uninit(struct mic_driver *mdrv);
+int mic_next_card_db(void);
+struct mic_irq *mic_request_card_irq(irqreturn_t (*func)(int irq, void *data),
+	const char *name, void *data, int intr_src);
+void mic_free_card_irq(struct mic_irq *cookie, void *data);
+u32 mic_read_spad(struct mic_device *mdev, unsigned int idx);
+void mic_send_intr(struct mic_device *mdev, int doorbell);
+int mic_db_to_irq(struct mic_driver *mdrv, int db);
+u32 mic_ack_interrupt(struct mic_device *mdev);
+void mic_hw_intr_init(struct mic_driver *mdrv);
+void __iomem *
+mic_card_map(struct mic_device *mdev, dma_addr_t addr, size_t size);
+void mic_card_unmap(struct mic_device *mdev, void __iomem *addr);
+void __init mic_create_card_debug_dir(struct mic_driver *mdrv);
+void mic_delete_card_debug_dir(struct mic_driver *mdrv);
+void __init mic_init_card_debugfs(void);
+void mic_exit_card_debugfs(void);
+#endif
diff --git a/drivers/misc/mic/card/mic_x100.c b/drivers/misc/mic/card/mic_x100.c
new file mode 100644
index 0000000..7cb3469
--- /dev/null
+++ b/drivers/misc/mic/card/mic_x100.c
@@ -0,0 +1,256 @@
+/*
+ * Intel MIC Platform Software Stack (MPSS)
+ *
+ * Copyright(c) 2013 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * The full GNU General Public License is included in this distribution in
+ * the file called "COPYING".
+ *
+ * Disclaimer: The codes contained in these modules may be specific to
+ * the Intel Software Development Platform codenamed: Knights Ferry, and
+ * the Intel product codenamed: Knights Corner, and are not backward
+ * compatible with other Intel products. Additionally, Intel will NOT
+ * support the codes or instruction set in future products.
+ *
+ * Intel MIC Card driver.
+ *
+ */
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/platform_device.h>
+
+#include "../common/mic_device.h"
+#include "mic_device.h"
+#include "mic_x100.h"
+
+static const char mic_driver_name[] = "mic";
+
+static struct mic_driver g_drv;
+
+/**
+ * mic_read_spad - read from the scratchpad register
+ * @mdev: pointer to mic_device instance
+ * @idx: index to scratchpad register, 0 based
+ *
+ * This function allows reading of the 32bit scratchpad register.
+ *
+ * RETURNS: An appropriate -ERRNO error value on error, or zero for success.
+ */
+u32 mic_read_spad(struct mic_device *mdev, unsigned int idx)
+{
+	return mic_mmio_read(&mdev->mmio,
+		MIC_X100_SBOX_BASE_ADDRESS +
+		MIC_X100_SBOX_SPAD0 + idx * 4);
+}
+
+/**
+ * __mic_send_intr - Send interrupt to Host.
+ * @mdev: pointer to mic_device instance
+ * @doorbell: Doorbell number.
+ */
+void mic_send_intr(struct mic_device *mdev, int doorbell)
+{
+	struct mic_mw *mw = &mdev->mmio;
+
+	if (doorbell > MIC_X100_MAX_DOORBELL_IDX)
+		return;
+	/* Ensure that the interrupt is ordered w.r.t previous stores. */
+	wmb();
+	mic_mmio_write(mw, MIC_X100_SBOX_SDBIC0_DBREQ_BIT,
+		MIC_X100_SBOX_BASE_ADDRESS +
+		(MIC_X100_SBOX_SDBIC0 + (4 * doorbell)));
+}
+
+/**
+ * mic_ack_interrupt - Device specific interrupt handling.
+ * @mdev: pointer to mic_device instance
+ *
+ * Returns: bitmask of doorbell events triggered.
+ */
+u32 mic_ack_interrupt(struct mic_device *mdev)
+{
+	return 0;
+}
+
+static inline int mic_get_sbox_irq(int db)
+{
+	return MIC_X100_IRQ_BASE + db;
+}
+
+static inline int mic_get_rdmasr_irq(int index)
+{
+	return  MIC_X100_RDMASR_IRQ_BASE + index;
+}
+
+/**
+ * mic_hw_intr_init - Initialize h/w specific interrupt
+ * information.
+ * @mdrv: pointer to mic_driver
+ */
+void mic_hw_intr_init(struct mic_driver *mdrv)
+{
+	mdrv->intr_info.num_intr = MIC_X100_NUM_SBOX_IRQ +
+				MIC_X100_NUM_RDMASR_IRQ;
+}
+
+/**
+ * mic_db_to_irq - Retrieve irq number corresponding to a doorbell.
+ * @mdrv: pointer to mic_driver
+ * @db: The doorbell obtained for which the irq is needed. Doorbell
+ * may correspond to an sbox doorbell or an rdmasr index.
+ *
+ * Returns the irq corresponding to the doorbell.
+ */
+int mic_db_to_irq(struct mic_driver *mdrv, int db)
+{
+	int rdmasr_index;
+	if (db < MIC_X100_NUM_SBOX_IRQ) {
+		return mic_get_sbox_irq(db);
+	} else {
+		rdmasr_index = db - MIC_X100_NUM_SBOX_IRQ +
+			MIC_X100_RDMASR_IRQ_BASE;
+		return mic_get_rdmasr_irq(rdmasr_index);
+	}
+}
+
+/*
+ * mic_card_map - Allocate virtual address for a remote memory region.
+ * @mdev: pointer to mic_device instance.
+ * @addr: Remote DMA address.
+ * @size: Size of the region.
+ *
+ * Returns: Virtual address backing the remote memory region.
+ */
+void __iomem *
+mic_card_map(struct mic_device *mdev, dma_addr_t addr, size_t size)
+{
+	return ioremap(addr, size);
+}
+
+/*
+ * mic_card_unmap - Unmap the virtual address for a remote memory region.
+ * @mdev: pointer to mic_device instance.
+ * @addr: Virtual address for remote memory region.
+ *
+ * Returns: None.
+ */
+void mic_card_unmap(struct mic_device *mdev, void __iomem *addr)
+{
+	iounmap(addr);
+}
+
+static int __init mic_probe(struct platform_device *pdev)
+{
+	struct mic_driver *mdrv = &g_drv;
+	struct mic_device *mdev = &mdrv->mdev;
+	int rc = 0;
+
+	mdrv->dev = &pdev->dev;
+	snprintf(mdrv->name, sizeof(mic_driver_name), mic_driver_name);
+
+	mdev->mmio.pa = MIC_X100_MMIO_BASE;
+	mdev->mmio.len = MIC_X100_MMIO_LEN;
+	mdev->mmio.va = ioremap(MIC_X100_MMIO_BASE, MIC_X100_MMIO_LEN);
+	if (!mdev->mmio.va) {
+		dev_err(&pdev->dev, "Cannot remap MMIO BAR\n");
+		rc = -EIO;
+		goto done;
+	}
+	mic_hw_intr_init(mdrv);
+	rc = mic_driver_init(mdrv);
+	if (rc) {
+		dev_err(&pdev->dev, "mic_driver_init failed rc %d\n", rc);
+		goto iounmap;
+	}
+done:
+	return rc;
+iounmap:
+	iounmap(mdev->mmio.va);
+	return rc;
+}
+
+static int mic_remove(struct platform_device *pdev)
+{
+	struct mic_driver *mdrv = &g_drv;
+	struct mic_device *mdev = &mdrv->mdev;
+
+	mic_driver_uninit(mdrv);
+	iounmap(mdev->mmio.va);
+	return 0;
+}
+
+static void mic_platform_shutdown(struct platform_device *pdev)
+{
+	mic_remove(pdev);
+}
+
+static struct platform_device mic_platform_dev = {
+	.name = mic_driver_name,
+	.id   = 0,
+	.num_resources = 0,
+};
+
+static struct platform_driver __refdata mic_platform_driver = {
+	.probe = mic_probe,
+	.remove = mic_remove,
+	.shutdown = mic_platform_shutdown,
+	.driver         = {
+		.name   = mic_driver_name,
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init mic_init(void)
+{
+	int ret;
+	struct cpuinfo_x86 *c = &cpu_data(0);
+
+	if (!(c->x86 == 11 && c->x86_model == 1)) {
+		ret = -ENODEV;
+		pr_err("%s not running on X100 ret %d\n", __func__, ret);
+		goto done;
+	}
+
+	mic_init_card_debugfs();
+	ret = platform_device_register(&mic_platform_dev);
+	if (ret) {
+		pr_err("platform_device_register ret %d\n", ret);
+		goto cleanup_debugfs;
+	}
+	ret = platform_driver_register(&mic_platform_driver);
+	if (ret) {
+		pr_err("platform_driver_register ret %d\n", ret);
+		goto device_unregister;
+	}
+	return ret;
+
+device_unregister:
+	platform_device_unregister(&mic_platform_dev);
+cleanup_debugfs:
+	mic_exit_card_debugfs();
+done:
+	return ret;
+}
+
+static void __exit mic_exit(void)
+{
+	platform_driver_unregister(&mic_platform_driver);
+	platform_device_unregister(&mic_platform_dev);
+	mic_exit_card_debugfs();
+}
+
+module_init(mic_init);
+module_exit(mic_exit);
+
+MODULE_AUTHOR("Intel Corporation");
+MODULE_DESCRIPTION("Intel(R) MIC X100 Card driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/misc/mic/card/mic_x100.h b/drivers/misc/mic/card/mic_x100.h
new file mode 100644
index 0000000..d66ea55
--- /dev/null
+++ b/drivers/misc/mic/card/mic_x100.h
@@ -0,0 +1,48 @@
+/*
+ * Intel MIC Platform Software Stack (MPSS)
+ *
+ * Copyright(c) 2013 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * The full GNU General Public License is included in this distribution in
+ * the file called "COPYING".
+ *
+ * Disclaimer: The codes contained in these modules may be specific to
+ * the Intel Software Development Platform codenamed: Knights Ferry, and
+ * the Intel product codenamed: Knights Corner, and are not backward
+ * compatible with other Intel products. Additionally, Intel will NOT
+ * support the codes or instruction set in future products.
+ *
+ * Intel MIC Card driver.
+ *
+ */
+#ifndef _MIC_X100_CARD_H_
+#define _MIC_X100_CARD_H_
+
+#define MIC_X100_MMIO_BASE 0x08007C0000ULL
+#define MIC_X100_MMIO_LEN 0x00020000ULL
+#define MIC_X100_SBOX_BASE_ADDRESS 0x00010000ULL
+
+#define MIC_X100_SBOX_SPAD0 0x0000AB20
+#define MIC_X100_SBOX_SDBIC0 0x0000CC90
+#define MIC_X100_SBOX_SDBIC0_DBREQ_BIT 0x80000000
+#define MIC_X100_SBOX_RDMASR0	0x0000B180
+
+#define MIC_X100_MAX_DOORBELL_IDX 8
+
+#define MIC_X100_NUM_SBOX_IRQ 8
+#define MIC_X100_NUM_RDMASR_IRQ 8
+#define MIC_X100_SBOX_IRQ_BASE 0
+#define MIC_X100_RDMASR_IRQ_BASE 17
+
+#define MIC_X100_IRQ_BASE 26
+
+#endif
-- 
1.8.2.1

