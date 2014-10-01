Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530AbaJAMBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 08:01:36 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51261 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbaJAMBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 08:01:33 -0400
Message-ID: <542BECF5.2090700@ti.com>
Date: Wed, 1 Oct 2014 15:00:53 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        <linux-serial@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tony@atomide.com>,
        <balbi@ti.com>, <gregkh@linuxfoundation.org>, <vinod.koul@intel.com>
Subject: Re: [PATCH 09/13] dmaengine: edma: check for echan->edesc => NULL
 in edma_dma_pause()
References: <1412014009-13315-1-git-send-email-bigeasy@linutronix.de> <1412014009-13315-10-git-send-email-bigeasy@linutronix.de>
In-Reply-To: <1412014009-13315-10-git-send-email-bigeasy@linutronix.de>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2014 09:06 PM, Sebastian Andrzej Siewior wrote:
> I added book keeping of whether or not the 8250-dma driver has an RX
> transfer pending or not so we don't BUG here if it calls
> dmaengine_pause() on a channel which has not a pending transfer. Guess
> what, this is not enough.
> The following can be triggered with a busy RX channel and hackbench in
> background:
> - DMA transfer completes. The callback is delayed via
>   vchan_cookie_complete() into a tasklet so it das not happen asap.
> - hackbench keeps the system busy so the tasklet does not run "soon".
> - the UART collected enough data and generates an "timeout"-interrupt.
>   Since 8250-dma *thinks* the DMA-transfer is still pending it tries to
>   cancel it via invoking dmaengine_pause() first. This causes the segfault
>   because echan->edesc is NULL now that the transfer completed (however
>   the callback did not run yet).
> 
> With this patch we don't BUG in the scenario described.

Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

> 
> Cc: vinod.koul@intel.com
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/dma/edma.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
> index 7b65633f495e..123f578d6dd3 100644
> --- a/drivers/dma/edma.c
> +++ b/drivers/dma/edma.c
> @@ -288,7 +288,7 @@ static int edma_slave_config(struct edma_chan *echan,
>  static int edma_dma_pause(struct edma_chan *echan)
>  {
>  	/* Pause/Resume only allowed with cyclic mode */
> -	if (!echan->edesc->cyclic)
> +	if (!echan->edesc || !echan->edesc->cyclic)
>  		return -EINVAL;
>  
>  	edma_pause(echan->ch_num);
> 


-- 
Péter
