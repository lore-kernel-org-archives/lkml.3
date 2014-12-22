Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbaLVSLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 13:11:22 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44252 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134AbaLVSLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 13:11:21 -0500
Date: Mon, 22 Dec 2014 18:10:45 +0000
From: Mark Brown <broonie@kernel.org>
To: Zidan Wang <b50113@freescale.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de, lars@metafoo.de,
        ckeepax@opensource.wolfsonmicro.com, Li.Xiubo@freescale.com,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20141222181045.GH17800@sirena.org.uk>
References: <1418103916-31295-1-git-send-email-b50113@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wO3ULb5M+sQS9v8+"
Content-Disposition: inline
In-Reply-To: <1418103916-31295-1-git-send-email-b50113@freescale.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 31.51.36.65
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel][PATCH v4] ASoC: wm8960: Let wm8960 codec driver
 manage its own MCLK
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wO3ULb5M+sQS9v8+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 09, 2014 at 01:45:16PM +0800, Zidan Wang wrote:

> @@ -1002,6 +1005,13 @@ static int wm8960_i2c_probe(struct i2c_client *i2c,
>  	if (wm8960 =3D=3D NULL)
>  		return -ENOMEM;
> =20
> +	wm8960->mclk =3D devm_clk_get(&i2c->dev, "codec_mclk");
> +
> +	if (IS_ERR(wm8960->mclk)) {
> +		if (PTR_ERR(wm8960->mclk) =3D=3D -EPROBE_DEFER)
> +			return -EPROBE_DEFER;
> +	}
> +
>  	wm8960->regmap =3D devm_regmap_init_i2c(i2c, &wm8960_regmap);
>  	if (IS_ERR(wm8960->regmap))
>  		return PTR_ERR(wm8960->regmap);
> @@ -1041,6 +1051,9 @@ static int wm8960_i2c_probe(struct i2c_client *i2c,
> =20
>  	i2c_set_clientdata(i2c, wm8960);
> =20
> +	pm_runtime_enable(&i2c->dev);
> +	pm_request_idle(&i2c->dev);
> +
>  	ret =3D snd_soc_register_codec(&i2c->dev,
>  			&soc_codec_dev_wm8960, &wm8960_dai, 1);
> =20

This isn't going to work if PM is disabled (which is still a valid
configuration).  The general idiom for this is that the driver should
start up with everything powered up then let runtime idle turn things
off if they're not required.  That way if runtime PM is disabled then
the system will still work as everything will just stay powered on all
the time.

--wO3ULb5M+sQS9v8+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUmF6kAAoJECTWi3JdVIfQ9n8H/jDkI+AF1J45YFitFrMTJjCo
CQQYAdtDsiHKYxuvnzcAScVD88MKqn2xsCqcOVOjPhbEu2JdrqyJn8oYmnl+jhNe
6d5Qe4cFEcrbFPhz0Pd50RBUAIGkFYXhCwrCZ7Wj0hHICG+hJTBa2UgnJMEfk1Rk
4XNH1y029o1rjV4W+jNOM/+bXvyhleuk9ZoGgEefiIhggFwNMQgXj8+wjW30VVjN
sCoBsFZysq+XKmnRSIXLTCbI9dVo0RBX4qKMStGXoor8O96LP3IdHitYVsIG2JZ6
YpfxnMDN/9FCFKnpkxN9WPrR0mtTwDtK7AdsYSFMAucfj50fini76hgyTeAfXY0=
=sRzo
-----END PGP SIGNATURE-----

--wO3ULb5M+sQS9v8+--
