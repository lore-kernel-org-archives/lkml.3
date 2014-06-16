Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbaFPN1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:27:31 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55324 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754307AbaFPNXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:23:39 -0400
Message-ID: <539EEFD8.20703@free-electrons.com>
Date: Mon, 16 Jun 2014 15:23:36 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Thierry Reding <thierry.reding@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        David Airlie <airlied@linux.ie>, Samuel Ortiz <sameo@linux.intel.com>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v2 1/7] mfd: add atmel-hlcdc driver
References: <1402329860-27520-1-git-send-email-boris.brezillon@free-electrons.com> <1402329860-27520-2-git-send-email-boris.brezillon@free-electrons.com> <20140616125030.GT14323@lee--X1>
In-Reply-To: <20140616125030.GT14323@lee--X1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Lee,

On 16/06/2014 14:50, Lee Jones wrote:
>> The HLCDC IP available on some Atmel SoCs (i.e. at91sam9n12, at91sam9x5
>> family or sama5d3 family) exposes 2 subdevices:
>> - a display controller (controlled by a DRM driver)
>> - a PWM chip
>>
>> Add support for the MFD device which will just retrieve HLCDC clocks and
>> create a regmap so that subdevices can access the HLCDC register range
>> concurrently.
>>
>> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
>> ---
>>  .../devicetree/bindings/mfd/atmel-hlcdc.txt        |  41 ++++++++
>>  drivers/mfd/Kconfig                                |  11 ++
>>  drivers/mfd/Makefile                               |   1 +
>>  drivers/mfd/atmel-hlcdc.c                          | 116 +++++++++++++++++++++
>>  include/linux/mfd/atmel-hlcdc.h                    |  78 ++++++++++++++
>>  5 files changed, 247 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/mfd/atmel-hlcdc.txt
>>  create mode 100644 drivers/mfd/atmel-hlcdc.c
>>  create mode 100644 include/linux/mfd/atmel-hlcdc.h
>> diff --git a/Documentation/devicetree/bindings/mfd/atmel-hlcdc.txt b/Documentation/devicetree/bindings/mfd/atmel-hlcdc.txt
>> new file mode 100644
>> index 0000000..f5b69cb
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/mfd/atmel-hlcdc.txt
>> @@ -0,0 +1,41 @@
>> +Device-Tree bindings for Atmel's HLCDC (High LCD Controller) MFD driver
>> +
>> +Required properties:
>> + - compatible: value should be one of the following:
>> +   "atmel,sama5d3-hlcdc"
>> + - reg: base address and size of the HLCDC device registers.
>> + - clock-names: the name of the 3 clocks requested by the HLCDC device.
>> +   Should contain "periph_clk", "sys_clk" and "slow_clk".
>> + - clocks: should contain the 3 clocks requested by the HLCDC device.
>> +
>> +The HLCDC IP exposes two subdevices:
>> + - a PWM chip: see Documentation/devicetree/bindings/pwm/atmel-hlcdc-pwm.txt
>> + - a Display Controller: see Documentation/devicetree/bindings/drm/atmel-hlcdc-dc.txt
>> +
>> +Example:
>> +
>> +	hlcdc: hlcdc@f0030000 {
>> +		compatible = "atmel,sama5d3-hlcdc";
>> +		reg = <0xf0030000 0x2000>;
>> +		clocks = <&lcdc_clk>, <&lcdck>, <&clk32k>;
>> +		clock-names = "periph_clk","sys_clk", "slow_clk";
>> +		status = "disabled";
> Not sure you really want to disable the the node in the example.

Nope, I'll remove this line.

>> +		hlcdc-display-controller {
>> +			compatible = "atmel,hlcdc-dc";
>> +			interrupts = <36 IRQ_TYPE_LEVEL_HIGH 0>;
> I assume you're using the 3rd parameter for flags.  If so, please use
> the defines.

No, the third parameter encodes the irq priority (from 0 to 7 IIRC).

>> +			pinctrl-names = "default", "rgb-444", "rgb-565", "rgb-666", "rgb-888";
>> +			pinctrl-0 = <&pinctrl_lcd_base>;
>> +			pinctrl-1 = <&pinctrl_lcd_base &pinctrl_lcd_rgb444>;
>> +			pinctrl-2 = <&pinctrl_lcd_base &pinctrl_lcd_rgb565>;
>> +			pinctrl-3 = <&pinctrl_lcd_base &pinctrl_lcd_rgb666>;
>> +			pinctrl-4 = <&pinctrl_lcd_base &pinctrl_lcd_rgb888>;
>> +		};
>> +
>> +		hlcdc_pwm: hlcdc-pwm {
>> +			compatible = "atmel,hlcdc-pwm";
>> +			pinctrl-names = "default";
>> +			pinctrl-0 = <&pinctrl_lcd_pwm>;
>> +			#pwm-cells = <3>;
>> +		};
>> +	};
>> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
>> index ee8204c..82777f6 100644
>> --- a/drivers/mfd/Kconfig
>> +++ b/drivers/mfd/Kconfig
>> @@ -59,6 +59,17 @@ config MFD_AAT2870_CORE
>>  	  additional drivers must be enabled in order to use the
>>  	  functionality of the device.
>>  
>> +config MFD_ATMEL_HLCDC
>> +	tristate "Atmel HLCDC (High LCD Controller)"
> What's the difference between a high and a low controller?

