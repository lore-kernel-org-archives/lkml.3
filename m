Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab3EaPMx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:12:53 -0400
Received: from 20.mo5.mail-out.ovh.net ([91.121.55.239]:57918 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753336Ab3EaPMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:12:44 -0400
X-Greylist: delayed 62918 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 May 2013 11:12:44 EDT
Date: Fri, 31 May 2013 17:08:33 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH 1/2] spi: atmel: convert to
 dma_request_slave_channel_compat()
Message-ID: <20130531150833.GF23653@game.jcrosoft.org>
References: <1370012520-30539-1-git-send-email-richard.genoud@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370012520-30539-1-git-send-email-richard.genoud@gmail.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 13693194667629783973
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrvddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrvddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:01 Fri 31 May     , Richard Genoud wrote:
> Use generic DMA DT helper.
> Platforms booting with or without DT populated are both supported.
> 
> Based on Ludovic Desroches <ludovic.desroches@atmel.com> patchset
> "ARM: at91: move to generic DMA device tree binding"
> 
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>

Ludo please take a look but this looks ok to me

Best Regards,
J.
> ---
>  drivers/spi/spi-atmel.c |   42 +++++++++++++++++++++++++++---------------
>  1 file changed, 27 insertions(+), 15 deletions(-)
> 
> rebased on linux-next next-20130531
> 
> diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
> index 31cfc87..ea1ec00 100644
> --- a/drivers/spi/spi-atmel.c
> +++ b/drivers/spi/spi-atmel.c
> @@ -424,10 +424,15 @@ static int atmel_spi_dma_slave_config(struct atmel_spi *as,
>  	return err;
>  }
>  
> -static bool filter(struct dma_chan *chan, void *slave)
> +static bool filter(struct dma_chan *chan, void *pdata)
>  {
> -	struct	at_dma_slave *sl = slave;
> +	struct atmel_spi_dma *sl_pdata = pdata;
> +	struct at_dma_slave *sl;
>  
> +	if (!sl_pdata)
> +		return false;
> +
> +	sl = &sl_pdata->dma_slave;
>  	if (sl->dma_dev == chan->device->dev) {
>  		chan->private = sl;
>  		return true;
> @@ -438,24 +443,31 @@ static bool filter(struct dma_chan *chan, void *slave)
>  
>  static int atmel_spi_configure_dma(struct atmel_spi *as)
>  {
> -	struct at_dma_slave *sdata = &as->dma.dma_slave;
>  	struct dma_slave_config	slave_config;
> +	struct device *dev = &as->pdev->dev;
>  	int err;
>  
> -	if (sdata && sdata->dma_dev) {
> -		dma_cap_mask_t mask;
> +	dma_cap_mask_t mask;
> +	dma_cap_zero(mask);
> +	dma_cap_set(DMA_SLAVE, mask);
>  
> -		/* Try to grab two DMA channels */
> -		dma_cap_zero(mask);
> -		dma_cap_set(DMA_SLAVE, mask);
> -		as->dma.chan_tx = dma_request_channel(mask, filter, sdata);
> -		if (as->dma.chan_tx)
> -			as->dma.chan_rx =
> -				dma_request_channel(mask, filter, sdata);
> +	as->dma.chan_tx = dma_request_slave_channel_compat(mask, filter,
> +							   &as->dma,
> +							   dev, "tx");
> +	if (!as->dma.chan_tx) {
> +		dev_err(dev,
> +			"DMA TX channel not available, SPI unable to use DMA\n");
> +		err = -EBUSY;
> +		goto error;
>  	}
> -	if (!as->dma.chan_rx || !as->dma.chan_tx) {
> -		dev_err(&as->pdev->dev,
> -			"DMA channel not available, SPI unable to use DMA\n");
> +
> +	as->dma.chan_rx = dma_request_slave_channel_compat(mask, filter,
> +							   &as->dma,
> +							   dev, "rx");
> +
> +	if (!as->dma.chan_rx) {
> +		dev_err(dev,
> +			"DMA RX channel not available, SPI unable to use DMA\n");
>  		err = -EBUSY;
>  		goto error;
>  	}
> -- 
> 1.7.10.4
> 
