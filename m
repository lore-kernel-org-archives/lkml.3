Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594AbaLXA33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 19:29:29 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:33095 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297AbaLXA31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 19:29:27 -0500
Date: Tue, 23 Dec 2014 18:29:04 -0600
From: Felipe Balbi <balbi@ti.com>
To: David Cohen <david.a.cohen@linux.intel.com>
CC: <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <baolu.lu@linux.intel.com>, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [RFC/PATCH] extcon: otg_gpio: add driver for USB OTG port
 controlled by GPIO(s)
Message-ID: <20141224002904.GE32702@saruman>
Reply-To: <balbi@ti.com>
References: <1419288217-19262-1-git-send-email-david.a.cohen@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xJK8B5Wah2CMJs8h"
Content-Disposition: inline
In-Reply-To: <1419288217-19262-1-git-send-email-david.a.cohen@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--xJK8B5Wah2CMJs8h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Dec 22, 2014 at 02:43:37PM -0800, David Cohen wrote:
> Some platforms have an USB OTG port fully (or partially) controlled by
> GPIOs:
>=20
> (1) USB ID is connected directly to GPIO
>=20
> Optionally:
> (2) VBUS is enabled by a GPIO (when ID is grounded)

ok, so a fixed regulator with a GPIO enable pin.

> (3) Platform has 2 USB controllers connected to same port: one for
>     device and one for host role. D+/- are switched between phys
>     by GPIO.

so you have discrete mux with a GPIO select signal, like below ?


 .-------.----------------.  .--------.
 |       |                |  |        |      D+
 |       |                |  |        |<-------------.
 |       |                |  |        |              |
 |       |    USB Host    -->|    P   |              |
 |       |                |  |    H   |              |
 |       |                |  |    Y   |    D-        |
 |       '----------------'  |    0   |<--------.    |
 |                       |   |        |         |    |
 |                       |   '--------'      .--------.  D+
 |                       |                   |        |------>
 |       SOC        GPIO | ----------------->|        |
 |                       |                   |   MUX  |
 |                       |                   |        |------>
 |                       |   .--------.      '--------'  D-
 |       .----------------.  |        |   D-  |      |
 |       |                |  |    P   |<------'      |
 |       |                |  |    H   |              |
 |       |                |  |    Y   |              |
 |       |   USB Device   -->|    1   |              |
 |       |                |  |        |      D+      |
 |       |                |  |        |<-------------'
 |       |                |  |        |
 '-------'----------------'  '--------'

I have been on and off about writing a pinctrl-gpio.c driver which would
allow us to hide this detail from users. It shouldn't really matter
which modes are available behind the mux, but we should be able to tell
the mux to go into mode 0 or mode 1 by toggling its select signal. And
it shouldn't really matter that we have a GPIO pin. The problem is: I
don't really know if pinctrl would be able to handle discrete muxes.

Adding Linus W to ask. Linus, what do you think ? Should we have a
pinctrl-gpio.c for such cases ? In TI we too have quite a few boards
which different modes hidden behind discrete muxes.

> As per initial version, this driver has the duty to control whether
> USB-Host cable is plugged in or not:
>  - If yes, OTG port is configured for host role
>  - If no, by standard, the OTG port is configured for device role

correct, this default-B is mandated by OTG spec anyway.

> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> ---
>=20
> Hi,
>=20
> Some Intel Bay Trail boards have an unusual way to handle the USB OTG por=
t:
>  - The USB ID pin is connected directly to GPIO on SoC
>  - When in host role, VBUS is provided by enabling a GPIO
>  - Device and host roles are supported by 2 independent controllers with =
D+/-
>    pins from port switched between different phys according a GPIO level.
>=20
> The ACPI table describes this USB port as a (virtual) device with all the
> necessary GPIOs. This driver implements support to this virtual device as=
 an
> extcon class driver. All drivers that depend on the USB OTG port state (U=
SB phy,
> PMIC, charge detection) will listen to extcon events.

Right I think you're almost there, but I still think that this needs to
be a bit broken down. First, we need some generic DRD library under
drivers/usb/common, and that should be the one listening to extcon cable
events. But your extcon driver should be doing only that: checking which
cable was attached, it shouldn't be doing the switch by itself. That
should be part of the DRD library.

That DRD library would also be the one enabling the (optional) VBUS
regulator.

George Cherian tried to implement a generic DRD library but I think
there are still too many changes happening on usbcore and udc-core. Most
of the pieces are already there (usb_del_hcd() and usb_del_gadget_udc()
know how to properly unload an hcd/udc), but there are details missing,
no doubt.

If we can find a way to broadcast (probably not the best term, but
whatever) a "Hey ID pin was just grounded" message, we can get things
working.

That message, btw, shouldn't really depend on extcon-gpio alone because
other platforms might use non-gpio methods to verify ID pin level. In
any case, we need to have generic ID_PIN_LOW and ID_PIN_HIGH messages
that a generic DRD library can listen to and load/unload the correct
drivers by means of usb_{add,del}_{hcd,gadget_udc}().

