Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab3DVKWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 06:22:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:36044 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712Ab3DVKWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 06:22:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,525,1363158000"; 
   d="scan'208";a="322855488"
Date: Mon, 22 Apr 2013 15:21:30 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH 15/32] dmaengine: ste_dma40: Separate Logical Global
 Interrupt Mask (GIM) unmasking
Message-ID: <20130422095130.GM24632@intel.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
 <1366279934-30761-16-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366279934-30761-16-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 11:11:57AM +0100, Lee Jones wrote:
> During the initial setup of a logical channel, it is necessary to unmask
> the GIM in order to receive generated terminal count and error interrupts.
> We're separating out this required code so it will be possible to move
> the remaining code in d40_phy_cfg(), which is mostly runtime configuration
> into the runtime_config() routine.
> 
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/dma/ste_dma40.c    |    3 +++
>  drivers/dma/ste_dma40_ll.c |   11 ++++++-----
>  drivers/dma/ste_dma40_ll.h |    2 ++
>  3 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
> index ec0d6ab..178a03c 100644
> --- a/drivers/dma/ste_dma40.c
> +++ b/drivers/dma/ste_dma40.c
> @@ -2456,6 +2456,9 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
>  				D40_LCPA_CHAN_SIZE + D40_LCPA_CHAN_DST_DELTA;
>  	}
>  
> +	if (chan_is_logical(d40c))
> +		d40_log_gim_unmask(&d40c->src_def_cfg, &d40c->dst_def_cfg);
> +
>  	dev_dbg(chan2dev(d40c), "allocated %s channel (phy %d%s)\n",
>  		 chan_is_logical(d40c) ? "logical" : "physical",
>  		 d40c->phy_chan->num,
> diff --git a/drivers/dma/ste_dma40_ll.c b/drivers/dma/ste_dma40_ll.c
> index 5eb6c10..b72d3e2 100644
> --- a/drivers/dma/ste_dma40_ll.c
> +++ b/drivers/dma/ste_dma40_ll.c
> @@ -50,6 +50,12 @@ void d40_log_cfg(struct stedma40_chan_cfg *cfg,
>  
>  }
>  
> +void d40_log_gim_unmask(u32 *src_cfg, u32 *dst_cfg) {
> +
> +	*src_cfg |= 1 << D40_SREG_CFG_LOG_GIM_POS;
> +	*dst_cfg |= 1 << D40_SREG_CFG_LOG_GIM_POS;
> +}
> +
>  /* Sets up SRC and DST CFG register for both logical and physical channels */
>  void d40_phy_cfg(struct stedma40_chan_cfg *cfg,
>  		 u32 *src_cfg, u32 *dst_cfg, bool is_log)
> @@ -107,11 +113,6 @@ void d40_phy_cfg(struct stedma40_chan_cfg *cfg,
>  			src |= 1 << D40_SREG_CFG_PRI_POS;
>  			dst |= 1 << D40_SREG_CFG_PRI_POS;
shouldnt these be converted to BIT() macro and in gim_unmask above?
Driver needs to be consistent in doing things

>  		}
> -
> -	} else {
> -		/* Logical channel */
> -		dst |= 1 << D40_SREG_CFG_LOG_GIM_POS;
> -		src |= 1 << D40_SREG_CFG_LOG_GIM_POS;
>  	}
>  
>  	if (cfg->src_info.big_endian)
> diff --git a/drivers/dma/ste_dma40_ll.h b/drivers/dma/ste_dma40_ll.h
> index fdde8ef..8aad679 100644
> --- a/drivers/dma/ste_dma40_ll.h
> +++ b/drivers/dma/ste_dma40_ll.h
> @@ -430,6 +430,8 @@ enum d40_lli_flags {
>  	LLI_LAST_LINK	= 1 << 3,
>  };
>  
> +void d40_log_gim_unmask(u32 *src_cfg, u32 *dst_cfg);
> +
>  void d40_phy_cfg(struct stedma40_chan_cfg *cfg,
>  		 u32 *src_cfg,
>  		 u32 *dst_cfg,
> -- 
> 1.7.10.4
> 
