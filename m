Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab3I0QLD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 12:11:03 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:50926 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab3I0QKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 12:10:55 -0400
X-IronPort-AV: E=Sophos;i="4.90,994,1371081600"; 
   d="scan'208";a="55582484"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v6 06/19] xen/arm,arm64: enable SWIOTLB_XEN
Date: Fri, 27 Sep 2013 17:09:54 +0100
Message-ID: <1380298207-29151-6-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1309271653420.5498@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1309271653420.5498@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
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

Implement xen_create_contiguous_region on arm and arm64 by using
XENMEM_exchange_and_pin.

Initialize the xen-swiotlb from xen_early_init (before the native
dma_ops are initialized), set xen_dma_ops to &xen_swiotlb_dma_ops.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


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
 arch/arm/include/asm/xen/page.h       |    2 +
 arch/arm/xen/Makefile                 |    2 +-
 arch/arm/xen/mm.c                     |  121 +++++++++++++++++++++++++++++++++
 arch/arm64/Kconfig                    |    1 +
 arch/arm64/xen/Makefile               |    2 +-
 drivers/xen/Kconfig                   |    1 -
 drivers/xen/swiotlb-xen.c             |   16 +++++
 9 files changed, 145 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm/xen/mm.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index c0bfb33..2c9d112 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1848,6 +1848,7 @@ config XEN
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
index 359a7b5..b0f7150 100644
--- a/arch/arm/include/asm/xen/page.h
+++ b/arch/arm/include/asm/xen/page.h
@@ -6,12 +6,14 @@
 
 #include <linux/pfn.h>
 #include <linux/types.h>
+#include <linux/dma-mapping.h>
 
 #include <xen/interface/grant_table.h>
 
 #define pfn_to_mfn(pfn)			(pfn)
 #define phys_to_machine_mapping_valid(pfn) (1)
 #define mfn_to_pfn(mfn)			(mfn)
+#define mfn_to_local_pfn(m)             (mfn_to_pfn(m))
 #define mfn_to_virt(m)			(__va(mfn_to_pfn(m) << PAGE_SHIFT))
 
 #define pte_mfn	    pte_pfn
diff --git a/arch/arm/xen/Makefile b/arch/arm/xen/Makefile
index 4384103..66fc35d 100644
--- a/arch/arm/xen/Makefile
+++ b/arch/arm/xen/Makefile
@@ -1 +1 @@
-obj-y		:= enlighten.o hypercall.o grant-table.o
+obj-y		:= enlighten.o hypercall.o grant-table.o mm.o
diff --git a/arch/arm/xen/mm.c b/arch/arm/xen/mm.c
new file mode 100644
index 0000000..b065c98
--- /dev/null
+++ b/arch/arm/xen/mm.c
@@ -0,0 +1,121 @@
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
+static int xen_exchange_memory(xen_ulong_t extents_in,
+			       unsigned int order_in,
+			       xen_pfn_t *pfns_in,
+			       xen_ulong_t extents_out,
+			       unsigned int order_out,
+			       xen_pfn_t *mfns_out,
+			       unsigned int address_bits)
+{
+	long rc;
+	int success;
+
+	struct xen_memory_exchange exchange = {
+		.in = {
+			.nr_extents   = extents_in,
+			.extent_order = order_in,
+			.domid        = DOMID_SELF
+		},
+		.out = {
+			.nr_extents   = extents_out,
+			.extent_order = order_out,
+			.address_bits = address_bits,
+			.domid        = DOMID_SELF
+		}
+	};
+	set_xen_guest_handle(exchange.in.extent_start, pfns_in);
+	set_xen_guest_handle(exchange.out.extent_start, mfns_out);
+
+	BUG_ON(extents_in << order_in != extents_out << order_out);
+
+
+	rc = HYPERVISOR_memory_op(XENMEM_exchange_and_pin, &exchange);
+	success = (exchange.nr_exchanged == extents_in);
+
+	BUG_ON(!success && ((exchange.nr_exchanged != 0) || (rc == 0)));
+	BUG_ON(success && (rc != 0));
+
+	return success;
+}
+
+int xen_create_contiguous_region(unsigned long vstart, unsigned int order,
+				 unsigned int address_bits,
+				 dma_addr_t *dma_handle)
+{
+	phys_addr_t pstart = __pa(vstart);
+	xen_pfn_t in_frame, out_frame;
+	int success;
+
+	/* Get a new contiguous memory extent. */
+	in_frame = out_frame = pstart >> PAGE_SHIFT;
+	success = xen_exchange_memory(1, order, &in_frame,
+				      1, order, &out_frame,
+				      address_bits);
+
+	if (!success)
+		return -ENOMEM;
+
+	*dma_handle = out_frame << PAGE_SHIFT;
+
+	return success ? 0 : -ENOMEM;
+}
+EXPORT_SYMBOL_GPL(xen_create_contiguous_region);
+
+void xen_destroy_contiguous_region(unsigned long vstart, unsigned int order)
+{
+	xen_pfn_t in_frame = __pa(vstart) >> PAGE_SHIFT;
+	struct xen_unpin unpin = {
+		.in = {
+			.nr_extents   = 1,
+			.extent_order = order,
+			.domid        = DOMID_SELF
+		},
+	};
+	set_xen_guest_handle(unpin.in.extent_start, &in_frame);
+
+	WARN_ON(HYPERVISOR_memory_op(XENMEM_unpin, &unpin));
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
+	xen_swiotlb_init(1, false);
+	xen_dma_ops = &xen_swiotlb_dma_ops;
+	return 0;
+}
+arch_initcall(xen_mm_init);
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 9737e97..aa1f6fb 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -209,6 +209,7 @@ config XEN_DOM0
 config XEN
 	bool "Xen guest support on ARM64 (EXPERIMENTAL)"
 	depends on ARM64 && OF
+	select SWIOTLB_XEN
 	help
 	  Say Y if you want to run Linux in a Virtual Machine on Xen on ARM64.
 
diff --git a/arch/arm64/xen/Makefile b/arch/arm64/xen/Makefile
index be24040..0ef9637 100644
--- a/arch/arm64/xen/Makefile
+++ b/arch/arm64/xen/Makefile
@@ -1,2 +1,2 @@
-xen-arm-y	+= $(addprefix ../../arm/xen/, enlighten.o grant-table.o)
+xen-arm-y	+= $(addprefix ../../arm/xen/, enlighten.o grant-table.o mm.o)
 obj-y		:= xen-arm.o hypercall.o
diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index 9e02d60..7e83688 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -140,7 +140,6 @@ config XEN_GRANT_DEV_ALLOC
 
 config SWIOTLB_XEN
 	def_bool y
-	depends on PCI && X86
 	select SWIOTLB
 
 config XEN_TMEM
diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 84aef43..a1cb0f4 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -45,6 +45,8 @@
 #include <xen/xen-ops.h>
 #include <xen/hvc-console.h>
 #include <xen/features.h>
+#include <asm/dma-mapping.h>
+
 /*
  * Used to do a quick range check in swiotlb_tbl_unmap_single and
  * swiotlb_tbl_sync_single_*, to see if the memory was in fact allocated by this
@@ -58,6 +60,20 @@ static unsigned long xen_io_tlb_nslabs;
  * Quick lookup value of the bus address of the IOTLB.
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
 struct xen_dma_info {
 	dma_addr_t dma_addr;
 	phys_addr_t phys_addr;
-- 
1.7.2.5

