Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbaCTIM1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 04:12:27 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46797 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbaCTIMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 04:12:22 -0400
Message-ID: <532AA2B0.1060103@ti.com>
Date: Thu, 20 Mar 2014 13:41:28 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tejun Heo <tj@kernel.org>
CC: Kevin Hilman <khilman@deeprootsystems.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, <linux-ide@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <spear-devel@list.st.com>
Subject: Re: [PATCH 3/4] ata: add new-style AHCI platform driver for DaVinci
 DA850 AHCI controller
References: <1395081118-15248-1-git-send-email-b.zolnierkie@samsung.com> <1395081118-15248-4-git-send-email-b.zolnierkie@samsung.com>
In-Reply-To: <1395081118-15248-4-git-send-email-b.zolnierkie@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bartlomiej,

On Tuesday 18 March 2014 12:01 AM, Bartlomiej Zolnierkiewicz wrote:
> The new driver is named ahci_da850 and is only compile tested.  Once it
> is tested on the real hardware and verified to work correctly, the legacy
> platform code (which depends on the deprecated struct ahci_platform_data)
> can be removed.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Thanks for the patch. I have been able to use your patch and verify SATA
functionality on DA850 EVM. I have some comments though.

> ---
>  drivers/ata/Kconfig      |   9 +++
>  drivers/ata/Makefile     |   1 +
>  drivers/ata/ahci_da850.c | 178 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 188 insertions(+)
>  create mode 100644 drivers/ata/ahci_da850.c
> 
> diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
> index 371e8890..6379a00 100644
> --- a/drivers/ata/Kconfig
> +++ b/drivers/ata/Kconfig
> @@ -97,6 +97,15 @@ config SATA_AHCI_PLATFORM
>  
>  	  If unsure, say N.
>  
> +config AHCI_DA850
> +	tristate "DaVinci DA850 AHCI SATA support (experimental)"
> +	depends on ARCH_DAVINCI_DA850
> +	help
> +	  This option enables support for the DaVinci DA850 SoC's
> +	  onboard AHCI SATA.
> +
> +	  If unsure, say N.
> +
>  config AHCI_ST
>  	tristate "ST AHCI SATA support"
>  	depends on ARCH_STI
> diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
> index 6123e64..0646d83 100644
> --- a/drivers/ata/Makefile
> +++ b/drivers/ata/Makefile
> @@ -10,6 +10,7 @@ obj-$(CONFIG_SATA_INIC162X)	+= sata_inic162x.o
>  obj-$(CONFIG_SATA_SIL24)	+= sata_sil24.o
>  obj-$(CONFIG_SATA_DWC)		+= sata_dwc_460ex.o
>  obj-$(CONFIG_SATA_HIGHBANK)	+= sata_highbank.o libahci.o
> +obj-$(CONFIG_AHCI_DA850)	+= ahci_da850.o libahci.o libahci_platform.o
>  obj-$(CONFIG_AHCI_IMX)		+= ahci_imx.o libahci.o libahci_platform.o
>  obj-$(CONFIG_AHCI_SUNXI)	+= ahci_sunxi.o libahci.o libahci_platform.o
>  obj-$(CONFIG_AHCI_ST)		+= ahci_st.o libahci.o libahci_platform.o
> diff --git a/drivers/ata/ahci_da850.c b/drivers/ata/ahci_da850.c
> new file mode 100644
> index 0000000..da874699
> --- /dev/null
> +++ b/drivers/ata/ahci_da850.c
> @@ -0,0 +1,178 @@
> +/*
> + * DaVinci DA850 AHCI SATA platform driver
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2, or (at your option)
> + * any later version.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/pm.h>
> +#include <linux/device.h>
> +#include <linux/platform_device.h>
> +#include <linux/libata.h>
> +#include <linux/ahci_platform.h>
> +#include "ahci.h"
> +
> +extern void __iomem *da8xx_syscfg1_base;

This platform specific extern symbol should not be used in drivers and
in fact checkpatch complains about it too. Can you instead get the
addresses you need as part of the device resources?

> +#define DA8XX_SYSCFG1_VIRT(x)	(da8xx_syscfg1_base + (x))
> +#define DA8XX_PWRDN_REG		0x18
> +
> +/* SATA PHY Control Register offset from AHCI base */
> +#define SATA_P0PHYCR_REG	0x178
> +
> +#define SATA_PHY_MPY(x)		((x) << 0)
> +#define SATA_PHY_LOS(x)		((x) << 6)
> +#define SATA_PHY_RXCDR(x)	((x) << 10)
> +#define SATA_PHY_RXEQ(x)	((x) << 13)
> +#define SATA_PHY_TXSWING(x)	((x) << 19)
> +#define SATA_PHY_ENPLL(x)	((x) << 31)

These can be replaced with BIT(N)

> +
> +static struct clk *da850_sata_clk;
> +static unsigned long da850_sata_refclkpn = 100 * 1000 * 1000;

This should ideally be platform data. Since we are not going to add
anymore board files, I am not going to ask you to add one.

