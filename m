Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025AbaKJMuk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 07:50:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:7816 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813AbaKJMuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 07:50:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,352,1413270000"; 
   d="scan'208";a="605276746"
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh.triplett@intel.com, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v6 05/10] tpm: device class for tpm
Date: Mon, 10 Nov 2014 14:49:49 +0200
Message-Id: <1415623794-6090-6-git-send-email-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415623794-6090-1-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1415623794-6090-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added own device class for TPM. Uses MISC_MAJOR:TPM_MINOR for the
first character device in order to retain backwards compatability.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm-dev.c         | 56 +++++++++++++++++++++++++++-----------
 drivers/char/tpm/tpm-interface.c   | 32 ++++++++++++++++++++++
 drivers/char/tpm/tpm.h             |  9 ++++--
 drivers/char/tpm/tpm_i2c_nuvoton.c |  2 +-
 drivers/char/tpm/tpm_tis.c         |  4 +--
 5 files changed, 82 insertions(+), 21 deletions(-)

diff --git a/drivers/char/tpm/tpm-dev.c b/drivers/char/tpm/tpm-dev.c
index 3568321..8f4263f 100644
--- a/drivers/char/tpm/tpm-dev.c
+++ b/drivers/char/tpm/tpm-dev.c
@@ -17,9 +17,9 @@
  * License.
  *
  */
