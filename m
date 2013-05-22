Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab3EVQkC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 12:40:02 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51841 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab3EVQkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 12:40:00 -0400
Date: Wed, 22 May 2013 11:39:42 -0500
From: Mark Brown <broonie@kernel.org>
To: Florian Meier <florian.meier@koalo.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>, swarren@wwwdotorg.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>
Message-ID: <20130522163942.GQ1627@sirena.org.uk>
References: <519CD1CC.8070507@koalo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PVGnt3hziMCGXk95"
Content-Disposition: inline
In-Reply-To: <519CD1CC.8070507@koalo.de>
X-Cookie: You will have long and healthy life.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 144.188.69.1
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: Add support for BCM2708
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PVGnt3hziMCGXk95
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 22, 2013 at 04:10:20PM +0200, Florian Meier wrote:

> This driver adds support for digital audio (I2S)
> for the BCM2708 SoC that is used by the
> Raspberry Pi. External audio codecs can be
> connected to the Raspberry Pi via P5 header.

Split this up into a patch series, for example one per CPU side driver
and one per machine driver.  I've given the code a relatively quick run
through here, it looks mostly sensible though DT would be nice but
there's a few comments.

> +static inline void bcm2708_i2s_write_reg(struct bcm2708_i2s_dev *dev,
> +					   int reg, u32 val)
> +{
> +	dev_dbg(dev->dev, "I2S write to register %p = %x\n",
> +			dev->clk_base + reg, val);
> +	__raw_writel(val, dev->i2s_base + reg);
> +}

This all looks like you want to use regmap-mmio - that'll get you all
the logging and so on for free too.

