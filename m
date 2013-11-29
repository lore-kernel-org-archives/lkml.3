Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab3K2SjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 13:39:09 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49304 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634Ab3K2SjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 13:39:06 -0500
Date: Fri, 29 Nov 2013 18:38:55 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        fabio.estevam@freescale.com, LW@KARO-electronics.de, oskar@scara.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20131129183855.GI27568@sirena.org.uk>
References: <1385621219-20652-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Vo48LVc30GAQuLuW"
Content-Disposition: inline
In-Reply-To: <1385621219-20652-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Boycott meat -- suck your thumb.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] ASoC: SGTL5000: Fix kernel failed while trying to get
 optional VDDD supply.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Vo48LVc30GAQuLuW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 28, 2013 at 02:46:59PM +0800, Xiubo Li wrote:

> +static int sgtl5000_external_vddd_used(struct snd_soc_codec *codec)
> +{
> +	struct regulator *consumer;
> +	struct sgtl5000_priv *sgtl5000 = snd_soc_codec_get_drvdata(codec);
> +
> +	consumer = regulator_get_optional(codec->dev,
> +			sgtl5000->supplies[VDDD].supply);
> +	if (IS_ERR(consumer))
> +		return 0;
> +
> +	regulator_put(consumer);
> +
> +	return 1;
> +}

This is broken with respect to deferred probe, deferred probe returns
an error when an external regulator is in use but not yet registered.
The driver needs to at least handle -EPROBE_DEFER specially here.

It's also not nice to get the regulator, release it and get it again
which you end up needing to do because...

> -	ret = regulator_bulk_get(codec->dev, ARRAY_SIZE(sgtl5000->supplies),
> +	if (sgtl5000_external_vddd_used(codec)) {
> +		ret = regulator_bulk_get(codec->dev,
> +				ARRAY_SIZE(sgtl5000->supplies),
>  				sgtl5000->supplies);

...I think my previous comments about this code being poorly structured
in the existing driver stand.  The bulk get should be used for the
supplies that are always needed and a separate optional get should be
used for this one.

--Vo48LVc30GAQuLuW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSmN87AAoJELSic+t+oim9A4wP/iMAtV26UeHAzFwiBIrDyv3F
rjnMxzqBbGUlwtsAzj+W6Lq9QNYw9PYbjQpK1jUaV3yi+X48deGxMtsitD3o+INA
aebVjrCvoyxRS6WZmeQLGHQxLOgqL4/mBQRHoywKkLvC1EamGWiscPK3pMpLl9ZH
JEvaKBl/0cLuYdXHjmBJUuBVtVKrBFJ1Hp5rxU0m0kaq7cnj8zqxac3AW2QSdKXU
joetOIFevBCYwEi88KRyM13ywAirqRhZJxZSywUibP9HaNtStmWCW8wgNXvRlfW6
Nfa/JzNH5jkJaekLMoFZeJpM25FNQvcvpWsjCj8wlY96W5LNvncaMKpD4ZpL/Ujx
bxpXKFoQrdtVwKEibkyRY6uGI9YH87coGFD6MbSd3vZdkFobqyIVHNsw1Pq40aYd
sCCKh45oY4YXZ3MFBP4AG1gHYRBwlGuGgr3X5kDjQfQ2iOcWLDFAVRswtMHGtMy0
aW/MmOAbIluRECA4JhcS3ajzop9AL2UAe6k5O7MKAWYjdPmTipDZnLKq9KHyQp1L
QUrBs/PQKAzEwR1Eid5xyzFPhmYkb14S8nodoB2/nSqrHLH6GP+gN6up0ja7/uxp
RphXSAGh/rGlYszajxi/nA+pmAcdeoOz/7wnLU7mlldhK8vZFI5pfHi+z+VYBZb4
0bQ0w3bThK3qmUrbTjwA
=K+bz
-----END PGP SIGNATURE-----

--Vo48LVc30GAQuLuW--
