Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab3KQQCR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 11:02:17 -0500
Received: from smtprelay0139.hostedemail.com ([216.40.44.139]:50644 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754165Ab3KQQCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 11:02:09 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2538:2559:2562:2693:2828:3138:3139:3140:3141:3142:3354:3622:3865:3866:3868:3870:3871:3872:3874:4250:4321:5007:7652:9010:10004:10400:10848:11026:11232:11473:11
X-HE-Tag: wind51_1231bd7cbdd08
X-Filterd-Recvd-Size: 3122
Message-ID: <1384704123.2727.8.camel@joe-AO722>
Subject: Re: [PATCHv7] dmaengine: Add support for BCM2835
From: Joe Perches <joe@perches.com>
To: Florian Meier <florian.meier@koalo.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree <devicetree@vger.kernel.org>, alsa-devel@alsa-project.org,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Date: Sun, 17 Nov 2013 08:02:03 -0800
In-Reply-To: <5288E327.8050809@koalo.de>
References: <5288E327.8050809@koalo.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-11-17 at 16:39 +0100, Florian Meier wrote:
> Add support for DMA controller of BCM2835 as used in the Raspberry Pi.
> Currently it only supports cyclic DMA.
[]
> diff --git a/drivers/dma/bcm2835-dma.c b/drivers/dma/bcm2835-dma.c
[]
> +static int bcm2835_dma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
> +	unsigned long arg)
> +{
> +	struct bcm2835_chan *c = to_bcm2835_dma_chan(chan);
> +	int ret;
> +
> +	switch (cmd) {
> +	case DMA_SLAVE_CONFIG:
> +		return bcm2835_dma_slave_config(c,
> +				(struct dma_slave_config *)arg);
> +
> +	case DMA_TERMINATE_ALL:
> +		bcm2835_dma_terminate_all(c);
> +		break;
> +
> +	default:
> +		ret = -ENXIO;
> +		break;
> +	}
> +
> +	return ret;
> +}

case DMA_TERMINATE_ALL returns an uninitialized ret;

[]

> +static struct dma_chan *bcm2835_dma_xlate(struct of_phandle_args *spec,
> +					   struct of_dma *ofdma)
> +{
> +	struct bcm2835_dmadev *d = ofdma->of_dma_data;
> +	struct dma_chan *chan, *candidate;
> +
> +retry:
> +	candidate = NULL;
> +
> +	/* Walk the list of channels registered with the current instance and
> +	 * find one that is currently unused */
> +	list_for_each_entry(chan, &d->ddev.channels, device_node)
> +		if (chan->client_count == 0) {
> +			candidate = chan;
> +			break;
> +		}
> +
> +	if (!candidate)
> +		return NULL;
> +
> +	/* dma_get_slave_channel will return NULL if we lost a race between
> +	 * the lookup and the reservation */
> +	chan = dma_get_slave_channel(candidate);

Can that race happen consistently?
Does this avoid being a tight loop?

> +	if (chan) {
> +		struct bcm2835_chan *c = to_bcm2835_dma_chan(chan);
> +
> +		/* Set DREQ from param */
> +		c->dreq = spec->args[0];
> +
> +		return chan;
> +	}
> +
> +	goto retry;
> +}

Also, I think this would be better as:

	if (!chan)
		goto retry;

	to_bcm2835_dma_chan(chan)->dreq = spec->args[0];

	return chan;
}

