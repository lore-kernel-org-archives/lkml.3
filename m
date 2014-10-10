Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbaJJGBA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 02:01:00 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44993 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbaJJGA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 02:00:57 -0400
Date: Fri, 10 Oct 2014 08:00:43 +0200
From: Markus Pargmann <mpa@pengutronix.de>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH v2 2/4] regulator: Set ena_gpio_initialized in regulator
 drivers
Message-ID: <20141010060043.GA26053@pengutronix.de>
References: <1412776028-15655-1-git-send-email-mpa@pengutronix.de>
 <1412776028-15655-3-git-send-email-mpa@pengutronix.de>
 <1412780013.31093.7.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
In-Reply-To: <1412780013.31093.7.camel@AMDC1943>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:55:41 up 28 days, 23:43, 91 users,  load average: 0.01, 0.04,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 08, 2014 at 04:53:33PM +0200, Krzysztof Kozlowski wrote:
> On =C5=9Bro, 2014-10-08 at 15:47 +0200, Markus Pargmann wrote:
> > This patch sets ena_gpio_initialized for all drivers which set a
> > ena_gpio from parsed DT properties. Drivers using pdata may get zero
> > initialized pdata and therefore copy a 0 into the regulator_config
> > ena_gpio field.
> >=20
> > Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
>=20
> (... rewind to s2m/s5m... I think Mark asked for splitting this per
> driver)

Then I misunderstood Mark, I thought he just meant the fixups at the end
of the last series.

>=20
> > diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
> > index adab82d5279f..49b9e1ddc87e 100644
> > --- a/drivers/regulator/s2mps11.c
> > +++ b/drivers/regulator/s2mps11.c
> > @@ -897,6 +897,7 @@ common_reg:
> >  			config.of_node =3D rdata[i].of_node;
> >  		}
> >  		config.ena_gpio =3D s2mps11->ext_control_gpio[i];
> > +		config.ena_gpio_initialized =3D true;
> > =20
> >  		regulator =3D devm_regulator_register(&pdev->dev,
> >  						&regulators[i], &config);
>=20
> Looks good.
>=20
> > diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
> > index 0ab5cbeeb797..7f176cdb7e37 100644
> > --- a/drivers/regulator/s5m8767.c
> > +++ b/drivers/regulator/s5m8767.c
> > @@ -466,6 +466,7 @@ static void s5m8767_regulator_config_ext_control(st=
ruct s5m8767_info *s5m8767,
> >  	}
> > =20
> >  	config->ena_gpio =3D rdata->ext_control_gpio;
> > +	config->ena_gpio_initialized =3D true;
> >  	config->ena_gpio_flags =3D GPIOF_OUT_INIT_HIGH;
> >  }
>=20
> It will work fine but a little messy. The 'config' is re-used in loop
> for next regulators, so:
> 1. regulator X with GPIO=3D-ENODEV, ena_gpio_initialized=3Dfalse
> 2. regulator X+1 with real GPIO, ena_gpio_initialized=3Dtrue
> 3. regulator X+2 with GPIO=3D-ENODEV, ena_gpio_initialized=3Dtrue
>=20
>=20
> Instead do this in probe around line 950:
>  config.ena_gpio =3D -EINVAL;
>  config.ena_gpio_flags =3D 0;
> +config->ena_gpio_initialized =3D true;
>  if (gpio_is_valid(pdata->regulators[i].ext_control_gpio))
>  	s5m8767_regulator_config_ext_control(s5m8767,
>  			&pdata->regulators[i], &config);

I will fix that.

Thanks,

Markus

--=20
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUN3YLAAoJEEpcgKtcEGQQRvUP/j6YUqw9RH4dCc/Y88YLvo9C
2hPuQ/qKMSj33VCOEnkWMpnqXZvRcHKGrnOO0XEbiTk2f04EzHaf7wZbyIja1bCK
wYY05TNZBp2YsmpLDXeg57uJ5eGNyEkKhFTYitPNFHH1ELf6rRxgspBtkL3lAOBX
z8bp4n2vNLzYIn1GN5G2gqT8Et5HTE8uItFu2c1Epr8+ZJLLO5EzOmsvCjS4Yyda
K+DPz4iIJ5asQ35TLFyJF/CX0CBzzMD4fC4t7HUc6CXwR8OIJOPhNdpw4Q5jsJpO
KXyQ0HAW9dzPtAOofbUeLDsDGs8zAUJGyIKTlFl/b3BCkamBbs9LrN9FlICRqCDh
e4whUQHt12FdYUYSsVLsRlQgklb6J/s4XkfrJBLY2l98M8RafX6IZQgx6LibDUWS
+Hf19TD8jR90NUh1QcpZCqcKwt5sr/r04ikmviqLP0N5Dq9HJSCEH7bErCSzL9v2
gl4XJbOVA0xU7m1Up1Gg5bZJf0otPZogdDlZmiQiG0Sji3rJLy2vHQVR0cWcjqom
ANn9txF8Zs0K0F2PuFv0Nsop6+1XLSQrq3ioFHaKuMVbfLJ83xg+Kkc92axIOHrP
Ov45rXJIkchfVXGNLwYW4xJvprVPz3hAsxbsmQQSmRNu1EJrQbexC3eSZI9OaU6X
8JcEiW1bguX588R953U3
=pBCZ
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
