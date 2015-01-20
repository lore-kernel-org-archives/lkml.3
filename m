Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbbATPqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 10:46:32 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:45255 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926AbbATPqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 10:46:30 -0500
Date: Tue, 20 Jan 2015 09:45:39 -0600
From: Felipe Balbi <balbi@ti.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>,
        Baolu Lu <baolu.lu@linux.intel.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] phy: ulpi: add driver for TI TUSB1210
Message-ID: <20150120154539.GB8988@saruman>
Reply-To: <balbi@ti.com>
References: <1421745502-169447-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1421745502-169447-4-git-send-email-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QKdGvSO+nmPlgiQ/"
Content-Disposition: inline
In-Reply-To: <1421745502-169447-4-git-send-email-heikki.krogerus@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--QKdGvSO+nmPlgiQ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jan 20, 2015 at 11:18:22AM +0200, Heikki Krogerus wrote:
> TUSB1210 ULPI PHY has vendor specific register for eye
> diagram tuning. On some platforms the system firmware has
> set optimized value to it. In order to not loose the
> optimized value, the driver stores it during probe and
> restores it every time the PHY is powered back on.
>=20
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> ---
>  drivers/phy/ulpi/Kconfig    |  11 ++++
>  drivers/phy/ulpi/Makefile   |   2 +
>  drivers/phy/ulpi/tusb1210.c | 131 ++++++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 144 insertions(+)
>  create mode 100644 drivers/phy/ulpi/tusb1210.c
>=20
> diff --git a/drivers/phy/ulpi/Kconfig b/drivers/phy/ulpi/Kconfig
> index 8007df2..7cd6f82 100644
> --- a/drivers/phy/ulpi/Kconfig
> +++ b/drivers/phy/ulpi/Kconfig
> @@ -7,3 +7,14 @@ config ULPI_PHY
>  	  Say yes if you have ULPI PHY attached to your USB controller.
> =20
>  	  If unsure, say N.
> +
> +if ULPI_PHY
> +
> +config ULPI_TUSB1210
> +	tristate "TI TUSB1210 USB PHY module"
> +	depends on POWER_SUPPLY
> +	select USB_PHY
> +	help
> +	  Support for TI TUSB1210 USB ULPI PHY.
> +
> +endif
> diff --git a/drivers/phy/ulpi/Makefile b/drivers/phy/ulpi/Makefile
> index 59e61cb..7ee6679 100644
> --- a/drivers/phy/ulpi/Makefile
> +++ b/drivers/phy/ulpi/Makefile
> @@ -1,2 +1,4 @@
>  ulpiphy-y			:=3D ulpi.o
>  obj-$(CONFIG_ULPI_PHY)		+=3D ulpiphy.o
> +
> +obj-$(CONFIG_ULPI_TUSB1210)	+=3D tusb1210.o
> diff --git a/drivers/phy/ulpi/tusb1210.c b/drivers/phy/ulpi/tusb1210.c
> new file mode 100644
> index 0000000..ac77f98
> --- /dev/null
> +++ b/drivers/phy/ulpi/tusb1210.c

do you really need this extra ulpi directory ?

I wonder if phy-tusb1210.c as a name would be enough.

