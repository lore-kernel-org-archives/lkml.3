Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbbAUPJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:09:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959AbbAUPFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:05:20 -0500
Date: Wed, 21 Jan 2015 17:05:11 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH post-squash 1/9] virtio_pci: move probe/remove code to common
Message-ID: <1421852670-23742-2-git-send-email-mst@redhat.com>
References: <1421852670-23742-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421852670-23742-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of initialization is device-independent.
Let's move it to common.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Tested-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/virtio/virtio_pci_common.h |  5 +--
 drivers/virtio/virtio_pci_common.c | 69 ++++++++++++++++++++++++++++++++++-
 drivers/virtio/virtio_pci_legacy.c | 75 ++++----------------------------------
 3 files changed, 77 insertions(+), 72 deletions(-)

diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
index 5a49728..2b1e70d 100644
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -127,8 +127,7 @@ const char *vp_bus_name(struct virtio_device *vdev);
  */
 int vp_set_vq_affinity(struct virtqueue *vq, int cpu);
 
-int virtio_pci_legacy_probe(struct pci_dev *pci_dev,
-			    const struct pci_device_id *id);
-void virtio_pci_legacy_remove(struct pci_dev *pci_dev);
+int virtio_pci_legacy_probe(struct virtio_pci_device *);
+void virtio_pci_legacy_remove(struct virtio_pci_device *);
 
 #endif
diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index 9756f21..457cbe2 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -464,15 +464,80 @@ static const struct pci_device_id virtio_pci_id_table[] = {
 
 MODULE_DEVICE_TABLE(pci, virtio_pci_id_table);
 
+static void virtio_pci_release_dev(struct device *_d)
+{
+	struct virtio_device *vdev = dev_to_virtio(_d);
+	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+
+	/* As struct device is a kobject, it's not safe to
+	 * free the memory (including the reference counter itself)
+	 * until it's release callback. */
+	kfree(vp_dev);
+}
+
 static int virtio_pci_probe(struct pci_dev *pci_dev,
 			    const struct pci_device_id *id)
 {
-	return virtio_pci_legacy_probe(pci_dev, id);
+	struct virtio_pci_device *vp_dev;
+	int rc;
+
+	/* allocate our structure and fill it out */
+	vp_dev = kzalloc(sizeof(struct virtio_pci_device), GFP_KERNEL);
+	if (!vp_dev)
+		return -ENOMEM;
+
+	pci_set_drvdata(pci_dev, vp_dev);
+	vp_dev->vdev.dev.parent = &pci_dev->dev;
+	vp_dev->vdev.dev.release = virtio_pci_release_dev;
+	vp_dev->pci_dev = pci_dev;
+	INIT_LIST_HEAD(&vp_dev->virtqueues);
+	spin_lock_init(&vp_dev->lock);
+
+	/* Disable MSI/MSIX to bring device to a known good state. */
+	pci_msi_off(pci_dev);
+
+	/* enable the device */
+	rc = pci_enable_device(pci_dev);
+	if (rc)
+		goto err_enable_device;
+
+	rc = pci_request_regions(pci_dev, "virtio-pci");
+	if (rc)
+		goto err_request_regions;
+
+	rc = virtio_pci_legacy_probe(vp_dev);
+	if (rc)
+		goto err_probe;
+
+	pci_set_master(pci_dev);
+
+	rc = register_virtio_device(&vp_dev->vdev);
+	if (rc)
+		goto err_register;
+
+	return 0;
+
+err_register:
+	virtio_pci_legacy_remove(vp_dev);
+err_probe:
+	pci_release_regions(pci_dev);
+err_request_regions:
+	pci_disable_device(pci_dev);
+err_enable_device:
+	kfree(vp_dev);
+	return rc;
 }
 
 static void virtio_pci_remove(struct pci_dev *pci_dev)
 {
-     virtio_pci_legacy_remove(pci_dev);
+	struct virtio_pci_device *vp_dev = pci_get_drvdata(pci_dev);
+
+	unregister_virtio_device(&vp_dev->vdev);
+
+	virtio_pci_legacy_remove(pci_dev);
+
+	pci_release_regions(pci_dev);
+	pci_disable_device(pci_dev);
 }
 
 static struct pci_driver virtio_pci_driver = {
diff --git a/drivers/virtio/virtio_pci_legacy.c b/drivers/virtio/virtio_pci_legacy.c
index 19f9309..256a527 100644
--- a/drivers/virtio/virtio_pci_legacy.c
+++ b/drivers/virtio/virtio_pci_legacy.c
@@ -211,23 +211,10 @@ static const struct virtio_config_ops virtio_pci_config_ops = {
 	.set_vq_affinity = vp_set_vq_affinity,
 };
 
-static void virtio_pci_release_dev(struct device *_d)
-{
-	struct virtio_device *vdev = dev_to_virtio(_d);
-	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
-
-	/* As struct device is a kobject, it's not safe to
-	 * free the memory (including the reference counter itself)
-	 * until it's release callback. */
-	kfree(vp_dev);
-}
-
 /* the PCI probing function */
-int virtio_pci_legacy_probe(struct pci_dev *pci_dev,
-			    const struct pci_device_id *id)
+int virtio_pci_legacy_probe(struct virtio_pci_device *vp_dev)
 {
-	struct virtio_pci_device *vp_dev;
-	int err;
+	struct pci_dev *pci_dev = vp_dev->pci_dev;
 
 	/* We only own devices >= 0x1000 and <= 0x103f: leave the rest. */
 	if (pci_dev->device < 0x1000 || pci_dev->device > 0x103f)
@@ -239,41 +226,12 @@ int virtio_pci_legacy_probe(struct pci_dev *pci_dev,
 		return -ENODEV;
 	}
 
-	/* allocate our structure and fill it out */
-	vp_dev = kzalloc(sizeof(struct virtio_pci_device), GFP_KERNEL);
-	if (vp_dev == NULL)
-		return -ENOMEM;
-
-	vp_dev->vdev.dev.parent = &pci_dev->dev;
-	vp_dev->vdev.dev.release = virtio_pci_release_dev;
-	vp_dev->vdev.config = &virtio_pci_config_ops;
-	vp_dev->pci_dev = pci_dev;
-	INIT_LIST_HEAD(&vp_dev->virtqueues);
-	spin_lock_init(&vp_dev->lock);
-
-	/* Disable MSI/MSIX to bring device to a known good state. */
-	pci_msi_off(pci_dev);
-
-	/* enable the device */
-	err = pci_enable_device(pci_dev);
-	if (err)
-		goto out;
-
-	err = pci_request_regions(pci_dev, "virtio-pci");
-	if (err)
-		goto out_enable_device;
-
 	vp_dev->ioaddr = pci_iomap(pci_dev, 0, 0);
-	if (vp_dev->ioaddr == NULL) {
-		err = -ENOMEM;
-		goto out_req_regions;
-	}
+	if (!vp_dev->ioaddr)
+		return -ENOMEM;
 
 	vp_dev->isr = vp_dev->ioaddr + VIRTIO_PCI_ISR;
 
-	pci_set_drvdata(pci_dev, vp_dev);
-	pci_set_master(pci_dev);
-
 	/* we use the subsystem vendor/device id as the virtio vendor/device
 	 * id.  this allows us to use the same PCI vendor/device id for all
 	 * virtio devices and to identify the particular virtio driver by
@@ -281,35 +239,18 @@ int virtio_pci_legacy_probe(struct pci_dev *pci_dev,
 	vp_dev->vdev.id.vendor = pci_dev->subsystem_vendor;
 	vp_dev->vdev.id.device = pci_dev->subsystem_device;
 
+	vp_dev->vdev.config = &virtio_pci_config_ops;
+
 	vp_dev->config_vector = vp_config_vector;
 	vp_dev->setup_vq = setup_vq;
 	vp_dev->del_vq = del_vq;
 
-	/* finally register the virtio device */
-	err = register_virtio_device(&vp_dev->vdev);
-	if (err)
-		goto out_set_drvdata;
-
 	return 0;
-
-out_set_drvdata:
-	pci_iounmap(pci_dev, vp_dev->ioaddr);
-out_req_regions:
-	pci_release_regions(pci_dev);
-out_enable_device:
-	pci_disable_device(pci_dev);
-out:
-	kfree(vp_dev);
-	return err;
 }
 
-void virtio_pci_legacy_remove(struct pci_dev *pci_dev)
+void virtio_pci_legacy_remove(struct virtio_pci_device *vp_dev)
 {
-	struct virtio_pci_device *vp_dev = pci_get_drvdata(pci_dev);
-
-	unregister_virtio_device(&vp_dev->vdev);
+	struct pci_dev *pci_dev = vp_dev->pci_dev;
 
 	pci_iounmap(pci_dev, vp_dev->ioaddr);
-	pci_release_regions(pci_dev);
-	pci_disable_device(pci_dev);
 }
-- 
MST

