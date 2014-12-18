Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbaLRLjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 06:39:15 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39308 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbaLRLjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 06:39:13 -0500
Message-ID: <1418902740.4212.46.camel@pengutronix.de>
Subject: Re: [PATCH RFC v2 08/14] drm: imx: Add MIPI DSI host controller
 driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Liu Ying <Ying.Liu@freescale.com>
Cc: dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        kernel@pengutronix.de, thierry.reding@gmail.com, shawn.guo@linaro.org,
        mturquette@linaro.org, airlied@linux.ie, linux-kernel@vger.kernel.org
Date: Thu, 18 Dec 2014 12:39:00 +0100
In-Reply-To: <1418886696-11636-9-git-send-email-Ying.Liu@freescale.com>
References: <1418886696-11636-1-git-send-email-Ying.Liu@freescale.com>
	 <1418886696-11636-9-git-send-email-Ying.Liu@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 18.12.2014, 15:11 +0800 schrieb Liu Ying:
> This patch adds i.MX MIPI DSI host controller driver support.
> Currently, the driver supports the burst with sync pulses mode only.
> 
> Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
> ---
> v1->v2:
>  * Address almost all comments from Thierry Reding and Russell.
>  * Update the DT documentation to remove the display-timings node in the panel node.
>  * Update the DT documentation to state that the nodes which represent the possible
>    DRM CRTCs the controller may connect with should be placed in the node "ports".
>  * Remove the flag 'enabled' from the struct imx_mipi_dsi.
>  * Move the format_to_bpp() function in v1 to the common DRM MIPI DSI driver.
>  * Improve the way we wait for check status for DPHY and command packet transfer.
>  * Improve the DPMS support for the encoder.
>  * Split the functions of ->host_attach() and ->mode_valid() clearly as suggested by
>    Thierry Reding.
>  * Improve the logics in imx_mipi_dsi_dcs_long_write().
>  * Enable/disable the pllref_clk and pllref_gate_clk at the component binding/unbinding
>    stages to help remove the flag 'enabled'.
>  * Update the module license to be "GPL".
>  * Other minor changes, such as coding style issues and macro naming issues.
> 
>  .../devicetree/bindings/drm/imx/mipi_dsi.txt       |   78 ++
>  drivers/gpu/drm/imx/Kconfig                        |    6 +
>  drivers/gpu/drm/imx/Makefile                       |    1 +
>  drivers/gpu/drm/imx/imx-mipi-dsi.c                 | 1056 ++++++++++++++++++++
>  4 files changed, 1141 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/drm/imx/mipi_dsi.txt
>  create mode 100644 drivers/gpu/drm/imx/imx-mipi-dsi.c
> 
> diff --git a/Documentation/devicetree/bindings/drm/imx/mipi_dsi.txt b/Documentation/devicetree/bindings/drm/imx/mipi_dsi.txt
> new file mode 100644
> index 0000000..892ed62
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/drm/imx/mipi_dsi.txt
> @@ -0,0 +1,78 @@
> +Device-Tree bindings for MIPI DSI host controller
> +
> +MIPI DSI host controller
> +========================
> +
> +The MIPI DSI host controller is a Synopsys DesignWare IP.
> +It is a digital core that implements all protocol functions defined
> +in the MIPI DSI specification, providing an interface between the
> +system and the MIPI DPHY, and allowing communication with a MIPI DSI
> +compliant display.
> +
> +Required properties:
> + - #address-cells: Should be <1>.
> + - #size-cells: Should be <0>.
> + - compatible: Should be "fsl,imx6q-mipi-dsi" for i.MX6q/sdl SoCs.

If this is a Synopsys DesignWare IP core as the HDMI TX, I think the
compatible should reflect that. How about a second compatible
"snps,dw-mipi-dsi"?

