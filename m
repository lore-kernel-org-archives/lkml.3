Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab3JUWer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:34:47 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:47847 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab3JUWd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:33:58 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [RFC v2 4/6] drm: make dev->unplugged reliable
Date: Tue, 22 Oct 2013 00:33:26 +0200
Message-Id: <1382394808-20611-5-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1382394808-20611-1-git-send-email-dh.herrmann@gmail.com>
References: <1382394808-20611-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we unplug a DRM device, we currently set dev->unplugged and then wait
for all open-files to close. Beside rather subtle race-conditions, the
main disadvantage is that most DRM device resources will stay allocated
and registered. This means the device cannot be re-used by another driver
until all user-space processes close()ed their DRM fds.

This patch changes the way we track pending fops. Instead of checking for
dev->unplugged before each fop, we now call drm_dev_get_active(). This
includes a test for dev->unplugged but also marks the device as active.
Once the fop is done, we call drm_dev_put_active() and the active-count is
decreased.

This allows us at _any_ time to see whether there is any running fop.
Furthermore, we can mark the device as unplugged and wait for these to
finish. So instead of waiting for all users to close() their fds, it is
now enough to wait for all running fops to finish. No new fops can be
started as the drm_dev_get_active() call fails once the device is
unplugged. If no DRM fop sleeps for an indefinite amount of time, this
effectively allows us to unregister and free DRM device resource _before_
all DRM fds are closed. Thus preventing user-space from delaying resource
destruction.

However, this patch doesn't enforce this, yet. Instead, we only introduce
the fops tracking. The new drm_dev_shutdown() helper can be used to do a
synchronous shutdown. However, this isn't enforced on hotplug-capable
drivers, yet. Instead, all drivers using drm_unplug_dev() will still wait
for all fds to close before destroying the device (to not break possibly
buggy existing drivers).

However, for all other drivers we now forcibly wait for all fops to finish
during drm_dev_unregister(). (for hotplug-capable drivers this is a no-op
as all fds are already closed, anyway).
We used to panic if a driver is unloaded while there're active users so
this is just a protection against _some_ of the existing races. To allow
proper unplugging of _any_ driver, some more protections will follow.

Note: The use of percpu_rw_semaphore is an implementation detail. The same
effect could be achieved with a spinlock+atomic_t+wait_queue. The
percpu_rw_sempahore is only slightly heavier but gives us much better
performance and is a lot more convenient to use.

Note2: This only fixes the global DRM fops to use drm_dev_get_active().
For drivers to allows full hotplugging, all their level-1 fops also need
to be fixed. This can be done separately for each driver, though.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 drivers/gpu/drm/Kconfig             |   1 +
 drivers/gpu/drm/drm_drv.c           |   5 +-
 drivers/gpu/drm/drm_fops.c          |  25 +++++--
 drivers/gpu/drm/drm_gem.c           |  10 +--
 drivers/gpu/drm/drm_stub.c          | 136 +++++++++++++++++++++++++++++++++---
 drivers/gpu/drm/drm_vm.c            |   3 +-
 drivers/gpu/drm/udl/udl_connector.c |   2 +-
 drivers/gpu/drm/udl/udl_fb.c        |   4 +-
 include/drm/drmP.h                  |  25 +++----
 9 files changed, 171 insertions(+), 40 deletions(-)

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 955555d..0795558 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -11,6 +11,7 @@ menuconfig DRM
 	select I2C
 	select I2C_ALGOBIT
 	select DMA_SHARED_BUFFER
+	select PERCPU_RWSEM
 	help
 	  Kernel-level support for the Direct Rendering Infrastructure (DRI)
 	  introduced in XFree86 4.0. If you say Y here, you need to select
diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index b55f138..21cd5f5 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -312,7 +312,7 @@ long drm_ioctl(struct file *filp,
 
 	dev = file_priv->minor->dev;
 
-	if (drm_device_is_unplugged(dev))
+	if (!drm_dev_get_active(dev))
 		return -ENODEV;
 
 	atomic_inc(&dev->ioctl_count);
@@ -403,7 +403,10 @@ long drm_ioctl(struct file *filp,
 
 	if (kdata != stack_kdata)
 		kfree(kdata);
+
 	atomic_dec(&dev->ioctl_count);
+	drm_dev_put_active(dev);
+
 	if (retcode)
 		DRM_DEBUG("ret = %d\n", retcode);
 	return retcode;
diff --git a/drivers/gpu/drm/drm_fops.c b/drivers/gpu/drm/drm_fops.c
index ecdd647..3884185 100644
--- a/drivers/gpu/drm/drm_fops.c
+++ b/drivers/gpu/drm/drm_fops.c
@@ -94,7 +94,7 @@ int drm_open(struct inode *inode, struct file *filp)
 	if (!(dev = minor->dev))
 		return -ENODEV;
 
-	if (drm_device_is_unplugged(dev))
+	if (!drm_dev_get_active(dev))
 		return -ENODEV;
 
 	if (!dev->open_count++)
@@ -118,7 +118,9 @@ int drm_open(struct inode *inode, struct file *filp)
 		if (retcode)
 			goto err_undo;
 	}
-	return 0;
+
+	retcode = 0;
+	goto out_active;
 
 err_undo:
 	mutex_lock(&dev->struct_mutex);
@@ -128,6 +130,8 @@ err_undo:
 	dev->dev_mapping = old_mapping;
 	mutex_unlock(&dev->struct_mutex);
 	dev->open_count--;
+out_active:
+	drm_dev_put_active(dev);
 	return retcode;
 }
 EXPORT_SYMBOL(drm_open);
@@ -159,9 +163,6 @@ int drm_stub_open(struct inode *inode, struct file *filp)
 	if (!(dev = minor->dev))
 		goto out;
 
-	if (drm_device_is_unplugged(dev))
-		goto out;
-
 	old_fops = filp->f_op;
 	filp->f_op = fops_get(dev->driver->fops);
 	if (filp->f_op == NULL) {
@@ -596,7 +597,7 @@ int drm_release(struct inode *inode, struct file *filp)
 				  atomic_read(&dev->ioctl_count));
 		else
 			drm_lastclose(dev);
-		if (drm_device_is_unplugged(dev))
+		if (drm_dev_is_unplugged(dev))
 			drm_put_dev(dev);
 	}
 
@@ -639,14 +640,18 @@ ssize_t drm_read(struct file *filp, char __user *buffer,
 		 size_t count, loff_t *offset)
 {
 	struct drm_file *file_priv = filp->private_data;
+	struct drm_device *dev = file_priv->minor->dev;
 	struct drm_pending_event *e;
 	size_t total;
 	ssize_t ret;
 
 	ret = wait_event_interruptible(file_priv->event_wait,
-				       !list_empty(&file_priv->event_list));
+				       !list_empty(&file_priv->event_list) ||
+				       drm_dev_is_unplugged(dev));
 	if (ret < 0)
 		return ret;
+	if (!drm_dev_get_active(dev))
+		return -ENODEV;
 
 	total = 0;
 	while (drm_dequeue_event(file_priv, total, count, &e)) {
@@ -660,6 +665,7 @@ ssize_t drm_read(struct file *filp, char __user *buffer,
 		e->destroy(e);
 	}
 
+	drm_dev_put_active(dev);
 	return total;
 }
 EXPORT_SYMBOL(drm_read);
@@ -667,10 +673,15 @@ EXPORT_SYMBOL(drm_read);
 unsigned int drm_poll(struct file *filp, struct poll_table_struct *wait)
 {
 	struct drm_file *file_priv = filp->private_data;
+	struct drm_device *dev = file_priv->minor->dev;
 	unsigned int mask = 0;
 
 	poll_wait(filp, &file_priv->event_wait, wait);
 
+	/* signal HUP on device removal */
+	if (drm_dev_is_unplugged(dev))
+		mask |= POLLHUP;
+
 	if (!list_empty(&file_priv->event_list))
 		mask |= POLLIN | POLLRDNORM;
 
diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index 4761ade..152a7661 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -838,7 +838,7 @@ int drm_gem_mmap(struct file *filp, struct vm_area_struct *vma)
 	struct drm_vma_offset_node *node;
 	int ret = 0;
 
-	if (drm_device_is_unplugged(dev))
+	if (!drm_dev_get_active(dev))
 		return -ENODEV;
 
 	mutex_lock(&dev->struct_mutex);
@@ -847,17 +847,19 @@ int drm_gem_mmap(struct file *filp, struct vm_area_struct *vma)
 					   vma_pages(vma));
 	if (!node) {
 		mutex_unlock(&dev->struct_mutex);
+		drm_dev_put_active(dev);
 		return drm_mmap(filp, vma);
 	} else if (!drm_vma_node_is_allowed(node, filp)) {
-		mutex_unlock(&dev->struct_mutex);
-		return -EACCES;
+		ret = -EACCES;
+		goto unlock;
 	}
 
 	obj = container_of(node, struct drm_gem_object, vma_node);
 	ret = drm_gem_mmap_obj(obj, drm_vma_node_size(node) << PAGE_SHIFT, vma);
 
