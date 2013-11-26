Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab3KZNpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 08:45:00 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59461 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab3KZNo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 08:44:59 -0500
Date: Tue, 26 Nov 2013 13:44:11 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        fabio.estevam@freescale.com, LW@KARO-electronics.de, oskar@scara.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20131126134411.GQ14725@sirena.org.uk>
References: <1385459713-6778-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="enbeIAqa8YisR7TD"
Content-Disposition: inline
In-Reply-To: <1385459713-6778-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Your supervisor is thinking about you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv1] ASoC: SGTL5000: Fix kernel failed while getting
 regulator consumers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--enbeIAqa8YisR7TD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 26, 2013 at 05:55:13PM +0800, Xiubo Li wrote:

> +static int sgtl5000_external_vddd_used(struct snd_soc_codec *codec)
> +{
> +	struct regulator *consumer;
> +	struct sgtl5000_priv *sgtl5000 =3D snd_soc_codec_get_drvdata(codec);
> +
> +	consumer =3D regulator_get(codec->dev, sgtl5000->supplies[VDDD].supply);
> +	if (IS_ERR(consumer)) {
> +		return 0;
> +	}
> +	regulator_put(consumer);
> +
> +	return 1;
> +}

This is going to fail to do what you expect if a dummy regulator is
substituted which it will almost all of the time when the supply is
genuinely absent.  It's also going to interact poorly with probe
deferral.

> -	ret =3D regulator_bulk_get(codec->dev, ARRAY_SIZE(sgtl5000->supplies),
> -				sgtl5000->supplies);
> -	if (!ret)
> +	if (sgtl5000_external_vddd_used(codec))
>  		external_vddd =3D 1;
>  	else {
>  		ret =3D sgtl5000_replace_vddd_with_ldo(codec);

This looks buggy, it removes the regulator_get() for most of the
supplies for the device.

I think the driver may want to use regulator_get_optional(), though
looking at the fact that there's an external_vdd flag there already it
seems like there's already some attempt to handle these configuratins in
the driver that isn't working so perhaps that just needs to be fixed.
Or possibly DTs need to be changed to describe the supply. =20

I'd expect to see a commit description that describes how the driver
currently tries to handle this, why it doesn't work and how the patch
fixes it.  Right now it seems like the change is jumping to a solution
without understanding the problem and making some already problematic
code more confused.

--enbeIAqa8YisR7TD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSlKWoAAoJELSic+t+oim9jvEP/jiqKsqaqMskeVpdahMP0xmk
p8qQ76t45yX0wYbNoDh7Fo35p919a1oS22Q225Z7LpkpFmceTfYjn8ZkL9277yNq
MamaIOZaJM3/6FnMUb/NfRl+3rFN7R9xCepqb+s7twyjhp2RLHdKuasFG69jFqsV
uzIE+1lGOPaIxD+OvP9xeNYoZSfIOmrJkSljpfMt/gnLqEBjLKuIsAA0/Bd0HyMj
HkUIOUcOH7ceUBQPim0Lr95EZoD7vv2BzpT8lgvqJFUe5s03+swLajOMisvAiHeV
6KBXgngLdiybDPYbKguzEW3LiAGidKxYbwWL/ydvGSn2UvonHPXTAryZzPUevvEz
4ANo9Eld2JagmxLO8brXSLdM4Z/MtKTSoKZrH32LKblyY6SLyvluSEACktCuWexm
HdLcfQtHTjZMfw2Ig7MUPN9EF2pLmzclvhDhAwuBg16c5CenU79ODZGZFvMWXtr+
vKyiVfpQ5lBLzy4jplnkV6QbPqixwecY6ueOEquSt9qer45YL9G6V60qO2tWMcyB
GYBy3kJTn6zgF0EdV37N5lE+pO0a3pXThb8R/fxv3FBpIUdDmwRf37Ez8Y9oVWJZ
nzLvZZtiqP/4Tlmf9793koJC5bIJ/dmZTtukLL2NFaZv1v3FG8hB3kYxuQEtyvOZ
UZz8l0ruvtCIF2UorNKZ
=BShb
-----END PGP SIGNATURE-----

--enbeIAqa8YisR7TD--
