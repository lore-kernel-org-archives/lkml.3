Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933787AbaGQQ6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:58:40 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42210 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949AbaGQQ6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:58:38 -0400
Date: Thu, 17 Jul 2014 17:58:16 +0100
From: Mark Brown <broonie@kernel.org>
To: Dan Murphy <dmurphy@ti.com>
Cc: linux-sound@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org
Message-ID: <20140717165816.GA17528@sirena.org.uk>
References: <1405368645-4168-1-git-send-email-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V8Y3+xXnhQGsvjWT"
Content-Disposition: inline
In-Reply-To: <1405368645-4168-1-git-send-email-dmurphy@ti.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v7] ASoC: tas2552: Support TI TAS2552 Amplifier
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--V8Y3+xXnhQGsvjWT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 14, 2014 at 03:10:45PM -0500, Dan Murphy wrote:

There's a few smallish issues below but this is basically good so I've
applied it, please send incremental fixed for the things below.

> +	/* Turn on Class D amplifier */
> +	snd_soc_update_bits(codec, TAS2552_CFG_2, TAS2552_CLASSD_EN_MASK,
> +						TAS2552_CLASSD_EN);
> +

Why is this being done in hw_params() and not using DAPM?

> +static int tas2552_runtime_suspend(struct device *dev)
> +{
> +	struct tas2552_data *tas2552 = dev_get_drvdata(dev);
> +
> +	tas2552_sw_shutdown(tas2552, 0);
> +
> +	if (tas2552->enable_gpio)
> +		gpiod_set_value(tas2552->enable_gpio, 0);
> +
> +	regcache_cache_only(tas2552->regmap, true);
> +	regcache_mark_dirty(tas2552->regmap);

It's better to do the GPIO set after making the device cache only in
order to be sure nothing can come in and try to use the register map
between the two.

> +static void tas2552_shutdown(struct snd_pcm_substream *substream,
> +			   struct snd_soc_dai *dai)
> +{
> +	struct snd_soc_codec *codec = dai->codec;
> +
> +	snd_soc_update_bits(codec, TAS2552_CFG_2, TAS2552_PLL_ENABLE, 0);
> +}

I'd also expect the PLL power to be managed via DAPM.

> +	ret = pm_runtime_get_sync(codec->dev);
> +	if (ret < 0) {
> +		dev_err(codec->dev, "Enabling device failed: %d\n",
> +			ret);
> +		goto probe_fail;
> +	}

There's no matching put for this in remove().

> +	snd_soc_write(codec, TAS2552_CFG_2, TAS2552_CLASSD_EN |
> +				  TAS2552_BOOST_EN | TAS2552_APT_EN |
> +				  TAS2552_LIM_EN);
> +	return 0;

The class D is still being enabled here.

--V8Y3+xXnhQGsvjWT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTyAClAAoJELSic+t+oim9vFAQAIfAImcJxrutXsuM3Fsso8xF
90mVS0WTPHQdt+T/DSBJddL36I3DywPm64r7kBCA3G8vpK77Gt8FanjzDMBj3Zkn
UbPowIn158AB5UBGo9oxr6bV0pXlG8Eqcy8DatU1xyejzj1wOVfNsr5PUYpuzdCU
a2nPjh6wAkrPjydBlLlzKzQnoaoMROssSBIcRHy0+PuiyERhfsB2mTbNLecqIohr
R4GehaWEy23H1+YWGQhee2M3P5SrQd7ZsKfUEW4uZxvSqYJulvPT6EEewjJ80rRF
akRoRaz6OyazUoqrHoGd75FAb5PCWcmwPk+zl5rTtGhd27NZUODcCMzYM1fd128G
nqvUPiAPePSW82HbNyfgczLTGNpnfNjTWzDagsFeQhSg4QEdMXfFIlg3Kqmb7u17
KHtobt6XI0tkFcYiKPGhtaThZ/L+PWcRoAq0liSpsn/36U/RU9Unz4bwvMgv238m
tlJe7s08HwcHk2qI9ns5XzII2lpCbwWFh/8XSzi0Um7d3KRsQZGKxJ0plsV9B7SG
5JEBfFylCkn8gc5CBSKCItstOGg0dLOg00b+Swqt6seMCLO8VuEFoL1M7oAvtXe9
GXmxB9SquIBty5uRwgrr2my0LH4CxpsC9Hx1rrTXt5sn5Gzc1D+8I4jj/KRwCQ9D
0W2Mr8L4OPHPkhMUxdsn
=7QW7
-----END PGP SIGNATURE-----

--V8Y3+xXnhQGsvjWT--
