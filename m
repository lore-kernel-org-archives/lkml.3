Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841AbaEYTnD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 15:43:03 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33580 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751798AbaEYTm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 15:42:57 -0400
Date: Sun, 25 May 2014 21:08:27 +0200
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
Subject: Re: [PATCH 15/22] pinctrl: sunxi: Add A23 PIO controller support
Message-ID: <20140525190827.GV10768@lukather>
References: <1400831485-28576-1-git-send-email-wens@csie.org>
 <1400831485-28576-16-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ln+iIw7POnzHEEo5"
Content-Disposition: inline
In-Reply-To: <1400831485-28576-16-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ln+iIw7POnzHEEo5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 23, 2014 at 03:51:18PM +0800, Chen-Yu Tsai wrote:
> The A23 uses the same pin controller as previous SoC's from Allwinner.
> Add support for the pins controlled by the main PIO controller.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---
>  .../bindings/pinctrl/allwinner,sunxi-pinctrl.txt   |   2 +
>  drivers/pinctrl/sunxi/Kconfig                      |   4 +
>  drivers/pinctrl/sunxi/Makefile                     |   1 +
>  drivers/pinctrl/sunxi/pinctrl-sun8i-a23.c          | 562 +++++++++++++++=
++++++
>  4 files changed, 569 insertions(+)
>  create mode 100644 drivers/pinctrl/sunxi/pinctrl-sun8i-a23.c
>=20
> diff --git a/Documentation/devicetree/bindings/pinctrl/allwinner,sunxi-pi=
nctrl.txt b/Documentation/devicetree/bindings/pinctrl/allwinner,sunxi-pinct=
rl.txt
> index d8d0656..93ce12e 100644
> --- a/Documentation/devicetree/bindings/pinctrl/allwinner,sunxi-pinctrl.t=
xt
> +++ b/Documentation/devicetree/bindings/pinctrl/allwinner,sunxi-pinctrl.t=
xt
> @@ -13,6 +13,8 @@ Required properties:
>    "allwinner,sun6i-a31-pinctrl"
>    "allwinner,sun6i-a31-r-pinctrl"
>    "allwinner,sun7i-a20-pinctrl"
> +  "allwinner,sun8i-a23-pinctrl"
> +  "allwinner,sun8i-a23-r-pinctrl"

This last line belongs in the R_PIO patch :)

>  - reg: Should contain the register physical address and length for the
>    pin controller.
> =20
> diff --git a/drivers/pinctrl/sunxi/Kconfig b/drivers/pinctrl/sunxi/Kconfig
> index da1e830..17a4281 100644
> --- a/drivers/pinctrl/sunxi/Kconfig
> +++ b/drivers/pinctrl/sunxi/Kconfig
> @@ -32,4 +32,8 @@ config PINCTRL_SUN7I_A20
>  	def_bool PINCTRL_SUNXI || MACH_SUN7I
>  	select PINCTRL_SUNXI_COMMON
> =20
> +config PINCTRL_SUN8I_A23
> +       def_bool PINCTRL_SUNXI || MACH_SUN8I
> +       select PINCTRL_SUNXI_COMMON

Since it's going to be merged in 3.16, you can just depend on MACH_SUN8I.

