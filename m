Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab3DVJyp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 05:54:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:49113 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488Ab3DVJyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 05:54:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,525,1363158000"; 
   d="scan'208";a="326110189"
Date: Mon, 22 Apr 2013 14:53:21 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH 13/32] dmaengine: ste_dma40: Calculate number of
 logical channels from physical ones
Message-ID: <20130422092321.GC24632@intel.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
 <1366279934-30761-14-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366279934-30761-14-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 11:11:55AM +0100, Lee Jones wrote:
> This change will cost ~25KB of memory, but it's worth the trade-off,
> as it removes a great deal of overhead. It means that instead of only
> allocating memory for the logical channels in use, it does so for all
> available ones, which is 32 per physical channel. However, this now
> means we can remove some platform data and we don't have to worry
> about adding vendor specific variables to Device Tree.
> 
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  arch/arm/mach-ux500/devices-db8500.c        |    1 -
>  drivers/dma/ste_dma40.c                     |   16 ++++++----------
>  include/linux/platform_data/dma-ste-dma40.h |    2 --
>  3 files changed, 6 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/arm/mach-ux500/devices-db8500.c b/arch/arm/mach-ux500/devices-db8500.c
> index 03efd4c1..2fcb8c2 100644
> --- a/arch/arm/mach-ux500/devices-db8500.c
> +++ b/arch/arm/mach-ux500/devices-db8500.c
> @@ -121,7 +121,6 @@ static const dma_addr_t dma40_rx_map[DB8500_DMA_NR_DEV] = {
>  };
>  
>  static struct stedma40_platform_data dma40_plat_data = {
> -	.dev_len = DB8500_DMA_NR_DEV,
>  	.dev_rx = dma40_rx_map,
>  	.dev_tx = dma40_tx_map,
>  	.disabled_channels = {-1},
> diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
> index 7b451b2..a39ef74 100644
> --- a/drivers/dma/ste_dma40.c
> +++ b/drivers/dma/ste_dma40.c
> @@ -45,6 +45,9 @@
>  #define D40_LCLA_LINK_PER_EVENT_GRP 128
>  #define D40_LCLA_END D40_LCLA_LINK_PER_EVENT_GRP
>  
> +/* Max number of logical channels per physical channel */
> +#define D40_MAX_LOG_CHAN_PER_PHY 32
> +
>  /* Attempts before giving up to trying to get pages that are aligned */
>  #define MAX_LCLA_ALLOC_ATTEMPTS 256
>  
> @@ -3197,6 +3200,8 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
>  	else
>  		num_phy_chans = 4 * (readl(virtbase + D40_DREG_ICFG) & 0x7) + 4;
>  
> +	num_log_chans = num_phy_chans * D40_MAX_LOG_CHAN_PER_PHY;
> +
>  	dev_info(&pdev->dev, "hardware revision: %d @ 0x%x with %d physical channels\n",
>  		 rev, res->start, num_phy_chans);
>  
> @@ -3206,15 +3211,6 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
>  		goto failure;
>  	}
>  
> -	/* Count the number of logical channels in use */
> -	for (i = 0; i < plat_data->dev_len; i++)
> -		if (plat_data->dev_rx[i] != 0)
> -			num_log_chans++;
> -
> -	for (i = 0; i < plat_data->dev_len; i++)
> -		if (plat_data->dev_tx[i] != 0)
> -			num_log_chans++;
> -
>  	base = kzalloc(ALIGN(sizeof(struct d40_base), 4) +
>  		       (num_phy_chans + num_log_chans + ARRAY_SIZE(dma40_memcpy_channels)) *
>  		       sizeof(struct d40_chan), GFP_KERNEL);
> @@ -3282,7 +3278,7 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
>  		 * The max number of logical channels are event lines for all
>  		 * src devices and dst devices
>  		 */
> -		base->lookup_log_chans = kzalloc(plat_data->dev_len * 2 *
> +		base->lookup_log_chans = kzalloc(num_log_chans *
you could have used devm_ helper for this.

Still,

Acked-by: Vinod Koul <vnod.koul@intel.com>

--
~Vinod
>  						 sizeof(struct d40_chan *),
>  						 GFP_KERNEL);
>  		if (!base->lookup_log_chans)
> diff --git a/include/linux/platform_data/dma-ste-dma40.h b/include/linux/platform_data/dma-ste-dma40.h
> index 9e42a67..c54af61 100644
> --- a/include/linux/platform_data/dma-ste-dma40.h
> +++ b/include/linux/platform_data/dma-ste-dma40.h
> @@ -136,7 +136,6 @@ struct stedma40_chan_cfg {
>  /**
>   * struct stedma40_platform_data - Configuration struct for the dma device.
>   *
> - * @dev_len: length of dev_tx and dev_rx
>   * @dev_tx: mapping between destination event line and io address
>   * @dev_rx: mapping between source event line and io address
>   * @disabled_channels: A vector, ending with -1, that marks physical channels
> @@ -153,7 +152,6 @@ struct stedma40_chan_cfg {
>   * for 'multiple of 4' channels, like 8.
>   */
>  struct stedma40_platform_data {
> -	u32				 dev_len;
>  	const dma_addr_t		*dev_tx;
>  	const dma_addr_t		*dev_rx;
>  	int				 disabled_channels[STEDMA40_MAX_PHYS];
> -- 
> 1.7.10.4
> 
