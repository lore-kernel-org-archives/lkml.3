Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbbAYQFH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 11:05:07 -0500
Received: from down.free-electrons.com ([37.187.137.238]:58605 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751550AbbAYQFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 11:05:04 -0500
Date: Sun, 25 Jan 2015 17:02:53 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>, Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 1/9] clk: sunxi: Add support for sun9i a80 usb clocks
 and resets
Message-ID: <20150125160253.GG8470@lukather>
References: <1422188530-1794-1-git-send-email-wens@csie.org>
 <1422188530-1794-2-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0qt3EE9wi45a2ZFX"
Content-Disposition: inline
In-Reply-To: <1422188530-1794-2-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0qt3EE9wi45a2ZFX
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Jan 25, 2015 at 08:22:02PM +0800, Chen-Yu Tsai wrote:
> The USB controller/phy clocks and reset controls are in a separate
> address block, unlike previous SoCs where they were in the clock
> controller.
>=20
> This patch copies the original gates clk functions used for usb
> clocks into a separate file, and renames them to *_usb_*. Also
> add a per-gate parent index, so we can set different parents for
> each gate.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---
>  Documentation/devicetree/bindings/clock/sunxi.txt |   2 +
>  drivers/clk/sunxi/Makefile                        |   1 +
>  drivers/clk/sunxi/clk-usb.c                       | 193 ++++++++++++++++=
++++++
>  3 files changed, 196 insertions(+)
>  create mode 100644 drivers/clk/sunxi/clk-usb.c
>=20
> diff --git a/Documentation/devicetree/bindings/clock/sunxi.txt b/Document=
ation/devicetree/bindings/clock/sunxi.txt
> index 60b44285250d..3f1dcd879af7 100644
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
> diff --git a/drivers/clk/sunxi/Makefile b/drivers/clk/sunxi/Makefile
> index 3a5292e3fcf8..058f273d6154 100644
> --- a/drivers/clk/sunxi/Makefile
> +++ b/drivers/clk/sunxi/Makefile
> @@ -9,6 +9,7 @@ obj-y +=3D clk-mod0.o
>  obj-y +=3D clk-sun8i-mbus.o
>  obj-y +=3D clk-sun9i-core.o
>  obj-y +=3D clk-sun9i-mmc.o
> +obj-y +=3D clk-usb.o

Is that supposed to handle the other USB clocks in the future as well?

> =20
>  obj-$(CONFIG_MFD_SUN6I_PRCM) +=3D \
>  	clk-sun6i-ar100.o clk-sun6i-apb0.o clk-sun6i-apb0-gates.o \
> diff --git a/drivers/clk/sunxi/clk-usb.c b/drivers/clk/sunxi/clk-usb.c
> new file mode 100644
> index 000000000000..1a93400353de
> --- /dev/null
> +++ b/drivers/clk/sunxi/clk-usb.c
> @@ -0,0 +1,193 @@
> +/*
> + * Copyright 2013 Emilio L=F3pez
> + *
> + * Emilio L=F3pez <emilio@elopez.com.ar>

Hmmmm, the copyright notice seems weird :)

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
> +	struct clk			*clk;
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
> +	clk_prepare_enable(data->clk);
> +	spin_lock_irqsave(data->lock, flags);
> +
> +	reg =3D readl(data->reg);
> +	writel(reg & ~BIT(id), data->reg);
> +
> +	spin_unlock_irqrestore(data->lock, flags);
> +	clk_disable_unprepare(data->clk);
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
> +	clk_prepare_enable(data->clk);
> +	spin_lock_irqsave(data->lock, flags);
> +
> +	reg =3D readl(data->reg);
> +	writel(reg | BIT(id), data->reg);
> +
> +	spin_unlock_irqrestore(data->lock, flags);
> +	clk_disable_unprepare(data->clk);
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
> +	bool reset_needs_clk;
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
> +	reg =3D of_io_request_and_map(node, 0, of_node_full_name(node));

You should check the return code here.

> +	clk_parent =3D of_clk_get_parent_name(node, 0);
> +	if (!clk_parent)
> +		return;
> +
> +	/* Worst-case size approximation and memory allocation */
> +	qty =3D find_last_bit((unsigned long *)&data->clk_mask,
> +			    SUNXI_USB_MAX_SIZE);