>  endif
> diff --git a/drivers/pinctrl/sunxi/Makefile b/drivers/pinctrl/sunxi/Makef=
ile
> index 0f4461c..850cd50 100644
> --- a/drivers/pinctrl/sunxi/Makefile
> +++ b/drivers/pinctrl/sunxi/Makefile
> @@ -8,3 +8,4 @@ obj-$(CONFIG_PINCTRL_SUN5I_A13)		+=3D pinctrl-sun5i-a13.o
>  obj-$(CONFIG_PINCTRL_SUN6I_A31)		+=3D pinctrl-sun6i-a31.o
>  obj-$(CONFIG_PINCTRL_SUN6I_A31_R)	+=3D pinctrl-sun6i-a31-r.o
>  obj-$(CONFIG_PINCTRL_SUN7I_A20)		+=3D pinctrl-sun7i-a20.o
> +obj-$(CONFIG_PINCTRL_SUN8I_A23)		+=3D pinctrl-sun8i-a23.o
> diff --git a/drivers/pinctrl/sunxi/pinctrl-sun8i-a23.c b/drivers/pinctrl/=
sunxi/pinctrl-sun8i-a23.c
> new file mode 100644
> index 0000000..5e045a6
> --- /dev/null
> +++ b/drivers/pinctrl/sunxi/pinctrl-sun8i-a23.c
> @@ -0,0 +1,562 @@
> +/*
> + * Allwinner A23 SoCs pinctrl driver.
> + *
> + * Copyright (C) 2014 Chen-Yu Tsai
> + *
> + * Chen-Yu Tsai <wens@csie.org>
> + *
> + * Copyright (C) 2014 Maxime Ripard
> + *
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
> +
> +#include "pinctrl-sunxi.h"
> +
> +static const struct sunxi_desc_pin sun8i_a23_pins[] =3D {
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(A, 0),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "spi1"),		/* CS */
> +		  SUNXI_FUNCTION(0x3, "jtag")),		/* MS0 */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(A, 1),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "spi1"),		/* CLK */
> +		  SUNXI_FUNCTION(0x3, "jtag")),		/* CKO */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(A, 2),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "spi1"),		/* MOSI */
> +		  SUNXI_FUNCTION(0x3, "jtag")),		/* DOO */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(A, 3),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "spi1"),		/* MISO */
> +		  SUNXI_FUNCTION(0x3, "jtag")),		/* DIO */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(A, 4),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "uart4")),	/* TX */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(A, 5),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "uart4")),	/* RX */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(A, 6),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "uart4")),	/* RTS */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(A, 7),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "uart4")),	/* CTS */
> +	/* Hole */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(B, 0),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "uart2")),	/* TX */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(B, 1),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "uart2")),	/* RX */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(B, 2),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "uart2")),	/* RTS */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(B, 3),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "uart2")),	/* CTS */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(B, 4),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "i2s0")),		/* SYNC */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(B, 5),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "i2s0")),		/* DOUT */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(B, 6),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "i2s0")),		/* DIN */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(B, 7),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x3, "i2s0")),		/* DI */
> +	/* Hole */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 0),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "nand0"),		/* WE */
> +		  SUNXI_FUNCTION(0x3, "spi0")),		/* MOSI */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 1),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "nand0"),		/* ALE */
> +		  SUNXI_FUNCTION(0x3, "spi0")),		/* MISO */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 2),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "nand0"),		/* CLE */
> +		  SUNXI_FUNCTION(0x3, "spi0")),		/* CLK */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 3),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "nand0"),		/* CE1 */
> +		  SUNXI_FUNCTION(0x3, "spi0")),		/* CS */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 4),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "nand0")),	/* CE0 */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 5),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "nand0"),		/* RE */
> +		  SUNXI_FUNCTION(0x3, "mmc2")),		/* CLK */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 6),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "nand0"),		/* RB0 */
> +		  SUNXI_FUNCTION(0x3, "mmc2")),		/* CMD */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 7),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "nand0")),	/* RB1 */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 8),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "nand0"),		/* DQ0 */
> +		  SUNXI_FUNCTION(0x3, "mmc2")),		/* D0 */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 9),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "nand0"),		/* DQ1 */
> +		  SUNXI_FUNCTION(0x3, "mmc2")),		/* D1 */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 10),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "nand0"),		/* DQ2 */
> +		  SUNXI_FUNCTION(0x3, "mmc2")),		/* D2 */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 11),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "nand0"),		/* DQ3 */
> +		  SUNXI_FUNCTION(0x3, "mmc2")),		/* D3 */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 12),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "nand0"),		/* DQ4 */
> +		  SUNXI_FUNCTION(0x3, "mmc2")),		/* D4 */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 13),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "nand0"),		/* DQ5 */
> +		  SUNXI_FUNCTION(0x3, "mmc2")),		/* D5 */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 14),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "nand"),		/* DQ6 */
> +		  SUNXI_FUNCTION(0x3, "mmc2")),		/* D6 */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 15),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "nand"),		/* DQ7 */
> +		  SUNXI_FUNCTION(0x3, "mmc2")),		/* D7 */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 16),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "nand"),		/* DQS */
> +		  SUNXI_FUNCTION(0x3, "mmc2")),		/* RST */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 17),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "nand0")),	/* CE2 */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 18),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "nand0")),	/* CE3 */
> +	/* Hole */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 0),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "lcd0")),		/* D0 */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 1),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "lcd0")),		/* D1 */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 2),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D2 */
> +		  SUNXI_FUNCTION(0x3, "mmc1")),		/* CLK */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 3),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D3 */
> +		  SUNXI_FUNCTION(0x3, "mmc1")),		/* CMD */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 4),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D4 */
> +		  SUNXI_FUNCTION(0x3, "mmc1")),		/* D0 */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 5),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D5 */
> +		  SUNXI_FUNCTION(0x3, "mmc1")),		/* D1 */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 6),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D6 */
> +		  SUNXI_FUNCTION(0x3, "mmc1")),		/* D2 */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 7),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D7 */
> +		  SUNXI_FUNCTION(0x3, "mmc1")),		/* D3 */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 8),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D8 */
> +		  SUNXI_FUNCTION(0x3, "uart3")),	/* TX */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 9),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D9 */
> +		  SUNXI_FUNCTION(0x3, "uart3")),	/* RX */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 10),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D10 */
> +		  SUNXI_FUNCTION(0x3, "uart1")),	/* TX */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 11),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D11 */
> +		  SUNXI_FUNCTION(0x3, "uart1")),	/* RX */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 12),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D12 */
> +		  SUNXI_FUNCTION(0x3, "uart1")),	/* RTS */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 13),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D13 */
> +		  SUNXI_FUNCTION(0x3, "uart1")),	/* CTS */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 14),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D14 */
> +		  SUNXI_FUNCTION(0x3, "i2s1")),		/* SYNC */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 15),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D15 */
> +		  SUNXI_FUNCTION(0x3, "i2s1")),		/* CLK */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 16),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D16 */
> +		  SUNXI_FUNCTION(0x3, "i2s1")),		/* DOUT */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 17),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D17 */
> +		  SUNXI_FUNCTION(0x3, "i2s1")),		/* DIN */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 18),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D18 */
> +		  SUNXI_FUNCTION(0x3, "lvds0")),	/* VN0 */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 19),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D19 */
> +		  SUNXI_FUNCTION(0x3, "lvds0")),	/* VP0 */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 20),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D20 */
> +		  SUNXI_FUNCTION(0x3, "lvds0")),	/* VP1 */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 21),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D21 */
> +		  SUNXI_FUNCTION(0x3, "lvds0")),	/* VN1 */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 22),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D22 */
> +		  SUNXI_FUNCTION(0x3, "lvds0")),	/* VP2 */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 23),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D23 */
> +		  SUNXI_FUNCTION(0x3, "lvds0")),	/* VN2 */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 24),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "lcd0"),		/* CLK */
> +		  SUNXI_FUNCTION(0x3, "lvds0")),	/* VPC */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 25),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "lcd0"),		/* DE */
> +		  SUNXI_FUNCTION(0x3, "lvds0")),	/* VNC */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 26),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "lcd0"),		/* HSYNC */
> +		  SUNXI_FUNCTION(0x3, "lvds0")),	/* VP3 */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 27),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "lcd0"),		/* VSYNC */
> +		  SUNXI_FUNCTION(0x3, "lvds0")),	/* VN3 */
> +	/* Hole */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(E, 0),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "csi")),		/* PCLK */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(E, 1),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "csi")),		/* MCLK */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(E, 2),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "csi")),		/* HSYNC */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(E, 3),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "csi")),		/* VSYNC */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(E, 4),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "csi")),		/* D0 */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(E, 5),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "csi")),		/* D1 */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(E, 6),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "csi")),		/* D2 */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(E, 7),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "csi")),		/* D3 */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(E, 8),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "csi")),		/* D4 */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(E, 9),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "csi")),		/* D5 */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(E, 10),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "csi")),		/* D6 */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(E, 11),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "csi")),		/* D7 */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(E, 12),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "csi"),		/* D8 */
> +		  SUNXI_FUNCTION(0x3, "i2c2")),		/* SCK */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(E, 13),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "csi"),		/* D9 */
> +		  SUNXI_FUNCTION(0x3, "i2c2")),		/* SDA */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(E, 14),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out")),
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(E, 15),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out")),
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(E, 16),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out")),
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(E, 17),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out")),
> +	/* Hole */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(F, 0),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "mmc0"),		/* D1 */
> +		  SUNXI_FUNCTION(0x3, "jtag")),		/* MS1 */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(F, 1),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "mmc0"),		/* D0 */
> +		  SUNXI_FUNCTION(0x3, "jtag")),		/* DI1 */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(F, 2),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "mmc0"),		/* CLK */
> +		  SUNXI_FUNCTION(0x3, "uart0")),	/* TX */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(F, 3),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "mmc0"),		/* CMD */
> +		  SUNXI_FUNCTION(0x3, "jtag")),		/* DO1 */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(F, 4),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "mmc0"),		/* D3 */
> +		  SUNXI_FUNCTION(0x3, "uart0")),	/* RX */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(F, 5),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "mmc0"),		/* D2 */
> +		  SUNXI_FUNCTION(0x3, "jtag")),		/* CK1 */
> +	/* Hole */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(G, 0),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "mmc1")),		/* CLK */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(G, 1),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "mmc1")),		/* CMD */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(G, 2),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "mmc1")),		/* D0 */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(G, 3),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "mmc1")),		/* D1 */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(G, 4),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "mmc1")),		/* D2 */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(G, 5),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "mmc1")),		/* D3 */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(G, 6),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "uart1")),	/* TX */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(G, 7),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "uart1")),	/* RX */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(G, 8),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "uart2")),	/* RTS */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(G, 9),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "uart2")),	/* CTS */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(G, 10),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "i2s1")),		/* SYNC */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(G, 11),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "i2s1")),		/* CLK */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(G, 12),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "i2s1")),		/* DOUT */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(G, 13),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "i2s1")),		/* DIN */
> +	/* Hole */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(H, 0),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "pwm0")),
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(H, 1),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "pwm1")),
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(H, 2),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "i2c0")),		/* SCK */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(H, 3),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "i2c0")),		/* SDA */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(H, 4),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "i2c1")),		/* SCK */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(H, 5),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "i2c1")),		/* SDA */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(H, 6),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "spi0"),		/* CS */
> +		  SUNXI_FUNCTION(0x3, "uart3")),	/* TX */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(H, 7),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "spi0"),		/* CLK */
> +		  SUNXI_FUNCTION(0x3, "uart3")),	/* RX */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(H, 8),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "spi0"),		/* DOUT */
> +		  SUNXI_FUNCTION(0x3, "uart3")),	/* RTS */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN(H, 9),
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x2, "spi0"),		/* DIN */
> +		  SUNXI_FUNCTION(0x3, "uart3")),	/* CTS */
> +};
> +
> +static const struct sunxi_pinctrl_desc sun8i_a23_pinctrl_data =3D {
> +	.pins =3D sun8i_a23_pins,
> +	.npins =3D ARRAY_SIZE(sun8i_a23_pins),
> +};
> +
> +static int sun8i_a23_pinctrl_probe(struct platform_device *pdev)
> +{
> +	return sunxi_pinctrl_init(pdev,
> +				  &sun8i_a23_pinctrl_data);
> +}
> +
> +static struct of_device_id sun8i_a23_pinctrl_match[] =3D {
> +	{ .compatible =3D "allwinner,sun8i-a23-pinctrl", },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(of, sun8i_a23_pinctrl_match);
> +
> +static struct platform_driver sun8i_a23_pinctrl_driver =3D {
> +	.probe	=3D sun8i_a23_pinctrl_probe,
> +	.driver	=3D {
> +		.name		=3D "sun8i-a23-pinctrl",
> +		.owner		=3D THIS_MODULE,
> +		.of_match_table	=3D sun8i_a23_pinctrl_match,
> +	},
> +};
> +module_platform_driver(sun8i_a23_pinctrl_driver);
> +
> +MODULE_AUTHOR("Chen-Yu Tsai <wens@csie.org>");
> +MODULE_AUTHOR("Maxime Ripard <maxime.ripard@free-electrons.com");
> +MODULE_DESCRIPTION("Allwinner A23 pinctrl driver");
> +MODULE_LICENSE("GPL");

Looks good otherwise.

Once the minor things mentionned above are fixed, you have my Acked-by

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--Ln+iIw7POnzHEEo5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTgj+rAAoJEBx+YmzsjxAgI/sQAK68v673Z8eJQjsI6BY+dfZh
I7DE+PZNTB/E+ZzIjDFX4muQ5mmpJbbJNkfqJBWRLiWf+fAZVHsBaKGhAJOVToCu
kw+VOF2YO1xBlsVKUpDPMR64DFxuRMH7ofKzFTGAJOS5FtM942V4vVt+7yrehaJn
wWjN4rvzvqg1AYHEEokS5tkrmMh2QElrzIUg9+21I09PVHQuI1cBDdgL/zc+eVgi
fdSKOkFQi3xvSAoHW1JICCMadwpxztUJsiHa5twznLB6/GqcHmYPomcErbLislsO
C3O0dBV+3XfmC1jTKrGFdIFESiqEBcEG0AcJ45YS74e5Yp14Zx5g4xS3oZMXOTMM
i1NVixGG4/fItDfg58EHMRA1vIGligVfuxGBWLU53qOB+tAK1nayR/wjiTR/W9Ez
EKosyO/1FnBHYDLNV3Li2O7DqIkeoAPZliqpeS/7qiX8y7FM9JKbf3FuAQDee+Fr
1Q/R4e3KaAbSDUYp6M/gWpv3rI8UOo2Uh0/I6bAh5Z1XjJq7ey/zsik45XyE0w09
qnhP7pncTekzAMJut7LFIIS4AaNvTjrjobvQlifqaCNbHxGn2Q8QOYn1zop8yFxk
iNAe9AcPbLeRmD6GUtzmthWCAc/IK2zGoflf2vVXbEn1UG79EEgwSJsCs1dRKysG
xjE0uyja8jmg7uFPXplk
=J1Jv
-----END PGP SIGNATURE-----

--Ln+iIw7POnzHEEo5--
