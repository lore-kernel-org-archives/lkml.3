Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477AbaELOPd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 10:15:33 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:42198 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758355AbaELOP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 10:15:29 -0400
Date: Mon, 12 May 2014 16:12:21 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
Cc: sebastian.hesselbarth@gmail.com, tj@kernel.org,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        alexandre.belloni@free-electrons.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/6] ata: ahci: add AHCI support for the Berlin BG2Q
Message-ID: <20140512141221.GE3378@lunn.ch>
References: <1399886217-20474-1-git-send-email-antoine.tenart@free-electrons.com>
 <1399886217-20474-4-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1399886217-20474-4-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 11:16:54AM +0200, Antoine Ténart wrote:
> Add support for the Berlin BG2Q AHCI SATA controller allowing to
> interface with devices like external hard drives.
> 
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> ---
>  drivers/ata/Kconfig       |  10 +++
>  drivers/ata/Makefile      |   1 +
>  drivers/ata/ahci_berlin.c | 202 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 213 insertions(+)
>  create mode 100644 drivers/ata/ahci_berlin.c
> 
> diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
> index c2706047337f..37e6817b31f4 100644
> --- a/drivers/ata/Kconfig
> +++ b/drivers/ata/Kconfig
> @@ -97,6 +97,16 @@ config SATA_AHCI_PLATFORM
>  
>  	  If unsure, say N.
>  
> +config AHCI_BERLIN
> +	tristate "Marvell Berlin AHCI SATA support"
> +	depends on ARCH_BERLIN
> +	select PHY_BERLIN_SATA
> +	help
> +	  This option enables support for the Marvell Berlin SoC's
> +	  onboard AHCI SATA.
> +
> +	  If unsure, say N.
> +
>  config AHCI_DA850
>  	tristate "DaVinci DA850 AHCI SATA support"
>  	depends on ARCH_DAVINCI_DA850
> diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
> index 44c8016e565c..7fb78d1e0a44 100644
> --- a/drivers/ata/Makefile
> +++ b/drivers/ata/Makefile
> @@ -10,6 +10,7 @@ obj-$(CONFIG_SATA_INIC162X)	+= sata_inic162x.o
>  obj-$(CONFIG_SATA_SIL24)	+= sata_sil24.o
>  obj-$(CONFIG_SATA_DWC)		+= sata_dwc_460ex.o
>  obj-$(CONFIG_SATA_HIGHBANK)	+= sata_highbank.o libahci.o
> +obj-$(CONFIG_AHCI_BERLIN)	+= ahci_berlin.o libahci.o libahci_platform.o
>  obj-$(CONFIG_AHCI_DA850)	+= ahci_da850.o libahci.o libahci_platform.o
>  obj-$(CONFIG_AHCI_IMX)		+= ahci_imx.o libahci.o libahci_platform.o
>  obj-$(CONFIG_AHCI_SUNXI)	+= ahci_sunxi.o libahci.o libahci_platform.o
> diff --git a/drivers/ata/ahci_berlin.c b/drivers/ata/ahci_berlin.c
> new file mode 100644
> index 000000000000..973c07e54a6a
> --- /dev/null
> +++ b/drivers/ata/ahci_berlin.c
> @@ -0,0 +1,202 @@
> +/*
> + * Marvell Berlin AHCI SATA platform driver
> + *
> + * Copyright (C) 2014 Marvell Technology Group Ltd.
> + *
> + * Antoine Ténart <antoine.tenart@free-electrons.com>
> + * Jisheng Zhang <jszhang@marvell.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2. This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#include <linux/ahci_platform.h>
> +#include <linux/module.h>
> +#include <linux/of_device.h>
> +#include <linux/platform_device.h>
> +
> +#include "ahci.h"
> +
> +#define BERLIN_SATA_NPORTS	2
> +
> +#define PORT_VSR_ADDR		0x78
> +#define PORT_VSR_DATA		0x7c
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
> +struct berlin_ahci_priv {
> +	struct ahci_host_priv	*hpriv;
> +	struct phy		*phys[BERLIN_SATA_NPORTS];
> +};
> +
> +static inline void ahci_berlin_reg_setbits(void __iomem *ctrl_reg, u32 reg,
> +					   u32 mask, u32 val)
> +{
> +	u32 regval;
> +
> +	/* select register */
> +	writel(PHY_BASE + reg, ctrl_reg + PORT_VSR_ADDR);
> +
> +	/* set bits */
> +	regval = readl(ctrl_reg + PORT_VSR_DATA);
> +	regval &= ~mask;
> +	regval |= val;
> +	writel(regval, ctrl_reg + PORT_VSR_DATA);
> +}
> +
> +static void ahci_berlin_port_init(struct ahci_host_priv *hpriv,
> +				  unsigned int port)
> +{
> +	struct berlin_ahci_priv *berlin_priv = hpriv->plat_data;
> +	void __iomem *ctrl_reg = hpriv->mmio + 0x100 + (port * 0x80);
> +
> +	/* power on the PHY */
> +	phy_power_on(berlin_priv->phys[port]);
> +
> +	/* set PHY mode to SATA, ref freq to 25 MHz */
> +	ahci_berlin_reg_setbits(ctrl_reg, 0x1, 0xff, REF_FREF_SEL_25 | PHY_MODE_SATA);
> +
> +	/* set PHY up to 6 Gbps */
> +	ahci_berlin_reg_setbits(ctrl_reg, 0x25, 0xc00, PHY_GEN_MAX_6_0);
> +
> +	/* set 40 bits width */
> +	ahci_berlin_reg_setbits(ctrl_reg, 0x23,  0xc00, DATA_BIT_WIDTH_40);
> +
> +	/* use max pll rate */
> +	ahci_berlin_reg_setbits(ctrl_reg, 0x2, 0x0, USE_MAX_PLL_RATE);
> +
> +	/* set the controller speed */
> +	writel(0x31, ctrl_reg + PORT_SCR_CTL);
> +}

Hi Antoine

I've no idea is this is a good or bad idea, but could you put all the
above code in the phy driver? It does seem to be mostly phy
related. Then teach the core ahci code about optional phy nodes in DT.
You can then probably do without a ahci berlin driver.

    Andrew
