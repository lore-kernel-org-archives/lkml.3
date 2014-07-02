Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbaGBLRb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 07:17:31 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45765 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbaGBLR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 07:17:28 -0400
Message-ID: <53B3EA15.4090400@ti.com>
Date: Wed, 2 Jul 2014 16:46:37 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>,
        <sebastian.hesselbarth@gmail.com>, <tj@kernel.org>
CC: <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-ide@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 1/7] phy: add a driver for the Berlin SATA PHY
References: <1404133772-11741-1-git-send-email-antoine.tenart@free-electrons.com> <1404133772-11741-2-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1404133772-11741-2-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 30 June 2014 06:39 PM, Antoine Ténart wrote:
> The Berlin SoC has a two SATA ports. Add a PHY driver to handle them.
> 
> The mode selection can let us think this PHY can be configured to fit
> other purposes. But there are reasons to think the SATA mode will be
> the only one usable: the PHY registers are only accessible indirectly
> through two registers in the SATA range, the PHY seems to be integrated
> and no information tells us the contrary. For these reasons, make the
> driver a SATA PHY driver.
> 
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> ---
>  drivers/phy/Kconfig           |   7 ++
>  drivers/phy/Makefile          |   1 +
>  drivers/phy/phy-berlin-sata.c | 262 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 270 insertions(+)
>  create mode 100644 drivers/phy/phy-berlin-sata.c
> 
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index 16a2f067c242..365ad3651e1c 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -15,6 +15,13 @@ config GENERIC_PHY
>  	  phy users can obtain reference to the PHY. All the users of this
>  	  framework should select this config.
>  
> +config PHY_BERLIN_SATA
> +	tristate "Marvell Berlin SATA PHY driver"
> +	depends on ARCH_BERLIN && OF

depends on HAS_IOMEM?
> +	select GENERIC_PHY
> +	help
> +	  Enable this to support the SATA PHY on Marvell Berlin SoCs.
> +
>  config PHY_EXYNOS_MIPI_VIDEO
>  	tristate "S5P/EXYNOS SoC series MIPI CSI-2/DSI PHY driver"
>  	depends on HAS_IOMEM
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index b4f1d5770601..a137a2e23218 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -3,6 +3,7 @@
>  #
>  
>  obj-$(CONFIG_GENERIC_PHY)		+= phy-core.o
> +obj-$(CONFIG_PHY_BERLIN_SATA)		+= phy-berlin-sata.o
>  obj-$(CONFIG_BCM_KONA_USB2_PHY)		+= phy-bcm-kona-usb2.o
>  obj-$(CONFIG_PHY_EXYNOS_DP_VIDEO)	+= phy-exynos-dp-video.o
>  obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
> diff --git a/drivers/phy/phy-berlin-sata.c b/drivers/phy/phy-berlin-sata.c
> new file mode 100644
> index 000000000000..4446e93e6d82
> --- /dev/null
> +++ b/drivers/phy/phy-berlin-sata.c
> @@ -0,0 +1,262 @@
> +/*
> + * Marvell Berlin SATA PHY driver
> + *
> + * Copyright (C) 2014 Marvell Technology Group Ltd.
> + *
> + * Antoine Ténart <antoine.tenart@free-electrons.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2. This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/module.h>
> +#include <linux/phy/phy.h>
> +#include <linux/io.h>
> +#include <linux/platform_device.h>
> +
> +#define HOST_VSA_ADDR		0x0
> +#define HOST_VSA_DATA		0x4
> +#define PORT_SCR_CTL		0x2c
> +#define PORT_VSR_ADDR		0x78
> +#define PORT_VSR_DATA		0x7c
> +
> +#define CONTROL_REGISTER	0x0
> +#define MBUS_SIZE_CONTROL	0x4
> +
> +#define POWER_DOWN_PHY0			BIT(6)
> +#define POWER_DOWN_PHY1			BIT(14)
> +#define MBUS_WRITE_REQUEST_SIZE_128	(BIT(2) << 16)
> +#define MBUS_READ_REQUEST_SIZE_128	(BIT(2) << 19)
> +
> +#define PHY_BASE		0x200
> +
> +/* register 0x01 */
> +#define REF_FREF_SEL_25		BIT(0)
> +#define PHY_MODE_SATA		(0x0 << 5)
> +
> +/* register 0x02 */
> +#define USE_MAX_PLL_RATE	BIT(12)
> +
> +/* register 0x23 */
> +#define DATA_BIT_WIDTH_10	(0x0 << 10)
> +#define DATA_BIT_WIDTH_20	(0x1 << 10)
> +#define DATA_BIT_WIDTH_40	(0x2 << 10)
> +
> +/* register 0x25 */
> +#define PHY_GEN_MAX_1_5		(0x0 << 10)
> +#define PHY_GEN_MAX_3_0		(0x1 << 10)
> +#define PHY_GEN_MAX_6_0		(0x2 << 10)
> +
> +#define BERLIN_SATA_PHY_NB	2
> +
> +#define to_berlin_sata_phy_priv(desc)	\
> +	container_of((desc), struct phy_berlin_priv, phys[(desc)->index])

You can get rid of this and use dev_get_drvdata(phy->dev->parent);
> +
> +struct phy_berlin_desc {
> +	struct phy	*phy;
> +	u32		power_bit;
> +	unsigned	index;
> +};
> +
> +struct phy_berlin_priv {
> +	void __iomem		*base;
> +	spinlock_t		lock;
> +	struct clk		*clk;
> +	struct phy_berlin_desc	phys[BERLIN_SATA_PHY_NB];

Avoid using fixed array sizes for ports or channels. Refer [1].

[1] -> http://www.spinics.net/lists/linux-sh/msg33350.html

Thanks
Kishon
