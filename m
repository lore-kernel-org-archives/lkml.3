Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbaLCQOx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:14:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043AbaLCQOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:14:38 -0500
Date: Wed, 3 Dec 2014 18:14:30 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH RFC 2/2] virtio_pci: use priv for vq notification
Message-ID: <1417623248-15666-2-git-send-email-mst@redhat.com>
References: <1417623248-15666-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417623248-15666-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

slightly reduce the amount of pointer chasing this needs to do.
More importantly, this will easily generalize to virtio 1.0.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_pci.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index 91b479b..5791a93 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -198,11 +198,9 @@ static void vp_reset(struct virtio_device *vdev)
 /* the notify function used when creating a virt queue */
 static bool vp_notify(struct virtqueue *vq)
 {
-	struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
-
 	/* we write the queue's selector into the notification register to
 	 * signal the other end */
-	iowrite16(vq->index, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_NOTIFY);
+	iowrite16(vq->index, (void __iomem *)vq->priv);
 	return true;
 }
 
@@ -432,6 +430,8 @@ static struct virtqueue *setup_vq(struct virtio_device *vdev, unsigned index,
 		goto out_activate_queue;
 	}
 
+	vq->priv = (void __force *)vp_dev->ioaddr +
+		VIRTIO_PCI_QUEUE_NOTIFY;
 	info->vq = vq;
 
 	if (msix_vec != VIRTIO_MSI_NO_VECTOR) {
-- 
MST

