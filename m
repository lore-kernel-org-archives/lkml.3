Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021AbaBSKd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 05:33:28 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:51466 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbaBSKdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 05:33:22 -0500
Message-ID: <53048822.2080307@ti.com>
Date: Wed, 19 Feb 2014 12:32:02 +0200
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: <santosh.shilimkar@ti.com>, <rob@landley.net>, <linux@arm.linux.org.uk>,
        <galak@kernel.crashing.org>, <devicetree@vger.kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <rob.herring@calxeda.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <grygorii.strashko@ti.com>,
        <dwmw2@infradead.org>, <nsekhar@ti.com>,
        "[initial author] Murali Karicheri" <m-karicheri2@ti.com>
Subject: Re: [PATCH v4 1/2] memory: ti-aemif: introduce AEMIF driver
References: <1391629574-18955-1-git-send-email-ivan.khoronzhuk@ti.com> <1391629574-18955-2-git-send-email-ivan.khoronzhuk@ti.com> <20140218203049.GA18647@kroah.com>
In-Reply-To: <20140218203049.GA18647@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2014 10:30 PM, Greg KH wrote:
> On Wed, Feb 05, 2014 at 09:46:13PM +0200, Ivan Khoronzhuk wrote:
>> Add new AEMIF driver for EMIF16 Texas Instruments controller.
>> The EMIF16 module is intended to provide a glue-less interface to
>> a variety of asynchronous memory devices like ASRA M, NOR and NAND
>> memory. A total of 256M bytes of any of these memories can be
>> accessed at any given time via 4 chip selects with 64M byte access
>> per chip select.
>>
>> Synchronous memories such as DDR1 SD RAM, SDR SDRAM and Mobile SDR
>> are not supported.
>>
>> This controller is used on SoCs like Davinci, Keysone2
>>
>> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com
>> Signed-off-by: [initial author] Murali Karicheri <m-karicheri2@ti.com>
> What's this [] stuff?
>
> If Murali wrote this, that name needs to be in a "From:" line in the
> patch to properly attribute it, and drop the [] here.

Ok, I'll delete [] stuff.

