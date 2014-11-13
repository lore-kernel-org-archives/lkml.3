Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539AbaKMGQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 01:16:39 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:54247 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbaKMGQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 01:16:38 -0500
Message-ID: <54644C92.8000900@ti.com>
Date: Thu, 13 Nov 2014 11:45:46 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Mark Rutland <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 4/6] phy: add support for USB cluster on the Armada
 375 SoC
References: <1415786237-21985-1-git-send-email-gregory.clement@free-electrons.com> <1415786237-21985-5-git-send-email-gregory.clement@free-electrons.com>
In-Reply-To: <1415786237-21985-5-git-send-email-gregory.clement@free-electrons.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 12 November 2014 03:27 PM, Gregory CLEMENT wrote:
> The Armada 375 SoC comes with an USB2 host and device controller and
> an USB3 controller. The USB cluster control register allows to manage
> common features of both USB controllers.
> 
> This commit adds a driver integrated in the generic PHY framework to
> control this USB cluster feature.
> 
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> ---
>  drivers/phy/Kconfig              |   6 ++
>  drivers/phy/Makefile             |   1 +
>  drivers/phy/phy-armada375-usb2.c | 145 +++++++++++++++++++++++++++++++++++++++
>  include/dt-bindings/phy/phy.h    |   1 +
>  4 files changed, 153 insertions(+)
>  create mode 100644 drivers/phy/phy-armada375-usb2.c
> 
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index 2a436e607f99..625adb0abd43 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -21,6 +21,12 @@ config PHY_BERLIN_SATA
>  	select GENERIC_PHY
>  	help
>  	  Enable this to support the SATA PHY on Marvell Berlin SoCs.
> +config ARMADA375_USBCLUSTER_PHY
> +	def_bool y
> +	depends on MACH_ARMADA_375 || COMPILE_TEST
> +	depends on OF
> +	select GENERIC_PHY
> +
>  
>  config PHY_EXYNOS_MIPI_VIDEO
>  	tristate "S5P/EXYNOS SoC series MIPI CSI-2/DSI PHY driver"
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index c4590fce082f..26b5633f378a 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -4,6 +4,7 @@
>  
>  obj-$(CONFIG_GENERIC_PHY)		+= phy-core.o
>  obj-$(CONFIG_PHY_BERLIN_SATA)		+= phy-berlin-sata.o
> +obj-$(CONFIG_ARMADA375_USBCLUSTER_PHY)	+= phy-armada375-usb2.o
>  obj-$(CONFIG_BCM_KONA_USB2_PHY)		+= phy-bcm-kona-usb2.o
>  obj-$(CONFIG_PHY_EXYNOS_DP_VIDEO)	+= phy-exynos-dp-video.o
>  obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
> diff --git a/drivers/phy/phy-armada375-usb2.c b/drivers/phy/phy-armada375-usb2.c
> new file mode 100644
> index 000000000000..d22fed4761f4
> --- /dev/null
> +++ b/drivers/phy/phy-armada375-usb2.c
> @@ -0,0 +1,145 @@
> +/*
> + * USB cluster support for Armada 375 platform.
> + *
> + * Copyright (C) 2014 Marvell
> + *
> + * Gregory CLEMENT <gregory.clement@free-electrons.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2 or later. This program is licensed "as is"
> + * without any warranty of any kind, whether express or implied.
> + *
> + * Armada 375 comes with an USB2 host and device controller and an
> + * USB3 controller. The USB cluster control register allows to manage
> + * common features of both USB controllers.
> + */
> +
> +#include <dt-bindings/phy/phy.h>
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of_address.h>
> +#include <linux/phy/phy.h>
> +#include <linux/platform_device.h>
> +
> +#define USB2_PHY_CONFIG_DISABLE BIT(0)
> +
> +struct armada375_cluster_phy {
> +	struct phy *phy;
> +	void __iomem *reg;
> +	bool use_usb3;
> +	int phy_provided;
> +};
> +
> +static struct armada375_cluster_phy usb_cluster_phy;

don't use global variables.
> +
> +static int armada375_usb_phy_init(struct phy *phy)
> +{
> +	struct armada375_cluster_phy *cluster_phy = phy_get_drvdata(phy);
> +	u32 reg;
> +
> +	reg = readl(cluster_phy->reg);
> +	if (cluster_phy->use_usb3)
> +		reg |= USB2_PHY_CONFIG_DISABLE;
> +	else
> +		reg &= ~USB2_PHY_CONFIG_DISABLE;
> +	writel(reg, cluster_phy->reg);
> +
> +	return 0;
> +}
> +
> +static struct phy_ops armada375_usb_phy_ops = {
> +	.init = armada375_usb_phy_init,
> +	.owner = THIS_MODULE,
> +};
> +
> +/*
> + * Only one controller can use this PHY. We shouldn't have the case
> + * when two controllers want to use this PHY. But if this case occurs
> + * then we provide a phy to the first one and return an error for the
> + * next one. This error has also to be an error returned by
> + * devm_phy_optional_get() so different from ENODEV for USB2. In the
> + * USB3 case it still optional and we use ENODEV.
> + */
> +static struct phy *armada375_usb_phy_xlate(struct device *dev,
> +					struct of_phandle_args *args)
> +{
> +
> +    /*
> +     * Either the phy had never been requested and then the first usb
> +     * claiming it can get it, or it had already been requested in
> +     * this case, we only allow to use it with the same configuration.
> +     */

You can dynamically create usb_cluster_phy in probe and then invoke
platform_set_drvdata by passing *usb_cluster_phy. Then you can invoke
platform_get_drvdata here to get *usb_cluster_phy.

While fixing this also add yourself as Maintainer of this file.

Thanks
Kishon