> +static void bcm2708_i2s_start_clock(struct bcm2708_i2s_dev *dev)
> +{
> +	/*
> +	 * Start the clock if in master mode.
> +	 */
> +	unsigned int master = dev->fmt & SND_SOC_DAIFMT_MASTER_MASK;
> +	if (master == SND_SOC_DAIFMT_CBS_CFS
> +			|| master == SND_SOC_DAIFMT_CBS_CFM) {

This looks like it should be a switch statement.

> +		unsigned int clkreg = bcm2708_clk_read_reg(dev,
> +				BCM2708_CLK_PCMCTL_REG);
> +		bcm2708_clk_write_reg(dev, BCM2708_CLK_PCMCTL_REG,
> +				BCM2708_CLK_PASSWD | clkreg | BCM2708_CLK_ENAB);
> +	}

Shouldn't this be using your set bits operation?

> +static bool bcm2708_i2s_check_other_stream(struct bcm2708_i2s_dev *dev,
> +					struct snd_pcm_substream *substream,
> +					struct snd_pcm_substream *other_stream,
> +					struct snd_pcm_hw_params *params)
> +{
> +	if (other_stream->runtime->format &&
> +		(other_stream->runtime->format != params_format(params))) {
> +		dev_err(dev->dev,
> +			"Sample formats of streams are different. %i (%s) != %i (%s) Initialization failed!\n",
> +			other_stream->runtime->format,
> +			(other_stream->stream ==
> +			 SNDRV_PCM_STREAM_PLAYBACK ?
> +			 "playback" : "capture"),
> +			params_format(params),
> +			(substream->stream ==
> +			 SNDRV_PCM_STREAM_PLAYBACK ?
> +			 "playback" : "capture"));

This is illegible.

> +	/* Ensure, that both streams have the same settings */
> +	struct snd_pcm_substream *other_stream = dev->first_stream;
> +	if (other_stream == substream)
> +		other_stream = dev->second_stream;

Set constraints for this so that the upper layers will stop mismatched
settings being configured.

> +	/*
> +	 * Clear both FIFOs if the one that should be started
> +	 * is not empty at the moment. This should only happen
> +	 * after overrun. Otherwise, hw_params would have cleared
> +	 * the FIFO.
> +	 */

Why both?

> +	case SNDRV_PCM_TRIGGER_START:
> +	case SNDRV_PCM_TRIGGER_RESUME:
> +	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
> +		bcm2708_i2s_start(dev, substream);

These functions are pretty small, I'd just inline them.

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

Don't split strings, but in any case you should just let people set up -
hopefully they'll try to set something that might work anyway.  Any code
for fixing this up should be in the core, like symmetric_rates.

> +static void bcm2708_i2s_setup_gpio(void)
> +{
> +	/*
> +	 * This is the common way to handle the GPIO pins for
> +	 * the Raspberry Pi.
> +	 * TODO Better way would be to handle
> +	 * this in the device tree!
> +	 */

Yup.

> +	/* request both ioareas */
> +	for (i = 0; i <= 1; i++) {
> +		struct resource *mem, *ioarea;
> +		mem = platform_get_resource(pdev, IORESOURCE_MEM, i);
> +		if (!mem) {

devm_ioremap_resource().

> +	/* get DMA data (e.g. FIFO address and DREQ) */
> +	dma_data = snd_soc_dai_get_dma_data(rtd->cpu_dai, substream);
> +
> +	/*
> +	 * There seems to be no use for bufferless
> +	 * transfer with this SoC.
> +	 */
> +	if (!dma_data)
> +		return 0;

This is now supported properly by the framework, no need for this.

> +	dma_data = snd_soc_dai_get_dma_data(rtd->cpu_dai, substream);
> +
> +	switch (cmd) {
> +	case SNDRV_PCM_TRIGGER_START:
> +	case SNDRV_PCM_TRIGGER_RESUME:
> +	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
> +		break;
> +
> +	case SNDRV_PCM_TRIGGER_STOP:
> +	case SNDRV_PCM_TRIGGER_SUSPEND:
> +	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
> +		break;
> +	default:
> +		ret = -EINVAL;
> +	}
> +
> +	if (ret == 0)
> +		ret = snd_dmaengine_pcm_trigger(substream, cmd);

Juse don't have switch statement.

> +static snd_pcm_uframes_t bcm2708_pcm_pointer(
> +		struct snd_pcm_substream *substream)
> +{
> +	return snd_dmaengine_pcm_pointer(substream);
> +}

Should just be able to use snd_dmaengine_pcm_pointer() as the ops.

> +static int bcm2708_pcm_mmap(struct snd_pcm_substream *substream,
> +	struct vm_area_struct *vma)

This should be a generic op...

> +{
> +	struct snd_pcm_runtime *runtime = substream->runtime;
> +
> +	return dma_mmap_writecombine(substream->pcm->card->dev, vma,

Should be using the DMA controller device not the card.

> +				     runtime->dma_area,
> +				     runtime->dma_addr,
> +				     runtime->dma_bytes);
> +}

> +static int bcm2708_pcm_preallocate_dma_buffer(struct snd_pcm *pcm,
> +	int stream)
> +{
> +	struct snd_pcm_substream *substream = pcm->streams[stream].substream;
> +	struct snd_dma_buffer *buf = &substream->dma_buffer;
> +	size_t size = bcm2708_pcm_hardware.buffer_bytes_max;
> +
> +	buf->dev.type = SNDRV_DMA_TYPE_DEV;
> +	buf->dev.dev = pcm->card->dev;

DMA controller device.

> +static int snd_rpi_mbed_init(struct snd_soc_pcm_runtime *rtd)
> +{
> +	return 0;
> +}

Empty functions can just be removed.

> +static const unsigned int wm8731_rates_12288000[] = {
> +	8000, 32000, 48000, 96000,
> +};
> +
> +static struct snd_pcm_hw_constraint_list wm8731_constraints_12288000 = {
> +	.list = wm8731_rates_12288000,
> +	.count = ARRAY_SIZE(wm8731_rates_12288000),
> +};
> +
> +static int snd_rpi_proto_startup(struct snd_pcm_substream *substream)
> +{
> +	/* Setup constraints, because there is a 12.288 MHz XTAL on the board */
> +	snd_pcm_hw_constraint_list(substream->runtime, 0,
> +				SNDRV_PCM_HW_PARAM_RATE,
> +				&wm8731_constraints_12288000);
> +	return 0;
> +}

Push this into the CODEC driver, this will be true for the device on any
platform with a fixed clock.

> +static int snd_rpi_proto_hw_params(struct snd_pcm_substream *substream,
> +				       struct snd_pcm_hw_params *params)
> +{
> +	struct snd_soc_pcm_runtime *rtd = substream->private_data;
> +	struct snd_soc_dai *codec_dai = rtd->codec_dai;
> +	int sysclk = 12288000; /* This is fixed on this board */
> +
> +	/* Set proto sysclk */
> +	int ret = snd_soc_dai_set_sysclk(codec_dai, WM8731_SYSCLK_XTAL,
> +		sysclk, SND_SOC_CLOCK_IN);
> +	if (ret < 0) {
> +		dev_err(substream->pcm->dev,
> +				"Failed to set WM8731 SYSCLK: %d\n", ret);
> +		return ret;
> +	}

Since this is fixed just do it once on init (eg, in late_probe()) rather
than every single time.

--PVGnt3hziMCGXk95
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRnPTLAAoJELSic+t+oim9Fj0P/RSW4GocQagCypu8pLaAdkSu
NKHFU6D/qJESO5gJsMQ3wZh5raJgGRgo4VeSR/UuAcfKzF3qu+qdaqpQYU9BdsbG
AUFVb3fy5rKCe19XI7JIPSDg631vBv3/fJK0hGJ0UqKjiYqx+u1vZPtv10DN2UqJ
YHrpFZjXWt9NMV18xJQdpqm0cJ/N17KplFioz995iJL0bGnYVFG5CxClOFILvR/Z
Wg2IZlxZt9Vtdoj7TV2roOqzoTQPnngcmV+sGB/H34cZSVy1qW2uULmB/gxohW2b
kxOSCm74APjdAGLPXhH3zeHSaDV0+fdqSriUi/IaAojfYMhA3Lx5Mdeellqd+oaE
eai6LhvML3DShcQguMqg6J2e3GCKUPKT057N85K/F1gS5R7iA2TlL18IW1dxM1Le
KeQk5FOhX1eNvJDvWjs7CTevpvT1iIZdGb4C+oUo3O5095OyDYhvVIKnz9+O0G5n
doDuwJWTJCgrYpMuqnsDofqvyeExOtme8Bz4VgHpqH7ymNHYDypkoPE06o0tDyDy
MV509OybZukrgM4hhhQBxUETKB+IOiSRhi2W0za8akyYmwHdw/qKHLrLEaz39lXs
JKwjapnyXRPq0znnrEMFtj1G/iKR40qQ7sEbyGNl31ajbdgezY1A6MsQ0EYV8HQD
9oYoZnzgh2jJXxKNMNGJ
=DLuC
-----END PGP SIGNATURE-----

--PVGnt3hziMCGXk95--
