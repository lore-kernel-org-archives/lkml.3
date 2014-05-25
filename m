Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbaEYTnJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 15:43:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33591 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751798AbaEYTnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 15:43:05 -0400
Date: Sun, 25 May 2014 21:11:28 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Subject: Re: [PATCH 16/22] pinctrl: sunxi: Add A23 R_PIO controller support
Message-ID: <20140525191128.GW10768@lukather>
References: <1400831485-28576-1-git-send-email-wens@csie.org>
 <1400831485-28576-17-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7kW37LRKoI6fR2de"
Content-Disposition: inline
In-Reply-To: <1400831485-28576-17-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7kW37LRKoI6fR2de
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 23, 2014 at 03:51:19PM +0800, Chen-Yu Tsai wrote:
> The A23 has a R_PIO pin controller, similar to the one found on the A31 S=
oC.
> Add support for the pins controlled by the R_PIO controller.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---
>  drivers/pinctrl/sunxi/Kconfig               |   4 +
>  drivers/pinctrl/sunxi/Makefile              |   1 +
>  drivers/pinctrl/sunxi/pinctrl-sun8i-a23-r.c | 129 ++++++++++++++++++++++=
++++++
>  3 files changed, 134 insertions(+)
>  create mode 100644 drivers/pinctrl/sunxi/pinctrl-sun8i-a23-r.c
>=20
> diff --git a/drivers/pinctrl/sunxi/Kconfig b/drivers/pinctrl/sunxi/Kconfig
> index 17a4281..3058d32 100644
> --- a/drivers/pinctrl/sunxi/Kconfig
> +++ b/drivers/pinctrl/sunxi/Kconfig
> @@ -36,4 +36,8 @@ config PINCTRL_SUN8I_A23
>         def_bool PINCTRL_SUNXI || MACH_SUN8I
>         select PINCTRL_SUNXI_COMMON
> =20
> +config PINCTRL_SUN8I_A23_R
> +       def_bool PINCTRL_SUNXI || MACH_SUN8I

Like said in the previous patch, you can just depend on MACH_SUN8I
here.

