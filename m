Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbaJCPFU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 11:05:20 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:25199 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbaJCPFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 11:05:17 -0400
X-IronPort-AV: E=Sophos;i="5.04,647,1406592000"; 
   d="scan'208";a="178984361"
Message-ID: <542EBB2A.6030104@citrix.com>
Date: Fri, 3 Oct 2014 16:05:14 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xensource.com>
CC: <konrad.wilk@oracle.com>, <Ian.Campbell@citrix.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 2/2] xen/arm: introduce GNTTABOP_cache_flush
References: <alpine.DEB.2.02.1410031549150.17038@kaball.uk.xensource.com> <1412348006-27884-2-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1412348006-27884-2-git-send-email-stefano.stabellini@eu.citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/14 15:53, Stefano Stabellini wrote:
> Introduce support for new hypercall GNTTABOP_cache_flush.
> Use it to perform cache flashing on pages used for dma when necessary.
[..]
>  /* functions called by SWIOTLB */
> @@ -22,16 +25,31 @@ static void dma_cache_maint(dma_addr_t handle, unsigned long offset,
>  		size_t len = left;
>  		void *vaddr;
>  	
> +		if (len + offset > PAGE_SIZE)
> +			len = PAGE_SIZE - offset;
> +
>  		if (!pfn_valid(pfn))
>  		{
> -			/* TODO: cache flush */
> +			struct gnttab_cache_flush cflush;
> +
> +			cflush.op = 0;
> +			cflush.a.dev_bus_addr = pfn << PAGE_SHIFT;
> +			cflush.offset = offset;
> +			cflush.size = len;
> +
> +			if (op == dmac_unmap_area && dir != DMA_TO_DEVICE)
> +				cflush.op = GNTTAB_CACHE_INVAL;
> +			if (op == dmac_map_area) {
> +				cflush.op = GNTTAB_CACHE_CLEAN;
> +				if (dir == DMA_FROM_DEVICE)
> +					cflush.op |= GNTTAB_CACHE_INVAL;
> +			}

Are all these cache operations needed?  You do a clean on map regardless
of the direction and INVAL on map seems unnecessary.

I would have thought it would be:

map && (TO_DEVICE || BOTH)
   op = CLEAN

unmap && (FROM_DEVICE || BOTH)
   op = INVAL

> --- a/include/xen/interface/grant_table.h
> +++ b/include/xen/interface/grant_table.h
> @@ -479,6 +479,24 @@ struct gnttab_get_version {
>  DEFINE_GUEST_HANDLE_STRUCT(gnttab_get_version);
>  
>  /*
> + * Issue one or more cache maintenance operations on a portion of a
> + * page granted to the calling domain by a foreign domain.
> + */
> +#define GNTTABOP_cache_flush          12
> +struct gnttab_cache_flush {
> +    union {
> +        uint64_t dev_bus_addr;
> +        grant_ref_t ref;
> +    } a;
> +    uint32_t offset; /* offset from start of grant */
> +    uint32_t size;   /* size within the grant */
> +#define GNTTAB_CACHE_CLEAN      (1<<0)
> +#define GNTTAB_CACHE_INVAL      (1<<1)
> +    uint32_t op;
> +};
> +DEFINE_GUEST_HANDLE_STRUCT(gnttab_cache_flush);
> +
> +/*
>   * Bitfield values for update_pin_status.flags.
>   */
>   /* Map the grant entry for access by I/O devices. */

If the ARM bits are correct, have a

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

for the common header.

David

