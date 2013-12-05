Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120Ab3LEL5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 06:57:22 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:37924 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab3LEL5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 06:57:19 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
CC: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH 3/9] IA64/PCI: Use dev_is_pci() to check whether it is pci device
Date: Thu, 5 Dec 2013 19:56:39 +0800
Message-ID: <1386244599-13468-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use PCI dev_is_pci() instead of directly compare
pci_bus_type to check whether it is pci device.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 arch/ia64/hp/common/sba_iommu.c |    2 +-
 arch/ia64/sn/pci/pci_dma.c      |   24 ++++++++++++------------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
index 4c530a8..8e858b5 100644
--- a/arch/ia64/hp/common/sba_iommu.c
+++ b/arch/ia64/hp/common/sba_iommu.c
@@ -255,7 +255,7 @@ static u64 prefetch_spill_page;
 #endif
 
 #ifdef CONFIG_PCI
-# define GET_IOC(dev)	(((dev)->bus == &pci_bus_type)						\
+# define GET_IOC(dev)	((dev_is_pci(dev))						\
 			 ? ((struct ioc *) PCI_CONTROLLER(to_pci_dev(dev))->iommu) : NULL)
 #else
 # define GET_IOC(dev)	NULL
diff --git a/arch/ia64/sn/pci/pci_dma.c b/arch/ia64/sn/pci/pci_dma.c
index 3290d6e..d0853e8 100644
--- a/arch/ia64/sn/pci/pci_dma.c
+++ b/arch/ia64/sn/pci/pci_dma.c
@@ -34,7 +34,7 @@
  */
 static int sn_dma_supported(struct device *dev, u64 mask)
 {
-	BUG_ON(dev->bus != &pci_bus_type);
+	BUG_ON(!dev_is_pci(dev));
 
 	if (mask < 0x7fffffff)
 		return 0;
@@ -50,7 +50,7 @@ static int sn_dma_supported(struct device *dev, u64 mask)
  */
 int sn_dma_set_mask(struct device *dev, u64 dma_mask)
 {
-	BUG_ON(dev->bus != &pci_bus_type);
+	BUG_ON(!dev_is_pci(dev));
 
 	if (!sn_dma_supported(dev, dma_mask))
 		return 0;
@@ -85,7 +85,7 @@ static void *sn_dma_alloc_coherent(struct device *dev, size_t size,
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct sn_pcibus_provider *provider = SN_PCIDEV_BUSPROVIDER(pdev);
 
-	BUG_ON(dev->bus != &pci_bus_type);
+	BUG_ON(!dev_is_pci(dev));
 
 	/*
 	 * Allocate the memory.
@@ -143,7 +143,7 @@ static void sn_dma_free_coherent(struct device *dev, size_t size, void *cpu_addr
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct sn_pcibus_provider *provider = SN_PCIDEV_BUSPROVIDER(pdev);
 
-	BUG_ON(dev->bus != &pci_bus_type);
+	BUG_ON(!dev_is_pci(dev));
 
 	provider->dma_unmap(pdev, dma_handle, 0);
 	free_pages((unsigned long)cpu_addr, get_order(size));
@@ -187,7 +187,7 @@ static dma_addr_t sn_dma_map_page(struct device *dev, struct page *page,
 
 	dmabarr = dma_get_attr(DMA_ATTR_WRITE_BARRIER, attrs);
 
-	BUG_ON(dev->bus != &pci_bus_type);
+	BUG_ON(!dev_is_pci(dev));
 
 	phys_addr = __pa(cpu_addr);
 	if (dmabarr)
@@ -223,7 +223,7 @@ static void sn_dma_unmap_page(struct device *dev, dma_addr_t dma_addr,
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct sn_pcibus_provider *provider = SN_PCIDEV_BUSPROVIDER(pdev);
 
-	BUG_ON(dev->bus != &pci_bus_type);
+	BUG_ON(!dev_is_pci(dev));
 
 	provider->dma_unmap(pdev, dma_addr, dir);
 }
@@ -247,7 +247,7 @@ static void sn_dma_unmap_sg(struct device *dev, struct scatterlist *sgl,
 	struct sn_pcibus_provider *provider = SN_PCIDEV_BUSPROVIDER(pdev);
 	struct scatterlist *sg;
 
-	BUG_ON(dev->bus != &pci_bus_type);
+	BUG_ON(!dev_is_pci(dev));
 
 	for_each_sg(sgl, sg, nhwentries, i) {
 		provider->dma_unmap(pdev, sg->dma_address, dir);
@@ -284,7 +284,7 @@ static int sn_dma_map_sg(struct device *dev, struct scatterlist *sgl,
 
 	dmabarr = dma_get_attr(DMA_ATTR_WRITE_BARRIER, attrs);
 
-	BUG_ON(dev->bus != &pci_bus_type);
+	BUG_ON(!dev_is_pci(dev));
 
 	/*
 	 * Setup a DMA address for each entry in the scatterlist.
@@ -323,26 +323,26 @@ static int sn_dma_map_sg(struct device *dev, struct scatterlist *sgl,
 static void sn_dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
 				       size_t size, enum dma_data_direction dir)
 {
-	BUG_ON(dev->bus != &pci_bus_type);
+	BUG_ON(!dev_is_pci(dev));
 }
 
 static void sn_dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
 					  size_t size,
 					  enum dma_data_direction dir)
 {
-	BUG_ON(dev->bus != &pci_bus_type);
+	BUG_ON(!dev_is_pci(dev));
 }
 
 static void sn_dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
 				   int nelems, enum dma_data_direction dir)
 {
-	BUG_ON(dev->bus != &pci_bus_type);
+	BUG_ON(!dev_is_pci(dev));
 }
 
 static void sn_dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 				      int nelems, enum dma_data_direction dir)
 {
-	BUG_ON(dev->bus != &pci_bus_type);
+	BUG_ON(!dev_is_pci(dev));
 }
 
 static int sn_dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
-- 
1.7.1


