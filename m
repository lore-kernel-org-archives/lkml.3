Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbaLVNw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 08:52:57 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:44760 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754185AbaLVNwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 08:52:55 -0500
Message-ID: <5498221C.6010701@ti.com>
Date: Mon, 22 Dec 2014 19:22:28 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>, <tony@atomide.com>,
        devicetree <devicetree@vger.kernel.org>
CC: <nm@ti.com>, <balbi@ti.com>, <george.cherian@ti.com>, <nsekhar@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] phy: ti-pipe3: Fix SATA across suspend/resume
References: <1418990720-3638-1-git-send-email-rogerq@ti.com> <1418990720-3638-3-git-send-email-rogerq@ti.com>
In-Reply-To: <1418990720-3638-3-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

On Friday 19 December 2014 05:35 PM, Roger Quadros wrote:
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
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  arch/arm/boot/dts/dra7.dtsi  |  4 ++--
>  arch/arm/boot/dts/omap5.dtsi |  4 ++--
>  drivers/phy/phy-ti-pipe3.c   | 53 +++++++++++++++++++++++++++++++-------------
>  3 files changed, 41 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
> index 63bf99b..8c35b84 100644
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
> index e60ff14..e08edd9 100644
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
> @@ -333,21 +334,20 @@ static int ti_pipe3_probe(struct platform_device *pdev)
>  		}
>  	}
>  
> +	phy->refclk = devm_clk_get(phy->dev, "refclk");
> +	if (IS_ERR(phy->refclk)) {
> +		dev_err(&pdev->dev, "unable to get refclk\n");
> +		return PTR_ERR(phy->refclk);
> +	}

This will break older dtbs. AFAIK, newer kernels should be compatible with
older dtbs too. cc'ed devicetree@vger.kernel.org for clarification.

Thanks
Kishon
