Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbaKSIvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 03:51:12 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:40676 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaKSIvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 03:51:09 -0500
Date: Wed, 19 Nov 2014 08:51:02 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, peppe.cavallaro@st.com, kishon@ti.com,
        arnd@arndb.de, netdev@vger.kernel.org, devicetree@vger.kernel.org,
        alexandre.torgue@st.com
Subject: Re: [PATCH 7/7] stmmac: dwmac-sti: Pass sysconfig register offset
 via syscon dt property.
Message-ID: <20141119085102.GH13959@x1>
References: <1416385632-5832-1-git-send-email-peter.griffin@linaro.org>
 <1416385632-5832-8-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416385632-5832-8-git-send-email-peter.griffin@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2014, Peter Griffin wrote:

> Based on Arnds review comments here https://lkml.org/lkml/2014/11/13/161,
> we should not be mixing address spaces in the reg property like this driver
> currently does. This patch updates the driver, dt docs and also the existing
> dt nodes to pass the sysconfig offset in the syscon dt property.
> 
> This patch breaks DT compatibility! But this platform is considered WIP, and is only
> used by a few developers who are upstreaming support for it. This change has been done
> as a single atomic commit to ensure it is bisectable.
> 
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> ---
>  Documentation/devicetree/bindings/net/sti-dwmac.txt | 14 +++++---------
>  arch/arm/boot/dts/stih415.dtsi                      | 12 ++++++------
>  arch/arm/boot/dts/stih416.dtsi                      | 12 ++++++------
>  drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c     | 13 +++++++------
>  4 files changed, 24 insertions(+), 27 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/sti-dwmac.txt b/Documentation/devicetree/bindings/net/sti-dwmac.txt
> index 6762a6b..d05c1e1 100644
> --- a/Documentation/devicetree/bindings/net/sti-dwmac.txt
> +++ b/Documentation/devicetree/bindings/net/sti-dwmac.txt
> @@ -9,14 +9,10 @@ The device node has following properties.
>  Required properties:
>   - compatible	: Can be "st,stih415-dwmac", "st,stih416-dwmac",
>     "st,stih407-dwmac", "st,stid127-dwmac".
> - - reg : Offset of the glue configuration register map in system
> -   configuration regmap pointed by st,syscon property and size.

Looks like you are removing the reg property description completely?

> - - st,syscon : Should be phandle to system configuration node which
> -   encompases this glue registers.
> + - st,syscon : Should be phandle/offset pair. The phandle to the syscon node which
> +   encompases the glue register, and the offset of the control register.
>   - st,gmac_en: this is to enable the gmac into a dedicated sysctl control
>     register available on STiH407 SoC.
> - - sti-ethconf: this is the gmac glue logic register to enable the GMAC,
> -   select among the different modes and program the clk retiming.
>   - pinctrl-0: pin-control for all the MII mode supported.

[...]

> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c
> @@ -123,7 +123,7 @@ struct sti_dwmac {
>  	bool ext_phyclk;	/* Clock from external PHY */
>  	u32 tx_retime_src;	/* TXCLK Retiming*/
>  	struct clk *clk;	/* PHY clock */
> -	int ctrl_reg;		/* GMAC glue-logic control register */
> +	u32 ctrl_reg;		/* GMAC glue-logic control register */
>  	int clk_sel_reg;	/* GMAC ext clk selection register */
>  	struct device *dev;
>  	struct regmap *regmap;
> @@ -286,11 +286,6 @@ static int sti_dwmac_parse_data(struct sti_dwmac *dwmac,
>  	if (!np)
>  		return -EINVAL;
>  
> -	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "sti-ethconf");
> -	if (!res)
> -		return -ENODATA;
> -	dwmac->ctrl_reg = res->start;
> -
>  	/* clk selection from extra syscfg register */
>  	dwmac->clk_sel_reg = -ENXIO;
>  	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "sti-clkconf");
> @@ -301,6 +296,12 @@ static int sti_dwmac_parse_data(struct sti_dwmac *dwmac,
>  	if (IS_ERR(regmap))
>  		return PTR_ERR(regmap);
>  
> +	err = of_property_read_u32_index(np, "st,syscon", 1, &dwmac->ctrl_reg);

A few platforms have this format for sysconn now.  We should toy with
the idea of either making this a standard call, and/or defining '1'.

> +	if (err) {
> +		dev_err(dev, "Can't get sysconfig ctrl offset (%d)\n", err);
> +		return err;
> +	}
> +
>  	dwmac->dev = dev;
>  	dwmac->interface = of_get_phy_mode(np);
>  	dwmac->regmap = regmap;

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
