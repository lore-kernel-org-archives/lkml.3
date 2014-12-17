Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365AbaLQSCz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 13:02:55 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50174 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaLQSCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 13:02:53 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
To: <gregkh@linuxfoundation.org>, <vinod.koul@intel.com>,
        <dmaengine@vger.kernel.org>, <bhelgaas@google.com>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
CC: Murali Karicheri <m-karicheri2@ti.com>
Subject: [RFC PATCH 1/2] common: dma-mapping: introduce dma_get_parent_cfg() helper
Date: Wed, 17 Dec 2014 13:02:23 -0500
Message-ID: <1418839344-14393-2-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418839344-14393-1-git-send-email-m-karicheri2@ti.com>
References: <1418839344-14393-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, in Kernel, parent device's DMA parameters has to be applied to
the child as is - to enable DMA support for the device. Usually this
is happened in places where parent device manually instantiates child
device such as in drivers/pci/probe.c (pci_device_add() for example).

Now DMA configuration is represented in device data structure not only
by DMA mask and DMA params, it also includes dma_pfn_offset at least.
Hence introduce common dma_get_parent_cfg() helper to apply dma
configuration from parent to child, and use __weak to allow arch to
override it if needed.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 drivers/base/dma-mapping.c  |   18 ++++++++++++++++++
 include/linux/dma-mapping.h |    3 +++
 2 files changed, 21 insertions(+)

diff --git a/drivers/base/dma-mapping.c b/drivers/base/dma-mapping.c
index 9e8bbdd..5322426 100644
--- a/drivers/base/dma-mapping.c
+++ b/drivers/base/dma-mapping.c
@@ -339,3 +339,21 @@ void dma_common_free_remap(void *cpu_addr, size_t size, unsigned long vm_flags)
 	vunmap(cpu_addr);
 }
 #endif
+
+int __weak dma_get_parent_cfg(struct device *dev, struct device *parent)
+{
+	struct device *temp = parent;
+
+	if (!temp)
+		temp = dev->parent;
+
+	if (temp && is_device_dma_capable(temp)) {
+		dev->dma_mask	= temp->dma_mask;
+		dev->coherent_dma_mask = temp->coherent_dma_mask;
+		dev->dma_parms	= temp->dma_parms;
+		dev->dma_pfn_offset = temp->dma_pfn_offset;
+		return 0;
+	}
+	return -EINVAL;
+}
+EXPORT_SYMBOL(dma_get_parent_cfg);
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index d5d3881..eb080d6 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -127,6 +127,9 @@ static inline int dma_coerce_mask_and_coherent(struct device *dev, u64 mask)
 	return dma_set_mask_and_coherent(dev, mask);
 }
 
+extern int __weak dma_get_parent_cfg(struct device *dev,
+					struct device *parent);
+
 extern u64 dma_get_required_mask(struct device *dev);
 
 #ifndef set_arch_dma_coherent_ops
-- 
1.7.9.5

