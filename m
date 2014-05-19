Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbaESA20 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 20:28:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:26450 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbaESA2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 20:28:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,864,1392192000"; 
   d="scan'208";a="513632384"
Message-ID: <53795016.2080601@linux.intel.com>
Date: Mon, 19 May 2014 08:28:06 +0800
From: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        bin.yang@intel.com
Subject: Re: [PATCH] gpio: Add support for Intel SoC PMIC (Crystal Cove)
References: <1400082247-24168-1-git-send-email-lejun.zhu@linux.intel.com> <CAAVeFuLK6TcGBtiVWFui9NunantvqNUqCmJErsFLN8DeC3C3nw@mail.gmail.com>
In-Reply-To: <CAAVeFuLK6TcGBtiVWFui9NunantvqNUqCmJErsFLN8DeC3C3nw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 5/17/2014 10:37 PM, Alexandre Courbot wrote:
> On Thu, May 15, 2014 at 12:44 AM, Zhu, Lejun <lejun.zhu@linux.intel.com> wrote:
>> Devices based on Intel SoC products such as Baytrail have a Power
>> Management IC. In the PMIC there are subsystems for voltage regulation,
>> A/D conversion, GPIO and PWMs. The PMIC in Baytrail-T platform is called
>> Crystal Cove.
>>
>> This patch adds support for the GPIO function in Crystal Cove.
>>
>> Signed-off-by: Yang, Bin <bin.yang@intel.com>
>> Signed-off-by: Zhu, Lejun <lejun.zhu@linux.intel.com>
>> ---
>>  drivers/gpio/Kconfig            |   9 ++
>>  drivers/gpio/Makefile           |   1 +
>>  drivers/gpio/gpio-crystalcove.c | 323 ++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 333 insertions(+)
>>  create mode 100644 drivers/gpio/gpio-crystalcove.c
>>
>> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
>> index a86c49a..95bb5a0 100644
>> --- a/drivers/gpio/Kconfig
>> +++ b/drivers/gpio/Kconfig
>> @@ -440,6 +440,15 @@ config GPIO_ARIZONA
>>         help
>>           Support for GPIOs on Wolfson Arizona class devices.
>>
>> +config GPIO_INTEL_SOC_PMIC
>> +       bool "GPIO on Intel SoC PMIC"
>> +       depends on INTEL_SOC_PMIC
>> +       help
>> +         Support for GPIO pins on Intel SoC PMIC, such as Crystal
>> +         Cove.
>> +         Say Y if you have a tablet with Intel SoC (e.g. Baytrail)
>> +         inside.
>> +
>>  config GPIO_LP3943
>>         tristate "TI/National Semiconductor LP3943 GPIO expander"
>>         depends on MFD_LP3943
>> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
>> index 6309aff..5380608 100644
>> --- a/drivers/gpio/Makefile
>> +++ b/drivers/gpio/Makefile
>> @@ -30,6 +30,7 @@ obj-$(CONFIG_GPIO_F7188X)     += gpio-f7188x.o
>>  obj-$(CONFIG_GPIO_GE_FPGA)     += gpio-ge.o
>>  obj-$(CONFIG_GPIO_GRGPIO)      += gpio-grgpio.o
>>  obj-$(CONFIG_GPIO_ICH)         += gpio-ich.o
>> +obj-$(CONFIG_GPIO_INTEL_SOC_PMIC)      += gpio-crystalcove.o
>>  obj-$(CONFIG_GPIO_IOP)         += gpio-iop.o
>>  obj-$(CONFIG_GPIO_IT8761E)     += gpio-it8761e.o
>>  obj-$(CONFIG_GPIO_JANZ_TTL)    += gpio-janz-ttl.o
>> diff --git a/drivers/gpio/gpio-crystalcove.c b/drivers/gpio/gpio-crystalcove.c
>> new file mode 100644
>> index 0000000..974f9b8
>> --- /dev/null
>> +++ b/drivers/gpio/gpio-crystalcove.c
>> @@ -0,0 +1,323 @@
>> +/*
>> + * gpio-crystalcove.c - Intel Crystal Cove GPIO Driver
>> + *
>> + * Copyright (C) 2012, 2014 Intel Corporation. All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License version
>> + * 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * Author: Yang, Bin <bin.yang@intel.com>
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/kernel.h>
>> +#include <linux/slab.h>
>> +#include <linux/io.h>
>> +#include <linux/delay.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/device.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/seq_file.h>
>> +#include <linux/sched.h>
>> +#include <linux/mfd/intel_soc_pmic.h>
>> +#include <linux/gpio.h>
>> +
>> +#define NUM_GPIO               16
>> +
>> +#define UPDATE_TYPE            (1 << 0)
>> +#define UPDATE_MASK            (1 << 1)
>> +
>> +#define GPIO0IRQ               0x0b
>> +#define GPIO1IRQ               0x0c
>> +#define MGPIO0IRQS0            0x19
>> +#define MGPIO1IRQS0            0x1a
>> +#define MGPIO0IRQSX            0x1b
>> +#define MGPIO1IRQSX            0x1c
>> +#define GPIO0P0CTLO            0x2b
>> +#define GPIO0P0CTLI            0x33
>> +#define GPIO1P0CTLO            0x3b
>> +#define GPIO1P0CTLI            0x43
>> +
>> +#define CTLI_INTCNT_NE         (1 << 1)
>> +#define CTLI_INTCNT_PE         (2 << 1)
>> +#define CTLI_INTCNT_BE         (3 << 1)
>> +
>> +#define CTLO_DIR_OUT           (1 << 5)
>> +#define CTLO_DRV_CMOS          (0 << 4)
>> +#define CTLO_DRV_OD            (1 << 4)
>> +#define CTLO_DRV_REN           (1 << 3)
>> +#define CTLO_RVAL_2KDW         (0)
>> +#define CTLO_RVAL_2KUP         (1 << 1)
>> +#define CTLO_RVAL_50KDW                (2 << 1)
>> +#define CTLO_RVAL_50KUP                (3 << 1)
>> +
>> +#define CTLO_INPUT_DEF (CTLO_DRV_CMOS | CTLO_DRV_REN | CTLO_RVAL_2KUP)
>> +#define CTLO_OUTPUT_DEF        (CTLO_DIR_OUT | CTLO_INPUT_DEF)
>> +
>> +struct crystalcove_gpio {
>> +       struct mutex            buslock; /* irq_bus_lock */
>> +       struct gpio_chip        chip;
>> +       int                     irq;
>> +       int                     irq_base;
>> +       int                     update;
>> +       int                     trigger_type;
>> +       int                     irq_mask;
>> +};
>> +static struct crystalcove_gpio gpio_info;
>> +
>> +static void __crystalcove_irq_mask(int gpio, int mask)
>> +{
>> +       u8 mirqs0 = gpio < 8 ? MGPIO0IRQS0 : MGPIO1IRQS0;
>> +       int offset = gpio < 8 ? gpio : gpio - 8;
>> +
>> +       if (mask)
>> +               intel_soc_pmic_setb(mirqs0, 1 << offset);
>> +       else
>> +               intel_soc_pmic_clearb(mirqs0, 1 << offset);
>> +}
>> +
>> +static void __crystalcove_irq_type(int gpio, int type)
>> +{
>> +       u8 ctli = gpio < 8 ? GPIO0P0CTLI + gpio : GPIO1P0CTLI + (gpio - 8);
> 
> Not a big comment, but wouldn't it be safer to factorize this logic
> (which is repeated in many places) into some macro? e.g. something
> like:
> 
> #define GPIOP0CTL(gpio, dir) ((gpio < 8 ? GPIO0P0CTL ## dir :
> GPIO1P0CTL ## dir) + (gpio & ~0x8))
> 
> ...
> 
> u8 ctli = GPIOP0CTL(gpio, I);
> 
> Feel free to come with a better macro (or to ignore that comment
> altogether if you think it makes the code less readable), but I think
> it would be less error-prone if you did not have to copy-paste that
> code all over the place.
> 

Thank you. I'll fix them in v2 as well.

Best Regards
Lejun

