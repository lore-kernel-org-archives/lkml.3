Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583AbaJAOE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 10:04:56 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56337 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207AbaJAOEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 10:04:54 -0400
Message-ID: <542C09DC.3030404@ti.com>
Date: Wed, 1 Oct 2014 17:04:12 +0300
From: Jyri Sarha <jsarha@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>, Mark Brown <broonie@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Dave Airlie <airlied@gmail.com>, Andrew Jackson <Andrew.Jackson@arm.com>,
        <alsa-devel@alsa-project.org>, <devicetree@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 1/2] ASoC:codecs: Add a transmitter interface to the
 HDMI CODEC CODEC
References: <cover.1411547014.git.moinejf@free.fr> <50d970aeb1fb8870b654ad01a437341aac58abb6.1411547014.git.moinejf@free.fr>
In-Reply-To: <50d970aeb1fb8870b654ad01a437341aac58abb6.1411547014.git.moinejf@free.fr>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/24/2014 10:49 AM, Jean-Francois Moine wrote:> The audio 
constraints of the HDMI interface are defined by the EDID
 > which is sent by the connected device.
 >
 > The HDMI transmitters may have one or many audio sources.
 >
 > This patch adds two functions to the HDMI CODEC:
 > - it updates the audio constraints from the EDID,
 > - it gives the audio source type to the HDMI transmitter
 >    on start of audio streaming.
 >
 > Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
 > ---
 >   include/sound/hdmi.h    |  20 ++++++
 >   sound/soc/codecs/hdmi.c | 174 
++++++++++++++++++++++++++++++++++++++++++++++--
 >   2 files changed, 188 insertions(+), 6 deletions(-)
 >   create mode 100644 include/sound/hdmi.h
 >
 > diff --git a/include/sound/hdmi.h b/include/sound/hdmi.h
 > new file mode 100644
 > index 0000000..49062c7
 > --- /dev/null
 > +++ b/include/sound/hdmi.h
 > @@ -0,0 +1,20 @@
 > +#ifndef SND_HDMI_H
 > +#define SND_HDMI_H
 > +
 > +#include <sound/soc.h>
 > +
 > +/* platform_data */
 > +struct hdmi_data {
 > +	int (*get_audio)(struct device *dev,
 > +			 int *max_channels,
 > +			 int *rate_mask,
 > +			 int *fmt);

This looks good for the api to HDMI ASoC codec.

 > +	void (*audio_switch)(struct device *dev,
 > +			     int port_index,
 > +			     unsigned sample_rate,
 > +			     int sample_format);

I see nothing about selecting the i2s format. I do not know too much
about tda998x registers but sii9022 can select left and right
justified mode, bit-clock and frame-clock polarity etc. Should we need
a callback that corresponds to snd_soc_dai_ops .set_fmt ?

SiI9022 also uses an external clock as some kind of reference for audio
and that needs to be divided to right ballpark in relation sample-rate
(I have no idea why this is, I am just talking about
experience). Should we need callback that corresponds to
snd_soc_dai_ops .set_sysclk?

Maybe the above two could also be left for later.

 > +	int ndais;
 > +	struct snd_soc_dai_driver *dais;
 > +	struct snd_soc_codec_driver *driver;
 > +};

The need to include sound/soc.h is something I was trying to avoid in
my early design for a similar generic HDMI ASoC codec. I came up with
this requirement from Mark's comments about my OMAP HDMI audio
patches. So the bellow suggestion are really up to Mark.

If I understand right, the need for ndais, dais, and driver is coming
solely from spdif/i2s switching change. Since at least I am not aware
of any other DAIs found in HDMI encoders, could we just give the info
whether i2s and/or spdif is supporter with a simple bit-field or enum?
The snd_soc_dai_driver and snd_soc_codec_driver definitions could then
be all put to ASoC side of source tree.

