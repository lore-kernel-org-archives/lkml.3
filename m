Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbaEAQ2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 12:28:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbaEAQ2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 12:28:11 -0400
Subject: [PATCH 10/13] iommu/fsl: Use pci_find_dma_isolation_root() for
 IOMMU groups
From: Alex Williamson <alex.williamson@redhat.com>
To: linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org
Cc: bhelgaas@google.com, Varun Sethi <varun.sethi@freescale.com>,
        acooks@gmail.com, linux-kernel@vger.kernel.org
Date: Thu, 01 May 2014 10:28:06 -0600
Message-ID: <20140501162806.17512.54367.stgit@bling.home>
In-Reply-To: <20140501160128.17512.23609.stgit@bling.home>
References: <20140501160128.17512.23609.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop custom code and use PCI provided isolation root support.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Cc: Varun Sethi <varun.sethi@freescale.com>
---
 drivers/iommu/fsl_pamu_domain.c |   67 ++-------------------------------------
 1 file changed, 3 insertions(+), 64 deletions(-)

diff --git a/drivers/iommu/fsl_pamu_domain.c b/drivers/iommu/fsl_pamu_domain.c
index 93072ba..83e3e7c 100644
--- a/drivers/iommu/fsl_pamu_domain.c
+++ b/drivers/iommu/fsl_pamu_domain.c
@@ -38,7 +38,6 @@
 #include <sysdev/fsl_pci.h>
 
 #include "fsl_pamu_domain.h"
-#include "pci.h"
 
 /*
  * Global spinlock that needs to be held while
@@ -892,8 +891,6 @@ static int fsl_pamu_get_domain_attr(struct iommu_domain *domain,
 	return ret;
 }
 
-#define REQ_ACS_FLAGS	(PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF)
-
 static struct iommu_group *get_device_iommu_group(struct device *dev)
 {
 	struct iommu_group *group;
@@ -950,74 +947,16 @@ static struct iommu_group *get_pci_device_group(struct pci_dev *pdev)
 	struct pci_controller *pci_ctl;
 	bool pci_endpt_partioning;
 	struct iommu_group *group = NULL;
-	struct pci_dev *bridge, *dma_pdev = NULL;
+	struct pci_dev *dma_pdev;
 
 	pci_ctl = pci_bus_to_host(pdev->bus);
 	pci_endpt_partioning = check_pci_ctl_endpt_part(pci_ctl);
 	/* We can partition PCIe devices so assign device group to the device */
 	if (pci_endpt_partioning) {
-		bridge = pci_find_upstream_pcie_bridge(pdev);
-		if (bridge) {
-			if (pci_is_pcie(bridge))
-				dma_pdev = pci_get_domain_bus_and_slot(
-						pci_domain_nr(pdev->bus),
-						bridge->subordinate->number, 0);
-			if (!dma_pdev)
-				dma_pdev = pci_dev_get(bridge);
-		} else
-			dma_pdev = pci_dev_get(pdev);
-
-		/* Account for quirked devices */
-		swap_pci_ref(&dma_pdev, pci_get_dma_source(dma_pdev));
-
-		/*
-		 * If it's a multifunction device that does not support our
-		 * required ACS flags, add to the same group as lowest numbered
-		 * function that also does not suport the required ACS flags.
-		 */
-		if (dma_pdev->multifunction &&
-		    !pci_acs_enabled(dma_pdev, REQ_ACS_FLAGS)) {
-			u8 i, slot = PCI_SLOT(dma_pdev->devfn);
+		dma_pdev = pci_find_dma_isolation_root(pdev);
 
-			for (i = 0; i < 8; i++) {
-				struct pci_dev *tmp;
-
-				tmp = pci_get_slot(dma_pdev->bus, PCI_DEVFN(slot, i));
-				if (!tmp)
-					continue;
-
-				if (!pci_acs_enabled(tmp, REQ_ACS_FLAGS)) {
-					swap_pci_ref(&dma_pdev, tmp);
-					break;
-				}
-				pci_dev_put(tmp);
-			}
-		}
-
-		/*
-		 * Devices on the root bus go through the iommu.  If that's not us,
-		 * find the next upstream device and test ACS up to the root bus.
-		 * Finding the next device may require skipping virtual buses.
-		 */
-		while (!pci_is_root_bus(dma_pdev->bus)) {
-			struct pci_bus *bus = dma_pdev->bus;
-
-			while (!bus->self) {
-				if (!pci_is_root_bus(bus))
-					bus = bus->parent;
-				else
-					goto root_bus;
-			}
-
-			if (pci_acs_path_enabled(bus->self, NULL, REQ_ACS_FLAGS))
-				break;
-
-			swap_pci_ref(&dma_pdev, pci_dev_get(bus->self));
-		}
-
-root_bus:
 		group = get_device_iommu_group(&dma_pdev->dev);
-		pci_dev_put(dma_pdev);
+
 		/*
 		 * PCIe controller is not a paritionable entity
 		 * free the controller device iommu_group.

