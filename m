Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbaKLPZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 10:25:46 -0500
Received: from smtp.citrix.com ([66.165.176.89]:26364 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239AbaKLPZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 10:25:43 -0500
X-IronPort-AV: E=Sophos;i="5.07,369,1413244800"; 
   d="scan'208";a="190548031"
From: David Vrabel <david.vrabel@citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        <xen-devel@lists.xenproject.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 3/3] x86/xen: use the maximum MFN to calculate the required DMA mask
Date: Wed, 12 Nov 2014 15:25:06 +0000
Message-ID: <1415805906-27316-4-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415805906-27316-1-git-send-email-david.vrabel@citrix.com>
References: <1415805906-27316-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a Xen PV guest the DMA addresses and physical addresses are not 1:1
(such as Xen PV guests) and the generic dma_get_required_mask() does
not return the correct mask (since it uses max_pfn).

Some device drivers (such as mptsas, mpt2sas) use
dma_get_required_mask() to set the device's DMA mask to allow them to
use only 32-bit DMA addresses in hardware structures.  This results in
unnecessary use of the SWIOTLB if DMA addresses are more than 32-bits,
impacting performance significantly.

Provide a get_required_mask op that uses the maximum MFN to calculate
the DMA mask.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
 arch/x86/xen/pci-swiotlb-xen.c |    1 +
 drivers/xen/swiotlb-xen.c      |   13 +++++++++++++
 include/xen/swiotlb-xen.h      |    4 ++++
 3 files changed, 18 insertions(+)

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
index ebd8f21..472fd52 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -42,9 +42,11 @@
 #include <xen/page.h>
 #include <xen/xen-ops.h>
 #include <xen/hvc-console.h>
+#include <xen/interface/memory.h>
 
 #include <asm/dma-mapping.h>
 #include <asm/xen/page-coherent.h>
+#include <asm/xen/hypercall.h>
 
 #include <trace/events/swiotlb.h>
 /*
@@ -683,3 +685,14 @@ xen_swiotlb_set_dma_mask(struct device *dev, u64 dma_mask)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(xen_swiotlb_set_dma_mask);
+
+u64
+xen_swiotlb_get_required_mask(struct device *dev)
+{
+	u64 max_mfn;
+
+	max_mfn = HYPERVISOR_memory_op(XENMEM_maximum_ram_page, NULL);
+
+	return DMA_BIT_MASK(fls64(max_mfn << PAGE_SHIFT) + 1);
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

