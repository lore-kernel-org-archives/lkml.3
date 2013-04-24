Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab3DXCcq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 22:32:46 -0400
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:56739
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757072Ab3DXCcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 22:32:45 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz17326ah8275bh8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 24 Apr 2013 09:11:55 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] ASoC: don't call of_dma_request_slave_channel directly
Message-ID: <20130424011153.GA2319@shlinux1.ap.freescale.net>
References: <1366732475-479886-1-git-send-email-arnd@arndb.de>
 <1366732475-479886-3-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1366732475-479886-3-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 05:54:33PM +0200, Arnd Bergmann wrote:
> The exported interface for device drivers is dma_request_slave_channel,
> not of_dma_request_slave_channel. The former does not depend on device
> tree but also works with ACPI and other interfaces providing an
> abstraction for DMA channels.
> 
> This fixes link errors when building ALSA as a loadable module.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

I had already sent a similar patch [1] for that.

Shawn

[1] http://thread.gmane.org/gmane.linux.alsa.devel/107568/

> Cc: alsa-devel@alsa-project.org
> Cc: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  sound/soc/soc-generic-dmaengine-pcm.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/sound/soc/soc-generic-dmaengine-pcm.c b/sound/soc/soc-generic-dmaengine-pcm.c
> index 5fd5ed4..8ee9859 100644
> --- a/sound/soc/soc-generic-dmaengine-pcm.c
> +++ b/sound/soc/soc-generic-dmaengine-pcm.c
> @@ -219,19 +219,20 @@ static const char * const dmaengine_pcm_dma_channel_names[] = {
>  };
>  
>  static void dmaengine_pcm_request_chan_of(struct dmaengine_pcm *pcm,
> -	struct device_node *of_node)
> +	struct device *dev)
>  {
>  	unsigned int i;
> +	struct device_node *of_node = dev->of_node;
>  
>  	if ((pcm->flags & SND_DMAENGINE_PCM_FLAG_NO_DT) || !of_node)
>  		return;
>  
>  	if (pcm->flags & SND_DMAENGINE_PCM_FLAG_HALF_DUPLEX) {
> -		pcm->chan[0] = of_dma_request_slave_channel(of_node, "tx_rx");
> +		pcm->chan[0] = dma_request_slave_channel(dev, "tx_rx");
>  		pcm->chan[1] = pcm->chan[0];
>  	} else {
>  		for (i = SNDRV_PCM_STREAM_PLAYBACK; i <= SNDRV_PCM_STREAM_CAPTURE; i++) {
> -			pcm->chan[i] = of_dma_request_slave_channel(of_node,
> +			pcm->chan[i] = dma_request_slave_channel(dev,
>  					dmaengine_pcm_dma_channel_names[i]);
>  		}
>  	}
> @@ -255,7 +256,7 @@ int snd_dmaengine_pcm_register(struct device *dev,
>  	pcm->config = config;
>  	pcm->flags = flags;
>  
> -	dmaengine_pcm_request_chan_of(pcm, dev->of_node);
> +	dmaengine_pcm_request_chan_of(pcm, dev);
>  
>  	if (flags & SND_DMAENGINE_PCM_FLAG_NO_RESIDUE)
>  		return snd_soc_add_platform(dev, &pcm->platform,
> -- 
> 1.8.1.2
> 

