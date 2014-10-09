Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126AbaJILAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 07:00:31 -0400
Received: from smtp.citrix.com ([66.165.176.89]:6976 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461AbaJILA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 07:00:26 -0400
X-IronPort-AV: E=Sophos;i="5.04,684,1406592000"; 
   d="scan'208";a="179741463"
Message-ID: <54366AC7.2080106@citrix.com>
Date: Thu, 9 Oct 2014 12:00:23 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xensource.com>
CC: <Ian.Campbell@citrix.com>, <linux-kernel@vger.kernel.org>,
        <david.vrabel@citrix.com>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [Xen-devel] [PATCH v3 2/2] xen/arm: introduce GNTTABOP_cache_flush
References: <alpine.DEB.2.02.1410081400520.17038@kaball.uk.xensource.com> <1412773496-15364-2-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1412773496-15364-2-git-send-email-stefano.stabellini@eu.citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/14 14:04, Stefano Stabellini wrote:
> Introduce support for new hypercall GNTTABOP_cache_flush.
> Use it to perform cache flashing on pages used for dma when necessary.

This still think all these additional hypercalls in the hot path are
going to limit performance but on the understanding that this is only
used for non-coherent devices and a lack of anything better:

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

With one comment below.

> --- a/arch/arm/xen/mm32.c
> +++ b/arch/arm/xen/mm32.c
> @@ -4,6 +4,9 @@
>  #include <linux/highmem.h>
>  
>  #include <xen/features.h>
> +#include <xen/interface/grant_table.h>
> +
> +#include <asm/xen/hypercall.h>
>  
>  
>  /* functions called by SWIOTLB */
> @@ -22,16 +25,32 @@ static void dma_cache_maint(dma_addr_t handle, unsigned long offset,
>  		size_t len = left;
>  		void *vaddr;
>  	
> +		if (len + offset > PAGE_SIZE)
> +			len = PAGE_SIZE - offset;

Since this looks like it would result in failing the clean/invalidate
the trailing part of the buffer, I think this needs a comment explaining
why this is safe.  i.e., buffers in highmem or foreign pages cannot
cross page boundaries.

David
