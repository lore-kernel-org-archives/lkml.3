Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbaIOT0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:26:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54593 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750AbaIOT0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:26:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Wei Yang <weiyang@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.16 012/158] powerpc/powernv: Fix IOMMU group lost
Date: Mon, 15 Sep 2014 12:24:11 -0700
Message-Id: <20140915192543.251710399@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gavin Shan <gwshan@linux.vnet.ibm.com>

commit 763fe0addb8fe15ccea67c0aebddc06f4bb25439 upstream.

When we take full hotplug to recover from EEH errors, PCI buses
could be involved. For the case, the child devices of involved
PCI buses can't be attached to IOMMU group properly, which is
caused by commit 3f28c5a ("powerpc/powernv: Reduce multi-hit of
iommu_add_device()").

When adding the PCI devices of the newly created PCI buses to
the system, the IOMMU group is expected to be added in (C).
(A) fails to bind the IOMMU group because bus->is_added is
false. (B) fails because the device doesn't have binding IOMMU
table yet. bus->is_added is set to true at end of (C) and
pdev->is_added is set to true at (D).

   pcibios_add_pci_devices()
      pci_scan_bridge()
         pci_scan_child_bus()
            pci_scan_slot()
               pci_scan_single_device()
                  pci_scan_device()
                  pci_device_add()
                     pcibios_add_device()           A: Ignore
                     device_add()                   B: Ignore
                  pcibios_fixup_bus()
                     pcibios_setup_bus_devices()
                        pcibios_setup_device()      C: Hit
      pcibios_finish_adding_to_bus()
         pci_bus_add_devices()
            pci_bus_add_device()                    D: Add device

If the parent PCI bus isn't involved in hotplug, the IOMMU
group is expected to be bound in (B). (A) should fail as the
sysfs entries aren't populated.

The patch fixes the issue by reverting commit 3f28c5a and remove
WARN_ON() in iommu_add_device() to allow calling the function
even the specified device already has associated IOMMU group.

Reported-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Signed-off-by: Gavin Shan <gwshan@linux.vnet.ibm.com>
Acked-by: Wei Yang <weiyang@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/iommu.c               |   38 ++++++++++++++++--------------
 arch/powerpc/platforms/powernv/pci-ioda.c |    2 -
 2 files changed, 22 insertions(+), 18 deletions(-)

--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -1120,37 +1120,41 @@ EXPORT_SYMBOL_GPL(iommu_release_ownershi
 int iommu_add_device(struct device *dev)
 {
 	struct iommu_table *tbl;
-	int ret = 0;
 
-	if (WARN_ON(dev->iommu_group)) {
-		pr_warn("iommu_tce: device %s is already in iommu group %d, skipping\n",
-				dev_name(dev),
-				iommu_group_id(dev->iommu_group));
+	/*
+	 * The sysfs entries should be populated before
+	 * binding IOMMU group. If sysfs entries isn't
+	 * ready, we simply bail.
+	 */
+	if (!device_is_registered(dev))
+		return -ENOENT;
+
+	if (dev->iommu_group) {
+		pr_debug("%s: Skipping device %s with iommu group %d\n",
+			 __func__, dev_name(dev),
+			 iommu_group_id(dev->iommu_group));
 		return -EBUSY;
 	}
 
 	tbl = get_iommu_table_base(dev);
 	if (!tbl || !tbl->it_group) {
-		pr_debug("iommu_tce: skipping device %s with no tbl\n",
-				dev_name(dev));
+		pr_debug("%s: Skipping device %s with no tbl\n",
+			 __func__, dev_name(dev));
 		return 0;
 	}
 
-	pr_debug("iommu_tce: adding %s to iommu group %d\n",
-			dev_name(dev), iommu_group_id(tbl->it_group));
+	pr_debug("%s: Adding %s to iommu group %d\n",
+		 __func__, dev_name(dev),
+		 iommu_group_id(tbl->it_group));
 
 	if (PAGE_SIZE < IOMMU_PAGE_SIZE(tbl)) {
-		pr_err("iommu_tce: unsupported iommu page size.");
-		pr_err("%s has not been added\n", dev_name(dev));
+		pr_err("%s: Invalid IOMMU page size %lx (%lx) on %s\n",
+		       __func__, IOMMU_PAGE_SIZE(tbl),
+		       PAGE_SIZE, dev_name(dev));
 		return -EINVAL;
 	}
 
-	ret = iommu_group_add_device(tbl->it_group, dev);
-	if (ret < 0)
-		pr_err("iommu_tce: %s has not been added, ret=%d\n",
-				dev_name(dev), ret);
-
-	return ret;
+	return iommu_group_add_device(tbl->it_group, dev);
 }
 EXPORT_SYMBOL_GPL(iommu_add_device);
 
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -462,7 +462,7 @@ static void pnv_pci_ioda_dma_dev_setup(s
 
 	pe = &phb->ioda.pe_array[pdn->pe_number];
 	WARN_ON(get_dma_ops(&pdev->dev) != &dma_iommu_ops);
-	set_iommu_table_base(&pdev->dev, &pe->tce32_table);
+	set_iommu_table_base_and_group(&pdev->dev, &pe->tce32_table);
 }
 
 static int pnv_pci_ioda_dma_set_mask(struct pnv_phb *phb,


