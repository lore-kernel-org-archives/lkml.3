Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab3KUPcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 10:32:31 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:63650 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab3KUPc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 10:32:29 -0500
MIME-Version: 1.0
In-Reply-To: <1385045153-25160-2-git-send-email-mika.westerberg@linux.intel.com>
References: <1385045153-25160-1-git-send-email-mika.westerberg@linux.intel.com>
	<1385045153-25160-2-git-send-email-mika.westerberg@linux.intel.com>
Date: Thu, 21 Nov 2013 17:32:28 +0200
Message-ID: <CAHp75VeEEWCVXz4X1qazfVKZBDBgP6NPfPnuS-b7qEiT4m7f=g@mail.gmail.com>
Subject: Re: [PATCH 1/5] net: rfkill: gpio: convert to descriptor-based GPIO interface
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Rhyland Klein <rklein@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Rob Landley <rob@landley.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-gpio@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 4:45 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>
> Convert to the safer gpiod_* family of API functions.

Few comments below.

> --- a/net/rfkill/rfkill-gpio.c
> +++ b/net/rfkill/rfkill-gpio.c

> +static int rfkill_gpio_convert_to_desc(struct platform_device *pdev,
> +                                      struct rfkill_gpio_data *rfkill)
> +{
> +       struct rfkill_gpio_platform_data *pdata = pdev->dev.platform_data;
> +       int ret = 0;

Unneeded assignment.

> +
> +       if (gpio_is_valid(pdata->reset_gpio)) {
> +               ret = devm_gpio_request_one(&pdev->dev, pdata->reset_gpio,
> +                                           0, rfkill->reset_name);
> +               if (ret) {
> +                       pr_warn("%s: failed to get reset gpio.\n", __func__);
> +                       return ret;
> +               }
> +               rfkill->reset_gpio = gpio_to_desc(pdata->reset_gpio);
> +       }
> +
> +       if (gpio_is_valid(pdata->shutdown_gpio)) {
> +               ret = devm_gpio_request_one(&pdev->dev, pdata->shutdown_gpio,
> +                                           0, rfkill->shutdown_name);
> +               if (ret) {
> +                       pr_warn("%s: failed to get shutdown gpio.\n", __func__);
> +                       return ret;
> +               }
> +               rfkill->shutdown_gpio = gpio_to_desc(pdata->shutdown_gpio);
> +       }
> +
> +       return 0;
> +}

[]

> +       /* Make sure at-least one of the GPIO is defined and that
> +        * a name is specified for this instance
> +        */
> +       if ((!rfkill->reset_gpio && !rfkill->shutdown_gpio) || !rfkill->name) {
> +               pr_warn("%s: invalid platform data\n", __func__);
> +               return -EINVAL;
> +       }
> +
> +       if (pdata && pdata->gpio_runtime_setup) {
> +               ret = pdata->gpio_runtime_setup(pdev);
>                 if (ret) {
> -                       pr_warn("%s: failed to get shutdown gpio.\n", __func__);
> +                       pr_warn("%s: can't set up gpio\n", __func__);

Could you use dev_* family of functions to print messages?

-- 
With Best Regards,
Andy Shevchenko
