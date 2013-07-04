Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab3GDM1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:27:14 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:61079 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756225Ab3GDM0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:26:46 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH v2 11/14] drm: add helpers to kick out firmware drivers
Date: Thu,  4 Jul 2013 14:25:11 +0200
Message-Id: <1372940714-12470-12-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1372940714-12470-1-git-send-email-dh.herrmann@gmail.com>
References: <1372940714-12470-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we load a real hardware DRM driver, we want all firmware drivers to be
unloaded. Historically, this was done via
remove_conflicting_framebuffers(), but for DRM drivers (like SimpleDRM) we
need a new way.

This patch introduces DRIVER_FIRMWARE and DRM apertures to provide a quite
similar way to kick out firmware DRM drivers. Additionally, unlike the
fbdev equivalent, DRM firmware drivers can now query the system whether a
real hardware driver is already loaded and prevent loading themselves.

Whenever a real hardware DRM driver is loaded which claims to provide the
boot fw FB, we invalidate the firmware framebuffer. Otherwise, simpledrm
could be loaded again, after a real hw-driver was unloaded (which is
very unlikely to work, except if hw-drivers reset fw FBs during unload).
Note that fbdev doesn't provide such protection against late driver
probing.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 drivers/gpu/drm/drm_pci.c                  |   1 +
 drivers/gpu/drm/drm_platform.c             |   1 +
 drivers/gpu/drm/drm_stub.c                 | 118 +++++++++++++++++++++++++++++
 drivers/gpu/drm/drm_usb.c                  |   1 +
 drivers/gpu/drm/simpledrm/simpledrm.h      |   1 +
 drivers/gpu/drm/simpledrm/simpledrm_drv.c  |   3 +-
 drivers/gpu/drm/simpledrm/simpledrm_main.c |  33 ++++++++
 include/drm/drmP.h                         |  26 +++++++
 8 files changed, 183 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_pci.c b/drivers/gpu/drm/drm_pci.c
index 14194b6..4dcb2a4 100644
--- a/drivers/gpu/drm/drm_pci.c
+++ b/drivers/gpu/drm/drm_pci.c
@@ -366,6 +366,7 @@ int drm_get_pci_dev(struct pci_dev *pdev, const struct pci_device_id *ent,
 	}
 
 	list_add_tail(&dev->driver_item, &driver->device_list);
