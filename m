Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab3JUWeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:34:24 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:50740 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab3JUWeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:34:00 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [RFC v2 5/6] drm: make drm_dev_unregister() immediate
Date: Tue, 22 Oct 2013 00:33:27 +0200
Message-Id: <1382394808-20611-6-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1382394808-20611-1-git-send-email-dh.herrmann@gmail.com>
References: <1382394808-20611-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers which support unplugging currently use drm_unplug_dev() which
waits for all open files to be closed before unregistering a device. All
other drivers just immediately unregister the device if unplugged or
unloaded, which results in panics if there're pending open files.

This patch implements proper revoke support for DRM devices. We remove
drm_unplug_dev() and make drm_put_dev() an alias for drm_dev_unregister().
Instead of plainly unregistering the device, we now mark the device as
dead, close all open files and then unregister the device. This guarantees
that all pending actions are done, no new actions can happen and the
device is properly unregistered and destroyed.

As the underlying VFS layer doesn't provide revoke support for us, we need
some special workarounds to support it properly. Any open file still has
the file->f_private pointer set to their drm_file object. We cannot reset
this pointer so we must keep it allocated. Fortunately, any f_op accesses
((drm_file*)file->f_private)->minor->dev and checks whether the given
drm_device is still active before accessing anything else. So what we do
during device shutdown is:
 1: Mark the device as dead
 2: Wait for all pending f_ops to finish
 3: Call drm_close() for all open files to fake a close()
 4: Only if no (dead) open-file remains, we free the drm_device

This procedure guarantees that any pending open-file is now dead but not
freed. So any further f_op will return ENODEV as drm_dev_get_active() will
fail. Any following real close() call will notice that the device is dead
and skip the call to drm_close(). Instead, it simply frees the drm_file
private data and decreases the open-count. Once the open-count drops to 0
and the device is already unplugged, the last drm_release() will free the
DRM-device.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 drivers/gpu/drm/drm_fops.c    | 29 +++++++++++++-----
 drivers/gpu/drm/drm_stub.c    | 68 ++++++++++++++++++++++++++-----------------
 drivers/gpu/drm/udl/udl_drv.c |  2 +-
 include/drm/drmP.h            |  1 -
 4 files changed, 65 insertions(+), 35 deletions(-)

diff --git a/drivers/gpu/drm/drm_fops.c b/drivers/gpu/drm/drm_fops.c
index 3884185..c860376 100644
--- a/drivers/gpu/drm/drm_fops.c
+++ b/drivers/gpu/drm/drm_fops.c
@@ -585,22 +585,37 @@ int drm_release(struct inode *inode, struct file *filp)
 {
 	struct drm_file *file_priv = filp->private_data;
 	struct drm_device *dev = file_priv->minor->dev;
+	bool active, alive;
 
 	mutex_lock(&drm_global_mutex);
 
-	drm_close(file_priv);
+	/* The additional test against dev->filelist is required as
+	 * drm_dev_unregister() cannot hold drm_global_mutex while locking
+	 * dev->active. So if we're called in the short window between
+	 * dev->unplugged being set but drm_global_mutex not yet locked in
+	 * drm_dev_unregister(), we notice it as dev->filelist cannot be empty.
+	 * We treat it as if the device was still active as drm_dev_unregister()
+	 * will wait for us to drop drm_global_mutex, anyway. */
+	active = drm_dev_get_active(dev);
+	alive = active || !list_empty(&dev->filelist);
+
+	if (alive)
+		drm_close(file_priv);
 	kfree(file_priv);
 
 	if (!--dev->open_count) {
-		if (atomic_read(&dev->ioctl_count))
-			DRM_ERROR("Device busy: %d\n",
-				  atomic_read(&dev->ioctl_count));
-		else
+		/* If the device is still alive, only call last-close. If it is
+		 * already unregistered (!alive), then free the device as we're
+		 * the last user. */
+		if (alive)
 			drm_lastclose(dev);
-		if (drm_dev_is_unplugged(dev))
-			drm_put_dev(dev);
+		else
+			drm_dev_free(dev);
 	}
 
+	if (active)
+		drm_dev_put_active(dev);
+
 	mutex_unlock(&drm_global_mutex);
 
 	return 0;
diff --git a/drivers/gpu/drm/drm_stub.c b/drivers/gpu/drm/drm_stub.c
index 9218f17..e363b72 100644
--- a/drivers/gpu/drm/drm_stub.c
+++ b/drivers/gpu/drm/drm_stub.c
@@ -407,30 +407,9 @@ void drm_put_dev(struct drm_device *dev)
 	}
 
 	drm_dev_unregister(dev);
-	drm_dev_free(dev);
 }
 EXPORT_SYMBOL(drm_put_dev);
 
