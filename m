Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927AbaGCPvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:51:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756460AbaGCPvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:51:35 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 3/7] iommu/amd: Use iommu_group_get_for_dev()
To: iommu@lists.linux-foundation.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Date: Thu, 03 Jul 2014 09:51:30 -0600
Message-ID: <20140703155130.8112.99665.stgit@gimli.home>
In-Reply-To: <20140703154428.8112.97562.stgit@gimli.home>
References: <20140703154428.8112.97562.stgit@gimli.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The common iommu_group_get_for_dev() allows us to greatly simplify
our group lookup for a new device.  Also, since we insert IVRS
aliases into the PCI DMA alias quirks, we should alway come up with
the same results as the existing code.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>
---

 drivers/iommu/amd_iommu.c       |  164 +--------------------------------------
 drivers/iommu/amd_iommu_types.h |    1 
 2 files changed, 5 insertions(+), 160 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 25d7571..2e03c17 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -46,7 +46,6 @@
 #include "amd_iommu_proto.h"
 #include "amd_iommu_types.h"
 #include "irq_remapping.h"
-#include "pci.h"
 
 #define CMD_SET_TYPE(cmd, t) ((cmd)->data[1] |= ((t) << 28))
 
@@ -133,9 +132,6 @@ static void free_dev_data(struct iommu_dev_data *dev_data)
 	list_del(&dev_data->dev_data_list);
 	spin_unlock_irqrestore(&dev_data_list_lock, flags);
 
-	if (dev_data->group)
-		iommu_group_put(dev_data->group);
-
 	kfree(dev_data);
 }
 
@@ -264,167 +260,17 @@ static bool check_device(struct device *dev)
 	return true;
 }
 
-static struct pci_bus *find_hosted_bus(struct pci_bus *bus)
-{
-	while (!bus->self) {
-		if (!pci_is_root_bus(bus))
-			bus = bus->parent;
-		else
-			return ERR_PTR(-ENODEV);
-	}
-
-	return bus;
-}
-
-#define REQ_ACS_FLAGS	(PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF)
-
-static struct pci_dev *get_isolation_root(struct pci_dev *pdev)
-{
-	struct pci_dev *dma_pdev = pdev;
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
-		struct pci_bus *bus = find_hosted_bus(dma_pdev->bus);
-		if (IS_ERR(bus))
-			break;
-
-		if (pci_acs_path_enabled(bus->self, NULL, REQ_ACS_FLAGS))
-			break;
-
-		swap_pci_ref(&dma_pdev, pci_dev_get(bus->self));
-	}
-
-	return dma_pdev;
-}
-
-static int use_pdev_iommu_group(struct pci_dev *pdev, struct device *dev)
-{
-	struct iommu_group *group = iommu_group_get(&pdev->dev);
-	int ret;
-
-	if (!group) {
-		group = iommu_group_alloc();
-		if (IS_ERR(group))
-			return PTR_ERR(group);
-
-		WARN_ON(&pdev->dev != dev);
-	}
-
-	ret = iommu_group_add_device(group, dev);
-	iommu_group_put(group);
-	return ret;
-}
-
-static int use_dev_data_iommu_group(struct iommu_dev_data *dev_data,
-				    struct device *dev)
-{
-	if (!dev_data->group) {
-		struct iommu_group *group = iommu_group_alloc();
-		if (IS_ERR(group))
-			return PTR_ERR(group);
-
-		dev_data->group = group;
-	}
-
-	return iommu_group_add_device(dev_data->group, dev);
-}
-
 static int init_iommu_group(struct device *dev)
 {
-	struct iommu_dev_data *dev_data;
 	struct iommu_group *group;
-	struct pci_dev *dma_pdev;
-	int ret;
 
-	group = iommu_group_get(dev);
-	if (group) {
-		iommu_group_put(group);
-		return 0;
-	}
+	group = iommu_group_get_for_dev(dev);
 
-	dev_data = find_dev_data(get_device_id(dev));
-	if (!dev_data)
-		return -ENOMEM;
-
-	if (dev_data->alias_data) {
-		u16 alias;
-		struct pci_bus *bus;
-
-		if (dev_data->alias_data->group)
-			goto use_group;
+	if (IS_ERR(group))
+		return PTR_ERR(group);
 
-		/*
-		 * If the alias device exists, it's effectively just a first
-		 * level quirk for finding the DMA source.
-		 */
-		alias = amd_iommu_alias_table[dev_data->devid];
-		dma_pdev = pci_get_bus_and_slot(alias >> 8, alias & 0xff);
-		if (dma_pdev) {
-			dma_pdev = get_isolation_root(dma_pdev);
-			goto use_pdev;
-		}
-
-		/*
-		 * If the alias is virtual, try to find a parent device
-		 * and test whether the IOMMU group is actualy rooted above
-		 * the alias.  Be careful to also test the parent device if
-		 * we think the alias is the root of the group.
-		 */
-		bus = pci_find_bus(0, alias >> 8);
-		if (!bus)
-			goto use_group;
-
-		bus = find_hosted_bus(bus);
-		if (IS_ERR(bus) || !bus->self)
-			goto use_group;
-
-		dma_pdev = get_isolation_root(pci_dev_get(bus->self));
-		if (dma_pdev != bus->self || (dma_pdev->multifunction &&
-		    !pci_acs_enabled(dma_pdev, REQ_ACS_FLAGS)))
-			goto use_pdev;
-
-		pci_dev_put(dma_pdev);
-		goto use_group;
-	}
-
-	dma_pdev = get_isolation_root(pci_dev_get(to_pci_dev(dev)));
-use_pdev:
-	ret = use_pdev_iommu_group(dma_pdev, dev);
-	pci_dev_put(dma_pdev);
-	return ret;
-use_group:
-	return use_dev_data_iommu_group(dev_data->alias_data, dev);
+	iommu_group_put(group);
+	return 0;
 }
 
 static int __last_alias(struct pci_dev *pdev, u16 alias, void *data)
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index f1a5abf..7277a20 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -432,7 +432,6 @@ struct iommu_dev_data {
 	struct iommu_dev_data *alias_data;/* The alias dev_data */
 	struct protection_domain *domain; /* Domain the device is bound to */
 	atomic_t bind;			  /* Domain attach reference count */
-	struct iommu_group *group;	  /* IOMMU group for virtual aliases */
 	u16 devid;			  /* PCI Device ID */
 	bool iommu_v2;			  /* Device can make use of IOMMUv2 */
 	bool passthrough;		  /* Default for device is pt_domain */

