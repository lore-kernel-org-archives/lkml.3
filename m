Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780Ab3JALq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 07:46:59 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:43937 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab3JALq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 07:46:57 -0400
Date: Tue, 1 Oct 2013 12:46:48 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: sameo@linux.intel.com, broonie@kernel.org, linus.walleij@linaro.org,
        akpm@linux-foundation.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, rtc-linux@googlegroups.com,
        rob.herring@calxeda.com, mark.rutland@arm.com, pawel.moll@arm.com,
        swarren@wwwdotorg.org, rob@landley.net, ijc+devicetree@hellion.org.uk,
        grant.likely@linaro.org, Florian Lobmaier <florian.lobmaier@ams.com>
Subject: Re: [PATCH V3 1/3] mfd: add support for AMS AS3722 PMIC
Message-ID: <20131001114648.GM9048@lee--X1>
References: <1380023921-29867-1-git-send-email-ldewangan@nvidia.com>
 <1380023921-29867-2-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1380023921-29867-2-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Sep 2013, Laxman Dewangan wrote:

> The AMS AS3722 is a compact system PMU suitable for mobile phones,

s/AMS/ams

> tablets etc. It has 4 DC/DC step-down regulators, 3 DC/DC step-down
> controller, 11 LDOs, RTC, automatic battery, temperature and
> over-current monitoring, 8 GPIOs, ADC and watchdog.
> 
> Add MFD core driver for the AS3722 to support core functionality.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> Signed-off-by: Florian Lobmaier <florian.lobmaier@ams.com>
> ---
> Changes from V1: 
> - Remove compatible string from DT for subnode.
> - Nit cleanups in driver and use module_i2c_driver
> 
> Changes from V2:
> - Change DT file to reflect the changes in gpio/pincntrl driver.
>   Now there is no extra subnode.
> 
>  Documentation/devicetree/bindings/mfd/as3722.txt |   52 +++

You need an Ack from the Device Tree guys for this.

I see a few nits in the formatting of the document too.

>  drivers/mfd/Kconfig                              |   12 +
>  drivers/mfd/Makefile                             |    1 +
>  drivers/mfd/as3722.c                             |  448 ++++++++++++++++++++++
>  include/linux/mfd/as3722.h                       |  423 ++++++++++++++++++++
>  5 files changed, 936 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mfd/as3722.txt
>  create mode 100644 drivers/mfd/as3722.c
>  create mode 100644 include/linux/mfd/as3722.h
> 
> diff --git a/Documentation/devicetree/bindings/mfd/as3722.txt b/Documentation/devicetree/bindings/mfd/as3722.txt
> new file mode 100644
> index 0000000..8e1b97c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/as3722.txt
> @@ -0,0 +1,52 @@
> +* AMS AS3722 Power management IC.

s/AMS/ams

> +Required properties:
> +-------------------
> +- compatible : Must be "ams,as3722".

               ^--- Space here

> +- reg:  I2C device address.

        ^--- But no Space here and an extra one after ':'.

> +- interrupt-controller : AS3722 has its own internal IRQs
> +- #interrupt-cells : should be set to 2 for IRQ number and flags

                        ^--- Uppercase                 Fullstop ---^

> +  The first cell is the IRQ number.
> +  The second cell is the flags, encoded as the trigger masks from
> +	Documentation/devicetree/bindings/interrupts.txt, using
> +	the #defines found in dt-bindings/irq.

All DTS files should be using the #defines, no need to specify that.

> +- interrupt-parent : The parent interrupt controller.
> +
> +Optional properties:
> +-------------------
> +- gpio-controller: Marks the device node as a GPIO controller.
> +- #gpio-cells: Number of GPIO cells. Refer
> +	Documentation/devicetree/bindings/gpio/gpio.txt
> +- pinctrl-names: It is define in the

s/define/defined

> +	Documentation/devicetree/bindings/pinctrl/pinctrl-binding.txt
> +
> +Example:
> +--------
> +ams3722 {
> +	compatible = "ams,as3722";
> +	reg = <0x48>

Missing ';'.

> +
> +	interrupt-parent = <&intc>;
> +	interrupt-controller;
> +	#interrupt-cells = <2>;
> +
> +	gpio-controller;
> +	#gpio-cells = <2>;
> +
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&as3722_default>;
> +
> +	as3722_default: pinmux {
> +		/*
> +		 * Default pinmux setting.
> +		 * Refer document bindings/pinctrl/pinctrl-as3722.txt

s/Refer/Refer to

> +		 */
> +	}
> +
> +	regulators {
> +		/*
> +		 * Regulator related properties
> +		 * Refer document bindings/regulator/as3722-regulator.txt
> +		 */
> +	};
> +};
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 914c3d1..694d226 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -27,6 +27,18 @@ config MFD_AS3711
>  	help
>  	  Support for the AS3711 PMIC from AMS

s/ams/AMS

> +config MFD_AS3722
> +	bool "AMS AS3722 Power Management IC"

s/ams/AMS

etc etc ...

> +	select MFD_CORE
> +	select REGMAP_I2C
> +	select REGMAP_IRQ
> +	depends on I2C && OF
> +	help
> +	  The AMS AS3722 is a compact system PMU suitable for mobile phones,
> +	  tablet etc. It has 4 DC/DC step-down regulators, 3 DC/DC step-down

s/tablet/tablets

> +	  controller, 11 LDOs, RTC, automatic battery, temperature and

s/controller/controllers

> +	  over current monitoring, GPIOs, ADC, watchdog.

... and a watchdog.

