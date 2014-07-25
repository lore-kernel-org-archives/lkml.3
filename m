Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760799AbaGYO73 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:59:29 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50326 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628AbaGYO70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:59:26 -0400
Message-ID: <53D27B72.2060709@ti.com>
Date: Fri, 25 Jul 2014 18:44:50 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Suman Anna <s-anna@ti.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
CC: "Khoronzhuk, Ivan" <ivan.khoronzhuk@ti.com>,
        "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "varkabhadram@gmail.com" <varkabhadram@gmail.com>
Subject: Re: [PATCH v2] gpio: keystone: add dsp gpio controller driver
References: <1406126699-10053-1-git-send-email-grygorii.strashko@ti.com> <53D15B47.6020802@ti.com>
In-Reply-To: <53D15B47.6020802@ti.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2014 10:15 PM, Suman Anna wrote:
> Grygorii,
> 
> On 07/23/2014 09:44 AM, Strashko, Grygorii wrote:
>> From: Murali Karicheri <m-karicheri2@ti.com>
>>
>> On Keystone SOCs, ARM host can send interrupts to DSP cores using the
>> DSP GPIO controller IP. Each DSP GPIO controller provides 28 IRQ signals for
>> each DSP core. This is one of the component used by the IPC mechanism used
>> on Keystone SOCs.
>>
>> Keystone 2 DSP GPIO controller has specific features:
>> - each GPIO can be configured only as output pin;
>> - setting GPIO value to 1 causes IRQ generation on target DSP core;
>> - reading pin value returns 0 - if IRQ was handled or 1 - IRQ is still
>>    pending.
>>
>> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>> ---
>> Changes in v2:
>> - minor comments applied
>>
>> v1:
>>   https://lkml.org/lkml/2014/7/16/170
>>
>>   .../devicetree/bindings/gpio/gpio-keystone.txt     |   43 ++++++
>>   drivers/gpio/Kconfig                               |    8 ++
>>   drivers/gpio/Makefile                              |    1 +
>>   drivers/gpio/gpio-keystone.c                       |  138 ++++++++++++++++++++
>>   4 files changed, 190 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/gpio/gpio-keystone.txt
>>   create mode 100644 drivers/gpio/gpio-keystone.c
>>
>> diff --git a/Documentation/devicetree/bindings/gpio/gpio-keystone.txt b/Documentation/devicetree/bindings/gpio/gpio-keystone.txt
>> new file mode 100644
>> index 0000000..d412711
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/gpio/gpio-keystone.txt
>> @@ -0,0 +1,43 @@
>> +Keystone 2 DSP GPIO controller bindings
>> +
>> +HOST OS userland running on ARM can send interrupts to DSP cores using
>> +the DSP GPIO controller IP. It provides 28 IRQ signals per each DSP core.
>> +This is one of the component used by the IPC mechanism used on Keystone SOCs.
>> +
>> +For example TCI6638K2K SoC has 8 DSP GPIO controllers:
>> + - 8 for C66x CorePacx CPUs 0-7
>> +
>> +Keystone 2 DSP GPIO controller has specific features:
>> +- each GPIO can be configured only as output pin;
>> +- setting GPIO value to 1 causes IRQ generation on target DSP core;
>> +- reading pin value returns 0 - if IRQ was handled or 1 - IRQ is still
>> +  pending.
>> +
>> +Required Properties:
>> +- compatible: should be "ti,keystone-dsp-gpio"
>> +
>> +- ti,syscon-dev : phandle/offset pair. The phandle to syscon used to
>> +				  access device state control registers and the offset
>> +				  in order to use block of device's specific registers.
>> +
>> +- gpio-controller : Marks the device node as a gpio controller.
>> +
>> +- #gpio-cells : Should be one.
>> +				See gpio.txt in this directory for a of the cells format
>> +
>> +Please refer to gpio.txt in this directory for details of the common GPIO
>> +bindings used by client devices.
>> +
>> +Example:
>> +	dspgpio0: keystone_dsp_gpio@02620240 {
>> +		compatible = "ti,keystone-dsp-gpio";
>> +		ti,syscon-dev = <&devctrl 0x240>;
>> +		gpio-controller;
>> +		#gpio-cells = <2>;
> 
> Mismatch? Conflicts with "Should be one".

You are right.
> 
>> +	};
>> +
>> +	dsp0: dsp0 {
>> +		compatible = "linux,rproc-user";
>> +		...
>> +		kick-gpio = <&dspgpio0 27>;
>> +	};
>> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
>> index 4a1b511..990871f 100644
>> --- a/drivers/gpio/Kconfig
>> +++ b/drivers/gpio/Kconfig
>> @@ -158,6 +158,14 @@ config GPIO_EP93XX
>>   	depends on ARCH_EP93XX
>>   	select GPIO_GENERIC
>>   
>> +config GPIO_KEYSTONE_DSP
>> +	tristate "Keystone DSP GPIO support"
>> +	depends on ARCH_KEYSTONE
>> +	help
>> +	  Say yes here to support the DSP GPIO driver for Keystone 2. This defines
>> +	  up to 28 GPIOs per each Remote (DSP) core. This is used to send
>> +	  signals from ARM to the Remote (DSP) core.
>> +
>>   config GPIO_ZEVIO
>>   	bool "LSI ZEVIO SoC memory mapped GPIOs"
>>   	depends on ARM && OF_GPIO
>> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
>> index d10f6a9..15c3389 100644
>> --- a/drivers/gpio/Makefile
>> +++ b/drivers/gpio/Makefile
>> @@ -34,6 +34,7 @@ obj-$(CONFIG_GPIO_IOP)		+= gpio-iop.o
>>   obj-$(CONFIG_GPIO_IT8761E)	+= gpio-it8761e.o
>>   obj-$(CONFIG_GPIO_JANZ_TTL)	+= gpio-janz-ttl.o
>>   obj-$(CONFIG_GPIO_KEMPLD)	+= gpio-kempld.o
>> +obj-$(CONFIG_GPIO_KEYSTONE_DSP)	+= gpio-keystone.o
>>   obj-$(CONFIG_ARCH_KS8695)	+= gpio-ks8695.o
>>   obj-$(CONFIG_GPIO_INTEL_MID)	+= gpio-intel-mid.o
>>   obj-$(CONFIG_GPIO_LP3943)	+= gpio-lp3943.o
>> diff --git a/drivers/gpio/gpio-keystone.c b/drivers/gpio/gpio-keystone.c
>> new file mode 100644
>> index 0000000..7909a1c
>> --- /dev/null
>> +++ b/drivers/gpio/gpio-keystone.c
>> @@ -0,0 +1,138 @@
>> +/*
>> + * Keystone 2 DSP GPIO support.
>> + *
>> + * Copyright (C) 2014 Texas Instruments, Inc.
>> + * Author: Murali Karicheri <m-karicheri2@ti.com>
>> + *	   Grygorii Strashko <grygorii.strashko@ti.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +#include <linux/module.h>
>> +#include <linux/of_platform.h>
>> +#include <linux/gpio.h>
>> +#include <linux/mfd/syscon.h>
>> +#include <linux/regmap.h>
>> +
>> +/* 28 bits in IPCGRx are treated as GPIO pins to generate interrupt */
>> +#define GPIOS_PER_BANK		28
>> +#define GPIO_OFFSET		4
>> +
>> +struct keystone_gpio_bank {
>> +	struct gpio_chip	 chip;
>> +	struct device		*dev;
>> +	struct regmap		*devctrl_regs;
>> +	u32			devctrl_offset;
>> +};
>> +#define chip_to_bank(c) \
>> +	container_of(c, struct keystone_gpio_bank, chip)
>> +
>> +static int keystone_gpio_direction_out(struct gpio_chip *c,
>> +					unsigned ofs, int val)
>> +{
>> +	return 0;
>> +}
>> +
>> +static int keystone_gpio_get(struct gpio_chip *c, unsigned ofs)
>> +{
>> +	struct keystone_gpio_bank *bank = chip_to_bank(c);
>> +	int bit = ofs + GPIO_OFFSET;
>> +	int ret;
>> +	u32 val = 0;
>> +
>> +	ret = regmap_read(bank->devctrl_regs, bank->devctrl_offset, &val);
>> +	if (ret < 0)
>> +		dev_dbg(bank->dev, "gpio read failed ret(%d)\n", ret);
>> +
>> +	return (val >> bit) & 1;
>> +}
>> +
>> +static void keystone_gpio_set(struct gpio_chip *c, unsigned ofs, int val)
>> +{
>> +	struct keystone_gpio_bank *bank = chip_to_bank(c);
>> +	int bit = ofs + GPIO_OFFSET;
>> +	int ret;
>> +
>> +	if (!val)
>> +		return;
>> +
>> +	ret = regmap_write(bank->devctrl_regs, bank->devctrl_offset,
>> +			   BIT(bit) | 1);
> 
> What is this ORing with 1 for?

This is lock/trigger bit. Once set - Configured GPIO values will be physically applied.

Regards,
-grygorii

