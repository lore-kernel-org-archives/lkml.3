Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbbATTBl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 14:01:41 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:48772 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbbATTBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 14:01:39 -0500
Date: Tue, 20 Jan 2015 13:00:45 -0600
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <balbi@ti.com>, <tony@atomide.com>, <myungjoo.ham@samsung.com>,
        <cw00.choi@samsung.com>, <george.cherian@ti.com>, <nsekhar@ti.com>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] extcon: gpio-usb: Introduce gpio usb extcon driver
Message-ID: <20150120190045.GC15169@saruman>
Reply-To: <balbi@ti.com>
References: <1421689942-10201-1-git-send-email-rogerq@ti.com>
 <1421689942-10201-2-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZmUaFz6apKcXQszQ"
Content-Disposition: inline
In-Reply-To: <1421689942-10201-2-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ZmUaFz6apKcXQszQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 19, 2015 at 07:52:18PM +0200, Roger Quadros wrote:
> This driver observes the USB ID pin connected over a GPIO and
> updates the USB cable extcon states accordingly.
>=20
> The existing GPIO extcon driver is not suitable for this purpose
> as it needs to be taught to understand USB cable states and it
> can't handle more than one cable per instance.
>=20
> For the USB case we need to handle 2 cable states.
> 1) USB (attach/detach)
> 2) USB-Host (attach/detach)
>=20
> This driver can be easily updated in the future to handle VBUS
> events in case it happens to be available on GPIO for any platform.
>=20
> Signed-off-by: Roger Quadros <rogerq@ti.com>