+	list_add_tail(&dev->global_item, &drm_devlist);
 
 	DRM_INFO("Initialized %s %d.%d.%d %s for %s on minor %d\n",
 		 driver->name, driver->major, driver->minor, driver->patchlevel,
diff --git a/drivers/gpu/drm/drm_platform.c b/drivers/gpu/drm/drm_platform.c
index b8a282e..94923c8 100644
--- a/drivers/gpu/drm/drm_platform.c
+++ b/drivers/gpu/drm/drm_platform.c
@@ -88,6 +88,7 @@ int drm_get_platform_dev(struct platform_device *platdev,
 	}
 
 	list_add_tail(&dev->driver_item, &driver->device_list);
+	list_add_tail(&dev->global_item, &drm_devlist);
 
 	mutex_unlock(&drm_global_mutex);
 
diff --git a/drivers/gpu/drm/drm_stub.c b/drivers/gpu/drm/drm_stub.c
index 16f3ec5..9b7557e 100644
--- a/drivers/gpu/drm/drm_stub.c
+++ b/drivers/gpu/drm/drm_stub.c
@@ -46,6 +46,10 @@ EXPORT_SYMBOL(drm_vblank_offdelay);
 unsigned int drm_timestamp_precision = 20;  /* Default to 20 usecs. */
 EXPORT_SYMBOL(drm_timestamp_precision);
 
+static bool drm_fw_invalid;	/* true if fw FBs have been destroyed */
+LIST_HEAD(drm_devlist);		/* device list; protected by global lock */
+EXPORT_SYMBOL(drm_devlist);
+
 /*
  * Default to use monotonic timestamps for wait-for-vblank and page-flip
  * complete events.
@@ -484,7 +488,9 @@ void drm_put_dev(struct drm_device *dev)
 
 	drm_put_minor(&dev->primary);
 
+	list_del(&dev->global_item);
 	list_del(&dev->driver_item);
+	kfree(dev->apertures);
 	kfree(dev->devname);
 	kfree(dev);
 }
@@ -507,3 +513,115 @@ void drm_unplug_dev(struct drm_device *dev)
 	mutex_unlock(&drm_global_mutex);
 }
 EXPORT_SYMBOL(drm_unplug_dev);
+
+void drm_unplug_dev_locked(struct drm_device *dev)
+{
+	/* for a USB device */
+	if (drm_core_check_feature(dev, DRIVER_MODESET))
+		drm_unplug_minor(dev->control);
+	drm_unplug_minor(dev->primary);
+
+	drm_device_set_unplugged(dev);
+
+	/* TODO: schedule drm_put_dev if open_count == 0 */
+}
+EXPORT_SYMBOL(drm_unplug_dev_locked);
+
+#define VGA_FB_PHYS 0xa0000
+
+static bool apertures_overlap(struct drm_device *dev,
+			      struct apertures_struct *ap,
+			      bool boot)
+{
+	unsigned int i, j;
+	struct aperture *a, *b;
+
+	if (!dev->apertures)
+		return false;
+
+	for (i = 0; i < dev->apertures->count; ++i) {
+		a = &dev->apertures->ranges[i];
+
+		if (boot && a->base == VGA_FB_PHYS)
+			return true;
+
+		for (j = 0; ap && j < ap->count; ++j) {
+			b = &ap->ranges[j];
+			if (a->base <= b->base && a->base + a->size > b->base)
+				return true;
+			if (b->base <= a->base && b->base + b->size > a->base)
+				return true;
+		}
+	}
+
+	return false;
+}
+
+/**
+ * Kick out firmware
+ *
+ * Virtually unplug any firmware graphics devices which overlap the given
+ * region. This must be called with the global-drm-mutex locked.
+ * This calls the kick_out_firmware() callback on any firmware DRM driver and
+ * after that remove_conflicting_framebuffers() to remove legacy fbdev
+ * framebuffers.
+ */
+void drm_kick_out_firmware(struct apertures_struct *ap, bool boot)
+{
+	struct drm_device *dev;
+
+	if (boot)
+		drm_fw_invalid = true;
+
+	list_for_each_entry(dev, &drm_devlist, global_item) {
+		if (!drm_core_check_feature(dev, DRIVER_FIRMWARE))
+			continue;
+		if (apertures_overlap(dev, ap, boot)) {
+			DRM_INFO("kicking out firmware %s\n",
+				 dev->devname);
+			dev->driver->kick_out_firmware(dev);
+		}
+	}
+
+#ifdef CONFIG_FB
+	remove_conflicting_framebuffers(ap, "DRM", boot);
+#endif
+}
+EXPORT_SYMBOL(drm_kick_out_firmware);
+
+/**
+ * Verify that no driver uses firmware FBs
+ *
+ * Whenever you register a firmware framebuffer driver, you should store the
+ * apertures in @ap and test whether any other registered driver already
+ * claimed this area. Hence, if this function returns true, you should _not_
+ * register your driver!
+ */
+bool drm_is_firmware_used(struct apertures_struct *ap)
+{
+	struct drm_device *dev;
+	unsigned int i;
+	bool boot = false;
+
+	/* If a real DRM driver was loaded once, we cannot assume that the
+	 * firmware framebuffers are still valid. */
+	if (drm_fw_invalid)
+		return true;
+
+	for (i = 0; ap && i < ap->count; ++i) {
+		if (ap->ranges[i].base == VGA_FB_PHYS) {
+			boot = true;
+			break;
+		}
+	}
+
+	list_for_each_entry(dev, &drm_devlist, global_item) {
+		if (dev->apert_boot && boot)
+			return true;
+		if (apertures_overlap(dev, ap, false))
+			return true;
+	}
+
+	return false;
+}
+EXPORT_SYMBOL(drm_is_firmware_used);
diff --git a/drivers/gpu/drm/drm_usb.c b/drivers/gpu/drm/drm_usb.c
index 34a156f..5ad8dba 100644
--- a/drivers/gpu/drm/drm_usb.c
+++ b/drivers/gpu/drm/drm_usb.c
@@ -50,6 +50,7 @@ int drm_get_usb_dev(struct usb_interface *interface,
 		goto err_g3;
 
 	list_add_tail(&dev->driver_item, &driver->device_list);
+	list_add_tail(&dev->global_item, &drm_devlist);
 
 	mutex_unlock(&drm_global_mutex);
 
diff --git a/drivers/gpu/drm/simpledrm/simpledrm.h b/drivers/gpu/drm/simpledrm/simpledrm.h
index b854981..c093ad5 100644
--- a/drivers/gpu/drm/simpledrm/simpledrm.h
+++ b/drivers/gpu/drm/simpledrm/simpledrm.h
@@ -53,6 +53,7 @@ struct sdrm_device {
 
 int sdrm_drm_load(struct drm_device *ddev, unsigned long flags);
 int sdrm_drm_unload(struct drm_device *ddev);
+void sdrm_drm_kick_out_firmware(struct drm_device *ddev);
 int sdrm_drm_mmap(struct file *filp, struct vm_area_struct *vma);
 int sdrm_pdev_init(struct sdrm_device *sdrm);
 void sdrm_pdev_destroy(struct sdrm_device *sdrm);
diff --git a/drivers/gpu/drm/simpledrm/simpledrm_drv.c b/drivers/gpu/drm/simpledrm/simpledrm_drv.c
index b774d5c..08f2286 100644
--- a/drivers/gpu/drm/simpledrm/simpledrm_drv.c
+++ b/drivers/gpu/drm/simpledrm/simpledrm_drv.c
@@ -34,9 +34,10 @@ static const struct file_operations sdrm_drm_fops = {
 };
 
 static struct drm_driver sdrm_drm_driver = {
-	.driver_features = DRIVER_MODESET | DRIVER_GEM,
+	.driver_features = DRIVER_MODESET | DRIVER_GEM | DRIVER_FIRMWARE,
 	.load = sdrm_drm_load,
 	.unload = sdrm_drm_unload,
+	.kick_out_firmware = sdrm_drm_kick_out_firmware,
 	.fops = &sdrm_drm_fops,
 
 	.gem_init_object = sdrm_gem_init_object,
diff --git a/drivers/gpu/drm/simpledrm/simpledrm_main.c b/drivers/gpu/drm/simpledrm/simpledrm_main.c
index 497542d..38571c2 100644
--- a/drivers/gpu/drm/simpledrm/simpledrm_main.c
+++ b/drivers/gpu/drm/simpledrm/simpledrm_main.c
@@ -267,6 +267,21 @@ int sdrm_drm_load(struct drm_device *ddev, unsigned long flags)
 	if (ret)
 		goto err_name;
 
+	ddev->apertures = alloc_apertures(1);
+	if (!ddev->apertures) {
+		ret = -ENOMEM;
+		goto err_pdev;
+	}
+
+	ddev->apertures->ranges[0].base = sdrm->fb_base;
+	ddev->apertures->ranges[0].size = sdrm->fb_size;
+
+	if (drm_is_firmware_used(ddev->apertures)) {
+		dev_info(ddev->dev, "firmware framebuffer is already in use\n");
+		ret = -EBUSY;
+		goto err_apert;
+	}
+
 	drm_mode_config_init(ddev);
 	ddev->mode_config.min_width = 0;
 	ddev->mode_config.min_height = 0;
@@ -308,6 +323,9 @@ int sdrm_drm_load(struct drm_device *ddev, unsigned long flags)
 
 err_cleanup:
 	drm_mode_config_cleanup(ddev);
+err_apert:
+	kfree(ddev->apertures);
+err_pdev:
 	sdrm_pdev_destroy(sdrm);
 err_name:
 	kfree(ddev->devname);
@@ -328,3 +346,18 @@ int sdrm_drm_unload(struct drm_device *ddev)
 
 	return 0;
 }
+
+void sdrm_drm_kick_out_firmware(struct drm_device *ddev)
+{
+	struct sdrm_device *sdrm = ddev->dev_private;
+
+	mutex_lock(&ddev->struct_mutex);
+
+	sdrm_fbdev_cleanup(sdrm);
+	drm_unplug_dev_locked(ddev);
+	if (sdrm->fb_obj)
+		sdrm_gem_unmap_object(sdrm->fb_obj);
+	sdrm_pdev_destroy(sdrm);
+
+	mutex_unlock(&ddev->struct_mutex);
+}
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index 63d17ee..a19e710 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -47,6 +47,7 @@
 #include <linux/fs.h>
 #include <linux/proc_fs.h>
 #include <linux/init.h>
+#include <linux/fb.h>
 #include <linux/file.h>
 #include <linux/platform_device.h>
 #include <linux/pci.h>
@@ -156,6 +157,7 @@ int drm_err(const char *func, const char *format, ...);
 #define DRIVER_GEM         0x1000
 #define DRIVER_MODESET     0x2000
 #define DRIVER_PRIME       0x4000
+#define DRIVER_FIRMWARE    0x8000
 
 #define DRIVER_BUS_PCI 0x1
 #define DRIVER_BUS_PLATFORM 0x2
@@ -954,6 +956,23 @@ struct drm_driver {
 			    struct drm_device *dev,
 			    uint32_t handle);
 
+	/**
+	 * kick_out_firmware - kick out firmware driver
+	 * @dev: DRM device
+	 *
+	 * Iff this driver has DRIVER_FIRMWARE set, this function is called
+	 * when a real hw-driver is loaded and claims the framebuffer memory
+	 * that is mapped by the firmware driver. This is called with the
+	 * global drm mutex held.
+	 * Drivers should unmap any memory-mappings, disable the device and
+	 * schedule a driver removal.
+	 *
+	 * Note that a driver setting DRIVER_FIRMWARE is supposed to also set
+	 * the "apertures" information on @dev. It is used to match the memory
+	 * regions that are used by firmware drivers.
+	 */
+	void (*kick_out_firmware) (struct drm_device *dev);
+
 	/* Driver private ops for this object */
 	const struct vm_operations_struct *gem_vm_ops;
 
@@ -1077,6 +1096,7 @@ struct drm_pending_vblank_event {
  */
 struct drm_device {
 	struct list_head driver_item;	/**< list of devices per driver */
+	struct list_head global_item;	/**< global list of devices */
 	char *devname;			/**< For /proc/interrupts */
 	int if_version;			/**< Highest interface version set */
 
@@ -1218,6 +1238,8 @@ struct drm_device {
 	int switch_power_state;
 
 	atomic_t unplugged; /* device has been unplugged or gone away */
+	struct apertures_struct *apertures;	/**< fbmem apertures */
+	bool apert_boot;			/**< true if mapped as boot fb */
 };
 
 #define DRM_SWITCH_POWER_ON 0
@@ -1532,6 +1554,10 @@ extern void drm_master_put(struct drm_master **master);
 extern void drm_put_dev(struct drm_device *dev);
 extern int drm_put_minor(struct drm_minor **minor);
 extern void drm_unplug_dev(struct drm_device *dev);
+extern void drm_unplug_dev_locked(struct drm_device *dev);
+extern void drm_kick_out_firmware(struct apertures_struct *ap, bool boot);
+extern bool drm_is_firmware_used(struct apertures_struct *ap);
+extern struct list_head drm_devlist;
 extern unsigned int drm_debug;
 
 extern unsigned int drm_vblank_offdelay;
-- 
1.8.3.2

