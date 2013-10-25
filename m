Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab3JYKxv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 06:53:51 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:28424 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab3JYKxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 06:53:09 -0400
X-IronPort-AV: E=Sophos;i="4.93,569,1378857600"; 
   d="scan'208";a="64684018"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v9 06/18] xen/arm,arm64: enable SWIOTLB_XEN
Date: Fri, 25 Oct 2013 11:51:41 +0100
Message-ID: <1382698313-13161-6-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1310251144020.26077@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1310251144020.26077@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xen on arm and arm64 needs SWIOTLB_XEN: when running on Xen we need to
program the hardware with mfns rather than pfns for dma addresses.
Remove SWIOTLB_XEN dependency on X86 and PCI and make XEN select
SWIOTLB_XEN on arm and arm64.

At the moment always rely on swiotlb-xen, but when Xen starts supporting
hardware IOMMUs we'll be able to avoid it conditionally on the presence
of an IOMMU on the platform.

Implement xen_create_contiguous_region on arm and arm64: for the moment
we assume that dom0 has been mapped 1:1 (physical addresses == machine
addresses) therefore we don't need to call XENMEM_exchange. Simply
return the physical address as dma address.

Initialize the xen-swiotlb from xen_early_init (before the native
dma_ops are initialized), set xen_dma_ops to &xen_swiotlb_dma_ops.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


Changes in v8:
- assume dom0 is mapped 1:1, no need to call XENMEM_exchange.

Changes in v7:
- call __set_phys_to_machine_multi from xen_create_contiguous_region and
xen_destroy_contiguous_region to update the P2M;
- don't call XENMEM_unpin, it has been removed;
- call XENMEM_exchange instead of XENMEM_exchange_and_pin;
- set nr_exchanged to 0 before calling the hypercall.

Changes in v6:
- introduce and export xen_dma_ops;
- call xen_mm_init from as arch_initcall.

Changes in v4:
- remove redefinition of DMA_ERROR_CODE;
- update the code to use XENMEM_exchange_and_pin and XENMEM_unpin;
- add a note about hardware IOMMU in the commit message.

Changes in v3:
- code style changes;
- warn on XENMEM_put_dma_buf failures.
---
 arch/arm/Kconfig                      |    1 +
 arch/arm/include/asm/xen/hypervisor.h |    2 +
 arch/arm/include/asm/xen/page.h       |    1 +
 arch/arm/xen/Makefile                 |    2 +-
 arch/arm/xen/mm.c                     |   64 +++++++++++++++++++++++++++++++++
 arch/arm64/Kconfig                    |    1 +
 arch/arm64/xen/Makefile               |    2 +-
 drivers/xen/Kconfig                   |    1 -
 drivers/xen/swiotlb-xen.c             |   15 ++++++++
 9 files changed, 86 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm/xen/mm.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index b08374f..01f7013 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1888,6 +1888,7 @@ config XEN
 	depends on CPU_V7 && !CPU_V6
 	depends on !GENERIC_ATOMIC64
 	select ARM_PSCI
+	select SWIOTLB_XEN
 	help
 	  Say Y if you want to run Linux in a Virtual Machine on Xen on ARM.
 
diff --git a/arch/arm/include/asm/xen/hypervisor.h b/arch/arm/include/asm/xen/hypervisor.h
index d7ab99a..1317ee4 100644
--- a/arch/arm/include/asm/xen/hypervisor.h
+++ b/arch/arm/include/asm/xen/hypervisor.h
@@ -16,4 +16,6 @@ static inline enum paravirt_lazy_mode paravirt_get_lazy_mode(void)
 	return PARAVIRT_LAZY_NONE;
 }
 
+extern struct dma_map_ops *xen_dma_ops;
+
 #endif /* _ASM_ARM_XEN_HYPERVISOR_H */
diff --git a/arch/arm/include/asm/xen/page.h b/arch/arm/include/asm/xen/page.h
index d1b5dd5..5d0e4c5 100644
--- a/arch/arm/include/asm/xen/page.h
+++ b/arch/arm/include/asm/xen/page.h
@@ -6,6 +6,7 @@
 
 #include <linux/pfn.h>
 #include <linux/types.h>
+#include <linux/dma-mapping.h>
 
 #include <xen/xen.h>
 #include <xen/interface/grant_table.h>
