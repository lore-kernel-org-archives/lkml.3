Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbbAVUta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 15:49:30 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:45517 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442AbbAVUt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 15:49:28 -0500
Date: Thu, 22 Jan 2015 14:49:25 -0600
From: Felipe Balbi <balbi@ti.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: Felipe Balbi <balbi@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Baolu Lu <baolu.lu@linux.intel.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] phy: ulpi: add driver for TI TUSB1210
Message-ID: <20150122204925.GF22288@saruman.tx.rr.com>
Reply-To: <balbi@ti.com>
References: <1421745502-169447-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1421745502-169447-4-git-send-email-heikki.krogerus@linux.intel.com>
 <20150120154539.GB8988@saruman>
 <20150121091749.GB22716@kuha.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yZnyZsPjQYjG7xG7"
Content-Disposition: inline
In-Reply-To: <20150121091749.GB22716@kuha.fi.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--yZnyZsPjQYjG7xG7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jan 21, 2015 at 11:17:49AM +0200, Heikki Krogerus wrote:
> > > TUSB1210 ULPI PHY has vendor specific register for eye
> > > diagram tuning. On some platforms the system firmware has
> > > set optimized value to it. In order to not loose the
> > > optimized value, the driver stores it during probe and
> > > restores it every time the PHY is powered back on.
> > >=20
> > > Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > > ---
> > >  drivers/phy/ulpi/Kconfig    |  11 ++++
> > >  drivers/phy/ulpi/Makefile   |   2 +
> > >  drivers/phy/ulpi/tusb1210.c | 131 ++++++++++++++++++++++++++++++++++=
++++++++++
> > >  3 files changed, 144 insertions(+)
> > >  create mode 100644 drivers/phy/ulpi/tusb1210.c
> > >=20
> > > diff --git a/drivers/phy/ulpi/Kconfig b/drivers/phy/ulpi/Kconfig
> > > index 8007df2..7cd6f82 100644
> > > --- a/drivers/phy/ulpi/Kconfig
> > > +++ b/drivers/phy/ulpi/Kconfig
> > > @@ -7,3 +7,14 @@ config ULPI_PHY
> > >  	  Say yes if you have ULPI PHY attached to your USB controller.
> > > =20
> > >  	  If unsure, say N.
> > > +
> > > +if ULPI_PHY
> > > +
> > > +config ULPI_TUSB1210
> > > +	tristate "TI TUSB1210 USB PHY module"
> > > +	depends on POWER_SUPPLY
> > > +	select USB_PHY
> > > +	help
> > > +	  Support for TI TUSB1210 USB ULPI PHY.
> > > +
> > > +endif
> > > diff --git a/drivers/phy/ulpi/Makefile b/drivers/phy/ulpi/Makefile
> > > index 59e61cb..7ee6679 100644
> > > --- a/drivers/phy/ulpi/Makefile
> > > +++ b/drivers/phy/ulpi/Makefile
> > > @@ -1,2 +1,4 @@
> > >  ulpiphy-y			:=3D ulpi.o
> > >  obj-$(CONFIG_ULPI_PHY)		+=3D ulpiphy.o
> > > +
> > > +obj-$(CONFIG_ULPI_TUSB1210)	+=3D tusb1210.o
> > > diff --git a/drivers/phy/ulpi/tusb1210.c b/drivers/phy/ulpi/tusb1210.c
> > > new file mode 100644
> > > index 0000000..ac77f98
> > > --- /dev/null
> > > +++ b/drivers/phy/ulpi/tusb1210.c
> >=20
> > do you really need this extra ulpi directory ?
> >=20
> > I wonder if phy-tusb1210.c as a name would be enough.
>=20
> IMO grouping the ULPI PHY drivers and other ULPI bus code into
> separate folder from the start is the right thing to do.

because... :-)

