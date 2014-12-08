Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbaLHNGf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 08:06:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755535AbaLHNGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 08:06:32 -0500
Date: Mon, 8 Dec 2014 15:06:25 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 5/9] virtio_pci: delete vqs indirectly
Message-ID: <1418043812-25753-6-git-send-email-mst@redhat.com>
References: <1418043812-25753-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418043812-25753-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VQ deletion is mostly version-specific, add another level of indirection
to split the version-independent code out.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_pci.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index 7b82eb5..133978c 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -81,6 +81,8 @@ struct virtio_pci_device {
 
 	/* Whether we have vector per vq */
 	bool per_vq_vectors;
+
+	void (*del_vq)(struct virtio_pci_vq_info *info);
 };
 
 /* Constants for MSI-X */
@@ -468,15 +470,11 @@ out_info:
 	return ERR_PTR(err);
 }
 
-static void vp_del_vq(struct virtqueue *vq)
+static void del_vq(struct virtio_pci_vq_info *info)
 {
+	struct virtqueue *vq = info->vq;
 	struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
-	struct virtio_pci_vq_info *info = vp_dev->vqs[vq->index];
-	unsigned long flags, size;
-
-	spin_lock_irqsave(&vp_dev->lock, flags);
-	list_del(&info->node);
-	spin_unlock_irqrestore(&vp_dev->lock, flags);
+	unsigned long size;
 
 	iowrite16(vq->index, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_SEL);
 
@@ -494,6 +492,19 @@ static void vp_del_vq(struct virtqueue *vq)
 
 	size = PAGE_ALIGN(vring_size(info->num, VIRTIO_PCI_VRING_ALIGN));
 	free_pages_exact(info->queue, size);
+}
+
+static void vp_del_vq(struct virtqueue *vq)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
+	struct virtio_pci_vq_info *info = vp_dev->vqs[vq->index];
+	unsigned long flags;
+
+	spin_lock_irqsave(&vp_dev->lock, flags);
+	list_del(&info->node);
+	spin_unlock_irqrestore(&vp_dev->lock, flags);
+
+	vp_dev->del_vq(info);
 	kfree(info);
 }
 
@@ -737,6 +748,8 @@ static int virtio_pci_probe(struct pci_dev *pci_dev,
 	vp_dev->vdev.id.vendor = pci_dev->subsystem_vendor;
 	vp_dev->vdev.id.device = pci_dev->subsystem_device;
 
+	vp_dev->del_vq = del_vq;
+
 	/* finally register the virtio device */
 	err = register_virtio_device(&vp_dev->vdev);
 	if (err)
-- 
MST

