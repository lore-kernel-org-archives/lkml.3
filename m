Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932917AbbA0MpH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:45:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34968 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758402AbbA0MRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:17:42 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 033/126] xen/arm/arm64: introduce xen_arch_need_swiotlb
Date: Tue, 27 Jan 2015 12:15:38 +0000
Message-Id: <1422361031-19364-34-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

commit a4dba130891271084344c12537731542ec77cb85 upstream.

Introduce an arch specific function to find out whether a particular dma
mapping operation needs to bounce on the swiotlb buffer.

On ARM and ARM64, if the page involved is a foreign page and the device
is not coherent, we need to bounce because at unmap time we cannot
execute any required cache maintenance operations (we don't know how to
find the pfn from the mfn).

No change of behaviour for x86.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Reviewed-by: David Vrabel <david.vrabel@citrix.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Ian Campbell <ian.campbell@citrix.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
[ stefano: The commit needs to be slightly modified because
  is_device_dma_coherent is not available on kernels < 3.19, so I just
  removed the call, thus assuming that the device is not coherent on arm
  (slower but safe) ]
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
[ luis: backported to 3.16: used backport by stefano ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/include/asm/xen/page.h | 4 ++++
 arch/arm/xen/mm.c               | 7 +++++++
 arch/x86/include/asm/xen/page.h | 7 +++++++
 drivers/xen/swiotlb-xen.c       | 5 ++++-
 4 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/xen/page.h b/arch/arm/include/asm/xen/page.h
index ded062f9b358..df89aa3b1f03 100644
--- a/arch/arm/include/asm/xen/page.h
+++ b/arch/arm/include/asm/xen/page.h
@@ -116,4 +116,8 @@ static inline bool set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 #define xen_remap(cookie, size) ioremap_cache((cookie), (size))
 #define xen_unmap(cookie) iounmap((cookie))
 
+bool xen_arch_need_swiotlb(struct device *dev,
+			   unsigned long pfn,
+			   unsigned long mfn);
+
 #endif /* _ASM_ARM_XEN_PAGE_H */
diff --git a/arch/arm/xen/mm.c b/arch/arm/xen/mm.c
index b0e77de99148..f8a576b1d9bb 100644
--- a/arch/arm/xen/mm.c
+++ b/arch/arm/xen/mm.c
@@ -16,6 +16,13 @@
 #include <asm/xen/hypercall.h>
 #include <asm/xen/interface.h>
 
+bool xen_arch_need_swiotlb(struct device *dev,
+			   unsigned long pfn,
+			   unsigned long mfn)
+{
+	return (pfn != mfn);
+}
+
 int xen_create_contiguous_region(phys_addr_t pstart, unsigned int order,
 				 unsigned int address_bits,
 				 dma_addr_t *dma_handle)
diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index c949923a5668..f58ef6c0613b 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -236,4 +236,11 @@ void make_lowmem_page_readwrite(void *vaddr);
 #define xen_remap(cookie, size) ioremap((cookie), (size));
 #define xen_unmap(cookie) iounmap((cookie))
 
+static inline bool xen_arch_need_swiotlb(struct device *dev,
+					 unsigned long pfn,
+					 unsigned long mfn)
+{
+	return false;
+}
+
 #endif /* _ASM_X86_XEN_PAGE_H */
diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 9df5d6ec7eec..de37cc22b9a5 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -397,7 +397,9 @@ dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
 	 * buffering it.
 	 */
 	if (dma_capable(dev, dev_addr, size) &&
-	    !range_straddles_page_boundary(phys, size) && !swiotlb_force) {
+	    !range_straddles_page_boundary(phys, size) &&
+		!xen_arch_need_swiotlb(dev, PFN_DOWN(phys), PFN_DOWN(dev_addr)) &&
+		!swiotlb_force) {
 		/* we are not interested in the dma_addr returned by
 		 * xen_dma_map_page, only in the potential cache flushes executed
 		 * by the function. */
@@ -555,6 +557,7 @@ xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 		dma_addr_t dev_addr = xen_phys_to_bus(paddr);
 
 		if (swiotlb_force ||
+		    xen_arch_need_swiotlb(hwdev, PFN_DOWN(paddr), PFN_DOWN(dev_addr)) ||
 		    !dma_capable(hwdev, dev_addr, sg->length) ||
 		    range_straddles_page_boundary(paddr, sg->length)) {
 			phys_addr_t map = swiotlb_tbl_map_single(hwdev,
-- 
2.1.4

