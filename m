Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbaAIOVM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 09:21:12 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50096 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096AbaAIOUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 09:20:30 -0500
Date: Thu, 9 Jan 2014 14:20:03 +0000
From: Mark Brown <broonie@kernel.org>
To: Daniel Matuschek <daniel@matuschek.net>
Cc: alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>,
        Dimitris.Papastamos@Wolfsonmicro.com, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Message-ID: <20140109142003.GV31886@sirena.org.uk>
References: <alpine.DEB.2.02.1401082231260.4025@parallels-Parallels-Virtual-Platform>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hrK/Uoh15cc91+7I"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401082231260.4025@parallels-Parallels-Virtual-Platform>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: wm8804: Allow fine-grained control of the PLL
 generation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hrK/Uoh15cc91+7I
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 08, 2014 at 10:36:53PM +0100, Daniel Matuschek wrote:
> Signed-off-by: Daniel Matuschek <daniel@matuschek.net>
>=20
>  WM8804 can run
>  with PLL frequencies of 256xfs and 128xfs for most sample
>  rates. At 192kHz only 128xfs is supported. The existing
>  driver selects 128xfs automatically for some lower samples
>  rates. By using the "pllid" argument of the "set_pll"
>  function is is now possible to control the behaviour. This
>  allows using 256xfs PLL frequency on all sample rates up to
>  96kHz. It should allow lower jitter and better signal
>  quality. When pllid=3D0, the behaviour of the driver does not
>  change.

Please put the signoff at the end of the commit log like
SubmittingPatches says.  The formatting of the log message is also
*very* odd, the first line is really short for some reason and
everything is indented by a space.  In general your commit message
shouldn't stand out from others when viewed with git log.

>   * wm8804.c  --  WM8804 S/PDIF transceiver driver
>   *
>   * Copyright 2010-11 Wolfson Microelectronics plc
> + * patched by Daniel Matuschek <info@crazyaudio.com> to allow
> + * fine-grained control of PLL

We have git history, we don't need changelogs in the driver too.  Adding
a copyright statement would be OK (though most people don't bother).

>  static int pll_factors(struct pll_div *pll_div, unsigned int target,
> -		       unsigned int source)
> +		       unsigned int source, int mclk_div)

Here you call this mclk_div...

> -			pll_div->mclkdiv =3D post_table[i].mclkdiv;
> -			target *=3D post_table[i].div;
> -			break;
> +			if ((mclk_div =3D=3D WM8804_MCLKDIV_DONTCARE) ||
> +			    ((post_table[i].mclkdiv =3D=3D 1) &&
> +				(mclk_div =3D=3D WM8804_MCLKDIV_1)) ||
> +			    ((post_table[i].mclkdiv =3D=3D 0) &&
> +				(mclk_div =3D=3D WM8804_MCLKDIV_0))) {
> +				pll_div->mclkdiv =3D post_table[i].mclkdiv;
> +				target *=3D post_table[i].div;
> +				break;
> +			}

This logic is really hard to read, it's five lines of if statement with
multiple levels of brackets indented to the same level as the following
statements.  I'd suggest either a series of if statements with continues
or something like

	if (mclk_div =3D=3D WM8804_MCLKDIV_DONTCARE ||
	    mclk_div - 1 =3D=3D post_table[i].mclkdiv) {

instead.

> @@ -388,7 +396,7 @@ static int wm8804_set_pll(struct snd_soc_dai *dai, in=
t pll_id,
>  		int ret;
>  		struct pll_div pll_div;
>=20
> -		ret =3D pll_factors(&pll_div, freq_out, freq_in);
> +		ret =3D pll_factors(&pll_div, freq_out, freq_in, pll_id);

=2E..but here it's pll_id.

> +#define WM8804_MCLKDIV_DONTCARE			0
> +#define WM8804_MCLKDIV_0			1
> +#define WM8804_MCLKDIV_1			2
> +#define WM8804_PLL_MCLKDIV_DONTCARE		WM8804_MCLKDIV_DONTCARE
> +#define WM8804_PLL_MCLKDIV_0			WM8804_MCLKDIV_0
> +#define WM8804_PLL_MCLKDIV_1			WM8804_MCLKDIV_1

Why are there two different sets of constants with the same values being
added here, the _PLL versions don't seem to be referenced?

--hrK/Uoh15cc91+7I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSzrAQAAoJELSic+t+oim9HC4P/3RkvOSr0bs3tSPB2RKtPMlS
prtWS2dVLzOVww+dPXEgC2XozfILiOxSj7VH15RMvhNCg4vOYEj8At8u0xHwzC7A
RYpQhAun8ZvC7SrNGzVHXULAWaQqBaTWeUApNg3T1whWeuNGU8OPz9YilLoDkiE8
kaYsByvORVKsOb0fzgERMgMm1TMg21sFzHUkW1Udn3xh8NzqqJeP5s16oZZu4CdA
j0LcI7SfzGBA5h0Y7bg1ojVh6bFxJfFnSK2DYoFdTei3CNwjQbXU7lL3r5/WjM0p
8f4Hei1UDzqXkyjkUsf4J3c56s85gYbyy3hnPBhTCcksexFaE4y4phuuDUWPRE7a
bDD9BIwnZPHOcLnUdjckr3HmmzkEALUcUrJQk7hapOC5WhKA/omJ6jnqLO8Yj5ju
+6t8/Y6jNVXlWJLQdBN9ZTaNABeop42b8xvfPlg31v/pvdI+W8ZQQ6L8EV8tK8c8
dMRNo/v0UTvlijbOF83G1vMNQXtDJI3tYal3Nlj55trHZPudbvvJZ2hnPrAGAqlI
tLt0F2WGt6wgnvRWEHRyf6ciqEWiV9nxQOrQjCwY7WdDqfgklT1860BWgvOo1ufz
YRBzKcr8xL0u6grZxn3HZP/KQU0fi2GTzKg2LG6SSC+AEZ9ywi2ekRHhTbGxhhPu
CV2A2k2bnBrqiJJm1wi7
=Er8p
-----END PGP SIGNATURE-----

--hrK/Uoh15cc91+7I--
