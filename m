Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbbAKVDp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 16:03:45 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:57607 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbbAKVDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 16:03:43 -0500
Message-ID: <54B2E512.7000904@ti.com>
Date: Sun, 11 Jan 2015 23:03:14 +0200
From: Jyri Sarha <jsarha@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>, Mark Brown <broonie@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Dave Airlie <airlied@gmail.com>, Andrew Jackson <Andrew.Jackson@arm.com>,
        <alsa-devel@alsa-project.org>, <devicetree@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 3/4] ASoC: tda998x: add a codec to the HDMI transmitter
References: <cover.1420628786.git.moinejf@free.fr> <23b36acc1f769418a06f3e929eba288b5911da12.1420628786.git.moinejf@free.fr>
In-Reply-To: <23b36acc1f769418a06f3e929eba288b5911da12.1420628786.git.moinejf@free.fr>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some more comments based on my - finally successful - attempt to use 
this code with BBB HDMI audio.

On 01/07/2015 12:51 PM, Jean-Francois Moine wrote:
> This patch adds a CODEC to the NXP TDA998x HDMI transmitter.
>
> The CODEC handles both I2S and S/PDIF inputs.
> It maintains the audio format and rate constraints according
> to the HDMI device parameters (EDID) and sets dynamically the input
> ports in the TDA998x I2C driver on start/stop audio streaming.
>
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> ---
>   drivers/gpu/drm/i2c/Kconfig       |   1 +
>   drivers/gpu/drm/i2c/tda998x_drv.c | 139 ++++++++++++++++++++++++++++--
>   include/sound/tda998x.h           |  23 +++++
>   sound/soc/codecs/Kconfig          |   4 +
>   sound/soc/codecs/Makefile         |   2 +
>   sound/soc/codecs/tda998x.c        | 175 ++++++++++++++++++++++++++++++++++++++
>   6 files changed, 339 insertions(+), 5 deletions(-)
>   create mode 100644 include/sound/tda998x.h
>   create mode 100644 sound/soc/codecs/tda998x.c
>
> diff --git a/drivers/gpu/drm/i2c/Kconfig b/drivers/gpu/drm/i2c/Kconfig
> index 22c7ed6..24fc975 100644
> --- a/drivers/gpu/drm/i2c/Kconfig
> +++ b/drivers/gpu/drm/i2c/Kconfig
> @@ -28,6 +28,7 @@ config DRM_I2C_SIL164
>   config DRM_I2C_NXP_TDA998X
>   	tristate "NXP Semiconductors TDA998X HDMI encoder"
>   	default m if DRM_TILCDC
> +	select SND_SOC_TDA998X
>   	help
>   	  Support for NXP Semiconductors TDA998X HDMI encoders.
>
> diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
> index ce1478d..a26a516 100644
> --- a/drivers/gpu/drm/i2c/tda998x_drv.c
> +++ b/drivers/gpu/drm/i2c/tda998x_drv.c
> @@ -27,6 +27,11 @@
>   #include <drm/drm_encoder_slave.h>
>   #include <drm/drm_edid.h>
>   #include <drm/i2c/tda998x.h>
> +#include <sound/tda998x.h>
> +
> +#if defined(CONFIG_SND_SOC_TDA998X) || defined(CONFIG_SND_SOC_TDA998X_MODULE)
> +#define WITH_CODEC 1
> +#endif
>
>   #define DBG(fmt, ...) DRM_DEBUG(fmt"\n", ##__VA_ARGS__)
>
> @@ -47,6 +52,10 @@ struct tda998x_priv {
>   	struct drm_encoder *encoder;
>
>   	u8 audio_ports[2];
> +#ifdef WITH_CODEC
> +	u8 sad[3];			/* Short Audio Descriptor */
> +	struct snd_pcm_hw_constraint_list rate_constraints;
> +#endif

It feels a bit backwards to me to store these audio side variables here 
in DRM side driver - especially the rate_constraint - and provide a 
function (tda998x_get_audio_var()) for getting their individual 
addresses to ASoC side. Wouldn't it be more straight forward to provide 
functions for setting and getting the audio side data from a void 
pointer in DRM side device drvdata?

>   };
>
>   #define to_tda998x_priv(x)  ((struct tda998x_priv *)to_encoder_slave(x)->slave_priv)
> @@ -730,11 +739,109 @@ tda998x_configure_audio(struct tda998x_priv *priv,
>   	tda998x_write_aif(priv, p);
>   }
>
> +#ifdef WITH_CODEC
> +/* tda998x audio codec interface */
> +
> +/* return the audio parameters extracted from the last EDID */
> +static int tda998x_get_audio_var(struct device *dev,
> +				u8 **sad,
> +			struct snd_pcm_hw_constraint_list **rate_constraints)
> +{
> +	struct tda998x_priv *priv = dev_get_drvdata(dev);
> +
> +	if (!priv->encoder->crtc
> +	 || !priv->is_hdmi_sink)
> +		return -ENODEV;
> +
> +	*sad = priv->sad;
> +	*rate_constraints = &priv->rate_constraints;
> +	return 0;
> +}
> +
> +/* switch the audio port and initialize the audio parameters for streaming */
> +static int tda998x_set_audio_input(struct device *dev,
> +				int port_index,
> +				unsigned sample_rate,
> +				int sample_format)
> +{
> +	struct tda998x_priv *priv = dev_get_drvdata(dev);
> +	struct tda998x_encoder_params *p = &priv->params;
> +
> +	if (!priv->encoder->crtc)
> +		return -ENODEV;
> +
> +	/* if no port, just disable the audio port */
> +	if (port_index == PORT_NONE) {
> +		reg_write(priv, REG_ENA_AP, 0);
> +		return 0;
> +	}
> +
> +	/* if same audio parameters, just enable the audio port */
> +	if (p->audio_cfg == priv->audio_ports[port_index] &&
> +	    p->audio_sample_rate == sample_rate) {
> +		reg_write(priv, REG_ENA_AP, p->audio_cfg);
> +		return 0;
> +	}
> +
> +	p->audio_format = port_index == PORT_SPDIF ? AFMT_SPDIF : AFMT_I2S;
> +	p->audio_clk_cfg = port_index == PORT_SPDIF ? 0 : 1;
> +	p->audio_cfg = priv->audio_ports[port_index];
> +	p->audio_sample_rate = sample_rate;
> +	tda998x_configure_audio(priv, &priv->encoder->crtc->hwmode, p);
> +	return 0;
> +}
> +
> +/* get the audio capabilities from the EDID */
> +static void tda998x_get_audio_caps(struct tda998x_priv *priv,
> +				struct drm_connector *connector)
> +{
> +	u8 *eld = connector->eld;
> +	u8 *sad;
> +	int sad_count;
> +	unsigned eld_ver, mnl;
> +	u8 max_channels, rate_mask, fmt;
> +
> +	/* adjust the hw params from the ELD (EDID) */
> +	eld_ver = eld[0] >> 3;
> +	if (eld_ver != 2 && eld_ver != 31)
> +		return;
> +
> +	mnl = eld[4] & 0x1f;
> +	if (mnl > 16)
> +		return;
> +
> +	sad_count = eld[5] >> 4;
> +	sad = eld + 20 + mnl;
> +SNDRV_PCM_RATE_CONTINUOUS
> +	/* Start from the basic audio settings */
> +	max_channels = 1;
> +	rate_mask = 0;
> +	fmt = 0;
> +	while (sad_count--) {
> +		switch (sad[0] & 0x78) {
> +		case 0x08:			/* SAD uncompressed audio */
> +			if ((sad[0] & 7) > max_channels)
> +				max_channels = sad[0] & 7;
> +			rate_mask |= sad[1];
> +			fmt |= sad[2] & 0x07;
> +			break;
> +		}
> +		sad += 3;
> +	}
> +
> +	priv->sad[0] = max_channels;
> +	priv->sad[1] = rate_mask;
> +	priv->sad[2] = fmt;
> +}
> +#endif /* WITH_CODEC */
> +
>   /* DRM encoder functions */
>
>   static void tda998x_encoder_set_config(struct tda998x_priv *priv,
>   				       const struct tda998x_encoder_params *p)
>   {
> +	int port_index;
> +
>   	priv->vip_cntrl_0 = VIP_CNTRL_0_SWAP_A(p->swap_a) |
>   			    (p->mirr_a ? VIP_CNTRL_0_MIRR_A : 0) |
>   			    VIP_CNTRL_0_SWAP_B(p->swap_b) |
> @@ -749,6 +856,8 @@ static void tda998x_encoder_set_config(struct tda998x_priv *priv,
>   			    (p->mirr_f ? VIP_CNTRL_2_MIRR_F : 0);
>
>   	priv->params = *p;
> +	port_index = p->audio_format == AFMT_SPDIF ? PORT_SPDIF : PORT_I2S;
> +	priv->audio_ports[port_index] = p->audio_cfg;
>   }
>
>   static void tda998x_encoder_dpms(struct tda998x_priv *priv, int mode)
> @@ -1142,6 +1251,15 @@ tda998x_encoder_get_modes(struct tda998x_priv *priv,
>   		drm_mode_connector_update_edid_property(connector, edid);
>   		n = drm_add_edid_modes(connector, edid);
>   		priv->is_hdmi_sink = drm_detect_hdmi_monitor(edid);
> +
> +#ifdef WITH_CODEC
> +		/* set the audio parameters from the EDID */
> +		if (priv->is_hdmi_sink) {
> +			drm_edid_to_eld(connector, edid);
> +			tda998x_get_audio_caps(priv, connector);
> +		}
> +#endif
> +
>   		kfree(edid);
>   	}
>
> @@ -1176,6 +1294,10 @@ static void tda998x_destroy(struct tda998x_priv *priv)
>   	if (priv->hdmi->irq)
>   		free_irq(priv->hdmi->irq, priv);
>
> +#ifdef WITH_CODEC
> +	tda9998x_codec_unregister(&priv->hdmi->dev);
> +#endif
> +
>   	i2c_unregister_device(priv->cec);
>   }
>
> @@ -1384,26 +1506,33 @@ static int tda998x_create(struct i2c_client *client, struct tda998x_priv *priv)
>   				break;
>   			}
>   			if (strcmp(p, "spdif") == 0) {
> -				priv->audio_ports[0] = port;
> +				priv->audio_ports[PORT_SPDIF] = port;
>   			} else if (strcmp(p, "i2s") == 0) {
> -				priv->audio_ports[1] = port;
> +				priv->audio_ports[PORT_I2S] = port;
>   			} else {
>   				dev_err(&client->dev,
>   					"bad audio-port-names '%s'\n", p);
>   				break;
>   			}
>   		}
> -		if (priv->audio_ports[0]) {
> -			priv->params.audio_cfg = priv->audio_ports[0];
> +		if (priv->audio_ports[PORT_SPDIF]) {
> +			priv->params.audio_cfg = priv->audio_ports[PORT_SPDIF];
>   			priv->params.audio_format = AFMT_SPDIF;
>   			priv->params.audio_clk_cfg = 0;
>   		} else {
> -			priv->params.audio_cfg = priv->audio_ports[1];
> +			priv->params.audio_cfg = priv->audio_ports[PORT_I2S];
>   			priv->params.audio_format = AFMT_I2S;
>   			priv->params.audio_clk_cfg = 1;
>   		}
>   	}
>
> +#ifdef WITH_CODEC
> +	/* create the audio CODEC */
> +	if (priv->audio_ports[PORT_SPDIF] || priv->audio_ports[PORT_I2S])
> +		tda9998x_codec_register(&client->dev,
> +					tda998x_get_audio_var,
> +					tda998x_set_audio_input);
> +#endif
>   	return 0;
>
>   fail:
> diff --git a/include/sound/tda998x.h b/include/sound/tda998x.h
> new file mode 100644
> index 0000000..97cff30
> --- /dev/null
> +++ b/include/sound/tda998x.h
> @@ -0,0 +1,23 @@
> +#ifndef SND_TDA998X_H
> +#define SND_TDA998X_H
> +
> +#include <sound/pcm.h>
> +
> +/* port indexes */
> +#define PORT_NONE (-1)
> +#define PORT_SPDIF 0
> +#define PORT_I2S 1
> +
> +typedef int (*get_audio_var_t)(struct device *dev,
> +				u8 **sad,
> +			struct snd_pcm_hw_constraint_list **rate_constraints);
> +typedef int (*set_audio_input_t)(struct device *dev,
> +				int port_index,
> +				unsigned sample_rate,
> +				int sample_format);
> +