Newline

> +	clk_data =3D kmalloc(sizeof(struct clk_onecell_data), GFP_KERNEL);
> +	if (!clk_data)
> +		return;

Newline.

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
> +		clk_data->clks[i] =3D clk_register_gate(NULL, clk_name,
> +						      clk_parent, 0,
> +						      reg, i, 0, lock);
> +		WARN_ON(IS_ERR(clk_data->clks[i]));
> +		clk_register_clkdev(clk_data->clks[i], clk_name, NULL);

Do we really need to use clkdev for these clocks?

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
> +	if (data->reset_needs_clk)
> +		reset_data->clk =3D of_clk_get(node, 0);

Newline

> +	if (IS_ERR(reset_data->clk)) {
> +		pr_err("Could not get clock for reset controls\n");
> +		kfree(reset_data);
> +		return;
> +	}

Newline, and that block should probably be part of the if block above.

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
> +	.reset_needs_clk =3D 1,
> +};
> +
> +static DEFINE_SPINLOCK(a80_usb_mod_lock);
> +
> +static void __init sun9i_a80_usb_mod_setup(struct device_node *node)
> +{
> +	sunxi_usb_clk_setup(node, &sun9i_a80_usb_mod_data, &a80_usb_mod_lock);
> +}
> +CLK_OF_DECLARE(sun9i_a80_usb_mod, "allwinner,sun9i-a80-usb-mod-clk", sun=
9i_a80_usb_mod_setup);
> +
> +static const struct usb_clk_data sun9i_a80_usb_phy_data __initconst =3D {
> +	.clk_mask =3D BIT(10) | BIT(5) | BIT(4) | BIT(3) | BIT(2) | BIT(1),
> +	.reset_mask =3D BIT(21) | BIT(20) | BIT(19) | BIT(18) | BIT(17),
> +	.reset_needs_clk =3D 1,
> +};
> +
> +static DEFINE_SPINLOCK(a80_usb_phy_lock);
> +
> +static void __init sun9i_a80_usb_phy_setup(struct device_node *node)
> +{
> +	sunxi_usb_clk_setup(node, &sun9i_a80_usb_phy_data, &a80_usb_phy_lock);
> +}
> +CLK_OF_DECLARE(sun9i_a80_usb_phy, "allwinner,sun9i-a80-usb-phy-clk", sun=
9i_a80_usb_phy_setup);

Looks good otherwise, thanks!

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--0qt3EE9wi45a2ZFX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUxROtAAoJEBx+YmzsjxAg7F0QALmKQp0GkoEUg6OTZrAWdf2s
Y/rqlynDCFiLnGjbK3kIw0RXGUduBq5glmgU48lNIUTEwimQHbsMRST0JW7WQC8v
RyAeyIZ7jnColniM1gmS+UfewxiG1OLkRiEtCQ38su0RBYCaPXxAMb7HOljGRjFx
VGvXKD0Gcw5VnzsnRA4QX8ebU7wZe+0PCiejlhWnRRZdz2pXGPc9yCr7YXrmfwch
TC+gB68NroNZDxqrZEThbPoxneYrbgvLjXm2wLRufW73Rv79ongggv8IEmfQXoCZ
9202whwLr783GvmFSkA8eid3FjxN8MwaQ5QuURmdLz3c8Pk9ifj55iYxXWv+MPOu
naeihgUyn0jcg++9tCXbiYHDMoLK9j4UsKsjMoopfG93Adm9I7BKJ2hXdpCVfE0X
NiFru5TmkfegYaSFj2FUS47YuKT/DHDUhjMP0eoNaMRAiTFUS4VUCm14o8ocPL7o
HEsuH23jkqHc9LsNgXCZSrqEKtEK2L9AFl16lGzz9N8aP+b8aOmW9iP2hLbN2vP8
V3wFWQWb70NznDM/0AqFeV3PtLjqqS3G3mjxS7Diq8jyJqmuKniio80sJn+m7mvB
AAnCz77Ccby90AwAefEoSgn9XqKunKT/mb9ecklYHA/O8RP+Ebk3KTSn6HUVGKpF
iW2XkknbMR5jX0Q1qAqa
=JvVf
-----END PGP SIGNATURE-----

--0qt3EE9wi45a2ZFX--
