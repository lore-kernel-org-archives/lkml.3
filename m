Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab3IIQv3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:51:29 -0400
Received: from smtp.citrix.com ([66.165.176.89]:14682 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873Ab3IIQv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:51:27 -0400
X-IronPort-AV: E=Sophos;i="4.90,872,1371081600"; 
   d="scan'208";a="52062611"
Date: Mon, 9 Sep 2013 17:46:59 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [PATCH v5 11/13] xen: introduce xen_alloc/free_coherent_pages
In-Reply-To: <8492887B-2509-42B5-A5F9-A711C519D912@arm.com>
Message-ID: <alpine.DEB.2.02.1309091732230.6397@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1308291917290.6397@kaball.uk.xensource.com> <1377801154-29215-11-git-send-email-stefano.stabellini@eu.citrix.com> <20130905160905.GI11887@arm.com> <alpine.DEB.2.02.1309051742390.6397@kaball.uk.xensource.com> <20130906141444.GE1946@arm.com>
 <alpine.DEB.2.02.1309061554260.6397@kaball.uk.xensource.com> <20130906155928.GH1946@arm.com> <alpine.DEB.2.02.1309061706480.6397@kaball.uk.xensource.com> <20130906162018.GJ1946@arm.com> <alpine.DEB.2.02.1309061740050.6397@kaball.uk.xensource.com>
 <8492887B-2509-42B5-A5F9-A711C519D912@arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Sep 2013, Catalin Marinas wrote:
> >>> They could also happen in a DomU if we assign a physical device to it
> >>> (and an SMMU is not available).
> >> 
> >> The problem is that you don't necessarily know one kind of coherency you
> >> know for a physical device. As I said, we plan to do this DT-driven.
> > 
> > OK, but if I call arm64_swiotlb_dma_ops.alloc passing the right
> > arguments to it, I should be able to get the right coherency for the
> > right device, correct?
> 
> I think it needs a bit more work on the Xen part.  Basically
> dma_alloc_attrs() calls get_dma_ops() to obtain the best DMA operations
> for a device.  arm64_swiotlb_dma_ops is just the default implementation
> and I'll add a _noncoherent variant as well.  Default dma_ops will be
> set to one of these during boot.  But a device is also allowed to have
> its own dev->archdata.dma_ops, set via set_dma_ops().
> 
> So even if you set the default dma_ops to Xen ops, you may not get them
> via dma_alloc_coherent().  I don't see any easier solution other than
> patching the dma_alloc_attrs() function to issue a Hyp call after the
> memory has been allocated with the get_dma_ops()->alloc().  But I don't
> like this either.

I see. This problem affects arch/arm as well.
Either we add an if (!xen_domain()) in get_dma_ops, or we could make
get_dma_ops a function pointer and let people overwrite it.
See below the first option implemented for arch/arm on top of the
swiotlb series:


diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
index 7d6e4f9..0b8b5e4 100644
--- a/arch/arm/include/asm/dma-mapping.h
+++ b/arch/arm/include/asm/dma-mapping.h
@@ -12,6 +12,8 @@
 #include <asm/memory.h>
 #include <asm/cacheflush.h>
 
+#include <xen/xen.h>
+
 #define DMA_ERROR_CODE	(~0)
 extern struct dma_map_ops *dma_ops;
 extern struct dma_map_ops arm_dma_ops;
@@ -19,7 +21,7 @@ extern struct dma_map_ops arm_coherent_dma_ops;
 
 static inline struct dma_map_ops *get_dma_ops(struct device *dev)
 {
-	if (dev && dev->archdata.dma_ops)
+	if (!xen_domain() && dev && dev->archdata.dma_ops)
 		return dev->archdata.dma_ops;
 	return dma_ops;
 }
diff --git a/arch/arm/include/asm/xen/page-coherent.h b/arch/arm/include/asm/xen/page-coherent.h
index af2cf8d..c2232fe 100644
--- a/arch/arm/include/asm/xen/page-coherent.h
+++ b/arch/arm/include/asm/xen/page-coherent.h
@@ -9,6 +9,8 @@ static inline void *xen_alloc_coherent_pages(struct device *hwdev, size_t size,
 		dma_addr_t *dma_handle, gfp_t flags,
 		struct dma_attrs *attrs)
 {
+	if (hwdev && hwdev->archdata.dma_ops)
+		return hwdev->archdata.dma_ops->alloc(hwdev, size, dma_handle, flags, attrs);
 	return arm_dma_ops.alloc(hwdev, size, dma_handle, flags, attrs);
 }
 
@@ -16,6 +18,8 @@ static inline void xen_free_coherent_pages(struct device *hwdev, size_t size,
 		void *cpu_addr, dma_addr_t dma_handle,
 		struct dma_attrs *attrs)
 {
+	if (hwdev && hwdev->archdata.dma_ops)
+		return hwdev->archdata.dma_ops->free(hwdev, size, cpu_addr, dma_handle, attrs);
 	return arm_dma_ops.free(hwdev, size, cpu_addr, dma_handle, attrs);
 }
 
