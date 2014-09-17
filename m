Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602AbaIQQlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:41:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756046AbaIQQlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:41:16 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v2 2/2] PCI: Remove pci_get_dma_source()
To: linux-pci@vger.kernel.org, bhelgaas@google.com
Cc: linux-kernel@vger.kernel.org
Date: Wed, 17 Sep 2014 10:41:13 -0600
Message-ID: <20140917164112.21584.66565.stgit@gimli.home>
In-Reply-To: <20140917163930.21584.69496.stgit@gimli.home>
References: <20140917163930.21584.69496.stgit@gimli.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove dead code.  We now have dma_alias_devfn to describe this

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/pci/quirks.c |   51 --------------------------------------------------
 include/linux/pci.h  |    5 -----
 2 files changed, 56 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 78cc83f..e232425 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3512,57 +3512,6 @@ DECLARE_PCI_FIXUP_HEADER(0x1283, 0x8892, quirk_use_pcie_bridge_dma_alias);
 /* Intel 82801, https://bugzilla.kernel.org/show_bug.cgi?id=44881#c49 */
 DECLARE_PCI_FIXUP_HEADER(0x8086, 0x244e, quirk_use_pcie_bridge_dma_alias);
 
-static struct pci_dev *pci_func_0_dma_source(struct pci_dev *dev)
-{
-	if (!PCI_FUNC(dev->devfn))
-		return pci_dev_get(dev);
-
-	return pci_get_slot(dev->bus, PCI_DEVFN(PCI_SLOT(dev->devfn), 0));
-}
-
-static const struct pci_dev_dma_source {
-	u16 vendor;
-	u16 device;
-	struct pci_dev *(*dma_source)(struct pci_dev *dev);
-} pci_dev_dma_source[] = {
-	/*
-	 * https://bugzilla.redhat.com/show_bug.cgi?id=605888
-	 *
-	 * Some Ricoh devices use the function 0 source ID for DMA on
-	 * other functions of a multifunction device.  The DMA devices
-	 * is therefore function 0, which will have implications of the
-	 * iommu grouping of these devices.
-	 */
-	{ PCI_VENDOR_ID_RICOH, 0xe822, pci_func_0_dma_source },
-	{ PCI_VENDOR_ID_RICOH, 0xe230, pci_func_0_dma_source },
-	{ PCI_VENDOR_ID_RICOH, 0xe832, pci_func_0_dma_source },
-	{ PCI_VENDOR_ID_RICOH, 0xe476, pci_func_0_dma_source },
-	{ 0 }
-};
-
-/*
- * IOMMUs with isolation capabilities need to be programmed with the
- * correct source ID of a device.  In most cases, the source ID matches
- * the device doing the DMA, but sometimes hardware is broken and will
- * tag the DMA as being sourced from a different device.  This function
- * allows that translation.  Note that the reference count of the
- * returned device is incremented on all paths.
- */
-struct pci_dev *pci_get_dma_source(struct pci_dev *dev)
-{
-	const struct pci_dev_dma_source *i;
-
-	for (i = pci_dev_dma_source; i->dma_source; i++) {
-		if ((i->vendor == dev->vendor ||
-		     i->vendor == (u16)PCI_ANY_ID) &&
-		    (i->device == dev->device ||
-		     i->device == (u16)PCI_ANY_ID))
-			return i->dma_source(dev);
-	}
-
-	return pci_dev_get(dev);
-}
-
 /*
  * AMD has indicated that the devices below do not support peer-to-peer
  * in any system where they are found in the southbridge with an AMD
diff --git a/include/linux/pci.h b/include/linux/pci.h
index b4fb9f4..b4937d7 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1557,16 +1557,11 @@ enum pci_fixup_pass {
 
 #ifdef CONFIG_PCI_QUIRKS
 void pci_fixup_device(enum pci_fixup_pass pass, struct pci_dev *dev);
-struct pci_dev *pci_get_dma_source(struct pci_dev *dev);
 int pci_dev_specific_acs_enabled(struct pci_dev *dev, u16 acs_flags);
 void pci_dev_specific_enable_acs(struct pci_dev *dev);
 #else
 static inline void pci_fixup_device(enum pci_fixup_pass pass,
 				    struct pci_dev *dev) { }
-static inline struct pci_dev *pci_get_dma_source(struct pci_dev *dev)
-{
-	return pci_dev_get(dev);
-}
 static inline int pci_dev_specific_acs_enabled(struct pci_dev *dev,
 					       u16 acs_flags)
 {

