Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577AbbASEFT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 23:05:19 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:47799 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbbASEFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 23:05:16 -0500
MIME-Version: 1.0
In-Reply-To: <1420621722-7428-3-git-send-email-oliver+list@schinagl.nl>
References: <1420621722-7428-1-git-send-email-oliver+list@schinagl.nl> <1420621722-7428-3-git-send-email-oliver+list@schinagl.nl>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Mon, 19 Jan 2015 13:04:55 +0900
Message-ID: <CAAVeFuLwTsX8HByCVyEucYJ_DhhCOP=tEDprmi9pBwx+a7zzJg@mail.gmail.com>
Subject: Re: [PATCH v1 2/4] gpio: add parameter to allow the use named gpios
To: Olliver Schinagl <oliver+list@schinagl.nl>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Olliver Schinagl <oliver@schinagl.nl>,
        Robin Gong <b38343@freescale.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Alexander Shiyan <shc_work@mail.ru>,
        Jingoo Han <jg1.han@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2015 at 6:08 PM, Olliver Schinagl
<oliver+list@schinagl.nl> wrote:
> From: Olliver Schinagl <oliver@schinagl.nl>
>
> The gpio binding document says that new code should always use named
> gpios. Patch 40b73183 added support to parse a list of gpios from child
> nodes, but does not make it possible to use named gpios. This patch adds
> the con_id property and implements it is done in gpiolib.c, where the
> old-style of using unnamed gpios still works.

This is absolutely correct - thanks for spotting this.

>
> Signed-off-by: Olliver Schinagl <oliver@schinagl.nl>
> ---
>  drivers/gpio/devres.c                     | 16 +++++++++++++++-
>  drivers/input/keyboard/gpio_keys_polled.c |  2 +-
>  drivers/leds/leds-gpio.c                  |  2 +-
>  include/linux/gpio/consumer.h             |  1 +
>  4 files changed, 18 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/gpio/devres.c b/drivers/gpio/devres.c
> index 13dbd3d..b7fbe1c 100644
> --- a/drivers/gpio/devres.c
> +++ b/drivers/gpio/devres.c
> @@ -111,23 +111,37 @@ EXPORT_SYMBOL(__devm_gpiod_get_index);
>  /**
>   * devm_get_gpiod_from_child - get a GPIO descriptor from a device's child node
>   * @dev:       GPIO consumer
> + * @con_id:    function within the GPIO consumer
>   * @child:     firmware node (child of @dev)
>   *
>   * GPIO descriptors returned from this function are automatically disposed on
>   * driver detach.
>   */
>  struct gpio_desc *devm_get_gpiod_from_child(struct device *dev,
> +                                           const char *con_id,
>                                             struct fwnode_handle *child)
>  {
> +       static const char const *suffixes[] = { "gpios", "gpio" };
> +       char prop_name[32]; /* 32 is max size of property name */
>         struct gpio_desc **dr;
>         struct gpio_desc *desc;
> +       unsigned int i;
>
>         dr = devres_alloc(devm_gpiod_release, sizeof(struct gpio_desc *),
>                           GFP_KERNEL);
>         if (!dr)
>                 return ERR_PTR(-ENOMEM);
>
> -       desc = fwnode_get_named_gpiod(child, "gpios");
> +       for (i = 0; i < ARRAY_SIZE(suffixes); i++) {
> +               if (con_id)
> +                       snprintf(prop_name, 32, "%s-%s", con_id, suffixes[i]);
> +               else
> +                       snprintf(prop_name, 32, "%s", suffixes[i]);

Same remark as Dmitry about the hardcoded length of the string, but ...

> +
> +               desc = fwnode_get_named_gpiod(child, prop_name);
> +               if (!IS_ERR(desc) || (PTR_ERR(desc) == -EPROBE_DEFER))
> +                       break;
> +       }

... since it looks like this part has been mostly copy/pasted from
of_find_gpio(), can you add another patch that fixes it there as well?

Also in the case of ACPI this will prove to be an incomplete lookup
since acpi_find_gpio() has an additional fallback if the named lookup
fails.

In that respect, I wonder if it would not be better for
devm_get_gpiod_from_child() to call of_find_gpio() and
acpi_find_gpio() (after making them non-static) followed by
gpiod_request() instead of calling fwnode_get_named_gpiod(). But in
that case it will have to do the OF/ACPI handling by itself.

I'm not really sure about which way is better. I'd appreciate if you
could give a thought to a possible refactoring that would improve the
situation ; otherwise feel free to ignore what I have written above
and to duplicate the property name building code.
