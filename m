Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab3BFMHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 07:07:20 -0500
Received: from mga11.intel.com ([192.55.52.93]:63458 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829Ab3BFMHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 07:07:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,615,1355126400"; 
   d="scan'208";a="287310808"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 1/6] mei: sperate interface and pci code into two files
Date: Wed,  6 Feb 2013 14:06:39 +0200
Message-Id: <1360152404-5769-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1360152404-5769-1-git-send-email-tomas.winkler@intel.com>
References: <1360152404-5769-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

leave misc file operations in the main
and move PCI related code into pci-me

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/Makefile  |    1 +
 drivers/misc/mei/main.c    |  354 ++--------------------------------------
 drivers/misc/mei/mei_dev.h |    3 +
 drivers/misc/mei/pci-me.c  |  393 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 409 insertions(+), 342 deletions(-)
 create mode 100644 drivers/misc/mei/pci-me.c

diff --git a/drivers/misc/mei/Makefile b/drivers/misc/mei/Makefile
index 9f71933..068f553 100644
--- a/drivers/misc/mei/Makefile
+++ b/drivers/misc/mei/Makefile
@@ -11,3 +11,4 @@ mei-objs += main.o
 mei-objs += amthif.o
 mei-objs += wd.o
 mei-objs += client.o
+mei-objs += pci-me.o
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 123c663..018623c 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -43,54 +43,6 @@
 #include "hw-me.h"
 #include "client.h"
 
