Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab3AWUtV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 15:49:21 -0500
Received: from mail-ia0-f182.google.com ([209.85.210.182]:55813 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab3AWUtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 15:49:14 -0500
Date: Wed, 23 Jan 2013 15:49:18 -0500
From: Matt Porter <mporter@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Benoit Cousson <b-cousson@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Chris Ball <cjb@laptop.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 00/14] DMA Engine support for AM33XX
Message-ID: <20130123204917.GA5256@beef>
References: <1358281974-8411-1-git-send-email-mporter@ti.com>
 <50FFC48B.80902@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50FFC48B.80902@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 04:37:55PM +0530, Santosh Shilimkar wrote:
> Matt,
> 
> On Wednesday 16 January 2013 02:02 AM, Matt Porter wrote:
> 
> [..]
> 
> >This series adds DMA Engine support for AM33xx, which uses
> >an EDMA DMAC. The EDMA DMAC has been previously supported by only
> >a private API implementation (much like the situation with OMAP
> >DMA) found on the DaVinci family of SoCs.
> >
> >The series applies on top of 3.8-rc3 and the following patches:
> >
> >	- TPS65910 REGMAP_IRQ build fix:
> >	  https://patchwork.kernel.org/patch/1857701/
> >	- dmaengine DT support from Vinod's dmaengine_dt branch in
> >	  git://git.infradead.org/users/vkoul/slave-dma.git since
> >	  027478851791df751176398be02a3b1c5f6aa824
> >	- edma dmaengine driver fix:
> >	  https://patchwork.kernel.org/patch/1961521/
> >	- dmaengine dma_get_channel_caps v2:
> >	  https://patchwork.kernel.org/patch/1961601/
> >	- dmaengine edma driver channel caps support v2:
> >	  https://patchwork.kernel.org/patch/1961591/
> >
> >The approach taken is similar to how OMAP DMA is being converted to
> >DMA Engine support. With the functional EDMA private API already
> >existing in mach-davinci/dma.c, we first move that to an ARM common
> >area so it can be shared. Adding DT and runtime PM support to the
> >private EDMA API implementation allows it to run on AM33xx. AM33xx
> >*only* boots using DT so we leverage Jon's generic DT DMA helpers to
> >register EDMA DMAC with the of_dma framework and then add support
> >for calling the dma_request_slave_channel() API to both the mmc
> >and spi drivers.
> >
> >With this series both BeagleBone and the AM335x EVM have working
> >MMC and SPI support.
> >
> >This is tested on BeagleBone with a SPI framebuffer driver and MMC
> >rootfs. A trivial gpio DMA event misc driver was used to test the
> >crossbar DMA event support. It is also tested on the AM335x EVM
> >with the onboard SPI flash and MMC rootfs. The branch at
> >https://github.com/ohporter/linux/tree/edma-dmaengine-am33xx-v4
> >has the complete series, dependencies, and some test
> >drivers/defconfigs.
> >
> >Regression testing was done on AM180x-EVM (which also makes use
> >of the EDMA dmaengine driver and the EDMA private API) using SD,
> >SPI flash, and the onboard audio supported by the ASoC Davinci
> >driver. Regression testing was also done on a BeagleBoard xM
> >booting from the legacy board file using MMC rootfs.
> >
> >Matt Porter (14):
> >   ARM: davinci: move private EDMA API to arm/common
> >   ARM: edma: remove unused transfer controller handlers
> >   ARM: edma: add AM33XX support to the private EDMA API
> >   dmaengine: edma: enable build for AM33XX
> >   dmaengine: edma: Add TI EDMA device tree binding
> >   ARM: dts: add AM33XX EDMA support
> >   dmaengine: add dma_request_slave_channel_compat()
> >   mmc: omap_hsmmc: convert to dma_request_slave_channel_compat()
> >   mmc: omap_hsmmc: set max_segs based on dma engine limitations
> >   mmc: omap_hsmmc: add generic DMA request support to the DT binding
> >   ARM: dts: add AM33XX MMC support
> >   spi: omap2-mcspi: convert to dma_request_slave_channel_compat()
> >   spi: omap2-mcspi: add generic DMA request support to the DT binding
> >   ARM: dts: add AM33XX SPI DMA support
> >
> While going through the series and testing it out, I observed an issue
> with MMC driver. You need patch in the end of the email to avoid the
> issue. Same is attached in case mailer damages it. Can you please
> add it with your series if you agree ?

Yes, by inspection this makes sense. As you noticed, we've been relying
on the fact that DMA resources still don't come from DT, we only use our
DT data in conjunction with the DMA OF helpers to do channel filtering.
I was figuring we would address that separately later, but I see how
even omap4 has this issue with DMA resources named with "tx1", for
example. A good followup once this series is taken will be to only
use hwmod resources on a !populated-dt platform like we do for other
resources now. Baby steps. :)

Thanks for the catch, I'll add this in with your tested line as well for
the series. 

-Matt

