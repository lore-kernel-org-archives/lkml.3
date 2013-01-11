Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab3AKRxm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 12:53:42 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:14132 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754976Ab3AKRxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 12:53:39 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19KyeId38zR+iXfnh79/UPN
Date: Fri, 11 Jan 2013 09:53:30 -0800
From: Tony Lindgren <tony@atomide.com>
To: Matt Porter <mporter@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>, Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>, Dan Williams <djbw@fb.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH v4 09/14] mmc: omap_hsmmc: set max_segs based on dma
 engine limitations
Message-ID: <20130111175330.GH14149@atomide.com>
References: <1357883330-5364-1-git-send-email-mporter@ti.com>
 <1357883330-5364-10-git-send-email-mporter@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357883330-5364-10-git-send-email-mporter@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matt Porter <mporter@ti.com> [130110 21:47]:
> The EDMA DMAC has a hardware limitation that prevents supporting
> scatter gather lists with any number of segments. The DMA Engine
> API reports the maximum number of segments a channel can support
> via the optional dma_get_channel_caps() API. If the nr_segs
> capability is present, the value is used to configure mmc->max_segs
> appropriately.

Acked-by: Tony Lindgren <tony@atomide.com>
 
> Signed-off-by: Matt Porter <mporter@ti.com>
> ---
>  drivers/mmc/host/omap_hsmmc.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index e79b12d..f74bd69 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -1769,6 +1769,7 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
>  	const struct of_device_id *match;
>  	dma_cap_mask_t mask;
>  	unsigned tx_req, rx_req;
> +	struct dmaengine_chan_caps *dma_chan_caps;
>  	struct pinctrl *pinctrl;
>  
>  	match = of_match_device(of_match_ptr(omap_mmc_of_match), &pdev->dev);
> @@ -1935,6 +1936,11 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
>  		goto err_irq;
>  	}
>  
> +	/* Some DMA Engines only handle a limited number of SG segments */
> +	dma_chan_caps = dma_get_channel_caps(host->rx_chan, DMA_DEV_TO_MEM);
> +	if (dma_chan_caps && dma_chan_caps->seg_nr)
> +		mmc->max_segs = dma_chan_caps->seg_nr;
> +
>  	/* Request IRQ for MMC operations */
>  	ret = request_irq(host->irq, omap_hsmmc_irq, 0,
>  			mmc_hostname(mmc), host);
> -- 
> 1.7.9.5
> 
