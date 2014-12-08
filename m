Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbaLHPQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 10:16:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755839AbaLHPQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 10:16:49 -0500
Date: Mon, 8 Dec 2014 17:16:43 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v2 04/10] virtio_pci: use priv for vq notification
Message-ID: <1418051779-27748-5-git-send-email-mst@redhat.com>
References: <1418051779-27748-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418051779-27748-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

slightly reduce the amount of pointer chasing this needs to do.
More importantly, this will easily generalize to virtio 1.0.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_pci.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index 6a7b8bf..7b82eb5 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -204,11 +204,9 @@ static void vp_reset(struct virtio_device *vdev)
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
 
@@ -437,6 +435,7 @@ static struct virtqueue *setup_vq(struct virtio_device *vdev, unsigned index,
 		goto out_activate_queue;
 	}
 
+	vq->priv = (void __force *)vp_dev->ioaddr + VIRTIO_PCI_QUEUE_NOTIFY;
 	info->vq = vq;
 
 	if (msix_vec != VIRTIO_MSI_NO_VECTOR) {
-- 
MST

