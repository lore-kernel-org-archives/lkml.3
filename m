Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475AbaKDRAI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 12:00:08 -0500
Received: from down.free-electrons.com ([37.187.137.238]:36409 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750819AbaKDRAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 12:00:04 -0500
Date: Tue, 4 Nov 2014 17:57:33 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Hans de Goede <hdegoede@redhat.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH 1/6] clk: sunxi: Add support for sun9i a80 usb clocks and
 resets
Message-ID: <20141104165733.GI26729@lukather>
References: <1415074039-16590-1-git-send-email-wens@csie.org>
 <1415074039-16590-2-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="D6z0c4W1rkZNF4Vu"
Content-Disposition: inline
In-Reply-To: <1415074039-16590-2-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--D6z0c4W1rkZNF4Vu
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Nov 04, 2014 at 12:07:14PM +0800, Chen-Yu Tsai wrote:
> The USB controller/phy clocks and reset controls are in a separate
> address block, unlike previous SoCs where they were in the clock
> controller.
>=20
> This patch copies the original gates clk functions used for usb
> clocks into a separate file, and renames them to *_usb_*. Also
> add a per-gate parent index, so we can set different parents for
> each gate.
>=20
> In time we may move the other usb clock drivers to this file.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---
>  Documentation/devicetree/bindings/clock/sunxi.txt |   5 +
>  drivers/clk/sunxi/Makefile                        |   1 +
>  drivers/clk/sunxi/clk-usb.c                       | 192 ++++++++++++++++=
++++++
>  3 files changed, 198 insertions(+)
>  create mode 100644 drivers/clk/sunxi/clk-usb.c
>=20
> diff --git a/Documentation/devicetree/bindings/clock/sunxi.txt b/Document=
ation/devicetree/bindings/clock/sunxi.txt
> index 0455cb9..b953fe5 100644
> --- a/Documentation/devicetree/bindings/clock/sunxi.txt
> +++ b/Documentation/devicetree/bindings/clock/sunxi.txt
> @@ -66,6 +66,8 @@ Required properties:
>  	"allwinner,sun4i-a10-usb-clk" - for usb gates + resets on A10 / A20
>  	"allwinner,sun5i-a13-usb-clk" - for usb gates + resets on A13
>  	"allwinner,sun6i-a31-usb-clk" - for usb gates + resets on A31
> +	"allwinner,sun9i-a80-usb-mod-clk" - for usb gates + resets on A80
> +	"allwinner,sun9i-a80-usb-phy-clk" - for usb phy gates + resets on A80
> =20
>  Required properties for all clocks:
>  - reg : shall be the control register address for the clock.
> @@ -82,6 +84,9 @@ Required properties for all clocks:
>  And "allwinner,*-usb-clk" clocks also require:
>  - reset-cells : shall be set to 1
> =20
> +"allwinner,sun9i-a80-usb-*-clk" clocks require:
> +- clocks : shall be the usb hci ahb1 gate and peripheral pll clocks
> +

In this particular order, I assume?

