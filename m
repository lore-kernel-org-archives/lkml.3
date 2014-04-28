Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525AbaD1XpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 19:45:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54283 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753252AbaD1XpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:45:07 -0400
Date: Mon, 28 Apr 2014 16:40:39 -0700
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chen-Yu Tsai <wens@csie.org>, Philipp Zabel <p.zabel@pengutronix.de>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Hans de Goede <hdegoede@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Subject: Re: [PATCH 5/7] clk: sunxi: add PRCM (Power/Reset/Clock Management)
 clks support
Message-ID: <20140428234039.GT3134@lukather>
References: <1398697130-8338-1-git-send-email-boris.brezillon@free-electrons.com>
 <1398697130-8338-6-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J9YdZykiGPT3Jhx7"
Content-Disposition: inline
In-Reply-To: <1398697130-8338-6-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J9YdZykiGPT3Jhx7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 28, 2014 at 04:58:48PM +0200, Boris BREZILLON wrote:
> The PRCM (Power/Reset/Clock Management) unit provides several clock
> devices:
> - AR100 clk: used to clock the Power Management co-processor
> - AHB0 clk: used to clock the AHB0 bus
> - APB0 clk and gates: used to clk

Used to clk?

>=20
> Add support for these clks in a separate driver so that they can be probed
> as platform devices instead of registered during early init.
> We need this to be able to probe PRCM MFD subdevices.
>=20
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> ---
>  drivers/clk/sunxi/Makefile         |   2 +
>  drivers/clk/sunxi/clk-sun6i-prcm.c | 253 +++++++++++++++++++++++++++++++=
++++++
>  2 files changed, 255 insertions(+)
>  create mode 100644 drivers/clk/sunxi/clk-sun6i-prcm.c
>=20
> diff --git a/drivers/clk/sunxi/Makefile b/drivers/clk/sunxi/Makefile
> index b5bac91..ef8cdc9 100644
> --- a/drivers/clk/sunxi/Makefile
> +++ b/drivers/clk/sunxi/Makefile
> @@ -3,3 +3,5 @@
>  #
> =20
>  obj-y +=3D clk-sunxi.o clk-factors.o
> +
> +obj-$(CONFIG_MFD_SUN6I_PRCM) +=3D clk-sun6i-prcm.o
> diff --git a/drivers/clk/sunxi/clk-sun6i-prcm.c b/drivers/clk/sunxi/clk-s=
un6i-prcm.c
> new file mode 100644
> index 0000000..bb7b25a
> --- /dev/null
> +++ b/drivers/clk/sunxi/clk-sun6i-prcm.c
> @@ -0,0 +1,253 @@
> +/*
> + * Copyright (C) 2014 Free Electrons
> + *
> + * License Terms: GNU General Public License v2
> + * Author: Boris BREZILLON <boris.brezillon@free-electrons.com>
> + *
> + * Allwinner PRCM (Power/Reset/Clock Management) driver
> + *
> + */
> +
> +#include <linux/clk-provider.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +
> +#define SUN6I_APB0_GATES_MAX_SIZE	32
> +#define SUN6I_AR100_MAX_PARENTS		4
> +
> +static int sun6i_a31_ar100_mux_clk_register(struct platform_device *pdev)
> +{
> +	const char *parents[SUN6I_AR100_MAX_PARENTS];
> +	struct device_node *np =3D pdev->dev.of_node;
> +	const char *clk_name =3D np->name;
> +	struct resource *r;
> +	void __iomem *reg;
> +	struct clk *clk;
> +	int nparents;
> +	int i;
> +
> +	r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	reg =3D devm_ioremap(&pdev->dev, r->start, resource_size(r));
> +	if (IS_ERR(reg))
> +		return PTR_ERR(reg);

devm_ioremap returns NULL on error, and not an error pointer.

> +
> +	nparents =3D of_clk_get_parent_count(np);
> +	if (nparents > SUN6I_AR100_MAX_PARENTS)
> +		nparents =3D SUN6I_AR100_MAX_PARENTS;
> +
> +	for (i =3D 0; i < nparents; i++)
> +		parents[i] =3D of_clk_get_parent_name(np, i);
> +
> +	of_property_read_string(np, "clock-output-names", &clk_name);
> +
> +	clk =3D clk_register_mux(&pdev->dev, clk_name, parents, nparents,
> +			       CLK_SET_RATE_NO_REPARENT, reg,
> +			       16, 2, 0, NULL);
> +	if (IS_ERR(clk))
> +		return PTR_ERR(clk);
> +
> +	return of_clk_add_provider(np, of_clk_src_simple_get, clk);
> +}
> +
> +static int sun6i_a31_ar100_clk_register(struct platform_device *pdev)
> +{
> +	struct device_node *np =3D pdev->dev.of_node;
> +	const char *clk_name =3D np->name;
> +	const char *clk_parent;
> +	struct resource *r;
> +	void __iomem *reg;
> +	struct clk *clk;
> +
> +	r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	reg =3D devm_ioremap(&pdev->dev, r->start, resource_size(r));
> +	if (IS_ERR(reg))
> +		return PTR_ERR(reg);

Ditto.

And you'll probably want to use devm_ioremap_resource when you'll have
a single clock for the AR100.

> +
> +	clk_parent =3D of_clk_get_parent_name(np, 0);
> +	if (!clk_parent)
> +		return -EINVAL;
> +
> +	of_property_read_string(np, "clock-output-names", &clk_name);
> +
> +	clk =3D clk_register_divider(&pdev->dev, clk_name, clk_parent,
> +				   0, reg, 4, 2, CLK_DIVIDER_POWER_OF_TWO,
> +				   NULL);
> +	if (IS_ERR(clk))
> +		return PTR_ERR(clk);
> +
> +	return of_clk_add_provider(np, of_clk_src_simple_get, clk);
> +}
> +
> +static int sun6i_a31_ar100_div_clk_register(struct platform_device *pdev)
> +{
> +	struct device_node *np =3D pdev->dev.of_node;
> +	const char *clk_name =3D np->name;
> +	const char *clk_parent;
> +	struct resource *r;
> +	void __iomem *reg;
> +	struct clk *clk;
> +
> +	r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	reg =3D devm_ioremap(&pdev->dev, r->start, resource_size(r));
> +	if (IS_ERR(reg))
> +		return PTR_ERR(reg);
> +
> +	clk_parent =3D of_clk_get_parent_name(np, 0);
> +	if (!clk_parent)
> +		return -EINVAL;
> +
> +	of_property_read_string(np, "clock-output-names", &clk_name);
> +
> +	clk =3D clk_register_divider(&pdev->dev, clk_name, clk_parent,
> +				   0, reg, 8, 5, 0, NULL);
> +	if (IS_ERR(clk))
> +		return PTR_ERR(clk);
> +
> +	return of_clk_add_provider(np, of_clk_src_simple_get, clk);
> +}
> +
> +static int sun6i_a31_apb0_clk_register(struct platform_device *pdev)
> +{
> +	struct device_node *np =3D pdev->dev.of_node;
> +	const char *clk_name =3D np->name;
> +	const char *clk_parent;
> +	struct resource *r;
> +	void __iomem *reg;
> +	struct clk *clk;
> +
> +	r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	reg =3D devm_ioremap_resource(&pdev->dev, r);
> +	if (IS_ERR(reg))
> +		return PTR_ERR(reg);
> +
> +	clk_parent =3D of_clk_get_parent_name(np, 0);
> +	if (!clk_parent)
> +		return -EINVAL;
> +
> +	of_property_read_string(np, "clock-output-names", &clk_name);
> +
> +	clk =3D clk_register_divider(&pdev->dev, clk_name, clk_parent,
> +				   0, reg, 0, 2, CLK_DIVIDER_POWER_OF_TWO,
> +				   NULL);
> +	if (IS_ERR(clk))
> +		return PTR_ERR(clk);
> +
> +	return of_clk_add_provider(np, of_clk_src_simple_get, clk);
> +}
> +
> +static int sun6i_a31_apb0_gates_clk_register(struct platform_device *pde=
v)
> +{
> +	struct device_node *np =3D pdev->dev.of_node;
> +	struct clk_onecell_data *clk_data;
> +	const char *clk_parent;
> +	const char *clk_name;
> +	struct resource *r;
> +	void __iomem *reg;
> +	int gate_id;
> +	int ngates;
> +	int i;
> +
> +	r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	reg =3D devm_ioremap_resource(&pdev->dev, r);
> +	if (!reg)
> +		return PTR_ERR(reg);
> +
> +	clk_parent =3D of_clk_get_parent_name(np, 0);
> +	if (!clk_parent)
> +		return -EINVAL;
> +
> +	ngates =3D of_property_count_strings(np, "clock-output-names");
> +	if (ngates < 0)
> +		return ngates;
> +
> +	if (!ngates || ngates > SUN6I_APB0_GATES_MAX_SIZE)
> +		return -EINVAL;
> +
> +	clk_data =3D devm_kzalloc(&pdev->dev, sizeof(struct clk_onecell_data),
> +				GFP_KERNEL);
> +	if (!clk_data)
> +		return -ENOMEM;
> +
> +	clk_data->clks =3D devm_kzalloc(&pdev->dev,
> +				      SUN6I_APB0_GATES_MAX_SIZE *
> +				      sizeof(struct clk *),
> +				      GFP_KERNEL);
> +	if (!clk_data->clks)
> +		return -ENOMEM;
> +
> +	for (i =3D 0; i < ngates; i++) {
> +		of_property_read_string_index(np, "clock-output-names",
> +					      i, &clk_name);
> +
> +		gate_id =3D i;
> +		of_property_read_u32_index(np, "clock-indices", i, &gate_id);
> +
> +		WARN_ON(gate_id >=3D SUN6I_APB0_GATES_MAX_SIZE);
> +		if (gate_id >=3D SUN6I_APB0_GATES_MAX_SIZE)
> +			continue;
> +
> +		clk_data->clks[gate_id] =3D clk_register_gate(&pdev->dev,
> +							    clk_name,
> +							    clk_parent, 0,
> +							    reg, gate_id,
> +							    0, NULL);
> +		WARN_ON(IS_ERR(clk_data->clks[gate_id]));
> +	}
> +
> +	clk_data->clk_num =3D ngates;
> +
> +	return of_clk_add_provider(np, of_clk_src_onecell_get, clk_data);
> +}
> +
> +const struct of_device_id sun6i_a31_prcm_clk_dt_ids[] =3D {
> +	{
> +		.compatible =3D "allwinner,sun6i-a31-ar100-mux-clk",
> +		.data =3D sun6i_a31_ar100_mux_clk_register,
> +	},
> +	{
> +		.compatible =3D "allwinner,sun6i-a31-ar100-clk",
> +		.data =3D sun6i_a31_ar100_clk_register,
> +	},
> +	{
> +		.compatible =3D "allwinner,sun6i-a31-ar100-div-clk",
> +		.data =3D sun6i_a31_ar100_div_clk_register,
> +	},
> +	{
> +		.compatible =3D "allwinner,sun6i-a31-apb0-clk",
> +		.data =3D sun6i_a31_apb0_clk_register,
> +	},
> +	{
> +		.compatible =3D "allwinner,sun6i-a31-apb0-gates-clk",
> +		.data =3D sun6i_a31_apb0_gates_clk_register,
> +	},
> +	{ /* sentinel */ }
> +};
> +
> +static int sun6i_a31_prcm_clk_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np =3D pdev->dev.of_node;
> +	int (*register_func)(struct platform_device *pdev);
> +	const struct of_device_id *match;
> +
> +	match =3D of_match_node(sun6i_a31_prcm_clk_dt_ids, np);
> +	if (!match)
> +		return -EINVAL;
> +
> +	register_func =3D match->data;
> +	return register_func(pdev);
> +}
> +
> +static struct platform_driver sun6i_a31_prcm_clk_driver =3D {
> +	.driver =3D {
> +		.name =3D "sun6i-a31-prcm-clk",
> +		.owner =3D THIS_MODULE,
> +		.of_match_table =3D sun6i_a31_prcm_clk_dt_ids,
> +	},
> +	.probe =3D sun6i_a31_prcm_clk_probe,

You're not calling the of_clk_del_provider, and you should probably
unregister your clocks too.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--J9YdZykiGPT3Jhx7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTXub3AAoJEBx+YmzsjxAgbT4QAJnCKwRvvqsxGlvyiDU7PCVl
yDI0XT1nFQ3nHWD0EnRUhotA98Mv1/UPkoLzAS6GF97Q7vXZbeIWBSQyVcC4D5Lq
e5eTAiIehG8vvkPYmmc1Z058y9zOGYHjeljc2hJ59bVw1HQkRgqGrKGtl6zD4a92
gVejlKQh+DLE6h9h9uMWvOlUFGWoRkhplNOd4B3/rv5Y4D1tbXLWBVM+EyvRVD0S
jD6D1WebpE+AJZuahldi2/CmBZliM2iKDWHR8WrYviwo5nofH5SJmqNFUiohLWy8
K4+pJKWbac/PjxkAA8e1wql8qvpyfTN7VOrVMiKpIsMYoOl3wgj4JHlND0eYbZ8L
aDElKRJvMphAd9gonz2x23LGPoKITw/RGDNc0xrKLs0lhaN6HG2p0rJZXDp4iDPx
p8ULBGSYuiK7vSLU4ZJG6ygwOnJzgaijCqcg/LmYf53OzRZS1ed9mfMsn5JHjJMp
BQUv2v1FDBoWonjpYnxKOdknAV0eVU5CJKvfAoi34EDxqQq3VIOLqXtk8nFWHY3q
IKp730t+FyAmLbyprPg46lH3Yijm36gsjNx53dcrYLpiKvBxphqhq9UNyU+Nocwe
dG+W9OUW6rC015D3U5VAAqjyYCF3GxYYNbXiT9FebcKjA8Px3t4Ab0ilC5k4Tq4s
NTcG43nrAHVTQYdULoBP
=oBQL
-----END PGP SIGNATURE-----

--J9YdZykiGPT3Jhx7--
