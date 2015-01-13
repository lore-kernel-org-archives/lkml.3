Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751132AbbAMHjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 02:39:13 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:9680 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbbAMHjM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 02:39:12 -0500
Date: Tue, 13 Jan 2015 08:41:44 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Jyri Sarha <jsarha@ti.com>
Cc: Mark Brown <broonie@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dave Airlie <airlied@gmail.com>,
        Andrew Jackson <Andrew.Jackson@arm.com>, <alsa-devel@alsa-project.org>,
        <devicetree@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 3/4] ASoC: tda998x: add a codec to the HDMI
 transmitter
Message-ID: <20150113084144.7c62c18d@armhf>
In-Reply-To: <54B2E512.7000904@ti.com>
References: <cover.1420628786.git.moinejf@free.fr>
	<23b36acc1f769418a06f3e929eba288b5911da12.1420628786.git.moinejf@free.fr>
	<54B2E512.7000904@ti.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Jan 2015 23:03:14 +0200
Jyri Sarha <jsarha@ti.com> wrote:

> Some more comments based on my - finally successful - attempt to use 
> this code with BBB HDMI audio.
> 
> On 01/07/2015 12:51 PM, Jean-Francois Moine wrote:
> > This patch adds a CODEC to the NXP TDA998x HDMI transmitter.
	[snip]
> > @@ -47,6 +52,10 @@ struct tda998x_priv {
> >   	struct drm_encoder *encoder;
> >
> >   	u8 audio_ports[2];
> > +#ifdef WITH_CODEC
> > +	u8 sad[3];			/* Short Audio Descriptor */
> > +	struct snd_pcm_hw_constraint_list rate_constraints;
> > +#endif
> 
> It feels a bit backwards to me to store these audio side variables here 
> in DRM side driver - especially the rate_constraint - and provide a 
> function (tda998x_get_audio_var()) for getting their individual 
> addresses to ASoC side. Wouldn't it be more straight forward to provide 
> functions for setting and getting the audio side data from a void 
> pointer in DRM side device drvdata?

Good idea. The rate_constraints would be allocated by the codec and set by a transmitter function.

	[snip]
> > diff --git a/include/sound/tda998x.h b/include/sound/tda998x.h
> > new file mode 100644
> > index 0000000..97cff30
> > --- /dev/null
> > +++ b/include/sound/tda998x.h
> > @@ -0,0 +1,23 @@
> > +#ifndef SND_TDA998X_H
> > +#define SND_TDA998X_H
> > +
> > +#include <sound/pcm.h>
> > +
> > +/* port indexes */
> > +#define PORT_NONE (-1)
> > +#define PORT_SPDIF 0
> > +#define PORT_I2S 1
> > +
> > +typedef int (*get_audio_var_t)(struct device *dev,
> > +				u8 **sad,
> > +			struct snd_pcm_hw_constraint_list **rate_constraints);
> > +typedef int (*set_audio_input_t)(struct device *dev,
> > +				int port_index,
> > +				unsigned sample_rate,
> > +				int sample_format);
> > +
> 
> Why don't you simply declare tda998x_get_audio_var() and 
> tda998x_set_audio_input() here and export them in DRM side driver? This 
> is a tda998x specific codec after all. I see no point to this this 
> function pointer typedef game, when the pointers are anyway stored to 
> global variables in ASoC the side module.

There cannot be both ways of function call with modules:
the transmitter may call exported functions of the codec,
but the codec cannot call exported functions of the transmitter.

	[snip]
> > +	snd_pcm_hw_constraint_minmax(runtime,
> > +				SNDRV_PCM_HW_PARAM_CHANNELS,
> > +				1, sad[SAD_MX_CHAN_I]);
> 
> SAD byte 1 bits 2-0 provides the maximum channel count _minus_one_. You 
> should _add_one_ to sad[SAD_MX_CHAN_I] when setting the constraint.

Right. Thanks.

	[snip]
> > +static struct snd_soc_dai_driver tda998x_dais[] = {
> > +	{
> > +		.name = "spdif-hifi",
> > +		.id = PORT_SPDIF,
> > +		.playback = {
> > +			.stream_name	= "HDMI SPDIF Playback",
> > +			.channels_min	= 1,
> > +			.channels_max	= 2,
> > +			.rates		= SNDRV_PCM_RATE_CONTINUOUS,
> > +			.rate_min	= 22050,
> > +			.rate_max	= 192000,
> > +			.formats	= TDA998X_FORMATS,
> > +		},
> > +		.ops = &tda998x_codec_ops,
> > +	},
> > +	{
> > +		.name = "i2s-hifi",
> > +		.id = PORT_I2S,
> > +		.playback = {
> > +			.stream_name	= "HDMI I2S Playback",
> > +			.channels_min	= 1,
> > +			.channels_max	= 8,
> > +			.rates		= SNDRV_PCM_RATE_CONTINUOUS,
> > +			.rate_min	= 5512,
> > +			.rate_max	= 192000,
> > +			.formats	= TDA998X_FORMATS,
> > +		},
> > +		.ops = &tda998x_codec_ops,
> > +	},
> > +};
> 
> Why do you use SNDRV_PCM_RATE_CONTINUOUS, when HDMI standard only 
> supports 32000, 44100, 48000, 88200, 96000, 176400, and 192000 Hz-rates?

Before I treated the EDID, I directly used these definitions,
and my TV display accepted many more rates as 22050 with S/PDIF input
or 7875 with I2S input.

> > +
> > +static const struct snd_soc_dapm_widget tda998x_widgets[] = {
> > +	SND_SOC_DAPM_OUTPUT("hdmi-out"),
> > +};
> > +static const struct snd_soc_dapm_route tda998x_routes[] = {
> > +	{ "hdmi-out", NULL, "HDMI I2S Playback" },
> > +	{ "hdmi-out", NULL, "HDMI SPDIF Playback" },
> > +};
> > +
> > +static struct snd_soc_codec_driver tda998x_codec_drv = {
> > +	.dapm_widgets = tda998x_widgets,
> > +	.num_dapm_widgets = ARRAY_SIZE(tda998x_widgets),
> > +	.dapm_routes = tda998x_routes,
> > +	.num_dapm_routes = ARRAY_SIZE(tda998x_routes),
> > +	.ignore_pmdown_time = true,
> > +};
> > +
> > +int tda9998x_codec_register(struct device *dev,
> > +			get_audio_var_t get_audio_var_i,
> > +			set_audio_input_t set_audio_input_i)
> > +{
> > +	get_audio_var = get_audio_var_i;
> > +	set_audio_input = set_audio_input_i;
> > +	return snd_soc_register_codec(dev,
> > +				&tda998x_codec_drv,
> > +				tda998x_dais, ARRAY_SIZE(tda998x_dais));
> 
> So this always registers a two DAI codec whether or not both the i2s and 
> spdif is used. The DT binding document could state that the DAI index 0 
> is always the spdif DAI and index 1 is the i2s DAI, or even better you 
> could #define them under include/dt-bindings/.
> 
> While you are at it, you could also mention the DAPM output name 
> "hdmi-out" for the codec in the DT-binding document.
	[snip]

This will be changed when using the graph of ports: the DAIs will be
dynamically created from the DT.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
