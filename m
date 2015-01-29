Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbbA2FKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 00:10:04 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:52024 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696AbbA2FKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 00:10:02 -0500
Date: Wed, 28 Jan 2015 23:09:51 -0600
From: Felipe Balbi <balbi@ti.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Baolu Lu <baolu.lu@linux.intel.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH 8/8] phy: add driver for TI TUSB1210 ULPI PHY
Message-ID: <20150129050951.GC9098@saruman.tx.rr.com>
Reply-To: <balbi@ti.com>
References: <1422025978-178336-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1422025978-178336-9-git-send-email-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ncSAzJYg3Aa9+CRW"
Content-Disposition: inline
In-Reply-To: <1422025978-178336-9-git-send-email-heikki.krogerus@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ncSAzJYg3Aa9+CRW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 23, 2015 at 05:12:58PM +0200, Heikki Krogerus wrote:
> TUSB1210 ULPI PHY has vendor specific register for eye
> diagram tuning. On some platforms the system firmware has
> set optimized value to it. In order to not loose the
> optimized value, the driver stores it during probe and
> restores it every time the PHY is powered back on.
>=20
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Cc: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  drivers/phy/Kconfig        |   6 ++
>  drivers/phy/Makefile       |   1 +
>  drivers/phy/phy-tusb1210.c | 133 +++++++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 140 insertions(+)
>  create mode 100644 drivers/phy/phy-tusb1210.c
>=20
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index 26a7623..52ee720 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -284,4 +284,10 @@ config PHY_QCOM_UFS
>  	help
>  	  Support for UFS PHY on QCOM chipsets.
> =20
> +config PHY_TUSB1210
> +	tristate "TI TUSB1210 ULPI PHY module"
> +	depends on USB_ULPI_BUS
> +	help
> +	  Support for TI TUSB1210 USB ULPI PHY.
> +
>  endmenu
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index cfbb720..03f3d85 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -37,3 +37,4 @@ obj-$(CONFIG_PHY_STIH41X_USB)		+=3D phy-stih41x-usb.o
>  obj-$(CONFIG_PHY_QCOM_UFS) 	+=3D phy-qcom-ufs.o
>  obj-$(CONFIG_PHY_QCOM_UFS) 	+=3D phy-qcom-ufs-qmp-20nm.o
>  obj-$(CONFIG_PHY_QCOM_UFS) 	+=3D phy-qcom-ufs-qmp-14nm.o
> +obj-$(CONFIG_PHY_TUSB1210)		+=3D phy-tusb1210.o
> diff --git a/drivers/phy/phy-tusb1210.c b/drivers/phy/phy-tusb1210.c
> new file mode 100644
> index 0000000..1551ae8
> --- /dev/null
> +++ b/drivers/phy/phy-tusb1210.c
> @@ -0,0 +1,133 @@
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
> +#include <linux/ulpi/driver.h>
> +#include <linux/gpio/consumer.h>
> +
> +#include "ulpi_phy.h"
> +
> +#define TUSB1210_VENDOR_SPECIFIC2 0x80
> +
> +struct tusb1210 {
> +	struct ulpi *ulpi;
> +	struct phy *phy;
> +	struct gpio_desc *gpio_reset;
> +	struct gpio_desc *gpio_cs;
> +	u8 eye_diagram_tuning;
> +};
> +
> +static int tusb1210_power_on(struct phy *phy)
> +{
> +	struct tusb1210 *tusb =3D phy_get_drvdata(phy);
> +
> +	gpiod_set_value_cansleep(tusb->gpio_reset, 1);
> +	gpiod_set_value_cansleep(tusb->gpio_cs, 1);
> +
> +	/* Restore eye diagram optimisation value */
> +	ulpi_write(tusb->ulpi, TUSB1210_VENDOR_SPECIFIC2,
> +		   tusb->eye_diagram_tuning);
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

these should not be the same. It looks like what you want is for reset
and cs gpios to be handle on init/exit and ulpi_write() from power_on().

Also, I was chatting in private with David and, apparently, there's a
way to request for eye diagram data from BIOS straight. That's more
in-line with what we would do for DT-based boots, passing that
eye-diagram data as a DT attribute.

Care to comment ? If that's the case, I'd rather use that BIOS hook and
remove ulpi_read() from probe().

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

right before this call, you really don't know the state of either CS nor
RESET gpios, so it could very well be that firmware left it disabled.

There are cases where that extra uW of runtime power consumption
matters, you probably still remember the weeks we spent optimizing
regulator usage on both twl4030-usb and isp17xx (whatever that was) on
N900.

Either wrap this call with proper gpio handling (if there's really no
other way to get the eye diagram data), or remove it from here
completely and use the BIOS hook which, apparently, exists.

Wrapping it with GPIOs has the added benefit of making sure the PHY is
powered down after probe in case firmware left it running. We really
can't make assumptions as to when the PHY will be needed.

--=20
balbi

--ncSAzJYg3Aa9+CRW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUycCfAAoJEIaOsuA1yqREwy8P/3/4MCowwLjJk72qls4NWK7u
nvjsmsi+h+FhZsS6zKy9L/aEnnxO7BM/1nKpC2g7DKnQ7LU44RfARBC37uVrb4VW
NGSfS/HfssoZEieRz3GhOUPAQkWFkgKRLBStuMBBwJAUpT/HkJbOhhBk3NbcBBzQ
qVVa0DHPwZT3dxKO2xrxBzpRk6/wmWWohkc2aPzYrBhyc/I35Fho46sHcJg3MVBV
oI16tDcu68Wygu0TfpfUYYRI019Q4i/NuBaIDQ+3W2uRVyb7iXDURLEgvzbSAS4I
3XDK+ZNQmovZY2QBJsDIqSPTA20+HJ1FSMPKwg6AOaHOwu777IYezEwqftSLlTEG
wk09QHQVX5yB2lHGBa8+dYNU7Q6hdCN1XKvNSoAV9O4c3MFSIIo8aH75X0eLYQql
diQniEZum0E9RAf0AmdO8jd/yjh3xRUsApy8LKFm34BRFPvC01SsnWWmlZvt6k1M
Iql7PnKQhH7ZRu9Q8+waawDTeKJ/Ouq9gK4jrtnsU0bQ8iK6aLaSTR9aeiwJG836
euY2ZDn6+jc/gzbiXVM1xNd8R68qh8qiOt0pdwGWu0IvdAflA1ppw2qbTh71C4fv
EteiHEcgSfFhtS+w8FmruTneIzSsR1hg1ELFZPWAF3h5X9BFp9fk94nMZgBFdbE1
YnxefDA5+y8jMUoKGcLX
=p+e7
-----END PGP SIGNATURE-----

--ncSAzJYg3Aa9+CRW--
