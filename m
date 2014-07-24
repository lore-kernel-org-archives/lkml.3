Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933288AbaGXPUw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 11:20:52 -0400
Received: from sym2.noone.org ([178.63.92.236]:33560 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759076AbaGXPUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:20:50 -0400
Date: Thu, 24 Jul 2014 17:20:45 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Nicolin Chen <nicoleotsuka@gmail.com>
Cc: broonie@kernel.org, shawn.guo@linaro.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.de, timur@tabi.org, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org,
        b02247@freescale.com, b42378@freescale.com
Subject: Re: [PATCH v2 2/2] ASoC: fsl_asrc: Add ASRC ASoC CPU DAI and
 platform drivers
Message-ID: <20140724152045.GA3384@distanz.ch>
References: <cover.1406189745.git.nicoleotsuka@gmail.com>
 <2c74a11776ffcc017c80dc31be4a8313755be8f5.1406189745.git.nicoleotsuka@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c74a11776ffcc017c80dc31be4a8313755be8f5.1406189745.git.nicoleotsuka@gmail.com>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-24 at 10:35:29 +0200, Nicolin Chen <nicoleotsuka@gmail.com> wrote:
> The Asynchronous Sample Rate Converter (ASRC) converts the sampling rate of a
> signal associated with an input clock into a signal associated with a different
> output clock. The driver currently works as a Front End of DPCM with other Back
> Ends DAI links such as ESAI<->CS42888 and SSI<->WM8962 and SAI. It converts the
> original sample rate to a common rate supported by Back Ends for playback while
> converts the common rate of Back Ends to a desired rate for capture. It has 3
> pairs to support three different substreams within totally 10 channels.
> 
> Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
> ---

[...]

> --- /dev/null
> +++ b/sound/soc/fsl/fsl_asrc.c
> @@ -0,0 +1,1031 @@

[...]

> +static struct platform_driver fsl_asrc_driver = {
> +	.probe = fsl_asrc_probe,
> +	.driver = {
> +		.name = "fsl-asrc",
> +		.owner = THIS_MODULE,

Not necessary, this will be set by module_platform_driver (or
the expansion of platform_driver_register, respectively).

> +		.of_match_table = fsl_asrc_ids,
> +		.pm = &fsl_asrc_pm,
> +	},
> +};
> +module_platform_driver(fsl_asrc_driver);

[...]

> --- /dev/null
> +++ b/sound/soc/fsl/fsl_asrc_dma.c
> @@ -0,0 +1,384 @@

[...]

> +static int fsl_asrc_dma_pcm_new(struct snd_soc_pcm_runtime *rtd)
> +{
> +	struct snd_card *card = rtd->card->snd_card;
> +	struct snd_pcm_substream *substream;
> +	struct snd_pcm *pcm = rtd->pcm;
> +	u64 dma_mask = DMA_BIT_MASK(32);
> +	int ret, i;
> +
> +	if (!card->dev->dma_mask)
> +		card->dev->dma_mask = &dma_mask;

dma_mask will go out of scope after fsl_asrc_dma_pcm_new returns,
resulting in a stray pointer in card->dev->dma_mask.

> +	if (!card->dev->coherent_dma_mask)
> +		card->dev->coherent_dma_mask = DMA_BIT_MASK(32);
> +
> +	for (i = SNDRV_PCM_STREAM_PLAYBACK; i <= SNDRV_PCM_STREAM_LAST; i++) {
> +		substream = pcm->streams[i].substream;
> +
> +		ret = snd_dma_alloc_pages(SNDRV_DMA_TYPE_DEV, pcm->card->dev,
> +				FSL_ASRC_DMABUF_SIZE, &substream->dma_buffer);
> +		if (ret) {
> +			dev_err(card->dev, "failed to allocate DMA buffer\n");
> +			goto err;
> +		}
> +	}
> +
> +	return 0;
> +
> +err:
> +	if (--i == 0)
> +		snd_dma_free_pages(&pcm->streams[i].substream->dma_buffer);
> +
> +	return ret;
> +}
> +
> +static void fsl_asrc_dma_pcm_free(struct snd_pcm *pcm)
> +{
> +	struct snd_pcm_substream *substream;
> +	int i;
> +
> +	for (i = SNDRV_PCM_STREAM_PLAYBACK; i <= SNDRV_PCM_STREAM_LAST; i++) {
> +		substream = pcm->streams[i].substream;
> +		if (!substream)
> +			continue;
> +
> +		snd_dma_free_pages(&substream->dma_buffer);
> +		substream->dma_buffer.area = NULL;
> +		substream->dma_buffer.addr = 0;
> +	}
> +}
> +
> +struct snd_soc_platform_driver fsl_asrc_platform = {
> +	.ops		= &fsl_asrc_dma_pcm_ops,
> +	.pcm_new	= fsl_asrc_dma_pcm_new,
> +	.pcm_free	= fsl_asrc_dma_pcm_free,
> +};
> +EXPORT_SYMBOL_GPL(fsl_asrc_platform);
> -- 
> 1.8.4
