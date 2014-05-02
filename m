Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaEBKZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 06:25:43 -0400
Received: from gloria.sntech.de ([95.129.55.99]:45338 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbaEBKZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 06:25:41 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Brown <broonie@kernel.org>, Xia Kaixu <kaixu.xia@linaro.org>,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Liam Girdwood <lgirdwood@gmail.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Sangbeom Kim <sbkim73@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 13/15] ASoC: SND_S3C_DMA_LEGACY needs S3C24XX_DMA
Date: Fri, 02 May 2014 12:25:58 +0200
Message-ID: <11471248.qyIXLf6t3H@diego>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <7071653.m3UbztQEJc@wuerfel>
References: <1398770316-19715-1-git-send-email-kaixu.xia@linaro.org> <20140501191125.GB3245@sirena.org.uk> <7071653.m3UbztQEJc@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Am Freitag, 2. Mai 2014, 00:35:21 schrieb Arnd Bergmann:
> On Thursday 01 May 2014 12:11:25 Mark Brown wrote:
> > On Tue, Apr 29, 2014 at 07:18:34PM +0800, Xia Kaixu wrote:
> > > From: Arnd Bergmann <arnd@arndb.de>
> > > 
> > > SND_S3C_DMA_LEGACY can only be set on S3C24xx, which does not
> > > (yet) support the dmaengine framework, so samsung_dma_get_ops()
> > 
> > > fails to link if S3C24XX_DMA is disabled:
> > Why is the fix for this not to ensure that s3c24xx always enables the
> > DMA controller - how likely is it that it would be sane to build a
> > kernel without DMA after all?
> 
> S3C24XX_DMA is only needed for ASoC and for s3cmci. The latter
> uses 'depends on S3C24XX_DMA'. arch/arm/configs/tct_hammer_defconfig
> is an example of a configuration that does not include DMA because
> it uses neither of the two drivers.
> 
> On a related topic, I looked at the overall DMA situation for
> plat-samsung again now, and it looks much nicer now than it used to,
> with mach-s3c64xx fully migrated to dmaengine, so there might be an
> even better way to deal with this.
> 
> From all I can tell, sound/soc/samsung is the only remaining user
> of the plat/dma.h interfaces, and there is only one other  driver
> using the s3c24xx_dma interface directly, drivers/mmc/host/s3cmci.c.
> 
> How about the patch below?
> 8<-------
> ASoC: s3c24xx: use legacy DMA interface directly
> 
> The samsung platform code has a wrapper around the legacy s3c24xx
> DMA API as an alternative to the dmaengine API. This is only used
> by the legacy s3c24xx sound support, which is never used in combination
> with the dmaengine API.

Just to mention, we have a dmaengine driver for s3c24xx :-) . Correct 
platform-data is present for all s3c24xx socs (in mach-s3c24xx/common.c) .

Mark already removed support for the legacy API from the s3c64xx spi driver 
(used by s3c2416 and s3c2443), so I guess to way forward would be to "simply" 
convert asoc and s3cmci to dmaengine and get rid of it altogether.

I just never had hardware using the old mci driver or with any previously 
working sound and didn't trust my experience to be enough to be able to do 
such a conversion "on the fly" like you below in the opposite direction ;-)


Heiko

