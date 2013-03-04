Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab3CDFCk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 00:02:40 -0500
Received: from mga11.intel.com ([192.55.52.93]:49386 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943Ab3CDFCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 00:02:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,777,1355126400"; 
   d="scan'208";a="294324804"
Date: Mon, 4 Mar 2013 10:32:20 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>
Cc: linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.jf.intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCHv2] dw_dmac: adjust slave_id accordingly to request line
 base
Message-ID: <20130304050220.GF22513@intel.com>
References: <1361361137-15396-1-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361361137-15396-1-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 01:52:17PM +0200, Andy Shevchenko wrote:
> On some hardware configurations we have got the request line with the offset.
> The patch introduces convert_slave_id() helper for that cases. The request line
> base is came from the driver data provided by the platform_device_id table.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
Applied, Thanks

> ---
> Since v1:
>  - use driver_data instead of parsing IORESOURCE_DMA
>  drivers/dma/dw_dmac.c      |   17 ++++++++++++++++-
>  drivers/dma/dw_dmac_regs.h |    1 +
>  2 files changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index 51c3ea2..67a868d 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -994,6 +994,13 @@ static inline void convert_burst(u32 *maxburst)
>  		*maxburst = 0;
>  }
>  
> +static inline void convert_slave_id(struct dw_dma_chan *dwc)
> +{
> +	struct dw_dma *dw = to_dw_dma(dwc->chan.device);
> +
> +	dwc->dma_sconfig.slave_id -= dw->request_line_base;
> +}
> +
>  static int
>  set_runtime_config(struct dma_chan *chan, struct dma_slave_config *sconfig)
>  {
> @@ -1008,6 +1015,7 @@ set_runtime_config(struct dma_chan *chan, struct dma_slave_config *sconfig)
>  
>  	convert_burst(&dwc->dma_sconfig.src_maxburst);
>  	convert_burst(&dwc->dma_sconfig.dst_maxburst);
> +	convert_slave_id(dwc);
>  
>  	return 0;
>  }
> @@ -1637,6 +1645,7 @@ dw_dma_parse_dt(struct platform_device *pdev)
>  
>  static int dw_probe(struct platform_device *pdev)
>  {
> +	const struct platform_device_id *match;
>  	struct dw_dma_platform_data *pdata;
>  	struct resource		*io;
>  	struct dw_dma		*dw;
> @@ -1722,6 +1731,11 @@ static int dw_probe(struct platform_device *pdev)
>  		memcpy(dw->data_width, pdata->data_width, 4);
>  	}
>  
> +	/* Get the base request line if set */
> +	match = platform_get_device_id(pdev);
> +	if (match)
> +		dw->request_line_base = (unsigned int)match->driver_data;
> +
>  	/* Calculate all channel mask before DMA setup */
>  	dw->all_chan_mask = (1 << nr_channels) - 1;
>  
> @@ -1907,7 +1921,8 @@ MODULE_DEVICE_TABLE(of, dw_dma_id_table);
>  #endif
>  
>  static const struct platform_device_id dw_dma_ids[] = {
> -	{ "INTL9C60", 0 },
> +	/* Name,	Request Line Base */
> +	{ "INTL9C60",	(kernel_ulong_t)16 },
>  	{ }
>  };
>  
> diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
> index 88dd8eb..3eeb766 100644
> --- a/drivers/dma/dw_dmac_regs.h
> +++ b/drivers/dma/dw_dmac_regs.h
> @@ -248,6 +248,7 @@ struct dw_dma {
>  	/* hardware configuration */
>  	unsigned char		nr_masters;
>  	unsigned char		data_width[4];
> +	unsigned int		request_line_base;
>  
>  	struct dw_dma_chan	chan[0];
>  };
> -- 
> 1.7.10.4
> 
