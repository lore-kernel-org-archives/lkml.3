Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933256AbaJVLxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 07:53:50 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50647 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932723AbaJVLxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 07:53:48 -0400
Message-ID: <54479AB8.2010106@ti.com>
Date: Wed, 22 Oct 2014 17:23:28 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Vivek Gautam <gautam.vivek@samsung.com>, <linux-usb@vger.kernel.org>
CC: <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <balbi@ti.com>, <kgene.kim@samsung.com>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <robh+dt@kernel.org>
Subject: Re: [PATCH v2 2/4] phy: exynos5-usbdrd: Add pipe-clk and utmi-clk
 support
References: <1412677176-3850-1-git-send-email-gautam.vivek@samsung.com> <1412677176-3850-3-git-send-email-gautam.vivek@samsung.com>
In-Reply-To: <1412677176-3850-3-git-send-email-gautam.vivek@samsung.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 07 October 2014 03:49 PM, Vivek Gautam wrote:
> Exynos7 SoC has now separate gate control for 125MHz pipe3 phy
> clock, as well as 60MHz utmi phy clock.
> So get the same and control in the phy-exynos5-usbdrd driver.
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>  .../devicetree/bindings/phy/samsung-phy.txt        |    4 ++++
>  drivers/phy/phy-exynos5-usbdrd.c                   |   22 ++++++++++++++++++++
>  2 files changed, 26 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt b/Documentation/devicetree/bindings/phy/samsung-phy.txt
> index 15e0f2c..c2bc9dc 100644
> --- a/Documentation/devicetree/bindings/phy/samsung-phy.txt
> +++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
> @@ -138,6 +138,10 @@ Required properties:
>  	       PHY operations, associated by phy name. It is used to
>  	       determine bit values for clock settings register.
>  	       For Exynos5420 this is given as 'sclk_usbphy30' in CMU.
> +	- optional clocks: Exynos7 SoC has now following additional
> +			   gate clocks available:
> +			   - phy_pipe: for PIPE3 phy
> +			   - phy_utmi: for UTMI+ phy
>  - samsung,pmu-syscon: phandle for PMU system controller interface, used to
>  		      control pmu registers for power isolation.
>  - #phy-cells : from the generic PHY bindings, must be 1;
> diff --git a/drivers/phy/phy-exynos5-usbdrd.c b/drivers/phy/phy-exynos5-usbdrd.c
> index f756aca..013ee84 100644
> --- a/drivers/phy/phy-exynos5-usbdrd.c
> +++ b/drivers/phy/phy-exynos5-usbdrd.c
> @@ -148,6 +148,8 @@ struct exynos5_usbdrd_phy_drvdata {
>   * @dev: pointer to device instance of this platform device
>   * @reg_phy: usb phy controller register memory base
>   * @clk: phy clock for register access
> + * @pipeclk: clock for pipe3 phy
> + * @utmiclk: clock for utmi+ phy
>   * @drv_data: pointer to SoC level driver data structure
>   * @phys[]: array for 'EXYNOS5_DRDPHYS_NUM' number of PHY
>   *	    instances each with its 'phy' and 'phy_cfg'.
> @@ -161,6 +163,8 @@ struct exynos5_usbdrd_phy {
>  	struct device *dev;
>  	void __iomem *reg_phy;
>  	struct clk *clk;
> +	struct clk *pipeclk;
> +	struct clk *utmiclk;
>  	const struct exynos5_usbdrd_phy_drvdata *drv_data;
>  	struct phy_usb_instance {
>  		struct phy *phy;
> @@ -446,6 +450,8 @@ static int exynos5_usbdrd_phy_power_on(struct phy *phy)
>  
>  	dev_dbg(phy_drd->dev, "Request to power_on usbdrd_phy phy\n");
>  
> +	clk_prepare_enable(phy_drd->utmiclk);
> +	clk_prepare_enable(phy_drd->pipeclk);

We can have a separate function for powering on/off usb3 phy and usb2 phy
independently. That way if the USB controller is operating only on high speed
mode, the pipe clock need not be enabled at all.

I think we should create separate PHYs (phy_create) for usb2 phy and usb3 phy
here. Please refer how Lee Jones did that for miphy365x modelling each PHY as a
child node to the PHY provider and doing phy_create for each child node.

Thanks
Kishon
