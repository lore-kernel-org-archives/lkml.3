Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab3JUWeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:34:00 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:33061 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab3JUWd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:33:56 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [RFC v2 3/6] drm: split drm_release()
Date: Tue, 22 Oct 2013 00:33:25 +0200
Message-Id: <1382394808-20611-4-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1382394808-20611-1-git-send-email-dh.herrmann@gmail.com>
References: <1382394808-20611-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This splits off real file-destruction into drm_close(). drm_release() now
calls drm_close() and then takes care of any device-cleanup which isn't
strictly related to file-destruction.

Besides making the code more readable, this is needed if we want to close
open-files during GPU unplug. We could simply fake a drm_close() on each
open-file now to logically close them.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 drivers/gpu/drm/drm_fops.c | 65 +++++++++++++++++++++++++++-------------------
 include/drm/drmP.h         |  1 +
 2 files changed, 39 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/drm/drm_fops.c b/drivers/gpu/drm/drm_fops.c
index d0e2766..ecdd647 100644
--- a/drivers/gpu/drm/drm_fops.c
+++ b/drivers/gpu/drm/drm_fops.c
@@ -450,34 +450,26 @@ int drm_lastclose(struct drm_device * dev)
 }
 
 /**
- * Release file.
+ * drm_close - Close open DRM file
+ * @file_priv: Open DRM-file to close
  *
- * \param inode device inode
- * \param file_priv DRM file private.
- * \return zero on success or a negative number on failure.
+ * This does the real work of drm_release(). All allocated data is freed and
+ * locks are released. drm_global_mutex must be locked by the caller. The
+ * drm_file object is not freed and @file_priv->minor->dev stays valid.
  *
- * If the hardware lock is held then free it, and take it again for the kernel
- * context since it's necessary to reclaim buffers. Unlink the file private
- * data from its list and free it. Decreases the open count and if it reaches
- * zero calls drm_lastclose().
+ * This does not call drm_lastclose() or any device-cleanup helpers. It's the
+ * callers responsibility to do this. Drivers must not call this directly. Use
+ * drm_release() instead.
  */
-int drm_release(struct inode *inode, struct file *filp)
+void drm_close(struct drm_file *file_priv)
 {
-	struct drm_file *file_priv = filp->private_data;
 	struct drm_device *dev = file_priv->minor->dev;
-	int retcode = 0;
-
-	mutex_lock(&drm_global_mutex);
 
 	DRM_DEBUG("open_count = %d\n", dev->open_count);
 
 	if (dev->driver->preclose)
 		dev->driver->preclose(dev, file_priv);
 
-	/* ========================================================
-	 * Begin inline drm_release
-	 */
-
 	DRM_DEBUG("pid = %d, device = 0x%lx, open_count = %d\n",
 		  task_pid_nr(current),
 		  (long)old_encode_dev(file_priv->minor->device),
@@ -490,7 +482,7 @@ int drm_release(struct inode *inode, struct file *filp)
 
 	/* if the master has gone away we can't do anything with the lock */
 	if (file_priv->minor->master)
-		drm_master_release(dev, filp);
+		drm_master_release(dev, file_priv->filp);
 
 	if (drm_core_check_feature(dev, DRIVER_HAVE_DMA))
 		drm_core_reclaim_buffers(dev, file_priv);
@@ -573,25 +565,44 @@ int drm_release(struct inode *inode, struct file *filp)
 		drm_prime_destroy_file_private(&file_priv->prime);
 
 	put_pid(file_priv->pid);
-	kfree(file_priv);
+}
 
-	/* ========================================================
-	 * End inline drm_release
-	 */
+/**
+ * drm_release - Release open DRM file
+ * @inode: device inode
+ * @file_priv: DRM file
+ *
+ * Release an open DRM file. This is the default callback for DRM fops.
+ * We free all internally allocated data, release held locks and unlink the
+ * open-file from the DRM device. If this is the last user of the unplugged
+ * device, we also release the device.
+ *
+ * RETURNS:
+ * Returns always zero.
+ */
+int drm_release(struct inode *inode, struct file *filp)
+{
+	struct drm_file *file_priv = filp->private_data;
+	struct drm_device *dev = file_priv->minor->dev;
+
+	mutex_lock(&drm_global_mutex);
+
+	drm_close(file_priv);
+	kfree(file_priv);
 
 	if (!--dev->open_count) {
-		if (atomic_read(&dev->ioctl_count)) {
+		if (atomic_read(&dev->ioctl_count))
 			DRM_ERROR("Device busy: %d\n",
 				  atomic_read(&dev->ioctl_count));
-			retcode = -EBUSY;
-		} else
-			retcode = drm_lastclose(dev);
+		else
+			drm_lastclose(dev);
 		if (drm_device_is_unplugged(dev))
 			drm_put_dev(dev);
 	}
+
 	mutex_unlock(&drm_global_mutex);
 
-	return retcode;
+	return 0;
 }
 EXPORT_SYMBOL(drm_release);
 
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index 19b8082..16ff7c4 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -1268,6 +1268,7 @@ extern int drm_open(struct inode *inode, struct file *filp);
 extern int drm_stub_open(struct inode *inode, struct file *filp);
 extern ssize_t drm_read(struct file *filp, char __user *buffer,
 			size_t count, loff_t *offset);
+extern void drm_close(struct drm_file *file_priv);
 extern int drm_release(struct inode *inode, struct file *filp);
 
 				/* Mapping support (drm_vm.h) */
-- 
1.8.4.1