However, with the input value hard coded in driver, it does not make
sense to have the frequencies table and its traversal. Instead, I
suggest you hard-code the multiplier itself with a porting warning
comment. Later when the DT conversion happens and this becomes a DT
property, we can add back the logic for multiple multiplier settings.
The way it is now, the code looks superfluous.

> +
> +/* Supported DA850 SATA crystal frequencies */
> +#define KHZ_TO_HZ(freq) ((freq) * 1000)
> +static unsigned long da850_sata_xtal[] = {
> +	KHZ_TO_HZ(300000),
> +	KHZ_TO_HZ(250000),
> +	0,			/* Reserved */
> +	KHZ_TO_HZ(187500),
> +	KHZ_TO_HZ(150000),
> +	KHZ_TO_HZ(125000),
> +	KHZ_TO_HZ(120000),
> +	KHZ_TO_HZ(100000),
> +	KHZ_TO_HZ(75000),
> +	KHZ_TO_HZ(60000),
> +};
> +
> +static int da850_sata_init(struct device *dev, void __iomem *addr)
> +{
> +	int i, ret;
> +	unsigned int val;
> +
> +	da850_sata_clk = clk_get(dev, NULL);
> +	if (IS_ERR(da850_sata_clk))
> +		return PTR_ERR(da850_sata_clk);
> +
> +	ret = clk_prepare_enable(da850_sata_clk);
> +	if (ret)
> +		goto err0;

Please switch to pm_runtime instead of using the clock APIs directly.

> +
> +	/* Enable SATA clock receiver */
> +	val = __raw_readl(DA8XX_SYSCFG1_VIRT(DA8XX_PWRDN_REG));

Use readl() or readl_relaxed() for endian-neutrality.

> +	val &= ~BIT(0);
> +	__raw_writel(val, DA8XX_SYSCFG1_VIRT(DA8XX_PWRDN_REG));
> +
> +	/* Get the multiplier needed for 1.5GHz PLL output */
> +	for (i = 0; i < ARRAY_SIZE(da850_sata_xtal); i++)
> +		if (da850_sata_xtal[i] == da850_sata_refclkpn)
> +			break;
> +
> +	if (i == ARRAY_SIZE(da850_sata_xtal)) {
> +		ret = -EINVAL;
> +		goto err1;
> +	}
> +
> +	val = SATA_PHY_MPY(i + 1) |
> +		SATA_PHY_LOS(1) |
> +		SATA_PHY_RXCDR(4) |
> +		SATA_PHY_RXEQ(1) |
> +		SATA_PHY_TXSWING(3) |
> +		SATA_PHY_ENPLL(1);
> +
> +	__raw_writel(val, addr + SATA_P0PHYCR_REG);
> +
> +	return 0;
> +
> +err1:
> +	clk_disable_unprepare(da850_sata_clk);
> +err0:
> +	clk_put(da850_sata_clk);
> +	return ret;
> +}
> +
> +static void da850_sata_exit(struct device *dev)
> +{
> +	clk_disable_unprepare(da850_sata_clk);
> +	clk_put(da850_sata_clk);
> +}
> +
> +static void ahci_da850_host_stop(struct ata_host *host)
> +{
> +	struct device *dev = host->dev;
> +	struct ahci_host_priv *hpriv = host->private_data;
> +
> +	da850_sata_exit(dev);
> +
> +	ahci_platform_disable_resources(hpriv);
> +}
> +
> +static struct ata_port_operations ahci_da850_port_ops = {
> +	.inherits	= &ahci_platform_ops,
> +	.host_stop	= ahci_da850_host_stop,
> +};
> +
> +static const struct ata_port_info ahci_da850_port_info = {
> +	.flags		= AHCI_FLAG_COMMON,
> +	.pio_mask	= ATA_PIO4,
> +	.udma_mask	= ATA_UDMA6,
> +	.port_ops	= &ahci_da850_port_ops,
> +};
> +
> +static int ahci_da850_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct ahci_host_priv *hpriv;
> +	int rc;
> +
> +	hpriv = ahci_platform_get_resources(pdev);
> +	if (IS_ERR(hpriv))
> +		return PTR_ERR(hpriv);
> +
> +	rc = ahci_platform_enable_resources(hpriv);
> +	if (rc)
> +		return rc;
> +
> +	rc = da850_sata_init(dev, hpriv->mmio);
> +	if (rc)
> +		goto disable_resources;
> +
> +	rc = ahci_platform_init_host(pdev, hpriv, &ahci_da850_port_info, 0, 0);
> +	if (rc)
> +		goto sata_exit;
> +
> +	return 0;
> +sata_exit:
> +	da850_sata_exit(dev);
> +disable_resources:
> +	ahci_platform_disable_resources(hpriv);
> +	return rc;
> +}
> +
> +static SIMPLE_DEV_PM_OPS(ahci_da850_pm_ops, ahci_platform_suspend,
> +			 ahci_platform_resume);
> +
> +static struct platform_device_id ahci_da850_platform_ids[] = {
> +	{ .name = "ahci" },

I was not able to get this driver probed with this name (I guess that
was because the generic driver was picked instead?). Can you please
change it to "da850-sata"?

Thanks,
Sekhar
