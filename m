Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbaLHNG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 08:06:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514AbaLHNGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 08:06:21 -0500
Date: Mon, 8 Dec 2014 15:06:16 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 1/9] virtio_pci: add isr field
Message-ID: <1418043812-25753-2-git-send-email-mst@redhat.com>
References: <1418043812-25753-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418043812-25753-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use isr field instead of direct access to ioaddr.
This way generalizes easily to virtio 1.0.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_pci.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index 9be59d9..ee1b54c 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -40,6 +40,9 @@ struct virtio_pci_device
 	/* the IO mapping for the PCI config space */
 	void __iomem *ioaddr;
 
+	/* the IO mapping for ISR operation */
+	void __iomem *isr;
+
 	/* a list of queues so we can dispatch IRQs */
 	spinlock_t lock;
 	struct list_head virtqueues;
@@ -248,7 +251,7 @@ static irqreturn_t vp_interrupt(int irq, void *opaque)
 
 	/* reading the ISR has the effect of also clearing it so it's very
 	 * important to save off the value. */
-	isr = ioread8(vp_dev->ioaddr + VIRTIO_PCI_ISR);
+	isr = ioread8(vp_dev->isr);
 
 	/* It's definitely not us if the ISR was not high */
 	if (!isr)
@@ -719,6 +722,8 @@ static int virtio_pci_probe(struct pci_dev *pci_dev,
 		goto out_req_regions;
 	}
 
+	vp_dev->isr = vp_dev->ioaddr + VIRTIO_PCI_ISR;
+
 	pci_set_drvdata(pci_dev, vp_dev);
 	pci_set_master(pci_dev);
 
-- 
MST

