Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbaBQJ5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:57:44 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:64067 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbaBQJ5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:57:41 -0500
Date: Mon, 17 Feb 2014 09:57:34 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Milo Kim <milo.kim@ti.com>
Cc: Jingoo Han <jg1.han@samsung.com>, Bryan Wu <cooloney@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 01/10] mfd: Add TI LMU driver
Message-ID: <20140217095734.GD17875@lee--X1>
References: <1392359450-6890-1-git-send-email-milo.kim@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392359450-6890-1-git-send-email-milo.kim@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> TI LMU (Lighting Management Unit) driver supports lighting devices such like
> LM3532, LM3631, LM3633, LM3695 and LM3697.
> 
> LMU devices has common features as below.
>   - I2C interface for accessing device registers
>   - Hardware enable pin control
>   - Backlight brightness control
>   - Light effect driver for backlight and LED patterns
> 
> It contains backlight, light effect, LED and regulator driver.
> 
> Backlight
> ---------
>   It's handled by TI LMU backlight common driver and chip dependent driver.
>   Please refer to separate patches for ti-lmu-backlight.
> 
> Light effect
> ------------
>   LMU effect driver is used for setting any light effects.
>   Each device has specific time value and register map.
>   Backlight and LED driver can use consitent APIs for light effects.
> 
>   There are two lists for effect management. LMU effect list and pending list.
>   Light effect list is added when ti-lmu-effect driver is loaded by referencing
>   platform resource data.
>   However, it can be a problem because some LMU device requests the effect
>   in advance of loading ti-lmu-effect driver.
> 
>   For example, LM3532 backlight driver requests light ramp effects before
>   ti-lmu-effect is loaded.
>   Then, requested effect can not be handled because it doesn't exist in the list.
>   To solve this situation, pending request list is used.
>   If requested effect is not in the list, just insert it into the pending list.
>   And then pending request is handled as soon as the effect is added.
> 
> LED indicator
> -------------
>   LM3633 has 6 indicator LEDs. Programmable pattern is supported.
> 
> Regulator
> ---------
>   LM3631 has 5 regulators for the display bias.
> 
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Milo Kim <milo.kim@ti.com>
> ---
>  drivers/mfd/Kconfig                 |   12 +
>  drivers/mfd/Makefile                |    1 +
>  drivers/mfd/ti-lmu-effect.c         |  328 +++++++++++++++++++++++++
>  drivers/mfd/ti-lmu.c                |  464 +++++++++++++++++++++++++++++++++++
>  include/linux/mfd/ti-lmu-effect.h   |  109 ++++++++
>  include/linux/mfd/ti-lmu-register.h |  269 ++++++++++++++++++++
>  include/linux/mfd/ti-lmu.h          |  150 +++++++++++
>  7 files changed, 1333 insertions(+)
>  create mode 100644 drivers/mfd/ti-lmu-effect.c
>  create mode 100644 drivers/mfd/ti-lmu.c
>  create mode 100644 include/linux/mfd/ti-lmu-effect.h
>  create mode 100644 include/linux/mfd/ti-lmu-register.h
>  create mode 100644 include/linux/mfd/ti-lmu.h

<snip>

