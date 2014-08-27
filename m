Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964830AbaH0SCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 14:02:49 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:53548 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935400AbaH0SCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 14:02:47 -0400
MIME-Version: 1.0
In-Reply-To: <53FD452F.7050609@roeck-us.net>
References: <1409096705-24290-1-git-send-email-davidriley@chromium.org>
	<1409096705-24290-2-git-send-email-davidriley@chromium.org>
	<53FD452F.7050609@roeck-us.net>
Date: Wed, 27 Aug 2014 11:02:45 -0700
Message-ID: <CAASgrz1CCDs8fUM_xKDacB2=aNDuoouQXmyvBkCV+0rjHgGuhQ@mail.gmail.com>
Subject: Re: [PATCH v1 1/1] power: Add simple gpio-restart driver
From: David Riley <davidriley@google.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Anton Vorontsov <anton@enomsg.org>,
        Marc Carino <marc.ceeeee@gmail.com>, Anders Berg <anders.berg@lsi.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Jamie Lentin <jm@lentin.co.uk>, Doug Anderson <dianders@chromium.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 7:40 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> On 08/26/2014 04:45 PM, David Riley wrote:
>>
>> This driver registers a restart handler to set a GPIO line high/low
>> to reset a board based on devicetree bindings.
>>
>> Signed-off-by: David Riley <davidriley@chromium.org>
>> ---
>>   .../devicetree/bindings/gpio/gpio-restart.txt      |  48 +++++++
>>   drivers/power/reset/Kconfig                        |   8 ++
>>   drivers/power/reset/Makefile                       |   1 +
>>   drivers/power/reset/gpio-restart.c                 | 142
>> +++++++++++++++++++++
>>   4 files changed, 199 insertions(+)
>>   create mode 100644
>> Documentation/devicetree/bindings/gpio/gpio-restart.txt
>>   create mode 100644 drivers/power/reset/gpio-restart.c
>>
>> diff --git a/Documentation/devicetree/bindings/gpio/gpio-restart.txt
>> b/Documentation/devicetree/bindings/gpio/gpio-restart.txt
>> new file mode 100644
>> index 0000000..7cd58788
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/gpio/gpio-restart.txt
>> @@ -0,0 +1,48 @@
>> +Driver a GPIO line that can be used to restart the system as a
>> +restart handler.
>> +
>> +The driver supports both level triggered and edge triggered power off.
>> +At driver load time, the driver will request the given gpio line and
>> +install a restart handler. If the optional properties 'input' is
>> +not found, the GPIO line will be driven in the inactive state.
>> +Otherwise its configured as an input.
>> +
>> +When do_kernel_restart is called the various restart handlers will be
>> tried
>> +in order.  The gpio is configured as an output, and drive active, so
>> +triggering a level triggered power off condition. This will also cause an
>> +inactive->active edge condition, so triggering positive edge triggered
>> +power off. After a delay of 100ms, the GPIO is set to inactive, thus
>> +causing an active->inactive edge, triggering negative edge triggered
>> power
>> +off. After another 100ms delay the GPIO is driver active again. If the
>> +power is still on and the CPU still running after a 3000ms delay, a
>> +WARN_ON(1) is emitted.
>> +
>> +Required properties:
>> +- compatible : should be "gpio-restart".
>> +- gpios : The GPIO to set high/low, see "gpios property" in
>> +  Documentation/devicetree/bindings/gpio/gpio.txt. If the pin should be
>> +  low to power down the board set it to "Active Low", otherwise set
>> +  gpio to "Active High".
>> +
>> +Optional properties:
>> +- input : Initially configure the GPIO line as an input. Only reconfigure
>> +  it to an output when the machine_restart function is called. If this
>> optional
>> +  property is not specified, the GPIO is initialized as an output in its
>> +  inactive state.
>
>
> Maybe describe this as open source ?

Done.

