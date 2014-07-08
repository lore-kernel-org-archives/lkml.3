Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbaGHXUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 19:20:35 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:46500 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaGHXUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 19:20:31 -0400
Message-ID: <53BC7CBD.2060901@codeaurora.org>
Date: Tue, 08 Jul 2014 16:20:29 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
CC: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/3] mfd: pm8921: Expose pm8xxx_read_irq_status
References: <1404782785-1824-1-git-send-email-bjorn.andersson@sonymobile.com> <1404782785-1824-2-git-send-email-bjorn.andersson@sonymobile.com>
In-Reply-To: <1404782785-1824-2-git-send-email-bjorn.andersson@sonymobile.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/14 18:26, Bjorn Andersson wrote:
> @@ -65,6 +66,41 @@ struct pm_irq_chip {
>  	u8			config[0];
>  };
>  
> +int pm8xxx_read_irq_status(int irq)
> +{
> +	struct irq_data *d = irq_get_irq_data(irq);
> +	struct pm_irq_chip *chip = irq_data_get_irq_chip_data(d);
> +	unsigned int pmirq = irqd_to_hwirq(d);
> +	unsigned int bits;
> +	int irq_bit;
> +	u8 block;
> +	int rc;
> +
> +	if (!chip) {
> +		pr_err("Failed to resolve pm_irq_chip\n");
> +		return -EINVAL;
> +	}

Is this actually necessary? Presumably the driver wouldn't have even
probed unless there was a pmic to begin with.

> +
> +	block = pmirq / 8;
> +	irq_bit = pmirq % 8;
> +
> +	spin_lock(&chip->pm_irq_lock);
> +	rc = regmap_write(chip->regmap, SSBI_REG_ADDR_IRQ_BLK_SEL, block);
> +	if (rc) {
> +		pr_err("Failed Selecting Block %d rc=%d\n", block, rc);
> +		goto bail;
> +	}
> +
> +	rc = regmap_read(chip->regmap, SSBI_REG_ADDR_IRQ_RT_STATUS, &bits);
> +	if (rc)
> +		pr_err("Failed Reading Status rc=%d\n", rc);
> +bail:
> +	spin_unlock(&chip->pm_irq_lock);
> +
> +	return rc ? rc : !!(bits & BIT(irq_bit));
> +}
> +EXPORT_SYMBOL(pm8xxx_read_irq_status);
> +
>  static int pm8xxx_read_block_irq(struct pm_irq_chip *chip, unsigned int bp,
>  				 unsigned int *ip)
>  {
> diff --git a/include/linux/mfd/pm8921-core.h b/include/linux/mfd/pm8921-core.h
> new file mode 100644
> index 0000000..77f7cb5
> --- /dev/null
> +++ b/include/linux/mfd/pm8921-core.h
> @@ -0,0 +1,32 @@
> +/*
> + * Copyright (c) 2014, Sony Mobile Communications AB
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
> +#ifndef __MFD_PM8921_CORE_H
> +#define __MFD_PM8921_CORE_H
> +
> +#include <linux/err.h>
> +
> +#ifdef CONFIG_MFD_PM8921_CORE
> +
> +int pm8xxx_read_irq_status(int irq);
> +
> +#else
> +
> +static inline int pm8xxx_read_irq_status(int irq)
> +{
> +	return -ENOSYS;
> +}
> +
> +#endif

Sad, the header file came back. I guess there isn't a way to put the
pinctrl driver inside the core mfd driver? Then we wouldn't need to
expose an "irq read line" function.

Actually Abhijeet proposed such an API in 2011 but it didn't go
anywhere[1]. If we had that API we should be able to call
read_irq_line() from the pinctrl driver whenever we want to get the
state of the gpio, plus the API is generic. We're going to need that API
anyway for things like USB insertion detection so it might make sense to
add it sooner rather than later.

[1]
http://lists.infradead.org/pipermail/linux-arm-kernel/2011-April/048319.html

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

