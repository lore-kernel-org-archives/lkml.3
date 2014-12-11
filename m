Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960AbaLKKal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 05:30:41 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:36169 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbaLKKaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 05:30:39 -0500
Message-ID: <548971AF.1020506@ti.com>
Date: Thu, 11 Dec 2014 15:57:59 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Yunzhi Li <lyz@rock-chips.com>, <heiko@sntech.de>, <jwerner@chromium.org>,
        <dianders@chromium.org>
CC: <olof@lixom.net>, <huangtao@rock-chips.com>, <zyw@rock-chips.com>,
        <cf@rock-chips.com>, <linux-rockchip@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v6 1/5] phy: add a driver for the Rockchip SoC internal
 USB2.0 PHY
References: <1418291722-25448-1-git-send-email-lyz@rock-chips.com> <1418291722-25448-2-git-send-email-lyz@rock-chips.com>
In-Reply-To: <1418291722-25448-2-git-send-email-lyz@rock-chips.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 11 December 2014 03:25 PM, Yunzhi Li wrote:
> This patch to add a generic PHY driver for ROCKCHIP usb PHYs,
> currently this driver can support RK3288. The RK3288 SoC have
> three independent USB PHY IPs which are all configured through a
> set of registers located in the GRF (general register files)
> module.
> 
> Signed-off-by: Yunzhi Li <lyz@rock-chips.com>
> 
> ---
> 
> Changes in v6:
> - Rename SIDDQ_MSK to SIDDQ_WRITE_ENA.
> - Use phandle args to find a phy struct directly.
> 
> Changes in v5: None
> Changes in v4:
> - Get number of PHYs from device tree.
> - Model each PHY as subnode of the phy provider node.
> 
> Changes in v3:
> - Use BIT macro instead of bit shift ops.
> - Rename the config entry to PHY_ROCKCHIP_USB.
> 
>  drivers/phy/Kconfig            |   7 ++
>  drivers/phy/Makefile           |   1 +
>  drivers/phy/phy-rockchip-usb.c | 198 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 206 insertions(+)
>  create mode 100644 drivers/phy/phy-rockchip-usb.c
> 
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index ccad880..b24500a 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -239,6 +239,13 @@ config PHY_QCOM_IPQ806X_SATA
>  	depends on OF
>  	select GENERIC_PHY
>  
> +config PHY_ROCKCHIP_USB
> +	tristate "Rockchip USB2 PHY Driver"
> +	depends on ARCH_ROCKCHIP && OF
> +	select GENERIC_PHY
> +	help
> +	  Enable this to support the Rockchip USB 2.0 PHY.
> +
>  config PHY_ST_SPEAR1310_MIPHY
>  	tristate "ST SPEAR1310-MIPHY driver"
>  	select GENERIC_PHY
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index aa74f96..48bf5a1 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -28,6 +28,7 @@ phy-exynos-usb2-$(CONFIG_PHY_EXYNOS5250_USB2)	+= phy-exynos5250-usb2.o
>  phy-exynos-usb2-$(CONFIG_PHY_S5PV210_USB2)	+= phy-s5pv210-usb2.o
>  obj-$(CONFIG_PHY_EXYNOS5_USBDRD)	+= phy-exynos5-usbdrd.o
>  obj-$(CONFIG_PHY_QCOM_APQ8064_SATA)	+= phy-qcom-apq8064-sata.o
> +obj-$(CONFIG_PHY_ROCKCHIP_USB) += phy-rockchip-usb.o
>  obj-$(CONFIG_PHY_QCOM_IPQ806X_SATA)	+= phy-qcom-ipq806x-sata.o
>  obj-$(CONFIG_PHY_ST_SPEAR1310_MIPHY)	+= phy-spear1310-miphy.o
>  obj-$(CONFIG_PHY_ST_SPEAR1340_MIPHY)	+= phy-spear1340-miphy.o
> diff --git a/drivers/phy/phy-rockchip-usb.c b/drivers/phy/phy-rockchip-usb.c
> new file mode 100644
> index 0000000..dad5194
> --- /dev/null
> +++ b/drivers/phy/phy-rockchip-usb.c
> @@ -0,0 +1,198 @@
> +/*
> + * Rockchip usb PHY driver
> + *
> + * Copyright (C) 2014 Yunzhi Li <lyz@rock-chips.com>
> + * Copyright (C) 2014 ROCKCHIP, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/phy/phy.h>
> +#include <linux/platform_device.h>
> +#include <linux/regulator/consumer.h>
> +#include <linux/reset.h>
> +#include <linux/regmap.h>
> +#include <linux/mfd/syscon.h>
> +
> +#define ROCKCHIP_RK3288_UOC(n)	(0x320 + n * 0x14)
> +
> +/*
> + * The higher 16-bit of this register is used for write protection
> + * only if BIT(13 + 16) set to 1 the BIT(13) can be written.
> + */
> +#define SIDDQ_WRITE_ENA	BIT(29)
> +#define SIDDQ_ON		BIT(13)
> +#define SIDDQ_OFF		(0 << 13)
> +
> +struct rockchip_usb_phy {
> +	struct regmap	*reg_base;
> +	unsigned int	reg_offset;
> +	struct clk	*clk;
> +	struct phy	*phy;
> +};
> +
> +struct rockchip_usb_phy_priv {
> +	struct rockchip_usb_phy	*phys;
> +	unsigned		nphys;
> +};
> +
> +static int rockchip_usb_phy_power(struct rockchip_usb_phy *phy,
> +					   bool siddq)
> +{
> +	return regmap_write(phy->reg_base, phy->reg_offset,
> +			    SIDDQ_WRITE_ENA | (siddq ? SIDDQ_ON : SIDDQ_OFF));
> +}
> +
> +static int rockchip_usb_phy_power_off(struct phy *_phy)
> +{
> +	struct rockchip_usb_phy *phy = phy_get_drvdata(_phy);
> +	int ret = 0;
> +
> +	/* Power down usb phy analog blocks by set siddq 1 */
> +	ret = rockchip_usb_phy_power(phy, 1);
> +	if (ret)
> +		return ret;
> +
> +	clk_disable_unprepare(phy->clk);
> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static int rockchip_usb_phy_power_on(struct phy *_phy)
> +{
> +	struct rockchip_usb_phy *phy = phy_get_drvdata(_phy);
> +	int ret = 0;
> +
> +	ret = clk_prepare_enable(phy->clk);
> +	if (ret)
> +		return ret;
> +
> +	/* Power up usb phy analog blocks by set siddq 0 */
> +	ret = rockchip_usb_phy_power(phy, 0);
> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static struct phy *rockchip_usb_phy_xlate(struct device *dev,
> +					struct of_phandle_args *args)
> +{
> +	struct rockchip_usb_phy_priv *priv = dev_get_drvdata(dev);
> +	unsigned int phy_id = args->args[0];
> +
> +	if (WARN_ON(phy_id < 0 || phy_id >= priv->nphys))
> +		return ERR_PTR(-ENODEV);
> +
> +	return priv->phys[phy_id].phy;

I didn't mean that. You can get rid of this entire xlate stuff if you use
something like below

phy@xxx {
	compatible = "";
	phy1:usb_phy {
	}
	phy2:usb_phy {
	};
};


usb@xx {
	compatible = "";
	phys = <&phy1>; //doesn't need xlate
	/* this needs xlate
	   phys = <&phy 1>;
	*/
	phy-names = "phy";
};

Thanks
Kishon
