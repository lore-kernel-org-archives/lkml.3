Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbaIIH7L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 03:59:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755826AbaIIH7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 03:59:09 -0400
Message-ID: <540EB32A.90701@redhat.com>
Date: Tue, 09 Sep 2014 09:58:34 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>, Tejun Heo <tj@kernel.org>
CC: linux-ide@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        b.zolnierkie@samsung.com
Subject: Re: [PATCH v4 2/3] ata: Add Qualcomm ARM SoC AHCI SATA host controller
 driver
References: <1410194390-29007-1-git-send-email-galak@codeaurora.org> <1410194390-29007-2-git-send-email-galak@codeaurora.org>
In-Reply-To: <1410194390-29007-2-git-send-email-galak@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/08/2014 06:39 PM, Kumar Gala wrote:
> Add support for the Qualcomm AHCI SATA controller that exists on several
> SoC and specifically the IPQ806x family of chips.  The IPQ806x SATA support
> requires the associated IPQ806x SATA PHY Driver to be enabled as well.

If I'm reading this driver correctly, all it does which ahci_platform.c does
not do is set the speed for 2 clocks, or am I missing something ?

If I'm correct, then why not simply use the following in the devicetree node ? :

	sata@29000000 {
		compatible = "qcom,ipq806x-ahci", "qcom,msm-ahci", "generic-ahci";
		reg = <0x29000000 0x180>;

		interrupts = <0 209 0x0>;

		clocks = <&gcc SFAB_SATA_S_H_CLK>,
			 <&gcc SATA_H_CLK>,
			 <&gcc SATA_A_CLK>,
			 <&gcc SATA_RXOOB_CLK>,
			 <&gcc SATA_PMALIVE_CLK>;
		clock-names = "slave_iface", "iface", "core",
				"rxoob", "pmalive";

		assigned-clocks = <&gcc SATA_RXOOB_CLK>, <&gcc SATA_PMALIVE_CLK>;
		assigned-clock-rates = <100000000>, <100000000>;

		phys = <&sata_phy>;
		phy-names = "sata-phy";
	};

Notice the "generic-ahci" and assigned-clock* properties, see:

Documentation/devicetree/bindings/clock/clock-bindings.txt

With this you don't need to write your own driver at all, just a patch to
increase the max clocks + a dts node.

In case you do need your own driver for some reason see my review comments
on the driver further down.