I don't know exactly.
I guess the name changed when the LCD Controller design changed.
Maybe "High-end LCD Controller" would be better...

Nicolas, can you help me on this one ?

>
>> +	select MFD_CORE
>> +	select REGMAP_MMIO
>> +	help
>> +	  Choose this option if you have an ATMEL SoC with an HLCDC (High
>> +	  LCD Controller) IP (i.e. at91sam9n12, at91sam9x5 family or sama5d3
>> +	  family).
>> +	  This MFD device exposes two subdevices: a PWM chip and a Display
>> +	  Controller.
>> +
>>  config MFD_BCM590XX
>>  	tristate "Broadcom BCM590xx PMUs"
>>  	select MFD_CORE
>> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
>> index 8afedba..5f25b0d 100644
>> --- a/drivers/mfd/Makefile
>> +++ b/drivers/mfd/Makefile
>> @@ -156,6 +156,7 @@ obj-$(CONFIG_MFD_PM8921_CORE) 	+= pm8921-core.o ssbi.o
>>  obj-$(CONFIG_TPS65911_COMPARATOR)	+= tps65911-comparator.o
>>  obj-$(CONFIG_MFD_TPS65090)	+= tps65090.o
>>  obj-$(CONFIG_MFD_AAT2870_CORE)	+= aat2870-core.o
>> +obj-$(CONFIG_MFD_ATMEL_HLCDC)	+= atmel-hlcdc.o
>>  obj-$(CONFIG_MFD_INTEL_MSIC)	+= intel_msic.o
>>  obj-$(CONFIG_MFD_PALMAS)	+= palmas.o
>>  obj-$(CONFIG_MFD_VIPERBOARD)    += viperboard.o
>> diff --git a/drivers/mfd/atmel-hlcdc.c b/drivers/mfd/atmel-hlcdc.c
>> new file mode 100644
>> index 0000000..e4636e8
>> --- /dev/null
>> +++ b/drivers/mfd/atmel-hlcdc.c
>> @@ -0,0 +1,116 @@
>> +/*
>> + * Copyright (C) 2014 Free Electrons
>> + * Copyright (C) 2014 Atmel
>> + *
>> + * Author: Boris BREZILLON <boris.brezillon@free-electrons.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License version 2 as published by
>> + * the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, but WITHOUT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
>> + * more details.
>> + *
>> + * You should have received a copy of the GNU General Public License along with
>> + * this program.  If not, see <http://www.gnu.org/licenses/>.
>> + */
>> +
>> +#include <linux/mfd/atmel-hlcdc.h>
>> +#include <linux/mfd/core.h>
>> +#include <linux/module.h>
>> +#include <linux/platform_device.h>
> Looks like you're inheriting the clk and regmap header files - don't
> do that.  Each source file which uses the interfaces should include
> them independently.

Okay, I'll explicitly include clk and regmap headers.

