Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab3IKJh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 05:37:26 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38921 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751028Ab3IKJhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 05:37:25 -0400
Date: Wed, 11 Sep 2013 10:36:46 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [PATCH v5 11/13] xen: introduce xen_alloc/free_coherent_pages
Message-ID: <20130911093646.GA26777@darko.cambridge.arm.com>
References: <20130905160905.GI11887@arm.com>
 <alpine.DEB.2.02.1309051742390.6397@kaball.uk.xensource.com>
 <20130906141444.GE1946@arm.com>
 <alpine.DEB.2.02.1309061554260.6397@kaball.uk.xensource.com>
 <20130906155928.GH1946@arm.com>
 <alpine.DEB.2.02.1309061706480.6397@kaball.uk.xensource.com>
 <20130906162018.GJ1946@arm.com>
 <alpine.DEB.2.02.1309061740050.6397@kaball.uk.xensource.com>
 <8492887B-2509-42B5-A5F9-A711C519D912@arm.com>
 <alpine.DEB.2.02.1309091732230.6397@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1309091732230.6397@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 05:46:59PM +0100, Stefano Stabellini wrote:
> On Mon, 9 Sep 2013, Catalin Marinas wrote:
> > >>> They could also happen in a DomU if we assign a physical device to it
> > >>> (and an SMMU is not available).
> > >> 
> > >> The problem is that you don't necessarily know one kind of coherency you
> > >> know for a physical device. As I said, we plan to do this DT-driven.
> > > 
> > > OK, but if I call arm64_swiotlb_dma_ops.alloc passing the right
> > > arguments to it, I should be able to get the right coherency for the
> > > right device, correct?
> > 
> > I think it needs a bit more work on the Xen part.  Basically
> > dma_alloc_attrs() calls get_dma_ops() to obtain the best DMA operations
> > for a device.  arm64_swiotlb_dma_ops is just the default implementation
> > and I'll add a _noncoherent variant as well.  Default dma_ops will be
> > set to one of these during boot.  But a device is also allowed to have
> > its own dev->archdata.dma_ops, set via set_dma_ops().
> > 
> > So even if you set the default dma_ops to Xen ops, you may not get them
> > via dma_alloc_coherent().  I don't see any easier solution other than
> > patching the dma_alloc_attrs() function to issue a Hyp call after the
> > memory has been allocated with the get_dma_ops()->alloc().  But I don't
> > like this either.
> 
> I see. This problem affects arch/arm as well.
> Either we add an if (!xen_domain()) in get_dma_ops, or we could make
> get_dma_ops a function pointer and let people overwrite it.
> See below the first option implemented for arch/arm on top of the
> swiotlb series:
> 
> 
> diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
> index 7d6e4f9..0b8b5e4 100644
> --- a/arch/arm/include/asm/dma-mapping.h
> +++ b/arch/arm/include/asm/dma-mapping.h
> @@ -12,6 +12,8 @@
>  #include <asm/memory.h>
>  #include <asm/cacheflush.h>
>  
> +#include <xen/xen.h>
> +
>  #define DMA_ERROR_CODE	(~0)
>  extern struct dma_map_ops *dma_ops;
>  extern struct dma_map_ops arm_dma_ops;
> @@ -19,7 +21,7 @@ extern struct dma_map_ops arm_coherent_dma_ops;
>  
>  static inline struct dma_map_ops *get_dma_ops(struct device *dev)
>  {
> -	if (dev && dev->archdata.dma_ops)
> +	if (!xen_domain() && dev && dev->archdata.dma_ops)
>  		return dev->archdata.dma_ops;
>  	return dma_ops;
>  }
> diff --git a/arch/arm/include/asm/xen/page-coherent.h b/arch/arm/include/asm/xen/page-coherent.h
> index af2cf8d..c2232fe 100644
> --- a/arch/arm/include/asm/xen/page-coherent.h
> +++ b/arch/arm/include/asm/xen/page-coherent.h
> @@ -9,6 +9,8 @@ static inline void *xen_alloc_coherent_pages(struct device *hwdev, size_t size,
>  		dma_addr_t *dma_handle, gfp_t flags,
>  		struct dma_attrs *attrs)
>  {
> +	if (hwdev && hwdev->archdata.dma_ops)
> +		return hwdev->archdata.dma_ops->alloc(hwdev, size, dma_handle, flags, attrs);
>  	return arm_dma_ops.alloc(hwdev, size, dma_handle, flags, attrs);

I still don't like xen digging into the archdata internals. What about:

diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
index 5b579b9..5fa472c 100644
--- a/arch/arm/include/asm/dma-mapping.h
+++ b/arch/arm/include/asm/dma-mapping.h
@@ -15,13 +15,20 @@
 extern struct dma_map_ops arm_dma_ops;
 extern struct dma_map_ops arm_coherent_dma_ops;
 
-static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline struct dma_map_ops *__get_dma_ops(struct device *dev)
 {
 	if (dev && dev->archdata.dma_ops)
 		return dev->archdata.dma_ops;
 	return &arm_dma_ops;
 }
 
+static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+{
+	if (xen_domain())
+		return xen_dma_ops;
+	return __get_dma_ops(dev);
+}
+
 static inline void set_dma_ops(struct device *dev, struct dma_map_ops *ops)
 {
 	BUG_ON(!dev);
@@ -32,7 +39,7 @@ static inline void set_dma_ops(struct device *dev, struct dma_map_ops *ops)
 
 static inline int dma_set_mask(struct device *dev, u64 mask)
 {
-	return get_dma_ops(dev)->set_dma_mask(dev, mask);
+	return __get_dma_ops(dev)->set_dma_mask(dev, mask);
 }
 
 #ifdef __arch_page_to_dma

And in xen_alloc_coherent_pages():

	return __get_dma_ops(dev).alloc(...);

Alternatively, add the xen_domain() check in dma_alloc_attrs() instead
of get_dma_ops() (and other functions like map_sg etc.)

-- 
Catalin