Reviewed-by: Felipe Balbi <balbi@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  .../devicetree/bindings/extcon/extcon-usb.txt      |  20 ++
>  drivers/extcon/Kconfig                             |   7 +
>  drivers/extcon/Makefile                            |   1 +
>  drivers/extcon/extcon-gpio-usb.c                   | 225 +++++++++++++++=
++++++
>  4 files changed, 253 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/extcon/extcon-usb.t=
xt
>  create mode 100644 drivers/extcon/extcon-gpio-usb.c
>=20
> diff --git a/Documentation/devicetree/bindings/extcon/extcon-usb.txt b/Do=
cumentation/devicetree/bindings/extcon/extcon-usb.txt
> new file mode 100644
> index 0000000..171c5a4
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/extcon/extcon-usb.txt
> @@ -0,0 +1,20 @@
> +USB Extcon device
> +
> +This is a virtual device used to generate USB cable states from the USB =
ID pin
> +connected to a GPIO pin.
> +
> +Required properties:
> +- compatible: Should be "linux,extcon-usb"
> +- id-gpio: gpio for USB ID pin. See gpio binding.
> +
> +Example:
> +	extcon_usb1 {
> +		compatible =3D "linux,extcon-usb";
> +		id-gpio =3D <&gpio6 1 GPIO_ACTIVE_HIGH>;
> +	}
> +
> +	usb@1 {
> +		...
> +		extcon =3D <&extcon_usb1>;
> +		...
> +	};
> diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
> index 6a1f7de..8106a83 100644
> --- a/drivers/extcon/Kconfig
> +++ b/drivers/extcon/Kconfig
> @@ -35,6 +35,13 @@ config EXTCON_GPIO
>  	  Say Y here to enable GPIO based extcon support. Note that GPIO
>  	  extcon supports single state per extcon instance.
> =20
> +config EXTCON_GPIO_USB
> +	tristate "USB GPIO extcon support"
> +	depends on GPIOLIB
> +	help
> +	  Say Y here to enable GPIO based USB cable detection extcon support.
> +	  Used typically if GPIO is used for USB ID pin detection.
> +
>  config EXTCON_MAX14577
>  	tristate "MAX14577/77836 EXTCON Support"
>  	depends on MFD_MAX14577
> diff --git a/drivers/extcon/Makefile b/drivers/extcon/Makefile
> index 0370b42..bae594b 100644
> --- a/drivers/extcon/Makefile
> +++ b/drivers/extcon/Makefile
> @@ -12,3 +12,4 @@ obj-$(CONFIG_EXTCON_MAX8997)	+=3D extcon-max8997.o
>  obj-$(CONFIG_EXTCON_PALMAS)	+=3D extcon-palmas.o
>  obj-$(CONFIG_EXTCON_RT8973A)	+=3D extcon-rt8973a.o
>  obj-$(CONFIG_EXTCON_SM5502)	+=3D extcon-sm5502.o
> +obj-$(CONFIG_EXTCON_GPIO_USB)	+=3D extcon-gpio-usb.o
> diff --git a/drivers/extcon/extcon-gpio-usb.c b/drivers/extcon/extcon-gpi=
o-usb.c
> new file mode 100644
> index 0000000..aeb2298
> --- /dev/null
> +++ b/drivers/extcon/extcon-gpio-usb.c
> @@ -0,0 +1,225 @@
> +/**
> + * drivers/extcon/extcon_gpio_usb.c - USB GPIO extcon driver
> + *
> + * Copyright (C) 2015 Texas Instruments Incorporated - http://www.ti.com
> + *
> + * Author: Roger Quadros <rogerq@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/extcon.h>
> +#include <linux/extcon/extcon-gpio.h>
> +#include <linux/gpio.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of_gpio.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/workqueue.h>
> +
> +#define USB_GPIO_DEBOUNCE_MS	20	/* ms */
> +
> +struct usb_extcon_info {
> +	struct device *dev;
> +	struct extcon_dev *edev;
> +
> +	struct gpio_desc *id_gpiod;
> +	int id_irq;
> +
> +	unsigned long debounce_jiffies;
> +	struct delayed_work wq_detcable;
> +};
> +
> +/* List of detectable cables */
> +enum {
> +	EXTCON_CABLE_USB =3D 0,
> +	EXTCON_CABLE_USB_HOST,
> +
> +	EXTCON_CABLE_END,
> +};
> +
> +static const char *usb_extcon_cable[] =3D {
> +	[EXTCON_CABLE_USB] =3D "USB",
> +	[EXTCON_CABLE_USB_HOST] =3D "USB-Host",
> +	NULL,
> +};
> +
> +static void usb_extcon_detect_cable(struct work_struct *work)
> +{
> +	int id;
> +	struct usb_extcon_info *info;
> +	const char **cable_names;
> +
> +	info  =3D container_of(to_delayed_work(work), struct usb_extcon_info,
> +			     wq_detcable);
> +	cable_names =3D info->edev->supported_cable;
> +
> +	/* check ID and update cable state */
> +	id =3D gpiod_get_value_cansleep(info->id_gpiod);
> +
> +	if (id) {
> +		/*
> +		 * ID =3D 1 means USB HOST cable detached.
> +		 * As we don't have event for USB peripheral cable attached,
> +		 * we simulate USB peripheral attach here.
> +		 */
> +		extcon_set_cable_state(info->edev,
> +				       cable_names[EXTCON_CABLE_USB_HOST],
> +				       false);
> +		extcon_set_cable_state(info->edev,
> +				       cable_names[EXTCON_CABLE_USB], true);
> +	} else {
> +		/*
> +		 * ID =3D 0 means USB HOST cable attached.
> +		 * As we don't have event for USB peripheral cable detached,
> +		 * we simulate USB peripheral detach here.
> +		 */
> +		extcon_set_cable_state(info->edev,
> +				       cable_names[EXTCON_CABLE_USB], false);
> +		extcon_set_cable_state(info->edev,
> +				       cable_names[EXTCON_CABLE_USB_HOST],
> +				       true);
> +	}
> +}
> +
> +static irqreturn_t usb_irq_handler(int irq, void *dev_id)
> +{
> +	struct usb_extcon_info *info =3D dev_id;
> +
> +	/* debounce the GPIO via delayed work */
> +	queue_delayed_work(system_power_efficient_wq, &info->wq_detcable,
> +			   info->debounce_jiffies);
> +	return IRQ_HANDLED;
> +}
> +
> +static int usb_extcon_probe(struct platform_device *pdev)
> +{
> +	struct device *dev =3D &pdev->dev;
> +	struct device_node *np =3D dev->of_node;
> +	struct usb_extcon_info *info;
> +	int ret;
> +
> +	if (!np)
> +		return -EINVAL;
> +
> +	info =3D devm_kzalloc(&pdev->dev, sizeof(struct usb_extcon_info),
> +			    GFP_KERNEL);
> +	if (!info)
> +		return -ENOMEM;
> +
> +	info->dev =3D dev;
> +	info->id_gpiod =3D devm_gpiod_get(&pdev->dev, "id");
> +	if (IS_ERR(info->id_gpiod)) {
> +		dev_err(dev, "failed to get ID GPIO\n");
> +		return PTR_ERR(info->id_gpiod);
> +	}
> +
> +	ret =3D gpiod_set_debounce(info->id_gpiod,
> +				 USB_GPIO_DEBOUNCE_MS * 1000);
> +	if (ret < 0)
> +		info->debounce_jiffies =3D msecs_to_jiffies(USB_GPIO_DEBOUNCE_MS);
> +
> +	INIT_DELAYED_WORK(&info->wq_detcable, usb_extcon_detect_cable);
> +
> +	info->id_irq =3D gpiod_to_irq(info->id_gpiod);
> +	if (info->id_irq < 0) {
> +		dev_err(dev, "failed to get ID IRQ\n");
> +		return info->id_irq;
> +	}
> +
> +	ret =3D devm_request_threaded_irq(dev, info->id_irq, NULL,
> +					usb_irq_handler,
> +					IRQF_SHARED | IRQF_ONESHOT,
> +					pdev->name, info);
> +	if (ret < 0) {
> +		dev_err(dev, "failed to request handler for ID IRQ\n");
> +		return ret;
> +	}
> +
> +	info->edev =3D devm_extcon_dev_allocate(dev, usb_extcon_cable);
> +	if (IS_ERR(info->edev)) {
> +		dev_err(dev, "failed to allocate extcon device\n");
> +		return -ENOMEM;
> +	}
> +
> +	ret =3D devm_extcon_dev_register(dev, info->edev);
> +	if (ret < 0) {
> +		dev_err(dev, "failed to allocate extcon device\n");
> +		return ret;
> +	}
> +
> +	platform_set_drvdata(pdev, info);
> +	/* Perform initial detection */
> +	usb_extcon_detect_cable(&info->wq_detcable.work);
> +
> +	return 0;
> +}
> +
> +static int usb_extcon_remove(struct platform_device *pdev)
> +{
> +	struct usb_extcon_info *info =3D platform_get_drvdata(pdev);
> +
> +	cancel_delayed_work_sync(&info->wq_detcable);
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM_SLEEP
> +static int usb_extcon_suspend(struct device *dev)
> +{
> +	struct usb_extcon_info *info;
> +
> +	info =3D dev_get_drvdata(dev);
> +
> +	if (!IS_ERR(info->id_gpiod))
> +		enable_irq_wake(info->id_irq);
> +
> +	return 0;
> +}
> +
> +static int usb_extcon_resume(struct device *dev)
> +{
> +	struct usb_extcon_info *info;
> +
> +	info =3D dev_get_drvdata(dev);
> +
> +	if (!IS_ERR(info->id_gpiod))
> +		disable_irq_wake(info->id_irq);
> +
> +	return 0;
> +}
> +#endif
> +
> +static SIMPLE_DEV_PM_OPS(usb_extcon_pm_ops,
> +			 usb_extcon_suspend, usb_extcon_resume);
> +
> +static struct of_device_id usb_extcon_dt_match[] =3D {
> +	{ .compatible =3D "linux,extcon-usb", },
> +	{ /* end */ }
> +};
> +
> +static struct platform_driver usb_extcon_driver =3D {
> +	.probe		=3D usb_extcon_probe,
> +	.remove		=3D usb_extcon_remove,
> +	.driver		=3D {
> +		.name	=3D "extcon-usb",
> +		.pm	=3D &usb_extcon_pm_ops,
> +		.of_match_table =3D usb_extcon_dt_match,
> +	},
> +};
> +
> +module_platform_driver(usb_extcon_driver);
> +
> +MODULE_AUTHOR("Roger Quadros <rogerq@ti.com>");
> +MODULE_DESCRIPTION("USB GPIO extcon driver");
> +MODULE_LICENSE("GPL v2");
> --=20
> 2.1.0
>=20

--=20
balbi

--ZmUaFz6apKcXQszQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUvqXdAAoJEIaOsuA1yqRE/lwP/iLl34XHgXZMvW1GnJ8dRpRS
9LKkTI7OQ1/3zGx9X4MurHrvr3Cf8onf2Cg5+/t2LFi6Hk5KTWCIs91FGBu3LuzP
4tYXUO22lUryJXLOgMw0N4GsqY9sQnSIQr2NL8Mgurz2cMl2Z7ILGylb3N1v+rq+
TOywTgfRnsPlKBL6Pv5gp7cu2AF1hGfUb7mYQlvHwZ8wqZPIWaeSocpoaSkc/Dy0
+Xvs/qSYbjX3asCVo0AA+vKmvDUVzuzDwnLsK7yY4nzb531rA/QNEqGFR8+KErus
paLvHr3uN1tRO2/wnGZ1CnAOcWEdfDZZCDNVfzMQsLFO+BsTpAcS9Ps+8vLKlH4N
DITwgSHOZzVWvr/bAtkgtVll7SJk5cnmgPmYBeoijO0SwBaj5O02oUWLIOfYVoJ1
fjhWJo6pTXaKVBBu4XNVSzAZ38C3iLEDxB0kmO3O+NN86i7eVXtZGPLCwEBwlatq
mpPVdIWimBwR5jO04tY5p/7r7/M4tks4pCZBRo4LbJKKh6GV99dDe7Dykc/YG/Bt
pyqb9jWtWOmsZsQLShH53wz4OAsgtfE3qOOkHr0x5NC5YP+3+zWLuflKab4/oyvm
J8idrTaBA1K8HFUE6BtXOpM05ThLMpsKw3z27vbU2uxZsrpsQt+n6+hCfIfBxXul
PyiCiUEn5tvz9Dab2zYL
=R/v0
-----END PGP SIGNATURE-----

--ZmUaFz6apKcXQszQ--