+unlock:
 	mutex_unlock(&dev->struct_mutex);
-
+	drm_dev_put_active(dev);
 	return ret;
 }
 EXPORT_SYMBOL(drm_gem_mmap);
diff --git a/drivers/gpu/drm/drm_stub.c b/drivers/gpu/drm/drm_stub.c
index b4c51d0..9218f17 100644
--- a/drivers/gpu/drm/drm_stub.c
+++ b/drivers/gpu/drm/drm_stub.c
@@ -370,6 +370,27 @@ static void drm_put_minor(struct drm_minor *minor)
 }
 
 /**
+ * drm_dev_shutdown - Shutdown a DRM device synchronously
+ * @dev: Device to shutdown
+ *
+ * This marks a device as unplugged, waits for all active fops to finish and
+ * then returns. Once the device is marked as unplugged, any further call to
+ * drm_dev_get_active() will fail so no new users can enter any DRM fops on the
+ * device.
+ * This must not be called with drm_global_mutex held! Otherwise, calls like
+ * drm_ioctl() might dead-lock. Instead, the caller must guarantee that this is
+ * never called multiple times in parallel. Repeated calls are allowed and
+ * detected properly.
+ */
+static void drm_dev_shutdown(struct drm_device *dev)
+{
+	if (!dev->unplugged) {
+		dev->unplugged = true;
+		percpu_down_write(&dev->active);
+	}
+}
+
+/**
  * Called via drm_exit() at module unload time or when pci device is
  * unplugged.
  *
@@ -399,14 +420,14 @@ void drm_unplug_dev(struct drm_device *dev)
 		drm_unplug_minor(dev->render);
 	drm_unplug_minor(dev->primary);
 
-	mutex_lock(&drm_global_mutex);
-
-	drm_device_set_unplugged(dev);
+	/* TODO: We should call drm_dev_shutdown() here. But to protect against
+	 * buggy drivers, we don't do any synchronous shutdown and instead wait
+	 * for users to go away. */
+	dev->unplugged = true;
+	mb();
 
-	if (dev->open_count == 0) {
+	if (dev->open_count == 0)
 		drm_put_dev(dev);
-	}
-	mutex_unlock(&drm_global_mutex);
 }
 EXPORT_SYMBOL(drm_unplug_dev);
 
