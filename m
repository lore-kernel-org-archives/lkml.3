Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab3HEUuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 16:50:21 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64002 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab3HEUuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 16:50:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Jensen <jonas.jensen@gmail.com>
Subject: Re: [PATCH v7] dmaengine: Add MOXA ART DMA engine driver
Date: Mon, 5 Aug 2013 22:49:31 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, vinod.koul@intel.com, djbw@fb.com,
        linux@arm.linux.org.uk, mark.rutland@arm.com
References: <1375450125-29767-1-git-send-email-jonas.jensen@gmail.com> <1375713457-5562-1-git-send-email-jonas.jensen@gmail.com>
In-Reply-To: <1375713457-5562-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201308052249.32174.arnd@arndb.de>
X-Provags-ID: V02:K0:nVYIYQx/gQFyYuE7JkfQV5CIL/3x/13l/l2DwB6KCB7
 YavnV1J81eHsIjXmlPHUTOgOZJcZQSmh9q3SkBk8C3akxly7Gs
 y4ntJhXX6fc9JL9KEn9VNv9AFX33kBZDBppxIWNpfR7BKn2JxA
 rWsS+FWHd54emYC+DDQ+fN30tseBc5E8nLzIHA5m356TFoPMfp
 f5Wt/QoZfh0l8m28Tkdyi+Wctkj3IS3vDJls63zrw29rzAXtv7
 4LbRVIgX1dZtB+f8EaKBpM3hDj+EBLouaE3FDhBHMKUSqNq9c/
 ruMqmesfHCnFA0hOyBiqIQgFJfxkVSNZTUSnzUnB6VSlIFYnk4
 bwnYr0J9rInOWbcAxzD0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 August 2013, Jonas Jensen wrote:

> +bool moxart_dma_filter_fn(struct dma_chan *chan, void *param)
> +{
> +	struct moxart_dma_chan *mchan = to_moxart_dma_chan(chan);
> +	struct moxart_dma_container *mc = to_dma_container(mchan->chan.device);
> +
> +	if (chan->device->dev == mc->dma_slave.dev) {

This comparison seems rather pointless -- you only check that the
device owning the channel is the same as the device that belongs
to channel's "container", which would naturally be the case.

What you don't check here is that it matches the device that was passed
to of_dma_controller_register().

> +		struct moxart_dma_chan *mchan = to_moxart_dma_chan(chan);
> +		unsigned int ch_req = *(unsigned int *)param;
> +		dev_dbg(chan2dev(chan), "%s: mchan=%p ch_req=%d mchan->ch_num=%d\n",
> +			__func__, mchan, ch_req, mchan->ch_num);
> +		return ch_req == mchan->ch_num;
> +	} else {
> +		dev_dbg(chan2dev(chan), "%s: device not registered to this DMA engine\n",
> +			__func__);
> +		return false;
> +	}
> +}
> +
> +static struct of_dma_filter_info moxart_dma_info = {
> +	.filter_fn = moxart_dma_filter_fn,
> +};
> +
> +static struct dma_chan *moxart_of_xlate(struct of_phandle_args *dma_spec,
> +					struct of_dma *ofdma)
> +{
> +	struct dma_chan *chan;
> +	struct of_dma_filter_info *info = ofdma->of_dma_data;
> +
> +	if (!info || !info->filter_fn)
> +		return NULL;

This seems pointless too. Why do you pass a of_dma_filter_info pointer
as ofdma->of_dma_data? It's constant after all and you can just access
it a couple of lines higher.

> +	if (dma_spec->args_count != 2)
> +		return NULL;
> +
> +	chan = dma_request_channel(info->dma_cap, info->filter_fn,
> +				   &dma_spec->args[0]);

The filter function is also constant. However, you need to pass the
device pointer here so the filter can compare it.

> +	if (chan)
> +		to_moxart_dma_chan(chan)->line = dma_spec->args[1];
> +
> +	return chan;
> +}

There is still an open question here regarding whether or not the
channel number is actually required to be fixed or not. In most
dma engines, the channels are actually interchangeable, so you only
need to specify the request number, not the channel. Does this still
work if you just pick the first

	Arnd
