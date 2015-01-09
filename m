Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259AbbAIVX0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 16:23:26 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:48698 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758195AbbAIVXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 16:23:03 -0500
MIME-Version: 1.0
In-Reply-To: <20150108225002.GI23256@dtor-ws>
References: <1420756991-16506-1-git-send-email-moritz.fischer@ettus.com>
	<1420756991-16506-2-git-send-email-moritz.fischer@ettus.com>
	<20150108225002.GI23256@dtor-ws>
Date: Fri, 9 Jan 2015 22:23:02 +0100
Message-ID: <CAAtXAHe1DF6vzWAqJEKFNb2FYti47VyzBtJvVejaZy_Ewv4xUQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] input: misc: Support NI Ettus Research USRP E3x0 Button
From: Moritz Fischer <moritz.fischer@ettus.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 8, 2015 at 11:50 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
>
> On Thu, Jan 08, 2015 at 11:43:09PM +0100, Moritz Fischer wrote:
> > Signed-off-by: Moritz Fischer <moritz.fischer@ettus.com>
> > ---
> >  drivers/input/misc/Kconfig       |  10 +++
> >  drivers/input/misc/Makefile      |   1 +
> >  drivers/input/misc/e3x0-button.c | 132 +++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 143 insertions(+)
> >
> > diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
> > index 23297ab..84a56b4 100644
> > --- a/drivers/input/misc/Kconfig
> > +++ b/drivers/input/misc/Kconfig
> > @@ -93,6 +93,16 @@ config INPUT_BMA150
> >         To compile this driver as a module, choose M here: the
> >         module will be called bma150.
> >
> > +config INPUT_E3X0_BUTTON
> > +     tristate "NI Ettus Research USRP E3x0 Button support."
> > +     default n
> > +     help
> > +       Say Y here to enable support for the NI Ettus Research
> > +       USRP E3x0 Button.
> > +
> > +       To compile this driver as a module, choose M here: the
> > +       module will be called e3x0_button.
> > +
> >  config INPUT_PCSPKR
> >       tristate "PC Speaker support"
> >       depends on PCSPKR_PLATFORM
> > diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
> > index 19c7603..b1775a5 100644
> > --- a/drivers/input/misc/Makefile
> > +++ b/drivers/input/misc/Makefile
> > @@ -26,6 +26,7 @@ obj-$(CONFIG_INPUT_COBALT_BTNS)             += cobalt_btns.o
> >  obj-$(CONFIG_INPUT_DA9052_ONKEY)     += da9052_onkey.o
> >  obj-$(CONFIG_INPUT_DA9055_ONKEY)     += da9055_onkey.o
> >  obj-$(CONFIG_INPUT_DM355EVM)         += dm355evm_keys.o
> > +obj-$(CONFIG_INPUT_E3X0_BUTTON)              += e3x0-button.o
> >  obj-$(CONFIG_INPUT_DRV260X_HAPTICS)  += drv260x.o
> >  obj-$(CONFIG_INPUT_DRV2667_HAPTICS)  += drv2667.o
> >  obj-$(CONFIG_INPUT_GP2A)             += gp2ap002a00f.o
> > diff --git a/drivers/input/misc/e3x0-button.c b/drivers/input/misc/e3x0-button.c
> > new file mode 100644
> > index 0000000..0f4e7f3
> > --- /dev/null
> > +++ b/drivers/input/misc/e3x0-button.c
> > @@ -0,0 +1,132 @@
> > +/*
> > + * Copyright (c) 2014, National Instruments Corp. All rights reserved.
> > + *
> > + * Driver for NI Ettus Research USRP E3x0 Button Driver
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; version 2 of the License.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#include <linux/device.h>
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/input.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/of.h>
> > +#include <linux/slab.h>
> > +
> > +static irqreturn_t e3x0_button_release_handler(int irq, void *data)
> > +{
> > +     struct input_dev *idev = data;
> > +
> > +     input_report_key(idev, KEY_POWER, 0);
> > +     input_sync(idev);
> > +
> > +     return IRQ_HANDLED;
> > +}
> > +
> > +static irqreturn_t e3x0_button_press_handler(int irq, void *data)
> > +{
> > +     struct input_dev *idev = data;
> > +
> > +     input_report_key(idev, KEY_POWER, 1);
> > +     input_sync(idev);
> > +
> > +     return IRQ_HANDLED;
> > +}
> > +
> > +static int e3x0_button_probe(struct platform_device *pdev)
> > +{
> > +     struct input_dev *input;
> > +     int irq_press, irq_release;
> > +     int error;
> > +
> > +     irq_press = platform_get_irq_byname(pdev, "press");
> > +     if (irq_press < 0) {
> > +             dev_err(&pdev->dev, "No IRQ for 'press', error=%d\n",
> > +                     irq_press);
> > +             return irq_press;
> > +     }
> > +
> > +     irq_release = platform_get_irq_byname(pdev, "release");
> > +     if (irq_release < 0) {
> > +             dev_err(&pdev->dev, "No IRQ for 'release', error=%d\n",
> > +                     irq_release);
> > +             return irq_release;
> > +     }
> > +
> > +     input = devm_input_allocate_device(&pdev->dev);
> > +     if (!input)
> > +             return -ENOMEM;
> > +
> > +     input->name = "NI Ettus Research USRP E3x0 Button Driver";
> > +     input->phys = "e3x0_button/input0";
> > +     input->dev.parent = &pdev->dev;
> > +
> > +     input_set_capability(input, EV_KEY, KEY_POWER);
> > +
> > +     error = devm_request_irq(&pdev->dev, irq_press,
> > +                                          e3x0_button_press_handler, 0,
> > +                                          "e3x0-button", input);
> > +     if (error < 0) {
> > +             dev_err(&pdev->dev, "Failed to request 'press' IRQ#%d: %d\n",
> > +                     irq_press, error);
> > +             return error;
> > +     }
> > +
> > +     error = devm_request_irq(&pdev->dev, irq_release,
> > +                                          e3x0_button_release_handler, 0,
> > +                                          "e3x0-button", input);
> > +     if (error < 0) {
> > +             dev_err(&pdev->dev, "Failed to request 'release' IRQ#%d: %d\n",
> > +                     irq_release, error);
> > +             return error;
> > +     }
> > +
> > +     error = input_register_device(input);
> > +     if (error) {
> > +             dev_err(&pdev->dev, "Can't register input device: %d\n", error);
> > +             return error;
> > +     }
> > +
> > +     platform_set_drvdata(pdev, input);
> > +     device_init_wakeup(&pdev->dev, 1);
> > +     return 0;
> > +}
> > +
> > +static int e3x0_button_remove(struct platform_device *pdev)
> > +{
> > +     device_init_wakeup(&pdev->dev, 0);
> > +     return 0;
> > +}
> > +
> > +#ifdef CONFIG_OF
> > +static const struct of_device_id e3x0_button_match[] = {
> > +     { .compatible = "ettus,e3x0-button", },
> > +     {}
> > +};
> > +MODULE_DEVICE_TABLE(of, e3x0_button_match);
> > +#endif
> > +
> > +static struct platform_driver e3x0_button_driver = {
> > +     .driver         = {
> > +             .name   = "e3x0-button",
> > +             .of_match_table = of_match_ptr(e3x0_button_match),
> > +     },
> > +     .probe          = e3x0_button_probe,
> > +     .probe          = e3x0_button_remove,
>
> Nope ;)

D'Oh ... sorry about that.

> BTW, I think you need to implement PM ops in the driver and do
>
> |-------if (device_may_wakeup(dev))
> |-------|-------enable_irq_wake(platform_get_irq_byname(pdev, "press"));
>
> in suspend and undo it in resume.

I submitted a v3 including the changes. Please let me know if there's
other stuff that needs fixing.

Thanks for taking the time!

Cheers,

Moritz
