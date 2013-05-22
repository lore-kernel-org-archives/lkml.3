Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab3EVR1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 13:27:12 -0400
Received: from smtp-out-044.synserver.de ([212.40.185.44]:1044 "EHLO
	smtp-out-044.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244Ab3EVR1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 13:27:11 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 13932
Message-ID: <519CFFDD.4080203@metafoo.de>
Date: Wed, 22 May 2013 19:26:53 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Florian Meier <florian.meier@koalo.de>
CC: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        swarren@wwwdotorg.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH] ASoC: Add support for BCM2708
References: <519CD1CC.8070507@koalo.de>
In-Reply-To: <519CD1CC.8070507@koalo.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2013 04:10 PM, Florian Meier wrote:
[...]
> diff --git a/sound/soc/bcm2708/bcm2708-i2s.c b/sound/soc/bcm2708/bcm2708-i2s.c
> new file mode 100644
> index 0000000..a8e995f
> --- /dev/null
> +++ b/sound/soc/bcm2708/bcm2708-i2s.c
> @@ -0,0 +1,964 @@
[...]
> +static int bcm2708_i2s_startup(struct snd_pcm_substream *substream,
> +			       struct snd_soc_dai *dai)
> +{
> +	struct bcm2708_i2s_dev *dev = snd_soc_dai_get_drvdata(dai);
> +
> +	if (!dev->first_stream) {
> +		dev->first_stream = substream;
> +
> +		/* should this still be running stop it */
> +		bcm2708_i2s_stop_clock(dev);
> +
> +		/* enable PCM block */
> +		bcm2708_i2s_set_bits(dev, BCM2708_I2S_CS_A_REG, BCM2708_I2S_EN);
> +
> +		/*
> +		 * Disable STBY
> +		 * Requires at least 4 PCM clock cycles to take effect
> +		 */
> +		bcm2708_i2s_set_bits(dev, BCM2708_I2S_CS_A_REG,
> +				BCM2708_I2S_STBY);
> +	} else {
> +		struct snd_pcm_runtime *first_runtime =
> +			dev->first_stream->runtime;
> +
> +		/*
> +		 * This is the second stream open, so we need to impose
> +		 * sample size and sampling rate constraints.
> +		 * This is because frame length and clock cannot be specified
> +		 * seperately.
> +		 *
> +		 * Note that this can cause a race condition if the
> +		 * second stream is opened before the first stream is
> +		 * fully initialized.  We provide some protection by
> +		 * checking to make sure the first stream is
> +		 * initialized, but it's not perfect.  ALSA sometimes
> +		 * re-initializes the driver with a different sample
> +		 * rate or size.  If the second stream is opened
> +		 * before the first stream has received its final
> +		 * parameters, then the second stream may be
> +		 * constrained to the wrong sample rate or size.
> +		 *
> +		 * We will continue in case of failure and recheck the
> +		 * constraint in hw_params.
> +		 */
> +		if (!first_runtime->format) {
> +			dev_err(substream->pcm->card->dev,
> +					"Set format in %s stream first! "
> +					"Initialization may fail.\n",
> +					substream->stream ==
> +					SNDRV_PCM_STREAM_PLAYBACK
> +					? "capture" : "playback");
> +		} else {
> +			snd_pcm_hw_constraint_minmax(substream->runtime,
> +					SNDRV_PCM_HW_PARAM_FORMAT,
> +					first_runtime->format,
> +					first_runtime->format);
> +		}
> +
> +		if (!first_runtime->rate) {
> +			dev_err(substream->pcm->card->dev,
> +					"Set sampling rate in %s stream first! "
> +					"Initialization may fail!\n",
> +					substream->stream ==
> +					SNDRV_PCM_STREAM_PLAYBACK
> +					? "capture" : "playback");
> +		} else {
> +			snd_pcm_hw_constraint_minmax(substream->runtime,
> +					SNDRV_PCM_HW_PARAM_RATE,
> +					first_runtime->rate,
> +					first_runtime->rate);
> +		}

Setting the symmetric_rates lets the core take care of setting the proper
constraints on the rate. It probably makes sense to also add a
symmetric_formats since this isn't the only driver that has the requirement
that the formats for playback and capture match.

> +
> +		dev->second_stream = substream;
> +	}
> +
> +	snd_soc_dai_set_dma_data(dai, substream,
> +			&dev->dma_params[substream->stream]);
> +
> +	return 0;
> +}
> +
> +static void bcm2708_i2s_shutdown(struct snd_pcm_substream *substream,
> +		struct snd_soc_dai *dai)
> +{
> +	struct bcm2708_i2s_dev *dev = snd_soc_dai_get_drvdata(dai);
> +
> +	bcm2708_i2s_stop(dev, substream);
> +
> +	if (dev->first_stream == substream)
> +		dev->first_stream = dev->second_stream;
> +
> +	dev->second_stream = NULL;
> +
> +	/* If both streams are stopped, disable module and clock */
> +	if (!dev->first_stream) {
> +		/* Disable the module */
> +		bcm2708_i2s_clear_bits(dev, BCM2708_I2S_CS_A_REG,
> +				BCM2708_I2S_EN);
> +
> +		/*
> +		 * Stopping clock is necessary, because stop does
> +		 * not stop the clock when SND_SOC_DAIFMT_CONT
> +		 */
> +		bcm2708_i2s_stop_clock(dev);
> +	}
> +}
[...]
> diff --git a/sound/soc/bcm2708/bcm2708-pcm.c b/sound/soc/bcm2708/bcm2708-pcm.c
> new file mode 100644
> index 0000000..4b3e688
> --- /dev/null
> +++ b/sound/soc/bcm2708/bcm2708-pcm.c
> @@ -0,0 +1,303 @@

I think you should be able to remove the bulk of this driver by using the
generic PCM dmaengine driver.

[...]
> +
> +#include "bcm2708-pcm.h"
> +
> +static const struct snd_pcm_hardware bcm2708_pcm_hardware = {
> +	.info			= SNDRV_PCM_INFO_MMAP |
> +				  SNDRV_PCM_INFO_MMAP_VALID |
> +				  SNDRV_PCM_INFO_INTERLEAVED |
> +				  SNDRV_PCM_INFO_PAUSE |
> +				  SNDRV_PCM_INFO_RESUME |
> +				  SNDRV_PCM_INFO_JOINT_DUPLEX |
> +				  SNDRV_PCM_INFO_NO_PERIOD_WAKEUP,

I don't think you actually support the last one, and neither pause and
resume are supported.

> +	.formats		= SNDRV_PCM_FMTBIT_S16_LE |
> +				  SNDRV_PCM_FMTBIT_S32_LE,
> +	.period_bytes_min	= 32,
> +	.period_bytes_max	= 64 * 1024,
> +	.periods_min		= 2,
> +	.periods_max		= 255,
> +	.buffer_bytes_max	= 128 * 1024,
> +};
> +
[...]
