Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab3LBSdx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 13:33:53 -0500
Received: from smtp-out-003.synserver.de ([212.40.185.3]:1054 "EHLO
	smtp-out-110.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752182Ab3LBSdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 13:33:51 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 18010
Message-ID: <529CD2B5.9060905@metafoo.de>
Date: Mon, 02 Dec 2013 19:34:29 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, broonie@kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [alsa-devel] [PATCH 1/3] ASoC: ux500_pcm: Stop pretending that
 we support varying address widths
References: <1386007222-10081-1-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1386007222-10081-1-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2013 07:00 PM, Lee Jones wrote:
> The Slave Config's addr_width attribute is populated by data_width of
> dma_cfg, which in turn is derived from dma_params' data_size attribute
> and that comes from the slot_width which is always 16 bits (2 Bytes).
> We're cutting out the middle man here and just setting the DMA Slave
> Config directly.
> 
> Cc: alsa-devel@alsa-project.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Patch looks good. But as a follow up patch I think you can now switch to the
generic snd_dmaengine_pcm_prepare_slave_config.

> ---
>  sound/soc/ux500/ux500_pcm.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/sound/soc/ux500/ux500_pcm.c b/sound/soc/ux500/ux500_pcm.c
> index 6162f70..2f1bdb7 100644
> --- a/sound/soc/ux500/ux500_pcm.c
> +++ b/sound/soc/ux500/ux500_pcm.c
> @@ -104,26 +104,25 @@ static int ux500_pcm_prepare_slave_config(struct snd_pcm_substream *substream,
>  		struct dma_slave_config *slave_config)
>  {
>  	struct snd_soc_pcm_runtime *rtd = substream->private_data;
> -	struct ux500_msp_dma_params *dma_params;
> -	struct stedma40_chan_cfg *dma_cfg;
> +	struct snd_dmaengine_dai_dma_data *dma_params;
>  	int ret;
>  
>  	dma_params = snd_soc_dai_get_dma_data(rtd->cpu_dai, substream);
> -	dma_cfg = dma_params->dma_cfg;
>  
>  	ret = snd_hwparams_to_dma_slave_config(substream, params, slave_config);
>  	if (ret)
>  		return ret;
>  
>  	slave_config->dst_maxburst = 4;
> -	slave_config->dst_addr_width = dma_cfg->dst_info.data_width;
>  	slave_config->src_maxburst = 4;
> -	slave_config->src_addr_width = dma_cfg->src_info.data_width;
> +
> +	slave_config->src_addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
> +	slave_config->dst_addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
>  
>  	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
> -		slave_config->dst_addr = dma_params->tx_rx_addr;
> +		slave_config->dst_addr = dma_params->addr;
>  	else
> -		slave_config->src_addr = dma_params->tx_rx_addr;
> +		slave_config->src_addr = dma_params->addr;
>  
>  	return 0;
>  }
> 

