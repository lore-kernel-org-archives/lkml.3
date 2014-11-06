Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407AbaKFNh6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 08:37:58 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45909 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbaKFNh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 08:37:57 -0500
Date: Thu, 6 Nov 2014 13:37:20 +0000
From: Mark Brown <broonie@kernel.org>
To: Peter Rosin <peda@lysator.liu.se>
Cc: alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, Peter Rosin <peda@axentia.se>
Message-ID: <20141106133720.GG8509@sirena.org.uk>
References: <1415278441-27866-1-git-send-email-peda@lysator.liu.se>
 <1415278441-27866-2-git-send-email-peda@lysator.liu.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vsHhinrhaqUzFcVS"
Content-Disposition: inline
In-Reply-To: <1415278441-27866-2-git-send-email-peda@lysator.liu.se>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.249.210
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] ASoC: tfa9879: New driver for NXP Semiconductors
 TFA9879 amplifier.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vsHhinrhaqUzFcVS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 06, 2014 at 01:54:00PM +0100, Peter Rosin wrote:

> +#define TFA9879_REG(codec, reg, field, value)				\
> +	snd_soc_update_bits(codec, TFA9879_ ## reg,			\
> +			    TFA9879_ ## field ## _MASK,			\
> +			    (value) << TFA9879_ ## field ## _SHIFT)

Please don't do stuff like this, it just makes the code look more
obscure than it should be for people who work with multiple devices -
just use update_bits() directly.

> +static int tfa9879_prepare(struct snd_pcm_substream *substream,
> +			   struct snd_soc_dai *dai)
> +{
> +	struct snd_soc_codec *codec = dai->codec;
> +
> +	TFA9879_REG(codec, DEVICE_CONTROL, POWERUP, 1);

Use DAPM to manage power, you're probably looking for a supply widget.

> +	switch (params_format(params)) {
> +	case SNDRV_PCM_FORMAT_S16_LE:

Use params_width() rather than a specific memory layout.

> +	if (tfa9879->lsb_justified)
> +		TFA9879_REG(codec, SERIAL_INTERFACE_1, I2S_SET, i2s_set);

Why does this need to be reset every time, shouldn't we just be setting
the register in set_fmt().?

> +static int tfa9879_probe(struct snd_soc_codec *codec)
> +{
> +	struct tfa9879_priv *tfa9879 = snd_soc_codec_get_drvdata(codec);
> +
> +	codec->control_data = tfa9879->regmap;

This is redundant, just remove the entire function - ASoC will get the
regmap automatically.

> +	{ TFA9879_MISC_STATUS,		0x0000 }, /* 0x15, read-only */
> +};
> +
> +static bool tfa9879_volatile_register(struct device *dev, unsigned int reg)
> +{
> +	return reg == TFA9879_MISC_STATUS;

If the register is volatile it shouldn't have a default value provided.

--vsHhinrhaqUzFcVS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUW3mQAAoJECTWi3JdVIfQNzcH/jkrpR2hbM0+Nc3CidJvFmB/
TVDQ0pwlCkt94NndEhQ6NXESGdIW6hRfe69cVLEacVrab/PO+BqYWW1UG1ALHLPV
gQUgkKNdfdw124Dg3rZr4P7kvUBoOoFsXAklsgC7Vv2siIWEkHZ3m96xFOeK9QTI
9AwjkImeolPzMSAEkpl0WQQQ6++nRHePQaGCyRFdk7B7/hreq5vW0qKcH10gRqT+
VxhyEgpDTKLEPfXw+zBOy0jmbQO61wKzjSDjgkTRK2IElRu+qsyo3bpIuYys4amv
GLp4705u+F2qZs+E1xSymBivokZjjonHnuOI42aWqiqE3km+oTm7sCX5uUuCfzE=
=2899
-----END PGP SIGNATURE-----

--vsHhinrhaqUzFcVS--
