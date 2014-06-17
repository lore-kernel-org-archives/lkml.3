Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933750AbaFQUNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 16:13:54 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58315 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932927AbaFQUNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 16:13:53 -0400
Date: Tue, 17 Jun 2014 22:13:47 +0200
From: Markus Pargmann <mpa@pengutronix.de>
To: David Rientjes <rientjes@google.com>
Cc: Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] regmap: Add Kconfig option for debugfs register writes
Message-ID: <20140617201347.GA32450@pengutronix.de>
References: <1403033795-9122-1-git-send-email-mpa@pengutronix.de>
 <alpine.DEB.2.02.1406171254540.18156@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1406171254540.18156@chino.kir.corp.google.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 22:01:20 up 55 days, 13:32, 59 users,  load average: 0.29, 0.12,
 0.07
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jun 17, 2014 at 12:56:54PM -0700, David Rientjes wrote:
> On Tue, 17 Jun 2014, Markus Pargmann wrote:
>=20
> > To enable writing of registers through the regmap debugfs interface, it
> > was necessary to alter the regmap-debugfs.c source code. This is not
> > really practical.
> >=20
> > As this is a powerful tool for debugging, this patch creates an expert
> > kconfig option for this function. This makes it easier to enable
> > register writing in the kernel.
> >=20
> > This patch also fixes the file mode when the regmap debugfs write code =
is
> > compiled.
> >=20
>=20
> Forcing users to enable CONFIG_EXPERT for this doesn't seem appropriate,=
=20
> it enables things by default and has really become a separate config of=
=20
> its own.  You might want to consider removing this dependency unless you=
=20
> have a strong reason for keeping it.

I only created the dependency on CONFIG_EXPERT to make it clear that
this option is only for people who know what they are doing. I can
remove that dependency if that is OK for everyone?

Thanks,

Markus

>=20
> > Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
> > Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
> > ---
> >  drivers/base/regmap/Kconfig          | 14 ++++++++++++++
> >  drivers/base/regmap/regmap-debugfs.c | 16 ++++++++++------
> >  2 files changed, 24 insertions(+), 6 deletions(-)
> >=20
> > diff --git a/drivers/base/regmap/Kconfig b/drivers/base/regmap/Kconfig
> > index 4251570610c9..ce86600dbe75 100644
> > --- a/drivers/base/regmap/Kconfig
> > +++ b/drivers/base/regmap/Kconfig
> > @@ -23,3 +23,17 @@ config REGMAP_MMIO
> > =20
> >  config REGMAP_IRQ
> >  	bool
> > +
> > +config REGMAP_ALLOW_WRITE_DEBUGFS
> > +	default n
> > +	depends on DEBUG_FS
> > +	depends on EXPERT
> > +	depends on REGMAP
> > +	bool "Regmap, allow direct register writes through debugfs"
> > +	help
> > +	  This option enables regmap debugfs write support. If this is enable=
d,
> > +	  you can directly write registers using the registers file in the
> > +	  regmap debugfs.
> > +
> > +	  This is potentially dangerous. Do not enable this option unless you
> > +	  know what you are doing.
> > diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap=
/regmap-debugfs.c
> > index 45d812c0ea77..12906f2bdf00 100644
> > --- a/drivers/base/regmap/regmap-debugfs.c
> > +++ b/drivers/base/regmap/regmap-debugfs.c
> > @@ -261,13 +261,10 @@ static ssize_t regmap_map_read_file(struct file *=
file, char __user *user_buf,
> >  				   count, ppos);
> >  }
> > =20
> > -#undef REGMAP_ALLOW_WRITE_DEBUGFS
> > -#ifdef REGMAP_ALLOW_WRITE_DEBUGFS
> > +#if IS_ENABLED(CONFIG_REGMAP_ALLOW_WRITE_DEBUGFS)
> >  /*
> >   * This can be dangerous especially when we have clients such as
> > - * PMICs, therefore don't provide any real compile time configuration =
option
> > - * for this feature, people who want to use this will need to modify
> > - * the source code directly.
> > + * PMICs, therefore this function can only be selected in expert kconf=
ig mode.
> >   */
> >  static ssize_t regmap_map_write_file(struct file *file,
> >  				     const char __user *user_buf,
> > @@ -512,7 +509,14 @@ void regmap_debugfs_init(struct regmap *map, const=
 char *name)
> >  			    map, &regmap_reg_ranges_fops);
> > =20
> >  	if (map->max_register || regmap_readable(map, 0)) {
> > -		debugfs_create_file("registers", 0400, map->debugfs,
> > +		unsigned int registers_mode;
> > +
> > +		if (IS_ENABLED(CONFIG_REGMAP_ALLOW_WRITE_DEBUGFS))
> > +			registers_mode =3D 0600;
> > +		else
> > +			registers_mode =3D 0400;
> > +
> > +		debugfs_create_file("registers", registers_mode, map->debugfs,
> >  				    map, &regmap_map_fops);
> >  		debugfs_create_file("access", 0400, map->debugfs,
> >  				    map, &regmap_access_fops);
>=20

--=20
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJToKF7AAoJEEpcgKtcEGQQQcIP/j2gUZZK3yfxlopmgPb2vlKp
m383z3m8RAUkJDSnuHlz/GuD7+J9QNRRTX1PMyz4JQgDrPLQ3KbAuEMgtTQYDF1h
qsbwD+SEuexSt28x3IUJYkOVprAprBHVAf6HdmzPrEhaPDQiQ9x2y9Y+0aBm8n7Z
+LkaqxmSrK+KTNbUTnYDlT3F/f4GGF05+tmQpIzRsRSzrfh18FNdp0BThB5v+m5F
nV28V3sgtkLojAXHz8UtlfzeupS2bU5+aclGx+BEnJHuNa9h4etsMVyUOCB5xz9Q
zG3Fe7lvpobhnriJQUgULHG3I4DZf4StBtvs4rbKJgpgv0cwRgKhqQxdXp9uPkxl
/1CHQUu720BZzf+RpVK+JfvlfA6acHNk3BnwZkcLIDKXwEHNv8xExFVGziaIfMbm
c4+NuWywYTfJRfN3ivxgyVhwX4hGjQDpogRrLDvofFSPdIPNJ8gVmZ6CRjd0sh8R
DGUwW3o0ceZoJ07qNpoURNM9gLDiOa5P/TJJbVCFx/mVT2/eqn91hDk3Gyj+lC4Z
n71883pd+28s0UgFXnTpJAbCxu/5/2Z0zPuGwPZiuZYbcxDUq/MAhL+/KeK4JSx+
HugH6+PW3CU/PZ02GLIG7fzOdNxcaop9E9NnT/QxrJsUib0bUN5bRzQUumNCnLgX
/Emx6DywGD6XJ4DEXH9B
=5Myu
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