> +static u8 ti_lmu_effect_get_ramp_index(struct ti_lmu_effect *lmu_effect,
> +				       int msec)
> +{
> +	const int *table = NULL;
> +	int size = 0;
> +	int index = 0;
> +	int i;
> +
> +	switch (lmu_effect->lmu->id) {
> +	case LM3532:
> +		table = lm3532_ramp_table;
> +		size = ARRAY_SIZE(lm3532_ramp_table);
> +		break;
> +	case LM3631:
> +		table = lm3631_ramp_table;
> +		size = ARRAY_SIZE(lm3631_ramp_table);
> +		break;
> +	case LM3633:
> +	case LM3697:	/* LM3697 has same ramp table as LM3633 */
> +		table = lm3633_ramp_table;
> +		size = ARRAY_SIZE(lm3633_ramp_table);
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	if (msec <= table[0]) {
> +		index = 0;
> +		goto out;

Just:
  return 0;

> +	}
> +
> +	if (msec >= table[size-1]) {
> +		index = size - 1;
> +		goto out;

Just:
  return index;

> +	}
> +
> +	/* Find appropriate register index from the table */
> +	for (i = 1; i < size; i++) {
> +		if (msec >= table[i-1] && msec < table[i]) {
> +			index = i - 1;
> +			goto out;

Same here.

> +		}
> +	}
> +
> +	return 0;
> +out:
> +	return index;

Remove this.

> +}
> +
> +static u8 ti_lmu_effect_get_time_index(struct ti_lmu_effect *lmu_effect,
> +				       int msec)
> +{
> +	u8 idx, offset;
> +
> +	/*
> +	 * Find appropriate register index around input time value
> +	 *
> +	 *      0 <= time <= 1000 : 16ms step
> +	 *   1000 <  time <= 9700 : 131ms step, base index is 61
> +	 */
> +
> +	msec = min_t(int, msec, LMU_EFFECT_MAX_TIME_PERIOD);
> +
> +	if (msec >= 0 && msec <= 1000) {
> +		idx = msec / 16;
> +		if (idx > 1)
> +			idx--;
> +		offset = 0;
> +	} else {
> +		idx = (msec - 1000) / 131;
> +		offset = 61;

What are 131 and 61? Sounds like magic, require #defines or at least a
comment.

<snip>

> +	if (lmu_effect) {
> +		cbfunc(lmu_effect, req_id, data);
> +		goto out;

This doesn't do anything. Just return from here.

> +	}

<snip>

> +out:
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ti_lmu_effect_request);

<snip>

> diff --git a/drivers/mfd/ti-lmu.c b/drivers/mfd/ti-lmu.c
> new file mode 100644
> index 0000000..e97d686
> --- /dev/null
> +++ b/drivers/mfd/ti-lmu.c
> @@ -0,0 +1,464 @@
> +/*
> + * TI LMU(Lighting Management Unit) Core Driver
> + *
> + * Copyright 2014 Texas Instruments
> + *
> + * Author: Milo Kim <milo.kim@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.

Move this to the bottom of the header.

> + * LMU MFD supports LM3532, LM3631, LM3633, LM3695 and LM3697.
> + *
> + *   LM3532: backlight + light effect
> + *   LM3631: backlight + light effect + regulators
> + *   LM3633: backlight + light effect + LED indicators
> + *   LM3695: backlight
> + *   LM3697: backlight + light effect
> + *
> + * Those devices have common features as below.
> + *
> + *   - I2C interface for accessing device registers
> + *   - Hardware enable pin control
> + *   - Backlight brightness control with current settings
> + *   - Light effect driver for backlight and LED patterns
> + */

kernel.h?
module.h?

> +#include <linux/delay.h>
> +#include <linux/err.h>
> +#include <linux/gpio.h>
> +#include <linux/i2c.h>
> +#include <linux/mfd/core.h>
> +#include <linux/mfd/ti-lmu.h>
> +#include <linux/mfd/ti-lmu-effect.h>
> +#include <linux/mfd/ti-lmu-register.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_gpio.h>
> +#include <linux/slab.h>
> +
> +#define LMU_IMAX_OFFSET		6
> +

<snip>

> +static const struct resource lm3633_effect_resources[] = {
> +	{
> +		.name  = LM3633_EFFECT_BL0_RAMPUP,
> +		.flags = IORESOURCE_REG,
> +		.start = LM3633_EFFECT_REGISTER(BL0_RAMPUP),
> +	},
> +	{
> +		.name  = LM3633_EFFECT_BL0_RAMPDOWN,
> +		.flags = IORESOURCE_REG,
> +		.start = LM3633_EFFECT_REGISTER(BL0_RAMPDN),
> +	},
> +	{
> +		.name  = LM3633_EFFECT_BL1_RAMPUP,
> +		.flags = IORESOURCE_REG,
> +		.start = LM3633_EFFECT_REGISTER(BL1_RAMPUP),
> +	},
> +	{
> +		.name  = LM3633_EFFECT_BL1_RAMPDOWN,
> +		.flags = IORESOURCE_REG,
> +		.start = LM3633_EFFECT_REGISTER(BL1_RAMPDN),
> +	},
> +	{
> +		.name  = LM3633_EFFECT_PTN_DELAY,
> +		.flags = IORESOURCE_REG,
> +		.start = LM3633_EFFECT_REGISTER(DELAY),
> +	},
> +	{
> +		.name  = LM3633_EFFECT_PTN_HIGHTIME,
> +		.flags = IORESOURCE_REG,
> +		.start = LM3633_EFFECT_REGISTER(HIGHTIME),
> +	},
> +	{
> +		.name  = LM3633_EFFECT_PTN_LOWTIME,
> +		.flags = IORESOURCE_REG,
> +		.start = LM3633_EFFECT_REGISTER(LOWTIME),
> +	},
> +	{
> +		.name  = LM3633_EFFECT_PTN0_RAMPUP,
> +		.flags = IORESOURCE_REG,
> +		.start = LM3633_EFFECT_REGISTER(PTN0_RAMPUP),
> +	},
> +	{
> +		.name  = LM3633_EFFECT_PTN0_RAMPDOWN,
> +		.flags = IORESOURCE_REG,
> +		.start = LM3633_EFFECT_REGISTER(PTN0_RAMPDN),
> +	},
> +	{
> +		.name  = LM3633_EFFECT_PTN1_RAMPUP,
> +		.flags = IORESOURCE_REG,
> +		.start = LM3633_EFFECT_REGISTER(PTN1_RAMPUP),
> +	},
> +	{
> +		.name  = LM3633_EFFECT_PTN1_RAMPDOWN,
> +		.flags = IORESOURCE_REG,
> +		.start = LM3633_EFFECT_REGISTER(PTN1_RAMPDN),
> +	},
> +	{
> +		.name  = LM3633_EFFECT_PTN_LOWBRT,
> +		.flags = IORESOURCE_REG,
> +		.start = LM3633_EFFECT_REGISTER(LOWBRT),
> +	},
> +	{
> +		.name  = LM3633_EFFECT_PTN_HIGHBRT,
> +		.flags = IORESOURCE_REG,
> +		.start = LM3633_EFFECT_REGISTER(HIGHBRT),
> +	},
> +};

Can you define a MACRO to do all of these as one liners?

<snip>

> +static int ti_lmu_parse_dt(struct device *dev, struct ti_lmu *lmu)
> +{

<snip>

> +	pdata->en_gpio = of_get_named_gpio(node, "ti,enable-gpio", 0);

There is a global DT property for this already.

> +static int ti_lmu_probe(struct i2c_client *cl, const struct i2c_device_id *id)
> +{

<snip>

> +	lmu->id = id->driver_data;
> +	switch (lmu->id) {
> +	case LM3532:
> +		lmu_regmap_config.max_register = LM3532_MAX_REGISTERS;
> +		break;
> +	case LM3631:
> +		lmu_regmap_config.max_register = LM3631_MAX_REGISTERS;
> +		break;
> +	case LM3633:
> +		lmu_regmap_config.max_register = LM3633_MAX_REGISTERS;
> +		break;
> +	case LM3695:
> +		lmu_regmap_config.max_register = LM3695_MAX_REGISTERS;
> +		break;
> +	case LM3697:
> +		lmu_regmap_config.max_register = LM3697_MAX_REGISTERS;
> +		break;
> +	default:
> +		break;
> +	}

As there are so many of these, it might be nicer to pull these out
into a seperate function.

<snip>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
