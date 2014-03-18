Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbaCRPzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 11:55:54 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47626 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755647AbaCRPzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 11:55:52 -0400
Date: Tue, 18 Mar 2014 10:54:02 -0500
From: Felipe Balbi <balbi@ti.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: <gregkh@linuxfoundation.org>, <balbi@ti.com>, <myungjoo.ham@samsung.com>,
        <kishon@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 2/2] extcon: Move OF helper function to extcon core and
 change function name
Message-ID: <20140318155402.GD14373@saruman.home>
Reply-To: <balbi@ti.com>
References: <1395144280-23240-1-git-send-email-cw00.choi@samsung.com>
 <1395144280-23240-3-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="llIrKcgUOe3dCx0c"
Content-Disposition: inline
In-Reply-To: <1395144280-23240-3-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--llIrKcgUOe3dCx0c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Mar 18, 2014 at 09:04:40PM +0900, Chanwoo Choi wrote:
> This patch move simply OF helper function to extcon core and change funct=
ion
> name as following:
> - of_extcon_get_extcon_dev() -> extcon_get_edev_by_phandle()
>=20
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  drivers/extcon/Kconfig           |  4 ---
>  drivers/extcon/Makefile          |  2 --
>  drivers/extcon/extcon-class.c    | 43 ++++++++++++++++++++++++++++++
>  drivers/extcon/of_extcon.c       | 56 ----------------------------------=
------
>  drivers/usb/dwc3/dwc3-omap.c     |  3 +--

for dwc3:

Acked-by: Felipe Balbi <balbi@ti.com>

