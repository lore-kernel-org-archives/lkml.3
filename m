Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679AbaK0OYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 09:24:32 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33376 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbaK0OYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 09:24:30 -0500
Message-ID: <547733E3.3020408@ti.com>
Date: Thu, 27 Nov 2014 16:23:31 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Mark Brown <broonie@kernel.org>, <linux@arm.linux.org.uk>,
        <nsekhar@ti.com>, <vinod.koul@intel.com>,
        <khilman@deeprootsystems.com>, Liam Girdwood <lgirdwood@gmail.com>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        <ulf.hansson@linaro.org>, <chris@printf.net>,
        <linux-arm-kernel@lists.infradead.org>, <linux-mmc@vger.kernel.org>,
        <linux-spi@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, <dmaengine@vger.kernel.org>
Subject: Re: [PATCH 2/3] ARM: edma: Rename header file for dmaengine filter
 function definition
References: <1417084891-17990-1-git-send-email-peter.ujfalusi@ti.com> <1417084891-17990-3-git-send-email-peter.ujfalusi@ti.com> <8235185.7qUDHu9jso@wuerfel>
In-Reply-To: <8235185.7qUDHu9jso@wuerfel>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2014 01:14 PM, Arnd Bergmann wrote:
> On Thursday 27 November 2014 12:41:30 Peter Ujfalusi wrote:
>> diff --git a/include/linux/edma-dmaengine.h b/include/linux/edma-dmaengine.h
>> new file mode 100644
>> index 000000000000..8a2602809a77
>> --- /dev/null
>> +++ b/include/linux/edma-dmaengine.h
>> @@ -0,0 +1,29 @@
>> +struct dma_chan;
>> +
>> +#if defined(CONFIG_TI_EDMA) || defined(CONFIG_TI_EDMA_MODULE)
>> +bool edma_filter_fn(struct dma_chan *, void *);
>> +#else
>> +static inline bool edma_filter_fn(struct dma_chan *chan, void *param)
>> +{
>> +	return false;
>> +}
>> +#endif
>> +
>> +#endif
> 
> It's better not to hardcode the name of the filter function in a driver,
> better move the filter function into platform code and pass it down
> to the driver in the platform_data pointer in davinci_mmc_config and
> davinci_spi_platform_data to get rid of this dependency.
> 
> Something roughly like the patch below.

This will only work in case of legacy boot. When booting with DT we do not
have pdata and after this patch in dt boot we are not going to be able to get
the DMA resources either.

I think if we want to do something like this, it has to be done within the
dmaengine framework. The dma controller's of_dma_filter_info already have
.filter_fn which could be used by the framework.

On the other hand the davinci_mmc (and spi-davinci) is only going to work on
davinci devices, so I don't really see issue with 'hard coding' davinci
related callback in the code.

-- 
Péter

