Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254AbaABSDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 13:03:49 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:57180 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbaABSDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 13:03:47 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Florian Meier <florian.meier@koalo.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        devicetree <devicetree@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCHv9] dmaengine: Add support for BCM2835
Date: Thu, 02 Jan 2014 19:03:34 +0100
Message-ID: <1964639.FVztRK0HBK@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <52C5A6A3.8000405@koalo.de>
References: <52C5A6A3.8000405@koalo.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:bPuBWxPD+yXUNwiR7Uj2p+cwXcxBU8TlrPFvOMZTNPL
 eXk/us8N9mXD/9+/Qn9hn4m24bD2NE/vpRlVGrlmT4G6K9Ijif
 Ovv7xO9bDvUkDqZIkMjKQ2pG1AjEusSrNmREn36b0lDLatU3op
 I3LxAmsTt4TRB4/uBbO4mnzI/1hjP1fifyxBg0cugME+KF5amk
 mO6eh2yV+aiDh3ZSiNqBuU+dZOPIljlfIPLUAFso+PtdmbVVQd
 8jT41dONEVDHgkodUc0f9d73JUunZZmDW4xC6wmWHraEiEYyDE
 hOR6AIFxxyoaX1ETdAtiYfgUOWI5Rv1H+8fEQx6VTWSBfitNAv
 Vey08hjbnv+P3zUrwC0U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 January 2014 18:49:23 Florian Meier wrote:
> Add support for DMA controller of BCM2835 as used in the Raspberry Pi.
> Currently it only supports cyclic DMA.

Looks very nice. Just a few details I noticed:

> +#if defined(CONFIG_OF)
> +static const struct of_device_id bcm2835_dma_of_match[] = {
> +	{ .compatible = "brcm,bcm2835-dma", },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, bcm2835_dma_of_match);
> +#endif

I doubt we are going to see non-DT versions of this driver, so the #ifdef
can just get removed here.

> +static struct dma_chan *bcm2835_dma_xlate(struct of_phandle_args *spec,
> +					   struct of_dma *ofdma)
> +{
> +	struct bcm2835_dmadev *d = ofdma->of_dma_data;
> +	struct dma_chan *chan, *candidate;
> +
> +retry:
> +	candidate = NULL;
> +
> +	/*
> +	 * Walk the list of channels registered with the current instance and
> +	 * find one that is currently unused.
> +	 */
> +	list_for_each_entry(chan, &d->ddev.channels, device_node)
> +		if (chan->client_count == 0) {
> +			candidate = chan;
> +			break;
> +		}
> +
> +	if (!candidate)
> +		return NULL;
> +
> +	/*
> +	 * dma_get_slave_channel will return NULL if we lost a race between
> +	 * the lookup and the reservation.
> +	 */
> +	chan = dma_get_slave_channel(candidate);
> +
> +	if (!chan)
> +		goto retry;
> +
> +	/* Set DREQ from param */
> +	to_bcm2835_dma_chan(chan)->dreq = spec->args[0];
> +
> +	return chan;
> +}

This can now be simplified using the dma_get_any_slave_channel() interface
taht Stephen Warren introduced.

> +
> +	if (!pdev->dev.dma_mask)
> +		pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
> +
> +	rc = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
> +	if (rc)
> +		return rc;
> +	dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));

dma_set_mask_and_coherent()

> +	if (pdev->dev.of_node) {
> +		/* Device-tree DMA controller registration */
> +		rc = of_dma_controller_register(pdev->dev.of_node,
> +				bcm2835_dma_xlate, od);
> +		if (rc) {
> +			dev_err(&pdev->dev, "Failed to register DMA controller\n");
> +			goto err_no_dma;
> +		}
> +	}

If pdev->dev.of_node isn't set, you didn't get here, so the if() can be removed.

	Arnd
