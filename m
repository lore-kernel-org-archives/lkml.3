Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbaLSKRs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 05:17:48 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54204 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbaLSKRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 05:17:36 -0500
Message-ID: <1418984246.3165.45.camel@pengutronix.de>
Subject: Re: [PATCH RFC v2 08/14] drm: imx: Add MIPI DSI host controller
 driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Liu Ying <Ying.Liu@freescale.com>
Cc: devicetree@vger.kernel.org, linux@arm.linux.org.uk, airlied@linux.ie,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        thierry.reding@gmail.com, kernel@pengutronix.de, mturquette@linaro.org,
        shawn.guo@linaro.org, linux-arm-kernel@lists.infradead.org
Date: Fri, 19 Dec 2014 11:17:26 +0100
In-Reply-To: <5493BD52.8070804@freescale.com>
References: <1418886696-11636-1-git-send-email-Ying.Liu@freescale.com>
	 <1418886696-11636-9-git-send-email-Ying.Liu@freescale.com>
	 <1418902740.4212.46.camel@pengutronix.de> <5493BD52.8070804@freescale.com>
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

Hi Liu,

Am Freitag, den 19.12.2014, 13:53 +0800 schrieb Liu Ying:
[...]
> >> +	mipi_dsi: mipi@021e0000 {
> >> +		#address-cells = <1>;
> >> +		#size-cells = <0>;
> >> +		compatible = "fsl,imx6q-mipi-dsi";
> >> +		reg = <0x021e0000 0x4000>;
> >> +		interrupts = <0 102 IRQ_TYPE_LEVEL_HIGH>;
> >> +		gpr = <&gpr>;
> >> +		clocks = <&clks IMX6QDL_CLK_VIDEO_27M>,
> >> +			 <&clks IMX6QDL_CLK_HSI_TX>,
> >> +			 <&clks IMX6QDL_CLK_HSI_TX>;
> >> +		clock-names = "pllref", "pllref_gate", "core_cfg";
> >
> > Not sure about this. Are those names from the Synopsys documentation?
> 
> No, I don't think it's from there.

Do you have access to it? I'd like to see the proper names used if
possible, considering this IP core will be used on other SoCs, too.

> > According to Table 41-1 in the i.MX6Q Reference Manual, this module has
> > 6 clock inputs:
> >   - ac_clk_125m (from ahb_clk_root)
> >   - pixel_clk (from axi_clk_root)
> >   - cfg_clk and pll_refclk (from video_27m)
> >   - ips_clk and ipg_clk_s (from ipg_clk_root)
> > The CCM chapter says that of these, "ac_clk_125m", "cfg_clk", ips_clk",
> > and "pll_refclk" are gated by a single bit called
> > "mipi_core_cfg_clk_enable", that is clk[CLK_HSI_TX].
> > If that is correct, I see no reason for the "pllref_gate" clock.
> > I suppose two clocks "pllref" and "cfg" should suffice.
> 
> Using the two clocks makes the code look like this, perhaps:
> 
>        clocks = <&clks IMX6QDL_CLK_VIDEO_27M>,
>                 <&clks IMX6QDL_CLK_HSI_TX>;
>        clock-names = "pllref", "core_cfg";
> 
> Then, it seems that I have no way to disable the pllref clock if
> using the clock tree after applying this patch set?

Correct. In my opinion we should put a new gate clock in the clock path
between video_27m and the pllref input triggers the same bit as hsi_tx,
see below.

> Or, perhaps, this one?
> 
>        clocks = <&clks IMX6QDL_CLK_HSI_TX>,
>                 <&clks IMX6QDL_CLK_HSI_TX>;
>        clock-names = "pllref", "core_cfg";
> 
> This only uses the gate clock hsi_tx.  The current clock tree states
> that it comes from:
> 
>       pll3_120m ->
>                   | -> hsi_tx_sel -> hsi_tx_podf -> hsi_tx
> pll2_pfd2_396m ->
> 
> So, I can not get the correct pllref clock frequency with this tree.
> The pllref clock should be derived from the video_27m clock.

According to the i.MX6 reference manual, the cfg clock also is derived
from video_27m, so both have the wrong rate if connected to hsi_tx (yes,
for cfg we don't care about the rate).

Currently we have this:

pll2_pfd2_396m -> hsi_tx_sel -> hsi_tx_podf -> hsi_tx
pll3_pfd1_540m -> video_27m -> hdmi_isfr

- hsi_tx_podf represents the hsi_tx_clk_root at its output.
- hsi_tx represents the gate between hsi_tx_clk_root and the tx_ref_clk
  input to the MIPI_HSI module, which is controlled by the
  mipi_core_cfg_clk_enable bit.
- video_27m represents the video_27m_clk_root at its output.

I'd say we should turn hsi_tx into a shared gate clock and add a new
shared gate clock using the same gate bit. Maybe name it mipi_core_cfg,
after the gating bit in the CCM.

pll2_pfd2_396m -> hsi_tx_sel -> hsi_tx_podf -> hsi_tx
pll3_pfd1_540m -> video_27m -> mipi_core_cfg
pll3_pfd1_540m -> video_27m -> hdmi_isfr

- mipi_core_cfg represents the gate between video_27_clk_root and the
  cfg_clk and pllref_clk inputs to the MIPI_DSI module, which is also
  controlled by the mipi_core_cfg_clk_enable bit.

> The way I decided to use the three clocks is:
> 1) PLL related
> * pllref clock only cares about the pll reference rate(the frequency).
>    And, the frequency does matter as it has an impact on the lane clock
>    frequency.
> * pllref_gate is a gate clock and it only cares about the gate.
>
> 2) register configuration related
> * core_cfg is a gate clock and it only cares about the gate.
> Usually, the register configuration clock frequency is not so important
> and the gate is what we really need.
> 
> I am currently not strong on the way I used.  I am open to any better
> solution.

