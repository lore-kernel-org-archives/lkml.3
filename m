Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbaAFSQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 13:16:58 -0500
Received: from top.free-electrons.com ([176.31.233.9]:54815 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755081AbaAFSQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 13:16:56 -0500
Date: Mon, 6 Jan 2014 19:14:22 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Roger Quadros <rogerq@ti.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH v2 2/2] reset: Add GPIO support to reset controller
 framework
Message-ID: <20140106181422.GS3144@lukather>
References: <1389030903-27684-1-git-send-email-p.zabel@pengutronix.de>
 <1389030903-27684-2-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qDp7aVEJD61w+rGb"
Content-Disposition: inline
In-Reply-To: <1389030903-27684-2-git-send-email-p.zabel@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qDp7aVEJD61w+rGb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Philipp,

On Mon, Jan 06, 2014 at 06:55:03PM +0100, Philipp Zabel wrote:
> This adds support for GPIO controlled reset pins on peripheral ICs to the=
 reset
> controller framework. Currently there is no support for specifying a delay
> between assertion and de-assertion of the reset signal, so this has to be
> handled by the drivers.
>=20
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
> Changes since v1:
>  - Since (<name>-)reset-gpios is already a common pattern, I have dropped=
 the
>    additional reset-gpio-names property.
>  - A boolean (<name>-)reset-boot-asserted is added to keep GPIOs asserted=
 when
