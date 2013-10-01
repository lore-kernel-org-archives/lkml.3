Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab3JAOBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 10:01:20 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:56691 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab3JAOBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 10:01:18 -0400
MIME-Version: 1.0
In-Reply-To: <1380635719-31171-1-git-send-email-zonque@gmail.com>
References: <1380635719-31171-1-git-send-email-zonque@gmail.com>
Date: Tue, 1 Oct 2013 11:01:17 -0300
Message-ID: <CAOMZO5Aq5-bdY3yTD3DqjUVVrTPHZodb7_vfLQcvxfJRXNok4w@mail.gmail.com>
Subject: Re: [PATCH] drivers: misc: add gpio wakeup driver
From: Fabio Estevam <festevam@gmail.com>
To: Daniel Mack <zonque@gmail.com>
Cc: linux-gpio@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Tue, Oct 1, 2013 at 10:55 AM, Daniel Mack <zonque@gmail.com> wrote:
> This patch adds a very simple driver that enables GPIO lines as wakeup
> sources. It only operates on information passed in via DT, and depends

Isn't it the same as the existing 'gpio-key,wakeup' ?

Please see Documentation/devicetree/bindings/gpio/gpio_keys.txt.

Regards,

Fabio Estevam


> on CONFIG_OF && CONFIG_PM_SLEEP. It can for example be used to connect
> wake-on-LAN (WOL) signals or other electric wakeup networks.
>
> The driver accepts a list of GPIO nodes and claims them along with their
> interrupt line. During suspend, the interrupts will be enabled and
> selected as wakeup source. The driver doesn't do anything else with the
> GPIO lines, and will ignore occured interrupts silently.
>
> Signed-off-by: Daniel Mack <zonque@gmail.com>
> ---
>  .../devicetree/bindings/misc/gpio-wakeup.txt       |  16 ++
>  drivers/misc/Kconfig                               |   8 +
>  drivers/misc/Makefile                              |   1 +
>  drivers/misc/gpio-wakeup.c                         | 162 +++++++++++++++++++++
>  4 files changed, 187 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/misc/gpio-wakeup.txt
>  create mode 100644 drivers/misc/gpio-wakeup.c
>
> diff --git a/Documentation/devicetree/bindings/misc/gpio-wakeup.txt b/Documentation/devicetree/bindings/misc/gpio-wakeup.txt
> new file mode 100644
> index 0000000..6aacd0f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/misc/gpio-wakeup.txt
> @@ -0,0 +1,16 @@
> +GPIO WAKEUP DRIVER BINDINGS
> +
> +Required:
> +
> +       compatible:     Must be "gpio-wakeup"
> +       gpios:          At list of GPIO nodes that are enabled as wakeup
> +                       sources.
> +
> +
> +Example:
> +
> +       wake_up {
> +               compatible = "gpio-wakeup";
> +               gpios = <&gpio0 19 0>;
> +       };
> +
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index 8dacd4c..c089280 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -528,6 +528,14 @@ config SRAM
>           the genalloc API. It is supposed to be used for small on-chip SRAM
>           areas found on many SoCs.
>
> +config GPIO_WAKEUP
> +       tristate "GPIO wakeup driver"
> +       depends on PM_SLEEP && OF
> +       help
> +         Say Y to build a driver that can wake up a system from GPIO
> +         lines. See Documentation/devicetree/bindings/gpio-wakeup.txt
> +         for binding details.
> +
>  source "drivers/misc/c2port/Kconfig"
>  source "drivers/misc/eeprom/Kconfig"
>  source "drivers/misc/cb710/Kconfig"
> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> index c235d5b..ee4df84 100644
> --- a/drivers/misc/Makefile
> +++ b/drivers/misc/Makefile
> @@ -53,3 +53,4 @@ obj-$(CONFIG_INTEL_MEI)               += mei/
>  obj-$(CONFIG_VMWARE_VMCI)      += vmw_vmci/
>  obj-$(CONFIG_LATTICE_ECP3_CONFIG)      += lattice-ecp3-config.o
>  obj-$(CONFIG_SRAM)             += sram.o
> +obj-$(CONFIG_GPIO_WAKEUP)      += gpio-wakeup.o
> diff --git a/drivers/misc/gpio-wakeup.c b/drivers/misc/gpio-wakeup.c
> new file mode 100644
> index 0000000..3c1ef88
> --- /dev/null
> +++ b/drivers/misc/gpio-wakeup.c
> @@ -0,0 +1,162 @@
> +/*
> + * Driver to select GPIO lines as wakeup sources from DT.
> + *
> + * Copyright 2013 Daniel Mack
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/module.h>
> +
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
> +#include <linux/pm.h>
> +#include <linux/slab.h>
> +#include <linux/platform_device.h>
> +#include <linux/gpio.h>
> +#include <linux/of_platform.h>
> +#include <linux/of_gpio.h>
> +
> +struct gpio_wakeup_priv {
> +       unsigned int count;
> +       unsigned int irq[0];
> +};
> +
> +static irqreturn_t gpio_wakeup_isr(int irq, void *dev_id)
> +{
> +       return IRQ_HANDLED;
> +}
> +
> +static int gpio_wakeup_probe(struct platform_device *pdev)
> +{
> +       int ret, count, i;
> +       struct gpio_wakeup_priv *priv;
> +       struct device *dev = &pdev->dev;
> +       struct device_node *np = dev->of_node;
> +
> +       if (!np)
> +               return -EINVAL;
> +
> +       count = of_gpio_count(np);
> +       if (count == 0)
> +               return -EINVAL;
> +
> +       priv = devm_kzalloc(dev, sizeof(*priv) +
> +                                sizeof(int) * count, GFP_KERNEL);
> +       if (!priv)
> +               return -ENOMEM;
> +
> +       for (i = 0; i < count; i++) {
> +               unsigned int gpio, irq;
> +
> +               priv->irq[i] = -EINVAL;
> +
> +               gpio = of_get_gpio(np, i);
> +               if (gpio < 0) {
> +                       dev_warn(dev, "Unable to get gpio #%d\n", i);
> +                       continue;
> +               }
> +
> +               irq = gpio_to_irq(gpio);
> +               if (irq < 0) {
> +                       dev_warn(dev, "Can't map GPIO %d to an IRQ\n", gpio);
> +                       continue;
> +               }
> +
> +               ret = devm_gpio_request_one(dev, gpio, GPIOF_IN, pdev->name);
> +               if (ret < 0) {
> +                       dev_warn(dev, "Unable to request GPIO %d: %d\n",
> +                                gpio, ret);
> +                       continue;
> +               }
> +
> +               ret = devm_request_irq(dev, irq, gpio_wakeup_isr,
> +                                      IRQF_TRIGGER_RISING |
> +                                      IRQF_TRIGGER_FALLING,
> +                                      pdev->name, NULL);
> +               if (ret < 0) {
> +                       dev_warn(dev, "Unable to request IRQ %d\n", irq);
> +                       continue;
> +               }
> +
> +               disable_irq(irq);
> +               priv->irq[i] = irq;
> +
> +               dev_info(dev, "Adding GPIO %d (IRQ %d) to wakeup sources\n",
> +                        gpio, irq);
> +       }
> +
> +       priv->count = count;
> +       device_init_wakeup(dev, 1);
> +       platform_set_drvdata(pdev, priv);
> +
> +       return 0;
> +}
> +
> +static int gpio_wakeup_suspend(struct device *dev)
> +{
> +       struct gpio_wakeup_priv *priv = dev_get_drvdata(dev);
> +       int i;
> +
> +       for (i = 0; i < priv->count; i++)
> +               if (priv->irq[i] >= 0) {
> +                       enable_irq(priv->irq[i]);
> +                       enable_irq_wake(priv->irq[i]);
> +               }
> +
> +       return 0;
> +}
> +
> +static int gpio_wakeup_resume(struct device *dev)
> +{
> +       struct gpio_wakeup_priv *priv = dev_get_drvdata(dev);
> +       int i;
> +
> +       for (i = 0; i < priv->count; i++)
> +               if (priv->irq[i] >= 0) {
> +                       disable_irq_wake(priv->irq[i]);
> +                       disable_irq(priv->irq[i]);
> +               }
> +
> +       return 0;
> +}
> +
> +static SIMPLE_DEV_PM_OPS(gpio_wakeup_pm_ops,
> +                        gpio_wakeup_suspend, gpio_wakeup_resume);
> +
> +static struct of_device_id gpio_wakeup_of_match[] = {
> +       { .compatible = "gpio-wakeup", },
> +       { },
> +};
> +MODULE_DEVICE_TABLE(of, gpio_wakeup_of_match);
> +
> +static struct platform_driver gpio_wakeup_driver = {
> +       .probe  = gpio_wakeup_probe,
> +       .driver = {
> +               .name   = "gpio-wakeup",
> +               .owner  = THIS_MODULE,
> +               .pm     = &gpio_wakeup_pm_ops,
> +               .of_match_table = of_match_ptr(gpio_wakeup_of_match),
> +       }
> +};
> +
> +static int __init gpio_wakeup_init(void)
> +{
> +       return platform_driver_register(&gpio_wakeup_driver);
> +}
> +
> +static void __exit gpio_wakeup_exit(void)
> +{
> +       platform_driver_unregister(&gpio_wakeup_driver);
> +}
> +
> +late_initcall(gpio_wakeup_init);
> +module_exit(gpio_wakeup_exit);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Daniel Mack <zonque@gmail.com>");
> +MODULE_DESCRIPTION("Driver to wake up systems from GPIOs");
> +MODULE_ALIAS("platform:gpio-wakeup");
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
