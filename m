Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374AbbAHVWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 16:22:11 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:40880 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757325AbbAHVWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 16:22:08 -0500
Date: Thu, 8 Jan 2015 13:22:03 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Moritz Fischer <moritz.fischer@ettus.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] input: misc: Support NI Ettus Research USRP E3x0
 Button
Message-ID: <20150108212203.GA23256@dtor-ws>
References: <1420750971-21812-1-git-send-email-moritz.fischer@ettus.com>
 <1420750971-21812-2-git-send-email-moritz.fischer@ettus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420750971-21812-2-git-send-email-moritz.fischer@ettus.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 10:02:49PM +0100, Moritz Fischer wrote:
> Signed-off-by: Moritz Fischer <moritz.fischer@ettus.com>
> ---
>  drivers/input/misc/Kconfig       |  10 +++
>  drivers/input/misc/Makefile      |   1 +
>  drivers/input/misc/e3x0-button.c | 153 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 164 insertions(+)
> 
> diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
> index 23297ab..84a56b4 100644
> --- a/drivers/input/misc/Kconfig
> +++ b/drivers/input/misc/Kconfig
> @@ -93,6 +93,16 @@ config INPUT_BMA150
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called bma150.
>  
> +config INPUT_E3X0_BUTTON
> +	tristate "NI Ettus Research USRP E3x0 Button support."
> +	default n
> +	help
> +	  Say Y here to enable support for the NI Ettus Research
> +	  USRP E3x0 Button.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called e3x0_button.
> +
>  config INPUT_PCSPKR
>  	tristate "PC Speaker support"
>  	depends on PCSPKR_PLATFORM
> diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
> index 19c7603..b1775a5 100644
> --- a/drivers/input/misc/Makefile
> +++ b/drivers/input/misc/Makefile
> @@ -26,6 +26,7 @@ obj-$(CONFIG_INPUT_COBALT_BTNS)		+= cobalt_btns.o
>  obj-$(CONFIG_INPUT_DA9052_ONKEY)	+= da9052_onkey.o
>  obj-$(CONFIG_INPUT_DA9055_ONKEY)	+= da9055_onkey.o
>  obj-$(CONFIG_INPUT_DM355EVM)		+= dm355evm_keys.o
> +obj-$(CONFIG_INPUT_E3X0_BUTTON)		+= e3x0-button.o
>  obj-$(CONFIG_INPUT_DRV260X_HAPTICS)	+= drv260x.o
>  obj-$(CONFIG_INPUT_DRV2667_HAPTICS)	+= drv2667.o
>  obj-$(CONFIG_INPUT_GP2A)		+= gp2ap002a00f.o
> diff --git a/drivers/input/misc/e3x0-button.c b/drivers/input/misc/e3x0-button.c
> new file mode 100644
> index 0000000..0022f6a
> --- /dev/null
> +++ b/drivers/input/misc/e3x0-button.c
> @@ -0,0 +1,153 @@
> +/*
> + * Copyright (c) 2014, National Instruments Corp. All rights reserved.
> + *
> + * Driver for NI Ettus Research USRP E3x0 Button Driver
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/device.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/input.h>
> +#include <linux/interrupt.h>
> +#include <linux/of.h>
> +#include <linux/slab.h>
> +
> +/**
> + * struct e3x0_button - e3x0 button information
> + * @input_dev: pointer to input device
> + * @irq_press: irq number for press event
> + * @irq_release: irq number for release event
> + */
> +struct e3x0_button {
> +	struct input_dev	*idev;
> +	int			irq_press;
> +	int			irq_release;
> +};
> +
> +static irqreturn_t e3x0_button_handler(int irq, void *data)
> +{
> +	struct e3x0_button *button = data;
> +
> +	if (irq == button->irq_press)
> +		input_report_key(button->idev, KEY_POWER, 1);
> +	else if (irq == button->irq_release)
> +		input_report_key(button->idev, KEY_POWER, 0);

Hmm, if you create a separate IRSs for press and release you would not
need to store irq_press and irq_release and consequently would not have
to use/allocate e3x0_button structure at all (unless you are planning to
expand the driver later).

> +
> +	input_sync(button->idev);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int e3x0_button_probe(struct platform_device *pdev)
> +{
> +	struct e3x0_button *button;
> +	struct input_dev *input;
> +	int irq_press, irq_release;
> +	int error;
> +
> +	irq_press = platform_get_irq_byname(pdev, "press");
> +	if (irq_press < 0) {
> +		dev_err(&pdev->dev, "No IRQ for 'press', error=%d\n",
> +			irq_press);
> +		return irq_press;
> +	}
> +
> +	irq_release = platform_get_irq_byname(pdev, "release");
> +	if (irq_release < 0) {
> +		dev_err(&pdev->dev, "No IRQ for 'release', error=%d\n",
> +			irq_release);
> +		return irq_release;
> +	}
> +
> +	button = devm_kzalloc(&pdev->dev, sizeof(*button),
> +			      GFP_KERNEL);
> +	if (!button)
> +		return -ENOMEM;
> +
> +	input = devm_input_allocate_device(&pdev->dev);
> +	if (!input)
> +		return -ENOMEM;
> +
> +	button->idev = input;
> +	button->irq_press = irq_press;
> +	button->irq_release = irq_release;
> +
> +	input->name = "NI Ettus Research USRP E3x0 Button Driver";
> +	input->phys = "e3x0_button/input0";
> +	input->dev.parent = &pdev->dev;
> +
> +	input_set_capability(input, EV_KEY, KEY_POWER);
> +
> +	error = devm_request_irq(&pdev->dev, button->irq_press,
> +					     e3x0_button_handler, 0,
> +					     "e3x0-button", button);
> +	if (error < 0) {
> +		dev_err(&pdev->dev, "Failed to request 'press' IRQ#%d: %d\n",
> +			button->irq_press, error);
> +		return error;
> +	}
> +
> +	error = devm_request_irq(&pdev->dev, button->irq_release,
> +					     e3x0_button_handler, 0,
> +					     "e3x0-button", button);
> +	if (error < 0) {
> +		dev_err(&pdev->dev, "Failed to request 'release' IRQ#%d: %d\n",
> +			button->irq_release, error);
> +		return error;
> +	}
> +
> +	error = input_register_device(button->idev);
> +	if (error) {
> +		dev_err(&pdev->dev, "Can't register input device: %d\n", error);
> +		return error;
> +	}
> +
> +	platform_set_drvdata(pdev, button);
> +	return 0;
> +}
> +
> +#ifdef CONFIG_OF
> +static const struct of_device_id e3x0_button_match[] = {
> +	{ .compatible = "ettus,e3x0-button", },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(of, e3x0_button_match);
> +#endif
> +
> +static struct platform_driver e3x0_button_driver = {
> +	.driver		= {
> +		.name	= "e3x0-button",
> +		.owner	= THIS_MODULE,

No need to set up owner explicitly - it is down automatically.

> +		.of_match_table = of_match_ptr(e3x0_button_match),
> +	},
> +	.probe		= e3x0_button_probe,
> +};
> +
> +static int __init e3x0_button_init(void)
> +{
> +	pr_info("e3x0-button: Copyright (c) 2014 National Instruments Corp");

Let's drop this message and use module_platform_driver() instead of
custom init/exit implementations.

> +	return platform_driver_register(&e3x0_button_driver);
> +}
> +
> +static void e3x0_button_exit(void)
> +{
> +	platform_driver_unregister(&e3x0_button_driver);
> +}
> +
> +module_init(e3x0_button_init);
> +module_exit(e3x0_button_exit);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("Moritz Fischer <moritz.fischer@ettus.com>");
> +MODULE_DESCRIPTION("NI Ettus Research USRP E3x0 Button driver");
> +MODULE_ALIAS("platform:e3x0-button");
> -- 
> 1.9.3
> 

By the way, don't you need to set up this device as a wakeup source?

Thanks.

-- 
Dmitry
