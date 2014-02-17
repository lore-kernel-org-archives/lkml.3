Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbaBQIiC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 03:38:02 -0500
Received: from mga01.intel.com ([192.55.52.88]:9293 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbaBQIiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 03:38:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,859,1384329600"; 
   d="scan'208";a="482798569"
Date: Mon, 17 Feb 2014 14:05:33 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Siva Yerramreddy <siva.krishna.kumar.reddy.yerramreddy@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, dmaengine@vger.kernel.org,
        Sudeep Dutt <sudeep.dutt@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH dmaengine-fixes 1/1] dmaengine: read completed cookie
 before used cookie
Message-ID: <20140217083533.GW10628@intel.com>
References: <d0106d723f7455208f83e50522007fee7887e67e.1392419479.git.siva.krishna.kumar.reddy.yerramreddy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0106d723f7455208f83e50522007fee7887e67e.1392419479.git.siva.krishna.kumar.reddy.yerramreddy@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 03:32:57PM -0800, Siva Yerramreddy wrote:
> When running dmatest with my yet-to-be submitted driver for the Intel MIC DMA
> engine, dmatest detected "dma0chan3-copy5: result #8096161:completion busy
> status with src_off=0x0 dst_off=0x0 len=0x40 (0)". This is caused by reading
> the used cookie before the completed cookie in dma_cookie_status(),  if a DMA
> request is submitted in between the two reads, and completes,  the completed
> cookie will be newer than the used cookie value read previously.  Reversing
> the order of reads ensures that the completed cookie is for a DMA request
> older than the used cookie.
> 
> Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
> Reviewed-by: Sudeep Dutt <sudeep.dutt@intel.com>
> Reviewed-by: Nikhil Rao <nikhil.rao@intel.com>
> Signed-off-by: Siva Yerramreddy <siva.krishna.kumar.reddy.yerramreddy@intel.com>
> ---
>  drivers/dma/dmaengine.h | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/dmaengine.h b/drivers/dma/dmaengine.h
> index 17f983a..4c96892 100644
> --- a/drivers/dma/dmaengine.h
> +++ b/drivers/dma/dmaengine.h
> @@ -7,6 +7,7 @@
>  
>  #include <linux/bug.h>
>  #include <linux/dmaengine.h>
> +#include <asm/barrier.h>
>  
>  /**
>   * dma_cookie_init - initialize the cookies for a DMA channel
> @@ -69,8 +70,13 @@ static inline enum dma_status dma_cookie_status(struct dma_chan *chan,
>  {
>  	dma_cookie_t used, complete;
>  
> -	used = chan->cookie;
>  	complete = chan->completed_cookie;
> +	/*
> +	 * If this order is not maintained, used can end up being older than
> +	 * complete
> +	 */
> +	smp_rmb();
> +	used = chan->cookie;
>  	barrier();
>  	if (state) {
>  		state->last = complete;
The idea is right to grab the channle cookie after completed. But I dont see why
you need another barrier in between these two?

Dan,

This really is intresting case where the request completed raced with status.
I am sure for us slow slave users we may not see such issues :D but for these
and other memcpy cases do we really need to bother checking the status properly
and getting right data or delayed reporting is fine?

-- 
~Vinod
