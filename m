Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319AbaGNSnp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 14:43:45 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37351 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548AbaGNSnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 14:43:39 -0400
Date: Mon, 14 Jul 2014 19:43:21 +0100
From: Mark Brown <broonie@kernel.org>
To: Dan Murphy <dmurphy@ti.com>
Cc: linux-sound@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org
Message-ID: <20140714184321.GW6800@sirena.org.uk>
References: <1405093489-11897-1-git-send-email-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RMorpr61ug7CvG36"
Content-Disposition: inline
In-Reply-To: <1405093489-11897-1-git-send-email-dmurphy@ti.com>
X-Cookie: Above all else -- sky.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v6] ASoC: tas2552: Support TI TAS2552 Amplifier
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RMorpr61ug7CvG36
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 11, 2014 at 10:44:49AM -0500, Dan Murphy wrote:

> @@ -754,4 +755,8 @@ config SND_SOC_TPA6130A2
>  	tristate "Texas Instruments TPA6130A2 headphone amplifier"
>  	depends on I2C
> =20
> +config SND_SOC_TAS2552
> +	tristate "Texas Instruments TAS2552 Mono Audio amplifier"
> +	depends on I2C
> +
>  endmenu

Keep this and Makefile sorted - since this is a proper CODEC driver it
should be in with the CODECs and also sorted in alphabetical order.

> +static int tas2552_startup(struct snd_pcm_substream *substream,
> +			   struct snd_soc_dai *dai)
> +{
> +	struct snd_soc_codec *codec =3D dai->codec;
> +
> +	pm_runtime_get_sync(codec->dev);
> +
> +	return 0;
> +}
> +
> +static void tas2552_shutdown(struct snd_pcm_substream *substream,
> +			   struct snd_soc_dai *dai)
> +{
> +	struct snd_soc_codec *codec =3D dai->codec;
> +
> +	pm_runtime_put(codec->dev);
> +}

These runtime calls should be redundant, the framework should hold a
runtime PM reference on devices while they are active.  Does this not
work for you?

> +	pm_runtime_get_sync(codec->dev);

Check the return value here.

> +	snd_soc_write(codec, TAS2552_CFG_2, TAS2552_CLASSD_EN |
> +				  TAS2552_BOOST_EN | TAS2552_APT_EN |
> +				  TAS2552_PLL_ENABLE | TAS2552_LIM_EN);

The PLL is enabled all the time not via DAPM or similar (it's never
disabled)?

> +static int tas2552_resume(struct snd_soc_codec *codec)
> +{
> +	struct tas2552_data *tas2552 =3D snd_soc_codec_get_drvdata(codec);
> +	int ret;
> +
> +	ret =3D regulator_bulk_enable(ARRAY_SIZE(tas2552->supplies),
> +				    tas2552->supplies);
> +
> +	if (ret !=3D 0) {
> +		dev_err(codec->dev, "Failed to enable supplies: %d\n",
> +			ret);
> +	}
> +
> +	pm_runtime_get_sync(codec->dev);

Remove these runtime PM calls from suspend and resume, they're not doing
what you think (and will prevent runtime PM from doing anything).  Let
the frameworks worry about it for now, or explicitly call the runtime
suspend and resume operators if and only if the device is runtime
active.

> +	for (i =3D 0; i < ARRAY_SIZE(data->supplies); i++)
> +		data->supplies[i].supply =3D tas2552_supply_names[i];
> +
> +	ret =3D devm_regulator_bulk_get(dev, ARRAY_SIZE(data->supplies),
> +				      data->supplies);
> +	if (ret !=3D 0)
> +		dev_err(dev, "Failed to request supplies: %d\n", ret);

These supplies are mandatory (as they should be) but weren't mentioned
in the DT binding - please add them there.

> +static const struct i2c_device_id tas2552_id[] =3D {
> +	{ "tas2552-codec", 0 },
> +	{ }
> +};

No -codec.

--RMorpr61ug7CvG36
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTxCTGAAoJELSic+t+oim9nAgQAIrmTZMVO2kaoAnVjddXToCa
9BDz7g38s+Fvv4xOyEVbfmb3S5nznqYQuWjVouRo6iFJH/O/mvsIffZVA4GqiyrF
s2c6GTxgcnHewShoQLtVy9WMnhGIxCMb8fYzSHmU9Ml099HsknVSX9pJNZdn4UBD
NyY8Iw2vihTAs+G+aZYqu80/O1ByqsF0no2qi8qgduBLg7NbQyOXPAE1mKkWUOkl
P/sOtcnfr7sujjMIHC5e9/5DgrfrOwq2TzfaR9/yBP4wr+mq/ole3heisNdHHiPy
wD+0Bemum/EiBT6RO3osJVvSc+jxsirH6Gz79wSX5xX0PAAebegsZe9/S4OM8lVP
w732Qgftnog/+89/n5py5pz6LH2LV+Z96uqEAOpEa8ZQ8yk3EVpZYeTKZs4c7uK2
BlreWhS/xp3NtCsU7BsuVgmK0RVcjjYUkWAKznWz38azFRSpIjrJhPNQee9OaBv8
0RDVK6Sd8MtkNDo6oEEEGiXye76huK76lvteDsVXqRGDhH8Hlt59MRFw60W2FQih
ZdUAwckYanRVjGJLWHkxzWpF00/P3bTqUy2F1r04B77+NLnz54+cIAAuj3I0yHcY
DES5g6yGeqTHeAcGG3dr0eqGmV382F3V3Os9GgAbTvEHLAI/3XKH6udBulcIpQ3h
rcf3baw4MIicb91j4b63
=HxrG
-----END PGP SIGNATURE-----

--RMorpr61ug7CvG36--