I have also been wondering why we do not have SND_SOC_DAIFMT_SPDIF
definition in sound/soc-dai.h. With that there would be no need
to define two different dais for spdif and i2s. But this is more a
suggestion for ASoC core future development. Because I do not currently
have any HW to experiment with this the suggestion should probably be
left only as a side note for now.

 > +#endif
 > diff --git a/sound/soc/codecs/hdmi.c b/sound/soc/codecs/hdmi.c
 > index 1087fd5..6ea2772 100644
 > --- a/sound/soc/codecs/hdmi.c
 > +++ b/sound/soc/codecs/hdmi.c
 > @@ -22,9 +22,146 @@
 >   #include <sound/soc.h>
 >   #include <linux/of.h>
 >   #include <linux/of_device.h>
 > +#include <sound/pcm_params.h>
 > +#include <sound/hdmi.h>
 >
 >   #define DRV_NAME "hdmi-audio-codec"
 >
 > +struct hdmi_priv {
 > +	struct hdmi_data hdmi_data;
 > +	struct snd_pcm_hw_constraint_list rate_constraints;
 > +};
 > +
 > +static int hdmi_dev_match(struct device *dev, void *data)
 > +{
 > +	return !strcmp(dev_name(dev), (char *) data);
 > +}
 > +
 > +/* get the codec device */
 > +static struct device *hdmi_get_cdev(struct device *dev)
 > +{
 > +	struct device *cdev;
 > +
 > +	cdev = device_find_child(dev,
 > +				 DRV_NAME,
 > +				 hdmi_dev_match);
 > +	if (!cdev)
 > +		dev_err(dev, "Cannot get codec device");
 > +	else
 > +		put_device(cdev);
 > +	return cdev;
 > +}
 > +
 > +static int hdmi_startup(struct snd_pcm_substream *substream,
 > +			struct snd_soc_dai *dai)
 > +{
 > +	struct snd_pcm_runtime *runtime = substream->runtime;
 > +	struct device *cdev;
 > +	struct hdmi_priv *priv;
 > +	struct snd_pcm_hw_constraint_list *rate_constraints;
 > +	int ret, max_channels, rate_mask, fmt;
 > +	u64 formats;
 > +	static const u32 hdmi_rates[] = {
 > +		32000, 44100, 48000, 88200, 96000, 176400, 192000
 > +	};
 > +
 > +	cdev = hdmi_get_cdev(dai->dev);
 > +	if (!cdev)
 > +		return -ENODEV;
 > +	priv = dev_get_drvdata(cdev);
 > +
 > +	/* get the EDID values and the rate constraints buffer */
 > +	ret = priv->hdmi_data.get_audio(dai->dev,
 > +					&max_channels, &rate_mask, &fmt);
 > +	if (ret < 0)
 > +		return ret;				/* no screen */
 > +
 > +	/* convert the EDID values to audio constraints */
 > +	rate_constraints = &priv->rate_constraints;
 > +	rate_constraints->list = hdmi_rates;
 > +	rate_constraints->count = ARRAY_SIZE(hdmi_rates);
 > +	rate_constraints->mask = rate_mask;
 > +	snd_pcm_hw_constraint_list(runtime, 0,
 > +				   SNDRV_PCM_HW_PARAM_RATE,
 > +				   rate_constraints);
 > +
 > +	formats = 0;
 > +	if (fmt & 1)
 > +		formats |= SNDRV_PCM_FMTBIT_S16_LE;
 > +	if (fmt & 2)
 > +		formats |= SNDRV_PCM_FMTBIT_S20_3LE;
 > +	if (fmt & 4)
 > +		formats |= SNDRV_PCM_FMTBIT_S24_LE;

I think we should add here:
		formats |= SNDRV_PCM_FMTBIT_S24_3LE;
and probably also
		formats |= SNDRV_PCM_FMTBIT_S32_LE;

The S24_3LE is equal to S24_LE at i2s level and the 32bit format would
help to get better than 16bit audio working with if there is trouble
supporting 24bit formats (like I have with wip sii9022 code). Both
tda998x and sii9022 are able to play 32bit i2s audio just fine. The 8
least significant bits are naturally ignored, but we can set
.sig_bits = 24 in snd_soc_pcm_stream.

 > +	snd_pcm_hw_constraint_mask64(runtime,
 > +				SNDRV_PCM_HW_PARAM_FORMAT,
 > +				formats);
 > +
 > +	snd_pcm_hw_constraint_minmax(runtime,
 > +				SNDRV_PCM_HW_PARAM_CHANNELS,
 > +				1, max_channels);
 > +	return 0;
 > +}
 > +
 > +static int hdmi_hw_params(struct snd_pcm_substream *substream,
 > +			  struct snd_pcm_hw_params *params,
 > +			  struct snd_soc_dai *dai)
 > +{
 > +	struct device *cdev;
 > +	struct hdmi_priv *priv;
 > +
 > +	cdev = hdmi_get_cdev(dai->dev);
 > +	if (!cdev)
 > +		return -ENODEV;
 > +	priv = dev_get_drvdata(cdev);
 > +
 > +	priv->hdmi_data.audio_switch(dai->dev, dai->id,
 > +				     params_rate(params),
 > +				     params_format(params));
 > +	return 0;
 > +}
 > +
 > +static void hdmi_shutdown(struct snd_pcm_substream *substream,
 > +			  struct snd_soc_dai *dai)
 > +{
 > +	struct device *cdev;
 > +	struct hdmi_priv *priv;
 > +
 > +	cdev = hdmi_get_cdev(dai->dev);
 > +	if (!cdev)
 > +		return;
 > +	priv = dev_get_drvdata(cdev);
 > +
 > +	priv->hdmi_data.audio_switch(dai->dev, -1, 0, 0);	/* stop */
 > +}
 > +
 > +static const struct snd_soc_dai_ops hdmi_ops = {
 > +	.startup = hdmi_startup,
 > +	.hw_params = hdmi_hw_params,
 > +	.shutdown = hdmi_shutdown,
 > +};
 > +
 > +static int hdmi_codec_probe(struct snd_soc_codec *codec)
 > +{
 > +	struct hdmi_priv *priv;
 > +	struct device *dev = codec->dev;	/* encoder device */
 > +	struct device *cdev;			/* codec device */
 > +
 > +	cdev = hdmi_get_cdev(dev);
 > +	if (!cdev)
 > +		return -ENODEV;
 > +
 > +	/* allocate some memory to store
 > +	 * the encoder callback functions and the rate constraints */
 > +	priv = devm_kzalloc(cdev, sizeof *priv, GFP_KERNEL);
 > +	if (!priv)
 > +		return -ENOMEM;
 > +	dev_set_drvdata(cdev, priv);
 > +
 > +	memcpy(&priv->hdmi_data, cdev->platform_data,
 > +				sizeof priv->hdmi_data);
 > +	return 0;
 > +}
 > +
 >   static const struct snd_soc_dapm_widget hdmi_widgets[] = {
 >   	SND_SOC_DAPM_INPUT("RX"),
 >   	SND_SOC_DAPM_OUTPUT("TX"),
 > @@ -77,13 +214,38 @@ static struct snd_soc_codec_driver hdmi_codec = {
 >   	.num_dapm_routes = ARRAY_SIZE(hdmi_routes),
 >   };
 >
 > -static int hdmi_codec_probe(struct platform_device *pdev)
 > +static int hdmi_codec_dev_probe(struct platform_device *pdev)
 >   {
 > -	return snd_soc_register_codec(&pdev->dev, &hdmi_codec,
 > -			&hdmi_codec_dai, 1);
 > +	struct hdmi_data *pdata = pdev->dev.platform_data;
 > +	struct snd_soc_dai_driver *dais;
 > +	struct snd_soc_codec_driver *driver;
 > +	int i, ret;
 > +
 > +	if (!pdata)
 > +		return snd_soc_register_codec(&pdev->dev, &hdmi_codec,
 > +						&hdmi_codec_dai, 1);
 > +
 > +	/* creation from a video encoder as a child device */
 > +	dais = devm_kmemdup(&pdev->dev,
 > +			    pdata->dais,
 > +			    sizeof *pdata->dais * pdata->ndais,
 > +			    GFP_KERNEL);
 > +	for (i = 0; i < pdata->ndais; i++)
 > +		dais[i].ops = &hdmi_ops;
 > +
 > +	driver = devm_kmemdup(&pdev->dev,
 > +			    pdata->driver,
 > +			    sizeof *pdata->driver,
 > +			    GFP_KERNEL);
 > +	driver->probe = hdmi_codec_probe;
 > +
 > +	/* register the codec on the video encoder */
 > +	ret = snd_soc_register_codec(pdev->dev.parent, driver,
 > +					dais, pdata->ndais);

Registering the codec under the tda998x driver makes me wonder why
would we need the a separate platform device in the first palce. At
least it makes it possible to unify the old dummy HDMI codec with the
new code, but I am not even sure if that makes eny sense.

Maybe we should have another dummy codec to be used in the situations
where you really just need a dummy endpoint to satisfy ASoC. AFAIK the
only setups that use the current hdmi codec are BBB HDMI audio and
OMAP4+ HDMI audio, which both are currently broken in the upstream.

 > +	return ret;
 >   }
 >
 > -static int hdmi_codec_remove(struct platform_device *pdev)
 > +static int hdmi_codec_dev_remove(struct platform_device *pdev)
 >   {
 >   	snd_soc_unregister_codec(&pdev->dev);
 >   	return 0;
 > @@ -96,8 +258,8 @@ static struct platform_driver hdmi_codec_driver = {
 >   		.of_match_table = of_match_ptr(hdmi_audio_codec_ids),
 >   	},
 >
 > -	.probe		= hdmi_codec_probe,
 > -	.remove		= hdmi_codec_remove,
 > +	.probe		= hdmi_codec_dev_probe,
 > +	.remove		= hdmi_codec_dev_remove,
 >   };
 >
 >   module_platform_driver(hdmi_codec_driver);
 >

What comes to compatibility to the old use of hdmi codec
everything appears to be fine after this patch.

Best regards,
Jyri
