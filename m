Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964805AbaFIXHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 19:07:52 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:50212 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933659AbaFIXHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 19:07:49 -0400
Message-ID: <53963E3F.2090607@collabora.co.uk>
Date: Tue, 10 Jun 2014 01:07:43 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
CC: Lee Jones <lee.jones@linaro.org>, Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        linux-samsung-soc@vger.kernel.org,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Mark Brown <broonie@kernel.org>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org,
        Daniel Stone <daniels@collabora.com>
Subject: Re: [PATCH 1/5] mfd: Add driver for Maxim 77802 Power Management
 IC
References: <1402306670-17041-1-git-send-email-javier.martinez@collabora.co.uk> <1402306670-17041-2-git-send-email-javier.martinez@collabora.co.uk> <1402309361.17650.14.camel@AMDC1943>
In-Reply-To: <1402309361.17650.14.camel@AMDC1943>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

On 06/09/2014 12:22 PM, Krzysztof Kozlowski wrote:
> On pon, 2014-06-09 at 11:37 +0200, Javier Martinez Canillas wrote:
>> Maxim MAX77802 is a power management chip that contains 10 high
>> efficiency Buck regulators, 32 Low-dropout (LDO) regulators used
>> to power up application processors and peripherals, a 2-channel
>> 32kHz clock outputs, a Real-Time-Clock (RTC) and a I2C interface
>> to program the individual regulators, clocks outputs and the RTC.
>> 
>> This patch adds the core support for MAX77802 PMIC and is based
>> on a driver added by Simon Glass to the Chrome OS kernel 3.8 tree.
>> 
>> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> 
> (...)
> 
> 
>> diff --git a/drivers/mfd/max77802-irq.c b/drivers/mfd/max77802-irq.c
>> new file mode 100644
>> index 0000000..38a8ce7
>> --- /dev/null
>> +++ b/drivers/mfd/max77802-irq.c
>> @@ -0,0 +1,332 @@
>> +/*
>> + * max77802-irq.c - Interrupt controller support for MAX77802
>> + *
>> + * Copyright (C) 2013-2014 Google, Inc
>> + *
>> + * Copyright (C) 2012 Samsung Electronics Co.Ltd
>> + * Chiwoong Byun <woong.byun@samsung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * This driver is based on max8997-irq.c
>> + */
>> +
>> +#include <linux/err.h>
>> +#include <linux/irq.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/gpio.h>
>> +#include <linux/mfd/max77802.h>
>> +#include <linux/mfd/max77802-private.h>
>> +#include <linux/irqdomain.h>
>> +#include <linux/regmap.h>
>> +
>> +enum {
>> +	MAX77802_DEBUG_IRQ_INFO = 1 << 0,
>> +	MAX77802_DEBUG_IRQ_MASK = 1 << 1,
>> +	MAX77802_DEBUG_IRQ_INT = 1 << 2,
>> +};
>> +
>> +static int debug_mask = 0;
>> +module_param(debug_mask, int, 0);
>> +MODULE_PARM_DESC(debug_mask, "Set debug_mask : 0x0=off 0x1=IRQ_INFO  0x2=IRQ_MASK 0x4=IRQ_INI)");
>> +
>> +static const u8 max77802_mask_reg[] = {
>> +	[PMIC_INT1] = MAX77802_REG_INT1MSK,
>> +	[PMIC_INT2] = MAX77802_REG_INT2MSK,
>> +	[RTC_INT] = MAX77802_RTC_INTM,
>> +};
>> +
>> +struct max77802_irq_data {
>> +	int mask;
>> +	enum max77802_irq_source group;
>> +};
>> +
>> +#define DECLARE_IRQ(idx, _group, _mask)		\
>> +	[(idx)] = { .group = (_group), .mask = (_mask) }
>> +static const struct max77802_irq_data max77802_irqs[] = {
>> +	DECLARE_IRQ(MAX77802_PMICIRQ_PWRONF,	PMIC_INT1, 1 << 0),
>> +	DECLARE_IRQ(MAX77802_PMICIRQ_PWRONR,	PMIC_INT1, 1 << 1),
>> +	DECLARE_IRQ(MAX77802_PMICIRQ_JIGONBF,	PMIC_INT1, 1 << 2),
>> +	DECLARE_IRQ(MAX77802_PMICIRQ_JIGONBR,	PMIC_INT1, 1 << 3),
>> +	DECLARE_IRQ(MAX77802_PMICIRQ_ACOKBF,	PMIC_INT1, 1 << 4),
>> +	DECLARE_IRQ(MAX77802_PMICIRQ_ACOKBR,	PMIC_INT1, 1 << 5),
>> +	DECLARE_IRQ(MAX77802_PMICIRQ_ONKEY1S,	PMIC_INT1, 1 << 6),
>> +	DECLARE_IRQ(MAX77802_PMICIRQ_MRSTB,		PMIC_INT1, 1 << 7),
>> +	DECLARE_IRQ(MAX77802_PMICIRQ_140C,		PMIC_INT2, 1 << 0),
>> +	DECLARE_IRQ(MAX77802_PMICIRQ_120C,		PMIC_INT2, 1 << 1),
>> +	DECLARE_IRQ(MAX77802_RTCIRQ_RTC60S,		RTC_INT, 1 << 0),
>> +	DECLARE_IRQ(MAX77802_RTCIRQ_RTCA1,		RTC_INT, 1 << 1),
>> +	DECLARE_IRQ(MAX77802_RTCIRQ_RTCA2,		RTC_INT, 1 << 2),
>> +	DECLARE_IRQ(MAX77802_RTCIRQ_SMPL,		RTC_INT, 1 << 3),
>> +	DECLARE_IRQ(MAX77802_RTCIRQ_RTC1S,		RTC_INT, 1 << 4),
>> +	DECLARE_IRQ(MAX77802_RTCIRQ_WTSR,		RTC_INT, 1 << 5),
>> +};
> 
> Why just not use two regmap_irq_chips (for PMIC and RTC blocks)
> replacing whole max77802-irq.c file?
>

Great, I was not aware about regmap_irq_chip. I'll take a look to it for v2.

> Best regards,
> Krzysztof
> 
> 

Best regards,
Javier
