Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243AbaEMIYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 04:24:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:52024 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759456AbaEMIXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 04:23:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1042,1389772800"; 
   d="scan'208";a="510767476"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 1/3] mei: move from misc to char device
Date: Tue, 13 May 2014 11:21:59 +0300
Message-Id: <1399969321-6512-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399969321-6512-1-git-send-email-tomas.winkler@intel.com>
References: <1399969321-6512-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

We need to support more then one mei interface
hence the simple misc devices is not longer an option.
We use char device now with to not break application
space we preserve /dev/mei for the first interface.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/main.c    | 98 +++++++++++++++++++++++++++++++++-------------
 drivers/misc/mei/mei_dev.h |  7 ++++
 drivers/misc/mei/pci-me.c  |  1 -
 3 files changed, 78 insertions(+), 28 deletions(-)

diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 66f0a1a..c58e059 100644
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
 	struct mei_cl *cl;
 	struct mei_device *dev;
 
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
 
@@ -667,26 +659,48 @@ static const struct file_operations mei_fops = {
 	.llseek = no_llseek
 };
 
-/*
- * Misc Device Struct
- */
-static struct miscdevice  mei_misc_device = {
-		.name = "mei",
-		.fops = &mei_fops,
-		.minor = MISC_DYNAMIC_MINOR,
-};
-
+static struct class *mei_class;
+static dev_t mei_devt;
+#define MAX_MEI_DEVS 5            /* Maximum number of mei devices */
 
 int mei_register(struct mei_device *dev)
 {
-	int ret;
-	mei_misc_device.parent = &dev->pdev->dev;
-	ret = misc_register(&mei_misc_device);
-	if (ret)
+
+	int ret, devno;
+	int id = 0; /* FIXME: retrieve interface version*/
+
+	/* Fill in the data structures */
+	devno = MKDEV(MAJOR(mei_devt), id);
+	cdev_init(&dev->cdev, &mei_fops);
+	dev->cdev.owner = mei_fops.owner;
+
+	/* Add the device */
+	ret = cdev_add(&dev->cdev, devno, 1);
+	if (ret) {
+		dev_err(&dev->pdev->dev, "mei%d unable to add device %d:%d\n",
+			id, MAJOR(mei_devt), id);
+		return ret;
+	}
+
+	/* Preserve /dev/mei for the first interface */
+	if (id)
+		dev->dev = device_create(mei_class, NULL, devno,
+					 NULL, "mei%d", id);
+	else
+		dev->dev = device_create(mei_class, NULL, devno,
+					NULL, "mei");
+
+	if (IS_ERR(dev->dev)) {
+		dev_err(&dev->pdev->dev, "mei%d unable to create device %d:%d\n",
+			id, MAJOR(mei_devt), id);
+		cdev_del(&dev->cdev);
+		ret = PTR_ERR(dev->dev);
 		return ret;
+	}
 
-	if (mei_dbgfs_register(dev, mei_misc_device.name))
-		dev_err(&dev->pdev->dev, "cannot register debugfs\n");
+	ret = mei_dbgfs_register(dev, dev->dev->kobj.name);
+	if (ret)
+		dev_err(dev->dev, "cannot register debugfs ret = %d\n", ret);
 
 	return 0;
 }
@@ -694,19 +708,49 @@ EXPORT_SYMBOL_GPL(mei_register);
 
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
+		return PTR_ERR(mei_class);
+	}
+
+	ret = alloc_chrdev_region(&mei_devt, 0, MAX_MEI_DEVS, "mei");
+	if (ret < 0) {
+		pr_err("unable to allocate char dev region\n");
+		goto err;
+	}
+
+	ret = mei_cl_bus_init();
+	if (ret < 0) {
+		pr_err("unable to initialize bus\n");
+		goto err;
+	}
+
+	return 0;
+err:
+	class_destroy(mei_class);
+	return ret;
 }
 
 static void __exit mei_exit(void)
 {
+	unregister_chrdev_region(mei_devt, MAX_MEI_DEVS);
+	class_destroy(mei_class);
 	mei_cl_bus_exit();
 }
 
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 5c7e990..a418565 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -400,6 +400,10 @@ struct mei_cfg {
 /**
  * struct mei_device -  MEI private device struct
 
+ * @pdev - pointer to pci device struct
+ * @cdev - character device
+ * @dev - pointer to device object
+ *
  * @reset_count - limits the number of consecutive resets
  * @hbm_state - state of host bus message protocol
  * @pg_event - power gating event
@@ -412,6 +416,9 @@ struct mei_cfg {
  */
 struct mei_device {
 	struct pci_dev *pdev;	/* pointer to pci device struct */
+	struct cdev cdev;
+	struct device *dev;
+
 	/*
 	 * lists of queues
 	 */
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index 1b46c64..cf4f654 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -31,7 +31,6 @@
 #include <linux/compat.h>
 #include <linux/jiffies.h>
 #include <linux/interrupt.h>
-#include <linux/miscdevice.h>
 
 #include <linux/pm_runtime.h>
 
-- 
1.9.0

