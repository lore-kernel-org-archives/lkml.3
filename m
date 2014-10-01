Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbaJAQpO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 12:45:14 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:22742 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbaJAQpL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 12:45:11 -0400
Date: Wed, 1 Oct 2014 18:45:17 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Jyri Sarha <jsarha@ti.com>
Cc: Mark Brown <broonie@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dave Airlie <airlied@gmail.com>,
        Andrew Jackson <Andrew.Jackson@arm.com>, <alsa-devel@alsa-project.org>,
        <devicetree@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 1/2] ASoC:codecs: Add a transmitter interface to the
 HDMI CODEC CODEC
Message-ID: <20141001184517.651f7197@armhf>
In-Reply-To: <542C09DC.3030404@ti.com>
References: <cover.1411547014.git.moinejf@free.fr>
	<50d970aeb1fb8870b654ad01a437341aac58abb6.1411547014.git.moinejf@free.fr>
	<542C09DC.3030404@ti.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Oct 2014 17:04:12 +0300
Jyri Sarha <jsarha@ti.com> wrote:

> 
> On 09/24/2014 10:49 AM, Jean-Francois Moine wrote:> The audio 
> constraints of the HDMI interface are defined by the EDID
>  > which is sent by the connected device.
>  >
>  > The HDMI transmitters may have one or many audio sources.
>  >
>  > This patch adds two functions to the HDMI CODEC:
>  > - it updates the audio constraints from the EDID,
>  > - it gives the audio source type to the HDMI transmitter
>  >    on start of audio streaming.
>  >
>  > Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
>  > ---
>  >   include/sound/hdmi.h    |  20 ++++++
>  >   sound/soc/codecs/hdmi.c | 174 
> ++++++++++++++++++++++++++++++++++++++++++++++--
>  >   2 files changed, 188 insertions(+), 6 deletions(-)
>  >   create mode 100644 include/sound/hdmi.h
>  >
>  > diff --git a/include/sound/hdmi.h b/include/sound/hdmi.h
>  > new file mode 100644
>  > index 0000000..49062c7
>  > --- /dev/null
>  > +++ b/include/sound/hdmi.h
>  > @@ -0,0 +1,20 @@
>  > +#ifndef SND_HDMI_H
>  > +#define SND_HDMI_H
>  > +
>  > +#include <sound/soc.h>
>  > +
>  > +/* platform_data */
>  > +struct hdmi_data {
>  > +	int (*get_audio)(struct device *dev,
>  > +			 int *max_channels,
>  > +			 int *rate_mask,
>  > +			 int *fmt);
> 
> This looks good for the api to HDMI ASoC codec.
> 
>  > +	void (*audio_switch)(struct device *dev,
>  > +			     int port_index,
>  > +			     unsigned sample_rate,
>  > +			     int sample_format);
> 
> I see nothing about selecting the i2s format. I do not know too much
> about tda998x registers but sii9022 can select left and right
> justified mode, bit-clock and frame-clock polarity etc. Should we need
> a callback that corresponds to snd_soc_dai_ops .set_fmt ?
> 
> SiI9022 also uses an external clock as some kind of reference for audio
> and that needs to be divided to right ballpark in relation sample-rate
> (I have no idea why this is, I am just talking about
> experience). Should we need callback that corresponds to
> snd_soc_dai_ops .set_sysclk?
> 
> Maybe the above two could also be left for later.

The HDMI CODEC does not interact with the audio controller.
The audio_switch function just tells the tda998x which is the audio
source and it gives the parameters which impact the HDMI transmission.
The modes, clock... must be defined in the audio card definition
(simple-card or specific card).

About the AIF, this one is sent only once in the tda998x driver.
The values 'refer to stream header' should work in most cases.

The audio source is offered to the HDMI CODEC by the DAIs.
There are 2 DAIs: the first one is S/PDIF and the second is I2S.
If your audio controller delivers I2S only, the audio card shall define
only this one. With a DT (simple-card), this is:

	sound {
		compatible = "simple-audio-card";
		...
		simple-audio-card,dai-link {	/* I2S - HDMI */
			cpu {
				sound-dai = <&audio 0>;
			};
			codec {
				sound-dai = <&hdmi 1>;	/* tda998x 2nd DAI */
			};
		};
	};

Without DT, the DAI link is defined the same way:

	.codec_name = "tda998x.0-0070";
	.codec_dai_name = "i2s-hifi";

>  > +	int ndais;
>  > +	struct snd_soc_dai_driver *dais;
>  > +	struct snd_soc_codec_driver *driver;
>  > +};
> 
> The need to include sound/soc.h is something I was trying to avoid in
> my early design for a similar generic HDMI ASoC codec. I came up with
> this requirement from Mark's comments about my OMAP HDMI audio
> patches. So the bellow suggestion are really up to Mark.
> 
> If I understand right, the need for ndais, dais, and driver is coming
> solely from spdif/i2s switching change. Since at least I am not aware
> of any other DAIs found in HDMI encoders, could we just give the info
> whether i2s and/or spdif is supporter with a simple bit-field or enum?
> The snd_soc_dai_driver and snd_soc_codec_driver definitions could then
> be all put to ASoC side of source tree.
> 
> I have also been wondering why we do not have SND_SOC_DAIFMT_SPDIF
> definition in sound/soc-dai.h. With that there would be no need
> to define two different dais for spdif and i2s. But this is more a
> suggestion for ASoC core future development. Because I do not currently
> have any HW to experiment with this the suggestion should probably be
> left only as a side note for now.