>  include/linux/extcon.h           | 12 +++++++++
>  include/linux/extcon/of_extcon.h | 31 ----------------------
>  7 files changed, 56 insertions(+), 95 deletions(-)
>  delete mode 100644 drivers/extcon/of_extcon.c
>  delete mode 100644 include/linux/extcon/of_extcon.h
>=20
> diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
> index bdb5a00..be56e8a 100644
> --- a/drivers/extcon/Kconfig
> +++ b/drivers/extcon/Kconfig
> @@ -14,10 +14,6 @@ if EXTCON
> =20
>  comment "Extcon Device Drivers"
> =20
> -config OF_EXTCON
> -	def_tristate y
> -	depends on OF
> -
>  config EXTCON_GPIO
>  	tristate "GPIO extcon support"
>  	depends on GPIOLIB
> diff --git a/drivers/extcon/Makefile b/drivers/extcon/Makefile
> index 43eccc0..bf7861e 100644
> --- a/drivers/extcon/Makefile
> +++ b/drivers/extcon/Makefile
> @@ -2,8 +2,6 @@
>  # Makefile for external connector class (extcon) devices
>  #
> =20
> -obj-$(CONFIG_OF_EXTCON)		+=3D of_extcon.o
> -
>  obj-$(CONFIG_EXTCON)		+=3D extcon-class.o
>  obj-$(CONFIG_EXTCON_GPIO)	+=3D extcon-gpio.o
>  obj-$(CONFIG_EXTCON_ADC_JACK)	+=3D extcon-adc-jack.o
> diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
> index 7632233..bc4c789 100644
> --- a/drivers/extcon/extcon-class.c
> +++ b/drivers/extcon/extcon-class.c
> @@ -31,6 +31,7 @@
>  #include <linux/extcon.h>
>  #include <linux/slab.h>
>  #include <linux/sysfs.h>
> +#include <linux/of.h>
> =20
>  /*
>   * extcon_cable_name suggests the standard cable names for commonly used
> @@ -818,6 +819,48 @@ void extcon_dev_unregister(struct extcon_dev *edev)
>  }
>  EXPORT_SYMBOL_GPL(extcon_dev_unregister);
> =20
> +#ifdef CONFIG_OF
> +/*
> + * extcon_get_edev_by_phandle - Get the extcon device from devicetree
> + * @dev - instance to the given device
> + * @index - index into list of extcon_dev
> + *
> + * return the instance of extcon device
> + */
> +struct extcon_dev *extcon_get_edev_by_phandle(struct device *dev, int in=
dex)
> +{
> +	struct device_node *node;
> +	struct extcon_dev *edev;
> +
> +	if (!dev->of_node) {
> +		dev_err(dev, "device does not have a device node entry\n");
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	node =3D of_parse_phandle(dev->of_node, "extcon", index);
> +	if (!node) {
> +		dev_err(dev, "failed to get phandle in %s node\n",
> +			dev->of_node->full_name);
> +		return ERR_PTR(-ENODEV);
> +	}
> +
> +	edev =3D extcon_get_extcon_dev(node->name);
> +	if (!edev) {
> +		dev_err(dev, "unable to get extcon device : %s\n", node->name);
> +		return ERR_PTR(-ENODEV);
> +	}
> +
> +	return edev;
> +}
> +#else
> +static inline struct extcon_dev *extcon_get_edev_by_phandle(struct devic=
e *dev,
> +							    int index)
> +{
> +	return ERR_PTR(-ENOSYS);
> +}
> +#endif /* CONFIG_OF */
> +EXPORT_SYMBOL_GPL(extcon_get_edev_by_phandle);
> +
>  static int __init extcon_class_init(void)
>  {
>  	return create_extcon_class();
> diff --git a/drivers/extcon/of_extcon.c b/drivers/extcon/of_extcon.c
> deleted file mode 100644
> index 0a29f82..0000000
> --- a/drivers/extcon/of_extcon.c
> +++ /dev/null
> @@ -1,56 +0,0 @@
> -/*
> - * OF helpers for External connector (extcon) framework
> - *
> - * Copyright (C) 2013 Texas Instruments, Inc.
> - * Kishon Vijay Abraham I <kishon@ti.com>
> - *
> - * Copyright (C) 2013 Samsung Electronics
> - * Chanwoo Choi <cw00.choi@samsung.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - */
> -
> -#include <linux/module.h>
> -#include <linux/slab.h>
> -#include <linux/err.h>
> -#include <linux/extcon.h>
> -#include <linux/of.h>
> -#include <linux/of_platform.h>
> -#include <linux/extcon/of_extcon.h>
> -
> -/*
> - * of_extcon_get_extcon_dev - Get the name of extcon device from devicet=
ree
> - * @dev - instance to the given device
> - * @index - index into list of extcon_dev
> - *
> - * return the instance of extcon device
> - */
> -struct extcon_dev *of_extcon_get_extcon_dev(struct device *dev, int inde=
x)
> -{
> -	struct device_node *node;
> -	struct extcon_dev *edev;
> -
> -	if (!dev->of_node) {
> -		dev_dbg(dev, "device does not have a device node entry\n");
> -		return ERR_PTR(-EINVAL);
> -	}
> -
> -	node =3D of_parse_phandle(dev->of_node, "extcon", index);
> -	if (!node) {
> -		dev_dbg(dev, "failed to get phandle in %s node\n",
> -			dev->of_node->full_name);
> -		return ERR_PTR(-ENODEV);
> -	}
> -
> -	edev =3D extcon_get_extcon_dev(node->name);
> -	if (!edev) {
> -		dev_dbg(dev, "unable to get extcon device : %s\n", node->name);
> -		return ERR_PTR(-ENODEV);
> -	}
> -
> -	return edev;
> -}
> -EXPORT_SYMBOL_GPL(of_extcon_get_extcon_dev);
> diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
> index b269dbd..b1d7ee6 100644
> --- a/drivers/usb/dwc3/dwc3-omap.c
> +++ b/drivers/usb/dwc3/dwc3-omap.c
> @@ -29,7 +29,6 @@
>  #include <linux/of.h>
>  #include <linux/of_platform.h>
>  #include <linux/extcon.h>
> -#include <linux/extcon/of_extcon.h>
>  #include <linux/regulator/consumer.h>
> =20
>  #include <linux/usb/otg.h>
> @@ -522,7 +521,7 @@ static int dwc3_omap_probe(struct platform_device *pd=
ev)
>  	dwc3_omap_enable_irqs(omap);
> =20
>  	if (of_property_read_bool(node, "extcon")) {
> -		edev =3D of_extcon_get_extcon_dev(dev, 0);
> +		edev =3D extcon_get_edev_by_phandle(dev, 0);
>  		if (IS_ERR(edev)) {
>  			dev_vdbg(dev, "couldn't get extcon device\n");
>  			ret =3D -EPROBE_DEFER;
> diff --git a/include/linux/extcon.h b/include/linux/extcon.h
> index 21c59af..f488145 100644
> --- a/include/linux/extcon.h
> +++ b/include/linux/extcon.h
> @@ -240,6 +240,12 @@ extern int extcon_register_notifier(struct extcon_de=
v *edev,
>  				    struct notifier_block *nb);
>  extern int extcon_unregister_notifier(struct extcon_dev *edev,
>  				      struct notifier_block *nb);
> +
> +/*
> + * Following API get the extcon device from devicetree.
> + * This function use phandle of devicetree to get extcon device directly.
> + */
> +extern struct extcon_dev *extcon_get_edev_by_phandle(struct device *dev,=
 int index);
>  #else /* CONFIG_EXTCON */
>  static inline int extcon_dev_register(struct extcon_dev *edev)
>  {
> @@ -324,5 +330,11 @@ static inline int extcon_unregister_interest(struct =
extcon_specific_cable_nb
>  {
>  	return 0;
>  }
> +
> +static inline struct extcon_dev *extcon_get_edev_by_phandle(struct devic=
e *dev,
> +							    int index)
> +{
> +	return ERR_PTR(-ENODEV);
> +}
>  #endif /* CONFIG_EXTCON */
>  #endif /* __LINUX_EXTCON_H__ */
> diff --git a/include/linux/extcon/of_extcon.h b/include/linux/extcon/of_e=
xtcon.h
> deleted file mode 100644
> index 0ebfeff..0000000
> --- a/include/linux/extcon/of_extcon.h
> +++ /dev/null
> @@ -1,31 +0,0 @@
> -/*
> - * OF helpers for External connector (extcon) framework
> - *
> - * Copyright (C) 2013 Texas Instruments, Inc.
> - * Kishon Vijay Abraham I <kishon@ti.com>
> - *
> - * Copyright (C) 2013 Samsung Electronics
> - * Chanwoo Choi <cw00.choi@samsung.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - */
> -
> -#ifndef __LINUX_OF_EXTCON_H
> -#define __LINUX_OF_EXTCON_H
> -
> -#include <linux/err.h>
> -
> -#if IS_ENABLED(CONFIG_OF_EXTCON)
> -extern struct extcon_dev
> -	*of_extcon_get_extcon_dev(struct device *dev, int index);
> -#else
> -static inline struct extcon_dev
> -	*of_extcon_get_extcon_dev(struct device *dev, int index)
> -{
> -	return ERR_PTR(-ENOSYS);
> -}
> -#endif /* CONFIG_OF_EXTCON */
> -#endif /* __LINUX_OF_EXTCON_H */
> --=20
> 1.8.0
>=20

--=20
balbi

--llIrKcgUOe3dCx0c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTKGwaAAoJEIaOsuA1yqREWYYP/jG+Jf4Bh0LsCJ3MLmd0P3Hi
mKfd10QL7yVPhMmZfwiCY5zOcm5RceUxGqCuSFOzp3dAqEeGvxR/n/sVpLxSZGRR
5Q+orjg0AWG1iOnHnnUySUVj/UQ5iABSDI1IupqyVCj2UziTZNI65gfNiBiLUeXD
3+RUQRGg76ZiFeP5uR263Dw2cM6Sxy+LR85jK/rcohdIKbwxPlzS4jza6MRXzQpi
EwVTctZP6lcqv9lj6IYoC0l/JxrWdSBAOMmYXqU5wQPG2QxZVgzl4DzWEG2ivtTN
QUarySNkDTwvSbJIKRXiNp4FDAJwi3LgJj5bwdtfpbblAyequfPe548hidEcWDwR
72xH/ik9jz1vBu2mFyTjCgydDi6NSnP8CQLqO5okCdr7cPSWK7jANvShEkqd6nkY
PNBB1CxSyc7+6RUiIWtfBS1eaa+F2cRhGccRbadspaUy8hYgI9uVFp/ZROA/SPI1
XJ976cw9uA8Y91gpasMbulBD3dJVYpFN3TiNlr6IcS57+R6VlNCjt6HOUuds1/IE
h+QzDx/gX1B3bta+b7ngnCiOMMMG/zq94/Kmx7y8NNf7ZcLYfnx1KibafxhXSy6A
60PodG34bqXUSLION3FGnzTkaDDoYXX+JwgzawUFfesVEeX7drcJkz7kmqCSnOeh
8fF0zq5KH3KaUPoLQlfP
=CjlZ
-----END PGP SIGNATURE-----

--llIrKcgUOe3dCx0c--
