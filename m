Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab3KDDjc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 22:39:32 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:45230 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587Ab3KDDi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 22:38:58 -0500
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: tpmdd-devel@lists.sourceforge.net, Peter Huewe <peterhuewe@gmx.de>
Cc: linux-kernel@vger.kernel.org, Ashley Lai <ashley@ashleylai.com>
Subject: [PATCH 1/5 v2] tpm: Pull everything related to /dev/tpmX into tpm-dev.c
Date: Sun,  3 Nov 2013 20:38:42 -0700
Message-Id: <1383536326-28772-2-git-send-email-jgunthorpe@obsidianresearch.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383536326-28772-1-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1383536326-28772-1-git-send-email-jgunthorpe@obsidianresearch.com>
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CLASS-dev.c is a common idiom for Linux subsystems

This pulls all the code related to the miscdev into tpm-dev.c and makes it
static. The identical file_operation structs in the drivers are purged and the
tpm common code unconditionally creates the miscdev.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Reviewed-by: Joel Schopp <jschopp@linux.vnet.ibm.com>
---
 drivers/char/tpm/Makefile           |   2 +-
 drivers/char/tpm/tpm-dev.c          | 199 ++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm-interface.c    | 178 ++------------------------------
 drivers/char/tpm/tpm.h              |  11 +-
 drivers/char/tpm/tpm_atmel.c        |  10 --
 drivers/char/tpm/tpm_i2c_atmel.c    |  10 --
 drivers/char/tpm/tpm_i2c_infineon.c |  10 --
 drivers/char/tpm/tpm_i2c_nuvoton.c  |  10 --
 drivers/char/tpm/tpm_i2c_stm_st33.c |  10 --
 drivers/char/tpm/tpm_ibmvtpm.c      |  10 --
 drivers/char/tpm/tpm_infineon.c     |  10 --
 drivers/char/tpm/tpm_nsc.c          |  10 --
 drivers/char/tpm/tpm_tis.c          |  11 --
 drivers/char/tpm/xen-tpmfront.c     |  12 ---
 14 files changed, 216 insertions(+), 277 deletions(-)
 create mode 100644 drivers/char/tpm/tpm-dev.c

diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index b80a400..d835e87 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the kernel tpm device drivers.
 #
 obj-$(CONFIG_TCG_TPM) += tpm.o
-tpm-y := tpm-interface.o
+tpm-y := tpm-interface.o tpm-dev.o
 tpm-$(CONFIG_ACPI) += tpm_ppi.o
 
 ifdef CONFIG_ACPI
