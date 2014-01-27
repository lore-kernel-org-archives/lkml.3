Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbaA0UmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 15:42:20 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60343 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996AbaA0UmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 15:42:19 -0500
Date: Mon, 27 Jan 2014 20:42:03 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: alsa-devel@alsa-project.org, Dave Airlie <airlied@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Message-ID: <20140127204203.GX11841@sirena.org.uk>
References: <cover.1390813480.git.moinejf@free.fr>
 <a62784e8778d06512d49a24dcf59ff9e45839902.1390813481.git.moinejf@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+smLgjZrX8DJCqNF"
Content-Disposition: inline
In-Reply-To: <a62784e8778d06512d49a24dcf59ff9e45839902.1390813481.git.moinejf@free.fr>
X-Cookie: O.K., fine.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/4] ASoC: tda998x: add a codec driver for TDA998x
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+smLgjZrX8DJCqNF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 26, 2014 at 07:45:36PM +0100, Jean-Francois Moine wrote:

>  	select SND_SOC_STAC9766 if SND_SOC_AC97_BUS
>  	select SND_SOC_TAS5086 if I2C
> +	select SND_SOC_TDA998X if I2C

> +config SND_SOC_TDA998X
> +	tristate
> +	depends on OF
> +	default y if DRM_I2C_NXP_TDA998X=y
> +	default m if DRM_I2C_NXP_TDA998X=m
> +

These two things don't seem to agree with each other, and I expect this
breaks the build for ALL_CODECS.

> +static void tda_get_encoder(struct tda_priv *priv)
> +{
> +	struct snd_soc_codec *codec = priv->codec;
> +	struct device_node *np;
> +	struct i2c_client *i2c_client;
> +	static const struct of_device_id tda_dt[] = {
> +		{ .compatible = "nxp,tda998x" },
> +		{ },
> +	};
> +
> +	/* search the tda998x device */
> +	np = of_find_matching_node_and_match(NULL, tda_dt, NULL);
> +	if (!np || !of_device_is_available(np)) {
> +		dev_err(codec->dev, "No tda998x in DT\n");
> +		return;
> +	}
> +	i2c_client = of_find_i2c_device_by_node(np);
> +	of_node_put(np);
> +	if (!i2c_client) {
> +		dev_err(codec->dev, "no tda998x i2c client\n");
> +		return;
> +	}
> +	if (!i2c_get_clientdata(i2c_client)) {
> +		dev_err(codec->dev, "tda998x not initialized\n");
> +		return;
> +	}
> +
> +	priv->i2c_client = i2c_client;
> +}

The normal way of doing this would be to make the device a MFD - that
way the frameworks make sure probe ordering and so on are sorted out.
Other than that this looks basically OK, a few small comments below.

> +	/* give the audio input type and ports to the HDMI encoder */
> +	format = start ? priv->dai_id : 0;

It's not clear to me what the above is doing (I think I know but it
requires thinking about rather than being clear).

> +static const struct snd_soc_dai_driver tda998x_dai[] = {
> +    {
> +	.name = "i2s-hifi",

Coding style, indents are tabs.

--+smLgjZrX8DJCqNF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5sSYAAoJELSic+t+oim9/q0P/0NijLlc2Ajqfpptgf8bfG16
gPZR0oj8fRn1SrD6E1HHjsbQhm3sv8OfyX6cJoy3iCC/ZYjcKVL4Goyje4v7xPyB
rEJQJ/AWivXGNract7mYp1s+I4M/91RHbyCeLEvb7YTtHmbwFGhZxjXJGuwaSHFs
cHM5vkpw/prMe304iPOvHTxQXnI1HzxuWKxiCOGF9f9h3oxZyndbeUS7B+Yo1SJq
SA3ml5J6rstfqBH3WIR67w/kKJ8HclhBCbd1bKiadAmAJkZ46oD0v9T4cHi5QG+2
UL00YtWDbGznjFtH6a4Q6hiIjo2MpZa41TODxMs5zEIT19Jq6qgoheShq+GU6nJG
ReveBHgeMNdqGD8n7DGH3IvxYaRZt0F+hEO2Zz1iC/g6PscyxMYCWRmWco5b3tnj
9cV6cH02geMRpOlXUBAzKcXu0IC+cIrskjYZUjF8pLTasj2mysRHrSn83SFsLHBa
7fh5o7r8Qh5umy7J0Zi09JSmFfNatu+fb1KhcDEEeiSYu7hZwlwNGRttPmQG3KOO
aLfZAdFH2sdRO6MqNHB+Gy4pfnPFdHH8OpUoZaE/wOe55p5wHTMyHUpkNNImD5P3
/CkhlCZHcKD5nVwCxw5WUY6l7seSlLNxmv9SlsO54LiV1kfuX5uC5p/u5mLvpiZi
LKplvxsifXaFZgcyl1jb
=EpZ5
-----END PGP SIGNATURE-----

--+smLgjZrX8DJCqNF--
