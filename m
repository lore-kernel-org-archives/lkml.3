Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751176AbaIJGVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 02:21:35 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58393 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbaIJGVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 02:21:34 -0400
Date: Wed, 10 Sep 2014 08:21:18 +0200
From: Markus Pargmann <mpa@pengutronix.de>
To: Nicolin Chen <nicoleotsuka@gmail.com>
Cc: Shengjiu Wang <shengjiu.wang@freescale.com>, timur@tabi.org,
        Li.Xiubo@freescale.com, lgirdwood@gmail.com, broonie@kernel.org,
        perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V1] ASoC: fsl_ssi: refine ipg clock usage in this module
Message-ID: <20140910062118.GA26348@pengutronix.de>
References: <e5a50d8bfde3aea5fcd092118da5aea4072c7e2f.1410254125.git.shengjiu.wang@freescale.com>
 <20140909183804.GA6944@Asurada>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
In-Reply-To: <20140909183804.GA6944@Asurada>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:13:14 up 24 days, 18:33, 75 users,  load average: 0.20, 0.09,
 0.06
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 09, 2014 at 11:38:05AM -0700, Nicolin Chen wrote:
> On Tue, Sep 09, 2014 at 05:18:07PM +0800, Shengjiu Wang wrote:
> > @@ -1321,7 +1333,11 @@ static int fsl_ssi_probe(struct platform_device =
*pdev)
> >  		return -ENOMEM;
> >  	}
> > =20
> > -	ssi_private->regs =3D devm_regmap_init_mmio(&pdev->dev, iomem,
> > +	if (ssi_private->soc->imx)
> > +		ssi_private->regs =3D devm_regmap_init_mmio_clk(&pdev->dev,
> > +			"ipg", iomem, &fsl_ssi_regconfig);
> > +	else
> > +		ssi_private->regs =3D devm_regmap_init_mmio(&pdev->dev, iomem,
>=20
> As Markus mentioned, the key point here is to be compatible with those
> non-clock-name platforms.
>=20
> I think it would be safer to keep the current code while adding an extra
> clk_disable_unprepare() at the end of probe() as a common routine. And
> meantime, make sure to have the call for imx only because it seems that
> the other platforms do not depend on the clock. //a bit guessing here :)
>=20
> Then we can get a patch like:
> open() {
> +	clk_prepare_enable();
> 	....
> }
>=20
> close() {
> 	....
> +	clk_disable_unprepare()
> }
>=20
> probe() {
> 	clk_get();
> 	clk_prepare_enable();
> 	....
> 	if (xxx)
> -		goto err_xx;
> +		return ret;
> 	....
> +	clk_disable_unprepare();
> 	return 0;
> -err_xx:
> -	clk_disable_unprepare()
> }
>=20
> remove() {
> 	....
> -	clk_disable_unprepare()
> }

If I remember correctly, there may be AC97 communication with the codec
before any substream is created. That's why we enable the SSI unit right
at the beginning for AC97 in fsl_ssi_setup_reg_vals(). So we need to
check for AC97 before disabling clocks.

Best regards,

Markus

--=20
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUD+3eAAoJEEpcgKtcEGQQpIwP/13uS6ra+9yDsKky0JK7ndGC
Rh2J1DaRbJLJ3xw0iDbY9FzccLVUCfhyxc1fRtkr4o2fjPztA5fBKv9lj1j0cWpk
LhsW4ceHxZECUNOFIq+ZzW8C7dEk9fVYTVGsMeC5phbrGrg0C860B5Sa0S0ZbF8u
wRxpKr1GElW0+Z5fXlzhWbORxO5oqKQhMYJoyM9hPdmM51olzI4AtqylgddmbURO
jjebQv6XG25rbYdlHgWxjwJ7QjePEdmKC1lATApANItTEZtMtEG9Swm37PS+D+Yf
efLXDhWYyw9cj/vSxBoze0cBG90SUaHn10rbjOSlYyYm7of78uisyeG7IFL0h20e
+dOaT5YbxC/JDLpjCWOo77aMdrfYmkU9hKlaZXs2XM1N0Eour1zVjPB4TUZVAa0a
foE6+66vOkM8XfmHQBEH4z/L7yq/8PIJBtTVBYdN+41/0Ql3cu70OHFKzoXdW+QG
GEffwkIOJYts0SAtVRUSb2ZIvIdU8U8SEM335zqOwOy1iPKDtBQa40WAWYJFz/Sy
hZyqsb68uW7TZENSh5m24JCwzpxUOg3C7YDoQCmpKTxWjeSIwdhnsMO+0k4C9aXT
d1xXFaHh9+mPjmJ+AngG+U2b6Vbd7lxkxcbteGE35XuFHA6+wj5KL43XQmKympFT
P4R0PBncjKGHy82hV++M
=KAho
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