diff --git a/drivers/char/tpm/tpm-dev.c b/drivers/char/tpm/tpm-dev.c
new file mode 100644
index 0000000..8d94e97
--- /dev/null
+++ b/drivers/char/tpm/tpm-dev.c
@@ -0,0 +1,199 @@
+/*
+ * Copyright (C) 2004 IBM Corporation
+ * Authors:
+ * Leendert van Doorn <leendert@watson.ibm.com>
+ * Dave Safford <safford@watson.ibm.com>
+ * Reiner Sailer <sailer@watson.ibm.com>
+ * Kylene Hall <kjhall@us.ibm.com>
+ *
+ * Copyright (C) 2013 Obsidian Reearch Corp
+ * Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
+ *
+ * Device file system interface to the TPM
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ *
+ */
+#include <linux/miscdevice.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include "tpm.h"
+
+static void user_reader_timeout(unsigned long ptr)
+{
+	struct tpm_chip *chip = (struct tpm_chip *) ptr;
+
+	schedule_work(&chip->work);
+}
+
+static void timeout_work(struct work_struct *work)
+{
+	struct tpm_chip *chip = container_of(work, struct tpm_chip, work);
+
+	mutex_lock(&chip->buffer_mutex);
+	atomic_set(&chip->data_pending, 0);
+	memset(chip->data_buffer, 0, TPM_BUFSIZE);
+	mutex_unlock(&chip->buffer_mutex);
+}
+
+static int tpm_open(struct inode *inode, struct file *file)
+{
+	struct miscdevice *misc = file->private_data;
+	struct tpm_chip *chip = container_of(misc, struct tpm_chip,
+					     vendor.miscdev);
+
+	/* It's assured that the chip will be opened just once,
+	 * by the check of is_open variable, which is protected
+	 * by driver_lock. */
+	if (test_and_set_bit(0, &chip->is_open)) {
+		dev_dbg(chip->dev, "Another process owns this TPM\n");
+		return -EBUSY;
+	}
+
+	chip->data_buffer = kzalloc(TPM_BUFSIZE, GFP_KERNEL);
+	if (chip->data_buffer == NULL) {
+		clear_bit(0, &chip->is_open);
+		return -ENOMEM;
+	}
+
+	atomic_set(&chip->data_pending, 0);
+
+	file->private_data = chip;
+	get_device(chip->dev);
+	return 0;
+}
+
+static ssize_t tpm_read(struct file *file, char __user *buf,
+			size_t size, loff_t *off)
+{
+	struct tpm_chip *chip = file->private_data;
+	ssize_t ret_size;
+	int rc;
+
+	del_singleshot_timer_sync(&chip->user_read_timer);
+	flush_work(&chip->work);
+	ret_size = atomic_read(&chip->data_pending);
+	if (ret_size > 0) {	/* relay data */
+		ssize_t orig_ret_size = ret_size;
+		if (size < ret_size)
+			ret_size = size;
+
+		mutex_lock(&chip->buffer_mutex);
+		rc = copy_to_user(buf, chip->data_buffer, ret_size);
+		memset(chip->data_buffer, 0, orig_ret_size);
+		if (rc)
+			ret_size = -EFAULT;
+
+		mutex_unlock(&chip->buffer_mutex);
+	}
+
+	atomic_set(&chip->data_pending, 0);
+
+	return ret_size;
+}
+
+static ssize_t tpm_write(struct file *file, const char __user *buf,
+			 size_t size, loff_t *off)
+{
+	struct tpm_chip *chip = file->private_data;
+	size_t in_size = size;
+	ssize_t out_size;
+
+	/* cannot perform a write until the read has cleared
+	   either via tpm_read or a user_read_timer timeout.
+	   This also prevents splitted buffered writes from blocking here.
+	*/
+	if (atomic_read(&chip->data_pending) != 0)
+		return -EBUSY;
+
+	if (in_size > TPM_BUFSIZE)
+		return -E2BIG;
+
+	mutex_lock(&chip->buffer_mutex);
+
+	if (copy_from_user
+	    (chip->data_buffer, (void __user *) buf, in_size)) {
+		mutex_unlock(&chip->buffer_mutex);
+		return -EFAULT;
+	}
+
+	/* atomic tpm command send and result receive */
+	out_size = tpm_transmit(chip, chip->data_buffer, TPM_BUFSIZE);
+	if (out_size < 0) {
+		mutex_unlock(&chip->buffer_mutex);
+		return out_size;
+	}
+
+	atomic_set(&chip->data_pending, out_size);
+	mutex_unlock(&chip->buffer_mutex);
+
+	/* Set a timeout by which the reader must come claim the result */
+	mod_timer(&chip->user_read_timer, jiffies + (60 * HZ));
+
+	return in_size;
+}
+
+/*
+ * Called on file close
+ */
+static int tpm_release(struct inode *inode, struct file *file)
+{
+	struct tpm_chip *chip = file->private_data;
+
+	del_singleshot_timer_sync(&chip->user_read_timer);
+	flush_work(&chip->work);
+	file->private_data = NULL;
+	atomic_set(&chip->data_pending, 0);
+	kzfree(chip->data_buffer);
+	clear_bit(0, &chip->is_open);
+	put_device(chip->dev);
+	return 0;
+}
+
+static const struct file_operations tpm_fops = {
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.open = tpm_open,
+	.read = tpm_read,
+	.write = tpm_write,
+	.release = tpm_release,
+};
+
+int tpm_dev_add_device(struct tpm_chip *chip)
+{
+	int rc;
+
+	mutex_init(&chip->buffer_mutex);
+	INIT_WORK(&chip->work, timeout_work);
+
+	setup_timer(&chip->user_read_timer, user_reader_timeout,
+			(unsigned long)chip);
+
+	chip->vendor.miscdev.fops = &tpm_fops;
+	if (chip->dev_num == 0)
+		chip->vendor.miscdev.minor = TPM_MINOR;
+	else
+		chip->vendor.miscdev.minor = MISC_DYNAMIC_MINOR;
+
+	chip->vendor.miscdev.name = chip->devname;
+	chip->vendor.miscdev.parent = chip->dev;
+
+	rc = misc_register(&chip->vendor.miscdev);
+	if (rc) {
+		chip->vendor.miscdev.name = NULL;
+		dev_warn(chip->dev,
+			"unable to misc_register %s, minor %d err=%d\n",
+			 chip->vendor.miscdev.name,
+			 chip->vendor.miscdev.minor, rc);
+	}
+	return rc;
+}
+
+void tpm_dev_del_device(struct tpm_chip *chip)
+{
+	if (chip->vendor.miscdev.name)
+		misc_deregister(&chip->vendor.miscdev);
+}
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 6ae41d3..9b9bb7b 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -312,23 +312,6 @@ static const u8 tpm_ordinal_duration[TPM_MAX_ORDINAL] = {
 	TPM_MEDIUM,
 };
 
