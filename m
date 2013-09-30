Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab3I3RWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 13:22:44 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:39698 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842Ab3I3RWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 13:22:43 -0400
Date: Mon, 30 Sep 2013 13:22:09 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Ian.Campbell@citrix.com
Subject: Re: [PATCH v6 17/19] xen: introduce XENMEM_pin
Message-ID: <20130930172209.GX3106@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1309271653420.5498@kaball.uk.xensource.com>
 <1380298207-29151-17-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380298207-29151-17-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 05:10:05PM +0100, Stefano Stabellini wrote:
> Introduce a new hypercall to pin one or more pages whose machine
> addresses respect a dma_mask passed as an argument
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/arm/xen/mm.c              |   16 ++++++++++++++++
>  arch/x86/xen/mmu.c             |    7 +++++++
>  include/xen/interface/memory.h |   32 ++++++++++++++++++++++++++++++++
>  include/xen/xen-ops.h          |    1 +
>  4 files changed, 56 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/xen/mm.c b/arch/arm/xen/mm.c
> index b305b94..146c1c3 100644
> --- a/arch/arm/xen/mm.c
> +++ b/arch/arm/xen/mm.c
> @@ -55,6 +55,22 @@ static int xen_exchange_memory(xen_ulong_t extents_in,
>  	return success;
>  }
>  
> +int xen_pin_page(xen_pfn_t *in_frame, unsigned int address_bits)
> +{
> +	struct xen_pin pin = {
> +		.in = {
> +			.nr_extents   = 1,
> +			.extent_order = 0,
> +			.domid        = DOMID_SELF,
> +			.address_bits = address_bits
> +		},
> +	};
> +	set_xen_guest_handle(pin.in.extent_start, in_frame);
> +
> +	return HYPERVISOR_memory_op(XENMEM_pin, &pin);
> +}
> +EXPORT_SYMBOL_GPL(xen_pin_page);
> +
>  int xen_create_contiguous_region(phys_addr_t pstart, unsigned int order,
>  				 unsigned int address_bits,
>  				 dma_addr_t *dma_handle)
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index 8830883..8f76ce2 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -2568,3 +2568,10 @@ int xen_unmap_domain_mfn_range(struct vm_area_struct *vma,
>  	return -EINVAL;
>  }
>  EXPORT_SYMBOL_GPL(xen_unmap_domain_mfn_range);
> +
> +int xen_pin_page(xen_pfn_t *in_frame, unsigned int address_bits)
> +{
> +	return -ENOSYS;
> +}
> +EXPORT_SYMBOL_GPL(xen_pin_page);
> +
> diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
> index 49db252..66ab578 100644
> --- a/include/xen/interface/memory.h
> +++ b/include/xen/interface/memory.h
> @@ -314,4 +314,36 @@ struct xen_unpin {
>  };
>  DEFINE_GUEST_HANDLE_STRUCT(xen_unpin);
>  
> +/*
> + * XENMEM_pin pins a set of pages to make sure that the hypervisor does
> + * not change the p2m mappings for them.
> + *
> + */
> +#define XENMEM_pin               28
> +struct xen_pin {
> +    /*
> +     * [IN/OUT] Details of memory extents to be pinned (GMFN bases).
> +     * Xen copies back the MFNs corresponding to the GMFNs passed in as
> +     * argument.
> +     * @in.address_bits contains the maximum number of bits addressable
> +     * by the caller. If the machine addresses of the pages to be pinned
> +     * are not addressable according to @in.address_bits, the hypercall
> +     * fails and returns an errors. The pages are not pinned. Otherwise
                               ^^^^^-error.
What kind of error? And you should probably join the two sentences together
(the "If the ... The pages are not pinned.")


> +     * the hypercall succeeds.

and does it return a number of pages that were pinned or just zero?

> +     */
> +    struct xen_memory_reservation in;
> +
> +    /*
> +     * [OUT] Number of input extents that were successfully pinned.
> +     *  1. The first @nr_pinned input extents were successfully
> +     *     pinned.
> +     *  2. All other input extents are untouched.
> +     *  3. If not all input extents are pinned then the return code of this
> +     *     command will be non-zero.

OK, what return code?

> +     */
> +    xen_ulong_t nr_pinned;
> +};
> +DEFINE_GUEST_HANDLE_STRUCT(xen_pin);
> +
> +
>  #endif /* __XEN_PUBLIC_MEMORY_H__ */
> diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
> index fb2ea8f..4cf4fc5 100644
> --- a/include/xen/xen-ops.h
> +++ b/include/xen/xen-ops.h
> @@ -22,6 +22,7 @@ extern unsigned long *xen_contiguous_bitmap;
>  int xen_create_contiguous_region(phys_addr_t pstart, unsigned int order,
>  				unsigned int address_bits,
>  				dma_addr_t *dma_handle);
> +int xen_pin_page(xen_pfn_t *in_frame, unsigned int address_bits);
>  
>  void xen_destroy_contiguous_region(phys_addr_t pstart, unsigned int order);
>  
> -- 
> 1.7.2.5
> 