>    requesting them.
>  - Rebased onto Maxime Ripard's of_reset_control_get patch
> ---
>  drivers/reset/Kconfig      |  17 ++++++
>  drivers/reset/Makefile     |   9 ++-
>  drivers/reset/core.c       |  29 +++++-----
>  drivers/reset/gpio-reset.c | 137 +++++++++++++++++++++++++++++++++++++++=
++++++
>  drivers/reset/reset-core.h |  47 ++++++++++++++++
>  5 files changed, 224 insertions(+), 15 deletions(-)
>  create mode 100644 drivers/reset/gpio-reset.c
>  create mode 100644 drivers/reset/reset-core.h
>=20
> diff --git a/drivers/reset/Kconfig b/drivers/reset/Kconfig
> index c9d04f7..a6b12a9 100644
> --- a/drivers/reset/Kconfig
> +++ b/drivers/reset/Kconfig
> @@ -10,4 +10,21 @@ menuconfig RESET_CONTROLLER
>  	  This framework is designed to abstract reset handling of devices
>  	  via GPIOs or SoC-internal reset controller modules.
> =20
> +	  If the device tree contains any resets or reset-gpio properties,
> +	  this probably should be enabled.
> +
>  	  If unsure, say no.
> +
> +if RESET_CONTROLLER
> +
> +menuconfig RESET_GPIO
> +	bool "GPIO Reset Support"
> +	depends on GPIOLIB
> +	default y if GPIOLIB
> +	help
> +	  GPIO Reset Controller support.
> +
> +	  This option lets the reset controller framework handle reset lines
> +	  connected to GPIOs.
> +
> +endif
> diff --git a/drivers/reset/Makefile b/drivers/reset/Makefile
> index cc29832..764bb74 100644
> --- a/drivers/reset/Makefile
> +++ b/drivers/reset/Makefile
> @@ -1,2 +1,9 @@
> -obj-$(CONFIG_RESET_CONTROLLER) +=3D core.o
> +reset-core-objs :=3D core.o
> +
> +obj-$(CONFIG_RESET_CONTROLLER) +=3D reset-core.o
> +
> +ifeq ($(CONFIG_RESET_GPIO),y)
> +  reset-core-objs +=3D gpio-reset.o
> +endif
> +
>  obj-$(CONFIG_ARCH_SUNXI) +=3D reset-sunxi.o
> diff --git a/drivers/reset/core.c b/drivers/reset/core.c
> index baeaf82..6bfd2d2 100644
> --- a/drivers/reset/core.c
> +++ b/drivers/reset/core.c
> @@ -18,23 +18,12 @@
>  #include <linux/reset-controller.h>
>  #include <linux/slab.h>
> =20
> +#include "reset-core.h"
> +
>  static DEFINE_MUTEX(reset_controller_list_mutex);
>  static LIST_HEAD(reset_controller_list);
> =20
>  /**
> - * struct reset_control - a reset control
> - * @rcdev: a pointer to the reset controller device
> - *         this reset control belongs to
> - * @id: ID of the reset controller in the reset
> - *      controller device
> - */
> -struct reset_control {
> -	struct reset_controller_dev *rcdev;
> -	struct device *dev;
> -	unsigned int id;
> -};
> -
> -/**
>   * of_reset_simple_xlate - translate reset_spec to the reset line number
>   * @rcdev: a pointer to the reset controller device
>   * @reset_spec: reset line specifier as found in the device tree
> @@ -149,6 +138,8 @@ struct reset_control *of_reset_control_get(struct dev=
ice_node *node,
>  						 "reset-names", id);
>  	ret =3D of_parse_phandle_with_args(node, "resets", "#reset-cells",
>  					 index, &args);
> +	if (index =3D=3D -EINVAL)
> +		return ERR_PTR(-ENOENT);
>  	if (ret)
>  		return ERR_PTR(ret);
> =20
> @@ -209,6 +200,13 @@ struct reset_control *reset_control_get(struct devic=
e *dev, const char *id)
>  	if (!IS_ERR(rstc))
>  		rstc->dev =3D dev;
> =20
> +	/*
> +	 * If there is no dedicated reset controller device, check if we have
> +	 * a reset line controlled by a GPIO instead.
> +	 */
> +	if (PTR_ERR(rstc) =3D=3D -ENOENT)
> +		return gpio_reset_control_get(dev, id);
> +
>  	return rstc;
>  }
>  EXPORT_SYMBOL_GPL(reset_control_get);
> @@ -223,7 +221,10 @@ void reset_control_put(struct reset_control *rstc)
>  	if (IS_ERR(rstc))
>  		return;
> =20
> -	module_put(rstc->rcdev->owner);
> +	if (reset_control_is_gpio(rstc))
> +		gpio_reset_control_put(rstc);
> +	else
> +		module_put(rstc->rcdev->owner);
>  	kfree(rstc);
>  }
>  EXPORT_SYMBOL_GPL(reset_control_put);
> diff --git a/drivers/reset/gpio-reset.c b/drivers/reset/gpio-reset.c
> new file mode 100644
> index 0000000..78cd023
> --- /dev/null
> +++ b/drivers/reset/gpio-reset.c
> @@ -0,0 +1,137 @@
> +/*
> + * GPIO Reset Controller
> + *
> + * Copyright 2013 Philipp Zabel, Pengutronix
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +#include <linux/device.h>
> +#include <linux/err.h>
> +#include <linux/gpio.h>
> +#include <linux/gpio/consumer.h>
> +#include <linux/reset-controller.h>
> +#include <linux/slab.h>
> +#include <linux/spinlock.h>
> +
> +#include "reset-core.h"
> +
> +/*
> + * Global GPIO reset controller
> + */
> +static struct reset_controller_dev *gpio_rcdev;
> +
> +static int gpio_reset_set(struct reset_controller_dev *rcdev,
> +			  unsigned int gpio, int asserted)
> +{
> +	struct gpio_desc *gpiod =3D gpio_to_desc(gpio);
> +
> +	if (!gpiod)
> +		return -EINVAL;
> +
> +	gpiod_set_value_cansleep(gpiod, asserted);
> +
> +	return 0;
> +}
> +
> +static int gpio_reset_assert(struct reset_controller_dev *rcdev,
> +		unsigned long id)
> +{
> +	return gpio_reset_set(rcdev, id, 1);
> +}
> +
> +static int gpio_reset_deassert(struct reset_controller_dev *rcdev,
> +		unsigned long id)
> +{
> +	return gpio_reset_set(rcdev, id, 0);
> +}
> +
> +static struct reset_control_ops gpio_reset_ops =3D {
> +	.assert =3D gpio_reset_assert,
> +	.deassert =3D gpio_reset_deassert,
> +};
> +
> +struct reset_controller_dev *reset_get_gpio_rcdev(void)
> +{
> +	if (gpio_rcdev)
> +		return gpio_rcdev;
> +
> +	gpio_rcdev =3D kzalloc(sizeof(*gpio_rcdev), GFP_KERNEL);
> +	if (!gpio_rcdev)
> +		return NULL;
> +
> +	gpio_rcdev->owner =3D THIS_MODULE;
> +	gpio_rcdev->ops =3D &gpio_reset_ops;
> +
> +	reset_controller_register(gpio_rcdev);
> +
> +	return gpio_rcdev;
> +}
> +
> +struct reset_control *gpio_reset_control_get(struct device *dev, const c=
har *id)
> +{
> +	const char *assert_prop =3D "reset-initially-asserted";

I guess you meant reset-boot-asserted here, right?

> +	const char *gpio_con_id =3D "reset";
> +	struct reset_controller_dev *rcdev;
> +	struct reset_control *rstc;
> +	struct gpio_desc *gpiod;
> +	bool asserted =3D false;
> +	char scratch[48];
> +	int ret;
> +
> +	if (id) {
> +		snprintf(scratch, 48, "%s-reset-boot-asserted", id);
> +		assert_prop =3D scratch;
> +	}
> +
> +	asserted =3D of_property_read_bool(dev->of_node, assert_prop);
> +
> +	if (id) {
> +		snprintf(scratch, 48, "%s-reset", id);
> +		gpio_con_id =3D scratch;
> +	}
> +
> +	gpiod =3D gpiod_get(dev, gpio_con_id);
> +	if (IS_ERR(gpiod)) {
> +		dev_err(dev, "Failed to get GPIO reset: %ld\n", PTR_ERR(gpiod));
> +		return ERR_CAST(gpiod);
> +	}
> +
> +	ret =3D gpiod_direction_output(gpiod, asserted);
> +	if (ret < 0)
> +		goto err_put;

What happens if the GPIO is active low? I see no way in your binding
and driver to give that information, and that would change the
behaviour quite a bit.


Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--qDp7aVEJD61w+rGb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSyvJ+AAoJEBx+YmzsjxAgJSAP+waO5EVDO2K0xhvTDi1QNT/l
MQqmvGkVSUk0IVo/HGMt7NpTRsTPga3dAh/Q1+F8rtU8OYXX1Tmc6Oe03GTYvbmf
wJ28ZT3HMfaOPGz0lfzNNeLoBf3hLeYc0y1Z6KbIwnAA6hQZW50d5zgVGfyPB9ly
Xl3Zq3VVe58YC14sfdV9NNgvNweaRNcXMaXFWKZ8tmBtsdgurRMHX6WVgGKEx5pZ
zbYwueOQBmF8juUWWtHDmaaSdBwrP79lIK5QkKTUTuLi9AZ3RIb/Lk12911j7nHB
x49aWki7drqgoPI4PRgdBlAZUtmtF0cTJADjizvfCl2AS/6xse6gZN4CTPkhBB9z
yE+c62qyf8T2vl/sMGX+tVMe0hnJXfwKBccUsaW7UtLIDK3OAIXvlMuxhHaKVYHS
TUBliQU5D+rUgbUkKFlgl+UoB6IQKWdNQyYD2jHrggatyEI1Bn5dqAGRgQXN702w
ZJQRrOUuJGMvu27veglRjJUvW/EAW1vhPI6A9olh1yT7vpLi1180QjXkQRy/LQR4
m4JWXm9dse/8lqWdI/ok5NKD0qbR8DgeBES1ftCEPhN3k6W2Yi9X/FICQkgM0Mce
ckHj9gv5lP0w1V1OiK5tLk3EBLrAwvRNXI1C3tx6W7BpopeBnJrX28na04koLFTc
xyql7NH9fz4UM2QCQ0xw
=J1Z3
-----END PGP SIGNATURE-----

--qDp7aVEJD61w+rGb--
