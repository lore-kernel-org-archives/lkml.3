Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273Ab3DSRm1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 13:42:27 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:45601 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab3DSRm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 13:42:26 -0400
Message-ID: <51718209.4000809@gmail.com>
Date: Fri, 19 Apr 2013 19:42:33 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Michal Bachraty <michal.bachraty@streamunlimited.com>
CC: perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, marek.belisko@streamunlimited.com,
        broonie@opensource.wolfsonmicro.com, lgirdwood@gmail.com
Subject: Re: [alsa-devel] [PATCH 1/2] ALSA: ASoC davinci-pcm, davinci-mcasp
 Clean up active_serializers
References: <1366378083-14325-1-git-send-email-michal.bachraty@streamunlimited.com>
In-Reply-To: <1366378083-14325-1-git-send-email-michal.bachraty@streamunlimited.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.04.2013 15:28, Michal Bachraty wrote:
> As pointed of by Vaibhav, commit message: "ASoC: davinci-mcasp: Add support for multichannel playback"
> number of active serializers can be hidden into fifo_level variable, which is set in davimci-mcasp.

You need to reformat the commit log so it does not exceed 80 characters
per line. Also, as you're on it, you can omit "ALSA" in the subject and
add two colons (after 'ASoC' and 'mcasp') for better readability.

Other than that, looks good to me. I've been using that patch for a
while now and it works fine for me.


Thanks,
Daniel


> 
> Signed-off-by: Michal Bachraty <michal.bachraty@streamunlimited.com>
> ---
>  sound/soc/davinci/davinci-mcasp.c |    8 +++++---
>  sound/soc/davinci/davinci-pcm.c   |   11 +++++------
>  sound/soc/davinci/davinci-pcm.h   |    1 -
>  3 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/sound/soc/davinci/davinci-mcasp.c b/sound/soc/davinci/davinci-mcasp.c
> index 8a9c0ee..63633e9 100644
> --- a/sound/soc/davinci/davinci-mcasp.c
> +++ b/sound/soc/davinci/davinci-mcasp.c
> @@ -834,17 +834,20 @@ static int davinci_mcasp_hw_params(struct snd_pcm_substream *substream,
>  	int word_length;
>  	u8 fifo_level;
>  	u8 slots = dev->tdm_slots;
> +	u8 active_serializers;
>  	int channels;
>  	struct snd_interval *pcm_channels = hw_param_interval(params,
>  					SNDRV_PCM_HW_PARAM_CHANNELS);
>  	channels = pcm_channels->min;
>  
> +	active_serializers = (channels + slots - 1) / slots;
> +
>  	if (davinci_hw_common_param(dev, substream->stream, channels) == -EINVAL)
>  		return -EINVAL;
>  	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
> -		fifo_level = dev->txnumevt;
> +		fifo_level = dev->txnumevt * active_serializers;
>  	else
> -		fifo_level = dev->rxnumevt;
> +		fifo_level = dev->rxnumevt * active_serializers;
>  
>  	if (dev->op_mode == DAVINCI_MCASP_DIT_MODE)
>  		davinci_hw_dit_param(dev);
> @@ -889,7 +892,6 @@ static int davinci_mcasp_hw_params(struct snd_pcm_substream *substream,
>  		dma_params->acnt = dma_params->data_type;
>  
>  	dma_params->fifo_level = fifo_level;
> -	dma_params->active_serializers = (channels + slots - 1) / slots;
>  	davinci_config_channel_size(dev, word_length);
>  
>  	return 0;
> diff --git a/sound/soc/davinci/davinci-pcm.c b/sound/soc/davinci/davinci-pcm.c
> index 0161579..8460edc 100644
> --- a/sound/soc/davinci/davinci-pcm.c
> +++ b/sound/soc/davinci/davinci-pcm.c
> @@ -182,7 +182,6 @@ static void davinci_pcm_enqueue_dma(struct snd_pcm_substream *substream)
>  	unsigned short acnt;
>  	unsigned int count;
>  	unsigned int fifo_level;
> -	unsigned char serializers = prtd->params->active_serializers;
>  
>  	period_size = snd_pcm_lib_period_bytes(substream);
>  	dma_offset = prtd->period * period_size;
> @@ -196,14 +195,14 @@ static void davinci_pcm_enqueue_dma(struct snd_pcm_substream *substream)
>  	data_type = prtd->params->data_type;
>  	count = period_size / data_type;
>  	if (fifo_level)
> -		count /= fifo_level * serializers;
> +		count /= fifo_level;
>  
>  	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
>  		src = dma_pos;
>  		dst = prtd->params->dma_addr;
>  		src_bidx = data_type;
>  		dst_bidx = 4;
> -		src_cidx = data_type * fifo_level * serializers;
> +		src_cidx = data_type * fifo_level;
>  		dst_cidx = 0;
>  	} else {
>  		src = prtd->params->dma_addr;
> @@ -211,7 +210,7 @@ static void davinci_pcm_enqueue_dma(struct snd_pcm_substream *substream)
>  		src_bidx = 0;
>  		dst_bidx = data_type;
>  		src_cidx = 0;
> -		dst_cidx = data_type * fifo_level * serializers;
> +		dst_cidx = data_type * fifo_level;
>  	}
>  
>  	acnt = prtd->params->acnt;
> @@ -226,8 +225,8 @@ static void davinci_pcm_enqueue_dma(struct snd_pcm_substream *substream)
>  							ASYNC);
>  	else
>  		edma_set_transfer_params(prtd->asp_link[0], acnt,
> -						fifo_level * serializers,
> -						count, fifo_level * serializers,
> +						fifo_level,
> +						count, fifo_level,
>  						ABSYNC);
>  }
>  
> diff --git a/sound/soc/davinci/davinci-pcm.h b/sound/soc/davinci/davinci-pcm.h
> index 0d84d32..fbb710c 100644
> --- a/sound/soc/davinci/davinci-pcm.h
> +++ b/sound/soc/davinci/davinci-pcm.h
> @@ -27,7 +27,6 @@ struct davinci_pcm_dma_params {
>  	unsigned char data_type;	/* xfer data type */
>  	unsigned char convert_mono_stereo;
>  	unsigned int fifo_level;
> -	unsigned char active_serializers; /* num. of active audio serializers */
>  };
>  
>  int davinci_soc_platform_register(struct device *dev);
> 

