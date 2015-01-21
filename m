Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbbAUPAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:00:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753205AbbAUPA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:00:28 -0500
Date: Wed, 21 Jan 2015 17:00:19 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH pre-squash 05/14] fixup! virtio_pci: modern driver
Message-ID: <1421852375-22604-6-git-send-email-mst@redhat.com>
References: <1421852375-22604-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421852375-22604-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio_pci_modern: fix up vendor capability

Gerd Hoffmann noticed that we implemented
capability layout from an old draft.
Unfortunately the code was copied to host as well,
so we didn't notice.

Luckily we caught this in time.

This fixes commit "virtio_pci: modern driver"
and should be smashed with it.

Reported-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Tested-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/virtio/virtio_pci_modern.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index e2f41c9..a3d8101 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -26,13 +26,13 @@ static void __iomem *map_capability(struct pci_dev *dev, int off,
 				    u32 start, u32 size,
 				    size_t *len)
 {
-	u8 type_and_bar, bar;
+	u8 bar;
 	u32 offset, length;
 	void __iomem *p;
 
 	pci_read_config_byte(dev, off + offsetof(struct virtio_pci_cap,
-						 type_and_bar),
-			     &type_and_bar);
+						 bar),
+			     &bar);
 	pci_read_config_dword(dev, off + offsetof(struct virtio_pci_cap, offset),
 			     &offset);
 	pci_read_config_dword(dev, off + offsetof(struct virtio_pci_cap, length),
@@ -76,9 +76,6 @@ static void __iomem *map_capability(struct pci_dev *dev, int off,
 	if (len)
 		*len = length;
 
-	bar = (type_and_bar >> VIRTIO_PCI_CAP_BAR_SHIFT) &
-		VIRTIO_PCI_CAP_BAR_MASK;
-
 	if (minlen + offset < minlen ||
 	    minlen + offset > pci_resource_len(dev, bar)) {
 		dev_err(&dev->dev,
@@ -438,15 +435,13 @@ static inline int virtio_pci_find_capability(struct pci_dev *dev, u8 cfg_type,
 	for (pos = pci_find_capability(dev, PCI_CAP_ID_VNDR);
 	     pos > 0;
 	     pos = pci_find_next_capability(dev, pos, PCI_CAP_ID_VNDR)) {
-		u8 type_and_bar, type, bar;
+		u8 type, bar;
 		pci_read_config_byte(dev, pos + offsetof(struct virtio_pci_cap,
-							 type_and_bar),
-				     &type_and_bar);
-
-		type = (type_and_bar >> VIRTIO_PCI_CAP_TYPE_SHIFT) &
-			VIRTIO_PCI_CAP_TYPE_MASK;
-		bar = (type_and_bar >> VIRTIO_PCI_CAP_BAR_SHIFT) &
-			VIRTIO_PCI_CAP_BAR_MASK;
+							 cfg_type),
+				     &type);
+		pci_read_config_byte(dev, pos + offsetof(struct virtio_pci_cap,
+							 bar),
+				     &bar);
 
 		/* Ignore structures with reserved BAR values */
 		if (bar > 0x5)
-- 
MST