> 
> Overall the series looks good to my eyes.
> Acked-tested-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> 
> Regards,
> Santosh
> 
> From 2dcc90b7a4b2dcdb52ddd052ca7f3e88a78e83e4 Mon Sep 17 00:00:00 2001
> From: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Date: Wed, 23 Jan 2013 16:04:32 +0530
> Subject: [PATCH] mmc: omap_hsmmc: Skip platform_get_resource_byname() for dt
>  case
> 
> MMC driver probe will abort for DT case because of failed
> platform_get_resource_byname() lookup. Fix it by skipping resource
> byname lookup for device tree build.
> 
> Issue is hidden because hwmod popullates the IO resources which
> helps to succeed platform_get_resource_byname() and probe.
> 
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> ---
>  drivers/mmc/host/omap_hsmmc.c |   28 +++++++++++++++-------------
>  1 file changed, 15 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index f74bd69..d4655e7 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -1897,21 +1897,23 @@ static int omap_hsmmc_probe(struct
> platform_device *pdev)
> 
>  	omap_hsmmc_conf_bus_power(host);
> 
> -	res = platform_get_resource_byname(pdev, IORESOURCE_DMA, "tx");
> -	if (!res) {
> -		dev_err(mmc_dev(host->mmc), "cannot get DMA TX channel\n");
> -		ret = -ENXIO;
> -		goto err_irq;
> -	}
> -	tx_req = res->start;
> +	if (!pdev->dev.of_node) {
> +		res = platform_get_resource_byname(pdev, IORESOURCE_DMA, "tx");
> +		if (!res) {
> +			dev_err(mmc_dev(host->mmc), "cannot get DMA TX channel\n");
> +			ret = -ENXIO;
> +			goto err_irq;
> +		}
> +		tx_req = res->start;
> 
> -	res = platform_get_resource_byname(pdev, IORESOURCE_DMA, "rx");
> -	if (!res) {
> -		dev_err(mmc_dev(host->mmc), "cannot get DMA RX channel\n");
> -		ret = -ENXIO;
> -		goto err_irq;
> +		res = platform_get_resource_byname(pdev, IORESOURCE_DMA, "rx");
> +		if (!res) {
> +			dev_err(mmc_dev(host->mmc), "cannot get DMA RX channel\n");
> +			ret = -ENXIO;
> +			goto err_irq;
> +		}
> +		rx_req = res->start;
>  	}
> -	rx_req = res->start;
> 
>  	dma_cap_zero(mask);
>  	dma_cap_set(DMA_SLAVE, mask);
> -- 
> 1.7.9.5
> 
> 
> 
> 

> >From 2dcc90b7a4b2dcdb52ddd052ca7f3e88a78e83e4 Mon Sep 17 00:00:00 2001
> From: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Date: Wed, 23 Jan 2013 16:04:32 +0530
> Subject: [PATCH] mmc: omap_hsmmc: Skip platform_get_resource_byname() for dt
>  case
> 
> MMC driver probe will abort for DT case because of failed
> platform_get_resource_byname() lookup. Fix it by skipping resource
> byname lookup for device tree build.
> 
> Issue is hidden because hwmod popullates the IO resources which
> helps to succeed platform_get_resource_byname() and probe.
> 
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> ---
>  drivers/mmc/host/omap_hsmmc.c |   28 +++++++++++++++-------------
>  1 file changed, 15 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index f74bd69..d4655e7 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -1897,21 +1897,23 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
>  
>  	omap_hsmmc_conf_bus_power(host);
>  
> -	res = platform_get_resource_byname(pdev, IORESOURCE_DMA, "tx");
> -	if (!res) {
> -		dev_err(mmc_dev(host->mmc), "cannot get DMA TX channel\n");
> -		ret = -ENXIO;
> -		goto err_irq;
> -	}
> -	tx_req = res->start;
> +	if (!pdev->dev.of_node) {
> +		res = platform_get_resource_byname(pdev, IORESOURCE_DMA, "tx");
> +		if (!res) {
> +			dev_err(mmc_dev(host->mmc), "cannot get DMA TX channel\n");
> +			ret = -ENXIO;
> +			goto err_irq;
> +		}
> +		tx_req = res->start;
>  
> -	res = platform_get_resource_byname(pdev, IORESOURCE_DMA, "rx");
> -	if (!res) {
> -		dev_err(mmc_dev(host->mmc), "cannot get DMA RX channel\n");
> -		ret = -ENXIO;
> -		goto err_irq;
> +		res = platform_get_resource_byname(pdev, IORESOURCE_DMA, "rx");
> +		if (!res) {
> +			dev_err(mmc_dev(host->mmc), "cannot get DMA RX channel\n");
> +			ret = -ENXIO;
> +			goto err_irq;
> +		}
> +		rx_req = res->start;
>  	}
> -	rx_req = res->start;
>  
>  	dma_cap_zero(mask);
>  	dma_cap_set(DMA_SLAVE, mask);
> -- 
> 1.7.9.5
> 

> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source

