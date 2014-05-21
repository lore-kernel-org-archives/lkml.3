Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbaEUPac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 11:30:32 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:58392 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbaEUPab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 11:30:31 -0400
Date: Wed, 21 May 2014 17:28:13 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: dri-devel@lists.freedesktop.org, airlied@linux.ie,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        lee.jones@linaro.org
Subject: Re: [PATCH v3 02/16] drm: sti: add VTAC drivers
Message-ID: <20140521152811.GN2014@ulmo>
References: <1400594186-8956-1-git-send-email-benjamin.gaignard@linaro.org>
 <1400594186-8956-3-git-send-email-benjamin.gaignard@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zbynv6TNPa9FrOf6"
Content-Disposition: inline
In-Reply-To: <1400594186-8956-3-git-send-email-benjamin.gaignard@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Zbynv6TNPa9FrOf6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

First off: a lot of the general style comments from my review of patch
01/16 also apply here.

On Tue, May 20, 2014 at 03:56:12PM +0200, Benjamin Gaignard wrote:
> Video Trafic Advance Communication Rx and Tx drivers are designed

s/Trafic/Traffic/?

> diff --git a/drivers/gpu/drm/sti/Kconfig b/drivers/gpu/drm/sti/Kconfig
[...]
> @@ -4,6 +4,12 @@ config DRM_STI
>  	help
>  	  Choose this option to enable DRM on STM stiH41x chipset
> =20
> +config VTAC_STI
> +	bool "Video Trafic Advance Communication Rx and Tx for STMicroelectroni=
cs SoC stiH41x Series"

Here too.

> +	depends on DRM_STI
> +	help
> +	  Choose this option to enable VTAC on STM stiH41x chipset

I wonder how useful it is to make all of these user-selectable (or even
Kconfig symbols to begin with). It seems like VTG and VTAC (and the same
is likely true for other subdrivers) are essential to make this driver
do anything useful, so in my opinion these should all be built
unconditionally.

> diff --git a/drivers/gpu/drm/sti/sti_vtac_rx.c b/drivers/gpu/drm/sti/sti_=
vtac_rx.c
[...]
> @@ -0,0 +1,169 @@
> +/*
> + * Copyright (C) STMicroelectronics SA 2013

Nit: this probably needs an update to include 2014.

> +#include <linux/clk.h>
> +#include <linux/component.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>

Should be sorted alphabetically.

> +#include <drm/drmP.h>
> +
> +#include "sti_vtac_utils.h"
> +
> +#define VTAC_RX_CONFIG		0x00
> +#define VTAC_RX_FIFO_CONFIG	0x04
> +
> +#define VTAC_SW_RST_AUTOC	0x02
> +#define VTAC_FIFO_CONFIG_VAL	0x04
> +
> +/*
> + * VTAC RX structure
> + *
> + * @dev: pointer to device structure
> + * @regs: ioremapped regsiters

s/regsiters/registers/

> + * @clk: clock
> + * @type: main or aux device
> + */

Also it's typically not necessary to document these driver-internal data
structures. The meaning of the fields is usually obvious. Also these
aren't usually exported to any documentation (because driver-internal)
and hence kernel-doc isn't such a good fit.

> +struct sti_vtac_rx {
> +	struct device *dev;
> +	void __iomem *regs;
> +	struct clk *clk;
> +	int type;
> +};
> +
> +static void sti_vtac_rx_reg_dump(struct sti_vtac_rx *vtac_rx)
> +{
> +	dev_dbg(vtac_rx->dev, "vtac_rx->regs %p\n", vtac_rx->regs);
> +	dev_dbg(vtac_rx->dev, "VTAC_RX_CONFIG 0x%x\n",
> +		readl(vtac_rx->regs + VTAC_RX_CONFIG));
> +	dev_dbg(vtac_rx->dev, "VTAC_RX_FIFO_CONFIG 0x%x\n",
> +		readl(vtac_rx->regs + VTAC_RX_FIFO_CONFIG));
> +}

Similar as in the previous patch, this would be desirable to have in
debugfs.

