Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783Ab3I3Oyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 10:54:43 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:23235 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864Ab3I3Oyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 10:54:39 -0400
Date: Mon, 30 Sep 2013 10:54:05 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Ian.Campbell@citrix.com
Subject: Re: [PATCH v6 03/19] xen: introduce XENMEM_exchange_and_pin and
 XENMEM_unpin
Message-ID: <20130930145405.GN3106@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1309271653420.5498@kaball.uk.xensource.com>
 <1380298207-29151-3-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380298207-29151-3-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 05:09:51PM +0100, Stefano Stabellini wrote:
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

Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> 
> Changes in v6:
> - update the comments and the hypercalls structures.
> 
> Changes in v5:
> - better comment for XENMEM_exchange_and_pin return codes;
> 
> Changes in v4:
> - rename XENMEM_get_dma_buf to XENMEM_exchange_and_pin;
> - rename XENMEM_put_dma_buf to XENMEM_unpin;
> - improve the documentation of the new hypercalls;
> - add a note about out.address_bits for XENMEM_exchange.
> ---
>  include/xen/interface/memory.h |   51 ++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 51 insertions(+), 0 deletions(-)
> 
> diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
> index 2ecfe4f..49db252 100644
> --- a/include/xen/interface/memory.h
> +++ b/include/xen/interface/memory.h
> @@ -66,6 +66,9 @@ struct xen_memory_exchange {
>      /*
>       * [IN] Details of memory extents to be exchanged (GMFN bases).
>       * Note that @in.address_bits is ignored and unused.
> +     * @out.address_bits contains the maximum number of bits addressable
> +     * by the caller. The addresses of the newly allocated pages have to
> +     * meet this restriction.
>       */
>      struct xen_memory_reservation in;
>  
> @@ -263,4 +266,52 @@ struct xen_remove_from_physmap {
>  };
>  DEFINE_GUEST_HANDLE_STRUCT(xen_remove_from_physmap);
>  
> +/*
> + * This hypercall is similar to XENMEM_exchange: it takes the same
> + * struct as an argument and it exchanges the pages passed in with a new
> + * set of pages. The new pages are going to be "pinned": it's guaranteed
> + * that their p2m mapping won't be changed until explicitly "unpinned".
> + * Only normal guest r/w memory can be pinned: no granted pages or
> + * ballooned pages.
> + * If return code is zero then @out.extent_list provides the frame
> + * numbers of the newly-allocated memory.
> + * On X86 the frame numbers are machine frame numbers (mfns).
> + * On ARMv7 and ARMv8 the frame numbers are machine frame numbers (mfns).
> + * Returns zero on complete success, otherwise a negative error code.
> + * The most common error codes are:
> + *   -ENOSYS if not implemented
> + *   -EPERM  if the domain is not privileged for this operation
> + *   -EBUSY  if the page is already pinned
> + *   -EFAULT if an internal error occurs
> + * On complete success then always @nr_exchanged == @in.nr_extents.  On
> + * partial success @nr_exchanged indicates how much work was done and a
> + * negative error code is returned.
> + */
> +#define XENMEM_exchange_and_pin             26
> +
> +/*
> + * XENMEM_unpin unpins a set of pages, previously pinned by
> + * XENMEM_exchange_and_pin. After this call the p2m mapping of the pages can
> + * be transparently changed by the hypervisor, as usual. The pages are
> + * still accessible from the guest.
> + */
> +#define XENMEM_unpin             27
> +struct xen_unpin {
> +    /*
> +     * [IN] Details of memory extents to be unpinned (GMFN bases).
> +     * Note that @in.address_bits is ignored and unused.
> +     */
> +    struct xen_memory_reservation in;
> +    /*
> +     * [OUT] Number of input extents that were successfully unpinned.
> +     *  1. The first @nr_unpinned input extents were successfully
> +     *     unpinned.
> +     *  2. All other input extents are untouched.
> +     *  3. If not all input extents are unpinned then the return code of this
> +     *     command will be non-zero.
> +     */
> +    xen_ulong_t nr_unpinned;
> +};
> +DEFINE_GUEST_HANDLE_STRUCT(xen_unpin);
> +
>  #endif /* __XEN_PUBLIC_MEMORY_H__ */
> -- 
> 1.7.2.5
> 