> 
> Signed-off-by: Kumar Gala <galak@codeaurora.org>
> ---
> v4:
> * Added simple PM ops implementation
> * Added setting of pmalive clk
> 
> v3:
> * Added comment about suspend/resume not supported
> * Fixup ahci_platform_init_host for upstream change to interface
> * cleanup error handling of rxoob clk, moved to devm_clk_get/put
> 
> v2:
> * Fixed MODULE_LICENSE to be GPL v2
> 
>  drivers/ata/Kconfig     | 10 +++++
>  drivers/ata/Makefile    |  1 +
>  drivers/ata/ahci_qcom.c | 99 +++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 110 insertions(+)
>  create mode 100644 drivers/ata/ahci_qcom.c
> 
> diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
> index e1b9278..165d2fa 100644
> --- a/drivers/ata/Kconfig
> +++ b/drivers/ata/Kconfig
> @@ -133,6 +133,16 @@ config AHCI_MVEBU
>  
>  	  If unsure, say N.
>  
> +config AHCI_QCOM
> +	tristate "Qualcomm AHCI SATA support"
> +	depends on ARCH_QCOM
> +	help
> +	  This option enables support for AHCI SATA controller
> +	  integrated into Qualcomm ARM SoC chipsets. For more
> +	  information please refer to http://www.qualcomm.com/chipsets.
> +
> +	  If unsure, say N.
> +
>  config AHCI_SUNXI
>  	tristate "Allwinner sunxi AHCI SATA support"
>  	depends on ARCH_SUNXI
> diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
> index ae41107..812435c 100644
> --- a/drivers/ata/Makefile
> +++ b/drivers/ata/Makefile
> @@ -13,6 +13,7 @@ obj-$(CONFIG_SATA_HIGHBANK)	+= sata_highbank.o libahci.o
>  obj-$(CONFIG_AHCI_DA850)	+= ahci_da850.o libahci.o libahci_platform.o
>  obj-$(CONFIG_AHCI_IMX)		+= ahci_imx.o libahci.o libahci_platform.o
>  obj-$(CONFIG_AHCI_MVEBU)	+= ahci_mvebu.o libahci.o libahci_platform.o
> +obj-$(CONFIG_AHCI_QCOM)		+= ahci_qcom.o libahci.o libahci_platform.o
>  obj-$(CONFIG_AHCI_SUNXI)	+= ahci_sunxi.o libahci.o libahci_platform.o
>  obj-$(CONFIG_AHCI_ST)		+= ahci_st.o libahci.o libahci_platform.o
>  obj-$(CONFIG_AHCI_TEGRA)	+= ahci_tegra.o libahci.o libahci_platform.o
> diff --git a/drivers/ata/ahci_qcom.c b/drivers/ata/ahci_qcom.c
> new file mode 100644
> index 0000000..3da0c94
> --- /dev/null
> +++ b/drivers/ata/ahci_qcom.c
> @@ -0,0 +1,99 @@
> +/*
> + * Qualcomm ARM SoC AHCI SATA platform driver
> + *
> + * based on the AHCI SATA platform driver by Jeff Garzik and Anton Vorontsov
> + *
> + * Copyright (c) 2014, The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/ahci_platform.h>
> +#include <linux/device.h>
> +#include <linux/kernel.h>
> +#include <linux/libata.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/pm.h>
> +#include "ahci.h"
> +
> +static const struct ata_port_info qcom_ahci_port_info = {
> +	.flags		= AHCI_FLAG_COMMON,
> +	.pio_mask	= ATA_PIO4,
> +	.udma_mask	= ATA_UDMA6,
> +	.port_ops	= &ahci_platform_ops,
> +};
> +
> +static int qcom_ahci_probe(struct platform_device *pdev)
> +{
> +	struct ahci_host_priv *hpriv;
> +	struct clk *rxoob_clk, *pmalive_clk;
> +	int rc;
> +
> +	hpriv = ahci_platform_get_resources(pdev);
> +	if (IS_ERR(hpriv))
> +		return PTR_ERR(hpriv);
> +
> +	/* Try and set the rxoob clk to 100Mhz */
> +	rxoob_clk = of_clk_get_by_name(pdev->dev.of_node, "rxoob");
> +	if (IS_ERR(rxoob_clk))
> +		return PTR_ERR(rxoob_clk);

You're leaking the reference to the clk you're getting here. Please do
one of the following to fix this:

1) Use devm_clk_get; or
2) Since ahci_platform_get_resources also got a reference,
   you can put the clk after having set the rate; or
3) Since you specify a fixed clock order in your dts bindings, at defines
   for the clock indexes, and just use hpriv->clks[DEFINE] to set the rates.

Otherwise this looks good, although I would prefer to not have a separate
driver for this at all, see above.

Regards,

Hans


> +
> +	rc = clk_set_rate(rxoob_clk, 100000000);
> +	if (rc)
> +		return rc;
> +
> +	/* Try and set the pmalive clk to 100Mhz */
> +	pmalive_clk = of_clk_get_by_name(pdev->dev.of_node, "pmalive");
> +	if (IS_ERR(pmalive_clk))
> +		return PTR_ERR(pmalive_clk);
> +
> +	rc = clk_set_rate(pmalive_clk, 100000000);
> +	if (rc)
> +		return rc;
> +
> +	rc = ahci_platform_enable_resources(hpriv);
> +	if (rc)
> +		return rc;
> +
> +	rc = ahci_platform_init_host(pdev, hpriv, &qcom_ahci_port_info);
> +	if (rc)
> +		goto disable_resources;
> +
> +	return 0;
> +disable_resources:
> +	ahci_platform_disable_resources(hpriv);
> +	return rc;
> +}
> +
> +static const struct of_device_id qcom_ahci_of_match[] = {
> +	{ .compatible = "qcom,msm-ahci", },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, qcom_ahci_of_match);
> +
> +static SIMPLE_DEV_PM_OPS(qcom_ahci_pm_ops, ahci_platform_suspend,
> +			 ahci_platform_resume);
> +
> +static struct platform_driver qcom_ahci_driver = {
> +	.probe = qcom_ahci_probe,
> +	.remove = ata_platform_remove_one,
> +	.driver = {
> +		.name = "qcom_ahci_qcom",
> +		.owner = THIS_MODULE,
> +		.of_match_table = qcom_ahci_of_match,
> +		.pm = &qcom_ahci_pm_ops,
> +	},
> +};
> +module_platform_driver(qcom_ahci_driver);
> +
> +MODULE_DESCRIPTION("Qualcomm AHCI SATA platform driver");
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS("ahci:qcom");
> 
