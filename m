Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012AbaFWMLb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 08:11:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:35399 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbaFWML2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 08:11:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,530,1400050800"; 
   d="scan'208";a="551977488"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 1/3 V2] mei: move from misc to char device
Date: Mon, 23 Jun 2014 15:10:35 +0300
Message-Id: <1403525437-4745-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403525437-4745-1-git-send-email-tomas.winkler@intel.com>
References: <1403525437-4745-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

We need to support more then one mei interface
hence the simple misc devices is not longer an option

In order not break the user space a device with pci function 0
need to be linked to /dev/mei

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
V2: use dynamic minor number allocation

 drivers/misc/mei/main.c    | 148 ++++++++++++++++++++++++++++++++++++---------
 drivers/misc/mei/mei_dev.h |   9 ++-
 drivers/misc/mei/pci-me.c  |   3 +-
 drivers/misc/mei/pci-txe.c |   2 +-
 4 files changed, 131 insertions(+), 31 deletions(-)

diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 66f0a1a..401a3d5 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -32,7 +32,6 @@
 #include <linux/compat.h>
 #include <linux/jiffies.h>
 #include <linux/interrupt.h>
-#include <linux/miscdevice.h>
 
 #include <linux/mei.h>
 
@@ -49,19 +48,12 @@
  */
 static int mei_open(struct inode *inode, struct file *file)
 {
-	struct miscdevice *misc = file->private_data;
-	struct pci_dev *pdev;
-	struct mei_cl *cl;
 	struct mei_device *dev;
+	struct mei_cl *cl;
 
 	int err;
 
-	if (!misc->parent)
-		return -ENODEV;
-
-	pdev = container_of(misc->parent, struct pci_dev, dev);
-
-	dev = pci_get_drvdata(pdev);
+	dev = container_of(inode->i_cdev, struct mei_device, cdev);
 	if (!dev)
 		return -ENODEV;
 
@@ -667,46 +659,148 @@ static const struct file_operations mei_fops = {
 	.llseek = no_llseek
 };
 
-/*
- * Misc Device Struct
+static struct class *mei_class;
+static dev_t mei_devt;
+#define MEI_MAX_DEVS  MINORMASK
+static DEFINE_MUTEX(mei_minor_lock);
+static DEFINE_IDR(mei_idr);
+
+/**
+ * mei_minor_get - obtain next free device minor number
+ *
+ * @dev:  device pointer
+ *
+ * returns allocated minor, or -ENOSPC if no free minor left
  */
-static struct miscdevice  mei_misc_device = {
-		.name = "mei",
-		.fops = &mei_fops,
-		.minor = MISC_DYNAMIC_MINOR,
-};
+static int mei_minor_get(struct mei_device *dev)
+{
+	int ret;
+
+	mutex_lock(&mei_minor_lock);
+	ret = idr_alloc(&mei_idr, dev, 0, MEI_MAX_DEVS, GFP_KERNEL);
+	if (ret >= 0)
+		dev->minor = ret;
+	else if (ret == -ENOSPC)
+		dev_err(&dev->pdev->dev, "too many mei devices\n");
 
+	mutex_unlock(&mei_minor_lock);
+	return ret;
+}
 
-int mei_register(struct mei_device *dev)
+/**
+ * mei_minor_free - mark device minor number as free
+ *
+ * @dev:  device pointer
+ */
+static void mei_minor_free(struct mei_device *dev)
 {
-	int ret;
-	mei_misc_device.parent = &dev->pdev->dev;
-	ret = misc_register(&mei_misc_device);
-	if (ret)
+	mutex_lock(&mei_minor_lock);
+	idr_remove(&mei_idr, dev->minor);
+	mutex_unlock(&mei_minor_lock);
+}
+
+int mei_register(struct mei_device *dev, struct device *parent)
+{
+	struct device *clsdev; /* class device */
+	int ret, devno;
+
+	ret = mei_minor_get(dev);
+	if (ret < 0)
 		return ret;
 
-	if (mei_dbgfs_register(dev, mei_misc_device.name))
-		dev_err(&dev->pdev->dev, "cannot register debugfs\n");
+	/* Fill in the data structures */
+	devno = MKDEV(MAJOR(mei_devt), dev->minor);
+	cdev_init(&dev->cdev, &mei_fops);
+	dev->cdev.owner = mei_fops.owner;
+
+	/* Add the device */
+	ret = cdev_add(&dev->cdev, devno, 1);
+	if (ret) {
+		dev_err(parent, "unable to add device %d:%d\n",
+			MAJOR(mei_devt), dev->minor);
+		goto err_dev_add;
+	}
+
+	clsdev = device_create(mei_class, parent, devno,
+			 NULL, "mei%d", dev->minor);
+
+	if (IS_ERR(clsdev)) {
+		dev_err(parent, "unable to create device %d:%d\n",
+			MAJOR(mei_devt), dev->minor);
+		ret = PTR_ERR(clsdev);
+		goto err_dev_create;
+	}
+
+	ret = mei_dbgfs_register(dev, dev_name(clsdev));
+	if (ret) {
+		dev_err(clsdev, "cannot register debugfs ret = %d\n", ret);
+		goto err_dev_dbgfs;
+	}
 
 	return 0;
+
+err_dev_dbgfs:
+	device_destroy(mei_class, devno);
+err_dev_create:
+	cdev_del(&dev->cdev);
+err_dev_add:
+	mei_minor_free(dev);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(mei_register);
 
 void mei_deregister(struct mei_device *dev)
 {
+	int devno;
+
+	devno = dev->cdev.dev;
+	cdev_del(&dev->cdev);
+
 	mei_dbgfs_deregister(dev);
-	misc_deregister(&mei_misc_device);
-	mei_misc_device.parent = NULL;
+
+	device_destroy(mei_class, devno);
+
+	mei_minor_free(dev);
 }
 EXPORT_SYMBOL_GPL(mei_deregister);
 
 static int __init mei_init(void)
 {
-	return mei_cl_bus_init();
+	int ret;
+
+	mei_class = class_create(THIS_MODULE, "mei");
+	if (IS_ERR(mei_class)) {
+		pr_err("couldn't create class\n");
+		ret = PTR_ERR(mei_class);
+		goto err;
+	}
+
+	ret = alloc_chrdev_region(&mei_devt, 0, MEI_MAX_DEVS, "mei");
+	if (ret < 0) {
+		pr_err("unable to allocate char dev region\n");
+		goto err_class;
+	}
+
+	ret = mei_cl_bus_init();
+	if (ret < 0) {
+		pr_err("unable to initialize bus\n");
+		goto err_chrdev;
+	}
+
+	return 0;
+
+err_chrdev:
+	unregister_chrdev_region(mei_devt, MEI_MAX_DEVS);
+err_class:
+	class_destroy(mei_class);
+err:
+	return ret;
 }
 
 static void __exit mei_exit(void)
 {
+	unregister_chrdev_region(mei_devt, MEI_MAX_DEVS);
+	class_destroy(mei_class);
 	mei_cl_bus_exit();
 }
 
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 5c7e990..2afa3d6 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -400,6 +400,10 @@ struct mei_cfg {
 /**
  * struct mei_device -  MEI private device struct
 
+ * @pdev - pointer to pci device struct
+ * @cdev - character device
+ * @minor - minor number allocated for device
+ *
  * @reset_count - limits the number of consecutive resets
  * @hbm_state - state of host bus message protocol
  * @pg_event - power gating event
@@ -412,6 +416,9 @@ struct mei_cfg {
  */
 struct mei_device {
 	struct pci_dev *pdev;	/* pointer to pci device struct */
+	struct cdev cdev;
+	int minor;
+
 	/*
 	 * lists of queues
 	 */
@@ -741,7 +748,7 @@ static inline int mei_dbgfs_register(struct mei_device *dev, const char *name)
 static inline void mei_dbgfs_deregister(struct mei_device *dev) {}
 #endif /* CONFIG_DEBUG_FS */
 
-int mei_register(struct mei_device *dev);
+int mei_register(struct mei_device *dev, struct device *parent);
 void mei_deregister(struct mei_device *dev);
 
 #define MEI_HDR_FMT "hdr:host=%02d me=%02d len=%d internal=%1d comp=%1d"
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index 1b46c64..887ace1 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -31,7 +31,6 @@
 #include <linux/compat.h>
 #include <linux/jiffies.h>
 #include <linux/interrupt.h>
-#include <linux/miscdevice.h>
 
 #include <linux/pm_runtime.h>
 
@@ -207,7 +206,7 @@ static int mei_me_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pm_runtime_set_autosuspend_delay(&pdev->dev, MEI_ME_RPM_TIMEOUT);
 	pm_runtime_use_autosuspend(&pdev->dev);
 
-	err = mei_register(dev);
+	err = mei_register(dev, &pdev->dev);
 	if (err)
 		goto release_irq;
 
diff --git a/drivers/misc/mei/pci-txe.c b/drivers/misc/mei/pci-txe.c
index 2343c62..d7480fe 100644
--- a/drivers/misc/mei/pci-txe.c
+++ b/drivers/misc/mei/pci-txe.c
@@ -149,7 +149,7 @@ static int mei_txe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pm_runtime_set_autosuspend_delay(&pdev->dev, MEI_TXI_RPM_TIMEOUT);
 	pm_runtime_use_autosuspend(&pdev->dev);
 
-	err = mei_register(dev);
+	err = mei_register(dev, &pdev->dev);
 	if (err)
 		goto release_irq;
 
-- 
1.9.3

