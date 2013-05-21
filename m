Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab3EUFnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 01:43:13 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:47470
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752374Ab3EUFnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 01:43:12 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h1151h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 21 May 2013 13:43:25 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Huang Shijie <b32955@freescale.com>
CC: <grant.likely@linaro.org>, <rob.herring@calxeda.com>, <arnd@arndb.de>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/6] drivers: bus: add a new driver for WEIM
Message-ID: <20130521054323.GE3080@S2101-09.ap.freescale.net>
References: <1369039742-10893-1-git-send-email-b32955@freescale.com>
 <1369039742-10893-2-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1369039742-10893-2-git-send-email-b32955@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 04:48:57PM +0800, Huang Shijie wrote:
> The WEIM(Wireless External Interface Module) works like a bus.
> You can attach many different devices on it, such as NOR, onenand.
> 
> In the case of i.MX6q-sabreauto, the NOR is connected to WEIM.
> 
> This patch also adds the devicetree binding document.
> The driver only works when the devicetree is enabled.
> 
> Signed-off-by: Huang Shijie <b32955@freescale.com>
> ---
>  Documentation/devicetree/bindings/bus/imx-weim.txt |   69 +++++++++
>  drivers/bus/Kconfig                                |    9 ++
>  drivers/bus/Makefile                               |    1 +
>  drivers/bus/imx-weim.c                             |  145 ++++++++++++++++++++
>  4 files changed, 224 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/bus/imx-weim.txt
>  create mode 100644 drivers/bus/imx-weim.c
> 
> diff --git a/Documentation/devicetree/bindings/bus/imx-weim.txt b/Documentation/devicetree/bindings/bus/imx-weim.txt
> new file mode 100644
> index 0000000..9913454
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/bus/imx-weim.txt
> @@ -0,0 +1,69 @@
> +Device tree bindings for i.MX Wireless External Interface Module (WEIM)
> +
> +The term ???wireless??? does not imply that the WEIM is literally an interface

"wireless"

> +without wires. It simply means that this module was originally designed for
> +wireless and mobile applications that use low-power technology.
> +
> +The actual devices are instantiated from the child nodes of a WEIM node.
> +But now we only have the NOR device.
> +
> +NOR flash connected to the WEIM (found on i.MX boards) are represented as
> +child nodes with a name of "nor".

I doubt that WEIM should care the particular device type connected on
it.

> +
> +Required properties:
> +
> + - compatible:		Should be set to "fsl, imx6q-weim"

Drop the space in middle of compatible string.

> + - reg:			A resource specifier for the register space
> +			(see the example below)
> + - interrupts:		the interrupt number, see the example below.
> + - clocks:		the clock, see the example below.
> + - #address-cells:	Must be set to 2 to allow memory address translation
> + - #size-cells:		Must be set to 1 to allow CS address passing
> + - ranges:		Must be set up to reflect the memory layout with four
> +			integer values for each chip-select line in use:
> +
> +			   <cs-number> 0 <physical address of mapping> <size>
> +
> +Timing properties for child nodes. All are mandatory, not optional.
> +
> + -weim-cs-index:	The CS index which the device is attaching on.

It seems we can find it out from "reg" property, so that we can save
this property?

> + -weim-cs-timing:	The timing array, contains 6 timing values for the
> +			weim-cs-index.

This is a vendor specific property, and should have a vendor (fsl)
perfix.  Also please put a space after the first "-" which acts as
a bullet symbol here.

> +
> +Example for an i.MX6q-sabreauto board:

You can write it as i.MX6Q SABRE Auto or imx6q-sabreauto.

> +	weim: weim@021b8000 {
> +		compatible = "fsl,imx6q-weim";
> +		reg = <0x021b8000 0x4000>;
> +		interrupts = <0 14 0x04>;
> +		clocks = <&clks 196>;
> +		#address-cells = <2>;
> +		#size-cells = <1>;
> +		ranges = <0 0 0x08000000 0x08000000>;
> +
> +		nor@0,0 {
> +			compatible = "cfi-flash";
> +			reg = <0 0 0x02000000>;
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			bank-width = <2>;
> +
> +			weim-cs-index = <0>;
> +			weim-cs-timing = <0x00620081 0x00000001 0x1C022000
> +					0x0000C000 0x1404a38e 0x00000000>;
> +			partition@0 {
> +				label = "U-Boot";
> +				reg = <0x0 0x40000>;
> +			};
> +
> +			partition@40000 {
> +				label = "U-Boot-ENV";
> +				reg = <0x40000 0x10000>;
> +				read-only;
> +			};
> +
> +			partition@50000 {
> +				label = "Kernel";
> +				reg = <0x50000 0x3b0000>;
> +			};
> +		};
> +	};
> diff --git a/drivers/bus/Kconfig b/drivers/bus/Kconfig
> index b05ecab..0f997af 100644
> --- a/drivers/bus/Kconfig
> +++ b/drivers/bus/Kconfig
> @@ -4,6 +4,15 @@
>  
>  menu "Bus devices"
>  
> +config IMX_WEIM
> +	tristate "Freescale EIM DRIVER"
> +	depends on ARCH_MXC && MTD_PHYSMAP_OF

I do not see how this driver depends on MTD_PHYSMAP_OF.