> +static void sti_vtac_rx_set_config(struct sti_vtac_rx *vtac_rx)
> +{
> +	int i;
> +	u32 rx_config =3D EVEN_PARITY | ODD_PARITY | SW_RST_AUTOC | ENABLE;

For readability I think it would make sense to move this closer to where
the register is written.

> +
> +	/* Enable VTAC clock */
> +	if (clk_prepare_enable(vtac_rx->clk))
> +		DRM_ERROR("Failed to prepare/enable vtac_rx clock.\n");
> +
> +	for (i =3D 0; i < ARRAY_SIZE(vtac_modes); i++) {
> +		if (vtac_modes[i].type =3D=3D vtac_rx->type) {

Rather than try to lookup the mode by type in a global table, could you
not simply pass in the specific mode that should be configured as a
parameter. That way you can probably leave out the type field from the
sti_vtac_rx structure and use this in a similar way than what I
suggested from the=20

> +			writel(VTAC_FIFO_CONFIG_VAL,
> +			       vtac_rx->regs + VTAC_RX_FIFO_CONFIG);
> +			rx_config |=3D vtac_modes[i].vid_in_width << 4;
> +			rx_config |=3D vtac_modes[i].phyts_width << 16;
> +			rx_config |=3D vtac_modes[i].phyts_per_pixel << 23;
> +			rx_config |=3D VTAC_SW_RST_AUTOC;
> +			writel(rx_config, vtac_rx->regs + VTAC_RX_CONFIG);
> +		}
> +	}
> +}
> +
> +static int vtac_rx_bind(struct device *dev, struct device *master, void =
*data)
> +{
> +	return 0;
> +}
> +
> +static void vtac_rx_unbind(struct device *dev, struct device *master,
> +	void *data)
> +{
> +	/* do nothing */
> +}
> +
> +static const struct component_ops vtac_rx_ops =3D {
> +	.bind	=3D vtac_rx_bind,
> +	.unbind	=3D vtac_rx_unbind,
> +};
> +
> +static int sti_vtac_rx_probe(struct platform_device *pdev)
> +{
> +	struct device *dev =3D &pdev->dev;
> +	struct device_node *np =3D dev->of_node;
> +	struct sti_vtac_rx *vtac_rx;
> +	struct resource *res;
> +
> +	DRM_INFO("%s\n", __func__);
> +
> +	vtac_rx =3D devm_kzalloc(dev, sizeof(*vtac_rx), GFP_KERNEL);
> +	if (!vtac_rx) {
> +		DRM_ERROR("Failed to allocate VTAC RX context\n");
> +		return -ENOMEM;
> +	}
> +	vtac_rx->dev =3D dev;
> +
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		DRM_ERROR("Invalid resource\n");

No need for this. devm_ioremap_resource() already checks for that and
outputs an error message.

> +		return -ENOMEM;
> +	}
> +	vtac_rx->regs =3D devm_ioremap_resource(dev, res);
> +	if (IS_ERR(vtac_rx->regs))
> +		return PTR_ERR(vtac_rx->regs);
> +
> +	vtac_rx->type =3D VTAC_MAIN;
> +	if (np)
> +		if (of_property_read_bool(np, "vtac-rx-aux"))
> +			vtac_rx->type =3D VTAC_AUX;

What exactly is the difference between auxiliary and main here? It seems
like the only reason why you separate things here is because you use
different names for the clocks and devices.

> +	if (vtac_rx->type =3D=3D VTAC_MAIN) {
> +		vtac_rx->clk =3D devm_clk_get(dev, "vtac_main_phy");
> +		if (IS_ERR(vtac_rx->clk)) {
> +			DRM_ERROR("Cannot get vtac_main_phy clock\n");
> +			return PTR_ERR(vtac_rx->clk);
> +		}
> +	} else {
> +		vtac_rx->clk =3D devm_clk_get(dev, "vtac_aux_phy");
> +		if (IS_ERR(vtac_rx->clk)) {
> +			DRM_ERROR("Cannot get vtac_aux_phy clock\n");
> +			return PTR_ERR(vtac_rx->clk);
> +		}
> +	}

There should be no need to make the consumer name of the clock different
for main or auxiliary types. From the above it seems like the clock is
used to drive a PHY, in which case something like "phy" would be good
enough. That way you don't have to conditionalize.

> +	sti_vtac_rx_set_config(vtac_rx);
> +	sti_vtac_rx_reg_dump(vtac_rx);
> +
> +	platform_set_drvdata(pdev, vtac_rx);
> +	DRM_INFO("%s VTAC RX %s\n", __func__,
> +		 vtac_rx->type =3D=3D VTAC_MAIN ? "main" : "aux");
> +
> +	return component_add(&pdev->dev, &vtac_rx_ops);
> +}
> +
> +static int sti_vtac_rx_remove(struct platform_device *pdev)
> +{
> +	component_del(&pdev->dev, &vtac_rx_ops);
> +	return 0;
> +}
> +
> +static struct of_device_id vtac_rx_match_types[] =3D {

Should be static const.

> +	{
> +	 .compatible =3D "st,stih416-vtac-rx",
> +	 }, {
> +	     /* end node */
> +	     }

Funky indentation.

> +};
> +
> +MODULE_DEVICE_TABLE(of, vtac_rx_match_types);

