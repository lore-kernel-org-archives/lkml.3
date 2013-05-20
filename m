Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab3ETNSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 09:18:35 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33961 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab3ETNSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 09:18:33 -0400
Date: Mon, 20 May 2013 15:18:27 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Huang Shijie <b32955@freescale.com>
Cc: grant.likely@linaro.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/6] drivers: bus: add a new driver for WEIM
Message-ID: <20130520131827.GB32299@pengutronix.de>
References: <1369039742-10893-1-git-send-email-b32955@freescale.com>
 <1369039742-10893-2-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369039742-10893-2-git-send-email-b32955@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:56:07 up 331 days,  4:07, 56 users,  load average: 0.28, 0.40,
 0.52
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
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
> +without wires. It simply means that this module was originally designed for
> +wireless and mobile applications that use low-power technology.
> +
> +The actual devices are instantiated from the child nodes of a WEIM node.
> +But now we only have the NOR device.
> +
> +NOR flash connected to the WEIM (found on i.MX boards) are represented as
> +child nodes with a name of "nor".
> +
> +Required properties:
> +
> + - compatible:		Should be set to "fsl, imx6q-weim"
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
> + -weim-cs-timing:	The timing array, contains 6 timing values for the
> +			weim-cs-index.
> +
> +Example for an i.MX6q-sabreauto board:
> +	weim: weim@021b8000 {
> +		compatible = "fsl,imx6q-weim";
> +		reg = <0x021b8000 0x4000>;
> +		interrupts = <0 14 0x04>;
> +		clocks = <&clks 196>;
> +		#address-cells = <2>;

Why is address cells 2 in this example?

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

The partitions are unnecessary to understand the example. Please drop them.

> +#define CS_TIMING_LEN 6
> +#define CS_REG_RANGE  0x18
> +/* Parse and set the timing for this device. */
> +static int weim_timing(struct platform_device *pdev, struct device_node *np)
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

It would be nice to check for cs_idx being valid.

> +
> +	ret = of_property_read_u32_array(np, "weim-cs-timing",
> +					value, CS_TIMING_LEN);
> +	if (ret)
> +		goto weim_parse_err;
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

What you want to do here is:

- iterate over your child nodes
- call weim_timing() for each of them
- call of_platform_device_create for each child (or even
  of_platform_populate() with the parent node)


> +	return 0;
> +
> +parse_fail:
> +	return ret;
> +}
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

No need to do error checking here. devm_ioremap_resource() will do this
for you and also print an error message.

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

what is this clock used for? Is it necessary for the register access or
is it necessary for the chipselects on the WEIM to work?

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
