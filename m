Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbaLCMlv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 07:41:51 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47050 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbaLCMlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 07:41:50 -0500
Date: Wed, 3 Dec 2014 12:41:24 +0000
From: Mark Brown <broonie@kernel.org>
To: Zidan Wang <b50113@freescale.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de, lars@metafoo.de,
        ckeepax@opensource.wolfsonmicro.com, Li.Xiubo@freescale.com,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20141203124124.GW7712@sirena.org.uk>
References: <1417604438-28362-1-git-send-email-b50113@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GP4Le6z6inNsfFpS"
Content-Disposition: inline
In-Reply-To: <1417604438-28362-1-git-send-email-b50113@freescale.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel][PATCH] ASoC: wm8960: Let wm8960 codec driver manage
 its own MCLK
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GP4Le6z6inNsfFpS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 03, 2014 at 07:00:38PM +0800, Zidan Wang wrote:

>  #include <sound/core.h>
> @@ -988,6 +990,8 @@ static void wm8960_set_pdata_from_of(struct i2c_clien=
t *i2c,
> =20
>  	if (of_property_read_bool(np, "wlf,shared-lrclk"))
>  		pdata->shared_lrclk =3D true;
> +
> +	pdata->mclk =3D devm_clk_get(&i2c->dev, NULL);

This isn't platform data then...  we also need to check the return code
here and handle at least probe deferral.

> +    /* Mark the mclk pointer to NULL if no mclk assigned */
> +	if (IS_ERR(wm8960->pdata.mclk)) {

Indentation is wrong for the comment here.

> +		/* But do not ignore the request for probe defer */
> +		if (PTR_ERR(wm8960->pdata.mclk) =3D=3D -EPROBE_DEFER)
> +			return -EPROBE_DEFER;
> +		wm8960->pdata.mclk =3D NULL;
> +	}

OK, so we are trying to handle probe deferral - but this should be next
to the clk_get().

> +	if (wm8960->pdata.mclk) {
> +		ret =3D clk_prepare_enable(wm8960->pdata.mclk);

Just continue to use !IS_ERR() - NULL is a valid clock.

> +static int wm8960_runtime_suspend(struct device *dev)
> +{
> +	struct wm8960_priv *wm8960 =3D dev_get_drvdata(dev);
> +
> +	/* Power down PLL to save power */
> +	regmap_update_bits(wm8960->regmap, WM8960_POWER2, 0x1, 0);

This isn't undone by the resume.

--GP4Le6z6inNsfFpS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUfwTzAAoJECTWi3JdVIfQz7sH/jfmau9pbKLeuJLayh4Ejnvs
zvFcixhIk2fkZupvvnM4w4Ffcpv+pi+xmzLDQsOomDaN6dNaSLqa28x7EyM7li2u
ggtNnDrwDVg1Ypddx9TURseJTtAlwAE1sWjHnoPMttRqjvwsUzbUeZ3gWYgvZNG6
Huva8NJxoz9i/+OQpfBO+UqtK9esYrKQ6FdgpYuTIc2oLduJAv34HBiL+7r7sBhI
P+Iqw4iJL9TED21mCMqbN2lAk8qxP5XtUidtxBgOcItqye/b4uM7cezYzegMHJ8L
oqWYqI5+Pio5KvCaGpIDOeisjjS14269ci6Er9w4GHA7p5g+hyjpVTJutFVNC0s=
=2prM
-----END PGP SIGNATURE-----

--GP4Le6z6inNsfFpS--