I think it's more common to not have a blank line between the }; and the
MODULE_DEVICE_TABLE. I missed that for 01/12.

> +
> +struct platform_driver sti_vtac_rx_driver =3D {
> +	.driver =3D {
> +		   .name =3D "sti-vtac-rx",
> +		   .owner =3D THIS_MODULE,
> +		   .of_match_table =3D vtac_rx_match_types,
> +		   },
> +	.probe =3D sti_vtac_rx_probe,
> +	.remove =3D sti_vtac_rx_remove,
> +};
> +
> +module_platform_driver(sti_vtac_rx_driver);

Same here, and that also applies to 01/12.

> +
> +MODULE_AUTHOR("Benjamin Gaignard <benjamin.gaignard@st.com>");
> +MODULE_DESCRIPTION("STMicroelectronics SoC VTAC_RX driver");
> +MODULE_LICENSE("GPL");

This doesn't match the license in the file header. This is also wrong in
patch 01/12.

> diff --git a/drivers/gpu/drm/sti/sti_vtac_tx.c b/drivers/gpu/drm/sti/sti_=
vtac_tx.c
> new file mode 100644
> index 0000000..3c0a152
> --- /dev/null
> +++ b/drivers/gpu/drm/sti/sti_vtac_tx.c
> @@ -0,0 +1,182 @@
> +/*
> + * Copyright (C) STMicroelectronics SA 2013
> + * Author: Benjamin Gaignard <benjamin.gaignard@st.com> for STMicroelect=
ronics.
> + * License terms:  GNU General Public License (GPL), version 2
> + */
> +#include <linux/clk.h>
> +#include <linux/component.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <drm/drmP.h>
> +
> +#include "sti_vtac_utils.h"
> +
> +#define VTAC_TX_CONFIG		0x00
> +
> +#define VTAC_SW_RST_AUTOC	0x02
> +
> +#define VTAC_TX_PHY_ENABLE_CLK_PHY	(0x01 << 0)
> +#define VTAC_TX_PHY_PROG_N3		(0x04 << 7)
> +#define VTAC_TX_PHY_ENABLE_CLK_DLL	(0x01 << 1)
> +#define VTAC_TX_PHY_RST_N_DLL_SWITCH	(0x01 << 4)
> +#define VTAC_TX_PHY_PLL_NOT_OSC_MODE	(0x01 << 3)
> +
> +/*
> + * VTAC TX structure
> + *
> + * @dev: pointer to device structure
> + * @regs: ioremapped regsiters
> + * @clk: clock
> + * @type: main or aux device
> + */
> +struct sti_vtac_tx {
> +	struct device *dev;
> +	void __iomem *tx_regs;
> +	void __iomem *phy_regs;

If these are separate register regions, perhaps the PHY part should be
exposed using the generic PHY framework (see Documentation/phy.txt).

> +static void sti_vtac_tx_set_config(struct sti_vtac_tx *vtac_tx)
> +{
> +	int i;
> +	u32 phy_config;
> +	u32 tx_config =3D EVEN_PARITY | ODD_PARITY | SW_RST_AUTOC | ENABLE;

Both of these are awfully long names. Perhaps you can use a single
variable called value here.

> +
> +	/* Enable VTAC clock */
> +	if (clk_prepare_enable(vtac_tx->clk))
> +		DRM_ERROR("Failed to prepare/enable vtac_tx clock.\n");

This would typically be a fatal error, wouldn't it? So this should
return (and probably return the error code as well).

> +
> +	/* Configure vtac phy */
> +	phy_config =3D 0x00000000;
> +	writel(phy_config, vtac_tx->phy_regs + 0x828);	/* SYS_CFG8522 */
> +	phy_config =3D VTAC_TX_PHY_ENABLE_CLK_PHY;
> +	writel(phy_config, vtac_tx->phy_regs + 0x824);	/* SYS_CFG8521 */
> +	phy_config =3D readl(vtac_tx->phy_regs + 0x824);
> +	phy_config |=3D VTAC_TX_PHY_PROG_N3;
> +	writel(phy_config, vtac_tx->phy_regs + 0x824);	/* SYS_CFG8521 */
> +	phy_config =3D readl(vtac_tx->phy_regs + 0x824);
> +	phy_config |=3D VTAC_TX_PHY_ENABLE_CLK_DLL;
> +	writel(phy_config, vtac_tx->phy_regs + 0x824);	/* SYS_CFG8521 */
> +	phy_config =3D readl(vtac_tx->phy_regs + 0x824);
> +	phy_config |=3D VTAC_TX_PHY_RST_N_DLL_SWITCH;
> +	writel(phy_config, vtac_tx->phy_regs + 0x824);	/* SYS_CFG8521 */
> +	phy_config =3D readl(vtac_tx->phy_regs + 0x824);
> +	phy_config |=3D VTAC_TX_PHY_PLL_NOT_OSC_MODE;
> +	writel(phy_config, vtac_tx->phy_regs + 0x824);	/* SYS_CFG8521 */

Can we have a symbolic name for registers 0x824 and 0x828 here, please?

> +
> +	/* Configure vtac tx */
> +	for (i =3D 0; i < ARRAY_SIZE(vtac_modes); i++) {
> +		if (vtac_modes[i].type =3D=3D vtac_tx->type) {
> +			tx_config |=3D vtac_modes[i].vid_in_width << 4;
> +			tx_config |=3D vtac_modes[i].phyts_width << 16;
> +			tx_config |=3D vtac_modes[i].phyts_per_pixel << 23;
> +			tx_config |=3D VTAC_SW_RST_AUTOC;

You already set SW_RST_AUTOC in tx_config and it seems to be the same
value as VTAC_SW_RST_AUTOC. Also please provide only one name for a
given field, either VTAC_SW_RST_AUTOC *or* SW_RST_AUTOC, not both.

> +			writel(tx_config, vtac_tx->tx_regs + VTAC_TX_CONFIG);

Similarly to VTAC Rx I'd set the variable right before writing it to the
register here to make it immediately obvious what value gets written.

Also this is the exact same programming sequence as for VTAC Rx, and the
config register seems to be at the same offset as well, so I'm wondering
if perhaps Rx and Tx VTACs are actually the same hardware. If so you can
probably get away with deduplicating both drivers and parameterizing. If
you move out the PHY register programming into a PHY driver, then most
of that work is already done.

> +static int sti_vtac_tx_probe(struct platform_device *pdev)
> +{
> +	struct device *dev =3D &pdev->dev;
> +	struct device_node *np =3D dev->of_node;
> +	struct sti_vtac_tx *vtac_tx;
> +	struct resource *res;
> +
> +	DRM_INFO("%s\n", __func__);
> +
> +	vtac_tx =3D devm_kzalloc(dev, sizeof(*vtac_tx), GFP_KERNEL);
> +	if (!vtac_tx) {
> +		DRM_ERROR("Failed to allocate VTAC TX context\n");
> +		return -ENOMEM;
> +	}
> +	vtac_tx->dev =3D dev;
> +
> +	res =3D platform_get_resource_byname(pdev, IORESOURCE_MEM, "vtac-tx");
> +	if (!res) {
> +		DRM_ERROR("Invalid resource 'vtac-tx'\n");
> +		return -ENOMEM;
> +	}
> +	vtac_tx->tx_regs =3D devm_ioremap_resource(dev, res);
> +	if (IS_ERR(vtac_tx->tx_regs))
> +		return PTR_ERR(vtac_tx->tx_regs);
> +
> +	res =3D platform_get_resource_byname(pdev, IORESOURCE_MEM, "vtac-phy");
> +	if (!res) {
> +		DRM_ERROR("Invalid resource 'vtac-phy'\n");
> +		return -ENOMEM;
> +	}
> +	vtac_tx->phy_regs =3D devm_ioremap_nocache(dev, res->start,
> +						 resource_size(res));
> +	if (IS_ERR(vtac_tx->phy_regs))
> +		return PTR_ERR(vtac_tx->phy_regs);

Why is this not using devm_ioremap_resource() like the tx_regs resource?
Also if you move this to a separate PHY driver your resource management
becomes a whole lot simpler (no need to worry about the tx_ or phy_
prefixes, ...).

> +static struct of_device_id vtac_tx_match_types[] =3D {

vtac_tx_of_match? Or if you can unify both drivers: vtac_of_match. If
some parameterization is required to make Tx and Rx work in one driver
you could add different compatible strings here for each. More likely
though I think that information could be derived from context.

> +	{
> +	 .compatible =3D "st,stih416-vtac-tx",
> +	 }, {
> +	     /* end node */
> +	     }
> +};

Strange indentation here.

> +MODULE_DEVICE_TABLE(of, vtac_tx_match_types);
> +
> +struct platform_driver sti_vtac_tx_driver =3D {
> +	.driver =3D {
> +		   .name =3D "sti-vtac-tx",
> +		   .owner =3D THIS_MODULE,
> +		   .of_match_table =3D vtac_tx_match_types,
> +		   },

And here.

> diff --git a/drivers/gpu/drm/sti/sti_vtac_utils.h b/drivers/gpu/drm/sti/s=
ti_vtac_utils.h
[...]
> +/* Number of phyts per pixel */

What's a "phyt"?

> +#define VTAC_2_5_PPP	0x0005
> +#define VTAC_3_PPP	0x0006
> +#define VTAC_4_PPP	0x0008
> +#define VTAC_5_PPP	0x000A
> +#define VTAC_6_PPP	0x000C
> +#define VTAC_13_PPP	0x001A
> +#define VTAC_14_PPP	0x001C
> +#define VTAC_15_PPP	0x001E
> +#define VTAC_16_PPP	0x0020
> +#define VTAC_17_PPP	0x0022
> +#define VTAC_18_PPP	0x0024
> +
> +/* enable bits */
> +#define EVEN_PARITY	(1 << 13)
> +#define ODD_PARITY	(1 << 12)
> +#define SW_RST_AUTOC	(1 << 1)
> +#define ENABLE		(1 << 0)

These could probably use a VTAC_ prefix for consistency.

> +
> +/*
> + * VTAC mode structure
> + *
> + * @type: main, aux or dvo device
> + * @vid_in_width: Video Data Resolution

These are probably obvious if you know the hardware or can look at the
datasheet, but I have no idea what this field for example means. I had
initially thought that it would contain some number of pixels, but the
table of modes below taught me better. Having some explanation of the
fields in this structure could be useful.

> + * @phyts_width: Width of phyt buses(phyt low and phyt high).
> + * @phyts_per_pixel: Number of phyts sent per pixel
> + */
> +struct sti_vtac_mode {
> +	int type;
> +	int vid_in_width;
> +	int phyts_width;
> +	int phyts_per_pixel;
> +};
> +
> +static struct sti_vtac_mode vtac_modes[] =3D {
> +	{VTAC_MAIN, 0x2, 0x2, VTAC_5_PPP}, /* Main RGB 12 */
> +	{VTAC_AUX, 0x1, 0x0, VTAC_17_PPP}, /* Aux 10 */
> +};

This doesn't really belong in a header. If you manage to unify both VTAC
Tx and Rx you can simply move this into the VTAC driver source file and
not expose it beyond that at all.

Thierry

--Zbynv6TNPa9FrOf6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTfMYLAAoJEN0jrNd/PrOh9rgP/2pzQ2O08/mXEHuEVpOzP4oa
Uj0h3mLwYDhP9TMmEpiMk4O2l6R5IA+Nt9UDi+TFBtXpMyW+5PuJD0ivQ1yIN8kg
JScpCUIVrq6uPvzWiTiWj+b2Q/OGGxydxyrIE9u1TlBIZ//fbbxH1S9zdMbwBEY3
/+DBe9e1P9LJzJmptXhKrqZRgDgEd/JGVDi1UJHu6DewD26rljtOXlpMTKLezIZh
MsjBu0mWSCsxjTfPaNq7lAZUnbG6CU5UnzeNaCqr7mXFx9VkSDBSgCMrEbxDxz8E
AZJrVX4pALLFV9l9daAChlGViyEgoRYczbEViaT/YD5bj57pVdOQVp9T2jjRPgZR
uueRTwjXcLrD7N8N3Ivdd0IHZ1CIvR+iBaAcedhkwnitms699gC8eJie5/SLLOZp
oJCbUukkM5JbE83IhY4qoDnVxuTwan8126m9k4d7wr57Ag2ewWwkgjuo8EJYilUM
6TRgspvsxd4TDrA52be4nZiZVUB33ACjE702JGWtCKvP5H4hJ5AyXJx9zocnm0WR
sLgkCHN32P4cqeJS6qgHJIpakSGTVRCW1MV4X2yX8/Ee9XGThtv0x0RLoGHwwjQ0
rK4HlS3KOvi8l5Wah3FAhWmrT/Q+XMsGNRm2/KgJj5myUx5ANuezHWfDZFlOv9Ms
SZ5WiPQ/muqZHQme7u1V
=ae3i
-----END PGP SIGNATURE-----

--Zbynv6TNPa9FrOf6--
