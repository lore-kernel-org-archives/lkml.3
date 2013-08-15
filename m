Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759553Ab3HOTv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 15:51:26 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:40754 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756721Ab3HOTvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 15:51:25 -0400
Date: Thu, 15 Aug 2013 15:50:51 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Ian.Campbell@citrix.com
Subject: Re: [PATCH v4 07/10] xen: introduce XENMEM_exchange_and_pin and
 XENMEM_unpin
Message-ID: <20130815195051.GC5337@konrad-lan.dumpdata.com>
References: <alpine.DEB.2.02.1308151200580.4470@kaball.uk.xensource.com>
 <1376565054-24153-7-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376565054-24153-7-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 12:10:51PM +0100, Stefano Stabellini wrote:
> XENMEM_exchange can't be used by autotranslate guests because of two
> severe limitations:
> 
> - it does not copy back the mfns into the out field for autotranslate
>   guests;
> 
> - it does not guarantee that the hypervisor won't change the p2m
>   mappings for the exchanged pages while the guest is using them. Xen
>   never promises to keep the p2m mapping stable for autotranslate guests
>   in general.  In practice it won't happen unless one uses uncommon
>   features like memory sharing or paging.
> 
> To overcome these problems I am introducing two new hypercalls.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> 
> Changes in v4:
> - rename XENMEM_get_dma_buf to XENMEM_exchange_and_pin;
> - rename XENMEM_put_dma_buf to XENMEM_unpin;
> - improve the documentation of the new hypercalls;
> - add a note about out.address_bits for XENMEM_exchange.
> ---
>  include/xen/interface/memory.h |   37 +++++++++++++++++++++++++++++++++++++
>  1 files changed, 37 insertions(+), 0 deletions(-)
> 
> diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
> index 2ecfe4f..5708ff8 100644
> --- a/include/xen/interface/memory.h
> +++ b/include/xen/interface/memory.h
> @@ -66,6 +66,7 @@ struct xen_memory_exchange {
>      /*
>       * [IN] Details of memory extents to be exchanged (GMFN bases).
>       * Note that @in.address_bits is ignored and unused.
> +     * @out.address_bits should contain the address mask for the new pages.
>       */
>      struct xen_memory_reservation in;
>  
> @@ -263,4 +264,40 @@ struct xen_remove_from_physmap {
>  };
>  DEFINE_GUEST_HANDLE_STRUCT(xen_remove_from_physmap);
>  
> +#define XENMEM_exchange_and_pin             26
> +/*
> + * This hypercall is similar to XENMEM_exchange: it takes the same
> + * struct as an argument and it exchanges the pages passed in with a new
> + * set of pages. The new pages are going to be "pinned": it's guaranteed
> + * that their p2m mapping won't be changed until explicitly "unpinned".
> + * The content of the exchanged pages is lost.
> + * Only normal guest r/w memory can be pinned: no granted pages or
> + * ballooned pages.
> + * If return code is zero then @out.extent_list provides the DMA frame
> + * numbers of the newly-allocated memory.
> + * Returns zero on complete success, otherwise a negative error code:
> + *   -ENOSYS if not implemented
> + *   -EINVAL if the page is already pinned
> + *   -EFAULT if the physical to machine walk fails

I don't know what that means. Physical to machine walk? That sounds like
you are trying to do some form of mind melt between robots and humans
while walking around the office.

Could you expand this a bit please?

> + * On complete success then always @nr_exchanged == @in.nr_extents.  On
> + * partial success @nr_exchanged indicates how much work was done and a
> + * negative error code is returned.
> + */
> +
> +#define XENMEM_unpin             27
> +/*
> + * XENMEM_unpin unpins a set of pages, previously pinned by
> + * XENMEM_exchange_and_pin. After this call the p2m mapping of the pages can
> + * be transparently changed by the hypervisor, as usual. The pages are
> + * still accessible from the guest.
> + */
> +struct xen_unpin {
> +    /*
> +     * [IN] Details of memory extents to be unpinned (GMFN bases).
> +     * Note that @in.address_bits is ignored and unused.
> +     */
> +    struct xen_memory_reservation in;
> +};
> +DEFINE_GUEST_HANDLE_STRUCT(xen_unpin);

Otherwise looks good to me.
> +
>  #endif /* __XEN_PUBLIC_MEMORY_H__ */
> -- 
> 1.7.2.5
> 
