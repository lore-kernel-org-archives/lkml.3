Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602AbaL2RJD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 12:09:03 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54530 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbaL2RJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 12:09:01 -0500
Date: Mon, 29 Dec 2014 17:08:18 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dave Airlie <airlied@gmail.com>,
        Andrew Jackson <Andrew.Jackson@arm.com>, Jyri Sarha <jsarha@ti.com>,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Message-ID: <20141229170818.GB17800@sirena.org.uk>
References: <cover.1414053169.git.moinejf@free.fr>
 <d63bb11d345ab1f1b7723ce5f82d42f56b0f1715.1414053169.git.moinejf@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HqU/NDEOKApT+6Er"
Content-Disposition: inline
In-Reply-To: <d63bb11d345ab1f1b7723ce5f82d42f56b0f1715.1414053169.git.moinejf@free.fr>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 86.128.155.20
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v8 1/2] ASoC: hdmi: Add a transmitter interface to the
 HDMI CODEC
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HqU/NDEOKApT+6Er
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 23, 2014 at 09:09:35AM +0200, Jean-Francois Moine wrote:

> +struct hdmi_data {
> +	int (*get_audio)(struct device *dev,
> +			 int *max_channels,
> +			 int *rate_mask,
> +			 int *fmt);
> +	void (*audio_switch)(struct device *dev,
> +			     int port_index,
> +			     unsigned sample_rate,
> +			     int sample_format);

I can't really tell from these function names what these functions are
supposed to do.  I think get_audio() should be get_audio_caps() or
similar since it reads the capabilities and audio_switch() is supposed
to be set_audio_params() or similar to set the settings for the running
stream.

> +	snd_pcm_hw_constraint_list(runtime, 0,
> +				   SNDRV_PCM_HW_PARAM_RATE,
> +				   rate_constraints);
> +
> +	formats =3D 0;
> +	if (fmt & 1)
> +		formats |=3D SNDRV_PCM_FMTBIT_S16_LE;
> +	if (fmt & 2)
> +		formats |=3D SNDRV_PCM_FMTBIT_S20_3LE;
> +	if (fmt & 4)
> +		formats |=3D SNDRV_PCM_FMTBIT_S24_LE |
> +			   SNDRV_PCM_FMTBIT_S24_3LE |
> +			   SNDRV_PCM_FMTBIT_S32_LE;

Magic numbers here - can't we have some constants defined?

> +	priv->hdmi_data.audio_switch(dai->dev, dai->id,
> +				     params_rate(params),
> +				     params_format(params));

I'd be happier if this were able to return an error; even if the
constraints are satisfied perhaps something changed or some operation
fails for some reason.

> +static void hdmi_shutdown(struct snd_pcm_substream *substream,
> +			  struct snd_soc_dai *dai)
> +{
> +	struct device *cdev;
> +	struct hdmi_priv *priv;
> +
> +	cdev =3D hdmi_get_cdev(dai->dev);
> +	if (!cdev)
> +		return;
> +	priv =3D dev_get_drvdata(cdev);
> +
> +	priv->hdmi_data.audio_switch(dai->dev, -1, 0, 0);	/* stop */
> +}

So the set parameters operation has to support these magic values as
being "off" - why not have an explicit shutdown operation here?

> +static int hdmi_codec_probe(struct snd_soc_codec *codec)
> +{
> +	struct hdmi_priv *priv;
> +	struct device *dev =3D codec->dev;	/* encoder device */
> +	struct device *cdev;			/* codec device */
> +
> +	cdev =3D hdmi_get_cdev(dev);
> +	if (!cdev)
> +		return -ENODEV;

This is (I think) only called for cases where the driver is being used
=66rom a parent device with ops but the name makes it sound like it should
be called all the time so errors like that shouldn't happen.  This
should be clearer, or perhaps we should just have a separate device
(perhaps rename the existing one to say that it's for a dumb device with
no control?).

--HqU/NDEOKApT+6Er
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUoYqBAAoJECTWi3JdVIfQu8UH/30bGmCST0NnrWXxo4iph7LT
P1WK69Bg2+E+BgihILZ9v/RFDA6lw8PI/dLmfVaF2gpiJoxMphalPhvRFpksCkLb
5hAHWCwA+j7lcQ9+4YmweOqVSiDHhoP186Zxtv5z6vKGAKwIXpY0nfQrzJV+WHxI
1YzwLSGpQH0RWeU8YJjEK3VLXlmqQxP0ApicOe0sVH+JAzFVsqI2Nj8RW75RydVp
Jk+2xxy6mJqu3uD0NNHPWqNQ7VJINejon9AWvdgmNMn7NQHPWjN2qY/fdk5Y8dmF
1wiZJyOESU2kz3KeiYvlHhrf36cS9ZQTZkoSh9vf83pDycPk7ynZyW1YAHARAew=
=5C1c
-----END PGP SIGNATURE-----

--HqU/NDEOKApT+6Er--