> 
> We can simplify the ASoC code significantly, and thereby completely
> obsoleting arch/arm/plat-samsung/dma-ops.c,
> arch/arm/plat-samsung/s3c-dma-ops.c and
> arch/arm/plat-samsung/include/plat/dma-ops.h.
> 
> This patch achieves this by open-coding the implementation of this
> wrapper, which ends up saving us more code than we have to add.
> s3c24xx does not support cyclic DMA, so anything referring to that
> gets deleted in the process.
> 
> The plat-samsung dma wrapper code is now dead code and can be removed
> subsequently.
> 
> Signed-off--by: Arnd Bergmann <arnd@arndb.de>
> ---
> 
>  sound/soc/samsung/ac97.c | 10 ++----
>  sound/soc/samsung/dma.c  | 79
> +++++++++++++++--------------------------------- sound/soc/samsung/dma.h  |
>  2 --
>  3 files changed, 27 insertions(+), 64 deletions(-)
> 
> diff --git a/sound/soc/samsung/ac97.c b/sound/soc/samsung/ac97.c
> index 76b072b..28fe097 100644
> --- a/sound/soc/samsung/ac97.c
> +++ b/sound/soc/samsung/ac97.c
> @@ -253,10 +253,7 @@ static int s3c_ac97_trigger(struct snd_pcm_substream
> *substream, int cmd,
> 
>  	writel(ac_glbctrl, s3c_ac97.regs + S3C_AC97_GLBCTRL);
> 
> -	if (!dma_data->ops)
> -		dma_data->ops = samsung_dma_get_ops();
> -
> -	dma_data->ops->started(dma_data->channel);
> +	s3c2410_dma_ctrl(dma_data->channel, S3C2410_DMAOP_STARTED);
> 
>  	return 0;
>  }
> @@ -287,10 +284,7 @@ static int s3c_ac97_mic_trigger(struct
> snd_pcm_substream *substream,
> 
>  	writel(ac_glbctrl, s3c_ac97.regs + S3C_AC97_GLBCTRL);
> 
> -	if (!dma_data->ops)
> -		dma_data->ops = samsung_dma_get_ops();
> -
> -	dma_data->ops->started(dma_data->channel);
> +	s3c2410_dma_ctrl(dma_data->channel, S3C2410_DMAOP_STARTED);
> 
>  	return 0;
>  }
> diff --git a/sound/soc/samsung/dma.c b/sound/soc/samsung/dma.c
> index dc09b71..3c6e2f2 100644
> --- a/sound/soc/samsung/dma.c
> +++ b/sound/soc/samsung/dma.c
> @@ -54,8 +54,6 @@ struct runtime_data {
>  	struct s3c_dma_params *params;
>  };
> 
> -static void audio_buffdone(void *data);
> -
>  /* dma_enqueue
>   *
>   * place a dma buffer onto the queue for the dma system
> @@ -66,7 +64,6 @@ static void dma_enqueue(struct snd_pcm_substream
> *substream) struct runtime_data *prtd = substream->runtime->private_data;
>  	dma_addr_t pos = prtd->dma_pos;
>  	unsigned int limit;
> -	struct samsung_dma_prep dma_info;
> 
>  	pr_debug("Entered %s\n", __func__);
> 
> @@ -75,33 +72,11 @@ static void dma_enqueue(struct snd_pcm_substream
> *substream) pr_debug("%s: loaded %d, limit %d\n",
>  				__func__, prtd->dma_loaded, limit);
> 
> -	dma_info.cap = (samsung_dma_has_circular() ? DMA_CYCLIC : DMA_SLAVE);
> -	dma_info.direction =
> -		(substream->stream == SNDRV_PCM_STREAM_PLAYBACK
> -		? DMA_MEM_TO_DEV : DMA_DEV_TO_MEM);
> -	dma_info.fp = audio_buffdone;
> -	dma_info.fp_param = substream;
> -	dma_info.period = prtd->dma_period;
> -	dma_info.len = prtd->dma_period*limit;
> -
> -	if (dma_info.cap == DMA_CYCLIC) {
> -		dma_info.buf = pos;
> -		prtd->params->ops->prepare(prtd->params->ch, &dma_info);
> -		prtd->dma_loaded += limit;
> -		return;
> -	}
> -
>  	while (prtd->dma_loaded < limit) {
>  		pr_debug("dma_loaded: %d\n", prtd->dma_loaded);
> 
> -		if ((pos + dma_info.period) > prtd->dma_end) {
> -			dma_info.period  = prtd->dma_end - pos;
> -			pr_debug("%s: corrected dma len %ld\n",
> -					__func__, dma_info.period);
> -		}
> -
> -		dma_info.buf = pos;
> -		prtd->params->ops->prepare(prtd->params->ch, &dma_info);
> +		s3c2410_dma_enqueue(prtd->params->channel, substream, pos,
> +				    prtd->dma_period * limit);
> 
>  		prtd->dma_loaded++;
>  		pos += prtd->dma_period;
> @@ -112,7 +87,8 @@ static void dma_enqueue(struct snd_pcm_substream
> *substream) prtd->dma_pos = pos;
>  }
> 
> -static void audio_buffdone(void *data)
> +static void audio_buffdone(struct s3c2410_dma_chan *channel, void *data,
> +		       int size, enum s3c2410_dma_buffresult res)
>  {
>  	struct snd_pcm_substream *substream = data;
>  	struct runtime_data *prtd = substream->runtime->private_data;
> @@ -128,10 +104,8 @@ static void audio_buffdone(void *data)
>  			snd_pcm_period_elapsed(substream);
> 
>  		spin_lock(&prtd->lock);
> -		if (!samsung_dma_has_circular()) {
> -			prtd->dma_loaded--;
> -			dma_enqueue(substream);
> -		}
> +		prtd->dma_loaded--;
> +		dma_enqueue(substream);
>  		spin_unlock(&prtd->lock);
>  	}
>  }
> @@ -145,8 +119,7 @@ static int dma_hw_params(struct snd_pcm_substream
> *substream, unsigned long totbytes = params_buffer_bytes(params);
>  	struct s3c_dma_params *dma =
>  		snd_soc_dai_get_dma_data(rtd->cpu_dai, substream);
> -	struct samsung_dma_req req;
> -	struct samsung_dma_config config;
> +	enum dma_transfer_direction direction;
> 
>  	pr_debug("Entered %s\n", __func__);
> 
> @@ -164,24 +137,22 @@ static int dma_hw_params(struct snd_pcm_substream
> *substream, pr_debug("params %p, client %p, channel %d\n", prtd->params,
>  			prtd->params->client, prtd->params->channel);
> 
> -		prtd->params->ops = samsung_dma_get_ops();
> -
> -		req.cap = (samsung_dma_has_circular() ?
> -			DMA_CYCLIC : DMA_SLAVE);
> -		req.client = prtd->params->client;
> -		config.direction =
> -			(substream->stream == SNDRV_PCM_STREAM_PLAYBACK
> +		direction = (substream->stream == SNDRV_PCM_STREAM_PLAYBACK
>  			? DMA_MEM_TO_DEV : DMA_DEV_TO_MEM);
> -		config.width = prtd->params->dma_size;
> -		config.fifo = prtd->params->dma_addr;
> -		prtd->params->ch = prtd->params->ops->request(
> -				prtd->params->channel, &req, rtd->cpu_dai->dev,
> -				prtd->params->ch_name);
> -		if (!prtd->params->ch) {
> +
> +		if (s3c2410_dma_request(prtd->params->channel,
> +					(void*)prtd->params->client, NULL) < 0) {
>  			pr_err("Failed to allocate DMA channel\n");
> +			s3c2410_dma_free(prtd->params->channel,
> +					 (void*)prtd->params->client);
>  			return -ENXIO;
>  		}
> -		prtd->params->ops->config(prtd->params->ch, &config);
> +		s3c2410_dma_devconfig(prtd->params->channel, direction,
> +				      prtd->params->dma_addr);
> +		s3c2410_dma_config(prtd->params->channel,
> +				   prtd->params->dma_size);
> +		s3c2410_dma_set_buffdone_fn(prtd->params->channel,
> +					    audio_buffdone);
>  	}
> 
>  	snd_pcm_set_runtime_buffer(substream, &substream->dma_buffer);
> @@ -208,9 +179,9 @@ static int dma_hw_free(struct snd_pcm_substream
> *substream) snd_pcm_set_runtime_buffer(substream, NULL);
> 
>  	if (prtd->params) {
> -		prtd->params->ops->flush(prtd->params->ch);
> -		prtd->params->ops->release(prtd->params->ch,
> -					prtd->params->client);
> +		s3c2410_dma_ctrl(prtd->params->channel, S3C2410_DMAOP_FLUSH);
> +		s3c2410_dma_free(prtd->params->channel,
> +				 (void*)prtd->params->client);
>  		prtd->params = NULL;
>  	}
> 
> @@ -230,7 +201,7 @@ static int dma_prepare(struct snd_pcm_substream
> *substream) return 0;
> 
>  	/* flush the DMA channel */
> -	prtd->params->ops->flush(prtd->params->ch);
> +	s3c2410_dma_ctrl(prtd->params->channel, S3C2410_DMAOP_FLUSH);
> 
>  	prtd->dma_loaded = 0;
>  	prtd->dma_pos = prtd->dma_start;
> @@ -253,12 +224,12 @@ static int dma_trigger(struct snd_pcm_substream
> *substream, int cmd) switch (cmd) {
>  	case SNDRV_PCM_TRIGGER_START:
>  		prtd->state |= ST_RUNNING;
> -		prtd->params->ops->trigger(prtd->params->ch);
> +		s3c2410_dma_ctrl(prtd->params->channel, S3C2410_DMAOP_START);
>  		break;
> 
>  	case SNDRV_PCM_TRIGGER_STOP:
>  		prtd->state &= ~ST_RUNNING;
> -		prtd->params->ops->stop(prtd->params->ch);
> +		s3c2410_dma_ctrl(prtd->params->channel, S3C2410_DMAOP_STOP);
>  		break;
> 
>  	default:
> diff --git a/sound/soc/samsung/dma.h b/sound/soc/samsung/dma.h
> index ad7c0f0..c52fa86 100644
> --- a/sound/soc/samsung/dma.h
> +++ b/sound/soc/samsung/dma.h
> @@ -23,8 +23,6 @@ struct s3c_dma_params {
>  	int channel;				/* Channel ID */
>  	dma_addr_t dma_addr;
>  	int dma_size;			/* Size of the DMA transfer */
> -	unsigned ch;
> -	struct samsung_dma_ops *ops;
>  	char *ch_name;
>  	struct snd_dmaengine_dai_dma_data dma_data;
>  };
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