@@ -446,9 +467,12 @@ struct drm_device *drm_dev_alloc(struct drm_driver *driver,
 	mutex_init(&dev->struct_mutex);
 	mutex_init(&dev->ctxlist_mutex);
 
-	if (drm_ht_create(&dev->map_hash, 12))
+	if (percpu_init_rwsem(&dev->active))
 		goto err_free;
 
+	if (drm_ht_create(&dev->map_hash, 12))
+		goto err_rwsem;
+
 	ret = drm_ctxbitmap_init(dev);
 	if (ret) {
 		DRM_ERROR("Cannot allocate memory for context bitmap.\n");
@@ -469,6 +493,8 @@ err_ctxbitmap:
 	drm_ctxbitmap_cleanup(dev);
 err_ht:
 	drm_ht_remove(&dev->map_hash);
+err_rwsem:
+	percpu_free_rwsem(&dev->active);
 err_free:
 	kfree(dev);
 	return NULL;
@@ -497,6 +523,7 @@ void drm_dev_free(struct drm_device *dev)
 	drm_ctxbitmap_cleanup(dev);
 	drm_ht_remove(&dev->map_hash);
 
+	percpu_free_rwsem(&dev->active);
 	kfree(dev->devname);
 	kfree(dev);
 }
@@ -575,14 +602,17 @@ EXPORT_SYMBOL(drm_dev_register);
  * drm_dev_unregister - Unregister DRM device
  * @dev: Device to unregister
  *
- * Unregister the DRM device from the system. This does the reverse of
- * drm_dev_register() but does not deallocate the device. The caller must call
- * drm_dev_free() to free all resources.
+ * Mark DRM device as unplugged, wait for any pending user request and then
+ * unregister the DRM device from the system. This does the reverse of
+ * drm_dev_register(). The caller is responsible of freeing the device via
+ * drm_dev_free() once this returns.
  */
 void drm_dev_unregister(struct drm_device *dev)
 {
 	struct drm_map_list *r_list, *list_temp;
 
+	drm_dev_shutdown(dev);
+
 	drm_lastclose(dev);
 
 	if (dev->driver->unload)
@@ -603,3 +633,89 @@ void drm_dev_unregister(struct drm_device *dev)
 	list_del(&dev->driver_item);
 }
 EXPORT_SYMBOL(drm_dev_unregister);
+
+/**
+ * drm_dev_is_unplugged - Test whether device is unplugged
+ * @dev: Device to test
+ *
+ * This returns true if the device is unplugged and should not be used. However,
+ * compared to drm_dev_get_active() it does not acquire the device. Therefore,
+ * this can only be used to test whether a device is dead, not whether it's
+ * alive. Once a device is dead it will never get active again so you can rely
+ * on the value to stay.
+ *
+ * This helper is mainly meant for wait_*() calls used as wake-up condition to
+ * get notified once a device gets unplugged. This call is unlocked so you need
+ * to make sure you use proper barriers (mostly implicitly via wait() calls).
+ *
+ * You're highly recommended to not use this helper. Use drm_dev_get_active()
+ * and drm_dev_put_active() instead.
+ *
+ * RETURNS:
+ * True iff the device is unplugged and about to be removed.
+ */
+bool drm_dev_is_unplugged(struct drm_device *dev)
+{
+	return dev->unplugged;
+}
+EXPORT_SYMBOL(drm_dev_is_unplugged);
+
+/**
+ * drm_dev_get_active - Mark device as active
+ * @dev: Device to mark
+ *
+ * Whenever a DRM driver performs an action on behalf of user-space, it should
+ * mark the DRM device as active. Once it is done, call drm_dev_put_active() to
+ * release that mark. This allows DRM core to wait for pending user-space
+ * actions before unplugging a device. But this also means, user-space must
+ * not sleep for an indefinite period while a device is marked active.
+ * If you have to sleep for an indefinite period, call drm_dev_put_active() and
+ * try to reacquire the device once you wake up.
+ *
+ * Recursive calls are allowed but may fail if the device is about to go away.
+ *
+ * This is implemented via percpu-semaphores and can safely be used in
+ * fast-paths and atomic-contexts. Internally we use read-locks to count all
+ * active readers. As down_read() is not safe to be called recursively we use
+ * down_read_trylock() instead. Once a device gets unplugged we call
+ * down_write() and wait for all readers to finish. This causes any further
+ * down_read_trylock() to fail so no new users will occur. Once we get the
+ * write-lock, we never release it. See drm_dev_unregister() for more.
+ *
+ * RETURNS:
+ * True iff the device was marked active and can be used. False if the device
+ * was unplugged and must not be used, anymore.
+ */
+bool drm_dev_get_active(struct drm_device *dev)
+{
+	if (!percpu_down_read_trylock(&dev->active))
+		return false;
+
+	/* TODO: If we strictly enforce synchronous shutdown, we will be unable
+	 * to lock dev->active if @unplugged is true. But buggy drivers are
+	 * allowed to loosen this strict enforcement. Hence, lets try our best
+	 * here and protect against use once @unplugged is set.
+	 * This can be simplified once drm_dev_shutdown() is always forced. */
+
+	if (!dev->unplugged)
+		return true;
+
+	percpu_up_read(&dev->active);
+	return false;
+}
+EXPORT_SYMBOL(drm_dev_get_active);
+
+/**
+ * drm_dev_put_active - Unmark active device
+ * @dev: Active device to unmark
+ *
+ * This finishes a call to drm_dev_get_active(). You must not call it if
+ * drm_dev_get_active() failed.
+ * This marks the device as inactive again, iff no other user currently has the
+ * device marked as active. See drm_dev_get_active().
+ */
+void drm_dev_put_active(struct drm_device *dev)
+{
+	percpu_up_read(&dev->active);
+}
+EXPORT_SYMBOL(drm_dev_put_active);
diff --git a/drivers/gpu/drm/drm_vm.c b/drivers/gpu/drm/drm_vm.c
index b5c5af7..abdcf1a 100644
--- a/drivers/gpu/drm/drm_vm.c
+++ b/drivers/gpu/drm/drm_vm.c
@@ -658,13 +658,14 @@ int drm_mmap(struct file *filp, struct vm_area_struct *vma)
 	struct drm_device *dev = priv->minor->dev;
 	int ret;
 
-	if (drm_device_is_unplugged(dev))
+	if (!drm_dev_get_active(dev))
 		return -ENODEV;
 
 	mutex_lock(&dev->struct_mutex);
 	ret = drm_mmap_locked(filp, vma);
 	mutex_unlock(&dev->struct_mutex);
 
+	drm_dev_put_active(dev);
 	return ret;
 }
 EXPORT_SYMBOL(drm_mmap);