>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
>> ---
>>   drivers/memory/Kconfig    |  11 ++
>>   drivers/memory/Makefile   |   1 +
>>   drivers/memory/ti-aemif.c | 429 ++++++++++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 441 insertions(+)
>>   create mode 100644 drivers/memory/ti-aemif.c
>>
>> diff --git a/drivers/memory/Kconfig b/drivers/memory/Kconfig
>> index 29a11db..7bc3982 100644
>> --- a/drivers/memory/Kconfig
>> +++ b/drivers/memory/Kconfig
>> @@ -7,6 +7,17 @@ menuconfig MEMORY
>>   
>>   if MEMORY
>>   
>> +config TI_AEMIF
>> +	tristate "Texas Instruments AEMIF driver"
>> +	depends on (ARCH_DAVINCI || ARCH_KEYSTONE) && OF
>> +	help
>> +	  This driver is for the AEMIF module available in Texas Instruments
>> +	  SoCs. AEMIF stands for Asynchronous External Memory Interface and
>> +	  is intended to provide a glue-less interface to a variety of
>> +	  asynchronuous memory devices like ASRAM, NOR and NAND memory. A total
>> +	  of 256M bytes of any of these memories can be accessed at a given
>> +	  time via four chip selects with 64M byte access per chip select.
>> +
>>   config TI_EMIF
>>   	tristate "Texas Instruments EMIF driver"
>>   	depends on ARCH_OMAP2PLUS
>> diff --git a/drivers/memory/Makefile b/drivers/memory/Makefile
>> index 969d923..d4e150c 100644
>> --- a/drivers/memory/Makefile
>> +++ b/drivers/memory/Makefile
>> @@ -5,6 +5,7 @@
>>   ifeq ($(CONFIG_DDR),y)
>>   obj-$(CONFIG_OF)		+= of_memory.o
>>   endif
>> +obj-$(CONFIG_TI_AEMIF)		+= ti-aemif.o
>>   obj-$(CONFIG_TI_EMIF)		+= emif.o
>>   obj-$(CONFIG_MVEBU_DEVBUS)	+= mvebu-devbus.o
>>   obj-$(CONFIG_TEGRA20_MC)	+= tegra20-mc.o
>> diff --git a/drivers/memory/ti-aemif.c b/drivers/memory/ti-aemif.c
>> new file mode 100644
>> index 0000000..8d15d87
>> --- /dev/null
>> +++ b/drivers/memory/ti-aemif.c
>> @@ -0,0 +1,429 @@
>> +/*
>> + * TI AEMIF driver
>> + *
>> + * Copyright (C) 2010 - 2013 Texas Instruments Incorporated. http://www.ti.com/
>> + *
>> + * Authors:
>> + * Murali Karicheri <m-karicheri2@ti.com>
>> + * Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include <linux/clk.h>
>> +#include <linux/err.h>
>> +#include <linux/io.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/of.h>
>> +#include <linux/of_platform.h>
>> +#include <linux/platform_device.h>
>> +
>> +#define TA_SHIFT	2
>> +#define RHOLD_SHIFT	4
>> +#define RSTROBE_SHIFT	7
>> +#define RSETUP_SHIFT	13
>> +#define WHOLD_SHIFT	17
>> +#define WSTROBE_SHIFT	20
>> +#define WSETUP_SHIFT	26
>> +#define EW_SHIFT	30
>> +#define SS_SHIFT	31
>> +
>> +#define TA(x)		((x) << TA_SHIFT)
>> +#define RHOLD(x)	((x) << RHOLD_SHIFT)
>> +#define RSTROBE(x)	((x) << RSTROBE_SHIFT)
>> +#define RSETUP(x)	((x) << RSETUP_SHIFT)
>> +#define WHOLD(x)	((x) << WHOLD_SHIFT)
>> +#define WSTROBE(x)	((x) << WSTROBE_SHIFT)
>> +#define WSETUP(x)	((x) << WSETUP_SHIFT)
>> +#define EW(x)		((x) << EW_SHIFT)
>> +#define SS(x)		((x) << SS_SHIFT)
>> +
>> +#define ASIZE_MAX	0x1
>> +#define TA_MAX		0x3
>> +#define RHOLD_MAX	0x7
>> +#define RSTROBE_MAX	0x3f
>> +#define RSETUP_MAX	0xf
>> +#define WHOLD_MAX	0x7
>> +#define WSTROBE_MAX	0x3f
>> +#define WSETUP_MAX	0xf
>> +#define EW_MAX		0x1
>> +#define SS_MAX		0x1
>> +#define NUM_CS		4
>> +
>> +#define TA_VAL(x)	(((x) & TA(TA_MAX)) >> TA_SHIFT)
>> +#define RHOLD_VAL(x)	(((x) & RHOLD(RHOLD_MAX)) >> RHOLD_SHIFT)
>> +#define RSTROBE_VAL(x)	(((x) & RSTROBE(RSTROBE_MAX)) >> RSTROBE_SHIFT)
>> +#define RSETUP_VAL(x)	(((x) & RSETUP(RSETUP_MAX)) >> RSETUP_SHIFT)
>> +#define WHOLD_VAL(x)	(((x) & WHOLD(WHOLD_MAX)) >> WHOLD_SHIFT)
>> +#define WSTROBE_VAL(x)	(((x) & WSTROBE(WSTROBE_MAX)) >> WSTROBE_SHIFT)
>> +#define WSETUP_VAL(x)	(((x) & WSETUP(WSETUP_MAX)) >> WSETUP_SHIFT)
>> +#define EW_VAL(x)	(((x) & EW(EW_MAX)) >> EW_SHIFT)
>> +#define SS_VAL(x)	(((x) & SS(SS_MAX)) >> SS_SHIFT)
>> +
>> +#define NRCSR_OFFSET	0x00
>> +#define AWCCR_OFFSET	0x04
>> +#define A1CR_OFFSET	0x10
>> +
>> +#define ACR_ASIZE_MASK	0x3
>> +#define ACR_EW_MASK	BIT(30)
>> +#define ACR_SS_MASK	BIT(31)
>> +#define ASIZE_16BIT	1
>> +
>> +#define CONFIG_MASK	(TA(TA_MAX) | \
>> +				RHOLD(RHOLD_MAX) | \
>> +				RSTROBE(RSTROBE_MAX) |	\
>> +				RSETUP(RSETUP_MAX) | \
>> +				WHOLD(WHOLD_MAX) | \
>> +				WSTROBE(WSTROBE_MAX) | \
>> +				WSETUP(WSETUP_MAX) | \
>> +				EW(EW_MAX) | SS(SS_MAX) | \
>> +				ASIZE_MAX)
>> +
>> +#define DRV_NAME	"ti-aemif"
> What's wrong with KBUILD_MODNAME?

Yes, I'll drop DRV_NAME in favour of KBUILD_MODNAME

>> +static int aemif_probe(struct platform_device *pdev)
>> +{
>> +	int ret  = -ENODEV, i;
> Extra spaces?
>
> Split this into two lines?

Ok.

>> +	struct resource *res;
>> +	struct device *dev = &pdev->dev;
>> +	struct device_node *np = dev->of_node;
>> +	struct device_node *child_np;
>> +	struct aemif_device *aemif;
>> +
>> +	if (np == NULL)
>> +		return 0;
>> +
>> +	aemif = devm_kzalloc(dev, sizeof(*aemif), GFP_KERNEL);
>> +	if (!aemif) {
>> +		dev_err(dev, "cannot allocate memory for aemif\n");
> Not needed, you'll get a message from kzalloc about this.\

Ok.

>
>> +		return -ENOMEM;
>> +	}
>> +
>> +	platform_set_drvdata(pdev, aemif);
>> +
>> +	aemif->clk = devm_clk_get(dev, NULL);
>> +	if (IS_ERR(aemif->clk)) {
>> +		dev_err(dev, "cannot get clock 'aemif'\n");
>> +		return PTR_ERR(aemif->clk);
> No freeing memory?

There is no need to free memory explicitly.
devm_kzalloc is used instead of kzalloc.

>> +	}
>> +
>> +	clk_prepare_enable(aemif->clk);
>> +	aemif->clk_rate = clk_get_rate(aemif->clk) / MSEC_PER_SEC;
>> +
>> +	if (of_device_is_compatible(np, "ti,da850-aemif"))
>> +		aemif->cs_offset = 2;
>> +
>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	aemif->base = devm_ioremap_resource(dev, res);
>> +	if (IS_ERR(aemif->base)) {
>> +		ret = PTR_ERR(aemif->base);
>> +		goto error;
>> +	}
>> +
>> +	/*
>> +	 * For every controller device node, there is a cs device node that
>> +	 * describe the bus configuration parameters. This functions iterate
>> +	 * over these nodes and update the cs data array.
>> +	 */
>> +	for_each_available_child_of_node(np, child_np) {
>> +		ret = of_aemif_parse_abus_config(pdev, child_np);
>> +		if (ret < 0)
>> +			goto error;
>> +	}
>> +
>> +	for (i = 0; i < aemif->num_cs; i++) {
>> +		ret = aemif_config_abus(pdev, i);
>> +		if (ret < 0) {
>> +			dev_err(dev, "Error configuring chip select %d\n",
>> +				aemif->cs_data[i].cs);
>> +			goto error;
>> +		}
>> +	}
>> +
>> +	/*
>> +	 * Create a child devices explicitly from here to
>> +	 * guarantee that the child will be probed after the AEMIF timing
>> +	 * parameters are set.
>> +	 */
>> +	for_each_available_child_of_node(np, child_np) {
>> +		ret = of_platform_populate(child_np, NULL, NULL, dev);
>> +		if (ret < 0)
>> +			goto error;
>> +	}
>> +
>> +	return 0;
>> +error:
>> +	clk_disable_unprepare(aemif->clk);
>> +	return ret;
> No freeing memory?

devm_* allocations were used, so no need.

>
>> +}
>> +
>> +static int aemif_remove(struct platform_device *pdev)
>> +{
>> +	struct aemif_device *aemif = platform_get_drvdata(pdev);
>> +	clk_disable_unprepare(aemif->clk);
> Extra line needed.

Ok

Thanks!

-- 
Regards,
Ivan Khoronzhuk

