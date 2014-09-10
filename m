Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbaIJKyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 06:54:19 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37269 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbaIJKyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 06:54:18 -0400
Date: Wed, 10 Sep 2014 12:53:59 +0200
From: Markus Pargmann <mpa@pengutronix.de>
To: Shengjiu Wang <shengjiu.wang@freescale.com>
Cc: Nicolin Chen <nicoleotsuka@gmail.com>, timur@tabi.org,
        Li.Xiubo@freescale.com, lgirdwood@gmail.com, broonie@kernel.org,
        perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V1] ASoC: fsl_ssi: refine ipg clock usage in this module
Message-ID: <20140910105359.GA16489@pengutronix.de>
References: <e5a50d8bfde3aea5fcd092118da5aea4072c7e2f.1410254125.git.shengjiu.wang@freescale.com>
 <20140909183804.GA6944@Asurada>
 <20140910062118.GA26348@pengutronix.de>
 <20140910103005.GB17326@audiosh1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <20140910103005.GB17326@audiosh1>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:34:17 up  3:21, 34 users,  load average: 0.03, 0.04, 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Sep 10, 2014 at 06:30:06PM +0800, Shengjiu Wang wrote:
> On Wed, Sep 10, 2014 at 08:21:18AM +0200, Markus Pargmann wrote:
> > On Tue, Sep 09, 2014 at 11:38:05AM -0700, Nicolin Chen wrote:
> > > On Tue, Sep 09, 2014 at 05:18:07PM +0800, Shengjiu Wang wrote:
> > > > @@ -1321,7 +1333,11 @@ static int fsl_ssi_probe(struct platform_dev=
ice *pdev)
> > > >  		return -ENOMEM;
> > > >  	}
> > > > =20
> > > > -	ssi_private->regs =3D devm_regmap_init_mmio(&pdev->dev, iomem,
> > > > +	if (ssi_private->soc->imx)
> > > > +		ssi_private->regs =3D devm_regmap_init_mmio_clk(&pdev->dev,
> > > > +			"ipg", iomem, &fsl_ssi_regconfig);
> > > > +	else
> > > > +		ssi_private->regs =3D devm_regmap_init_mmio(&pdev->dev, iomem,
> > >=20
> > > As Markus mentioned, the key point here is to be compatible with those
> > > non-clock-name platforms.
> > >=20
> > > I think it would be safer to keep the current code while adding an ex=
tra
> > > clk_disable_unprepare() at the end of probe() as a common routine. And
> > > meantime, make sure to have the call for imx only because it seems th=
at
> > > the other platforms do not depend on the clock. //a bit guessing here=
 :)
> > >=20
> > > Then we can get a patch like:
> > > open() {
> > > +	clk_prepare_enable();
> > > 	....
> > > }
> > >=20
> > > close() {
> > > 	....
> > > +	clk_disable_unprepare()
> > > }
> > >=20
> > > probe() {
> > > 	clk_get();
> > > 	clk_prepare_enable();
> > > 	....
> > > 	if (xxx)
> > > -		goto err_xx;
> > > +		return ret;
> > > 	....
> > > +	clk_disable_unprepare();
> > > 	return 0;
> > > -err_xx:
> > > -	clk_disable_unprepare()
> > > }
> > >=20
> > > remove() {
> > > 	....
> > > -	clk_disable_unprepare()
> > > }
> >=20
> > If I remember correctly, there may be AC97 communication with the codec
> > before any substream is created. That's why we enable the SSI unit right
> > at the beginning for AC97 in fsl_ssi_setup_reg_vals(). So we need to
> > check for AC97 before disabling clocks.
> >=20
> > Best regards,
> >=20
> > Markus
>=20
> hi Markus
>=20
> I think if clk_prepare_enable() in startup(), and clk_disable_unprepare()
> in shutdown can meet this requirement, right?

Yes that could work.

>=20
> done:
>         if (ssi_private->dai_fmt)
>                 _fsl_ssi_set_dai_fmt(ssi_private, ssi_private->dai_fmt);
>=20
> I find that in end of probe, there is setting of dai_fmt. Can we remove t=
his?
> because this setting need to enable ipg clock, and if ac97, ipg clock can=
't be
> disabled.

No you can't remove it. It is necessary for the DT property "fsl,mode".
Most dts do not have this property anymore because the sound cards are
setting the dai-fmt. But there are still some powerpc dts files that
contain that property.

Best regards,

Markus

--=20
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUEC3HAAoJEEpcgKtcEGQQZzwQAIVVINoEJjvi/FANlG/mhPoW
HMsfwFYgkJUfbLo2+tzsOdQ3rIYNxw6rlaRruwNP7D/cfTa2vY0RUszKRoPS6+lR
MYYC52JKEjZHcEK/4yU8j3xCrC9/lOfsKPv7IXdjwE3iXHBOCeaUIp7Fy5cVlhSu
SQHfPs1FFF5kRIbcXdls+Pd5Wy1j2hT+lymX8NFGx8icOuLvHk2PVvqlL/EQPf8J
2UUrydscZvRkjzJI0KL2F0VT3I10/6GHdxIvzzQDBOIW8QlRqReaZsYm5udhkMTl
OVkDWWkafmukhv5+8jjMDLqj0Mqx2FCGNsL/Bse5ClN5u8qGAG1+9OooL3ekbAGc
ZnsrVMz97iKhhwCNlECmoGDQX+E+Pt7bVuXGfSBJLG4TuojFtotGqjH+vQhruROw
kHHDSt9SAHSuJNlDU8i1Z6vYVgWfUbJl5GekB+tkmkprnOo4LaZL6D0+sHZCQolW
m0KzFwpXHgyUDuW85VSjWhYpUcy3/CKEFcaXIjV4TvCQb6LCELQTiXDJskbl2MHv
D6gdyp9Jdqi9buHgeuOOwUnJH7omAjKFKFgWciVNu3SBp8w/dmzS2kZvBBUeUcTZ
heKDdLTXigpD8/2cSe2BhRiWo1s1H67GeOT3MLKaUvJVliE+kVZozdZsWYPSnTiL
wcBVOpLSxoXyRy6sHg5n
=C5g+
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