> + - reg: Physical base address of the controller and length of memory
> +         mapped region.
> + - interrupts: The controller's interrupt number to the CPU(s).
> + - gpr: Should be <&gpr>.
> +         The phandle points to the iomuxc-gpr region containing the
> +         multiplexer control register for the controller.
> + - clocks, clock-names: Phandles to the controller pllref, pllref_gate
> +           and core_cfg clocks, as described in [1] and [2].
> +
> +Required sub-nodes:
> + - ports: This node may contain up to four port nodes with endpoint
> +   definitions as defined in [3], corresponding to the four inputs to
> +   the controller multiplexer.
> + - A node to represent a DSI peripheral as described in [4].
> +
> +[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
> +[2] Documentation/devicetree/bindings/clock/imx6q-clock.txt
> +[3] Documentation/devicetree/bindings/media/video-interfaces.txt
> +[4] Documentation/devicetree/bindings/mipi/dsi/mipi-dsi-bus.txt
> +
> +example:
> +	gpr: iomuxc-gpr@020e0000 {
> +		/* ... */
> +	};
> +
> +	mipi_dsi: mipi@021e0000 {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		compatible = "fsl,imx6q-mipi-dsi";
> +		reg = <0x021e0000 0x4000>;
> +		interrupts = <0 102 IRQ_TYPE_LEVEL_HIGH>;
> +		gpr = <&gpr>;
> +		clocks = <&clks IMX6QDL_CLK_VIDEO_27M>,
> +			 <&clks IMX6QDL_CLK_HSI_TX>,
> +			 <&clks IMX6QDL_CLK_HSI_TX>;
> +		clock-names = "pllref", "pllref_gate", "core_cfg";

Not sure about this. Are those names from the Synopsys documentation?

According to Table 41-1 in the i.MX6Q Reference Manual, this module has
6 clock inputs:
 - ac_clk_125m (from ahb_clk_root)
 - pixel_clk (from axi_clk_root)
 - cfg_clk and pll_refclk (from video_27m)
 - ips_clk and ipg_clk_s (from ipg_clk_root)
The CCM chapter says that of these, "ac_clk_125m", "cfg_clk", ips_clk",
and "pll_refclk" are gated by a single bit called
"mipi_core_cfg_clk_enable", that is clk[CLK_HSI_TX].
If that is correct, I see no reason for the "pllref_gate" clock.
I suppose two clocks "pllref" and "cfg" should suffice.

Maybe HSI_TX should be split up into multiple shared gate clocks that
all set the mipi_core_cfg clock bits (see below).

> diff --git a/drivers/gpu/drm/imx/Kconfig b/drivers/gpu/drm/imx/Kconfig
> index 82fb758..03f04fb 100644
> --- a/drivers/gpu/drm/imx/Kconfig
> +++ b/drivers/gpu/drm/imx/Kconfig
> @@ -51,3 +51,9 @@ config DRM_IMX_HDMI
>  	depends on DRM_IMX
>  	help
>  	  Choose this if you want to use HDMI on i.MX6.
> +
> +config DRM_IMX_MIPI_DSI
> +	tristate "Freescale i.MX DRM MIPI DSI"
> +	depends on DRM_IMX && MFD_SYSCON
> +	help
> +	  Choose this if you want to use MIPI DSI on i.MX6.
> diff --git a/drivers/gpu/drm/imx/Makefile b/drivers/gpu/drm/imx/Makefile
> index 582c438..4571d52 100644
> --- a/drivers/gpu/drm/imx/Makefile
> +++ b/drivers/gpu/drm/imx/Makefile
> @@ -10,3 +10,4 @@ obj-$(CONFIG_DRM_IMX_LDB) += imx-ldb.o
>  imx-ipuv3-crtc-objs  := ipuv3-crtc.o ipuv3-plane.o
>  obj-$(CONFIG_DRM_IMX_IPUV3)	+= imx-ipuv3-crtc.o
>  obj-$(CONFIG_DRM_IMX_HDMI) += imx-hdmi.o
> +obj-$(CONFIG_DRM_IMX_MIPI_DSI) += imx-mipi-dsi.o
> diff --git a/drivers/gpu/drm/imx/imx-mipi-dsi.c b/drivers/gpu/drm/imx/imx-mipi-dsi.c
> new file mode 100644
> index 0000000..1cb4328
> --- /dev/null
> +++ b/drivers/gpu/drm/imx/imx-mipi-dsi.c
[...]
> +static int imx_mipi_dsi_bind(struct device *dev, struct device *master, void *data)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct drm_device *drm = data;
> +	struct device_node *np = dev->of_node;
> +	struct imx_mipi_dsi *dsi;
> +	struct resource *res;
> +	u32 val;
> +	int ret;
> +
> +	dsi = devm_kzalloc(dev, sizeof(*dsi), GFP_KERNEL);
> +	if (!dsi)
> +		return -ENOMEM;
> +
> +	dsi->dev = dev;
> +	dsi->dsi_host.ops = &imx_mipi_dsi_host_ops;
> +	dsi->dsi_host.dev = dev;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	dsi->base = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(dsi->base))
> +		return PTR_ERR(dsi->base);
> +
> +	dsi->regmap = syscon_regmap_lookup_by_phandle(np, "gpr");
> +	if (IS_ERR(dsi->regmap))
> +		return PTR_ERR(dsi->regmap);
> +
> +	dsi->pllref_clk = devm_clk_get(dev, "pllref");
> +	if (IS_ERR(dsi->pllref_clk)) {
> +		ret = PTR_ERR(dsi->pllref_clk);
> +		dev_err(dev, "Unable to get pll reference clock: %d\n", ret);
> +		return ret;
> +	}
> +	clk_prepare_enable(dsi->pllref_clk);
> +
> +	dsi->pllref_gate_clk = devm_clk_get(dev, "pllref_gate");
> +	if (IS_ERR(dsi->pllref_gate_clk)) {
> +		ret = PTR_ERR(dsi->pllref_gate_clk);
> +		dev_err(dev, "Unable to get pll reference gate clock: %d\n", ret);
> +		return ret;
> +	}
> +	clk_prepare_enable(dsi->pllref_gate_clk);

As said above, I don't think this clock is needed, or is it?

If enabling pllref_clk doesn't actually enable the 27m clock input to
the mipi dsi core because it is still gated by hsi_tx, maybe the clock
tree should be fixed and hsi_tx turned into multiple
imx_clk_gate2_shared clocks.

> +
> +	dsi->cfg_clk = devm_clk_get(dev, "core_cfg");
> +	if (IS_ERR(dsi->cfg_clk)) {
> +		ret = PTR_ERR(dsi->cfg_clk);
> +		dev_err(dev, "Unable to get configuration clock: %d\n", ret);

And leave pllref enabled?

> +		return ret;
> +	}
> +
> +	clk_prepare_enable(dsi->cfg_clk);
> +	val = dsi_read(dsi, DSI_VERSION);
> +	clk_disable_unprepare(dsi->cfg_clk);
> +
> +	dev_info(dev, "version number is 0x%08x\n", val);
> +
> +	ret = imx_mipi_dsi_register(drm, dsi);
> +	if (ret)

Same here.

> +		return ret;
> +
> +	dev_set_drvdata(dev, dsi);
> +
> +	return mipi_dsi_host_register(&dsi->dsi_host);
> +}
[...]

regards
Philipp

