Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759137AbaGCPwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:52:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759056AbaGCPwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:52:02 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 4/7] iommu/intel: Use iommu_group_get_for_dev()
To: iommu@lists.linux-foundation.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Date: Thu, 03 Jul 2014 09:51:37 -0600
Message-ID: <20140703155136.8112.64951.stgit@gimli.home>
In-Reply-To: <20140703154428.8112.97562.stgit@gimli.home>
References: <20140703154428.8112.97562.stgit@gimli.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IOMMU code now provides a common interface for finding or
creating an IOMMU group for a device on PCI buses.  Make use of it
and remove piles of code.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
---

 drivers/iommu/intel-iommu.c |   79 ++-----------------------------------------
 1 file changed, 4 insertions(+), 75 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 51b6b77..9128c84 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -45,7 +45,6 @@
 #include <asm/iommu.h>
 
 #include "irq_remapping.h"
-#include "pci.h"
 
 #define ROOT_SIZE		VTD_PAGE_SIZE
 #define CONTEXT_SIZE		VTD_PAGE_SIZE
@@ -4373,91 +4372,21 @@ static int intel_iommu_domain_has_cap(struct iommu_domain *domain,
 	return 0;
 }
 
-#define REQ_ACS_FLAGS	(PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF)
-
 static int intel_iommu_add_device(struct device *dev)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct pci_dev *bridge, *dma_pdev = NULL;
 	struct iommu_group *group;
-	int ret;
 	u8 bus, devfn;
 
 	if (!device_to_iommu(dev, &bus, &devfn))
 		return -ENODEV;
 
-	bridge = pci_find_upstream_pcie_bridge(pdev);
-	if (bridge) {
-		if (pci_is_pcie(bridge))
-			dma_pdev = pci_get_domain_bus_and_slot(
-						pci_domain_nr(pdev->bus),
-						bridge->subordinate->number, 0);
-		if (!dma_pdev)
-			dma_pdev = pci_dev_get(bridge);
-	} else
-		dma_pdev = pci_dev_get(pdev);
-
-	/* Account for quirked devices */
-	swap_pci_ref(&dma_pdev, pci_get_dma_source(dma_pdev));
-
-	/*
-	 * If it's a multifunction device that does not support our
-	 * required ACS flags, add to the same group as lowest numbered
-	 * function that also does not suport the required ACS flags.
-	 */
-	if (dma_pdev->multifunction &&
-	    !pci_acs_enabled(dma_pdev, REQ_ACS_FLAGS)) {
-		u8 i, slot = PCI_SLOT(dma_pdev->devfn);
-
-		for (i = 0; i < 8; i++) {
-			struct pci_dev *tmp;
-
-			tmp = pci_get_slot(dma_pdev->bus, PCI_DEVFN(slot, i));
-			if (!tmp)
-				continue;
-
-			if (!pci_acs_enabled(tmp, REQ_ACS_FLAGS)) {
-				swap_pci_ref(&dma_pdev, tmp);
-				break;
-			}
-			pci_dev_put(tmp);
-		}
-	}
-
-	/*
-	 * Devices on the root bus go through the iommu.  If that's not us,
-	 * find the next upstream device and test ACS up to the root bus.
-	 * Finding the next device may require skipping virtual buses.
-	 */
-	while (!pci_is_root_bus(dma_pdev->bus)) {
-		struct pci_bus *bus = dma_pdev->bus;
-
-		while (!bus->self) {
-			if (!pci_is_root_bus(bus))
-				bus = bus->parent;
-			else
-				goto root_bus;
-		}
-
-		if (pci_acs_path_enabled(bus->self, NULL, REQ_ACS_FLAGS))
-			break;
-
-		swap_pci_ref(&dma_pdev, pci_dev_get(bus->self));
-	}
+	group = iommu_group_get_for_dev(dev);
 
-root_bus:
-	group = iommu_group_get(&dma_pdev->dev);
-	pci_dev_put(dma_pdev);
-	if (!group) {
-		group = iommu_group_alloc();
-		if (IS_ERR(group))
-			return PTR_ERR(group);
-	}
-
-	ret = iommu_group_add_device(group, dev);
+	if (IS_ERR(group))
+		return PTR_ERR(group);
 
 	iommu_group_put(group);
-	return ret;
+	return 0;
 }
 
 static void intel_iommu_remove_device(struct device *dev)

