Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590AbaL3Qf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 11:35:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbaL3Qfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 11:35:54 -0500
Date: Tue, 30 Dec 2014 18:35:36 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, cornelia.huck@de.ibm.com,
        Michael S Tsirkin <mst@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org
Subject: [PATCH RFC v2 2/7] pci: add pci_iomap_range
Message-ID: <1419957310-26009-3-git-send-email-mst@redhat.com>
References: <1419957310-26009-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419957310-26009-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael S Tsirkin <mst@redhat.com>

Virtio drivers should map the part of the BAR they need, not necessarily
all of it.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/asm-generic/pci_iomap.h | 10 ++++++++++
 lib/pci_iomap.c                 | 35 ++++++++++++++++++++++++++++++-----
 2 files changed, 40 insertions(+), 5 deletions(-)

diff --git a/include/asm-generic/pci_iomap.h b/include/asm-generic/pci_iomap.h
index ce37349..7389c87 100644
--- a/include/asm-generic/pci_iomap.h
+++ b/include/asm-generic/pci_iomap.h
@@ -15,6 +15,9 @@ struct pci_dev;
 #ifdef CONFIG_PCI
 /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
 extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
+extern void __iomem *pci_iomap_range(struct pci_dev *dev, int bar,
+				     unsigned long offset,
+				     unsigned long maxlen);
 /* Create a virtual mapping cookie for a port on a given PCI device.
  * Do not call this directly, it exists to make it easier for architectures
  * to override */
@@ -30,6 +33,13 @@ static inline void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned lon
 {
 	return NULL;
 }
+
+static inline void __iomem *pci_iomap_range(struct pci_dev *dev, int bar,
+					    unsigned long offset,
+					    unsigned long maxlen)
+{
+	return NULL;
+}
 #endif
 
 #endif /* __ASM_GENERIC_IO_H */
diff --git a/lib/pci_iomap.c b/lib/pci_iomap.c
index 0d83ea8..bcce5f1 100644
--- a/lib/pci_iomap.c
+++ b/lib/pci_iomap.c
@@ -10,10 +10,11 @@
 
 #ifdef CONFIG_PCI
 /**
- * pci_iomap - create a virtual mapping cookie for a PCI BAR
+ * pci_iomap_range - create a virtual mapping cookie for a PCI BAR
  * @dev: PCI device that owns the BAR
  * @bar: BAR number
- * @maxlen: length of the memory to map
+ * @offset: map memory at the given offset in BAR
+ * @maxlen: max length of the memory to map
  *
  * Using this function you will get a __iomem address to your device BAR.
  * You can access it using ioread*() and iowrite*(). These functions hide
@@ -21,16 +22,21 @@
  * you expect from them in the correct way.
  *
  * @maxlen specifies the maximum length to map. If you want to get access to
- * the complete BAR without checking for its length first, pass %0 here.
+ * the complete BAR from offset to the end, pass %0 here.
  * */
-void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
+void __iomem *pci_iomap_range(struct pci_dev *dev,
+			      int bar,
+			      unsigned long offset,
+			      unsigned long maxlen)
 {
 	resource_size_t start = pci_resource_start(dev, bar);
 	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
 
-	if (!len || !start)
+	if (len <= offset || !start)
 		return NULL;
+	len -= offset;
+	start += offset;
 	if (maxlen && len > maxlen)
 		len = maxlen;
 	if (flags & IORESOURCE_IO)
@@ -43,6 +49,25 @@ void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 	/* What? */
 	return NULL;
 }
+EXPORT_SYMBOL(pci_iomap_range);
 
+/**
+ * pci_iomap - create a virtual mapping cookie for a PCI BAR
+ * @dev: PCI device that owns the BAR
+ * @bar: BAR number
+ * @maxlen: length of the memory to map
+ *
+ * Using this function you will get a __iomem address to your device BAR.
+ * You can access it using ioread*() and iowrite*(). These functions hide
+ * the details if this is a MMIO or PIO address space and will just do what
+ * you expect from them in the correct way.
+ *
+ * @maxlen specifies the maximum length to map. If you want to get access to
+ * the complete BAR without checking for its length first, pass %0 here.
+ * */
+void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
+{
+	return pci_iomap_range(dev, bar, 0, maxlen);
+}
 EXPORT_SYMBOL(pci_iomap);
 #endif /* CONFIG_PCI */
-- 
MST