Why don't you simply declare tda998x_get_audio_var() and 
tda998x_set_audio_input() here and export them in DRM side driver? This 
is a tda998x specific codec after all. I see no point to this this 
function pointer typedef game, when the pointers are anyway stored to 
global variables in ASoC the side module.

> +int tda9998x_codec_register(struct device *dev,
> +			get_audio_var_t get_audio_var_i,
> +			set_audio_input_t set_audio_input_i);
> +void tda9998x_codec_unregister(struct device *dev);
> +#endif
> diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
> index 8349f98..456c549 100644
> --- a/sound/soc/codecs/Kconfig
> +++ b/sound/soc/codecs/Kconfig
> @@ -102,6 +102,7 @@ config SND_SOC_ALL_CODECS
>   	select SND_SOC_STAC9766 if SND_SOC_AC97_BUS
>   	select SND_SOC_TAS2552 if I2C
>   	select SND_SOC_TAS5086 if I2C
> +	select SND_SOC_TDA998X if DRM_I2C_NXP_TDA998X
>   	select SND_SOC_TFA9879 if I2C
>   	select SND_SOC_TLV320AIC23_I2C if I2C
>   	select SND_SOC_TLV320AIC23_SPI if SPI_MASTER
> @@ -600,6 +601,9 @@ config SND_SOC_TAS5086
>   	tristate "Texas Instruments TAS5086 speaker amplifier"
>   	depends on I2C
>
> +config SND_SOC_TDA998X
> +	tristate
> +
>   config SND_SOC_TFA9879
>   	tristate "NXP Semiconductors TFA9879 amplifier"
>   	depends on I2C
> diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
> index bbdfd1e..44b4fda 100644
> --- a/sound/soc/codecs/Makefile
> +++ b/sound/soc/codecs/Makefile
> @@ -104,6 +104,7 @@ snd-soc-sta350-objs := sta350.o
>   snd-soc-sta529-objs := sta529.o
>   snd-soc-stac9766-objs := stac9766.o
>   snd-soc-tas5086-objs := tas5086.o
> +snd-soc-tda998x-objs := tda998x.o
>   snd-soc-tfa9879-objs := tfa9879.o
>   snd-soc-tlv320aic23-objs := tlv320aic23.o
>   snd-soc-tlv320aic23-i2c-objs := tlv320aic23-i2c.o
> @@ -282,6 +283,7 @@ obj-$(CONFIG_SND_SOC_STA529)   += snd-soc-sta529.o
>   obj-$(CONFIG_SND_SOC_STAC9766)	+= snd-soc-stac9766.o
>   obj-$(CONFIG_SND_SOC_TAS2552)	+= snd-soc-tas2552.o
>   obj-$(CONFIG_SND_SOC_TAS5086)	+= snd-soc-tas5086.o
> +obj-$(CONFIG_SND_SOC_TDA998X)	+= snd-soc-tda998x.o
>   obj-$(CONFIG_SND_SOC_TFA9879)	+= snd-soc-tfa9879.o
>   obj-$(CONFIG_SND_SOC_TLV320AIC23)	+= snd-soc-tlv320aic23.o
>   obj-$(CONFIG_SND_SOC_TLV320AIC23_I2C)	+= snd-soc-tlv320aic23-i2c.o
> diff --git a/sound/soc/codecs/tda998x.c b/sound/soc/codecs/tda998x.c
> new file mode 100644
> index 0000000..b055570
> --- /dev/null
> +++ b/sound/soc/codecs/tda998x.c
> @@ -0,0 +1,175 @@
> +/*
> + * ALSA SoC TDA998x CODEC
> + *
> + * Copyright (C) 2015 Jean-Francois Moine
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/module.h>
> +#include <sound/soc.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <sound/pcm_params.h>
> +#include <sound/tda998x.h>
> +
> +/* functions in tda998x_drv */
> +static get_audio_var_t get_audio_var;
> +static set_audio_input_t set_audio_input;
> +
> +static int tda998x_codec_startup(struct snd_pcm_substream *substream,
> +				 struct snd_soc_dai *dai)
> +{
> +	struct snd_pcm_runtime *runtime = substream->runtime;
> +	struct snd_pcm_hw_constraint_list *rate_constraints;
> +	u8 *sad;		/* Short Audio Descriptor (3 bytes) */
> +#define SAD_MX_CHAN_I 0			/* max number of chennels - 1 */
> +#define SAD_RATE_MASK_I 1		/* rate mask */
> +#define SAD_FMT_I 2			/* formats */
> +#define  SAD_FMT_16 0x01
> +#define  SAD_FMT_20 0x02
> +#define  SAD_FMT_24 0x04
> +	u64 formats;
> +	int ret;
> +	static const u32 hdmi_rates[] = {
> +		32000, 44100, 48000, 88200, 96000, 176400, 192000
> +	};
> +
> +	/* get the EDID values and the rate constraints buffer */
> +	ret = get_audio_var(dai->dev, &sad, &rate_constraints);
> +	if (ret < 0)
> +		return ret;			/* no screen */
> +
> +	/* convert the EDID values to audio constraints */
> +	rate_constraints->list = hdmi_rates;
> +	rate_constraints->count = ARRAY_SIZE(hdmi_rates);
> +	rate_constraints->mask = sad[SAD_RATE_MASK_I];
> +	snd_pcm_hw_constraint_list(runtime, 0,
> +				   SNDRV_PCM_HW_PARAM_RATE,
> +				   rate_constraints);
> +
> +	formats = 0;
> +	if (sad[SAD_FMT_I] & SAD_FMT_16)
> +		formats |= SNDRV_PCM_FMTBIT_S16_LE;
> +	if (sad[SAD_FMT_I] & SAD_FMT_20)
> +		formats |= SNDRV_PCM_FMTBIT_S20_3LE;
> +	if (sad[SAD_FMT_I] & SAD_FMT_24)
> +		formats |= SNDRV_PCM_FMTBIT_S24_LE |
> +			   SNDRV_PCM_FMTBIT_S24_3LE |
> +			   SNDRV_PCM_FMTBIT_S32_LE;
> +	snd_pcm_hw_constraint_mask64(runtime,
> +				SNDRV_PCM_HW_PARAM_FORMAT,
> +				formats);
> +
> +	snd_pcm_hw_constraint_minmax(runtime,
> +				SNDRV_PCM_HW_PARAM_CHANNELS,
> +				1, sad[SAD_MX_CHAN_I]);

SAD byte 1 bits 2-0 provides the maximum channel count _minus_one_. You 
should _add_one_ to sad[SAD_MX_CHAN_I] when setting the constraint.

> +	return 0;
> +}
> +
> +static int tda998x_codec_hw_params(struct snd_pcm_substream *substream,
> +				   struct snd_pcm_hw_params *params,
> +				   struct snd_soc_dai *dai)
> +{
> +	return set_audio_input(dai->dev, dai->id,
> +				params_rate(params),
> +				params_format(params));
> +}
> +
> +static void tda998x_codec_shutdown(struct snd_pcm_substream *substream,
> +				   struct snd_soc_dai *dai)
> +{
> +	set_audio_input(dai->dev, PORT_NONE, 0, 0);
> +}
> +
> +static const struct snd_soc_dai_ops tda998x_codec_ops = {
> +	.startup = tda998x_codec_startup,
> +	.hw_params = tda998x_codec_hw_params,
> +	.shutdown = tda998x_codec_shutdown,
> +};
> +
> +#define TDA998X_FORMATS	(SNDRV_PCM_FMTBIT_S16_LE | \
> +			SNDRV_PCM_FMTBIT_S20_3LE | \
> +			SNDRV_PCM_FMTBIT_S24_LE | \
> +			SNDRV_PCM_FMTBIT_S32_LE)
> +
> +static struct snd_soc_dai_driver tda998x_dais[] = {
> +	{
> +		.name = "spdif-hifi",
> +		.id = PORT_SPDIF,
> +		.playback = {
> +			.stream_name	= "HDMI SPDIF Playback",
> +			.channels_min	= 1,
> +			.channels_max	= 2,
> +			.rates		= SNDRV_PCM_RATE_CONTINUOUS,
> +			.rate_min	= 22050,
> +			.rate_max	= 192000,
> +			.formats	= TDA998X_FORMATS,
> +		},
> +		.ops = &tda998x_codec_ops,
> +	},
> +	{
> +		.name = "i2s-hifi",
> +		.id = PORT_I2S,
> +		.playback = {
> +			.stream_name	= "HDMI I2S Playback",
> +			.channels_min	= 1,
> +			.channels_max	= 8,
> +			.rates		= SNDRV_PCM_RATE_CONTINUOUS,
> +			.rate_min	= 5512,
> +			.rate_max	= 192000,
> +			.formats	= TDA998X_FORMATS,
> +		},
> +		.ops = &tda998x_codec_ops,
> +	},
> +};

