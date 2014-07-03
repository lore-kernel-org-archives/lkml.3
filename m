Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844AbaGCPvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:51:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756403AbaGCPva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:51:30 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 2/7] iommu/amd: Update to use PCI DMA aliases
To: iommu@lists.linux-foundation.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Date: Thu, 03 Jul 2014 09:51:24 -0600
Message-ID: <20140703155124.8112.99914.stgit@gimli.home>
In-Reply-To: <20140703154428.8112.97562.stgit@gimli.home>
References: <20140703154428.8112.97562.stgit@gimli.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AMD-Vi already has a concept of an alias provided via the IVRS table.
Now that PCI-core also understands aliases, we need to incorporate
both aspects when programming the IOMMU.  IVRS is generally quite
reliable, so we continue to prefer it when an alias is present.  For
cases where we have an IVRS alias that does not match the PCI alias
or where PCI does not report an alias, report the mismatch to allow
us to collect more quirks and dynamically incorporate the alias into
the device alias quirks where possible.

This should allow AMD-Vi to work with devices like Marvell and Ricoh
with DMA function alias quirks unknown to the BIOS.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>
---

 drivers/iommu/amd_iommu.c |   78 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 74 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 4aec6a2..25d7571 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -427,6 +427,68 @@ use_group:
 	return use_dev_data_iommu_group(dev_data->alias_data, dev);
 }
 
+static int __last_alias(struct pci_dev *pdev, u16 alias, void *data)
+{
+	*(u16 *)data = alias;
+	return 0;
+}
+
+static u16 get_alias(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	u16 devid, ivrs_alias, pci_alias;
+
+	devid = get_device_id(dev);
+	ivrs_alias = amd_iommu_alias_table[devid];
+	pci_for_each_dma_alias(pdev, __last_alias, &pci_alias);
+
+	if (ivrs_alias == pci_alias)
+		return ivrs_alias;
+
+	/*
+	 * DMA alias showdown
+	 *
+	 * The IVRS is fairly reliable in telling us about aliases, but it
+	 * can't know about every screwy device.  If we don't have an IVRS
+	 * reported alias, use the PCI reported alias.  In that case we may
+	 * still need to initialize the rlookup and dev_table entries if the
+	 * alias is to a non-existent device.
+	 */
+	if (ivrs_alias == devid) {
+		if (!amd_iommu_rlookup_table[pci_alias]) {
+			amd_iommu_rlookup_table[pci_alias] =
+				amd_iommu_rlookup_table[devid];
+			memcpy(amd_iommu_dev_table[pci_alias].data,
+			       amd_iommu_dev_table[devid].data,
+			       sizeof(amd_iommu_dev_table[pci_alias].data));
+		}
+
+		return pci_alias;
+	}
+
+	pr_info("AMD-Vi: Using IVRS reported alias %02x:%02x.%d "
+		"for device %s[%04x:%04x], kernel reported alias "
+		"%02x:%02x.%d\n", PCI_BUS_NUM(ivrs_alias), PCI_SLOT(ivrs_alias),
+		PCI_FUNC(ivrs_alias), dev_name(dev), pdev->vendor, pdev->device,
+		PCI_BUS_NUM(pci_alias), PCI_SLOT(pci_alias),
+		PCI_FUNC(pci_alias));
+
+	/*
+	 * If we don't have a PCI DMA alias and the IVRS alias is on the same
+	 * bus, then the IVRS table may know about a quirk that we don't.
+	 */
+	if (pci_alias == devid &&
+	    PCI_BUS_NUM(ivrs_alias) == pdev->bus->number) {
+		pdev->dev_flags |= PCI_DEV_FLAGS_DMA_ALIAS_DEVFN;
+		pdev->dma_alias_devfn = ivrs_alias & 0xff;
+		pr_info("AMD-Vi: Added PCI DMA alias %02x.%d for %s\n",
+			PCI_SLOT(ivrs_alias), PCI_FUNC(ivrs_alias),
+			dev_name(dev));
+	}
+
+	return ivrs_alias;
+}
+
 static int iommu_init_device(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
@@ -441,7 +503,8 @@ static int iommu_init_device(struct device *dev)
 	if (!dev_data)
 		return -ENOMEM;
 
-	alias = amd_iommu_alias_table[dev_data->devid];
+	alias = get_alias(dev);
+
 	if (alias != dev_data->devid) {
 		struct iommu_dev_data *alias_data;
 
@@ -489,12 +552,19 @@ static void iommu_ignore_device(struct device *dev)
 
 static void iommu_uninit_device(struct device *dev)
 {
+	struct iommu_dev_data *dev_data = search_dev_data(get_device_id(dev));
+
+	if (!dev_data)
+		return;
+
 	iommu_group_remove_device(dev);
 
+	/* Unlink from alias, it may change if another device is re-plugged */
+	dev_data->alias_data = NULL;
+
 	/*
-	 * Nothing to do here - we keep dev_data around for unplugged devices
-	 * and reuse it when the device is re-plugged - not doing so would
-	 * introduce a ton of races.
+	 * We keep dev_data around for unplugged devices and reuse it when the
+	 * device is re-plugged - not doing so would introduce a ton of races.
 	 */
 }
 