> +	help
> +	  Driver for i.MX6 WEIM controller.
> +	  The WEIM(Wireless External Interface Module) works like a bus.
> +	  You can attach many different devices on it, such as NOR, onenand.
> +	  But now, we only support the Parallel NOR.
> +
>  config MVEBU_MBUS
>  	bool
>  	depends on PLAT_ORION
> diff --git a/drivers/bus/Makefile b/drivers/bus/Makefile
> index 3c7b53c..436bbcc 100644
> --- a/drivers/bus/Makefile
> +++ b/drivers/bus/Makefile
> @@ -2,6 +2,7 @@
>  # Makefile for the bus drivers.
>  #
>  
> +obj-$(CONFIG_IMX_WEIM)	+= imx-weim.o
>  obj-$(CONFIG_MVEBU_MBUS) += mvebu-mbus.o
>  obj-$(CONFIG_OMAP_OCP2SCP)	+= omap-ocp2scp.o
>  
> diff --git a/drivers/bus/imx-weim.c b/drivers/bus/imx-weim.c
> new file mode 100644
> index 0000000..8bd9362
> --- /dev/null
> +++ b/drivers/bus/imx-weim.c
> @@ -0,0 +1,145 @@
> +/*
> + * EIM driver for Freescale's i.MX chips
> + *
> + * Copyright (C) 2013 Freescale Semiconductor, Inc.
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2. This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +#include <linux/module.h>
> +#include <linux/clk.h>
> +#include <linux/io.h>
> +#include <linux/of_device.h>
> +
> +struct imx_weim {
> +	void __iomem *base;
> +	struct clk *clk;
> +};
> +
> +static const struct of_device_id weim_id_table[] = {
> +	{ .compatible = "fsl,imx6q-weim", },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(of, weim_id_table);
> +
> +#define CS_TIMING_LEN 6
> +#define CS_REG_RANGE  0x18

Nit: put a blank line here.

> +/* Parse and set the timing for this device. */
> +static int weim_timing(struct platform_device *pdev, struct device_node *np)

Name the function weim_timing_setup for better?

> +{
> +	struct imx_weim *weim = platform_get_drvdata(pdev);
> +	u32 value[CS_TIMING_LEN];
> +	u32 cs_idx;
> +	int ret;
> +	int i;
> +
> +	ret = of_property_read_u32(np, "weim-cs-index", &cs_idx);
> +	if (ret)
> +		goto weim_parse_err;

Why not simply "return ret;"?

> +
> +	ret = of_property_read_u32_array(np, "weim-cs-timing",
> +					value, CS_TIMING_LEN);
> +	if (ret)
> +		goto weim_parse_err;

Ditto

> +
> +	/* set the timing for WEIM */
> +	for (i = 0; i < CS_TIMING_LEN; i++)
> +		writel(value[i], weim->base + cs_idx * CS_REG_RANGE + i * 4);
> +	return 0;
> +
> +weim_parse_err:
> +	return ret;
> +}
> +
> +static int weim_parse_dt(struct platform_device *pdev)
> +{
> +	struct device_node *child;
> +	int ret;
> +
> +	/* We only support the Parallel NOR now. We may add more in future. */
> +	child = of_find_node_by_name(NULL, "nor");
> +	if (child) {
> +		ret = weim_timing(pdev, child);
> +		if (ret)
> +			goto parse_fail;
> +
> +		if (!of_platform_device_create(child, NULL, &pdev->dev)) {
> +			ret = -EINVAL;
> +			goto parse_fail;
> +		}
> +	}
> +	return 0;
> +
> +parse_fail:
> +	return ret;
> +}

I second Sascha's comments on this function.

> +
> +static int weim_probe(struct platform_device *pdev)
> +{
> +	struct imx_weim *weim;
> +	struct resource *res;
> +	int ret = -EINVAL;
> +
> +	weim = devm_kzalloc(&pdev->dev, sizeof(*weim), GFP_KERNEL);
> +	if (!weim) {
> +		ret = -ENOMEM;
> +		goto weim_err;
> +	}
> +	platform_set_drvdata(pdev, weim);
> +
> +	/* get the resource */
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		ret = -ENOENT;
> +		goto weim_err;
> +	}
> +
> +	weim->base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(weim->base)) {
> +		ret = PTR_ERR(weim->base);
> +		goto weim_err;
> +	}
> +
> +	/* get the clock */
> +	weim->clk = devm_clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(weim->clk))
> +		goto weim_err;
> +
> +	clk_prepare_enable(weim->clk);
> +
> +	/* parse the device node */
> +	ret = weim_parse_dt(pdev);
> +	if (ret) {
> +		clk_disable_unprepare(weim->clk);
> +		goto weim_err;
> +	}
> +
> +	dev_info(&pdev->dev, "WEIM driver registered.\n");
> +	return 0;
> +
> +weim_err:
> +	return ret;
> +}
> +
> +static int weim_remove(struct platform_device *pdev)
> +{
> +	struct imx_weim *weim = platform_get_drvdata(pdev);
> +
> +	clk_disable_unprepare(weim->clk);
> +	return 0;
> +}
> +
> +static struct platform_driver weim_driver = {
> +	.driver = {
> +		.name = "imx-weim",
> +		.of_match_table = weim_id_table,
> +	},
> +	.probe   = weim_probe,
> +	.remove  = weim_remove,
> +};
> +
> +module_platform_driver(weim_driver);
> +MODULE_AUTHOR("Freescale Inc.");

"Freescale Semiconductor, Inc."

Shawn

> +MODULE_DESCRIPTION("i.MX EIM Controller Driver");
> +MODULE_LICENSE("GPL");
> -- 
> 1.7.1
> 
> 