Why do you use SNDRV_PCM_RATE_CONTINUOUS, when HDMI standard only 
supports 32000, 44100, 48000, 88200, 96000, 176400, and 192000 Hz-rates?

> +
> +static const struct snd_soc_dapm_widget tda998x_widgets[] = {
> +	SND_SOC_DAPM_OUTPUT("hdmi-out"),
> +};
> +static const struct snd_soc_dapm_route tda998x_routes[] = {
> +	{ "hdmi-out", NULL, "HDMI I2S Playback" },
> +	{ "hdmi-out", NULL, "HDMI SPDIF Playback" },
> +};
> +
> +static struct snd_soc_codec_driver tda998x_codec_drv = {
> +	.dapm_widgets = tda998x_widgets,
> +	.num_dapm_widgets = ARRAY_SIZE(tda998x_widgets),
> +	.dapm_routes = tda998x_routes,
> +	.num_dapm_routes = ARRAY_SIZE(tda998x_routes),
> +	.ignore_pmdown_time = true,
> +};
> +
> +int tda9998x_codec_register(struct device *dev,
> +			get_audio_var_t get_audio_var_i,
> +			set_audio_input_t set_audio_input_i)
> +{
> +	get_audio_var = get_audio_var_i;
> +	set_audio_input = set_audio_input_i;
> +	return snd_soc_register_codec(dev,
> +				&tda998x_codec_drv,
> +				tda998x_dais, ARRAY_SIZE(tda998x_dais));

So this always registers a two DAI codec whether or not both the i2s and 
spdif is used. The DT binding document could state that the DAI index 0 
is always the spdif DAI and index 1 is the i2s DAI, or even better you 
could #define them under include/dt-bindings/.

While you are at it, you could also mention the DAPM output name 
"hdmi-out" for the codec in the DT-binding document.

> +}
> +EXPORT_SYMBOL(tda9998x_codec_register);
> +
> +void tda9998x_codec_unregister(struct device *dev)
> +{
> +	snd_soc_unregister_codec(dev);
> +}
> +EXPORT_SYMBOL(tda9998x_codec_unregister);
> +
> +static int __init tda998x_codec_init(void)
> +{
> +	return 0;
> +}
> +static void __exit tda998x_codec_exit(void)
> +{
> +}
> +module_init(tda998x_codec_init);
> +module_exit(tda998x_codec_exit);
> +
> +MODULE_AUTHOR("Jean-Francois Moine <moinejf@free.fr>");
> +MODULE_DESCRIPTION("TDA998X CODEC");
> +MODULE_LICENSE("GPL");
>

