Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbaEAQ2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 12:28:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995AbaEAQ22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 12:28:28 -0400
Subject: [PATCH 13/13] PCI: Remove pci_get_dma_source()
From: Alex Williamson <alex.williamson@redhat.com>
To: linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org
Cc: bhelgaas@google.com, acooks@gmail.com, linux-kernel@vger.kernel.org
Date: Thu, 01 May 2014 10:28:24 -0600
Message-ID: <20140501162824.17512.556.stgit@bling.home>
In-Reply-To: <20140501160128.17512.23609.stgit@bling.home>
References: <20140501160128.17512.23609.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It has no users; replaced by dma_func_alias.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/pci/quirks.c |   51 --------------------------------------------------
 include/linux/pci.h  |    5 -----
 2 files changed, 56 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 82b2733..ea55b0f 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3371,57 +3371,6 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_JMICRON,
 			 PCI_DEVICE_ID_JMICRON_JMB388_ESD,
 			 quirk_dma_func1_alias);
 
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
index bf4b0e9..65bdcfd 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1530,16 +1530,11 @@ enum pci_fixup_pass {
 
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