diff --git a/arch/arm/xen/Makefile b/arch/arm/xen/Makefile
index 21e6ff5..1296952 100644
--- a/arch/arm/xen/Makefile
+++ b/arch/arm/xen/Makefile
@@ -1 +1 @@
-obj-y		:= enlighten.o hypercall.o grant-table.o p2m.o
+obj-y		:= enlighten.o hypercall.o grant-table.o p2m.o mm.o
diff --git a/arch/arm/xen/mm.c b/arch/arm/xen/mm.c
new file mode 100644
index 0000000..d56b8c6
--- /dev/null
+++ b/arch/arm/xen/mm.c
@@ -0,0 +1,64 @@
+#include <linux/bootmem.h>
+#include <linux/gfp.h>
+#include <linux/export.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/dma-mapping.h>
+#include <linux/vmalloc.h>
+#include <linux/swiotlb.h>
+
+#include <xen/xen.h>
+#include <xen/interface/memory.h>
+#include <xen/swiotlb-xen.h>
+
+#include <asm/cacheflush.h>
+#include <asm/xen/page.h>
+#include <asm/xen/hypercall.h>
+#include <asm/xen/interface.h>
+
+int xen_create_contiguous_region(unsigned long vstart, unsigned int order,
+				 unsigned int address_bits,
+				 dma_addr_t *dma_handle)
+{
+	if (!xen_initial_domain())
+		return -EINVAL;
+
+	/* we assume that dom0 is mapped 1:1 for now */
+	*dma_handle = virt_to_phys(pstart);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xen_create_contiguous_region);
+
+void xen_destroy_contiguous_region(unsigned long vstart, unsigned int order)
+{
+	return;
+}
+EXPORT_SYMBOL_GPL(xen_destroy_contiguous_region);
+
+struct dma_map_ops *xen_dma_ops;
+EXPORT_SYMBOL_GPL(xen_dma_ops);
+
+static struct dma_map_ops xen_swiotlb_dma_ops = {
+	.mapping_error = xen_swiotlb_dma_mapping_error,
+	.alloc = xen_swiotlb_alloc_coherent,
+	.free = xen_swiotlb_free_coherent,
+	.sync_single_for_cpu = xen_swiotlb_sync_single_for_cpu,
+	.sync_single_for_device = xen_swiotlb_sync_single_for_device,
+	.sync_sg_for_cpu = xen_swiotlb_sync_sg_for_cpu,
+	.sync_sg_for_device = xen_swiotlb_sync_sg_for_device,
+	.map_sg = xen_swiotlb_map_sg_attrs,
+	.unmap_sg = xen_swiotlb_unmap_sg_attrs,
+	.map_page = xen_swiotlb_map_page,
+	.unmap_page = xen_swiotlb_unmap_page,
+	.dma_supported = xen_swiotlb_dma_supported,
+};
+
+int __init xen_mm_init(void)
+{
+	if (!xen_initial_domain())
+		return 0;
+	xen_swiotlb_init(1, false);
+	xen_dma_ops = &xen_swiotlb_dma_ops;
+	return 0;
+}
+arch_initcall(xen_mm_init);
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index c044548..04ffafb 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -211,6 +211,7 @@ config XEN_DOM0
 config XEN
 	bool "Xen guest support on ARM64 (EXPERIMENTAL)"
 	depends on ARM64 && OF
+	select SWIOTLB_XEN
 	help
 	  Say Y if you want to run Linux in a Virtual Machine on Xen on ARM64.
 
diff --git a/arch/arm64/xen/Makefile b/arch/arm64/xen/Makefile
index cd866b0..74a8d87 100644
--- a/arch/arm64/xen/Makefile
+++ b/arch/arm64/xen/Makefile
@@ -1,2 +1,2 @@
-xen-arm-y	+= $(addprefix ../../arm/xen/, enlighten.o grant-table.o p2m.o)
+xen-arm-y	+= $(addprefix ../../arm/xen/, enlighten.o grant-table.o p2m.o mm.o)
 obj-y		:= xen-arm.o hypercall.o
diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index 23eae5c..c794ea1 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -140,7 +140,6 @@ config XEN_GRANT_DEV_ALLOC
 
 config SWIOTLB_XEN
 	def_bool y
-	depends on PCI && X86
 	select SWIOTLB
 
 config XEN_TMEM
diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index b72f31c..f0fc1a4 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -42,12 +42,27 @@
 #include <xen/page.h>
 #include <xen/xen-ops.h>
 #include <xen/hvc-console.h>
+#include <asm/dma-mapping.h>
 /*
  * Used to do a quick range check in swiotlb_tbl_unmap_single and
  * swiotlb_tbl_sync_single_*, to see if the memory was in fact allocated by this
  * API.
  */
 
+#ifndef CONFIG_X86
+static unsigned long dma_alloc_coherent_mask(struct device *dev,
+					    gfp_t gfp)
+{
+	unsigned long dma_mask = 0;
+
+	dma_mask = dev->coherent_dma_mask;
+	if (!dma_mask)
+		dma_mask = (gfp & GFP_DMA) ? DMA_BIT_MASK(24) : DMA_BIT_MASK(32);
+
+	return dma_mask;
+}
+#endif
+
 static char *xen_io_tlb_start, *xen_io_tlb_end;
 static unsigned long xen_io_tlb_nslabs;
 /*
-- 
1.7.2.5

