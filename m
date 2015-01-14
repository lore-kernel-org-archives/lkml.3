Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbbANRa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 12:30:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58619 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754325AbbANR2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 12:28:16 -0500
Date: Wed, 14 Jan 2015 19:27:59 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, cornelia.huck@de.ibm.com,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        linux-s390@vger.kernel.org
Subject: [PATCH v3 10/16] s390: add pci_iomap_range
Message-ID: <1421256142-11512-11-git-send-email-mst@redhat.com>
References: <1421256142-11512-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421256142-11512-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Virtio drivers should map the part of the range they need, not
necessarily all of it.
To this end, support mapping ranges within BAR on s390.
Since multiple ranges can now be mapped within a BAR, we keep track of
the number of mappings created, and only clear out the mapping for a BAR
when this number reaches 0.

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org
Tested-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Heiko, Martin, can you please ack merging this through the virtio tree?
This was lightly tested by Sebastian Ott.

 arch/s390/include/asm/pci_io.h |  1 +
 arch/s390/pci/pci.c            | 34 +++++++++++++++++++++++++++-------
 2 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/arch/s390/include/asm/pci_io.h b/arch/s390/include/asm/pci_io.h
index f664e96..1a9a98d 100644
--- a/arch/s390/include/asm/pci_io.h
+++ b/arch/s390/include/asm/pci_io.h
@@ -16,6 +16,7 @@
 struct zpci_iomap_entry {
 	u32 fh;
 	u8 bar;
+	u16 count;
 };
 
 extern struct zpci_iomap_entry *zpci_iomap_start;
diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index 3290f11..753a567 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -259,7 +259,10 @@ void __iowrite64_copy(void __iomem *to, const void *from, size_t count)
 }
 
 /* Create a virtual mapping cookie for a PCI BAR */
-void __iomem *pci_iomap(struct pci_dev *pdev, int bar, unsigned long max)
+void __iomem *pci_iomap_range(struct pci_dev *pdev,
+			      int bar,
+			      unsigned long offset,
+			      unsigned long max)
 {
 	struct zpci_dev *zdev =	get_zdev(pdev);
 	u64 addr;
@@ -270,14 +273,27 @@ void __iomem *pci_iomap(struct pci_dev *pdev, int bar, unsigned long max)
 
 	idx = zdev->bars[bar].map_idx;
 	spin_lock(&zpci_iomap_lock);
-	zpci_iomap_start[idx].fh = zdev->fh;
-	zpci_iomap_start[idx].bar = bar;
+	if (zpci_iomap_start[idx].count++) {
+		BUG_ON(zpci_iomap_start[idx].fh != zdev->fh ||
+		       zpci_iomap_start[idx].bar != bar);
+	} else {
+		zpci_iomap_start[idx].fh = zdev->fh;
+		zpci_iomap_start[idx].bar = bar;
+	}
+	/* Detect overrun */
+	BUG_ON(!zpci_iomap_start[idx].count);
 	spin_unlock(&zpci_iomap_lock);
 
 	addr = ZPCI_IOMAP_ADDR_BASE | ((u64) idx << 48);
-	return (void __iomem *) addr;
+	return (void __iomem *) addr + offset;
 }
-EXPORT_SYMBOL_GPL(pci_iomap);
+EXPORT_SYMBOL_GPL(pci_iomap_range);
+
+void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
+{
+	return pci_iomap_range(dev, bar, 0, maxlen);
+}
+EXPORT_SYMBOL(pci_iomap);
 
 void pci_iounmap(struct pci_dev *pdev, void __iomem *addr)
 {
@@ -285,8 +301,12 @@ void pci_iounmap(struct pci_dev *pdev, void __iomem *addr)
 
 	idx = (((__force u64) addr) & ~ZPCI_IOMAP_ADDR_BASE) >> 48;
 	spin_lock(&zpci_iomap_lock);
-	zpci_iomap_start[idx].fh = 0;
-	zpci_iomap_start[idx].bar = 0;
+	/* Detect underrun */
+	BUG_ON(!zpci_iomap_start[idx].count);
+	if (!--zpci_iomap_start[idx].count) {
+		zpci_iomap_start[idx].fh = 0;
+		zpci_iomap_start[idx].bar = 0;
+	}
 	spin_unlock(&zpci_iomap_lock);
 }
 EXPORT_SYMBOL_GPL(pci_iounmap);
-- 
MST

