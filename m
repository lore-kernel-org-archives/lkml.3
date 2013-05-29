Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965737Ab3E2L2K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 07:28:10 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:38771 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965472Ab3E2L2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 07:28:08 -0400
Message-ID: <51A5E644.1040901@monstr.eu>
Date: Wed, 29 May 2013 13:28:04 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Michal Simek <michal.simek@xilinx.com>
CC: linux-kernel@vger.kernel.org, "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH 2/2] uio: Add two platform uio drivers to one
References: <086bdaf83fe546bd3c7fe163e565a0887770770f.1369317710.git.michal.simek@xilinx.com> <71c482e15ee32fa304db73b984f6d5a63441cd92.1369317710.git.michal.simek@xilinx.com>
In-Reply-To: <71c482e15ee32fa304db73b984f6d5a63441cd92.1369317710.git.michal.simek@xilinx.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2VDWDNSSMUUKNSLEAHUGF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2VDWDNSSMUUKNSLEAHUGF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Hans,

any comment on this?

Thanks,
Michal

On 05/23/2013 04:01 PM, Michal Simek wrote:
> - Remove Userspace I/O platform driver without IRQ support
>   but add this functionality to genirq driver
> - Remove code duplication from OF binding
>=20
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
> The main reason for this change is to have one
> compatibility string for UIO with and without IRQ.
>=20
> ---
>  drivers/uio/Kconfig           |   7 ---
>  drivers/uio/Makefile          |   1 -
>  drivers/uio/uio_pdrv.c        | 113 ----------------------------------=
--------
>  drivers/uio/uio_pdrv_genirq.c |  30 ++++-------
>  4 files changed, 9 insertions(+), 142 deletions(-)
>  delete mode 100644 drivers/uio/uio_pdrv.c
>=20
> diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig
> index e92eeaf..2ff4c90 100644
> --- a/drivers/uio/Kconfig
> +++ b/drivers/uio/Kconfig
> @@ -23,13 +23,6 @@ config UIO_CIF
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called uio_cif.
>=20
> -config UIO_PDRV
> -	tristate "Userspace I/O platform driver"
> -	help
> -	  Generic platform driver for Userspace I/O devices.
> -
> -	  If you don't know what to do here, say N.
> -
>  config UIO_PDRV_GENIRQ
>  	tristate "Userspace I/O platform driver with generic IRQ handling"
>  	help
> diff --git a/drivers/uio/Makefile b/drivers/uio/Makefile
> index b354c53..ea015a2 100644
> --- a/drivers/uio/Makefile
> +++ b/drivers/uio/Makefile
> @@ -1,6 +1,5 @@
>  obj-$(CONFIG_UIO)	+=3D uio.o
>  obj-$(CONFIG_UIO_CIF)	+=3D uio_cif.o
> -obj-$(CONFIG_UIO_PDRV)	+=3D uio_pdrv.o
>  obj-$(CONFIG_UIO_PDRV_GENIRQ)	+=3D uio_pdrv_genirq.o
>  obj-$(CONFIG_UIO_DMEM_GENIRQ)	+=3D uio_dmem_genirq.o
>  obj-$(CONFIG_UIO_AEC)	+=3D uio_aec.o
> diff --git a/drivers/uio/uio_pdrv.c b/drivers/uio/uio_pdrv.c
> deleted file mode 100644
> index 39be9e0..0000000
> --- a/drivers/uio/uio_pdrv.c
> +++ /dev/null
> @@ -1,113 +0,0 @@
> -/*
> - * drivers/uio/uio_pdrv.c
> - *
> - * Copyright (C) 2008 by Digi International Inc.
> - * All rights reserved.
> - *
> - * This program is free software; you can redistribute it and/or modif=
y it
> - * under the terms of the GNU General Public License version 2 as publ=
ished by
> - * the Free Software Foundation.
> - */
> -#include <linux/platform_device.h>
> -#include <linux/uio_driver.h>
> -#include <linux/stringify.h>
> -#include <linux/module.h>
> -#include <linux/slab.h>
> -
> -#define DRIVER_NAME "uio_pdrv"
> -
> -struct uio_platdata {
> -	struct uio_info *uioinfo;
> -};
> -
> -static int uio_pdrv_probe(struct platform_device *pdev)
> -{
> -	struct uio_info *uioinfo =3D pdev->dev.platform_data;
> -	struct uio_platdata *pdata;
> -	struct uio_mem *uiomem;
> -	int ret =3D -ENODEV;
> -	int i;
> -
> -	if (!uioinfo || !uioinfo->name || !uioinfo->version) {
> -		dev_dbg(&pdev->dev, "%s: err_uioinfo\n", __func__);
> -		goto err_uioinfo;
> -	}
> -
> -	pdata =3D kzalloc(sizeof(*pdata), GFP_KERNEL);
> -	if (!pdata) {
> -		ret =3D -ENOMEM;
> -		dev_dbg(&pdev->dev, "%s: err_alloc_pdata\n", __func__);
> -		goto err_alloc_pdata;
> -	}
> -
> -	pdata->uioinfo =3D uioinfo;
> -
> -	uiomem =3D &uioinfo->mem[0];
> -
> -	for (i =3D 0; i < pdev->num_resources; ++i) {
> -		struct resource *r =3D &pdev->resource[i];
> -
> -		if (r->flags !=3D IORESOURCE_MEM)
> -			continue;
> -
> -		if (uiomem >=3D &uioinfo->mem[MAX_UIO_MAPS]) {
> -			dev_warn(&pdev->dev, "device has more than "
> -					__stringify(MAX_UIO_MAPS)
> -					" I/O memory resources.\n");
> -			break;
> -		}
> -
> -		uiomem->memtype =3D UIO_MEM_PHYS;
> -		uiomem->addr =3D r->start;
> -		uiomem->size =3D resource_size(r);
> -		uiomem->name =3D r->name;
> -		++uiomem;
> -	}
> -
> -	while (uiomem < &uioinfo->mem[MAX_UIO_MAPS]) {
> -		uiomem->size =3D 0;
> -		++uiomem;
> -	}
> -
> -	pdata->uioinfo->priv =3D pdata;
> -
> -	ret =3D uio_register_device(&pdev->dev, pdata->uioinfo);
> -
> -	if (ret) {
> -		kfree(pdata);
> -err_alloc_pdata:
> -err_uioinfo:
> -		return ret;
> -	}
> -
> -	platform_set_drvdata(pdev, pdata);
> -
> -	return 0;
> -}
> -
> -static int uio_pdrv_remove(struct platform_device *pdev)
> -{
> -	struct uio_platdata *pdata =3D platform_get_drvdata(pdev);
> -
> -	uio_unregister_device(pdata->uioinfo);
> -
> -	kfree(pdata);
> -
> -	return 0;
> -}
> -
> -static struct platform_driver uio_pdrv =3D {
> -	.probe =3D uio_pdrv_probe,
> -	.remove =3D uio_pdrv_remove,
> -	.driver =3D {
> -		.name =3D DRIVER_NAME,
> -		.owner =3D THIS_MODULE,
> -	},
> -};
> -
> -module_platform_driver(uio_pdrv);
> -
> -MODULE_AUTHOR("Uwe Kleine-Koenig");
> -MODULE_DESCRIPTION("Userspace I/O platform driver");
> -MODULE_LICENSE("GPL v2");
> -MODULE_ALIAS("platform:" DRIVER_NAME);
> diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genir=
q.c
> index d7ba355..ccd2750 100644
> --- a/drivers/uio/uio_pdrv_genirq.c
> +++ b/drivers/uio/uio_pdrv_genirq.c
> @@ -103,8 +103,6 @@ static int uio_pdrv_genirq_probe(struct platform_de=
vice *pdev)
>  	int i;
>=20
>  	if (pdev->dev.of_node) {
> -		int irq;
> -
>  		/* alloc uioinfo for one device */
>  		uioinfo =3D kzalloc(sizeof(*uioinfo), GFP_KERNEL);
>  		if (!uioinfo) {
> @@ -114,13 +112,6 @@ static int uio_pdrv_genirq_probe(struct platform_d=
evice *pdev)
>  		}
>  		uioinfo->name =3D pdev->dev.of_node->name;
>  		uioinfo->version =3D "devicetree";
> -
> -		/* Multiple IRQs are not supported */
> -		irq =3D platform_get_irq(pdev, 0);
> -		if (irq =3D=3D -ENXIO)
> -			uioinfo->irq =3D UIO_IRQ_NONE;
> -		else
> -			uioinfo->irq =3D irq;
>  	}
>=20
>  	if (!uioinfo || !uioinfo->name || !uioinfo->version) {
> @@ -146,14 +137,6 @@ static int uio_pdrv_genirq_probe(struct platform_d=
evice *pdev)
>  	priv->flags =3D 0; /* interrupt is enabled to begin with */
>  	priv->pdev =3D pdev;
>=20
> -	if (!uioinfo->irq) {
> -		ret =3D platform_get_irq(pdev, 0);
> -		if (ret < 0) {
> -			dev_err(&pdev->dev, "failed to get IRQ\n");
> -			goto bad0;
> -		}
> -		uioinfo->irq =3D ret;
> -	}
>  	uiomem =3D &uioinfo->mem[0];
>=20
>  	for (i =3D 0; i < pdev->num_resources; ++i) {
> @@ -190,10 +173,15 @@ static int uio_pdrv_genirq_probe(struct platform_=
device *pdev)
>  	 * Interrupt sharing is not supported.
>  	 */
>=20
> -	uioinfo->handler =3D uio_pdrv_genirq_handler;
> -	uioinfo->irqcontrol =3D uio_pdrv_genirq_irqcontrol;
> -	uioinfo->open =3D uio_pdrv_genirq_open;
> -	uioinfo->release =3D uio_pdrv_genirq_release;
> +	ret =3D platform_get_irq(pdev, 0);
> +	if (ret >=3D 0) {
> +		uioinfo->irq =3D ret;
> +		uioinfo->handler =3D uio_pdrv_genirq_handler;
> +		uioinfo->irqcontrol =3D uio_pdrv_genirq_irqcontrol;
> +		uioinfo->open =3D uio_pdrv_genirq_open;
> +		uioinfo->release =3D uio_pdrv_genirq_release;
> +	}
> +
>  	uioinfo->priv =3D priv;
>=20
>  	/* Enable Runtime PM for this device:
> --
> 1.8.2.3
>=20


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2VDWDNSSMUUKNSLEAHUGF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlGl5kQACgkQykllyylKDCHOMACcCvFjc25dtQtTdj1gqJyBx7wf
h/IAn3utH8TIoO5eCWQkbDUfIMGht679
=YD2R
-----END PGP SIGNATURE-----

------enig2VDWDNSSMUUKNSLEAHUGF--
