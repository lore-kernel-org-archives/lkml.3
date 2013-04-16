Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219Ab3DPNpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 09:45:40 -0400
Received: from mga14.intel.com ([143.182.124.37]:13743 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757264Ab3DPNpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 09:45:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,485,1363158000"; 
   d="scan'208";a="286888965"
Date: Tue, 16 Apr 2013 18:45:19 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: torvalds@linux-foundation.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] dmaengine: at_hdmac: fix race condition in
 atc_advance_work()
Message-ID: <20130416131519.GL12436@intel.com>
References: <1366112974-32043-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366112974-32043-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 01:49:34PM +0200, Nicolas Ferre wrote:
> From: Ludovic Desroches <ludovic.desroches@atmel.com>
> 
> The BUG_ON() directive is triggered probably due to a latency modification
> following inclusion of c10d736 (softirq: reduce latencies).
> This condition has not been met before 3.9-rc1 and doesn't trigger without
> this patch.
> 
> We now make sure that DMA channel is idle before calling atc_complete_all()
> which makes the BUG_ON() "protection" useless.
> 
> Signed-off-by: Ludovic Desroches <ludovic.desroches@atmel.com>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Vinod Koul <vinod.koul@intel.com>
> ---
> Linus,
> 
> We have identified a race condition on the Atmel ARM-based AT91 DMA controller
> driver that leads to hitting a BUG_ON() directive.
> This error, only triggered after the inclusion of a patch that reduces the
> softirq latency, is affecting several AT91 SoCs and can be seen
> as a regression by people using the dmaengine driver (on NAND flash
> accesses for instance).
> 
> I know that it is late in the development cycle but can you please consider
> including it in your tree before 3.9-final?
> 
> This patch can also go through dmaengine tree (Vinod Koul) but I do not know if
> there is enough time remaining.
> 
> Thanks a lot, best regards,
> 
> Nicolas Ferre
> 
> 
>  drivers/dma/at_hdmac.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
> index 6e13f26..88cfc61 100644
> --- a/drivers/dma/at_hdmac.c
> +++ b/drivers/dma/at_hdmac.c
> @@ -310,8 +310,6 @@ static void atc_complete_all(struct at_dma_chan *atchan)
>  
>  	dev_vdbg(chan2dev(&atchan->chan_common), "complete all\n");
>  
> -	BUG_ON(atc_chan_is_enabled(atchan));
> -
>  	/*
>  	 * Submit queued descriptors ASAP, i.e. before we go through
>  	 * the completed ones.
> @@ -368,6 +366,9 @@ static void atc_advance_work(struct at_dma_chan *atchan)
>  {
>  	dev_vdbg(chan2dev(&atchan->chan_common), "advance_work\n");
>  
> +	if (atc_chan_is_enabled(atchan))
> +		return;
> +
>  	if (list_empty(&atchan->active_list) ||
>  	    list_is_singular(&atchan->active_list)) {
>  		atc_complete_all(atchan);
> @@ -1078,9 +1079,7 @@ static void atc_issue_pending(struct dma_chan *chan)
>  		return;
>  
>  	spin_lock_irqsave(&atchan->lock, flags);
> -	if (!atc_chan_is_enabled(atchan)) {
> -		atc_advance_work(atchan);
> -	}
> +	atc_advance_work(atchan);
>  	spin_unlock_irqrestore(&atchan->lock, flags);
>  }
>  
> -- 
> 1.8.0
> 