-#include <linux/miscdevice.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
+#include <linux/major.h>
 #include "tpm.h"
 
 struct file_priv {
@@ -54,9 +54,8 @@ static void timeout_work(struct work_struct *work)
 
 static int tpm_open(struct inode *inode, struct file *file)
 {
-	struct miscdevice *misc = file->private_data;
-	struct tpm_chip *chip = container_of(misc, struct tpm_chip,
-					     vendor.miscdev);
+	struct tpm_chip *chip =
+		container_of(inode->i_cdev, struct tpm_chip, cdev);
 	struct file_priv *priv;
 
 	/* It's assured that the chip will be opened just once,
@@ -182,32 +181,57 @@ static const struct file_operations tpm_fops = {
 	.release = tpm_release,
 };
 
+static void tpm_dev_release(struct device *dev)
+{
+}
+
 int tpm_dev_add_device(struct tpm_chip *chip)
 {
 	int rc;
 
-	chip->vendor.miscdev.fops = &tpm_fops;
+	chip->dev.class = tpm_class;
+	chip->dev.release = tpm_dev_release;
+	chip->dev.parent = chip->pdev;
+	chip->cdev.owner = chip->pdev->driver->owner;
+
 	if (chip->dev_num == 0)
-		chip->vendor.miscdev.minor = TPM_MINOR;
+		chip->dev.devt = MKDEV(MISC_MAJOR, TPM_MINOR);
 	else
-		chip->vendor.miscdev.minor = MISC_DYNAMIC_MINOR;
+		chip->dev.devt = MKDEV(MAJOR(tpm_devt), chip->dev_num);
 
-	chip->vendor.miscdev.name = chip->devname;
-	chip->vendor.miscdev.parent = chip->pdev;
+	dev_set_name(&chip->dev, chip->devname);
 
-	rc = misc_register(&chip->vendor.miscdev);
+	rc = device_register(&chip->dev);
 	if (rc) {
-		chip->vendor.miscdev.name = NULL;
 		dev_err(chip->pdev,
-			"unable to misc_register %s, minor %d err=%d\n",
-			chip->vendor.miscdev.name,
-			chip->vendor.miscdev.minor, rc);
+			"unable to device_register %s, major %d, minor %d " \
+			"err=%d\n",
+			chip->devname, MAJOR(chip->dev.devt),
+			MINOR(chip->dev.devt), rc);
 	}
+
+	cdev_init(&chip->cdev, &tpm_fops);
+
+	rc = cdev_add(&chip->cdev, chip->dev.devt, 1);
+	if (rc) {
+		dev_err(chip->pdev,
+			"unable to cdev_add %s, major %d, minor %d " \
+			"err=%d\n",
+			chip->devname, MAJOR(chip->dev.devt),
+			MINOR(chip->dev.devt), rc);
+		device_unregister(&chip->dev);
+		put_device(&chip->dev);
+		return rc;
+	}
+
 	return rc;
 }
 
 void tpm_dev_del_device(struct tpm_chip *chip)
 {
-	if (chip->vendor.miscdev.name)
-		misc_deregister(&chip->vendor.miscdev);
+	if (get_device(&chip->dev) != NULL) {
+		cdev_del(&chip->cdev);
+		device_unregister(&chip->dev);
+		put_device(&chip->dev);
+	}
 }
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index e6b08bd..3cb1ec6 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -38,6 +38,9 @@
 #define TPM_PROTECTED_COMMAND 0x00
 #define TPM_CONNECTION_COMMAND 0x40
 
+struct class *tpm_class;
+dev_t tpm_devt;
+
 /*
  * Bug workaround - some TPM's don't flush the most
  * recently changed pcr on suspend, so force the flush
@@ -997,6 +1000,35 @@ int tpm_get_random(u32 chip_num, u8 *out, size_t max)
 }
 EXPORT_SYMBOL_GPL(tpm_get_random);
 
+static int __init tpm_init(void)
+{
+	int rc;
+
+	tpm_class = class_create(THIS_MODULE, "tpm");
+	if (IS_ERR(tpm_class)) {
+		pr_err("couldn't create tpm class\n");
+		return PTR_ERR(tpm_class);
+	}
+
+	rc = alloc_chrdev_region(&tpm_devt, 0, TPM_NUM_DEVICES, "tpm");
+	if (rc < 0) {
+		pr_err("tpm: failed to allocate char dev region\n");
+		class_destroy(tpm_class);
+		return rc;
+	}
+
+	return 0;
+}
+
+static void __exit tpm_exit(void)
+{
+	class_destroy(tpm_class);
+	unregister_chrdev_region(tpm_devt, TPM_NUM_DEVICES);
+}
+
+subsys_initcall(tpm_init);
+module_exit(tpm_exit);
+
 MODULE_AUTHOR("Leendert van Doorn (leendert@watson.ibm.com)");
 MODULE_DESCRIPTION("TPM Driver");
 MODULE_VERSION("2.0");
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index b3a7c76..111c61d 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -23,11 +23,11 @@
 #include <linux/fs.h>
 #include <linux/mutex.h>
 #include <linux/sched.h>
-#include <linux/miscdevice.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/tpm.h>
 #include <linux/acpi.h>
+#include <linux/cdev.h>
 
 enum tpm_const {
 	TPM_MINOR = 224,	/* officially assigned */
@@ -74,7 +74,6 @@ struct tpm_vendor_specific {
 	int region_size;
 	int have_region;
 
-	struct miscdevice miscdev;
 	struct list_head list;
 	int locality;
 	unsigned long timeout_a, timeout_b, timeout_c, timeout_d; /* jiffies */
@@ -99,6 +98,9 @@ struct tpm_vendor_specific {
 
 struct tpm_chip {
 	struct device *pdev;	/* Device stuff */
+	struct device dev;
+	struct cdev cdev;
+
 	const struct tpm_class_ops *ops;
 
 	int dev_num;		/* /dev/tpm# */
@@ -320,6 +322,9 @@ struct tpm_cmd_t {
 	tpm_cmd_params	params;
 } __packed;
 
+extern struct class *tpm_class;
+extern dev_t tpm_devt;
+
 ssize_t	tpm_getcap(struct device *, __be32, cap_t *, const char *);
 ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
 		     size_t bufsiz);
diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_i2c_nuvoton.c
index 92ee9fa..14246e2 100644
--- a/drivers/char/tpm/tpm_i2c_nuvoton.c
+++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
@@ -557,7 +557,7 @@ static int i2c_nuvoton_probe(struct i2c_client *client,
 		rc = devm_request_irq(dev, chip->vendor.irq,
 				      i2c_nuvoton_int_handler,
 				      IRQF_TRIGGER_LOW,
-				      chip->vendor.miscdev.name,
+				      chip->devname,
 				      chip);
 		if (rc) {
 			dev_err(dev, "%s() Unable to request irq: %d for use\n",
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 660d9af..7a2c59b 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -661,7 +661,7 @@ static int tpm_tis_init(struct device *dev, acpi_handle acpi_dev_handle,
 				 TPM_INT_VECTOR(chip->vendor.locality));
 			if (devm_request_irq
 			    (dev, i, tis_int_probe, IRQF_SHARED,
-			     chip->vendor.miscdev.name, chip) != 0) {
+			     chip->devname, chip) != 0) {
 				dev_info(chip->pdev,
 					 "Unable to request irq: %d for probe\n",
 					 i);
@@ -708,7 +708,7 @@ static int tpm_tis_init(struct device *dev, acpi_handle acpi_dev_handle,
 			 TPM_INT_VECTOR(chip->vendor.locality));
 		if (devm_request_irq
 		    (dev, chip->vendor.irq, tis_int_handler, IRQF_SHARED,
-		     chip->vendor.miscdev.name, chip) != 0) {
+		     chip->devname, chip) != 0) {
 			dev_info(chip->pdev,
 				 "Unable to request irq: %d for use\n",
 				 chip->vendor.irq);
-- 
2.1.0

