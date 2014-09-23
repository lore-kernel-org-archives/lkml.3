Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328AbaIWQIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 12:08:53 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:37813 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050AbaIWQIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 12:08:50 -0400
MIME-Version: 1.0
In-Reply-To: <1411473545-3290-3-git-send-email-heiko@sntech.de>
References: <1411473545-3290-1-git-send-email-heiko@sntech.de>
	<1411473545-3290-3-git-send-email-heiko@sntech.de>
Date: Tue, 23 Sep 2014 09:08:49 -0700
X-Google-Sender-Auth: oh_08a7FWkw8wFvLRlTH4ZrfOow
Message-ID: <CAD=FV=VKwZnKQP2KDVkrOfYibHARmr=Z9QU9Cprepj9C8CuA9A@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] power: gpio-charger: add device tree support
From: Doug Anderson <dianders@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>
Cc: sre@kernel.org, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Heiko Stuebner <heiko.stuebner@bq.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko,

On Tue, Sep 23, 2014 at 4:59 AM, Heiko Stuebner <heiko@sntech.de> wrote:
> From: Heiko Stuebner <heiko.stuebner@bq.com>
>
> Add the ability to parse gpio-charger data from a devicetree node.
>
> Signed-off-by: Heiko Stuebner <heiko.stuebner@bq.com>
> ---
>  drivers/power/gpio-charger.c | 72 ++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 70 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/power/gpio-charger.c b/drivers/power/gpio-charger.c
> index a0024b2..22f084a 100644
> --- a/drivers/power/gpio-charger.c
> +++ b/drivers/power/gpio-charger.c
> @@ -22,6 +22,8 @@
>  #include <linux/platform_device.h>
>  #include <linux/power_supply.h>
>  #include <linux/slab.h>
> +#include <linux/of.h>
> +#include <linux/of_gpio.h>
>
>  #include <linux/power/gpio-charger.h>
>
> @@ -69,6 +71,59 @@ static enum power_supply_property gpio_charger_properties[] = {
>         POWER_SUPPLY_PROP_ONLINE,
>  };
>
> +static
> +struct gpio_charger_platform_data *gpio_charger_parse_dt(struct device *dev)
> +{
> +       struct device_node *np = dev->of_node;
> +       struct gpio_charger_platform_data *pdata;
> +       const char *chargetype;
> +       enum of_gpio_flags flags;
> +       int ret;
> +
> +       if (!np)
> +               return ERR_PTR(-ENOENT);
> +
> +       pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
> +       if (!pdata)
> +               return ERR_PTR(-ENOMEM);
> +
> +       pdata->name = np->name;
> +
> +       pdata->gpio = of_get_gpio_flags(np, 0, &flags);
> +       if (pdata->gpio < 0) {
> +               if (pdata->gpio != -EPROBE_DEFER)
> +                       dev_err(dev, "could not get charger gpio\n");
> +               return ERR_PTR(pdata->gpio);
> +       }
> +
> +       pdata->gpio_active_low = !!(flags & OF_GPIO_ACTIVE_LOW);
> +
> +       pdata->type = POWER_SUPPLY_TYPE_UNKNOWN;
> +       ret = of_property_read_string(np, "charger-type", &chargetype);
> +       if (ret >= 0) {
> +               if (!strncmp("unknown", chargetype, 7))
> +                       pdata->type = POWER_SUPPLY_TYPE_UNKNOWN;
> +               else if (!strncmp("battery", chargetype, 7))
> +                       pdata->type = POWER_SUPPLY_TYPE_BATTERY;
> +               else if (!strncmp("ups", chargetype, 3))
> +                       pdata->type = POWER_SUPPLY_TYPE_UPS;
> +               else if (!strncmp("mains", chargetype, 5))
> +                       pdata->type = POWER_SUPPLY_TYPE_MAINS;
> +               else if (!strncmp("usb-sdp", chargetype, 7))
> +                       pdata->type = POWER_SUPPLY_TYPE_USB;
> +               else if (!strncmp("usb-dcp", chargetype, 7))
> +                       pdata->type = POWER_SUPPLY_TYPE_USB_DCP;
> +               else if (!strncmp("usb-cdp", chargetype, 7))
> +                       pdata->type = POWER_SUPPLY_TYPE_USB_CDP;
> +               else if (!strncmp("usb-aca", chargetype, 7))
> +                       pdata->type = POWER_SUPPLY_TYPE_USB_ACA;
> +               else
> +                       dev_warn(dev, "unknown charger type %s\n", chargetype);
> +       }
> +
> +       return pdata;
> +}
> +
>  static int gpio_charger_probe(struct platform_device *pdev)
>  {
>         const struct gpio_charger_platform_data *pdata = pdev->dev.platform_data;
> @@ -78,8 +133,13 @@ static int gpio_charger_probe(struct platform_device *pdev)
>         int irq;
>
>         if (!pdata) {
> -               dev_err(&pdev->dev, "No platform data\n");
> -               return -EINVAL;
> +               pdata = gpio_charger_parse_dt(&pdev->dev);
> +               if (IS_ERR(pdata)) {
> +                       ret = PTR_ERR(pdata);
> +                       if (ret != -EPROBE_DEFER)
> +                               dev_err(&pdev->dev, "No platform data\n");
> +                       return ret;
> +               }
>         }
>
>         if (!gpio_is_valid(pdata->gpio)) {
> @@ -103,6 +163,7 @@ static int gpio_charger_probe(struct platform_device *pdev)
>         charger->get_property = gpio_charger_get_property;
>         charger->supplied_to = pdata->supplied_to;
>         charger->num_supplicants = pdata->num_supplicants;
> +       charger->of_node = pdev->dev.of_node;
>
>         ret = gpio_request(pdata->gpio, dev_name(&pdev->dev));
>         if (ret) {
> @@ -189,6 +250,12 @@ static int gpio_charger_resume(struct device *dev)
>  static SIMPLE_DEV_PM_OPS(gpio_charger_pm_ops,
>                 gpio_charger_suspend, gpio_charger_resume);
>
> +static const struct of_device_id gpio_charger_match[] = {
> +       { .compatible = "gpio-charger" },
> +       { }
> +};
> +MODULE_DEVICE_TABLE(of, gpio_charger_match);
> +
>  static struct platform_driver gpio_charger_driver = {
>         .probe = gpio_charger_probe,
>         .remove = gpio_charger_remove,
> @@ -196,6 +263,7 @@ static struct platform_driver gpio_charger_driver = {
>                 .name = "gpio-charger",
>                 .owner = THIS_MODULE,
>                 .pm = &gpio_charger_pm_ops,
> +               .of_match_table = of_match_ptr(gpio_charger_match),

I'm still not convinced about of_match_ptr() here as you can see in my
response to v2.  ...but at most it could give a warning that would be
something like "gpio_charger_match defined but not used" in the
!CONFIG_OF case, so I guess it's fine?

In any case, everything else looks reasonable:

Reviewed-by: Doug Anderson <dianders@chromium.org>
Tested-by: Doug Anderson <dianders@chromium.org>
