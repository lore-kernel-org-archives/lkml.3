Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbaLHPRA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 10:17:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755932AbaLHPQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 10:16:56 -0500
Date: Mon, 8 Dec 2014 17:16:50 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v2 07/10] virtio_pci: setup config vector indirectly
Message-ID: <1418051779-27748-8-git-send-email-mst@redhat.com>
References: <1418051779-27748-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418051779-27748-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

config vector setup is version specific, do it indirectly.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_pci.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index 68023e5..c8ca3f7 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -89,6 +89,7 @@ struct virtio_pci_device {
 				      const char *name,
 				      u16 msix_vec);
 	void (*del_vq)(struct virtio_pci_vq_info *info);
+	u16 (*config_vector)(struct virtio_pci_device *vp_dev, u16 vector);
 };
 
 /* Constants for MSI-X */
@@ -271,6 +272,15 @@ static irqreturn_t vp_interrupt(int irq, void *opaque)
 	return vp_vring_interrupt(irq, opaque);
 }
 
+u16 vp_config_vector(struct virtio_pci_device *vp_dev, u16 vector)
+{
+	/* Setup the vector used for configuration events */
+	iowrite16(vector, vp_dev->ioaddr + VIRTIO_MSI_CONFIG_VECTOR);
+	/* Verify we had enough resources to assign the vector */
+	/* Will also flush the write out to device */
+	return ioread16(vp_dev->ioaddr + VIRTIO_MSI_CONFIG_VECTOR);
+}
+
 static void vp_free_vectors(struct virtio_device *vdev)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
@@ -290,10 +300,7 @@ static void vp_free_vectors(struct virtio_device *vdev)
 
 	if (vp_dev->msix_enabled) {
 		/* Disable the vector used for configuration */
-		iowrite16(VIRTIO_MSI_NO_VECTOR,
-			  vp_dev->ioaddr + VIRTIO_MSI_CONFIG_VECTOR);
-		/* Flush the write out to device */
-		ioread16(vp_dev->ioaddr + VIRTIO_MSI_CONFIG_VECTOR);
+		vp_dev->config_vector(vp_dev, VIRTIO_MSI_NO_VECTOR);
 
 		pci_disable_msix(vp_dev->pci_dev);
 		vp_dev->msix_enabled = 0;
@@ -357,9 +364,8 @@ static int vp_request_msix_vectors(struct virtio_device *vdev, int nvectors,
 		goto error;
 	++vp_dev->msix_used_vectors;
 
-	iowrite16(v, vp_dev->ioaddr + VIRTIO_MSI_CONFIG_VECTOR);
+	v = vp_dev->config_vector(vp_dev, v);
 	/* Verify we had enough resources to assign the vector */
-	v = ioread16(vp_dev->ioaddr + VIRTIO_MSI_CONFIG_VECTOR);
 	if (v == VIRTIO_MSI_NO_VECTOR) {
 		err = -EBUSY;
 		goto error;
@@ -770,6 +776,7 @@ static int virtio_pci_probe(struct pci_dev *pci_dev,
 	vp_dev->vdev.id.vendor = pci_dev->subsystem_vendor;
 	vp_dev->vdev.id.device = pci_dev->subsystem_device;
 
+	vp_dev->config_vector = vp_config_vector;
 	vp_dev->setup_vq = setup_vq;
 	vp_dev->del_vq = del_vq;
 
-- 
MST

