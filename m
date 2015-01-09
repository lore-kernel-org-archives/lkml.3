Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757705AbbAIN72 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 08:59:28 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:38759 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757188AbbAIN70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 08:59:26 -0500
Message-ID: <54AFDEB9.3060402@ti.com>
Date: Fri, 9 Jan 2015 19:29:21 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>, <tony@atomide.com>
CC: <nm@ti.com>, <balbi@ti.com>, <george.cherian@ti.com>, <nsekhar@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] phy: ti-pipe3: Fix SATA across suspend/resume
References: <1418990720-3638-1-git-send-email-rogerq@ti.com> <1418990720-3638-3-git-send-email-rogerq@ti.com> <54AE6758.7030501@ti.com>
In-Reply-To: <54AE6758.7030501@ti.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

On Thursday 08 January 2015 04:47 PM, Roger Quadros wrote:
> Failed test case: Boot without SATA drive connected. Suspend/resume
> the board and then connect SATA drive. It fails to enumerate.
> 
> Due to Errata i783 "SATA Lockup After SATA DPLL Unlock/Relock"
> we can't allow SATA DPLL to be in the unlocked state.
> The SATA refclk (sata_ref_clk) is the source of the SATA_DPLL.
> Till now this clock was controlled by the AHCI SATA driver and was being
> shut off  during system suspend (if the SATA drive was not already attached)
> causing the SATA DPLL to be unlocked and so causing errata i783.
> 
> To prevent sata_ref_clk from being disabled, we move the control of
> this clock from the SATA AHCI driver to the SATA PHY driver and prevent
> it from being disabled.
> 
> This also fixes the issue of SATA not working on OMAP5/DRA7 when
> AHCI platform driver is built as a module.

I feel the dt patches and the PHY patches can go separately. Can you split and
re-send?

Thanks
Kishon

> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
> v2: don't bail out for missing refclk on SATA phy to work with older broken DTBs.
> 
>  arch/arm/boot/dts/dra7.dtsi  |  4 ++--
>  arch/arm/boot/dts/omap5.dtsi |  4 ++--
>  drivers/phy/phy-ti-pipe3.c   | 57 +++++++++++++++++++++++++++++++-------------
>  3 files changed, 45 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
> index 22771bc..8d2a635 100644
> --- a/arch/arm/boot/dts/dra7.dtsi
> +++ b/arch/arm/boot/dts/dra7.dtsi
> @@ -1090,8 +1090,8 @@
>  				      <0x4A096800 0x40>; /* pll_ctrl */
>  				reg-names = "phy_rx", "phy_tx", "pll_ctrl";
>  				ctrl-module = <&omap_control_sata>;
> -				clocks = <&sys_clkin1>;
> -				clock-names = "sysclk";
> +				clocks = <&sys_clkin1>, <&sata_ref_clk>;
> +				clock-names = "sysclk", "refclk";
>  				#phy-cells = <0>;
>  			};
>  
> diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
> index b321fdf..bb498e7 100644
> --- a/arch/arm/boot/dts/omap5.dtsi
> +++ b/arch/arm/boot/dts/omap5.dtsi
> @@ -929,8 +929,8 @@
>  				      <0x4A096800 0x40>; /* pll_ctrl */
>  				reg-names = "phy_rx", "phy_tx", "pll_ctrl";
>  				ctrl-module = <&omap_control_sata>;
> -				clocks = <&sys_clkin>;
> -				clock-names = "sysclk";
> +				clocks = <&sys_clkin>, <&sata_ref_clk>;
> +				clock-names = "sysclk", "refclk";
>  				#phy-cells = <0>;
>  			};
>  		};
> diff --git a/drivers/phy/phy-ti-pipe3.c b/drivers/phy/phy-ti-pipe3.c
> index e60ff14..456dec2 100644
> --- a/drivers/phy/phy-ti-pipe3.c
> +++ b/drivers/phy/phy-ti-pipe3.c
> @@ -85,6 +85,7 @@ struct ti_pipe3 {
>  	struct pipe3_dpll_map	*dpll_map;
>  	u8			id;
>  	bool enabled;
> +	bool refclk_enabled;	/* this flag is needed specifically for SATA */
>  	spinlock_t lock;	/* serialize clock enable/disable */
>  };
>  
> @@ -333,21 +334,24 @@ static int ti_pipe3_probe(struct platform_device *pdev)
>  		}
>  	}
>  
> +	phy->refclk = devm_clk_get(phy->dev, "refclk");
> +	if (IS_ERR(phy->refclk)) {
> +		dev_err(&pdev->dev, "unable to get refclk\n");
> +		/* older DTBs have missing refclk in SATA PHY
> +		 * so don't bail out in case of SATA PHY.
> +		 */
> +		if (!of_device_is_compatible(node, "ti,phy-pipe3-sata"))
> +			return PTR_ERR(phy->refclk);
> +	}
> +
>  	if (!of_device_is_compatible(node, "ti,phy-pipe3-sata")) {
>  		phy->wkupclk = devm_clk_get(phy->dev, "wkupclk");
>  		if (IS_ERR(phy->wkupclk)) {
>  			dev_err(&pdev->dev, "unable to get wkupclk\n");
>  			return PTR_ERR(phy->wkupclk);
>  		}
> -
> -		phy->refclk = devm_clk_get(phy->dev, "refclk");
> -		if (IS_ERR(phy->refclk)) {
> -			dev_err(&pdev->dev, "unable to get refclk\n");
> -			return PTR_ERR(phy->refclk);
> -		}
>  	} else {
>  		phy->wkupclk = ERR_PTR(-ENODEV);
> -		phy->refclk = ERR_PTR(-ENODEV);
>  	}
>  
>  	if (of_device_is_compatible(node, "ti,phy-pipe3-pcie")) {
> @@ -428,6 +432,29 @@ static int ti_pipe3_remove(struct platform_device *pdev)
>  }
>  
>  #ifdef CONFIG_PM
> +static int ti_pipe3_enable_refclk(struct ti_pipe3 *phy)
> +{
> +	if (!IS_ERR(phy->refclk) && !phy->refclk_enabled) {
> +		int ret;
> +
> +		ret = clk_prepare_enable(phy->refclk);
> +		if (ret) {
> +			dev_err(phy->dev, "Failed to enable refclk %d\n", ret);
> +			return ret;
> +		}
> +		phy->refclk_enabled = true;
> +	}
> +
> +	return 0;
> +}
> +
> +static void ti_pipe3_disable_refclk(struct ti_pipe3 *phy)
> +{
> +	if (!IS_ERR(phy->refclk))
> +		clk_disable_unprepare(phy->refclk);
> +
> +	phy->refclk_enabled = false;
> +}
>  
>  static int ti_pipe3_enable_clocks(struct ti_pipe3 *phy)
>  {
> @@ -438,13 +465,9 @@ static int ti_pipe3_enable_clocks(struct ti_pipe3 *phy)
>  	if (phy->enabled)
>  		goto err1;
>  
> -	if (!IS_ERR(phy->refclk)) {
> -		ret = clk_prepare_enable(phy->refclk);
> -		if (ret) {
> -			dev_err(phy->dev, "Failed to enable refclk %d\n", ret);
> -			goto err1;
> -		}
> -	}
> +	ret = ti_pipe3_enable_refclk(phy);
> +	if (ret)
> +		goto err1;
>  
>  	if (!IS_ERR(phy->wkupclk)) {
>  		ret = clk_prepare_enable(phy->wkupclk);
> @@ -474,6 +497,7 @@ err2:
>  	if (!IS_ERR(phy->refclk))
>  		clk_disable_unprepare(phy->refclk);
>  
> +	ti_pipe3_disable_refclk(phy);
>  err1:
>  	spin_unlock_irqrestore(&phy->lock, flags);
>  	return ret;
> @@ -491,8 +515,9 @@ static void ti_pipe3_disable_clocks(struct ti_pipe3 *phy)
>  
>  	if (!IS_ERR(phy->wkupclk))
>  		clk_disable_unprepare(phy->wkupclk);
> -	if (!IS_ERR(phy->refclk))
> -		clk_disable_unprepare(phy->refclk);
> +	/* Don't disable refclk for SATA PHY due to Errata i783 */
> +	if (!of_device_is_compatible(phy->dev->of_node, "ti,phy-pipe3-sata"))
> +		ti_pipe3_disable_refclk(phy);
>  	if (!IS_ERR(phy->div_clk))
>  		clk_disable_unprepare(phy->div_clk);
>  	phy->enabled = false;
> 
