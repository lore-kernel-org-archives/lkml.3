Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab3KWI74 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 03:59:56 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:45986 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab3KWI7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 03:59:52 -0500
MIME-Version: 1.0
In-Reply-To: <1385122474-14926-4-git-send-email-mika.westerberg@linux.intel.com>
References: <1385122474-14926-1-git-send-email-mika.westerberg@linux.intel.com>
 <1385122474-14926-4-git-send-email-mika.westerberg@linux.intel.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Sat, 23 Nov 2013 17:59:30 +0900
Message-ID: <CAAVeFuKm=AHf4Az+ZZXwWLtft2_zmCqy2Wscw25cWNCbn2T+dQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] net: rfkill: gpio: remove gpio conversion support
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Rhyland Klein <rklein@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Rob Landley <rob@landley.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 9:14 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>
> All platforms using this driver are now converted to the new
> descriptor-based GPIO interface.
>
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
>  net/rfkill/rfkill-gpio.c | 61 ++++++++++--------------------------------------
>  1 file changed, 12 insertions(+), 49 deletions(-)
>
> diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
> index 503432154616..bd2a5b90400c 100644
> --- a/net/rfkill/rfkill-gpio.c
> +++ b/net/rfkill/rfkill-gpio.c
> @@ -68,35 +68,6 @@ static const struct rfkill_ops rfkill_gpio_ops = {
>         .set_block = rfkill_gpio_set_power,
>  };
>
> -static int rfkill_gpio_convert_to_desc(struct platform_device *pdev,
> -                                      struct rfkill_gpio_data *rfkill)
> -{
> -       struct rfkill_gpio_platform_data *pdata = pdev->dev.platform_data;
> -       int ret;
> -
> -       if (gpio_is_valid(pdata->reset_gpio)) {
> -               ret = devm_gpio_request_one(&pdev->dev, pdata->reset_gpio,
> -                                           0, rfkill->reset_name);
> -               if (ret) {
> -                       dev_err(&pdev->dev, "failed to get reset gpio.\n");
> -                       return ret;
> -               }
> -               rfkill->reset_gpio = gpio_to_desc(pdata->reset_gpio);
> -       }
> -
> -       if (gpio_is_valid(pdata->shutdown_gpio)) {
> -               ret = devm_gpio_request_one(&pdev->dev, pdata->shutdown_gpio,
> -                                           0, rfkill->shutdown_name);
> -               if (ret) {
> -                       dev_err(&pdev->dev, "failed to get shutdown gpio.\n");
> -                       return ret;
> -               }
> -               rfkill->shutdown_gpio = gpio_to_desc(pdata->shutdown_gpio);
> -       }
> -
> -       return 0;
> -}
> -
>  static int rfkill_gpio_acpi_probe(struct device *dev,
>                                   struct rfkill_gpio_data *rfkill)
>  {
> @@ -117,6 +88,7 @@ static int rfkill_gpio_probe(struct platform_device *pdev)
>         struct rfkill_gpio_platform_data *pdata = pdev->dev.platform_data;
>         struct rfkill_gpio_data *rfkill;
>         const char *clk_name = NULL;
> +       struct gpio_desc *gpio;
>         int ret;
>         int len;
>
> @@ -150,29 +122,20 @@ static int rfkill_gpio_probe(struct platform_device *pdev)
>
>         rfkill->clk = devm_clk_get(&pdev->dev, clk_name);
>
> -       if (pdata && (pdata->reset_gpio || pdata->shutdown_gpio)) {
> -               ret = rfkill_gpio_convert_to_desc(pdev, rfkill);
> +       gpio = devm_gpiod_get_index(&pdev->dev, rfkill->reset_name, 0);
> +       if (!IS_ERR(gpio)) {
> +               ret = gpiod_direction_output(gpio, 0);
>                 if (ret)
>                         return ret;
> -       } else {
> -               struct gpio_desc *gpio;
> -
> -               gpio = devm_gpiod_get_index(&pdev->dev, rfkill->reset_name, 0);
> -               if (!IS_ERR(gpio)) {
> -                       ret = gpiod_direction_output(gpio, 0);
> -                       if (ret)
> -                               return ret;
> -                       rfkill->reset_gpio = gpio;
> -               }
> +               rfkill->reset_gpio = gpio;
> +       }
>
> -               gpio = devm_gpiod_get_index(&pdev->dev,
> -                                           rfkill->shutdown_name, 1);
> -               if (!IS_ERR(gpio)) {
> -                       ret = gpiod_direction_output(gpio, 0);
> -                       if (ret)
> -                               return ret;
> -                       rfkill->shutdown_gpio = gpio;
> -               }
> +       gpio = devm_gpiod_get_index(&pdev->dev, rfkill->shutdown_name, 1);
> +       if (!IS_ERR(gpio)) {
> +               ret = gpiod_direction_output(gpio, 0);
> +               if (ret)
> +                       return ret;
> +               rfkill->shutdown_gpio = gpio;
>         }
>
>         /* Make sure at-least one of the GPIO is defined and that

Wouldn't it be possible (and simpler) to move patch 2 of your series
to first position, and then to merge patch 1 and 3 together in second
position? It seems to me that you are basically undoing much of the
work of your first patch here (notably by removing
rfkill_gpio_convert_to_desc() which ends up having a very short life)
and that this could be avoided if you defined the platform lookup
tables first.

Doing so would avoid prevent you from using gpio_to_desc() which you
should never ever use anyway. :P
