Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbaKMRAS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 12:00:18 -0500
Received: from mga14.intel.com ([192.55.52.115]:57980 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbaKMRAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 12:00:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="416075109"
Date: Thu, 13 Nov 2014 22:31:04 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: pl330: Fix linker error "undefined
 reference to `__aeabi_uldivmod'"
Message-ID: <20141113170104.GP24582@intel.com>
References: <1415896047.1787.4.camel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415896047.1787.4.camel@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 04:27:27PM +0000, Jon Medhurst (Tixy) wrote:
> 32-bit ARM kernels may have a 64-bit dma_addr_t but have no
> implementation of the compiler helper for 64-bit unsigned division,
> therefore the use of the modulo operator in pl330_prep_dma_memcpy causes
> the link error "undefined reference to `__aeabi_uldivmod'"
> 
> As the burst value is always a power of two we can fix the problem, and
> make the code more efficient, by replacing "% burst" with "& (burst-1)".
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Jon Medhurst <tixy@linaro.org>
> ---
> 
> Vinod. I haven't added a 'Fixes:' line because I was unsure if the patch
> in linux-next is part of a stable branch or if the SHA1 might change
> before hitting mainline. If it stable then the line should be...
> 
> Fixes: 63369d0a96dc ("dmaengine: pl330: Align DMA memcpy operations to MFIFO width")
I have applied this for now but...

While at it and also related to Fixes, typically the fixes branch wont be
rebased before its sent to Linus and merged. But this is introduced in patch
which is sent, should I just fold it in and not cause this regression in
first place...?

-- 
~Vinod
> 
> 
>  drivers/dma/pl330.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index 38c9617..52c4c62 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -2464,11 +2464,8 @@ pl330_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dst,
>  	 * parameters because our DMA programming algorithm doesn't cope with
>  	 * transfers which straddle an entry in the DMA device's MFIFO.
>  	 */
> -	while (burst > 1) {
> -		if (!((src | dst | len) % burst))
> -			break;
> +	while ((src | dst | len) & (burst - 1))
>  		burst /= 2;
> -	}
>  
>  	desc->rqcfg.brst_size = 0;
>  	while (burst != (1 << desc->rqcfg.brst_size))
> -- 
> 2.1.1
> 
> 

-- 
