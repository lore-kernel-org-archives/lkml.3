Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbaEAQ2C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 12:28:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbaEAQ16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 12:27:58 -0400
Subject: [PATCH 08/13] iommu/intel: Use pci_find_dma_isolation_root() for
 IOMMU groups
From: Alex Williamson <alex.williamson@redhat.com>
To: linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org
Cc: bhelgaas@google.com, acooks@gmail.com,
        David Woodhouse <David.Woodhouse@intel.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 01 May 2014 10:27:54 -0600
Message-ID: <20140501162754.17512.36589.stgit@bling.home>
In-Reply-To: <20140501160128.17512.23609.stgit@bling.home>
References: <20140501160128.17512.23609.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop custom code that attempts to do the exact same thing and use
PCI provided isolation root support.  Existing IOMMU group laytout
should not change.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Cc: David Woodhouse <David.Woodhouse@intel.com>
---
 drivers/iommu/intel-iommu.c |   71 +++++--------------------------------------
 1 file changed, 8 insertions(+), 63 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index f256ffc..f0e50f1 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -44,7 +44,6 @@
 #include <asm/iommu.h>
 
 #include "irq_remapping.h"
-#include "pci.h"
 
 #define ROOT_SIZE		VTD_PAGE_SIZE
 #define CONTEXT_SIZE		VTD_PAGE_SIZE
@@ -4359,12 +4358,9 @@ static int intel_iommu_domain_has_cap(struct iommu_domain *domain,
 	return 0;
 }
 
-#define REQ_ACS_FLAGS	(PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF)
-
 static int intel_iommu_add_device(struct device *dev)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct pci_dev *bridge, *dma_pdev = NULL;
+	struct pci_dev *pdev;
 	struct iommu_group *group;
 	int ret;
 	u8 bus, devfn;
@@ -4372,68 +4368,16 @@ static int intel_iommu_add_device(struct device *dev)
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
+	group = iommu_group_get(dev);
+	if (group) {
+		iommu_group_put(group);
+		return 0;
 	}
 
-	/*
-	 * Devices on the root bus go through the iommu.  If that's not us,
-	 * find the next upstream device and test ACS up to the root bus.
-	 * Finding the next device may require skipping virtual buses.
-	 */
-	while (!pci_is_root_bus(dma_pdev->bus)) {
-		struct pci_bus *bus = dma_pdev->bus;
+	pdev = pci_find_dma_isolation_root(to_pci_dev(dev));
 
-		while (!bus->self) {
-			if (!pci_is_root_bus(bus))
-				bus = bus->parent;
-			else
-				goto root_bus;
-		}
+	group = iommu_group_get(&pdev->dev);
 
-		if (pci_acs_path_enabled(bus->self, NULL, REQ_ACS_FLAGS))
-			break;
-
-		swap_pci_ref(&dma_pdev, pci_dev_get(bus->self));
-	}
-
-root_bus:
-	group = iommu_group_get(&dma_pdev->dev);
-	pci_dev_put(dma_pdev);
 	if (!group) {
 		group = iommu_group_alloc();
 		if (IS_ERR(group))
@@ -4443,6 +4387,7 @@ root_bus:
 	ret = iommu_group_add_device(group, dev);
 
 	iommu_group_put(group);
+
 	return ret;
 }
 

