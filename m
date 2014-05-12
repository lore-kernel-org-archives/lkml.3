Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191AbaELKQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 06:16:22 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:13437 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078AbaELKQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 06:16:19 -0400
X-IronPort-AV: E=Sophos;i="4.97,1034,1389744000"; 
   d="scan'208";a="129289081"
From: David Vrabel <david.vrabel@citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <xen-devel@lists.xenproject.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: [PATCH 2/2] x86,xen: correct dma_get_required_mask() for Xen PV guests
Date: Mon, 12 May 2014 11:15:42 +0100
Message-ID: <1399889742-26165-3-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399889742-26165-1-git-send-email-david.vrabel@citrix.com>
References: <1399889742-26165-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On systems where DMA addresses and physical addresses are not 1:1
(such as Xen PV guests), the generic dma_get_required_mask() will not
return the correct mask (since it uses max_pfn).

Some device drivers (such as mptsas, mpt2sas) use
dma_get_required_mask() to set device DMA masks to allow them to use
only 32-bit DMA addresses in hardware structures.  This results in
unnecessary use of the SWIOTLB if DMA addresses are more than 32-bits,
impacting performance significantly.

Provide an arch-specific dma_get_required_mask() that defaults to the
generic dma_get_required_mask_from_pfn().

Under Xen, the required DMA mask can then be set to always 64-bits.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
 arch/x86/include/asm/device.h  |    2 ++
 arch/x86/kernel/pci-dma.c      |    7 +++++++
 arch/x86/xen/pci-swiotlb-xen.c |    1 +
 drivers/xen/swiotlb-xen.c      |    7 +++++++
 include/xen/swiotlb-xen.h      |    4 ++++
 5 files changed, 21 insertions(+)

diff --git a/arch/x86/include/asm/device.h b/arch/x86/include/asm/device.h
index 03dd729..10bc628 100644
--- a/arch/x86/include/asm/device.h
+++ b/arch/x86/include/asm/device.h
@@ -13,4 +13,6 @@ struct dev_archdata {
 struct pdev_archdata {
 };
 
+#define ARCH_HAS_DMA_GET_REQUIRED_MASK
+
 #endif /* _ASM_X86_DEVICE_H */
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index f7d0672..ad2c3e2 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -135,6 +135,13 @@ void dma_generic_free_coherent(struct device *dev, size_t size, void *vaddr,
 		free_pages((unsigned long)vaddr, get_order(size));
 }
 
+u64 dma_get_required_mask(struct device *dev)
+{
+	if (dma_ops->get_required_mask)
+		return dma_ops->get_required_mask(dev);
+	return dma_get_required_mask_from_max_pfn(dev);
+}
+
 /*
  * See <Documentation/x86/x86_64/boot-options.txt> for the iommu kernel
  * parameter documentation.
diff --git a/arch/x86/xen/pci-swiotlb-xen.c b/arch/x86/xen/pci-swiotlb-xen.c
index 0e98e5d..a5d180a 100644
--- a/arch/x86/xen/pci-swiotlb-xen.c
+++ b/arch/x86/xen/pci-swiotlb-xen.c
@@ -31,6 +31,7 @@ static struct dma_map_ops xen_swiotlb_dma_ops = {
 	.map_page = xen_swiotlb_map_page,
 	.unmap_page = xen_swiotlb_unmap_page,
 	.dma_supported = xen_swiotlb_dma_supported,
+	.get_required_mask = xen_swiotlb_get_required_mask,
 };
 
 /*
diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index ebd8f21..798f62b 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -683,3 +683,10 @@ xen_swiotlb_set_dma_mask(struct device *dev, u64 dma_mask)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(xen_swiotlb_set_dma_mask);
+
+u64
+xen_swiotlb_get_required_mask(struct device *dev)
+{
+	return DMA_BIT_MASK(64);
+}
+EXPORT_SYMBOL_GPL(xen_swiotlb_get_required_mask);
diff --git a/include/xen/swiotlb-xen.h b/include/xen/swiotlb-xen.h
index 8b2eb93..6408888 100644
--- a/include/xen/swiotlb-xen.h
+++ b/include/xen/swiotlb-xen.h
@@ -58,4 +58,8 @@ xen_swiotlb_dma_supported(struct device *hwdev, u64 mask);
 
 extern int
 xen_swiotlb_set_dma_mask(struct device *dev, u64 dma_mask);
+
+extern u64
+xen_swiotlb_get_required_mask(struct device *dev);
+
 #endif /* __LINUX_SWIOTLB_XEN_H */
-- 
1.7.10.4

