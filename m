Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbbATQZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:25:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56455 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735AbbATQZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:25:15 -0500
Date: Tue, 20 Jan 2015 18:25:07 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kraxel@redhat.com, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, linux-api@vger.kernel.org
Subject: [PATCH 01/05] fixup! virtio_pci: modern driver
Message-ID: <1421771093-1589-2-git-send-email-mst@redhat.com>
References: <1421771093-1589-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421771093-1589-1-git-send-email-mst@redhat.com>
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
---
 include/uapi/linux/virtio_pci.h    |  7 ++++---
 drivers/virtio/virtio_pci_modern.c | 23 +++++++++--------------
 2 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
index 4e05423..a2b2e13 100644
--- a/include/uapi/linux/virtio_pci.h
+++ b/include/uapi/linux/virtio_pci.h
@@ -117,10 +117,11 @@ struct virtio_pci_cap {
 	__u8 cap_vndr;		/* Generic PCI field: PCI_CAP_ID_VNDR */
 	__u8 cap_next;		/* Generic PCI field: next ptr. */
 	__u8 cap_len;		/* Generic PCI field: capability length */
-	__u8 type_and_bar;	/* Upper 3 bits: bar.
-				 * Lower 3 is VIRTIO_PCI_CAP_*_CFG. */
+	__u8 cfg_type;		/* Identifies the structure. */
+	__u8 bar;		/* Where to find it. */
+	__u8 padding[3];	/* Pad to full dword. */
 	__le32 offset;		/* Offset within bar. */
-	__le32 length;		/* Length. */
+	__le32 length;		/* Length of the structure, in bytes. */
 };
 
 #define VIRTIO_PCI_CAP_BAR_SHIFT	5
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

