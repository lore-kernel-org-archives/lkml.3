Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbaEAQ1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 12:27:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbaEAQ1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 12:27:21 -0400
Subject: [PATCH 02/13] PCI: quirk pci_for_each_dma_alias()
From: Alex Williamson <alex.williamson@redhat.com>
To: linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org
Cc: bhelgaas@google.com, acooks@gmail.com, linux-kernel@vger.kernel.org
Date: Thu, 01 May 2014 10:27:18 -0600
Message-ID: <20140501162717.17512.25998.stgit@bling.home>
In-Reply-To: <20140501160128.17512.23609.stgit@bling.home>
References: <20140501160128.17512.23609.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a few broken devices that use the requester ID of a different
function in the slot for their DMA.  To handle these, add a bitmap to
struct pci_dev (using an alignment gap) that quirks can populate.  As
we iterate over the device and bus DMA aliases, also iterate over any
bits in the map.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/pci/search.c |   21 +++++++++++++++++++++
 include/linux/pci.h  |    2 ++
 2 files changed, 23 insertions(+)

diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index 5601cdb..ad698b2 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -37,6 +37,27 @@ int pci_for_each_dma_alias(struct pci_dev *pdev,
 	if (ret)
 		return ret;
 
+	/*
+	 * dma_func_alias provides a bitmap of other function numbers on
+	 * this same PCI slot to use as DMA aliases.
+	 */
+	if (unlikely(pdev->dma_func_alias)) {
+		u8 map = pdev->dma_func_alias & ~(1 << PCI_FUNC(pdev->devfn));
+		int func;
+
+		for (func = 0; map && func < 8; func++, map >>= 1) {
+			if (!(map & 1))
+				continue;
+
+			ret = fn(pdev,
+				 PCI_DEVID(pdev->bus->number,
+					   PCI_DEVFN(PCI_SLOT(pdev->devfn),
+					   func)), data);
+			if (ret)
+				return ret;
+		}
+	}
+
 	for (bus = pdev->bus; !pci_is_root_bus(bus); bus = bus->parent) {
 		struct pci_dev *tmp;
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 14b074b..b4c97d2 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -268,6 +268,8 @@ struct pci_dev {
 	u8		rom_base_reg;	/* which config register controls the ROM */
 	u8		pin;		/* which interrupt pin this device uses */
 	u16		pcie_flags_reg;	/* cached PCIe Capabilities Register */
+	u8		dma_func_alias;	/* bitmap of functions used as DMA
+					   aliases for this device */
 
 	struct pci_driver *driver;	/* which driver has allocated this device */
 	u64		dma_mask;	/* Mask of the bits of bus address this

