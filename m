Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933348AbaFQPmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 11:42:43 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37402 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932989AbaFQPml convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 11:42:41 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Subject: Re: [PATCH v2 2/3] ata: Add Qualcomm ARM SoC AHCI SATA host controller driver
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <14174621.WL9ndpHQ2Q@amdc1032>
Date: Tue, 17 Jun 2014 10:42:36 -0500
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <419989CC-5106-4AF7-8911-617B51FD7395@codeaurora.org>
References: <1402676163-31574-1-git-send-email-galak@codeaurora.org> <14174621.WL9ndpHQ2Q@amdc1032>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
X-Mailer: Apple Mail (2.1878.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 17, 2014, at 7:25 AM, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com> wrote:

> 
> Hi,
> 
> On Friday, June 13, 2014 11:16:03 AM Kumar Gala wrote:
>> Add support for the Qualcomm AHCI SATA controller that exists on several
>> SoC and specifically the IPQ806x family of chips.  The IPQ806x SATA support
>> requires the associated IPQ806x SATA PHY Driver to be enabled as well.
>> 
>> Signed-off-by: Kumar Gala <galak@codeaurora.org>
>> ---
>> v2:
>> * Fixed MODULE_LICENSE to be GPL v2
>> 
>> drivers/ata/Kconfig     | 10 ++++++
>> drivers/ata/Makefile    |  1 +
>> drivers/ata/ahci_qcom.c | 86 +++++++++++++++++++++++++++++++++++++++++++++++++
>> 3 files changed, 97 insertions(+)
>> create mode 100644 drivers/ata/ahci_qcom.c
>> 
>> diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
>> index 7671dba..aa88648 100644
>> --- a/drivers/ata/Kconfig
>> +++ b/drivers/ata/Kconfig
>> @@ -132,6 +132,16 @@ config AHCI_MVEBU
>> 
>> 	  If unsure, say N.
>> 
>> +config AHCI_QCOM
>> +	tristate "Qualcomm AHCI SATA support"
>> +	depends on ARCH_QCOM
>> +	help
>> +	  This option enables support for AHCI SATA controller
>> +	  integrated into Qualcomm ARM SoC chipsets. For more
>> +	  information please refer to http://www.qualcomm.com/chipsets.
>> +
>> +	  If unsure, say N.
>> +
>> config AHCI_SUNXI
>> 	tristate "Allwinner sunxi AHCI SATA support"
>> 	depends on ARCH_SUNXI
>> diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
>> index 5a02aee..15401e9 100644
>> --- a/drivers/ata/Makefile
>> +++ b/drivers/ata/Makefile
>> @@ -13,6 +13,7 @@ obj-$(CONFIG_SATA_HIGHBANK)	+= sata_highbank.o libahci.o
>> obj-$(CONFIG_AHCI_DA850)	+= ahci_da850.o libahci.o libahci_platform.o
>> obj-$(CONFIG_AHCI_IMX)		+= ahci_imx.o libahci.o libahci_platform.o
>> obj-$(CONFIG_AHCI_MVEBU)	+= ahci_mvebu.o libahci.o libahci_platform.o
>> +obj-$(CONFIG_AHCI_QCOM)		+= ahci_qcom.o libahci.o libahci_platform.o
>> obj-$(CONFIG_AHCI_SUNXI)	+= ahci_sunxi.o libahci.o libahci_platform.o
>> obj-$(CONFIG_AHCI_ST)		+= ahci_st.o libahci.o libahci_platform.o
>> obj-$(CONFIG_AHCI_XGENE)	+= ahci_xgene.o libahci.o libahci_platform.o
>> diff --git a/drivers/ata/ahci_qcom.c b/drivers/ata/ahci_qcom.c
>> new file mode 100644
>> index 0000000..bfb7a77
>> --- /dev/null
>> +++ b/drivers/ata/ahci_qcom.c
>> @@ -0,0 +1,86 @@
>> +/*
>> + * Qualcomm ARM SoC AHCI SATA platform driver
>> + *
>> + * based on the AHCI SATA platform driver by Jeff Garzik and Anton Vorontsov
>> + *
>> + * Copyright (c) 2014, The Linux Foundation. All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 and
>> + * only version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/pm.h>
>> +#include <linux/device.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/libata.h>
>> +#include <linux/ahci_platform.h>
>> +#include "ahci.h"
>> +
>> +static const struct ata_port_info qcom_ahci_port_info = {
>> +	.flags		= AHCI_FLAG_COMMON,
>> +	.pio_mask	= ATA_PIO4,
>> +	.udma_mask	= ATA_UDMA6,
>> +	.port_ops	= &ahci_platform_ops,
>> +};
>> +
>> +static int qcom_ahci_probe(struct platform_device *pdev)
>> +{
>> +	struct ahci_host_priv *hpriv;
>> +	struct clk *rxoob_clk;
>> +	int rc;
>> +
>> +	hpriv = ahci_platform_get_resources(pdev);
>> +	if (IS_ERR(hpriv))
>> +		return PTR_ERR(hpriv);
>> +
>> +	/* Try and set the rxoob clk to 100Mhz */
>> +	rxoob_clk = of_clk_get_by_name(pdev->dev.of_node, "rxoob");
>> +	if (IS_ERR(rxoob_clk))
>> +		return PTR_ERR(rxoob_clk);
>> +
>> +	rc = clk_set_rate(rxoob_clk, 100000000);
> 
> Shouldn't the clk_prepare_enable() be called first?

I don’t believe there is any requirement for clk_prepare_enable to be called first.

> 
>> +	if (rc)
>> +		return rc;
> 
> of_clk_get_by_name() gets an extra reference on the clock so clk_put()
> should be called on failure.

will fix.

> 
>> +	rc = ahci_platform_enable_resources(hpriv);
>> +	if (rc)
>> +		return rc;
>> +
>> +	rc = ahci_platform_init_host(pdev, hpriv, &qcom_ahci_port_info, 0, 0);
>> +	if (rc)
>> +		goto disable_resources;
>> +
>> +	return 0;
>> +disable_resources:
>> +	ahci_platform_disable_resources(hpriv);
>> +	return rc;
>> +}
>> +
>> +static const struct of_device_id qcom_ahci_of_match[] = {
>> +	{ .compatible = "qcom,msm-ahci", },
>> +	{},
>> +};
>> +MODULE_DEVICE_TABLE(of, qcom_ahci_of_match);
>> +
>> +static struct platform_driver qcom_ahci_driver = {
>> +	.probe = qcom_ahci_probe,
>> +	.remove = ata_platform_remove_one,
>> +	.driver = {
>> +		.name = "qcom_ahci_qcom",
>> +		.owner = THIS_MODULE,
>> +		.of_match_table = qcom_ahci_of_match,
>> +	},
> 
> This driver lacks PM suspend/resume support.  I assume that
> the IPQ806x platform also doesn't support suspend/resume yet
> (if so a comment in the driver code about this would be useful),
> otherwise the driver should be fixed.

Correct, do you want the comment in the commit message or the driver itself?

> 
>> +};
>> +module_platform_driver(qcom_ahci_driver);
>> +
>> +MODULE_DESCRIPTION("Qualcomm AHCI SATA platform driver");
>> +MODULE_LICENSE("GPL v2");
>> +MODULE_ALIAS("ahci:qcom");
> 
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