> +
>  config PMIC_ADP5520
>  	bool "Analog Devices ADP5520/01 MFD PMIC Core Support"
>  	depends on I2C=y
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index 15b905c..d8c2ba1 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -162,3 +162,4 @@ obj-$(CONFIG_MFD_LM3533)	+= lm3533-core.o lm3533-ctrlbank.o
>  obj-$(CONFIG_VEXPRESS_CONFIG)	+= vexpress-config.o vexpress-sysreg.o
>  obj-$(CONFIG_MFD_RETU)		+= retu-mfd.o
>  obj-$(CONFIG_MFD_AS3711)	+= as3711.o
> +obj-$(CONFIG_MFD_AS3722)	+= as3722.o
> diff --git a/drivers/mfd/as3722.c b/drivers/mfd/as3722.c
> new file mode 100644
> index 0000000..4d54c00
> --- /dev/null
> +++ b/drivers/mfd/as3722.c
> @@ -0,0 +1,448 @@
> +/*
> + * Core driver for AMS AS3722 PMICs
> + *
> + * Copyright (C) 2013 ams AG

s/ams/AMS

<snip>

> +static int as3722_i2c_of_probe(struct i2c_client *i2c,
> +			struct as3722 *as3722)
> +{
> +	struct device_node *np = i2c->dev.of_node;
> +	struct irq_data *irq_data;
> +
> +	if (!np) {
> +		dev_err(&i2c->dev, "Device is not having of_node\n");

En Anglais?

"Device Tree not found"

> +		return -EINVAL;
> +	}
> +
> +	irq_data = irq_get_irq_data(i2c->irq);
> +	if (!irq_data) {
> +		dev_err(&i2c->dev, "Invalid IRQ: %d\n", i2c->irq);
> +		return -EINVAL;
> +	}
> +
> +	as3722->en_intern_int_pullup = of_property_read_bool(np,
> +					"ams,enable-internal-int-pullup");
> +	as3722->en_intern_i2c_pullup = of_property_read_bool(np,
> +					"ams,enable-internal-i2c-pullup");

Not sure what this means, or if it's been discussed before, but aren't
there generic bindings for these?

> +	as3722->irq_flags = irqd_get_trigger_type(irq_data);
> +	dev_dbg(&i2c->dev, "Irq flag is 0x%08lx\n", as3722->irq_flags);

"IRQ flags are"

> +	return 0;
> +}
> +
> +static int as3722_i2c_probe(struct i2c_client *i2c,
> +			const struct i2c_device_id *id)
> +{
> +	struct as3722 *as3722;
> +	unsigned long irq_flags;
> +	int ret;
> +
> +	as3722 = devm_kzalloc(&i2c->dev, sizeof(struct as3722), GFP_KERNEL);
> +	if (!as3722)
> +		return -ENOMEM;
> +
> +	as3722->dev = &i2c->dev;
> +	as3722->chip_irq = i2c->irq;
> +	i2c_set_clientdata(i2c, as3722);
> +
> +	ret = as3722_i2c_of_probe(i2c, as3722);
> +	if (ret < 0)
> +		return ret;
> +
> +	as3722->regmap = devm_regmap_init_i2c(i2c, &as3722_regmap_config);
> +	if (IS_ERR(as3722->regmap)) {
> +		ret = PTR_ERR(as3722->regmap);
> +		dev_err(&i2c->dev, "regmap_init failed with err: %d\n", ret);
> +		return ret;
> +	}
> +
> +	ret = as3722_check_device_id(as3722);
> +	if (ret < 0)
> +		return ret;
> +
> +	irq_flags = as3722->irq_flags | IRQF_ONESHOT;
> +	ret = regmap_add_irq_chip(as3722->regmap, as3722->chip_irq,
> +			irq_flags, -1, &as3722_irq_chip,
> +			&as3722->irq_data);
> +	if (ret < 0) {
> +		dev_err(as3722->dev, "regmap_add_irq failed: %d\n", ret);
> +		return ret;
> +	}
> +
> +	ret = as3722_configure_pullups(as3722);
> +	if (ret < 0)
> +		goto scrub;
> +
> +	ret = mfd_add_devices(&i2c->dev, -1, as3722_devs,
> +			ARRAY_SIZE(as3722_devs), NULL, 0,
> +			regmap_irq_get_domain(as3722->irq_data));
> +	if (ret) {
> +		dev_err(as3722->dev, "mfd_add_devices() failed: %d\n", ret);

Not keen on function names in error messages.

"Failed to add MFD devices"

> +		goto scrub;
> +	}
> +
> +	dev_dbg(as3722->dev, "AS3722 core driver initialized successfully\n");
> +	return 0;

'/n' here please.

> +scrub:
> +	regmap_del_irq_chip(as3722->chip_irq, as3722->irq_data);
> +	return ret;
> +}
> +
> +static int as3722_i2c_remove(struct i2c_client *i2c)
> +{
> +	struct as3722 *as3722 = i2c_get_clientdata(i2c);
> +
> +	mfd_remove_devices(as3722->dev);
> +	regmap_del_irq_chip(as3722->chip_irq, as3722->irq_data);
> +	return 0;
> +}
> +
> +static const struct of_device_id as3722_of_match[] = {
> +	{ .compatible = "ams,as3722", },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, as3722_of_match);
> +
> +static const struct i2c_device_id as3722_i2c_id[] = {
> +	{ "as3722", 0 },
> +	{}

Use the same format throughout, pick '{},' or '{}' for both structs. I
suggest the former.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