The kirkwood audio subsystem which is used in the Cubox also has 2
audio outputs, I2S and S/PDIF. The audio route 'I2S --> HDMI I2S' or
'S/PDIF --> HDMI S/PDIF + optical S/PDIF' is chosen by the application
(PCM).

Then, the audio constraints are not the same on the audio controller
and HDMI transmitter sides. There must be a full description of these
constraints in the HDMI CODEC. I was thinking to build the DAIs from a
reduced description in the TDA998x transmitter, but, as all parameters
are required, it was simpler to include sound/soc.h.

>  > +#endif
>  > diff --git a/sound/soc/codecs/hdmi.c b/sound/soc/codecs/hdmi.c
>  > index 1087fd5..6ea2772 100644
>  > --- a/sound/soc/codecs/hdmi.c
>  > +++ b/sound/soc/codecs/hdmi.c
>  > @@ -22,9 +22,146 @@
>  >   #include <sound/soc.h>
>  >   #include <linux/of.h>
>  >   #include <linux/of_device.h>
>  > +#include <sound/pcm_params.h>
>  > +#include <sound/hdmi.h>
>  >
>  >   #define DRV_NAME "hdmi-audio-codec"
>  >
>  > +struct hdmi_priv {
>  > +	struct hdmi_data hdmi_data;
>  > +	struct snd_pcm_hw_constraint_list rate_constraints;
>  > +};
>  > +
>  > +static int hdmi_dev_match(struct device *dev, void *data)
>  > +{
>  > +	return !strcmp(dev_name(dev), (char *) data);
>  > +}
>  > +
>  > +/* get the codec device */
>  > +static struct device *hdmi_get_cdev(struct device *dev)
>  > +{
>  > +	struct device *cdev;
>  > +
>  > +	cdev = device_find_child(dev,
>  > +				 DRV_NAME,
>  > +				 hdmi_dev_match);
>  > +	if (!cdev)
>  > +		dev_err(dev, "Cannot get codec device");
>  > +	else
>  > +		put_device(cdev);
>  > +	return cdev;
>  > +}
>  > +
>  > +static int hdmi_startup(struct snd_pcm_substream *substream,
>  > +			struct snd_soc_dai *dai)
>  > +{
>  > +	struct snd_pcm_runtime *runtime = substream->runtime;
>  > +	struct device *cdev;
>  > +	struct hdmi_priv *priv;
>  > +	struct snd_pcm_hw_constraint_list *rate_constraints;
>  > +	int ret, max_channels, rate_mask, fmt;
>  > +	u64 formats;
>  > +	static const u32 hdmi_rates[] = {
>  > +		32000, 44100, 48000, 88200, 96000, 176400, 192000
>  > +	};
>  > +
>  > +	cdev = hdmi_get_cdev(dai->dev);
>  > +	if (!cdev)
>  > +		return -ENODEV;
>  > +	priv = dev_get_drvdata(cdev);
>  > +
>  > +	/* get the EDID values and the rate constraints buffer */
>  > +	ret = priv->hdmi_data.get_audio(dai->dev,
>  > +					&max_channels, &rate_mask, &fmt);
>  > +	if (ret < 0)
>  > +		return ret;				/* no screen */
>  > +
>  > +	/* convert the EDID values to audio constraints */
>  > +	rate_constraints = &priv->rate_constraints;
>  > +	rate_constraints->list = hdmi_rates;
>  > +	rate_constraints->count = ARRAY_SIZE(hdmi_rates);
>  > +	rate_constraints->mask = rate_mask;
>  > +	snd_pcm_hw_constraint_list(runtime, 0,
>  > +				   SNDRV_PCM_HW_PARAM_RATE,
>  > +				   rate_constraints);
>  > +
>  > +	formats = 0;
>  > +	if (fmt & 1)
>  > +		formats |= SNDRV_PCM_FMTBIT_S16_LE;
>  > +	if (fmt & 2)
>  > +		formats |= SNDRV_PCM_FMTBIT_S20_3LE;
>  > +	if (fmt & 4)
>  > +		formats |= SNDRV_PCM_FMTBIT_S24_LE;
> 
> I think we should add here:
> 		formats |= SNDRV_PCM_FMTBIT_S24_3LE;
> and probably also
> 		formats |= SNDRV_PCM_FMTBIT_S32_LE;
> 
> The S24_3LE is equal to S24_LE at i2s level and the 32bit format would
> help to get better than 16bit audio working with if there is trouble
> supporting 24bit formats (like I have with wip sii9022 code). Both
> tda998x and sii9022 are able to play 32bit i2s audio just fine. The 8
> least significant bits are naturally ignored, but we can set
> .sig_bits = 24 in snd_soc_pcm_stream.

OK.

>  > +	snd_pcm_hw_constraint_mask64(runtime,
>  > +				SNDRV_PCM_HW_PARAM_FORMAT,
>  > +				formats);
>  > +
>  > +	snd_pcm_hw_constraint_minmax(runtime,
>  > +				SNDRV_PCM_HW_PARAM_CHANNELS,
>  > +				1, max_channels);
>  > +	return 0;
>  > +}
>  > +
>  > +static int hdmi_hw_params(struct snd_pcm_substream *substream,
>  > +			  struct snd_pcm_hw_params *params,
>  > +			  struct snd_soc_dai *dai)
>  > +{
>  > +	struct device *cdev;
>  > +	struct hdmi_priv *priv;
>  > +
>  > +	cdev = hdmi_get_cdev(dai->dev);
>  > +	if (!cdev)
>  > +		return -ENODEV;
>  > +	priv = dev_get_drvdata(cdev);
>  > +
>  > +	priv->hdmi_data.audio_switch(dai->dev, dai->id,
>  > +				     params_rate(params),
>  > +				     params_format(params));
>  > +	return 0;
>  > +}
>  > +
>  > +static void hdmi_shutdown(struct snd_pcm_substream *substream,
>  > +			  struct snd_soc_dai *dai)
>  > +{
>  > +	struct device *cdev;
>  > +	struct hdmi_priv *priv;
>  > +
>  > +	cdev = hdmi_get_cdev(dai->dev);
>  > +	if (!cdev)
>  > +		return;
>  > +	priv = dev_get_drvdata(cdev);
>  > +
>  > +	priv->hdmi_data.audio_switch(dai->dev, -1, 0, 0);	/* stop */
>  > +}
>  > +
>  > +static const struct snd_soc_dai_ops hdmi_ops = {
>  > +	.startup = hdmi_startup,
>  > +	.hw_params = hdmi_hw_params,
>  > +	.shutdown = hdmi_shutdown,
>  > +};
>  > +
>  > +static int hdmi_codec_probe(struct snd_soc_codec *codec)
>  > +{
>  > +	struct hdmi_priv *priv;
>  > +	struct device *dev = codec->dev;	/* encoder device */
>  > +	struct device *cdev;			/* codec device */
>  > +
>  > +	cdev = hdmi_get_cdev(dev);
>  > +	if (!cdev)
>  > +		return -ENODEV;
>  > +
>  > +	/* allocate some memory to store
>  > +	 * the encoder callback functions and the rate constraints */
>  > +	priv = devm_kzalloc(cdev, sizeof *priv, GFP_KERNEL);
>  > +	if (!priv)
>  > +		return -ENOMEM;
>  > +	dev_set_drvdata(cdev, priv);
>  > +
>  > +	memcpy(&priv->hdmi_data, cdev->platform_data,
>  > +				sizeof priv->hdmi_data);
>  > +	return 0;
>  > +}
>  > +
>  >   static const struct snd_soc_dapm_widget hdmi_widgets[] = {
>  >   	SND_SOC_DAPM_INPUT("RX"),
>  >   	SND_SOC_DAPM_OUTPUT("TX"),
>  > @@ -77,13 +214,38 @@ static struct snd_soc_codec_driver hdmi_codec = {
>  >   	.num_dapm_routes = ARRAY_SIZE(hdmi_routes),
>  >   };
>  >
>  > -static int hdmi_codec_probe(struct platform_device *pdev)
>  > +static int hdmi_codec_dev_probe(struct platform_device *pdev)
>  >   {
>  > -	return snd_soc_register_codec(&pdev->dev, &hdmi_codec,
>  > -			&hdmi_codec_dai, 1);
>  > +	struct hdmi_data *pdata = pdev->dev.platform_data;
>  > +	struct snd_soc_dai_driver *dais;
>  > +	struct snd_soc_codec_driver *driver;
>  > +	int i, ret;
>  > +
>  > +	if (!pdata)
>  > +		return snd_soc_register_codec(&pdev->dev, &hdmi_codec,
>  > +						&hdmi_codec_dai, 1);
>  > +
>  > +	/* creation from a video encoder as a child device */
>  > +	dais = devm_kmemdup(&pdev->dev,
>  > +			    pdata->dais,
>  > +			    sizeof *pdata->dais * pdata->ndais,
>  > +			    GFP_KERNEL);
>  > +	for (i = 0; i < pdata->ndais; i++)
>  > +		dais[i].ops = &hdmi_ops;
>  > +
>  > +	driver = devm_kmemdup(&pdev->dev,
>  > +			    pdata->driver,
>  > +			    sizeof *pdata->driver,
>  > +			    GFP_KERNEL);
>  > +	driver->probe = hdmi_codec_probe;
>  > +
>  > +	/* register the codec on the video encoder */
>  > +	ret = snd_soc_register_codec(pdev->dev.parent, driver,
>  > +					dais, pdata->ndais);
> 
> Registering the codec under the tda998x driver makes me wonder why
> would we need the a separate platform device in the first palce. At
> least it makes it possible to unify the old dummy HDMI codec with the
> new code, but I am not even sure if that makes eny sense.

The CODEC platform device is needed for 2 reasons:
- it permits the HDMI transmitter to give the callback functions and the
  DAIs to the CODEC,
- the CODEC needs to memorize the callback functions and the rate
  constraints, but, as a CODEC, it has no private data, and, on the
  other side, the drvdata of the HDMI transmitter is already used.

> Maybe we should have another dummy codec to be used in the situations
> where you really just need a dummy endpoint to satisfy ASoC. AFAIK the
> only setups that use the current hdmi codec are BBB HDMI audio and
> OMAP4+ HDMI audio, which both are currently broken in the upstream.

My patch does not break the dummy codec as soon as the device does not
get a platform_data at probe time.

>  > +	return ret;
>  >   }
>  >
>  > -static int hdmi_codec_remove(struct platform_device *pdev)
>  > +static int hdmi_codec_dev_remove(struct platform_device *pdev)
>  >   {
>  >   	snd_soc_unregister_codec(&pdev->dev);
>  >   	return 0;
>  > @@ -96,8 +258,8 @@ static struct platform_driver hdmi_codec_driver = {
>  >   		.of_match_table = of_match_ptr(hdmi_audio_codec_ids),
>  >   	},
>  >
>  > -	.probe		= hdmi_codec_probe,
>  > -	.remove		= hdmi_codec_remove,
>  > +	.probe		= hdmi_codec_dev_probe,
>  > +	.remove		= hdmi_codec_dev_remove,
>  >   };
>  >
>  >   module_platform_driver(hdmi_codec_driver);
>  >
> 
> What comes to compatibility to the old use of hdmi codec
> everything appears to be fine after this patch.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
