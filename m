Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab3ITTJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 15:09:00 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:49812 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab3ITTI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 15:08:58 -0400
MIME-Version: 1.0
In-Reply-To: <1379085280-2211-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1379085280-2211-1-git-send-email-mika.westerberg@linux.intel.com>
Date: Fri, 20 Sep 2013 21:08:57 +0200
Message-ID: <CACRpkdZ4WNmt5ZO_+Wtpm0+GD4EMAK5VscV-cTN+43heF17FJg@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio / ACPI: register to ACPI events automatically
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 5:14 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:

> Instead of asking each driver to register to the ACPI events we can just
> call acpi_gpiochip_register_interrupts() for each chip that has ACPI
> handle. It checks chip->to_irq and if it is set to NULL (a GPIO driver that
> doesn't do interrupts) the function does nothing.
>
> Also make the event interface to be private to gpiolib-acpi and remove call
> to the API from the one existing user (pinctrl-baytrail.c).
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

The concept looks sane...

> +void acpi_gpiochip_add(struct gpio_chip *chip)
> +{
> +       acpi_gpiochip_request_interrupts(chip);
> +}
> +EXPORT_SYMBOL_GPL(acpi_gpiochip_add);
> +
> +void acpi_gpiochip_remove(struct gpio_chip *chip)
> +{
> +       acpi_gpiochip_free_interrupts(chip);
> +}
> +EXPORT_SYMBOL_GPL(acpi_gpiochip_remove);

If you're only going to call this from within gpiolib, why are
you EXPORTing the APIs?

I think we should maybe create drivers/gpio/gpiolib.h
for such subsystem-local headers.

> @@ -1221,6 +1222,7 @@ int gpiochip_add(struct gpio_chip *chip)
>  #endif
>
>         of_gpiochip_add(chip);
> +       acpi_gpiochip_add(chip);
>
>         if (status)
>                 goto fail;
> @@ -1262,6 +1264,7 @@ int gpiochip_remove(struct gpio_chip *chip)
>
>         gpiochip_remove_pin_ranges(chip);
>         of_gpiochip_remove(chip);
> +       acpi_gpiochip_remove(chip);

What happens on a platform that is not using CONFIG_GPIO_ACPI
when they try to compile this?

You forgot to add static inline stubs for the non-ACPI case.

Yours,
Linus Walleij