> @@ -0,0 +1,131 @@
> +/**
> + * tusb1210.c - TUSB1210 USB ULPI PHY driver
> + *
> + * Copyright (C) 2015 Intel Corporation
> + *
> + * Author: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#include <linux/module.h>
> +#include <linux/phy/ulpi/driver.h>
> +#include <linux/phy/ulpi/regs.h>
> +#include <linux/gpio/consumer.h>
> +
> +#include "ulpi_phy.h"
> +
> +struct tusb1210 {
> +	struct ulpi *ulpi;
> +	struct phy *phy;
> +	struct gpio_desc *gpio_reset;
> +	struct gpio_desc *gpio_cs;
> +	u8 ctx[1];
> +};
> +
> +static int tusb1210_power_on(struct phy *phy)
> +{
> +	struct tusb1210 *tusb =3D phy_get_drvdata(phy);
> +
> +	gpiod_set_value_cansleep(tusb->gpio_reset, 1);
> +	gpiod_set_value_cansleep(tusb->gpio_cs, 1);
> +
> +	/* Restore eye optimisation value */
> +	ulpi_write(tusb->ulpi, ULPI_EXT_VENDOR_SPECIFIC, tusb->ctx[0]);
> +
> +	return 0;
> +}
> +
> +static int tusb1210_power_off(struct phy *phy)
> +{
> +	struct tusb1210 *tusb =3D phy_get_drvdata(phy);
> +
> +	gpiod_set_value_cansleep(tusb->gpio_reset, 0);
> +	gpiod_set_value_cansleep(tusb->gpio_cs, 0);
> +
> +	return 0;
> +}
> +
> +static struct phy_ops phy_ops =3D {
> +	.power_on =3D tusb1210_power_on,
> +	.power_off =3D tusb1210_power_off,
> +	.init =3D tusb1210_power_on,
> +	.exit =3D tusb1210_power_off,
> +	.owner =3D THIS_MODULE,
> +};
> +
> +static int tusb1210_probe(struct ulpi *ulpi)
> +{
> +	struct gpio_desc *gpio;
> +	struct tusb1210 *tusb;
> +	int ret;
> +
> +	tusb =3D devm_kzalloc(&ulpi->dev, sizeof(*tusb), GFP_KERNEL);
> +	if (!tusb)
> +		return -ENOMEM;
> +
> +	gpio =3D devm_gpiod_get(&ulpi->dev, "reset");
> +	if (!IS_ERR(gpio)) {
> +		ret =3D gpiod_direction_output(gpio, 0);
> +		if (ret)
> +			return ret;
> +		tusb->gpio_reset =3D gpio;
> +	}
> +
> +	gpio =3D devm_gpiod_get(&ulpi->dev, "cs");
> +	if (!IS_ERR(gpio)) {
> +		ret =3D gpiod_direction_output(gpio, 0);
> +		if (ret)
> +			return ret;
> +		tusb->gpio_cs =3D gpio;
> +	}
> +
> +	/* Store initial eye diagram optimisation value */
> +	ret =3D ulpi_read(ulpi, ULPI_EXT_VENDOR_SPECIFIC);

do they *all* use this register for eye diagram optimization or is this
something that Intel decided to do ?

(sorry, don't know much about tusb1210 other than it sucks like hell :-)

> +	if (ret < 0)
> +		return ret;
> +
> +	tusb->ctx[0] =3D ret;
> +
> +	tusb->phy =3D ulpi_phy_create(ulpi, &phy_ops);
> +	if (IS_ERR(tusb->phy))
> +		return PTR_ERR(tusb->phy);
> +
> +	tusb->ulpi =3D ulpi;
> +
> +	phy_set_drvdata(tusb->phy, tusb);
> +	dev_set_drvdata(&ulpi->dev, tusb);
> +	return 0;
> +}
> +
> +static void tusb1210_remove(struct ulpi *ulpi)
> +{
> +	struct tusb1210 *tusb =3D dev_get_drvdata(&ulpi->dev);

completely unrelated to $subject, but we might want to have a
ulpi_{set,get}_drvdata() at some point.

In fact, we might decide to add an entire ULPI bus, eventually, though
I'm still considering if there's any benefit to that.

> +
> +	ulpi_phy_destroy(ulpi, tusb->phy);
> +}
> +
> +#define TI_VENDOR_ID 0x0451
> +
> +static struct ulpi_device_id tusb1210_ulpi_id[] =3D {
> +	{ TI_VENDOR_ID, 0x1508, },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(ulpi, tusb1210_ulpi_id);
> +
> +static struct ulpi_driver tusb1210_driver =3D {
> +	.id_table =3D tusb1210_ulpi_id,
> +	.probe =3D tusb1210_probe,
> +	.remove =3D tusb1210_remove,
> +	.driver =3D {
> +		.name =3D "tusb1210",
> +		.owner =3D THIS_MODULE,
> +	},
> +};
> +
> +module_ulpi_driver(tusb1210_driver);
> +
> +MODULE_AUTHOR("Intel Corporation");
> +MODULE_LICENSE("GPL");

comment says GPL 2 only, this says GPL 2+

--=20
balbi

--QKdGvSO+nmPlgiQ/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUvngjAAoJEIaOsuA1yqREFOUQAIdvFOh6hQ7Yr6BQywa7czX/
PdmMvyNuDUKQQY8XQR5S0aLomP6rs/U7ubR6iWwiZy23YGTDY33T2MJ1MV36LFgA
JNQGoGfAl2yKlZ8DnKWjgXHW7Wq8hW5t+4f3cbddbJX9jag9GJgQBwuu9NcMeSz+
zCYAvh3qV+3fV6z2oXoEZzJ9o3d3uu/pprcdCXNdr0Tgr4pzRkr5ZcNZBnby313b
SOADI/M2ur+5/piqxTJ2k9CRFSURI1VjmDzdYl6qJC+U6ca6at3c+nGABzzXM+lG
wVqbmvLae4A647AXhGOn4nK6LI3WBiydMskhGP2i8a2o6n8uhwXDi8QP6aISEsfJ
suX+cqmK2HuOn6WvVhK173CUt491rKnfn7ahwpIHRux/6pvVVaMMjsJvudSk7koy
C8WpT2boWfQPcnrGQVb9dUnootSweX6N9xoaKR2elv8/SA8H9601g8tM2QBzODSi
X3LwUF9i80QHvqoC0wJ40y0WNl0+i+lT88LuV0FUxrA+aTSeTc3qdp1B6tmWmj21
q8xkRt6wEDimUlv7jSig2eCl+HV9wFWStgVMsBh8rmHym8fdN9k9RwzIBoSQxmkI
wEQQ0JkOWhw8PBhkQlQ4WZJLTWe6KSRk1lMBw1eVom/wbkIw2ZM0w3zTQukXmUUl
7iScsSoklISRDdm22bAH
=LEEH
-----END PGP SIGNATURE-----

--QKdGvSO+nmPlgiQ/--