>> +- priority : A priority ranging from 0 to 255 (default 128) according to
>> +  the following guidelines:
>> +       0:      Restart handler of last resort, with limited restart
>> +               capabilities
>> +       128:    Default restart handler; use if no other restart handler
>> is
>> +               expected to be available, and/or if restart functionality
>> is
>> +               sufficient to restart the entire system
>> +       255:    Highest priority restart handler, will preempt all other
>> +               restart handlers
>> +
>> +Examples:
>> +
>> +gpio-restart {
>> +       compatible = "gpio-restart";
>> +       gpios = <&gpio 4 0>;
>> +       priority = /bits/ 8 <200>;
>> +};
>> diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
>> index ca41523..f07e26c 100644
>> --- a/drivers/power/reset/Kconfig
>> +++ b/drivers/power/reset/Kconfig
>> @@ -39,6 +39,14 @@ config POWER_RESET_GPIO
>>           If your board needs a GPIO high/low to power down, say Y and
>>           create a binding in your devicetree.
>>
>> +config POWER_RESET_GPIO_RESTART
>> +       bool "GPIO restart driver"
>> +       depends on OF_GPIO && POWER_RESET
>> +       help
>> +         This driver supports restarting your board via a GPIO line.
>> +         If your board needs a GPIO high/low to restart, say Y and
>> +         create a binding in your devicetree.
>> +
>>   config POWER_RESET_HISI
>>         bool "Hisilicon power-off driver"
>>         depends on POWER_RESET && ARCH_HISI
>> diff --git a/drivers/power/reset/Makefile b/drivers/power/reset/Makefile
>> index a42e70e..199cb6e 100644
>> --- a/drivers/power/reset/Makefile
>> +++ b/drivers/power/reset/Makefile
>> @@ -2,6 +2,7 @@ obj-$(CONFIG_POWER_RESET_AS3722) += as3722-poweroff.o
>>   obj-$(CONFIG_POWER_RESET_AXXIA) += axxia-reset.o
>>   obj-$(CONFIG_POWER_RESET_BRCMSTB) += brcmstb-reboot.o
>>   obj-$(CONFIG_POWER_RESET_GPIO) += gpio-poweroff.o
>> +obj-$(CONFIG_POWER_RESET_GPIO_RESTART) += gpio-restart.o
>>   obj-$(CONFIG_POWER_RESET_HISI) += hisi-reboot.o
>>   obj-$(CONFIG_POWER_RESET_MSM) += msm-poweroff.o
>>   obj-$(CONFIG_POWER_RESET_QNAP) += qnap-poweroff.o
>> diff --git a/drivers/power/reset/gpio-restart.c
>> b/drivers/power/reset/gpio-restart.c
>> new file mode 100644
>> index 0000000..2cbff64
>> --- /dev/null
>> +++ b/drivers/power/reset/gpio-restart.c
>> @@ -0,0 +1,142 @@
>> +/*
>> + * Toggles a GPIO pin to restart a device
>> + *
>> + * Copyright (C) 2014 Google, Inc.
>> + *
>> + * This software is licensed under the terms of the GNU General Public
>> + * License version 2, as published by the Free Software Foundation, and
>> + * may be copied, distributed, and modified under those terms.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * Based on the gpio-poweroff driver.
>> + */
>> +#include <linux/reboot.h>
>> +#include <linux/kernel.h>
>> +#include <linux/init.h>
>> +#include <linux/delay.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/gpio/consumer.h>
>> +#include <linux/of_platform.h>
>> +#include <linux/module.h>
>> +
>> +struct gpio_restart {
>> +       struct gpio_desc *reset_gpio;
>> +       struct notifier_block restart_handler;
>> +};
>> +
>> +static int gpio_restart_notify(struct notifier_block *this,
>> +                               unsigned long mode, void *cmd)
>> +{
>> +       struct gpio_restart *gpio_restart =
>> +               container_of(this, struct gpio_restart, restart_handler);
>> +
>> +       BUG_ON(!gpio_restart->reset_gpio);
>> +
>
> Is this really necessary ? First, it can't really happen,
> but if it happens anyway I am not sure if there might be
> a possibility for recursiveness. After all, this is called
> from machine_restart().

I've removed it.

>> +       /* drive it active, also inactive->active edge */
>> +       gpiod_direction_output(gpio_restart->reset_gpio, 1);
>> +       mdelay(100);
>> +
>> +       /* drive inactive, also active->inactive edge */
>> +       gpiod_set_value(gpio_restart->reset_gpio, 0);
>> +       mdelay(100);
>> +
>> +       /* drive it active, also inactive->active edge */
>> +       gpiod_set_value(gpio_restart->reset_gpio, 1);
>> +
>> +       /* give it some time */
>> +       mdelay(3000);
>> +
>
> Should those delays be parameters ?

Done.

>
>
>> +       WARN_ON(1);
>> +
>> +       return NOTIFY_DONE;
>> +}
>> +
>> +static int gpio_restart_probe(struct platform_device *pdev)
>> +{
>> +       struct gpio_restart *gpio_restart;
>> +       bool input = false;
>> +       u8 priority;
>> +       int ret;
>> +
>> +       gpio_restart = devm_kzalloc(&pdev->dev, sizeof(*gpio_restart),
>> +                       GFP_KERNEL);
>> +       if (!gpio_restart)
>> +               return -ENOMEM;
>> +
>> +       gpio_restart->reset_gpio = devm_gpiod_get(&pdev->dev, NULL);
>> +       if (IS_ERR(gpio_restart->reset_gpio))
>> +               return PTR_ERR(gpio_restart->reset_gpio);
>> +
>
> There is now a flags parameter to devm_gpiod_get which should help
> handling input/output with a single call.

Done.

>
>> +       gpio_restart->restart_handler.notifier_call = gpio_restart_notify;
>> +       gpio_restart->restart_handler.priority = 128;
>> +
>> +       platform_set_drvdata(pdev, gpio_restart);
>> +
>> +       input = of_property_read_bool(pdev->dev.of_node, "input");
>> +       if (input) {
>> +               if (gpiod_direction_input(gpio_restart->reset_gpio)) {
>> +                       dev_err(&pdev->dev,
>> +                               "Could not set direction of reset GPIO to
>> input\n");
>> +                       return -ENODEV;
>> +               }
>> +       } else {
>> +               if (gpiod_direction_output(gpio_restart->reset_gpio, 0)) {
>> +                       dev_err(&pdev->dev,
>> +                               "Could not set direction of reset
>> GPIO\n");
>> +                       return -ENODEV;
>> +               }
>> +       }
>> +
>> +       if (!of_property_read_u8(pdev->dev.of_node, "priority",
>> &priority))
>> +               gpio_restart->restart_handler.priority = priority;
>> +
>> +       ret = register_restart_handler(&gpio_restart->restart_handler);
>> +       if (ret) {
>> +               dev_err(&pdev->dev, "%s: cannot register restart handler,
>> %d\n",
>> +                               __func__, ret);
>> +               return -ENODEV;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static int gpio_restart_remove(struct platform_device *pdev)
>> +{
>> +       struct gpio_restart *gpio_restart = platform_get_drvdata(pdev);
>> +       int ret;
>> +
>> +       ret = unregister_restart_handler(&gpio_restart->restart_handler);
>> +       if (ret) {
>> +               dev_err(&pdev->dev,
>> +                               "%s: cannot unregister restart handler,
>> %d\n",
>> +                               __func__, ret);
>> +               return -ENODEV;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static const struct of_device_id of_gpio_restart_match[] = {
>> +       { .compatible = "gpio-restart", },
>> +       {},
>> +};
>> +
>> +static struct platform_driver gpio_restart_driver = {
>> +       .probe = gpio_restart_probe,
>> +       .remove = gpio_restart_remove,
>> +       .driver = {
>> +               .name = "restart-gpio",
>> +               .owner = THIS_MODULE,
>> +               .of_match_table = of_gpio_restart_match,
>> +       },
>> +};
>> +
>> +module_platform_driver(gpio_restart_driver);
>> +
>> +MODULE_AUTHOR("David Riley <davidriley@chromium.org>");
>> +MODULE_DESCRIPTION("GPIO restart driver");
>> +MODULE_LICENSE("GPL");
>>
>