> 
> 	Arnd
> 
> 
> ---
> [DRAFT] ARM: davinci: pass dma config through platform data
> 
> DMA slave drivers are supposed to be written independent of the dma engine
> driver, which means that the mmc and spi drivers on davinci should not
> reference the edma_filter_fn or know about the specific format of the
> data passed into it.
> 
> This changes the channel data from a resource into a void pointer and
> passes it as platform data along with the filter function.
> 
> TODO: do the same thing for SPI, and adapt the filter function for the
> new format.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
>  arch/arm/mach-davinci/devices-da8xx.c     | 26 ++++++--------------------
>  arch/arm/mach-davinci/devices.c           | 22 ++++++----------------
>  drivers/mmc/host/davinci_mmc.c            | 27 +++++++++++----------------
>  include/linux/platform_data/mmc-davinci.h |  5 +++++
>  4 files changed, 28 insertions(+), 52 deletions(-)
> 
> diff --git a/arch/arm/mach-davinci/devices-da8xx.c b/arch/arm/mach-davinci/devices-da8xx.c
> index b85b781b05fd..4aa872dc6dc3 100644
> --- a/arch/arm/mach-davinci/devices-da8xx.c
> +++ b/arch/arm/mach-davinci/devices-da8xx.c
> @@ -671,16 +671,6 @@ static struct resource da8xx_mmcsd0_resources[] = {
>  		.end	= IRQ_DA8XX_MMCSDINT0,
>  		.flags	= IORESOURCE_IRQ,
>  	},
> -	{		/* DMA RX */
> -		.start	= DA8XX_DMA_MMCSD0_RX,
> -		.end	= DA8XX_DMA_MMCSD0_RX,
> -		.flags	= IORESOURCE_DMA,
> -	},
> -	{		/* DMA TX */
> -		.start	= DA8XX_DMA_MMCSD0_TX,
> -		.end	= DA8XX_DMA_MMCSD0_TX,
> -		.flags	= IORESOURCE_DMA,
> -	},
>  };
>  
>  static struct platform_device da8xx_mmcsd0_device = {
> @@ -693,6 +683,9 @@ static struct platform_device da8xx_mmcsd0_device = {
>  int __init da8xx_register_mmcsd0(struct davinci_mmc_config *config)
>  {
>  	da8xx_mmcsd0_device.dev.platform_data = config;
> +	config->filter = edma_filter_fn;
> +	config->rxdma = (void *)DA8XX_DMA_MMCSD0_RX;
> +	config->txdma = (void *)DA8XX_DMA_MMCSD0_TX;
>  	return platform_device_register(&da8xx_mmcsd0_device);
>  }
>  
> @@ -708,16 +701,6 @@ static struct resource da850_mmcsd1_resources[] = {
>  		.end	= IRQ_DA850_MMCSDINT0_1,
>  		.flags	= IORESOURCE_IRQ,
>  	},
> -	{		/* DMA RX */
> -		.start	= DA850_DMA_MMCSD1_RX,
> -		.end	= DA850_DMA_MMCSD1_RX,
> -		.flags	= IORESOURCE_DMA,
> -	},
> -	{		/* DMA TX */
> -		.start	= DA850_DMA_MMCSD1_TX,
> -		.end	= DA850_DMA_MMCSD1_TX,
> -		.flags	= IORESOURCE_DMA,
> -	},
>  };
>  
>  static struct platform_device da850_mmcsd1_device = {
> @@ -730,6 +713,9 @@ static struct platform_device da850_mmcsd1_device = {
>  int __init da850_register_mmcsd1(struct davinci_mmc_config *config)
>  {
>  	da850_mmcsd1_device.dev.platform_data = config;
> +	config->filter = edma_filter_fn;
> +	config->rxdma = (void *)DA8XX_DMA_MMCSD1_RX;
> +	config->txdma = (void *)DA8XX_DMA_MMCSD1_TX;
>  	return platform_device_register(&da850_mmcsd1_device);
>  }
>  #endif
> diff --git a/arch/arm/mach-davinci/devices.c b/arch/arm/mach-davinci/devices.c
> index 6257aa452568..7b7039d9b079 100644
> --- a/arch/arm/mach-davinci/devices.c
> +++ b/arch/arm/mach-davinci/devices.c
> @@ -144,14 +144,6 @@ static struct resource mmcsd0_resources[] = {
>  		.start = IRQ_SDIOINT,
>  		.flags = IORESOURCE_IRQ,
>  	},
> -	/* DMA channels: RX, then TX */
> -	{
> -		.start = EDMA_CTLR_CHAN(0, DAVINCI_DMA_MMCRXEVT),
> -		.flags = IORESOURCE_DMA,
> -	}, {
> -		.start = EDMA_CTLR_CHAN(0, DAVINCI_DMA_MMCTXEVT),
> -		.flags = IORESOURCE_DMA,
> -	},
>  };
>  
>  static struct platform_device davinci_mmcsd0_device = {
> @@ -181,14 +173,6 @@ static struct resource mmcsd1_resources[] = {
>  		.start = IRQ_DM355_SDIOINT1,
>  		.flags = IORESOURCE_IRQ,
>  	},
> -	/* DMA channels: RX, then TX */
> -	{
> -		.start = EDMA_CTLR_CHAN(0, 30),	/* rx */
> -		.flags = IORESOURCE_DMA,
> -	}, {
> -		.start = EDMA_CTLR_CHAN(0, 31),	/* tx */
> -		.flags = IORESOURCE_DMA,
> -	},
>  };
>  
>  static struct platform_device davinci_mmcsd1_device = {
> @@ -218,6 +202,9 @@ void __init davinci_setup_mmc(int module, struct davinci_mmc_config *config)
>  	 */
>  	switch (module) {
>  	case 1:
> +		config->filter = edma_filter_fn;
> +		config->rxdma = (void *)EDMA_CTLR_CHAN(0, DAVINCI_DMA_MMCRXEVT);
> +		config->txdma = (void *)EDMA_CTLR_CHAN(0, DAVINCI_DMA_MMCTXEVT);
>  		if (cpu_is_davinci_dm355()) {
>  			/* REVISIT we may not need all these pins if e.g. this
>  			 * is a hard-wired SDIO device...
> @@ -247,6 +234,9 @@ void __init davinci_setup_mmc(int module, struct davinci_mmc_config *config)
>  		pdev = &davinci_mmcsd1_device;
>  		break;
>  	case 0:
> +		config->filter = edma_filter_fn;
> +		config->rxdma = (void *)EDMA_CTLR_CHAN(0, 30);
> +		config->txdma = (void *)EDMA_CTLR_CHAN(0, 31);
>  		if (cpu_is_davinci_dm355()) {
>  			mmcsd0_resources[0].start = DM355_MMCSD0_BASE;
>  			mmcsd0_resources[0].end = DM355_MMCSD0_BASE + SZ_4K - 1;
> diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
> index 1625f908dc70..3f25be9942c8 100644
> --- a/drivers/mmc/host/davinci_mmc.c
> +++ b/drivers/mmc/host/davinci_mmc.c
> @@ -202,7 +202,8 @@ struct mmc_davinci_host {
>  	u32 buffer_bytes_left;
>  	u32 bytes_left;
>  
> -	u32 rxdma, txdma;
> +	dma_filter_fn filter;
> +	void *rxdma, *txdma;
>  	struct dma_chan *dma_tx;
>  	struct dma_chan *dma_rx;
>  	bool use_dma;
> @@ -524,16 +525,16 @@ static int __init davinci_acquire_dma_channels(struct mmc_davinci_host *host)
>  	dma_cap_set(DMA_SLAVE, mask);
>  
>  	host->dma_tx =
> -		dma_request_slave_channel_compat(mask, edma_filter_fn,
> -				&host->txdma, mmc_dev(host->mmc), "tx");
> +		dma_request_slave_channel_compat(mask, host->filter,
> +				host->txdma, mmc_dev(host->mmc), "tx");
>  	if (!host->dma_tx) {
>  		dev_err(mmc_dev(host->mmc), "Can't get dma_tx channel\n");
>  		return -ENODEV;
>  	}
>  
>  	host->dma_rx =
> -		dma_request_slave_channel_compat(mask, edma_filter_fn,
> -				&host->rxdma, mmc_dev(host->mmc), "rx");
> +		dma_request_slave_channel_compat(mask, host->filter,
> +				host->rxdma, mmc_dev(host->mmc), "rx");
>  	if (!host->dma_rx) {
>  		dev_err(mmc_dev(host->mmc), "Can't get dma_rx channel\n");
>  		r = -ENODEV;
> @@ -1262,17 +1263,11 @@ static int __init davinci_mmcsd_probe(struct platform_device *pdev)
>  	host = mmc_priv(mmc);
>  	host->mmc = mmc;	/* Important */
>  
> -	r = platform_get_resource(pdev, IORESOURCE_DMA, 0);
> -	if (!r)
> -		dev_warn(&pdev->dev, "RX DMA resource not specified\n");
> -	else
> -		host->rxdma = r->start;
> -
> -	r = platform_get_resource(pdev, IORESOURCE_DMA, 1);
> -	if (!r)
> -		dev_warn(&pdev->dev, "TX DMA resource not specified\n");
> -	else
> -		host->txdma = r->start;
> +	if (pdata) {
> +		host->filter = pdata->filter;
> +		host->rxdma  = pdata->rxdma;
> +		host->txdma  = pdata->txdma;
> +	}
>  
>  	host->mem_res = mem;
>  	host->base = ioremap(mem->start, mem_size);
> diff --git a/include/linux/platform_data/mmc-davinci.h b/include/linux/platform_data/mmc-davinci.h
> index 9cea4ee377b5..0e5809bcaff0 100644
> --- a/include/linux/platform_data/mmc-davinci.h
> +++ b/include/linux/platform_data/mmc-davinci.h
> @@ -25,6 +25,11 @@ struct davinci_mmc_config {
>  
>  	/* Number of sg segments */
>  	u8	nr_sg;
> +
> +	/* DMA setup */
> +	dma_filter_fn filter;
> +	void	*rxdma;
> +	void	*txdma;
>  };
>  void davinci_setup_mmc(int module, struct davinci_mmc_config *config);
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

