Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982AbaA1XWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:22:54 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:37366 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913AbaA1XWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:22:10 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, stern@rowland.harvard.edu,
        JBottomley@parallels.com, bhelgaas@google.com,
        Tejun Heo <tj@kernel.org>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH 10/11] s390: use device_remove_file_self() instead of device_schedule_callback()
Date: Tue, 28 Jan 2014 18:21:50 -0500
Message-Id: <1390951311-15325-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390951311-15325-1-git-send-email-tj@kernel.org>
References: <1390951311-15325-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

driver-core now supports synchrnous self-deletion of attributes and
the asynchrnous removal mechanism is scheduled for removal.  Use it
instead of device_schedule_callback().

* Conversions in arch/s390/pci/pci_sysfs.c and
  drivers/s390/block/dcssblk.c are straightforward.

* drivers/s390/cio/ccwgroup.c is a bit more tricky because
  ccwgroup_notifier() was (ab)using device_schedule_callback() to
  purely obtain a process context to kick off ungroup operation which
  may block from a notifier callback.

  Rename ccwgroup_ungroup_callback() to ccwgroup_ungroup() and make it
  take ccwgroup_device * instead.  The new function is now called
  directly from ccwgroup_ungroup_store().

  ccwgroup_notifier() chain is updated to explicitly bounce through
  ccwgroup_device->ungroup_work.  This also removes possible failure
  from memory pressure.

Only compile-tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org
---
 arch/s390/include/asm/ccwgroup.h |  1 +
 arch/s390/pci/pci_sysfs.c        | 18 ++++++++----------
 drivers/s390/block/dcssblk.c     | 14 +++++++-------
 drivers/s390/cio/ccwgroup.c      | 26 ++++++++++++++++----------
 4 files changed, 32 insertions(+), 27 deletions(-)

diff --git a/arch/s390/include/asm/ccwgroup.h b/arch/s390/include/asm/ccwgroup.h
index 23723ce..6e670f8 100644
--- a/arch/s390/include/asm/ccwgroup.h
+++ b/arch/s390/include/asm/ccwgroup.h
@@ -23,6 +23,7 @@ struct ccwgroup_device {
 	unsigned int count;
 	struct device	dev;
 	struct ccw_device *cdev[0];
+	struct work_struct ungroup_work;
 };
 
 /**
diff --git a/arch/s390/pci/pci_sysfs.c b/arch/s390/pci/pci_sysfs.c
index cf8a12f..ab4a913 100644
--- a/arch/s390/pci/pci_sysfs.c
+++ b/arch/s390/pci/pci_sysfs.c
@@ -48,29 +48,27 @@ static ssize_t show_pfgid(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR(pfgid, S_IRUGO, show_pfgid, NULL);
 
-static void recover_callback(struct device *dev)
+static ssize_t store_recover(struct device *dev, struct device_attribute *attr,
+			     const char *buf, size_t count)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct zpci_dev *zdev = get_zdev(pdev);
 	int ret;
 
+	if (!device_remove_file_self(dev, attr))
+		return count;
+
 	pci_stop_and_remove_bus_device(pdev);
 	ret = zpci_disable_device(zdev);
 	if (ret)
-		return;
+		return ret;
 
 	ret = zpci_enable_device(zdev);
 	if (ret)
-		return;
+		return ret;
 
 	pci_rescan_bus(zdev->bus);
-}
-
-static ssize_t store_recover(struct device *dev, struct device_attribute *attr,
-			     const char *buf, size_t count)
-{
-	int rc = device_schedule_callback(dev, recover_callback);
-	return rc ? rc : count;
+	return count;
 }
 static DEVICE_ATTR(recover, S_IWUSR, NULL, store_recover);
 
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 6eca019..2e2f454 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -304,12 +304,6 @@ dcssblk_load_segment(char *name, struct segment_info **seg_info)
 	return rc;
 }
 
-static void dcssblk_unregister_callback(struct device *dev)
-{
-	device_unregister(dev);
-	put_device(dev);
-}
-
 /*
  * device attribute for switching shared/nonshared (exclusive)
  * operation (show + store)
@@ -397,7 +391,13 @@ removeseg:
 	blk_cleanup_queue(dev_info->dcssblk_queue);
 	dev_info->gd->queue = NULL;
 	put_disk(dev_info->gd);
-	rc = device_schedule_callback(dev, dcssblk_unregister_callback);
+	up_write(&dcssblk_devices_sem);
+
+	if (device_remove_file_self(dev, attr)) {
+		device_unregister(dev);
+		put_device(dev);
+	}
+	return rc;
 out:
 	up_write(&dcssblk_devices_sem);
 	return rc;
diff --git a/drivers/s390/cio/ccwgroup.c b/drivers/s390/cio/ccwgroup.c
index fd3367a1..dfd7bc6 100644
--- a/drivers/s390/cio/ccwgroup.c
+++ b/drivers/s390/cio/ccwgroup.c
@@ -168,14 +168,12 @@ static ssize_t ccwgroup_online_show(struct device *dev,
  * Provide an 'ungroup' attribute so the user can remove group devices no
  * longer needed or accidentially created. Saves memory :)
  */
