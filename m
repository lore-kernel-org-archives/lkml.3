Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbaLKK1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 05:27:37 -0500
Received: from mga01.intel.com ([192.55.52.88]:25672 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbaLKK1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 05:27:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,557,1413270000"; 
   d="scan'208";a="645975198"
From: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
To: "Tan, Raymond" <raymond.tan@intel.com>
CC: "mturquette@linaro.org" <mturquette@linaro.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chen, Alvin" <alvin.chen@intel.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>
Subject: Re: [PATCH v3 1/1] mfd: intel_quark_i2c_gpio: Add Intel Quark X1000
 I2C-GPIO MFD Driver
Thread-Topic: [PATCH v3 1/1] mfd: intel_quark_i2c_gpio: Add Intel Quark
 X1000 I2C-GPIO MFD Driver
Thread-Index: AQHQFScXkoFpvfa40kexjfgJp3n0NpyKL8EA
Date: Thu, 11 Dec 2014 10:27:10 +0000
Message-ID: <1418293634.17201.59.camel@intel.com>
References: <1418290710-5871-1-git-send-email-raymond.tan@intel.com>
	 <1418290710-5871-2-git-send-email-raymond.tan@intel.com>
In-Reply-To: <1418290710-5871-2-git-send-email-raymond.tan@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.90]
Content-Type: text/plain; charset="utf-8"
Content-ID: <417C61E141ABCA4A97B26675F9F0D8E1@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBBARku8011822

On Thu, 2014-12-11 at 17:38 +0800, Raymond Tan wrote:
> In Quark X1000, there's a single PCI device that provides both
> an I2C controller and a GPIO controller. This MFD driver will
> split the 2 devices for their respective drivers.
> 
> This patch is based on Josef Ahmad's initial work for Quark enabling.

See my comments below.

> 
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Signed-off-by: Weike Chen <alvin.chen@intel.com>
> Signed-off-by: Raymond Tan <raymond.tan@intel.com>
> ---
>  drivers/mfd/Kconfig                |   12 ++
>  drivers/mfd/Makefile               |    1 +
>  drivers/mfd/intel_quark_i2c_gpio.c |  279 ++++++++++++++++++++++++++++++++++++

So, there is a proposal to bring the order into the source tree a bit
for Intel related MFD drivers.

What about to move this module to 
drivers/mfd/intel/quark/i2c_gpio.c ?

At least what I can tell now, it will come more Intel stuff and we have
few drivers already there.

I can see the following:
drivers/mfd/intel/
 -> quark/
 -> mid/ (Intel MID platforms, existing drivers)
 -> some new platform/ (whatever is the one of the new Intel SoCs)

Lee, what's your opinion?

I could change a layout for existing in-tree drivers.

>  3 files changed, 292 insertions(+)
>  create mode 100644 drivers/mfd/intel_quark_i2c_gpio.c
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index b7c74a7..2f2f62d 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -219,6 +219,18 @@ config HTC_I2CPLD
>  	  This device provides input and output GPIOs through an I2C
>  	  interface to one or more sub-chips.
>  
> +config MFD_INTEL_QUARK_I2C_GPIO

Depending on the further discussion about layout.

