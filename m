Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbaGCI3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 04:29:22 -0400
Received: from smtp-out-164.synserver.de ([212.40.185.164]:1091 "EHLO
	smtp-out-164.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaGCI3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 04:29:13 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 1488
Message-ID: <53B51454.2060704@metafoo.de>
Date: Thu, 03 Jul 2014 10:29:08 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, vinod.koul@intel.com,
        dan.j.williams@intel.com, tiwai@suse.de,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        joelf@ti.com, nsekhar@ti.com
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH v3 3/5] ASoC: generic-dmaengine-pcm: Prepare formats mask
 for valid physical sample sizes
References: <1404363116-10538-1-git-send-email-peter.ujfalusi@ti.com> <1404363116-10538-4-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1404363116-10538-4-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2014 06:51 AM, Peter Ujfalusi wrote:
> Based on the dma_slave_caps's addr_widths queried from the dma driver
> prepare the hw.formats mask to include only formats which is supported by
> the DMA engine.
> In case the dma driver does not implement the slave_caps the default
> assumption is that it supports 1, 2 and 4 bytes widths.
>
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

Looks good, thanks.

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

> ---
>
> I know that the format validation could be done like this:
>
> +		if (bits > 0 && bits <=64 && !(bits % 8) &&
> +		    (addr_widths & (1 << (bits / 8))))
> +				hw.formats |= (1LL << i);
>
> But I think the switch() implementation is more readable.
>
>
>   sound/soc/soc-generic-dmaengine-pcm.c | 37 ++++++++++++++++++++++++++++++++++-
>   1 file changed, 36 insertions(+), 1 deletion(-)
>
> diff --git a/sound/soc/soc-generic-dmaengine-pcm.c b/sound/soc/soc-generic-dmaengine-pcm.c
> index 5bace124ef43..6307f85e871b 100644
> --- a/sound/soc/soc-generic-dmaengine-pcm.c
> +++ b/sound/soc/soc-generic-dmaengine-pcm.c
> @@ -119,7 +119,10 @@ static int dmaengine_pcm_set_runtime_hwparams(struct snd_pcm_substream *substrea
>   	struct snd_dmaengine_dai_dma_data *dma_data;
>   	struct dma_slave_caps dma_caps;
>   	struct snd_pcm_hardware hw;
> -	int ret;
> +	u32 addr_widths = BIT(DMA_SLAVE_BUSWIDTH_1_BYTE) |
> +			  BIT(DMA_SLAVE_BUSWIDTH_2_BYTES) |
> +			  BIT(DMA_SLAVE_BUSWIDTH_4_BYTES);
> +	int i, ret;
>
>   	if (pcm->config && pcm->config->pcm_hardware)
>   		return snd_soc_set_runtime_hwparams(substream,
> @@ -146,6 +149,38 @@ static int dmaengine_pcm_set_runtime_hwparams(struct snd_pcm_substream *substrea
>   			hw.info |= SNDRV_PCM_INFO_PAUSE | SNDRV_PCM_INFO_RESUME;
>   		if (dma_caps.residue_granularity <= DMA_RESIDUE_GRANULARITY_SEGMENT)
>   			hw.info |= SNDRV_PCM_INFO_BATCH;
> +
> +		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
> +			addr_widths = dma_caps.dstn_addr_widths;
> +		else
> +			addr_widths = dma_caps.src_addr_widths;
> +	}
> +
> +	/*
> +	 * Prepare formats mask for valid/allowed sample types. If the dma does
> +	 * not have support for the given physical word size, it needs to be
> +	 * masked out so user space can not use the format which produces
> +	 * corrupted audio.
> +	 * In case the dma driver does not implement the slave_caps the default
> +	 * assumption is that it supports 1, 2 and 4 bytes widths.
> +	 */
> +	for (i = 0; i <= SNDRV_PCM_FORMAT_LAST; i++) {
> +		int bits = snd_pcm_format_physical_width(i);
> +
> +		/* Enable only samples with DMA supported physical widths */
> +		switch (bits) {
> +		case 8:
> +		case 16:
> +		case 24:
> +		case 32:
> +		case 64:
> +			if (addr_widths & (1 << (bits / 8)))
> +				hw.formats |= (1LL << i);
> +			break;
> +		default:
> +			/* Unsupported types */
> +			break;
> +		}
>   	}
>
>   	return snd_soc_set_runtime_hwparams(substream, &hw);
>