With that in mind, I think you can use extcon-gpio.c for your purposes
if the other pieces can be fullfilled by regulator and pinctrl.

> diff --git a/drivers/extcon/Makefile b/drivers/extcon/Makefile
> index 0370b42e5a27..9e81088c6584 100644
> --- a/drivers/extcon/Makefile
> +++ b/drivers/extcon/Makefile
> @@ -12,3 +12,4 @@ obj-$(CONFIG_EXTCON_MAX8997)	+=3D extcon-max8997.o
>  obj-$(CONFIG_EXTCON_PALMAS)	+=3D extcon-palmas.o
>  obj-$(CONFIG_EXTCON_RT8973A)	+=3D extcon-rt8973a.o
>  obj-$(CONFIG_EXTCON_SM5502)	+=3D extcon-sm5502.o
> +obj-$(CONFIG_EXTCON_OTG_GPIO) +=3D extcon-otg_gpio.o
> diff --git a/drivers/extcon/extcon-otg_gpio.c b/drivers/extcon/extcon-otg=
_gpio.c
> new file mode 100644
> index 000000000000..c5ee765a5f4f
> --- /dev/null
> +++ b/drivers/extcon/extcon-otg_gpio.c
> @@ -0,0 +1,200 @@
> +/*
> + * Virtual USB OTG Port driver controlled by gpios
> + *
> + * Copyright (c) 2014, Intel Corporation.
> + * Author: David Cohen <david.a.cohen@linux.intel.com>
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
> +#include <linux/acpi.h>
> +#include <linux/extcon.h>
> +#include <linux/gpio.h>
> +#include <linux/interrupt.h>
> +#include <linux/platform_device.h>
> +
> +#define DRV_NAME	"usb_otg_port"
> +
> +struct vuport {
> +	struct device *dev;
> +	struct gpio_desc *gpio_vbus_en;
> +	struct gpio_desc *gpio_usb_id;
> +	struct gpio_desc *gpio_usb_mux;
> +
> +	struct extcon_dev edev;
> +};
> +
> +static const char *const vuport_extcon_cable[] =3D {
> +	[0] =3D "USB-Host",
> +	NULL,
> +};
> +
> +/*
> + * If id =3D=3D 1, USB port should be set to peripheral
> + * if id =3D=3D 0, USB port should be set to host
> + *
> + * Peripheral: set USB mux to peripheral and disable VBUS
> + * Host: set USB mux to host and enable VBUS
> + */
> +static void vuport_set_port(struct vuport *vup, int id)
> +{
> +	int mux_val =3D id;
> +	int vbus_val =3D !id;
> +
> +	if (!IS_ERR(vup->gpio_usb_mux))
> +		gpiod_direction_output(vup->gpio_usb_mux, mux_val);
> +
> +	if (!IS_ERR(vup->gpio_vbus_en))
> +		gpiod_direction_output(vup->gpio_vbus_en, vbus_val);

not all SoCs will allow for direction to be set all the time. This can
be glitchy in some cases. What you want here is to set direction during
probe and just set value here.

> +static void vuport_do_usb_id(struct vuport *vup)
> +{
> +	int id =3D gpiod_get_value(vup->gpio_usb_id);
> +
> +	dev_info(vup->dev, "USB PORT ID: %s\n", id ? "PERIPHERAL" : "HOST");

info ? sounds like debug to me.

> +
> +	/*
> +	 * id =3D=3D 1: PERIPHERAL
> +	 * id =3D=3D 0: HOST
> +	 */
> +	vuport_set_port(vup, id);
> +
> +	/*
> +	 * id =3D=3D 0: HOST connected
> +	 * id =3D=3D 1: Host disconnected
> +	 */
> +	extcon_set_cable_state(&vup->edev, "USB-Host", !id);
> +}
> +
> +static irqreturn_t vuport_thread_isr(int irq, void *priv)
> +{

this is unrelated to $subject, but I always consider if we should have a
generic way to figure out if the interrupt was for rising or falling
edge, if we knew that, we could avoid reading the GPIO value altogether
;-)

> +	struct vuport *vup =3D priv;
> +
> +	vuport_do_usb_id(vup);
> +	return IRQ_HANDLED;
> +}
> +
> +static irqreturn_t vuport_isr(int irq, void *priv)
> +{
> +	return IRQ_WAKE_THREAD;
> +}

you don't need this. Set the top half handler to NULL and pass
IRQF_ONESHOT (which you shoudl already have set anyway).