> > > @@ -0,0 +1,131 @@
> > > +/**
> > > + * tusb1210.c - TUSB1210 USB ULPI PHY driver
> > > + *
> > > + * Copyright (C) 2015 Intel Corporation
> > > + *
> > > + * Author: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > > + *
> > > + * This program is free software; you can redistribute it and/or mod=
ify
> > > + * it under the terms of the GNU General Public License version 2 as
> > > + * published by the Free Software Foundation.
> > > + */
> > > +#include <linux/module.h>
> > > +#include <linux/phy/ulpi/driver.h>
> > > +#include <linux/phy/ulpi/regs.h>
> > > +#include <linux/gpio/consumer.h>
> > > +
> > > +#include "ulpi_phy.h"
> > > +
> > > +struct tusb1210 {
> > > +	struct ulpi *ulpi;
> > > +	struct phy *phy;
> > > +	struct gpio_desc *gpio_reset;
> > > +	struct gpio_desc *gpio_cs;
> > > +	u8 ctx[1];
> > > +};
> > > +
> > > +static int tusb1210_power_on(struct phy *phy)
> > > +{
> > > +	struct tusb1210 *tusb =3D phy_get_drvdata(phy);
> > > +
> > > +	gpiod_set_value_cansleep(tusb->gpio_reset, 1);
> > > +	gpiod_set_value_cansleep(tusb->gpio_cs, 1);
> > > +
> > > +	/* Restore eye optimisation value */
> > > +	ulpi_write(tusb->ulpi, ULPI_EXT_VENDOR_SPECIFIC, tusb->ctx[0]);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static int tusb1210_power_off(struct phy *phy)
> > > +{
> > > +	struct tusb1210 *tusb =3D phy_get_drvdata(phy);
> > > +
> > > +	gpiod_set_value_cansleep(tusb->gpio_reset, 0);
> > > +	gpiod_set_value_cansleep(tusb->gpio_cs, 0);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static struct phy_ops phy_ops =3D {
> > > +	.power_on =3D tusb1210_power_on,
> > > +	.power_off =3D tusb1210_power_off,
> > > +	.init =3D tusb1210_power_on,
> > > +	.exit =3D tusb1210_power_off,
> > > +	.owner =3D THIS_MODULE,
> > > +};
> > > +
> > > +static int tusb1210_probe(struct ulpi *ulpi)
> > > +{
> > > +	struct gpio_desc *gpio;
> > > +	struct tusb1210 *tusb;
> > > +	int ret;
> > > +
> > > +	tusb =3D devm_kzalloc(&ulpi->dev, sizeof(*tusb), GFP_KERNEL);
> > > +	if (!tusb)
> > > +		return -ENOMEM;
> > > +
> > > +	gpio =3D devm_gpiod_get(&ulpi->dev, "reset");
> > > +	if (!IS_ERR(gpio)) {
> > > +		ret =3D gpiod_direction_output(gpio, 0);
> > > +		if (ret)
> > > +			return ret;
> > > +		tusb->gpio_reset =3D gpio;
> > > +	}
> > > +
> > > +	gpio =3D devm_gpiod_get(&ulpi->dev, "cs");
> > > +	if (!IS_ERR(gpio)) {
> > > +		ret =3D gpiod_direction_output(gpio, 0);
> > > +		if (ret)
> > > +			return ret;
> > > +		tusb->gpio_cs =3D gpio;
> > > +	}
> > > +
> > > +	/* Store initial eye diagram optimisation value */
> > > +	ret =3D ulpi_read(ulpi, ULPI_EXT_VENDOR_SPECIFIC);
> >=20
> > do they *all* use this register for eye diagram optimization or is this
> > something that Intel decided to do ?
> >=20
> > (sorry, don't know much about tusb1210 other than it sucks like hell :-)
>=20
> All I know that somebody needs to save the value. The ones using this
> PHY who don't need to save it can most likely live without the driver.

right, but what I mean is: is it mandatory that Eye diagram
configuration be stored in *this* register? Or is it more like a scratch
register which Intel just happens to be using for Eye diagram data ?

> > > +	if (ret < 0)
> > > +		return ret;
> > > +
> > > +	tusb->ctx[0] =3D ret;
> > > +
> > > +	tusb->phy =3D ulpi_phy_create(ulpi, &phy_ops);
> > > +	if (IS_ERR(tusb->phy))
> > > +		return PTR_ERR(tusb->phy);
> > > +
> > > +	tusb->ulpi =3D ulpi;
> > > +
> > > +	phy_set_drvdata(tusb->phy, tusb);
> > > +	dev_set_drvdata(&ulpi->dev, tusb);
> > > +	return 0;
> > > +}
> > > +
> > > +static void tusb1210_remove(struct ulpi *ulpi)
> > > +{
> > > +	struct tusb1210 *tusb =3D dev_get_drvdata(&ulpi->dev);
> >=20
> > completely unrelated to $subject, but we might want to have a
> > ulpi_{set,get}_drvdata() at some point.
>=20
> Makes sense.
>=20
> > In fact, we might decide to add an entire ULPI bus, eventually, though
> > I'm still considering if there's any benefit to that.
>=20
> I don't think I understand this comment? ULPI bus is what I'm
> introducing in this set (the first patch in it)?

I mean introducing a real struct bus ulpi_bus_type :-) With match,
probe, remove, etc.

--=20
balbi

--yZnyZsPjQYjG7xG7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUwWJVAAoJEIaOsuA1yqREPk4P/j01i5C7E/X/zdftbbdC9LnW
n5CekTRdTh6uOjfVdHVHdxALyvLqC/OG+Z8uEiWwPpA0I5DJ6oaCAsyM6gLIoAJN
svl5+bqU07QHYTvtKBprL3z+HheBa4v5YDnC0lUDb/n0e2HtNaDemVks6ccFUJml
SMV6qNvS3Ug5X80z9ei15lYhUMgYVg3QH3UPQ/xR+JXPCjeySA8QHNEiHEnFILnd
07kcmsAYqPeqHdFo6VXXGpV6bCl+W++oI+qcHwgz/oqATX4XHJNfDHNN5D4HnsTk
TP5vgU42J6TnnL30vxFOj9IGdGU1RHaCTLIFlvPbHP7PVaLFymyhUEXWXo+/g74J
pclzEsNHy6KRSCtDxqvuQN+YGLhyetnW+tgrnATALKoAiQV/Xv9OjNJEzslJJsIM
8IpbR4c07NpUm2SnH2jTASJDkjUWwAaXZbjwXJ+ASTdhUq0isYoanI/27vCIYLD9
R7ZT5cOHP/heqkQXMtPyyWQngGs5HCRlUEvTxEr+Rlz7IlxKiYpkMhntJht/Xy0v
MTtDK00y+KPi9umr4RMvtJoDtWlIn4Q8N4uG7lggZCiHNgUmouTREiJmHe55GOvM
SVyeXJ/YY18IPo8jBn1T8DlLzX29uWQgLfRDbKCMyRbiVk/SvaYEUYD9+KptWDWb
b19oFSj+2r2qkmqarAAB
=7ldj
-----END PGP SIGNATURE-----

--yZnyZsPjQYjG7xG7--
