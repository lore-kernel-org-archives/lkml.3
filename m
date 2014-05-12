Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbaELKQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 06:16:18 -0400
Received: from smtp.citrix.com ([66.165.176.89]:34324 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756078AbaELKQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 06:16:14 -0400
X-IronPort-AV: E=Sophos;i="4.97,1034,1389744000"; 
   d="scan'208";a="130110808"
From: David Vrabel <david.vrabel@citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <xen-devel@lists.xenproject.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        <linux-ia64@vger.kernel.org>
Subject: [PATCH 1/2] dma: add dma_get_required_mask_from_max_pfn()
Date: Mon, 12 May 2014 11:15:41 +0100
Message-ID: <1399889742-26165-2-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399889742-26165-1-git-send-email-david.vrabel@citrix.com>
References: <1399889742-26165-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ia64 provides a duplicate of the generic dma_get_required_mask()
because it has ARCH_HAS_GET_REQUIRED_MASK.  Provide a common
dma_get_require_mask_max_pfn() instead.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-ia64@vger.kernel.org
---
 arch/ia64/include/asm/machvec.h      |    2 +-
 arch/ia64/include/asm/machvec_init.h |    1 -
 arch/ia64/pci/pci.c                  |   20 --------------------
 drivers/base/platform.c              |   10 ++++++++--
 include/linux/dma-mapping.h          |    1 +
 5 files changed, 10 insertions(+), 24 deletions(-)

diff --git a/arch/ia64/include/asm/machvec.h b/arch/ia64/include/asm/machvec.h
index 9c39bdf..beaa47d 100644
--- a/arch/ia64/include/asm/machvec.h
+++ b/arch/ia64/include/asm/machvec.h
@@ -287,7 +287,7 @@ extern struct dma_map_ops *dma_get_ops(struct device *);
 # define platform_dma_get_ops		dma_get_ops
 #endif
 #ifndef platform_dma_get_required_mask
-# define  platform_dma_get_required_mask	ia64_dma_get_required_mask
+# define  platform_dma_get_required_mask	dma_get_required_mask_from_max_pfn
 #endif
 #ifndef platform_irq_to_vector
 # define platform_irq_to_vector		__ia64_irq_to_vector
diff --git a/arch/ia64/include/asm/machvec_init.h b/arch/ia64/include/asm/machvec_init.h
index 37a4698..ef964b2 100644
--- a/arch/ia64/include/asm/machvec_init.h
+++ b/arch/ia64/include/asm/machvec_init.h
@@ -3,7 +3,6 @@
 
 extern ia64_mv_send_ipi_t ia64_send_ipi;
 extern ia64_mv_global_tlb_purge_t ia64_global_tlb_purge;
-extern ia64_mv_dma_get_required_mask ia64_dma_get_required_mask;
 extern ia64_mv_irq_to_vector __ia64_irq_to_vector;
 extern ia64_mv_local_vector_to_irq __ia64_local_vector_to_irq;
 extern ia64_mv_pci_get_legacy_mem_t ia64_pci_get_legacy_mem;
diff --git a/arch/ia64/pci/pci.c b/arch/ia64/pci/pci.c
index 291a582..79da21b 100644
--- a/arch/ia64/pci/pci.c
+++ b/arch/ia64/pci/pci.c
@@ -791,26 +791,6 @@ static void __init set_pci_dfl_cacheline_size(void)
 	pci_dfl_cache_line_size = (1 << cci.pcci_line_size) / 4;
 }
 
-u64 ia64_dma_get_required_mask(struct device *dev)
-{
-	u32 low_totalram = ((max_pfn - 1) << PAGE_SHIFT);
-	u32 high_totalram = ((max_pfn - 1) >> (32 - PAGE_SHIFT));
-	u64 mask;
-
-	if (!high_totalram) {
-		/* convert to mask just covering totalram */
-		low_totalram = (1 << (fls(low_totalram) - 1));
-		low_totalram += low_totalram - 1;
-		mask = low_totalram;
-	} else {
-		high_totalram = (1 << (fls(high_totalram) - 1));
-		high_totalram += high_totalram - 1;
-		mask = (((u64)high_totalram) << 32) + 0xffffffff;
-	}
-	return mask;
-}
-EXPORT_SYMBOL_GPL(ia64_dma_get_required_mask);
-
 u64 dma_get_required_mask(struct device *dev)
 {
 	return platform_dma_get_required_mask(dev);
diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 5b47210..a53ef9d 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -942,8 +942,7 @@ int __init platform_bus_init(void)
 	return error;
 }
 
-#ifndef ARCH_HAS_DMA_GET_REQUIRED_MASK
-u64 dma_get_required_mask(struct device *dev)
+u64 dma_get_required_mask_from_max_pfn(struct device *dev)
 {
 	u32 low_totalram = ((max_pfn - 1) << PAGE_SHIFT);
 	u32 high_totalram = ((max_pfn - 1) >> (32 - PAGE_SHIFT));
@@ -961,6 +960,13 @@ u64 dma_get_required_mask(struct device *dev)
 	}
 	return mask;
 }
+EXPORT_SYMBOL_GPL(dma_get_required_mask_from_max_pfn);
+
+#ifndef ARCH_HAS_DMA_GET_REQUIRED_MASK
+u64 dma_get_required_mask(struct device *dev)
+{
+	return dma_get_required_mask_from_max_pfn(dev);
+}
 EXPORT_SYMBOL_GPL(dma_get_required_mask);
 #endif
 
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index fd4aee2..bc6e2b6 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -121,6 +121,7 @@ static inline int dma_coerce_mask_and_coherent(struct device *dev, u64 mask)
 	return dma_set_mask_and_coherent(dev, mask);
 }
 
+extern u64 dma_get_required_mask_from_max_pfn(struct device *dev);
 extern u64 dma_get_required_mask(struct device *dev);
 
 static inline unsigned int dma_get_max_seg_size(struct device *dev)
-- 
1.7.10.4