-/* AMT device is a singleton on the platform */
-static struct pci_dev *mei_pdev;
-
-/* mei_pci_tbl - PCI Device ID Table */
-static DEFINE_PCI_DEVICE_TABLE(mei_pci_tbl) = {
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_82946GZ)},
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_82G35)},
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_82Q965)},
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_82G965)},
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_82GM965)},
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_82GME965)},
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9_82Q35)},
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9_82G33)},
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9_82Q33)},
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9_82X38)},
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9_3200)},
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9_6)},
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9_7)},
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9_8)},
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9_9)},
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9_10)},
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9M_1)},
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9M_2)},
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9M_3)},
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9M_4)},
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH10_1)},
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH10_2)},
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH10_3)},
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH10_4)},
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_IBXPK_1)},
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_IBXPK_2)},
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_CPT_1)},
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_PBG_1)},
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_PPT_1)},
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_PPT_2)},
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_PPT_3)},
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_LPT)},
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_LPT_LP)},
-
-	/* required last entry */
-	{0, }
-};
-
-MODULE_DEVICE_TABLE(pci, mei_pci_tbl);
-
-static DEFINE_MUTEX(mei_mutex);
-
-
 /**
  * mei_open - the open function
  *
@@ -101,15 +53,20 @@ static DEFINE_MUTEX(mei_mutex);
  */
 static int mei_open(struct inode *inode, struct file *file)
 {
+	struct miscdevice *misc = file->private_data;
+	struct pci_dev *pdev;
 	struct mei_cl *cl;
 	struct mei_device *dev;
+
 	int err;
 
 	err = -ENODEV;
-	if (!mei_pdev)
+	if (!misc->parent)
 		goto out;
 
-	dev = pci_get_drvdata(mei_pdev);
+	pdev = container_of(misc->parent, struct pci_dev, dev);
+
+	dev = pci_get_drvdata(pdev);
 	if (!dev)
 		goto out;
 
@@ -787,7 +744,6 @@ static const struct file_operations mei_fops = {
 	.llseek = no_llseek
 };
 
-
 /*
  * Misc Device Struct
  */
@@ -797,302 +753,16 @@ static struct miscdevice  mei_misc_device = {
 		.minor = MISC_DYNAMIC_MINOR,
 };
 
-/**
- * mei_quirk_probe - probe for devices that doesn't valid ME interface
- * @pdev: PCI device structure
- * @ent: entry into pci_device_table
- *
- * returns true if ME Interface is valid, false otherwise
- */
-static bool mei_quirk_probe(struct pci_dev *pdev,
-				const struct pci_device_id *ent)
+int mei_register(struct device *dev)
 {
-	u32 reg;
-	if (ent->device == MEI_DEV_ID_PBG_1) {
-		pci_read_config_dword(pdev, 0x48, &reg);
-		/* make sure that bit 9 is up and bit 10 is down */
-		if ((reg & 0x600) == 0x200) {
-			dev_info(&pdev->dev, "Device doesn't have valid ME Interface\n");
-			return false;
-		}
-	}
-	return true;
-}
-/**
- * mei_probe - Device Initialization Routine
- *
- * @pdev: PCI device structure
- * @ent: entry in kcs_pci_tbl
- *
- * returns 0 on success, <0 on failure.
- */
-static int mei_probe(struct pci_dev *pdev,
-				const struct pci_device_id *ent)
-{
-	struct mei_device *dev;
-	int err;
-
-	mutex_lock(&mei_mutex);
-
-	if (!mei_quirk_probe(pdev, ent)) {
-		err = -ENODEV;
-		goto end;
-	}
-
-	if (mei_pdev) {
-		err = -EEXIST;
-		goto end;
-	}
-	/* enable pci dev */
-	err = pci_enable_device(pdev);
-	if (err) {
-		dev_err(&pdev->dev, "failed to enable pci device.\n");
-		goto end;
-	}
-	/* set PCI host mastering  */
-	pci_set_master(pdev);
-	/* pci request regions for mei driver */
-	err = pci_request_regions(pdev, KBUILD_MODNAME);
-	if (err) {
-		dev_err(&pdev->dev, "failed to get pci regions.\n");
-		goto disable_device;
-	}
-	/* allocates and initializes the mei dev structure */
-	dev = mei_device_init(pdev);
-	if (!dev) {
-		err = -ENOMEM;
-		goto release_regions;
-	}
-	/* mapping  IO device memory */
-	dev->mem_addr = pci_iomap(pdev, 0, 0);
-	if (!dev->mem_addr) {
-		dev_err(&pdev->dev, "mapping I/O device memory failure.\n");
-		err = -ENOMEM;
-		goto free_device;
-	}
-	pci_enable_msi(pdev);
-
-	 /* request and enable interrupt */
-	if (pci_dev_msi_enabled(pdev))
-		err = request_threaded_irq(pdev->irq,
-			NULL,
-			mei_interrupt_thread_handler,
-			IRQF_ONESHOT, KBUILD_MODNAME, dev);
-	else
-		err = request_threaded_irq(pdev->irq,
-			mei_interrupt_quick_handler,
-			mei_interrupt_thread_handler,
-			IRQF_SHARED, KBUILD_MODNAME, dev);
-
-	if (err) {
-		dev_err(&pdev->dev, "request_threaded_irq failure. irq = %d\n",
-		       pdev->irq);
-		goto disable_msi;
-	}
-
-	if (mei_hw_init(dev)) {
-		dev_err(&pdev->dev, "init hw failure.\n");
-		err = -ENODEV;
-		goto release_irq;
-	}
-
-	err = misc_register(&mei_misc_device);
-	if (err)
-		goto release_irq;
-
-	mei_pdev = pdev;
-	pci_set_drvdata(pdev, dev);
-
-
-	schedule_delayed_work(&dev->timer_work, HZ);
-
-	mutex_unlock(&mei_mutex);
-
-	pr_debug("initialization successful.\n");
-
-	return 0;
-
-release_irq:
-	mei_disable_interrupts(dev);
-	flush_scheduled_work();
-	free_irq(pdev->irq, dev);
-disable_msi:
-	pci_disable_msi(pdev);
-	pci_iounmap(pdev, dev->mem_addr);
-free_device:
-	kfree(dev);
-release_regions:
-	pci_release_regions(pdev);
-disable_device:
-	pci_disable_device(pdev);
-end:
-	mutex_unlock(&mei_mutex);
-	dev_err(&pdev->dev, "initialization failed.\n");
-	return err;
+	mei_misc_device.parent = dev;
+	return misc_register(&mei_misc_device);
 }
 
-/**
- * mei_remove - Device Removal Routine
- *
- * @pdev: PCI device structure
- *
- * mei_remove is called by the PCI subsystem to alert the driver
- * that it should release a PCI device.
- */
-static void mei_remove(struct pci_dev *pdev)
+void mei_deregister(void)
 {
-	struct mei_device *dev;
-
-	if (mei_pdev != pdev)
-		return;
-
-	dev = pci_get_drvdata(pdev);
-	if (!dev)
-		return;
-
-	mutex_lock(&dev->device_lock);
-
-	cancel_delayed_work(&dev->timer_work);
-
-	mei_wd_stop(dev);
-
-	mei_pdev = NULL;
-
-	if (dev->iamthif_cl.state == MEI_FILE_CONNECTED) {
-		dev->iamthif_cl.state = MEI_FILE_DISCONNECTING;
-		mei_cl_disconnect(&dev->iamthif_cl);
-	}
-	if (dev->wd_cl.state == MEI_FILE_CONNECTED) {
-		dev->wd_cl.state = MEI_FILE_DISCONNECTING;
-		mei_cl_disconnect(&dev->wd_cl);
-	}
-
-	/* Unregistering watchdog device */
-	mei_watchdog_unregister(dev);
-
-	/* remove entry if already in list */
-	dev_dbg(&pdev->dev, "list del iamthif and wd file list.\n");
-
-	if (dev->open_handle_count > 0)
-		dev->open_handle_count--;
-	mei_cl_unlink(&dev->wd_cl);
-
-	if (dev->open_handle_count > 0)
-		dev->open_handle_count--;
-	mei_cl_unlink(&dev->iamthif_cl);
-
-	dev->iamthif_current_cb = NULL;
-	dev->me_clients_num = 0;
-
-	mutex_unlock(&dev->device_lock);
-
-	flush_scheduled_work();
-
-	/* disable interrupts */
-	mei_disable_interrupts(dev);
-
-	free_irq(pdev->irq, dev);
-	pci_disable_msi(pdev);
-	pci_set_drvdata(pdev, NULL);
-
-	if (dev->mem_addr)
-		pci_iounmap(pdev, dev->mem_addr);
-
-	kfree(dev);
-
-	pci_release_regions(pdev);
-	pci_disable_device(pdev);
-
 	misc_deregister(&mei_misc_device);
+	mei_misc_device.parent = NULL;
 }
-#ifdef CONFIG_PM
-static int mei_pci_suspend(struct device *device)
-{
-	struct pci_dev *pdev = to_pci_dev(device);
-	struct mei_device *dev = pci_get_drvdata(pdev);
-	int err;
-
-	if (!dev)
-		return -ENODEV;
-	mutex_lock(&dev->device_lock);
-
-	cancel_delayed_work(&dev->timer_work);
-
-	/* Stop watchdog if exists */
-	err = mei_wd_stop(dev);
-	/* Set new mei state */
-	if (dev->dev_state == MEI_DEV_ENABLED ||
-	    dev->dev_state == MEI_DEV_RECOVERING_FROM_RESET) {
-		dev->dev_state = MEI_DEV_POWER_DOWN;
-		mei_reset(dev, 0);
-	}
-	mutex_unlock(&dev->device_lock);
-
-	free_irq(pdev->irq, dev);
-	pci_disable_msi(pdev);
-
-	return err;
-}
-
-static int mei_pci_resume(struct device *device)
-{
-	struct pci_dev *pdev = to_pci_dev(device);
-	struct mei_device *dev;
-	int err;
-
-	dev = pci_get_drvdata(pdev);
-	if (!dev)
-		return -ENODEV;
-
-	pci_enable_msi(pdev);
-
-	/* request and enable interrupt */
-	if (pci_dev_msi_enabled(pdev))
-		err = request_threaded_irq(pdev->irq,
-			NULL,
-			mei_interrupt_thread_handler,
-			IRQF_ONESHOT, KBUILD_MODNAME, dev);
-	else
-		err = request_threaded_irq(pdev->irq,
-			mei_interrupt_quick_handler,
-			mei_interrupt_thread_handler,
-			IRQF_SHARED, KBUILD_MODNAME, dev);
-
-	if (err) {
-		dev_err(&pdev->dev, "request_threaded_irq failed: irq = %d.\n",
-				pdev->irq);
-		return err;
-	}
-
-	mutex_lock(&dev->device_lock);
-	dev->dev_state = MEI_DEV_POWER_UP;
-	mei_reset(dev, 1);
-	mutex_unlock(&dev->device_lock);
-
-	/* Start timer if stopped in suspend */
-	schedule_delayed_work(&dev->timer_work, HZ);
-
-	return err;
-}
-static SIMPLE_DEV_PM_OPS(mei_pm_ops, mei_pci_suspend, mei_pci_resume);
-#define MEI_PM_OPS	(&mei_pm_ops)
-#else
-#define MEI_PM_OPS	NULL
-#endif /* CONFIG_PM */
-/*
- *  PCI driver structure
- */
-static struct pci_driver mei_driver = {
-	.name = KBUILD_MODNAME,
-	.id_table = mei_pci_tbl,
-	.probe = mei_probe,
-	.remove = mei_remove,
-	.shutdown = mei_remove,
-	.driver.pm = MEI_PM_OPS,
-};
 
-module_pci_driver(mei_driver);
 
-MODULE_AUTHOR("Intel Corporation");
-MODULE_DESCRIPTION("Intel(R) Management Engine Interface");
-MODULE_LICENSE("GPL v2");
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index d6589d0..3b2bca3 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -401,6 +401,9 @@ bool mei_me_is_ready(struct mei_device *dev);
 
 
 
+int mei_register(struct device *dev);
+void mei_deregister(void);
+
 #define MEI_HDR_FMT "hdr:host=%02d me=%02d len=%d comp=%1d"
 #define MEI_HDR_PRM(hdr)                  \
 	(hdr)->host_addr, (hdr)->me_addr, \
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
new file mode 100644
index 0000000..eaed398
--- /dev/null
+++ b/drivers/misc/mei/pci-me.c
@@ -0,0 +1,393 @@
+/*
+ *
+ * Intel Management Engine Interface (Intel MEI) Linux driver
+ * Copyright (c) 2003-2012, Intel Corporation.
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
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/fs.h>
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/fcntl.h>
+#include <linux/aio.h>
+#include <linux/pci.h>
+#include <linux/poll.h>
+#include <linux/init.h>
+#include <linux/ioctl.h>
+#include <linux/cdev.h>
+#include <linux/sched.h>
+#include <linux/uuid.h>
+#include <linux/compat.h>
+#include <linux/jiffies.h>
+#include <linux/interrupt.h>
+#include <linux/miscdevice.h>
+
+#include <linux/mei.h>
+
+#include "mei_dev.h"
+#include "hw-me.h"
+#include "client.h"
+
+/* AMT device is a singleton on the platform */
+static struct pci_dev *mei_pdev;
+
+/* mei_pci_tbl - PCI Device ID Table */
+static DEFINE_PCI_DEVICE_TABLE(mei_pci_tbl) = {
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_82946GZ)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_82G35)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_82Q965)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_82G965)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_82GM965)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_82GME965)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9_82Q35)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9_82G33)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9_82Q33)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9_82X38)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9_3200)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9_6)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9_7)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9_8)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9_9)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9_10)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9M_1)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9M_2)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9M_3)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9M_4)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH10_1)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH10_2)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH10_3)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH10_4)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_IBXPK_1)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_IBXPK_2)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_CPT_1)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_PBG_1)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_PPT_1)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_PPT_2)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_PPT_3)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_LPT)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_LPT_LP)},
+
+	/* required last entry */
+	{0, }
+};
+
+MODULE_DEVICE_TABLE(pci, mei_pci_tbl);
+
+static DEFINE_MUTEX(mei_mutex);
+
+
+/**
+ * mei_quirk_probe - probe for devices that doesn't valid ME interface
+ * @pdev: PCI device structure
+ * @ent: entry into pci_device_table
+ *
+ * returns true if ME Interface is valid, false otherwise
+ */
+static bool mei_quirk_probe(struct pci_dev *pdev,
+				const struct pci_device_id *ent)
+{
+	u32 reg;
+	if (ent->device == MEI_DEV_ID_PBG_1) {
+		pci_read_config_dword(pdev, 0x48, &reg);
+		/* make sure that bit 9 is up and bit 10 is down */
+		if ((reg & 0x600) == 0x200) {
+			dev_info(&pdev->dev, "Device doesn't have valid ME Interface\n");
+			return false;
+		}
+	}
+	return true;
+}
+/**
+ * mei_probe - Device Initialization Routine
+ *
+ * @pdev: PCI device structure
+ * @ent: entry in kcs_pci_tbl
+ *
+ * returns 0 on success, <0 on failure.
+ */
+static int mei_probe(struct pci_dev *pdev,
+				const struct pci_device_id *ent)
+{
+	struct mei_device *dev;
+	int err;
+
+	mutex_lock(&mei_mutex);
+
+	if (!mei_quirk_probe(pdev, ent)) {
+		err = -ENODEV;
+		goto end;
+	}
+
+	if (mei_pdev) {
+		err = -EEXIST;
+		goto end;
+	}
+	/* enable pci dev */
+	err = pci_enable_device(pdev);
+	if (err) {
+		dev_err(&pdev->dev, "failed to enable pci device.\n");
+		goto end;
+	}
+	/* set PCI host mastering  */
+	pci_set_master(pdev);
+	/* pci request regions for mei driver */
+	err = pci_request_regions(pdev, KBUILD_MODNAME);
+	if (err) {
+		dev_err(&pdev->dev, "failed to get pci regions.\n");
+		goto disable_device;
+	}
+	/* allocates and initializes the mei dev structure */
+	dev = mei_device_init(pdev);
+	if (!dev) {
+		err = -ENOMEM;
+		goto release_regions;
+	}
+	/* mapping  IO device memory */
+	dev->mem_addr = pci_iomap(pdev, 0, 0);
+	if (!dev->mem_addr) {
+		dev_err(&pdev->dev, "mapping I/O device memory failure.\n");
+		err = -ENOMEM;
+		goto free_device;
+	}
+	pci_enable_msi(pdev);
+
+	 /* request and enable interrupt */
+	if (pci_dev_msi_enabled(pdev))
+		err = request_threaded_irq(pdev->irq,
+			NULL,
+			mei_interrupt_thread_handler,
+			IRQF_ONESHOT, KBUILD_MODNAME, dev);
+	else
+		err = request_threaded_irq(pdev->irq,
+			mei_interrupt_quick_handler,
+			mei_interrupt_thread_handler,
+			IRQF_SHARED, KBUILD_MODNAME, dev);
+
+	if (err) {
+		dev_err(&pdev->dev, "request_threaded_irq failure. irq = %d\n",
+		       pdev->irq);
+		goto disable_msi;
+	}
+
+	if (mei_hw_init(dev)) {
+		dev_err(&pdev->dev, "init hw failure.\n");
+		err = -ENODEV;
+		goto release_irq;
+	}
+
+	err = mei_register(&pdev->dev);
+	if (err)
+		goto release_irq;
+
+	mei_pdev = pdev;
+	pci_set_drvdata(pdev, dev);
+
+
+	schedule_delayed_work(&dev->timer_work, HZ);
+
+	mutex_unlock(&mei_mutex);
+
+	pr_debug("initialization successful.\n");
+
+	return 0;
+
+release_irq:
+	mei_disable_interrupts(dev);
+	flush_scheduled_work();
+	free_irq(pdev->irq, dev);
+disable_msi:
+	pci_disable_msi(pdev);
+	pci_iounmap(pdev, dev->mem_addr);
+free_device:
+	kfree(dev);
+release_regions:
+	pci_release_regions(pdev);
+disable_device:
+	pci_disable_device(pdev);
+end:
+	mutex_unlock(&mei_mutex);
+	dev_err(&pdev->dev, "initialization failed.\n");
+	return err;
+}
+
+/**
+ * mei_remove - Device Removal Routine
+ *
+ * @pdev: PCI device structure
+ *
+ * mei_remove is called by the PCI subsystem to alert the driver
+ * that it should release a PCI device.
+ */
+static void mei_remove(struct pci_dev *pdev)
+{
+	struct mei_device *dev;
+
+	if (mei_pdev != pdev)
+		return;
+
+	dev = pci_get_drvdata(pdev);
+	if (!dev)
+		return;
+
+	mutex_lock(&dev->device_lock);
+
+	cancel_delayed_work(&dev->timer_work);
+
+	mei_wd_stop(dev);
+
+	mei_pdev = NULL;
+
+	if (dev->iamthif_cl.state == MEI_FILE_CONNECTED) {
+		dev->iamthif_cl.state = MEI_FILE_DISCONNECTING;
+		mei_cl_disconnect(&dev->iamthif_cl);
+	}
+	if (dev->wd_cl.state == MEI_FILE_CONNECTED) {
+		dev->wd_cl.state = MEI_FILE_DISCONNECTING;
+		mei_cl_disconnect(&dev->wd_cl);
+	}
+
+	/* Unregistering watchdog device */
+	mei_watchdog_unregister(dev);
+
+	/* remove entry if already in list */
+	dev_dbg(&pdev->dev, "list del iamthif and wd file list.\n");
+
+	if (dev->open_handle_count > 0)
+		dev->open_handle_count--;
+	mei_cl_unlink(&dev->wd_cl);
+
+	if (dev->open_handle_count > 0)
+		dev->open_handle_count--;
+	mei_cl_unlink(&dev->iamthif_cl);
+
+	dev->iamthif_current_cb = NULL;
+	dev->me_clients_num = 0;
+
+	mutex_unlock(&dev->device_lock);
+
+	flush_scheduled_work();
+
+	/* disable interrupts */
+	mei_disable_interrupts(dev);
+
+	free_irq(pdev->irq, dev);
+	pci_disable_msi(pdev);
+	pci_set_drvdata(pdev, NULL);
+
+	if (dev->mem_addr)
+		pci_iounmap(pdev, dev->mem_addr);
+
+	kfree(dev);
+
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+
+	mei_deregister();
+
+}
+#ifdef CONFIG_PM
+static int mei_pci_suspend(struct device *device)
+{
+	struct pci_dev *pdev = to_pci_dev(device);
+	struct mei_device *dev = pci_get_drvdata(pdev);
+	int err;
+
+	if (!dev)
+		return -ENODEV;
+	mutex_lock(&dev->device_lock);
+
+	cancel_delayed_work(&dev->timer_work);
+
+	/* Stop watchdog if exists */
+	err = mei_wd_stop(dev);
+	/* Set new mei state */
+	if (dev->dev_state == MEI_DEV_ENABLED ||
+	    dev->dev_state == MEI_DEV_RECOVERING_FROM_RESET) {
+		dev->dev_state = MEI_DEV_POWER_DOWN;
+		mei_reset(dev, 0);
+	}
+	mutex_unlock(&dev->device_lock);
+
+	free_irq(pdev->irq, dev);
+	pci_disable_msi(pdev);
+
+	return err;
+}
+
+static int mei_pci_resume(struct device *device)
+{
+	struct pci_dev *pdev = to_pci_dev(device);
+	struct mei_device *dev;
+	int err;
+
+	dev = pci_get_drvdata(pdev);
+	if (!dev)
+		return -ENODEV;
+
+	pci_enable_msi(pdev);
+
+	/* request and enable interrupt */
+	if (pci_dev_msi_enabled(pdev))
+		err = request_threaded_irq(pdev->irq,
+			NULL,
+			mei_interrupt_thread_handler,
+			IRQF_ONESHOT, KBUILD_MODNAME, dev);
+	else
+		err = request_threaded_irq(pdev->irq,
+			mei_interrupt_quick_handler,
+			mei_interrupt_thread_handler,
+			IRQF_SHARED, KBUILD_MODNAME, dev);
+
+	if (err) {
+		dev_err(&pdev->dev, "request_threaded_irq failed: irq = %d.\n",
+				pdev->irq);
+		return err;
+	}
+
+	mutex_lock(&dev->device_lock);
+	dev->dev_state = MEI_DEV_POWER_UP;
+	mei_reset(dev, 1);
+	mutex_unlock(&dev->device_lock);
+
+	/* Start timer if stopped in suspend */
+	schedule_delayed_work(&dev->timer_work, HZ);
+
+	return err;
+}
+static SIMPLE_DEV_PM_OPS(mei_pm_ops, mei_pci_suspend, mei_pci_resume);
+#define MEI_PM_OPS	(&mei_pm_ops)
+#else
+#define MEI_PM_OPS	NULL
+#endif /* CONFIG_PM */
+/*
+ *  PCI driver structure
+ */
+static struct pci_driver mei_driver = {
+	.name = KBUILD_MODNAME,
+	.id_table = mei_pci_tbl,
+	.probe = mei_probe,
+	.remove = mei_remove,
+	.shutdown = mei_remove,
+	.driver.pm = MEI_PM_OPS,
+};
+
+module_pci_driver(mei_driver);
+
+MODULE_AUTHOR("Intel Corporation");
+MODULE_DESCRIPTION("Intel(R) Management Engine Interface");
+MODULE_LICENSE("GPL v2");
-- 
1.7.4.4

