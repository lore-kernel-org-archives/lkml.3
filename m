Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbaHAPTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 11:19:36 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:32935 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754171AbaHAPTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 11:19:33 -0400
Date: Fri, 1 Aug 2014 16:19:17 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dma-mapping: Provide write-combine allocations
Message-ID: <20140801151917.GS30282@n2100.arm.linux.org.uk>
References: <1403863018-20033-1-git-send-email-thierry.reding@gmail.com> <20140801124057.GA19889@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140801124057.GA19889@ulmo>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 02:40:59PM +0200, Thierry Reding wrote:
> On Fri, Jun 27, 2014 at 11:56:58AM +0200, Thierry Reding wrote:
> > From: Thierry Reding <treding@nvidia.com>
> > 
> > Provide an implementation for dma_{alloc,free,mmap}_writecombine() when
> > the architecture supports DMA attributes.
> > 
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > ---
> > Changes in v2:
> > - Add a generic dma_mmap_writecombine() function
> > 
> >  arch/arm/include/asm/dma-mapping.h       | 16 ----------------
> >  include/asm-generic/dma-mapping-common.h |  8 --------
> >  include/linux/dma-mapping.h              | 26 ++++++++++++++++++++++++++
> >  3 files changed, 26 insertions(+), 24 deletions(-)
> 
> Ping?

I have no problem with this, but I don't think I can say yes to it; that
depends whether other people are happy for this to live in
include/linux/dma-mapping.h.

I guess consent for this change can only come by no one objecting to it
after several postings.

> > diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
> > index c45b61a4b4a5..85738b200023 100644
> > --- a/arch/arm/include/asm/dma-mapping.h
> > +++ b/arch/arm/include/asm/dma-mapping.h
> > @@ -265,22 +265,6 @@ extern int arm_dma_mmap(struct device *dev, struct vm_area_struct *vma,
> >  			void *cpu_addr, dma_addr_t dma_addr, size_t size,
> >  			struct dma_attrs *attrs);
> >  
> > -static inline void *dma_alloc_writecombine(struct device *dev, size_t size,
> > -				       dma_addr_t *dma_handle, gfp_t flag)
> > -{
> > -	DEFINE_DMA_ATTRS(attrs);
> > -	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
> > -	return dma_alloc_attrs(dev, size, dma_handle, flag, &attrs);
> > -}
> > -
> > -static inline void dma_free_writecombine(struct device *dev, size_t size,
> > -				     void *cpu_addr, dma_addr_t dma_handle)
> > -{
> > -	DEFINE_DMA_ATTRS(attrs);
> > -	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
> > -	return dma_free_attrs(dev, size, cpu_addr, dma_handle, &attrs);
> > -}
> > -
> >  /*
> >   * This can be called during early boot to increase the size of the atomic
> >   * coherent DMA pool above the default value of 256KiB. It must be called
> > diff --git a/include/asm-generic/dma-mapping-common.h b/include/asm-generic/dma-mapping-common.h
> > index de8bf89940f8..d137431bf26f 100644
> > --- a/include/asm-generic/dma-mapping-common.h
> > +++ b/include/asm-generic/dma-mapping-common.h
> > @@ -205,14 +205,6 @@ dma_mmap_attrs(struct device *dev, struct vm_area_struct *vma, void *cpu_addr,
> >  
> >  #define dma_mmap_coherent(d, v, c, h, s) dma_mmap_attrs(d, v, c, h, s, NULL)
> >  
> > -static inline int dma_mmap_writecombine(struct device *dev, struct vm_area_struct *vma,
> > -		      void *cpu_addr, dma_addr_t dma_addr, size_t size)
> > -{
> > -	DEFINE_DMA_ATTRS(attrs);
> > -	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
> > -	return dma_mmap_attrs(dev, vma, cpu_addr, dma_addr, size, &attrs);
> > -}
> > -
> >  int
> >  dma_common_get_sgtable(struct device *dev, struct sg_table *sgt,
> >  		       void *cpu_addr, dma_addr_t dma_addr, size_t size);
> > diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> > index 931b70986272..d5d388160f42 100644
> > --- a/include/linux/dma-mapping.h
> > +++ b/include/linux/dma-mapping.h
> > @@ -263,6 +263,32 @@ struct dma_attrs;
> >  #define dma_unmap_sg_attrs(dev, sgl, nents, dir, attrs) \
> >  	dma_unmap_sg(dev, sgl, nents, dir)
> >  
> > +#else
> > +static inline void *dma_alloc_writecombine(struct device *dev, size_t size,
> > +					   dma_addr_t *dma_addr, gfp_t gfp)
> > +{
> > +	DEFINE_DMA_ATTRS(attrs);
> > +	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
> > +	return dma_alloc_attrs(dev, size, dma_addr, gfp, &attrs);
> > +}
> > +
> > +static inline void dma_free_writecombine(struct device *dev, size_t size,
> > +					 void *cpu_addr, dma_addr_t dma_addr)
> > +{
> > +	DEFINE_DMA_ATTRS(attrs);
> > +	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
> > +	return dma_free_attrs(dev, size, cpu_addr, dma_addr, &attrs);
> > +}
> > +
> > +static inline int dma_mmap_writecombine(struct device *dev,
> > +					struct vm_area_struct *vma,
> > +					void *cpu_addr, dma_addr_t dma_addr,
> > +					size_t size)
> > +{
> > +	DEFINE_DMA_ATTRS(attrs);
> > +	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
> > +	return dma_mmap_attrs(dev, vma, cpu_addr, dma_addr, size, &attrs);
> > +}
> >  #endif /* CONFIG_HAVE_DMA_ATTRS */
> >  
> >  #ifdef CONFIG_NEED_DMA_MAP_STATE
> > -- 
> > 2.0.0
> > 



-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