diff --git a/drivers/gpu/drm/udl/udl_connector.c b/drivers/gpu/drm/udl/udl_connector.c
index b44d548..b013022 100644
--- a/drivers/gpu/drm/udl/udl_connector.c
+++ b/drivers/gpu/drm/udl/udl_connector.c
@@ -96,7 +96,7 @@ static int udl_mode_valid(struct drm_connector *connector,
 static enum drm_connector_status
 udl_detect(struct drm_connector *connector, bool force)
 {
-	if (drm_device_is_unplugged(connector->dev))
+	if (drm_dev_is_unplugged(connector->dev))
 		return connector_status_disconnected;
 	return connector_status_connected;
 }
diff --git a/drivers/gpu/drm/udl/udl_fb.c b/drivers/gpu/drm/udl/udl_fb.c
index 97e9d61..c328826 100644
--- a/drivers/gpu/drm/udl/udl_fb.c
+++ b/drivers/gpu/drm/udl/udl_fb.c
@@ -323,10 +323,9 @@ static int udl_fb_open(struct fb_info *info, int user)
 {
 	struct udl_fbdev *ufbdev = info->par;
 	struct drm_device *dev = ufbdev->ufb.base.dev;
-	struct udl_device *udl = dev->dev_private;
 
 	/* If the USB device is gone, we don't accept new opens */
-	if (drm_device_is_unplugged(udl->ddev))
+	if (!drm_dev_get_active(dev))
 		return -ENODEV;
 
 	ufbdev->fb_count++;
@@ -350,6 +349,7 @@ static int udl_fb_open(struct fb_info *info, int user)
 	pr_notice("open /dev/fb%d user=%d fb_info=%p count=%d\n",
 		  info->node, user, info, ufbdev->fb_count);
 
+	drm_dev_put_active(dev);
 	return 0;
 }
 
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index 16ff7c4..d066a58 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -47,6 +47,7 @@
 #include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/file.h>
+#include <linux/percpu-rwsem.h>
 #include <linux/platform_device.h>
 #include <linux/pci.h>
 #include <linux/jiffies.h>
@@ -1209,7 +1210,11 @@ struct drm_device {
 	/*@} */
 	int switch_power_state;
 
-	atomic_t unplugged; /* device has been unplugged or gone away */
+	/** \name Hotplug Management */
+	/*@{ */
+	struct percpu_rw_semaphore active;	/**< protect active fops */
+	bool unplugged;				/**< device unplugged? */
+	/*@} */
 };
 
 #define DRM_SWITCH_POWER_ON 0
@@ -1228,19 +1233,6 @@ static inline int drm_dev_to_irq(struct drm_device *dev)
 	return dev->driver->bus->get_irq(dev);
 }
 
-static inline void drm_device_set_unplugged(struct drm_device *dev)
-{
-	smp_wmb();
-	atomic_set(&dev->unplugged, 1);
-}
-
-static inline int drm_device_is_unplugged(struct drm_device *dev)
-{
-	int ret = atomic_read(&dev->unplugged);
-	smp_rmb();
-	return ret;
-}
-
 static inline bool drm_modeset_is_locked(struct drm_device *dev)
 {
 	return mutex_is_locked(&dev->mode_config.mutex);
@@ -1642,6 +1634,11 @@ struct drm_device *drm_dev_alloc(struct drm_driver *driver,
 void drm_dev_free(struct drm_device *dev);
 int drm_dev_register(struct drm_device *dev, unsigned long flags);
 void drm_dev_unregister(struct drm_device *dev);
+
+bool drm_dev_is_unplugged(struct drm_device *dev);
+bool drm_dev_get_active(struct drm_device *dev);
+void drm_dev_put_active(struct drm_device *dev);
+
 /*@}*/
 
 /* PCI section */
-- 
1.8.4.1