-static void user_reader_timeout(unsigned long ptr)
-{
-	struct tpm_chip *chip = (struct tpm_chip *) ptr;
-
-	schedule_work(&chip->work);
-}
-
-static void timeout_work(struct work_struct *work)
-{
-	struct tpm_chip *chip = container_of(work, struct tpm_chip, work);
-
-	mutex_lock(&chip->buffer_mutex);
-	atomic_set(&chip->data_pending, 0);
-	memset(chip->data_buffer, 0, TPM_BUFSIZE);
-	mutex_unlock(&chip->buffer_mutex);
-}
-
 /*
  * Returns max number of jiffies to wait
  */
@@ -355,8 +338,8 @@ EXPORT_SYMBOL_GPL(tpm_calc_ordinal_duration);
 /*
  * Internal kernel interface to transmit TPM commands
  */
-static ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
-			    size_t bufsiz)
+ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
+		     size_t bufsiz)
 {
 	ssize_t rc;
 	u32 count, ordinal;
@@ -1151,127 +1134,6 @@ again:
 	return -ETIME;
 }
 EXPORT_SYMBOL_GPL(wait_for_tpm_stat);
-/*
- * Device file system interface to the TPM
- *
- * It's assured that the chip will be opened just once,
- * by the check of is_open variable, which is protected
- * by driver_lock.
- */
-int tpm_open(struct inode *inode, struct file *file)
-{
-	struct miscdevice *misc = file->private_data;
-	struct tpm_chip *chip = container_of(misc, struct tpm_chip,
-					     vendor.miscdev);
-
-	if (test_and_set_bit(0, &chip->is_open)) {
-		dev_dbg(chip->dev, "Another process owns this TPM\n");
-		return -EBUSY;
-	}
-
-	chip->data_buffer = kzalloc(TPM_BUFSIZE, GFP_KERNEL);
-	if (chip->data_buffer == NULL) {
-		clear_bit(0, &chip->is_open);
-		return -ENOMEM;
-	}
-
-	atomic_set(&chip->data_pending, 0);
-
-	file->private_data = chip;
-	get_device(chip->dev);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(tpm_open);
-
-/*
- * Called on file close
- */
-int tpm_release(struct inode *inode, struct file *file)
-{
-	struct tpm_chip *chip = file->private_data;
-
-	del_singleshot_timer_sync(&chip->user_read_timer);
-	flush_work(&chip->work);
-	file->private_data = NULL;
-	atomic_set(&chip->data_pending, 0);
-	kzfree(chip->data_buffer);
-	clear_bit(0, &chip->is_open);
-	put_device(chip->dev);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(tpm_release);
-
-ssize_t tpm_write(struct file *file, const char __user *buf,
-		  size_t size, loff_t *off)
-{
-	struct tpm_chip *chip = file->private_data;
-	size_t in_size = size;
-	ssize_t out_size;
-
-	/* cannot perform a write until the read has cleared
-	   either via tpm_read or a user_read_timer timeout.
-	   This also prevents splitted buffered writes from blocking here.
-	*/
-	if (atomic_read(&chip->data_pending) != 0)
-		return -EBUSY;
-
-	if (in_size > TPM_BUFSIZE)
-		return -E2BIG;
-
-	mutex_lock(&chip->buffer_mutex);
-
-	if (copy_from_user
-	    (chip->data_buffer, (void __user *) buf, in_size)) {
-		mutex_unlock(&chip->buffer_mutex);
-		return -EFAULT;
-	}
-
-	/* atomic tpm command send and result receive */
-	out_size = tpm_transmit(chip, chip->data_buffer, TPM_BUFSIZE);
-	if (out_size < 0) {
-		mutex_unlock(&chip->buffer_mutex);
-		return out_size;
-	}
-
-	atomic_set(&chip->data_pending, out_size);
-	mutex_unlock(&chip->buffer_mutex);
-
-	/* Set a timeout by which the reader must come claim the result */
-	mod_timer(&chip->user_read_timer, jiffies + (60 * HZ));
-
-	return in_size;
-}
-EXPORT_SYMBOL_GPL(tpm_write);
-
-ssize_t tpm_read(struct file *file, char __user *buf,
-		 size_t size, loff_t *off)
-{
-	struct tpm_chip *chip = file->private_data;
-	ssize_t ret_size;
-	int rc;
-
-	del_singleshot_timer_sync(&chip->user_read_timer);
-	flush_work(&chip->work);
-	ret_size = atomic_read(&chip->data_pending);
-	if (ret_size > 0) {	/* relay data */
-		ssize_t orig_ret_size = ret_size;
-		if (size < ret_size)
-			ret_size = size;
-
-		mutex_lock(&chip->buffer_mutex);
-		rc = copy_to_user(buf, chip->data_buffer, ret_size);
-		memset(chip->data_buffer, 0, orig_ret_size);
-		if (rc)
-			ret_size = -EFAULT;
-
-		mutex_unlock(&chip->buffer_mutex);
-	}
-
-	atomic_set(&chip->data_pending, 0);
-
-	return ret_size;
-}
-EXPORT_SYMBOL_GPL(tpm_read);
 
 void tpm_remove_hardware(struct device *dev)
 {
@@ -1287,7 +1149,7 @@ void tpm_remove_hardware(struct device *dev)
 	spin_unlock(&driver_lock);
 	synchronize_rcu();
 
-	misc_deregister(&chip->vendor.miscdev);
+	tpm_dev_del_device(chip);
 	sysfs_remove_group(&dev->kobj, chip->vendor.attr_group);
 	tpm_remove_ppi(&dev->kobj);
 	tpm_bios_log_teardown(chip->bios_dir);
@@ -1480,15 +1342,9 @@ struct tpm_chip *tpm_register_hardware(struct device *dev,
 	if (chip == NULL)
 		return NULL;
 
-	mutex_init(&chip->buffer_mutex);
 	mutex_init(&chip->tpm_mutex);
 	INIT_LIST_HEAD(&chip->list);
 
-	INIT_WORK(&chip->work, timeout_work);
-
-	setup_timer(&chip->user_read_timer, user_reader_timeout,
-			(unsigned long)chip);
-
 	memcpy(&chip->vendor, entry, sizeof(struct tpm_vendor_specific));
 
 	chip->dev_num = find_first_zero_bit(dev_mask, TPM_NUM_DEVICES);
@@ -1496,40 +1352,26 @@ struct tpm_chip *tpm_register_hardware(struct device *dev,
 	if (chip->dev_num >= TPM_NUM_DEVICES) {
 		dev_err(dev, "No available tpm device numbers\n");
 		goto out_free;
-	} else if (chip->dev_num == 0)
-		chip->vendor.miscdev.minor = TPM_MINOR;
-	else
-		chip->vendor.miscdev.minor = MISC_DYNAMIC_MINOR;
+	}
 
 	set_bit(chip->dev_num, dev_mask);
 
 	scnprintf(chip->devname, sizeof(chip->devname), "%s%d", "tpm",
 		  chip->dev_num);
-	chip->vendor.miscdev.name = chip->devname;
 
-	chip->vendor.miscdev.parent = dev;
 	chip->dev = get_device(dev);
 	chip->release = dev->release;
 	dev->release = tpm_dev_release;
 	dev_set_drvdata(dev, chip);
 
-	if (misc_register(&chip->vendor.miscdev)) {
-		dev_err(chip->dev,
-			"unable to misc_register %s, minor %d\n",
-			chip->vendor.miscdev.name,
-			chip->vendor.miscdev.minor);
+	if (tpm_dev_add_device(chip))
 		goto put_device;
-	}
 
-	if (sysfs_create_group(&dev->kobj, chip->vendor.attr_group)) {
-		misc_deregister(&chip->vendor.miscdev);
-		goto put_device;
-	}
+	if (sysfs_create_group(&dev->kobj, chip->vendor.attr_group))
+		goto del_misc;
 
-	if (tpm_add_ppi(&dev->kobj)) {
-		misc_deregister(&chip->vendor.miscdev);
-		goto put_device;
-	}
+	if (tpm_add_ppi(&dev->kobj))
+		goto del_misc;
 
 	chip->bios_dir = tpm_bios_log_setup(chip->devname);
 
@@ -1540,6 +1382,8 @@ struct tpm_chip *tpm_register_hardware(struct device *dev,
 
 	return chip;
 
+del_misc:
+	tpm_dev_del_device(chip);
 put_device:
 	put_device(chip->dev);
 out_free:
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index f328478..496228c 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -323,25 +323,24 @@ struct tpm_cmd_t {
 
 ssize_t	tpm_getcap(struct device *, __be32, cap_t *, const char *);
 
+ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
+		     size_t bufsiz);
 extern int tpm_get_timeouts(struct tpm_chip *);
 extern void tpm_gen_interrupt(struct tpm_chip *);
 extern int tpm_do_selftest(struct tpm_chip *);
 extern unsigned long tpm_calc_ordinal_duration(struct tpm_chip *, u32);
 extern struct tpm_chip* tpm_register_hardware(struct device *,
 				 const struct tpm_vendor_specific *);
-extern int tpm_open(struct inode *, struct file *);
-extern int tpm_release(struct inode *, struct file *);
-extern void tpm_dev_release(struct device *dev);
 extern void tpm_dev_vendor_release(struct tpm_chip *);
-extern ssize_t tpm_write(struct file *, const char __user *, size_t,
-			 loff_t *);
-extern ssize_t tpm_read(struct file *, char __user *, size_t, loff_t *);
 extern void tpm_remove_hardware(struct device *);
 extern int tpm_pm_suspend(struct device *);
 extern int tpm_pm_resume(struct device *);
 extern int wait_for_tpm_stat(struct tpm_chip *, u8, unsigned long,
 			     wait_queue_head_t *, bool);
 
+int tpm_dev_add_device(struct tpm_chip *chip);
+void tpm_dev_del_device(struct tpm_chip *chip);
+
 #ifdef CONFIG_ACPI
 extern int tpm_add_ppi(struct kobject *);
 extern void tpm_remove_ppi(struct kobject *);
diff --git a/drivers/char/tpm/tpm_atmel.c b/drivers/char/tpm/tpm_atmel.c
index c9a528d..9692e2f 100644
--- a/drivers/char/tpm/tpm_atmel.c
+++ b/drivers/char/tpm/tpm_atmel.c
@@ -121,15 +121,6 @@ static bool tpm_atml_req_canceled(struct tpm_chip *chip, u8 status)
 	return (status == ATML_STATUS_READY);
 }
 
-static const struct file_operations atmel_ops = {
-	.owner = THIS_MODULE,
-	.llseek = no_llseek,
-	.open = tpm_open,
-	.read = tpm_read,
-	.write = tpm_write,
-	.release = tpm_release,
-};
-
 static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
 static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
 static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps, NULL);
@@ -154,7 +145,6 @@ static const struct tpm_vendor_specific tpm_atmel = {
 	.req_complete_val = ATML_STATUS_DATA_AVAIL,
 	.req_canceled = tpm_atml_req_canceled,
 	.attr_group = &atmel_attr_grp,
-	.miscdev = { .fops = &atmel_ops, },
 };
 
 static struct platform_device *pdev;
diff --git a/drivers/char/tpm/tpm_i2c_atmel.c b/drivers/char/tpm/tpm_i2c_atmel.c
index af6805b..079c19d 100644
--- a/drivers/char/tpm/tpm_i2c_atmel.c
+++ b/drivers/char/tpm/tpm_i2c_atmel.c
@@ -135,15 +135,6 @@ static u8 i2c_atmel_read_status(struct tpm_chip *chip)
 	return ATMEL_STS_OK;
 }
 
-static const struct file_operations i2c_atmel_ops = {
-	.owner = THIS_MODULE,
-	.llseek = no_llseek,
-	.open = tpm_open,
-	.read = tpm_read,
-	.write = tpm_write,
-	.release = tpm_release,
-};
-
 static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
 static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
 static DEVICE_ATTR(enabled, S_IRUGO, tpm_show_enabled, NULL);
@@ -187,7 +178,6 @@ static const struct tpm_vendor_specific i2c_atmel = {
 	.req_complete_val = ATMEL_STS_OK,
 	.req_canceled = i2c_atmel_req_canceled,
 	.attr_group = &i2c_atmel_attr_grp,
-	.miscdev.fops = &i2c_atmel_ops,
 };
 
 static int i2c_atmel_probe(struct i2c_client *client,
diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
index fefd2aa..c1ba7fa 100644
--- a/drivers/char/tpm/tpm_i2c_infineon.c
+++ b/drivers/char/tpm/tpm_i2c_infineon.c
@@ -566,15 +566,6 @@ static bool tpm_tis_i2c_req_canceled(struct tpm_chip *chip, u8 status)
 	return (status == TPM_STS_COMMAND_READY);
 }
 
-static const struct file_operations tis_ops = {
-	.owner = THIS_MODULE,
-	.llseek = no_llseek,
-	.open = tpm_open,
-	.read = tpm_read,
-	.write = tpm_write,
-	.release = tpm_release,
-};
-
 static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
 static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
 static DEVICE_ATTR(enabled, S_IRUGO, tpm_show_enabled, NULL);
@@ -613,7 +604,6 @@ static struct tpm_vendor_specific tpm_tis_i2c = {
 	.req_complete_val = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
 	.req_canceled = tpm_tis_i2c_req_canceled,
 	.attr_group = &tis_attr_grp,
-	.miscdev.fops = &tis_ops,
 };
 
 static int tpm_tis_i2c_init(struct device *dev)
diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_i2c_nuvoton.c
index 6276fea..3766fe7 100644
--- a/drivers/char/tpm/tpm_i2c_nuvoton.c
+++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
@@ -456,15 +456,6 @@ static bool i2c_nuvoton_req_canceled(struct tpm_chip *chip, u8 status)
 	return (status == TPM_STS_COMMAND_READY);
 }
 
-static const struct file_operations i2c_nuvoton_ops = {
-	.owner = THIS_MODULE,
-	.llseek = no_llseek,
-	.open = tpm_open,
-	.read = tpm_read,
-	.write = tpm_write,
-	.release = tpm_release,
-};
-
 static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
 static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
 static DEVICE_ATTR(enabled, S_IRUGO, tpm_show_enabled, NULL);
@@ -503,7 +494,6 @@ static const struct tpm_vendor_specific tpm_i2c = {
 	.req_complete_val = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
 	.req_canceled = i2c_nuvoton_req_canceled,
 	.attr_group = &i2c_nuvoton_attr_grp,
-	.miscdev.fops = &i2c_nuvoton_ops,
 };
 
 /* The only purpose for the handler is to signal to any waiting threads that
diff --git a/drivers/char/tpm/tpm_i2c_stm_st33.c b/drivers/char/tpm/tpm_i2c_stm_st33.c
index cf68403..e519e68 100644
--- a/drivers/char/tpm/tpm_i2c_stm_st33.c
+++ b/drivers/char/tpm/tpm_i2c_stm_st33.c
@@ -574,15 +574,6 @@ static bool tpm_st33_i2c_req_canceled(struct tpm_chip *chip, u8 status)
 	return (status == TPM_STS_COMMAND_READY);
 }
 
-static const struct file_operations tpm_st33_i2c_fops = {
-	.owner = THIS_MODULE,
-	.llseek = no_llseek,
-	.read = tpm_read,
-	.write = tpm_write,
-	.open = tpm_open,
-	.release = tpm_release,
-};
-
 static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
 static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
 static DEVICE_ATTR(enabled, S_IRUGO, tpm_show_enabled, NULL);
@@ -616,7 +607,6 @@ static struct tpm_vendor_specific st_i2c_tpm = {
 	.req_complete_val = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
 	.req_canceled = tpm_st33_i2c_req_canceled,
 	.attr_group = &stm_tpm_attr_grp,
-	.miscdev = {.fops = &tpm_st33_i2c_fops,},
 };
 
 static int interrupts;
diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
index 42ff798..14af0c1 100644
--- a/drivers/char/tpm/tpm_ibmvtpm.c
+++ b/drivers/char/tpm/tpm_ibmvtpm.c
@@ -404,15 +404,6 @@ static bool tpm_ibmvtpm_req_canceled(struct tpm_chip *chip, u8 status)
 	return (status == 0);
 }
 
-static const struct file_operations ibmvtpm_ops = {
-	.owner = THIS_MODULE,
-	.llseek = no_llseek,
-	.open = tpm_open,
-	.read = tpm_read,
-	.write = tpm_write,
-	.release = tpm_release,
-};
-
 static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
 static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
 static DEVICE_ATTR(enabled, S_IRUGO, tpm_show_enabled, NULL);
@@ -449,7 +440,6 @@ static const struct tpm_vendor_specific tpm_ibmvtpm = {
 	.req_complete_val = 0,
 	.req_canceled = tpm_ibmvtpm_req_canceled,
 	.attr_group = &ibmvtpm_attr_grp,
-	.miscdev = { .fops = &ibmvtpm_ops, },
 };
 
 static const struct dev_pm_ops tpm_ibmvtpm_pm_ops = {
diff --git a/drivers/char/tpm/tpm_infineon.c b/drivers/char/tpm/tpm_infineon.c
index 2b480c2..c75c10c 100644
--- a/drivers/char/tpm/tpm_infineon.c
+++ b/drivers/char/tpm/tpm_infineon.c
@@ -386,15 +386,6 @@ static struct attribute *inf_attrs[] = {
 
 static struct attribute_group inf_attr_grp = {.attrs = inf_attrs };
 
-static const struct file_operations inf_ops = {
-	.owner = THIS_MODULE,
-	.llseek = no_llseek,
-	.open = tpm_open,
-	.read = tpm_read,
-	.write = tpm_write,
-	.release = tpm_release,
-};
-
 static const struct tpm_vendor_specific tpm_inf = {
 	.recv = tpm_inf_recv,
 	.send = tpm_inf_send,
@@ -403,7 +394,6 @@ static const struct tpm_vendor_specific tpm_inf = {
 	.req_complete_mask = 0,
 	.req_complete_val = 0,
 	.attr_group = &inf_attr_grp,
-	.miscdev = {.fops = &inf_ops,},
 };
 
 static const struct pnp_device_id tpm_inf_pnp_tbl[] = {
diff --git a/drivers/char/tpm/tpm_nsc.c b/drivers/char/tpm/tpm_nsc.c
index 770c46f..a4acac9 100644
--- a/drivers/char/tpm/tpm_nsc.c
+++ b/drivers/char/tpm/tpm_nsc.c
@@ -232,15 +232,6 @@ static bool tpm_nsc_req_canceled(struct tpm_chip *chip, u8 status)
 	return (status == NSC_STATUS_RDY);
 }
 
-static const struct file_operations nsc_ops = {
-	.owner = THIS_MODULE,
-	.llseek = no_llseek,
-	.open = tpm_open,
-	.read = tpm_read,
-	.write = tpm_write,
-	.release = tpm_release,
-};
-
 static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
 static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
 static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps, NULL);
@@ -265,7 +256,6 @@ static const struct tpm_vendor_specific tpm_nsc = {
 	.req_complete_val = NSC_STATUS_OBF,
 	.req_canceled = tpm_nsc_req_canceled,
 	.attr_group = &nsc_attr_grp,
-	.miscdev = { .fops = &nsc_ops, },
 };
 
 static struct platform_device *pdev = NULL;
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 0732a1e..c606ca1 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -432,15 +432,6 @@ static bool tpm_tis_req_canceled(struct tpm_chip *chip, u8 status)
 	}
 }
 
-static const struct file_operations tis_ops = {
-	.owner = THIS_MODULE,
-	.llseek = no_llseek,
-	.open = tpm_open,
-	.read = tpm_read,
-	.write = tpm_write,
-	.release = tpm_release,
-};
-
 static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
 static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
 static DEVICE_ATTR(enabled, S_IRUGO, tpm_show_enabled, NULL);
@@ -479,8 +470,6 @@ static struct tpm_vendor_specific tpm_tis = {
 	.req_complete_val = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
 	.req_canceled = tpm_tis_req_canceled,
 	.attr_group = &tis_attr_grp,
-	.miscdev = {
-		    .fops = &tis_ops,},
 };
 
 static irqreturn_t tis_int_probe(int irq, void *dev_id)
diff --git a/drivers/char/tpm/xen-tpmfront.c b/drivers/char/tpm/xen-tpmfront.c
index c8ff4df..e3c7c01 100644
--- a/drivers/char/tpm/xen-tpmfront.c
+++ b/drivers/char/tpm/xen-tpmfront.c
@@ -143,15 +143,6 @@ static int vtpm_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 	return length;
 }
 
-static const struct file_operations vtpm_ops = {
-	.owner = THIS_MODULE,
-	.llseek = no_llseek,
-	.open = tpm_open,
-	.read = tpm_read,
-	.write = tpm_write,
-	.release = tpm_release,
-};
-
 static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
 static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
 static DEVICE_ATTR(enabled, S_IRUGO, tpm_show_enabled, NULL);
@@ -191,9 +182,6 @@ static const struct tpm_vendor_specific tpm_vtpm = {
 	.req_complete_val  = VTPM_STATUS_IDLE | VTPM_STATUS_RESULT,
 	.req_canceled      = vtpm_req_canceled,
 	.attr_group = &vtpm_attr_grp,
-	.miscdev = {
-		.fops = &vtpm_ops,
-	},
 };
 
 static irqreturn_t tpmif_interrupt(int dummy, void *dev_id)
-- 
1.8.1.2

