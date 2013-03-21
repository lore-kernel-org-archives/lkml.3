Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287Ab3CUNPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 09:15:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:55233 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755793Ab3CUNPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 09:15:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,886,1355126400"; 
   d="scan'208";a="309969376"
Date: Thu, 21 Mar 2013 18:20:40 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dw_dmac: don't wait for FIFO_EMPTY endlessly in
 dwc_chan_pause
Message-ID: <20130321125040.GS10326@intel.com>
References: <1363859357-31545-1-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363859357-31545-1-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 11:49:17AM +0200, Andy Shevchenko wrote:
> When we pause the channel after transfer is completed we might stuck in the
> dwc_chan_pause() because the FIFO_EMPTY flag will never be asserted. To avoid
> the endless loop we introduce a timeout here (*). The proper solution is to
> somehow get the residue in FIFO and avoid busyloop when transfer is done, but
> this task is not simple and fast.
> 
> Unfortunately we can't use cpu_relax() in conjunction with jiffies checker, due
> to we have interrupts disabled by spin_lock_irqsave() and there is a big chance
> that no interrupts will come to update the jiffies..
> 
> (*) The worst case is
> 	AHB write * FIFO size / hclk = 5.12 us,
>     where
> 	AHB write = 2 cycles,
> 	hclk = 100 MHz,
> 	burst size = 1 byte,
> 	FIFO size = 256 bytes.
>     The proposed 40us timeout might be considered as a big one, though we enter
>     to that state only when we have the transfer already completed.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Applied Thanks

> ---
>  drivers/dma/dw_dmac.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index 43a5329..43e2e89 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -1030,10 +1030,11 @@ set_runtime_config(struct dma_chan *chan, struct dma_slave_config *sconfig)
>  static inline void dwc_chan_pause(struct dw_dma_chan *dwc)
>  {
>  	u32 cfglo = channel_readl(dwc, CFG_LO);
> +	unsigned int count = 20;	/* timeout iterations */
>  
>  	channel_writel(dwc, CFG_LO, cfglo | DWC_CFGL_CH_SUSP);
> -	while (!(channel_readl(dwc, CFG_LO) & DWC_CFGL_FIFO_EMPTY))
> -		cpu_relax();
> +	while (!(channel_readl(dwc, CFG_LO) & DWC_CFGL_FIFO_EMPTY) && count--)
> +		udelay(2);
>  
>  	dwc->paused = true;
>  }
> -- 
> 1.8.2.rc0.22.gb3600c3
> 