>
>> +static const struct mfd_cell atmel_hlcdc_cells[] = {
>> +	{
>> +		.name = "atmel-hlcdc-pwm",
>> +		.of_compatible = "atmel,hlcdc-pwm",
>> +	},
>> +	{
>> +		.name = "atmel-hlcdc-dc",
>> +		.of_compatible = "atmel,hlcdc-dc",
>> +	},
>> +};
>> +
>> +static int atmel_hlcdc_probe(struct platform_device *pdev)
>> +{
>> +	struct device *dev = &pdev->dev;
>> +	struct regmap_config config;
>> +	struct atmel_hlcdc *hlcdc;
>> +	struct resource *res;
>> +	void __iomem *regs;
>> +
>> +	hlcdc = devm_kzalloc(dev, sizeof(*hlcdc), GFP_KERNEL);
>> +	if (!hlcdc)
>> +		return -ENOMEM;
>> +
>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	regs = devm_ioremap_resource(dev, res);
>> +	if (IS_ERR(regs))
>> +		return PTR_ERR(regs);
>> +
>> +	hlcdc->periph_clk = devm_clk_get(dev, "periph_clk");
>> +	if (IS_ERR(hlcdc->periph_clk)) {
>> +		dev_err(dev, "failed to get functional clock\n");
>> +		return PTR_ERR(hlcdc->periph_clk);
>> +	}
>> +
>> +	hlcdc->sys_clk = devm_clk_get(dev, "sys_clk");
>> +	if (IS_ERR(hlcdc->sys_clk)) {
>> +		dev_err(dev, "failed to get functional clock\n");
> Can you be more descriptive?  This error message is the same as the
> one above.  How will a user know which one has failed?

This is a copy/paste error. I'll fix that.

>
>> +		return PTR_ERR(hlcdc->sys_clk);
>> +	}
>> +
>> +	hlcdc->slow_clk = devm_clk_get(dev, "slow_clk");
>> +	if (IS_ERR(hlcdc->slow_clk)) {
>> +		dev_err(dev, "failed to get slow clock\n");
>> +		return PTR_ERR(hlcdc->slow_clk);
>> +	}
>> +
>> +	memset(&config, 0, sizeof(config));
>> +	config.reg_bits = 32;
>> +	config.val_bits = 32;
>> +	config.reg_stride = 4;
>> +	config.max_register = (resource_size(res) / 4) - 1;
> I'd prefer you did this as a separate struct, like everyone else
> does.

I tend to avoid static structures when they're used to initialize
configurable things (here max_register depends on the resource size).
This prevent getting the structure filled with dirty values from
previous probe calls.
Moreover, AFAIK, all the fields set in config are copied to the regmap
struct during registration, and config pointer is never used after the
registration has completed.

Anyway, I can define a static struct and dynamically modify max_register.

>> +	hlcdc->regmap = devm_regmap_init_mmio_clk(dev, "periph_clk", regs,
>> +						  &config);
>> +	if (IS_ERR(hlcdc->regmap))
>> +		return PTR_ERR(hlcdc->regmap);
>> +
>> +	dev_set_drvdata(dev, hlcdc);
>> +
>> +	return mfd_add_devices(dev, -1, atmel_hlcdc_cells,
>> +			       ARRAY_SIZE(atmel_hlcdc_cells),
>> +			       NULL, 0, NULL);
>> +}
>> +
>> +static int atmel_hlcdc_remove(struct platform_device *pdev)
>> +{
>> +	mfd_remove_devices(&pdev->dev);
>> +
>> +	dev_set_drvdata(&pdev->dev, NULL);
> This is done automatically for you - you can remove it.

Okay.

>
>> +	return 0;
>> +}
>> +
>> +static const struct of_device_id atmel_hlcdc_match[] = {
>> +	{ .compatible = "atmel,sama5d3-hlcdc" },
>> +	{ },
>> +};
>> +
>> +static struct platform_driver atmel_hlcdc_driver = {
>> +	.probe = atmel_hlcdc_probe,
>> +	.remove = atmel_hlcdc_remove,
>> +	.driver = {
>> +		.name = "atmel-hlcdc",
>> +		.owner = THIS_MODULE,
>> +		.of_match_table = atmel_hlcdc_match,
> Is this driver DT only?

Yes it is.

>
>> +	},
>> +};
>> +module_platform_driver(atmel_hlcdc_driver);
>> +
>> +MODULE_ALIAS("platform:atmel-hlcdc");
>> +MODULE_AUTHOR("Boris Brezillon <boris.brezillon@free-electrons.com>");
>> +MODULE_DESCRIPTION("Atmel HLCDC driver");
>> +MODULE_LICENSE("GPL");
>> diff --git a/include/linux/mfd/atmel-hlcdc.h b/include/linux/mfd/atmel-hlcdc.h
>> new file mode 100644
>> index 0000000..d7a5589
>> --- /dev/null
>> +++ b/include/linux/mfd/atmel-hlcdc.h
>> @@ -0,0 +1,78 @@
>> +/*
>> + * Copyright (C) 2014 Free Electrons
>> + * Copyright (C) 2014 Atmel
>> + *
>> + * Author: Boris BREZILLON <boris.brezillon@free-electrons.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License version 2 as published by
>> + * the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, but WITHOUT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
>> + * more details.
>> + *
>> + * You should have received a copy of the GNU General Public License along with
>> + * this program.  If not, see <http://www.gnu.org/licenses/>.
>> + */
>> +
>> +#ifndef __LINUX_MFD_HLCDC_H
>> +#define __LINUX_MFD_HLCDC_H
>> +
>> +#include <linux/clk.h>
>> +#include <linux/regmap.h>
>> +
>> +#define ATMEL_HLCDC_CFG(i)		((i) * 0x4)
>> +#define ATMEL_HLCDC_SIG_CFG		LCDCFG(5)
>> +#define		ATMEL_HLCDC_HSPOL		BIT(0)
>> +#define		ATMEL_HLCDC_VSPOL		BIT(1)
>> +#define		ATMEL_HLCDC_VSPDLYS		BIT(2)
>> +#define		ATMEL_HLCDC_VSPDLYE		BIT(3)
>> +#define		ATMEL_HLCDC_DISPPOL		BIT(4)
>> +#define		ATMEL_HLCDC_DITHER		BIT(6)
>> +#define		ATMEL_HLCDC_DISPDLY		BIT(7)
>> +#define		ATMEL_HLCDC_MODE_MASK		0x300
>> +#define		ATMEL_HLCDC_PP			BIT(10)
>> +#define		ATMEL_HLCDC_VSPSU		BIT(12)
>> +#define		ATMEL_HLCDC_VSPHO		BIT(13)
>> +#define		ATMEL_HLCDC_GUARDTIME_MASK	0x1f0000
> There should only be one space after '#define'.

I'll fix that.

Thanks for your review.

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

