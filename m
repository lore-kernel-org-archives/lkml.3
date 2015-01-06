Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbbAFNcv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 08:32:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45243 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751286AbbAFNct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 08:32:49 -0500
Date: Tue, 6 Jan 2015 13:32:47 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Zidan Wang <b50113@freescale.com>
Cc: broonie@kernel.org, lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        lars@metafoo.de, Li.Xiubo@freescale.com,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel][PATCH 2/4] ASoC: wm8960: Let wm8960 driver
	configure its bit clock and frame clock
Message-ID: <20150106133247.GQ14516@opensource.wolfsonmicro.com>
References: <1419997154-860-1-git-send-email-b50113@freescale.com> <1419997154-860-2-git-send-email-b50113@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419997154-860-2-git-send-email-b50113@freescale.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2014 at 11:39:12AM +0800, Zidan Wang wrote:
> wm8960 codec driver missing configure its bit clock and frame clock, so add
> support for it. It will calculate a appropriate frequency dividing ratio
> according to the system clock, bit clock and frame clock, then set the
> corresponding registers.
> 
> Signed-off-by: Zidan Wang <b50113@freescale.com>
> ---
>  sound/soc/codecs/wm8960.c | 108 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 108 insertions(+)
> 
> diff --git a/sound/soc/codecs/wm8960.c b/sound/soc/codecs/wm8960.c
> index 1a5f47b..86a5489 100644
> --- a/sound/soc/codecs/wm8960.c
> +++ b/sound/soc/codecs/wm8960.c
> @@ -127,6 +127,8 @@ struct wm8960_priv {
>  	struct snd_soc_dapm_widget *out3;
>  	bool deemph;
>  	int playback_fs;
> +	int bclk;
> +	int sysclk;
>  	struct wm8960_data pdata;
>  };
>  
> @@ -563,6 +565,79 @@ static struct {
>  	{  8000, 5 },
>  };
>  
> +/* Multiply 256 for internal 256 div */
> +static const int dac_divs[] = { 256, 384, 512, 768, 1024, 1408, 1536 };
> +
> +/* Multiply 10 to eliminate decimials */
> +static const int bclk_divs[] = {
> +	10, 15, 20, 30, 40, 55, 60, 80, 110,
> +	120, 160, 220, 240, 320, 320, 320
> +};
> +
> +static void wm8960_configure_clocking(struct snd_soc_codec *codec,
> +		int stream, int lrclk)
> +{
> +	struct wm8960_priv *wm8960 = snd_soc_codec_get_drvdata(codec);
> +	u16 iface1 = snd_soc_read(codec, WM8960_IFACE1);
> +	u16 iface2 = snd_soc_read(codec, WM8960_IFACE2);
> +	int i, j;
> +
> +	if (!(iface1 & (1<<6))) {
> +		dev_dbg(codec->dev,
> +			"Codec is slave mode, no need to configure clock\n");
> +		return;
> +	}
> +
> +	if (!wm8960->sysclk) {
> +		dev_dbg(codec->dev, "No SYSCLK configured\n");
> +		return;
> +	}
> +
> +	if (!wm8960->bclk || !lrclk) {
> +		dev_dbg(codec->dev, "No audio clocks configured\n");
> +		return;
> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(dac_divs); ++i) {
> +		if (wm8960->sysclk == lrclk * dac_divs[i]) {
> +			for (j = 0; j < ARRAY_SIZE(bclk_divs); ++j) {
> +				if (wm8960->sysclk ==  wm8960->bclk *
> +						bclk_divs[j] / 10) {
> +					/* configure frame clock */
> +					if (iface2 & (1<<6))
> +						/* If ADCLRC configure as GPIO
> +						 * pin, DACLRC pin is used as
> +						 * a frame clock for ADCs and
> +						 * DACs */
> +						snd_soc_update_bits(codec,
> +								WM8960_CLOCK1,
> +								0x7 << 3,
> +								i << 3);

The indentation is getting pretty horrific here can we do some
things to ease that a little. You could flip the polarity of the
two if statements and use continues instead for example that
would help a lot.

Thanks,
Charles

> +					else if (SNDRV_PCM_STREAM_PLAYBACK
> +								== stream)
> +						snd_soc_update_bits(codec,
> +								WM8960_CLOCK1,
> +								0x7 << 3,
> +								i << 3);
> +					else if (SNDRV_PCM_STREAM_CAPTURE
> +								== stream)
> +						snd_soc_update_bits(codec,
> +								WM8960_CLOCK1,
> +								0x7 << 6,
> +								i << 6);
> +
> +					/* configure bit clock */
> +					snd_soc_update_bits(codec,
> +							WM8960_CLOCK2, 0xf, j);
> +					return;
> +				}
> +			}
> +		}
> +	}
> +
> +	dev_err(codec->dev, "Unsupported sysclk %d\n", wm8960->sysclk);
> +}
> +