> +	tristate "Intel Quark MFD I2C GPIO"
> +	depends on PCI
> +	depends on X86
> +	depends on COMMON_CLK
> +	select MFD_CORE
> +	help
> +	  This MFD provides support for I2C and GPIO that exist only
> +	  in a single PCI device. It splits the 2 IO devices to
> +	  their respective IO driver.
> +	  The GPIO exports a total amount of 8 interrupt-capable GPIOs.
> +
>  config LPC_ICH
>  	tristate "Intel ICH LPC"
>  	depends on PCI
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index 8a28dc9..d42652d 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -133,6 +133,7 @@ obj-$(CONFIG_AB8500_CORE)	+= ab8500-core.o ab8500-sysctrl.o
>  obj-$(CONFIG_MFD_TIMBERDALE)    += timberdale.o
>  obj-$(CONFIG_PMIC_ADP5520)	+= adp5520.o
>  obj-$(CONFIG_MFD_KEMPLD)	+= kempld-core.o
> +obj-$(CONFIG_MFD_INTEL_QUARK_I2C_GPIO)	+= intel_quark_i2c_gpio.o
>  obj-$(CONFIG_LPC_SCH)		+= lpc_sch.o
>  obj-$(CONFIG_LPC_ICH)		+= lpc_ich.o
>  obj-$(CONFIG_MFD_RDC321X)	+= rdc321x-southbridge.o
> diff --git a/drivers/mfd/intel_quark_i2c_gpio.c b/drivers/mfd/intel_quark_i2c_gpio.c
> new file mode 100644
> index 0000000..a3a7043
> --- /dev/null
> +++ b/drivers/mfd/intel_quark_i2c_gpio.c
> @@ -0,0 +1,279 @@
> +/*
> + * Intel Quark MFD PCI driver for I2C & GPIO
> + *
> + * Copyright(c) 2014 Intel Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * Intel Quark PCI device for I2C and GPIO controller sharing the same
> + * PCI function. This PCI driver will split the 2 devices into their
> + * respective drivers.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/mfd/core.h>
> +#include <linux/clkdev.h>
> +#include <linux/clk-provider.h>
> +#include <linux/dmi.h>
> +#include <linux/platform_data/gpio-dwapb.h>
> +#include <linux/platform_data/i2c-designware.h>
> +
> +/* PCI BAR for register base address */
> +#define MFD_I2C_BAR		0
> +#define MFD_GPIO_BAR		1
> +
> +/* The base GPIO number under GPIOLIB framework */
> +#define INTEL_QUARK_MFD_GPIO_BASE	8
> +
> +/* The default number of South-Cluster GPIO on Quark. */
> +#define INTEL_QUARK_MFD_NGPIO		8
> +
> +/* The DesignWare GPIO ports on Quark. */
> +#define INTEL_QUARK_GPIO_NPORTS	1
> +
> +#define INTEL_QUARK_IORES_MEM	0
> +#define INTEL_QUARK_IORES_IRQ	1
> +
> +#define INTEL_QUARK_I2C_CONTROLLER_CLK "i2c_designware.0"
> +
> +/* The Quark I2C controller source clock */
> +#define INTEL_QUARK_I2C_CLK_HZ	33000000
> +
> +#define INTEL_QUARK_I2C_NCLK	1
> +
> +struct intel_quark_mfd {
> +	struct pci_dev		*pdev;
> +	struct clk			*i2c_clk;
> +	struct clk_lookup	*i2c_clk_lookup;
> +};
> +
> +struct i2c_mode_info {
> +	const char *name;
> +	unsigned int i2c_scl_freq;
> +};
> +
> +static const struct i2c_mode_info platform_i2c_mode_info[] = {
> +	{
> +		.name = "Galileo",
> +		.i2c_scl_freq = 100000,
> +	},
> +	{
> +		.name = "GalileoGen2",
> +		.i2c_scl_freq = 400000,
> +	},
> +};
> +
> +static struct resource intel_quark_i2c_res[] = {
> +	[INTEL_QUARK_IORES_MEM] = {
> +		.flags = IORESOURCE_MEM,
> +	},
> +	[INTEL_QUARK_IORES_IRQ] = {
> +		.flags = IORESOURCE_IRQ,
> +	},
> +};
> +
> +static struct resource intel_quark_gpio_res[] = {
> +	[INTEL_QUARK_IORES_MEM] = {
> +		.flags = IORESOURCE_MEM,
> +	},
> +};
> +
> +static struct mfd_cell intel_quark_mfd_cells[] = {
> +	{
> +		.id = MFD_I2C_BAR,
> +		.name = "i2c_designware",
> +		.num_resources = ARRAY_SIZE(intel_quark_i2c_res),
> +		.resources = intel_quark_i2c_res,
> +		.ignore_resource_conflicts = true,
> +	},
> +	{
> +		.id = MFD_GPIO_BAR,
> +		.name = "gpio-dwapb",
> +		.num_resources = ARRAY_SIZE(intel_quark_gpio_res),
> +		.resources = intel_quark_gpio_res,
> +		.ignore_resource_conflicts = true,
> +	},
> +};
> +
> +static const struct pci_device_id intel_quark_mfd_ids[] = {
> +	{ PCI_VDEVICE(INTEL, 0x0934), },
> +	{ 0,}
> +};
> +MODULE_DEVICE_TABLE(pci, intel_quark_mfd_ids);
> +
> +static int intel_quark_register_i2c_clk(struct intel_quark_mfd *quark_mfd)

