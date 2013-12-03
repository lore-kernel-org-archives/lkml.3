Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab3LCIbW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 03:31:22 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:38235 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab3LCIbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 03:31:21 -0500
Date: Tue, 3 Dec 2013 08:31:16 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, broonie@kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [alsa-devel] [PATCH 1/3] ASoC: ux500_pcm: Stop pretending that
 we support varying address widths
Message-ID: <20131203083116.GA11828@lee--X1>
References: <1386007222-10081-1-git-send-email-lee.jones@linaro.org>
 <529CD2B5.9060905@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <529CD2B5.9060905@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Dec 2013, Lars-Peter Clausen wrote:

> On 12/02/2013 07:00 PM, Lee Jones wrote:
> > The Slave Config's addr_width attribute is populated by data_width of
> > dma_cfg, which in turn is derived from dma_params' data_size attribute
> > and that comes from the slot_width which is always 16 bits (2 Bytes).
> > We're cutting out the middle man here and just setting the DMA Slave
> > Config directly.
> > 
> > Cc: alsa-devel@alsa-project.org
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Patch looks good. But as a follow up patch I think you can now switch to the
> generic snd_dmaengine_pcm_prepare_slave_config.

No, I don't think we can. Your version only populates the DMA settings
for the correct stream (Playback OR Capture), but our DMA Controller
requires both source and destination to be setup.

> > ---
> >  sound/soc/ux500/ux500_pcm.c | 13 ++++++-------
> >  1 file changed, 6 insertions(+), 7 deletions(-)
> > 
> > diff --git a/sound/soc/ux500/ux500_pcm.c b/sound/soc/ux500/ux500_pcm.c
> > index 6162f70..2f1bdb7 100644
> > --- a/sound/soc/ux500/ux500_pcm.c
> > +++ b/sound/soc/ux500/ux500_pcm.c
> > @@ -104,26 +104,25 @@ static int ux500_pcm_prepare_slave_config(struct snd_pcm_substream *substream,
> >  		struct dma_slave_config *slave_config)
> >  {
> >  	struct snd_soc_pcm_runtime *rtd = substream->private_data;
> > -	struct ux500_msp_dma_params *dma_params;
> > -	struct stedma40_chan_cfg *dma_cfg;
> > +	struct snd_dmaengine_dai_dma_data *dma_params;
> >  	int ret;
> >  
> >  	dma_params = snd_soc_dai_get_dma_data(rtd->cpu_dai, substream);
> > -	dma_cfg = dma_params->dma_cfg;
> >  
> >  	ret = snd_hwparams_to_dma_slave_config(substream, params, slave_config);
> >  	if (ret)
> >  		return ret;
> >  
> >  	slave_config->dst_maxburst = 4;
> > -	slave_config->dst_addr_width = dma_cfg->dst_info.data_width;
> >  	slave_config->src_maxburst = 4;
> > -	slave_config->src_addr_width = dma_cfg->src_info.data_width;
> > +
> > +	slave_config->src_addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
> > +	slave_config->dst_addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
> >  
> >  	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
> > -		slave_config->dst_addr = dma_params->tx_rx_addr;
> > +		slave_config->dst_addr = dma_params->addr;
> >  	else
> > -		slave_config->src_addr = dma_params->tx_rx_addr;
> > +		slave_config->src_addr = dma_params->addr;
> >  
> >  	return 0;
> >  }
> > 
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
