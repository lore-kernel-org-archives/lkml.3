Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846AbaEAQ1z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 12:27:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784AbaEAQ1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 12:27:53 -0400
Subject: [PATCH 07/13] iommu/amd: Update to use PCI DMA aliases
From: Alex Williamson <alex.williamson@redhat.com>
To: linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org
Cc: bhelgaas@google.com, Joerg Roedel <joro@8bytes.org>, acooks@gmail.com,
        linux-kernel@vger.kernel.org
Date: Thu, 01 May 2014 10:27:48 -0600
Message-ID: <20140501162748.17512.4466.stgit@bling.home>
In-Reply-To: <20140501160128.17512.23609.stgit@bling.home>
References: <20140501160128.17512.23609.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AMD-Vi already has a concept of an alias provided via the IVRS table.
This alias only handles topology based aliases, such as PCIe-to-PCI
bridges.  When such an alias is present, we continue to use it.  When
a platform alias is not present, we can now add a check of the device
dma_func_alias to create our own.  Note that the current code can
only handle a single alias of a device, and we don't attempt to change
that here.  It would only become a factor for the requester ID seen by
the IOMMU if PCI-X were involved anway.

Since the alias is now potentially device specific rather than the
topology based alias provided by the platform, we need to clear it
when the device goes away.

With the DMA alias and isolation infrastructure now in PCI-core, we
could opt to ignore IVRS provided aliases.  We now do this for IOMMU
groups.  However, for this more common use case, the "don't fix what
isn't broken" mantra seems like the safer route.

This should allow AMD-Vi to work with devices like Marvell and Ricoh
with DMA function alias quirks.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>
---
 drivers/iommu/amd_iommu.c |   27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 3d58de4..4621692 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -294,6 +294,7 @@ static int iommu_init_device(struct device *dev)
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct iommu_dev_data *dev_data;
 	u16 alias;
+	u8 func_alias;
 	int ret;
 
 	if (dev->archdata.iommu)
@@ -304,6 +305,19 @@ static int iommu_init_device(struct device *dev)
 		return -ENOMEM;
 
 	alias = amd_iommu_alias_table[dev_data->devid];
+
+	/*
+	 * If there is no platform provided alias (topology-based) check
+	 * if we have a device quirk based alias.
+	 */
+	func_alias = pdev->dma_func_alias & ~(1 << PCI_SLOT(pdev->devfn));
+	if (func_alias && alias == dev_data->devid) {
+		WARN_ON(hweight8(func_alias) > 1);
+		alias = PCI_DEVID(pdev->bus->number,
+				  PCI_DEVFN(PCI_SLOT(pdev->devfn),
+					    ffs(func_alias) - 1));
+	}
+
 	if (alias != dev_data->devid) {
 		struct iommu_dev_data *alias_data;
 
@@ -351,12 +365,19 @@ static void iommu_ignore_device(struct device *dev)
 
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
 

