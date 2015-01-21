Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbbAUPBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:01:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552AbbAUPAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:00:42 -0500
Date: Wed, 21 Jan 2015 17:00:32 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH pre-squash 09/14] virtio_pci_modern: reduce number of mappings
Message-ID: <1421852375-22604-10-git-send-email-mst@redhat.com>
References: <1421852375-22604-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421852375-22604-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't know the # of VQs that drivers are going to use so it's hard to
predict how much memory we'll need to map. However, the relevant
capability does give us an upper limit.
If that's below a page, we can reduce the number of required
mappings by mapping it all once ahead of the time.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Tested-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/virtio/virtio_pci_common.h |  3 ++
 drivers/virtio/virtio_pci_modern.c | 57 ++++++++++++++++++++++++++++++++------
 2 files changed, 52 insertions(+), 8 deletions(-)

diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
index 610c43f..d391805 100644
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -62,8 +62,11 @@ struct virtio_pci_device {
 	struct virtio_pci_common_cfg __iomem *common;
 	/* Device-specific data (non-legacy mode)  */
 	void __iomem *device;
+	/* Base of vq notifications (non-legacy mode). */
+	void __iomem *notify_base;
 
 	/* So we can sanity-check accesses. */
+	size_t notify_len;
 	size_t device_len;
 
 	/* Capability for when we need to map notifications per-vq. */
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index b2e707ad..0e54cc8 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -330,10 +330,26 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 	iowrite64_twopart(virt_to_phys(virtqueue_get_used(vq)),
 			  &cfg->queue_used_lo, &cfg->queue_used_hi);
 
-	vq->priv = (void __force *)map_capability(vp_dev->pci_dev,
-				  vp_dev->notify_map_cap, 2, 2,
-				  off * vp_dev->notify_offset_multiplier, 2,
-				  NULL);
+	if (vp_dev->notify_base) {
+		/* offset should not wrap */
+		if ((u64)off * vp_dev->notify_offset_multiplier + 2
+		    > vp_dev->notify_len) {
+			dev_warn(&vp_dev->pci_dev->dev,
+				 "bad notification offset %u (x %u) "
+				 "for queue %u > %zd",
+				 off, vp_dev->notify_offset_multiplier,
+				 index, vp_dev->notify_len);
+			err = -EINVAL;
+			goto err_map_notify;
+		}
+		vq->priv = (void __force *)vp_dev->notify_base +
+			off * vp_dev->notify_offset_multiplier;
+	} else {
+		vq->priv = (void __force *)map_capability(vp_dev->pci_dev,
+					  vp_dev->notify_map_cap, 2, 2,
+					  off * vp_dev->notify_offset_multiplier, 2,
+					  NULL);
+	}
 
 	if (!vq->priv) {
 		err = -ENOMEM;
@@ -352,7 +368,8 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 	return vq;
 
 err_assign_vector:
-	pci_iounmap(vp_dev->pci_dev, (void __iomem __force *)vq->priv);
+	if (!vp_dev->notify_base)
+		pci_iounmap(vp_dev->pci_dev, (void __iomem __force *)vq->priv);
 err_map_notify:
 	vring_del_virtqueue(vq);
 err_new_queue:
@@ -397,7 +414,8 @@ static void del_vq(struct virtio_pci_vq_info *info)
 		ioread16(&vp_dev->common->queue_msix_vector);
 	}
 
-	pci_iounmap(vp_dev->pci_dev, (void __force __iomem *)vq->priv);
+	if (!vp_dev->notify_base)
+		pci_iounmap(vp_dev->pci_dev, (void __force __iomem *)vq->priv);
 
 	vring_del_virtqueue(vq);
 
@@ -533,6 +551,7 @@ int virtio_pci_modern_probe(struct virtio_pci_device *vp_dev)
 	struct pci_dev *pci_dev = vp_dev->pci_dev;
 	int err, common, isr, notify, device;
 	u32 notify_length;
+	u32 notify_offset;
 
 	check_offsets();
 
@@ -599,13 +618,30 @@ int virtio_pci_modern_probe(struct virtio_pci_device *vp_dev)
 			      notify + offsetof(struct virtio_pci_notify_cap,
 						notify_off_multiplier),
 			      &vp_dev->notify_offset_multiplier);
-	/* Read notify length from config space. */
+	/* Read notify length and offset from config space. */
 	pci_read_config_dword(pci_dev,
 			      notify + offsetof(struct virtio_pci_notify_cap,
 						cap.length),
 			      &notify_length);
 
-	vp_dev->notify_map_cap = notify;
+	pci_read_config_dword(pci_dev,
+			      notify + offsetof(struct virtio_pci_notify_cap,
+						cap.length),
+			      &notify_offset);
+
+	/* We don't know how many VQs we'll map, ahead of the time.
+	 * If notify length is small, map it all now.
+	 * Otherwise, map each VQ individually later.
+	 */
+	if ((u64)notify_length + (notify_offset % PAGE_SIZE) <= PAGE_SIZE) {
+		vp_dev->notify_base = map_capability(pci_dev, notify, 2, 2,
+						     0, notify_length,
+						     &vp_dev->notify_len);
+		if (!vp_dev->notify_base)
+			goto err_map_notify;
+	} else {
+		vp_dev->notify_map_cap = notify;
+	}
 
 	/* Again, we don't know how much we should map, but PAGE_SIZE
 	 * is more than enough for all existing devices.
@@ -627,6 +663,9 @@ int virtio_pci_modern_probe(struct virtio_pci_device *vp_dev)
 	return 0;
 
 err_map_device:
+	if (vp_dev->notify_base)
+		pci_iounmap(pci_dev, vp_dev->notify_base);
+err_map_notify:
 	pci_iounmap(pci_dev, vp_dev->isr);
 err_map_isr:
 	pci_iounmap(pci_dev, vp_dev->common);
@@ -640,6 +679,8 @@ void virtio_pci_modern_remove(struct virtio_pci_device *vp_dev)
 
 	if (vp_dev->device)
 		pci_iounmap(pci_dev, vp_dev->device);
+	if (vp_dev->notify_base)
+		pci_iounmap(pci_dev, vp_dev->notify_base);
 	pci_iounmap(pci_dev, vp_dev->isr);
 	pci_iounmap(pci_dev, vp_dev->common);
 }
-- 
MST