Since cfg is a real clock input to the MIPI DSI IP, that's ok. But the
two pllref entries in reality are one and the same clock input.

> > Maybe HSI_TX should be split up into multiple shared gate clocks that
> > all set the mipi_core_cfg clock bits (see below).
> 
> Yes, maybe.
> If that's the case, do we need to add two gate clocks in the DT node to
> represent cfg_gate and pllref_gate respectively?

I'd say yes. While on i.MX6 it could be represented by a single clock
because both have the same rate and use the same gate bit, that doesn't
have to be the case on other SoCs. With my suggestion above, that would
be:

	clocks = <&clks IMX6QDL_CLK_MIPI_CORE_CFG>,
		 <&clks IMX6QDL_CLK_MIPI_CORE_CFG>;
	clock-names = "pllref", "cfg";

> >> diff --git a/drivers/gpu/drm/imx/Kconfig b/drivers/gpu/drm/imx/Kconfig
[...]
> >> +static int imx_mipi_dsi_bind(struct device *dev, struct device *master, void *data)
> >> +{
[...]
> >> +	dsi->pllref_clk = devm_clk_get(dev, "pllref");
> >> +	if (IS_ERR(dsi->pllref_clk)) {
> >> +		ret = PTR_ERR(dsi->pllref_clk);
> >> +		dev_err(dev, "Unable to get pll reference clock: %d\n", ret);
> >> +		return ret;
> >> +	}
> >> +	clk_prepare_enable(dsi->pllref_clk);

What I mean below is this: Here you enable pllref ...

[...]
> >> +	dsi->cfg_clk = devm_clk_get(dev, "core_cfg");
> >> +	if (IS_ERR(dsi->cfg_clk)) {
> >> +		ret = PTR_ERR(dsi->cfg_clk);
> >> +		dev_err(dev, "Unable to get configuration clock: %d\n", ret);
> >
> > And leave pllref enabled?
> 
> As I mentioned in the v1-> v2 change log, I enable/disable the 
> pllref_clk and pllref_gate_clk at the component binding/unbinding stages 
> to help remove the flag 'enabled' introduced in v1.
> 
> I referred to the i.MX HDMI driver which enables/disables the isfr clock 
> and the iahb clock at the component binding/unbinding stages.
> 
> I may try to handle the clock enablement/disablement more decently and
> avoid using the flag 'enable'.
> 
> >
> >> +		return ret;

... and here you return with an error without disabling pllref again. If
the bind fails, unbind won't be called, and the clock stays enabled. For
reference, see how imx-hdmi unprepare_disables its iahb/isfr clocks in
the bind function's error path.

> >> +	}
> >> +
> >> +	clk_prepare_enable(dsi->cfg_clk);
> >> +	val = dsi_read(dsi, DSI_VERSION);
> >> +	clk_disable_unprepare(dsi->cfg_clk);
> >> +
> >> +	dev_info(dev, "version number is 0x%08x\n", val);
> >> +
> >> +	ret = imx_mipi_dsi_register(drm, dsi);
> >> +	if (ret)
> >
> > Same here.
> 
> You meant that the pllref_gate clock is left enabled above, right?

Yes.

> Regards,
> Liu Ying
> 
> >
> >> +		return ret;

This return with an error leaves the pllref enabled.

regards
Philipp

