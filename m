Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154Ab3LEL63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 06:58:29 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:18029 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656Ab3LEL60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 06:58:26 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>
CC: <linux-pci@vger.kernel.org>, <sparclinux@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Yijing Wang <wangyijing@huawei.com>,
        "Hanjun Guo" <guohanjun@huawei.com>
Subject: [PATCH 4/9] sparc/pci: Use dev_is_pci() to check whether it is pci device
Date: Thu, 5 Dec 2013 19:57:58 +0800
Message-ID: <1386244678-19028-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use PCI standard marco dev_is_pci() instead of directly compare
pci_bus_type to check whether it is pci device.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 arch/sparc/include/asm/dma-mapping.h |   10 ++++------
 arch/sparc/kernel/iommu.c            |    2 +-
 arch/sparc/kernel/ioport.c           |    4 +---
 3 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/sparc/include/asm/dma-mapping.h b/arch/sparc/include/asm/dma-mapping.h
index 05fe53f..751c299 100644
--- a/arch/sparc/include/asm/dma-mapping.h
+++ b/arch/sparc/include/asm/dma-mapping.h
@@ -4,6 +4,7 @@
 #include <linux/scatterlist.h>
 #include <linux/mm.h>
 #include <linux/dma-debug.h>
+#include <linux/pci.h>
 
 #define DMA_ERROR_CODE	(~(dma_addr_t)0x0)
 
@@ -16,14 +17,13 @@ extern struct dma_map_ops *dma_ops;
 extern struct dma_map_ops *leon_dma_ops;
 extern struct dma_map_ops pci32_dma_ops;
 
-extern struct bus_type pci_bus_type;
 
 static inline struct dma_map_ops *get_dma_ops(struct device *dev)
 {
-#if defined(CONFIG_SPARC32) && defined(CONFIG_PCI)
+#if defined(CONFIG_SPARC32)
 	if (sparc_cpu_model == sparc_leon)
 		return leon_dma_ops;
-	else if (dev->bus == &pci_bus_type)
+	else if (dev_is_pci(dev))
 		return &pci32_dma_ops;
 #endif
 	return dma_ops;
@@ -65,14 +65,12 @@ static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 
 static inline int dma_set_mask(struct device *dev, u64 mask)
 {
-#ifdef CONFIG_PCI
-	if (dev->bus == &pci_bus_type) {
+	if (dev_is_pci(dev)) {
 		if (!dev->dma_mask || !dma_supported(dev, mask))
 			return -EINVAL;
 		*dev->dma_mask = mask;
 		return 0;
 	}
-#endif
 	return -EINVAL;
 }
 
diff --git a/arch/sparc/kernel/iommu.c b/arch/sparc/kernel/iommu.c
index 070ed14..76663b0 100644
--- a/arch/sparc/kernel/iommu.c
+++ b/arch/sparc/kernel/iommu.c
@@ -854,7 +854,7 @@ int dma_supported(struct device *dev, u64 device_mask)
 		return 1;
 
 #ifdef CONFIG_PCI
-	if (dev->bus == &pci_bus_type)
+	if (dev_is_pci(dev))
 		return pci64_dma_supported(to_pci_dev(dev), device_mask);
 #endif
 
diff --git a/arch/sparc/kernel/ioport.c b/arch/sparc/kernel/ioport.c
index 2096468..0ead3cd 100644
--- a/arch/sparc/kernel/ioport.c
+++ b/arch/sparc/kernel/ioport.c
@@ -666,10 +666,8 @@ EXPORT_SYMBOL(dma_ops);
  */
 int dma_supported(struct device *dev, u64 mask)
 {
-#ifdef CONFIG_PCI
-	if (dev->bus == &pci_bus_type)
+	if (dev_is_pci(dev))
 		return 1;
-#endif
 	return 0;
 }
 EXPORT_SYMBOL(dma_supported);
-- 
1.7.1