-static void ccwgroup_ungroup_callback(struct device *dev)
+static void ccwgroup_ungroup(struct ccwgroup_device *gdev)
 {
-	struct ccwgroup_device *gdev = to_ccwgroupdev(dev);
-
 	mutex_lock(&gdev->reg_mutex);
 	if (device_is_registered(&gdev->dev)) {
 		__ccwgroup_remove_symlinks(gdev);
-		device_unregister(dev);
+		device_unregister(&gdev->dev);
 		__ccwgroup_remove_cdev_refs(gdev);
 	}
 	mutex_unlock(&gdev->reg_mutex);
@@ -195,10 +193,9 @@ static ssize_t ccwgroup_ungroup_store(struct device *dev,
 		rc = -EINVAL;
 		goto out;
 	}
-	/* Note that we cannot unregister the device from one of its
-	 * attribute methods, so we have to use this roundabout approach.
-	 */
-	rc = device_schedule_callback(dev, ccwgroup_ungroup_callback);
+
+	if (device_remove_file_self(dev, attr))
+		ccwgroup_ungroup(gdev);
 out:
 	if (rc) {
 		if (rc != -EAGAIN)
@@ -224,6 +221,14 @@ static const struct attribute_group *ccwgroup_attr_groups[] = {
 	NULL,
 };
 
+static void ccwgroup_ungroup_workfn(struct work_struct *work)
+{
+	struct ccwgroup_device *gdev =
+		container_of(work, struct ccwgroup_device, ungroup_work);
+
+	ccwgroup_ungroup(gdev);
+}
+
 static void ccwgroup_release(struct device *dev)
 {
 	kfree(to_ccwgroupdev(dev));
@@ -323,6 +328,7 @@ int ccwgroup_create_dev(struct device *parent, struct ccwgroup_driver *gdrv,
 	atomic_set(&gdev->onoff, 0);
 	mutex_init(&gdev->reg_mutex);
 	mutex_lock(&gdev->reg_mutex);
+	INIT_WORK(&gdev->ungroup_work, ccwgroup_ungroup_workfn);
 	gdev->count = num_devices;
 	gdev->dev.bus = &ccwgroup_bus_type;
 	gdev->dev.parent = parent;
@@ -404,10 +410,10 @@ EXPORT_SYMBOL(ccwgroup_create_dev);
 static int ccwgroup_notifier(struct notifier_block *nb, unsigned long action,
 			     void *data)
 {
-	struct device *dev = data;
+	struct ccwgroup_device *gdev = to_ccwgroupdev(data);
 
 	if (action == BUS_NOTIFY_UNBIND_DRIVER)
-		device_schedule_callback(dev, ccwgroup_ungroup_callback);
+		schedule_work(&gdev->ungroup_work);
 
 	return NOTIFY_OK;
 }
-- 
1.8.5.3

