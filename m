Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaJEQHF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 12:07:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbaJEQDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 12:03:39 -0400
Date: Sun, 5 Oct 2014 19:07:05 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Heinz Graalfs <graalfs@linux.vnet.ibm.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 05/16] virtio: defer config changed notifications
Message-ID: <1412525038-15871-6-git-send-email-mst@redhat.com>
References: <1412525038-15871-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412525038-15871-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Defer config changed notifications that arrive during
probe/scan/freeze/restore.

This will allow drivers to set DRIVER_OK earlier, without worrying about
racing with config change interrupts.

This change will also benefit old hypervisors (before 2009)
that send interrupts without checking DRIVER_OK: previously,
the callback could race with driver-specific initialization.

This will also help simplify drivers.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/linux/virtio.h  |  6 ++++++
 drivers/virtio/virtio.c | 55 +++++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 52 insertions(+), 9 deletions(-)

diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 8df7ba8..5636b11 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -79,6 +79,9 @@ bool virtqueue_is_broken(struct virtqueue *vq);
  * virtio_device - representation of a device using virtio
  * @index: unique position on the virtio bus
  * @failed: saved value for CONFIG_S_FAILED bit (for restore)
+ * @config_enabled: configuration change reporting enabled
+ * @config_changed: configuration change reported while disabled
+ * @config_lock: protects configuration change reporting
  * @dev: underlying device.
  * @id: the device type identification (used to match it with a driver).
  * @config: the configuration ops for this device.
@@ -90,6 +93,9 @@ bool virtqueue_is_broken(struct virtqueue *vq);
 struct virtio_device {
 	int index;
 	bool failed;
+	bool config_enabled;
+	bool config_changed;
+	spinlock_t config_lock;
 	struct device dev;
 	struct virtio_device_id id;
 	const struct virtio_config_ops *config;
diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index 657f817..578e02d 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -117,6 +117,40 @@ void virtio_check_driver_offered_feature(const struct virtio_device *vdev,
 }
 EXPORT_SYMBOL_GPL(virtio_check_driver_offered_feature);
 
+static void __virtio_config_changed(struct virtio_device *dev)
+{
+	struct virtio_driver *drv = drv_to_virtio(dev->dev.driver);
+
+	if (!dev->config_enabled)
+		dev->config_changed = true;
+	else if (drv && drv->config_changed)
+		drv->config_changed(dev);
+}
+
+void virtio_config_changed(struct virtio_device *dev)
+{
+	spin_lock_irq(&dev->config_lock);
+	__virtio_config_changed(dev);
+	spin_unlock_irq(&dev->config_lock);
+}
+EXPORT_SYMBOL_GPL(virtio_config_changed);
+
+static void virtio_config_disable(struct virtio_device *dev)
+{
+	spin_lock_irq(&dev->config_lock);
+	dev->config_enabled = false;
+	spin_unlock_irq(&dev->config_lock);
+}
+
+static void virtio_config_enable(struct virtio_device *dev)
+{
+	spin_lock_irq(&dev->config_lock);
+	dev->config_enabled = true;
+	__virtio_config_changed(dev);
+	dev->config_changed = false;
+	spin_unlock_irq(&dev->config_lock);
+}
+
 static int virtio_dev_probe(struct device *_d)
 {
 	int err, i;
@@ -153,6 +187,8 @@ static int virtio_dev_probe(struct device *_d)
 		add_status(dev, VIRTIO_CONFIG_S_DRIVER_OK);
 		if (drv->scan)
 			drv->scan(dev);
+
+		virtio_config_enable(dev);
 	}
 
 	return err;
@@ -163,6 +199,8 @@ static int virtio_dev_remove(struct device *_d)
 	struct virtio_device *dev = dev_to_virtio(_d);
 	struct virtio_driver *drv = drv_to_virtio(dev->dev.driver);
 
+	virtio_config_disable(dev);
+
 	drv->remove(dev);
 
 	/* Driver should have reset device. */
@@ -211,6 +249,10 @@ int register_virtio_device(struct virtio_device *dev)
 	dev->index = err;
 	dev_set_name(&dev->dev, "virtio%u", dev->index);
 
+	spin_lock_init(&dev->config_lock);
+	dev->config_enabled = false;
+	dev->config_changed = false;
+
 	/* We always start by resetting the device, in case a previous
 	 * driver messed it up.  This also tests that code path a little. */
 	dev->config->reset(dev);
@@ -239,20 +281,13 @@ void unregister_virtio_device(struct virtio_device *dev)
 }
 EXPORT_SYMBOL_GPL(unregister_virtio_device);
 
-void virtio_config_changed(struct virtio_device *dev)
-{
-	struct virtio_driver *drv = drv_to_virtio(dev->dev.driver);
-
-	if (drv && drv->config_changed)
-		drv->config_changed(dev);
-}
-EXPORT_SYMBOL_GPL(virtio_config_changed);
-
 #ifdef CONFIG_PM_SLEEP
 int virtio_device_freeze(struct virtio_device *dev)
 {
 	struct virtio_driver *drv = drv_to_virtio(dev->dev.driver);
 
+	virtio_config_disable(dev);
+
 	dev->failed = dev->config->get_status(dev) & VIRTIO_CONFIG_S_FAILED;
 
 	if (drv && drv->freeze)
@@ -296,6 +331,8 @@ int virtio_device_restore(struct virtio_device *dev)
 		add_status(dev, VIRTIO_CONFIG_S_DRIVER_OK);
 	}
 
+	virtio_config_enable(dev);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(virtio_device_restore);
-- 
MST