> +       select PINCTRL_SUNXI_COMMON
> +
>  endif
> diff --git a/drivers/pinctrl/sunxi/Makefile b/drivers/pinctrl/sunxi/Makef=
ile
> index 850cd50..e797efb 100644
> --- a/drivers/pinctrl/sunxi/Makefile
> +++ b/drivers/pinctrl/sunxi/Makefile
> @@ -9,3 +9,4 @@ obj-$(CONFIG_PINCTRL_SUN6I_A31)		+=3D pinctrl-sun6i-a31.o
>  obj-$(CONFIG_PINCTRL_SUN6I_A31_R)	+=3D pinctrl-sun6i-a31-r.o
>  obj-$(CONFIG_PINCTRL_SUN7I_A20)		+=3D pinctrl-sun7i-a20.o
>  obj-$(CONFIG_PINCTRL_SUN8I_A23)		+=3D pinctrl-sun8i-a23.o
> +obj-$(CONFIG_PINCTRL_SUN8I_A23_R)	+=3D pinctrl-sun8i-a23-r.o
> diff --git a/drivers/pinctrl/sunxi/pinctrl-sun8i-a23-r.c b/drivers/pinctr=
l/sunxi/pinctrl-sun8i-a23-r.c
> new file mode 100644
> index 0000000..ae17888
> --- /dev/null
> +++ b/drivers/pinctrl/sunxi/pinctrl-sun8i-a23-r.c
> @@ -0,0 +1,129 @@
> +/*
> + * Allwinner A23 SoCs special pins pinctrl driver.
> + *
> + * Copyright (C) 2014 Chen-Yu Tsai
> + * Chen-Yu Tsai <wens@csie.org>
> + *
> + * Copyright (C) 2014 Boris Brezillon
> + * Boris Brezillon <boris.brezillon@free-electrons.com>
> + *
> + * Copyright (C) 2014 Maxime Ripard
> + * Maxime Ripard <maxime.ripard@free-electrons.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2.  This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/pinctrl/pinctrl.h>
> +#include <linux/reset.h>
> +
> +#include "pinctrl-sunxi.h"
> +
> +static const struct sunxi_desc_pin sun8i_a23_r_pins[] =3D {
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(L, 0),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "s_rsb"),		/* SCK */
> +		  SUNXI_FUNCTION(0x3, "s_twi")),	/* SCK */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(L, 1),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "s_rsb"),		/* SDA */
> +		  SUNXI_FUNCTION(0x3, "s_twi")),	/* SDA */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(L, 2),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "s_uart")),	/* TX */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(L, 3),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "s_uart")),	/* RX */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(L, 4),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x3, "s_jtag")),	/* MS */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(L, 5),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x3, "s_jtag")),	/* CK */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(L, 6),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x3, "s_jtag")),	/* DO */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(L, 7),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x3, "s_jtag")),	/* DI */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(L, 8),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "s_twi")),	/* SCK */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(L, 9),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "s_twi")),	/* SDA */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(L, 10),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "s_pwm")),
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(L, 11),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out")),
> +};
> +
> +static const struct sunxi_pinctrl_desc sun8i_a23_r_pinctrl_data =3D {
> +	.pins =3D sun8i_a23_r_pins,
> +	.npins =3D ARRAY_SIZE(sun8i_a23_r_pins),
> +	.pin_base =3D PL_BASE,
> +};
> +
> +static int sun8i_a23_r_pinctrl_probe(struct platform_device *pdev)
> +{
> +	struct reset_control *rstc;
> +	int ret;
> +
> +	rstc =3D devm_reset_control_get(&pdev->dev, NULL);

Oh, and since you're using the reset framework, you should depends on
RESET_CONTROLLER.

> +	if (IS_ERR(rstc)) {
> +		dev_err(&pdev->dev, "Reset controller missing\n");
> +		return PTR_ERR(rstc);
> +	}
> +
> +	ret =3D reset_control_deassert(rstc);
> +	if (ret)
> +		return ret;
> +
> +	ret =3D sunxi_pinctrl_init(pdev,
> +				 &sun8i_a23_r_pinctrl_data);
> +
> +	if (ret)
> +		reset_control_assert(rstc);
> +
> +	return ret;
> +}
> +
> +static struct of_device_id sun8i_a23_r_pinctrl_match[] =3D {
> +	{ .compatible =3D "allwinner,sun8i-a23-r-pinctrl", },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(of, sun8i_a23_r_pinctrl_match);
> +
> +static struct platform_driver sun8i_a23_r_pinctrl_driver =3D {
> +	.probe	=3D sun8i_a23_r_pinctrl_probe,
> +	.driver	=3D {
> +		.name		=3D "sun8i-a23-r-pinctrl",
> +		.owner		=3D THIS_MODULE,
> +		.of_match_table	=3D sun8i_a23_r_pinctrl_match,
> +	},
> +};
> +module_platform_driver(sun8i_a23_r_pinctrl_driver);
> +
> +MODULE_AUTHOR("Chen-Yu Tsai <wens@csie.org>");
> +MODULE_AUTHOR("Boris Brezillon <boris.brezillon@free-electrons.com");
> +MODULE_AUTHOR("Maxime Ripard <maxime.ripard@free-electrons.com");
> +MODULE_DESCRIPTION("Allwinner A23 R_PIO pinctrl driver");
> +MODULE_LICENSE("GPL");

Looks good otherwise, once these minor things are fixed, you have my
acked-by.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--7kW37LRKoI6fR2de
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTgkBgAAoJEBx+YmzsjxAgajsQALuM5Esu2lI45xQE3a8VrXJB
gjO+ODhwtk2CLXRTy0doURPTs3BjTCDn7iWw9OphLSqfB5W0QioVjNEuSkzjdrXe
MOylNquOYQuwVR4lhodr1YW6NT+KXtbDpfWRWTI8GXzdssj9q03itPgEnVf0Im+x
/Vx0lSMx//W8/GE+WzbjWYuajm+vsvY1ryrHWEDF+CxnuL6eNVDTe7BY6VE/TBSR
hx4qw66RVSQNqS4n1huI2Kc37z/TuakvMZaLfqHuU8ebu6wRc7aqR+izreh037Ul
vSyjZTo77eJhNM0W3uDftHUJX5OO1F7VL8e/TKVecl38/Lq/7QeY4UTHTO5XbUcl
U+8xCBGWuB0oxWOO8rUE94HSKVNfBkC5oWiRhZfXxcYQ18Cmfdja8XJTCuAchtic
LitQG8+zRJea9O5+Q6pu8zqUCVX7ZMJERg/JM4WeVgq8CI/jpE/0GKDUBVk4nxKL
dTkBkinuD3QCPoFPx8byA9Z0uEaJc4dF7BypB/eIfJpSqOmeFcovn4wZbwMtC0t0
iFx9H7/VHYZyy0WchTk/WZlslpjwe2cRasxuqMr9hxOM79HqsYQx+uxb/EV6KlMU
GP/xiDgb7jJcsHFpxV0oWqIXS+FJCjTbXxb4rgBZw7Qr86WJy9Hi7ZpeYNc8UeMl
5+NV4yLGrgrtrk1by9ci
=e5Vp
-----END PGP SIGNATURE-----

--7kW37LRKoI6fR2de--
