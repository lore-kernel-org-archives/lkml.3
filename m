Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381AbaFYA0H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 20:26:07 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:64629 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaFYA0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 20:26:05 -0400
Date: Tue, 24 Jun 2014 17:26:02 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mark Salter <msalter@redhat.com>
cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm64: fix CONFIG_ZONE_DMA on systems with no 32-bit
 addressable DRAM
In-Reply-To: <1403499940-11258-1-git-send-email-msalter@redhat.com>
Message-ID: <alpine.DEB.2.02.1406241718210.22030@chino.kir.corp.google.com>
References: <1403499940-11258-1-git-send-email-msalter@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2014, Mark Salter wrote:

> Commit 2d5a5612bc (arm64: Limit the CMA buffer to 32-bit if ZONE_DMA)
> forces the CMA buffer to be 32-bit addressable if CONFIG_ZONE_DMA is
> defined. This breaks CMA on platforms with no 32-bit addressable DRAM.
> This patch checks to make sure there is 32-bit addressable DRAM before
> setting the 32-bit limit. If there is none, no limit is placed on the
> CMA buffer. This allows a single kernel (with CONFIG_ZONE_DMA defined)
> to support platforms requiring the 32-bit limit and platforms with no
> 32-bit limit.
> 
> Signed-off-by: Mark Salter <msalter@redhat.com>
> ---
>  arch/arm64/mm/init.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
> index c5415e2..2925576 100644
> --- a/arch/arm64/mm/init.c
> +++ b/arch/arm64/mm/init.c
> @@ -149,8 +149,17 @@ void __init arm64_memblock_init(void)
>  	early_init_fdt_scan_reserved_mem();
>  
>  	/* 4GB maximum for 32-bit only capable devices */
> -	if (IS_ENABLED(CONFIG_ZONE_DMA))
> +	if (IS_ENABLED(CONFIG_ZONE_DMA)) {
>  		dma_phys_limit = dma_to_phys(NULL, DMA_BIT_MASK(32)) + 1;
> +		/*
> +		 * If platform doesn't have DRAM within the dma_phys_limit,
> +		 * remove the limit altogether. This allows one kernel (with
> +		 * CONFIG_ZONE_DMA defined) to support platforms with 32-bit
> +		 * only devices and platforms with no 32-bit DRAM.
> +		 */
> +		if (dma_phys_limit <= memblock_start_of_DRAM())
> +			dma_phys_limit = 0;
> +	}
>  	dma_contiguous_reserve(dma_phys_limit);
>  
>  	memblock_allow_resize();

It is a shame that we have very similar logic, all dependent on 
memblock_start_of_DRAM(), in both zone_sizes_init() and 
arm64_memblock_init() and the latter having to be called before the 
former.  I assume there's no way to make this cleaner in the bootstrap 
code so the dma_to_phys(NULL, DMA_BIT_MASK(32)) + 1 limit can be handled 
properly in a single location?
