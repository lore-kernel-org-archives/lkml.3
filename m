Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824AbaLKTiE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 14:38:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758797AbaLKThv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 14:37:51 -0500
Date: Thu, 11 Dec 2014 21:37:34 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, cornelia.huck@de.ibm.com,
        Michael S Tsirkin <mst@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org
Subject: [PATCH RFC 3/5] pci: add pci_iomap_range
Message-ID: <1418326570-9541-4-git-send-email-mst@redhat.com>
References: <1418326570-9541-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418326570-9541-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael S Tsirkin <mst@redhat.com>

Virtio drivers should map the part of the range they need, not necessarily
all of it. They also need non-cacheable mapping even for
prefetchable BARs.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/asm-generic/pci_iomap.h |  5 +++++
 lib/pci_iomap.c                 | 46 +++++++++++++++++++++++++++++++++++------
 2 files changed, 45 insertions(+), 6 deletions(-)

diff --git a/include/asm-generic/pci_iomap.h b/include/asm-generic/pci_iomap.h
index ce37349..8777331 100644
--- a/include/asm-generic/pci_iomap.h
+++ b/include/asm-generic/pci_iomap.h
@@ -15,6 +15,11 @@ struct pci_dev;
 #ifdef CONFIG_PCI
 /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
 extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
+extern void __iomem *pci_iomap_range(struct pci_dev *dev, int bar,
+				     unsigned offset,
+				     unsigned long minlen,
+				     unsigned long maxlen,
+				     bool force_nocache);
 /* Create a virtual mapping cookie for a port on a given PCI device.
  * Do not call this directly, it exists to make it easier for architectures
  * to override */
diff --git a/lib/pci_iomap.c b/lib/pci_iomap.c
index 0d83ea8..1ac4def 100644
--- a/lib/pci_iomap.c
+++ b/lib/pci_iomap.c
@@ -10,33 +10,47 @@
 
 #ifdef CONFIG_PCI
 /**
- * pci_iomap - create a virtual mapping cookie for a PCI BAR
+ * pci_iomap_range - create a virtual mapping cookie for a PCI BAR
  * @dev: PCI device that owns the BAR
  * @bar: BAR number
- * @maxlen: length of the memory to map
+ * @offset: map memory at the given offset in BAR
+ * @minlen: min length of the memory to map
+ * @maxlen: max length of the memory to map
  *
  * Using this function you will get a __iomem address to your device BAR.
  * You can access it using ioread*() and iowrite*(). These functions hide
  * the details if this is a MMIO or PIO address space and will just do what
  * you expect from them in the correct way.
  *
+ * @minlen specifies the minimum length to map. We check that BAR is
+ * large enough.
  * @maxlen specifies the maximum length to map. If you want to get access to
- * the complete BAR without checking for its length first, pass %0 here.
+ * the complete BAR from offset to the end, pass %0 here.
+ * @force_nocache makes the mapping noncacheable even if the BAR
+ * is prefetcheable. It has no effect otherwise.
  * */
-void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
+void __iomem *pci_iomap_range(struct pci_dev *dev, int bar,
+			      unsigned offset,
+			      unsigned long minlen,
+			      unsigned long maxlen,
+			      bool force_nocache)
 {
 	resource_size_t start = pci_resource_start(dev, bar);
 	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
 
-	if (!len || !start)
+	if (len <= offset || !start)
+		return NULL;
+	len -= offset;
+	start += offset;
+	if (len < minlen)
 		return NULL;
 	if (maxlen && len > maxlen)
 		len = maxlen;
 	if (flags & IORESOURCE_IO)
 		return __pci_ioport_map(dev, start, len);
 	if (flags & IORESOURCE_MEM) {
-		if (flags & IORESOURCE_CACHEABLE)
+		if (!force_nocache && (flags & IORESOURCE_CACHEABLE))
 			return ioremap(start, len);
 		return ioremap_nocache(start, len);
 	}
@@ -44,5 +58,25 @@ void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 	return NULL;
 }
 
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
+	return pci_iomap_range(dev, bar, 0, 0, maxlen, false);
+}
+
 EXPORT_SYMBOL(pci_iomap);
+EXPORT_SYMBOL(pci_iomap_range);
 #endif /* CONFIG_PCI */
-- 
MST

