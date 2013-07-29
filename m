Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab3G2VDO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 17:03:14 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:49057 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab3G2VDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 17:03:12 -0400
Message-ID: <51F6D88B.80202@gmail.com>
Date: Mon, 29 Jul 2013 23:03:07 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Julius Werner <jwerner@chromium.org>
CC: Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, Tomasz Figa <t.figa@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH] usb: phy-samsung-usb: Simplify PMU register handling
References: <1375130839-5523-1-git-send-email-jwerner@chromium.org>
In-Reply-To: <1375130839-5523-1-git-send-email-jwerner@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 07/29/2013 10:47 PM, Julius Werner wrote:
> This patch simplifies the way the phy-samsung-usb code finds the correct
> power management register to enable PHY clock gating. Previously, the
> code would calculate the register address from a device tree supplied
> base address and add an offset based on the PHY type.
>
> Since every PHY has its own device tree entry and needs only one
> register, we can just encode the address itself in the device tree and
> remove the diffentiation in the code. The bitmask needed to specify the
> bit within that register stays in place, allowing support for platforms
> like s3c64xx that use different bits within the same register. Due to
> this simplification, the whole complication of a Samsung-specific USB
> PHY type can be removed from the PHY driver.
>
> Change-Id: Id823f04bbf1942f307bd1d24ec9d8d55a69b0e56
> Signed-off-by: Julius Werner<jwerner@chromium.org>
> ---
>   arch/arm/boot/dts/exynos5250.dtsi  |  4 ++--
>   drivers/usb/phy/phy-samsung-usb.c  | 46 +++++++++-----------------------------
>   drivers/usb/phy/phy-samsung-usb.h  | 34 +++++++---------------------
>   drivers/usb/phy/phy-samsung-usb2.c | 34 ++++++++--------------------
>   drivers/usb/phy/phy-samsung-usb3.c | 13 +++--------
>   5 files changed, 32 insertions(+), 99 deletions(-)
>
> diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
> index ef57277..5a754d7 100644
> --- a/arch/arm/boot/dts/exynos5250.dtsi
> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> @@ -473,7 +473,7 @@
>   		ranges;
>
>   		usbphy-sys {
> -			reg =<0x10040704 0x8>;
> +			reg =<0x10040704 0x4>;
>   		};
>   	};
>
> @@ -505,7 +505,7 @@
>   		ranges;
>
>   		usbphy-sys {
> -			reg =<0x10040704 0x8>,
> +			reg =<0x10040708 0x4>,
>   			<0x10050230 0x4>;
>   		};
>   	};
> diff --git a/drivers/usb/phy/phy-samsung-usb.c b/drivers/usb/phy/phy-samsung-usb.c
> index ac025ca..c142233 100644
> --- a/drivers/usb/phy/phy-samsung-usb.c
> +++ b/drivers/usb/phy/phy-samsung-usb.c
> @@ -27,7 +27,6 @@
>   #include<linux/io.h>
>   #include<linux/of.h>
>   #include<linux/of_address.h>
> -#include<linux/usb/samsung_usb_phy.h>
>
>   #include "phy-samsung-usb.h"
>
> @@ -42,9 +41,9 @@ int samsung_usbphy_parse_dt(struct samsung_usbphy *sphy)
>   		return -ENODEV;
>   	}
>
> -	sphy->pmuregs = of_iomap(usbphy_sys, 0);
> +	sphy->pmureg = of_iomap(usbphy_sys, 0);
>
> -	if (sphy->pmuregs == NULL) {
> +	if (sphy->pmureg == NULL) {
>   		dev_err(sphy->dev, "Can't get usb-phy pmu control register\n");
>   		goto err0;
>   	}
> @@ -75,35 +74,26 @@ EXPORT_SYMBOL_GPL(samsung_usbphy_parse_dt);
>    */
>   void samsung_usbphy_set_isolation_4210(struct samsung_usbphy *sphy, bool on)
>   {
> -	void __iomem *reg = NULL;
>   	u32 reg_val;
>   	u32 en_mask = 0;
>
> -	if (!sphy->pmuregs) {
> +	if (!sphy->pmureg) {
>   		dev_warn(sphy->dev, "Can't set pmu isolation\n");
>   		return;
>   	}
>
> -	if (sphy->phy_type == USB_PHY_TYPE_DEVICE) {
> -		reg = sphy->pmuregs + sphy->drv_data->devphy_reg_offset;
> -		en_mask = sphy->drv_data->devphy_en_mask;
> -	} else if (sphy->phy_type == USB_PHY_TYPE_HOST) {
> -		reg = sphy->pmuregs + sphy->drv_data->hostphy_reg_offset;
> -		en_mask = sphy->drv_data->hostphy_en_mask;
> -	}

How is en_mask supposed to get initialized, now when this code is removed ?
It's always 0 now, isn't it ?

> -
> -	reg_val = readl(reg);
> +	reg_val = readl(sphy->pmureg);
>
>   	if (on)
>   		reg_val&= ~en_mask;
>   	else
>   		reg_val |= en_mask;
>
> -	writel(reg_val, reg);
> +	writel(reg_val, sphy->pmureg);

--
Regards,
Sylwester