-void drm_unplug_dev(struct drm_device *dev)
-{
-	/* for a USB device */
-	if (drm_core_check_feature(dev, DRIVER_MODESET))
-		drm_unplug_minor(dev->control);
-	if (dev->render)
-		drm_unplug_minor(dev->render);
-	drm_unplug_minor(dev->primary);
-
-	/* TODO: We should call drm_dev_shutdown() here. But to protect against
-	 * buggy drivers, we don't do any synchronous shutdown and instead wait
-	 * for users to go away. */
-	dev->unplugged = true;
-	mb();
-
-	if (dev->open_count == 0)
-		drm_put_dev(dev);
-}
-EXPORT_SYMBOL(drm_unplug_dev);
-
 /**
  * drm_dev_alloc - Allocate new drm device
  * @driver: DRM driver to allocate device for
@@ -508,8 +487,8 @@ EXPORT_SYMBOL(drm_dev_alloc);
  * Free a DRM device that has previously been allocated via drm_dev_alloc().
  * You must not use kfree() instead or you will leak memory.
  *
- * This must not be called once the device got registered. Use drm_put_dev()
- * instead, which then calls drm_dev_free().
+ * This must not be called once the device got registered. See
+ * drm_dev_unregister().
  */
 void drm_dev_free(struct drm_device *dev)
 {
@@ -535,7 +514,8 @@ EXPORT_SYMBOL(drm_dev_free);
  *
  * Register the DRM device @dev with the system, advertise device to user-space
  * and start normal device operation. @dev must be allocated via drm_dev_alloc()
- * previously.
+ * previously. You must not call drm_dev_free() if this succeeds. Use
+ * drm_dev_unregister() instead.
  *
  * Never call this twice on any device!
  *
@@ -604,15 +584,45 @@ EXPORT_SYMBOL(drm_dev_register);
  *
  * Mark DRM device as unplugged, wait for any pending user request and then
  * unregister the DRM device from the system. This does the reverse of
- * drm_dev_register(). The caller is responsible of freeing the device via
- * drm_dev_free() once this returns.
+ * drm_dev_register().
+ *
+ * This also forcibly closes all open files on the device. The open-files are
+ * marked dead and get unregistered and unlinked (but kept allocated) so any
+ * new fop from user-space will result in ENODEV.
+ *
+ * The caller must not hold drm_global_mutex! The caller also must not access
+ * the device after this returns. If the device is unused, it's immediately
+ * freed, otherwise the last drm_release() will free the now dead device.
  */
 void drm_dev_unregister(struct drm_device *dev)
 {
 	struct drm_map_list *r_list, *list_temp;
+	struct drm_file *file;
+	bool dead;
 
 	drm_dev_shutdown(dev);
 
+	/* We cannot hold drm_global_mutex during drm_dev_shutdown() as it might
+	 * dead-lock. Hence, there's a small race between drm_dev_shutdown() and
+	 * us locking drm_global_mutex which drm_release() might trigger. To fix
+	 * it, drm_release() tests for list_empty(&dev->filelist) additionally
+	 * to the device being unplugged. */
+
+	mutex_lock(&drm_global_mutex);
+
+	/* Close all open DRM files. As the device is marked dead, any DRM fop
+	 * will fail calling drm_dev_get_device() so they cannot access the DRM
+	 * device anymore. We keep the dead drm_file allocated so new fops can
+	 * access it. The real drm_release() will notice the device is dead and
+	 * just free the dead drm_file for real. */
+	while (!list_empty(&dev->filelist)) {
+		file = list_entry(dev->filelist.next, struct drm_file, lhead);
+
+		/* wake up drm_read() and drm_poll() */
+		wake_up_interruptible(&file->event_wait);
+		drm_close(file);
+	}
+
 	drm_lastclose(dev);
 
 	if (dev->driver->unload)
@@ -631,6 +641,12 @@ void drm_dev_unregister(struct drm_device *dev)
 	drm_unplug_minor(dev->primary);
 
 	list_del(&dev->driver_item);
+	dead = !dev->open_count;
+
+	mutex_unlock(&drm_global_mutex);
+
+	if (dead)
+		drm_dev_free(dev);
 }
 EXPORT_SYMBOL(drm_dev_unregister);
 
diff --git a/drivers/gpu/drm/udl/udl_drv.c b/drivers/gpu/drm/udl/udl_drv.c
index 3ddd6cd..2cb65d1 100644
--- a/drivers/gpu/drm/udl/udl_drv.c
+++ b/drivers/gpu/drm/udl/udl_drv.c
@@ -48,7 +48,7 @@ static void udl_usb_disconnect(struct usb_interface *interface)
 	drm_connector_unplug_all(dev);
 	udl_fbdev_unplug(dev);
 	udl_drop_usb(dev);
-	drm_unplug_dev(dev);
+	drm_dev_unregister(dev);
 }
 
 static const struct vm_operations_struct udl_gem_vm_ops = {
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index d066a58..6b22f15 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -1441,7 +1441,6 @@ extern struct drm_master *drm_master_get(struct drm_master *master);
 extern void drm_master_put(struct drm_master **master);
 
 extern void drm_put_dev(struct drm_device *dev);
-extern void drm_unplug_dev(struct drm_device *dev);
 extern unsigned int drm_debug;
 extern unsigned int drm_rnodes;
 
-- 
1.8.4.1