>  For "allwinner,sun7i-a20-gmac-clk", the parent clocks shall be fixed rate
>  dummy clocks at 25 MHz and 125 MHz, respectively. See example.
> =20
> diff --git a/drivers/clk/sunxi/Makefile b/drivers/clk/sunxi/Makefile
> index a66953c..f19ce54 100644
> --- a/drivers/clk/sunxi/Makefile
> +++ b/drivers/clk/sunxi/Makefile
> @@ -8,6 +8,7 @@ obj-y +=3D clk-a20-gmac.o
>  obj-y +=3D clk-mod0.o
>  obj-y +=3D clk-sun8i-mbus.o
>  obj-y +=3D clk-sun9i-core.o
> +obj-y +=3D clk-usb.o
> =20
>  obj-$(CONFIG_MFD_SUN6I_PRCM) +=3D \
>  	clk-sun6i-ar100.o clk-sun6i-apb0.o clk-sun6i-apb0-gates.o \
> diff --git a/drivers/clk/sunxi/clk-usb.c b/drivers/clk/sunxi/clk-usb.c
> new file mode 100644
> index 0000000..d92ee36
> --- /dev/null
> +++ b/drivers/clk/sunxi/clk-usb.c
> @@ -0,0 +1,192 @@
> +/*
> + * Copyright 2013 Emilio L=F3pez
> + *
> + * Emilio L=F3pez <emilio@elopez.com.ar>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/clk-provider.h>
> +#include <linux/clkdev.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/reset-controller.h>
> +#include <linux/spinlock.h>
> +
> +
> +/**
> + * sunxi_usb_reset... - reset bits in usb clk registers handling
> + */
> +
> +struct usb_reset_data {
> +	void __iomem			*reg;
> +	spinlock_t			*lock;
> +	struct reset_controller_dev	rcdev;
> +};
> +
> +static int sunxi_usb_reset_assert(struct reset_controller_dev *rcdev,
> +			      unsigned long id)
> +{
> +	struct usb_reset_data *data =3D container_of(rcdev,
> +						   struct usb_reset_data,
> +						   rcdev);
> +	unsigned long flags;
> +	u32 reg;
> +
> +	spin_lock_irqsave(data->lock, flags);
> +
> +	reg =3D readl(data->reg);
> +	writel(reg & ~BIT(id), data->reg);
> +
> +	spin_unlock_irqrestore(data->lock, flags);
> +
> +	return 0;
> +}
> +
> +static int sunxi_usb_reset_deassert(struct reset_controller_dev *rcdev,
> +				unsigned long id)
> +{
> +	struct usb_reset_data *data =3D container_of(rcdev,
> +						     struct usb_reset_data,
> +						     rcdev);
> +	unsigned long flags;
> +	u32 reg;
> +
> +	spin_lock_irqsave(data->lock, flags);
> +
> +	reg =3D readl(data->reg);
> +	writel(reg | BIT(id), data->reg);
> +
> +	spin_unlock_irqrestore(data->lock, flags);
> +
> +	return 0;
> +}
> +
> +static struct reset_control_ops sunxi_usb_reset_ops =3D {
> +	.assert		=3D sunxi_usb_reset_assert,
> +	.deassert	=3D sunxi_usb_reset_deassert,
> +};
> +
> +/**
> + * sunxi_usb_clk_setup() - Setup function for usb gate clocks
> + */
> +
> +#define SUNXI_USB_MAX_SIZE 32
> +
> +struct usb_clk_data {
> +	u32 clk_mask;
> +	u32 reset_mask;
> +	/* which parent to use, should match clock-output-names */
> +	char parents[SUNXI_USB_MAX_SIZE];
> +};
> +
> +static void __init sunxi_usb_clk_setup(struct device_node *node,
> +				       const struct usb_clk_data *data,
> +				       spinlock_t *lock)
> +{
> +	struct clk_onecell_data *clk_data;
> +	struct usb_reset_data *reset_data;
> +	const char *clk_parent;
> +	const char *clk_name;
> +	void __iomem *reg;
> +	int qty;
> +	int i =3D 0;
> +	int j =3D 0;
> +
> +	reg =3D of_iomap(node, 0);

of_io_request_and_map?

> +
> +	/* Worst-case size approximation and memory allocation */
> +	qty =3D find_last_bit((unsigned long *)&data->clk_mask,
> +			    SUNXI_USB_MAX_SIZE);
> +	clk_data =3D kmalloc(sizeof(struct clk_onecell_data), GFP_KERNEL);
> +	if (!clk_data)
> +		return;
> +	clk_data->clks =3D kzalloc((qty+1) * sizeof(struct clk *), GFP_KERNEL);
> +	if (!clk_data->clks) {
> +		kfree(clk_data);
> +		return;
> +	}
> +
> +	for_each_set_bit(i, (unsigned long *)&data->clk_mask,
> +			 SUNXI_USB_MAX_SIZE) {
> +		of_property_read_string_index(node, "clock-output-names",
> +					      j, &clk_name);
> +		clk_parent =3D of_clk_get_parent_name(node, data->parents[j]);
> +
> +		clk_data->clks[i] =3D clk_register_gate(NULL, clk_name,
> +						      clk_parent, 0,
> +						      reg, i, 0, lock);
> +		WARN_ON(IS_ERR(clk_data->clks[i]));
> +		clk_register_clkdev(clk_data->clks[i], clk_name, NULL);
> +
> +		j++;
> +	}
> +
> +	/* Adjust to the real max */
> +	clk_data->clk_num =3D i;
> +
> +	of_clk_add_provider(node, of_clk_src_onecell_get, clk_data);
> +
> +	/* Register a reset controller for usb with reset bits */
> +	if (data->reset_mask =3D=3D 0)
> +		return;
> +
> +	reset_data =3D kzalloc(sizeof(*reset_data), GFP_KERNEL);
> +	if (!reset_data)
> +		return;
> +
> +	reset_data->reg =3D reg;
> +	reset_data->lock =3D lock;
> +	reset_data->rcdev.nr_resets =3D __fls(data->reset_mask) + 1;
> +	reset_data->rcdev.ops =3D &sunxi_usb_reset_ops;
> +	reset_data->rcdev.of_node =3D node;
> +	reset_controller_register(&reset_data->rcdev);
> +}
> +
> +static const struct usb_clk_data sun9i_a80_usb_mod_data __initconst =3D {
> +	.clk_mask =3D BIT(6) | BIT(5) | BIT(4) | BIT(3) | BIT(2) | BIT(1),
> +	.reset_mask =3D BIT(19) | BIT(18) | BIT(17),
> +	.parents =3D {0, 1, 0, 1, 0, 1},
> +};
> +
> +static DEFINE_SPINLOCK(a80_usb_mod_lock);
> +
> +static void __init sun9i_a80_usb_mod_setup(struct device_node *node)
> +{
> +	/* AHB1 gate must be enabled to access registers */
> +	struct clk *ahb =3D of_clk_get(node, 0);
> +
> +	WARN_ON(IS_ERR(ahb));
> +	clk_prepare_enable(ahb);

Hmmmm. That look off.

Why do you need the clock to be enabled all the time? Isn't the CCF
already taking care of enabling the parent clock whenever it needs to
access any register?

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--D6z0c4W1rkZNF4Vu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUWQV9AAoJEBx+YmzsjxAgeEQP/3IlqQZFdC5HR/U0mSXfEygj
aSkK5XfpoQcnPP907rdES719z6502DAFWR+yYOdJL7dWTfBNmLE5oCeU1oCY52Dz
o0r15egpta6QYbNO9D3ZXCOpvU5hUJIRAQ3CFteREPZJ3kiiF0b2g0Kavz86SwtC
Evua7lThg9wexRwvtXy0FjUsvAAd6TqV0llHLlkzrU0mJQeVv0AgFJL80rCwIVbf
UMYKNPvqF9q8hDrybneTpaLelFZmYK7FPJxiKvgVuHei8OkKqF6SZ+bLASs4NXP6
NjFBFeEtEhS5qGudynsy0Ck97XvNmT69df1cBp4e7SHoNIVyCB+39FuW25c5eGD0
98h/ZQId/8om6XZ8xJi+KjLk7ww/ONtdWwH3eUcKF1Ef0mXroRegapMf1aRDPZij
r0/4uW0O4XP+gr+0Zx1qLS+xsjf+kCyRqw4Cm8oiVRAzYlv+7HH1ksPyv1yS9UcL
59NhWoMejiL8C2lFrOK3oXtFhUXGjLJFF6nqam8l5diolGmVtDcp8UScwQOyWUxf
5Fawn/xeojyl5Nk4OHNSOnm0E1LBvIm7kTtDlN5jyGNe6nJ4bzA9jBHqjB1X7AeP
LI7NTutYLiAMI4gWEFr4+853HqsKYyeosuu3cXNGhNI3Km8p+mi6eRGoT4utFwip
aFvAG60Zu0rK3cFBRjGY
=D0I8
-----END PGP SIGNATURE-----

--D6z0c4W1rkZNF4Vu--
