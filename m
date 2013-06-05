Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab3FEQee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 12:34:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755387Ab3FEQec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 12:34:32 -0400
Date: Wed, 5 Jun 2013 19:35:00 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Jason Wang <jasowang@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, qemu-devel@nongnu.org
Subject: [PATCH RFC] virtio-pci: support config layout in BAR1
Message-ID: <20130605163500.GA3393@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some setups don't support enabling BAR0 (IO BAR). Reasons range from CPU
limitations (e.g. on some powerpc setups) to architecture limmitations
(e.g. a setup with >15 PCI bridges, with one virtio device behind each,
on x86).

PCI Express spec made IO optional, so future guests will disable IO for
a device in more and more configurations.

This patch makes it possible for host to mirror the config in BAR1, such
that these setups can work properly.

Guests with old drivers can't be fixed, they will continue to work as
well (or as bad) as they did previously.  For this reason, changing
revision id appears unnecessary - it would break setups that previously
worked, partially.

Future work on re-organizing layout won't conflict with this patch - it
can use a different BAR or put config at an offset, or update revision.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_pci.c | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index a7ce730..03564fe 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -675,6 +675,33 @@ static void virtio_pci_release_dev(struct device *_d)
 	 */
 }
 
+/* Map a BAR. But carefully: make sure we don't overlap the MSI-X table */
+static void __iomem * virtio_pci_iomap(struct pci_dev *pci_dev, int bar)
+{
+	int msix_cap = pci_find_capability(pci_dev, PCI_CAP_ID_MSIX);
+	if (msix_cap) {
+		u32 offset;
+		u8 bir;
+		pci_read_config_dword(pci_dev, msix_cap + PCI_MSIX_TABLE,
+				      &offset);
+		bir = (u8)(offset & PCI_MSIX_TABLE_BIR);
+		offset &= PCI_MSIX_TABLE_OFFSET;
+		/* Spec says table offset is in a 4K page all by itself */
+		if (bir == bar && offset < 4096)
+			return NULL;
+
+		pci_read_config_dword(pci_dev, msix_cap + PCI_MSIX_PBA,
+				      &offset);
+		bir = (u8)(offset & PCI_MSIX_PBA_BIR);
+		offset &= PCI_MSIX_PBA_OFFSET;
+		/* Spec says table offset is in a 4K page all by itself. */
+		if (bir == bar && offset < 4096)
+			return NULL;
+	}
+	/* 4K is enough for all devices at the moment. */
+	return pci_iomap(pci_dev, 0, 4096);
+}
+
 /* the PCI probing function */
 static int virtio_pci_probe(struct pci_dev *pci_dev,
 			    const struct pci_device_id *id)
@@ -716,7 +743,10 @@ static int virtio_pci_probe(struct pci_dev *pci_dev,
 	if (err)
 		goto out_enable_device;
 
-	vp_dev->ioaddr = pci_iomap(pci_dev, 0, 0);
+	vp_dev->ioaddr = virtio_pci_iomap(pci_dev, 0);
+	/* Failed to map BAR0? Try with BAR1. */
+	if (vp_dev->ioaddr == NULL)
+		vp_dev->ioaddr = virtio_pci_iomap(pci_dev, 1);
 	if (vp_dev->ioaddr == NULL) {
 		err = -ENOMEM;
 		goto out_req_regions;
-- 
MST