What about quark_mfd -> mfd ? This prefix is kinda useless inside the
functions in this module.

> +{
> +	struct pci_dev *pdev = quark_mfd->pdev;
> +	struct clk_lookup *i2c_clk_lookup;
> +	struct clk *i2c_clk;
> +	int retval;
> +
> +	i2c_clk_lookup = devm_kcalloc(
> +		&pdev->dev, INTEL_QUARK_I2C_NCLK,
> +		sizeof(*i2c_clk_lookup), GFP_KERNEL);
> +
> +	if (!i2c_clk_lookup)
> +		return -ENOMEM;
> +
> +	i2c_clk_lookup[0].dev_id = INTEL_QUARK_I2C_CONTROLLER_CLK;
> +
> +	i2c_clk = clk_register_fixed_rate(
> +		&pdev->dev, INTEL_QUARK_I2C_CONTROLLER_CLK, NULL,
> +		CLK_IS_ROOT, INTEL_QUARK_I2C_CLK_HZ);
> +
> +	quark_mfd->i2c_clk_lookup = i2c_clk_lookup;
> +	quark_mfd->i2c_clk = i2c_clk;
> +
> +	retval = clk_register_clkdevs(i2c_clk, i2c_clk_lookup,
> +				      INTEL_QUARK_I2C_NCLK);
> +	if (retval)
> +		dev_err(&pdev->dev, "Fixed clk register failed: %d\n", retval);
> +
> +	return retval;
> +}
> +
> +static void intel_quark_unregister_i2c_clk(struct pci_dev *pdev)
> +{
> +	struct intel_quark_mfd *quark_mfd = dev_get_drvdata(&pdev->dev);

Ditto.

> +
> +	if (!quark_mfd->i2c_clk || !quark_mfd->i2c_clk_lookup)
> +		return;
> +
> +	clkdev_drop(quark_mfd->i2c_clk_lookup);
> +	clk_unregister(quark_mfd->i2c_clk);
> +}
> +
> +static int intel_quark_i2c_setup(struct pci_dev *pdev, struct mfd_cell *cell)
> +{
> +	const char *board_name = dmi_get_system_info(DMI_BOARD_NAME);
> +	struct dw_i2c_platform_data *pdata;
> +	struct resource *res = (struct resource *)cell->resources;

Here you know what the exact resource you is going to change.

What if you update the global variable first, and assign it here to the
cell?


> +	struct device *dev = &pdev->dev;
> +	unsigned int i;
> +
> +	res[INTEL_QUARK_IORES_MEM].start =
> +		pci_resource_start(pdev, MFD_I2C_BAR);
> +	res[INTEL_QUARK_IORES_MEM].end =
> +		pci_resource_end(pdev, MFD_I2C_BAR);
> +
> +	res[INTEL_QUARK_IORES_IRQ].start = pdev->irq;
> +	res[INTEL_QUARK_IORES_IRQ].end = pdev->irq;
> +
> +	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
> +	if (!pdata)
> +		return -ENOMEM;
> +
> +	/* Fast mode by default */
> +	pdata->i2c_scl_freq = 400000;
> +
> +	for (i = 0; i < ARRAY_SIZE(platform_i2c_mode_info); i++)
> +		if (!strcmp(board_name, platform_i2c_mode_info[i].name))
> +			pdata->i2c_scl_freq
> +				= platform_i2c_mode_info[i].i2c_scl_freq;
> +
> +	cell->platform_data = pdata;
> +	cell->pdata_size = sizeof(*pdata);
> +
> +	return 0;
> +}
> +
> +static int intel_quark_gpio_setup(struct pci_dev *pdev, struct mfd_cell *cell)
> +{
> +	struct dwapb_platform_data *pdata;
> +	struct resource *res = (struct resource *)cell->resources;

Same idea here.

> +	struct device *dev = &pdev->dev;
> +
> +	res[INTEL_QUARK_IORES_MEM].start =
> +		pci_resource_start(pdev, MFD_GPIO_BAR);
> +	res[INTEL_QUARK_IORES_MEM].end =
> +		pci_resource_end(pdev, MFD_GPIO_BAR);
> +
> +	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
> +	if (!pdata)
> +		return -ENOMEM;
> +
> +	/* For intel quark x1000, it has only one port: portA */
> +	pdata->nports = INTEL_QUARK_GPIO_NPORTS;
> +	pdata->properties = devm_kcalloc(dev, pdata->nports,
> +					 sizeof(*pdata->properties),
> +					 GFP_KERNEL);
> +	if (!pdata->properties)
> +		return -ENOMEM;
> +
> +	/* Set the properties for portA */
> +	pdata->properties->node	= NULL;
> +	pdata->properties->name	= "intel-quark-x1000-gpio-portA";
> +	pdata->properties->idx	= 0;
> +	pdata->properties->ngpio	= INTEL_QUARK_MFD_NGPIO;
> +	pdata->properties->gpio_base	= INTEL_QUARK_MFD_GPIO_BASE;
> +	pdata->properties->irq	= pdev->irq;
> +	pdata->properties->irq_shared	= true;
> +
> +	cell->platform_data = pdata;
> +	cell->pdata_size = sizeof(*pdata);
> +
> +	return 0;
> +}
> +
> +static int intel_quark_mfd_probe(struct pci_dev *pdev,
> +				 const struct pci_device_id *id)
> +{
> +	struct intel_quark_mfd *quark_mfd;
> +	int retval;
> +
> +	retval = pcim_enable_device(pdev);
> +	if (retval)
> +		return retval;
> +
> +	quark_mfd = devm_kzalloc(&pdev->dev, sizeof(*quark_mfd), GFP_KERNEL);
> +	if (!quark_mfd)
> +		return -ENOMEM;
> +	quark_mfd->pdev = pdev;
> +
> +	retval = intel_quark_register_i2c_clk(quark_mfd);
> +	if (retval)
> +		return retval;
> +
> +	dev_set_drvdata(&pdev->dev, quark_mfd);
> +
> +	retval = intel_quark_i2c_setup(pdev,
> +				       &intel_quark_mfd_cells[MFD_I2C_BAR]);
> +	if (retval)
> +		return retval;
> +
> +	retval = intel_quark_gpio_setup(pdev,
> +					&intel_quark_mfd_cells[MFD_GPIO_BAR]);
> +	if (retval)
> +		return retval;
> +
> +	return mfd_add_devices(&pdev->dev, 0, intel_quark_mfd_cells,
> +		ARRAY_SIZE(intel_quark_mfd_cells), NULL, 0, NULL);
> +}
> +
> +static void intel_quark_mfd_remove(struct pci_dev *pdev)
> +{
> +	intel_quark_unregister_i2c_clk(pdev);
> +	mfd_remove_devices(&pdev->dev);
> +}
> +
> +static struct pci_driver intel_quark_mfd_driver = {
> +	.name		= "intel_quark_mfd_i2c_gpio",
> +	.id_table	= intel_quark_mfd_ids,
> +	.probe		= intel_quark_mfd_probe,
> +	.remove		= intel_quark_mfd_remove,
> +};
> +
> +module_pci_driver(intel_quark_mfd_driver);
> +
> +MODULE_AUTHOR("Raymond Tan <raymond.tan@intel.com>");
> +MODULE_DESCRIPTION("Intel Quark MFD PCI driver for I2C & GPIO");
> +MODULE_LICENSE("GPL v2");


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy
---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki 
Business Identity Code: 0357606 - 4 
Domiciled in Helsinki 

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
