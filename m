Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964774AbbA1UoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:44:20 -0500
Received: from smtp.citrix.com ([66.165.176.89]:5572 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761533AbbA1UoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:44:13 -0500
X-IronPort-AV: E=Sophos;i="5.09,480,1418083200"; 
   d="scan'208";a="221206463"
Date: Wed, 28 Jan 2015 12:01:19 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Greg KH <greg@kroah.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        <xen-devel@lists.xensource.com>, <catalin.marinas@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: Re: backport a4dba130891271084344c12537731542ec77cb85 to 3.16+
In-Reply-To: <20150128001038.GB17677@kroah.com>
Message-ID: <alpine.DEB.2.02.1501281159560.9702@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1501121704380.3058@kaball.uk.xensource.com> <20150128001038.GB17677@kroah.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2015, Greg KH wrote:
> On Mon, Jan 12, 2015 at 06:09:33PM +0000, Stefano Stabellini wrote:
> > Hi all,
> > I would like to request a backport of the following commit:
> > 
> > 
> > commit a4dba130891271084344c12537731542ec77cb85
> > Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > Date:   Fri Nov 21 11:07:39 2014 +0000
> > 
> >     xen/arm/arm64: introduce xen_arch_need_swiotlb
> > 
> > 
> > to stable trees from 3.16 onward (3.16 included).
> > 
> > 
> > The commit needs to be slightly modified because is_device_dma_coherent
> > is not available on kernels < 3.19, so I just removed the call,
> > thus assuming that the device is not coherent on arm (slower but safe):
> 
> A diff of a diff is hard to apply, please send the reworked patch in a
> format that I can apply it in.
 
The full patch was just below, in the original email.
Also appended here, for convenience.


---

xen/arm/arm64: introduce xen_arch_need_swiotlb

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

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

diff --git a/arch/arm/include/asm/xen/page.h b/arch/arm/include/asm/xen/page.h
index 135c24a..68c739b 100644
--- a/arch/arm/include/asm/xen/page.h
+++ b/arch/arm/include/asm/xen/page.h
@@ -107,4 +107,8 @@ static inline bool set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 #define xen_remap(cookie, size) ioremap_cache((cookie), (size))
 #define xen_unmap(cookie) iounmap((cookie))
 
+bool xen_arch_need_swiotlb(struct device *dev,
+			   unsigned long pfn,
+			   unsigned long mfn);
+
 #endif /* _ASM_ARM_XEN_PAGE_H */
diff --git a/arch/arm/xen/mm.c b/arch/arm/xen/mm.c
index b0e77de..f8a576b 100644
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
index c949923..f58ef6c 100644
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
index ebd8f21..ac5d41b 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -399,7 +399,9 @@ dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
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
@@ -557,6 +559,7 @@ xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 		dma_addr_t dev_addr = xen_phys_to_bus(paddr);
 
 		if (swiotlb_force ||
+		    xen_arch_need_swiotlb(hwdev, PFN_DOWN(paddr), PFN_DOWN(dev_addr)) ||
 		    !dma_capable(hwdev, dev_addr, sg->length) ||
 		    range_straddles_page_boundary(paddr, sg->length)) {
 			phys_addr_t map = swiotlb_tbl_map_single(hwdev,