> +#define VUPORT_GPIO_USB_ID	0
> +#define VUPORT_GPIO_VBUS_EN	1
> +#define VUPORT_GPIO_USB_MUX	2
> +static int vuport_probe(struct platform_device *pdev)
> +{
> +	struct device *dev =3D &pdev->dev;
> +	struct vuport *vup;
> +	int ret;
> +
> +	vup =3D devm_kzalloc(dev, sizeof(*vup), GFP_KERNEL);
> +	if (!vup) {
> +		dev_err(dev, "cannot allocate private data\n");
> +		return -ENOMEM;
> +	}
> +	vup->dev =3D dev;
> +
> +	vup->gpio_usb_id =3D devm_gpiod_get_index(dev, "id", VUPORT_GPIO_USB_ID=
);
> +	if (IS_ERR(vup->gpio_usb_id)) {
> +		dev_err(dev, "cannot request USB ID GPIO: ret =3D %ld\n",
> +			PTR_ERR(vup->gpio_usb_id));
> +		return PTR_ERR(vup->gpio_usb_id);
> +	}
> +
> +	ret =3D gpiod_direction_input(vup->gpio_usb_id);
> +	if (ret < 0) {
> +		dev_err(dev, "cannot set input direction to USB ID GPIO: ret =3D %d\n",
> +			ret);
> +		return ret;
> +	}
> +
> +	vup->gpio_vbus_en =3D devm_gpiod_get_index(dev, "vbus en",
> +						 VUPORT_GPIO_VBUS_EN);
> +	if (IS_ERR(vup->gpio_vbus_en))
> +		dev_info(dev, "cannot request VBUS EN GPIO, skipping it.\n");
> +
> +	vup->gpio_usb_mux =3D devm_gpiod_get_index(dev, "usb mux",
> +						 VUPORT_GPIO_USB_MUX);
> +	if (IS_ERR(vup->gpio_usb_mux))
> +		dev_info(dev, "cannot request USB USB MUX, skipping it.\n");
> +
> +	/* register extcon device */
> +	vup->edev.dev.parent =3D dev;
> +	vup->edev.supported_cable =3D vuport_extcon_cable;

IIRC, edev should be allocated from now on. Have a look at
devm_extcon_dev_allocate() and devm_extcon_dev_register().

> +	ret =3D extcon_dev_register(&vup->edev);
> +	if (ret < 0) {
> +		dev_err(dev, "failed to register extcon device: ret =3D %d\n",
> +			ret);
> +		return ret;
> +	}
> +
> +	ret =3D devm_request_threaded_irq(dev, gpiod_to_irq(vup->gpio_usb_id),
> +					vuport_isr, vuport_thread_isr,
> +					IRQF_SHARED | IRQF_TRIGGER_RISING |
> +					IRQF_TRIGGER_FALLING,
> +					dev_name(dev), vup);
> +	if (ret < 0) {
> +		dev_err(dev, "cannot request IRQ for USB ID GPIO: ret =3D %d\n",
> +			ret);
> +		goto irq_err;
> +	}
> +	vuport_do_usb_id(vup);
> +
> +	platform_set_drvdata(pdev, vup);
> +
> +	dev_info(dev, "driver successfully probed\n");

this will just make boot noisier, make it dev_dbg() ? Or even
dev_vdbg() ?

> +MODULE_LICENSE("GPL");

you header on the top of this C file states gpl 2 only, but this says
GPL 2+.

cheers

--=20
balbi

--xJK8B5Wah2CMJs8h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUmgjPAAoJEIaOsuA1yqREfU0P/02GJeYMYCZs2WuHriRf5XYY
DfzZda0nBy8r6TlRLx3rxx3ruBHPpA4gaQXs/UL5TZUmHh4guL1TZyP1kL8tevuu
A6IhxWhh//MSLHNHHuU6AvWWLN0VzXK/9yv50sVyuOBQPpFH4icr8BAuOL5MXAnu
RuosAU+ZrataGdep9HyRNmSGQ3XQnfDpWtXCk6i2oOmHvlNEw6zWOKUiKVfSxOqq
EvslZ7QRBOV1lnjURQUT4UhgByM2p2KK/vpj6de4qLPTyDmzWOutvCKkgZ5RIQ46
l7+vzmaRIYx8kNzWg4sSc/AgzldRak0+e7YvcvXl9f/caRhnv0SW9THuaJINDYpi
/D0GC8WiVXPv46QzmhEJD/wTInAl/UUja5ZCGF52N0e+JMWGvONOOPuPtqw46SaX
fCjCKQsXXLH6bc9N+a1AaqeS7I82ormHZCIAEwKx2EHW0DUJQg6PlnUxfYRqEzi5
Da34d665rtcS8caBlTKJLDMpojCCd3cgzdTV3LKyr9bQFdgl/4eVXxjBI3eUDFWk
VL/1BELRxXsqfXwr3b789ZoBDa/A0q3Z4iee9G9cDeQrMgpsR123p0AjTV9XCqZe
TDA47ebCrCp1FCxPXZSXCltFdvYEx1NkZXQNVa4n+nepTgomO+F4FIFoRBUh68hF
qPtoqPN6ETparidisQ7l
=GYiS
-----END PGP SIGNATURE-----

--xJK8B5Wah2CMJs8h--
